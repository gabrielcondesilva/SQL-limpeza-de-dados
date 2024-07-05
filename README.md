# SQL-limpeza-de-dados
Este projeto demonstra o processo de limpeza de um conjunto de dados utilizando SQL, com o objetivo de transformar dados brutos em dados limpos e prontos para análise, garantindo a precisão e a consistência das informações.

## Sobre o Dataset
Utilizei um dataset, disponível neste repositório, que abrange demissões em empresas ao redor do mundo durante o período de 2020 até 2023. Esse conjunto de dados inclui as seguintes colunas:

company: Nome da empresa.

location: Localização da empresa.

industry: Indústria em que a empresa atua.

total_laid_off: Total de funcionários demitidos.

percentage_laid_off: Percentual de funcionários demitidos.

date: Data da demissão.

stage: Estágio da empresa (por exemplo, startup, grande empresa).

country: País da empresa.

funds_raised_millions: Fundos arrecadados pela empresa (em milhões).


## Passos Realizados
Criação de uma Cópia do Dataset: Criação de uma cópia dos dados originais para evitar alterações irreversíveis em caso de erros.

Remoção de Duplicatas: Uso de comandos SQL para identificar e remover registros duplicados.

Padronização e Validação dos Dados: Aplicação de transformações para assegurar a consistência dos dados, como a conversão de todas as datas para um único formato e a verificação da integridade dos dados.

Tratamento de Valores Nulos e em Branco: Estratégias para lidar com dados ausentes utilização de comandos SQL para preencher ou remover valores ausentes.

Exclusão de Colunas e Linhas Irrelevantes: Remoção de colunas e linhas que não são necessárias para o projeto de análise exploratória.

## Ferramentas Utilizadas
SQL: Linguagem de consulta utilizada para manipulação e limpeza dos dados.

MySQL: Banco de dados onde os dados foram armazenados e manipulados.


## Como Utilizar
Clone o repositório para sua máquina local.

Importe o dataset disponível no repositório para o seu banco de dados SQL.

Execute os scripts SQL fornecidos para realizar o processo de limpeza de dados.
