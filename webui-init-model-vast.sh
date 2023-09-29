#!/usr/bin/env bash

apt update
apt install -y aria2

id_models=(
    "1=Majicmix,Meinamix,XXMix9realistic,RevAnimated,ChilloutMix,Counterfeit"
    "2=Majicmix,SDVN1Real,ToonYou,CyberRealistic,RealisticVision,GhostMix,KenCanMix"
    "3=Majicmix,Meinamix,XXMix9realistic,RevAnimated,ChilloutMix,Counterfeit,MechaMix,DreamShaper,ChildrenStories,XSarchitectural"
    "4=Majicmix,SDVN1Real,ToonYou,CyberRealistic,RealisticVision,GhostMix,KenCanMix,dvArch,NightSkyYOZORAStyle,AZovyaRPGArtistTools"
)

if [ $# -ne 3 ]; then
    echo "Usage: $0 <id> $1 <name> $2 <url>"
    exit 1
fi

id=$1
name=$2
url=$3

containsSubstring() {
    string="$1"
    substring="$2"
    if [[ $string == *"$substring"* ]]; then
        return 0
    else
        return 1
    fi
}

downloadModel() {
    file="$1"
    link="$2"
    if [ -z "$link" ]; then
        link="https://huggingface.co/annh/general/resolve/main/$file"
    fi
    echo "Download $link"
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M "$link" -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o "$file"
}

updateWebuiUserSh() {
    file_path="./webui-user.sh"
    sed -i "s|^ID=.*|ID=$1|" "$file_path"
    sed -i "s|^GROUP=.*|GROUP=$2|" "$file_path"
    sed -i "s|^URL=.*|URL=$3|" "$file_path"
}


for entry in "${id_models[@]}"; do
    if containsSubstring "$entry" "$id="; then
        # Extract the associated string
        string="${entry#*=}"
        echo "Setup model $string"
        updateWebuiUserSh $name $string $url
        if containsSubstring "$string" "Majicmix"; then
            file=majicmixRealistic_v5.safetensors
            link=https://huggingface.co/sinkinai/majicMIX-realistic-v5/resolve/main/majicmixRealistic_v5.safetensors
            downloadModel  $file $link
        fi
        if containsSubstring "$string" "RevAnimated"; then
            file=revAnimated_v11.safetensors
            link=https://huggingface.co/ckpt/rev-animated/resolve/main/revAnimated_v11.safetensors
            downloadModel  $file $link
        fi
        if containsSubstring "$string" "Meinamix"; then
            file=meinamix_meinaV10.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "RealisticVision"; then
            file=realisticVisionV30_v30VAE.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "CosplayMix"; then
            file=cosplaymix_v41.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "GhostMix"; then
            file=ghostmix_v20Bakedvae.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "ChilloutMix"; then
            file=chilloutmix_NiPrunedFp32.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "XXMix9realistic"; then
            file=xxmix9realistic_v40.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "CyberRealistic"; then
            file=cyberrealistic_v32.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "dvArch"; then
            file=dvarchMultiPrompt_dvarchExterior.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "XSarchitectural"; then
            file=xsarchitectural_v11.ckpt
            downloadModel  $file
        fi
        if containsSubstring "$string" "ToonYou"; then
            file=toonyou_beta6.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "ChildrenStories"; then
            file=childrensStories_v1CustomA.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "MechaMix"; then
            file=mechamix_v10.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "AZovyaRPGArtistTools"; then
            file=aZovyaRPGArtistTools_v3.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "NightSkyYOZORAStyle"; then
            file=nightSkyYOZORAStyle_yozoraV1PurnedFp16.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "DreamShaper"; then
            file=dreamshaper_8.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "AnyLoRA"; then
            file=anyloraCheckpoint_bakedvaeBlessedFp16.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "AbsoluteReality"; then
            file=absolutereality_v181.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "AnyLoRAAnimeMix"; then
            file=aamAnyloraAnimeMixAnime_v1.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "NeverEndingDream"; then
            file=neverendingDreamNED_v122BakedVae.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "KenCanMix"; then
            file=kencanmix_v20Beta.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "Counterfeit"; then
            file=CounterfeitV30_v30.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "ColoringBook"; then
            file=coloringBook_coloringBook.ckpt
            downloadModel  $file
        fi
        if containsSubstring "$string" "BeautifulRealisticAsians"; then
            file=beautifulRealistic_v40.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "Photon"; then
            file=photon_v1.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "HRA_hyperrealism"; then
            file=hraHyperrealismArt_v155.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$string" "SDVN1Real"; then
            file=sdvn1Real_origin.safetensors
            downloadModel  $file
        fi
    fi
done


