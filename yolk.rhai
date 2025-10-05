export let data = #{
};
export let eggs = #{
    eww: #{ targets: "~/.config/eww" },
    kitty: #{ targets: "~/.config/kitty" },
    vim: #{ targets: "~/.config/vim" },
    bash: #{ targets: "~", strategy: "merge" },
    zen: #{ targets: "~/.var/app/app.zen_browser.zen/.zen/fimwnwwm.Default (release)/chrome", strategy: "merge" },
    sway: #{ targets: "~/.config/sway", templates: ["config"] },
    homemanager: #{ targets: "~/.config/home-manager" }
};
