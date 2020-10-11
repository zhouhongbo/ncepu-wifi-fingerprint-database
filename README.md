用于WiFi室内定位的MATLAB代码。

目录结构:
./      ->      通用的工具函数和示例脚本
db/     ->      数据集. 里面的每个子文件夹包含了一周的实验数据. 每个数据集包括4个文件: RSS值, 时间戳, 位置坐标和样本的ID
files/  ->      加载文件的函数
ids/    ->      过滤加载数据的函数
ips/	->      定位算法

基于下述代码修改：

G.M. Mendoza-Silva, P. Richter, J. Torres-Sospedra, E.S. Lohan, J. Huerta, A. Cramariuc, "Long-Term Wi-Fi fingerprinting dataset and supporting material", Zenodo repository, DOI 10.5281/zenodo.1066041.