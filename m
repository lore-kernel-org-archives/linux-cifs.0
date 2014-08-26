From: Pavel Shilovsky <pshilovsky@samba.org>
Subject: Re: [patch] cifs: update a check for NULL function pointer
Date: Tue, 26 Aug 2014 12:21:07 +0400
Message-ID: <CAKywueS8pjGrY=SkmxSazVTYVMmnj7zrNhcPCWYgf7NNrNZnYg@mail.gmail.com>
References: <20140826073802.GA31076@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <sfrench@samba.org>,
	linux-cifs <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20140826073802.GA31076@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

2014-08-26 11:38 GMT+04:00 Dan Carpenter <dan.carpenter@oracle.com>:
> We changed the function call from ->close() to ->close_dir() so we
> should update the test for NULL as well.
>
> Both of them probably work, but my static checker complains when we have
> a check for a NULL function pointer and then immediately call a
> different function pointer.  This is a common cut and paste error.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 41e52e2..d2141f1 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -592,7 +592,7 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
>                 if (server->ops->dir_needs_close(cfile)) {
>                         cfile->invalidHandle = true;
>                         spin_unlock(&cifs_file_list_lock);
> -                       if (server->ops->close)
> +                       if (server->ops->close_dir)
>                                 server->ops->close_dir(xid, tcon, &cfile->fid);
>                 } else
>                         spin_unlock(&cifs_file_list_lock);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This looks right, thanks.

Dan, would you mind if I merge your code change as well as your
Signed-off-by line into the original patch "CIFS: Fix wrong restart
readdir for SMB1" since the latter hasn't been merged into the
mainline yet?

-- 
Best regards,
Pavel Shilovsky.
