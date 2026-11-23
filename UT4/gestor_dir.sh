#!/bin/bash
directorio=$1
if [ $# -eq 0 ]; then
echo "No has introducido la ruta del directorio. Introducela a continuación. "
read -p "Ruta del directorio: " directorio
fi
if [ -d $directorio ];
then
        if test -r $directorio
        then
                echo "Tienes permisos de lectura."
        else
                echo "No tienes permisos de lectura."
        fi
        if test -w $directorio
        then
                echo "Tienes permisos de escritura."
        else
                echo "No tienes permisos de escritura."
        fi
else
        echo "Error grave. El directorio no existe."
fi
echo "--- MENÚ DE GESTIÓN DEL DIRECTORIO ---"
echo "1) Contar archivos por extensión (.txt, .sh y .log)"
echo "2) Realizar copia de seguridad comprimida (Backup)"
echo "3) Mostrar información del usuario y fecha actual"
echo "4) Salir"
read -p "Introduce la opción que desees:" opcion
case $opcion in
1)
        txt=$(ls $directorio/*.txt 2>/dev/null | wc -l)
        sh=$(ls $directorio/*.sh 2>/dev/null | wc -l)
        log=$(ls $directorio/*.log 2>/dev/null | wc -l)
        echo "Hay $txt archivos .txt."
        echo "Hay $sh archivos .sh."
        echo "Hay $log archivos .log."
        ;;
2)
        fecha=$(date +%Y%m%d)
        copia=$(tar -cvzf /tmp/backup_$fecha.tar.gz $directorio)
        echo "Copia de seguridad completada."
        ;;
3)
        root=0
        dia=$(date +%d)
        hora=$(date +%H:%M)
        if [ $(id -u) -eq 0 ]; then
                echo "Hola usuario Root"
                echo "Hoy es $dia y son las $hora horas."
        else
                echo "Hola usuario que no es root."
                echo "Hoy es $dia y son las $hora horas."
        fi
        ;;
4)
        echo "Adiós, gracias por usarme."
        ;;
esac