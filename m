From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix variable types in cifs_iovec_read/write (try #2)
Date: Thu, 3 Feb 2011 22:00:47 +0300
Message-ID: <AANLkTi=+uqOt0bNOq3_+nTmzHC2jj0xTd7h7hFZHxnb7@mail.gmail.com>
References: <1296478988-22307-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296478988-22307-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/1/31 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> Variable 'i' should be unsigned long as it's used in circle with num_=
pages,
> and bytes_read/total_written should be ssize_t according to return va=
lue.
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/file.c | =A0 11 ++++++-----
> =A01 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 74c0a28..e964b1c 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1662,10 +1662,10 @@ static ssize_t
> =A0cifs_iovec_write(struct file *file, const struct iovec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long nr_segs, loff_t *poffse=
t)
> =A0{
> - =A0 =A0 =A0 size_t total_written =3D 0;
> - =A0 =A0 =A0 unsigned int written =3D 0;
> - =A0 =A0 =A0 unsigned long num_pages, npages;
> - =A0 =A0 =A0 size_t copied, len, cur_len, i;
> + =A0 =A0 =A0 unsigned int written;
> + =A0 =A0 =A0 unsigned long num_pages, npages, i;
> + =A0 =A0 =A0 size_t copied, len, cur_len;
> + =A0 =A0 =A0 ssize_t total_written =3D 0;
> =A0 =A0 =A0 =A0struct kvec *to_send;
> =A0 =A0 =A0 =A0struct page **pages;
> =A0 =A0 =A0 =A0struct iov_iter it;
> @@ -1821,7 +1821,8 @@ cifs_iovec_read(struct file *file, const struct=
 iovec *iov,
> =A0{
> =A0 =A0 =A0 =A0int rc;
> =A0 =A0 =A0 =A0int xid;
> - =A0 =A0 =A0 unsigned int total_read, bytes_read =3D 0;
> + =A0 =A0 =A0 ssize_t total_read;
> + =A0 =A0 =A0 unsigned int bytes_read =3D 0;
> =A0 =A0 =A0 =A0size_t len, cur_len;
> =A0 =A0 =A0 =A0int iov_offset =3D 0;
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb;
> --
> 1.7.1
>
>

What's about this?

--=20
Best regards,
Pavel Shilovsky.
