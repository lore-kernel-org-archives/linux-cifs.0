From: Parav Pandit <parav@mellanox.com>
Subject: RE: [PATCH 2/6] cifs: Allocate validate negoation request through
 kmalloc
Date: Tue, 17 Apr 2018 04:01:06 +0000
Message-ID: <VI1PR0502MB300847394E1E25FADDCC0BB7D1B70@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20180417004918.29213-1-longli@linuxonhyperv.com>
 <20180417004918.29213-2-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: longli <longli@microsoft.com>, Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180417004918.29213-2-longli@linuxonhyperv.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org [mailto:linux-rdma-
> owner@vger.kernel.org] On Behalf Of Long Li
> Sent: Monday, April 16, 2018 7:49 PM
> To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org; samba-
> technical@lists.samba.org; linux-kernel@vger.kernel.org; linux-
> rdma@vger.kernel.org; stable@vger.kernel.org
> Cc: longli <longli@microsoft.com>
> Subject: [PATCH 2/6] cifs: Allocate validate negoation request through km=
alloc
>=20
> From: Long Li <longli@microsoft.com>
>=20
> The data buffer allocated on the stack can't be DMA'ed, and hence can't s=
end
> through RDMA via SMB Direct.
>=20
> Fix this by allocating the request on the heap in smb3_validate_negotiate=
.
>=20
Please provide Fixes ("12-letters commit id") "commit string" which introdu=
ced this issue and it is getting fixed here, so that other can apply this f=
ix to older versions.

> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/smb2pdu.c | 38 ++++++++++++++++++++++----------------
>  1 file changed, 22 insertions(+), 16 deletions(-)
>=20
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c index 0f044c4..abbefe2
> 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -730,7 +730,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_se=
s
> *ses)  int smb3_validate_negotiate(const unsigned int xid, struct cifs_tc=
on
> *tcon)  {
>  	int rc =3D 0;
> -	struct validate_negotiate_info_req vneg_inbuf;
> +	struct validate_negotiate_info_req *pneg_inbuf;
[..]
=20
>  	rc =3D SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>  		FSCTL_VALIDATE_NEGOTIATE_INFO, true /* is_fsctl */,
> -		(char *)&vneg_inbuf, sizeof(struct
> validate_negotiate_info_req),
> +		(char *)pneg_inbuf, sizeof(struct validate_negotiate_info_req),
>  		(char **)&pneg_rsp, &rsplen);
>=20
>  	if (rc !=3D 0) {
>  		cifs_dbg(VFS, "validate protocol negotiate failed: %d\n", rc);
> +		kfree(pneg_inbuf);
>  		return -EIO;
Instead of duplicating code here, please jump to err_rsp_free label. Kfree(=
) takes care to not panic for NULL pointer.
Or for clarity define new label.

>  	}
>=20
> @@ -838,12 +842,14 @@ int smb3_validate_negotiate(const unsigned int xid,
> struct cifs_tcon *tcon)
>=20
>  	/* validate negotiate successful */
>  	cifs_dbg(FYI, "validate negotiate info successful\n");
> +	kfree(pneg_inbuf);
>  	kfree(pneg_rsp);
>  	return 0;
>=20
>  vneg_out:
>  	cifs_dbg(VFS, "protocol revalidation - security settings mismatch\n");
>  err_rsp_free:
> +	kfree(pneg_inbuf);
>  	kfree(pneg_rsp);
>  	return -EIO;
>  }
> --
> 2.7.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in =
the body
> of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
