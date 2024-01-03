
# 启动 timer
systemctl --user daemon-reload
systemctl --user enable sstate-cache-cleanup.timer --now

# 测试

```shell
systemctl --user start sstate-cache-cleanup.service
```
