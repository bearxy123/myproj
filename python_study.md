# Python 基础入门
好的。我们正式开始 Python 系统学习课程。
后续我会按照之前制定的 8 个阶段教学，采用从零开始、逐个知识点讲解、代码实践、练习考核、批改纠错、达标后进入下一课的方式进行。
考虑到你是在 Linux 环境学习，并且有 Linux Shell 基础，我们会尽量使用 Linux 实际运维场景作为代码示例，但不会默认你已经掌握 Python。
# Python 系统学习课程
当前学习进度
第一阶段
# 第 1 / 8 阶段
Python 基础概念与运行环境
当前课程：第一课 · Python 基础概念
学习环境
Linux
教学方式
零基础详细讲解
考核标准
满分 100，达到 80 分进入下一课
# 第一阶段：Python 基础概念
## 第一课：认识 Python 和运行环境
本课分成 6 个知识点，我们一次只讲一个知识点，不会一次性把所有内容灌输给你。
本课知识点安排
1. 当前学习
   Python 是什么？解释器是什么？
   理解 Python 的基本概念和运行机制。
2. Linux 下 Python 环境安装与版本管理
   掌握 python3、pip、环境检查。
3. Python 程序文件与执行方式
   理解 .py 文件、解释器执行和脚本权限。
4. print() 输出函数
   掌握程序输出信息的基本方式。
5. 注释与缩进
   掌握 Python 的代码规范和语法结构。
6. 第一课综合练习
   独立编写一个简单的 Python 程序。
# 知识点 1：Python 是什么？
## 1.1 Python 的基本定义
Python 是一种高级编程语言，具有语法简单、可读性强、生态丰富等特点。
我们先理解几个概念。
（1）什么是编程语言？
计算机本身并不能直接理解我们日常使用的中文或英文。
计算机最终执行的是机器指令，而编程语言就是我们用来编写程序、描述执行逻辑的工具。
例如，你想让 Linux 系统完成以下工作：
1. 获取 CPU 使用率。
2. 获取内存使用率。
3. 判断 CPU 是否超过 90%。
4. 如果超过 90%，输出告警信息。
这些工作可以通过 Shell 实现，也可以通过 Python 实现。
Shell 示例：
```
#!/bin/bash
echo "开始检查服务器"
uptime
free -h
df -h
```
Python 示例：
```
print("开始检查服务器")
```
两者都可以实现自动化任务，但 Python 更适合组织复杂的数据处理逻辑、业务判断和模块化程序。
（2）什么是高级编程语言？
高级语言是相对于机器指令而言的。
例如：
```
print("Hello Python")
```
我们只需要编写一条简单的语句，就可以让程序输出文字，而不需要自己编写底层机器指令。
因此，Python 属于高级编程语言。
（3）什么是解释型语言？
这是一个比较重要的概念。
你可能知道 C 语言的编译过程：
```
C语言源代码
    |
    v
编译器
    |
    v
机器代码
    |
    v
执行程序
```
而 Python 通常采用解释器执行：
```
Python源代码（.py）
       |
       v
Python解释器
       |
       v
编译为字节码
       |
       v
Python虚拟机执行
       |
       v
程序运行结果
```
注意：Python 并不是简单地逐行直接翻译成机器码。以 CPython 为例，源代码通常先编译成字节码，再由 Python 虚拟机执行。
## 1.2 什么是 Python 解释器？
这是今天最重要的概念之一。
Python 解释器就是负责执行 Python 程序的软件。
例如，在 Linux 中执行：
```
python3 test.py
```
实际上发生了什么？
- `python3`：调用 Python 解释器。
- `test.py`：告诉解释器需要执行哪个 Python 程序。
- 解释器：读取程序、编译并执行。
- 最终：将程序运行结果输出到终端。
可以理解为：

| 名称              | 作用              |
| --------------- | --------------- |
| Python          | 编程语言            |
| Python 解释器      | 执行 Python 程序的软件 |
| test.py         | Python 源代码文件    |
| python3 test.py | 执行程序的命令         |

## 1.3 Python 能做什么？
结合 Linux 运维工作，Python 常见应用如下：

| 应用领域   | 实际应用           |
| ------ | -------------- |
| 自动化运维  | 批量巡检服务器        |
| 系统管理   | 获取 CPU、内存、磁盘信息 |
| 文件处理   | 分析系统日志         |
| 网络管理   | 检查端口和网络连通性     |
| 自动化部署  | 批量执行部署任务       |
| 数据处理   | 统计巡检数据         |
| Web 开发 | 开发运维管理平台       |
| 自动化测试  | 测试操作系统和软件功能    |

你目前不需要了解所有应用领域，先把 Linux 自动化运维作为主要学习方向。
## 1.4 第一个 Python 程序
现在我们动手实践。
请在 Linux 终端执行：
第一步：查看 Python 版本
```
python3 --version
```
例如：
```
Python 3.12.3
```
第二步：进入 Python 交互模式
```
python3
```
如果成功，会看到类似：
```
Python 3.12.3
>>>
```
这里的 `>>>` 表示 Python 交互式解释器已经启动，可以直接输入 Python 代码。
输入：
```
print("Hello Python")
```
输出：
```
Hello Python
```
退出交互模式：
```
exit()
```
也可以使用 `Ctrl + D`。
第三步：理解两种运行方式

| 运行方式 | 命令              | 特点         |
| ---- | --------------- | ---------- |
| 交互模式 | python3         | 输入一条执行一条   |
| 脚本模式 | python3 test.py | 执行保存好的程序文件 |

两种方式后面都会用到。
# 知识点 1：阶段练习
现在先不要继续学习下一个知识点。
请完成下面的练习，我会根据你的回答进行批改。
基础知识理解测试
5 道单选题
1\. Python 属于哪一种编程语言？
机器语言
高级编程语言
汇编语言
Shell 专用语言
2\. Python 解释器的主要作用是什么？
编写 Linux 内核
执行 Python 程序
管理 Linux 用户
安装操作系统
3\. 在 Linux 中，执行 Python 文件 test.py 的常用命令是什么？
bash test.py
gcc test.py
python3 test.py
systemctl test.py
4\. CPython 通常会先将 Python 源代码编译成什么？
Shell 脚本
字节码
HTML 文件
SQL 文件
5\. 下面哪种方式属于 Python 交互模式？
python3 test.py
python3
bash test.py
pip install
好的，我们继续下一课。
按照之前的学习路线，当前进入：
# 第一阶段 · 第二课：Linux 下 Python 环境安装与版本管理
本课从零开始，重点理解 Python 在 Linux 中是如何安装、管理和运行的。
课程进度
知识点 2 / 6
# Python 环境管理
预计学习时间：30～45 分钟
本课学习内容：
1. Python 环境的组成
2. 查看 Python 版本
3. Linux 安装 Python
4. Python 解释器路径
5. pip 包管理工具
6. Python 多版本管理基础
## 一、什么是 Python 运行环境？
首先理解一个概念：Python 运行环境不是单独一个 Python 命令，而是一组能够支持 Python 程序运行的软件和配置。
通常包括：

| 组成         | 作用               |
| ---------- | ---------------- |
| Python 解释器 | 执行 Python 程序     |
| pip        | 安装和管理 Python 软件包 |
| 标准库        | 提供文件、系统、网络等功能    |
| 第三方库       | 提供额外的开发功能        |
| 环境变量 PATH  | 帮助系统找到 Python 命令 |
| 虚拟环境       | 隔离不同项目的依赖        |

可以理解为：
```
Linux 操作系统
    |
    +-- Python 解释器
    |      |
    |      +-- 标准库
    |      |
    |      +-- pip
    |      |
    |      +-- 第三方库
    |
    +-- Python 项目
           |
           +-- 项目代码
           +-- 项目依赖
           +-- 虚拟环境
```
这里先记住一个重点：
Python 解释器负责运行程序，pip 负责安装库，两者不是同一个东西。
## 二、查看 Linux 中的 Python 环境
在 Linux 中，我们通常通过命令查看 Python 环境。
### 2.1 查看 Python 版本
```
python3 --version
```
例如：
```
Python 3.12.3
```
也可以：
```
python3 -V
```
两条命令作用相同。
为什么使用 `python3` 而不是 `python`？
因为部分 Linux 系统中，`python` 可能不存在，也可能指向其他 Python 版本。使用 `python3` 可以明确表示调用 Python 3 解释器。
### 2.2 查看 Python 命令的位置
```
which python3
```
例如：
```
/usr/bin/python3
```
这表示当前 Shell 通过 PATH 找到的 Python 命令位置。
进一步查看实际路径：
```
readlink -f "$(which python3)"
```
例如：
```
/usr/bin/python3.12
```
注意：`which` 查找的是 PATH 中的命令，而不是系统中所有可能存在的 Python 安装位置。
### 2.3 查看 Python 详细信息
进入交互模式：
```
python3
```
执行：
```
import sysprint(sys.version)print(sys.executable)print(sys.path)
```
分别表示：

| 属性             | 作用             |
| -------------- | -------------- |
| sys.version    | Python 版本信息    |
| sys.executable | 当前解释器的实际路径     |
| sys.path       | Python 搜索模块的路径 |

例如：
```
/usr/bin/python3
```
这就能帮助我们确定当前运行程序使用的是哪个 Python 解释器。
## 三、Linux 中如何安装 Python？
Python 在不同 Linux 发行版中的安装方式有所区别。
### 3.1 Debian / Ubuntu
```
apt update
apt install python3 -y
apt install python3-pip -y
```
安装完成后检查：
```
python3 --version
pip3 --version
```
### 3.2 openEuler / RHEL 系
通常使用：
```
dnf install python3 -y
```
安装 pip：
```
dnf install python3-pip -y
```
检查：
```
python3 --version
pip3 --version
```
不同发行版的软件包名称和默认 Python 版本可能不同，具体以软件源提供的版本为准。
特别注意：不要随意替换系统 Python
Linux 某些系统工具依赖系统自带的 Python 环境。
不要随意删除 `/usr/bin/python3`，也不要擅自修改系统 Python 软链接，否则可能影响系统管理工具正常运行。
学习和开发建议使用独立虚拟环境。
## 四、什么是 pip？
pip 是 Python 的包管理工具。
举个例子：
你希望通过 Python 获取 Linux 的 CPU、内存、磁盘信息。
Python 本身提供了一些基础功能，但如果想更方便地获取系统资源信息，可以安装第三方库 `psutil`。
安装：
```
pip3 install psutil
```
然后在 Python 程序中：
```
import psutilprint(psutil.cpu_percent(interval=1))
```
这里：
- `pip3 install psutil`：安装 psutil。
- `import psutil`：在程序中导入 psutil。
- `psutil.cpu_percent()`：调用库提供的功能。
### 4.1 pip 常用命令

| 命令                               | 作用        |
| -------------------------------- | --------- |
| pip3 --version                   | 查看 pip 版本 |
| pip3 list                        | 查看已安装的库   |
| pip3 install requests            | 安装库       |
| pip3 uninstall requests          | 卸载库       |
| pip3 show requests               | 查看库的信息    |
| pip3 freeze                      | 输出依赖列表    |
| pip3 install -r requirements.txt | 批量安装依赖    |

注意：实际操作中建议使用 `python3 -m pip`，这样可以明确指定 pip 属于哪个 Python 解释器。
例如：
```
python3 -m pip --version
python3 -m pip list
```
## 五、什么是 Python 虚拟环境？
这是本课需要理解的一个重要知识点。
假设你有两个 Python 项目：
```
项目 A：需要 requests 2.28
项目 B：需要 requests 2.32
```
如果所有项目都使用系统全局 Python 环境，依赖版本可能产生冲突。
因此，Python 提供了虚拟环境机制。
虚拟环境就是为某个 Python 项目创建相对独立的 Python 包安装环境。
### 5.1 创建虚拟环境
先创建项目目录：
```
mkdir python_project
cd python_project
```
创建虚拟环境：
```
python3 -m venv venv
```
目录大致如下：
```
python_project/
└── venv/
    ├── bin/
    │   ├── python
    │   └── pip
    ├── include/
    ├── lib/
    └── pyvenv.cfg
```
### 5.2 激活虚拟环境
```
source venv/bin/activate
```
激活后，终端一般会出现：
```
(venv) root@server:~/python_project#
```
这里的 `(venv)` 就表示当前激活了虚拟环境。
### 5.3 在虚拟环境安装第三方库
```
python -m pip install psutil
```
检查：
```
python -m pip list
```
### 5.4 退出虚拟环境
```
deactivate
```
退出后，终端前面的 `(venv)` 会消失。
### 5.5 为什么推荐使用虚拟环境？

| 对比   | 系统全局环境 | 虚拟环境       |
| ---- | ------ | ---------- |
| 依赖隔离 | 不隔离    | 相对独立       |
| 版本管理 | 容易冲突   | 项目间可使用不同版本 |
| 项目管理 | 不方便    | 更清晰        |
| 推荐程度 | 谨慎使用   | 推荐         |

## 六、本课知识点总结
到这里，你需要理解以下概念：

| 知识点       | 必须掌握的内容              |
| --------- | -------------------- |
| Python 版本 | python3 --version    |
| 解释器路径     | which、sys.executable |
| Python 环境 | 解释器、标准库、第三方库         |
| pip       | 安装、卸载、查看第三方库         |
| 虚拟环境      | 创建、激活、退出             |
| Linux 安装  | apt、dnf              |

# 七、本课实践任务
现在开始实际操作。
建议使用你之前的 Linux 测试环境，不要在生产服务器上随意安装或修改系统 Python。
任务 1：查看当前环境
```
python3 --version
which python3
readlink -f "$(which python3)"
python3 -m pip --version
```
任务 2：创建自己的 Python 项目
```
mkdir -p ~/python_learning/lesson02
cd ~/python_learning/lesson02
python3 -m venv venv
source venv/bin/activate
```
任务 3：检查虚拟环境
```
which python
python --version
python -m pip --version
```
任务 4：安装 psutil
```
python -m pip install psutil
```
任务 5：验证第三方库
创建 `test.py`：
```
import psutilprint("CPU使用率：", psutil.cpu_percent(interval=1))print("内存使用率：", psutil.virtual_memory().percent)print("磁盘使用率：", psutil.disk_usage("/").percent)
```
执行：
```
python test.py
```
如果能够输出 CPU、内存、磁盘使用率，说明你已经完成了本课的核心实践。
# 八、本课考核
下面有 5 道理论题，完成后还需要提交实际操作结果。
第二课理论考核
100 分
1\. Linux 中查看 Python 版本的命令是什么？
python3 --version
python3 --install
python3 --show
python3 --list
2\. pip 的主要作用是什么？
执行 Python 程序
管理和安装 Python 包
管理 Linux 进程
编译 Linux 内核
3\. sys.executable 可以查看什么？
Python 版本
当前解释器路径
CPU 使用率
pip 安装列表
4\. 创建 Python 虚拟环境的正确命令是什么？
python3 -m venv venv
pip3 create venv
python3 --venv
apt install venv
5\. 激活虚拟环境的命令是什么？
deactivate
python3 venv
source venv/bin/activate
pip3 activate
好，我们进入下一章节。
前面已经学习了 Python 的运行环境、虚拟环境，以及如何区分系统 Python 和项目虚拟环境。接下来开始学习 Python 最基础、也是后续所有程序都离不开的知识：变量与数据类型。
# 第一阶段：Python 基础
## 第三课：变量与数据类型
本课按照知识点逐个学习，先从变量开始。掌握后再学习数据类型。
### 知识点 1：什么是变量？
1\. 变量的基本概念
在 Python 中，变量可以理解为一个用于保存数据的名称。
例如：
```
name = "Linux"age = 18
```
这里：
- `name` 是变量名称。
- `"Linux"` 是变量保存的数据。
- `age` 是变量名称。
- `18` 是变量保存的数据。
你可以把变量理解成一个有名字的容器。
[Eduzza](https://images.openai.com/static-rsc-4/ZbgnbgIq1GfrHoglMPVn4Ms1LJvM0lfdOR-Vo7xbHZmVr1LU6en412EYlsym9PYX_gEacTh4cH9RkQOmcvR8Pet6Wr7jDFEkRVqznCx5vI3A9-bOvhWNmfGLwGifBq70IcGfiIhQQ-1l_SWH8HtVNjfUJGmyOegTor5oDQsIgyc?purpose=inline)
[eduzza.com](https://eduzza.com/blogs/python-variables-and-assignment?utm_source=chatgpt.com)
2\. 如何定义变量？
Python 定义变量非常简单：
```
变量名称 = 数据
```
例如：
```
hostname = "server01"cpu_usage = 35memory_usage = 68.5
```
分别表示：

| 变量             | 保存的数据        | 含义      |
| -------------- | ------------ | ------- |
| `hostname`     | `"server01"` | 主机名称    |
| `cpu_usage`    | `35`         | CPU 使用率 |
| `memory_usage` | `68.5`       | 内存使用率   |

注意：Python 中的 `=` 是赋值符号，不是数学中的相等判断。
例如：
```
a = 10
```
意思是把数字 `10` 赋值给变量 `a`。
3\. 如何使用变量？
定义变量之后，可以直接使用：
```
hostname = "server01"print(hostname)
```
输出：
```
server01
```
也可以进行计算：
```
cpu_usage = 30memory_usage = 60total = cpu_usage + memory_usageprint(total)
```
输出：
```
90
```
这里的执行过程是：
1. 创建变量 `cpu_usage`，保存数字 30。
2. 创建变量 `memory_usage`，保存数字 60。
3. 将两个变量的值相加。
4. 把结果 90 保存到 `total`。
5. 使用 `print()` 输出结果。
4\. Python 变量命名规则
变量名称需要遵循以下规则：

| 规则              | 示例                    |
| --------------- | --------------------- |
| 可以包含字母、数字和下划线   | `cpu_usage`           |
| 不能以数字开头         | `1cpu` 不合法            |
| 不能使用 Python 关键字 | `if`、`for` 不合法        |
| 区分大小写           | `name` 和 `Name` 是不同变量 |
| 建议使用有意义的名称      | `memory_usage` 优于 `a` |

建议使用小写字母加下划线的方式命名，这也是 Python 常见的命名风格。
5\. 一个 Linux 运维场景示例
假设我们要编写一个简单的 Linux 系统巡检程序：
```
hostname = "server01"cpu_usage = 45memory_usage = 72disk_usage = 85print("主机名称：", hostname)print("CPU使用率：", cpu_usage, "%")print("内存使用率：", memory_usage, "%")print("磁盘使用率：", disk_usage, "%")
```
输出：
```
主机名称： server01
CPU使用率： 45 %
内存使用率： 72 %
磁盘使用率： 85 %
```
你可以看到，变量的作用就是保存数据，方便后续进行计算、判断、输出和处理。
## 六、动手练习
请在你的 Linux 虚拟环境中创建一个文件：
```
cd ~/python_learning
vim lesson03.py
```
编写下面的程序：
```
# 定义主机基本信息hostname = "linux-server01"ip_address = "192.168.1.100"cpu_usage = 35memory_usage = 68disk_usage = 82# 输出主机信息print("主机名称：", hostname)print("IP地址：", ip_address)print("CPU使用率：", cpu_usage, "%")print("内存使用率：", memory_usage, "%")print("磁盘使用率：", disk_usage, "%")
```
运行：
```
python lesson03.py
```
## 七、知识点考核
请回答下面 5 道题。
变量基础测试
1\. Python 中如何定义一个变量？
var a = 10
a = 10
int a = 10
正确
2\. 下面哪个变量名称合法？
1cpu
cpu-usage
cpu_usage
正确
3\. 下面代码的输出是什么？\
a = 10\
b = 20\
print(a + b)
1020
30
a+b
正确
4\. Python 中变量名是否区分大小写？
区分
不区分
正确
5\. 下面哪个是正确的赋值操作？
10 = age
age == 10
age = 10
正确
提交答案
## 得分：100/100
全部正确！
本节通过标准：
- 理论测试达到 80 分。
- 能独立编写并运行上面的 Linux 主机信息程序。
- 能解释变量、赋值和变量命名规则。
完成后把代码运行结果和测试答案发给我，我会逐项批改。通过后，我们继续学习下一个知识点：Python 的基本数据类型（整数、浮点数、字符串和布尔值）。
好的，变量这一节按你反馈的结果视为全部通过，不再重复考核。我们直接继续下一知识点。
# 第三课：Python 基本数据类型
本节学习 Python 最常见的四种基本数据类型：
1. 整数（`int`）
2. 浮点数（`float`）
3. 字符串（`str`）
4. 布尔值（`bool`）
这四种类型在 Linux 自动化运维中非常常见。
## 一、整数类型（int）
整数就是没有小数部分的数字。
例如：
```
cpu_count = 8memory_size = 32process_count = 125
```
这些变量保存的都是整数。
实际运维场景：
```
cpu_count = 16memory_gb = 64disk_count = 4print("CPU核心数：", cpu_count)print("内存容量：", memory_gb)print("磁盘数量：", disk_count)
```
输出：
```
CPU核心数： 16
内存容量： 64
磁盘数量： 4
```
整数可以进行数学运算：
```
a = 10b = 3print(a + b)  # 加法print(a - b)  # 减法print(a * b)  # 乘法print(a // b) # 整除print(a % b)  # 取余
```
输出：
```
13
7
30
3
1
```
注意两个运算符：
- `//`：整除，只保留整数部分。
- `%`：取余，返回除法后的余数。
## 二、浮点数类型（float）
浮点数就是带有小数部分的数字。
例如：
```
cpu_usage = 35.5memory_usage = 68.2disk_usage = 85.75
```
在 Linux 运维中，CPU、内存和磁盘使用率经常使用浮点数表示。
例如：
```
cpu_usage = 35.5memory_usage = 68.2print("CPU使用率：", cpu_usage, "%")print("内存使用率：", memory_usage, "%")
```
输出：
```
CPU使用率： 35.5 %
内存使用率： 68.2 %
```
浮点数也可以进行计算：
```
a = 10.5b = 2.5print(a + b)print(a - b)print(a * b)print(a / b)
```
输出：
```
13.0
8.0
26.25
4.2
```
注意：浮点数存在精度问题。
例如：
```
a = 0.1b = 0.2print(a + b)
```
输出可能是：
```
0.30000000000000004
```
这是因为计算机使用二进制表示浮点数时，某些十进制小数无法被精确表示。
在后续开发中，如果涉及金额等精确计算，可以学习使用 `decimal` 模块。
## 三、字符串类型（str）
字符串就是文本数据。
Python 中字符串需要使用引号包围。
例如：
```
hostname = "server01"ip_address = "192.168.1.100"system_name = "Ubuntu"
```
单引号和双引号都可以：
```
name = "Linux"system = 'Ubuntu'
```
两者没有本质区别。
1\. 字符串拼接
```
first = "Linux"second = "Python"result = first + secondprint(result)
```
输出：
```
LinuxPython
```
如果需要添加空格：
```
result = first + " " + secondprint(result)
```
输出：
```
Linux Python
```
2\. 字符串与数字
下面这段代码会报错：
```
cpu_usage = 80result = "CPU使用率：" + cpu_usageprint(result)
```
因为字符串和整数不能直接使用 `+` 拼接。
需要将整数转换成字符串：
```
cpu_usage = 80result = "CPU使用率：" + str(cpu_usage)print(result)
```
输出：
```
CPU使用率：80
```
这里的 `str()` 是类型转换函数，后面会继续学习。
3\. f-string 格式化字符串
这是 Python 中非常常用的字符串处理方式。
```
hostname = "server01"cpu_usage = 75.5memory_usage = 68print(f"主机名称：{hostname}")print(f"CPU使用率：{cpu_usage}%")print(f"内存使用率：{memory_usage}%")
```
输出：
```
主机名称：server01
CPU使用率：75.5%
内存使用率：68%
```
注意：
- 字符串前面加 `f`。
- 使用 `{}` 包围变量名称。
- Python 会自动将变量值放入字符串中。
以后编写巡检报告、日志信息时，f-string 会非常有用。
## 四、布尔类型（bool）
布尔类型只有两个值：
```
TrueFalse
```
分别表示：
- `True`：真。
- `False`：假。
注意首字母必须大写。
例如：
```
service_status = Truedisk_warning = Falseprint(service_status)print(disk_warning)
```
输出：
```
True
False
```
实际运维场景：
```
disk_usage = 95disk_warning = disk_usage > 90print(disk_warning)
```
输出：
```
True
```
因为磁盘使用率 95 大于 90，所以结果为 `True`。
这就是布尔类型在系统监控和告警判断中的典型应用。
## 五、如何查看变量的数据类型？
Python 提供了一个非常重要的内置函数：
```
type()
```
例如：
```
a = 100b = 85.5c = "Linux"d = Trueprint(type(a))print(type(b))print(type(c))print(type(d))
```
输出：
```
<class 'int'>
<class 'float'>
<class 'str'>
<class 'bool'>
```
对应关系：

| 数据        | 类型      | 说明  |
| --------- | ------- | --- |
| `100`     | `int`   | 整数  |
| `85.5`    | `float` | 浮点数 |
| `"Linux"` | `str`   | 字符串 |
| `True`    | `bool`  | 布尔值 |

## 六、Linux 运维综合示例
现在把前面四种数据类型结合起来，编写一个简单的系统状态判断程序：
```
# 主机基本信息hostname = "server01"ip_address = "192.168.1.100"# 系统资源使用情况cpu_usage = 45.5memory_usage = 78.2disk_usage = 92.5# 判断磁盘是否告警disk_warning = disk_usage > 90# 输出巡检结果print("========== Linux系统巡检 ==========")print(f"主机名称：{hostname}")print(f"IP地址：{ip_address}")print(f"CPU使用率：{cpu_usage}%")print(f"内存使用率：{memory_usage}%")print(f"磁盘使用率：{disk_usage}%")print(f"磁盘是否告警：{disk_warning}")
```
运行后可以看到：
```
========== Linux系统巡检 ==========
主机名称：server01
IP地址：192.168.1.100
CPU使用率：45.5%
内存使用率：78.2%
磁盘使用率：92.5%
磁盘是否告警：True
```
你可以看到，实际项目中通常会同时使用多种数据类型：
- 主机名称、IP 地址：字符串。
- CPU、内存、磁盘使用率：浮点数。
- CPU 核心数、进程数量：整数。
- 是否告警、服务是否正常：布尔值。
## 七、本节练习
在 Linux 中创建文件：
```
vim ~/python_learning/data_type.py
```
编写下面的程序：
```
hostname = "linux-server01"cpu_usage = 65.5memory_usage = 72disk_usage = 91.5service_running = Trueprint(f"主机：{hostname}")print(f"CPU：{cpu_usage}%")print(f"内存：{memory_usage}%")print(f"磁盘：{disk_usage}%")print(f"服务运行状态：{service_running}")print(type(hostname))print(type(cpu_usage))print(type(memory_usage))print(type(disk_usage))print(type(service_running))
```
运行：
```
python ~/python_learning/data_type.py
```
## 八、知识点考核
基本数据类型测试
1\. 变量 a = 100 的数据类型是什么？
float
int
str
正确
2\. 变量 a = 85.5 的数据类型是什么？
int
bool
float
正确
3\. 下面哪个是正确的布尔值？
true
TRUE
True
正确
4\. 查看变量数据类型应该使用哪个函数？
print()
type()
input()
正确
5\. 下面代码输出什么？\
a = 90\
print(a > 80)
True
False
90
正确
提交答案
## 得分：100/100
通过标准：理论成绩达到 80 分，并完成实践程序。
下一知识点我们学习：Python 数据类型转换与 input() 输入函数。这两个知识点对于编写交互式 Linux 运维工具非常重要。
好的，我们继续 Python 学习课程。
接下来进入第一阶段：Python 基础语法中的下一个知识点——类型转换与 input() 输入函数。
这个知识点非常重要。以后编写 Linux 自动化运维脚本时，经常需要读取用户输入的参数、转换数据类型，再进行计算和判断。
# 第一阶段 · 第四课：类型转换与 input() 输入函数
## 一、为什么需要类型转换？
先看一个例子：
```
cpu_usage = "80"threshold = 90print(cpu_usage + threshold)
```
运行后会报错：
```
TypeError: can only concatenate str (not "int") to str
```
为什么？
因为：
- `cpu_usage` 是字符串类型 `str`，内容虽然是数字 80，但它本质上还是文本。
- `threshold` 是整数类型 `int`。
- Python 不允许直接将字符串和整数相加。
可以通过类型转换解决这个问题：
```
cpu_usage = "80"threshold = 90cpu_usage = int(cpu_usage)print(cpu_usage + threshold)
```
输出：
```
170
```
核心概念：类型转换就是将一个数据转换成另一种数据类型，以便进行相应的操作。
## 二、常见的类型转换函数
Python 中最常用的类型转换函数有四个。
### 1. int()：转换为整数
```
a = "100"b = int(a)print(b)print(type(b))
```
输出：
```
100
<class 'int'>
```
注意以下情况：
```
print(int("100"))    # 100print(int("100.5"))  # 报错print(int(100.9))    # 100
```
这里需要注意：
- 字符串 `"100"` 可以转换成整数。
- 字符串 `"100.5"` 不能直接转换成整数。
- 浮点数 `100.9` 转换成整数时，会直接截去小数部分，不是四舍五入。
如果需要把 `"100.5"` 转换成整数，可以这样：
```
a = "100.5"b = int(float(a))print(b)
```
输出：
```
100
```
### 2. float()：转换为浮点数
```
a = "85.5"b = float(a)print(b)print(type(b))
```
输出：
```
85.5
<class 'float'>
```
常见情况：
```
print(float("100"))    # 100.0print(float("85.5"))   # 85.5print(float(100))      # 100.0
```
Linux 运维场景：
CPU、内存、磁盘使用率通常会带有小数，因此使用 `float()` 比较合适。
### 3. str()：转换为字符串
```
cpu_usage = 80result = str(cpu_usage)print(result)print(type(result))
```
输出：
```
80
<class 'str'>
```
什么时候使用？
例如，想把巡检结果组合成字符串：
```
hostname = "server01"cpu_usage = 80message = "主机：" + hostname + "，CPU使用率：" + str(cpu_usage) + "%"print(message)
```
输出：
```
主机：server01，CPU使用率：80%
```
当然，也可以使用之前学习的 f-string：
```
print(f"主机：{hostname}，CPU使用率：{cpu_usage}%")
```
### 4. bool()：转换为布尔值
```
print(bool(1))       # Trueprint(bool(0))       # Falseprint(bool(""))      # Falseprint(bool("Linux")) # True
```
需要特别注意：
```
print(bool("False"))
```
输出：
```
True
```
为什么？
因为 Python 判断字符串是否为真，主要看字符串是否为空，而不是判断字符串的内容是不是 `"False"`。

| 数据        | bool() 结果 |
| --------- | --------- |
| `0`       | False     |
| `1`       | True      |
| `""`      | False     |
| `"Linux"` | True      |
| `"False"` | True      |
| `[]`      | False     |
| `[1, 2]`  | True      |

记住一个规律：
数字 0、空字符串、空列表等空值通常转换为 False；其他非空值通常转换为 True。
## 三、input()：获取用户输入
这是本节的重点。
在 Python 中，`input()` 用于接收用户输入的数据。
基本语法：
```
变量 = input("提示信息")
```
例如：
```
hostname = input("请输入主机名称：")print(hostname)
```
运行：
```
请输入主机名称：server01
server01
```
### 1. input() 返回的是什么类型？
这是一个非常重要的知识点：
无论用户输入的是数字、字母还是其他内容，input() 返回的结果始终是字符串 str。
例如：
```
age = input("请输入年龄：")print(age)print(type(age))
```
即使输入：
```
18
```
输出类型仍然是：
```
<class 'str'>
```
所以，如果想让用户输入数字并进行计算，就必须进行类型转换：
```
age = input("请输入年龄：")age = int(age)print(age + 10)
```
输入：
```
18
```
输出：
```
28
```
### 2. 为什么 input() 返回字符串？
因为 Python 无法提前知道用户输入的内容究竟是什么。
用户可能输入：
```
100
```
也可能输入：
```
Linux
```
还可能输入：
```
85.5
```
因此，Python 先将用户输入的内容作为文本接收，具体需要转换成什么类型，由程序员决定。
## 四、结合 Linux 运维场景进行实践
假设我们正在编写一个简单的 Linux 巡检程序，需要用户输入磁盘告警阈值，然后输出当前磁盘使用情况。
创建文件：
```
vim input_test.py
```
编写代码：
```
# 获取主机名称hostname = input("请输入主机名称：")# 获取磁盘告警阈值threshold = input("请输入磁盘告警阈值：")# 转换为浮点数threshold = float(threshold)# 模拟当前磁盘使用率disk_usage = 85.5# 输出巡检信息print("主机名称：", hostname)print("磁盘使用率：", disk_usage)print("告警阈值：", threshold)print(f"当前磁盘使用率为：{disk_usage}%")
```
运行：
```
python3 input_test.py
```
输入：
```
请输入主机名称：server01
请输入磁盘告警阈值：80
```
输出：
```
主机名称： server01
磁盘使用率： 85.5
告警阈值： 80.0
当前磁盘使用率为：85.5%
```
这里先不引入 `if` 判断，因为条件判断属于后续课程内容。我们先把输入和类型转换掌握好。
## 五、本节需要掌握的内容

| 知识点       | 作用           |
| --------- | ------------ |
| `int()`   | 转换为整数        |
| `float()` | 转换为浮点数       |
| `str()`   | 转换为字符串       |
| `bool()`  | 转换为布尔值       |
| `input()` | 接收用户输入，返回字符串 |
| `type()`  | 查看数据类型       |

## 六、本节练习
请先完成下面的理论题，再完成实践题。
理论考核（共 5 题，每题 20 分）
1\. input() 接收到用户输入的 100 后，返回的数据类型是什么？
int
float
str
bool
回答正确input() 始终返回字符串，不会自动识别数字。
2\. 以下哪种方式可以将字符串 '85.5' 转换为浮点数？
int('85.5')
float('85.5')
str('85.5')
bool('85.5')
回答正确float() 可以将表示小数的字符串转换为浮点数。
3\. int(98.9) 的结果是什么？
99
98
98.9
报错
回答正确int() 对浮点数直接截去小数部分，不进行四舍五入。
4\. bool('False') 的结果是什么？
False
True
报错
None
回答正确非空字符串转换为布尔值时为 True。
5\. 如果用户通过 input() 输入磁盘使用率 85.5，想将它用于数值计算，应该转换成什么类型？
str
int
float
bool
回答正确磁盘使用率可能包含小数，适合使用 float。
提交并查看成绩
# 得分：100/100
达到 80 分即可通过理论考核。
实践任务：
请创建 `input_practice.py`，实现以下要求：
1. 使用 `input()` 获取主机名称。
2. 使用 `input()` 获取 CPU 使用率。
3. 使用 `input()` 获取内存使用率。
4. 将 CPU 和内存使用率转换为 `float` 类型。
5. 使用 `type()` 检查三个变量的数据类型。
6. 使用 f-string 输出格式化的巡检报告。
输出效果参考：
```
请输入主机名称：server01
请输入CPU使用率：75.5
请输入内存使用率：68.2
========== 巡检报告 ==========
主机名称：server01
CPU使用率：75.5%
内存使用率：68.2%
==============================
```
本节完成后，我们再进入运算符，学习如何让 Python 对巡检数据进行计算和比较，逐步实现真正的自动化告警判断。
好的，继续下一章节。
前面我们学习了变量、数据类型、类型转换和输入输出。接下来进入 Python 基础语法的第二阶段：运算符与表达式。
这一阶段非常重要，因为后续编写 Linux 自动化巡检程序时，需要通过运算符计算 CPU 使用率、判断磁盘是否超标、比较内存使用情况等。
# 第二阶段 · 第一课：Python 运算符
本节先学习第一组：算术运算符。我们一个知识点一个知识点地掌握，不一次性展开所有运算符。
## 一、什么是运算符？
运算符就是用于执行某种运算的符号。
例如：
```
a = 10b = 3result = a + bprint(result)
```
输出：
```
13
```
这里：
- `a` 和 `b` 是操作数。
- `+` 是运算符。
- `a + b` 是一个表达式。
- `result` 用来保存计算结果。
你可以把它理解为数学中的加减乘除，只不过 Python 提供了更多运算操作。
## 二、Python 常见算术运算符

| 运算符  | 名称       | 示例        | 结果         |
| ---- | -------- | --------- | ---------- |
| `+`  | 加法       | `10 + 3`  | `13`       |
| `-`  | 减法       | `10 - 3`  | `7`        |
| `*`  | 乘法       | `10 * 3`  | `30`       |
| `/`  | 除法       | `10 / 3`  | `3.333...` |
| `//` | 整除（向下取整） | `10 // 3` | `3`        |
| `%`  | 取模（求余数）  | `10 % 3`  | `1`        |
| `**` | 幂运算      | `10 ** 3` | `1000`     |

下面逐个讲解。
### 1. 加法 `+`
```
a = 10b = 3print(a + b)
```
输出：
```
13
```
除了数字相加，字符串也可以使用 `+` 拼接：
```
hostname = "server"number = "01"print(hostname + number)
```
输出：
```
server01
```
注意：数字相加和字符串拼接是两种不同的操作。
### 2. 减法 `-`
```
total_memory = 32used_memory = 20free_memory = total_memory - used_memoryprint(f"剩余内存：{free_memory} GB")
```
输出：
```
剩余内存：12 GB
```
在 Linux 运维中，可以用来计算剩余磁盘空间、剩余内存等。
### 3. 乘法 `*`
```
cpu_count = 8cpu_performance = 100total_performance = cpu_count * cpu_performanceprint(total_performance)
```
输出：
```
800
```
字符串也可以使用乘法：
```
print("-" * 20)
```
输出：
```
--------------------
```
### 4. 除法 `/`
```
total_memory = 32used_memory = 20usage = used_memory / total_memory * 100print(usage)
```
输出：
```
62.5
```
这里需要记住：
Python 中使用 `/` 进行除法，结果通常是 float 类型，即使能够整除也是如此。
例如：
```
print(10 / 2)print(type(10 / 2))
```
输出：
```
5.0
<class 'float'>
```
### 5. 整除 `//`
整除表示向下取整，而不是简单地删除小数部分。
```
print(10 // 3)
```
输出：
```
3
```
再看一个例子：
```
print(10 // 4)print(15 // 4)
```
输出：
```
2
3
```
注意负数的情况：
```
print(-10 // 3)
```
结果是：
```
-4
```
因为向下取整是朝负无穷方向取整，而不是向零取整。
### 6. 取模 `%`
取模用于获取除法的余数。
```
print(10 % 3)
```
输出：
```
1
```
因为：
\\[ 10 = 3 \times 3 + 1 \\]
再看几个例子：
```
print(10 % 2)  # 0print(11 % 2)  # 1print(15 % 4)  # 3
```
在实际开发中，取模经常用于判断奇偶数、周期任务、数据分组等。
例如：
```
number = 10print(number % 2)
```
结果为 `0`，说明这个数字可以被 2 整除。
### 7. 幂运算 `**`
幂运算就是数学中的乘方。
```
print(2 ** 3)
```
输出：
```
8
```
也就是：
\\[ 2^3 = 2 \times 2 \times 2 = 8 \\]
## 三、算术运算符的优先级
与数学一样，Python 也有运算优先级。
例如：
```
result = 10 + 5 * 2print(result)
```
结果：
```
20
```
因为乘法优先于加法。
如果希望先进行加法，可以使用括号：
```
result = (10 + 5) * 2print(result)
```
结果：
```
30
```
常见优先级从高到低：

| 优先级 | 运算符              |
| --- | ---------------- |
| 高   | `**`             |
|     | `*`、`/`、`//`、`%` |
| 低   | `+`、`-`          |

实际编程中，遇到复杂计算，建议使用括号明确运算顺序，避免理解错误。
## 四、结合 Linux 巡检场景实践
假设一台 Linux 服务器有以下资源：
- 总内存：64 GB
- 已使用内存：48 GB
- 总磁盘容量：1000 GB
- 已使用磁盘：850 GB
我们编写一个简单的资源计算程序。
```
# 服务器资源信息total_memory = 64used_memory = 48total_disk = 1000used_disk = 850# 计算剩余资源free_memory = total_memory - used_memoryfree_disk = total_disk - used_disk# 计算资源使用率memory_usage = used_memory / total_memory * 100disk_usage = used_disk / total_disk * 100# 输出结果print("========== Linux资源巡检 ==========")print(f"内存总量：{total_memory} GB")print(f"内存已使用：{used_memory} GB")print(f"内存剩余：{free_memory} GB")print(f"内存使用率：{memory_usage:.2f}%")print("-" * 35)print(f"磁盘总量：{total_disk} GB")print(f"磁盘已使用：{used_disk} GB")print(f"磁盘剩余：{free_disk} GB")print(f"磁盘使用率：{disk_usage:.2f}%")print("=" * 35)
```
运行结果：
```
========== Linux资源巡检 ==========
内存总量：64 GB
内存已使用：48 GB
内存剩余：16 GB
内存使用率：75.00%
-----------------------------------
磁盘总量：1000 GB
磁盘已使用：850 GB
磁盘剩余：150 GB
磁盘使用率：85.00%
===================================
```
这里我们已经初步实现了一个资源计算模块。
注意，目前数据是手动定义的，后续我们会学习使用 Python 获取 Linux 系统的真实资源信息。
## 五、本节练习
先完成下面 5 道理论题。
算术运算符理论考核
满分 100 分
1\. Python 中 10 / 2 的结果是什么？
5
5.0
2
报错
正确/ 执行普通除法，结果为浮点数。
2\. Python 中 10 // 3 的结果是什么？
3
3.33
1
4
正确// 是向下取整的整除运算。
3\. Python 中 10 % 3 的结果是什么？
3
0
1
10
正确% 返回除法的余数。
4\. Python 中 2 \*\* 4 的结果是什么？
6
8
16
24
正确\*\* 表示幂运算，即 2 的 4 次方。
5\. 表达式 10 + 5 \* 2 的结果是什么？
30
20
25
40
正确乘法优先于加法。
提交答案
# 得分：100 分
实践任务：
创建 `operator_practice.py`，要求：
1. 定义服务器总内存 `total_memory = 128`。
2. 定义已使用内存 `used_memory = 96`。
3. 计算剩余内存。
4. 计算内存使用率。
5. 定义磁盘总容量 `total_disk = 2000`，已使用容量 `used_disk = 1500`。
6. 计算磁盘剩余容量和使用率。
7. 使用 f-string 输出完整巡检报告，使用率保留两位小数。
本节考核标准仍然是：理论成绩达到 80 分，并完成实践任务，即可进入下一个知识点。
好的，我们继续。上一节学习了算术运算符，接下来学习 Python 第二组运算符：比较运算符（Comparison Operators）。
这组知识非常重要，因为以后编写 Linux 巡检程序时，需要判断 CPU、内存、磁盘使用率是否超过告警阈值。
# 第二阶段 · 第二课：比较运算符
## 一、什么是比较运算符？
比较运算符用于比较两个数据之间的关系，例如：
- 两个数字是否相等？
- CPU 使用率是否超过 80%？
- 磁盘剩余空间是否小于 10 GB？
- 两个变量的值是否不同？
比较运算的结果只有两种：
- `True`：条件成立。
- `False`：条件不成立。
例如：
```
a = 10b = 20print(a > b)
```
输出：
```
False
```
因为 10 并不大于 20。
## 二、Python 常见比较运算符

| 运算符  | 含义    | 示例         | 结果   |
| ---- | ----- | ---------- | ---- |
| `==` | 等于    | `10 == 10` | True |
| `!=` | 不等于   | `10 != 20` | True |
| `>`  | 大于    | `20 > 10`  | True |
| `<`  | 小于    | `10 < 20`  | True |
| `>=` | 大于或等于 | `10 >= 10` | True |
| `<=` | 小于或等于 | `10 <= 20` | True |

下面逐个理解。
### 1. 等于 `==`
判断两个值是否相等。
```
a = 100b = 100print(a == b)
```
输出：
```
True
```
特别注意：`=` 和 `==` 完全不同。

| 符号   | 含义             |
| ---- | -------------- |
| `=`  | 赋值，将右边的值赋给左边变量 |
| `==` | 比较，判断两边的值是否相等  |

例如：
```
a = 100print(a == 100)
```
这里先将 100 赋值给 a，再判断 a 是否等于 100。
### 2. 不等于 `!=`
判断两个值是否不同。
```
cpu_usage = 85print(cpu_usage != 80)
```
输出：
```
True
```
因为 85 不等于 80。
### 3. 大于 `>`
判断左边的值是否大于右边。
```
cpu_usage = 85print(cpu_usage > 80)
```
输出：
```
True
```
在运维中，可以用于判断 CPU 是否超过告警阈值。
### 4. 小于 `<`
判断左边的值是否小于右边。
```
free_memory = 4print(free_memory < 8)
```
输出：
```
True
```
表示剩余内存小于 8 GB。
### 5. 大于或等于 `>=`
判断左边是否大于或者等于右边。
```
disk_usage = 80print(disk_usage >= 80)
```
输出：
```
True
```
这里要注意：当磁盘使用率刚好等于 80 时，结果也是 True。
### 6. 小于或等于 `<=`
判断左边是否小于或者等于右边。
```
memory_usage = 70print(memory_usage <= 70)
```
输出：
```
True
```
## 三、比较运算符的返回值
比较运算符返回的是布尔类型 `bool`，不是字符串。
例如：
```
cpu_usage = 85result = cpu_usage > 80print(result)print(type(result))
```
输出：
```
True
<class 'bool'>
```
这里需要理解：
```
result = cpu_usage > 80
```
执行过程是：
1. 获取 `cpu_usage` 的值。
2. 判断它是否大于 80。
3. 得到 `True` 或 `False`。
4. 将判断结果赋值给 result。
这就把前面学习的变量、数据类型、运算符联系起来了。
## 四、多个比较运算符组合使用
Python 支持连续比较。
例如：
```
cpu_usage = 75print(60 < cpu_usage < 80)
```
输出：
```
True
```
它等价于：
```
print(60 < cpu_usage and cpu_usage < 80)
```
表示 CPU 使用率大于 60，同时小于 80。
不过，`and` 属于逻辑运算符，我们下一课再详细学习。
## 五、结合 Linux 巡检场景实践
假设我们要检查一台服务器的资源状态：
```
# 模拟服务器资源数据cpu_usage = 85.5memory_usage = 72.3disk_usage = 90.0# 告警阈值cpu_threshold = 80memory_threshold = 80disk_threshold = 85# 比较运算cpu_alert = cpu_usage >= cpu_thresholdmemory_alert = memory_usage >= memory_thresholddisk_alert = disk_usage >= disk_threshold# 输出判断结果print("========== 服务器巡检 ==========")print(f"CPU使用率：{cpu_usage}%")print(f"CPU是否告警：{cpu_alert}")print("-" * 30)print(f"内存使用率：{memory_usage}%")print(f"内存是否告警：{memory_alert}")print("-" * 30)print(f"磁盘使用率：{disk_usage}%")print(f"磁盘是否告警：{disk_alert}")
```
运行结果：
```
========== 服务器巡检 ==========
CPU使用率：85.5%
CPU是否告警：True
------------------------------
内存使用率：72.3%
内存是否告警：False
------------------------------
磁盘使用率：90.0%
磁盘是否告警：True
```
现在我们已经能够：
1. 定义服务器资源数据。
2. 设置告警阈值。
3. 使用比较运算符进行判断。
4. 得到 True 或 False。
5. 输出巡检结果。
下一步学习逻辑运算符后，就可以把多个判断条件组合起来。
## 六、本节练习
比较运算符理论考核
每题 20 分
1\. 10 == 10 的结果是什么？
True
False
10
报错
回答正确== 判断两个值是否相等。
2\. 10 != 20 的结果是什么？
True
False
20
报错
回答正确!= 判断两个值是否不相等。
3\. 85 >= 85 的结果是什么？
True
False
85
报错
回答正确>= 包含等于的情况。
4\. 比较运算符的返回值是什么数据类型？
str
int
float
bool
回答正确比较运算的结果为 True 或 False，类型为 bool。
5\. cpu_usage = 75，表达式 60 < cpu_usage < 80 的结果是什么？
True
False
75
报错
回答正确75 同时大于 60 且小于 80。
提交并查看成绩
# 得分：100/100
实践任务：
创建 `comparison_practice.py`，要求：
1. 定义 CPU 使用率 `cpu_usage = 85.5`。
2. 定义内存使用率 `memory_usage = 75.0`。
3. 定义磁盘使用率 `disk_usage = 90.0`。
4. 设置三个告警阈值：CPU 80、内存 80、磁盘 85。
5. 分别使用 `>`、`<`、`==`、`!=`、`>=`、`<=` 进行比较练习。
6. 输出所有比较结果，并使用 `type()` 查看结果的数据类型。
完成后把代码和运行结果发给我，我会按照之前的标准进行批改。
下一课：逻辑运算符 `and`、`or`、`not`，学习如何组合多个条件，实现更接近真实生产环境的告警判断。
好的，继续 Python 学习。
上一课我们学习了比较运算符，已经能够判断 CPU、内存、磁盘使用率是否达到告警阈值。
本节学习第三组运算符：逻辑运算符（Logical Operators）。
它是后续学习 `if` 条件判断的基础，也是编写 Linux 自动化巡检告警程序的重要知识点。
# 第二阶段 · 第三课：逻辑运算符
## 一、什么是逻辑运算符？
逻辑运算符用于组合多个条件，或者对条件结果进行取反。
例如：
一台服务器需要同时满足以下条件，才认为运行正常：
- CPU 使用率小于 80%。
- 内存使用率小于 80%。
如果 CPU 正常，但内存超过 80%，服务器就不能被判定为完全正常。
这时候就需要使用逻辑运算符。
Python 有三个主要逻辑运算符：

| 运算符   | 含义  | 作用                 |
| ----- | --- | ------------------ |
| `and` | 逻辑与 | 所有条件都成立，结果才为 True  |
| `or`  | 逻辑或 | 至少一个条件成立，结果就为 True |
| `not` | 逻辑非 | 对条件结果取反            |

## 二、and：逻辑与
`and` 表示多个条件必须同时成立。
例如：
```
cpu_usage = 60memory_usage = 70result = cpu_usage < 80 and memory_usage < 80print(result)
```
输出：
```
True
```
因为：
- CPU 使用率 60，小于 80，结果为 True。
- 内存使用率 70，小于 80，结果为 True。
- 两个条件都成立，所以最终结果为 True。
再看一个例子：
```
cpu_usage = 90memory_usage = 70result = cpu_usage < 80 and memory_usage < 80print(result)
```
输出：
```
False
```
因为 CPU 使用率已经超过 80%，即使内存正常，两个条件也没有同时成立。
### and 的真值表

| 条件 A  | 条件 B  | A and B |
| ----- | ----- | ------- |
| True  | True  | True    |
| True  | False | False   |
| False | True  | False   |
| False | False | False   |

记住：and 要求所有条件都为 True，最终结果才是 True。
## 三、or：逻辑或
`or` 表示多个条件中，只要有一个成立，最终结果就是 True。
例如：
```
cpu_usage = 90memory_usage = 70result = cpu_usage >= 80 or memory_usage >= 80print(result)
```
输出：
```
True
```
因为 CPU 使用率已经达到告警阈值，虽然内存正常，但整体告警条件已经成立。
再看一个例子：
```
cpu_usage = 60memory_usage = 70result = cpu_usage >= 80 or memory_usage >= 80print(result)
```
输出：
```
False
```
因为两个条件都没有达到告警阈值。
### or 的真值表

| 条件 A  | 条件 B  | A or B |
| ----- | ----- | ------ |
| True  | True  | True   |
| True  | False | True   |
| False | True  | True   |
| False | False | False  |

记住：or 只需要一个条件为 True，最终结果就是 True。
## 四、not：逻辑非
`not` 用于对一个条件取反。
例如：
```
service_status = Trueresult = not service_statusprint(result)
```
输出：
```
False
```
原来的值是 True，取反之后就变成 False。
再看一个 Linux 运维场景：
```
disk_usage = 60result = not (disk_usage >= 80)print(result)
```
输出：
```
True
```
原本：
```
disk_usage >= 80
```
结果为 False。
使用 `not` 之后，就变成 True。
### not 的真值表

| 条件 A  | not A |
| ----- | ----- |
| True  | False |
| False | True  |

## 五、三个逻辑运算符组合使用
实际开发中，我们通常不会只使用一个逻辑运算符。
例如：
一台服务器被判定为正常，需要满足：
1. CPU 使用率小于 80%。
2. 内存使用率小于 80%。
3. 磁盘使用率小于 90%。
可以这样编写：
```
cpu_usage = 60memory_usage = 70disk_usage = 85result = (    cpu_usage < 80    and memory_usage < 80    and disk_usage < 90)print(result)
```
输出：
```
True
```
再看一个更复杂的例子：
```
cpu_usage = 90memory_usage = 70disk_usage = 60result = (    cpu_usage >= 80    or memory_usage >= 80    or disk_usage >= 90)print(result)
```
输出：
```
True
```
这表示三个资源指标中至少有一个达到了告警阈值。
## 六、逻辑运算符的优先级
Python 中逻辑运算符也有优先级：

| 优先级 | 运算符   |
| --- | ----- |
| 高   | `not` |
| 中   | `and` |
| 低   | `or`  |

例如：
```
a = Trueb = Falsec = Trueresult = a or b and cprint(result)
```
输出：
```
True
```
因为 `and` 的优先级高于 `or`，所以相当于：
```
result = a or (b and c)
```
实际开发中，建议使用括号明确逻辑关系，尤其是复杂的告警判断：
```
result = (a or b) and c
```
这样可读性更好，也不容易出现逻辑错误。
## 七、一个重要细节：短路机制
这是逻辑运算符中比较值得理解的知识点。
Python 的 `and` 和 `or` 具有短路特性。
and：如果第一个条件已经是 False，就不再执行后面的条件。
例如：
```
a = Falseresult = a and print("执行了后面的代码")print(result)
```
输出：
```
False
```
因为第一个条件已经是 False，所以后面的 `print()` 不会执行。
or：如果第一个条件已经是 True，就不再执行后面的条件。
```
a = Trueresult = a or print("执行了后面的代码")print(result)
```
输出：
```
True
```
同样，后面的 `print()` 不会执行。
为什么要有短路机制？
主要有两个作用：
- 避免不必要的计算，提高执行效率。
- 避免执行可能产生错误的表达式。
例如：
```
a = 0result = a != 0 and 100 / a > 10print(result)
```
输出：
```
False
```
因为 `a != 0` 已经是 False，后面的除法不会执行，因此避免了除零错误。
这个机制在实际编程中非常有用。
## 八、结合 Linux 自动化巡检实践
现在把前面学习的知识组合起来。
假设我们有一台服务器，需要判断它是否存在资源告警。
告警规则：
- CPU 使用率大于或等于 80%，产生告警。
- 内存使用率大于或等于 80%，产生告警。
- 磁盘使用率大于或等于 90%，产生告警。
- 只要其中一项满足，就认为服务器存在资源告警。
代码：
```
# 模拟服务器资源数据cpu_usage = 85.5memory_usage = 75.0disk_usage = 92.0# 设置告警阈值cpu_threshold = 80memory_threshold = 80disk_threshold = 90# 分别判断资源状态cpu_alert = cpu_usage >= cpu_thresholdmemory_alert = memory_usage >= memory_thresholddisk_alert = disk_usage >= disk_threshold# 判断是否存在整体告警system_alert = (    cpu_alert    or memory_alert    or disk_alert)# 输出巡检结果print("========== Linux服务器巡检 ==========")print(f"CPU使用率：{cpu_usage}%")print(f"CPU告警：{cpu_alert}")print(f"内存使用率：{memory_usage}%")print(f"内存告警：{memory_alert}")print(f"磁盘使用率：{disk_usage}%")print(f"磁盘告警：{disk_alert}")print("-" * 40)
```
输出：
```
========== Linux服务器巡检 ==========
CPU使用率：85.5%
CPU告警：True
内存使用率：75.0%
内存告警：False
磁盘使用率：92.0%
磁盘告警：True
----------------------------------------
服务器是否存在资源告警：True
```
到这里，你已经能够组合变量、数据类型、比较运算符和逻辑运算符，完成一个简单的资源告警判断模块。
## 九、本节练习
逻辑运算符理论考核
每题 20 分
1\. True and False 的结果是什么？
True
False
None
报错
回答正确and 要求两个条件都为 True。
2\. True or False 的结果是什么？
True
False
None
报错
回答正确or 只需要至少一个条件为 True。
3\. not True 的结果是什么？
True
False
None
报错
回答正确not 对布尔结果取反。
4\. cpu=90，memory=70，cpu<80 and memory<80 的结果是什么？
True
False
90
70
回答正确CPU 条件不成立，and 的整体结果为 False。
5\. a=False，a and (100/0>1) 会发生除零错误吗？
会
不会
回答正确and 的第一个条件为 False，短路机制使后面的表达式不执行。
提交并查看成绩
# 得分：100/100
实践任务：
创建 `logic_operator.py`，实现以下要求：
1. 定义 CPU 使用率 `cpu_usage = 85.5`。
2. 定义内存使用率 `memory_usage = 75.0`。
3. 定义磁盘使用率 `disk_usage = 92.0`。
4. 设置 CPU、内存、磁盘告警阈值分别为 80、80、90。
5. 分别使用 `and`、`or`、`not` 实现条件判断。
6. 判断 CPU 和内存是否同时超过阈值。
7. 判断 CPU、内存、磁盘是否至少有一个超过阈值。
8. 使用 `not` 判断服务器是否不存在资源告警。
9. 输出所有判断结果，并使用 `type()` 检查结果类型。
本节通过标准：理论成绩达到 80 分，并完成实践任务。
下一课我们将学习 `if / elif / else`，把前面掌握的比较运算符和逻辑运算符真正用于程序流程控制，实现自动判断、自动告警。
好的，继续下一章节。
前面我们已经学习了：
- 变量与数据类型
- 类型转换与 `input()`
- 算术运算符
- 比较运算符
- 逻辑运算符
现在进入 Python 编程中非常重要的一个知识点：条件判断语句 `if / elif / else`。
从这一课开始，我们将逐步让 Python 程序具备自动判断和自动处理问题的能力。这也是以后编写 Linux 自动化巡检脚本的基础。
# 第二阶段 · 第四课：条件判断 if / elif / else
## 一、什么是条件判断？
先看一个生活中的例子：
假设服务器 CPU 使用率达到 80% 就需要告警。
那么程序需要执行以下逻辑：
- CPU 使用率大于或等于 80%：输出告警。
- CPU 使用率小于 80%：输出正常。
如果使用之前学习的比较运算符，只能得到 True 或 False。
例如：
```
cpu_usage = 85result = cpu_usage >= 80print(result)
```
输出：
```
True
```
但是，我们希望程序根据判断结果执行不同的操作。
这就需要使用 `if`。
## 二、if：单条件判断
基本语法：
```
if 条件:    条件成立时执行的代码
```
注意两个重要细节：
1. 条件后面必须有英文冒号 `:`。
2. 条件成立后执行的代码必须缩进，Python 通常使用 4 个空格。
例如：
```
cpu_usage = 85if cpu_usage >= 80:    print("CPU使用率过高")
```
运行结果：
```
CPU使用率过高
```
执行过程：
1. 定义 CPU 使用率为 85。
2. 判断 `cpu_usage >= 80`。
3. 判断结果为 True。
4. 执行缩进代码。
5. 输出告警信息。
再看一个例子：
```
cpu_usage = 60if cpu_usage >= 80:    print("CPU使用率过高")print("巡检结束")
```
输出：
```
巡检结束
```
因为条件不成立，所以 `if` 内部的代码不会执行。
但 `print("巡检结束")` 没有缩进，属于 `if` 外部代码，因此仍然会执行。
这里一定要理解：缩进决定代码属于哪个代码块。
## 三、if / else：双分支判断
如果我们希望条件成立和不成立时都执行不同的代码，就使用 `else`。
基本语法：
```
if 条件:    条件成立时执行else:    条件不成立时执行
```
例如：
```
cpu_usage = 85if cpu_usage >= 80:    print("CPU使用率过高")else:    print("CPU使用正常")
```
输出：
```
CPU使用率过高
```
如果修改为：
```
cpu_usage = 60if cpu_usage >= 80:    print("CPU使用率过高")else:    print("CPU使用正常")
```
输出：
```
CPU使用正常
```
这里需要记住：
- `if` 负责判断条件。
- `else` 负责处理所有不满足 `if` 条件的情况。
- `else` 不需要写判断条件。
## 四、if / elif / else：多分支判断
如果需要判断多个不同的条件，就需要使用 `elif`。
`elif` 可以理解为 else if，也就是前面的条件不成立，再继续判断其他条件。
基本语法：
```
if 条件1:    执行代码1elif 条件2:    执行代码2elif 条件3:    执行代码3else:    执行代码4
```
例如，我们根据 CPU 使用率划分服务器状态：

| CPU 使用率    | 状态   |
| ---------- | ---- |
| 小于 60%     | 正常   |
| 60%～79.99% | 关注   |
| 80%～89.99% | 警告   |
| 大于或等于 90%  | 严重告警 |

代码：
```
cpu_usage = 85if cpu_usage < 60:    print("CPU状态：正常")elif cpu_usage < 80:    print("CPU状态：关注")elif cpu_usage < 90:    print("CPU状态：警告")else:    print("CPU状态：严重告警")
```
输出：
```
CPU状态：警告
```
### 为什么这里不需要每个条件都写完整？
例如：
```
elif cpu_usage < 80:
```
看起来没有写 `cpu_usage >= 60`，但实际上不需要。
因为程序按照顺序执行：
1. 首先判断 CPU 是否小于 60。
2. 如果不是，才进入第二个条件。
3. 因此，进入第二个条件时，已经隐含了 CPU 大于或等于 60。
所以第二个条件实际表示：
\\[ 60 \leq CPU < 80 \\]
这就是 `elif` 的一个重要特点：前面的分支不成立，才会继续判断后面的分支。
## 五、if 中使用逻辑运算符
前面学习过 `and`、`or`、`not`，现在可以把它们应用到条件判断中。
例如：
一台服务器只有 CPU 和内存都正常，才判定为资源正常。
```
cpu_usage = 60memory_usage = 70if cpu_usage < 80 and memory_usage < 80:    print("服务器资源正常")else:    print("服务器存在资源异常")
```
输出：
```
服务器资源正常
```
再看一个例子：
只要 CPU 或内存任意一项达到告警阈值，就输出告警：
```
cpu_usage = 85memory_usage = 70if cpu_usage >= 80 or memory_usage >= 80:    print("服务器资源告警")else:    print("服务器资源正常")
```
输出：
```
服务器资源告警
```
这里将比较运算符、逻辑运算符和条件判断结合起来了。
## 六、嵌套 if：条件判断中再进行条件判断
Python 还允许在一个 `if` 内部继续使用 `if`。
例如：
我们先判断服务器是否在线，只有在线时才检查 CPU 使用率。
```
server_online = Truecpu_usage = 90if server_online:    print("服务器在线")    if cpu_usage >= 80:        print("CPU使用率过高")    else:        print("CPU使用正常")else:    print("服务器无法连接")
```
输出：
```
服务器在线
CPU使用率过高
```
这里的执行逻辑是：
1. 判断服务器是否在线。
2. 如果在线，进入内部的 CPU 判断。
3. 如果不在线，则不再执行 CPU 判断。
嵌套判断在实际运维中很常见，例如：
- 先检查服务是否运行。
- 服务运行后再检查端口。
- 端口正常后再检查服务响应。
不过，嵌套层级不宜过多，否则程序会难以维护。
## 七、结合 Linux 运维场景：编写资源告警程序
现在我们把本节知识整合起来。
创建文件：
```
vim resource_check.py
```
编写代码：
```
# 模拟服务器资源数据hostname = "server01"cpu_usage = 85.5memory_usage = 72.0disk_usage = 92.0# 设置告警阈值cpu_threshold = 80memory_threshold = 80disk_threshold = 90print("========== Linux服务器巡检 ==========")print(f"主机名称：{hostname}")# CPU状态判断if cpu_usage >= cpu_threshold:    print(f"CPU使用率：{cpu_usage}% [告警]")else:    print(f"CPU使用率：{cpu_usage}% [正常]")# 内存状态判断if memory_usage >= memory_threshold:    print(f"内存使用率：{memory_usage}% [告警]")else:    print(f"内存使用率：{memory_usage}% [正常]")# 磁盘状态判断if disk_usage >= disk_threshold:    print(f"磁盘使用率：{disk_usage}% [告警]")else:    print(f"磁盘使用率：{disk_usage}% [正常]")print("=" * 40)
```
运行：
```
python3 resource_check.py
```
预期输出：
```
========== Linux服务器巡检 ==========
主机名称：server01
CPU使用率：85.5% [告警]
内存使用率：72.0% [正常]
磁盘使用率：92.0% [告警]
========================================
```
现在，程序已经可以根据不同的资源数据，自动输出不同的状态。
后续我们会使用 Python 获取 Linux 的真实 CPU、内存和磁盘信息，将这里的模拟数据替换掉。
## 八、本节需要掌握的知识

| 语法      | 作用         |
| ------- | ---------- |
| `if`    | 条件成立时执行    |
| `else`  | 条件不成立时执行   |
| `elif`  | 继续判断其他条件   |
| 嵌套 `if` | 在条件分支中继续判断 |
| `and`   | 多个条件必须同时成立 |
| `or`    | 多个条件至少一个成立 |
| `not`   | 对条件取反      |

特别注意三个容易出错的地方：
1. `if`、`elif`、`else` 后面必须使用英文冒号。
2. 同一个代码块必须保持一致的缩进，通常使用 4 个空格。
3. `elif` 和 `else` 必须与对应的 `if` 保持相同缩进。
## 九、本节练习
先完成理论考核，再完成实践任务。
条件判断理论考核
每题 20 分
1\. Python 中 if 条件成立时，执行哪部分代码？
if 后面所有代码
if 内部缩进的代码
else 内部代码
整个程序
回答正确if 代码块通过缩进确定范围。
2\. if 和 else 可以有多少个？
只能有一个 if 和一个 else
可以有多个 if，但一个 if 结构最多有一个对应的 else
可以有多个 else
else 必须有多个
回答正确一个 if/else 结构中只有一个 if 和一个可选的 else；可以有多个 elif。
3\. cpu_usage=85，执行 if cpu_usage >= 80: print('告警')，会输出什么？
正常
告警
False
不输出
回答正确85 大于等于 80，条件成立。
4\. elif 的作用是什么？
结束程序
重复执行代码
当前面条件不成立时继续判断
对条件取反
回答正确elif 用于多分支条件判断。
5\. 如果先判断 server_online，只有在线时才检查 CPU，适合使用什么结构？
字符串拼接
嵌套 if
算术运算
类型转换
回答正确外层判断服务器状态，内层判断 CPU 状态。
提交并查看成绩
# 得分：100/100
实践任务：
创建 `if_practice.py`，要求：
1. 定义主机名称 `server01`。
2. 定义 CPU 使用率 `cpu_usage = 85.5`。
3. 定义内存使用率 `memory_usage = 75.0`。
4. 定义磁盘使用率 `disk_usage = 92.0`。
5. CPU 状态分为四级：
   - 小于 60：正常。
   - 60～小于 80：关注。
   - 80～小于 90：警告。
   - 大于或等于 90：严重告警。
6. 内存和磁盘分别进行正常与告警判断。
7. 最后输出完整巡检报告。
通过标准：理论成绩达到 80 分，并完成实践任务。
下一课我们将学习 Python 的循环结构 `for` 和 `while`。这对 Linux 运维尤其重要，例如批量巡检多台服务器、循环检查多个磁盘分区、定时采集系统资源等。
# 第二阶段第六课：for 循环与 range()
上一课我们学习了 `while` 循环，它的核心特点是：根据条件决定是否继续执行循环。
今天学习另一种非常重要的循环结构：`for`。
在 Python 中，`for` 循环经常用于遍历数据。例如：
- 批量检查服务器 IP 地址。
- 批量读取目录中的文件。
- 批量检查 Linux 进程。
- 批量统计磁盘、内存和 CPU 信息。
## 一、为什么需要 for 循环？
假设我们有三台服务器：
```
server1 = "192.168.1.10"server2 = "192.168.1.11"server3 = "192.168.1.12"print(server1)print(server2)print(server3)
```
如果有 100 台服务器，就需要写很多重复代码。
使用 `for` 循环：
```
servers = ["192.168.1.10", "192.168.1.11", "192.168.1.12"]for server in servers:    print(server)
```
运行结果：
```
192.168.1.10
192.168.1.11
192.168.1.12
```
只需要写一遍 `print()`，Python 就会自动遍历列表中的每个元素。
## 二、for 循环的基本语法
```
for 变量 in 可迭代对象:    循环执行的代码
```
我们逐个理解：

| 组成部分    | 含义                       |
| ------- | ------------------------ |
| `for`   | 声明一个循环                   |
| `变量`    | 用来接收每次遍历得到的数据            |
| `in`    | 表示从某个对象中依次取值             |
| `可迭代对象` | 可以逐个取出元素的数据，例如列表、字符串、元组等 |
| `:`     | 表示循环体开始                  |
| 缩进代码    | 每次遍历时执行的代码               |

例如：
```
servers = ["server01", "server02", "server03"]for server in servers:    print(f"正在检查服务器：{server}")
```
执行过程：
1. 第一次循环，`server` 获取 `"server01"`。
2. 第二次循环，`server` 获取 `"server02"`。
3. 第三次循环，`server` 获取 `"server03"`。
4. 所有元素遍历完成，循环自动结束。
这里需要注意：`server` 是一个普通变量名，可以自行命名，例如 `ip`、`host`、`item`。
## 三、range() 函数
前面我们使用 `while` 循环打印 1 到 10：
```
count = 1while count <= 10:    print(count)    count += 1
```
使用 `for` 和 `range()` 可以更简洁地完成：
```
for count in range(1, 11):    print(count)
```
运行结果同样是 1 到 10。
`range()` 是 Python 内置函数，用于生成一个整数序列。
它有三种常见形式。
1\. range(stop)
```
for i in range(5):    print(i)
```
输出：
```
0
1
2
3
4
```
从 0 开始，到 5 之前结束。
2\. range(start, stop)
```
for i in range(1, 6):    print(i)
```
输出：
```
1
2
3
4
5
```
从 1 开始，到 6 之前结束。
3\. range(start, stop, step)
```
for i in range(1, 11, 2):    print(i)
```
输出：
```
1
3
5
7
9
```
其中：
- `start`：起始值。
- `stop`：结束边界，但不包含该值。
- `step`：每次递增或递减的步长。
再看一个递减的例子：
```
for i in range(10, 0, -1):    print(i)
```
输出：
```
10
9
8
7
6
5
4
3
2
1
```
注意：递减时，步长需要设置为负数。
## 四、for 循环与 while 循环有什么区别？

| 对比项         | while      | for           |
| ----------- | ---------- | ------------- |
| 主要用途        | 根据条件重复执行   | 遍历数据或指定范围     |
| 循环次数        | 可能不确定      | 通常由可迭代对象决定    |
| 是否需要手动更新计数器 | 通常需要       | 通常不需要         |
| 退出方式        | 条件变为 False | 遍历完成          |
| 常见场景        | 持续监控、等待条件  | 批量处理服务器、文件、数据 |

例如：
```
# whilecount = 1while count <= 3:    print(count)    count += 1# forfor count in range(1, 4):    print(count)
```
这两段代码的输出相同。
学习建议：
- 已经知道需要遍历多少个元素，或者需要处理一个列表时，优先考虑 `for`。
- 需要持续执行，直到某个条件满足或不满足时，优先考虑 `while`。
## 五、结合 Linux 运维场景
假设我们有三台服务器，需要模拟批量巡检：
```
servers = [    "192.168.1.10",    "192.168.1.11",    "192.168.1.12"]for server in servers:    print(f"开始巡检服务器：{server}")    print("CPU：正常")    print("内存：正常")    print("磁盘：正常")    print("----------------")
```
这就是批量巡检的基本思想。
后续我们会将模拟数据替换为真正的 Linux 命令采集结果，例如使用 `subprocess` 获取服务器资源信息。
## 六、本节考核
先完成下面 5 道理论题，再完成实践任务。
理论测试
5 题 · 100 分
1\. for 循环主要用于什么？
A. 只执行一次代码
B. 遍历可迭代对象中的元素
C. 定义函数
D. 处理异常
回答正确：for 通常用于遍历列表、字符串、range 等可迭代对象。
2\. range(5) 会生成哪些数字？
A. 1、2、3、4、5
B. 0、1、2、3、4
C. 0、1、2、3、4、5
D. 1、2、3、4
回答正确：range(5) 从 0 开始，不包含 5。
3\. range(2, 8, 2) 的结果是什么？
A. 2、4、6
B. 2、4、6、8
C. 0、2、4、6
D. 2、3、4、5、6、7
回答正确：从 2 开始，每次增加 2，遇到 8 前停止。
4\. for 循环遍历完列表后会怎样？
A. 自动从头开始
B. 自动进入死循环
C. 自动结束循环
D. 自动删除列表
回答正确：所有元素遍历完成后，for 循环自动结束。
5\. 下面代码会输出多少次？\
for i in range(1, 11, 3):\
&#x20;   print(i)
A. 3 次
B. 4 次
C. 5 次
D. 10 次
回答正确：输出 1、4、7、10，共 4 次。
# 得分：100/100
重新答题
### 实践任务：编写 for_practice.py
在 Linux 中创建文件：
```
vim for_practice.py
```
完成以下三个任务：
任务 1：数字遍历
使用 `for` 和 `range()` 打印 1 到 20。
任务 2：计算累加和
使用 `for` 循环计算 1 到 100 的累加和，要求使用变量保存累加结果，不允许直接写出结果。
任务 3：批量服务器巡检
定义以下服务器列表：
```
servers = [    "192.168.1.10",    "192.168.1.11",    "192.168.1.12",    "192.168.1.13",    "192.168.1.14"]
```
使用 `for` 循环遍历服务器列表，每台服务器输出：
- 服务器 IP。
- CPU 使用率。
- 内存使用率。
- 磁盘使用率。
- 一条巡检完成提示。
提交完整代码和理论测试结果。 我会重点检查你是否真正理解 `for`、`in`、`range()` 以及循环变量的变化。通过后继续学习 `break` 和 `continue`。
第二个问题回答正确，4995 是正确结果。
但第一个问题的解释需要纠正一下。你已经注意到了变量不会自动恢复初始值，不过原因不是变量没有被释放。
### 1. 为什么 count 最终是 11？
因为 Python 中变量在赋值后，会持续引用对应的数据对象，直到变量被重新赋值或引用关系发生变化。
第一个循环的执行过程：
```
count = 1while count <= 10:    print(count)    count += 1
```
最后一次循环：
```
count = 10count += 1
```
执行后：
```
count = 11
```
随后判断：
```
11 <= 10
```
结果为 `False`，循环退出。
注意：循环退出不会自动清空变量，也不会重置变量。
### 2. 为什么结果是 4995？
因为第二个循环直接使用了上一个循环留下的 `count = 11`。
实际计算：
\\[ 11+12+\cdots+100=4995 \\]
因此你的计算完全正确。
### 本次考核结果
通过
你已经掌握：
- while 循环基本结构。
- 循环条件判断。
- 计数器更新。
- 循环结束条件。
- 多个循环之间的变量状态延续。
接下来进入下一课：for 循环与 range()。它们在 Linux 运维中尤其适合批量遍历服务器列表、文件列表和进程信息。
# 第二阶段第七课：break 和 continue（循环控制语句）
本节将 `break` 和 `continue` 放在一起讲解。它们都是 Python 循环中的控制语句，可以改变循环原本的执行流程。
在 Linux 自动化运维中，这两个关键字非常实用：
- `break`：遇到严重异常，提前结束整个巡检循环。
- `continue`：当前服务器不需要继续检查，跳过它，检查下一台服务器。
## 一、break：提前结束整个循环
先看一个简单例子：
```
for i in range(1, 11):    print(i)    if i == 5:        breakprint("循环结束")
```
运行结果：
```
1
2
3
4
5
循环结束
```
我们分析一下执行过程：
1. `i` 从 1 开始。
2. 当 `i` 为 1、2、3、4 时，正常执行 `print(i)`。
3. 当 `i` 等于 5 时，执行 `print(i)`。
4. 接下来判断 `i == 5`，条件成立。
5. 执行 `break`，立即退出整个循环。
6. 执行循环外面的 `print("循环结束")`。
这里需要记住：
break 只会终止当前所在的那一层循环。
例如：
```
for i in range(1, 4):    for j in range(1, 4):        if j == 2:            break        print(f"i={i}, j={j}")
```
输出：
```
i=1, j=1
i=2, j=1
i=3, j=1
```
原因是 `break` 只结束内层的 `for j` 循环，外层的 `for i` 仍然会继续执行。
## 二、continue：跳过本次循环
看下面的例子：
```
for i in range(1, 6):    if i == 3:        continue    print(i)
```
运行结果：
```
1
2
4
5
```
当 `i == 3` 时：
```
continue
```
会直接结束当前这一轮循环，跳回循环开头，开始下一轮。
注意：continue 不会结束整个循环，只会跳过当前这一次。
执行过程：

| i 的值 | 判断 i == 3 | 执行结果 |
| ---- | --------- | ---- |
| 1    | False     | 输出 1 |
| 2    | False     | 输出 2 |
| 3    | True      | 跳过本次 |
| 4    | False     | 输出 4 |
| 5    | False     | 输出 5 |

## 三、break 和 continue 的核心区别
break
结束整个当前循环
一旦执行，当前循环不再继续，直接执行循环后面的代码。
第 1 轮
执行
第 2 轮
执行
第 3 轮
break，结束循环
第 4 轮及后续轮次不再执行
continue
跳过当前这一轮
当前轮次剩余代码不再执行，直接进入下一轮。
第 1 轮
执行
第 2 轮
continue，跳过
第 3 轮
继续执行
后续轮次仍然正常执行
可以简单记忆：
- `break`：不干了，整个循环结束。
- `continue`：这一轮跳过，下一轮继续。
## 四、结合 Linux 批量服务器巡检
这是本节最重要的部分。
假设我们需要检查 5 台服务器：
```
servers = [    "192.168.1.10",    "192.168.1.11",    "192.168.1.12",    "192.168.1.13",    "192.168.1.14"]
```
假设我们提前获得了每台服务器的 CPU 使用率：
```
cpu_usages = [35, 55, 95, 40, 60]
```
我们规定：
- CPU 使用率低于 80%：正常。
- CPU 使用率达到 80% 但低于 90%：告警。
- CPU 使用率达到 90%：严重异常，停止后续巡检。
代码：
```
servers = [    "192.168.1.10",    "192.168.1.11",    "192.168.1.12",    "192.168.1.13",    "192.168.1.14"]cpu_usages = [35, 55, 95, 40, 60]for i in range(len(servers)):    server = servers[i]    cpu_usage = cpu_usages[i]    print(f"\n正在检查服务器：{server}")    if cpu_usage >= 90:        print(f"严重告警：CPU使用率达到 {cpu_usage}%")        print("停止后续巡检")        break    elif cpu_usage >= 80:        print(f"CPU告警：使用率为 {cpu_usage}%")    else:        print(f"CPU正常：使用率为 {cpu_usage}%")print("\n巡检程序结束")
```
运行结果：
```
正在检查服务器：192.168.1.10
CPU正常：使用率为 35%
正在检查服务器：192.168.1.11
CPU正常：使用率为 55%
正在检查服务器：192.168.1.12
严重告警：CPU使用率达到 95%
停止后续巡检
巡检程序结束
```
注意：这里的 `break` 会让第四台和第五台服务器不再检查。
另外，`len(servers)` 用于获取列表长度，`range(len(servers))` 就会生成对应的索引序列。`servers[i]` 和 `cpu_usages[i]` 使用相同索引，取出对应服务器及其 CPU 数据。
这种写法先让你理解索引和两个列表的对应关系，后续还会学习更简洁的 `zip()`。
## 五、continue 在巡检中的应用
再看一个场景：
假设服务器列表中有一台服务器处于维护状态，我们不需要检查它，但也不应该停止整个巡检任务。
```
servers = [    "192.168.1.10",    "192.168.1.11",    "192.168.1.12",    "192.168.1.13",    "192.168.1.14"]maintenance_servers = [    "192.168.1.12"]for server in servers:    if server in maintenance_servers:        print(f"{server} 正在维护，跳过检查")        continue    print(f"正在检查服务器：{server}")    print("CPU正常")    print("内存正常")    print("磁盘正常")print("所有巡检任务结束")
```
这里的：
```
if server in maintenance_servers:    continue
```
意思是：
如果当前服务器在维护名单中，就跳过当前循环，直接检查下一台服务器。
输出效果：
```
正在检查服务器：192.168.1.10
CPU正常
内存正常
磁盘正常
正在检查服务器：192.168.1.11
CPU正常
内存正常
磁盘正常
192.168.1.12 正在维护，跳过检查
正在检查服务器：192.168.1.13
CPU正常
内存正常
磁盘正常
正在检查服务器：192.168.1.14
CPU正常
内存正常
磁盘正常
所有巡检任务结束
```
这里你应该注意到：
`continue` 后面的代码在本轮不执行，但循环外面的代码仍然会执行。
## 六、一个容易犯错的地方：while 中使用 continue
看下面的代码：
```
count = 1while count <= 5:    if count == 3:        continue    print(count)    count += 1
```
这段代码存在问题。
当 `count` 等于 3 时，执行 `continue`，直接返回循环开头。
但是 `count += 1` 没有执行。
因此：
```
count = 3
```
永远不会发生变化，条件始终成立，程序就会陷入无限循环。
正确写法：
```
count = 1while count <= 5:    if count == 3:        count += 1        continue    print(count)    count += 1
```
这样就能正常跳过 3，输出 1、2、4、5。
记住：在 while 循环中使用 continue 时，要特别检查计数器是否能够正常更新。
## 七、本节考核
理论测试 5 题，每题 20 分，80 分及以上通过。
理论测试
5 题 · 100 分
1\. break 的作用是什么？
A. 跳过当前循环
B. 结束整个当前循环
C. 重新开始循环
D. 暂停程序
2\. continue 的作用是什么？
A. 结束整个循环
B. 结束程序
C. 跳过当前轮次，进入下一轮
D. 重新执行上一轮
3\. 下面代码会输出什么？\
for i in range(1, 6):\
&#x20;   if i == 3:\
&#x20;       break\
&#x20;   print(i)
A. 1、2
B. 1、2、3
C. 1、2、4、5
D. 1、2、3、4、5
4\. 下面代码会输出什么？\
for i in range(1, 6):\
&#x20;   if i == 3:\
&#x20;       continue\
&#x20;   print(i)
A. 1、2
B. 1、2、3
C. 1、2、4、5
D. 1、2、3、4、5
5\. while 循环中使用 continue，最需要注意什么？
A. 是否导入模块
B. 计数器是否能正常更新
C. 是否使用字符串
D. 是否使用列表
提交答案
### 实践任务：编写 break_continue.py
创建文件：
```
vim break_continue.py
```
任务 1：break 实践
定义一个数字列表：
```
numbers = [10, 20, 30, 40, 50, 60]
```
使用 `for` 遍历列表。
要求：
- 正常输出数字。
- 当数字等于 40 时，输出提示信息。
- 使用 `break` 结束循环。
任务 2：continue 实践
仍然使用：
```
numbers = [10, 20, 30, 40, 50, 60]
```
要求：
- 使用 `for` 遍历。
- 当数字等于 30 时跳过本次循环。
- 其他数字正常输出。
任务 3：综合 Linux 巡检实践
定义服务器列表：
```
servers = [    "192.168.1.10",    "192.168.1.11",    "192.168.1.12",    "192.168.1.13",    "192.168.1.14"]
```
定义 CPU 使用率列表：
```
cpu_usages = [35, 55, 30, 95, 60]
```
要求：
1. 使用 `for` 循环遍历服务器。
2. 获取每台服务器对应的 CPU 使用率。
3. CPU 使用率达到 90% 时，输出严重告警并使用 `break`。
4. CPU 使用率达到 80% 但低于 90% 时，输出普通告警。
5. CPU 使用率低于 80% 时，输出正常。
6. 巡检结束后输出结束提示。
完成后，把理论测试结果和完整代码发给我。 我会重点检查你是否真正理解了 `break` 和 `continue` 的执行位置，以及它们对循环流程的影响。
好的，`break` 和 `continue` 这部分不再安排练习，我们直接进入下一课。
# 第二阶段第八课：嵌套循环（循环里面再套循环）
嵌套循环是指：一个循环结构内部，再包含另一个循环结构。
在 Linux 自动化运维中，它可以用于：
- 多台服务器的批量巡检。
- 每台服务器检查多个资源指标。
- 批量检查多个目录中的文件。
- 多个主机与多个服务之间的状态检查。
## 一、什么是嵌套循环？
先看一个简单例子：
```
for i in range(1, 4):    for j in range(1, 4):        print(f"i={i}, j={j}")
```
输出：
```
i=1, j=1
i=1, j=2
i=1, j=3
i=2, j=1
i=2, j=2
i=2, j=3
i=3, j=1
i=3, j=2
i=3, j=3
```
这里有两个循环：
```
for i in range(1, 4):
```
这是外层循环。
```
for j in range(1, 4):
```
这是内层循环。
核心执行规则：外层循环每执行一次，内层循环就完整执行一次。
来看执行过程：

| 外层 i | 内层 j 执行过程 |
| ---- | --------- |
| 1    | 1、2、3     |
| 2    | 1、2、3     |
| 3    | 1、2、3     |

所以总执行次数是：
\\[ 3 \times 3 = 9 \\]
## 二、理解外层循环和内层循环
看一个更简单的例子：
```
for i in range(1, 3):    print(f"外层循环：{i}")    for j in range(1, 4):        print(f"    内层循环：{j}")
```
输出：
```
外层循环：1
    内层循环：1
    内层循环：2
    内层循环：3
外层循环：2
    内层循环：1
    内层循环：2
    内层循环：3
```
注意：
- 外层循环执行两次。
- 内层循环每次执行三次。
- 内层循环执行完毕后，才会进入下一次外层循环。
这里还有一个重要细节：每次进入内层循环，`j` 都会从 `range(1, 4)` 的起始位置重新遍历。
## 三、嵌套循环结合 break 和 continue
前面学习过 `break` 和 `continue`，现在可以把它们放在嵌套循环中理解。
### 1. 内层 break
```
for i in range(1, 4):    for j in range(1, 4):        if j == 2:            break        print(f"i={i}, j={j}")
```
输出：
```
i=1, j=1
i=2, j=1
i=3, j=1
```
原因是 `break` 只结束它所在的内层循环，外层循环仍然继续。
### 2. 内层 continue
```
for i in range(1, 3):    for j in range(1, 4):        if j == 2:            continue        print(f"i={i}, j={j}")
```
输出：
```
i=1, j=1
i=1, j=3
i=2, j=1
i=2, j=3
```
每次内层循环的 `j == 2` 都会被跳过，但其他数据仍然正常执行。
## 四、结合 Linux 运维场景
假设我们需要检查三台服务器，每台服务器都需要检查三个资源指标：
- CPU
- 内存
- 磁盘
可以使用嵌套循环：
```
servers = [    "192.168.1.10",    "192.168.1.11",    "192.168.1.12"]resources = ["CPU", "内存", "磁盘"]for server in servers:    print(f"\n开始检查服务器：{server}")    for resource in resources:        print(f"正在检查：{resource}")    print("服务器检查完成")
```
输出：
```
开始检查服务器：192.168.1.10
正在检查：CPU
正在检查：内存
正在检查：磁盘
服务器检查完成
开始检查服务器：192.168.1.11
正在检查：CPU
正在检查：内存
正在检查：磁盘
服务器检查完成
开始检查服务器：192.168.1.12
正在检查：CPU
正在检查：内存
正在检查：磁盘
服务器检查完成
```
这个例子体现了嵌套循环在自动化运维中的价值：
外层循环负责遍历服务器，内层循环负责遍历每台服务器需要检查的资源。
## 五、嵌套循环的执行次数
假设：
```
for i in range(1, 6):    for j in range(1, 4):        print(i, j)
```
外层循环执行 5 次，内层循环每次执行 3 次。
因此：
\\[ 5 \times 3 = 15 \\]
总共执行 15 次。
如果是三层循环，则通常可以将每层循环的次数相乘，得到完整执行次数（前提是每层循环次数固定，且没有提前退出）。
注意：嵌套层数越多，程序执行逻辑越复杂。实际编写运维程序时，不要为了使用嵌套循环而刻意增加层数。
## 六、本节需要掌握的知识

| 知识点         | 掌握要求               |
| ----------- | ------------------ |
| 嵌套循环概念      | 理解循环内部可以再放循环       |
| 外层循环        | 理解控制整体遍历次数         |
| 内层循环        | 理解外层每次执行时，内层都会完整遍历 |
| 执行顺序        | 能够分析程序输出结果         |
| 嵌套 break    | 理解只结束所在层级的循环       |
| 嵌套 continue | 理解只跳过当前层级的本次循环     |
| 运维应用        | 能够实现多服务器、多指标遍历     |

本节先不安排练习，按照你的要求直接推进。
下一课：循环与列表、字典结合使用。
这部分非常重要，我们会学习如何使用 Python 批量处理服务器信息、资源数据和巡检结果，为后面开发真正的 Linux 自动化巡检脚本做准备。
# 第二阶段：运算符与流程控制
## 第九课：循环与列表、字典结合使用
前面我们已经分别学习了 `for` 循环、`while` 循环、列表和字典的基本概念。本节把这些知识结合起来，学习如何批量处理多台服务器的信息。
这也是编写 Linux 自动化巡检脚本非常重要的一项基础能力。
### 一、使用 for 循环遍历列表
先看一个简单例子：
```
servers = [    "192.168.1.10",    "192.168.1.11",    "192.168.1.12"]for server in servers:    print(f"正在巡检服务器：{server}")
```
这里有几个关键点：
- `servers` 是一个列表，里面保存了多个 IP 地址。
- `for server in servers` 表示依次取出列表中的每个元素。
- 每次循环，变量 `server` 都会指向当前取出的 IP 地址。
- 列表遍历完成后，循环自动结束。
执行过程如下：

| 循环次数 | server 的值    |
| ---- | ------------ |
| 第一次  | 192.168.1.10 |
| 第二次  | 192.168.1.11 |
| 第三次  | 192.168.1.12 |

重点： `for` 循环可以直接遍历列表元素，不需要自己维护计数器。
### 二、列表中保存字典
实际的 Linux 巡检工作中，我们不仅需要保存服务器 IP，还需要保存主机名、CPU 使用率、内存使用率等信息。
如果只使用普通列表，数据就不容易组织。
例如：
```
servers = [    {        "ip": "192.168.1.10",        "hostname": "server01",        "cpu": 35,        "memory": 60    },    {        "ip": "192.168.1.11",        "hostname": "server02",        "cpu": 92,        "memory": 75    },    {        "ip": "192.168.1.12",        "hostname": "server03",        "cpu": 45,        "memory": 85    }]
```
这里出现了一种非常常见的数据结构：
```
列表  ├── 字典1  ├── 字典2  └── 字典3
```
也就是说：
- 最外层是列表，用于保存多台服务器。
- 每台服务器对应一个字典。
- 字典通过键值对保存服务器的具体信息。
为什么这样设计？
因为每台服务器都有相同的信息字段，但具体数值不同。使用字典能够让每台服务器的数据结构保持一致。
### 三、使用循环读取字典中的数据
接下来遍历这个列表：
```
for server in servers:    print(f"服务器IP：{server['ip']}")    print(f"主机名称：{server['hostname']}")    print(f"CPU使用率：{server['cpu']}%")    print(f"内存使用率：{server['memory']}%")    print("----------------------")
```
重点理解这一句：
```
server["ip"]
```
它的执行过程是：
1. `for` 从列表中取出一个字典。
2. 将这个字典赋值给变量 `server`。
3. `server["ip"]` 获取当前字典中键为 `ip` 的值。
4. 下一轮循环再取出下一个字典。
例如第一次循环时：
```
server = {    "ip": "192.168.1.10",    "hostname": "server01",    "cpu": 35,    "memory": 60}
```
此时：
```
server["ip"]       # 192.168.1.10server["hostname"] # server01server["cpu"]      # 35
```
注意：这里的 `server["ip"]` 是字典取值，不是列表下标。
### 四、使用 items() 遍历字典
前面我们学习了通过键获取字典中的值：
```
server = {    "ip": "192.168.1.10",    "cpu": 35,    "memory": 60}print(server["ip"])print(server["cpu"])
```
如果希望一次遍历字典中的所有键和值，可以使用 `items()`。
```
for key, value in server.items():    print(f"字段名称：{key}，字段值：{value}")
```
输出：
```
字段名称：ip，字段值：192.168.1.10
字段名称：cpu，字段值：35
字段名称：memory，字段值：60
```
这里需要理解：
```
for key, value in server.items():
```
`items()` 会依次提供字典中的键和值。
每轮循环中：
- `key` 接收当前键。
- `value` 接收当前键对应的值。
另外，字典还有两个常见方法：
```
server.keys()    # 获取所有键server.values()  # 获取所有值
```
例如：
```
for key in server.keys():    print(key)for value in server.values():    print(value)
```
在实际工作中，最常用的还是：
```
for key, value in server.items():
```
### 五、循环与 if 结合：实现服务器资源告警
现在把前面学习的内容结合起来。
假设有三台服务器，需要判断 CPU 和内存是否超过告警阈值。
```
servers = [    {"ip": "192.168.1.10", "cpu": 35, "memory": 60},    {"ip": "192.168.1.11", "cpu": 92, "memory": 75},    {"ip": "192.168.1.12", "cpu": 45, "memory": 85}]for server in servers:    print(f"正在检查服务器：{server['ip']}")    if server["cpu"] >= 90:        print(f"CPU告警：{server['cpu']}%")    else:        print(f"CPU正常：{server['cpu']}%")    if server["memory"] >= 80:        print(f"内存告警：{server['memory']}%")    else:        print(f"内存正常：{server['memory']}%")    print("----------------------")
```
这里涉及三个知识点：

| 代码                       | 作用              |
| ------------------------ | --------------- |
| `for server in servers`  | 遍历每台服务器         |
| `server["cpu"]`          | 获取当前服务器 CPU 使用率 |
| `if server["cpu"] >= 90` | 判断 CPU 是否达到告警阈值 |

执行逻辑是：
开始遍历服务器列表
获取当前服务器的字典数据
判断 CPU 是否达到 90%
否
CPU 正常
是
CPU 告警
判断内存是否达到 80%
处理下一台服务器，直到列表遍历完成
这就是自动化巡检中最基础的批量检查逻辑。
### 六、遍历时如何获取列表下标？
有时我们不仅需要列表中的元素，还需要知道当前元素是第几个。
可以使用：
```
servers = ["server01", "server02", "server03"]for i in range(len(servers)):    print(f"第{i + 1}台服务器：{servers[i]}")
```
这里有三个概念：
- `len(servers)`：获取列表长度，这里是 3。
- `range(3)`：生成 0、1、2。
- `servers[i]`：根据下标获取列表中的元素。
不过，实际开发中如果不需要下标，优先使用：
```
for server in servers:    print(server)
```
因为这种方式更简单，也更容易理解。
## 本节需要掌握的内容

| 知识点                | 掌握要求          |
| ------------------ | ------------- |
| `for item in list` | 能够遍历列表        |
| 列表嵌套字典             | 能够组织多台服务器的数据  |
| `dict["key"]`      | 能够获取字典中的指定字段  |
| `dict.items()`     | 能够同时遍历字典的键和值  |
| `if + for`         | 能够批量判断服务器资源状态 |
| `len()`、`range()`  | 能够通过下标访问列表元素  |

本节的核心是理解数据组织方式：列表负责管理多台服务器，字典负责保存单台服务器的信息，循环负责逐台处理，条件判断负责识别异常。
下一章节将进入第二阶段的最后一个重要内容：循环与数据统计、结果汇总，为后面学习函数和编写完整的 Linux 巡检程序做准备。
# 第二阶段：运算符与流程控制
## 第十课：循环与数据统计、结果汇总
上一节我们学习了如何使用 `for` 循环遍历服务器列表，并通过字典获取每台服务器的 CPU、内存等信息。
但是，实际 Linux 运维工作中，仅仅逐台输出数据还不够。
例如，我们巡检了 100 台服务器，最终还需要知道：
- 一共巡检了多少台服务器？
- 有多少台服务器正常？
- 有多少台服务器存在异常？
- CPU 平均使用率是多少？
- 哪台服务器的 CPU 使用率最高？
这些都涉及循环统计和结果汇总。
本节主要学习五个内容。
### 一、使用变量统计循环次数
先看一个简单例子：
```
servers = [    "192.168.1.10",    "192.168.1.11",    "192.168.1.12",    "192.168.1.13"]count = 0for server in servers:    print(f"正在巡检：{server}")    count += 1print(f"总共巡检了 {count} 台服务器")
```
输出：
```
正在巡检：192.168.1.10
正在巡检：192.168.1.11
正在巡检：192.168.1.12
正在巡检：192.168.1.13
总共巡检了 4 台服务器
```
这里需要理解两个关键点：
1\. 为什么 count 初始值是 0？
因为还没有开始巡检，所以初始巡检数量为 0。
2\. 为什么使用 count += 1？
每完成一台服务器的巡检，就把统计数量增加 1。
等价于：
```
count = count + 1
```
这种方式称为计数器。
### 二、使用变量统计正常和异常数量
接下来增加一个实际运维场景。
假设我们有四台服务器，需要根据 CPU 使用率判断是否正常。
```
servers = [    {"ip": "192.168.1.10", "cpu": 35},    {"ip": "192.168.1.11", "cpu": 92},    {"ip": "192.168.1.12", "cpu": 45},    {"ip": "192.168.1.13", "cpu": 96}]total_count = 0normal_count = 0alarm_count = 0for server in servers:    total_count += 1    if server["cpu"] >= 90:        print(f"{server['ip']} CPU异常：{server['cpu']}%")        alarm_count += 1    else:        print(f"{server['ip']} CPU正常：{server['cpu']}%")        normal_count += 1print("==========巡检统计==========")print(f"巡检总数：{total_count}")print(f"正常数量：{normal_count}")print(f"异常数量：{alarm_count}")
```
输出结果：
```
192.168.1.10 CPU正常：35%
192.168.1.11 CPU异常：92%
192.168.1.12 CPU正常：45%
192.168.1.13 CPU异常：96%
==========巡检统计==========
巡检总数：4
正常数量：2
异常数量：2
```
这里有一个非常重要的编程思想：
统计变量应该在循环外初始化，在循环内部根据实际情况更新。
例如：
```
normal_count = 0alarm_count = 0for server in servers:    ...
```
如果把 `normal_count = 0` 写到循环里面，每次循环都会重新清零，之前统计的数量就会丢失。
### 三、使用变量计算平均值
假设需要计算所有服务器的平均 CPU 使用率。
可以使用：
```
servers = [    {"ip": "192.168.1.10", "cpu": 35},    {"ip": "192.168.1.11", "cpu": 92},    {"ip": "192.168.1.12", "cpu": 45},    {"ip": "192.168.1.13", "cpu": 96}]total_cpu = 0count = 0for server in servers:    total_cpu += server["cpu"]    count += 1average_cpu = total_cpu / countprint(f"CPU平均使用率：{average_cpu:.2f}%")
```
输出：
```
CPU平均使用率：67.00%
```
这里出现了一个新的格式化写法：
```
{average_cpu:.2f}
```
含义是保留两位小数。
例如：

| 原始数值    | 格式化结果 |
| ------- | ----- |
| 67      | 67.00 |
| 67.1234 | 67.12 |
| 80.5    | 80.50 |

注意：`:.2f` 只是控制输出显示格式，不会把原来的数值变量转换成字符串或改变其数值。
一个需要注意的问题： 如果列表为空，`count` 就是 0，直接执行 `total_cpu / count` 会发生除零错误。
所以实际程序中需要先判断：
```
if count > 0:    average_cpu = total_cpu / count    print(f"CPU平均使用率：{average_cpu:.2f}%")else:    print("没有可统计的服务器")
```
### 四、统计最大值和最小值
在运维工作中，我们还可能需要找出 CPU 使用率最高的服务器。
例如：
```
servers = [    {"ip": "192.168.1.10", "cpu": 35},    {"ip": "192.168.1.11", "cpu": 92},    {"ip": "192.168.1.12", "cpu": 45},    {"ip": "192.168.1.13", "cpu": 96}]max_cpu = 0max_server = ""for server in servers:    if server["cpu"] > max_cpu:        max_cpu = server["cpu"]        max_server = server["ip"]print(f"CPU使用率最高的服务器：{max_server}")print(f"CPU最高使用率：{max_cpu}%")
```
输出：
```
CPU使用率最高的服务器：192.168.1.13
CPU最高使用率：96%
```
这里的执行逻辑是：
1. 初始化最大值 `max_cpu = 0`。
2. 获取第一台服务器的 CPU 使用率。
3. 比较当前 CPU 使用率与 `max_cpu`。
4. 如果当前值更大，就更新最大值和服务器 IP。
5. 继续遍历，直到所有服务器检查完毕。
同理，可以使用 `<` 实现最小值统计。
这里还有一个细节：如果 CPU 数据可能全部为负数、数据缺失，或者列表为空，就不适合简单地把最大值初始化为 0。更稳妥的方式是使用第一条有效数据初始化，或者先判断是否存在有效数据。
### 五、综合案例：Linux 服务器巡检结果汇总
现在将前面的知识整合起来。
假设我们模拟巡检五台服务器，统计 CPU、内存、正常数量、异常数量、平均 CPU 和最高 CPU。
```
#!/usr/bin/python3servers = [    {"ip": "192.168.1.10", "cpu": 35, "memory": 60},    {"ip": "192.168.1.11", "cpu": 92, "memory": 75},    {"ip": "192.168.1.12", "cpu": 45, "memory": 85},    {"ip": "192.168.1.13", "cpu": 96, "memory": 90},    {"ip": "192.168.1.14", "cpu": 55, "memory": 50}]# 初始化统计变量total_count = 0normal_count = 0alarm_count = 0total_cpu = 0max_cpu = Nonemax_server = ""# 开始巡检for server in servers:    total_count += 1    cpu = server["cpu"]    memory = server["memory"]    total_cpu += cpu    if max_cpu is None or cpu > max_cpu:        max_cpu = cpu        max_server = server["ip"]    if cpu >= 90 or memory >= 90:        print(f"[异常] {server['ip']} CPU:{cpu}% 内存:{memory}%")        alarm_count += 1    else:        print(f"[正常] {server['ip']} CPU:{cpu}% 内存:{memory}%")        normal_count += 1# 汇总统计print("\n==========巡检报告==========")print(f"巡检服务器总数：{total_count}")print(f"正常服务器数量：{normal_count}")print(f"异常服务器数量：{alarm_count}")if total_count > 0:    average_cpu = total_cpu / total_count    print(f"平均CPU使用率：{average_cpu:.2f}%")    print(f"CPU最高使用率：{max_cpu}%")    print(f"CPU最高服务器：{max_server}")print("============================")
```
这个程序已经具备了一个简单巡检程序的基本统计能力。
模拟巡检报告
# 5
巡检总数
# 3
正常数量
# 2
异常数量
平均 CPU 使用率\
64.60%
最高 CPU 使用率\
96%
最高 CPU 服务器\
192.168.1.13
## 六、本节需要理解的核心思想

| 知识点                    | 用途            |
| ---------------------- | ------------- |
| `count += 1`           | 统计数量          |
| `total += value`       | 累加数据          |
| `total / count`        | 计算平均值         |
| `if value > max_value` | 统计最大值         |
| `if value < min_value` | 统计最小值         |
| 循环外初始化变量               | 保留整个循环过程的统计结果 |
| 循环结束后输出                | 生成汇总报告        |

这部分知识以后会直接应用到你的 Linux 巡检项目中，例如统计磁盘使用率超过阈值的数量、CPU 平均负载、异常进程数量等。
下一课：第二阶段总结与综合应用。 我们会把变量、数据类型、运算符、条件判断、循环、列表和字典串联起来，完成一个小型服务器巡检模拟程序，然后进入第三阶段：字符串、列表、元组、字典和集合的深入学习。
# 第二阶段：运算符与流程控制
## 第十一课：阶段总结与综合实战
前面我们已经学习了 Python 的变量、数据类型、运算符、条件判断和循环。本节先不引入太多新语法，而是把这些知识整合起来，完成一个小型 Linux 服务器巡检模拟程序。
这一步很重要：从单独理解 Python 语法，过渡到使用 Python 解决实际问题。
### 一、回顾第二阶段的核心知识

| 知识点      | 主要作用    | 常见写法                       |
| -------- | ------- | -------------------------- |
| 变量       | 保存数据    | `cpu = 80`                 |
| 数据类型     | 区分数据性质  | `int`、`float`、`str`、`bool` |
| 算术运算符    | 数值计算    | `+ - * / // %`             |
| 比较运算符    | 比较大小    | `== != > < >= <=`          |
| 逻辑运算符    | 组合条件    | `and`、`or`、`not`           |
| if 判断    | 条件分支    | `if / elif / else`         |
| while 循环 | 按条件重复执行 | `while`                    |
| for 循环   | 遍历数据    | `for`                      |
| break    | 结束循环    | `break`                    |
| continue | 跳过当前轮次  | `continue`                 |
| 列表       | 保存多个数据  | `[]`                       |
| 字典       | 保存键值对   | `{}`                       |

### 二、实战需求：模拟 Linux 服务器巡检
假设现在有五台服务器，需要实现以下功能：
1. 保存每台服务器的 IP、主机名、CPU、内存和磁盘使用率。
2. 遍历所有服务器。
3. 判断 CPU、内存和磁盘是否超过阈值。
4. 输出每台服务器的巡检结果。
5. 统计正常服务器数量和异常服务器数量。
6. 计算平均 CPU 使用率。
7. 找出 CPU 使用率最高的服务器。
本次使用模拟数据，先把程序逻辑掌握好，后面再学习如何从真实 Linux 系统采集数据。
### 三、完整代码
创建文件：
```
vim server_inspection.py
```
编写以下代码：
```
#!/usr/bin/python3    cpu = server["cpu"]    memory = server["memory"]    disk = server["disk"]    total_cpu += cpu    # 统计 CPU 最高值    if max_cpu is None or cpu > max_cpu:        max_cpu = cpu        max_server = ip    # 判断服务器状态    if (        cpu >= CPU_THRESHOLD        or memory >= MEMORY_THRESHOLD        or disk >= DISK_THRESHOLD    ):        print(f"[异常] {hostname} ({ip})")        if cpu >= CPU_THRESHOLD:            print(f"CPU使用率异常：{cpu}%")        if memory >= MEMORY_THRESHOLD:            print(f"内存使用率异常：{memory}%")        if disk >= DISK_THRESHOLD:            print(f"磁盘使用率异常：{disk}%")        alarm_count += 1    else:        print(f"[正常] {hostname} ({ip})")        normal_count += 1    print("------------------------------")# 5. 输出统计结果print("\n========== 巡检统计报告 ==========")print(f"巡检总数：{total_count}")print(f"正常数量：{normal_count}")print(f"异常数量：{alarm_count}")if total_count > 0:    average_cpu = total_cpu / total_count    print(f"平均CPU使用率：{average_cpu:.2f}%")    print(f"最高CPU使用率：{max_cpu}%")    print(f"最高CPU服务器：{max_server}")print("========== 巡检结束 ==========")
```
### 四、逐步理解程序的执行逻辑
不要急着记住整段代码，重点理解程序是如何组织起来的。
第一步：准备服务器数据
列表保存多台服务器，每台服务器使用字典描述
第二步：初始化统计变量
统计数量、CPU 累计值、最大 CPU 值
第三步：for 循环遍历服务器
逐台获取 IP、主机名和资源使用率
第四步：if 判断资源是否超标
根据 CPU、内存、磁盘阈值判断状态
正常
增加正常数量
异常
增加异常数量
第五步：输出统计报告
计算平均值、最大值，输出最终巡检结果
### 五、运行程序
保存文件后执行：
```
python3 server_inspection.py
```
你应该能看到类似以下结果：
```
========== 开始服务器巡检 ==========
[正常] server01 (192.168.1.10)
------------------------------
[异常] server02 (192.168.1.11)
CPU使用率异常：92%
------------------------------
[异常] server03 (192.168.1.12)
磁盘使用率异常：95%
------------------------------
[异常] server04 (192.168.1.13)
CPU使用率异常：96%
内存使用率异常：90%
------------------------------
[正常] server05 (192.168.1.14)
------------------------------
========== 巡检统计报告 ==========
巡检总数：5
正常数量：2
异常数量：3
平均CPU使用率：64.60%
最高CPU使用率：96%
最高CPU服务器：192.168.1.13
========== 巡检结束 ==========
```
## 六、第二阶段学习总结
到这里，你已经掌握了 Python 基础流程控制能力。
需要特别注意的是：目前程序中的服务器数据都是手动填写的，尚未真正读取 Linux 的 CPU、内存、磁盘信息。
后续我们会逐步学习：
- 如何从 Linux 系统获取真实数据。
- 如何把采集到的数据组织成列表和字典。
- 如何封装重复的巡检逻辑。
- 如何处理命令执行失败、文件不存在等异常。
- 如何生成日志和巡检报告。
这些内容会在后续阶段逐步实现，不需要现在就全部掌握。
# 第三阶段：Python 数据结构
开始新阶段
## 第一课：字符串（str）深入学习
字符串是 Python 中非常重要的数据类型。
在 Linux 运维中，字符串的应用非常广泛，例如：
- 读取 `/etc/os-release` 获取操作系统版本。
- 解析 `df -h` 获取磁盘使用情况。
- 解析 `ip addr` 获取 IP 地址。
- 处理 `/var/log/messages` 等系统日志。
- 从命令输出中提取错误信息。
本节先掌握字符串的基本操作。
### 一、字符串是什么？
字符串就是由字符组成的一段文本。
```
hostname = "server01"ip = "192.168.1.10"os_name = "openEuler"
```
可以使用单引号、双引号：
```
name1 = 'Linux'name2 = "Python"
```
也可以使用三引号表示多行字符串：
```
message = """服务器巡检报告CPU使用率：80%内存使用率：60%磁盘使用率：70%"""
```
### 二、字符串的拼接
使用 `+` 可以连接两个字符串：
```
hostname = "server01"ip = "192.168.1.10"result = hostname + " " + ipprint(result)
```
输出：
```
server01 192.168.1.10
```
注意，字符串不能直接与整数拼接：
```
cpu = 80# 错误result = "CPU使用率：" + cpu
```
需要转换类型：
```
result = "CPU使用率：" + str(cpu) + "%"
```
或者直接使用 f-string：
```
result = f"CPU使用率：{cpu}%"
```
实际开发中，推荐优先使用 f-string。
### 三、字符串长度 len()
使用 `len()` 获取字符串长度：
```
hostname = "server01"print(len(hostname))
```
输出：
```
8
```
中文字符也会计为一个字符：
```
message = "服务器巡检"print(len(message))
```
输出：
```
6
```
这里需要区分：`len()` 统计的是 Python 字符串中的字符数量，不等同于 UTF-8 编码后的字节数。
例如：
```
message = "Linux"print(len(message))print(len(message.encode("utf-8")))
```
两个结果都是 5。
而对于中文：
```
message = "服务器"print(len(message))print(len(message.encode("utf-8")))
```
在 UTF-8 编码下，结果分别是 3 和 9。
这在 Linux 日志编码、文件处理和字符长度判断时很有用。
### 四、字符串索引
字符串中的每个字符都有对应的位置，也就是索引。
```
text = "Linux"
```
索引从 0 开始：

| 字符   | L  | i  | n  | u  | x  |
| ---- | -- | -- | -- | -- | -- |
| 正向索引 | 0  | 1  | 2  | 3  | 4  |
| 反向索引 | -5 | -4 | -3 | -2 | -1 |

例如：
```
print(text[0])   # Lprint(text[1])   # iprint(text[-1])  # x
```
如果访问超出范围的索引，例如：
```
print(text[10])
```
就会出现 `IndexError`。
### 五、字符串切片
切片可以截取字符串的一部分。
语法：
```
字符串[开始索引:结束索引:步长]
```
注意：结束索引不包含在结果中。
例如：
```
text = "LinuxServer"print(text[0:5])
```
输出：
```
Linux
```
更多示例：
```
text = "LinuxServer"print(text[0:5])    # Linuxprint(text[5:])     # Serverprint(text[:5])     # Linuxprint(text[-6:])    # Serverprint(text[::2])    # Lnxreprint(text[::-1])   # revreSxuniL
```
切片在日志处理、字符串提取和数据解析中很常用。
本节先学习到字符串的基本操作。下一部分继续学习字符串常用方法，包括 `strip()`、`split()`、`replace()`、`find()`、`startswith()`、`endswith()`、`join()` 等，这些方法会直接应用于 Linux 命令输出和日志解析。
