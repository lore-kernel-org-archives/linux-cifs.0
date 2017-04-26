From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [4.11-rc6 bug] fstests cifs/001 failure with cifs 2.0/2.1/3.0
 mounts
Date: Wed, 26 Apr 2017 17:52:50 +0100
Message-ID: <1493225570.4270.25.camel@redhat.com>
References: <20170410043431.GB22845@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
To: Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170410043431.GB22845-+7p9VZFSOIEFmhoHi+V13ACJwEvxM/w9@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Eryu,

I have identified a change in behaviour which leads to this error. I
have posted a patch which fixes this issue.

Sachin Prabhu

On Mon, 2017-04-10 at 12:34 +0800, Eryu Guan wrote:
> Hi all,
> 
> Starting from 4.11-rc6 kernel, I noticed new cifs/001 failure, I
> tested
> with a local mount linux samba server, with v2.0/2.1/3.0 cifs mounts,
> and it's always reproducible.
> 
> @@ -19,3 +19,13 @@
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>  wrote 10240/10240 bytes at offset 0
>  XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> +clone failed: No such file or directory
> +clone failed: No such file or directory
> +clone failed: No such file or directory
> +clone failed: No such file or directory
> +clone failed: No such file or directory
> +clone failed: No such file or directory
> +clone failed: No such file or directory
> +clone failed: No such file or directory
> +clone failed: No such file or directory
> +clone failed: No such file or directory
> 
> git bisect pointed the "first bad" commit to
> 
> commit 620d8745b35daaf507186c26b40c7ea02aed131e
> Author: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date:   Fri Feb 10 16:03:51 2017 +0530
> 
>     Introduce cifs_copy_file_range()
>     
>     The earlier changes to copy range for cifs unintentionally
> disabled the more
>     common form of server side copy.
>     
>     The patch introduces the file_operations helper
> cifs_copy_file_range()
>     which is used by the syscall copy_file_range. The new file
> operations
>     helper allows us to perform server side copies for SMB2.0 and 2.1
>     servers as well as SMB 3.0+ servers which do not support the
> ioctl
>     FSCTL_DUPLICATE_EXTENTS_TO_FILE.
> 
>     The new helper uses the ioctl FSCTL_SRV_COPYCHUNK_WRITE to
> perform
>     server side copies. The helper is called by vfs_copy_file_range()
> only
>     once an attempt to clone the file using the ioctl
>     FSCTL_DUPLICATE_EXTENTS_TO_FILE has failed.
> 
>     Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     Reviewed-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
>     CC: Stable  <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>     Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Not sure if test needs to be updated, if you need more info please
> let
> me know.
> 
> Thanks,
> Eryu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" 
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
