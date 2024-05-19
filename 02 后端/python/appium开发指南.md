查看当前打开app的app包名和activity名
```shell
adb shell dumpsys activity activities | grep mResumedActivity
```