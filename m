From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Configuring CIFS mount with cifsacl - STATUS_NONE_MAPPED
Date: Mon, 24 Nov 2014 20:42:25 -0600
Message-ID: <CADT32eKWbwvuvr4mJObenG4vquuhkGX=zcjagEYnC8DzoGfZpw@mail.gmail.com>
References: <982926402.71713.1416844711273.JavaMail.zimbra@xes-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Andrew Martin <amartin-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <982926402.71713.1416844711273.JavaMail.zimbra-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Is it possible to provide a wireshark trace?  I think there may be an error
at the Samba/ZFS interaction/interface wrt to NTFS ACL.
If logging is enabled at the Samba server, is there any error logged by the
Samba server?


On Mon, Nov 24, 2014 at 9:58 AM, Andrew Martin <amartin-AQeFf1F/bRxBDgjK7y7TUQ@public.gmane.org> wrote:
> Hello,
>
> I am attempting to mount a CIFS share (SMB 1.0) onto an Ubuntu 14.04 client. I
> would like to be able to map ACLs using the "cifsacl" mount option. The server
> is an OpenIndiana server using the smb/server CIFS server (with ZFS as the
> underlying filesystem).
>
> Client Kernel Version: 3.13.0-24-generic
>
> Client mount.cifs version: 6.0
>
> I have verified that my kernel has been compiled with CIFS_XATTR and CIFS_ACL:
> $ grep CIFS /boot/config-3.13.0-24-generic
> CONFIG_CIFS=m
> CONFIG_CIFS_STATS=y
> # CONFIG_CIFS_STATS2 is not set
> CONFIG_CIFS_WEAK_PW_HASH=y
> CONFIG_CIFS_UPCALL=y
> CONFIG_CIFS_XATTR=y
> CONFIG_CIFS_POSIX=y
> CONFIG_CIFS_ACL=y
> CONFIG_CIFS_DEBUG=y
> # CONFIG_CIFS_DEBUG2 is not set
> CONFIG_CIFS_DFS_UPCALL=y
> CONFIG_CIFS_SMB2=y
> CONFIG_CIFS_FSCACHE=y
>
> I have already configured winbind (getent passwd works and I verified that
> cifs.idmap is set up in /etc/request-key.d/cifs.idmap.conf. I am able to mount
> the share successfully, however when I attempt to list the contents of a
> directory, I receive output like this:
> ls: cannot access /mnt/Test/one: Input/output error
> ls: cannot access /mnt/Test/two: Input/output error
> ls: cannot access /mnt/Test/three: Input/output error
> total 0
> d????????? ? ?       ?            ?            ? one
> d????????? ? ?       ?            ?            ? two
> d????????? ? ?       ?            ?            ? three
>
> Here are the ACLs I have set on these directories:
> A:d:OWNER@:rwaDdxtTnNcCoy
> A:fi:OWNER@:rwaDdtTnNcCoy
> A:dg:Domain Users-J0of1frlU80@public.gmane.org:rwaDdxtTnNcCoy
> A:fig:Domain Users-J0of1frlU80@public.gmane.org:rwaDdtTnNcCoy
> A:dg:GROUP@:rxtncy
> A:fig:GROUP@:rtncy
> D:d:EVERYONE@:rwaDxtTcCy
>
> Errors in dmesg:
> [Fri Nov 21 18:57:03 2014] CIFS VFS: cifs_acl_to_fattr: error -5 getting sec desc
> [Fri Nov 21 18:57:03 2014] CIFS VFS: cifs_acl_to_fattr: error -13 getting sec desc
> [Fri Nov 21 18:57:03 2014] CIFS VFS: cifs_acl_to_fattr: error -5 getting sec desc
>
> I also grabbed the contents /f proc/fs/cifs/DebugData:
> $ cat /proc/fs/cifs/DebugData
> Display Internal CIFS Data Structures for Debugging
> ---------------------------------------------------
> CIFS Version 2.02
> Features: dfs fscache lanman posix spnego xattr acl
> Active VFS Requests: 0
> Servers:
> 1) Name: 192.168.0.33  Domain: TEST Uses: 1 OS: Windows 2000
>         NOS: Windows 2000 LAN Manager        Capability: 0xf3fc
>         SMB session status: 1        TCP status: 1
>         Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
>         Shares:
>         1) \\test\Test Mounts: 1 Type: ZFS DevInfo: 0x20 Attributes: 0x4006e
>         PathComponentMax: 256 Status: 0x1 type: 9
>
>         MIDs:
>
>
> I then enabled /proc/fs/cifs/cifsFYI and captured this sample debug:
> http://pastebin.com/Xy23ws7m
>
> I see the error is NT_STATUS_NONE_MAPPED, but it is unclear why this is
> failing. What else can I try to debug this CIFS mount?
>
> Thanks,
>
> Andrew Martin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
