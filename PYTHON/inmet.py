# Instalar as bibliotecas abaixo:
# pip install selenium
# pip install webdriver-manager

# Autor: Guilherme Martins
# E-mail: jgmsantos@gmail.com
# Data: 25/10/2022
# Homepage: https://guilherme.readthedocs.io/en/latest/
# GitHub: https://github.com/jgmsantos

# Para executar:
# python inmet.py

# Objetivo do script:
# Entrar no link abaixo de forma automática:
# https://portal.inmet.gov.br/paginas/catalogoaut
# E depois clicar no número da estação de interesse (coluna Código). Para este 
# exemplo, será selecionada a estação "AFONSO CLAUDIO" que tem o código
# "A657". Será feito um clique neste link e depois será feito o download do 
# dado.

import time

from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options

#chrome_options = Options()
#chrome_options.add_experimental_option('excludeSwitches', ['enable-logging'])

servico = Service(ChromeDriverManager().install())

navegador = webdriver.Chrome(service=servico)

url = "https://portal.inmet.gov.br/paginas/catalogoaut" # Link de interesse.

print('--------------------------------------')
print('Abrindo a página...')
print('--------------------------------------')

navegador.maximize_window() # Maximiza a página.

navegador.get(url) # Acessa a página de interesse.

# Trava a página por 20 segundos para dar tempo de realizar o clique no local de interesse.
wait = WebDriverWait(navegador, 20) 

print('--------------------------------------')
print('Selecionando a estação de interesse...')
print('--------------------------------------')

# Clica no link da estação de interesse.
wait.until(EC.element_to_be_clickable((By.XPATH, '//*[@id="tb"]/tbody/tr[4]/td[8]/a'))).click()

print('--------------------------------------')
print('Download do dado...')
print('--------------------------------------')

# Clica no botão "Baixar CSV" para realizar o download do dado de interesse.
wait.until(EC.element_to_be_clickable((By.XPATH, '//*[@id="root"]/div[2]/div[2]/div/div/div/span/a'))).click()

# Trava o navegador por 20 segundos, caso contrário, o navegador será fechado.
time.sleep(10)