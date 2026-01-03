# Pascal-BP-Network 🚀

> **A backpropagation neural network implemented in pure Pascal.**

> **一个纯 Pascal 语言实现的 BP 神经网络。**

This project uses the **Concrete Compressive Strength Dataset** from the **UCI Machine Learning Repository** to train and test a neural network model. All the parameters 

本项目使用 **UCI 机器学习库** 中的 **混凝土抗压强度数据集** 来训练和测试神经网络模型。

This project demonstrates that even with a legacy language/IDE environment, modern performance can be achieved through hardware-specific compiler tuning (AVX2) and logical optimization.  

本项目旨在证明，即使是在复古的语言和 IDE 环境下，通过针对硬件的编译调优（AVX2）和逻辑优化，依然能获得现代级别的性能表现。

**Notice:** All parameters are the result of precision tuning. If you wish to experiment, you can modify the values in the `const` section of the program.  

**提示：** 程序中的所有参数均为调优后的最佳结果。如需自行调整，请修改程序 `const` 部分的数值。

---

### 📊 Performance | 性能表现
*Tested on a modern x64 processor with 50,000 epochs | 在现代 x64 处理器上进行 50,000 轮训练测试*

| Metric (指标) | Details (详情) | Result (结果) |
| :--- | :--- | :--- |
| **Baseline** | Standard 80386 mode (标准模式) | **53.546s** |
| **Optimized** | COREAVX2 + Inline (优化模式) | **17.750s** |
| **Accuracy** | Mean Absolute Error (MAE) | **3.5875** |

---

### 🖥️ Development Environment | 开发环境
**The code was developed and precision-tuned using the classic Free Pascal IDE (FP.EXE).** 

**代码使用经典的 Free Pascal IDE (FP.EXE) 进行开发与精细调优。**

* **The Setup:** A legacy 16-bit-styled skeuomorphic interface running on a modern 64-bit environment.  
  *在现代 64 位环境下运行的具有 16 位时代风格的拟物化界面。*
* **The Challenge:** Bridging the gap between 1990s IDE aesthetics and 2026 hardware capabilities.  
  *跨越 20 世纪 90 年代的 IDE 审美与 2026 年硬件性能之间的鸿沟。*

---

### ⚙️ Optimization Notes | 优化说明
To achieve the 17s benchmark, the following settings were configured within the IDE:  
为了达到 17 秒的基准成绩，在 IDE 中进行了如下配置：

1. **Target Processor (COREAVX2)**: Enables 256-bit SIMD vectorization.  
   *目标处理器 (COREAVX2): 开启 256 位 SIMD 向量化指令集。*
2. **Optimization Level (Level 3)**: Heuristic optimizations for speed.  
   *优化等级 (Level 3): 针对速度进行启发式优化。*
3. **Syntax Switches (Allow inline)**: Eliminates `fastSigmoid` call overhead.  
   *语法开关 (允许内联): 消除 fastSigmoid 函数调用的额外开销。*

**What's More | 此外：**
* **Math Logic**: Implemented a lookup table to bypass expensive `exp()` calculations.  
  *数学逻辑：实现 Sigmoid 查表法，绕过耗时的 exp() 指数运算。*

---

### 📂 Files | 文件说明
* **`BPNetwork.pas`**: Core engine source code. (源码)
* **`Concrete_Data.csv`**: Training dataset. (训练数据集)
* **`training_result_sample.txt`**: A sample output of the 17.75s run. (17.75秒运行结果样本)

---

### 🛠️ Usage | 使用方法
1. **Environment**: Keep `BPNetwork.pas` and `Concrete_Data.csv` in the same directory.  
   *确保 BPNetwork.pas 和 Concrete_Data.csv 位于同一目录。*
2. **Compilation**: Compile with FPC (Free Pascal Compiler) and configure optimization settings.  
   *使用 FPC 编译器并配置优化选项。*
3. **Execution**: Run the executable; results will be saved to `Training_result.txt`.  
   *运行程序，结果将自动保存至 Training_result.txt。*

---

### 📜 License | 协议
**MIT License**

---
**Η Pascal είναι η καλύτερη γλώσσα προγραμματισμού στον κόσμο!**
