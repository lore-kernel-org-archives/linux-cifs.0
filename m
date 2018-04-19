From: "Michael Kelley (EOSG)" <Michael.H.Kelley@microsoft.com>
Subject: RE: [Patch v2 2/6] cifs: Allocate validate negotiation request
 through kmalloc
Date: Thu, 19 Apr 2018 00:45:14 +0000
Message-ID: <DM5PR2101MB1030884AD39F91A77BC0E16EDCB50@DM5PR2101MB1030.namprd21.prod.outlook.com>
References: <20180417191710.14855-1-longli@linuxonhyperv.com>
 <20180417191710.14855-2-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>
To: Long Li <longli@microsoft.com>, Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180417191710.14855-2-longli@linuxonhyperv.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org <linux-kernel-owner@vger.kernel.=
org> On Behalf
> Of Long Li
> Sent: Tuesday, April 17, 2018 12:17 PM
> To: Steve French <sfrench@samba.org>; linux-cifs@vger.kernel.org; samba-
> technical@lists.samba.org; linux-kernel@vger.kernel.org; linux-rdma@vger.=
kernel.org
> Cc: Long Li <longli@microsoft.com>; stable@vger.kernel.org
> Subject: [Patch v2 2/6] cifs: Allocate validate negotiation request throu=
gh kmalloc
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
> Fixes: ff1c038addc4f205d5f1ede449426c7d316c0eed "Check SMB3 dialects agai=
nst
> downgrade attacks"
>=20
> Changes in v2:
> Removed duplicated code on freeing buffers on function exit.
> (Thanks to Parav Pandit <parav@mellanox.com>)
>=20
> Fixed typo in the patch title.
>=20
> Signed-off-by: Long Li <longli@microsoft.com>
> Cc: stable@vger.kernel.org
> ---
>  fs/cifs/smb2pdu.c | 57 ++++++++++++++++++++++++++++++-------------------=
------
>  1 file changed, 31 insertions(+), 26 deletions(-)
>=20
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 0f044c4..41625e4 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -729,8 +729,8 @@ SMB2_negotiate(const unsigned int xid, struct cifs_se=
s *ses)
>=20
>  int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tc=
on)
>  {
> -	int rc =3D 0;
> -	struct validate_negotiate_info_req vneg_inbuf;
> +	int ret, rc =3D -EIO;
> +	struct validate_negotiate_info_req *pneg_inbuf;
>  	struct validate_negotiate_info_rsp *pneg_rsp =3D NULL;
>  	u32 rsplen;
>  	u32 inbuflen; /* max of 4 dialects */
> @@ -741,6 +741,9 @@ int smb3_validate_negotiate(const unsigned int xid, s=
truct cifs_tcon
> *tcon)
>  	if (tcon->ses->server->rdma)
>  		return 0;
>  #endif
> +	pneg_inbuf =3D kmalloc(sizeof(*pneg_inbuf), GFP_KERNEL);
> +	if (!pneg_inbuf)
> +		return -ENOMEM;

Immediately after the above new code, there are three if statements that ca=
n
'return 0' and never free the pneg_inbuf memory.  They should instead set '=
rc'
appropriately and 'goto' the out_free_inbuf label.

Michael

>=20
>  	/* In SMB3.11 preauth integrity supersedes validate negotiate */
>  	if (tcon->ses->server->dialect =3D=3D SMB311_PROT_ID)
> @@ -764,53 +767,53 @@ int smb3_validate_negotiate(const unsigned int xid,=
 struct cifs_tcon
> *tcon)
>  	if (tcon->ses->session_flags & SMB2_SESSION_FLAG_IS_NULL)
>  		cifs_dbg(VFS, "Unexpected null user (anonymous) auth flag sent by serv=
er\n");
>=20
> -	vneg_inbuf.Capabilities =3D
> +	pneg_inbuf->Capabilities =3D
>  			cpu_to_le32(tcon->ses->server->vals->req_capabilities);
> -	memcpy(vneg_inbuf.Guid, tcon->ses->server->client_guid,
> +	memcpy(pneg_inbuf->Guid, tcon->ses->server->client_guid,
>  					SMB2_CLIENT_GUID_SIZE);
>=20
>  	if (tcon->ses->sign)
> -		vneg_inbuf.SecurityMode =3D
> +		pneg_inbuf->SecurityMode =3D
>  			cpu_to_le16(SMB2_NEGOTIATE_SIGNING_REQUIRED);
>  	else if (global_secflags & CIFSSEC_MAY_SIGN)
> -		vneg_inbuf.SecurityMode =3D
> +		pneg_inbuf->SecurityMode =3D
>  			cpu_to_le16(SMB2_NEGOTIATE_SIGNING_ENABLED);
>  	else
> -		vneg_inbuf.SecurityMode =3D 0;
> +		pneg_inbuf->SecurityMode =3D 0;
>=20
>=20
>  	if (strcmp(tcon->ses->server->vals->version_string,
>  		SMB3ANY_VERSION_STRING) =3D=3D 0) {
> -		vneg_inbuf.Dialects[0] =3D cpu_to_le16(SMB30_PROT_ID);
> -		vneg_inbuf.Dialects[1] =3D cpu_to_le16(SMB302_PROT_ID);
> -		vneg_inbuf.DialectCount =3D cpu_to_le16(2);
> +		pneg_inbuf->Dialects[0] =3D cpu_to_le16(SMB30_PROT_ID);
> +		pneg_inbuf->Dialects[1] =3D cpu_to_le16(SMB302_PROT_ID);
> +		pneg_inbuf->DialectCount =3D cpu_to_le16(2);
>  		/* structure is big enough for 3 dialects, sending only 2 */
>  		inbuflen =3D sizeof(struct validate_negotiate_info_req) - 2;
>  	} else if (strcmp(tcon->ses->server->vals->version_string,
>  		SMBDEFAULT_VERSION_STRING) =3D=3D 0) {
> -		vneg_inbuf.Dialects[0] =3D cpu_to_le16(SMB21_PROT_ID);
> -		vneg_inbuf.Dialects[1] =3D cpu_to_le16(SMB30_PROT_ID);
> -		vneg_inbuf.Dialects[2] =3D cpu_to_le16(SMB302_PROT_ID);
> -		vneg_inbuf.DialectCount =3D cpu_to_le16(3);
> +		pneg_inbuf->Dialects[0] =3D cpu_to_le16(SMB21_PROT_ID);
> +		pneg_inbuf->Dialects[1] =3D cpu_to_le16(SMB30_PROT_ID);
> +		pneg_inbuf->Dialects[2] =3D cpu_to_le16(SMB302_PROT_ID);
> +		pneg_inbuf->DialectCount =3D cpu_to_le16(3);
>  		/* structure is big enough for 3 dialects */
>  		inbuflen =3D sizeof(struct validate_negotiate_info_req);
>  	} else {
>  		/* otherwise specific dialect was requested */
> -		vneg_inbuf.Dialects[0] =3D
> +		pneg_inbuf->Dialects[0] =3D
>  			cpu_to_le16(tcon->ses->server->vals->protocol_id);
> -		vneg_inbuf.DialectCount =3D cpu_to_le16(1);
> +		pneg_inbuf->DialectCount =3D cpu_to_le16(1);
>  		/* structure is big enough for 3 dialects, sending only 1 */
>  		inbuflen =3D sizeof(struct validate_negotiate_info_req) - 4;
>  	}
>=20
> -	rc =3D SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
> +	ret =3D SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>  		FSCTL_VALIDATE_NEGOTIATE_INFO, true /* is_fsctl */,
> -		(char *)&vneg_inbuf, sizeof(struct validate_negotiate_info_req),
> +		(char *)pneg_inbuf, sizeof(struct validate_negotiate_info_req),
>  		(char **)&pneg_rsp, &rsplen);
>=20
> -	if (rc !=3D 0) {
> -		cifs_dbg(VFS, "validate protocol negotiate failed: %d\n", rc);
> -		return -EIO;
> +	if (ret !=3D 0) {
> +		cifs_dbg(VFS, "validate protocol negotiate failed: %d\n", ret);
> +		goto out_free_inbuf;
>  	}
>=20
>  	if (rsplen !=3D sizeof(struct validate_negotiate_info_rsp)) {
> @@ -820,7 +823,7 @@ int smb3_validate_negotiate(const unsigned int xid, s=
truct cifs_tcon
> *tcon)
>  		/* relax check since Mac returns max bufsize allowed on ioctl */
>  		if ((rsplen > CIFSMaxBufSize)
>  		     || (rsplen < sizeof(struct validate_negotiate_info_rsp)))
> -			goto err_rsp_free;
> +			goto out_free_rsp;
>  	}
>=20
>  	/* check validate negotiate info response matches what we got earlier *=
/
> @@ -838,14 +841,16 @@ int smb3_validate_negotiate(const unsigned int xid,=
 struct cifs_tcon
> *tcon)
>=20
>  	/* validate negotiate successful */
>  	cifs_dbg(FYI, "validate negotiate info successful\n");
> -	kfree(pneg_rsp);
> -	return 0;
> +	rc =3D 0;
> +	goto out_free_rsp;
>=20
>  vneg_out:
>  	cifs_dbg(VFS, "protocol revalidation - security settings mismatch\n");
> -err_rsp_free:
> +out_free_rsp:
>  	kfree(pneg_rsp);
> -	return -EIO;
> +out_free_inbuf:
> +	kfree(pneg_inbuf);
> +	return rc;
>  }
>=20
>  enum securityEnum
> --
> 2.7.4
