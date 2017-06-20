####Shell脚本&&Linux常用命令学习实录：
参考文章：
<https://github.com/qinjx/30min_guides/blob/master/shell.md#mac-os>
鸟哥的Linux私房菜

####准备工作：
使用bash ，新建一个文件，扩展名为sh，例如： vi test.sh文件, 并输入代码：

    #!/bin/bash
    echo "Hello World !"
    
 “#!” 是一个约定的标记，它告诉系统这个脚本需要什么解释器来执行，即使用哪一种Shell。echo命令用于向窗口输出文本。
 
####1、执行脚本：
cd到脚本所在目录， ``./test.sh  #执行脚本``

    注意，一定要写成./test.sh，而不是test.sh。运行其它二进制的
    程序也一样，直接写test.sh，linux系统会去PATH里寻找有没有叫
    test.sh的，而只有/bin, /sbin, /usr/bin，/usr/sbin等在
    PATH里，你的当前目录通常不在PATH里，所以写成test.sh是会找不
    到命令的，要用./test.sh告诉系统说，就在当前目录找。

####2、定义变量：
定义变量时，变量名不加美元符号（$），而且变量名和等号之间不能有空格如：
    
     myName="zhangzhongyang"
     echo ${myName}  #使用变量的时候要加 $ 符号

####3、创建文件夹mkdir：
    dirname="zhangzhongyang"
    mkdir $dirname
    
####4、实践一：找出来某个文件夹下面所有的png图片
    dirname="pngIcon"  #自定义文件夹的名称
	mkdir $dirname     #创建文件夹
	filename="/Users/zhangzhongyang/Desktop/git/dfc/Images"  #目标文件夹的绝对地址,赋值给一个新的变量
	cp -a $filename/*jpg $dirname 
    #cp:拷贝文件， *通配符，代表0个到无穷个任意字符 -a表示完全拷贝，无差异性
    
####5、选取命令:cut, grep
+ #####cut : 这个命令可以将一段信息的某一个段“切”出来，处理的信息是以“行”为单位。
    
        cut -d '分割字符' -f 第几段     #用于分割字符
    
        cut -c  字符范围              #用于排列整齐的信息
   		参数：
   		-d: 后面接分隔符，与-f一起使用
   		-f: 依据-d的分隔符将一段信息切成数段， 用-f 取出第几段的
   		意思，如果要取出其中几段，用逗号分割,例如 -f 3,5
   		-c: 以字符（charecters）的单位取出固定字符区间
   		
   #####范例一：将PATH变量取出，找出第三和第五个路径:
        echo $PATH | cut ':' -f 3，5
   
  #####范例二：将export变量输出的信息取出第12个字符到20字符以内的所有字符串:
        export | cut -c 12-20
        export | cut -c 12-     :12个字符以后的所有字符串


+ #####grep: cut是在一行信息中取出某部分我们想要的，而grep则是分析一行信息，若当中有我们所需要的信息，就把该行拿出来：
        grep [-acinv] [--color=auto] '查找字符串' filename
        -a：将binary文件以text文件的方式查找数据
        -c：计算找到'查找字符串' 的次数
        -i: 忽略大小写的不同，所以大小写视为相同
        -n: 顺便输出行号
        -v: 反向选择，即显示出没有'查找字符串'内容的那一行
        --color=auto:可以把找到的关键字部分加上颜色显示
        
  #####范例一：取出 /etc/man.config 内含 MANPATH的那几行:
        grep --color=auto 'MANPATH' /etc/man.config
 
  #####范二：将last输出信息中，有root就取出，并且仅取出第一列:
        last | grep 'root' | cut -d ' ' -f1

####6、修改文件时间或创建新文件：touch

####7、文件内容的查阅：
    cat(从第一行还是显示文件内容)
    more（一页一页的显示文件内容）
    less（与more类似，不过它可以往前翻页）
    tail（只看结尾几行）

####8、解压缩命令（单文件压缩）:gzip,zcat， bzip2,bzcat,两者用法基本相同，bzip2能提供更好的压缩比，压缩后源文件就不存在了
     gzip(bzip2) [-cdtv#] 文件名
     参数：
     -c: 将压缩过程中的数据输出到屏幕上，可通过数据流重定向来处理
     -d: 解压缩的参数
     -t: 可以用来检验一个压缩文件的一致性，看看文件有无错误
     -v: 可以显示出源文件/压缩文件的压缩比等信息
     -#: 压缩等级，-1最快，但是压缩比最差， -9最差，但压缩比最好，默认-6
     eg: bzip2 -v test.sh

####9、打包命令（多个文件或目录包成一个大文件）:tar
    tar -jpcv -f ***.tar.bz2 文件名
    tar -zpcv -f ***.tar.gz 文件名
    -j: 通过bzip2的方式支持解压缩，此时文件名最好为***.tar.bz2
    -z: 通过gzip的方式支持解压缩，此时文件名最好为***. tar.gz
	-p: 保留备份数据的原本权限与属性，常用于备份重要的配置文件
	-c: 新建打包文件， 可搭配-v来查看过程中被打包的文件名
	-v: 在压缩/解压缩过程中，将正在处理的文件名显示出来
	-f filename： -f后面要接被处理后的文件名。建议 -f 单独写一个参数
	eg: tar -jc -f Book.tar.bz2 Book



