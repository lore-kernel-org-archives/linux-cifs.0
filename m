From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch] cifs: fix revalidation test in cifs_llseek()
Date: Fri, 27 Apr 2012 16:59:07 +0400
Message-ID: <CAKywueQrrHdqXXrHQbP=vjs_MLjksvR09cpax0iWw-PS6ms=fg@mail.gmail.com>
References: <20120419210619.GA19074@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	Josef Bacik <josef-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120419210619.GA19074-mgFCXtclrQlZLf2FXnZxJA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

20 =C1=D0=D2=C5=CC=D1 2012=9A=C7. 1:06 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=
=D8 Dan Carpenter
<dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> This test is always true so it means we revalidate the length every
> time, which generates more network traffic. =9AThis was introduced in
> 06222e491e "fs: handle SEEK_HOLE/SEEK_DATA properly in all fs's that
> define their own llseek".
>
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> Josef, there were three other places that had this same problem but I
> think they've all been fixed now. =9AExcept that I had a question abo=
ut
> nfs_file_llseek(). =9AIsn't that reversed? =9AIt seems like it only
> revalidates when it's not supposed to. =9AI chose to copy what
> fuse_file_llseek() does instead.
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index d342128..97d26c7 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -695,7 +695,7 @@ static loff_t cifs_llseek(struct file *file, loff=
_t offset, int origin)
> =9A =9A =9A =9A * origin =3D=3D SEEK_END || SEEK_DATA || SEEK_HOLE =3D=
> we must revalidate
> =9A =9A =9A =9A * the cached file length
> =9A =9A =9A =9A */
> - =9A =9A =9A if (origin !=3D SEEK_SET || origin !=3D SEEK_CUR) {
> + =9A =9A =9A if (origin =3D=3D SEEK_SET || origin =3D=3D SEEK_CUR) {
> =9A =9A =9A =9A =9A =9A =9A =9Aint rc;
> =9A =9A =9A =9A =9A =9A =9A =9Astruct inode *inode =3D file->f_path.d=
entry->d_inode;
>

In this case the semantic contradict the comment above. May be it
should be "if (origin !=3D SEEK_SET && origin !=3D SEEK_CUR)"?

--=20
Best regards,
Pavel Shilovsky.
