# Bit

以下文件来自 `Project/UDP_STACK.xpr` 于 2026-11-19 在临时验证副本中的 JH 实现构建：

- `eth_udp_loop.bit`：PL 配置位流，已下载到 JH 板的 `xc7z020_1`，`DONE=1`。
- `eth_udp_loop.ltx`：对应 ILA 探针定义，匹配 1 个 ILA 和 4 个 GMII 探针。
- `eth_udp_loop.bin`：同一次实现生成的二进制位流。

修改 RTL、IP 或 XDC 后，应从 `Project/UDP_STACK.xpr` 重新生成对应输出，再更新本目录文件。