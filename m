From: Pankaj Baranwal <Pankaj.Baranwal-MlROQetx9QU@public.gmane.org>
Subject: RE: [patch] cifs: fix revalidation test in cifs_llseek()
Date: Fri, 27 Apr 2012 18:38:57 +0530
Message-ID: <AD32159B1843864D8CB027AD1A54E8375187694FB6@CHN-HCLT-EVS09.HCLT.CORP.HCL.IN>
References: <20120419210619.GA19074@elgon.mountain>
 <CAKywueQrrHdqXXrHQbP=vjs_MLjksvR09cpax0iWw-PS6ms=fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	Josef Bacik <josef-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQrrHdqXXrHQbP=vjs_MLjksvR09cpax0iWw-PS6ms=fg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Could you please unscribe me from this list

-----Original Message-----
=46rom: samba-technical-bounces-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org [mailto:samba-technical=
-bounces-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org] On Behalf Of Pavel Shilovsky
Sent: Friday, April 27, 2012 6:29 PM
To: Dan Carpenter
Cc: Steve French; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; kernel-janitors-u79uwXL29Tb/PtFMR13I2A@public.gmane.org=
el.org; samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; Josef Bacik
Subject: Re: [patch] cifs: fix revalidation test in cifs_llseek()

20 =C1=D0=D2=C5=CC=D1 2012 =C7. 1:06 =D0=CF=CC=D8=DA=CF=D7=C1=D4=C5=CC=D8=
 Dan Carpenter
<dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> =CE=C1=D0=C9=D3=C1=CC:
> This test is always true so it means we revalidate the length every
> time, which generates more network traffic.  This was introduced in
> 06222e491e "fs: handle SEEK_HOLE/SEEK_DATA properly in all fs's that
> define their own llseek".
>
> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> Josef, there were three other places that had this same problem but I
> think they've all been fixed now.  Except that I had a question about
> nfs_file_llseek().  Isn't that reversed?  It seems like it only
> revalidates when it's not supposed to.  I chose to copy what
> fuse_file_llseek() does instead.
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index d342128..97d26c7 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -695,7 +695,7 @@ static loff_t cifs_llseek(struct file *file, loff=
_t offset, int origin)
>         * origin =3D=3D SEEK_END || SEEK_DATA || SEEK_HOLE =3D> we mu=
st revalidate
>         * the cached file length
>         */
> -       if (origin !=3D SEEK_SET || origin !=3D SEEK_CUR) {
> +       if (origin =3D=3D SEEK_SET || origin =3D=3D SEEK_CUR) {
>                int rc;
>                struct inode *inode =3D file->f_path.dentry->d_inode;
>

In this case the semantic contradict the comment above. May be it
should be "if (origin !=3D SEEK_SET && origin !=3D SEEK_CUR)"?

--
Best regards,
Pavel Shilovsky.



::DISCLAIMER::
-----------------------------------------------------------------------=
------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and =
intended for the named recipient(s) only.
E-mail transmission cannot be guaranteed to be secure or error-free as =
information could be intercepted, corrupted,
lost, destroyed, arrive late or incomplete, or contain viruses.The e ma=
il and its contents (with or without referred
errors) shall therefore not attach any liability on the originator or H=
CL or its affiliates. Any views or opinions
presented in this email are solely those of the author and may not nece=
ssarily reflect the opinions of HCL or its
affiliates. Any form of reproduction, dissemination, copying, disclosur=
e, Modification, distribution and/or publication
of this message without the prior written consent of the author of this=
 e-mail is strictly prohibited. If you have
received this email in error please delete it and notify the sender imm=
ediately. Before opening any mail and attachments
please check them for viruses and defect.

-----------------------------------------------------------------------=
------------------------------------------------
