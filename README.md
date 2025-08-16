# CFM-GXL 配置管理器

## 概述

CFM-GXL 提供统一的版本管理、Git操作和标签管理功能。实现了标准化的配置管理流程，支持版本号自动管理、Git提交操作和标签发布等功能。

## 版本信息

当前版本：0.2.0

## 系统架构

### 核心组件

CFM-GXL 由以下核心模块构成：

- **cfm**: 主配置模块，协调其他模块的依赖关系
- **ver**: 版本管理模块，提供版本号操作功能
- **git**: Git操作模块，处理版本提交相关操作
- **tag**: 标签管理模块，支持不同阶段的标签发布
- **ver_adm**: 版本管理器，提供高级版本管理功能

### 目录结构

```
cfm-gxl/
├── _gal/                    # Galaxy 配置目录
│   ├── adm.gxl             # 管理配置文件
│   └── work.gxl            # 工作配置文件
├── mods/                   # 模块目录
│   ├── cfm.gxl             # 主配置模块
│   ├── git.gxl             # Git操作模块
│   ├── tag.gxl             # 标签管理模块
│   ├── ver.gxl             # 版本管理模块
│   └── ver_adm.gxl         # 版本管理器
├── tests/                  # 测试目录
│   ├── data/               # 测试数据
│   └── ver.gxl             # 版本测试
├── .gitignore              # Git 忽略文件
├── README.md               # 项目说明文档
├── version.txt             # 版本信息文件
└── version.txt             # 版本信息文件
```

## 功能特性

### 1. 版本管理 (ver)

提供完整的版本号管理功能：

- **use**: 读取当前版本号
- **build**: 更新构建版本号
- **patch**: 更新补丁版本号
- **feature**: 更新功能版本号

### 2. Git操作 (git)

提供Git相关的操作功能：

- **ci_ver**: 版本提交操作，自动更新版本号并提交到Git

### 3. 标签管理 (tag)

支持不同阶段的标签发布：

- **alpha**: Alpha版本标签
- **beta**: Beta版本标签
- **rc**: Release Candidate版本标签

### 4. 版本管理器 (ver_adm)

提供高级版本管理功能：

#### 系统版本管理 (sys_ver_adm)
- **up_patch**: 更新补丁版本号
- **up_patch_commit**: 更新补丁版本号并提交
- **up_feature**: 更新功能版本号
- **up_feature_commit**: 更新功能版本号并提交
- **tag_stable**: 创建稳定版本标签
- **tag_beta**: 创建Beta版本标签
- **tag_alpha**: 创建Alpha版本标签

#### 库版本管理 (lib_ver_adm)
- 提供与系统版本管理相同的功能，用于库项目

## 配置说明

### 依赖配置

在 `_gal/adm.gxl` 中配置模块依赖：

```gxl
extern mod cfm { path = "./mods/" }

mod envs {
  env default {
  }
}
mod main : ver_adm {
}
```

### 模块依赖关系

```gxl
// cfm.gxl
extern mod ver,git,tag,ver_adm { path="@{PATH}" }
```

## 使用方法

### 1. 版本操作

```bash
# 读取当前版本
gx.ver(file: "${GXL_START_ROOT}/version.txt", inc: "null")

# 更新构建版本
gx.ver(file: "${GXL_START_ROOT}/version.txt", inc: "build")

# 更新补丁版本
gx.ver(file: "${GXL_START_ROOT}/version.txt", inc: "bugfix")

# 更新功能版本
gx.ver(file: "${GXL_START_ROOT}/version.txt", inc: "feature")
```

### 2. Git操作

```bash
# 版本提交
gx.ver(file: "${GXL_START_ROOT}/version.txt", inc: "null")
gx.echo("${VERSION}")
gx.cmd("git commit -a -m 'update version to ${VERSION}'")
```

### 3. 标签操作

```bash
# 创建Alpha标签
gx.cmd("git tag v${VERSION}-alpha")
gx.cmd("git push --tags")

# 创建Beta标签
gx.cmd("git tag v${VERSION}-beta")
gx.cmd("git push --tags")

# 创建稳定标签
gx.cmd("git tag v${VERSION}")
gx.cmd("git push --tags")
```

### 4. 高级版本管理

```bash
# 更新补丁版本并提交
ver.patch | git.ci_ver

# 更新功能版本并提交
ver.feature | git.ci_ver

# 创建稳定版本标签
gx.ver(file: "${GXL_START_ROOT}/version.txt", inc: "null")
gx.cmd("git tag v${VERSION}")
gx.cmd("git push --tags")
```

## 环境变量

CFM-GXL 使用以下环境变量：

- `GXL_START_ROOT`: 项目根目录路径
- `GXL_CHANNEL`: Galaxy 通道配置
- `PATH`: 模块路径配置
- `VERSION`: 当前版本号（由系统自动设置）

## 外部脚本依赖

标签管理模块依赖于以下外部脚本：

- `tag_alpha.sh`: Alpha版本标签脚本
- `tag_beta.sh`: Beta版本标签脚本
- `tag_rc.sh`: Release Candidate版本标签脚本

## 最佳实践

### 1. 版本管理

- 使用语义化版本控制 (SemVer)
- 按照以下顺序更新版本号：feature → patch → build
- 在每次版本更新后进行Git提交

### 2. 标签管理

- 遵循开发流程：alpha → beta → rc → stable
- 确保标签与版本号对应
- 及时推送标签到远程仓库

### 3. 工作流程

1. 开发新功能时使用 `up_feature`
2. 修复bug时使用 `up_patch`
3. 发布版本时使用相应的标签操作
4. 定期进行版本提交和标签推送

## 故障排除

### 常见问题

1. **版本号更新失败**
   - 检查 `version.txt` 文件是否存在
   - 确认文件权限设置正确
   - 验证 `GXL_START_ROOT` 环境变量

2. **Git操作失败**
   - 检查Git仓库状态
   - 确认有提交权限
   - 验证网络连接

3. **标签操作失败**
   - 检查标签脚本是否存在
   - 确认脚本执行权限
   - 验证远程仓库访问权限

### 调试方法

1. 使用 `gx.echo` 输出调试信息
2. 检查环境变量设置
3. 验证文件路径和权限
4. 查看详细的错误日志

## 依赖关系

- **Galaxy Operator 框架**: 基础运行环境
- **Sys-Operator 规范**: 系统操作标准
- **Git**: 版本控制系统
- **外部脚本**: 标签管理脚本

## 开发指南

### 添加新功能

1. 在相应模块中添加新的flow或activity
2. 更新依赖配置
3. 添加相应的测试用例
4. 更新文档

### 测试

项目包含测试目录 `tests/`，提供版本管理功能的测试用例。

## 贡献指南

1. 遵循 Sys-Operator 命名规范
2. 实现完整的模块接口
3. 提供详细的文档和示例
4. 确保代码质量和测试覆盖

## 许可证

请参考项目根目录的许可证文件。

## 联系方式

如有问题或建议，请通过以下方式联系：

- 项目仓库：[Galaxy Operators](https://github.com/galaxy-operators)
- 问题反馈：GitHub Issues

---
