From: Pavel Shilovsky <piastry@etersoft.ru>
Subject: Re: [PATCH] cifs: fix compiler warning about incompatible pointer
 type (try #3)
Date: Mon, 31 Jan 2011 15:52:10 +0300
Message-ID: <AANLkTin6-BkS23c-Bpa3e7gVdZSBzwD-XtRRkZN3WBSQ@mail.gmail.com>
References: <4D4693CF.9090903@suse.de>
	<1296475779-19357-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs@vger.kernel.org, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jeff Layton <jlayton@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Steve French <smfrench@gmail.com>,
	Suresh Jayaraman <sjayaraman@suse.de>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1296475779-19357-1-git-send-email-piastry@etersoft.ru>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

2011/1/31 Pavel Shilovsky <piastry@etersoft.ru>:
> fs/cifs/file.c: In function =91cifs_iovec_write=92:
> fs/cifs/file.c:1740:9: warning: passing argument 6 of =91CIFSSMBWrite=
2=92 from incompatible pointer type
> fs/cifs/cifsproto.h:343:12: note: expected =91unsigned int *=92 but a=
rgument is of type =91size_t *=92
>
> Signed-off-by: Suresh Jayaraman <sjayaraman@suse.de>
> Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
> ---
> =A0fs/cifs/file.c | =A0 10 ++++++----
> =A01 files changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 0de17c1..d8338e7 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1667,9 +1667,10 @@ static ssize_t
> =A0cifs_iovec_write(struct file *file, const struct iovec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long nr_segs, loff_t *poffse=
t)
> =A0{
> - =A0 =A0 =A0 size_t total_written =3D 0, written =3D 0;
> - =A0 =A0 =A0 unsigned long num_pages, npages;
> - =A0 =A0 =A0 size_t copied, len, cur_len, i;
> + =A0 =A0 =A0 unsigned int written;
> + =A0 =A0 =A0 ssize_t total_written =3D 0;
> + =A0 =A0 =A0 unsigned long num_pages, npages, i;
> + =A0 =A0 =A0 size_t copied, len, cur_len;
> =A0 =A0 =A0 =A0struct kvec *to_send;
> =A0 =A0 =A0 =A0struct page **pages;
> =A0 =A0 =A0 =A0struct iov_iter it;
> @@ -1825,7 +1826,8 @@ cifs_iovec_read(struct file *file, const struct=
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

Let's drop this one according to [PATCH] cifs: clean up some compiler
warnings patch.

--=20
Best regards,
Pavel Shilovsky.
