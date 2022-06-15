
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Renova

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/Renova)](https://CRAN.R-project.org/package=Renova)
<!-- badges: end -->

O objetivo do pacote `Renova` é automatizar processos para análises de
dados.

## Instalação

Você pode instalar a versão de desenvolvimento do pacote da seguinte
forma:

``` r
remotes::install_github("HerkenhoffPrates/Renova",  auth_token)
```

## Exemplos

Como exportar a planilha de faturamento?

``` r
library(Renova) # Leia a biblioteca
renova_VPN() # Rode a VPN (instale Forcepoint VPN Client antes)
planilha_faturamento() # Rode a função de faturamento
```

Como exportar a planilha de Monitoramento?

``` r
library(Renova) # Leia a biblioteca
renova_VPN() # Rode a VPN (instale Forcepoint VPN Client antes)
planilha_faturamento() # Rode a função de monitoramento
```
