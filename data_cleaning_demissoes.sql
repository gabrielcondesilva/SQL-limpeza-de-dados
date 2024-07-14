-- LIMPEZA DE DADOS


-- Processo:
-- 1. Criar uma cópia para não usar o original em caso de erro.
-- 2. Remover Duplicadas.
-- 3. Padronizar os Dados.
-- 4. Lidar com Dados em branco ou nulos.
-- 5. Excluir colunas ou linhas que não vamos usar.


-- Visualizar todos os dados da tabela original.
SELECT * FROM layoffs;

-- 1. Criar uma cópia da tabela original.
CREATE TABLE layoffs_copia LIKE layoffs;

-- Verificar a criação da cópia.
SELECT * FROM layoffs_copia;

-- Inserir dados na cópia da tabela.
INSERT layoffs_copia
SELECT * FROM layoffs;

-- 2. Remover duplicatas (sem identificador único) usando window function.
WITH duplicadas AS (
    SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions,
        ROW_NUMBER() OVER (
            PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
        ) AS row_num
    FROM layoffs_copia
)
SELECT *
FROM duplicadas
WHERE row_num > 1;

-- Adicionar coluna row_num na tabela layoffs_copia.
ALTER TABLE layoffs_copia ADD row_num INT;

-- Criar nova tabela com a mesma estrutura da tabela layoffs_copia.
CREATE TABLE layoffs_copia2 (
    company TEXT,
    location TEXT,
    industry TEXT,
    total_laid_off INT,
    percentage_laid_off TEXT,
    `date` TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions INT,
    row_num INT
);

-- Inserir dados na tabela layoffs_copia2 calculando os valores da coluna row_num durante a inserção.
INSERT INTO layoffs_copia2
(company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions, row_num)
SELECT company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions,
    ROW_NUMBER() OVER (
        PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions
    ) AS row_num
FROM layoffs_copia;

-- Excluir duplicatas (linhas com row_num >= 2).
DELETE FROM layoffs_copia2
WHERE row_num >= 2;

-- 3. Padronizar os Dados

-- Identificar espaços vazios na coluna company.
SELECT TRIM(company), company
FROM layoffs_copia2;

-- Atualizar a coluna company corrigindo os erros de espaço.
UPDATE layoffs_copia2
SET company = TRIM(company);

-- Verificar e corrigir dados na coluna industry.
SELECT DISTINCT industry
FROM layoffs_copia2
ORDER BY 1;

SELECT *
FROM layoffs_copia2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_copia2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Verificar e corrigir dados na coluna location.
SELECT DISTINCT location
FROM layoffs_copia2
ORDER BY 1;

SELECT *
FROM layoffs_copia2
WHERE location LIKE 'Mal%';

UPDATE layoffs_copia2
SET location = 'Florianopolis'
WHERE location = 'FlorianÃ³polis';

UPDATE layoffs_copia2
SET location = 'Dusseldorf'
WHERE location = 'DÃ¼sseldorf';

UPDATE layoffs_copia2
SET location = 'Malmo'
WHERE location = 'MalmÃ¶';

-- Verificar e corrigir dados na coluna country.
SELECT DISTINCT country
FROM layoffs_copia2
ORDER BY 1;

SELECT DISTINCT country
FROM layoffs_copia2
WHERE country LIKE 'United%';

UPDATE layoffs_copia2
SET country = 'United States'
WHERE country = 'United States.';

-- Identificar a coluna date em formato de texto e convertê-la para formato de data.
SELECT `date`, 
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_copia2;

UPDATE layoffs_copia2
SET `date`= STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_copia2
MODIFY COLUMN `date` DATE;

-- 4. Lidar com valores nulos e em branco

-- Identificar linhas com valores nulos ou em branco na coluna industry.
SELECT *
FROM layoffs_copia2
WHERE industry IS NULL
OR industry = '';

-- Atualizar valores nulos com dados existentes.
SELECT t1.industry, t2.industry
FROM layoffs_copia2 t1
JOIN layoffs_copia2 t2
    ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_copia2
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_copia2 t1
JOIN layoffs_copia2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

-- 5. Excluir linhas desnecessárias para a análise.
DELETE 
FROM layoffs_copia2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Excluir a coluna row_num que não será mais utilizada.
ALTER TABLE layoffs_copia2
DROP COLUMN row_num;

-- Verificar a tabela final após a limpeza.
SELECT *
FROM layoffs_copia2;

