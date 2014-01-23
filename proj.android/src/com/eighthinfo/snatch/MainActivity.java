/****************************************************************************
Copyright (c) 2010-2012 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package com.eighthinfo.snatch;

import java.util.HashMap;
import java.util.Map;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxLuaJavaBridge;

import android.os.Bundle;
import android.util.Log;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.onekeyshare.OnekeyShare;

public class MainActivity extends Cocos2dxActivity {

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		ShareSDK.initSDK(this);
	}
	
    @Override
	protected void onDestroy() {
		super.onDestroy();
		ShareSDK.stopSDK(this);
	}

    public static void showSharePanel(String awardName,final int luaFunction){
    	OnekeyShare oks = new OnekeyShare();

    	// 分享时Notification的图标和文字
    	oks.setNotification(R.drawable.ic_launcher, 
    	getContext().getString(R.string.app_name));
    	// title标题，印象笔记、邮箱、信息、微信、人人网和QQ空间使用
    	oks.setTitle(getContext().getString(R.string.share));
    	// titleUrl是标题的网络链接，仅在人人网和QQ空间使用
    	oks.setTitleUrl("http://sharesdk.cn");
    	// text是分享文本，所有平台都需要这个字段
    	oks.setText(getContext().getString(R.string.share_content) + awardName);
    	// imagePath是图片的本地路径，Linked-In以外的平台都支持此参数
//    	oks.setImagePath(MainActivity.TEST_IMAGE);
    	// imageUrl是图片的网络路径，新浪微博、人人网、QQ空间、
    	// 微信的两个平台、Linked-In支持此字段
//    	oks.setImageUrl("http://img.appgo.cn/imgs/sharesdk/content/2013/07/25/1374723172663.jpg");
    	// url仅在微信（包括好友和朋友圈）中使用
    	oks.setUrl("http://sharesdk.cn");
    	// appPath是待分享应用程序的本地路劲，仅在微信中使用
//    	oks.setAppPath(MainActivity.TEST_IMAGE);
    	// 去除注释可通过OneKeyShareCallback来捕获快捷分享的处理结果
    	 oks.setCallback(new PlatformActionListener(){

			@Override
			public void onCancel(Platform arg0, int arg1) {
				// TODO Auto-generated method stub
				Log.i("MainActivity", "onCancel");
			}

			@Override
			public void onComplete(Platform arg0, int arg1,
					HashMap<String, Object> arg2) {
				//TODO call lua function
				Log.i("MainActivity", "onComplete");
				Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFunction, "onComplete");
			}

			@Override
			public void onError(Platform platform, int arg1, Throwable e) {
				// TODO Auto-generated method stub
				Log.e("MainActivity", "onError",e);
				Cocos2dxLuaJavaBridge.callLuaFunctionWithString(luaFunction, "onError");
			}
    		 
    	 });
    	//通过OneKeyShareCallback来修改不同平台分享的内容
//    	oks.setShareContentCustomizeCallback(
//    	new ShareContentCustomizeDemo());

    	oks.show(getContext());
    }
    

	static {
    	System.loadLibrary("game");
    }
}
