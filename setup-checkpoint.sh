#!/usr/bin/env bash

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

downloadModels() {
    group=$1
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
    if containsSubstring "$group" "AnimeCivitaiv1"; then
        file=KizukiAnimeCivitaiv1.safetensors
        downloadModel  $file
    fi
    if containsSubstring "$group" "AnimeCivitaiv2"; then
        file=KizukiAnimeCivitaiv2.safetensors
        downloadModel  $file
    fi
    if containsSubstring "$group" "AnimeCivitaiv3"; then
        file=KizukiAnimeCivitaiv3.safetensors
        downloadModel  $file
    fi
    if containsSubstring "$group" "flat2DAnimerge"; then
        file=flat2DAnimerge_v30.safetensors
        downloadModel  $file
    fi
    if containsSubstring "$group" "CyberrealisticInpaint"; then
        file=cyberrealistic_v40-inpainting.safetensors
        downloadModel  $file
    fi
}

downloadModels $1
