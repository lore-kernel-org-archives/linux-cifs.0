From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: Support for an upcall to map SID to an uid and a
 gid
Date: Sat, 11 Dec 2010 22:11:59 -0500
Message-ID: <20101211221159.36e6c814@corrin.poochiereds.net>
References: <1291741872-22747-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101211111716.1e21be41@corrin.poochiereds.net>
	<AANLkTimiD_iAJveTFpsANQsJC_cUfRwHM=jO5FSoj4x_@mail.gmail.com>
	<20101211193003.4a11fc7f@corrin.poochiereds.net>
	<AANLkTiniGp28dxZuoTcjyp0OMEoQ-7E0yE6T8B+VHOLj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTiniGp28dxZuoTcjyp0OMEoQ-7E0yE6T8B+VHOLj-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 11 Dec 2010 19:57:11 -0500
Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Sat, Dec 11, 2010 at 7:30 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> >>
> >> Will look into this. =A0One thing that concerns me is if a cached =
etnry
> >> for a SID with its name and an id (either an uid or a gid), if tha=
t SID
> >> now represents a different object and has differernt name, would
> >> not cached info be incorrect? =A0Not sure if this can ever happen
> >> or how would it happen and if it does, what would be a trigger
> >> for a cache revalidation and purges!
> >>
> >
> > Sure, mappings can change. But, you still have the same problem wit=
h
> > what you're proposing in these patches. The userspace program isn't
> > setting a timeout on the key. Once a mapping is put in the keyring,
> > it's there until it's revoked. You probably want to set a max TTL f=
or
> > the entries in the cache regardless of what scheme is used.
>=20
> I was under the impression that SIDs are never reused. Perhaps I am m=
istaken.
>=20

That may be, but the mapping of a SID is dependent upon settings in
config files that could change. It seems reasonable to me to only cache
these mappings for a period of time in the event that they do. That
period of time could default to being rather long and be tunable.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
