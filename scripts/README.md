# 更新脚本说明

`checkupdate.sh` 列出repo中被开发修改过的project列表;<br>
`checkupdate.sh help` 可用命令帮助;<br>
`checkupdate.sh check_github_multi` 检测实验室repo的project与github project是否一致，保证两方的manifest对应的一致性，包括openthos/oto_路径名称等生成检测;<br>
**checkupdate.sh projects_update** 自动化实验室repo提交至github的入口，已配置到185服务器的自动化任务当中;<br>
`checkupdate.sh up2github` 自动更新multiwindow到github，同时具备github外部提交的检测，出现外部提交将报告。<br><br>

`push2github.sh` 设置好所需project到变量new_repo，运行时提供github用户名密码，将自动在github创建提供的project，并push到github; 方式主要是调用github API.<br><br>

`proj_name2path.sh` 把repo manifest的name转换成对应的path，有被checkupdate.sh调用。<br>

