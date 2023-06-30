## prettier设置

### 常见配置

pretter配置文件分为三种：

- vscode配置文件中设置：user settings.json，优先级最低
- 通过项目的prettier: 在根目录下创建`.prettierrc.js`配置文件及`.prettierignore`忽略文件
- 在项目package.json中配置

自己的项目推荐在vscode配置文件中设置，全局通用，公司项目推荐在项目下创建pretter配置文件，不推荐在package.json中创建，会影响这个文件

常用配置项目如下，三种方式略有差距，以vscode中为例：

```json
// 配置保存自动格式化
"editor.defaultFormatter": "esbenp.prettier-vscode",
"editor.formatOnSave": true,

// 常见配置
"prettier.useEditorConfig": false,	// 使用编辑器配置
"prettier.tabWidth": 4,	// tab的宽度
"prettier.printWidth": 180,	// 换行宽度
"prettier.proseWrap": "preserve",
"prettier.useTabs": false, // 使用tab代替空格格式化
"prettier.singleQuote": true, // 使用单引号
"prettier.semi": false, // 末尾不添加分号
"prettier.insertPragma": false, // 不插入分号
"prettier.trailingComma": "all", // 最后一个添加逗号
"prettier.htmlWhitespaceSensitivity": "ignore", // html文件中的空格
"prettier.bracketSameLine": false, // 括号同一行
"prettier.quoteProps": "as-needed",
"prettier.bracketSpacing": true,
"prettier.arrowParens": "avoid", // 箭头函数只有唯一参数是否添加括号always,avoid
"prettier.jsxSingleQuote": true,
```

