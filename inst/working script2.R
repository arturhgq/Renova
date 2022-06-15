# Instalar R
# Isntalar Rstudio
# Instalar e configurar Forcepoint VPN client
# Login e senha da VPN
login: crtf_avds
Senha: "BJ@m1E24"

install.packages(
  c("odbc",
    "readxl",
    "remotes",
    "DBI",
    "dplyr",
    "glue",
    "here",
    "openxlsx",
    "purrr",
    "rstudioapi",
    "svDialogs")
 )

# Instalar Microsoft ODBC Driver 18 para SQL Server (x64)
# https://docs.microsoft.com/pt-br/sql/connect/odbc/download-odbc-driver-for-sql-server?view=sql-server-ver15

# Instalação do pacote Renova
remotes::install_github(
  "HerkenhoffPrates/Renova",
  auth_token = "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")

Renova::renova_VPN()
Login: "crtf_avds@fundacaorenova.org"
Senha: "BJ@m1E24"
Renova::planilha_faturamento()
Renova::planilha_monitoramento()
Renova::planilha()


# Monitoramento

# Novas manifestações


# Encaminhamentos


# Conclusões



