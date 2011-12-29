From: Konstantinos Skarlatos <k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cifs: ls of mount point gives input/output error (probably related
 to CIFS: getdents() broken for large dirs)
Date: Thu, 29 Dec 2011 02:08:57 +0200
Message-ID: <4EFBAF99.3010208@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I mount via cifs a windows XP share, df gives me correct sizes, but when 
I ls the mount point i get input/output error.
strace: http://pastebin.com/WXf8M1nu

mount --verbose -t cifs -o username=administrator,password=blahblah 
//192.168.0.11/jobs /mnt/backups/montaz/jobs
mount.cifs kernel mount options: 
ip=192.168.0.11,unc=\\192.168.0.11\jobs,,ver=1,user=administrator,pass=********

df
//192.168.0.11/jobs                                       114464  
105196      9268  92% /mnt/backups/montaz/jobs

ls /mnt/backups/montaz/jobs/
ls: reading directory /mnt/backups/montaz/jobs/: Input/output error
total 0

the fun thing is that i can cd to a lower level directory, and ls works 
fine there! only the mount point has the problem

ls /mnt/backups/montaz/jobs/test
total 44K
drwxr-xr-x 1 root root    0 Apr 30  2010 blah blah/
......

kernel version 3.2rc7

this seems to be related to :
https://lkml.org/lkml/2011/8/1/427
Re: [3.0.0+][Regression][Bisected] CIFS: getdents() broken for large dirs

Please CC because i am not subscribed
