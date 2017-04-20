From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs.ko + smb 3.0 + DFS fails (though direct mount succeeds)
Date: Thu, 20 Apr 2017 15:14:49 -0500
Message-ID: <CAH2r5mvn_Z5B=kYza1gAr3SkPX+kwKmXBEXcTBL327zcW8FP-g@mail.gmail.com>
References: <CAJUwKM3-U2yRHB5O-R19wmzj1-yrO3sU_b8+xVCFaFwsZRWtTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Robin Blanchard <robin.blanchard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJUwKM3-U2yRHB5O-R19wmzj1-yrO3sU_b8+xVCFaFwsZRWtTA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Fixes to add SMB2/SMB3 support for DFS were added fairly recently
(about two months ago) by Aurelien, so will be in new kernels.

Hopefully RedHat and other will backport these as they are quite useful.

On Thu, Apr 20, 2017 at 3:09 PM, Robin Blanchard
<robin.blanchard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> environment:
>
> # cat /etc/redhat-release
> CentOS Linux release 7.3.1611 (Core)
>
> # uname -r
> 3.10.0-514.16.1.el7.x86_64
>
> # modinfo cifs
> filename:       /lib/modules/3.10.0-514.16.1.el7.x86_64/kernel/fs/cifs/cifs.ko
> version:        2.08
> description:    VFS to access servers complying with the SNIA CIFS
> Specification e.g. Samba and Windows
> license:        GPL
> author:         Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> alias:          fs-cifs
> rhelversion:    7.3
> srcversion:     119ACC0FE17824C08D648CE
> depends:        dns_resolver
> intree:         Y
> vermagic:       3.10.0-514.16.1.el7.x86_64 SMP mod_unload modversions
> signer:         CentOS Linux kernel signing key
> sig_key:        3F:E1:EB:8B:4F:91:D4:84:CD:55:44:84:54:A0:24:DE:56:34:E1:06
> sig_hashalgo:   sha256
> parm:           CIFSMaxBufSize:Network buffer size (not including
> header). Default: 16384 Range: 8192 to 130048 (uint)
> parm:           cifs_min_rcv:Network buffers in pool. Default: 4
> Range: 1 to 64 (uint)
> parm:           cifs_min_small:Small network buffers in pool. Default:
> 30 Range: 2 to 256 (uint)
> parm:           cifs_max_pending:Simultaneous requests to server.
> Default: 32767 Range: 2 to 32767. (uint)
> parm:           enable_oplocks:Enable or disable oplocks. Default: y/Y/1 (bool)
>
>
>
> issue:
>
> 01) smb vers=1.0 + DFS works as expected:
>
> # mount -v -t cifs //my.domain/dfs/path /mnt -o
> "ro,vers=1.0,domain=my.domain,username=silly_user"
> # echo $?
> 0
>
>
> 02) smb vers=3.0 + DFS fails with:
>
> # echo 7 > /proc/fs/cifs/cifsFYI ; mount -v -t cifs
> //my.domain/dfs/path /mnt -o
> "ro,vers=3.0,domain=my.domain,username=silly_user"; sleep 5 ; echo 0 >
> /proc/fs/cifs/cifsFYI ; dmesg |tail -3
>
> mount error(38): Function not implemented
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
> [273116.707979] Status code returned 0xc0000016 STATUS_MORE_PROCESSING_REQUIRED
> [273116.712186] Status code returned 0xc0000257 STATUS_PATH_NOT_COVERED
> [273116.713723] CIFS VFS: cifs_mount failed w/return code = -38
>
>
> 03) smb vers=3.0 w/o CFS works as expected
>
> # mount -v -t cifs //real.win2k12.server/non-dfs/path /mnt -o
> "ro,vers=3.0,domain=my.domain,username=silly_user
> # echo $?
> 0
>
>
>
> Is there another incantation of mount -t cifs to get smbv3 + DFS
> working? Or is this a known issue (and if so, is there a work-around)
> ?
>
> Thanks in advance!
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
