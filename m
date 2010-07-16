From: Dave Kleikamp <shaggy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 10/15] fs: cifs: check kmalloc() result
Date: Fri, 16 Jul 2010 11:35:30 -0500
Message-ID: <1279298130.26876.12.camel@shaggy-w500>
References: <1279296925-25147-1-git-send-email-segooon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Content-Transfer-Encoding: 7bit
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kulikov Vasiliy <segooon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1279296925-25147-1-git-send-email-segooon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 2010-07-16 at 20:15 +0400, Kulikov Vasiliy wrote:
> If kmalloc() fails exit with -ENOMEM.

Looks good to me.  Add my ack if you want it.

> Signed-off-by: Kulikov Vasiliy <segooon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Acked-by: Dave Kleikamp <shaggy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

> ---
>  fs/cifs/readdir.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index daf1753..d5e591f 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -847,6 +847,11 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
>  		end_of_smb = cifsFile->srch_inf.ntwrk_buf_start + max_len;
> 
>  		tmp_buf = kmalloc(UNICODE_NAME_MAX, GFP_KERNEL);
> +		if (tmp_buf == NULL) {
> +			rc = -ENOMEM;
> +			break;
> +		}
> +
>  		for (i = 0; (i < num_to_fill) && (rc == 0); i++) {
>  			if (current_entry == NULL) {
>  				/* evaluate whether this case is an error */

-- 
Dave Kleikamp
IBM Linux Technology Center
