From: Shinnosuke Yagi <yagi.shinnosuke-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Subject: Source code of SMB2 Kernel module
Date: Tue, 26 Oct 2010 13:26:01 +0900
Message-ID: <4CC65859.7040100@nttcom.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Dear.

Now, I try to use mount.smb2, which was posted at
http://archives.free.net.ph/message/20100507.172615.fda263bc.en.html

However, mount.smb2 was failed with error message.

 mount error: smb2 filesystem not supported by the system

So, I need a source code of smb2 kernel module.
(Test or experimental branch will do, because I know smb2
 is not in mainline kernels.)

I tried to do
"git clone
http://www.kernel.org/home/ftp/pub/scm/linux/kernel/git/sfrench/smb2.git"
to find it failed.

Are there another git repository (or any patch) ?


Thanks.

-- 
-------------------------------------
Shinnosuke Yagi
