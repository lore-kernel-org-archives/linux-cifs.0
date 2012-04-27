From: Jeff Layton <jlayton@samba.org>
Subject: Re: [patch] cifs: fix revalidation test in cifs_llseek()
Date: Fri, 27 Apr 2012 09:40:33 -0400
Message-ID: <20120427094033.18733a5f@corrin.poochiereds.net>
References: <20120419210619.GA19074@elgon.mountain>
	<CAKywueQrrHdqXXrHQbP=vjs_MLjksvR09cpax0iWw-PS6ms=fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	kernel-janitors@vger.kernel.org, Steve French <sfrench@samba.org>,
	Dan Carpenter <dan.carpenter@oracle.com>, Josef Bacik <josef@redhat.com>
To: Pavel Shilovsky <piastryyy@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAKywueQrrHdqXXrHQbP=vjs_MLjksvR09cpax0iWw-PS6ms=fg@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 27 Apr 2012 16:59:07 +0400
Pavel Shilovsky <piastryyy@gmail.com> wrote:

> 20 =D0=B0=D0=BF=D1=80=D0=B5=D0=BB=D1=8F 2012=C2=A0=D0=B3. 1:06 =D0=BF=D0=
=BE=D0=BB=D1=8C=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=D0=B5=D0=BB=D1=8C Dan Carpent=
er
> <dan.carpenter@oracle.com> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
> > This test is always true so it means we revalidate the length every
> > time, which generates more network traffic. =C2=A0This was introduced in
> > 06222e491e "fs: handle SEEK_HOLE/SEEK_DATA properly in all fs's that
> > define their own llseek".
> >
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > Josef, there were three other places that had this same problem but I
> > think they've all been fixed now. =C2=A0Except that I had a question ab=
out
> > nfs_file_llseek(). =C2=A0Isn't that reversed? =C2=A0It seems like it on=
ly
> > revalidates when it's not supposed to. =C2=A0I chose to copy what
> > fuse_file_llseek() does instead.
> >
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index d342128..97d26c7 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -695,7 +695,7 @@ static loff_t cifs_llseek(struct file *file, loff_t=
 offset, int origin)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 * origin =3D=3D SEEK_END || SEEK_DATA || SE=
EK_HOLE =3D> we must revalidate
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 * the cached file length
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 */
> > - =C2=A0 =C2=A0 =C2=A0 if (origin !=3D SEEK_SET || origin !=3D SEEK_CUR=
) {
> > + =C2=A0 =C2=A0 =C2=A0 if (origin =3D=3D SEEK_SET || origin =3D=3D SEEK=
_CUR) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int rc;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct inode *in=
ode =3D file->f_path.dentry->d_inode;
> >
>=20
> In this case the semantic contradict the comment above. May be it
> should be "if (origin !=3D SEEK_SET && origin !=3D SEEK_CUR)"?
>=20

Agreed, I think Pavel is correct here. The stuff inside the if block
revalidates the file size, and we only need to do that if whence is not
SEEK_SET or SEEK_CUR.

--=20
Jeff Layton <jlayton@samba.org>
