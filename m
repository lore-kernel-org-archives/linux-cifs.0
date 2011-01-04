From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: switch cifs_open and cifs_create to use
 CIFSSMBUnixSetFileInfo
Date: Tue, 4 Jan 2011 10:29:53 -0500
Message-ID: <20110104102953.116241ef@tlielax.poochiereds.net>
References: <1294146996-25591-1-git-send-email-jlayton@redhat.com>
	<AANLkTimQwrJzF_pQLPdT24kb4R=eGNKBn7D2kM3S0xht@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimQwrJzF_pQLPdT24kb4R=eGNKBn7D2kM3S0xht-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 4 Jan 2011 09:17:26 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Jan 4, 2011 at 7:16 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> > We call CIFSSMBUnixSetPathInfo in these functions, but we have a
> > filehandle since an open was just done. Switch these functions to
> > use CIFSSMBUnixSetFileInfo instead.
> >
> > In practice, these codepaths are only used if posix opens are broke=
n.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =A0fs/cifs/dir.c =A0| =A0 =A06 ++----
> > =A0fs/cifs/file.c | =A0 =A06 ++----
> > =A02 files changed, 4 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> > index 521d841..d9b46bf 100644
> > --- a/fs/cifs/dir.c
> > +++ b/fs/cifs/dir.c
> > @@ -293,10 +293,8 @@ cifs_create(struct inode *inode, struct dentry=
 *direntry, int mode,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0args.uid =3D NO_CHAN=
GE_64;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0args.gid =3D NO_CHAN=
GE_64;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFSSMBUnixSetPathInfo(xid, tcon, ful=
l_path, &args,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 cifs_sb->local_nls,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 cifs_sb->mnt_cifs_flags &
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_MOUNT_MAP_SPECIAL_CHR);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFSSMBUnixSetFileInfo(xid, tcon, &ar=
gs, fileHandle,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 current->tgid);
> > =A0 =A0 =A0 =A0} else {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB implement mode setting via Win=
dows security
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 descriptors e.g. */
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index a7b8a37..4007e60 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -424,10 +424,8 @@ int cifs_open(struct inode *inode, struct file=
 *file)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.mtime =A0=3D NO_CHA=
NGE_64,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0.device =3D 0,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0};
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFSSMBUnixSetPathInfo(xid, tcon, ful=
l_path, &args,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0cifs_sb->local_nls,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0cifs_sb->mnt_cifs_flags &
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 CIFS_MOUNT_MAP_SPECIAL_CHR);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFSSMBUnixSetFileInfo(xid, tcon, &ar=
gs, netfid,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 pCifsFile->pid);
> > =A0 =A0 =A0 =A0}
> >
> > =A0out:
> > --
> > 1.7.3.4
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>=20
> Would a filehandle always remain valid between open and set?
> Could there be a reconnect in between these calls thus making
> a filehandle invalid and failing a setfileinfo which otherwise would
> succeed with setpathinfo?

Seems unlikely, but I suppose it's possible.

Unfortunately, cifs is pretty racy in this regard. Suppose we do this:

                        if (open_file->invalidHandle) {
                                rc =3D cifs_reopen_file(open_file, fals=
e);
                                if (rc !=3D 0)
                                        break;
                        }
			CIFSSMBUnixSetFileInfo(...);

=2E..it's always possible that the handle will flip to being invalid
after you've done the check but before the call goes out on the wire.
It's also possible that the file was reclaimed with a different number
before you do this check. The main things that save us is that
reconnects are relatively uncommon, and they generally take a long time
so those sorts of races don't generally happen much.

What we really need is a better way to deal with this that doesn't rely
on these sorts of checks. I have a scheme in mind to do this, but it
requires overhauling quite a bit of the SendReceive code. I don't want
to embark on that work until some of my existing patches has been merge=
d.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
