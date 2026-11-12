$logCrudo = @"
[INFO] ID:8842 :: 2023/11/01_10:00 :: User:admin_01 :: Action:Login_Success
[ERROR] ID:9921 :: 2023/11/01_10:05 :: User:guest_user :: Action:Auth_Fail (Pass)
[WARN] ID:8843 :: 2023-11-01 10:15 :: User:dev_team :: Action:Upload_Limit_Exceeded
[CRITICAL] ID:1001 :: 01-11-2023_10:20 :: User:ROOT :: Action:Service_Stop
"@

$lineas = $logCrudo -split "`n"

$reportes = foreach ($linea in $lineas) {

    $partes = $linea -split "::"

    $nivelID = $partes[0].Trim()
    $fecha = $partes[1].Trim()
    $usuario = $partes[2].Trim()
    $accion = $partes[3].Trim()

    $nivelID = $nivelID.Replace("[", "").Replace("]", "")
    $nivel = $nivelID.Split(" ")[0]
    $ID = $nivelID.Split(":")[1].Trim()

    if ($nivel -ne "INFO") {
        $usuario = $usuario.Replace("User:", "").Trim().Replace("ROOT", "administrator").ToLower()
        $accion = $accion.Replace("Action:", "").Trim()
        $fecha = $fecha.Replace("/", "-").Replace("_", " ").Trim()

        if ($fecha[2] -eq '-') {
            $f = $fecha.split(" ")[0]
            $h = $fecha.split(" ")[1]
            $dia = $f.split("-")[0]
            $mes = $f.split("-")[1]
            $anio = $f.split("-")[2]
            $fecha = "$anio-$mes-$dia $h"
        }
        else {
            $f = $fecha.split(" ")[0]
            $h = $fecha.split(" ")[1]
            $dia = $f.split("-")[2]
            $mes = $f.split("-")[1]
            $anio = $f.split("-")[0]
            $fecha = "$anio-$mes-$dia $h"
        }
        [PSCustomObject]@{
            Fecha   = $fecha
            Nivel   = $nivel
            Usuario = $usuario
            ID      = $ID
            Accion  = $accion
        }
    }
}
$reportes | Export-Csv "reporte_seguridad.csv" -NoTypeInformation -Encoding UTF8
