@echo off
title Pipeline ETL - Marketplace Analytics
chcp 65001 > nul
color 0A

echo ======================================================
echo    AUTO-PROCESSAMENTO: MARKETPLACE ANALYTICS
echo ======================================================
echo [ %date% %time% ] Iniciando o motor de dados...

:: 1. Garante que o terminal está na pasta do .bat (Raiz)
cd /d "%~dp0"

:: 2. Executa o script que está dentro da pasta Python
:: O comando chama o python apontando para o caminho relativo
echo [ %date% %time% ] Rodando extração e carga de dados...
python Python/pipeline_etl.py

:: 3. Verifica se o script retornou erro (sys.exit(1))
if %errorlevel% neq 0 (
    echo.
    color 0C
    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    echo    ERRO: Ocorreu um problema ao rodar o script.
    echo    Verifique as mensagens acima ou o arquivo de log.
    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    pause
    exit /b %errorlevel%
)

:: 4. Finalização com sucesso
echo.
echo ======================================================
echo [ %date% %time% ] SUCESSO: Pipeline finalizado!
echo ======================================================
echo Esta janela fechara automaticamente em 10 segundos...
timeout /t 10
exit