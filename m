From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: linux-next: build warning after merge of the cifs tree
Date: Mon, 31 Jan 2011 14:38:52 +0300
Message-ID: <AANLkTikcAEdFLwhcGC8uqRQAYVCCzR4Bz06Qr5ZdvyLd@mail.gmail.com>
References: <20110131133038.ab3aa826.sfr@canb.auug.org.au>
	<4D4693CF.9090903@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D4693CF.9090903-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/1/31 Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>:
> On 01/31/2011 08:00 AM, Stephen Rothwell wrote:
>> Hi all,
>>
>> After merging the cifs tree, today's linux-next build (powerpc
>> ppc64_defconfig) produced this warning:
>>
>> fs/cifs/file.c: In function 'cifs_iovec_write':
>> fs/cifs/file.c:1740: warning: passing argument 6 of 'CIFSSMBWrite2' =
from incompatible pointer type
>> fs/cifs/cifsproto.h:343: note: expected 'unsigned int *' but argumen=
t is of type 'size_t *'
>>
>> Introduced by commit 72432ffcf555decbbae47f1be338e1d2f210aa69 ("CIFS=
:
>> Implement cifs_strict_writev (try #4)").
>>
>
> The following patch should silence that warning.
>
> From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> Subject: [PATCH] cifs: fix compiler warning about incompatible pointe=
r type
>
> fs/cifs/file.c: In function =91cifs_iovec_write=92:
> fs/cifs/file.c:1740:9: warning: passing argument 6 of =91CIFSSMBWrite=
2=92 from incompatible pointer type
> fs/cifs/cifsproto.h:343:12: note: expected =91unsigned int *=92 but a=
rgument is of type =91size_t *=92
>
> Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
> =A0fs/cifs/file.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 0de17c1..2a3c5d8 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1667,7 +1667,7 @@ static ssize_t
> =A0cifs_iovec_write(struct file *file, const struct iovec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long nr_segs, loff_t *poffse=
t)
> =A0{
> - =A0 =A0 =A0 size_t total_written =3D 0, written =3D 0;
> + =A0 =A0 =A0 unsigned int total_written =3D 0, written =3D 0;
> =A0 =A0 =A0 =A0unsigned long num_pages, npages;
> =A0 =A0 =A0 =A0size_t copied, len, cur_len, i;
> =A0 =A0 =A0 =A0struct kvec *to_send;
>

I've just noriced another bug: that 'i' variable should be unsigned
long. I will recreate the patch with this fix.

--=20
Best regards,
Pavel Shilovsky.
