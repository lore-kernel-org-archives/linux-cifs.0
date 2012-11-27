From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/5] CIFS: Fix write after setting a read lock for read
 oplock files
Date: Tue, 27 Nov 2012 11:04:48 -0600
Message-ID: <CAH2r5mt-cQ4ppzMnhM=9T3ALE5QO4_A6t3P87n8-q=zGutuAOw@mail.gmail.com>
References: <1353999029-3975-1-git-send-email-piastry@etersoft.ru>
	<1353999029-3975-6-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353999029-3975-6-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Am curious how you noticed this problem?  Did you have a test case?

On Tue, Nov 27, 2012 at 12:50 AM, Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> If we have a read oplock and set a read lock in it, we can't write to the
> locked area - so, filemap_fdatawrite may fail with a no information for a
> userspace application even if we request a write to non-locked area. Fix
> this by replacing it with filemap_write_and_wait call and sending non-page
> write in a error case.
>
> While this may end up with two write requests to the server, we can be sure
> that our data will be the same at the server and the page cache - the next read
> on this file gets the valid data.
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/file.c |   10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index f8fe1bd..89efd85 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2511,14 +2511,12 @@ cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
>          */
>         if (!cinode->clientCanCacheAll && cinode->clientCanCacheRead) {
>                 ssize_t written;
> -               int rc;
>
>                 written = generic_file_aio_write(iocb, iov, nr_segs, pos);
> -               rc = filemap_fdatawrite(inode->i_mapping);
> -               if (rc)
> -                       return (ssize_t)rc;
> -
> -               return written;
> +               /* try page write at first */
> +               if (!filemap_write_and_wait(inode->i_mapping))
> +                       return written;
> +               /* page write failed - try from pos to pos+len-1 */
>         }
>  #endif
>
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
