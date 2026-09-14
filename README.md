# ImmortalWrt-Builder-24.10

这是一个用于自动编译 [ImmortalWrt 24.10](https://github.com/padavanonly/immortalwrt-mt798x-24.10) 固件的 GitHub Actions 工作流，专为 CMCC RAX3000M EMMC设计。支持每周检查源码更新、自动编译固件，并将 `sysupgrade.bin` 文件上传到 GitHub Release。

## 提示
- 刷机有风险！有风险！有风险！
- 由于上游更新造成的uboot和固件不匹配造成无法刷入，原先引用`padavanonly/immortalwrt-mt798x-6.6`仓库转为`padavanonly-mt798x-6.6`分支，下载`RAX3000M-eMMC_XR30-eMMC_Tutorial-Files.7z`获取具体刷机教程和文件，[刷入文件获取](https://github.com/lgs2007m/Actions-OpenWrt/releases/tag/Router-Flashing-Files)。
- 当前main分支转为使用immortalwrt官方的openwrt-24.10

## 功能
- **支持的设备**：`cmcc_rax3000m-emmc`
- **自动编译**：每周一检查源仓库更新，若有新提交，自动为 CMCC RAX3000M EMMC 机型编译固件。
- **固件上传**：上传 `sysupgrade.itb`（日常升级）与 `initramfs-recovery.itb`（U-Boot 救砖）到 GitHub Release；勾选"上传所有文件"时额外上传 GPT、preloader、FIP 等底层文件。
- **清理机制**：保留最近 30 个 GitHub Release 和 30 次工作流运行，自动删除旧记录以节省空间。

## 使用方法

### 1. 配置仓库
- Fork 或单独创建一个独立的新仓库到你的GitHub。

### 2. 手动触发编译
- 进入仓库的 **Actions** 页面，选择 `ImmortalWrt-24.10` 工作流。
- 点击 **Run workflow**，选择：
  - `device_model`：默认`cmcc_rax3000m`。
  - `上传所有文件（包括 GPT、preloader、FIP、recovery、sysupgrade）`：用于底层刷机。
- 运行成功后，固件将上传到 GitHub Release 。

### 3. 编译失败
 - 在创建发布时失败：HTTP 403: Resource not accessible by integration (https://api.github.com/repos/PlanetEditorX/ImWRT-798X/releases)
    - 方式一：在 fork 仓库下新建一个 Personal Access Token (classic)（需要 repo 权限），在仓库 Secrets 里添加，比如叫 GH_TOKEN，然后 workflow 里用它替换 GITHUB_TOKEN
    - 方式二：创建一个新仓库，将该仓库除`.git`目录的其它内容移至新仓库（无提交记录）
    - 方式三：裸克隆+镜像推送（包含提交记录）
      ```bash
      git clone --bare https://github.com/PlanetEditorX/ImmortalWrt-CMCC-RAX3000M-EMMC.git
      cd ImmortalWrt-CMCC-RAX3000M-EMMC.git
      git push --mirror <新空仓库地址>
      ```
### 4. 下载固件
- **GitHub Release**：在仓库的 **Releases** 页面查下载 `sysupgrade.itb`固件。

### 5. 刷写固件
- 确认设备型号与固件匹配。
- 备份设备原有固件。
- 进入`U-Boot`配合`TFTP`刷入 `initramfs-recovery.itb`临时系统。
- 使用 `系统-备份与升级-刷写新的固件` 输入`sysupgrade.itb` 文件。
- 具体步骤查看[刷机教程](/files/刷机教程.md)。

### 6. 测试功能
- luci-app-keepalived-ha (主从路由管理)
  - 代码：https://github.com/PlanetEditorX/luci-app-build/tree/main/luci-app-keepalived-ha
  - 功能：仅界面端，方便简化配置keepalived
  - 介绍：在主从路由分别安装好keepalived后，自主编译ipk，或运行一键部署脚本，配置好主从路由信息和虚拟IP地址，将局域网需要的设备打上标签，并在接口`lan`的`DHCP服务器`-`高级设置`中配置`DHCP选项`:`tag:proxy,3,192.168.1.5`和`tag:proxy,6,192.168.1.5`。
  - 正常情况：主路由仅做管理，从路由绑定虚拟IP，标签设备的流量指向从路由
  - 故障情况：从路由9090端口打开失败，或从路由无法被Ping通，主路由接管虚拟IP，标签设备的流量指向主路由
  - 适用场景：主路由如`CMCC RAX3000M EMMC`性能一般，主要负责拨号和管理，在性能较好的从路由上进行相应的流量处理，不影响局域网的其它普通设备上网。仅当从路由失联后，主路由才会接管对应流量，作为后备处理，从路由恢复后又释放虚拟IP，让所有标签流量走从路由

## 源码
### main分支
- immortalwrt官方仓库：[immortalwrt](https://github.com/immortalwrt/immortalwrt)
- immortalwrt官方分支：[openwrt-24.10](https://github.com/immortalwrt/immortalwrt/tree/openwrt-24.10)
### padavanonly-mt798x-6.6分支
- padavanonly源码仓库：[immortalwrt-mt798x-24.10](https://github.com/padavanonly/immortalwrt-mt798x-24.10)
- padavanonly仓库分支：[openwrt-24.10-6.6](https://github.com/padavanonly/immortalwrt-mt798x-6.6/tree/openwrt-24.10-6.6)
### 工作流
- 参考工作流：[ImWRT-798X](https://github.com/hhCodingCat/ImWRT-798X)

---

# v2.0 优化说明（2026-09）

## 1. 新增 ImmortalWrt 25.12 支持
- 新增工作流 `ImmortalWrt-25.12.yml`：基于 ImmortalWrt 官方 `openwrt-25.12` 分支（最新稳定版 25.12.x，内核 6.12）。
- 新增 `config/25.12.config`：由 24.10 配置迁移，已在 25.12 真实源码树中完成 `make defconfig` 干跑验证（420 个启用包全部解析成功、零符号丢失）。
- 25.12 的自动适配已处理：包管理器由 opkg 迁移为 apk（opkg 保留）、`CONFIG_LINUX_6_12`、`acme` → `acme-acmesh`（官方重构更名）、移除已被官方替代的 turboacc 等。
- 24.10 与 25.12 双版本并存，可按需选用；上游 ImmortalWrt 24.10 分支已停止安全更新，建议优先使用 25.12。

## 2. 第三方软件包官方去重（官方优先）
- 原方案在 `diy-part1.sh` 中以白名单整包复制第三方源码（kenzok8/small-package），其中 **85 个包与官方源码树/feeds 重复**（如 sing-box、hysteria、mosdns、tailscale、frp、vlmcsd、ttyd、nmap、luci-app-passwall、luci-app-openclash、luci-app-homeproxy 等），且旧版散落在脚本中的固定清单会随时间漂移。
- 现统一改为 `diy-part2.sh` 调用 `scripts/common/package-sync.sh`：
  - 以 153 个真实第三方包白名单为准（16 个功能分类），全部来自 kenzok8/small-package；
  - 逐包对照 **源码树 package/ + 全部官方 feeds**，官方已有的一律跳过、使用官方版本（运行时判定，官方未来新增同名包会自动切换到官方版本）；
  - 剔除了 88 个在上游和官方 feeds 中均已消失的彻底失效包（如 luci-app-wireguard、luci-app-kucat、turboacc 旧版等）；
  - 修复了原脚本顶层目录判断的隐藏 bug：small-package 中嵌套目录内的包（如 `other/lean/luci-app-turboacc`）此前从未被复制成功，现支持递归查找。
- 白名单更新方式：直接编辑 `scripts/common/package-sync.sh` 中的 `WHITELIST` 段落（每行一个包名，`#` 开头为分类注释）。

## 3. 编译链路修复与优化
- **修复 `scripts/24.10/diy-part1.sh` 截断问题**：原文件仅存前 267 行（约 405 行处戛然而止）；v2.0 中第三方导入与去重逻辑移至 diy-part2（需要官方 feeds 目录做对照），diy-part1 保留为占位脚本，截断不再有影响。
- **ccache 改为官方原生支持**：原 workflow 向 `include/toplevel.mk` 追加的 hack 因 `MAKECMDGOALS` 判空实际永远 `CCACHE_DISABLE=1`（无效缓存）；且编译步骤的 `export USE_CCACHE=1` 并非 OpenWrt 认可的开关。现改为写入 `CONFIG_CCACHE=y` + `CONFIG_CCACHE_DIR`（与 actions/cache 的 `~/.cache/ccache` 路径一致），缓存真实生效。
- **Runner 升级**：两个 workflow 均由 `ubuntu-22.04` 升级为 `ubuntu-24.04`（22.04 镜像已被 GitHub 淘汰，旧配置存在无法调度的风险）。
- 定时检查为每周一/周四（06:00 / 06:30 UTC 错峰），只在源码有更新时才编译，同时保活 GitHub 缓存（闲置 7 天会被淘汰）。
- **编译提速（不改动任何编译配置）**：`openwrt/dl` 源码包缓存（按月滚动，每次省 10-20 分钟下载）+ ccache 滚动缓存（修复原静态 key 导致缓存首建后永不更新的问题，容量上限提升至 6G）。
- Actions 全部组件升级至 Node 24 运行时（checkout@v5 / upload-artifact@v5 / gh-release@v3 / cache@v5），消除 Node.js 20 弃用警告。
- **Docker 改为按需集成**：`enable_docker` 默认关闭——dockerd/docker-compose/containerd/runc 均为 Go 编译大户（合计约 25-35 分钟，且 ccache 对 Go 交叉编译无效），RAX3000M 仅 512MB 内存运行 Docker 也本就吃力；需要时在 Run workflow 勾选「集成 Docker」即可，`config/docker.config` 保留、随时可用。

## 4. 使用说明
- 编译 25.12：Actions 页面选择 `ImmortalWrt-25.12` 工作流 → Run workflow（默认 `openwrt-25.12` 分支 + `25.12.config`）。
- 编译 24.10：选择 `ImmortalWrt-24.10` 工作流，用法不变。
- 两个版本的 diy 脚本均位于 `scripts/<版本>/`，公共去重脚本位于 `scripts/common/package-sync.sh`。
- 手动触发时请保持默认的 `repo_branch` / `config_file` 选择，避免跨版本混用配置。

## 值守式固件升级（GitHub Releases 固定 URL，无需 ASU 服务器）

每次编译发布 Release 时会额外上传一组固定资产（文件名恒定，URL 永远指向最新构建）：

- `autoupdate-RAX3000M-24.10-version.txt`：构建指纹（RUN_ID）
- `autoupdate-RAX3000M-24.10-sysupgrade.itb`：最新 sysupgrade 镜像
- `autoupdate-RAX3000M-24.10-sysupgrade.itb.sha256`：镜像 sha256

固件内置 `rax-autoupdate` 脚本，cron 每日自动检查一次（默认只提醒不自动刷）：

    rax-autoupdate status     # 查看状态
    rax-autoupdate check      # 手动检查更新
    rax-autoupdate apply      # 下载 + sha256 校验 + 刷写（保留配置，自动重启）
    rax-autoupdate disable    # 停用每日自动检查

- 升级地址基于本仓库 `releases/latest/download/<固定文件名>`，fork 后无需改配置自动适配
- 新版本提醒写入系统日志；如需推送，配置 /etc/config/autoupdate 的 notify_url（ntfy/Bark 等 POST 文本接口）
- 全自动无人值守刷写默认关闭；确认风险后可置 auto_apply '1'
