From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [v4 PATCH 4/4] CIFS: Migrate to shared superblock model
Date: Thu, 26 May 2011 14:45:03 -0400
Message-ID: <20110526144503.33670e56@tlielax.poochiereds.net>
References: <1306389721-28550-1-git-send-email-piastry@etersoft.ru>
	<1306389721-28550-4-git-send-email-piastry@etersoft.ru>
	<20110526112001.6602ce52@corrin.poochiereds.net>
	<BANLkTim+a8swvWytQwUQqE+1s+wVnX3gRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTim+a8swvWytQwUQqE+1s+wVnX3gRg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 26 May 2011 11:06:59 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, May 26, 2011 at 10:20 AM, Jeff Layton <jlayton-vpEMnDpepFvY2uhgrK1nQg@public.gmane.org=
t> wrote:
> > On Thu, 26 May 2011 10:02:01 +0400
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> Add cifs_match_super to use in sget to share superblock between mo=
unts
> >> that have the same //server/sharename, credentials and mount optio=
ns.
> >> It helps us to improve performance on work with future SMB2.1 leas=
es.
> <snip>
> >> +static int
> >> +compare_mount_options(struct super_block *sb, struct cifs_mnt_dat=
a *mnt_data)
> >> +{
> >> + =C2=A0 =C2=A0 struct cifs_sb_info *old =3D CIFS_SB(sb);
> >> + =C2=A0 =C2=A0 struct cifs_sb_info *new =3D mnt_data->cifs_sb;
> >> +
> >> + =C2=A0 =C2=A0 if ((sb->s_flags & CIFS_MS_MASK) !=3D (mnt_data->f=
lags & CIFS_MS_MASK))
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >> +
> >> + =C2=A0 =C2=A0 if ((old->mnt_cifs_flags & CIFS_MOUNT_MASK) !=3D
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 (new->mnt_cifs_flags & CIFS_MOUNT_MA=
SK))
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >> +
> >> + =C2=A0 =C2=A0 if (old->rsize !=3D new->rsize)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >> +
> >> + =C2=A0 =C2=A0 if (new->wsize && new->wsize > old->wsize)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> >> +
> >
> > ...also I think the above condition should be reversed. We don't wa=
nt
> > to match if new->wsize is smaller than the existing one. Since the
> > specified wsize is just a starting point for negotiation, wsize now
> > means "any wsize less than or equal to this size". If the old->wsiz=
e is
> > bigger than that, then it's outside that range and we shouldn't mat=
ch.
>=20
> A more important question is whether the user intentionally tried to
> specify a wsize.  I don't see a problem matching a new default mount
> request (with no wsize specified, using therefore a default wsize)
> with an existing mount (with a larger explicitly specified wsize).
> If a user explicitly requests to override to a particular wsize on th=
e 2nd
> mount - seems more logical to give them what they ask for if
> possible whether larger or smaller.
>=20
>=20

Good point. That will probably mean that you'll need to separately
track the "requested" wsize and the "actual" wsize. Honestly though, I
don't see this as a huge issue. I suggest we take this patch as-is and
plan to fix that later.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
