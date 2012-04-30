From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch v2] cifs: fix revalidation test in cifs_llseek()
Date: Mon, 30 Apr 2012 11:15:14 -0400
Message-ID: <20120430111514.72b54efa@corrin.poochiereds.net>
References: <20120419210619.GA19074@elgon.mountain>
	<CAKywueQrrHdqXXrHQbP=vjs_MLjksvR09cpax0iWw-PS6ms=fg@mail.gmail.com>
	<20120430143621.GK6447@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	Josef Bacik <josef-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120430143621.GK6447@mwanda>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 30 Apr 2012 17:36:21 +0300
Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> This test is always true so it means we revalidate the length every
> time, which generates more network traffic.  When it is SEEK_SET or
> SEEK_CUR, then we don't need to revalidate.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> v2:  I had the test reversed in the first version.
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 811245b..4a6ad20 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -699,7 +699,7 @@ static loff_t cifs_llseek(struct file *file, loff_t offset, int origin)
>  	 * origin == SEEK_END || SEEK_DATA || SEEK_HOLE => we must revalidate
>  	 * the cached file length
>  	 */
> -	if (origin != SEEK_SET || origin != SEEK_CUR) {
> +	if (origin != SEEK_SET && origin != SEEK_CUR) {
>  		int rc;
>  		struct inode *inode = file->f_path.dentry->d_inode;
>  

Looks good.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
