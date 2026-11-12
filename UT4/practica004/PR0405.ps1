$logsWeb = @"
POST /api/v1/auth/login?session=a8f93j2&token=expired [IP: 192.168.10.45] [Agent: Mozilla/5.0] [ERR-0040-AUTH]
GET /api/v2/products/search?q=laptop&sort=asc [IP: 10.0.2.15] [Agent: Chrome/110.0] [ERR-0200-OK]
DELETE /api/v1/admin/drop_table?confirm=true&force=1 [IP: 172.16.254.88] [Agent: ScriptBot/1.2] [ERR-0500-FATAL]
GET /api/v1/user/profile?id=9921&token=xyz [IP: 192.168.10.102] [Agent: Firefox/109.0] [ERR-0403-FORBIDDEN]
"@

$lineas = $logsWeb -split "`n"

$reportes = foreach ($linea in $lineas) {
    $partes = $linea.split(" ")
    $metodo = $partes[0].Trim()
    $ruta = $partes[1].Trim()
    $IP = $partes[3].Trim()
    $agente = $partes[5].Trim().replace("]", "")
    $fallo = $partes[6].Trim().Replace("[", "").Replace("]", "")

    $fallo = $fallo.split("-")
    $fallo_aislado = $fallo[1]
    $fallo_letras = $fallo[2]

    if ($fallo_letras -ne "OK") {
        $ruta = $ruta.split("?").Trim()
        $ruta_limpia = $ruta[0]
        $IP = $IP.split("]")
        $IP_sinAsterisco = $IP[0]
        $IP_sinAsterisco = $IP_sinAsterisco.split(".")
        $IP_conAsterisco = $IP_sinAsterisco[0] + "." + $IP_sinAsterisco[1] + "." + $IP_sinAsterisco[2] + "." + "***"
    
        [PSCustomObject]@{
            Metodo = $metodo
            Ruta   = $ruta_limpia
            IP     = $IP_conAsterisco
            Fallo  = $fallo_aislado
            Agente = $agente
        }
    }
}
$reportes | Export-Csv "reporte_seguridad2.csv" -NoTypeInformation -Encoding UTF8