### 插件模板配置
```
package editor.cn;

/**
  * 题目Id：${question.frontendQuestionId}; 
  * 题目：${question.title}，${question.titleSlug}; 
  * 日期：$!velocityTool.date()
*/

${question.content}

class P_${question.frontendQuestionId}_$!velocityTool.camelCaseName(${question.titleSlug}){
    public static void main(String[] args) {
        Solution solution = new P_${question.frontendQuestionId}_$!velocityTool.camelCaseName(${question.titleSlug})().new Solution();
        
    }

    ${question.code}
}
```
