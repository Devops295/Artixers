#!/bin/bash

# Programa realizado por Hugo Napoli en octubre-noviembre de 2023 - https://hugonapoli.blogspot.com - @entropiabinaria en YouTube
# Copyright 2023 Hugo Napoli.

# Actualizaciones (0=aún no realizado;*=en tránsito;1=realizado):
# ---------------------------------------------------------------
#   0  ¿permitir elegir ubicación específica de directorio home?,
#   0  ofrecer posibilidad de no caducidad en contraseña de inicio de sesión,
#   0  ¿ver los contenidos de todos los grupos no vacíos?
#   0  ¿preguntar al usuario si quiere volver a ejecutar cada subprograma dentro de artixers?,
#   1  solucionar detalle gráfico al pulsar teclas del menú principal,
#   *  sección de permisos especiales,
#   0  ¿seleccionar ID al consultar usuarios?
#   0  

artixers=$(realpath "$0");camino=$(dirname "$artixers")
reg_num_let="^[A-Za-z0-9_-]*$"
reg_num="^[0-9_-]*$"
reg_num_07="^[0-7_-]*$"
parpadeo="verdadero"

clear;tput civis

function blanco { tput setaf 15; }
function gris { tput setaf 7; }
function celeste { tput setaf 14; }
function verde { tput setaf 2; }
function amarillo { tput setaf 11; }
function negro { tput setaf 0; }
function rojo { tput setaf 1; }
function anaranjado { tput setaf 3; }
function azul { tput setaf 4; }
function lila { tput setaf 13; }

function parpadear {
    if [[ $parpadeo == "verdadero" ]];then tput blink; fi
}

function pulsa_tecla {
    amarillo;echo "" && echo "Pulse alguna tecla para continuar.";read -sn1;blanco
}

function mensaje_regresar_menu {
    gris;echo -n "> Escriba ";blanco;parpadear;echo -n "@menu";tput sgr0;gris;echo " en cualquier momento para regresar al menú principal." && echo "";blanco
}

function salir {
    verde;echo "";cat "$camino/complementos/agradecimientos";echo ""
    amarillo;echo "¡Muchas gracias por utilizar artixers!" && echo "";tput sgr0;tput cnorm;exit
}

function usuario_no_encontrado {
    amarillo;echo "" && echo "El nombre de usuario proporcionado no ha sido encontrado."
    echo -n "Se recomienda volver al menú y seleccionar la opción ";verde;echo -n "02";amarillo;echo " antes de volver a esta sección del programa."
    echo -n "Si desea regresar al menú, pulse ";parpadear;celeste;echo -n "M";tput sgr0;amarillo;echo " ahora; de lo contrario, regresará al inicio de esta misma sección.";blanco
}

function grupo_no_encontrado {
    amarillo;echo "" && echo "El nombre del grupo proporcionado no ha sido encontrado."
    echo -n "Se recomienda volver al menú y seleccionar la opción ";verde;echo -n "05";amarillo;echo " antes de volver a esta sección del programa."
    echo -n "Si desea regresar al menú, pulse ";parpadear;celeste;echo -n "M";tput sgr0;amarillo;echo " ahora; de lo contrario, regresará al inicio de esta misma sección.";blanco
}

function confirmacion_codigo {
    acuerdo=$((RANDOM*(9999-1000)/32767+1000))
    blanco;echo "" && echo -n "Para continuar, digite el código ";parpadear;amarillo;echo -n $acuerdo;tput sgr0;blanco;echo -n ", o cualquier otro código de 4 dígitos para abortar la operación: ";amarillo
    tput cnorm;read -n4 aku;tput civis;blanco
    echo ".";read -e -t1

    if [[ $aku -ne $acuerdo ]] || [[ ! $aku =~ $reg_num ]];then
        parpadear;rojo;echo "" && echo "La operación ha sido abortada. No se han realizado cambios."
        echo "ESPERE..."
        tput sgr0;sleep 4
        exec bash "$0"
    fi
}

function ayuda_e_info {
    clear;echo ""
    cat "$camino/complementos/ayuda_e_info"
    pulsa_tecla;menu
}

function creditos {
    clear;echo ""
    cat "$camino/complementos/creditos"
    pulsa_tecla;menu
}

function resumen_permisos {

    if [[ $seleccion == "" ]] || [[ $accion == "" ]] || [[ $atributo == "" ]] || [[ $comando == "" ]] || [[ $tipo == "" ]];then
        parpadear;rojo;echo "" && echo "La información ingresada es inconsistente.";tput sgr0
        amarillo;echo "Se regresará al inicio de la sección, para que pueda empezar nuevamente con mayor cuidado."
        pulsa_tecla;permisos_especiales
    fi
    
    clear;blanco
    echo "" && echo "RESUMEN:" && echo ""
    echo -n "DIRECTORIO OBJETIVO          : ";verde;echo $seleccion
    blanco;echo -n "ACCIÓN A APLICAR             : ";verde;echo $accion
    blanco;echo -n "ATRIBUTO GENERAL UTILIZADO   : ";verde;echo $atributo
    blanco;echo -n "COMANDO INVOCADO             : ";verde;echo $comando
    blanco;echo -n "TIPO DE PERMISO              : ";verde;echo $tipo
    blanco;echo -n "ATRIBUTO DE COMANDO UTILIZADO: ";verde;echo $atribcom
    amarillo;echo "" && echo "Por favor, confirme el código 2 veces seguidas para poder continuar."
    confirmacion_codigo;confirmacion_codigo
    
    if [[ $qlp == "1" ]];then
        echo "chattr +a $seleccion";read
        sudo chattr +a "$seleccion"
    elif [[ $qlp == "2" ]];then
        echo "chattr -a $seleccion";read
        sudo chattr -a "$seleccion"
    elif [[ $qlp == "3" ]];then
        echo "chattr -R +a $seleccion";read
        sudo chattr -R +a "$seleccion"
    elif [[ $qlp == "4" ]];then
        echo "chattr -R -a $seleccion";read
        sudo chattr -R -a "$seleccion"
    elif [[ $qlp == "5" ]];then
        echo "chattr +i $seleccion";read
        sudo chattr +i "$seleccion"
    elif [[ $qlp == "6" ]];then
        echo "chattr -i $seleccion";read
        sudo chattr -i "$seleccion"
    elif [[ $qlp == "7" ]];then
        echo "chmod -R $sopermis $seleccion";read
        sudo chmod -R $sopermis "$seleccion"
    elif [[ $qlp == "8" ]];then
        echo "chmod $sopermis $seleccion";read
        sudo chmod $sopermis "$seleccion"
    fi
    
    echo "" && echo "La operación ha sido realizada. Compruebe por sus propios medios que así haya sido."
    pulsa_tecla;menu
}

function permisos_especiales {
    clear;blanco;echo "" && echo "Aplicación de PERMISOS ESPECIALES." && echo ""
    gris;echo "En esta sección, podrá aplicar 'permisos chmod' y también 'permisos chattr'.";amarillo
    echo "" && echo "INFORMACIÓN MUY IMPORTANTE:" && echo "";rojo
    echo "> DEBE TENER CUIDADO: podría dejar inutilizable al sistema, o perder el acceso a directorios fundamentales."
    echo "> DEBE PRESTAR ATENCIÓN: no utilice esta sección de artixers si su situación le impide concentrarse y focalizar."
    echo "> DEBE CONOCER LOS PERMISOS UNIX 'UGO' (UsuariosGruposOtros/UsersGroupsOthers) de 3 cifras (000 a 777)."
    gris;echo "" && echo "Si continúa, en primer lugar, artixers le pedirá que seleccione un directorio al cual aplicarle los permisos."
    echo -n "En una siguiente etapa, podrá indicarle a artixers qué tipo de permisos desea aplicar ('";blanco;echo -n "chattr";gris;echo -n "' o '";blanco;echo -n "chmod";gris;echo "')."
    amarillo;echo "" && echo "NO CONTINÚE SI NO SABE REALMENTE LO QUE ESTÁ HACIENDO."
    confirmacion_codigo
    clear;blanco;echo "" && echo "Aplicación de PERMISOS ESPECIALES." && echo ""
    echo "RECUERDE: la tecla [ESPACIO] es fundamental. Lea con cuidado." && echo ""
    gris;echo -n "Las teclas ";blanco;echo -n "[Tab]";gris;echo -n " o ";blanco;echo -n "[↑] [↓]";gris;echo ", seleccionan el panel correspondiente (directorios/selección/botones de acción)."
    echo -n "La tecla ";blanco;echo -n "[ESPACIO]";gris;echo " pulsada 1 sola vez, establece el directorio al que le aplicará los cambios."
    echo -n "La tecla ";blanco;echo -n "[ESPACIO]";gris;echo " pulsada 2 veces, ingresa dentro de un directorio."
    echo -n "La tecla ";blanco;echo -n "[ Enter ]";gris;echo ", da por finalizada la selección, y da paso a que artixers le confirme lo seleccionado."
    amarillo;echo "" && echo "Pulse alguna tecla para que se abra el cuadro de diálogo y sea posible continuar."
    read -sn1
    seleccion=$(dialog --stdout --title "Seleccione el directorio:" --dselect "/home/entropia_binaria/Documentos/00_BASH/10_Últimos/artixers/pruebas/" 22 44)
    
    if [[ $seleccion == "" ]];then resumen_permisos; fi
    
    clear;blanco;echo "" && echo "Directorio seleccionado: ";verde;echo "" && echo $seleccion && echo "";blanco
    echo "Pulse..." && echo ""
    echo -n "'";celeste;parpadear;echo -n "P";blanco;tput sgr0;blanco;echo "' para regresar y elegir otro directorio,"
    echo -n "'";celeste;parpadear;echo -n "V";blanco;tput sgr0;blanco;echo "' para visualizar el contenido del directorio seleccionado"
    gris;echo "    (una vez allí, puede pulsar 'Q' para continuar),";blanco
    echo -n "'";celeste;parpadear;echo -n "M";blanco;tput sgr0;blanco;echo "' para volver al menú general,"
    amarillo;echo "" && echo "...cualquier otra tecla para continuar.";blanco
    read -sn1 tyt
    tyt=`echo "$tyt" | tr '[:upper:]' '[:lower:]'`
    
    if [[ $tyt == "p" ]];then
        permisos_especiales
    elif [[ $tyt == "v" ]];then
        if [[ "$(ls -A $seleccion)" ]];then
            clear;tree $seleccion | less -FE
            pulsa_tecla
        else
            clear
            echo "" && echo "El directorio está vacío."
            pulsa_tecla
        fi
    elif [[ $tyt == "m" ]];then
        menu
    fi
    
    clear;echo "" && echo "Prosigamos." && echo -n "Ahora deberá indicar si quiere aplicar permisos '";verde;echo -n "chattr";blanco;echo -n "' o '";lila;echo -n "chmod";blanco;echo "' al directorio"
    verde;echo "" && echo $seleccion
    blanco;echo "" && echo "Pulse:" && echo ""
    echo "╔═════════════════════════════════════════════════════════════════════════╗"
    echo -n "║ ";celeste;parpadear;echo -n "1";tput sgr0;blanco;echo -n " │ para ";anaranjado;echo -n "OTORGAR";blanco;echo -n " PERMANENCIA   de permisos ";verde;echo -n "chattr";blanco;echo "                  (+a) ║"
    echo -n "║ ";celeste;parpadear;echo -n "2";tput sgr0;blanco;echo -n " │ para ";azul;echo -n "QUITAR";blanco;echo -n "  PERMANENCIA   de permisos ";verde;echo -n "chattr";blanco;echo "                  (-a) ║"
    echo -n "║ ";celeste;parpadear;echo -n "3";tput sgr0;blanco;echo -n " │ para ";anaranjado;echo -n "OTORGAR";blanco;echo -n " PERMANENCIA   de permisos ";verde;echo -n "chattr";blanco;echo " RECURSIVOS    (-R +a) ║"
    echo -n "║ ";celeste;parpadear;echo -n "4";tput sgr0;blanco;echo -n " │ para ";azul;echo -n "QUITAR";blanco;echo -n "  PERMANENCIA   de permisos ";verde;echo -n "chattr";blanco;echo " RECURSIVOS    (-R -a) ║"
    echo "║───┼─────────────────────────────────────────────────────────────────────║"
    echo -n "║ ";celeste;parpadear;echo -n "5";tput sgr0;blanco;echo -n " │ para ";anaranjado;echo -n "OTORGAR";blanco;echo -n " INMUTABILIDAD de permisos ";verde;echo -n "chattr";blanco;echo "                  (+i) ║"
    echo -n "║ ";celeste;parpadear;echo -n "6";tput sgr0;blanco;echo -n " │ para ";azul;echo -n "QUITAR";blanco;echo -n "  INMUTABILIDAD de permisos ";verde;echo -n "chattr";blanco;echo "                  (-i) ║"
    echo "║───┼─────────────────────────────────────────────────────────────────────║"
    echo -n "║ ";celeste;parpadear;echo -n "7";tput sgr0;blanco;echo -n " │ para ";anaranjado;echo -n "OTORGAR";blanco;echo -n "                  permisos ";lila;echo -n "chmod";blanco;echo "  RECURSIVOS    (-R)    ║"
    echo -n "║ ";celeste;parpadear;echo -n "8";tput sgr0;blanco;echo -n " │ para ";anaranjado;echo -n "OTORGAR";blanco;echo -n "                  permisos ";lila;echo -n "chmod";blanco;echo "  NO RECURSIVOS         ║"
    echo "║───┼─────────────────────────────────────────────────────────────────────║"
    echo -n "║ ";celeste;parpadear;echo -n "9";tput sgr0;blanco;echo " │ para volver a la sección de permisos sin realizar cambios           ║"
    echo -n "║ ";celeste;parpadear;echo -n "0";tput sgr0;blanco;echo " │ para volver al menú principal sin realizar cambios                  ║"
    echo "╚═════════════════════════════════════════════════════════════════════════╝" && echo ""
    read -sn1 qlp
    
    if [[ $qlp == "1" ]];then
        accion="otorgamiento";atributo="permanencia";comando="chattr";tipo="individual y simple";atribcom="+a"
    elif [[ $qlp == "2" ]];then
        accion="quita";atributo="permanencia";comando="chattr";tipo="individual y simple";atribcom="-a"
    elif [[ $qlp == "3" ]];then
        accion="otorgamiento";atributo="permanencia";comando="chattr";tipo="múltiple y recursivo";atribcom="-R +a"
    elif [[ $qlp == "4" ]];then
        accion="quita";atributo="permanencia";comando="chattr";tipo="múltiple y recursivo";atribcom="-R -a"
    elif [[ $qlp == "5" ]];then
        accion="otorgamiento";atributo="inmutabilidad";comando="chattr";tipo="individual y simple";atribcom="+i"
    elif [[ $qlp == "6" ]];then
        accion="quita";atributo="inmutabilidad";comando="chattr";tipo="individual y simple";atribcom="-i"
    elif [[ $qlp == "7" ]];then
        accion="otorgamiento";atributo="ugo ($sopermis)";comando="chmod";tipo="múltiple y recursivo";atribcom="-R"
    elif [[ $qlp == "8" ]];then
        accion="quita";atributo="ugo ($sopermis)";comando="chmod";tipo="individual y simple";atribcom=""
    elif [[ $qlp == "9" ]];then
        permisos_especiales
    elif [[ $qlp == "0" ]];then
        menu
    fi
    
    if [[ $qlp == "7" ]] || [[ $qlp == "8" ]];then
        function ta_mal {
            echo "La información ingresada posee inconsistencias."
            pulsa_tecla;permisos_especiales
        }

        function traducir_permisos () {
            if [[ $1 == 0 ]];then echo "ninguna";
            elif [[ $1 == 1 ]];then echo "ejecución";
            elif [[ $1 == 2 ]];then echo "escritura";
            elif [[ $1 == 3 ]];then echo "escritura y ejecución";
            elif [[ $1 == 4 ]];then echo "lectura";
            elif [[ $1 == 5 ]];then echo "lectura y ejecución";
            elif [[ $1 == 6 ]];then echo "lectura y escritura";
            elif [[ $1 == 7 ]];then echo "lectura, escritura y ejecución"; fi
        }

        tput cnorm;read -p "Ingrese los permisos UNIX 'ugo' en forma de 3 dígitos: " sopermis;tput civis

        # Verificar que el largo sea de 3 caracteres.
        if [[ ${#sopermis} -ne 3 ]];then ta_mal; fi

        # Verificar que sean números.
        if [[ ! $sopermis =~ $reg_num_07 ]];then ta_mal; fi

        perm_propietario=${sopermis:0:1};perm_grupos=${sopermis:1:1};perm_resto=${sopermis:2:1}
        echo "" && echo "Propietario: "$perm_propietario", grupos: "$perm_grupos", el resto: "$perm_resto"." && echo ""
        echo -n "Posibilidades del propietario: ";traducir_permisos $perm_propietario
        echo -n "Posibilidades de los grupos  : ";traducir_permisos $perm_grupos
        echo -n "Posibilidades del resto      : ";traducir_permisos $perm_resto
        echo "" && echo -n "Pulse '";parpadear;celeste;echo -n "P";tput sgr0;blanco;echo "', para volver a establecer los permisos, o cualquier otra tecla para continuar."
        atributo="ugo ($sopermis)"
        read -sn1 zxc
        zxc=`echo "$zxc" | tr '[:upper:]' '[:lower:]'`
        
        if [[ $zxc == "p" ]];then permisos_especiales; fi
    fi
    
    if [[ $qlp -ge 0 ]] && [[ $qlp -le 8 ]];then
        resumen_permisos
    else
        echo "" && echo "No se ha efectuado correctamente la selección. Se volverá al principio de la sección."
        pulsa_tecla;menu
    fi
    
    pulsa_tecla;salir
}

function menu {
    clear;celeste;tput bold;echo ""
    echo " ░░░  ░░░░  ░░░░░ ░ ░   ░ ░░░░░ ░░░░   ░░░"
    echo "▒   ▒ ▒   ▒   ▒   ▒  ▒ ▒  ▒     ▒   ▒ ▒"
    echo "▓▓▓▓▓ ▓▓▓▓    ▓   ▓   ▓   ▓▓▓▓  ▓▓▓▓   ▓▓▓"
    echo "█   █ █   █   █   █  █ █  █     █   █     █"
    echo "█   █ █   █   █   █ █   █ █████ █   █ ████" && echo ""
    tput sgr0;amarillo;echo "Panel ASCII de administración de cuentas de usuarios y sus atributos,"
    echo "pensado para sistemas basados en Arch, 100% compatible con otras distribuciones Linux y con BSD."
    blanco;echo ""
    gris;echo -n "╔";blanco;echo "═════════════════════════════════════════════════════════════════════╗"
    gris;echo -n "║";celeste;tput setab 4;echo -n "     Menú principal                                                  ";tput sgr0;blanco;echo "║"
    gris;echo -n "╠";blanco;echo "═════════════════════════════════════════════════════════════════════╣"
    gris;echo -n "║ 01. ";celeste;tput bold;parpadear;echo -n "L";tput sgr0;blanco;echo "istar nombres de usuarios creados con ID mayor o igual a 1000  ║"
    gris;echo -n "║ 02. ";blanco;echo -n "Listar ";celeste;tput bold;parpadear;echo -n "t";tput sgr0;blanco;echo "odos los nombres de usuarios existentes en el sistema   ║"
    gris;echo -n "║ 03. ";celeste;tput bold;parpadear;echo -n "C";tput sgr0;blanco;echo "rear usuarios                                                  ║"
    gris;echo -n "║ 04. ";celeste;tput bold;parpadear;echo -n "E";tput sgr0;blanco;echo "liminar usuarios                                               ║"
    gris;echo -n "║ 05. ";blanco;echo -n "L";celeste;tput bold;parpadear;echo -n "i";tput sgr0;blanco;echo "star grupos                                                   ║"
    gris;echo -n "║ 06. ";celeste;tput bold;parpadear;echo -n "A";tput sgr0;blanco;echo "ñadir grupos                                                   ║"
    gris;echo -n "║ 07. ";celeste;tput bold;parpadear;echo -n "B";tput sgr0;blanco;echo "orrar grupos                                                   ║"
    gris;echo -n "║ 08. ";blanco;echo -n "Ver qué usuarios e";celeste;tput bold;parpadear;echo -n "x";tput sgr0;blanco;echo "isten dentro de un grupo                     ║"
    gris;echo -n "║ 09. ";celeste;tput bold;parpadear;echo -n "V";tput sgr0;blanco;echo "er los grupos a los cuales pertenece un usuario                ║"
    gris;echo -n "║ 10. ";blanco;echo -n "Añadi";celeste;tput bold;parpadear;echo -n "r";tput sgr0;blanco;echo " a un usuario a un grupo                                  ║"
    gris;echo -n "║ 11. ";celeste;tput bold;parpadear;echo -n "Q";tput sgr0;blanco;echo "uitar a un usuario de un grupo                                 ║"
    gris;echo -n "║ 12. ";blanco;echo -n "Consultar el camino al directorio ";celeste;tput bold;parpadear;echo -n "h";tput sgr0;blanco;echo "ome de un usuario            ║"
    gris;echo -n "║ 13. ";blanco;echo -n "Asignar ";celeste;tput bold;parpadear;echo -n "p";tput sgr0;blanco;echo "ermisos especiales (utilice cuidadosamente)            ║"
    gris;echo -n "╠";blanco;echo "═════════════════════════════════════════════════════════════════════╣"
    gris;echo -n "║ 14.";blanco;echo -n " A";celeste;tput bold;parpadear;echo -n "y";tput sgr0;blanco;echo "uda e información sobre artixers                              ║"
    gris;echo -n "║ 15. ";blanco;echo -n "Cré";celeste;tput bold;parpadear;echo -n "d";tput sgr0;blanco;echo "itos y licencia                                             ║"
    gris;echo -n "║ 16. ";celeste;tput bold;parpadear;echo -n "S";tput sgr0;blanco;echo "alir                                                           ║"
    gris;echo -n "╚";blanco;echo "═════════════════════════════════════════════════════════════════════╝" && echo ""
    gris;echo "Para seleccionar una opción, pulse la letra (parpadeante o coloreada) correspondiente."
    gris;echo "También puede pulsar '-' para apagar el parpadeo, y '+' para volver a encenderlo.";blanco
    
    function encapsulamiento_tecla_menu {
        read -sn1 op
        nom_logico=`echo "$op" | tr '[:upper:]' '[:lower:]'`
        
        if [[ $op == "l" ]];then listar_creados;
        elif [[ $op == "t" ]];then listar_todos;
        elif [[ $op == "c" ]];then crear_usuario;
        elif [[ $op == "e" ]];then eliminar_usuario;
        elif [[ $op == "i" ]];then listar_grupos;
        elif [[ $op == "a" ]];then aniadir_grupos;
        elif [[ $op == "b" ]];then borrar_grupos;
        elif [[ $op == "x" ]];then usuarios_dentro_grupo;
        elif [[ $op == "v" ]];then ver_grupos_usuario;
        elif [[ $op == "r" ]];then aniadir_a_grupo;
        elif [[ $op == "q" ]];then quitar_de_grupo;
        elif [[ $op == "h" ]];then consultar_home;
        elif [[ $op == "p" ]];then permisos_especiales;
        elif [[ $op == "y" ]];then ayuda_e_info;
        elif [[ $op == "d" ]];then creditos;
        elif [[ $op == "s" ]];then salir;
        elif [[ $op == "-" ]];then parpadeo="falso";menu;
        elif [[ $op == "+" ]];then parpadeo="verdadero";menu;
        else encapsulamiento_tecla_menu;fi
    }
    
    encapsulamiento_tecla_menu
}

function listar_creados {
    clear;echo "" && echo "Usuarios creados con ID mayor o igual a 1000:" && echo ""
    celeste;cat /etc/passwd | awk -F':' '(( $3 >= 1000 && $3 < 65534 )) {print $1}' | sort
    pulsa_tecla;menu
}

function listar_todos {
    cant_usuarios=`wc -l </etc/passwd`
    blanco;clear;echo "" && echo "Lista de todos los usuarios existentes en el sistema." && echo ""
    amarillo;echo "Se han encontrado "$cant_usuarios" usuarios.";blanco;echo ""
    gris;echo "> Cuando vea el listado, con las flechas arriba/abajo, podrá recorrer la lista y también pulsar Q para finalizar."
    echo "  Al llegar al final de la misma, el programa volverá al menú principal."
    pulsa_tecla;echo ""
    celeste;cat /etc/passwd | awk -F':' '{print $1}' | sort | less -FE
    parpadear;pulsa_tecla;tput sgr0;menu
}

function crear_usuario {
    clear;blanco;echo "" && echo "Creación de usuarios." && echo "";gris
    echo "  Instrucciones generales:" && echo ""
    echo "> El nombre lógico, no deberá poseer un número al principio, ni poseer más de 32 caracteres. Tampoco podrá contener mayúsculas, espacios, tildes ni símbolos."
    echo "> El nombre real, no deberá poseer un número al principio, ni poseer más de 256 caracteres ."
    echo "> Cualquier cosa que responda a la pregunta sobre crearle un directorio personal al usuario, será tomada como un 'sí', salvo que escriba 'no'."
    mensaje_regresar_menu
    tput cnorm;read -p "Ingrese el nombre lógico del usuario a crear: " nom_logico;tput civis
    nom_logico=`echo "$nom_logico" | tr '[:upper:]' '[:lower:]'`
    
    if [[ $nom_logico == "@menu" ]];then menu;fi
    
    if [[ -z "$nom_logico" ]];then crear_usuario;fi
    
    if [[ ! $nom_logico =~ $reg_num_let ]]; then
        echo "" && echo "El nombre ingresado contiene caracteres no válidos."
        echo "Revise las instrucciones generales proporcionadas."
        pulsa_tecla;crear_usuario
    fi
    
    if [[ $nom_logico == [0-9]* ]];then
        echo "" && echo "El nombre del usuario no puede comenzar con un número."
        echo "Revise las instrucciones generales proporcionadas."
        pulsa_tecla;crear_usuario
    fi
    
    if id "$nom_logico" >/dev/null 2>&1;then
        echo "" && echo "Ese nombre de usuario lógico ya existe. Deberá utilizar otro."
        pulsa_tecla;crear_usuario
    fi

    if [[ ${#nom_logico} -gt 32 ]];then
        echo "" && echo ${#nom_logico} "caracteres para el nombre real son demasiados. Reintente."
        pulsa_tecla;crear_usuario
    fi

    tput cnorm;read -p "Ingrese el nombre  real  del usuario a crear: " nom_real;tput civis
    if [[ $nom_real == "@menu" ]];then menu; fi
    
    if [[ ${#nom_real} -gt 256 ]];then
        echo "" && echo ${#nom_real} "caracteres para el nombre real son demasiados. Reintente."
        pulsa_tecla;crear_usuario
    fi

    tput cnorm;read -p "¿Crear directorio personal dentro de home?  : " var;tput civis
    var=`echo "$var" | tr '[:upper:]' '[:lower:]'`
    
    if [[ $var == "@menu" ]];then menu; fi
    
    if [[ $var == "n" ]] || [[ $var == "no" ]];then
        dir_pers="falso"
    else
        dir_pers="verdadero"
    fi
    
    echo "" && echo "RESUMEN:" && echo ""
    echo "Nombre lógico      : "$nom_logico
    echo "Nombre real        : "$nom_real
    echo "Directorio personal: "$dir_pers
    confirmacion_codigo
    
    if [[ $dir_pers == "verdadero" ]];then
        sudo useradd -c "$nom_real" $nom_logico
        echo "" && echo "Creando los directorios personales del usuario y asignando permisos..."
        sudo mkdir "/home/$nom_logico"
        sudo chown -R $nom_logico "/home/$nom_logico"
        sudo chgrp -R users "/home/$nom_logico"
    else
        sudo useradd -M -N -r -s /bin/false -c "$nom_real" $nom_logico
    fi
    
    echo "Ahora, deberá introducir una contraseña para el usuario "$nom_logico"." && echo ""
    sudo passwd $nom_logico
    echo "" && echo "Si ha introducido la contraseña correctamente, el usuario ha sido completamente creado."
    echo -n "De no ser así, deberá ejecutar en terminal o consola la instrucción ";amarillo;echo -n "sudo passwd $nom_logico";blanco;echo " para completar la creación."
    pulsa_tecla;menu
}

function eliminar_usuario {
    clear;echo "" && echo "ELIMINACIÓN DE USUARIOS." && echo ""
    mensaje_regresar_menu
    tput cnorm;read -p "Ingrese el nombre lógico del usuario a eliminar: " nom_logico;tput civis
    nom_logico=`echo "$nom_logico" | tr '[:upper:]' '[:lower:]'`
    
    if [[ $nom_logico == "@menu" ]];then menu; fi
    
    if id "$nom_logico" >/dev/null 2>&1;then
        echo -n "* Cualquier cosa que responda a la pregunta sobre eliminar el directorio personal al usuario, será tomada como un ";amarillo;echo -n  "'no'";blanco;echo -n ", salvo que escriba ";amarillo;echo -n "'si'";blanco;echo "." && echo ""        
        tput cnorm;read -p "ATENCIÓN: ¿eliminar el directorio personal dentro de home?: " var1;tput civis
        
        if [[ $var1 == "@menu" ]];then menu; fi

        parpadear;read -p "DE NUEVO: ¿SEGURO QUE DESEA ELIMINAR TODA LA INFORMACIÓN PERSONAL DEL USUARIO?: " var2
        tput sgr0;tput civis;blanco
        
        if [[ $var2 == "@menu" ]];then menu; fi
        
        var1=`echo "$var1" | tr '[:upper:]' '[:lower:]'`
        var2=`echo "$var2" | tr '[:upper:]' '[:lower:]'`
        
        if [[ $var1 != $var2 ]];then
            echo "" && echo "No es posible continuar. Se han detectado inconsistencias muy importantes."
            pulsa_tecla;eliminar_usuario
        else
            if [[ $var1 == "si" ]] || [[ $var1 == "sí" ]];then
                eliminar_directorio="verdadero"
            else
                eliminar_directorio="falso"
            fi
        fi
        
        echo "" && echo "RESUMEN:" && echo ""
        echo "USUARIO A ELIMINAR           : "$nom_logico
        echo "ELIMINAR INFORMACIÓN PERSONAL: "$eliminar_directorio
        confirmacion_codigo
        
        if [[ $eliminar_directorio = "falso" ]];then
            sudo userdel $nom_logico
        else
            sudo userdel -r $nom_logico
        fi
    else
        usuario_no_encontrado
        read -sn1 var
        
        if [[ $var == "m" ]] || [[ $var == "M" ]];then
            menu
        else
            eliminar_usuario
        fi
    fi
    
    echo "" && echo "El usuario "$nom_logico" ha sido eliminado del sistema."
    pulsa_tecla;menu
}

function listar_grupos {
    cant_grupos=`wc -l </etc/group`
    blanco;clear;echo "" && echo "Lista de todos los grupos de usuarios existentes en el sistema." && echo ""
    clear;amarillo;echo "Se han encontrado "$cant_grupos" grupos.";blanco;echo ""
    gris;echo "> Cuando vea el listado, con las flechas arriba/abajo, podrá recorrer la lista y también pulsar Q para finalizar."
    echo "  Al llegar al final de la misma, el programa volverá al menú principal."
    pulsa_tecla;echo ""
    celeste;cat /etc/group | awk -F':' '{print $1}' | sort | less -FE
    parpadear;pulsa_tecla;tput sgr0;menu
}

function aniadir_grupos {
    clear;blanco;echo "" && echo "Creación de grupos." && echo "";gris
    echo "  Instrucciones generales:" && echo ""
    echo "> El nombre del grupo a añadir, no deberá poseer números, ni una longitud mayor que 32 caracteres."
    echo "> Tampoco podrá contener mayúsculas, espacios, tildes ni símbolos."
    mensaje_regresar_menu
    echo "";blanco
    tput cnorm;read -p "Ingrese el nombre lógico del grupo a crear: " nom_grupo;tput civis
    nom_grupo=`echo "$nom_grupo" | tr '[:upper:]' '[:lower:]'`
    
    if [[ $nom_grupo == "@menu" ]];then menu; fi
    
    if [[ ! $nom_grupo =~ $reg_num_let ]]; then
        echo "" && echo "El nombre ingresado contiene caracteres no válidos."
        echo "Revise las instrucciones generales proporcionadas."
        pulsa_tecla;aniadir_grupos
    fi
    
    if [[ $nom_grupo == *[0-9]* ]];then
        echo "" && echo "El nombre del usuario no puede contener números."
        echo "Revise las instrucciones generales proporcionadas."
        pulsa_tecla;aniadir_grupos
    fi
    
    if [[ $(getent group $nom_grupo) ]]; then
        echo "" && echo "Ese nombre de grupo ya existe. Deberá utilizar otro."
        pulsa_tecla;aniadir_grupos
    fi

    if [[ ${#nom_grupo} -gt 32 ]];then
        echo "" && echo ${#nom_grupo} "caracteres para el nombre real son demasiados. Reintente."
        pulsa_tecla;aniadir_grupos
    fi
    
    confirmacion_codigo
    sudo groupadd $nom_grupo
    echo "" && echo "Si ha introducido la contraseña correctamente, el grupo ha sido creado."
    echo -n "Para continuar añadiendo grupos, pulse ";parpadear;celeste;echo -n "A";tput sgr0;blanco;echo "."
    echo "Cualquier otra tecla, vuelve al menú principal."
    var="";read -sn1 var
    
    if [[ $var == "A" ]] || [[ $var == "a" ]];then
        aniadir_grupos
    else
        menu
    fi
}

function borrar_grupos {
    clear;echo "" && echo "BORRADO DE GRUPOS." && echo ""
    rojo;echo "CUIDADO: no es recomendable borrar grupos creados para el sistema."
    echo "Se aconseja enfáticamente que borre únicamente grupos creados por usuarios de este equipo." && echo "";gris
    mensaje_regresar_menu
    tput cnorm;read -p "Ingrese el nombre del grupo a borrar: " grupo_a_borrar;tput civis
    grupo_a_borrar=`echo "$grupo_a_borrar" | tr '[:upper:]' '[:lower:]'`
    
    if [[ $grupo_a_borrar == "@menu" ]];then menu; fi
    
    if [[ $(getent group $grupo_a_borrar) ]];then
        confirmacion_codigo
        sudo groupdel $grupo_a_borrar
        echo "" && echo "Si se le ha solicitado una contraseña y la ha introducido correctamente, el grupo ha sido borrado."
        echo -n "Para continuar añadiendo grupos, pulse ";parpadear;celeste;echo -n "B";tput sgr0;blanco;echo "."
        echo "Cualquier otra tecla, vuelve al menú principal."
        read -sn1 var
        
        if [[ $var == "B" ]] || [[ $var == "b" ]];then
            borrar_grupos
        else
            menu
        fi
    else
        amarillo;grupo_no_encontrado
        read -sn1 var
        
        if [[ $var == "M" ]] || [[ $var == "m" ]];then
            menu
        else
            borrar_grupos
        fi
    fi
}

function usuarios_dentro_grupo {
    clear;blanco;echo "" && echo "Visualización del contenido de los grupos de usuarios." && echo ""
    mensaje_regresar_menu
    tput cnorm;read -p "Ingrese el nombre del grupo a inspeccionar: " gru;tput civis
    gru=`echo "$gru" | tr '[:upper:]' '[:lower:]'`

    if [[ $gru == "@menu" ]];then menu; fi
    
    usuengrp=`getent group $gru | cut -d ":" -f4`
    
    if [[ $(getent group $gru) ]];then
        echo "" && echo "Usuarios contenidos dentro del grupo $gru:" && echo ""

        if [[ $usuengrp == "" ]];then          
            verde;echo "> no se han encontrado usuarios dentro de este grupo <"
        else
            celeste;getent group $gru | cut -d ":" -f4;blanco
        fi
        
        pulsa_tecla;menu
    else
        amarillo;grupo_no_encontrado
        read -sn1 var
        
        if [[ $var == "M" ]] || [[ $var == "m" ]];then
            menu
        else
            usuarios_dentro_grupo
        fi
    fi
}

function ver_grupos_usuario {
    clear;echo "" && echo "Verificación de grupos." && echo ""
    mensaje_regresar_menu
    tput cnorm;read -p "Ingrese el nombre lógico del usuario objetivo: " usu;tput civis
    usu=`echo "$usu" | tr '[:upper:]' '[:lower:]'`
    
    if [[ $usu == "@menu" ]];then menu; fi
    
    if [[ $(getent group $usu) ]];then
        clear;blanco;echo "" && echo "Grupo PRINCIPAL del usuario $usu:" && echo ""
        celeste;id -gn $usu
        blanco;echo "" && echo "Grupos SECUNDARIOS del usuario $usu:" && echo ""
        celeste;id -Gn $usu | cut -d' ' -f2-
        pulsa_tecla;menu
    else
        usuario_no_encontrado
        read -sn1 var
        
        if [[ $var == "m" ]] || [[ $var == "M" ]];then
            menu
        else
            ver_grupos_usuario
        fi
    fi
}

function aniadir_a_grupo {
    clear;blanco;echo "" && echo "Añadir a usuarios a grupos." && echo ""
    mensaje_regresar_menu
    tput cnorm;read -p "Ingrese el nombre lógico del usuario objetivo: " usu;tput civis
    usu=`echo "$usu" | tr '[:upper:]' '[:lower:]'`
    
    if [[ $usu == "@menu" ]];then menu; fi
    
    if id "$usu" >/dev/null 2>&1;then
        tput cnorm;read -p "Ingrese el grupo a añadir al usuario $usu: " grupo;tput civis
        
        if [[ $usu == "@menu" ]];then menu; fi
        
        if [[ $(getent group $grupo) ]];then
            blanco;echo "" && echo "Pulse:" && echo ""
            celeste;parpadear;echo -n "1";tput sgr0;blanco;echo " para añadirle al usuario $usu el grupo $grupo como PRIMARIO."
            celeste;parpadear;echo -n "2";tput sgr0;blanco;echo " para añadirle al usuario $usu el grupo $grupo como SECUNDARIO.";tput civis
            echo "" && echo "Cualquier otra tecla para regresar al menú principal.";tput civis
            
            read -sn1 primsec
            
            if [[ $primsec == "1" ]];then
                confirmacion_codigo
                sudo usermod -g $grupo $usu
            elif [[ $primsec == "2" ]];then
                confirmacion_codigo
                sudo usermod -a -G $grupo $usu
            else
                menu
            fi
        else
            grupo_no_encontrado
            read -sn1 var
            
            if [[ $var == "M" ]] || [[ $var == "m" ]];then
                menu
            else
                aniadir_a_grupo
            fi
        fi
        
    else
        usuario_no_encontrado
        read -sn1 var
        
        if [[ $var == "m" ]] || [[ $var == "M" ]];then
            menu
        else
            aniadir_a_grupo
        fi
    fi
    
    echo "" && echo "Si se le ha solicitado una contraseña y la ha introducido correctamente, el grupo ha sido añadido."
    echo -n "Para continuar añadiendo grupos, pulse ";parpadear;celeste;echo -n "R";tput sgr0;blanco;echo "."
    echo "Cualquier otra tecla, vuelve al menú principal."

    read -sn1 var
        
    if [[ $var == "R" ]] || [[ $var == "r" ]];then
        aniadir_a_grupo
    else
        menu
    fi
}

function quitar_de_grupo {
    clear;blanco;echo "" && echo "QUITAR A USUARIOS DE GRUPOS." && echo ""
    gris;echo "Solo a modo informativo: no es posible eliminar a un usuario de un grupo primario."
    echo -n "Si es esto lo que desea hacer, deberá ir al menú principal, escoger la opción ";amarillo;echo -n "06";gris;echo ", y añadir al usuario a un grupo primario distinto al que ya pertenece."
    echo "De este modo es que se consigue cambiar a un usuario de un grupo primario a otro." && echo ""
    mensaje_regresar_menu
    tput cnorm;read -p "Ingrese el nombre lógico del usuario objetivo: " usu;tput civis
    usu=`echo "$usu" | tr '[:upper:]' '[:lower:]'`
    
    if [[ $usu == "@menu" ]];then menu; fi
    
    if id "$usu" >/dev/null 2>&1;then
        tput cnorm;read -p "Ingrese el grupo a quitarle al usuario $usu: " grupo;tput civis
        
        if [[ $(getent group $grupo) ]];then
            grupos_usuario=`id $usu`
            
            if [[ $grupos_usuario == *"$grupo"* ]];then
                confirmacion_codigo
                sudo gpasswd --delete $usu $grupo
                
                echo "" && echo "Si se le ha solicitado una contraseña y la ha introducido correctamente,"
                echo "el grupo $grupo ha sido quitado del usuario $usu"
                echo -n "Para continuar añadiendo grupos, pulse ";parpadear;celeste;echo -n "Q";tput sgr0;blanco;echo "."
                echo "Cualquier otra tecla, vuelve al menú principal."

                var="";read -sn1 var
                    
                if [[ $var == "Q" ]] || [[ $var == "q" ]];then
                    aniadir_a_grupo
                else
                    menu
                fi
            fi
        else
            grupo_no_encontrado            
            read -sn1 var
            
            if [[ $var == "M" ]] || [[ $var == "m" ]];then
                menu
            else
                quitar_de_grupo
            fi
        fi
    else
        usuario_no_encontrado
        read -sn1 var
        
        if [[ $var == "m" ]] || [[ $var == "M" ]];then
            menu
        else
            quitar_de_grupo
        fi
    fi
    pulsa_tecla;menu
}

function consultar_home {
    clear;echo "" && echo "Consulta de directorios 'home'." && echo ""
    mensaje_regresar_menu
    tput cnorm;read -p "Ingrese el nombre lógico del usuario: " nomusu;tput civis
    nomusu=`echo "$nomusu" | tr '[:upper:]' '[:lower:]'`
    
    if id "$nomusu" >/dev/null 2>&1;then
        if [[ $nomusu == "@menu" ]];then menu; fi
        home_usuario=$( getent passwd $nomusu | cut -d: -f6 )
        echo "" && echo "El directorio 'home' del usuario "$nomusu", se halla en:"
        celeste;echo "" && echo $home_usuario;blanco
        pulsa_tecla;menu
    else
        usuario_no_encontrado
        read -sn1 byr
        
        if [[ $byr == "m" ]];then
            menu
        else
            consultar_home
        fi
    fi
}

menu
