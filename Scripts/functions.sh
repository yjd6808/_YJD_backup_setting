#!/bin/bash

SCRIPT_DIR=$(dirname $0)

# 오류 메시지 출력
stderr_message() {
	echo $1 >&2
}

# https://stackoverflow.com/questions/592620/how-can-i-check-if-a-program-exists-from-a-bash-script
# command 있는지 확인하는 코드
command_exist() {

	if [[ $# -eq 0 ]]; then
		return 1
	fi

	if ! command -v $1  &> /dev/null; then
		return 2
	fi		
	return 0
}

# 오-마이-포쉬 테마 변경 기능
theme_change() {
	
	# $() 또는 ``로 실행한 실행결과를 소괄호로 묶어 줘야 리스트로 얻을 수 있음
	# <문자열>$는 정규표현식으로 regex 파일 목록 중 .omp.json으로 끝나는 파일들만 리스트에 담도록한다.
	local theme_list=($(ls ~/.poshthemes/ | grep ".omp.json$"))
	local theme_list_len=${#theme_list[@]}
	
	if [[ ${theme_list_len} -le 0 ]]; then
		stderr_message '선택가능한 테마가 없습니다.'
		return 1
	fi

	
	for i in ${!theme_list[@]}; do
		local theme_filename=${theme_list[${i}]}

		# ${변수%문자열} 변수의 뒷부분 부터 일치하는 문자열을 삭제해줌
		printf "\t%3d) %s\n" ${i} ${theme_filename%.omp.json}
	done
	
	read -p "바꿀 테마의 번호를 선택해주세요." choose 
	if [[ $choose -lt 0 || $choose -ge ${theme_list_len} ]]; then		
		stderr_message '입력한 번호의 테마가 없습니다.' 
		return 1
	fi

	# .bashrc 파일에서 export POSH_THEME= 찾아서 줄번호 반환
	# \s*  : 공백문자 0개 이상
	# \s\+ : 공백문자 1개 이상
	# number=$(cat .bashrc | grep -n "\s*export\s\+POSH_THEME=" | cut -d ':' -f 1)
	selected_theme_config_file=`basename ${theme_list[${choose}]}`
	echo 선택된 테마 : $selected_theme_config_file
	original_export_str=$(cat ~/.bashrc | grep "\s*export\s\+POSH_THEME=")
	if [[ $? -gt 0 ]]; then
		echo "export POSH_THEME=\"~/.poshthemes/{selected_theme_config_file}\"" >> ~/.bashrc
		if [[ $? -gt 0 ]]; then
			stderr_message '.basrc에 export 메시지 추가에 실패하였습니다.'
			return 1
		fi
	else
        slash="/"
        replace_str="export POSH_THEME=~${slash}.poshthemes${slash}${selected_theme_config_file}"

        echo original_export_str : ${original_export_str}
        echo replace_str : ${replace_str}

		sed "s,${original_export_str},${replace_str}," -i  ~/.bashrc
		if [[ $? -gt 0 ]]; then
			stderr_message '.basrc에 export 메시지 수정에 실패하였습니다.'
			return 1
		fi
	fi
	bash
	return 0
}




# 밝기 변경 기능
change_brightness() {

    # -v 변수가 set 되어있는지 확인해줌
    if test -v $1; then
        echo "밝기 수치를 전달해주세요.(0.0 ~ 1.0)"
        return 1
    fi

    xrandr | grep " connected" | cut -f1 -d " " | xargs -I {} xrandr --output {} --brightness $1 
    return $?
} 



# 해쉬값과 함께 파일 목록 출력
# 참고 : https://stackoverflow.com/questions/14634349/calling-an-executable-program-using-awk
# 명령 실행결과가 geline 으로 파이프되고 geline의 싫행 결과가 양수면 출력된 값이 있다는 뜻이다.
# 실행 결과가 0이면 출력된게 없다는 뜻
# 실행 결과가 -1이면 실패했다는 뜻
# awk에서 출력결과를 좌측 또는 우측 정렬 할 수 있음 
# %-10s : |aaaaa     |
# %10s  : |     aaaaa|

alias "lsh=sudo ls -Al | awk    '{cmd = \"sha1sum \"\$NF
                                    while ( ( cmd | getline result ) > 0 ) {
                                        printf \"%-80s | %s\n\", \$0, substr(result, 0, 8)
                                    }
                                    close(cmd)
                                }' 2> /dev/null"


# 스크립트들 깃허브에 백업
backup() {
   
    if ! command_exist rm_; then
        return 1
    fi;

    local prev_path=$(pwd)
    local remover=/usr/bin/rm

    cd ~
    sudo mkdir -p .backup/temp/; if [ $? -ne 0 ]; then echo mkdir -p .backup/temp/ : failed; return 1; fi 

    for f in .backup/*; do
        if [ ! -d $f ]; then
            sudo mv $f .backup/temp/
            if [ $? -ne 0 ]; then echo sudo mv $f .backup/temp/ : failed; return 1; fi
        fi
    done

    sudo $remover -rf .backup/temp/; if [ $? -ne 0 ]; then echo rm_ -f .backup/ : failed; return 1; fi
    sudo cp -r Scripts/ .backup/; if [ $? -ne 0 ]; then echo cp -r Scripts/ .backup/ : failed; return 1; fi
    sudo cp .bashrc .backup/; if [ $? -ne 0 ]; then echo cp .bashrc .backup/ : failed; return 1; fi
    sudo cp .vimrc .backup/; if [ $? -ne 0 ]; then echo cp .vimrc .backup/ : failed; return 1; fi

    cd .backup

    git add .; if [ $? -ne 0 ]; then echo git add . : failed; return 1; fi
    git commit -m "auto commit"; 

    if [ $? -eq 0 ]; then
        git push; if [ $? -ne 0 ]; then echo git commit : failed; return 1; fi
    else 
        echo git commit : failed; 
        cd $prev
        return 1
    fi

    cd $prev
    echo "백업 완료"

    return 0
}
