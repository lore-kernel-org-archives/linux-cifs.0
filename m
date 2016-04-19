From: Jeff Layton <jlayton@poochiereds.net>
Subject: Re: [PATCH 2/6] cifs: merge the hash calculation helpers
Date: Tue, 19 Apr 2016 12:12:34 -0400
Message-ID: <1461082354.15135.6.camel@poochiereds.net>
References: <20160409204301.GF25498@ZenIV.linux.org.uk>
	 <20160409205056.GH25498@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>, linux-cifs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160409205056.GH25498@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Sat, 2016-04-09 at 21:50 +0100, Al Viro wrote:
> three practically identical copies...
>=20
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> =C2=A0fs/cifs/cifsencrypt.c=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A097 ++++++++=
++++++++++++++++-------------------
> =C2=A0fs/cifs/cifsproto.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A0=C2=
=A03 ++
> =C2=A0fs/cifs/smb2transport.c | 107 +++++----------------------------=
---------------
> =C2=A03 files changed, 67 insertions(+), 140 deletions(-)
>=20
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 4897dac..6aeb8d4 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -66,45 +66,15 @@ cifs_crypto_shash_md5_allocate(struct TCP_Server_=
Info *server)
> =C2=A0	return 0;
> =C2=A0}
> =C2=A0
> -/*
> - * Calculate and return the CIFS signature based on the mac key and =
SMB PDU.
> - * The 16 byte signature must be allocated by the caller. Note we on=
ly use the
> - * 1st eight bytes and that the smb header signature field on input =
contains
> - * the sequence number before this function is called. Also, this fu=
nction
> - * should be called with the server->srv_mutex held.
> - */
> -static int cifs_calc_signature(struct smb_rqst *rqst,
> -			struct TCP_Server_Info *server, char *signature)
> +int __cifs_calc_signature(struct smb_rqst *rqst,
> +			struct TCP_Server_Info *server, char *signature,
> +			struct shash_desc *shash)
> =C2=A0{
> =C2=A0	int i;
> =C2=A0	int rc;
> =C2=A0	struct kvec *iov =3D rqst->rq_iov;
> =C2=A0	int n_vec =3D rqst->rq_nvec;
> =C2=A0
> -	if (iov =3D=3D NULL || signature =3D=3D NULL || server =3D=3D NULL)
> -		return -EINVAL;
> -
> -	if (!server->secmech.sdescmd5) {
> -		rc =3D cifs_crypto_shash_md5_allocate(server);
> -		if (rc) {
> -			cifs_dbg(VFS, "%s: Can't alloc md5 crypto\n", __func__);
> -			return -1;
> -		}
> -	}
> -
> -	rc =3D crypto_shash_init(&server->secmech.sdescmd5->shash);
> -	if (rc) {
> -		cifs_dbg(VFS, "%s: Could not init md5\n", __func__);
> -		return rc;
> -	}
> -
> -	rc =3D crypto_shash_update(&server->secmech.sdescmd5->shash,
> -		server->session_key.response, server->session_key.len);
> -	if (rc) {
> -		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
> -		return rc;
> -	}
> -
> =C2=A0	for (i =3D 0; i < n_vec; i++) {
> =C2=A0		if (iov[i].iov_len =3D=3D 0)
> =C2=A0			continue;
> @@ -117,12 +87,10 @@ static int cifs_calc_signature(struct smb_rqst *=
rqst,
> =C2=A0		if (i =3D=3D 0) {
> =C2=A0			if (iov[0].iov_len <=3D 8) /* cmd field at offset 9 */
> =C2=A0				break; /* nothing to sign or corrupt header */
> -			rc =3D
> -			crypto_shash_update(&server->secmech.sdescmd5->shash,
> +			rc =3D crypto_shash_update(shash,
> =C2=A0				iov[i].iov_base + 4, iov[i].iov_len - 4);
> =C2=A0		} else {
> -			rc =3D
> -			crypto_shash_update(&server->secmech.sdescmd5->shash,
> +			rc =3D crypto_shash_update(shash,
> =C2=A0				iov[i].iov_base, iov[i].iov_len);
> =C2=A0		}
> =C2=A0		if (rc) {
> @@ -134,21 +102,64 @@ static int cifs_calc_signature(struct smb_rqst =
*rqst,
> =C2=A0
> =C2=A0	/* now hash over the rq_pages array */
> =C2=A0	for (i =3D 0; i < rqst->rq_npages; i++) {
> -		struct kvec p_iov;
> +		void *kaddr =3D kmap(rqst->rq_pages[i]);
> +		size_t len =3D rqst->rq_pagesz;
> +
> +		if (i =3D=3D rqst->rq_npages - 1)
> +			len =3D rqst->rq_tailsz;
> +
> +		crypto_shash_update(shash, kaddr, len);
> =C2=A0
> -		cifs_rqst_page_to_kvec(rqst, i, &p_iov);
> -		crypto_shash_update(&server->secmech.sdescmd5->shash,
> -					p_iov.iov_base, p_iov.iov_len);
> =C2=A0		kunmap(rqst->rq_pages[i]);
> =C2=A0	}
> =C2=A0
> -	rc =3D crypto_shash_final(&server->secmech.sdescmd5->shash, signatu=
re);
> +	rc =3D crypto_shash_final(shash, signature);
> =C2=A0	if (rc)
> -		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
> +		cifs_dbg(VFS, "%s: Could not generate hash\n", __func__);
> =C2=A0
> =C2=A0	return rc;
> =C2=A0}
> =C2=A0
> +/*
> + * Calculate and return the CIFS signature based on the mac key and =
SMB PDU.
> + * The 16 byte signature must be allocated by the caller. Note we on=
ly use the
> + * 1st eight bytes and that the smb header signature field on input =
contains
> + * the sequence number before this function is called. Also, this fu=
nction
> + * should be called with the server->srv_mutex held.
> + */
> +static int cifs_calc_signature(struct smb_rqst *rqst,
> +			struct TCP_Server_Info *server, char *signature)
> +{
> +	int rc;
> +
> +	if (!rqst->rq_iov || !signature || !server)
> +		return -EINVAL;
> +
> +	if (!server->secmech.sdescmd5) {
> +		rc =3D cifs_crypto_shash_md5_allocate(server);
> +		if (rc) {
> +			cifs_dbg(VFS, "%s: Can't alloc md5 crypto\n", __func__);
> +			return -1;
> +		}
> +	}
> +
> +	rc =3D crypto_shash_init(&server->secmech.sdescmd5->shash);
> +	if (rc) {
> +		cifs_dbg(VFS, "%s: Could not init md5\n", __func__);
> +		return rc;
> +	}
> +
> +	rc =3D crypto_shash_update(&server->secmech.sdescmd5->shash,
> +		server->session_key.response, server->session_key.len);
> +	if (rc) {
> +		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
> +		return rc;
> +	}
> +
> +	return __cifs_calc_signature(rqst, server, signature,
> +				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0&server->secmech.sdescmd5->shash);
> +}
> +
> =C2=A0/* must be called with server->srv_mutex held */
> =C2=A0int cifs_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Inf=
o *server,
> =C2=A0		=C2=A0=C2=A0=C2=A0__u32 *pexpected_response_sequence_number)
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index eed7ff5..d9b4f44 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -512,4 +512,7 @@ int cifs_create_mf_symlink(unsigned int xid, stru=
ct cifs_tcon *tcon,
> =C2=A0			=C2=A0=C2=A0=C2=A0struct cifs_sb_info *cifs_sb,
> =C2=A0			=C2=A0=C2=A0=C2=A0const unsigned char *path, char *pbuf,
> =C2=A0			=C2=A0=C2=A0=C2=A0unsigned int *pbytes_written);
> +int __cifs_calc_signature(struct smb_rqst *rqst,
> +			struct TCP_Server_Info *server, char *signature,
> +			struct shash_desc *shash);
> =C2=A0#endif			/* _CIFSPROTO_H */
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index 8732a43..bc9a7b6 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -135,11 +135,10 @@ smb2_find_smb_ses(struct smb2_hdr *smb2hdr, str=
uct TCP_Server_Info *server)
> =C2=A0int
> =C2=A0smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_In=
fo *server)
> =C2=A0{
> -	int i, rc;
> +	int rc;
> =C2=A0	unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
> =C2=A0	unsigned char *sigptr =3D smb2_signature;
> =C2=A0	struct kvec *iov =3D rqst->rq_iov;
> -	int n_vec =3D rqst->rq_nvec;
> =C2=A0	struct smb2_hdr *smb2_pdu =3D (struct smb2_hdr *)iov[0].iov_ba=
se;
> =C2=A0	struct cifs_ses *ses;
> =C2=A0
> @@ -171,53 +170,11 @@ smb2_calc_signature(struct smb_rqst *rqst, stru=
ct TCP_Server_Info *server)
> =C2=A0		return rc;
> =C2=A0	}
> =C2=A0
> -	for (i =3D 0; i < n_vec; i++) {
> -		if (iov[i].iov_len =3D=3D 0)
> -			continue;
> -		if (iov[i].iov_base =3D=3D NULL) {
> -			cifs_dbg(VFS, "null iovec entry\n");
> -			return -EIO;
> -		}
> -		/*
> -		=C2=A0* The first entry includes a length field (which does not ge=
t
> -		=C2=A0* signed that occupies the first 4 bytes before the header).
> -		=C2=A0*/
> -		if (i =3D=3D 0) {
> -			if (iov[0].iov_len <=3D 8) /* cmd field at offset 9 */
> -				break; /* nothing to sign or corrupt header */
> -			rc =3D
> -			crypto_shash_update(
> -				&server->secmech.sdeschmacsha256->shash,
> -				iov[i].iov_base + 4, iov[i].iov_len - 4);
> -		} else {
> -			rc =3D
> -			crypto_shash_update(
> -				&server->secmech.sdeschmacsha256->shash,
> -				iov[i].iov_base, iov[i].iov_len);
> -		}
> -		if (rc) {
> -			cifs_dbg(VFS, "%s: Could not update with payload\n",
> -				=C2=A0__func__);
> -			return rc;
> -		}
> -	}
> -
> -	/* now hash over the rq_pages array */
> -	for (i =3D 0; i < rqst->rq_npages; i++) {
> -		struct kvec p_iov;
> -
> -		cifs_rqst_page_to_kvec(rqst, i, &p_iov);
> -		crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
> -					p_iov.iov_base, p_iov.iov_len);
> -		kunmap(rqst->rq_pages[i]);
> -	}
> -
> -	rc =3D crypto_shash_final(&server->secmech.sdeschmacsha256->shash,
> -				sigptr);
> -	if (rc)
> -		cifs_dbg(VFS, "%s: Could not generate sha256 hash\n", __func__);
> +	rc =3D __cifs_calc_signature(rqst, server, sigptr,
> +		&server->secmech.sdeschmacsha256->shash);
> =C2=A0
> -	memcpy(smb2_pdu->Signature, sigptr, SMB2_SIGNATURE_SIZE);
> +	if (!rc)
> +		memcpy(smb2_pdu->Signature, sigptr, SMB2_SIGNATURE_SIZE);
> =C2=A0
> =C2=A0	return rc;
> =C2=A0}
> @@ -395,12 +352,10 @@ generate_smb311signingkey(struct cifs_ses *ses)
> =C2=A0int
> =C2=A0smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_In=
fo *server)
> =C2=A0{
> -	int i;
> =C2=A0	int rc =3D 0;
> =C2=A0	unsigned char smb3_signature[SMB2_CMACAES_SIZE];
> =C2=A0	unsigned char *sigptr =3D smb3_signature;
> =C2=A0	struct kvec *iov =3D rqst->rq_iov;
> -	int n_vec =3D rqst->rq_nvec;
> =C2=A0	struct smb2_hdr *smb2_pdu =3D (struct smb2_hdr *)iov[0].iov_ba=
se;
> =C2=A0	struct cifs_ses *ses;
> =C2=A0
> @@ -431,54 +386,12 @@ smb3_calc_signature(struct smb_rqst *rqst, stru=
ct TCP_Server_Info *server)
> =C2=A0		cifs_dbg(VFS, "%s: Could not init cmac aes\n", __func__);
> =C2=A0		return rc;
> =C2=A0	}
> +=09
> +	rc =3D __cifs_calc_signature(rqst, server, sigptr,
> +				=C2=A0=C2=A0=C2=A0&server->secmech.sdesccmacaes->shash);
> =C2=A0
> -	for (i =3D 0; i < n_vec; i++) {
> -		if (iov[i].iov_len =3D=3D 0)
> -			continue;
> -		if (iov[i].iov_base =3D=3D NULL) {
> -			cifs_dbg(VFS, "null iovec entry");
> -			return -EIO;
> -		}
> -		/*
> -		=C2=A0* The first entry includes a length field (which does not ge=
t
> -		=C2=A0* signed that occupies the first 4 bytes before the header).
> -		=C2=A0*/
> -		if (i =3D=3D 0) {
> -			if (iov[0].iov_len <=3D 8) /* cmd field at offset 9 */
> -				break; /* nothing to sign or corrupt header */
> -			rc =3D
> -			crypto_shash_update(
> -				&server->secmech.sdesccmacaes->shash,
> -				iov[i].iov_base + 4, iov[i].iov_len - 4);
> -		} else {
> -			rc =3D
> -			crypto_shash_update(
> -				&server->secmech.sdesccmacaes->shash,
> -				iov[i].iov_base, iov[i].iov_len);
> -		}
> -		if (rc) {
> -			cifs_dbg(VFS, "%s: Couldn't update cmac aes with payload\n",
> -							__func__);
> -			return rc;
> -		}
> -	}
> -
> -	/* now hash over the rq_pages array */
> -	for (i =3D 0; i < rqst->rq_npages; i++) {
> -		struct kvec p_iov;
> -
> -		cifs_rqst_page_to_kvec(rqst, i, &p_iov);
> -		crypto_shash_update(&server->secmech.sdesccmacaes->shash,
> -					p_iov.iov_base, p_iov.iov_len);
> -		kunmap(rqst->rq_pages[i]);
> -	}
> -
> -	rc =3D crypto_shash_final(&server->secmech.sdesccmacaes->shash,
> -						sigptr);
> -	if (rc)
> -		cifs_dbg(VFS, "%s: Could not generate cmac aes\n", __func__);
> -
> -	memcpy(smb2_pdu->Signature, sigptr, SMB2_SIGNATURE_SIZE);
> +	if (!rc)
> +		memcpy(smb2_pdu->Signature, sigptr, SMB2_SIGNATURE_SIZE);
> =C2=A0
> =C2=A0	return rc;
> =C2=A0}

Nice. Long overdue cleanup.

Reviewed-by: Jeff Layton <jlayton@poochiereds.net>
