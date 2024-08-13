#!/bin/bash
echo "Отчёт сохранён в файл report.txt"
#Подсчёт количества строк(запросов)
line_count=$(wc -l < access.log)
#Подсчёт количества уникальных IP
count=$(awk '{count[$1]++} END {print length(count)}' access.log)
#Подсчёт количества запросов по методам
count_method=$(awk 'gsub(/\"/, "", $6) {count[$6]++} END {for (word in count) print count[word], word}' access.log)
count_url=$(awk '{count[$7]++} END {for (word in count) print count[word], word}' access.log)
mp_url=$( echo $count_url | awk '
{
    max = 0
    max_elem = ""
    for (i = 1; i <= NF; i++){
        if ($i > max) {
            max = $i
            max_elem = $(i + 1)
        }
    }
    print max, max_elem
}
')

echo "Отчёт о логе веб-сервера" >> report.txt
echo "========================" >> report.txt
echo "Общее количество запросов:" $line_count >> report.txt
echo "Количество уникальных IP-адресов:" $count >> report.txt
echo "Количество запросов по методам:" >> report.txt
echo $count_method | awk 'NR==1 {print $1, $2}' >> report.txt
echo $count_method | awk 'NR==1 {print $3, $4}' >> report.txt
echo "Самый популярный URL:" $mp_url >> report.txt

