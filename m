From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: -o noposixpaths
Date: Mon, 11 Jul 2011 14:41:46 -0400
Message-ID: <20110711144146.3748d1ff@tlielax.poochiereds.net>
References: <20110711142311.27b4dfce@tlielax.poochiereds.net>
	<CAH2r5mv3WOCKk4jL1YXrfvSjt52NOTgJZKatbLqB4U61iuZxRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mv3WOCKk4jL1YXrfvSjt52NOTgJZKatbLqB4U61iuZxRg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 11 Jul 2011 13:32:54 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Yes, IIRC the apple guys mentioned plausible server scenarios for thi=
s
> (where we want to mount with unix extensions for symlinks and ownersh=
ip
> but server can not handle posix path names)
>=20
> Presumably if the server file system does not support posix path name=
s
> (FAT32, NTFS?) or if we want to restrict the characters (for interope=
rability
> with Windows clients accessing the same share?) - might be other case=
s.
>=20

In that case though, shouldn't those servers just not set
CIFS_UNIX_POSIX_PATHNAMES_CAP ?


> On Mon, Jul 11, 2011 at 1:23 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > Is this mount option actually useful? Is there ever a case where we=
'd
> > want to use unix extensions, but not use posix-style pathnames? If =
not,
> > does it make sense to deprecate this option?
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
