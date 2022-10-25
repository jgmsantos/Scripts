# Instalar as bibliotecas abaixo:
# pip install selenium
# pip install webdriver-manager

# Autor: Guilherme Martins
# E-mail: jgmsantos@gmail.com
# Data: 25/10/2022
# Homepage: https://guilherme.readthedocs.io/en/latest/
# GitHub: https://github.com/jgmsantos

from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.chrome.service import Service # Executa o ChromeDriverManager.
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options

chrome_options = Options() # Cria uma instância.
chrome_options.add_argument("--headless") # Não abre o navegador na tela (executa em backgound).

# Instala a versão do ChromeDriver compatível com a versão Google
# Chrome instalada na sua máquina.
servico = Service(ChromeDriverManager().install())

# Usando o navegador Google Chrome, por isso o nome "Chrome".
navegador = webdriver.Chrome(service=servico, options=chrome_options)

url = "http://www.ons.org.br/paginas/energia-agora/carga-e-geracao" # Site a ser analisado.

navegador.get(url) # Acessa a página de interesse.

# ValorString é a variável que armazenará o valor de interesse usando XPATH.
ValorString = navegador.find_element(By.XPATH, 
                                     '//*[@id="curva_ctl00_ctl64_g_2559304d_ec9c_4f80_abba_e53b97ebf8fc"]/div[2]/div/div/div[1]/span[2]').text

# Cria uma regra quando a variável for vazia em vez de retornar o erro. Neste caso, imprime 
# a mensagem "Variável vazia".
try:
     # Formato da variável (string): 68626,0 MW (são duas informações, índice 0 [68626,0] = valor e 
     # índice 1 = unidade [MW]).
     ValorFloat = float(ValorString.replace(",",".").split(' ')[0])
     print(ValorFloat)
except ValueError:
     resultado = "Variável vazia"
     print(resultado)

navegador.close() # Fecha a janela atual do navegador.