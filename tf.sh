#!/bin/bash

# 使い方
# (お使いのbash) switch_environment.sh ENVIRONMENT_NAME COMMAND
# https://aws-blog.de/2019/05/managing-multiple-stages-with-terraform.html

STAGE=$1

if [[ ! -d "environments/${STAGE}" ]]; then
    echo "ステージ：${STAGE}はenvironments/の中にありません。"
    echo "以下が利用可能："
    ls environments/
    return 1
fi

exec_with_tfvars() {
    # Only some of the subcommands can work with the -var-file argument
    if [[ -f "environments/${STAGE}/variables.tfvars" ]]; then
        echo "環境変数を適用したうえでterraformコマンドを実行します。"
        echo "実行中: terraform -chdir=environments/${STAGE} $1 -var-file=variables.tfvars ${@:2}"
        terraform -chdir=environments/${STAGE} $1 -var-file=variables.tfvars ${@:2}
    else
        echo "environments/${STAGE}/variables.tfvars が存在しません。"
        return 3
    fi
}

exec_with_backend_config() {
    # Only some sub commands require the backend configuration
    if [[ -f "environments/${STAGE}/backend.config" ]]; then
        echo "実行中: terraform -chdir=environments/${STAGE} $1 -backend-config=backend.config ${@:2}"
        terraform -chdir=environments/${STAGE} $1 -backend-config=backend.config ${@:2}
    else
        echo "environments/${STAGE}/backend.config が存在しません。"
        return 2
    fi
}

switch_command() {
    # List of commands that can accept the -var-file argument
    sub_commands_with_vars=(apply destroy plan import)

    # List of commands that accept the backend argument
    sub_commands_with_backend=(init)

    # ${@:2} means that we append all of the arguments after tf init

    if [[ " ${sub_commands_with_vars[@]} " =~ " $1 " ]]; then
        # exec_with_backend_config init
        exec_with_tfvars $@
    elif [[ " ${sub_commands_with_backend[@]} " =~ " $1 " ]]; then
        exec_with_backend_config $@
    else
        echo "実行中: terraform -chdir=environments/${STAGE} $@"
        terraform -chdir=environments/${STAGE} $@
    fi
}

switch_command ${@:2}