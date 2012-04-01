From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [ 105/175] CIFS: Respect negotiated MaxMpxCount
Date: Sun, 1 Apr 2012 09:55:39 -0400
Message-ID: <20120401095539.31323c95@corrin.poochiereds.net>
References: <20120330195801.GA31806@kroah.com>
	<20120330194846.517484801@linuxfoundation.org>
	<20120331201825.036fe1d8@corrin.poochiereds.net>
	<CAH2r5muM-4_pVt59XeNrOZZ=28P0hT8GiMqBUk+0nxnUw9L+VA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muM-4_pVt59XeNrOZZ=28P0hT8GiMqBUk+0nxnUw9L+VA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 1 Apr 2012 02:26:58 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Sat, Mar 31, 2012 at 7:18 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > On Fri, 30 Mar 2012 12:50:10 -0700
> > Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org> wrote:
> >
> >> 3.3-stable review patch. =C2=A0If anyone has any objections, pleas=
e let me know.
> >>
> >
> > I'm not sure it's a good idea to put this patch into any stable rel=
ease
> > just yet. I think it's a correct and necessary fix, but it has some
> > potential to cause regressions too (or uncover other preexisting
> > problems with this code). Might it be best to wait until we have so=
me
> > more experience with this before we push it into stable?
>=20
> Delaying it a little is probably ok, but weigh that against the
> frequency/severity
> of the problem that Pavel's fix addresses:  ie sequential writes to s=
ome
> versions of Windows 7 and Windows Vista can fail partway
> through large file copy (which also causes those servers
> to become unresponsive to subsequent connection requests
> as well) so the fix does address a hot problem.
>=20
>=20
>=20

I'm not disputing whether this patch is correct. It's clearly a bug
that cifs.ko has never respected this value, and it's quite problematic
with certain servers.

The problem is that we don't have any confirmation that:

a) this fixes any of the problems that we think it will

b) this doesn't introduce any regressions

The request slot allocation code is quite fiddly and fragile, and I
think the potential for "b" is somewhat high. I'd feel more comfortable
if we waited until we have more experience with this patch before
merging it into stable.

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
