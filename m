From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v2] cifs: call print_hex_dump instead of custom
 implementation
Date: Mon, 12 May 2014 19:30:05 +0300
Message-ID: <1399912205.3703.18.camel@smile.fi.intel.com>
References: <1399907720-18622-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20140512114247.0c96ad58@tlielax.poochiereds.net>
	 <1399911309.3703.14.camel@smile.fi.intel.com>
	 <20140512122356.1143f317@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Alexander Bokovoy <ab-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140512122356.1143f317-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 2014-05-12 at 12:23 -0400, Jeff Layton wrote:
> On Mon, 12 May 2014 19:15:09 +0300
> Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>=20
> > On Mon, 2014-05-12 at 11:42 -0400, Jeff Layton wrote:
> > > On Mon, 12 May 2014 18:15:20 +0300
> > > Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> > >=20
> > > > This patch converts custom dumper to use native print_hex_dump(=
) instead. The
> > > > dump will have a given label and addresses per each line which =
differs it from
> > > > the original code.
> > > >=20
> > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563A2t4k+OOtxA@public.gmane.org=
om>
> > > > ---
> > > >  fs/cifs/cifs_debug.c | 21 ++-------------------
> > > >  1 file changed, 2 insertions(+), 19 deletions(-)
> > > >=20
> > > > diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> > > > index fa78b68..e7b87ce 100644
> > > > --- a/fs/cifs/cifs_debug.c
> > > > +++ b/fs/cifs/cifs_debug.c
> > > > @@ -34,27 +34,10 @@
> > > >  void
> > > >  cifs_dump_mem(char *label, void *data, int length)
> > > >  {
> > > > -	int i, j;
> > > > -	int *intptr =3D data;
> > > > -	char *charptr =3D data;
> > > > -	char buf[10], line[80];
> > > > -
> > > >  	printk(KERN_DEBUG "%s: dump of %d bytes of data at 0x%p\n",
> > > >  		label, length, data);
> > > > -	for (i =3D 0; i < length; i +=3D 16) {
> > > > -		line[0] =3D 0;
> > > > -		for (j =3D 0; (j < 4) && (i + j * 4 < length); j++) {
> > > > -			sprintf(buf, " %08x", intptr[i / 4 + j]);
> > > > -			strcat(line, buf);
> > > > -		}
> > > > -		buf[0] =3D ' ';
> > > > -		buf[2] =3D 0;
> > > > -		for (j =3D 0; (j < 16) && (i + j < length); j++) {
> > > > -			buf[1] =3D isprint(charptr[i + j]) ? charptr[i + j] : '.';
> > > > -			strcat(line, buf);
> > > > -		}
> > > > -		printk(KERN_DEBUG "%s\n", line);
> > > > -	}
> > > > +	print_hex_dump(KERN_DEBUG, label, DUMP_PREFIX_ADDRESS, 16, 4,
> > > > +		       data, length, true);
> > >=20
> > > I'm not sure we want "label" as the prefix_str as it'll go on eve=
ry
> > > line. Maybe just use "" in place of "label" there?
> >=20
> > It was in my initial v1. I thought it would be better to have.
>=20
> Most of the labels are stuff like "Bad SMB:" and I'm not sure there's=
 a
> lot of value in repeating that on every line. The existing code
> certainly doesn't and that sort of thing tends to clutter up logfiles=
=2E

Got it.

>=20
> > What about addresses? Would you like to see it or offset is enough,=
 or
> > drop them as well?
> >=20
>=20
> The addresses aren't terribly helpful in general, and printing them
> might be considered information leakage. I'd suggest going with just
> the offsets.

Yeah, but since printk at the top of function already prints virtual
address... Maybe you could fix it in separate patch if you want, I leav=
e
as agreed =E2=80=94 just offsets and no label.

>=20
> > Moreover, I found another place where similar change could be done
> > (dump_smb), so, would it be better to do in separate patch?
> >=20
>=20
> Sure, that certainly wouldn't hurt. Your call on whether to do two
> patches or one.

I'm going to resend a whole patchseries as v3 with coverletter and
changelog, since I missed CC you in previous patch, and AB's
Reviewed-by. Also found rebase error which makes compilation fail.
And printk->pr_* change as new patch as well, will be 3 all together.

>=20
>=20
> > >=20
> > > >  }
> > > > =20
> > > >  #ifdef CONFIG_CIFS_DEBUG
> > >=20
> > > Otherwise, this looks good.
> > >=20
> > > Acked-by: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
> >=20
> >=20
>=20


--=20
Andy Shevchenko <andriy.shevchenko-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Intel Finland Oy
