!/bin/bash
while true; do

     echo "      FILE MANAGER"
    echo "1 - Renomear arquivo"
    echo "2 - Converter para .txt"
    echo "3 - Compactar (.zip)"
    echo "4 - Descompactar (.zip)"
    echo "5 - Alterar permissões"
    echo "0 - Sair"
     
read -p "Escolha uma opção: " opcao

    case $opcao in

        Renomear arquivo
        1)
            read -p "Qual arquivo você quer renomear? " origem
            read -p "Novo nome: " destino
            mv "$origem" "$destino"
            echo "✔ Pronto! Arquivo renomeado."
            ;;

        Converter para txt (na prática, só cria uma cópia .txt)
        2)
            read -p "Qual arquivo? " arquivo
            cp "$arquivo" "${arquivo%.*}.txt"
            echo "✔ Criado arquivo .txt"
            ;;

        Compactar arquivo
        3)
            read -p "Qual arquivo deseja compactar? " arquivo
            zip "${arquivo}.zip" "$arquivo"
            echo "✔ Arquivo compactado com sucesso."
            ;;

        Descompactar
        4)
            read -p "Qual arquivo .zip? " zipfile
            unzip "$zipfile"
            echo "✔ Arquivo descompactado."
            ;;

        Permissões
        5)
            read -p "Arquivo: " arquivo
            read -p "Permissão (ex: 755): " perm
            chmod "$perm" "$arquivo"
            echo "✔ Permissões alteradas."
            ;;

         Sair   
        0)
            echo "Saindo... até mais "
            break
            ;;
        Qualquer coisa inválida
        
            echo "Opção inválida, tenta de novo."
            ;;
    esac
done
