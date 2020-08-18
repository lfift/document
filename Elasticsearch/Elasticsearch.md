# 基本概念

## 文档（Document)

* Elasticsearch 是面向文档的，文档是所有可搜索的最小单元
  * 一件商品的信息
  * 一部电影的信息
* 文档会被序列化为 JSON 的数据格式，保存在 Elasticsearch 中
  * JSON 对象由字段组成
  * 每一个字段都有对应的字段类型（字符串/数值/布尔/日期/二进制/范围类型）
* 每一个文档有一个 Unique ID 
  * 可以自己指定
  * 或者通过 Elasticsearch 自动生成

### JSON 文档

* 一篇文档包含了一系列的字段。类似数据库表中的一条记录

* JSON 文档，格式灵活，不需要预先定义格式

  * 字段的类型可以指定或者通过 Elasticsearch 自动推算
  * 支持数组
  * 支持嵌套

  ``` json
  {
    "_index" : "movies",
    "_type" : "_doc",
    "_id" : "125",
    "_score" : 1.0,
    "_source" : {
      "year" : 1996,
      "@version" : "1",
      "id" : "125",
      "title" : "Flirting With Disaster",
      "genre" : [
        "Comedy"
      ]
    }
  }
  ```

### 文档的元数据

* 元数据，用于标注文档的相关信息
  * _index：文档所属的索引名
  * _type：文档所属的类型名
  * _id：文档唯一id
  * _source：文档的原始 Json 数据
  * _all：整合所有字段内容到该字段，已被废除
  * _version：文档的版本信息
  * _score：相关性打分

## 索引（Index）

* 索引是文档的容器，是一类文档的集合
  * Index 体现了逻辑空间的概念：每个索引都有自己的 Mapping 定义，用于定义包含的文档的字段名和字段类型
  * Shard 体现了物理空间的概念：索引中的数据分散在 Shard 上
* 索引的 Mapping 与 Settings
  * Mapping 定义文档字段的类型
  * Setting 定义不同的数据分布

### 索引的不同语意

* 名词：一个 Elasticsearch 集群中，可以创建很多个不同的索引
* 动词：保存一个文档到 Elasticsearch 集群中的过程（indexing）
  * ES 中，创建一个倒排索引的过程
* 名词：一个 B 树索引，一个倒排索引

## 类型（Type）

* 在 7.0 之前，一个 Index 可以设置多个 Type
* 6.0 开始，Type 已经被 Deprecated。7.0 开始，一个索引只能创建一个 Type：”_doc”

## 对比

| RDBMS  | Elasticsearch |
| :----- | ------------- |
| Table  | Index（Type） |
| Row    | Document      |
| Column | Field         |
| Schema | Mapping       |
| SQL    | DSL           |

* 传统关系型数据库和 Elasticsearch 的区别
  * Elasticsearch：Schemaless / 相关性 / 高性能全文检索
  * RDBMS：事务性 / Join

## 分布式系统的可用性与扩展性

* 高可用性
  * 服务可用性：允许有节点停止服务
  * 数据可用性：部分节点丢失，不会丢失数据
* 可扩展性
  * 请求量提升 / 数据得不断增长（将数据分布到所有节点上）

## 分布式特性

* Elasticsearch 的分布式架构的好处
  * 存储的水平扩容
  * 提高系统的可用性，部分节点停止服务，整个集群的服务不受影响
* Elasticsearch 的分布式架构
  * 不同的集群通过不同的名字来区分，默认名字是：elasticsearch
  * 可通过配置文件修改，或者在启动参数中增加 -E cluster.name=your cluster name 进行设定
  * 一个集群可以有一个或多个节点

## 节点（Node）

* 节点是一个 Elasticsearch 的实例
  * 本质上就是一个 Java 进程
  * 一台机器上可以运行多个 Elasticsearch 进程，但是生产环境一般建议一台机器上只运行一个 Elasticsearch 实例
* 每一个节点都有名字，通过配置文件配置，或者启动时增加参数：-E node.name=your node name 指定
* 每一个节点启动后会分配一个 UID ，保存在 data 目录下

### 候选节点（Master Eligible Nodes）

具有 Master Node 选举的节点

* 每一个节点启动后，默认就是一个 Master Eligible 节点
  * 可以设置：node.master: false 禁止
* Master Eligible 节点可以参加选主流程，成为Master

### 主节点（Master Node）

集群中的主节点

* 默认情况下当集群的第一个节点启动时，它会将自己选举成 Master 节点
* 每一个节点上都保存了集群的状态，但是只有 Master 节点才能修改集群的状态信息
  * 集群状态（Cluster State）：维护了一个集群中的必要信息
    * 所有的节点信息
    * 所有的索引和其相关的 Mapping 与 Setting 信息
    * 分片的路由信息
  * 如果任意节点都能修改信息将会导致数据不一致问题

