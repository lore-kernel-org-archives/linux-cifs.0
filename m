From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] cifs: don't allow mmap'ed pages to be dirtied while
 under writeback
Date: Mon, 28 Mar 2011 07:20:32 -0400
Message-ID: <20110328072032.5864d3e2@tlielax.poochiereds.net>
References: <1300302931-13830-1-git-send-email-jlayton@redhat.com>
	<1300302931-13830-3-git-send-email-jlayton@redhat.com>
	<AANLkTin2Kzg=g+m3j66uLyaWRx6jn8j37Kg9C0zxCWhd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTin2Kzg=g+m3j66uLyaWRx6jn8j37Kg9C0zxCWhd-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 27 Mar 2011 23:13:45 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:


> > =C2=A0int cifs_file_strict_mmap(struct file *file, struct vm_area_s=
truct *vma)
> > =C2=A0{
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0int rc, xid;
> > @@ -1920,6 +1918,7 @@ int cifs_file_strict_mmap(struct file *file, =
struct vm_area_struct *vma)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cifs_invalid=
ate_mapping(inode);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0rc =3D generic_file_mmap(file, vma);
> > + =C2=A0 =C2=A0 =C2=A0 vma->vm_ops =3D &cifs_file_vm_ops;
>=20
> May be we should set this only if generic_file_mmap succeed and rc =3D=
=3D 0?
>=20

I don't think it really matters but you're probably right that it won't
hurt to do so. All of the existing callers of generic_file_mmap that
set the vm_ops don't do it unless generic_file_mmap succeeds. I'll
respin it...

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
