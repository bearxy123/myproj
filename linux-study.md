# Linux 系统运维基础知识与面试题手册

> **学习目标：** 面向 Linux 系统运维、生产制造系统运维、服务器部署及故障排查岗位。
>
> **学习方法：** 基础知识 → 常用命令 → 面试问题 → 故障排查。
>
> **说明：** 命令以常见 Linux 发行版为基础，部分工具需要额外安装。配置文件和网络管理方式应根据发行版及实际环境选择。

---

# 第一章：Linux 系统启动与 systemd

## 1.1 基础知识

### 1.1.1 Linux 系统完整启动流程

Linux 从开机到进入用户登录界面，主要经历以下阶段：

**固件初始化 → 引导程序 → Linux Kernel → initramfs → systemd → 用户登录界面**

#### 1. BIOS / UEFI 固件初始化

BIOS 和 UEFI 都是主板固件，负责开机自检、硬件初始化和寻找启动设备。

| 对比 | BIOS | UEFI |
|---|---|---|
| 类型 | 传统固件 | 现代固件 |
| 启动方式 | 通常通过 MBR 引导 | 通过 EFI 启动文件 |
| 分区表 | 常见 MBR | 常见 GPT |
| 启动文件 | MBR 中的引导代码 | ESP 分区中的 `.efi` 文件 |
| 安全启动 | 不支持标准 Secure Boot | 支持 Secure Boot |

BIOS 通常通过 POST 完成硬件自检，然后根据启动顺序读取磁盘引导代码。

UEFI 则从 EFI 系统分区（ESP）加载 EFI 格式的引导程序。

#### 2. GRUB 引导程序

GRUB 是 Linux 常见的引导加载程序，主要负责：

- 显示启动菜单。
- 读取启动配置文件。
- 加载 Linux Kernel。
- 加载 initramfs。
- 向内核传递启动参数，例如 `root=`。
- 将控制权交给 Linux Kernel。

常见配置文件：

```bash
/boot/grub2/grub.cfg       # 部分 RHEL 系发行版
/boot/grub/grub.cfg        # 部分 Debian/Ubuntu 系发行版
```

#### 3. Linux Kernel 内核初始化

内核接管系统后，主要完成：

- 初始化 CPU 和内存管理。
- 初始化进程调度器。
- 初始化中断机制。
- 初始化驱动程序。
- 探测和识别硬件设备。
- 初始化 VFS（虚拟文件系统）。
- 准备挂载根文件系统。

#### 4. initramfs 临时根文件系统

initramfs 是启动早期使用的临时根文件系统，通常由引导程序加载到内存中。

主要作用：

- 加载必要的内核模块。
- 识别磁盘和存储设备。
- 加载文件系统驱动。
- 激活 LVM、RAID、加密磁盘等。
- 定位真正的根文件系统。
- 完成根文件系统切换。

注意：initramfs 并不是所有驱动都必须依赖的组件。如果内核已经内置了所需驱动，也可能不需要通过 initramfs 加载。

#### 5. systemd 初始化

现代 Linux 通常使用 systemd 作为 PID 1 的初始化进程。

主要负责：

- 启动系统服务。
- 管理服务依赖关系。
- 管理系统启动目标。
- 管理挂载点。
- 管理日志。
- 管理系统运行状态。

systemd 使用 Unit 管理系统资源和服务，例如：

| Unit 类型 | 作用 |
|---|---|
| service | 管理系统服务 |
| target | 管理系统启动目标 |
| mount | 管理文件系统挂载 |
| socket | 管理 Socket |
| timer | 管理定时任务 |
| device | 管理设备 |

systemd 通过依赖关系组织启动任务，并行启动不存在依赖冲突的服务。

常见依赖关系：

- `Requires`：强依赖关系。
- `Wants`：弱依赖关系。
- `After`：指定启动顺序。
- `Before`：指定在某个 Unit 之前启动。

注意：`After` 只控制顺序，本身不会自动拉起另一个 Unit。

#### 6. 用户登录界面

系统根据默认启动目标进入相应模式：

- `graphical.target`：图形化登录界面。
- `multi-user.target`：多用户命令行模式。
- `rescue.target`：救援模式。
- `emergency.target`：紧急维护模式。

---

### 1.1.2 systemd 常用命令

```bash
# 查看默认启动目标
systemctl get-default

# 设置默认图形化启动
systemctl set-default graphical.target

# 设置默认命令行启动
systemctl set-default multi-user.target

# 查看系统运行目标
systemctl list-units --type=target

# 查看服务状态
systemctl status nginx

# 启动服务
systemctl start nginx

# 停止服务
systemctl stop nginx

# 重启服务
systemctl restart nginx

# 重新加载服务配置
systemctl reload nginx

# 设置开机自启动
systemctl enable nginx

# 取消开机自启动
systemctl disable nginx

# 查看启动失败的服务
systemctl --failed

# 查看启动耗时
systemd-analyze

# 查看服务启动耗时
systemd-analyze blame
```

### 1.1.3 系统启动日志

```bash
# 查看本次启动日志
journalctl -b

# 查看上一次启动日志
journalctl -b -1

# 查看指定服务日志
journalctl -u nginx

# 实时查看服务日志
journalctl -u nginx -f

# 查看内核日志
dmesg -T

# 查看最近的内核日志
dmesg -T | tail -n 50
```

## 1.2 面试问题

**问题1：描述一下 Linux 系统从开机到进入用户登录界面的完整启动流程？**

参考回答：

Linux 启动主要分为五个阶段：

1. BIOS 或 UEFI 完成硬件初始化和启动设备检查。
2. GRUB 引导程序加载内核和 initramfs，并传递启动参数。
3. Kernel 初始化 CPU、内存、驱动和文件系统。
4. initramfs 加载必要驱动，识别并挂载真正的根文件系统。
5. systemd 接管系统，根据默认 target 启动服务，最终进入图形界面或命令行登录界面。

**问题2：BIOS 和 UEFI 有什么区别？**

参考回答：

BIOS 是传统固件，通常通过 MBR 引导；UEFI 是现代固件，可以直接从 EFI 系统分区加载 EFI 引导文件，支持 GPT 和 Secure Boot 等功能。

**问题3：GRUB 的作用是什么？**

参考回答：

GRUB 是引导加载程序，主要负责加载 Linux 内核和 initramfs，传递内核启动参数，最后将控制权交给内核。

**问题4：initramfs 是什么？有什么作用？**

参考回答：

initramfs 是启动早期使用的临时根文件系统，主要负责加载磁盘驱动、文件系统驱动，以及激活 LVM、RAID 等存储环境，帮助内核找到并挂载真正的根文件系统。

**问题5：systemd 是什么？**

参考回答：

systemd 是现代 Linux 的初始化系统，通常作为 PID 1 运行，负责系统服务管理、启动依赖管理、挂载管理和系统运行目标管理。

**问题6：Linux 启动时出现以下错误，如何排查？**

```text
VFS: Cannot open root device
or unknown-block(0,0)
Please append a correct "root=" boot option

Kernel panic - not syncing:
VFS: Unable to mount root fs
```

参考回答：

这个错误说明内核无法成功挂载根文件系统。

可能原因包括：

1. GRUB 中的 `root=` 参数错误。
2. 磁盘或存储控制器驱动缺失。
3. 文件系统驱动缺失。
4. initramfs 不完整。
5. 根分区 UUID 或设备路径发生变化。
6. 存储设备未被正常识别。

排查步骤：

```bash
# 1. 检查 GRUB 启动参数
cat /proc/cmdline

# 2. 查看块设备
lsblk -f

# 3. 查看文件系统 UUID
blkid

# 4. 查看内核模块
lsmod

# 5. 查看内核启动日志
dmesg | grep -iE "scsi|nvme|ata|root|filesystem"
```

如果无法正常进入系统，可以通过 Live CD 或救援模式检查 initramfs、GRUB 配置及存储设备。

**问题7：如何查看系统默认启动模式？**

```bash
systemctl get-default
```

如果输出 `graphical.target`，表示默认进入图形化模式；如果输出 `multi-user.target`，表示默认进入多用户命令行模式。

---

# 第二章：Linux 进程与线程管理

## 2.1 基础知识

### 2.1.1 什么是进程？

进程是程序运行时的实例，是操作系统进行资源分配和管理的重要单位。

每个进程通常具有：

- 独立的虚拟地址空间。
- 进程 ID（PID）。
- 文件描述符。
- 进程状态。
- 内存资源。
- 运行上下文。

### 2.1.2 什么是线程？

线程是进程内部的执行单元，是 CPU 调度的重要对象。

同一进程内的多个线程通常共享：

- 进程地址空间。
- 全局变量和堆内存。
- 打开的文件描述符。

每个线程拥有独立的：

- 线程 ID（TID）。
- 栈空间。
- 寄存器状态。
- 线程局部存储。

### 2.1.3 进程和线程的区别

| 对比项目 | 进程 | 线程 |
|---|---|---|
| 资源分配 | 独立进程资源 | 共享进程资源 |
| 地址空间 | 通常相互隔离 | 同进程内共享 |
| 创建开销 | 相对较大 | 相对较小 |
| 通信方式 | IPC | 共享内存等 |
| 切换开销 | 通常较大 | 通常较小 |
| 稳定性 | 隔离性较强 | 一个线程异常可能影响整个进程 |

注意：Linux 中线程也由内核调度，线程切换是否需要切换地址空间，取决于线程是否属于同一个进程。

### 2.1.4 Linux 常见进程状态

| 状态 | 含义 |
|---|---|
| R | 正在运行或等待运行 |
| S | 可中断睡眠 |
| D | 不可中断睡眠，通常等待 I/O |
| Z | 僵尸进程 |
| T | 停止或被跟踪 |
| I | 空闲内核线程状态 |

重点：

- R：正在使用 CPU 或处于运行队列。
- S：等待某个事件，可以被信号唤醒。
- D：通常等待磁盘或其他内核 I/O 操作。
- Z：进程已经退出，但父进程尚未回收退出状态。

### 2.1.5 什么是僵尸进程？

僵尸进程是已经结束运行，但父进程尚未通过 `wait()` 或相关系统调用回收其退出状态的进程。

僵尸进程：

- 不再执行代码。
- 不占用正常的运行内存。
- 通常不消耗 CPU。
- 仍然占用进程表中的 PID 等有限资源。

### 2.1.6 什么是上下文切换？

上下文切换是 CPU 从一个执行任务切换到另一个执行任务的过程。

系统需要保存当前任务的运行状态，并恢复下一个任务的状态。

上下文切换可以分为：

- 进程上下文切换。
- 线程上下文切换。
- 用户态与内核态之间的切换（严格来说，后者是特权级切换，不一定意味着任务上下文切换）。

频繁的任务上下文切换会增加系统开销。

## 2.2 常用命令

```bash
# 查看所有进程
ps aux

# 查看进程及父进程关系
ps -ef

# 根据进程名称查询
ps aux | grep nginx

# 查看指定 PID
ps -p 1234 -o pid,ppid,stat,%cpu,%mem,cmd

# 查看进程线程
ps -T -p 1234

# 按线程 CPU 使用率排序
ps -L -p 1234 -o pid,tid,pcpu,comm --sort=-pcpu

# 查看进程树
pstree -p

# 查看进程打开的文件
lsof -p 1234

# 查看进程状态
cat /proc/1234/status

# 查看指定进程的线程
ls /proc/1234/task/
```

### 2.2.1 top 常用命令

```bash
# 查看指定进程
top -p 1234

# 查看线程
top -H -p 1234

# 指定刷新间隔
top -d 1

# 只显示指定用户
top -u root

# 批处理模式
top -b -n 1

# 只查看 CPU 排名前列的进程
top -o %CPU
```

top 交互快捷键：

| 按键 | 作用 |
|---|---|
| P | 按 CPU 排序 |
| M | 按内存排序 |
| T | 按累计运行时间排序 |
| 1 | 展开每个 CPU 核心 |
| c | 显示完整命令 |
| H | 切换线程显示 |
| u | 过滤指定用户 |
| i | 隐藏空闲进程 |

## 2.3 面试问题

**问题1：进程和线程有什么区别？**

参考回答：

进程是资源分配和管理的基本单位，线程是 CPU 调度的重要执行单位。进程之间通常拥有独立的地址空间，而同一进程内的线程共享地址空间和大部分资源，但拥有各自独立的栈和寄存器状态。

**问题2：如何查看 CPU 占用最高的进程？**

```bash
top
```

进入 top 后按大写 `P`，即可按照 CPU 使用率排序。

也可以使用：

```bash
ps -eo pid,comm,%cpu --sort=-%cpu | head
```

**问题3：如何查看进程对应的 PID？**

```bash
ps -ef | grep nginx
```

或者：

```bash
pgrep -a nginx
```

**问题4：如何查看进程的线程？**

```bash
top -H -p <PID>
```

或者：

```bash
ps -T -p <PID>
```

**问题5：如何查看进程运行状态？**

```bash
ps -p <PID> -o pid,ppid,stat,cmd
```

重点关注 STAT 列中的 R、S、D、Z 等状态。

**问题6：kill -15 和 kill -9 有什么区别？**

参考回答：

`kill -15` 发送 SIGTERM 信号，属于正常终止请求，允许程序执行清理操作后退出。

`kill -9` 发送 SIGKILL 信号，无法被捕获或忽略，内核会强制终止进程，进程没有机会执行正常清理操作。

生产环境通常优先使用：

```bash
kill -15 <PID>
```

确认无法正常退出且评估风险后，再考虑：

```bash
kill -9 <PID>
```

注意：D 状态进程通常无法立即响应信号，盲目使用 SIGKILL 也不能解决底层 I/O 卡死问题。

**问题7：如何排查僵尸进程？**

第一步：查找僵尸进程。

```bash
ps -eo pid,ppid,stat,cmd | awk '$3 ~ /^Z/'
```

第二步：查看父进程 PID（PPID）。

```bash
ps -eo pid,ppid,stat,cmd
```

第三步：检查父进程为什么没有回收子进程。

第四步：修复父进程的回收逻辑，或者在确认影响后重启异常父进程。

注意：不能直接通过 kill 僵尸进程来清理它。应该由父进程调用 wait 系列函数回收退出状态；如果父进程退出，孤儿进程会被重新托管并最终回收。

---

# 第三章：CPU 性能排查

## 3.1 基础知识

### 3.1.1 CPU 使用率

CPU 使用率表示 CPU 在统计周期内执行不同任务所占用的时间比例。

Linux top 常见指标：

| 指标 | 含义 |
|---|---|
| us | 用户态 CPU 时间 |
| sy | 内核态 CPU 时间 |
| ni | 调整过优先级的用户态任务时间 |
| id | CPU 空闲时间 |
| wa | I/O 等待时间 |
| hi | 硬中断时间 |
| si | 软中断时间 |
| st | 虚拟化环境中被宿主机占用的时间 |

重点：

- us 高：可能是应用程序计算量大。
- sy 高：可能是系统调用、内核处理或系统开销大。
- wa 高：可能存在磁盘 I/O 等待。
- si 高：可能存在网络包处理或软中断压力。
- st 高：可能是虚拟机所在宿主机资源竞争。

注意：wa 是 CPU 处于 I/O 等待相关统计状态的时间比例，不代表 CPU 正在执行磁盘 I/O，也不能简单地认为 CPU 已经被占满。

### 3.1.2 用户态和内核态

**用户态：**

应用程序运行的权限级别较低，不能直接操作受保护的硬件和内核数据。

**内核态：**

操作系统内核运行的权限级别较高，可以管理内存、进程、设备驱动、中断等资源。

应用程序通过系统调用向内核请求服务，例如：

```text
应用程序
   |
   | read() / write()
   v
系统调用
   |
   v
Linux Kernel
   |
   v
硬件设备
```

### 3.1.3 什么是负载平均值 Load Average？

Load Average 表示系统在一段时间内处于可运行状态和不可中断睡眠状态的任务平均数量。

通过以下命令查看：

```bash
uptime
```

输出中的三个值分别代表：

- 最近 1 分钟平均负载。
- 最近 5 分钟平均负载。
- 最近 15 分钟平均负载。

查看 CPU 核心数量：

```bash
nproc
```

例如：

如果服务器有 8 个 CPU 核心：

- Load Average = 2：通常说明运行队列压力不大。
- Load Average = 8：可能接近 CPU 运行能力。
- Load Average = 16：可能存在较明显的任务排队。

但 Load Average 不能单独判断 CPU 是否饱和，因为 D 状态的任务也会计入负载。

### 3.1.4 CPU 性能排查工具

| 工具 | 主要作用 |
|---|---|
| top | 查看进程和系统整体 CPU 使用率 |
| vmstat | 查看运行队列、阻塞、内存和上下文切换 |
| mpstat | 查看每个 CPU 核心的使用情况 |
| pidstat | 查看具体进程和线程的资源使用情况 |
| perf | 分析 CPU 热点、调用栈和性能事件 |

## 3.2 常用命令

### 3.2.1 top

```bash
top
```

查看：

- 系统整体 CPU 使用率。
- 进程 CPU 使用率。
- 内存占用。
- 进程状态。

### 3.2.2 vmstat

```bash
vmstat 2 5
```

每隔 2 秒采样一次，共采样 5 次。

重点字段：

| 字段 | 含义 |
|---|---|
| r | 可运行任务数量 |
| b | 不可中断睡眠任务数量 |
| si | Swap 换入量 |
| so | Swap 换出量 |
| bi | 块设备读取量 |
| bo | 块设备写入量 |
| in | 每秒中断次数 |
| cs | 每秒上下文切换次数 |
| us | 用户态 CPU 时间 |
| sy | 内核态 CPU 时间 |
| id | CPU 空闲时间 |
| wa | I/O 等待时间 |

注意：第一行通常反映自系统启动以来的平均情况，后续行才更适合观察当前采样周期。

### 3.2.3 mpstat

```bash
# 查看所有 CPU 核心
mpstat -P ALL 2

# 查看指定 CPU 核心
mpstat -P 0 2
```

适合排查单核 CPU 使用率过高的问题。

### 3.2.4 pidstat

```bash
# 查看进程 CPU
pidstat -u 2

# 查看指定进程线程 CPU
pidstat -t -p <PID> 2

# 查看进程内存
pidstat -r 2

# 查看进程磁盘 I/O
pidstat -d 2
```

## 3.3 面试问题

**问题1：Linux 服务器 CPU 使用率突然达到 100%，如何排查？**

参考回答：

首先使用 uptime 查看系统负载，再使用 top 查看 CPU 整体使用情况，并通过 P 键找到 CPU 占用最高的进程。

然后根据 CPU 使用类型判断问题：

1. us 高：排查应用程序计算逻辑、死循环或高并发请求。
2. sy 高：排查系统调用、内核开销和上下文切换。
3. si 高：排查网络流量和软中断。
4. wa 高：进一步检查磁盘 I/O。

定位到具体进程后，通过 top -H 或 pidstat 查看线程，必要时使用 perf 分析调用栈。

**问题2：用户态 CPU 和内核态 CPU 有什么区别？**

参考回答：

用户态主要执行应用程序代码，内核态主要执行操作系统内核代码。应用程序需要访问硬件、文件系统等资源时，会通过系统调用进入内核态。

**问题3：什么是上下文切换？**

参考回答：

上下文切换是 CPU 在不同任务之间切换时，保存当前任务状态并恢复下一个任务状态的过程。频繁切换会带来额外的 CPU 开销。

**问题4：什么是 Load Average？**

参考回答：

Load Average 表示系统在一段时间内处于可运行状态和不可中断睡眠状态的任务平均数量。它反映系统整体负载，但不能单独作为 CPU 饱和的判断依据。

**问题5：top、vmstat、mpstat 分别有什么用途？**

参考回答：

- top：查看系统整体和进程 CPU 使用情况。
- vmstat：查看运行队列、阻塞任务、内存和上下文切换。
- mpstat：查看每个 CPU 核心的使用情况。

**问题6：CPU 使用率高是否一定代表 CPU 资源不足？**

参考回答：

不一定。可能是程序存在死循环、频繁上下文切换、系统调用过多、软中断压力大等原因。需要结合 us、sy、si、wa、Load Average 和具体进程进一步分析。

**问题7：如何判断单核 CPU 被跑满？**

```bash
mpstat -P ALL 1
```

如果某个核心的 idle 接近 0，而其他核心仍然空闲，说明可能存在单线程热点问题。

---

# 第四章：内存管理与 OOM 排查

## 4.1 基础知识

### 4.1.1 什么是 OOM？

OOM（Out Of Memory）表示系统或某个内存控制组无法满足内存分配需求。

当内核无法通过正常内存回收满足分配请求时，可能触发 OOM Killer。

OOM Killer 会根据进程的 OOM 评分等因素选择目标进程并终止，以释放内存。

### 4.1.2 OOM 常见原因

1. 物理内存不足。
2. Swap 空间不足或无法提供足够缓冲。
3. 应用程序内存泄漏。
4. 突发大内存分配。
5. 容器或服务的 cgroup 内存限制达到上限。
6. 内核内存资源不足。

### 4.1.3 free 和 available 的区别

执行：

```bash
free -h
```

重点关注：

| 指标 | 含义 |
|---|---|
| total | 总内存 |
| used | 已使用内存 |
| free | 完全空闲内存 |
| shared | 共享内存 |
| buff/cache | 缓冲和缓存 |
| available | 预计可供新程序使用的内存 |

**free：** 完全未使用的物理内存。

**available：** Linux 根据当前内存使用和可回收缓存等情况估算的可用内存。

判断内存是否紧张，通常优先观察 available，而不是只看 free。

### 4.1.4 什么是 Swap？

Swap 是 Linux 使用磁盘空间作为虚拟内存的一种机制。

主要作用：

- 为内存压力提供一定缓冲。
- 将部分不活跃内存页换出。
- 提高系统在内存紧张情况下的生存能力。

Swap 的性能远低于物理内存，持续大量换入换出会严重影响性能。

### 4.1.5 RSS、VSZ、PSS、USS

| 指标 | 含义 |
|---|---|
| RSS | 当前驻留在物理内存中的页面 |
| VSZ | 进程虚拟地址空间大小 |
| PSS | 共享页面按照比例分摊后的内存 |
| USS | 进程独占的物理内存 |

其中：

- RSS 适合快速判断进程常驻内存。
- PSS 更适合估算进程实际分摊的物理内存。
- USS 用于查看进程独占内存。

## 4.2 常用命令

```bash
# 查看整体内存
free -h

# 查看内存详细信息
cat /proc/meminfo

# 查看进程内存占用
ps aux --sort=-%mem | head

# 查看指定进程内存
ps -o pid,rss,vsz,cmd -p <PID>

# 查看进程内存状态
cat /proc/<PID>/status

# 查看进程内存映射
pmap -x <PID>

# 查看进程内存汇总
cat /proc/<PID>/smaps_rollup

# 查看内核缓存
slabtop

# 查看 Swap
swapon --show

# 查看动态内存情况
vmstat 1 5
```

### 4.2.1 OOM 日志排查

```bash
# 查看内核 OOM 日志
dmesg -T | grep -iE "oom|killed process|out of memory"

# 使用 journalctl
journalctl -k | grep -iE "oom|killed process"

# 查看传统系统日志
grep -iE "oom|killed process" /var/log/messages
```

典型日志：

```text
Out of memory: Killed process 21734 (python3)
```

可以据此确定被杀死的进程及 PID。

### 4.2.2 cgroup 内存排查

容器环境中，内存限制可能与宿主机物理内存无关。

cgroup v2 常见文件：

```bash
# 查看内存上限
cat /sys/fs/cgroup/memory.max

# 查看当前使用量
cat /sys/fs/cgroup/memory.current

# 查看历史峰值
cat /sys/fs/cgroup/memory.peak

# 查看内存压力
cat /sys/fs/cgroup/memory.pressure

# 查看 OOM 事件计数
cat /sys/fs/cgroup/memory.events
```

注意：以上是当前 cgroup 的示例路径，实际容器和服务通常需要先定位对应的 cgroup 子目录。

## 4.3 面试问题

**问题1：什么是 OOM？Linux 为什么会触发 OOM Killer？**

参考回答：

OOM 是系统无法满足内存分配需求的一种状态。当内核尝试回收内存仍然无法满足分配请求时，可能启动 OOM Killer，选择一个进程终止，释放内存资源，避免系统整体崩溃。

**问题2：如何查看系统内存使用情况？**

```bash
free -h
cat /proc/meminfo
vmstat 1 5
```

**问题3：free -h 中的 available 和 free 有什么区别？**

参考回答：

free 表示完全空闲的内存，available 表示系统综合考虑可回收缓存等因素后，预计能够提供给新程序使用的内存。

**问题4：如何查看 OOM Killer 杀死了哪个进程？**

```bash
dmesg -T | grep -iE "oom|killed process"
```

**问题5：如何查看进程实际内存占用？**

```bash
ps -o pid,rss,vsz,cmd -p <PID>
cat /proc/<PID>/smaps_rollup
```

可以重点关注 RSS、PSS 和 USS。

**问题6：如何减少 OOM 发生的概率？**

参考回答：

1. 监控 available 内存和 Swap 使用趋势。
2. 排查应用程序是否存在内存泄漏。
3. 合理配置容器及服务的 cgroup 内存限制。
4. 根据业务特点合理配置 Swap。
5. 优化应用程序内存使用。
6. 对关键服务合理设置 oom_score_adj，降低被 OOM Killer 选择的概率。

注意：`oom_score_adj=-1000` 可以显著降低进程被 OOM Killer 选择的可能性，但不应随意设置，避免其他进程被迫承担风险。

**问题7：如何判断是用户进程内存泄漏还是内核内存泄漏？**

参考回答：

如果某个进程 RSS 或 PSS 持续增长，可以重点检查该进程的堆、匿名映射和内存分配情况。

如果系统整体 available 持续下降，而用户进程占用并不明显，则需要进一步检查 Slab、内核对象缓存等。

常用工具：

```bash
pmap -x <PID>
cat /proc/<PID>/smaps_rollup
slabtop
cat /proc/meminfo
```

进一步可以使用 Valgrind、语言运行时分析工具或 eBPF 工具进行定位。

---

# 第五章：磁盘与文件系统基础

## 5.1 基础知识

### 5.1.1 Linux 磁盘结构

Linux 磁盘管理涉及以下几个层次：

```text
物理磁盘
   |
   v
磁盘分区
   |
   v
文件系统
   |
   v
挂载点
   |
   v
用户访问文件
```

常见磁盘设备：

- `/dev/sda`：常见 SATA/SAS 磁盘设备。
- `/dev/nvme0n1`：NVMe 磁盘设备。
- `/dev/vda`：虚拟磁盘设备。
- `/dev/loop0`：Loop 虚拟块设备。

### 5.1.2 MBR 和 GPT

| 对比 | MBR | GPT |
|---|---|---|
| 分区数量 | 最多 4 个主分区（可通过扩展分区增加逻辑分区） | 通常支持更多分区 |
| 容量限制 | 传统实现约 2 TiB | 支持更大容量 |
| 结构 | 主引导记录 | GUID 分区表 |
| 适用环境 | 传统系统 | 现代系统 |

### 5.1.3 文件系统

文件系统负责组织、存储和管理磁盘上的文件数据。

常见文件系统：

| 文件系统 | 特点 |
|---|---|
| ext4 | Linux 常用通用文件系统 |
| XFS | 适合大文件和高容量存储 |
| Btrfs | 支持快照、子卷等功能 |
| FAT32 | 兼容性好，单文件最大 4 GiB |
| NTFS | Windows 常用文件系统 |

### 5.1.4 inode

inode 是文件系统用于描述文件元数据的数据结构。

通常记录：

- 文件权限。
- 文件所有者。
- 文件大小。
- 时间信息。
- 数据块位置等信息。

inode 不直接保存文件名，文件名与 inode 的对应关系由目录项维护。

如果 inode 耗尽，即使磁盘仍然有剩余空间，也可能无法创建新文件。

### 5.1.5 df 和 du 的区别

| 命令 | 作用 |
|---|---|
| df | 查看文件系统整体使用情况 |
| du | 统计文件或目录占用空间 |

`df` 关注文件系统层面的空间使用。

`du` 通过遍历目录中的文件进行统计。

## 5.2 常用命令

### 5.2.1 查看磁盘信息

```bash
# 查看块设备
lsblk

# 查看块设备及文件系统
lsblk -f

# 查看分区表
fdisk -l

# 查看 GPT / MBR 分区
parted /dev/sda print

# 查看 UUID 和文件系统类型
blkid

# 查看磁盘使用空间
df -h

# 查看 inode 使用情况
df -i

# 查看目录大小
du -sh /var/log

# 查看一级目录大小
du -xh --max-depth=1 / 2>/dev/null | sort -rh
```

### 5.2.2 挂载管理

```bash
# 查看挂载情况
mount

# 挂载文件系统
mount /dev/sdb1 /data

# 卸载文件系统
umount /data

# 重新挂载为只读
mount -o remount,ro /data

# 测试 fstab 配置
mount -a
```

### 5.2.3 /etc/fstab

`/etc/fstab` 用于配置系统启动时自动挂载的文件系统。

配置示例：

```text
UUID=xxxx-xxxx  /data  xfs  defaults  0  0
```

字段含义：

| 字段 | 含义 |
|---|---|
| UUID | 文件系统标识 |
| /data | 挂载点 |
| xfs | 文件系统类型 |
| defaults | 挂载参数 |
| 0 | 是否使用 dump |
| 0 | fsck 检查顺序 |

对于非关键数据盘，可以根据实际需求考虑：

```text
UUID=xxxx-xxxx /data xfs defaults,nofail 0 0
```

`nofail` 可以避免该设备无法挂载时直接阻断正常启动，但仍需通过日志监控挂载失败情况。

## 5.3 面试问题

**问题1：如何查看 Linux 磁盘分区？**

```bash
lsblk -f
fdisk -l
blkid
```

**问题2：df 和 du 有什么区别？**

参考回答：

df 从文件系统角度查看整体使用情况，du 通过遍历目录和文件统计空间占用。

**问题3：磁盘空间满了如何排查？**

第一步：区分磁盘空间和 inode 是否耗尽。

```bash
df -h
df -i
```

第二步：查看大目录。

```bash
du -xh --max-depth=1 / 2>/dev/null | sort -rh | head
```

第三步：逐层定位大文件。

```bash
find /var -type f -size +1G -ls
```

第四步：检查删除但仍被进程打开的文件。

```bash
lsof +L1
```

第五步：根据实际情况清理日志、缓存或临时文件。

**问题4：df 显示磁盘满了，但 du 统计出来的空间很小，为什么？**

参考回答：

常见原因是文件已经删除，但仍然被某个进程打开。

虽然目录中已经看不到文件，但进程仍然持有文件描述符，文件占用的磁盘空间不会立即释放。

排查：

```bash
lsof +L1
```

处理时可以根据业务情况重启或重新打开文件的进程。对于确认可以丢弃的日志文件，也可以通过对应的 `/proc/<PID>/fd/<FD>` 文件描述符处理，但必须谨慎操作，不能对未知文件直接截断。

**问题5：磁盘 inode 耗尽怎么办？**

参考回答：

通过 `df -i` 确认 inode 使用率，再逐层统计目录下的小文件数量，找到文件大量堆积的位置。

常见原因：

- 应用日志碎片。
- PHP Session 文件。
- 临时文件未清理。
- 缓存文件持续累积。

处理时应清理确认无用的文件，并增加自动过期清理机制。

**问题6：UUID 挂载有什么好处？**

参考回答：

设备名 `/dev/sda1` 可能因设备识别顺序变化而改变，使用 UUID 可以更稳定地识别文件系统，降低开机挂载错误的风险。

---

# 第六章：LVM、RAID 与文件系统故障处理

## 6.1 LVM 基础知识

LVM（Logical Volume Manager）是 Linux 逻辑卷管理机制。

主要由三个核心部分组成：

| 层级 | 名称 | 作用 | 常见命令 |
|---|---|---|---|
| PV | Physical Volume | 物理卷 | pvcreate、pvs |
| VG | Volume Group | 卷组 | vgcreate、vgs |
| LV | Logical Volume | 逻辑卷 | lvcreate、lvs |

结构：

```text
物理磁盘 / 分区
       |
       v
      PV
       |
       v
      VG
       |
       v
      LV
       |
       v
    文件系统
       |
       v
     挂载点
```

### 6.1.1 创建 LVM

```bash
# 1. 创建 PV
pvcreate /dev/sdb /dev/sdc

# 2. 创建 VG
vgcreate vg_data /dev/sdb /dev/sdc

# 3. 创建 LV
lvcreate -L 100G -n lv_app vg_data

# 4. 格式化
mkfs.xfs /dev/vg_data/lv_app

# 5. 创建挂载点
mkdir -p /data

# 6. 挂载
mount /dev/vg_data/lv_app /data

# 7. 查看 LVM 状态
pvs
vgs
lvs
```

### 6.1.2 LVM 扩容

扩容核心流程：

**底层设备 → PV → VG → LV → 文件系统**

```bash
# 查看当前容量
pvs
vgs
lvs

# 如果底层磁盘扩容了，刷新 PV 容量
pvresize /dev/sdb

# 如果增加了新磁盘
pvcreate /dev/sdc
vgextend vg_data /dev/sdc

# 扩大逻辑卷
lvextend -L +50G /dev/vg_data/lv_app

# XFS 文件系统扩容
xfs_growfs /data

# ext4 文件系统扩容
resize2fs /dev/vg_data/lv_app

# 查看最终容量
df -h
```

注意：

- `pvresize` 用于让 PV 识别底层设备已经增加的容量。
- `vgextend` 用于向 VG 添加新的 PV。
- XFS 通常支持在线扩容，但不支持缩小。
- ext4 可以在卸载状态下缩小，具体操作必须先进行文件系统检查。

## 6.2 RAID 基础知识

RAID 是磁盘冗余阵列技术，主要用于提高存储性能、可靠性或容量利用率。

| RAID | 最少磁盘数 | 容错能力 | 可用容量 | 特点 |
|---|---:|---|---|---|
| RAID 0 | 2 | 无 | N 块盘总容量 | 条带化，性能高 |
| RAID 1 | 2 | 可容忍 1 块故障 | 约 50% | 镜像 |
| RAID 5 | 3 | 可容忍 1 块故障 | (N-1) 块盘容量 | 分布式奇偶校验 |
| RAID 6 | 4 | 可容忍 2 块故障 | (N-2) 块盘容量 | 双重奇偶校验 |
| RAID 10 | 4 | 每组镜像可坏 1 块 | 约 50% | 镜像加条带化 |

注意：RAID 10 如果同一镜像组中的两块盘同时损坏，仍然可能丢失数据。RAID 不能代替备份。

### 6.2.1 常见 RAID 工具

```bash
# 查看软件 RAID 状态
cat /proc/mdstat

# 查看 RAID 详细信息
mdadm --detail /dev/md0

# 查看磁盘
lsblk
```

## 6.3 文件系统基础知识

### 6.3.1 ext4 和 XFS 的区别

| 对比 | ext4 | XFS |
|---|---|---|
| 类型 | 日志文件系统 | 日志文件系统 |
| 特点 | 通用、成熟 | 适合大容量、高并发场景 |
| 在线扩容 | 支持 | 支持 |
| 在线缩容 | 不支持 | 不支持 |
| 离线缩容 | 支持 | 不支持 |
| 检查工具 | e2fsck | xfs_repair |

### 6.3.2 文件系统损坏的处理原则

**第一步：确认问题**

```bash
dmesg -T | tail -n 100
journalctl -k -p err
```

检查是否存在：

- I/O error。
- 文件系统元数据损坏。
- 磁盘设备异常。
- 文件系统自动切换为只读。

**第二步：保护数据**

如果文件系统还能读取，应优先备份重要数据。

如果怀疑底层磁盘存在硬件故障，应优先考虑制作磁盘镜像或使用专业恢复方案，避免反复读写原盘。

**第三步：离线修复**

对于根文件系统或无法卸载的分区，应进入救援模式。

ext4：

```bash
umount /dev/sdX1

# 检查文件系统
e2fsck -f /dev/sdX1

# 确认修复方案后执行
e2fsck -f -y /dev/sdX1
```

XFS：

```bash
umount /dev/sdX1

# 只检查，不修改
xfs_repair -n /dev/sdX1

# 执行修复
xfs_repair /dev/sdX1
```

注意：`xfs_repair -L` 会清除日志，可能造成元数据丢失，只能在必要且评估风险后使用。

**第四步：修复验证**

```bash
mount /dev/sdX1 /mnt
dmesg -T | tail
df -h
```

检查文件系统是否能够正常挂载和读写。

## 6.4 面试问题

**问题1：什么是 LVM？**

参考回答：

LVM 是 Linux 逻辑卷管理机制，可以将多个物理卷组成一个卷组，再从卷组中划分逻辑卷，实现灵活的容量管理和扩容。

**问题2：LVM 扩容需要经过哪些步骤？**

参考回答：

首先确认底层磁盘容量是否增加，然后根据情况执行 pvresize 或 pvcreate、vgextend，接着扩展 LV，最后扩展文件系统，使用 df -h 验证。

**问题3：RAID 0、1、5、6、10 有什么区别？**

参考回答：

RAID 0 侧重性能，没有冗余；RAID 1 使用镜像提高可靠性；RAID 5 使用单校验，允许一块磁盘损坏；RAID 6 使用双校验，允许两块磁盘损坏；RAID 10 结合镜像和条带化，兼顾性能和可靠性。

**问题4：XFS 和 ext4 有什么区别？**

参考回答：

两者都是 Linux 常见日志文件系统。ext4 通用性较强，支持离线缩容；XFS 在大文件和高容量场景中应用广泛，支持在线扩容，但不支持缩容。

**问题5：文件系统损坏如何处理？**

参考回答：

首先通过 dmesg 和 journalctl 确认错误类型，再判断是否存在底层磁盘故障。尽可能备份数据，进入救援环境卸载文件系统，然后根据文件系统类型使用 e2fsck 或 xfs_repair 修复，最后重新挂载验证。

**问题6：Linux 删除文件后还能恢复吗？**

参考回答：

能否恢复取决于文件系统类型、删除后的写入情况以及是否存在备份。

- ext4：可以尝试专业恢复工具，例如 extundelete，但不保证成功。
- XFS：通常依赖备份、快照或专业数据恢复工具，不应简单认为一定无法恢复。
- 文件仍被进程打开：可以通过 `/proc/<PID>/fd/<FD>` 尝试复制文件内容。

示例：

```bash
# 查找被删除但仍打开的文件
lsof | grep deleted

# 从进程文件描述符复制内容
cp /proc/<PID>/fd/<FD> /tmp/recovered_file
```

注意：恢复前应尽量停止对原文件系统的写入。恢复文件必须写到其他磁盘，不能写回原分区。

---

# 第七章：磁盘 I/O 性能排查

## 7.1 基础知识

### 7.1.1 什么是 IOPS？

IOPS 表示每秒完成的磁盘 I/O 操作次数。

主要用于衡量随机读写性能。

### 7.1.2 什么是吞吐量？

吞吐量表示单位时间内磁盘读写的数据量。

例如：

- MB/s。
- KB/s。

主要用于衡量连续读写性能。

### 7.1.3 常见 I/O 指标

| 指标 | 含义 |
|---|---|
| r/s | 每秒读取次数 |
| w/s | 每秒写入次数 |
| rkB/s | 每秒读取数据量 |
| wkB/s | 每秒写入数据量 |
| await | I/O 平均等待及处理时间 |
| aqu-sz | 平均 I/O 队列长度 |
| %util | 设备处于忙碌状态的时间比例 |

重点：

- await 高：I/O 响应时间较长。
- aqu-sz 高：可能存在请求积压。
- %util 高：设备持续繁忙，但不能单独判断现代 SSD/NVMe 是否饱和。

对于 NVMe 等支持并行处理的设备，不能简单地将 `%util=100%` 等同于性能耗尽。

## 7.2 常用命令

### 7.2.1 iostat

```bash
# 每秒查看一次，连续 5 次
iostat -xz 1 5
```

主要用于观察：

- 磁盘读写速率。
- IOPS。
- await。
- aqu-sz。
- %util。

### 7.2.2 iotop

```bash
# 只显示正在产生 I/O 的进程
iotop -o
```

用于定位具体进程的磁盘读写行为。

### 7.2.3 pidstat

```bash
# 查看进程磁盘 I/O
pidstat -d 2

# 查看指定进程磁盘 I/O
pidstat -d -p <PID> 2
```

## 7.3 面试问题

**问题1：如何排查 Linux 磁盘 I/O 性能问题？**

参考回答：

首先使用 iostat 查看磁盘整体 I/O 情况，重点观察 await、aqu-sz 和 %util。

如果发现磁盘响应时间明显升高，再使用 iotop 或 pidstat 定位具体进程，判断是否存在大量读写。

最后结合业务日志、磁盘类型和文件系统状态进行分析。

**问题2：iostat 和 iotop 有什么区别？**

参考回答：

iostat 主要查看磁盘设备层面的整体 I/O 指标，iotop 主要查看具体进程的 I/O 活动。

**问题3：磁盘 %util 达到 100% 是否说明磁盘已经饱和？**

参考回答：

不一定。对于机械硬盘，接近 100% 通常意味着设备持续繁忙；对于 SSD 和 NVMe，可能仍然存在并行处理能力，需要结合 await、aqu-sz、IOPS 和吞吐量判断。

**问题4：磁盘 await 很高，如何进一步定位？**

```bash
iostat -xz 1
iotop -o
pidstat -d 2
```

根据结果判断是业务读写、备份任务、日志写入还是设备自身性能问题。

---

# 第八章：Linux 网络基础与故障排查

## 8.1 基础知识

### 8.1.1 TCP/IP 网络分层

| 层级 | 主要作用 | 常见协议 |
|---|---|---|
| 应用层 | 应用数据交互 | HTTP、HTTPS、DNS、SSH |
| 传输层 | 端到端通信 | TCP、UDP |
| 网络层 | IP 寻址和路由 | IP、ICMP |
| 链路层 | 同网段数据交付 | Ethernet、ARP、VLAN |

网络通信的基本过程：

1. DNS 将域名解析为 IP 地址。
2. 路由表决定数据包的下一跳。
3. ARP 或 IPv6 邻居发现机制获取下一跳链路层地址。
4. 通过链路层发送数据。
5. TCP 或 UDP 负责传输层通信。
6. 应用层完成业务交互。

### 8.1.2 IP 地址和子网掩码

IP 地址用于标识网络中的主机。

例如：

```text
192.168.1.100/24
```

其中：

- IP 地址：192.168.1.100
- 网络前缀长度：24
- 子网掩码：255.255.255.0

### 8.1.3 路由

路由决定数据包应该从哪个网络接口发送，以及下一跳地址是什么。

常见类型：

- 直连路由。
- 静态路由。
- 默认路由。
- 策略路由。

### 8.1.4 DNS

DNS 用于将域名解析为 IP 地址。

例如：

```text
www.example.com
       |
       v
DNS 查询
       |
       v
192.0.2.10
```

### 8.1.5 TCP 和 UDP

| 对比 | TCP | UDP |
|---|---|---|
| 连接 | 面向连接 | 无连接 |
| 可靠性 | 提供可靠、有序传输 | 不保证可靠交付 |
| 握手 | 三次握手 | 无连接握手 |
| 流量控制 | 支持 | 不提供 TCP 式流量控制 |
| 应用 | HTTP、SSH、数据库连接 | DNS、实时音视频等 |

### 8.1.6 TCP 三次握手

```text
客户端                  服务端

  SYN       --------->

            <--------- SYN + ACK

  ACK       --------->

        连接建立
```

第一次握手：客户端发送 SYN
- 客户端向服务端发送 SYN 报文。
- 表示客户端请求建立 TCP 连接。
- 客户端进入 SYN_SENT 状态。
第二次握手：服务端发送 SYN + ACK
- 服务端收到 SYN 后，回复 SYN + ACK 报文。
- SYN 表示服务端同意建立连接，并发送自己的初始序列号。
- ACK 表示确认收到了客户端的 SYN。
- 服务端进入 SYN_RCVD 状态。
第三次握手：客户端发送 ACK
- 客户端收到服务端的 SYN + ACK 后，发送 ACK 确认报文。
- 服务端收到 ACK 后，确认连接建立。
- 客户端和服务端进入 ESTABLISHED 状态，可以开始传输数据。

为什么需要三次握手，而不是两次？
核心原因是：三次握手能够让双方确认彼此的发送和接收能力，并完成初始序列号的同步。
假设只有两次握手：
1. 客户端发送 SYN，服务端收到。
2. 服务端回复 SYN + ACK。
此时服务端无法确认客户端是否成功收到自己的响应，因此还需要客户端再发送一次 ACK，让服务端确认客户端已经收到服务端的 SYN + ACK，三次握手可以完成双方连接建立前的确认。
SYN	Synchronize	同步	请求建立连接，并同步双方的初始序列号
ACK	Acknowledgment	确认	确认已经成功接收到对方发送的数据或报文

为什么会有四次挥手呢？
TCP 是全双工通信协议，客户端和服务端都可以独立发送和接收数据。
当客户端不需要继续发送数据时，会发送 FIN 报文，表示主动关闭自己的发送方向。
服务端收到 FIN 后，先回复 ACK，确认收到关闭请求。但是服务端可能还有数据没有发送完成，因此不能立即关闭连接。
等服务端数据发送完成后，再发送 FIN，通知客户端关闭服务端的发送方向。
最后客户端回复 ACK，双方完成连接关闭。
因为 TCP 的两个通信方向需要分别关闭，所以通常需要四次挥手。


### 8.1.7 MTU

MTU 是网络接口能够承载的最大三层数据包长度，常见以太网 MTU 为 1500 字节。

当路径 MTU 不匹配时，可能出现：

- 小包正常，大包异常。
- 部分业务访问缓慢。
- TCP 重传。
- 大文件传输失败。

### 8.1.8 Bond 网络

Bond 是 Linux 网络链路聚合机制，可以将多块物理网卡组合成一个逻辑接口。

常见模式：

| 模式 | 名称 | 特点 |
|---|---|---|
| 0 | balance-rr | 轮询发送 |
| 1 | active-backup | 主备模式 |
| 2 | balance-xor | 基于哈希 |
| 3 | broadcast | 广播模式 |
| 4 | 802.3ad | LACP 动态聚合 |
| 5 | balance-tlb | 自适应发送负载均衡 |
| 6 | balance-alb | 自适应收发负载均衡 |

重点：

- Mode 1：主备模式，一块网卡工作，另一块作为备用。
- Mode 4：LACP 模式，需要交换机配合配置链路聚合。

## 8.2 网络常用命令

### 8.2.1 ip addr

```bash
# 查看所有 IP 地址
ip addr show

# 查看指定网卡
ip addr show eth0

# 添加 IP
ip addr add 192.168.1.100/24 dev eth0

# 删除 IP
ip addr del 192.168.1.100/24 dev eth0
```

### 8.2.2 ip link

```bash
# 查看网卡状态
ip link show

# 启用网卡
ip link set eth0 up

# 关闭网卡
ip link set eth0 down

# 查看详细链路属性
ip -d link show eth0
```

### 8.2.3 ip route

```bash
# 查看路由表
ip route show

# 查看到目标 IP 的实际路由
ip route get 8.8.8.8

# 添加默认路由
ip route add default via 192.168.1.1 dev eth0

# 删除默认路由
ip route del default
```

### 8.2.4 ip rule

```bash
# 查看策略路由规则
ip rule show

# 添加策略路由规则
ip rule add from 192.168.1.50 table 100 priority 100

# 删除规则
ip rule del from 192.168.1.50 table 100
```

### 8.2.5 ip neigh

```bash
# 查看 ARP/邻居表
ip neigh show

# 查看指定网卡邻居表
ip neigh show dev eth0

# 清空指定网卡邻居缓存
ip neigh flush dev eth0
```

### 8.2.6 ss

```bash
# 查看 TCP/UDP 监听端口
ss -lntup

# 查看 TCP 连接
ss -tnp

# 查看已建立连接
ss -tnp state established

# 查看连接统计
ss -s
```

### 8.2.7 DNS 查询

```bash
# 查询域名
dig example.com

# 简洁输出
dig +short example.com

# 指定 DNS 服务器
dig @8.8.8.8 example.com

# 查看 DNS 配置
cat /etc/resolv.conf

# 查看 systemd-resolved 状态
resolvectl status
```

注意：`resolvectl` 仅适用于使用 systemd-resolved 的系统。

### 8.2.8 MTU 测试

```bash
# 测试 MTU 1500
ping -M do -s 1472 192.168.1.1

# 测试较小的 MTU
ping -M do -s 1400 192.168.1.1
```

计算：

```text
1472 字节 ICMP 数据
+ 8 字节 ICMP 头
+ 20 字节 IPv4 头
= 1500 字节
```

注意：IPv6 的头部长度不同，不能直接套用这个计算方式。

### 8.2.9 tcpdump 抓包

```bash
# 抓取指定端口
tcpdump -ni eth0 port 80

# 抓取指定 IP
tcpdump -ni any host 192.168.1.100

# 抓取 DNS
tcpdump -ni eth0 port 53

# 抓取 ICMP
tcpdump -ni eth0 icmp

# 保存抓包文件
tcpdump -ni eth0 -s 0 -w /tmp/cap.pcap port 443

# 抓取指定数量的数据包
tcpdump -ni eth0 -c 20 port 80
```

## 8.3 网络管理工具

### 8.3.1 ip 命令临时配置

```bash
# 添加 IP
ip addr add 192.168.1.100/24 dev eth0

# 添加网关
ip route add default via 192.168.1.1

# 删除 IP
ip addr del 192.168.1.100/24 dev eth0
```

注意：ip 命令修改通常只对当前运行状态有效，重启后不一定保留。

### 8.3.2 NetworkManager / nmcli

```bash
# 查看连接
nmcli connection show

# 创建静态 IP 配置
nmcli connection modify eth0 \
ipv4.method manual \
ipv4.addresses 192.168.1.100/24 \
ipv4.gateway 192.168.1.1 \
ipv4.dns "8.8.8.8"

# 重新激活连接
nmcli connection up eth0

# 查看设备状态
nmcli device status
```

注意：这里的 eth0 应替换成实际连接名称，连接名称不一定与网卡设备名称相同。

### 8.3.3 Netplan

Ubuntu 等使用 Netplan 的系统可以通过 YAML 文件配置网络。

配置示例：

```yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: false
      addresses:
        - 192.168.1.100/24
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
```

应用：

```bash
netplan apply
```

### 8.3.4 Debian / Ubuntu ifupdown

部分 Debian 系统使用 `/etc/network/interfaces`。

```text
auto eth0
iface eth0 inet static
    address 192.168.1.100
    netmask 255.255.255.0
    gateway 192.168.1.1
```

### 8.3.5 RHEL 系网络配置

较新的 RHEL 系发行版通常使用 NetworkManager。

部分旧版本仍使用：

```text
/etc/sysconfig/network-scripts/ifcfg-eth0
```

常见字段：

```text
BOOTPROTO=none
ONBOOT=yes
IPADDR=192.168.1.100
PREFIX=24
GATEWAY=192.168.1.1
DNS1=8.8.8.8
```

旧版配置方式不应直接套用到所有新版本。

## 8.4 Bond 配置

### 8.4.1 使用 nmcli 创建 Bond

```bash
# 创建 bond0，采用主备模式
nmcli connection add type bond \
con-name bond0 \
ifname bond0 \
bond.options "mode=active-backup,miimon=100"

# 配置 IP
nmcli connection modify bond0 \
ipv4.method manual \
ipv4.addresses 192.168.1.100/24 \
ipv4.gateway 192.168.1.1

# 添加物理网卡
nmcli connection add type ethernet \
con-name bond0-slave-eth0 \
ifname eth0 \
master bond0

nmcli connection add type ethernet \
con-name bond0-slave-eth1 \
ifname eth1 \
master bond0

# 激活连接
nmcli connection up bond0
nmcli connection up bond0-slave-eth0
nmcli connection up bond0-slave-eth1

# 查看 Bond 状态
cat /proc/net/bonding/bond0
```

### 8.4.2 LACP 模式

```bash
nmcli connection add type bond \
con-name bond0 \
ifname bond0 \
bond.options "mode=802.3ad,miimon=100"
```

LACP 模式通常需要交换机侧配置对应的链路聚合组。

## 8.5 网络丢包排查

### 8.5.1 第一步：检查网卡状态

```bash
# 查看 IP
ip addr show

# 查看链路状态
ip link show

# 查看接口统计
ip -s link show eth0

# 查看网卡详细统计
ethtool -S eth0

# 查看速率和双工
ethtool eth0
```

重点检查：

- 网卡是否 UP。
- 是否存在 RX/TX errors。
- 是否存在 dropped。
- 网卡速率是否正确。
- 是否存在 CRC 错误。

### 8.5.2 第二步：分段测试网络

```bash
# 测试本地网关
ping -c 100 <网关IP>

# 测试外部 IP
ping -c 100 8.8.8.8

# 追踪路由
traceroute -n 8.8.8.8
```

如果网关都无法连通，优先排查本地网络、网卡、VLAN 和网关配置。

如果网关正常但外部访问异常，则继续检查路由、出口网络和 DNS。

### 8.5.3 第三步：检查网络路径

```bash
# 安装 mtr 后执行
mtr -rwzc 100 8.8.8.8
```

注意：中间路由节点可能对 ICMP 限速，因此单纯看到中间某一跳丢包，不代表实际转发业务流量也丢包。应结合最终目标及 TCP 测试判断。

### 8.5.4 第四步：检查带宽占用

```bash
# 查看实时网络流量
iftop -i eth0

# 查看进程网络流量
nethogs eth0

# 查看 TCP 连接状态
ss -s
```

### 8.5.5 第五步：抓包分析

```bash
# 抓取指定目标 TCP 流量
tcpdump -ni eth0 host <目标IP> and tcp \
-w /tmp/network.pcap
```

使用 Wireshark 检查：

- TCP 重传。
- TCP 三次握手异常。
- RST 连接重置。
- MTU 和分片相关问题。

### 8.5.6 第六步：检查网卡硬件

```bash
# 查看网卡信息
ethtool eth0

# 查看驱动信息
ethtool -i eth0

# 查看 CRC 错误
ethtool -S eth0 | grep -i crc

# 查看丢包和错误统计
ip -s link show eth0
```

如果 CRC 错误持续增长，可能是网线、光模块、交换机端口或物理链路问题。

## 8.6 面试问题

**问题1：Linux 网络无法访问，如何排查？**

参考回答：

我会按照从底层到上层的顺序排查：

1. 检查网卡是否 UP，IP 地址是否正确。
2. 检查子网掩码、网关和路由表。
3. 检查 ARP 邻居表。
4. ping 网关，确认本地网络连通性。
5. ping 目标 IP，排查网络路径。
6. 使用 dig 检查 DNS。
7. 使用 ss 检查端口和 TCP 连接。
8. 必要时使用 tcpdump 抓包分析。

**问题2：如何查看 Linux 监听端口？**

```bash
ss -lntup
```

**问题3：如何查看 TCP 已建立的连接？**

```bash
ss -tnp state established
```

**问题4：如何判断 DNS 是否正常？**

```bash
dig example.com
dig +short example.com
cat /etc/resolv.conf
```

**问题5：如何查看网卡是否存在丢包？**

```bash
ip -s link show eth0
ethtool -S eth0
```

重点关注 RX/TX errors、dropped 和 CRC 错误。

**问题6：TCP 和 UDP 有什么区别？**

参考回答：

TCP 是面向连接的可靠传输协议，具有确认、重传、流量控制和拥塞控制等机制。UDP 是无连接协议，开销较小，不保证数据一定送达，适合实时性要求较高的应用场景。

**问题7：Bond Mode 1 和 Mode 4 有什么区别？**

参考回答：

Mode 1 是主备模式，主要用于链路故障切换；Mode 4 是 LACP 动态链路聚合，可以利用多条链路进行负载分担，但通常需要交换机配合配置。

**问题8：网络小包正常，大包异常，可能是什么原因？**

参考回答：

可能是路径 MTU 不匹配、分片受限、防火墙过滤或 PMTUD 异常。可以使用禁止分片的 ping 测试逐步定位可通过的最大数据包长度。

**问题9：tcpdump 有什么作用？**

参考回答：

tcpdump 是网络抓包工具，可以捕获指定网卡上的网络数据包，通过 IP、端口、协议等条件进行过滤，并保存为 pcap 文件供 Wireshark 分析。

---


# 第九章:Linux 日志管理与故障排查

日志管理是 Linux 系统运维的核心技能之一。排查服务器启动失败、服务异常、CPU 或内存问题、磁盘故障、网络异常时，都需要通过日志还原故障发生的时间、过程和原因。

### 1. 什么是 Linux 日志？
Linux 日志是系统、内核、服务程序和应用程序运行过程中产生的记录。
日志通常包含以下信息：

| 信息     | 说明       | 示例                  |
| ------ | -------- | ------------------- |
| 时间     | 事件发生时间   | 2026-11-03 10:30:00 |
| 主机名    | 产生日志的主机  | server01            |
| 服务名    | 产生日志的程序  | sshd、nginx          |
| 进程 PID | 产生日志的进程号 | sshd[1234]          |
| 日志级别   | 事件严重程度   | error、warning       |
| 日志内容   | 具体事件     | Failed password     |

### 2. Linux 日志的主要来源
可以将 Linux 日志分成四类：
| 类型   | 主要内容                 | 常用查看方式               |
| ---- | -------------------- | -------------------- |
| 系统日志 | 系统服务、登录、计划任务等        | journalctl、/var/log  |
| 内核日志 | 驱动、硬件、内存、磁盘、网络等      | dmesg、journalctl -k  |
| 服务日志 | SSH、Nginx、数据库等服务运行情况 | journalctl -u、服务自身日志 |
| 应用日志 | 业务程序运行、异常、请求记录       | 应用指定日志文件             |

### 3. 常见日志级别
Linux syslog 和 journald 使用的日志级别通常如下：

| 级别      | 数值 | 含义         |
| ------- | -- | ---------- |
| emerg   | 0  | 系统不可用      |
| alert   | 1  | 必须立即处理     |
| crit    | 2  | 严重错误       |
| err     | 3  | 错误         |
| warning | 4  | 警告         |
| notice  | 5  | 正常但值得关注的事件 |
| info    | 6  | 一般信息       |
| debug   | 7  | 调试信息       |

数字越小，严重程度越高。
例如：排查服务异常时，可以优先检索 `err`、`crit`、`alert` 等级别的日志，但不要只看错误级别，因为有些故障的前置线索可能记录为 warning 或 info。

### 4. 基础知识

`journalctl` 是 systemd 提供的日志查询工具，用于读取 systemd-journald 收集的日志。

它可以查看：
- 系统启动过程和启动失败记录。
- systemd 服务运行日志。
- 内核日志。
- 指定时间段内的系统事件。
- 指定进程、用户或优先级的日志。

常见日志存储位置：

```
/run/log/journal/
```

或者：

```
/var/log/journal/
```

具体取决于 journald 的持久化配置。

### 5. 常用命令

| 命令                        | 作用                |
| ------------------------- | ----------------- |
| `journalctl`              | 查看全部可访问的日志        |
| `journalctl -b`           | 查看本次启动日志          |
| `journalctl -b -1`        | 查看上一次启动日志         |
| `journalctl -k`           | 查看内核日志            |
| `journalctl -u sshd`      | 查看 sshd 服务日志      |
| `journalctl -u nginx`     | 查看 nginx 服务日志     |
| `journalctl -f`           | 实时跟踪日志            |
| `journalctl -n 100`       | 查看最后 100 行        |
| `journalctl -p err`       | 查看错误及更严重级别的日志     |
| `journalctl -xe`          | 查看近期日志并显示解释性信息    |
| `journalctl --disk-usage` | 查看 journal 日志占用空间 |

注意：`journalctl -xe` 并不等同于只显示错误日志，排查时最好结合 `-p`、`-u`、时间范围等参数。

### 6. 按时间段检索日志

这是运维面试和实际故障排查中的重点。

```
# 查看今天的日志
journalctl --since today

# 查看最近一小时日志
journalctl --since "1 hour ago"

# 查看指定日期日志
journalctl --since "2026-11-03 09:00:00" \
           --until "2026-11-03 10:00:00"

# 查看最近10分钟的日志
journalctl --since "10 minutes ago"

# 查看指定服务在某个时间段的日志
journalctl -u nginx \
           --since "2026-11-03 09:00:00" \
           --until "2026-11-03 10:00:00"
```

### 7. 按服务和进程检索

```
# 查看 SSH 服务日志
journalctl -u sshd

# 查看 Nginx 服务日志
journalctl -u nginx

# 实时查看 Nginx 日志
journalctl -u nginx -f

# 查看指定 PID 的日志
journalctl _PID=1234

# 查看指定用户的日志
journalctl _UID=1000

# 查看指定服务最近100条日志
journalctl -u nginx -n 100
```

注意：Ubuntu 中 SSH 服务单元名称常见为 `ssh`，RHEL 系系统常见为 `sshd`，以 `systemctl list-units` 的实际结果为准。

### 5. 按日志级别过滤

```
# 查看错误级别及更严重日志
journalctl -p err

# 查看警告及更严重日志
journalctl -p warning

# 查看本次启动中的错误日志
journalctl -b -p err

# 查看指定服务的错误日志
journalctl -u nginx -p err
```

### 6. journalctl 综合排查案例

场景：服务器上的 Nginx 突然无法访问。

第一步：检查服务状态。

```
systemctl status nginx
```

第二步：查看近期服务日志。

```
journalctl -u nginx -n 100
```

第三步：查看故障时间段内的日志。

```
journalctl -u nginx \
  --since "2026-11-03 09:00:00" \
  --until "2026-11-03 10:00:00"
```

第四步：筛选错误日志。

```
journalctl -u nginx -p err
```

第五步：检查服务启动和配置问题。

```
nginx -t
systemctl status nginx
ss -lntp | grep ':80'
```
。

### 7. rsyslog

`rsyslog` 是 Linux 常见的系统日志服务，负责接收、过滤、分类和写入日志。

它与 `systemd-journald` 的区别：

| 对比     | systemd-journald                | rsyslog             |
| ------ | ------------------------------- | ------------------- |
| 主要用途   | 收集系统、服务、内核日志                    | 收集、筛选、转发和保存日志       |
| 查询工具   | journalctl                      | cat、less、grep、tail  |
| 常见存储   | journal 二进制日志                   | `/var/log` 下的文本日志   |
| 配置文件   | `/etc/systemd/journald.conf`    | `/etc/rsyslog.conf` |
| 常见配置目录 | `/etc/systemd/journald.conf.d/` | `/etc/rsyslog.d/`   |

两者可以同时运行。某些系统由 journald 收集日志，再通过配置转发给 rsyslog，最终写入 `/var/log`。具体链路取决于发行版和配置。

[image](https://www.google.com/s2/favicons?domain=https://docs.rsyslog.com\&sz=32)

rsyslog 8 daily stable documentation+2



### 8. 检查 rsyslog 服务

```
# 查看服务状态
systemctl status rsyslog

# 查看是否开机启动
systemctl is-enabled rsyslog

# 启动服务
systemctl start rsyslog

# 设置开机启动
systemctl enable rsyslog

# 重启服务
systemctl restart rsyslog

# 查看 rsyslog 自身运行日志
journalctl -u rsyslog -n 100
```

注意：不是所有 Linux 系统都默认安装或启用 rsyslog。即使没有 rsyslog，systemd-journald 仍然可以收集系统日志。

### 9. rsyslog 配置文件

主要配置文件：

```
/etc/rsyslog.conf
```

扩展配置目录：

```
/etc/rsyslog.d/
```

查看配置：

```
cat /etc/rsyslog.conf

ls -l /etc/rsyslog.d/
```

rsyslog 配置常见格式：

```
facility.priority    action
```

其中：

- facility：日志来源类别。
- priority：日志级别。
- action：日志保存位置或转发目标。

常见 facility：

| facility        | 含义          |
| --------------- | ----------- |
| auth / authpriv | 身份认证、安全相关日志 |
| cron            | 定时任务日志      |
| kern            | 内核日志        |
| mail            | 邮件服务日志      |
| daemon          | 系统守护进程日志    |
| user            | 用户进程日志      |
| local0～local7   | 自定义日志类别     |

例如：

```
# 将认证相关日志保存到 auth.log
auth,authpriv.*    /var/log/auth.log

# 将 cron 日志保存到 cron.log
cron.*             /var/log/cron.log

# 将所有错误及更严重级别的日志保存到 error.log
*.err              /var/log/error.log
```

这里的 `*` 表示所有级别，`*.err` 表示 err 及比 err 更严重的级别。

注意：上面是配置示例，不代表每个发行版都采用这些日志文件名称。修改后应检查配置语法，并确认实际日志是否写入目标文件。

### 10. 自定义 rsyslog 日志分类

例如，想把某个业务程序的日志单独保存到：

```
/var/log/myapp.log
```

可以创建：

```
vim /etc/rsyslog.d/30-myapp.conf
```

添加：

```
# 将 local0 类别的日志写入指定文件
local0.*    /var/log/myapp.log
```

重启服务：

```
systemctl restart rsyslog
```

可以通过 logger 测试：

```
logger -p local0.info "myapp test log"
```

检查日志：

```
tail -f /var/log/myapp.log
```

如果没有写入，检查 rsyslog 配置、服务状态、日志输入链路和文件权限。


### 11. dmesg

`dmesg` 用于读取 Linux 内核环形缓冲区中的日志。

主要用于排查：

- 磁盘和文件系统错误。
- 内存不足和 OOM。
- CPU、硬件和驱动异常。
- 网卡、网络驱动问题。
- 内核崩溃、Call Trace、Kernel Warning。
- 设备识别失败。

它与 `journalctl` 的区别：

- `dmesg`：主要查看内核消息缓冲区。
- `journalctl -k`：查看 journald 收集的内核日志，支持按时间和启动记录过滤。

### 12. 常用命令

```
# 查看全部内核日志
dmesg

# 查看带可读时间戳的日志
dmesg -T

# 查看最近50行
dmesg | tail -n 50

# 实时查看内核日志
dmesg -w

# 查看错误和警告
dmesg -T | grep -i -E "error|fail|warning"

# 查看磁盘相关日志
dmesg -T | grep -i -E "disk|I/O error|blk|xfs|ext4"

# 查看内存和 OOM 相关日志
dmesg -T | grep -i -E "memory|oom|killed process"

# 查看网卡和驱动日志
dmesg -T | grep -i -E "eth|ens|link is|firmware"
```

### 3. 重点关注的内核日志

| 日志关键词                     | 可能的问题           | 排查方向           |
| ------------------------- | --------------- | -------------- |
| `Out of memory`           | 内存不足            | free、ps、OOM 日志 |
| `Killed process`          | OOM Killer 杀死进程 | 检查进程内存使用       |
| `I/O error`               | 存储 I/O 异常       | 磁盘、控制器、存储链路    |
| `XFS metadata corruption` | XFS 元数据损坏       | 文件系统检查与修复      |
| `EXT4-fs error`           | ext4 文件系统异常     | 检查文件系统和磁盘      |
| `Call Trace`              | 内核调用栈异常         | 分析内核日志和触发场景    |
| `NETDEV WATCHDOG`         | 网络设备发送队列超时      | 网卡驱动、链路、负载     |
| `link is down`            | 网络链路断开          | 网卡、交换机、网线、Bond |

### 13. 内核日志排查案例

场景：服务器突然出现磁盘 I/O 异常。

第一步：查看内核日志。

```
dmesg -T | grep -i -E "I/O error|blk_update|buffer I/O"
```

第二步：检查系统日志。

```
journalctl -k -p warning
```

第三步：检查磁盘设备。

```
lsblk
fdisk -l
```

第四步：查看磁盘 I/O 状态。

```
iostat -xz 1 5
```

第五步：检查文件系统和存储链路。

```
df -h
findmnt
```

如果确认文件系统损坏，不要直接在正在使用的文件系统上执行修复操作。先评估硬件状态并保护数据，再根据文件系统类型安排离线检查。

结合你之前遇到的 XFS 镜像损坏问题：

```
dmesg -T | grep -i xfs
```

可以快速定位 XFS 元数据损坏、inode 校验错误以及文件系统要求卸载并运行 `xfs_repair` 的提示。

### 15. 常见日志信息
`/var/log` 是 Linux 中常见的文本日志存放目录。
不同发行版、服务安装方式和日志配置会导致文件名称不同。例如 Ubuntu 常见 `/var/log/syslog`，RHEL 系系统常见 `/var/log/messages`。

| 日志文件                | 主要用途              | 排查场景           |
| ------------------- | ----------------- | -------------- |
| `/var/log/syslog`   | Ubuntu 等系统的综合系统日志 | 系统服务异常         |
| `/var/log/messages` | RHEL 系常见系统日志      | 系统运行异常         |
| `/var/log/auth.log` | Ubuntu 常见认证日志     | SSH 登录、sudo 认证 |
| `/var/log/secure`   | RHEL 系常见认证日志      | SSH 登录、权限认证    |
| `/var/log/kern.log` | 部分系统单独保存的内核日志     | 内核、驱动问题        |
| `/var/log/dmesg`    | 部分系统保存的启动内核日志     | 启动和硬件识别        |
| `/var/log/boot.log` | 部分系统的启动过程日志       | 开机服务启动失败       |
| `/var/log/cron`     | RHEL 系常见计划任务日志    | 定时任务未执行        |
| `/var/log/maillog`  | 邮件服务日志            | 邮件发送异常         |
| `/var/log/wtmp`     | 用户登录和退出记录，二进制格式   | 历史登录情况         |
| `/var/log/btmp`     | 失败登录记录，二进制格式      | 暴力破解排查         |
| `/var/log/lastlog`  | 用户最近一次登录记录        | 用户登录审计         |

注意：`wtmp`、`btmp`、`lastlog` 不是普通文本文件，不能直接用 `cat` 阅读。

对应命令：

```
# 查看历史登录记录
last

# 查看失败登录记录
lastb

# 查看用户最近登录信息
lastlog
```


### 16. 常见日志检索命令

```
# 查看日志
cat /var/log/syslog

# 分页查看
less /var/log/syslog

# 查看最后100行
tail -n 100 /var/log/syslog

# 实时跟踪
tail -f /var/log/syslog

# 实时跟踪多个文件
tail -f /var/log/syslog /var/log/auth.log

# 搜索错误信息
grep -i "error" /var/log/syslog

# 搜索多个关键字
grep -i -E "error|failed|warning" /var/log/syslog

# 显示匹配行号
grep -in "error" /var/log/syslog

# 查看包含关键字的上下文
grep -in -C 5 "error" /var/log/syslog

# 统计错误数量
grep -ic "error" /var/log/syslog
```

注意：日志可能已经被压缩轮转，`.gz` 文件可以使用：

```
zgrep -i "error" /var/log/syslog*.gz
```

### 17. 日志时间线排查

假设服务器在 10:30 出现故障，建议以故障时间为中心，向前和向后查看日志。

```
# 查看系统日志时间段
journalctl \
  --since "2026-11-03 10:20:00" \
  --until "2026-11-03 10:40:00"

# 查看内核日志时间段
journalctl -k \
  --since "2026-11-03 10:20:00" \
  --until "2026-11-03 10:40:00"

# 查看指定服务时间段
journalctl -u nginx \
  --since "2026-11-03 10:20:00" \
  --until "2026-11-03 10:40:00"
```

重点不是只找到一条 `error`，而是把故障发生前后的日志关联起来，找出最早出现的异常。


### 18. 为什么需要日志轮转？

假设一台服务器上的 Nginx 每天产生 2GB 日志。

如果一直向同一个文件写入：

```
/var/log/nginx/access.log
```

可能导致：

- 日志文件越来越大。
- 占满磁盘空间。
- 日志检索速度下降。
- 系统因磁盘空间不足出现异常。

因此需要日志轮转（Log Rotation）。

logrotate 的主要作用：

1. 定期切割日志文件。
2. 保留历史日志。
3. 压缩旧日志。
4. 删除超过保留期限或数量的日志。
5. 必要时通知服务重新打开日志文件。

它通常通过定时任务或 systemd timer 自动执行。

[image](https://www.google.com/s2/favicons?domain=https://www.man7.org\&sz=32)

Linux manual page+1



### 19. logrotate 的工作原理

假设当前有一个日志文件：

```
/var/log/myapp/app.log
```

经过日志轮转后，可能变成：

```
/var/log/myapp/app.log
/var/log/myapp/app.log.1
/var/log/myapp/app.log.2.gz
/var/log/myapp/app.log.3.gz
```

含义：

| 文件           | 作用        |
| ------------ | --------- |
| app.log      | 当前正在写入的日志 |
| app.log.1    | 上一次轮转的日志  |
| app.log.2.gz | 更早的压缩日志   |
| app.log.3.gz | 更早的压缩日志   |

### 20. logrotate 配置文件

主要配置文件：

```
/etc/logrotate.conf
```

应用程序独立配置目录：

```
/etc/logrotate.d/
```

查看配置：

```
cat /etc/logrotate.conf

ls -l /etc/logrotate.d/
```

通常主配置文件通过 `include` 引入 `/etc/logrotate.d/` 中的配置。

### 21. 常用配置参数

| 参数              | 作用                  |
| --------------- | ------------------- |
| `daily`         | 每天轮转                |
| `weekly`        | 每周轮转                |
| `monthly`       | 每月轮转                |
| `hourly`        | 每小时轮转，但执行调度也必须支持小时级 |
| `size 100M`     | 日志超过 100MB 时满足轮转条件  |
| `rotate 7`      | 保留 7 个轮转文件          |
| `compress`      | 压缩旧日志               |
| `delaycompress` | 延迟到下一次轮转再压缩         |
| `missingok`     | 日志文件不存在时不报错         |
| `notifempty`    | 空文件不轮转              |
| `dateext`       | 使用日期后缀命名            |
| `copytruncate`  | 复制日志后清空原文件          |
| `create`        | 轮转后创建新的日志文件         |
| `sharedscripts` | 同一配置段中的多个日志共用一次脚本执行 |
| `postrotate`    | 轮转完成后执行命令           |
| `endscript`     | 结束轮转脚本段             |

注意：`daily`、`weekly` 等是轮转频率，`size` 是大小条件。实际轮转还受到 logrotate 调度时间和状态文件的影响。

[image](https://www.google.com/s2/favicons?domain=https://www.man7.org\&sz=32)

Linux manual page+1



### 22. 实际配置一个业务日志轮转规则

假设业务程序的日志路径为：

```
/var/log/myapp/app.log
```

需求：

- 每天轮转一次。
- 保留 7 份历史日志。
- 压缩旧日志。
- 空日志不轮转。
- 轮转后创建新日志文件。

创建配置：

```
vim /etc/logrotate.d/myapp
```

写入：

```
/var/log/myapp/app.log {
    daily
    rotate 7

    missingok
    notifempty

    compress
    delaycompress

    dateext

    create 0640 root root
}
```

逐项解释：

```
daily
```

每天执行一次轮转。

```
rotate 7
```

最多保留 7 份轮转日志。

```
compress
```

压缩旧日志，通常使用 gzip。

```
delaycompress
```

最新轮转出来的历史日志暂不压缩，等下一次轮转再压缩。

```
dateext
```

使用日期后缀区分历史日志。

```
create 0640 root root
```

创建新的日志文件，权限为 640，所有者和所属组均为 root。

这里的 `root root` 只是示例。实际应根据业务程序运行用户、日志目录权限设置合适的属主和属组，不能盲目照搬。

### 23. 如果业务程序一直占用日志文件怎么办？

这是一个非常重要的实际问题。

假设 Nginx 正在向 `access.log` 写入日志。

如果 logrotate 直接重命名旧文件，Nginx 可能仍然持有原文件的文件描述符，继续向旧文件写入。

因此，需要让服务重新打开日志文件。

常见处理方法有两种：

方法一：postrotate 通知服务重新打开日志

例如 Nginx：

```
/var/log/nginx/*.log {
    daily
    rotate 14

    missingok
    notifempty

    compress
    delaycompress

    create 0640 www-data adm

    sharedscripts
    postrotate
        if systemctl is-active --quiet nginx; then
            systemctl kill -s USR1 nginx
        fi
    endscript
}
```

这里使用 Nginx 的 USR1 信号，让其重新打开日志文件。实际使用时，需要根据发行版、运行用户和 Nginx 配置调整属主、属组和信号处理方式。

方法二：使用 copytruncate

```
/var/log/myapp/app.log {
    daily
    rotate 7
    compress
    copytruncate
}
```

`copytruncate` 的工作方式：

1. 复制当前日志文件。
2. 清空原日志文件。
3. 应用程序继续向原文件写入。

它不需要通知应用程序重新打开日志，但复制与清空之间存在极短的时间窗口，可能丢失部分日志。因此，能让应用程序正确重新打开日志时，通常优先采用第一种方式。

### 24. 如何测试 logrotate 配置？

实际运维中，不建议直接修改完配置就强制执行。

先检查语法和执行计划：

```
# Debug 模式，不真正执行轮转
logrotate -d /etc/logrotate.conf
```

查看详细执行过程：

```
logrotate -v /etc/logrotate.conf
```

强制执行：

```
logrotate -f /etc/logrotate.conf
```

注意：`-f` 会强制执行轮转，可能立即改变真实日志文件，建议先在测试环境验证。

查看轮转后的文件：

```
ls -lh /var/log/myapp/
```

查看压缩日志：

```
zcat /var/log/myapp/app.log*.gz
```

查看 logrotate 状态记录：

```
cat /var/lib/logrotate/status
```

状态文件记录各日志上一次轮转时间等信息。

### 25. logrotate 自动执行机制

检查系统是否已经配置自动执行：

```
# 查看 systemd 定时器
systemctl status logrotate.timer

# 查看下次执行时间
systemctl list-timers | grep logrotate

# 查看定时器执行日志
journalctl -u logrotate.service
```

有些系统也通过 cron 执行：

```
ls -l /etc/cron.daily/logrotate
```

不要在已经配置自动执行的系统上重复创建定时任务，否则可能造成重复执行或不必要的轮转。

### 26. journald 自身的日志清理

这里需要特别区分：
logrotate 管理普通文本日志，不能直接用它管理 journald 的二进制日志。
journal 日志通常通过 journald 自身配置进行空间管理。

配置文件：
```
/etc/systemd/journald.conf
```

例如：

```
[Journal]
Storage=persistent
SystemMaxUse=1G
SystemKeepFree=2G
MaxRetentionSec=30day
```

含义：

| 参数                      | 作用                 |
| ----------------------- | ------------------ |
| `Storage=persistent`    | 持久化保存 journal 日志   |
| `SystemMaxUse=1G`       | 限制持久化 journal 日志空间 |
| `SystemKeepFree=2G`     | 尽量为文件系统保留 2GB 空间   |
| `MaxRetentionSec=30day` | 设置日志最大保留时间         |

修改后：

```
systemctl restart systemd-journald
```

查看 journal 占用：

```
journalctl --disk-usage
```

清理较旧的归档 journal：

```
# 只保留最近7天的归档日志
journalctl --vacuum-time=7d

# 将归档日志空间控制在500MB以内
journalctl --vacuum-size=500M
```

这些命令会实际删除旧日志，执行前应确认审计和故障追溯要求。


## 27.  综合故障排查：如何通过日志定位服务器异常？

这部分最重要，建议按照真实生产环境的排查思路学习。

### 案例一：服务器突然重启

现象： 业务系统突然中断，服务器重新启动。

第一步：查看启动记录。

```
journalctl --list-boots
```

第二步：查看上一次启动日志。

```
journalctl -b -1
```

第三步：查看上一次启动的错误信息。

```
journalctl -b -1 -p err
```

第四步：查看内核日志。

```
journalctl -k -b -1
```

第五步：重点搜索：

```
journalctl -b -1 | grep -i -E \
"panic|oom|watchdog|power|shutdown|reboot|killed process"
```

可能原因：

- OOM Killer 导致关键进程退出。
- 内核 Panic。
- CPU Watchdog。
- 电源或硬件故障。
- 管理员执行重启。
- 虚拟化平台或云平台触发重启。

注意：如果是突然断电或硬件复位，系统可能来不及将最后的日志写入磁盘，因此日志不一定能完整记录故障原因。

### 案例二：服务器内存不足，进程被杀死

第一步：检查内存。

```
free -h
```

第二步：查看 OOM 日志。

```
dmesg -T | grep -i -E "oom|killed process"
```

第三步：查看 journald 内核日志。

```
journalctl -k | grep -i -E "oom|out of memory|killed process"
```

第四步：查看进程内存使用。

```
ps aux --sort=-%mem | head -n 10
```

第五步：检查进程是否受到 cgroup 内存限制。

```
cat /proc/PID/cgroup
```

如果使用 cgroup v2，还可以检查对应控制组中的：

```
memory.current
memory.max
memory.events
```

排查重点：区分系统整体内存不足、容器内存限制触发，以及应用自身内存泄漏。

### 案例三：磁盘空间突然占满

第一步：检查磁盘空间。

```
df -h
```

第二步：查看目录占用。

```
du -xh --max-depth=1 /var/log | sort -rh
```

第三步：查看大日志文件。

```
find /var/log -type f -size +500M -ls
```

第四步：检查是否存在删除但仍被进程占用的日志文件。

```
lsof +L1
```

第五步：检查日志轮转配置。

```
cat /etc/logrotate.conf
ls -l /etc/logrotate.d/
```

排查重点：

- 日志文件是否持续增长。
- logrotate 是否正常运行。
- 日志是否未配置轮转。
- 是否存在删除但未释放的文件描述符。
- journald 是否占用过多空间。

### 案例四：服务启动失败

第一步：

```
systemctl status nginx
```

第二步：

```
journalctl -u nginx -n 100
```

第三步：

```
journalctl -u nginx -p err
```

第四步：

```
nginx -t
```

第五步：

```
ss -lntp
```

重点判断：

- 配置文件是否错误。
- 端口是否被占用。
- 日志目录是否存在。
- 权限是否正确。
- 依赖服务是否正常。

### 案例五：服务器网络突然异常

第一步：检查网卡日志。

```
dmesg -T | grep -i -E "link|eth|ens|network"
```

第二步：检查内核日志。

```
journalctl -k --since "10 minutes ago"
```

第三步：检查网络服务日志。

```
journalctl -u NetworkManager -n 100
```

如果使用 systemd-networkd：

```
journalctl -u systemd-networkd -n 100
```

第四步：检查网卡状态和丢包。

```
ip -s link
```

第五步：检查网络连接。

```
ss -s
ping -c 5 网关IP
```

## 八、日志排查常用命令速查表

建议把下面这张表作为日常运维的命令清单。

| 排查目标           | 常用命令                            |
| -------------- | ------------------------------- |
| 查看系统日志         | `journalctl`                    |
| 查看本次启动日志       | `journalctl -b`                 |
| 查看上次启动日志       | `journalctl -b -1`              |
| 查看系统错误日志       | `journalctl -p err`             |
| 查看服务日志         | `journalctl -u nginx`           |
| 实时查看服务日志       | `journalctl -u nginx -f`        |
| 查看指定时间日志       | `journalctl --since --until`    |
| 查看内核日志         | `dmesg -T`                      |
| 查看内核错误         | `dmesg -T \\| grep -i error`    |
| 查看系统日志文件       | `less /var/log/syslog`          |
| 实时查看日志文件       | `tail -f`                       |
| 搜索日志关键字        | `grep -i`                       |
| 搜索压缩日志         | `zgrep`                         |
| 查看日志占用         | `du -sh /var/log`               |
| 查看 journald 占用 | `journalctl --disk-usage`       |
| 检查日志轮转配置       | `cat /etc/logrotate.conf`       |
| 测试轮转配置         | `logrotate -d`                  |
| 强制执行轮转         | `logrotate -f`                  |
| 查看轮转状态         | `cat /var/lib/logrotate/status` |
| 查看删除但仍被占用的文件   | `lsof +L1`                      |

## 28. Linux 日志管理面试题

以下问题建议你逐一掌握。
#### 问题 1：journalctl 和 dmesg 有什么区别？
参考回答：
`journalctl` 用于查询 systemd-journald 收集的系统、服务和内核日志；`dmesg` 主要用于查看内核日志缓冲区中的消息。排查服务问题时主要使用 journalctl，排查驱动、磁盘、内存等内核问题时可以使用 dmesg。

#### 问题 2：rsyslog 和 systemd-journald 有什么区别？
参考回答：
systemd-journald 负责收集系统、服务和内核日志，支持结构化日志存储；rsyslog 主要负责日志过滤、分类、保存和转发。两者可以同时运行，形成日志收集和文本日志保存的组合。

#### 问题 3：logrotate 的作用是什么？
参考回答：
logrotate 用于自动管理日志文件，包括定期轮转、压缩、保留和删除历史日志，避免日志持续增长占满磁盘空间。主要配置文件是 `/etc/logrotate.conf`，应用程序独立配置一般放在 `/etc/logrotate.d/`。

#### 问题 4：服务器出现大量日志，导致磁盘空间不足，如何处理？
参考回答：
首先通过 `df -h` 确认磁盘空间，再通过 `du` 定位占用较大的目录和日志文件。然后检查日志是否持续增长、logrotate 是否正常执行，以及是否存在删除但仍被进程占用的文件。最后根据日志用途配置合理的轮转、压缩和保留策略。

#### 问题 5：如何根据日志排查一次服务故障？
参考回答：
先通过 `systemctl status` 确认服务状态，再通过 `journalctl -u 服务名` 查看服务日志，根据故障时间缩小查询范围，结合 `journalctl -k`、`dmesg` 查看内核日志，最后关联系统资源、网络、磁盘和服务配置，定位故障原因。

#### 问题 6：为什么删除日志文件后，磁盘空间没有释放？
参考回答：
可能是进程仍然持有被删除文件的文件描述符。虽然文件目录项已经删除，但文件实际数据仍然存在，直到进程关闭对应文件描述符后才会释放。可以通过 `lsof +L1` 定位，再让服务安全地重新打开日志文件或重启服务。

# 第十章：定时任务与软件包管理

这一部分主要掌握四个方面：
1. `cron` 和 `systemd timer`：配置、查看和排查定时任务。
2. `apt/dpkg`：Debian、Ubuntu 系统的软件包管理。
3. `dnf/rpm`：openEuler、RHEL、Rocky Linux 等系统的软件包管理。
4. 软件仓库、依赖管理和离线安装：解决软件安装、升级、依赖缺失及回滚问题。

## 1. 定时任务管理

Linux 常见的定时任务管理方式有两种：
| 对比   | cron          | systemd timer       |
| ---- | ------------- | ------------------- |
| 管理方式 | crontab 时间表达式 | systemd Unit        |
| 适用场景 | 简单周期任务        | 周期任务、开机后延迟任务、单次任务   |
| 日志查看 | 系统日志          | journalctl          |
| 任务依赖 | 相对简单          | 支持 Unit 依赖关系        |
| 失败处理 | 需要自行处理        | 可结合 systemd 重启、状态管理 |

### 1. cron 定时任务
查看定时任务

```
# 查看当前用户的定时任务
crontab -l

# 编辑当前用户定时任务
crontab -e

# 查看 root 用户的定时任务
crontab -u root -l

# 查看系统级定时任务
cat /etc/crontab

# 查看系统定时任务目录
ls -l /etc/cron.d/
ls -l /etc/cron.daily/
ls -l /etc/cron.hourly/
```

配置格式
```
分 时 日 月 星期 执行命令
```

例如：

```
# 每天凌晨2点执行
0 2 * * * /usr/local/bin/backup.sh

# 每5分钟执行一次
*/5 * * * * /usr/local/bin/check.sh

# 每天早上8点执行
0 8 * * * /usr/local/bin/start.sh

# 每周日凌晨3点执行
0 3 * * 0 /usr/local/bin/clean.sh

# 每月1号凌晨1点执行
0 1 1 * * /usr/local/bin/archive.sh
```

常见符号
| 符号  | 含义  | 示例             |
| --- | --- | -------------- |
| `*` | 任意值 | `* * * * *`    |
| `,` | 多个值 | `0,30 * * * *` |
| `-` | 范围  | `0 8-18 * * *` |
| `/` | 间隔  | `*/5 * * * *`  |

实际配置示例：每天凌晨 2 点备份数据
```
crontab -e
```

添加：

```
0 2 * * * /usr/local/bin/backup.sh >> /var/log/backup.log 2>&1
```

这里：
- `>>`：追加标准输出。
- `2>&1`：将标准错误也重定向到标准输出。
- 这样任务执行结果和错误信息都会写入日志文件。
注意：cron 的环境变量比较精简，建议使用命令绝对路径，并设置必要的 PATH、工作目录和执行权限。

### 2. cron 服务排查

```
# 查看 cron 服务状态
systemctl status cron       # Ubuntu 常见
systemctl status crond      # RHEL 系常见

# 查看 cron 运行日志
journalctl -u cron
journalctl -u crond

# 查看任务执行记录
grep CRON /var/log/syslog       # Ubuntu 常见
grep CRON /var/log/cron         # RHEL 系常见
```

常见问题：
- 脚本没有执行权限。
- 脚本使用相对路径，cron 环境找不到文件。
- 环境变量与手动执行时不同。
- 执行用户没有文件或目录权限。
- cron 服务没有启动。
- 任务执行时间过长，导致任务堆积。

## 二、systemd timer 定时任务

`systemd timer` 是通过 `.timer` 和 `.service` 两个 Unit 配合实现的。

- `.timer`：定义什么时候执行。
- `.service`：定义具体执行什么命令。

### 1. 创建一个定时任务

假设需求：每天凌晨 2 点执行一次备份脚本。
第一步：创建 service 文件

```
vim /etc/systemd/system/backup.service
```

配置：

```
[Unit]
Description=Daily Backup Task

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
```

第二步：创建 timer 文件
```
vim /etc/systemd/system/backup.timer
```

配置：

```
[Unit]
Description=Run Backup Daily

[Timer]
OnCalendar=*-*-* 02:00:00
Persistent=true

[Install]
WantedBy=timers.target
```

其中：

| 参数                | 作用                  |
| ----------------- | ------------------- |
| `OnCalendar`      | 设置日历时间              |
| `OnBootSec`       | 开机后多久执行             |
| `OnUnitActiveSec` | 距离上次 Unit 激活多久后再次执行 |
| `Persistent=true` | 如果错过了计划执行时间，启动后补执行  |
| `AccuracySec`     | 允许定时器触发时间的精度范围      |

第三步：加载并启动
```
# 重新加载 systemd 配置
systemctl daemon-reload

# 设置定时器开机启动并立即启动
systemctl enable --now backup.timer
```

第四步：查看定时器
```
# 查看所有定时器
systemctl list-timers --all

# 查看指定定时器状态
systemctl status backup.timer

# 查看任务执行日志
journalctl -u backup.service
```

第五步：手动测试
```
# 手动执行任务
systemctl start backup.service

# 查看执行结果
systemctl status backup.service
```

### 2. 常见时间配置

```
# 每天凌晨2点
OnCalendar=*-*-* 02:00:00

# 每小时执行一次
OnCalendar=hourly

# 每周日凌晨3点
OnCalendar=Sun *-*-* 03:00:00

# 开机后5分钟执行一次
OnBootSec=5min

# 每隔10分钟执行一次
OnUnitActiveSec=10min
```

### 3. cron 和 systemd timer 怎么选？

- 简单的备份、清理、巡检脚本：cron 就够用。
- 需要查看执行状态、管理依赖、开机补执行：优先考虑 systemd timer。
- 对于生产任务，两者都应考虑脚本的日志记录、失败告警和重复执行安全性。

## 三、Debian / Ubuntu：apt 和 dpkg

这两个工具的区别：
- `apt`：高级软件包管理工具，可以连接软件仓库，自动处理依赖关系。
- `dpkg`：底层软件包管理工具，主要负责本地 `.deb` 软件包的安装、卸载和查询，本身不会自动从仓库下载缺失依赖。

### 1. apt 常用命令

| 操作      | 命令                     |
| ------- | ---------------------- |
| 更新仓库索引  | `apt update`           |
| 升级软件包   | `apt upgrade`          |
| 升级系统软件包 | `apt full-upgrade`     |
| 安装软件    | `apt install nginx`    |
| 卸载软件    | `apt remove nginx`     |
| 卸载并删除配置 | `apt purge nginx`      |
| 清理无用依赖  | `apt autoremove`       |
| 搜索软件包   | `apt search nginx`     |
| 查看软件包信息 | `apt show nginx`       |
| 查看已安装软件 | `apt list --installed` |
| 查看软件包版本 | `apt policy nginx`     |
| 查看软件包依赖 | `apt depends nginx`    |

实际操作示例：安装 Nginx

```
# 更新软件仓库索引
apt update

# 查看可用版本和来源
apt policy nginx

# 安装
apt install nginx

# 查看安装状态
dpkg -l nginx

# 查看服务状态
systemctl status nginx
```
注意：`apt update` 只是更新本地软件包索引，不会升级已经安装的软件。

### 2. dpkg 常用命令

| 操作           | 命令                                 |
| ------------ | ---------------------------------- |
| 安装本地 deb     | `dpkg -i package.deb`              |
| 卸载软件         | `dpkg -r nginx`                    |
| 删除软件及配置      | `dpkg -P nginx`                    |
| 查询软件是否安装     | `dpkg -l nginx`                    |
| 查看软件包文件列表    | `dpkg -L nginx`                    |
| 查看文件属于哪个包    | `dpkg -S /usr/bin/nginx`           |
| 查看软件包详细信息    | `dpkg -s nginx`                    |
| 查看 deb 包信息   | `dpkg-deb -I package.deb`          |
| 解压 deb 包但不安装 | `dpkg-deb -x package.deb /tmp/pkg` |

安装本地 deb 包：

```
dpkg -i nginx.deb
```

如果提示依赖缺失，可以尝试：

```
apt --fix-broken install
```

它会尝试从当前已配置的软件仓库中补齐依赖。如果仓库中没有所需依赖，仍然需要先准备对应的软件包。

### 3. apt 软件仓库配置

Debian / Ubuntu 的软件源配置通常位于：

```
/etc/apt/sources.list
/etc/apt/sources.list.d/
```

查看当前软件源：

```
cat /etc/apt/sources.list
ls -l /etc/apt/sources.list.d/
```

传统配置示例：

```
deb https://archive.ubuntu.com/ubuntu/ noble main restricted universe multiverse
deb https://archive.ubuntu.com/ubuntu/ noble-updates main restricted universe multiverse
deb https://security.ubuntu.com/ubuntu/ noble-security main restricted universe multiverse
```

含义：
| 字段           | 含义           |
| ------------ | ------------ |
| `deb`        | 二进制软件包仓库     |
| URL          | 软件仓库地址       |
| `noble`      | Ubuntu 发行版代号 |
| `main`       | 软件仓库组件       |
| `restricted` | 受限制的软件组件     |
| `universe`   | 社区维护的软件      |
| `multiverse` | 受许可证等限制的软件   |

较新的 Ubuntu 也可能使用 deb822 格式，配置文件通常以 `.sources` 结尾，例如：

```
/etc/apt/sources.list.d/ubuntu.sources
```

修改仓库配置后，执行：

```
apt update
```

### 4. apt 依赖管理

查看软件包依赖：

```
apt depends nginx
```

查看哪些软件包依赖某个包：

```
apt rdepends nginx
```

模拟安装，检查依赖和安装计划：

```
apt install nginx --simulate
```

查看软件包的依赖关系是否满足：

```
apt check
```

依赖关系的基本概念：

- Depends：必须依赖的软件包。
- Recommends：推荐安装的软件包。
- Suggests：建议安装的软件包。
- Conflicts：不能与之共存的软件包。
- Provides：声明该软件包提供的虚拟功能或包名。

### 5. 软件升级与回滚

升级前先查看版本：

```
apt policy nginx
```

指定版本安装：

```
apt install nginx=指定版本号
```

例如：

```
apt install nginx=1.24.0-2ubuntu7
```

版本号只是示例，必须以实际仓库提供的版本为准。

暂时禁止软件包升级：

```
apt-mark hold nginx
```

恢复升级：

```
apt-mark unhold nginx
```

查看被锁定的软件包：

```
apt-mark showhold
```

回滚思路：
1. 查找仓库中是否还保留旧版本。
2. 使用 `apt install 包名=旧版本号` 安装旧版本。
3. 如果仓库没有旧版本，需要提前备份旧版 `.deb` 包及其依赖。
4. 验证程序配置、服务状态和业务功能。
注意：软件包降级可能影响依赖关系和配置文件，不能保证所有软件都能安全降级。数据库等有数据格式升级的软件，尤其不能简单依靠降级软件包回滚。

## 四、openEuler / RHEL 系：dnf 和 rpm

这类系统常见于 openEuler、Rocky Linux、AlmaLinux、RHEL 等。

区别：

- `dnf`：高级软件包管理工具，负责仓库、依赖解析、安装和升级。
- `rpm`：底层软件包管理工具，直接管理 `.rpm` 文件。

### 1. dnf 常用命令

| 操作       | 命令                                   |
| -------- | ------------------------------------ |
| 查看仓库     | `dnf repolist`                       |
| 查看所有仓库   | `dnf repolist all`                   |
| 更新仓库元数据  | `dnf makecache`                      |
| 安装软件     | `dnf install nginx`                  |
| 升级软件     | `dnf upgrade nginx`                  |
| 升级全部软件   | `dnf upgrade`                        |
| 卸载软件     | `dnf remove nginx`                   |
| 搜索软件     | `dnf search nginx`                   |
| 查看软件信息   | `dnf info nginx`                     |
| 查看软件包文件  | `dnf repoquery -l nginx`             |
| 查看依赖     | `dnf repoquery --requires nginx`     |
| 查看反向依赖   | `dnf repoquery --whatrequires nginx` |
| 查看软件包提供者 | `dnf provides /usr/bin/nginx`        |
| 查看安装历史   | `dnf history`                        |

安装 Nginx 示例：

```
# 查看仓库
dnf repolist

# 查看软件包信息
dnf info nginx

# 安装
dnf install nginx

# 查看安装结果
rpm -q nginx

# 查看服务状态
systemctl status nginx
```

### 2. rpm 常用命令

| 操作          | 命令                       |
| ----------- | ------------------------ |
| 安装 rpm      | `rpm -ivh package.rpm`   |
| 升级 rpm      | `rpm -Uvh package.rpm`   |
| 卸载软件        | `rpm -e nginx`           |
| 查询软件是否安装    | `rpm -q nginx`           |
| 查询全部软件      | `rpm -qa`                |
| 查看软件包信息     | `rpm -qi nginx`          |
| 查看软件包文件列表   | `rpm -ql nginx`          |
| 查询文件所属软件包   | `rpm -qf /usr/bin/nginx` |
| 查看 rpm 包信息  | `rpm -qpi package.rpm`   |
| 检查软件包依赖     | `rpm -qpR package.rpm`   |
| 检查已安装包文件完整性 | `rpm -V nginx`           |

注意：`rpm -ivh`、`rpm -Uvh` 不会自动从仓库下载缺失依赖。生产环境优先使用 `dnf install` 或 `dnf upgrade`。

### 3. dnf 软件仓库配置

配置文件通常位于：

```
/etc/yum.repos.d/
```

查看：

```
ls -l /etc/yum.repos.d/
cat /etc/yum.repos.d/*.repo
```

典型配置：

```
[myrepo]
name=My Local Repository
baseurl=file:///opt/repo
enabled=1
gpgcheck=0
```

常见参数：
| 参数           | 含义            |
| ------------ | ------------- |
| `name`       | 仓库名称          |
| `baseurl`    | 软件仓库地址        |
| `enabled=1`  | 启用仓库          |
| `enabled=0`  | 禁用仓库          |
| `gpgcheck=1` | 检查软件包 GPG 签名  |
| `gpgkey`     | 指定仓库签名公钥      |
| `priority`   | 仓库优先级，需相应插件支持 |
`baseurl` 可以使用 HTTP、HTTPS、FTP 或本地文件路径。

修改配置后：
```
# 清理旧缓存
dnf clean all

# 重新生成仓库缓存
dnf makecache

# 查看仓库
dnf repolist
```

### 4. dnf 依赖管理

查看软件包依赖：

```
dnf repoquery --requires nginx
```

查看依赖树：

```
dnf repoquery --tree-requires nginx
```

查看哪个软件包提供某个命令或文件：

```
dnf provides /usr/bin/python3
```

检查系统已安装包的依赖关系：

```
dnf check
```

模拟安装或查看事务计划：

```
dnf install nginx --assumeno
```

依赖解决原则：

dnf 会从启用的软件仓库中查找软件包及其依赖，计算可行的安装事务。安装时尽量使用 dnf，而不是逐个使用 rpm 安装，以减少依赖遗漏。

### 5. 软件升级与回滚

升级前查看版本：

```
dnf info nginx
rpm -q nginx
```

升级：

```
dnf upgrade nginx
```

查看历史操作：

```
dnf history
```

查看某次事务详情：

```
dnf history info 10
```

尝试撤销某次事务：

```
dnf history undo 10
```

尝试回滚到某个历史事务之前的状态：

```
dnf history rollback 10
```

注意：
- `undo` 撤销指定事务，`rollback` 尝试恢复到指定事务之前的状态。
- 只有仓库或本地仍有需要的旧版本包时，回滚才可能成功。
- 如果依赖包已被其他事务使用，或者软件包不可用，可能无法回滚。
- 数据库数据格式、配置文件和业务数据不一定随 RPM 回滚，因此重要系统应提前备份。
如果已经准备好旧版本 RPM，也可以：

```
rpm -Uvh --oldpackage nginx-old-version.rpm
```

但这不会自动解决依赖问题，需提前准备完整依赖。

## 五、离线安装软件包及依赖管理

这是生产环境运维中很重要的一项能力。
例如：服务器没有互联网，或者生产网络与互联网隔离，需要提前在有网络的机器上下载软件包及依赖，再拷贝到目标服务器安装。
核心原则：
不能只下载主软件包，还必须准备它依赖的所有软件包，并尽量保证操作系统版本、CPU 架构和软件仓库版本一致。
### 1. Ubuntu / Debian 离线安装
假设需要离线安装 Nginx。
方法一：提前下载软件包及依赖
在一台能够访问软件仓库、且环境与目标服务器兼容的 Ubuntu 机器上：

```
# 创建下载目录
mkdir -p /opt/offline-debs

# 更新仓库索引
apt update

# 下载软件包及其依赖，但不安装
cd /opt/offline-debs

apt-get install --download-only \
  --reinstall \
  -o Dir::Cache::archives=/opt/offline-debs \
  nginx
```
这里要注意：`--download-only` 会下载安装事务所需的软件包，但已经安装的依赖可能不会重新下载。对于离线目标机，应确认目标机缺少的依赖也已经准备好。

可以使用：
```
# 查看下载结果
ls -lh /opt/offline-debs/
```

将整个目录拷贝到离线服务器：
```
scp -r /opt/offline-debs root@目标服务器:/opt/
```

离线服务器执行：

```
cd /opt/offline-debs

# 使用 apt 安装本地 deb 包并解析本地依赖
apt install ./*.deb
```

如果目标机完全离线，所有需要的依赖都必须在这个目录中，否则仍然会提示缺少依赖。

方法二：使用 dpkg 安装
```
dpkg -i /opt/offline-debs/*.deb
```
如果出现依赖缺失：
```
apt --fix-broken install
```
但注意：这条命令只有在本地已经有依赖包，或者系统仍然能够访问可用仓库时才能修复。完全离线且依赖不齐时，它不能凭空解决问题。

### 2. Debian / Ubuntu 制作本地软件仓库
如果需要给多台离线服务器安装软件，建议制作本地仓库，而不是每台服务器逐个执行 dpkg。
安装仓库索引工具：
```
apt install dpkg-dev
```
假设所有 deb 包都放在：
```
/opt/offline-debs/
```
生成软件包索引：
```
cd /opt/offline-debs
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
```

在离线服务器配置：
```
vim /etc/apt/sources.list.d/local.list
```

写入：

```
deb [trusted=yes] file:/opt/offline-debs ./
```

然后：

```
apt update

# 查询软件包
apt policy nginx

# 安装
apt install nginx
```

这里的 `[trusted=yes]` 会跳过仓库签名验证，只适合可信、受控的内部测试仓库。生产环境建议建立签名仓库并验证 GPG 签名。

### 3. openEuler / RHEL 系离线安装
假设需要离线安装 Nginx。
方法一：使用 dnf download 下载软件包及依赖
首先安装下载插件：
```
dnf install dnf-plugins-core
```

在联网机器上执行：
```
# 创建目录
mkdir -p /opt/offline-rpms

# 下载 Nginx 及其依赖
dnf download \
  --resolve \
  --alldeps \
  --destdir=/opt/offline-rpms \
  nginx
```

参数含义：

| 参数          | 作用               |
| ----------- | ---------------- |
| `download`  | 下载软件包            |
| `--resolve` | 下载依赖包            |
| `--alldeps` | 即使本机已经安装依赖，也尝试下载 |
| `--destdir` | 指定下载目录           |

将整个目录拷贝到离线服务器。

```
scp -r /opt/offline-rpms root@目标服务器:/opt/
```

离线服务器执行：

```
# 使用 dnf 安装本地 RPM
dnf install /opt/offline-rpms/*.rpm
```

dnf 会尝试利用本地 RPM 和当前可用仓库解析依赖。完全离线时，需要确保所有依赖都已经准备好。

也可以使用：

```
rpm -Uvh /opt/offline-rpms/*.rpm
```

但是 RPM 命令本身不会自动解决依赖，依赖顺序不正确或缺少依赖时可能安装失败，所以通常优先使用 dnf。

### 4. 制作 RPM 本地软件仓库

如果需要在多台 openEuler 服务器上安装软件，可以将 RPM 包制作成一个本地仓库。

安装仓库生成工具：

```
dnf install createrepo_c
```

假设 RPM 包放在：

```
/opt/offline-rpms/
```

生成仓库元数据：

```
createrepo_c /opt/offline-rpms/
```

创建仓库配置：

```
vim /etc/yum.repos.d/local.repo
```

配置：

```
[local]
name=Local Offline Repository
baseurl=file:///opt/offline-rpms/
enabled=1
gpgcheck=0
```

刷新缓存：

```
dnf clean all
dnf makecache
```

查看仓库：

```
dnf repolist
```

安装：

```
dnf install nginx
```

这里的 `gpgcheck=0` 仅用于可信的内部测试环境。生产仓库应启用签名验证，并正确配置 `gpgkey`。

### 5. 离线依赖管理需要注意什么？

| 检查项    | 需要确认的内容                                    |
| ------ | ------------------------------------------ |
| 操作系统版本 | Ubuntu 22.04、24.04，openEuler 22.03、24.03 等 |
| CPU 架构 | x86_64、aarch64、riscv64 等                   |
| 软件包版本  | 软件版本是否兼容                                   |
| 依赖完整性  | 是否包含所有缺失依赖                                 |
| 仓库来源   | 是否来自兼容的发行版仓库                               |
| GPG 签名 | 软件包是否可信、签名是否验证                             |
| 安装顺序   | 是否存在依赖关系或冲突                                |
| 回滚包    | 是否保留原版本及其依赖                                |

## 六、日常运维命令速查表

| 工作内容    | Debian / Ubuntu                   | openEuler / RHEL 系                 |
| ------- | --------------------------------- | ---------------------------------- |
| 查看仓库    | `apt policy`                      | `dnf repolist`                     |
| 更新仓库索引  | `apt update`                      | `dnf makecache`                    |
| 安装软件    | `apt install`                     | `dnf install`                      |
| 卸载软件    | `apt remove`                      | `dnf remove`                       |
| 查询软件    | `dpkg -l`                         | `rpm -qa`                          |
| 查询文件所属包 | `dpkg -S`                         | `rpm -qf`                          |
| 查看软件包文件 | `dpkg -L`                         | `rpm -ql`                          |
| 查看依赖    | `apt depends`                     | `dnf repoquery --requires`         |
| 查看反向依赖  | `apt rdepends`                    | `dnf repoquery --whatrequires`     |
| 升级软件    | `apt upgrade`                     | `dnf upgrade`                      |
| 查看安装历史  | `/var/log/apt/history.log`        | `dnf history`                      |
| 回滚      | 指定旧版本安装                           | `dnf history undo`                 |
| 本地安装    | `dpkg -i` / `apt install ./包.deb` | `rpm -ivh` / `dnf install ./包.rpm` |
| 离线依赖下载  | `apt-get --download-only`         | `dnf download --resolve --alldeps` |
| 本地仓库    | `dpkg-scanpackages`               | `createrepo_c`                     |

## 七、面试常见问题

问题 1：apt 和 dpkg 有什么区别？
参考回答：
apt 是高级软件包管理工具，可以连接软件仓库、自动解析和安装依赖；dpkg 是底层工具，主要负责本地 deb 包的安装、卸载和查询，本身不会自动下载依赖。

问题 2：dnf 和 rpm 有什么区别？
参考回答：
dnf 是高级包管理工具，可以从仓库下载软件包并自动解决依赖；rpm 是底层包管理工具，直接操作 RPM 文件，不会自动解决缺失依赖。

问题 3：Linux 如何配置软件仓库？
参考回答：
Debian 系统主要通过 `/etc/apt/sources.list` 和 `/etc/apt/sources.list.d/` 配置软件源；openEuler、RHEL 系统通常通过 `/etc/yum.repos.d/*.repo` 配置仓库。修改后需要更新软件包索引或仓库缓存。

问题 4：生产环境没有互联网，如何安装软件？
参考回答：
我会先确认目标系统的发行版、版本和 CPU 架构，在兼容的联网环境中下载目标软件及其完整依赖，再将软件包传输到离线服务器。如果只有少量软件，可以直接使用本地 deb 或 rpm 安装；如果需要多台机器使用，可以制作本地软件仓库，通过 apt 或 dnf 统一管理。

问题 5：软件升级失败，如何回滚？
参考回答：
升级前记录当前软件版本，并尽可能保存原版本软件包和配置文件。Debian 系可以通过指定旧版本重新安装；RPM 系可以查看 dnf history，尝试撤销升级事务。如果软件涉及数据库结构或业务数据变更，还需要恢复相应备份，不能只依赖软件包降级。


# Linux 时间同步：时区、chrony/NTP 服务端与客户端、偏差排查

先区分两个概念：

- 时区（Timezone）：决定系统时间如何显示，例如 UTC+8。
- 时间同步（NTP）：让系统时钟与时间服务器保持一致，解决系统时间走快、走慢的问题。

Linux 生产环境通常使用 `chrony` 实现 NTP 同步。下面按实际操作顺序整理，命令以 Ubuntu、Debian、openEuler、Anolis 等常见发行版为参考；不同发行版的安装命令和服务名称可能略有区别。

## 一、先掌握常用命令

`chrony` 主要由两个组件组成：

- `chronyd`：后台时间同步服务，负责校准系统时间，也可以向其他机器提供 NTP 服务。
- `chronyc`：命令行管理工具，用于查看同步状态、时间偏差和调整同步行为。

### 1. 安装与启动

| 发行版                       | 安装命令                    |
| ------------------------- | ----------------------- |
| Ubuntu / Debian           | `apt install chrony -y` |
| openEuler / Anolis / RHEL | `dnf install chrony -y` |

启动并设置开机自启：

```
systemctl enable --now chronyd
systemctl status chronyd
```

Ubuntu / Debian 部分版本的服务名称是 `chrony`，如果 `chronyd` 找不到，可以执行：

```
systemctl status chrony
```

### 2. 常用查看命令

```
# 查看系统时间、时区、NTP 同步状态
timedatectl

# 查看 chrony 时间源
chronyc sources -v

# 查看时间同步详细状态
chronyc tracking

# 查看当前时间源统计信息
chronyc sourcestats -v

# 立即向时间源发起一轮快速测量
chronyc burst 4/4

# 等待同步状态
chronyc waitsync 60

# 查看 chrony 服务日志
journalctl -u chronyd -f
```

重点掌握三个命令：

| 命令                   | 主要用途                |
| -------------------- | ------------------- |
| `timedatectl`        | 查看系统时间、时区、NTP 状态    |
| `chronyc sources -v` | 查看时间源是否可用、当前选择哪个时间源 |
| `chronyc tracking`   | 查看时间偏差、频率误差、同步层级等   |

`chronyc tracking` 中比较重要的字段：

- `Reference ID`：当前参考的时间源。
- `Stratum`：时间源层级，数值越小通常离参考时钟越近。
- `System time`：系统时钟与 chrony 内部时钟之间的差值。
- `Last offset`：最近一次测量的时间偏差。
- `RMS offset`：一段时间内的偏差均方根。
- `Leap status`：同步状态，正常时通常为 `Normal`。

注意：`System time`、`Last offset` 等字段的正负方向有各自定义，不要只凭正负号判断哪台机器时间快，最好结合实际时间和多个时间源综合判断。

[image](https://www.google.com/s2/favicons?domain=https://chrony-project.org\&sz=32)

chronyc(1)



## 二、设置 Linux 时区

### 1. 查看当前时区

```
timedatectl
timedatectl status
```

查看可用时区：

```
timedatectl list-timezones
```

筛选中国时区：

```
timedatectl list-timezones | grep Shanghai
```

### 2. 设置时区

设置为中国标准时间（UTC+8）：

```
timedatectl set-timezone Asia/Shanghai
```

设置为新加坡时间：

```
timedatectl set-timezone Asia/Singapore
```

查看结果：

```
timedatectl
date
date -u
```

### 3. 时区与 UTC 的关系

例如，系统内部时间对应同一个 UTC 时间：

- UTC：08:00
- Asia/Shanghai：16:00
- Asia/Singapore：16:00

重点：时区不正确不代表 NTP 同步失败。 NTP 主要同步系统时钟所表示的时间，时区决定显示方式。不要为了修复时区显示问题而随意修改 NTP 时间源。

## 三、配置 NTP 服务端

假设有一台 Linux 服务器作为内网 NTP 服务端：

- NTP 服务端 IP：`192.168.1.10`
- 客户端网段：`192.168.1.0/24`
- 服务端通过公网或上级 NTP 服务器同步时间。

### 1. 修改服务端配置

配置文件位置通常是：

- openEuler / Anolis / RHEL：`/etc/chrony.conf`
- Ubuntu / Debian：`/etc/chrony/chrony.conf`

编辑配置：

```
vim /etc/chrony.conf
```

参考配置：

```
# 上级 NTP 时间源
server ntp1.example.com iburst
server ntp2.example.com iburst
server ntp3.example.com iburst

# 允许内网客户端访问
allow 192.168.1.0/24

# 保存系统时钟频率偏差
driftfile /var/lib/chrony/drift

# 初始偏差较大时，允许前几次同步直接调整时间
makestep 1.0 3

# 定期将系统时间同步到硬件时钟
rtcsync
```

参数说明：

| 参数               | 作用                       |
| ---------------- | ------------------------ |
| `server`         | 指定上级 NTP 服务器             |
| `iburst`         | 加快初始同步                   |
| `allow`          | 允许指定网段的客户端访问             |
| `driftfile`      | 保存系统时钟频率偏差               |
| `makestep 1.0 3` | 前 3 次更新中，偏差超过 1 秒时允许直接跳变 |
| `rtcsync`        | 定期将系统时间写入硬件时钟            |

注意：`allow` 是让 chronyd 接受客户端 NTP 请求的关键配置，默认情况下不能假设服务端已经对外提供 NTP 服务。

[image](https://www.google.com/s2/favicons?domain=https://chrony-project.org\&sz=32)

chrony.conf(5)+1



### 2. 启动服务

```
systemctl enable --now chronyd
systemctl restart chronyd
systemctl status chronyd
```

检查是否监听 UDP 123 端口：

```
ss -lunp | grep ':123'
```

### 3. 配置防火墙

NTP 使用 UDP 123 端口。

如果使用 firewalld：

```
firewall-cmd --permanent --add-port=123/udp
firewall-cmd --reload
```

如果使用 ufw：

```
ufw allow 123/udp
```

生产环境建议只允许客户端所在网段访问，不要无条件向公网开放 NTP 服务。

### 4. 验证服务端

```
chronyc tracking
chronyc sources -v
```

确认服务端自身已经从上级时间源同步成功，再让客户端使用它。

## 四、配置 NTP 客户端

假设客户端 IP 为 `192.168.1.20`，服务端 IP 为 `192.168.1.10`。

### 1. 修改客户端配置

编辑：

```
vim /etc/chrony.conf
```

Ubuntu / Debian 通常编辑：

```
vim /etc/chrony/chrony.conf
```

配置：

```
# 指定内网 NTP 服务端
server 192.168.1.10 iburst

# 保存时钟频率偏差
driftfile /var/lib/chrony/drift

# 初始同步允许直接调整时间
makestep 1.0 3

# 同步系统时间到硬件时钟
rtcsync
```

如果配置文件中原本存在公网 `pool` 或 `server`，应根据实际需求决定是否保留，避免客户端同时使用不合适的时间源。

### 2. 重启客户端服务

```
systemctl restart chronyd
systemctl enable chronyd
```

### 3. 检查客户端同步状态

```
chronyc sources -v
chronyc tracking
timedatectl
```

如果正常，`chronyc sources -v` 中通常会看到类似：

```
MS Name/IP address         Stratum Poll Reach LastRx Last sample
===============================================================================
^* 192.168.1.10                  3   6    17    10   +125us[+180us] +/-  15ms
```

重点看：

- `^*`：当前选中的时间源。
- `^+`：可用的候选时间源。
- `^?`：暂时无法获取有效测量。
- `Reach`：可达性记录，八进制表示；持续为 `0` 通常表示没有收到有效响应。

`^*` 表示当前选中的时间源，不能只看服务是否启动就认定同步成功。

## 五、NTP 时间同步存在偏差，怎么排查和解决？

这是生产环境中比较常见的问题。建议按照下面的顺序排查，不要一开始就手动修改系统时间。

### 1. 先判断偏差有多大

执行：

```
date
date -u
timedatectl

chronyc tracking
chronyc sources -v
```

重点观察：

- 系统当前时间是否正确。
- 时区是否正确。
- `Leap status` 是否为 `Normal`。
- `Reference ID` 是否有有效时间源。
- `Last offset`、`RMS offset` 是否持续偏大。
- `Reach` 是否长期为 0。

可以先区分两种情况：

| 现象            | 可能原因                |
| ------------- | ------------------- |
| 时间相差固定几个小时    | 时区设置错误              |
| 时间逐渐变快或变慢     | 系统时钟频率偏差较大          |
| 时间长期差几十秒或几分钟  | NTP 未同步或上游时间源异常     |
| 偶尔出现较大偏差      | 网络延迟、虚拟机时钟问题或时间源不稳定 |
| `Reach` 长期为 0 | 网络不通、防火墙拦截或服务端异常    |
| 多台机器时间不一致     | 时间源配置不统一或部分机器同步失败   |

### 2. 检查 NTP 网络是否连通

NTP 使用 UDP 123 端口。

检查客户端能否访问服务端：

```
ping 192.168.1.10
```

检查 UDP 123 端口：

```
nc -uvz 192.168.1.10 123
```

注意：UDP 探测工具显示成功不一定代表 NTP 服务正常响应，最终应以 `chronyc sources -v` 的测量结果为准。

检查服务端：

```
systemctl status chronyd
ss -lunp | grep ':123'
```

检查防火墙：

```
firewall-cmd --list-all
```

重点确认：

1. 客户端能访问服务端。
2. 服务端 UDP 123 端口正常。
3. 防火墙允许客户端网段访问。
4. 服务端配置了正确的 `allow` 网段。
5. 服务端本身已经同步到有效上游时间源。

### 3. 检查时间源是否异常

执行：

```
chronyc sources -v
chronyc tracking
```

如果出现以下情况：

- `^?`：时间源暂时不可用，或者没有有效测量。
- `Reach` 为 0：没有收到有效响应。
- `Leap status: Not synchronised`：当前未同步。
- `Reference ID` 没有有效上游：可能没有选中可用时间源。

可以重新加载配置并触发测量：

```
systemctl restart chronyd

chronyc online
chronyc burst 4/4
chronyc sources -v
```

如果是 DNS 时间源，还要检查域名解析：

```
getent hosts ntp1.example.com
```

### 4. 时间偏差太大，如何快速校准？

chrony 默认倾向于通过逐渐加快或减慢系统时钟来校准，也就是 slew，避免突然跳变影响应用。

如果系统时间偏差很大，需要立即校准，可以执行：

```
chronyc makestep
```

然后检查：

```
chronyc tracking
date
```

如果想让服务启动后的前几次同步自动处理大偏差，可以在配置文件中设置：

```
makestep 1.0 3
```

含义：前 3 次时钟更新中，如果偏差超过 1 秒，允许直接调整系统时间。

生产环境注意

`makestep` 会让系统时间发生跳变，可能影响数据库、分布式任务、日志时间线、证书校验和依赖时间顺序的应用。生产服务器不要不加判断地频繁执行。对于数据库等关键业务服务器，应先评估影响，必要时安排维护窗口。

### 5. 检查系统时间与硬件时钟是否不一致

Linux 有两种常见时间：

- 系统时钟：操作系统运行期间使用的时钟。
- 硬件时钟 RTC：主板上的实时时钟，关机后仍可计时。

查看：

```
date
hwclock --show
timedatectl
```

查看 RTC 是否使用 UTC：

```
timedatectl | grep -i "RTC"
```

建议服务器统一使用 UTC 保存硬件时钟：

```
timedatectl set-local-rtc 0
```

如果系统时间已经正确，可以将系统时间写入 RTC：

```
hwclock --systohc
```

注意：不要在没有确认时钟状态的情况下随意执行 `hwclock --hctosys`，它会用硬件时钟覆盖系统时钟。

### 6. 检查是否存在多个时间同步服务冲突

有些机器可能同时安装了 chrony、ntpd、systemd-timesyncd 等服务。

查看：

```
systemctl status chronyd
systemctl status ntp
systemctl status systemd-timesyncd
```

如果决定使用 chrony，建议停用其他时间同步服务：

```
systemctl disable --now systemd-timesyncd
```

如果存在 `ntpd` 服务，也应根据实际情况停用，避免多个服务同时调整系统时钟。

### 7. 虚拟机时间偏差问题

虚拟机也容易出现时间漂移，例如：

- 宿主机时间不准确。
- 虚拟机暂停、恢复后时间跳变。
- 虚拟机迁移后时钟出现偏差。
- 虚拟化工具与 chrony 同时调整时间。

排查：

```
chronyc tracking
timedatectl
dmesg | grep -i -E "clock|time|tsc"
```

如果是 VMware 环境，还需要检查 VMware Tools / open-vm-tools 的时间同步策略，避免与 chrony 重复校准。

## 六、生产环境常见配置模板

如果有多台 Linux 服务器，建议采用集中式时间同步架构：

| 机器       | 配置角色    | 时间源       |
| -------- | ------- | --------- |
| Server01 | NTP 服务端 | 公网或上级 NTP |
| Server02 | NTP 客户端 | Server01  |
| Server03 | NTP 客户端 | Server01  |
| Server04 | NTP 客户端 | Server01  |
| Server05 | NTP 客户端 | Server01  |

这样做的好处：
- 内网服务器使用统一时间源。
- 减少每台服务器直接访问公网 NTP 的需求。
- 上游网络短暂中断时，内网服务器仍可保持共同的时间基准。
- 便于集中排查时间偏差。

## 七、面试常见问题

问题 1：chrony 和 NTP 是什么关系？
回答：NTP 是网络时间同步协议，chrony 是 Linux 上实现 NTP 客户端和服务端功能的软件，主要包含 chronyd 服务和 chronyc 管理工具。

问题 2：如何判断 Linux 是否已经同步 NTP？
回答：使用 `timedatectl` 查看 NTP 状态，再使用 `chronyc tracking` 和 `chronyc sources -v` 查看同步状态、时间源和偏差。不能只看 chronyd 服务是否启动。

问题 3：NTP 时间偏差过大怎么处理？
回答：先检查时区、网络连通性、UDP 123 端口、时间源状态和 chrony 日志。如果时间源正常但系统偏差较大，可以使用 `chronyc makestep` 立即校准，但需要评估时间跳变对业务的影响。

问题 4：如何配置一台 Linux 服务器作为内网 NTP 服务端？
回答：安装 chrony，配置上游 `server`，添加 `allow` 允许内网网段访问，开放 UDP 123 端口，重启 chronyd；客户端配置该服务器 IP 作为时间源。

问题 5：NTP 同步成功了，为什么显示时间还是差 8 小时？
回答：通常是时区问题。NTP 同步的是时间基准，时区决定本地显示方式。可以使用 `timedatectl set-timezone Asia/Shanghai` 设置为中国标准时间。

这一章最值得掌握的是： `timedatectl` 管时区，`chrony.conf` 管时间源和服务端访问权限，`chronyc sources -v` 看时间源，`chronyc tracking` 看偏差，`chronyc makestep` 处理需要立即校准的大偏差。


# 脚本常用命令解析

grep：负责搜索和过滤。
awk：负责按列提取、条件判断和统计。
sed：负责文本替换、删除和插入。
sort：负责排序。
cut：负责按固定分隔符或字符位置提取内容。
xargs：负责把管道输入转换成命令参数。

#!/bin/bash

# ============================================================
# Linux 文本处理常用命令：grep、awk、sed、sort、cut、xargs
# ============================================================
# ------------------------------------------------------------
# 1. grep：文本搜索、过滤
# ------------------------------------------------------------
# 搜索文件中包含 error 的行
grep "error" /var/log/messages
# 忽略大小写搜索
grep -i "error" /var/log/messages
# 显示匹配行的行号
grep -n "error" /var/log/messages
# 递归搜索目录下所有文件
grep -r "error" /var/log/
# 只显示不包含 error 的行
grep -v "error" /var/log/messages
# 使用扩展正则表达式，匹配 error 或 failed
grep -E "error|failed" /var/log/messages
# 显示匹配内容前后各 3 行
grep -C 3 "error" /var/log/messages
# 只统计匹配的行数
grep -c "error" /var/log/messages
# 只显示匹配的文件名
grep -l "error" /var/log/*
# 统计日志中出现 error 的次数（按匹配行统计）
grep -c "error" /var/log/messages


# ------------------------------------------------------------
# 2. awk：按列提取、过滤、统计
# ------------------------------------------------------------
# 默认以空格或 Tab 分隔，输出第一列
awk '{print $1}' file.txt

# 输出第一列和第三列
awk '{print $1, $3}' file.txt
# 指定冒号作为分隔符，输出第一列
awk -F ':' '{print $1}' /etc/passwd
# 输出用户名和登录 Shell
awk -F ':' '{print $1, $7}' /etc/passwd
# 输出第二列大于 80 的行
awk '$2 > 80 {print $0}' score.txt
# 输出包含 root 的行
awk '/root/ {print $0}' /etc/passwd
# 统计文件行数
awk 'END {print NR}' file.txt
# 计算第三列的总和
awk '{sum += $3} END {print sum}' file.txt
# 计算第三列的平均值
awk '{sum += $3} END {if (NR > 0) print sum/NR}' file.txt
# NR：当前记录行号；NF：当前行字段数量
awk '{print "行号:", NR, "字段数:", NF}' file.txt
# 输出最后一列
awk '{print $NF}' file.txt
# 输出第二列和最后一列
awk '{print $2, $NF}' file.txt


# ------------------------------------------------------------
# 3. sed：文本替换、删除、插入
# ------------------------------------------------------------
# 将文件中的 old 替换成 new（只替换每行第一个匹配项）
sed 's/old/new/' file.txt
# 替换每行所有匹配项
sed 's/old/new/g' file.txt
# 忽略大小写替换
sed 's/old/new/gi' file.txt
# 直接修改文件内容（原文件会被修改）
sed -i 's/old/new/g' file.txt
# 直接修改前先备份原文件
sed -i.bak 's/old/new/g' file.txt
# 删除第 3 行
sed '3d' file.txt
# 删除第 2 到第 5 行
sed '2,5d' file.txt
# 删除包含 error 的行
sed '/error/d' file.txt
# 只显示第 3 行
sed -n '3p' file.txt
# 显示第 2 到第 5 行
sed -n '2,5p' file.txt
# 在第 3 行前插入一行
sed '3i\这是插入的内容' file.txt
# 在第 3 行后追加一行
sed '3a\这是追加的内容' file.txt


# ------------------------------------------------------------
# 4. sort：排序、去重
# ------------------------------------------------------------
# 按字典顺序排序
sort file.txt
# 按数字大小排序
sort -n number.txt
# 按数字从大到小排序
sort -nr number.txt
# 按第 2 列排序（默认空白分隔）
sort -k2 file.txt
# 按冒号分隔，按照第 3 列数字排序
sort -t ':' -k3,3n /etc/passwd
# 排序并去除重复行
sort -u file.txt
# 按第 2 列排序，忽略大小写
sort -f -k2 file.txt
# 按照第 2 列数字排序，再按照第 1 列排序
sort -k2,2n -k1,1 file.txt


# ------------------------------------------------------------
# 5. cut：按分隔符或字符位置提取字段
# ------------------------------------------------------------
# 按默认 Tab 分隔，提取第 1 列
cut -f1 file.txt
# 指定冒号分隔，提取第 1 列
cut -d ':' -f1 /etc/passwd
# 提取第 1 列和第 3 列
cut -d ':' -f1,3 /etc/passwd
# 提取第 1 到第 3 列
cut -d ':' -f1-3 /etc/passwd
# 提取第 2 列到最后一列
cut -d ':' -f2- /etc/passwd
# 按字符位置提取第 1 到第 5 个字符
cut -c1-5 file.txt
# 提取第 3 个字符
cut -c3 file.txt


# ------------------------------------------------------------
# 6. xargs：将标准输入转换为命令参数
# ------------------------------------------------------------
# 将输入内容作为 rm 的参数
echo "a.txt b.txt" | xargs rm -f
# 将查找到的文件交给 rm 删除
find /tmp -name "*.tmp" -print0 | xargs -0 rm -f
# 每次传递一个参数执行命令
echo "a.txt b.txt c.txt" | xargs -n 1 echo
# 每次传递两个参数执行命令
echo "a.txt b.txt c.txt d.txt" | xargs -n 2 echo
# 使用 -I 指定参数替换位置
find /tmp -name "*.log" | xargs -I {} cp {} /tmp/backup/
# 执行前先询问是否确认
echo "a.txt b.txt" | xargs -p rm -f
# 空输入时也执行一次命令
echo "" | xargs -r echo "执行命令"
# -r：GNU xargs 扩展，输入为空时不执行命令
# 限制命令参数数量，每次最多处理 100 个
find /tmp -name "*.log" -print0 | xargs -0 -n 100 rm -f


# ------------------------------------------------------------
# 7. 常见组合用法：Linux 运维日志处理
# ------------------------------------------------------------
# 统计日志中 error 出现的行数
grep -i "error" /var/log/messages | wc -l
# 提取日志中的 IP 地址（简单匹配，不校验 IP 合法性）
grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' access.log
# 统计访问日志中出现次数最多的 IP
awk '{print $1}' access.log | sort | uniq -c | sort -nr | head
# 统计 passwd 文件中的用户数量
cut -d ':' -f1 /etc/passwd | wc -l
# 查找日志中的 failed 行，并提取第一列
grep "failed" /var/log/messages | awk '{print $1}'
# 将配置文件中的旧 IP 替换为新 IP
sed -i 's/192.168.1.10/192.168.1.20/g' config.conf
# 查找 /tmp 下大于 100MB 的文件，并删除
find /tmp -type f -size +100M -print0 | xargs -0 -r rm -f
# 统计日志中不同错误类型的数量
grep -i "error" app.log | awk '{print $NF}' | sort | uniq -c | sort -nr
# ============================================================
# 脚本结束
# ============================================================


# 第十一章：生产环境综合故障排查思路

这一章将前面知识整合起来，形成实际运维工作中可以复用的故障排查流程。

## 9.1 服务器突然变慢

第一步：检查整体负载。

```bash
uptime
top
```

第二步：检查 CPU。

```bash
mpstat -P ALL 1
pidstat -u 1
```

第三步：检查内存。

```bash
free -h
vmstat 1 5
```

第四步：检查磁盘 I/O。

```bash
iostat -xz 1 5
iotop -o
```

第五步：检查网络。

```bash
ss -s
ip -s link
```

第六步：查看系统日志。

```bash
journalctl -p err -b
dmesg -T | tail -n 100
```

## 9.2 服务器 CPU 突然升高

```text
uptime
   |
   v
top 查看 CPU
   |
   v
定位高 CPU 进程
   |
   v
top -H -p PID
   |
   v
定位高 CPU 线程
   |
   v
pidstat / perf 分析
   |
   v
判断应用计算、系统调用或软中断问题
```

## 9.3 服务器内存不足

```text
free -h
   |
   v
available 是否持续下降？
   |
   v
vmstat 查看 si / so
   |
   v
ps / top 查看进程内存
   |
   v
检查 /proc/PID/smaps_rollup
   |
   v
判断用户进程或内核内存问题
   |
   v
检查 OOM 日志和 cgroup 限制
```

## 9.4 磁盘空间不足

```text
df -h / df -i
       |
       v
区分空间耗尽还是 inode 耗尽
       |
       v
du -xh --max-depth=1
       |
       v
定位大目录或小文件堆积
       |
       v
df 和 du 结果是否一致？
       |
       v
检查 lsof +L1
       |
       v
确认原因并安全处理
```

## 9.5 网络无法连接

```text
ip addr
    |
    v
ip link
    |
    v
ip route
    |
    v
ip neigh
    |
    v
ping 网关
    |
    v
ping 目标 IP
    |
    v
dig DNS
    |
    v
ss 检查端口
    |
    v
tcpdump 抓包
```

---

# 第十章：常用运维命令速查表

| 分类 | 命令 | 主要作用 |
|---|---|---|
| 系统启动 | systemctl get-default | 查看默认启动目标 |
| 系统启动 | systemctl --failed | 查看启动失败服务 |
| 日志 | journalctl -b | 查看本次启动日志 |
| 日志 | journalctl -u nginx | 查看指定服务日志 |
| 进程 | ps -ef | 查看进程 |
| 进程 | ps aux | 查看进程资源占用 |
| 进程 | pstree -p | 查看进程树 |
| 进程 | pgrep -a nginx | 查询进程 |
| 进程 | top -H -p PID | 查看进程线程 |
| CPU | uptime | 查看负载 |
| CPU | top | 查看 CPU 和进程 |
| CPU | vmstat 1 | 查看系统运行情况 |
| CPU | mpstat -P ALL 1 | 查看每个 CPU 核心 |
| CPU | pidstat -u 1 | 查看进程 CPU |
| 内存 | free -h | 查看内存 |
| 内存 | cat /proc/meminfo | 查看内存详情 |
| 内存 | pmap -x PID | 查看进程内存映射 |
| 内存 | slabtop | 查看内核 Slab |
| OOM | dmesg -T | 查看内核日志 |
| 磁盘 | lsblk -f | 查看块设备 |
| 磁盘 | blkid | 查看 UUID |
| 磁盘 | df -h | 查看磁盘空间 |
| 磁盘 | df -i | 查看 inode |
| 磁盘 | du -sh | 查看目录占用 |
| 磁盘 | lsof +L1 | 查看已删除但仍打开的文件 |
| LVM | pvs / vgs / lvs | 查看 LVM |
| RAID | cat /proc/mdstat | 查看软件 RAID |
| 文件系统 | xfs_repair -n | 检查 XFS |
| 文件系统 | e2fsck -f | 检查 ext4 |
| I/O | iostat -xz 1 | 查看磁盘 I/O |
| I/O | iotop -o | 查看进程 I/O |
| I/O | pidstat -d 1 | 查看进程磁盘 I/O |
| 网络 | ip addr | 查看 IP |
| 网络 | ip link | 查看网卡 |
| 网络 | ip route | 查看路由 |
| 网络 | ip neigh | 查看 ARP |
| 网络 | ss -lntup | 查看监听端口 |
| 网络 | ss -tnp | 查看 TCP 连接 |
| 网络 | dig | DNS 查询 |
| 网络 | ping | 网络连通性 |
| 网络 | traceroute | 路由跟踪 |
| 网络 | mtr | 综合网络路径诊断 |
| 网络 | ethtool | 查看网卡信息 |
| 网络 | tcpdump | 网络抓包 |
| 网络 | nmcli | NetworkManager 管理 |





