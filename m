From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix wrong length in cifs_iovec_read
Date: Wed, 20 Jul 2011 16:34:56 -0400
Message-ID: <20110720163456.5bfaecfa@tlielax.poochiereds.net>
References: <1311171849-5550-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1311171849-5550-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 20 Jul 2011 18:24:09 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/file.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index bb71471..a9b4a24 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1737,7 +1737,7 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
>  			io_parms.pid = pid;
>  			io_parms.tcon = pTcon;
>  			io_parms.offset = *poffset;
> -			io_parms.length = len;
> +			io_parms.length = cur_len;
>  			rc = CIFSSMBRead(xid, &io_parms, &bytes_read,
>  					 &read_data, &buf_type);
>  			pSMBr = (struct smb_com_read_rsp *)read_data;


Looks correct...

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
