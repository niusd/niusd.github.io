#!/bin/bash
# �����е� #! ��һ��Լ�����, �����Ը���ϵͳ����ű���Ҫʲô���Ľ�������ִ��;

echo "�����е��Ƶ����� GitAutoPush Starting..."
time=$(date "+%Y-%m-%d %H:%M:%S")
git add .

read -t 30 -p "�������ύע��:" msg

if  [ ! "$msg" ] ;then
    echo "[commit message] Ĭ���ύ, �ύ��: $(whoami), �ύʱ��: ${time}"
	git commit -m "Ĭ���ύ, �ύ��: $(whoami), �ύʱ��: ${time}"
else
    echo "[commit message] $msg, �ύ��: $(whoami), �ύʱ��: ${time}"
	git commit -m "$msg, �ύ��: $(whoami), �ύʱ��: ${time}"
fi

	
git push origin master
echo "�����е��Ƶ����� GitAutoPush Ending..."
