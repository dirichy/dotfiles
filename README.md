## Rime-ice 配置：
### 下载Rime-ice 到 对应前端的用户目录，

| 前端 |用户目录|
|-------|-------|
|鼠须管 |~/Library/Rime/|
|fcitx-rime |~/.local/share/fcitx/rime|
### 修改Rime-ice 的配置

后端配置在用户目录下的 default.yaml 中； 鼠须管前端配置在squirrel.yaml, squirrel.custom.yaml

修改配置后，重新部署才生效。

## keyd 配置:
keyd 是linux 上的键位映射软件。配置文件在/etc/keyd, 
安装之后启动
```bash 
systemctl enable --now keyd
```
修改之后需要以下命令才生效。
```bash
sudo keyd reload
```
若配置文件在其他位置，需要需要软链到/etc/keyd，
```bash 
sudo ln -s /path/to/dotfiles/keyd /etc/keyd
```


