From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: Reopen the file if reconnect durable handle failed
Date: Thu, 11 Jul 2013 16:50:40 +0400
Message-ID: <CAKywueTeG1EN4h7SG+Yi85X1aYdt0555OOr3Z+9naHWN874f+Q@mail.gmail.com>
References: <1373450401-4135-9-git-send-email-pshilovsky@samba.org>
	<1373546829-4925-1-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373546829-4925-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2013/7/11 Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/file.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 2cd4a7c..b149ae4 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -681,6 +681,13 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
>          * not dirty locally we could do this.
>          */
>         rc = server->ops->open(xid, &oparms, &oplock, NULL);
> +       if (rc == -ENOENT && oparms.reconnect == false) {
> +               /* durable handle timeout is expired - open the file again */
> +               rc = server->ops->open(xid, &oparms, &oplock, NULL);
> +               /* indicate that we need to relock the file */
> +               oparms.reconnect = true;
> +       }
> +
>         if (rc) {
>                 mutex_unlock(&cfile->fh_mutex);
>                 cifs_dbg(FYI, "cifs_reopen returned 0x%x\n", rc);
> @@ -1509,7 +1516,6 @@ cifs_setlk(struct file *file, struct file_lock *flock, __u32 type,
>                 if (!rc)
>                         goto out;
>
> -
>                 /*
>                  * Windows 7 server can delay breaking lease from read to None
>                  * if we set a byte-range lock on a file - break it explicitly
> --
> 1.7.10.4
>

This is a follow-on patch for 8/8 patch from the durable handles
series and it should be merged into that patch. It fixes the problem
when durable file handle timeout expired on the server and reopen
returns -ENOENT for such files.

--
Best regards,
Pavel Shilovsky.
