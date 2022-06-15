## CONTESTAÇÕES E REENQUADRAMENTO ##

# Lê a base Contestações.
## #PENDÊNCIA baixar a versão correta da base no SharePoint da Renova ou no Data Lake.
##
HerkenhoffPrates::find_data(
  here::here("data-raw")
) -> dataraw

dataraw$`Base_Contestacao_Operacao 20220311.xlsx` |>
  readxl::read_excel() |>
  suppressWarnings() -> data

data |>
  dplyr::filter(
    TIPO_CONTESTACAO %in% "INCLUSAO DE CPF",
    STATUSPORTALADVOGADOCONTESTACAO %in% "Aguardando Análise"
  ) |>
  dplyr::mutate(
    dplyr::across(
      .cols = c(
        LIBERACAOCPF_AN2_PARECER,
        INCLUSAODANO_AN1_PARECER
      ),
        as.numeric
    )
  )-> contestacao

# Lista de abas da planilha 'PlanHePFormula_Nova_LiberaCPF_V1.xlsx' ----
list(
  "Liberação de CPF",
  "BD",
  "dimensao_people",
  "Cadastro",
  "Solicit Cadastro 30-04",
  "Outras Manif 30-04",
  "Dano X Tipo Requerente",
  "Profissionais OS",
  "Advogados",
  "Municpio"
) -> .sheets

tictoc::tic()
# Baixa a última versão da planilha 'PlanHePFormula_Nova_LiberaCPF_V1.xlsx' ----
HerkenhoffPrates::read_SharePoint_xlsx(
  .SharePoint = "https://herkenhoffprates.sharepoint.com/sites/PMO/FluxoAgil",
  .drive = "Documentos",
  .file = "Execução/GestMonito/01_AnaliseContesRecurso/ContagemDiaria/PlanFormulas/PlanHePFormula_Nova_LiberaCPF_V1.xlsx",
  .sheet = .sheets
) |>
  suppressMessages() |>
  suppressWarnings() -> CPF_formulas
tictoc::toc() # em média 45 segundos

CPF_formulas -> backup
backup -> CPF_formulas

tictoc::tic()
CPF_formulas$BD |>
  dplyr::select(- dplyr::any_of("Coluna2")) |>
  dplyr::mutate(
    dplyr::across(
      .cols = c(
        DTINS,
        DTINS_MES,
        DEMANDANTE_DATANASCIMENTO,
        LIBERACAOCPF_AN1_FINALIZARVERIFICACAO_DTINS,
        LIBERACAOCPF_AN1_RESPONSAVEL_DTINS,
        LIBERACAOCPF_AN2_RESPONSAVEL_DTINS,
        LIBERACAOCPF_AN2_FINALIZARVERIFICACAO_DTINS,
        INCLUSAODANO_AN1_FINALIZARVERIFICACAO_DTINS,
        INCLUSAODANO_AN1_RESPONSAVEL_DTINS
      ),
      ~ as.numeric(.x) |>
        janitor::excel_numeric_to_date(include_time = TRUE)
    )
  ) |>
  dplyr::bind_rows(contestacao)  -> CPF_formulas$BD
tictoc::toc() # em média 150 segundos

# Banco de dados BD ----
## PROTOCOLO CONTESTAÇÃO  ----
## NOME  ----
## CPF/CNPJ  ----
## TIPO REQUERENTE  ----
## COD PESSOA ----
## DATA DE NASCIMENTO ----
##  DATA DA CONTESTAÇÃO ----
##  DATA DA DISTRIBUIÇÃO ----
##  TIPO DA CONTESTAÇÃO ----
##  DANO,  `MUNICÍPIO ----
##  BAIRRO/COMUNIDADE ----
##  JUSTIFICATIVA ----
##  CPF/CNPJ ADVOGADO ----
##  NOME ADVOGADO ----
##
CPF_formulas$BD |>
  dplyr::transmute(
    `PROTOCOLO CONTESTAÇÃO` = PROTOCOLO,
    NOME = DEMANDANTE_NOME,
    `CPF/CNPJ` = DEMANDANTE_CPF,
    `TIPO REQUERENTE` = dplyr::if_else(
      stringr::str_length(DEMANDANTE_CPF) > 14,
      true = "CNPJ",
      false = "CPF"
    ),
    `COD PESSOA` = DEMANDANTE_CODPESSOA,
    `DATA DE NASCIMENTO` = DEMANDANTE_DATANASCIMENTO,
    `DATA DA CONTESTAÇÃO` = DTINS,
    `DATA DA DISTRIBUIÇÃO` = Sys.time(), #format(lubridate::today(), "%d-%m-%Y"),
    `TIPO DA CONTESTAÇÃO` = TIPO_CONTESTACAO,
    DANO = DANOS,
    `MUNICÍPIO` = MUNICIPIO,
    `BAIRRO/COMUNIDADE` = DEMANDANTE_ENDERECO_BAIRRO,
    JUSTIFICATIVA = DEMANDANTE_JUSTIFICATIVA,
    `CPF/CNPJ ADVOGADO` = ADVOGADO_CPF,
    `NOME ADVOGADO` = ADVOGADO_NOME,
  ) |>
  HerkenhoffPrates::make_clean_strings(
    NOME,
    `NOME ADVOGADO`,
    .make_title = T
  ) -> CPF_formulas$`Liberação de CPF`

# Banco de dados Advogados ----
## OAB ADVOGADO ----
## UF OAB ADVOGADO ----
## MAIOR DE 16 ANOS NO ROMPIMENTO? ----
CPF_formulas$Advogados |>
  dplyr::transmute(
    Cpfcnpjsolicitacao,
    `OAB ADVOGADO` = Numerooab,
    `UF OAB ADVOGADO` = `Uf OAB`,
  ) -> advogados_vars

CPF_formulas$`Liberação de CPF` |>
  dplyr::left_join(
    advogados_vars,
    by = c("CPF/CNPJ ADVOGADO" = "Cpfcnpjsolicitacao")
  ) |>
  dplyr::mutate(
    `MAIOR DE 16 ANOS NO ROMPIMENTO?` = dplyr::case_when(
      `TIPO REQUERENTE` %in% "CNPJ" ~ "N/A",
      `TIPO REQUERENTE` %in% "CPF" & `DATA DE NASCIMENTO` <= "1999-11-05" ~ "Sim",
      `TIPO REQUERENTE` %in% "CPF" & `DATA DE NASCIMENTO` > "1999-11-05" ~ "Não",
      TRUE ~ NA_character_
    )
  )-> CPF_formulas$`Liberação de CPF`

# Banco de dados "Municipio" ----
CPF_formulas$Municpio |>
  dplyr::select(
    Município,
    `MUNICÍPIO/REGIÃO JÁ SENTENCIADO?` = `Todos as localidades?`
  ) -> municipios_vars

CPF_formulas$`Liberação de CPF` |>
  dplyr::left_join(
    municipios_vars,
    by = c("MUNICÍPIO" = "Município")
  ) -> CPF_formulas$`Liberação de CPF`

# Banco de dados Solicit Cadastro 30-04 ----
CPF_formulas$`Solicit Cadastro 30-04` |>
  dplyr::distinct(`COD PESSOA` = manifestante_codPessoa) |>
  dplyr::transmute(
    `COD PESSOA` = as.character(`COD PESSOA`),
    cod2 = "sim"
  ) -> cad_vars

CPF_formulas$`Liberação de CPF` |>
  dplyr::mutate(
    `COD PESSOA` = as.character(`COD PESSOA`)
  ) |>
  dplyr::left_join(
    cad_vars,
    by = "COD PESSOA"
  ) |>
  dplyr::mutate(
    `SOLICITAÇÃO DE CADASTRO ANTES DE 30/04/20?` = dplyr::if_else(
      is.na(cod2),
      true = "Não",
      false = "Sim"
    )
  ) |>
  dplyr::select(-cod2) -> CPF_formulas$`Liberação de CPF`

# Banco de dados Outras Manif 30-04 ----
CPF_formulas$`Outras Manif 30-04` |>
  dplyr::distinct(`COD PESSOA` = manifestante_codPessoa) |>
  dplyr::transmute(
    `COD PESSOA` = as.character(`COD PESSOA`),
    cod2 = "sim"
  ) -> outr_manif_vars

CPF_formulas$`Liberação de CPF` |>
  dplyr::left_join(
    outr_manif_vars,
    by = "COD PESSOA"
  ) |>
  dplyr::mutate(
    `POSSUI OUTRA MANIFESTAÇÃO ANTERIOR A 30/04?` = dplyr::if_else(
      is.na(cod2),
      true = "Não",
      false = "Sim"
    )
  ) |>
  dplyr::select(-cod2) -> CPF_formulas$`Liberação de CPF`

# Banco de dados Cadastro ----
tictoc::tic()
CPF_formulas$Cadastro |>
  dplyr::distinct(
    `COD PESSOA` = CODPESSOA,
    FASE
  ) |>
  tidyr::drop_na(`COD PESSOA`) |>
  dplyr::transmute(
    `COD PESSOA` = as.character(`COD PESSOA`),
    FASE,
    cod2 = "sim"
  ) |>
  HerkenhoffPrates::collapse_duplicates(`COD PESSOA`) -> cadastro_vars
tictoc::toc() # Em média 1 minuto

CPF_formulas$`Liberação de CPF` |>
  dplyr::left_join(
    cadastro_vars,
    by = "COD PESSOA"
  ) |>
  dplyr::mutate(
    `POSSUI CADASTRO INTEGRADO?` = dplyr::if_else(
      is.na(cod2),
      true = "Não",
      false = FASE
    ),
    `DANO CONTESTADO COMPATÍVEL COM A LOCALIDADE?` = "N/A"
  ) |>
  dplyr::select(
    - dplyr::all_of(c("cod2", "FASE"))
    ) -> CPF_formulas$`Liberação de CPF`

# Banco de dados Dano X Tipo Requerente ----
## DANO CONTESTADO COMPATÍVEL COM TIPO DO REQUERENTE?`----

CPF_formulas$`Dano X Tipo Requerente` |>
  dplyr::transmute(
    CPF2 = CPF,
    CNPJ2 = CNPJ,
    dano_join = HerkenhoffPrates::make_clean_string_vector(Dano),
    `DANOS SOLICITADOS SÃO CUMULÁVEIS?` = Cumulatividade
  ) -> dano_vars

CPF_formulas$`Liberação de CPF` |>
  dplyr::mutate(
    dano_join = HerkenhoffPrates::make_clean_string_vector(DANO)
  ) |>
  dplyr::left_join(
    dano_vars,
    by = "dano_join"
  ) |>
  dplyr::mutate(
    `DANO CONTESTADO COMPATÍVEL COM TIPO DO REQUERENTE?` = dplyr::if_else(
      `TIPO REQUERENTE` %in% "CPF",
      true = CPF2,
      false = CNPJ2
    ),
    `RELATO DO DANO CONSTA NO CADASTRO, MANIFESTAÇÕES OU DOCUMENTOS?` = "",
    `[SE SIM] ONDE FOI ENCONTRADO?` = "",
    `RELATOU OUTRO DANO PASSÍVEL DE INDENIZAÇÃO?` = "",
    `[SE SIM] QUAL DANO DAS EVIDÊNCIAS?` = "",
  ) |>
  dplyr::select(
    - dplyr::all_of(c("CPF2", "CNPJ2", "dano_join"))
    ) |>
  dplyr::relocate(
    `DANOS SOLICITADOS SÃO CUMULÁVEIS?`,
    .after = `[SE SIM] QUAL DANO DAS EVIDÊNCIAS?`
  )-> CPF_formulas$`Liberação de CPF`



list(
  "LiberaCPF_PARADISTRIBUIR",
  "LiberaCPF_DISTRIBUÍDO",
  "LiberaCPF_CheckList"
) -> .sheets

HerkenhoffPrates::read_SharePoint_xlsx(
  .SharePoint = "https://herkenhoffprates.sharepoint.com/sites/PMO/FluxoAgil",
  .drive = "Documentos",
  .file = "Execução/GestMonito/01_AnaliseContesRecurso/ContagemDiaria/PlanValores/PlanHePValores_Nova_LiberaCPF_V1.xlsx",
  .function = readxl::read_excel,
  .sheet = .sheets
) |>
  suppressMessages() -> CPF_valores

CPF_formulas$`Liberação de CPF` -> CPF_valores$LiberaCPF_PARADISTRIBUIR

Renova::export(CPF_valores)
