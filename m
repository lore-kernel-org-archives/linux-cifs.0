From: Konstantinos Skarlatos <k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs: ls of mount point gives input/output error (probably related
 to CIFS: getdents() broken for large dirs)
Date: Thu, 29 Dec 2011 12:30:18 +0200
Message-ID: <4EFC413A.80302@gmail.com>
References: <4EFBAF99.3010208@gmail.com> <20111228210420.2a422d11@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111228210420.2a422d11-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 29/12/2011 4:04 =CF=80=CE=BC, Jeff Layton wrote:
> On Thu, 29 Dec 2011 02:08:57 +0200
> Konstantinos Skarlatos<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>  wrote:
>
>> I mount via cifs a windows XP share, df gives me correct sizes, but =
when
>> I ls the mount point i get input/output error.
>> strace: http://pastebin.com/WXf8M1nu
>>
>> mount --verbose -t cifs -o username=3Dadministrator,password=3Dblahb=
lah
>> //192.168.0.11/jobs /mnt/backups/montaz/jobs
>> mount.cifs kernel mount options:
>> ip=3D192.168.0.11,unc=3D\\192.168.0.11\jobs,,ver=3D1,user=3Dadminist=
rator,pass=3D********
>>
>> df
>> //192.168.0.11/jobs                                       114464
>> 105196      9268  92% /mnt/backups/montaz/jobs
>>
>> ls /mnt/backups/montaz/jobs/
>> ls: reading directory /mnt/backups/montaz/jobs/: Input/output error
>> total 0
>>
>> the fun thing is that i can cd to a lower level directory, and ls wo=
rks
>> fine there! only the mount point has the problem
>>
>> ls /mnt/backups/montaz/jobs/test
>> total 44K
>> drwxr-xr-x 1 root root    0 Apr 30  2010 blah blah/
>> ......
>>
>> kernel version 3.2rc7
>>
>> this seems to be related to :
>> https://lkml.org/lkml/2011/8/1/427
>> Re: [3.0.0+][Regression][Bisected] CIFS: getdents() broken for large=
 dirs
>>
> Hmmm, maybe. What makes you think that it's related? What sort of
> server are you seeing this against?
Windows XP service pack 2 (greek)
>
> What would be most helpful is a capture and/or some cifsFYI info.
> Instructions on how to capture that are here:
>
> http://wiki.samba.org/index.php/LinuxCIFS_troubleshooting
>
> Would you be able to provide those?
http://pastebin.com/XR9H5Kzj
>
> Thanks,
