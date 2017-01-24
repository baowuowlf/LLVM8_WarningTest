>年底了，又到了项目中消除warning的好时节，这里针对XCode8中LLVM8的警告开关做一个翻译和解释吧，了解一下，以备查询。

-----

![D大调.jpg](http://upload-images.jianshu.io/upload_images/1289608-954b103b15008c5e.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


###### Check Switch Statements (GCC_WARN_CHECK_SWITCH_STATEMENTS)
这个检查枚举是否都会处理，这里注意如果有default是不会报警的，默认YES
```objc
enum TestMenu {
    TestMenu_DEFAULT = 1,
    TestMenu_VALUE1,
    TestMenu_VALUE2,
    TestMenu_VALUE3
};
// -- Check Switch Statements
- (void)testCheck_Switch_Statements {
    enum TestMenu tValue = TestMenu_DEFAULT;
    switch (tValue) {
        case TestMenu_DEFAULT:
        case TestMenu_VALUE1:
        case TestMenu_VALUE2:
            NSLog(@"tValue = %d",tValue);
            break;
        /*这里如果有default，是不会报警告的
        default:
            break;
         */
    }
}
```
-----
######Deprecated Functions (GCC_WARN_ABOUT_DEPRECATED_FUNCTIONS)
这个会检查弃用的函数，默认YES
```objc
// -- Check Deprecated Functions
- (void)testDeprecated_Functions {
    CGSize size = CGSizeZero;
    NSString * string = @"abc";
    size = [string sizeWithFont:[UIFont systemFontOfSize:13]];
}
```
-----
######Documentation Comment 检查注释的
检测注释的暂不深究，默认NO

-----
######Check Empty Loop Bodies (CLANG_WARN_EMPTY_BODY)
这个检查循环体内部是否为空，这里注意如果有**default**是不会报警的，默认YES
```objc
// -- Check Empty Loop Bodies
- (void)testEmpty_Loop_Bodies {
    int a = 0;
    while(a>0);{
        // loop body
    }
}
```

-----
######Check Empty Loop Bodies (CLANG_WARN_EMPTY_BODY)
这个检查循环体内部是否为空，这里注意如果有default是不会报警的，默认YES
```objc
// -- Check Empty Loop Bodies
- (void)testEmpty_Loop_Bodies {
    int a = 0;
    while(a>0);{
        // loop body
    }
}
```
-----
######Hidden Local Variables (GCC_WARN_SHADOW)
这个检查内部参数是否与外部参数同名,如果同名则外部变量如函数参数，全局变量，外部变量等在内部被屏蔽(SHADOWED)，默认NO
```objc
//-- Check Hidden Local Variables
- (void)testHidden_Local_Variables {
    NSInteger aValue = 0;
    for (NSInteger i=0; i<3; i++) {
        NSInteger aValue = 4;
        NSLog(@"Inner aValue = %zd",aValue);
    }
    NSLog(@"-- Out aValue = %zd",aValue);
}
```
-----
######Implicit Boolean Conversions (CLANG_WARN_BOOL_CONVERSION)
这个检查Bool类型是否被隐私转换，这里实了几种，暂时结论应该是不允许将Bool隐私转换成对象指针，基础类型的转换是可以的，另外隐私转换YES为指针的话是直接报error的;默认YES
```objc
- (void)testImplicit_Boolean_Conversions {
    id aValue = NO;//这里会报警，隐式的将NO转换为null了
    NSLog(@"aValue = %@",aValue);
    
    //这里两种就没有报警
    int aValue2 = NO;
    char aValue3 = YES;
    NSLog(@"aValue2 = %d",aValue2);
    NSLog(@"aValue3 = %d",aValue3);
    
    TestSubClass *subObject = [TestSubClass new];
    TestSuperClass *superObject = subObject;//这里隐私转换也没有报警
    //subObject = YES;//YES的话这里会报一个error和一个warning,隐私转换YES是disAllow的
    NSLog(@"superObject = %@,subObject = %@",superObject,subObject);
    
    //这里还是没有问题
    BOOL aValue4 = nil;
    NSLog(@"aValue4 = %d",aValue4);
}
```
-----

######Implicit Constant Conversions (CLANG_WARN_CONSTANT_CONVERSION)
这个检查常量是否被隐私转换，这里试了几种,感觉这里类型的转换分的有点细了；默认YES
```objc
//-- Check Implicit Constant Conversions
- (void)testImplicit_Constant_Conversions {
    int8_t int8Value = 500;
    NSLog(@"int8Value = %d",int8Value);
    
    //const NSInteger intValue2 = 0;
    //char aValue2 = LONG_MAX;
    //NSLog(@"aValue2 = %c",aValue2);
}
```
-----
######Implicit Conversion to 32 Bit Type (GCC_WARN_64_TO_32_BIT_CONVERSION)
这个检查64位数是否被转换为32位，这个比较常见；默认YES
```objc
 //-- Check Implicit Conversions to 32 bit type
- (void)testImplicit_Conversions_to_32_bit_type {
    long theIntegerValue = LONG_MAX;
    int theIntValue = theIntegerValue;
    NSLog(@"theIntValue = %d",theIntValue);
}
```
-----
######Implicit Enum Conversions (CLANG_WARN_ENUM_CONVERSION)
这个会检查不同的enum之间的转换，这个应该重视；默认YES
```objc
enum TestEnum {
    TestEnum_DEFAULT = 1,
    TestEnum_VALUE1,
    TestEnum_VALUE2,
    TestEnum_VALUE3
};

enum TestEnum2 {
    TestEnum2_DEFAULT = 1,
    TestEnum2_VALUE1,
    TestEnum2_VALUE2,
    TestEnum2_VALUE3
};
//-- Check Implicit Enum Conversions
- (void)testImplicit_Enum_Conversions {
    enum TestEnum testValue = TestEnum2_VALUE1;
    NSLog(@"testValue = %d",testValue);
    
    int testValue2 = TestEnum_VALUE2;
    NSLog(@"testValue2 = %d",testValue2);
}
```
------
######Incompatible Integer to Pointer Conversion (CLANG_WARN_INT_CONVERSION)
这个会检查intger和pointer的相互转化，但是integer to pointer 首先会报error；默认YES
```objc
//-- Check Incompatible Integer to Pointer Conversion
- (void)testImplicit_Integer_to_Pointer {
    NSInteger integerValue = @111;//这里会报warning
    //NSNumber *testValue1 = 222;//这里会报warning，并且会报一个error
    NSLog(@"integer = %zd",integerValue);
}

```
-----
######Sign Comparison (GCC_WARN_SIGN_COMPARE)
这个会检查intger和pointer的相互转化，但是integer to pointer 首先会报error；默认NO
```objc
//-- Check Incompatible Integer to Pointer Conversion
- (void)testImplicit_Integer_to_Pointer {
    NSInteger integerValue = @111;//这里会报warning
    //NSNumber *testValue1 = 222;//这里会报warning，并且会报一个error
    NSLog(@"integer = %zd",integerValue);
}
```
-----
######Infinite Recursion (CLANG_WARN_INFINITE_RECURSION)
这个应该会检查无限循环递归，但是试了几个方式都没有出现警告；默认YES
```objc
// -- Check Infinite Recursion
- (void)setProperty1:(NSString *)property1{
    [self setProperty1:property1];//应该出警告的，为什么没出？
}
- (int)foo {
    return [self foo];//应该出警告的，为什么没出？
}
```
-----
######Initializer Not Fully Bracketed (GCC_WARN_INITIALIZER_NOT_FULLY_BRACKETED)
这个会检查数组等括号的完整性，这种形式用的不多，暂不深究；默认NO
```objc
//-- Check Initializer Not Fully Bracketed
- (void)testInitializer_Not_Fully_Bracketed{
    int a[2][2] = { 0, 1, 2, 3 };//这里会报警，因为口号不全
    int b[2][2] = { { 0, 1 }, { 2, 3 } };
    a[0][0] = b[0][0];
}
```
------

######Mismatched return type (GCC_WARN_ABOUT_RETURN_TYPE)
这个会检测函数的返回值类型是否匹配，试了几个情况，缺还预想的不同，这里应该只会检查是否给了返回值；默认YES treat as error
```objc
//-- Check Mismatched return type
- (NSTimer*)testMismatched_return_type{
    NSString * rs = @"test";
    if (random() > 3) {
        return ;//这里就会报错了，
    }else if(random() > 2) {
        return 0;//这里确是没有问题
    }else {
        return rs;//这里的警告和这个开关无关，oh,why?
    }
}
```
-----

######Missing Braces and Parentheses (CLANG_WARN_MISSING_PARENTHESES)
这个会检测if else等括号，如果不写括号会报警的；默认YES
```objc
//-- Check Missing Braces and Parentheses
- (void)testMissing_Braces_and_Parentheses {
    if (random())
        if (random())
            return;
    else//这里就会报警
        NSLog(@"-- 1");
}

```
-----
######Missing Fields in Structure Initializers (GCC_WARN_ABOUT_MISSING_FIELD_INITIALIZERS)
这个会检测结构体初始化参数个数是否匹配；默认NO
```objc
//-- Check Missing Fields in Structure Initializers
- (void)testMissing_Fields_in_Structure_Initializers {
    CGSize size = {3};
    size.width = 3;
}
```
-----
######Missing Function Prototypes(GCC_WARN_ABOUT_MISSING_FIELD_INITIALIZERS)
这个会检测函数声明是否声明过，c的用法，这里也不深究了；默认NO
```objc
//-- Check Missing Function Prototypes
BOOL testMissing_Function_Prototypes() {
    return YES;
}

```
-----
######Out-of-range enum assignments(CLANG_WARN_ASSIGN_ENUM)
这个会检测枚举赋值是否越界；默认NO
```objc
//-- Check Missing Function Prototypes
BOOL testMissing_Function_Prototypes() {
    return YES;
}

```
-----
######Sign Comparison (GCC_WARN_SIGN_COMPARE)
######Pointer Sign Comparison (GCC_WARN_ABOUT_POINTER_SIGNEDNESS)
这个没搞定，找不出有什么跟这两个开关有关的；默认NO
```objc
// --Check Pointer Sign Comparison & Sign Comparison
- (void)testPointer_Sign_Comparison {
    //这个没有试出来
    NSString * testValue = [NSString new];
    NSData * testValue2 = [NSData new];
    if (testValue == testValue2) {
        
    }
    
    NSNumber *anInt = @27;
    NSNumber *sameInt = @27U;
    // Pointer comparison (fails)
    if (anInt == sameInt) {
        NSLog(@"They are the same object");
    }
}
```
-----
######Suspicious Implicit Conversions (CLANG_WARN_SUSPICIOUS_IMPLICIT_CONVERSION)
这个会检可疑的隐式转换，不过还是没有找到case；默认NO
```objc
// --Check Suspicious Implicit Conversions
- (void)testSuspicious_Implicit_Conversions {
    NSUInteger testValue1 = 13;
    BOOL testValue2 = testValue1;
    testValue2 = !testValue2;
}
```
------
######Treat Imcompatible Pointer Type Warning as Errors(GCC_TREAT_INCOMPATIBLE_POINTER_TYPE_WARNINGS_AS_ERRORS)
这个将不兼容的指针赋值，这个一开很多指针赋值都会有问题了平时开发可疑适度打开这个开关；默认NO

------
######Treat Missing Function Prototypes as Errors (GCC_TREAT_IMPLICIT_FUNCTION_DECLARATIONS_AS_ERRORS)
这个会检测函数声明，如果没有函数声明，则报错；默认NO

-----
#####Typecheck Calls to printf/scanf(GCC_WARN_TYPECHECK_CALLS_TO_PRINTF)
这个会检测打印输入等%d指定格式是否匹配；默认YES
```objc
// --Check Typecheck Calls to printf/scanf
- (void)testTypecheck_Calls_to_printf_scanf {
    NSLog(@"%d",@"a");
}
```
-----
######Unknown Pragma (GCC_WARN_UNKNOWN_PRAGMAS)
这个会检测Pragma是否合法；默认NO
```objc
// --Check Unknown Pragma
#pragma --Unknown Pragma
```
-----
######Unreachable Code(CLANG_WARN_UNREACHABLE_CODE)
这个会检测代码是否会被执行；默认YES
```objc
// --Check UnReachable Code
- (void)testCheck_UnReachable_Code {
    return;
    NSLog(@"Check UnReachable Code");
}
```
-----
######Unused Function(GCC_WARN_UNUSED_FUNCTION)
这个会检测声明的静态函数是否被实现，这个跟我想的意义完全不一样，本来还想用这个来检测垃圾代码的；默认YES

-----
######Unused Labels (GCC_WARN_UNUSED_LABEL)
这个会检测goto的没有的label；默认NO
```objc
// --Check Unused Labels
- (void)testUnuseLabels {
    //goto myLabel1;
    NSLog(@"I won't print");
    myLabel1:
    NSLog(@"I will print");
}
```
------
######Unused Parameters(GCC_WARN_UNUSED_PARAMETER)
这个会检测函数参数是否被用到；默认NO
```objc
//Unused Parameters
- (void)testUnused_Parameters:(int)arg1 {
    NSLog(@"%s",__FUNCTION__);
}
```
------
######Unused Values(GCC_WARN_UNUSED_VALUE)
这个会检测变量是否有用到,这个很常见就不展示了；默认YES

------
######Unused Values(GCC_WARN_UNUSED_VALUE)
######Unused Variables(GCC_WARN_UNUSED_VARIABLE)
这个会检测变量以及值是否有用到，比较奇怪，我觉得有些情况应该也要报警的，缺没有报警，只看到这种情况；默认YES
```objc
//Unused Values & Unused Variables
- (void)testUnused_Values_Unused_Variable {
    NSInteger i = 0;
    NSInteger a = 0;//这里报unused variable
    NSArray * tags = @[];
    for ( i; i < tags.count; i++) {//这里第一个分号前的i去掉警告消除
        NSLog(@"%zd",i);
    }
    NSLog(@"%zd",i);
}
```
------
>以下没啥用不解释了:
•	Four Character Literals 
•	Missing Newline At End of File
