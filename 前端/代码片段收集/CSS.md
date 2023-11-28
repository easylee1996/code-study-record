### 文字超出滚动效果

```css
@keyframes rowup {
  0% {
    -webkit-transform: translate3d(0, 0px, 0);
    transform: translate3d(0, 0px, 0);
  }
  100% {
    -webkit-transform: translate3d(-105%, 0px, 0);
    transform: translate3d(-105%, 0px, 0);
  }
}

.to-roll {
  -webkit-animation: 10s rowup linear infinite normal;
  animation: 10s rowup linear infinite normal;
  position: relative;
  white-space: nowrap;
  width: auto;
}
```

```vue
<div class="trainModel">
   <div :class="child.trainModel.length > 10 ? 'to-roll' : ''">{{ child.trainModel }}</div>
</div>
```

只需要给具体需要滚动的文字内容添加上滚动css即可，注意必须是div，span不是块，无法滚动