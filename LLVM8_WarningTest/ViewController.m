//
//  ViewController.m
//  LLVM8_WarningTest
//
//  Created by caoyu on 2017/1/22.
//  Copyright © 2017年 caoyu. All rights reserved.
//


#import "ViewController.h"

@interface TestSuperClass : NSObject @end
@implementation TestSuperClass @end

@interface TestSubClass : TestSuperClass @end
@implementation TestSubClass @end

@interface ViewController ()
@property (nonatomic,strong) NSString *property1;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


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

// -- Check Switch Statements
- (void)testCheck_Switch_Statements {
    enum TestEnum tValue = TestEnum_DEFAULT;
    switch (tValue) {
        case TestEnum_DEFAULT:
        case TestEnum_VALUE1:
        case TestEnum_VALUE2:
            NSLog(@"tValue = %d",tValue);
            break;
        /*这里如果有default，是不会报警告的
        default:
            break;
         */
    }
}

// -- Check Deprecated Functions
- (void)testDeprecated_Functions {
    CGSize size = CGSizeZero;
    NSString * string = @"abc";
    size = [string sizeWithFont:[UIFont systemFontOfSize:13]];
}

// -- Check Empty Loop Bodies
- (void)testEmpty_Loop_Bodies {
    NSInteger a = 0;
    while(a>0);{
        // loop body
    }
}

//-- Check Hidden Local Variables
- (void)testHidden_Local_Variables {
    NSInteger aValue = 0;
    for (NSInteger i=0; i<3; i++) {
        NSInteger aValue = 4;
        NSLog(@"Inner aValue = %zd",aValue);
    }
    NSLog(@"-- Out aValue = %zd",aValue);
}

//-- Chekc Implicit Boolean Conversions
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

//-- Check Implicit Constant Conversions
- (void)testImplicit_Constant_Conversions {
    int8_t int8Value = 500;
    NSLog(@"int8Value = %d",int8Value);
    
    char aValue = 800;
    NSLog(@"aValue = %c",aValue);
    
    //const NSInteger intValue2 = 0;
    //char aValue2 = LONG_MAX;
    //NSLog(@"aValue2 = %c",aValue2);
}

//-- Check Implicit Conversions to 32 bit type
- (void)testImplicit_Conversions_to_32_bit_type {
    long theIntegerValue = LONG_MAX;
    int theIntValue = theIntegerValue;
    NSLog(@"theIntValue = %d",theIntValue);
}

//-- Check Implicit Enum Conversions
- (void)testImplicit_Enum_Conversions {
    enum TestEnum testValue = TestEnum2_VALUE1;
    NSLog(@"testValue = %d",testValue);
    
    int testValue2 = TestEnum_VALUE2;
    NSLog(@"testValue2 = %d",testValue2);
}

//-- Check Incompatible Integer to Pointer Conversion
- (void)testImplicit_Integer_to_Pointer {
    NSInteger integerValue = @111;//这里会报warning
    //NSNumber *testValue1 = 222;//这里会报warning，并且会报一个error
    NSLog(@"integer = %zd",integerValue);
}

//-- Check Incompatible Signedness Conversions
- (void)testSignedness_Conversions {
    NSInteger intValue = -3;
    NSUInteger uIntValue = intValue;
    intValue = uIntValue;
    NSLog(@"uIntValue = %zu",uIntValue);
}


// -- Check Infinite Recursion
- (void)setProperty1:(NSString *)property1{
    [self setProperty1:property1];//应该出警告的，为什么没出？
}

- (int)foo {
    return [self foo];//应该出警告的，为什么没出？
}

//-- Check Initializer Not Fully Bracketed
- (void)testInitializer_Not_Fully_Bracketed{
    int a[2][2] = { 0, 1, 2, 3 };//这里会报警，因为口号不全
    int b[2][2] = { { 0, 1 }, { 2, 3 } };
    a[0][0] = b[0][0];
}

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

//-- Check Missing Braces and Parentheses
- (void)testMissing_Braces_and_Parentheses {
    if (random())
        if (random())
            return;
    else//这里就会报警
        NSLog(@"-- 1");
}

//-- Check Missing Fields in Structure Initializers
- (void)testMissing_Fields_in_Structure_Initializers {
    CGSize size = {3};
    size.width = 3;
}

//-- Check Missing Function Prototypes
BOOL testMissing_Function_Prototypes() {
    return YES;
}

// --Check Out-of-range enum assignments
- (void)testOut_of_range_enum_assignments {
    enum TestEnum testValue = 199;
    testValue = TestEnum_VALUE2;
}

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

// --Check Suspicious Implicit Conversions
- (void)testSuspicious_Implicit_Conversions {
    NSUInteger testValue1 = 13;
    BOOL testValue2 = testValue1;
    testValue2 = !testValue2;
}

// --Check Typecheck Calls to printf/scanf
- (void)testTypecheck_Calls_to_printf_scanf {
    NSLog(@"%d",@"a");
}

// --Check Unknown Pragma
#pragma --Unknown Pragma

// --Check UnReachable Code
- (void)testCheck_UnReachable_Code {
    return;
    NSLog(@"Check UnReachable Code");
}

// --Check Unused Labels
- (void)testUnuseLabels {
    //goto myLabel1;
    NSLog(@"I won't print");
    myLabel1:
    NSLog(@"I will print");
}

//Unused Parameters
- (void)testUnused_Parameters:(int)arg1 {
    NSLog(@"%s",__FUNCTION__);
}

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








@end
