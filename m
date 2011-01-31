From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix variable types in cifs_iovec_read/write
Date: Mon, 31 Jan 2011 16:03:40 +0300
Message-ID: <AANLkTi=XXsT8m8atYiBpSv9us-oWWnL2sbihVQciN1ax@mail.gmail.com>
References: <1296478671-22224-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296478671-22224-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

let's drop this one.

2011/1/31 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> Variable 'i' should be unsigned long as it's used in circle with num_=
pages,
> and bytes_read/total_written should be ssize_t according to return va=
lue.
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/file.c | =A0 =A09 +++++----
> =A01 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 74c0a28..1b5e01f 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1662,10 +1662,10 @@ static ssize_t
> =A0cifs_iovec_write(struct file *file, const struct iovec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long nr_segs, loff_t *poffse=
t)
> =A0{
> + =A0 =A0 =A0 unsigned int written;
> + =A0 =A0 =A0 unsigned long num_pages, npages, i;
> + =A0 =A0 =A0 size_t copied, len, cur_len;
> =A0 =A0 =A0 =A0size_t total_written =3D 0;
> - =A0 =A0 =A0 unsigned int written =3D 0;
> - =A0 =A0 =A0 unsigned long num_pages, npages;
> - =A0 =A0 =A0 size_t copied, len, cur_len, i;
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



--=20
Best regards,
Pavel Shilovsky.
