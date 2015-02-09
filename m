From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: Re: New ioctl - FSCTL_DUPLICATE_EXTENTS_TO_FILE
Date: Tue, 10 Feb 2015 00:51:20 +0100
Message-ID: <20150210005120.6936991d@plati.site>
References: <CAH2r5mu4zB08avnUSig5b-DGBekgOHVGoUYNNosOpvfAfOYBoA@mail.gmail.com>
	<20150128192203.5dbb06ea@g21.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	David Disseldorp <ddiss-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150128192203.5dbb06ea-TzLh5lQYVSQb1SvskN2V4Q@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 28 Jan 2015 19:22:03 +0100, David Disseldorp wrote:

> > "A new File System Control (FSCTL) has been added to support the ne=
w
> > FSCTL_DUPLICATE_EXTENTS_TO_FILE operation in [MS-FSA]." =20
>=20
> I haven't played with it yet, but from the [MS-FCC] 20150119 preview
> doc it looks very similar to copy-chunk, with a few small differences=
:
> - It's only supported on ReFS, which may indicate that it's implement=
ed
>   using COW clones.

The [MS-FSA] draft can be found at:
http://download.microsoft.com/download/C/6/C/C6C3C6F1-E84A-44EF-82A9-49=
BD3AAD8F58/Windows/%5BMS-FSA-Diff%5D.pdf

It pretty much confirms that it's COW based:
"The purpose of this operation is to make it look like a copy of a
 region from the source stream to the target stream has occurred when
 in reality no data is actually copied. This operation modifies the
 target stream=E2=80=99s extent list such that, the same clusters are p=
ointed
 to by both the source and target streams=E2=80=99 extent lists for the=
 region
 being copied."

@Steve, it looks like the perfect candidate for cp --reflink mapping on
the client side.

Cheers, David
