#!/usr/bin/env bash

id_models=(
    "v2a_1=Majicmix,Meinamix,XXMix9realistic,RevAnimated,ChilloutMix,Counterfeit"
    "v2a_2=Majicmix,SDVN1Real,ToonYou,CyberRealistic,RealisticVision,GhostMix,KenCanMix"
    "v2a_3=Majicmix,Meinamix,XXMix9realistic,RevAnimated,ChilloutMix,Counterfeit,MechaMix,DreamShaper,ChildrenStories,XSarchitectural"
    "v2a_4=Majicmix,SDVN1Real,ToonYou,CyberRealistic,RealisticVision,GhostMix,KenCanMix,dvArch,NightSkyYOZORAStyle,AZovyaRPGArtistTools"
)

# Default values
id=$1
url=$2
group=""
type="webui"

if [ -z "$id" ]; then
    echo "$1 id: is require"
    exit 1
fi

containsSubstring() {
    main_string="$1"
    substring="$2"
    if [[ $main_string == *"$substring"* ]]; then
        return 0
    else
        return 1
    fi
}

downloadModel() {
    _file="$1"
    _link="$2"
    if [ -z "$_link" ]; then
        _link="https://huggingface.co/annh/general/resolve/main/$_file"
    fi
    echo "Download $_link"
    aria2c --console-log-level=error -c -x 16 -s 16 -k 1M "$_link" -d /workspace/stable-diffusion-webui/models/Stable-diffusion -o "$_file"
}

for entry in "${id_models[@]}"; do
    if containsSubstring "$entry" "$id="; then
        # Extract the associated string
        group="${entry#*=}"
        echo "Setup model $group"
        if containsSubstring "$group" "Majicmix"; then
            file=majicmixRealistic_v5.safetensors
            link=https://huggingface.co/sinkinai/majicMIX-realistic-v5/resolve/main/majicmixRealistic_v5.safetensors
            downloadModel  $file $link
        fi
        if containsSubstring "$group" "RevAnimated"; then
            file=revAnimated_v11.safetensors
            link=https://huggingface.co/ckpt/rev-animated/resolve/main/revAnimated_v11.safetensors
            downloadModel  $file $link
        fi
        if containsSubstring "$group" "Meinamix"; then
            file=meinamix_meinaV10.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "RealisticVision"; then
            file=realisticVisionV30_v30VAE.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "CosplayMix"; then
            file=cosplaymix_v41.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "GhostMix"; then
            file=ghostmix_v20Bakedvae.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "ChilloutMix"; then
            file=chilloutmix_NiPrunedFp32.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "XXMix9realistic"; then
            file=xxmix9realistic_v40.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "CyberRealistic"; then
            file=cyberrealistic_v32.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "dvArch"; then
            file=dvarchMultiPrompt_dvarchExterior.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "XSarchitectural"; then
            file=xsarchitectural_v11.ckpt
            downloadModel  $file
        fi
        if containsSubstring "$group" "ToonYou"; then
            file=toonyou_beta6.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "ChildrenStories"; then
            file=childrensStories_v1CustomA.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "MechaMix"; then
            file=mechamix_v10.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "AZovyaRPGArtistTools"; then
            file=aZovyaRPGArtistTools_v3.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "NightSkyYOZORAStyle"; then
            file=nightSkyYOZORAStyle_yozoraV1PurnedFp16.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "DreamShaper"; then
            file=dreamshaper_8.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "AnyLoRA"; then
            file=anyloraCheckpoint_bakedvaeBlessedFp16.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "AbsoluteReality"; then
            file=absolutereality_v181.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "AnyLoRAAnimeMix"; then
            file=aamAnyloraAnimeMixAnime_v1.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "NeverEndingDream"; then
            file=neverendingDreamNED_v122BakedVae.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "KenCanMix"; then
            file=kencanmix_v20Beta.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "Counterfeit"; then
            file=CounterfeitV30_v30.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "ColoringBook"; then
            file=coloringBook_coloringBook.ckpt
            downloadModel  $file
        fi
        if containsSubstring "$group" "BeautifulRealisticAsians"; then
            file=beautifulRealistic_v40.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "Photon"; then
            file=photon_v1.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "HRA_hyperrealism"; then
            file=hraHyperrealismArt_v155.safetensors
            downloadModel  $file
        fi
        if containsSubstring "$group" "SDVN1Real"; then
            file=sdvn1Real_origin.safetensors
            downloadModel  $file
        fi
    fi
done

# Update webui-user.sh
file_path="./webui-user.sh"
sed -i "s|^GROUP=.*|GROUP=$group|" "$file_path"
sed -i "s|^TYPE=.*|TYPE=$type|" "$file_path"
if [ -n "$id" ]; then
    sed -i "s|^ID=.*|ID=$id|" "$file_path"
fi
if [ -n "$url" ]; then
    sed -i "s|^URL=.*|URL=$url|" "$file_path"
fi
