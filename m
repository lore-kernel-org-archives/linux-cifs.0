From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: RE: [Patch v2 13/19] CIFS: SMBD: Use registered memory RDMA read for
 SMB write
Date: Wed, 23 Aug 2017 18:09:11 +0000
Message-ID: <MWHPR21MB0190DBBDE3317D973FEF0E43CE850@MWHPR21MB0190.namprd21.prod.outlook.com>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
 <1503255883-3041-14-git-send-email-longli@exchange.microsoft.com>
 <20170823135200.GP1724@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        "Tom Talpey" <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170823135200.GP1724-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>



> -----Original Message-----
> From: Leon Romanovsky [mailto:leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org]
> Sent: Wednesday, August 23, 2017 6:52 AM
> To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; samba-
> technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-
> rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>; Tom Talpey
> <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>; Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>;
> Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> Subject: Re: [Patch v2 13/19] CIFS: SMBD: Use registered memory RDMA
> read for SMB write
>=20
> On Sun, Aug 20, 2017 at 12:04:37PM -0700, Long Li wrote:
> > From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> >
> > When sending I/O, if size is larger than rdma_readwrite_threshold we
> prepare to send SMB WRITE packet for a RDMA read via memory registration.
> The actual I/O is done out-of-the-band, so modify the relevant fields in =
the
> packet accordingly.
> >
> > Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
> > ---
> >  fs/cifs/smb2pdu.c | 45
> ++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 44 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c index
> > 5cc5f6c..5581afd 100644
> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -48,6 +48,7 @@
> >  #include "smb2glob.h"
> >  #include "cifspdu.h"
> >  #include "cifs_spnego.h"
> > +#include "smbdirect.h"
> >
> >  /*
> >   *  The following table defines the expected "StructureSize" of SMB2
> > requests @@ -2716,6 +2717,41 @@ smb2_async_writev(struct
> cifs_writedata *wdata,
> >  				offsetof(struct smb2_write_req, Buffer) - 4);
> >  	req->RemainingBytes =3D 0;
> >
> > +	/*
> > +	 * If we want to do a server RDMA read, fill in and append
> > +	 * smbd_buffer_descriptor_v1 to the end of write request
> > +	 */
> > +	if (server->rdma && wdata->bytes >
> > +		server->smbd_conn->rdma_readwrite_threshold) {
> > +
> > +		struct smbd_buffer_descriptor_v1 *v1;
> > +		bool need_invalidate =3D server->dialect =3D=3D SMB30_PROT_ID;
> > +
> > +		wdata->mr =3D smbd_register_mr(
> > +				server->smbd_conn, wdata->pages,
> > +				wdata->nr_pages, wdata->tailsz,
> > +				false, need_invalidate);
> > +		if (!wdata->mr) {
> > +			rc =3D -ENOBUFS;
> > +			goto async_writev_out;
> > +		}
> > +		req->Length =3D 0;
> > +		req->DataOffset =3D 0;
> > +		req->RemainingBytes =3D
>=20
> Wow, we have CamelCase variables in linux kernel. It will help if you sta=
rt
> your patchset with small cleanup to convert those variables from CamelCas=
e
> to normal names.

They are used everywhere in the upper layer code for packet definitions, wr=
itten a long time ago. (most in fs/cifs/smb2pdu.h and fs/cifs/cifspdu.h)

I suggest we do another cleanup patch to clean things up.

>=20
> Thanks
>=20
> > +			(wdata->nr_pages-1)*PAGE_SIZE + wdata->tailsz;
> > +		req->Channel =3D SMB2_CHANNEL_RDMA_V1_INVALIDATE;
> > +		if (need_invalidate)
> > +			req->Channel =3D SMB2_CHANNEL_RDMA_V1;
> > +		req->WriteChannelInfoOffset =3D
> > +			offsetof(struct smb2_write_req, Buffer) - 4;
> > +		req->WriteChannelInfoLength =3D
> > +			sizeof(struct smbd_buffer_descriptor_v1);
> > +		v1 =3D (struct smbd_buffer_descriptor_v1 *) &req->Buffer[0];
> > +		v1->offset =3D wdata->mr->mr->iova;
> > +		v1->token =3D wdata->mr->mr->rkey;
> > +		v1->length =3D wdata->mr->mr->length;
> > +	}
> > +
> >  	/* 4 for rfc1002 length field and 1 for Buffer */
> >  	iov[0].iov_len =3D 4;
> >  	iov[0].iov_base =3D req;
> > @@ -2729,10 +2765,17 @@ smb2_async_writev(struct cifs_writedata
> *wdata,
> >  	rqst.rq_pagesz =3D wdata->pagesz;
> >  	rqst.rq_tailsz =3D wdata->tailsz;
> >
> > +	if (wdata->mr) {
> > +		iov[1].iov_len +=3D sizeof(struct smbd_buffer_descriptor_v1);
> > +		rqst.rq_npages =3D 0;
> > +	}
> > +
> >  	cifs_dbg(FYI, "async write at %llu %u bytes\n",
> >  		 wdata->offset, wdata->bytes);
> >
> > -	req->Length =3D cpu_to_le32(wdata->bytes);
> > +	/* For RDMA read, I/O size is in RemainingBytes not in Length */
> > +	if (!wdata->mr)
> > +		req->Length =3D cpu_to_le32(wdata->bytes);
> >
> >  	inc_rfc1001_len(&req->hdr, wdata->bytes - 1 /* Buffer */);
> >
> > --
> > 2.7.4
> >
