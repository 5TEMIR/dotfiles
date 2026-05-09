config.load_autoconfig(False)
config.set("content.cookies.accept", "all", "chrome-devtools://*")
config.set("content.cookies.accept", "all", "devtools://*")
config.set("content.headers.accept_language", "", "https://matchmaker.krunker.io/*")
config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 ({os_info}; rv:145.0) Gecko/20100101 Firefox/145.0",
    "https://accounts.google.com/*",
)
config.set(
    "content.headers.user_agent",
    "Mozilla/5.0 ({os_info}) AppleWebKit/{webkit_version} (KHTML, like Gecko) {qt_key}/{qt_version} {upstream_browser_key}/{upstream_browser_version_short} Safari/{webkit_version}",
    "https://gitlab.gnome.org/*",
)
config.set("content.images", True, "chrome-devtools://*")
config.set("content.images", True, "devtools://*")
config.set("content.javascript.enabled", True, "chrome-devtools://*")
config.set("content.javascript.enabled", True, "devtools://*")
config.set("content.javascript.enabled", True, "chrome://*/*")
config.set("content.javascript.enabled", True, "qute://*/*")
config.set(
    "content.local_content_can_access_remote_urls",
    True,
    "file:///home/stemir/.local/share/qutebrowser/userscripts/*",
)
config.set(
    "content.local_content_can_access_file_urls",
    False,
    "file:///home/stemir/.local/share/qutebrowser/userscripts/*",
)

# Custom options
config.source("theme.py")

c.qt.args = [
    "enable-features=VaapiVideoDecoder",
    "ignore-gpu-blocklist",
    "enable-gpu-rasterization",
    "enable-accelerated-video-decode",
    "enable-oop-rasterization",
]

c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "!aw": "https://wiki.archlinux.org/?search={}",
    "!apkg": "https://archlinux.org/packages/?sort=&q={}",
    "!git": "https://github.com/search?o=desc&q={}&s=stars",
    "!yt": "https://www.youtube.com/results?search_query={}",
    "!rd": "https://www.reddit.com/search?q={}",
    "!so": "https://stackoverflow.com/search?q={}",
    "!w": "https://en.wikipedia.org/wiki/Special:Search?search={}",
    "!aur": "https://aur.archlinux.org/packages?K={}",
    "!g": "https://www.google.com/search?q={}",
    "!ya": "https://www.yandex.ru/search?text={}",
}

config.bind("<Ctrl-m>", "fake-key <Return>", "insert")
config.bind("<Ctrl-h>", "fake-key <Backspace>", "insert")
# config.bind("<Ctrl-a>", "fake-key <Home>", "insert")
config.bind("<Ctrl-e>", "fake-key <End>", "insert")
config.bind("<Ctrl-b>", "fake-key <Left>", "insert")
config.bind("<Mod1-b>", "fake-key <Ctrl-Left>", "insert")
config.bind("<Ctrl-f>", "fake-key <Right>", "insert")
config.bind("<Mod1-f>", "fake-key <Ctrl-Right>", "insert")
config.bind("<Ctrl-p>", "fake-key <Up>", "insert")
config.bind("<Ctrl-n>", "fake-key <Down>", "insert")
config.bind("<Mod1-d>", "fake-key <Ctrl-Delete>", "insert")
config.bind("<Ctrl-d>", "fake-key <Delete>", "insert")
config.bind("<Ctrl-w>", "fake-key <Ctrl-Backspace>", "insert")
config.bind("<Ctrl-u>", "fake-key <Shift-Home><Delete>", "insert")
config.bind("<Ctrl-k>", "fake-key <Shift-End><Delete>", "insert")
config.bind("wf", "hint links spawn --detach yt-queue add {hint-url}")

c.auto_save.session = True

c.colors.webpage.darkmode.enabled = True
c.fonts.web.size.default = 15

config.set("content.javascript.clipboard", "access-paste", "https://chat.deepseek.com")
