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
    group="$1"
    if [[ $group == *"Majicmix"* || $group == "all" ]]; then
        file=majicmixRealistic_v5.safetensors
        link=https://huggingface.co/sinkinai/majicMIX-realistic-v5/resolve/main/majicmixRealistic_v5.safetensors
        downloadModel  $file $link
    fi
    if [[ $group == *"RevAnimated"* || $group == "all" ]]; then
        file=revAnimated_v121.safetensors
        link=https://huggingface.co/ckpt/rev-animated/resolve/main/revAnimated_v121.safetensors
        downloadModel  $file $link
    fi
    if [[ $group == *"Meinamix"* || $group == "all" ]]; then
        file=meinamix_meinaV10.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"RealisticVision"* || $group == "all" ]]; then
        file=realisticVisionV30_v30VAE.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"CosplayMix"* || $group == "all" ]]; then
        file=cosplaymix_v41.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"GhostMix"* || $group == "all" ]]; then
        file=ghostmix_v20Bakedvae.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"ChilloutMix"* || $group == "all" ]]; then
        file=chilloutmix_NiPrunedFp32.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"XXMix9realistic"* || $group == "all" ]]; then
        file=xxmix9realistic_v40.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"CyberRealistic"* || $group == "all" ]]; then
        file=cyberrealistic_v32.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"dvArch"* || $group == "all" ]]; then
        file=dvarchMultiPrompt_dvarchExterior.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"XSarchitectural"* || $group == "all" ]]; then
        file=xsarchitectural_v11.ckpt
        downloadModel  $file
    fi
    if [[ $group == *"ToonYou"* || $group == "all" ]]; then
        file=toonyou_beta6.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"ChildrenStories"* || $group == "all" ]]; then
        file=childrensStories_v1CustomA.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"MechaMix"* || $group == "all" ]]; then
        file=mechamix_v10.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"AZovyaRPGArtistTools"* || $group == "all" ]]; then
        file=aZovyaRPGArtistTools_v3.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"NightSkyYOZORAStyle"* || $group == "all" ]]; then
        file=nightSkyYOZORAStyle_yozoraV1PurnedFp16.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"DreamShaper"* || $group == "all" ]]; then
        file=dreamshaper_8.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"AnyLoRA"* || $group == "all" ]]; then
        file=anyloraCheckpoint_bakedvaeBlessedFp16.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"AbsoluteReality"* || $group == "all" ]]; then
        file=absolutereality_v181.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"AnyLoRAAnimeMix"* || $group == "all" ]]; then
        file=aamAnyloraAnimeMixAnime_v1.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"NeverEndingDream"* || $group == "all" ]]; then
        file=neverendingDreamNED_v122BakedVae.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"KenCanMix"* || $group == "all" ]]; then
        file=kencanmix_v20Beta.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"Counterfeit"* || $group == "all" ]]; then
        file=CounterfeitV30_v30.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"ColoringBook"* || $group == "all" ]]; then
        file=coloringBook_coloringBook.ckpt
        downloadModel  $file
    fi
    if [[ $group == *"BeautifulRealisticAsians"* || $group == "all" ]]; then
        file=beautifulRealistic_v40.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"Photon"* || $group == "all" ]]; then
        file=photon_v1.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"HRA_hyperrealism"* || $group == "all" ]]; then
        file=hraHyperrealismArt_v155.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"SDVN1Real"* || $group == "all" ]]; then
        file=sdvn1Real_origin.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"AnimeCivitaiv1"* || $group == "all" ]]; then
        file=KizukiAnimeCivitaiv1.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"AnimeCivitaiv2"* || $group == "all" ]]; then
        file=KizukiAnimeCivitaiv2.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"AnimeCivitaiv3"* || $group == "all" ]]; then
        file=KizukiAnimeCivitaiv3.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"flat2DAnimerge"* || $group == "all" ]]; then
        file=flat2DAnimerge_v30.safetensors
        downloadModel  $file
    fi
    if [[ $group == *"CyberrealisticInpaint"* || $group == "all" ]]; then
        file=cyberrealistic_v40-inpainting.safetensors
        downloadModel  $file
    fi
}

downloadModels $1
