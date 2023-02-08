import urllib.request
 
def getHtml(url):
    html = urllib.request.urlopen(url).read()
    return html
 
def saveHtml(file_name, file_content):
    #   注意windows文件命名的禁用符，比如 /
    #   Preste atención a los caracteres prohibidos en los nombres de archivos de Windows, como /
    with open(file_name.replace('/', '_') + ".html", "wb") as f:
        #   写文件用bytes而不是str，所以要转码
        #   Escribir archivos con bytes en lugar de str, por lo que se requiere transcodificación
        f.write(file_content)

s=input('Introducir la ciudad:')
aurl = "https://www.eltiempo.es/" + s + ".html"
html = getHtml(aurl)
saveHtml(s, html)

print("Descarga con exito")
