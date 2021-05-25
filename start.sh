#!/bin/bash

# Default
PROJECT="tmp"
RM="Y"
IMAGE="spiritwithourwalls/pwn-box:baseimage-amd64"

echo "
      :::::::::  :::       ::: ::::    :::               :::::::::   ::::::::  :::    ::: 
     :+:    :+: :+:       :+: :+:+:   :+:               :+:    :+: :+:    :+: :+:    :+:  
    +:+    +:+ +:+       +:+ :+:+:+  +:+               +:+    +:+ +:+    +:+  +:+  +:+    
   +#++:++#+  +#+  +:+  +#+ +#+ +:+ +#+ +#++:++#++:++ +#++:++#+  +#+    +:+   +#++:+      
  +#+        +#+ +#+#+ +#+ +#+  +#+#+#               +#+    +#+ +#+    +#+  +#+  +#+      
 #+#         #+#+# #+#+#  #+#   #+#+#               #+#    #+# #+#    #+# #+#    #+#      
###          ###   ###   ###    ####               #########   ########  ###    ###       

========================================================================================
"


read -p "Enter project name (default \"tmp\"): " INPUT
if [ ! -z "$INPUT" ]; then
    PROJECT=$INPUT
    unset INPUT
fi

read -r -p "Remove container when used ? [Y/n] " INPUT
if [ ! -z "$INPUT" ]; then
    if [[ "$INPUT" =~ ^([nN][oO]|[nN])+$ ]]; then
        RM="N"
        unset INPUT
    fi
fi

printf "\n"

# --network=host --privileged
if [ "$RM" == "N" ]; then
    docker run -h ${PROJECT} --name ${PROJECT} -v $(pwd)/${PROJECT}:/workdir --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -d -i ${IMAGE}
    docker exec -it ${PROJECT} /bin/bash
else
    docker run -it --rm -h ${PROJECT} --name ${PROJECT} -v $(pwd)/${PROJECT}:/workdir --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -d -i ${IMAGE}
    docker exec -it ${PROJECT} /bin/bash
fi
