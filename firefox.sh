firefox &
sleep 5
killall firefox
ff_profile=$(echo ~/.mozilla/firefox/*.default-release)

install_package sqlite3
echo "DELETE FROM moz_bookmarks" | sqlite3 $ff_profile/places.sqlite

mkdir $ff_profile/chrome
echo '#webrtcIndicator { display: none !important; }' >> $ff_profile/chrome/userChrome.css

declare -A arr
arr+=(
    ["browser.uiCustomization.state"]='"{\"placements\":{\"widget-overflow-fixed-list\":[],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"urlbar-container\",\"personal-bookmarks\",\"downloads-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[]},\"seen\":[\"developer-button\",\"feed-button\"],\"dirtyAreaCache\":[\"PersonalToolbar\",\"nav-bar\",\"toolbar-menubar\",\"TabsToolbar\"],\"currentVersion\":15,\"newElementCount\":3}"'
    ["browser.startup.homepage"]='"ddg.gg"'
    ["browser.newtabpage.enabled"]=false
    ["toolkit.legacyUserProfileCustomizations.stylesheets"]=true
    ["browser.urlbar.suggest.bookmark"]=false
    ["full-screen-api.warning.timeout"]=0
    ["browser.urlbar.oneOffSearches"]=false
    ["reader.color_scheme"]='"dark"'
    ["browser.tabs.drawInTitlebar"]=true
    ["full-screen-api.warning.delay"]=-1
    ["browser.urlbar.clickSelectsAll"]=true
    ["browser.urlbar.suggest.history"]=false
    ["browser.urlbar.suggest.openpage"]=false
    ["browser.urlbar.suggest.searches"]=false
    ["browser.warnOnQuit"]=false
    ["font.name.monospace.x-western"]='"Ubuntu Mono"'
    ["font.name.sans-serif.x-western"]='"Ubuntu"'
    ["font.name.serif.x-western"]='"Ubuntu"'
    ["general.autoScroll"]=true
    ["extensions.pocket.enabled"]=false # start of privacy settings
    ["browser.safebrowsing.malware.enabled"]=false
    ["browser.safebrowsing.phishing.enabled"]=false
    ["browser.send_pings"]=false
    ["dom.battery.enabled"]=false
    ["privacy.donottrackheader.enabled"]=true
    ["privacy.trackingprotection.enabled"]=true
    ["geo.enabled"]=false
    ["media.eme.enabled"]=false
    ["media.gmp-widevinecdm.enabled"]=false
    ["media.navigator.enabled"]=false
    ["network.cookie.cookieBehavior"]=1
    ["network.IDN_show_punycode"]=true
    ["browser.cache.disk.enable"]=false
    ["browser.sessionstore.resume_from_crash"]=false
)

for key in ${!arr[@]}; do
    sed -i "/^user_pref(\"$key\"/d" $ff_profile/prefs.js
    echo "user_pref(\"$key\", ${arr[${key}]});" >> $ff_profile/prefs.js
    echo "Firefox: $key set"
done
