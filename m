From: Shinnosuke Yagi <yagi.shinnosuke-o7dWnD6vFTHqq2nvvmkE/A@public.gmane.org>
Subject: Re: Source code of SMB2 Kernel module
Date: Mon, 08 Nov 2010 11:58:25 +0900
Message-ID: <4CD76751.8010700@nttcom.co.jp>
References: <4CC65859.7040100@nttcom.co.jp>	<4CC6642F.2040401@suse.de>	<4CCA6FD3.4060907@nttcom.co.jp>	<4CCA7177.40303@suse.de>	<4CCF5DF8.9030809@nttcom.co.jp>	<4CD12521.2020708@suse.de>	<4CD35A27.4050605@nttcom.co.jp> <AANLkTinm718oZX2Qc4++W_CYkv0+RZRwr09Uzu4zcDn0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinm718oZX2Qc4++W_CYkv0+RZRwr09Uzu4zcDn0-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


>
> try a modprobe smb2 or insmod smb2.ko
>

I tried, but nothing changed.

=================================================================
# modprobe -v smb2
insmod /lib/modules/2.6.36-rc4+/kernel/fs/smb2/smb2.ko
# mount -t smb2 //server/share /mnt/point -o user=xxxx
Password:
mount error: smb2 filesystem not supported by the system
mount error(19): No such device
Refer to the mount.smb2(8) manual page (e.g. man mount.smb2)
typescript (END)
=================================================================

I got the same result when I tried with kernel bulit-in parameters
( CONFIG_SMB2_FS=y ).

Do I have to install other modules?


Kernel and cifs-util versions are follow.
=================================================================
$ uname -a
Linux hostname 2.6.36-rc4+ #5 SMP Fri Nov 5 11:25:48 JST 2010 i686 GNU/Linux
# mount.smb2 -V
mount.cifs version: 4.7
# grep -i smb2 /boot/config-2.6.36-rc4+
CONFIG_SMB2_FS=m
CONFIG_SMB2_STATS=y
CONFIG_SMB2_STATS2=y
CONFIG_SMB2_DEBUG2=y
=================================================================




----
Yagi Shinnosuke
