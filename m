From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Patch v2 13/19] CIFS: SMBD: Use registered memory RDMA read for
 SMB write
Date: Wed, 23 Aug 2017 22:23:00 +0300
Message-ID: <20170823192300.GZ1724@mtr-leonro.local>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
 <1503255883-3041-14-git-send-email-longli@exchange.microsoft.com>
 <20170823135200.GP1724@mtr-leonro.local>
 <MWHPR21MB0190DBBDE3317D973FEF0E43CE850@MWHPR21MB0190.namprd21.prod.outlook.com>
 <20170823190214.GY1724@mtr-leonro.local>
 <MWHPR21MB0190DDCDB0B5F8FED3265A60CE850@MWHPR21MB0190.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AUHDRRu7c4EIRU83"
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
In-Reply-To: <MWHPR21MB0190DDCDB0B5F8FED3265A60CE850-saRRjQKJ25M/hL2NnenhuM1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org


--AUHDRRu7c4EIRU83
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 23, 2017 at 07:10:38PM +0000, Long Li wrote:
>
>
> > -----Original Message-----
> > From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> > Sent: Wednesday, August 23, 2017 12:02 PM
> > To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; samba-
> > technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
> > rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>; Tom Talpey
> > <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > Subject: Re: [Patch v2 13/19] CIFS: SMBD: Use registered memory RDMA
> > read for SMB write
> >
> > On Wed, Aug 23, 2017 at 06:09:11PM +0000, Long Li wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> > > > Sent: Wednesday, August 23, 2017 6:52 AM
> > > > To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > > > Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> > > > samba- technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> > > > linux- rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>;
> > > > Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Matthew Wilcox
> > > > <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > > > Subject: Re: [Patch v2 13/19] CIFS: SMBD: Use registered memory RDMA
> > > > read for SMB write
> > > >
> > > > On Sun, Aug 20, 2017 at 12:04:37PM -0700, Long Li wrote:
> > > > > From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > > > >
> > > > > When sending I/O, if size is larger than rdma_readwrite_threshold
> > > > > we
> > > > prepare to send SMB WRITE packet for a RDMA read via memory
> > registration.
> > > > The actual I/O is done out-of-the-band, so modify the relevant
> > > > fields in the packet accordingly.
> > > > >
> > > > > Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > > > > ---
> > > > >  fs/cifs/smb2pdu.c | 45
> > > > ++++++++++++++++++++++++++++++++++++++++++++-
> > > > >  1 file changed, 44 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c index
> > > > > 5cc5f6c..5581afd 100644
> > > > > --- a/fs/cifs/smb2pdu.c
> > > > > +++ b/fs/cifs/smb2pdu.c
> > > > > @@ -48,6 +48,7 @@
> > > > >  #include "smb2glob.h"
> > > > >  #include "cifspdu.h"
> > > > >  #include "cifs_spnego.h"
> > > > > +#include "smbdirect.h"
> > > > >
> > > > >  /*
> > > > >   *  The following table defines the expected "StructureSize" of
> > > > > SMB2 requests @@ -2716,6 +2717,41 @@ smb2_async_writev(struct
> > > > cifs_writedata *wdata,
> > > > >  				offsetof(struct smb2_write_req, Buffer) - 4);
> > > > >  	req->RemainingBytes =3D 0;
> > > > >
> > > > > +	/*
> > > > > +	 * If we want to do a server RDMA read, fill in and append
> > > > > +	 * smbd_buffer_descriptor_v1 to the end of write request
> > > > > +	 */
> > > > > +	if (server->rdma && wdata->bytes >
> > > > > +		server->smbd_conn->rdma_readwrite_threshold) {
> > > > > +
> > > > > +		struct smbd_buffer_descriptor_v1 *v1;
> > > > > +		bool need_invalidate =3D server->dialect =3D=3D SMB30_PROT_ID;
> > > > > +
> > > > > +		wdata->mr =3D smbd_register_mr(
> > > > > +				server->smbd_conn, wdata->pages,
> > > > > +				wdata->nr_pages, wdata->tailsz,
> > > > > +				false, need_invalidate);
> > > > > +		if (!wdata->mr) {
> > > > > +			rc =3D -ENOBUFS;
> > > > > +			goto async_writev_out;
> > > > > +		}
> > > > > +		req->Length =3D 0;
> > > > > +		req->DataOffset =3D 0;
> > > > > +		req->RemainingBytes =3D
> > > >
> > > > Wow, we have CamelCase variables in linux kernel. It will help if
> > > > you start your patchset with small cleanup to convert those
> > > > variables from CamelCase to normal names.
> > >
> > > They are used everywhere in the upper layer code for packet
> > > definitions, written a long time ago. (most in fs/cifs/smb2pdu.h and
> > > fs/cifs/cifspdu.h)
> >
> > "everywhere" is a little bit over estimated in this case.
> > =E2=9E=9C  linux-rdma git:(master) git grep RemainingBytes
> > fs/cifs/smb2pdu.c:              req->RemainingBytes =3D
> > cpu_to_le32(remaining_bytes);
> > fs/cifs/smb2pdu.c:              req->RemainingBytes =3D 0;
> > fs/cifs/smb2pdu.c:      req->RemainingBytes =3D 0;
> > fs/cifs/smb2pdu.c:      req->RemainingBytes =3D 0;
> > fs/cifs/smb2pdu.h:      __le32 RemainingBytes;
> > fs/cifs/smb2pdu.h:      __le32 RemainingBytes;
> >
> > One simple "sed -i" will replace all them in one shot and it doesn't lo=
ok like
> > undoable task.
>
> I mean cifspdu.h and smb2pdu.h. use CamelCase for all packet definitions.=
 For example another one in smb2pdu.h:
> struct smb2_negotiate_rsp {
>         struct smb2_hdr hdr;
>         __le16 StructureSize;   /* Must be 65 */
>         __le16 SecurityMode;
>         __le16 DialectRevision;
>         __le16 NegotiateContextCount;   /* Prior to SMB3.1.1 was Reserved=
 & MBZ */
>         __u8   ServerGUID[16];
>         __le32 Capabilities;
>         __le32 MaxTransactSize;
>         __le32 MaxReadSize;
>         __le32 MaxWriteSize;
>         __le64 SystemTime;      /* MBZ */
>         __le64 ServerStartTime;
>         __le16 SecurityBufferOffset;
>         __le16 SecurityBufferLength;
>         __le32 NegotiateContextOffset;  /* Pre:SMB3.1.1 was reserved/igno=
red */
>         __u8   Buffer[1];       /* variable length GSS security buffer */
> } __packed;
>
> We may want to change them all together to keep naming consistent, that's=
 a lot of changes.

Yes, but I'm not asking to change the structures which you are not
touching/using, concentrate on the ones used in your series.

It is great to have all these files in one coding style, but I agree with y=
ou that
it is not needed. I hope that your first patch with CC to kernel-janiators =
will
bring other people who will clean the rest.

Thanks

>
> >
> > >
> > > I suggest we do another cleanup patch to clean things up.
> >
> > Yes, another cleanup patch is needed before your patches. You are adding
> > your code in 2017 and you are expected to follow present coding standar=
ds
> > like everyone else in the kernel.
> >
> > Thanks

--AUHDRRu7c4EIRU83
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmd1hQACgkQ5GN7iDZy
WKcPahAAoHwYjfJQGbQCRJ7FqMQBSheqiKRGjsp8l4cmKB6HvakLlEhv+pDKwGBq
ZWlM3g2h/AfgD5JzlaM1Xe72mvbghWl6zFRYqCtHJeax4rAiwv8AnHiEiOANggfo
/8H/4wrB7WqR1wBanYhXna46sVpXEHS5Gy2CYKxKbpSCtcPcovh6xjHXAbeimMyM
lViRxGmCmuBGO8G03Vd1HvG611XGP1lVLVbABMVFUKI1z9oThK13sCGygvB/nt6b
2bM5TOpnJ2e0x1vYDhFZUyCPBAz8mAmQPtYF4LW6yPXK2f681PkLvPjrb4Uh9N0v
fjHnURE9ADuqHcpjaxAEvVMGnctW/GNmF8SMh5laJBS5T2b5vfqdCybS8/MeGYvm
3tvyGBHGKe5NEkOINysT47vXpH3owo8C/xKfmPyGr/a/Ed6jApl/ql7G+pODf3VJ
Orz5VKGjzVL1FV4Wknftym3QTK34tV2qfoyyQhFOc9bTRHPQa7bUlbytT4v5PPT5
azE0zCTmjFo+bUscc6ujWLQDdS6np+YVIGkYkJIg9yVVpmXoFcKJeo3Efe1NO2/X
XqeJ8PyrS04kTN5Cw85cmEk46jPQZD0KdnF+7O7RUY+cMTl+8m7fQHEB57l8xty0
5/vgHXFCeIK7wJOHRvCYF621kKpfNvGwOdVrTTC3JPHyfeEBfeE=
=0knl
-----END PGP SIGNATURE-----

--AUHDRRu7c4EIRU83--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
