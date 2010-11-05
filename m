From: Shinnosuke Yagi <yagi.shinnosuke-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Subject: Re: Source code of SMB2 Kernel module
Date: Fri, 05 Nov 2010 10:13:11 +0900
Message-ID: <4CD35A27.4050605@nttcom.co.jp>
References: <4CC65859.7040100@nttcom.co.jp> <4CC6642F.2040401@suse.de> <4CCA6FD3.4060907@nttcom.co.jp> <4CCA7177.40303@suse.de> <4CCF5DF8.9030809@nttcom.co.jp> <4CD12521.2020708@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CD12521.2020708-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thank you, Suresh.


> I'm assuming you are using the recent cifs-utils package which supports
> smb2.

Sorry, I didn't use newest one.
So, I updated cifs-util to version 4.7

===================================================
# mount.cifs -V
mount.cifs version: 4.7
# mount.smb2 -V
mount.cifs version: 4.7
===================================================

 > From where did you get mount.smb2? Is it a symlink to mount.cifs by 
any chance?
Yes, it is. I made symbolic link to mount.cifs manually.

===================================================
# ls -l /sbin/mount.smb2
lrwxrwxrwx 1 root root 10 2010-10-18 10:23 /sbin/mount.smb2 -> mount.cifs*
===================================================



 > Could you try
 >
 > mount -t smb2 //server/share /mnt/point -o user=user1

I tried and got another error.
Error massage is follow.
===================================================
# mount -t smb2 //server/share /mnt/point -o user=xxxx,pass=yyyy
mount error: smb2 filesystem not supported by the system
mount error(19): No such device
Refer to the mount.smb2(8) manual page (e.g. man mount.smb2)
===================================================

I didn't got this message before I updated to cifs-util 4.7

I think this means that Kernel of my box is not support SMB2,
is it right?

I built my kernel from
git.kernel.org/pub/scm/linux/kernel/git/sfrench/smb2.git

Kernel parametrs about SMB2 are
===================================================
# grep SMB2 .config
CONFIG_SMB2_FS=y
CONFIG_SMB2_STATS=y
CONFIG_SMB2_STATS2=y
CONFIG_SMB2_DEBUG2=y
===================================================

Should I set any other parameters ?



Thanks.

-- 
Shinnosuke Yagi
