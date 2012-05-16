From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 5/5] CIFS: Separate protocol specific part from setlk
Date: Wed, 16 May 2012 14:31:34 -0400
Message-ID: <20120516143134.7871db3f@tlielax.poochiereds.net>
References: <1337162254-13121-1-git-send-email-piastry@etersoft.ru>
	<1337162254-13121-6-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337162254-13121-6-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 16 May 2012 13:57:34 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/file.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 9c2d85d..ed9b5a8 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1357,8 +1357,8 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u32 type,
>  		if (rc <= 0)
>  			goto out;
>  
> -		rc = CIFSSMBLock(xid, tcon, netfid, current->tgid, length,
> -				 flock->fl_start, 0, 1, type, wait_flag, 0);
> +		rc = cifs_mandatory_lock(xid, cfile, flock->fl_start, length,
> +					 type, 1, 0, wait_flag);
>  		if (rc) {
>  			kfree(lock);
>  			goto out;

You can probably roll this in with patch #4 since it's a very similar
change and so small...

Looks fine though. I guess at some point you'll need to add a
ops->mandatory_lock or something?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
