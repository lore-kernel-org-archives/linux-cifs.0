From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch] cifs: accidentally creating empty files
Date: Thu, 13 Oct 2011 13:09:53 -0500
Message-ID: <CAH2r5mu2P0O=K4Np77UBrnMg1KboJ5Z2MD9TDCHF7MEdrFDguA@mail.gmail.com>
References: <20110927212810.GA12900@elgon.mountain>
	<20111013132755.6c5db87e@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111013132755.6c5db87e-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 13, 2011 at 12:27 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
>
> On Wed, 28 Sep 2011 00:28:10 +0300
> Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>
> > This solves a problem for where a user without write permissions
> > was creating empty files. =A0This function was supposed to do a loo=
kup
> > only, the create happens later.
> >
>
> Not quite. This uses the open-intent goop in the VFS layer that Al Vi=
ro
> is trying to get rid of. The idea here is that doing a lookup just to
> do an open is a waste, when you could just attempt the open. There's =
no
> real reason to exempt creates from that if cifs used a sane permissio=
ns
> model...
>
> > Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >
> > diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> > index 72d448b..8515afe 100644
> > --- a/fs/cifs/dir.c
> > +++ b/fs/cifs/dir.c
> > @@ -566,11 +566,13 @@ cifs_lookup(struct inode *parent_dir_inode, s=
truct dentry *direntry,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (nd && !(nd->flags & LOOKUP_DIRECTOR=
Y) &&
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(nd->flags & LOOKUP_OPEN) &&=
 !pTcon->broken_posix_open &&
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(nd->intent.open.file->f_fla=
gs & O_CREAT)) {
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int f_flags;
> > +
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 f_flags =3D (nd->intent.o=
pen.file->f_flags & ~O_CREAT);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D cifs_posix_open(=
full_path, &newInode,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 parent_dir_inode->i_sb,
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 nd->intent.open.create_mode,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 nd->intent.open.file->f_flags, &oplock,
> > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 &fileHandle, xid);
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 f_flags, &oplock, &fileHandle, xid);
>
> =A0 =A0 =A0 =A0...so this makes it only do the open at lookup time if=
 the
> =A0 =A0 =A0 =A0file already exists.
>
> =A0 =A0 =A0 =A0I suspect the real problem here is that cifs is trying=
 to
> =A0 =A0 =A0 =A0enforce permissions on the client, which happens after=
 the
> =A0 =A0 =A0 =A0lookup.
>
> =A0 =A0 =A0 =A0If the client simply allowed the server to handle the
> =A0 =A0 =A0 =A0permissions (and used the right credentials for each u=
ser),
> =A0 =A0 =A0 =A0then this would probably work fine. Another nail in th=
e coffin
> =A0 =A0 =A0 =A0for the whole model of client side permissions enforce=
ment,
> =A0 =A0 =A0 =A0IMO...

so it works with "noperm" on.=A0 Presumably we should be recommending
turning noperm and multiuser on (and probably cifsacl if the server is
not samba).

I still would much prefer being able to hook in to the create and open
"closer" to the syscall itself rather than after it is broken down
into (unneeded) lower level fs entry points (for getattr/setattr and
create vs. open).

--
Thanks,

Steve
