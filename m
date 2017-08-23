From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [Patch v2 13/19] CIFS: SMBD: Use registered memory RDMA read for
 SMB write
Date: Wed, 23 Aug 2017 16:52:00 +0300
Message-ID: <20170823135200.GP1724@mtr-leonro.local>
References: <1503255883-3041-1-git-send-email-longli@exchange.microsoft.com>
 <1503255883-3041-14-git-send-email-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zYX8XqlwBJQgDxCD"
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Tom Talpey <ttalpey@microsoft.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        Long Li <longli@microsoft.com>
To: Long Li <longli@exchange.microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1503255883-3041-14-git-send-email-longli@exchange.microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org


--zYX8XqlwBJQgDxCD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 20, 2017 at 12:04:37PM -0700, Long Li wrote:
> From: Long Li <longli@microsoft.com>
>
> When sending I/O, if size is larger than rdma_readwrite_threshold we prepare to send SMB WRITE packet for a RDMA read via memory registration. The actual I/O is done out-of-the-band, so modify the relevant fields in the packet accordingly.
>
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/smb2pdu.c | 45 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 44 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 5cc5f6c..5581afd 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -48,6 +48,7 @@
>  #include "smb2glob.h"
>  #include "cifspdu.h"
>  #include "cifs_spnego.h"
> +#include "smbdirect.h"
>
>  /*
>   *  The following table defines the expected "StructureSize" of SMB2 requests
> @@ -2716,6 +2717,41 @@ smb2_async_writev(struct cifs_writedata *wdata,
>  				offsetof(struct smb2_write_req, Buffer) - 4);
>  	req->RemainingBytes = 0;
>
> +	/*
> +	 * If we want to do a server RDMA read, fill in and append
> +	 * smbd_buffer_descriptor_v1 to the end of write request
> +	 */
> +	if (server->rdma && wdata->bytes >
> +		server->smbd_conn->rdma_readwrite_threshold) {
> +
> +		struct smbd_buffer_descriptor_v1 *v1;
> +		bool need_invalidate = server->dialect == SMB30_PROT_ID;
> +
> +		wdata->mr = smbd_register_mr(
> +				server->smbd_conn, wdata->pages,
> +				wdata->nr_pages, wdata->tailsz,
> +				false, need_invalidate);
> +		if (!wdata->mr) {
> +			rc = -ENOBUFS;
> +			goto async_writev_out;
> +		}
> +		req->Length = 0;
> +		req->DataOffset = 0;
> +		req->RemainingBytes =

Wow, we have CamelCase variables in linux kernel. It will help if you
start your patchset with small cleanup to convert those variables from
CamelCase to normal names.

Thanks

> +			(wdata->nr_pages-1)*PAGE_SIZE + wdata->tailsz;
> +		req->Channel = SMB2_CHANNEL_RDMA_V1_INVALIDATE;
> +		if (need_invalidate)
> +			req->Channel = SMB2_CHANNEL_RDMA_V1;
> +		req->WriteChannelInfoOffset =
> +			offsetof(struct smb2_write_req, Buffer) - 4;
> +		req->WriteChannelInfoLength =
> +			sizeof(struct smbd_buffer_descriptor_v1);
> +		v1 = (struct smbd_buffer_descriptor_v1 *) &req->Buffer[0];
> +		v1->offset = wdata->mr->mr->iova;
> +		v1->token = wdata->mr->mr->rkey;
> +		v1->length = wdata->mr->mr->length;
> +	}
> +
>  	/* 4 for rfc1002 length field and 1 for Buffer */
>  	iov[0].iov_len = 4;
>  	iov[0].iov_base = req;
> @@ -2729,10 +2765,17 @@ smb2_async_writev(struct cifs_writedata *wdata,
>  	rqst.rq_pagesz = wdata->pagesz;
>  	rqst.rq_tailsz = wdata->tailsz;
>
> +	if (wdata->mr) {
> +		iov[1].iov_len += sizeof(struct smbd_buffer_descriptor_v1);
> +		rqst.rq_npages = 0;
> +	}
> +
>  	cifs_dbg(FYI, "async write at %llu %u bytes\n",
>  		 wdata->offset, wdata->bytes);
>
> -	req->Length = cpu_to_le32(wdata->bytes);
> +	/* For RDMA read, I/O size is in RemainingBytes not in Length */
> +	if (!wdata->mr)
> +		req->Length = cpu_to_le32(wdata->bytes);
>
>  	inc_rfc1001_len(&req->hdr, wdata->bytes - 1 /* Buffer */);
>
> --
> 2.7.4
>

--zYX8XqlwBJQgDxCD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmdiIAACgkQ5GN7iDZy
WKdIgBAAglhJ6zOlMZbvh4KNHlyRnn2nCSJIHgoanQRWEsg/FVP2eEfXvTyzKKWd
NY05ykojFEcHEgPI3Zct8ZSDQj6z1w8dCTyGY/7SweDypft2PmgdAQbHwF8YxlpG
g9pNCQO3gSK+/sjjKcuwj0tWP87XAumKFG+d2DhT9IarciTqsMmNgYK6mgbvAKCy
orQI7sw7ZwDPlTZmh5y3Pidd0luh2U3kWH+OTc0HlEIT8Jmmtc9SkHb423+Aapb8
SPy6WXmsJUUoWYiHuusWhElNdvHWkjz9QolPCXMVNBCoC1/65pSwmQXCgIj+egar
6rMHQyy6Dttx0UFCaz8ev9P96bj3zASXzKwa0PqYXHInpFuKahYt9lAN7gBZ0trp
kQys3cTWf1Ab9fTeqlo/c/8pVv+P4LWgBg5yNDKHKc5Jwvk9ThnhqS7mFJndDieG
cUNk3pHXIBPD8cmFL0km1+4oIGI6Vy7rlfKUBqLBqr7K/zBbI9Be4mIz5KioVG7s
aDtS6YSvfIfAJGRQfJlVqeG4RVRswP++2WN8TkjCC/N7K3A7xgh5mqOFIMclZ9sD
7eiK7lDUH+sTUSDwp0qcQBUDuikVQgxuUAPr+4wwOTkGS6Eo1whACC6qEyirjfUN
GW3nroEUZeetbwJCqpvlypKn6nM2ALX36ABkDASAMWQqs0plD34=
=uzUa
-----END PGP SIGNATURE-----

--zYX8XqlwBJQgDxCD--
