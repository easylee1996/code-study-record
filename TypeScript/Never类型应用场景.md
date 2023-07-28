```typescript
type Type = boolean | string | number

function checkType(type: Type) {
  if (typeof type === 'boolean') {
    return 'boolean'
  } else if (typeof type === 'string') {
    return 'string'
  } else {
    const neverOver: never = type // 报错：不能将number赋值给never类型的值
  }
}
```

在上面的示例中，最开始Type只有boolean和string两个类型，方法中对这两个类型进行了判断，后期有人添加了一个number类型，但是方法中没有添加对应的逻辑进行类型保护，那么就会执行到`const neverOver: never = type`，由于never不允许赋值number类型，所以会报错

所以`never`的主要应用场景就是用于保护联合类型时，添加了类型但是没有添加对应的类型保护代码