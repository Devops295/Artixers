#!/bin/bash

# Programa realizado por Hugo Napoli en octubre de 2023 - https://hugonapoli.blogspot.com - @entropiabinaria en YouTube - Copyright 2023 Hugo Napoli.

artixers=$(realpath "$0");camino=$(dirname "$artixers")
reg_num_let="^[A-Za-z0-9_-]*$"
parpadeo="verdadero"

clear;tput civis

function blanco { tput setaf 7; }
function gris { tput setaf 8; }
function azul { tput setaf 4; }
function verde { tput setaf 2; }
function amarillo { tput setaf 11; }
function negro { tput setaf 0; }
function rojo { tput setaf 1; }

function parpadear {
    if [[ $parpadeo == "verdadero" ]];then
        tput blink
    fi
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
    amarillo
    echo "" && echo "El nombre de usuario proporcionado no ha sido encontrado."
    echo -n "Se recomienda volver al menú y seleccionar la opción ";verde;echo -n "02";amarillo;echo " antes de volver a esta sección del programa."
    echo -n "Si desea regresar al menú, pulse ";parpadear;azul;echo -n "M";tput sgr0;amarillo;echo " ahora; de lo contrario, regresará al inicio de esta misma sección."
    blanco
}

function grupo_no_encontrado {
    amarillo
    echo "" && echo "El nombre del grupo proporcionado no ha sido encontrado."
    echo -n "Se recomienda volver al menú y seleccionar la opción ";verde;echo -n "05";amarillo;echo " antes de volver a esta sección del programa."
    echo -n "Si desea regresar al menú, pulse ";parpadear;azul;echo -n "M";tput sgr0;amarillo;echo " ahora; de lo contrario, regresará al inicio de esta misma sección."
    blanco
}

function confirmacion_codigo {
    acuerdo=$((RANDOM*(9999-1000)/32767+1000))
    echo "" && echo -n "Para continuar, digite el siguiente código de 4 dígitos (o escriba 4 caracteres al azar para abortar): ";parpadear;amarillo;echo -n $acuerdo;tput sgr0;echo "." && echo ""
    tput cnorm;read -n4 aku;tput civis
    echo "."

    if [[ $aku -ne $acuerdo ]];then
        parpadear;rojo;echo "" && echo "La operación ha sido abortada. No se han realizado cambios."
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

function menu {
    clear;azul;tput bold;echo ""
    echo " ░░░  ░░░░  ░░░░░ ░ ░   ░ ░░░░░ ░░░░   ░░░"
    echo "▒   ▒ ▒   ▒   ▒   ▒  ▒ ▒  ▒     ▒   ▒ ▒"
    echo "▓▓▓▓▓ ▓▓▓▓    ▓   ▓   ▓   ▓▓▓▓  ▓▓▓▓   ▓▓▓"
    echo "█   █ █   █   █   █  █ █  █     █   █     █"
    echo "█   █ █   █   █   █ █   █ █████ █   █ ████" && echo ""
    tput sgr0
    amarillo;echo "Panel ASCII de administración de usuarios"
    echo "pensado para sistemas basados en Arch, 100% compatible"
    echo "con otras distribuciones Linux y con BSD."
    echo "";negro;tput setab 4
    echo " ╔════════════════╗ "
    echo " ║ Menú principal ║ "
    echo " ╚════════════════╝ ";tput sgr0;echo ""
    blanco;echo -n "01. ";azul;tput bold;parpadear;echo -n "L";tput sgr0;echo "istar nombres de usuarios creados con ID mayor o igual a 1000."
    blanco;echo -n "02. ";echo -n "Listar ";azul;tput bold;parpadear;echo -n "t";tput sgr0; echo "odos los nombres de usuarios existentes en el sistema."
    blanco;echo -n "03. ";azul;tput bold;parpadear;echo -n "C";tput sgr0;echo "rear usuarios."
    blanco;echo -n "04. ";azul;tput bold;parpadear;echo -n "E";tput sgr0; echo "liminar usuarios."
    blanco;echo -n "05. L";azul;tput bold;parpadear;echo -n "i";tput sgr0;echo "star grupos."
    blanco;echo -n "06. ";azul;tput bold;parpadear;echo -n "A";tput sgr0;echo "ñadir grupos."
    blanco;echo -n "07. ";azul;tput bold;parpadear;echo -n "B";tput sgr0;echo "orrar grupos."
    blanco;echo -n "08. Ver qué usuarios e";azul;tput bold;parpadear;echo -n "x";tput sgr0;echo "isten dentro de un grupo."
    blanco;echo -n "09. ";azul;tput bold;parpadear;echo -n "V";tput sgr0;echo "er los grupos a los cuales pertenece un usuario."
    blanco;echo -n "10. Añadi";azul;tput bold;parpadear;echo -n "r";tput sgr0;echo " a un usuario a un grupo."
    blanco;echo -n "11. ";azul;tput bold;parpadear;echo -n "Q";tput sgr0;echo "uitar a un usuario de un grupo."
    blanco;echo -n "12. A";azul;tput bold;parpadear;echo -n "y";tput sgr0;echo "uda e información sobre artixers."
    blanco;echo -n "13. Cré";azul;tput bold;parpadear;echo -n "d";tput sgr0;echo "itos y licencia."
    blanco;echo -n "14. ";azul;tput bold;parpadear;echo -n "S";tput sgr0;echo "alir." && echo ""
    gris;echo "También puede pulsar '0' para apagar el parpadeo, y '1' para volver a encenderlo.";blanco
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
    elif [[ $op == "y" ]];then ayuda_e_info;
    elif [[ $op == "d" ]];then creditos;
    elif [[ $op == "s" ]];then salir;
    elif [[ $op == "0" ]];then parpadeo="falso";menu;
    elif [[ $op == "1" ]];then parpadeo="verdadero";menu;
    else menu;fi
}

function listar_creados {
    clear;echo "" && echo "Usuarios creados con PID mayor o igual a 1000:" && echo ""
    azul;cat /etc/passwd | awk -F':' '(( $3 >= 1000 && $3 < 65534 )) {print $1}' | sort
    pulsa_tecla;menu
}

function listar_todos {
    cant_usuarios=`wc -l </etc/passwd`
    blanco;clear;echo "" && echo "Lista de todos los usuarios existentes en el sistema." && echo ""
    amarillo;echo "Se han encontrado "$cant_usuarios" usuarios.";blanco;echo ""
    gris;echo "> Cuando vea el listado, con las flechas arriba/abajo, podrá recorrer la lista y también pulsar Q para finalizar."
    echo "  Al llegar al final de la misma, el programa volverá al menú principal."
     
    pulsa_tecla;echo ""
    azul;cat /etc/passwd | awk -F':' '{print $1}' | sort | less -FE
    parpadear;pulsa_tecla;tput sgr0;menu
}

function crear_usuario {
    clear;blanco;echo "" && echo "CREACIÓN DE USUARIOS." && echo "";gris
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
    if [[ $nom_real == "@menu" ]];then menu;fi
    
    if [[ ${#nom_real} -gt 256 ]];then
        echo "" && echo ${#nom_real} "caracteres para el nombre real son demasiados. Reintente."
        pulsa_tecla;crear_usuario
    fi

    tput cnorm;read -p "¿Crear directorio personal dentro de home?  : " var;tput civis
    
    var=`echo "$var" | tr '[:upper:]' '[:lower:]'`
    if [[ $var == "@menu" ]];then menu;fi
    
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
    
    if [[ $nom_logico == "@menu" ]];then menu;fi
    
    if id "$nom_logico" >/dev/null 2>&1;then
        echo -n "* Cualquier cosa que responda a la pregunta sobre eliminar el directorio personal al usuario, será tomada como un ";amarillo;echo -n  "'no'";blanco;echo -n ", salvo que escriba ";amarillo;echo -n "'si'";blanco;echo "." && echo ""
        
        tput cnorm;read -p "ATENCIÓN: ¿eliminar el directorio personal dentro de home?: " var1;tput civis
        
        if [[ $var1 == "@menu" ]];then menu;fi
        
        parpadear
        read -p "DE NUEVO: ¿SEGURO QUE DESEA ELIMINAR TODA LA INFORMACIÓN PERSONAL DEL USUARIO?: " var2
        tput sgr0;tput civis;blanco
        
        if [[ $var2 == "@menu" ]];then menu;fi
        
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
    azul;cat /etc/group | awk -F':' '{print $1}' | sort | less -FE
    parpadear;pulsa_tecla;tput sgr0;menu
    
#     clear;echo "" && echo "Lista de todos los grupos existentes en el sistema:" && echo ""
#     azul;cat /etc/group | awk -F':' '{print $1}' | sort | more
#     pulsa_tecla;menu
}

function aniadir_grupos {
    clear;blanco;echo "" && echo "CREACIÓN DE GRUPOS." && echo "";gris
    echo "  Instrucciones generales:" && echo ""
    echo "> El nombre del grupo a añadir, no deberá poseer números, ni una longitud mayor que 32 caracteres."
    echo "> Tampoco podrá contener mayúsculas, espacios, tildes ni símbolos."
    
    mensaje_regresar_menu
    
    echo "";blanco
    
    tput cnorm;read -p "Ingrese el nombre lógico del grupo a crear: " nom_grupo;tput civis
    nom_grupo=`echo "$nom_grupo" | tr '[:upper:]' '[:lower:]'`
    
    if [[ $nom_grupo == "@menu" ]];then menu;fi
    
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
    echo -n "Para continuar añadiendo grupos, pulse ";parpadear;azul;echo -n "A";tput sgr0;blanco;echo "."
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
    
    if [[ $grupo_a_borrar == "@menu" ]];then menu;fi
    
    if [[ $(getent group $grupo_a_borrar) ]];then
    
        confirmacion_codigo
        sudo groupdel $grupo_a_borrar
        
        echo "" && echo "Si se le ha solicitado una contraseña y la ha introducido correctamente, el grupo ha sido borrado."
        echo -n "Para continuar añadiendo grupos, pulse ";parpadear;azul;echo -n "B";tput sgr0;blanco;echo "."
        echo "Cualquier otra tecla, vuelve al menú principal."

        read -sn1 var
        
        if [[ $var == "B" ]] || [[ $var == "b" ]];then
            borrar_grupos
        else
            menu
        fi
    else
        amarillo
        grupo_no_encontrado
        
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
    usu=`echo "$usu" | tr '[:upper:]' '[:lower:]'`

    if [[ $gru == "@menu" ]];then menu;fi
    
    if [[ $(getent group $gru) ]];then
        echo "" && echo "Usuarios contenidos dentro del grupo $gru:" && echo ""
        azul;getent group $gru | cut -d ":" -f1;blanco
        pulsa_tecla;menu
    else
        amarillo
        grupo_no_encontrado
        
        read -sn1 var
        
        if [[ $var == "M" ]] || [[ $var == "m" ]];then
            menu
        else
            usuarios_dentro_grupo
        fi
    fi
}

function ver_grupos_usuario {
    clear;echo "" && echo "VERIFICACIÓN DE GRUPOS." && echo ""
    
    mensaje_regresar_menu
    
    tput cnorm;read -p "Ingrese el nombre lógico del usuario objetivo: " usu;tput civis
    usu=`echo "$usu" | tr '[:upper:]' '[:lower:]'`
    
    if [[ $usu == "@menu" ]];then menu;fi
    
    if [[ $(getent group $usu) ]];then
        clear;blanco;echo "" && echo "Grupo PRINCIPAL del usuario $usu:" && echo ""
        azul;id -gn $usu
        blanco;echo "" && echo "Grupos SECUNDARIOS del usuario $usu:" && echo ""
        azul;id -Gn $usu | cut -d' ' -f2-
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
    clear;blanco;echo "" && echo "AÑADIR A USUARIOS A GRUPOS." && echo ""
    
    mensaje_regresar_menu
    
    tput cnorm;read -p "Ingrese el nombre lógico del usuario objetivo: " usu;tput civis
    usu=`echo "$usu" | tr '[:upper:]' '[:lower:]'`
    
    if [[ $usu == "@menu" ]];then menu;fi
    
    if id "$usu" >/dev/null 2>&1;then
        tput cnorm;read -p "Ingrese el grupo a añadir al usuario $usu: " grupo;tput civis
        
        if [[ $usu == "@menu" ]];then menu;fi
        
        if [[ $(getent group $grupo) ]];then
            blanco;echo "" && echo "Pulse:" && echo ""
            azul;parpadear;echo -n "1";tput sgr0;blanco;echo " para añadirle al usuario $usu el grupo $grupo como PRIMARIO."
            azul;parpadear;echo -n "2";tput sgr0;blanco;echo " para añadirle al usuario $usu el grupo $grupo como SECUNDARIO.";tput civis
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
    echo -n "Para continuar añadiendo grupos, pulse ";parpadear;azul;echo -n "R";tput sgr0;blanco;echo "."
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
    
    if [[ $usu == "@menu" ]];then menu;fi
    
    if id "$usu" >/dev/null 2>&1;then
        tput cnorm;read -p "Ingrese el grupo a quitarle al usuario $usu: " grupo;tput civis
        
        if [[ $(getent group $grupo) ]];then
            grupos_usuario=`id $usu`
            
            if [[ $grupos_usuario == *"$grupo"* ]];then
                confirmacion_codigo
                sudo gpasswd --delete $usu $grupo
                
                echo "" && echo "Si se le ha solicitado una contraseña y la ha introducido correctamente,"
                echo "el grupo $grupo ha sido quitado del usuario $usu"
                echo -n "Para continuar añadiendo grupos, pulse ";parpadear;azul;echo -n "Q";tput sgr0;blanco;echo "."
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

menu
