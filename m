From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] manpage: document new rsize= behavior
Date: Thu, 3 Nov 2011 13:54:27 -0400
Message-ID: <20111103135427.24d8d2df@barsoom.rdu.redhat.com>
References: <1315922939-19672-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1315922939-19672-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 13 Sep 2011 10:08:59 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> With the addition of async readpages in 3.2 kernels, the behavior of
> the rsize= option has changed.
> 
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  mount.cifs.8 |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mount.cifs.8 b/mount.cifs.8
> index 64a8b64..ff505e1 100644
> --- a/mount.cifs.8
> +++ b/mount.cifs.8
> @@ -414,9 +414,9 @@ nouser_xattr
>  (default) Do not allow getfattr/setfattr to get/set xattrs, even if server would support it otherwise\&.
>  .RE
>  .PP
> -rsize=\fIarg\fR
> +rsize=\fIbytes\fR
>  .RS 4
> -default network read size (usually 16K)\&. The client currently can not use rsize larger than CIFSMaxBufSize\&. CIFSMaxBufSize defaults to 16K and may be changed (from 8K to the maximum kmalloc size allowed by your kernel) at module install time for cifs\&.ko\&. Setting CIFSMaxBufSize to a very large value will cause cifs to use more memory and may reduce performance in some cases\&. To use rsize greater than 127K (the original cifs protocol maximum) also requires that the server support a new Unix Capability flag (for very large read) which some newer servers (e\&.g\&. Samba 3\&.0\&.26 or later) do\&. rsize can be set from a minimum of 2048 to a maximum of 130048 (127K or CIFSMaxBufSize, whichever is smaller)
> +Maximum amount of data that the kernel will request in a read request in bytes. Prior to kernel 3.2.0, the default was 16k, and the maximum size was limited by the CIFSMaxBufSize module parameter. As of kernel 3.2.0, the behavior varies according to whether POSIX extensions are enabled on the mount and the server supports large POSIX reads. If they are, then the default is 1M, and the maxmimum is 16M. If they are not supported by the server, then the default is 60k and the maximum is around 127k. The reason for the 60k is because it's the maximum size read that windows servers can fill. Note that this value is a maximum, and the client may settle on a smaller size to accomodate what the server supports. In kernels prior to 3.2.0, no negotiation is performed.
>  .RE
>  .PP
>  wsize=\fIbytes\fR
> -- 
> 1.7.6
> 

Committed.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
