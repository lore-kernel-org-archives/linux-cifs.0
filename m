From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Patch v2 13/19] CIFS: SMBD: Use registered memory RDMA read for
 SMB write
Date: Wed, 23 Aug 2017 22:02:14 +0300
Message-ID: <20170823190214.GY1724@mtr-leonro.local>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
 <1503255883-3041-14-git-send-email-longli@exchange.microsoft.com>
 <20170823135200.GP1724@mtr-leonro.local>
 <MWHPR21MB0190DBBDE3317D973FEF0E43CE850@MWHPR21MB0190.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="QQ8SllDnVL7XJJuW"
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <MWHPR21MB0190DBBDE3317D973FEF0E43CE850-saRRjQKJ25M/hL2NnenhuM1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org


--QQ8SllDnVL7XJJuW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 23, 2017 at 06:09:11PM +0000, Long Li wrote:
>
>
> > -----Original Message-----
> > From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> > Sent: Wednesday, August 23, 2017 6:52 AM
> > To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; samba-
> > technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
> > rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>; Tom Talpey
> > <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>;
> > Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > Subject: Re: [Patch v2 13/19] CIFS: SMBD: Use registered memory RDMA
> > read for SMB write
> >
> > On Sun, Aug 20, 2017 at 12:04:37PM -0700, Long Li wrote:
> > > From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > >
> > > When sending I/O, if size is larger than rdma_readwrite_threshold we
> > prepare to send SMB WRITE packet for a RDMA read via memory registratio=
n.
> > The actual I/O is done out-of-the-band, so modify the relevant fields i=
n the
> > packet accordingly.
> > >
> > > Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > > ---
> > >  fs/cifs/smb2pdu.c | 45
> > ++++++++++++++++++++++++++++++++++++++++++++-
> > >  1 file changed, 44 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c index
> > > 5cc5f6c..5581afd 100644
> > > --- a/fs/cifs/smb2pdu.c
> > > +++ b/fs/cifs/smb2pdu.c
> > > @@ -48,6 +48,7 @@
> > >  #include "smb2glob.h"
> > >  #include "cifspdu.h"
> > >  #include "cifs_spnego.h"
> > > +#include "smbdirect.h"
> > >
> > >  /*
> > >   *  The following table defines the expected "StructureSize" of SMB2
> > > requests @@ -2716,6 +2717,41 @@ smb2_async_writev(struct
> > cifs_writedata *wdata,
> > >  				offsetof(struct smb2_write_req, Buffer) - 4);
> > >  	req->RemainingBytes =3D 0;
> > >
> > > +	/*
> > > +	 * If we want to do a server RDMA read, fill in and append
> > > +	 * smbd_buffer_descriptor_v1 to the end of write request
> > > +	 */
> > > +	if (server->rdma && wdata->bytes >
> > > +		server->smbd_conn->rdma_readwrite_threshold) {
> > > +
> > > +		struct smbd_buffer_descriptor_v1 *v1;
> > > +		bool need_invalidate =3D server->dialect =3D=3D SMB30_PROT_ID;
> > > +
> > > +		wdata->mr =3D smbd_register_mr(
> > > +				server->smbd_conn, wdata->pages,
> > > +				wdata->nr_pages, wdata->tailsz,
> > > +				false, need_invalidate);
> > > +		if (!wdata->mr) {
> > > +			rc =3D -ENOBUFS;
> > > +			goto async_writev_out;
> > > +		}
> > > +		req->Length =3D 0;
> > > +		req->DataOffset =3D 0;
> > > +		req->RemainingBytes =3D
> >
> > Wow, we have CamelCase variables in linux kernel. It will help if you s=
tart
> > your patchset with small cleanup to convert those variables from CamelC=
ase
> > to normal names.
>
> They are used everywhere in the upper layer code for packet definitions, =
written a long time ago. (most in fs/cifs/smb2pdu.h and fs/cifs/cifspdu.h)

"everywhere" is a little bit over estimated in this case.
=E2=9E=9C  linux-rdma git:(master) git grep RemainingBytes
fs/cifs/smb2pdu.c:              req->RemainingBytes =3D cpu_to_le32(remaini=
ng_bytes);
fs/cifs/smb2pdu.c:              req->RemainingBytes =3D 0;
fs/cifs/smb2pdu.c:      req->RemainingBytes =3D 0;
fs/cifs/smb2pdu.c:      req->RemainingBytes =3D 0;
fs/cifs/smb2pdu.h:      __le32 RemainingBytes;
fs/cifs/smb2pdu.h:      __le32 RemainingBytes;

One simple "sed -i" will replace all them in one shot and it doesn't
look like undoable task.

>
> I suggest we do another cleanup patch to clean things up.

Yes, another cleanup patch is needed before your patches. You are adding
your code in 2017 and you are expected to follow present coding standards
like everyone else in the kernel.

Thanks

--QQ8SllDnVL7XJJuW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmd0TYACgkQ5GN7iDZy
WKcWjg/7BU3NWGr3oN6PiFz1Sy1Ui/KUrPz0IWOzb/pcUf4nPrk9V9SHUfyvzJ+W
oQhf+6dGsTW5vcKIYAY70lXjaNF2O/wGLzLZ9QS3Ncr+yg+Htwd+A9IX0pNJ6AJN
ZDgCeFrYo02ZHz8/CC9T42jMXCLhR7uwrNCo8iRlGOwH5XICWoJ3vcLKsjvzXfqT
+BeFThQQkgnfBOIA0XiOsaUtQvuoOyBsU35pwv6ht12iHVT7/763Wq6hDEdOUMdd
+koBrpdYf0fgbjha9IQMlOKgY2umi4VOyCOV5gyHQK8p61jjB977QqyYzpW3ji0y
enKWKksn5+NpWh7Md+1tqt93MznNgAGSSHvH0KdYUCrgBZPdB9yrV3tnGrV7h9xR
gafzPzM3qG+RZmF0oWDxvXLUjGBbvGqkf3+9HCR4E3EN+tS/tFpBzRv1L12kZXJ3
HVkLbzN7cSHNOOs2kBIUbutNSY12zSQPYZGHtshMmi5w/l7dRreieanfblWN9c1v
QzQbh87M0OTL5gjDvn2hsH0ZNuWrdGrt8VuS7mzu7eo172vC/LsBUi5Ijo+p7G48
khnZtzt2uwHL9YFYQ9VRZGJQjZJjaZXmf+OlKAhXnm/cYYpeuEUJBNWm76HZzkwG
eoYG6ksBimDhmox8cntNIzVsDEHaUQecqz5c1jj+rFhkP0xbkZA=
=R6VB
-----END PGP SIGNATURE-----

--QQ8SllDnVL7XJJuW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
