From: Niels Basjes <Niels-WkKhAqUkEt5mR6Xm/wNWPw@public.gmane.org>
Subject: Fwd: CentOS cifs client sees Windows 2012 deduplicated files as symlinks
Date: Thu, 11 Jun 2015 13:53:25 +0200
Message-ID: <CADoiZqqc1Opge73nADG=xPtzvAE2oyK5bf6w3nCZ6n8k6bcfag@mail.gmail.com>
References: <CADoiZqqHT1eh7-BvxpbSg8a5S+kLqBmBi-CXWp562BeXooVLgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADoiZqqHT1eh7-BvxpbSg8a5S+kLqBmBi-CXWp562BeXooVLgA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

Last week I ran into a serious problem from my CentOS 7 system using
the cifs client to mount a volume on a Windows 2012-R2 server.
I posted this a problem on ServerFault (
http://serverfault.com/q/697393 ) a few days ago but I thought that it
is usefull to ask here too.
I included some screenshots in the serverfault page so that may be
useful to have a look at.

The essence of my problem is that the local Windows sysadmin turned on
a feature to deduplicate files on an existing Windows server volume.
After that my Linux system started seeing all the files that were
deduplicated as symlinks to what I can only describe as 'chinese
letters'.
Under Windows 7 everything works fine.

The way I currently look at this is that what is apparently some kind
of 'copy-on-write hardlink' on the Windows server is interpreted as a
softlink by the cifs client in my CentOS system.

I have been experimenting with some mount settings but I have been
unable to fix this problem (other than turning off the deduplication).

My current (Client) setup:
- CentOS 7.0
- samba-client-4.1.1-38.el7_0.x86_64
- samba-common-4.1.1-38.el7_0.x86_64
- samba-libs-4.1.1-38.el7_0.x86_64
- cifs-utils-6.2-7.el7.x86_64

The command in my /etc/fstab

\\xxxxxxxx\file\video /var/www/html/wp-content/uploads cifs
nouser_xattr,nounix,iocharset=utf8,credentials=/etc/fstab.cifs.sa_video.credentials,_netdev,uid=apache,gid=apache,rw,auto
0 0

How do I get the Linux to see these files as files again?


-- 
Best regards / Met vriendelijke groeten,

Niels Basjes
