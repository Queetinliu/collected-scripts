#!/bin/bash
if [[ -f ~/.complete_alias ]];then 
rm -f ~/.complete_alias
fi
cp complete_alias.original .complete_alias 
input="/root/.kubectl_aliases"
while IFS= read -r line 
do
if [[ ! -z $line ]];then
alias=$(echo "sline" | awk '(print $2)'| awk -F'=' '{print $1}') 
echo "complete -F _complete_alias $alias" >> ~/.complete_alias 
fi
done < "$input"