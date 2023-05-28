## JavaScript

插件：VS Code JavaScript (ES6) snippets

### Supported languages (file extensions)

- JavaScript (.js)
- TypeScript (.ts)
- JavaScript React (.jsx)
- TypeScript React (.tsx)
- Html (.html)
- Vue (.vue)

### Snippets

Below is a list of all available snippets and the triggers of each one. The **⇥** means the `TAB` key.

### Import and export

| Trigger | Content                                                      |
| ------- | ------------------------------------------------------------ |
| `imp→`  | imports entire module `import fs from 'fs';`                 |
| `imn→`  | imports entire module without module name `import 'animate.css'` |
| `imd→`  | imports only a portion of the module using destructing `import {rename} from 'fs';` |
| `ime→`  | imports everything as alias from the module `import * as localAlias from 'fs';` |
| `ima→`  | imports only a portion of the module as alias `import { rename  as localRename } from 'fs';` |
| `rqr→`  | require package `require('');`                               |
| `req→`  | require package to const `const packageName = require('packageName');` |
| `mde→`  | default module.exports `module.exports = {};`                |
| `env→`  | exports name variable `export const nameVariable = localVariable;` |
| `enf→`  | exports name function `export const log = (parameter) => { console.log(parameter);};` |
| `edf→`  | exports default function `export default function fileName (parameter){ console.log(parameter);};` |
| `ecl→`  | exports default class `export default class Calculator { };` |
| `ece→`  | exports default class by extending a base one `export default class Calculator extends BaseClass { };` |

### Class helpers

| Trigger | Content                                                      |
| ------- | ------------------------------------------------------------ |
| `con→`  | adds default constructor in the class `constructor() {}`     |
| `met→`  | creates a method inside a class `add() {}`                   |
| `pge→`  | creates a getter property `get propertyName() {return value;}` |
| `pse→`  | creates a setter property `set propertyName(value) {}`       |

### Various methods

| Trigger  | Content                                                      |
| -------- | ------------------------------------------------------------ |
| `fre→`   | forEach loop in ES6 syntax `array.forEach(currentItem => {})` |
| `fof→`   | for ... of loop `for(const item of object) {}`               |
| `fin→`   | for ... in loop `for(const item in object) {}`               |
| `anfn→`  | creates an anonymous function `(params) => {}`               |
| `nfn→`   | creates a named function `const add = (params) => {}`        |
| `dob→`   | destructing object syntax `const {rename} = fs`              |
| `dar→`   | destructing array syntax `const [first, second] = [1,2]`     |
| `sti→`   | set interval helper method `setInterval(() => {});`          |
| `sto→`   | set timeout helper method `setTimeout(() => {});`            |
| `prom→`  | creates a new Promise `return new Promise((resolve, reject) => {});` |
| `thenc→` | adds then and catch declaration to a promise `.then((res) => {}).catch((err) => {});` |

### Console methods

| Trigger | Content                                                      |
| ------- | ------------------------------------------------------------ |
| `cas→`  | console alert method `console.assert(expression, object)`    |
| `ccl→`  | console clear `console.clear()`                              |
| `cco→`  | console count `console.count(label)`                         |
| `cdb→`  | console debug `console.debug(object)`                        |
| `cdi→`  | console dir `console.dir`                                    |
| `cer→`  | console error `console.error(object)`                        |
| `cgr→`  | console group `console.group(label)`                         |
| `cge→`  | console groupEnd `console.groupEnd()`                        |
| `clg→`  | console log `console.log(object)`                            |
| `clo→`  | console log object with name `console.log('object :>> ', object);` |
| `ctr→`  | console trace `console.trace(object)`                        |
| `cwa→`  | console warn `console.warn`                                  |
| `cin→`  | console info `console.info`                                  |
| `clt→`  | console table `console.table`                                |
| `cti→`  | console time `console.time`                                  |
| `cte→`  | console timeEnd `console.timeEnd`                            |

## VUE

插件： Vue VSCode Snippets

### Installation

*Either*

- click the extensions button (lowest square icon in the editor), and type in Vue VSCode Snippets, select the one by sdras

*or*

- go here [vscode Extensions Marketplace](https://marketplace.visualstudio.com/items?itemName=sdras.vue-vscode-snippets)

```
ext install Vue VSCode Snippets
```

You can enable tab completion (recommended) by opening `Code > Preferences > Settings` (on a Mac) and applying `"editor.tabCompletion": "onlySnippets"` to your personal settings

### Snippets

### Vue

| Snippet            | Purpose                                                      |
| ------------------ | ------------------------------------------------------------ |
| `vbase`            | Single file component base with SCSS                         |
| `vbase-3`          | Single File component Composition API with SCSS              |
| `vbase-3-setup`    | Single File component setup Composition API with SCSS        |
| `vbase-3-reactive` | Single File component Composition API with Reactive and SCSS |
| `vbase-css`        | Single file component base with CSS                          |
| `vbase-pcss`       | Single file component base with PostCSS                      |
| `vbase-styl`       | Single file component base with Stylus                       |
| `vbase-ts`         | Single file component base with Typescript                   |
| `vbase-ts-class`   | Single file component base with Typescript Class Format      |
| `vbase-3-ts`       | Single File component Composition API with Typescript        |
| `vbase-3-ts-setup` | Single File component setup Composition API with Typescript  |
| `vbase-ns`         | Single file component with no styles                         |
| `vbase-sass`       | Single file component base with SASS                         |
| `vbase-less`       | Single file component base with LESS                         |

### Template

| Snippet           | Purpose                             |
| ----------------- | ----------------------------------- |
| `vfor`            | v-for directive                     |
| `vmodel`          | Semantic v-model directive          |
| `vmodel-num`      | Semantic v-model number directive   |
| `von`             | v-on click handler with arguments   |
| `vslot-named`     | Named slot                          |
| `vel-props`       | Component element with props        |
| `vsrc`            | Image src binding                   |
| `vstyle`          | Inline style binding                |
| `vstyle-obj`      | Inline style binding with objects   |
| `vclass`          | Class binding                       |
| `vclass-obj`      | Class binding with objects          |
| `vclass-obj-mult` | Multiple conditional class bindings |
| `vanim`           | Transition component with JS hooks  |
| `vnuxtl`          | Nuxt Routing Link                   |
| `vroutename`      | router-link Named Routing           |
| `vroutenameparam` | router-link Named with Parameters   |
| `vroutepath`      | router-link Path Routing Link       |
| `vemit-child`     | Emit event from child component     |
| `vemit-parent`    | Emit event to parent component      |

### Script

| Snippet           | Purpose                                                      |
| ----------------- | ------------------------------------------------------------ |
| `vdata`           | Component data as a function                                 |
| `vmethod`         | Vue method                                                   |
| `vcomputed`       | Vue computed property                                        |
| `vwatcher`        | Vue watcher with new and old value args                      |
| `vbeforecreate`   | beforeCreate lifecycle method                                |
| `vcreated`        | created lifecycle method                                     |
| `vbeforemount`    | beforeMount lifecycle method                                 |
| `vmounted`        | vmounted lifecycle method                                    |
| `vbeforeupdate`   | beforeUpdate lifecycle method                                |
| `vupdated`        | updated lifecycle method                                     |
| `vbeforedestroy`  | beforeDestroy lifecycle method                               |
| `vdestroyed`      | destroyed lifecycle method                                   |
| `vprops`          | Props with type and default                                  |
| `vimport`         | Import one component into another                            |
| `vimport-dynamic` | Import one component that should be lazy loaded by webpack   |
| `vcomponents`     | Import one component into another within the export statement |
| `vimport-export`  | Import one component into another and use it within the export statement |
| `vmapstate`       | import mapState from Vuex into vue component component       |
| `vmapgetters`     | import mapGetters from Vuex into vue component component     |
| `vmapmutations`   | import mapMutations from Vuex into vue component component   |
| `vmapactions`     | import mapActions from Vuex into vue component component     |
| `vfilter`         | Vue filter                                                   |
| `vmixin`          | Create a Vue Mixin                                           |
| `vmixin-use`      | Bring a mixin into a component to use                        |
| `vc-direct`       | Vue create a custom directive                                |
| `vimport-lib`     | Import a library                                             |
| `vimport-gsap`    | Import GreenSock                                             |
| `vanimhook-js`    | Using the Transition component JS hooks in methods           |
| `vcommit`         | Commit to Vuex store in methods for mutation                 |
| `vdispatch`       | Dispatch to Vuex store in methods for action                 |
| `vtest`           | A simple unit testing component                              |

### Vue Composition API

| Snippet             | Purpose                                               |
| ------------------- | ----------------------------------------------------- |
| `v3reactive`        | Vue Composition API - reactive                        |
| `v3reactive-setup`  | Vue Composition API - reactive with setup boilerplate |
| `v3computed`        | Vue Composition API - computed                        |
| `v3watch`           | Vue Composition API - watcher single source           |
| `v3watch-array`     | Vue Composition API - watch as array                  |
| `v3watcheffect`     | Vue Composition API - watchEffect                     |
| `v3ref`             | Vue Ref                                               |
| `v3onmounted`       | Lifecycle hook - onMounted                            |
| `v3onbeforemount`   | Lifecycle hook - onBeforeMount                        |
| `v3onbeforeupdate`  | Lifecycle hook - onBeforeUpdate                       |
| `v3onupdated`       | Lifecycle hook - onUpdated                            |
| `v3onerrorcaptured` | Lifecycle hook - onErrorCaptured                      |
| `v3onunmounted`     | Lifecycle hook - (destroyed) onUnmounted              |
| `v3onbeforeunmount` | Lifecycle hook - (beforeDestroy) onBeforeUnmount      |
| `v3useinoptions`    | Use Composition API in Options API                    |

### Vuex

| Snippet         | Purpose                        |
| --------------- | ------------------------------ |
| `vstore`        | Base for Vuex store.js         |
| `vgetter`       | Vuex Getter                    |
| `vmutation`     | Vuex Mutation                  |
| `vaction`       | Vuex Action                    |
| `vmodule`       | Vuex Module                    |
| `vstore-import` | Import vuex store into main.js |
| `vstore2`       | Updated Base for Vuex store    |

### Vue Router

| Snippet              | Purpose                                       |
| -------------------- | --------------------------------------------- |
| `vrouter`            | Vue Router base                               |
| `vscrollbehavior`    | Vue Router scrollBehavior                     |
| `vbeforeeach`        | Vue Router global guards beforeEach           |
| `vbeforeresolve`     | Vue Router global guards beforeResolve        |
| `vaftereach`         | Vue Router global guards afterEach            |
| `vbeforeenter`       | Vue Router per-route guard beforeEnter        |
| `vbeforerouteenter`  | Vue Router component guards beforeRouteEnter  |
| `vbeforerouteupdate` | Vue Router component guards beforeRouteUpdate |
| `vbeforerouteleave`  | Vue Router component guards beforeRouteLeave  |

### Vue Config

| Snippet   | Purpose                                                      |
| --------- | ------------------------------------------------------------ |
| `vplugin` | Import a plugin to main.js or plugins file                   |
| `vconfig` | vue.config.js file, example imports a sass file into every component |

### Nuxt Config

| Snippet | Purpose                                                 |
| ------- | ------------------------------------------------------- |
| `nfont` | link to include fonts in a nuxt project, in nuxt-config |
| `ncss`  | link to css assets such as normalize                    |

### Nuxt Page

| Snippet           | Purpose                          |
| ----------------- | -------------------------------- |
| `nasyncdata`      | Nuxt asyncData                   |
| `nasyncdataaxios` | Nuxt asyncData with Axios module |
| `nfetch`          | Nuxt Fetch                       |
| `nfetchaxios`     | Nuxt Fetch with Axios module     |
| `nhead`           | Nuxt Head                        |
| `nparam`          | Nuxt Route Params                |

### Extra (plaintext)

| Snippet     | Purpose                 |
| ----------- | ----------------------- |
| `gitignore` | .gitignore file presets |