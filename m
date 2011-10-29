From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [patch] cifs: accidentally creating empty files
Date: Sat, 29 Oct 2011 01:48:55 -0400
Message-ID: <20111029014855.13dd53be@corrin.poochiereds.net>
References: <20110927212810.GA12900@elgon.mountain>
	<20111013132755.6c5db87e@barsoom.rdu.redhat.com>
	<CAH2r5mtOF=Ja7_mTK576uEqgZqaVH+8YXtOqmZVknBC81sD=8Q@mail.gmail.com>
	<20111028072019.GA14900@longonot.mountain>
	<CAH2r5msb_+tenSg1kWCn_0xi2EZu6vboqvmbQ17vRBYoqHp2Eg@mail.gmail.com>
	<20111028234406.01fd23ba@corrin.poochiereds.net>
	<CAH2r5mvHF0X6PQ8FyBfVEpQeyWgd7RGkawJykapkKt0K84QTHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvHF0X6PQ8FyBfVEpQeyWgd7RGkawJykapkKt0K84QTHw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 29 Oct 2011 00:07:12 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Oct 28, 2011 at 10:44 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wro=
te:
> > On Fri, 28 Oct 2011 10:27:04 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Fri, Oct 28, 2011 at 2:20 AM, Dan Carpenter <dan.carpenter@orac=
le.com> wrote:
> >> > On Wed, Oct 19, 2011 at 09:14:37PM -0500, Steve French wrote:
> >> >> Doesn't this force the create to happen later - rather than
> >> >> at lookup time where it belongs?
> >> >>
> >> >> if the issue is just noperm ... we should let this through if t=
he user
> >> >> has local permissions. =C2=A0Doubling the cost of a file create=
 to Samba
> >> >> seems like a bad idea (ie doing aQueryPathInfo AND an NTCreateX
> >> >> doubles the roundrip, doubles the load on the server etc.) - th=
e whole
> >> >> point of this is to let us do an "atomic" open or create operat=
ion
> >> >> and not have to split it into multiple requests. =C2=A0In any c=
ase why would
> >> >> we do the open and then follow it with a create?
> >> >>
> >> >> Can we fix this to (at least) narrow the performance penalty.
> >> >>
> >> >
> >> > Yes, it does add another back and forth to file create... =C2=A0=
It's hard/
> >> > impossible to check the permissions first and then decide whethe=
r to
> >> > pass the O_CREAT flag. =C2=A0Maybe we could add an if statement =
to check
> >> > whether noperm was used and the noperm version could use the cre=
ate
> >> > on lookup.
> >>
> >> Why is it hard to check local permissions? We have the local mode
> >> for the parent.
> >>
> >> Also note that the "intent" flags and the atomic create is not jus=
t
> >> about performance, but also making it atomic reduces some of the w=
eird
> >> failure cases.
> >>
> >
> > We have the local mode for the parent, but we do not have the owner=
ship
> > and mode for the file that has not yet been created. Because of the
> > special (ahem) way that cifs handles permissions, it's easily possi=
ble
> > for the ownership of the file not to match the user doing that crea=
te.
> > At that point, later operations on the file can easily fail.
> >
> > This was the primary reason for the multiuser patch series, and why=
 I
> > still say that doing permissions checking on the client is a broken
> > model.
>=20
> We don't have much choice - we have to allow permission
> checking on the client when client security context
> can't match security context on server - but I would like
> to make multiuser the default (especially if we
> can figure out a way to integrate winbind-like
> upcall for ntlmv2 auth) at least for the future (smb2 etc.)
> even if we can't change the default for cifs mounts.
>=20

That's fine, but that doesn't solve Dan's immediate problem. We need to
either take his patch or something like it for 3.2 (and probably for
stable as well) or just rip this crap out altogether.

I'd favor the latter, for the following reason:

----------------------[snip]-------------------
        /*
         * O_EXCL: optimize away the lookup, but don't hash the dentry.=
 Let
         * the VFS handle the create.
         */
        if (nd && (nd->flags & LOOKUP_EXCL)) {
                d_instantiate(direntry, NULL);
                rc =3D 0;
                goto lookup_out;
        }

	[...]

        if (pTcon->unix_ext) {
                if (nd && !(nd->flags & LOOKUP_DIRECTORY) &&
                     (nd->flags & LOOKUP_OPEN) && !pTcon->broken_posix_=
open &&
                     (nd->intent.open.file->f_flags & O_CREAT)) {
                        rc =3D cifs_posix_open(full_path, &newInode,
                                        parent_dir_inode->i_sb,
                                        nd->intent.open.create_mode,
                                        nd->intent.open.file->f_flags, =
&oplock,
                                        &fileHandle, xid);
----------------------[snip]-------------------

Ok, so we optimize away the lookup in the O_EXCL case (which is fine).

Then, we only attempt a posix open if O_CREAT was set (note that
regular SMB CREATE_ANDX is prohibited here -- why?). Now, with Dan's
patch, we'll be doing this only when O_CREAT is set, and only when the
file actually exists on the server (since we'll be clearing=20

This really just makes no sense at all. The times when we can use this
are so vanishingly small that it makes more sense to just remove this
stuff. If you really want to do this, it needs a redesign from the
ground up, with a consideration of each possible case and determination
of whether it's better (and safe) to use an open instead of lookup in
that case.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
