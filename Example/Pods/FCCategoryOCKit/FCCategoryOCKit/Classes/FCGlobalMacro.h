//
//  FCGlobalMacro.h
//  FCCategoryOCKit
//
//  Created by 石富才 on 2021/3/17.
//

#ifndef FCGlobalMacro_h
#define FCGlobalMacro_h

#define FCStaticInline  static inline
#define FCCategoryOCKitUnavailable( DESCRIPTION ) __attribute__((unavailable(DESCRIPTION)))

#define FCPropStatementAddPropSetFuncStatement(propertyModifier, className, propertyPointerType, propertyName)              \
@property(nonatomic, propertyModifier)propertyPointerType propertyName;                                                     \
- (className * (^)(propertyPointerType propertyName))propertyName##Set;

#define FCPropSetFuncImplementation(className, propertyPointerType, propertyName)                                           \
- (className *(^)(propertyPointerType propertyName))propertyName##Set{                                                      \
    return ^(propertyPointerType propertyName){                                                                             \
        self->_##propertyName = propertyName;                                                                             \
        return self;                                                                                                        \
    };                                                                                                                      \
}


#endif /* FCGlobalMacro_h */
