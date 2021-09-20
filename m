Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8537CC433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 15:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C5A661107
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Sep 2021 15:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241746AbhITPjt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 11:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241816AbhITPji (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 11:39:38 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E567C061764
        for <linux-cifs@vger.kernel.org>; Mon, 20 Sep 2021 08:38:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=bZwXyNhOvQzirTHPmLDQ4NvJ/5/S6sDujUB7Ilksbbk=; b=ih17e8cnSxUpkq7dwBKw9Aw6iw
        z1VC43d5E+itRVdW64/lN5qdH6L9faL6T1i5O86AyBbk5d2Fa1qI02isWwadpV3TxwQSZ4QXuCQPO
        QUv/grZlbYkRED9ROREfGTJ7vlNh/Piyosd8GwvHt8kwx24aTfpNcI1ZHXnAqDXrr/UDiEzcG9/f5
        FNkzqfag+KEYsprVF35RRbP1SiXAR0la4rKqV1mGIqAGjCUmnhH9SOMwsUq5pcIbCWxMzigKAmp5J
        oOrvLleSKdPSo0ZXQRtjLE8zrb8drq7/TaQmX0MXDgi6FRD4zHIwYurbJwDLWShcmWMa9ByjRJ96W
        V2N3XOPTYXvnRfS7ZIMhROISbBSNBl/AMpA2sferUC6LMqeC9R09d6paZi8uKWYeRY6HFeEZzJZ6g
        oRu9VHSDOe/2YTVf16j4KDDHyDwJTMeRbZhUDis/EUEuUt8PfsYXirxyikPGZby/MaZOLxtN6z4UL
        3C/hCZxAprbHYDPksU7enuw9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mSLMv-0070V0-E9; Mon, 20 Sep 2021 15:38:09 +0000
Subject: Re: [PATCH v2 1/4] ksmbd: add request buffer validation in
 smb2_set_info
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org
References: <20210919021315.642856-1-linkinjeon@kernel.org>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <7f51fab9-ff31-aee0-aee2-e91e8bc45d07@samba.org>
Date:   Mon, 20 Sep 2021 17:38:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210919021315.642856-1-linkinjeon@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fV9LhnbvJnAivET8WWhvePEb0CdyEp75M"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fV9LhnbvJnAivET8WWhvePEb0CdyEp75M
Content-Type: multipart/mixed; boundary="NvVfvNYjjBhfa8Xv5ASNBdHJCMyBFIXIH";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Message-ID: <7f51fab9-ff31-aee0-aee2-e91e8bc45d07@samba.org>
Subject: Re: [PATCH v2 1/4] ksmbd: add request buffer validation in
 smb2_set_info
References: <20210919021315.642856-1-linkinjeon@kernel.org>
In-Reply-To: <20210919021315.642856-1-linkinjeon@kernel.org>

--NvVfvNYjjBhfa8Xv5ASNBdHJCMyBFIXIH
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Namjae,

patch looks great, a few nitpicks inline...

Am 19.09.21 um 04:13 schrieb Namjae Jeon:
> Add buffer validation in smb2_set_info.
>=20
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/ksmbd/smb2pdu.c | 113 +++++++++++++++++++++++++++++++++++---------=
-
>   fs/ksmbd/smb2pdu.h |   9 ++++
>   2 files changed, 97 insertions(+), 25 deletions(-)
>=20
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 46e0275a77a8..7763f69e1ae8 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -2107,17 +2107,23 @@ static noinline int create_smb2_pipe(struct ksm=
bd_work *work)
>    * smb2_set_ea() - handler for setting extended attributes using set
>    *		info command
>    * @eabuf:	set info command buffer
> + * @buf_len:	set info command buffer length
>    * @path:	dentry path for get ea
>    *
>    * Return:	0 on success, otherwise error
>    */
> -static int smb2_set_ea(struct smb2_ea_info *eabuf, struct path *path)
> +static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_le=
n,
> +		       struct path *path)
>   {
>   	struct user_namespace *user_ns =3D mnt_user_ns(path->mnt);
>   	char *attr_name =3D NULL, *value;
>   	int rc =3D 0;
>   	int next =3D 0;
>  =20
> +	if (buf_len < sizeof(struct smb2_ea_info) + eabuf->EaNameLength +
> +			le16_to_cpu(eabuf->EaValueLength))
> +		return -EINVAL;
> +
>   	attr_name =3D kmalloc(XATTR_NAME_MAX + 1, GFP_KERNEL);
>   	if (!attr_name)
>   		return -ENOMEM;
> @@ -2181,7 +2187,13 @@ static int smb2_set_ea(struct smb2_ea_info *eabu=
f, struct path *path)
>  =20
>   next:
>   		next =3D le32_to_cpu(eabuf->NextEntryOffset);
> +		if (next =3D=3D 0 || buf_len < next)
> +			break;
> +		buf_len -=3D next;
>   		eabuf =3D (struct smb2_ea_info *)((char *)eabuf + next);
> +		if (next < eabuf->EaNameLength + le16_to_cpu(eabuf->EaValueLength))
> +			break;
> +
>   	} while (next !=3D 0);
>  =20
>   	kfree(attr_name);
> @@ -2790,7 +2802,9 @@ int smb2_open(struct ksmbd_work *work)
>   		created =3D true;
>   		user_ns =3D mnt_user_ns(path.mnt);
>   		if (ea_buf) {
> -			rc =3D smb2_set_ea(&ea_buf->ea, &path);
> +			rc =3D smb2_set_ea(&ea_buf->ea,
> +					 le32_to_cpu(ea_buf->ccontext.DataLength),
> +					 &path);
>   			if (rc =3D=3D -EOPNOTSUPP)
>   				rc =3D 0;
>   			else if (rc)
> @@ -5375,7 +5389,7 @@ static int smb2_rename(struct ksmbd_work *work,
>   static int smb2_create_link(struct ksmbd_work *work,
>   			    struct ksmbd_share_config *share,
>   			    struct smb2_file_link_info *file_info,
> -			    struct file *filp,
> +			    int buf_len, struct file *filp,
>   			    struct nls_table *local_nls)
>   {
>   	char *link_name =3D NULL, *target_name =3D NULL, *pathname =3D NULL;=

> @@ -5383,6 +5397,10 @@ static int smb2_create_link(struct ksmbd_work *w=
ork,
>   	bool file_present =3D true;
>   	int rc;
>  =20
> +	if (buf_len < sizeof(struct smb2_file_link_info) +
> +			le32_to_cpu(file_info->FileNameLength))
> +		return -EINVAL;
> +
>   	ksmbd_debug(SMB, "setting FILE_LINK_INFORMATION\n");
>   	pathname =3D kmalloc(PATH_MAX, GFP_KERNEL);
>   	if (!pathname)
> @@ -5442,7 +5460,7 @@ static int smb2_create_link(struct ksmbd_work *wo=
rk,
>   static int set_file_basic_info(struct ksmbd_file *fp, char *buf,
>   			       struct ksmbd_share_config *share)
>   {
> -	struct smb2_file_all_info *file_info;
> +	struct smb2_file_basic_info *file_info;

this change should be moved to a seperate commit.

>   	struct iattr attrs;
>   	struct timespec64 ctime;
>   	struct file *filp;
> @@ -5453,7 +5471,7 @@ static int set_file_basic_info(struct ksmbd_file =
*fp, char *buf,
>   	if (!(fp->daccess & FILE_WRITE_ATTRIBUTES_LE))
>   		return -EACCES;
>  =20
> -	file_info =3D (struct smb2_file_all_info *)buf;
> +	file_info =3D (struct smb2_file_basic_info *)buf;

same here.

>   	attrs.ia_valid =3D 0;
>   	filp =3D fp->filp;
>   	inode =3D file_inode(filp);
> @@ -5619,7 +5637,8 @@ static int set_end_of_file_info(struct ksmbd_work=
 *work, struct ksmbd_file *fp,
>   }
>  =20
>   static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file=
 *fp,
> -			   char *buf)
> +			   struct smb2_file_rename_info *rename_info,
> +			   int buf_len)
>   {
>   	struct user_namespace *user_ns;
>   	struct ksmbd_file *parent_fp;
> @@ -5632,6 +5651,10 @@ static int set_rename_info(struct ksmbd_work *wo=
rk, struct ksmbd_file *fp,
>   		return -EACCES;
>   	}
>  =20
> +	if (buf_len < sizeof(struct smb2_file_rename_info) +
> +			le32_to_cpu(rename_info->FileNameLength))
> +		return -EINVAL;
> +
>   	user_ns =3D file_mnt_user_ns(fp->filp);
>   	if (ksmbd_stream_fd(fp))
>   		goto next;
> @@ -5654,8 +5677,7 @@ static int set_rename_info(struct ksmbd_work *wor=
k, struct ksmbd_file *fp,
>   		}
>   	}
>   next:
> -	return smb2_rename(work, fp, user_ns,
> -			   (struct smb2_file_rename_info *)buf,
> +	return smb2_rename(work, fp, user_ns, rename_info,
>   			   work->sess->conn->local_nls);
>   }
>  =20
> @@ -5741,40 +5763,71 @@ static int set_file_mode_info(struct ksmbd_file=
 *fp, char *buf)
>    * TODO: need to implement an error handling for STATUS_INFO_LENGTH_M=
ISMATCH
>    */
>   static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_f=
ile *fp,
> -			      int info_class, char *buf,
> +			      struct smb2_set_info_req *req,
>   			      struct ksmbd_share_config *share)
>   {
> -	switch (info_class) {
> +	int buf_len =3D le32_to_cpu(req->BufferLength);
> +
> +	switch (req->FileInfoClass) {
>   	case FILE_BASIC_INFORMATION:
> -		return set_file_basic_info(fp, buf, share);
> +	{
> +		if (buf_len < sizeof(struct smb2_file_basic_info))
> +			return -EINVAL;
>  =20
> +		return set_file_basic_info(fp, req->Buffer, share);

set_file_basic_info() should take a pointer to struct=20
smb2_file_basic_info to make it clear that the buffer size has already=20
been validated.

The same needs to be changed in the several other infolevel handlers.

> +	}
>   	case FILE_ALLOCATION_INFORMATION:
> -		return set_file_allocation_info(work, fp, buf);
> +	{
> +		if (buf_len < sizeof(struct smb2_file_alloc_info))
> +			return -EINVAL;
>  =20
> +		return set_file_allocation_info(work, fp, req->Buffer);

here

> +	}
>   	case FILE_END_OF_FILE_INFORMATION:
> -		return set_end_of_file_info(work, fp, buf);
> +	{
> +		if (buf_len < sizeof(struct smb2_file_eof_info))
> +			return -EINVAL;
>  =20
> +		return set_end_of_file_info(work, fp, req->Buffer);

here.

> +	}
>   	case FILE_RENAME_INFORMATION:
> +	{
>   		if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)=
) {
>   			ksmbd_debug(SMB,
>   				    "User does not have write permission\n");
>   			return -EACCES;
>   		}
> -		return set_rename_info(work, fp, buf);
>  =20
> +		if (buf_len < sizeof(struct smb2_file_rename_info))
> +			return -EINVAL;
> +
> +		return set_rename_info(work, fp,
> +				       (struct smb2_file_rename_info *)req->Buffer,
> +				       buf_len);
> +	}
>   	case FILE_LINK_INFORMATION:
> +	{
> +		if (buf_len < sizeof(struct smb2_file_link_info))
> +			return -EINVAL;
> +
>   		return smb2_create_link(work, work->tcon->share_conf,
> -					(struct smb2_file_link_info *)buf, fp->filp,
> +					(struct smb2_file_link_info *)req->Buffer,
> +					buf_len, fp->filp,
>   					work->sess->conn->local_nls);
> -
> +	}
>   	case FILE_DISPOSITION_INFORMATION:
> +	{
>   		if (!test_tree_conn_flag(work->tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)=
) {
>   			ksmbd_debug(SMB,
>   				    "User does not have write permission\n");
>   			return -EACCES;
>   		}
> -		return set_file_disposition_info(fp, buf);
>  =20
> +		if (buf_len < sizeof(struct smb2_file_disposition_info))
> +			return -EINVAL;
> +
> +		return set_file_disposition_info(fp, req->Buffer);

here

> +	}
>   	case FILE_FULL_EA_INFORMATION:
>   	{
>   		if (!(fp->daccess & FILE_WRITE_EA_LE)) {
> @@ -5783,18 +5836,29 @@ static int smb2_set_info_file(struct ksmbd_work=
 *work, struct ksmbd_file *fp,
>   			return -EACCES;
>   		}
>  =20
> -		return smb2_set_ea((struct smb2_ea_info *)buf,
> -				   &fp->filp->f_path);
> -	}
> +		if (buf_len < sizeof(struct smb2_ea_info))
> +			return -EINVAL;
>  =20
> +		return smb2_set_ea((struct smb2_ea_info *)req->Buffer,
> +				   buf_len, &fp->filp->f_path); > +	}
>   	case FILE_POSITION_INFORMATION:
> -		return set_file_position_info(fp, buf);
> +	{
> +		if (buf_len < sizeof(struct smb2_file_pos_info))
> +			return -EINVAL;
>  =20
> +		return set_file_position_info(fp, req->Buffer);

here

> +	}
>   	case FILE_MODE_INFORMATION:
> -		return set_file_mode_info(fp, buf);
> +	{
> +		if (buf_len < sizeof(struct smb2_file_mode_info))
> +			return -EINVAL;
> +
> +		return set_file_mode_info(fp, req->Buffer);

here

Cheers!
-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--NvVfvNYjjBhfa8Xv5ASNBdHJCMyBFIXIH--

--fV9LhnbvJnAivET8WWhvePEb0CdyEp75M
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFIquAFAwAAAAAACgkQqh6bcSY5nkYd
AA/9Fqs14vyp54T/Ke9mAslUi1GrixJs/OmE52B5ua5pmI7iAfVzqzgkJ87zHXT/4A/glsUQ23+I
M7bfrxT2oamrJVr8V+mvvJw8t2emWnoXiBjPDAE80eYwzYmn1/bmxXc/RziXqqxO8lykx4ftWLBZ
RvErW83wJC9VjDjw86N08shq33vKTfCrLd2C6aPh7AxUKxHUqAuGLTB2sRjsushLYqfTUBZX5lHj
hJRfahG9nCDBlDiwqmetZhXasUZy+rhAePrHjWh9tSaNIkK2QCCYIp7ldx3KpmEDrbLfAXfoA/tO
Dwnf14Z+AdO79BlsZLcrpQUFqj1kqa0XhZbDpfE0u+ceho0oa2YCTgl0BnkTsS0jHLwauIuQ+5md
WXSvxEZRoG+QDEv/AR0wyPXWFY1gOcTu6kgPu9JFl84m+DVaIEgSUcIEXj4J0EjCm5d7m0nq9l7H
YXCGnCsmLvIuXYDxUXalsjLdLfVcPnY8kWgzbEdDGgwkHfogO5tSdBVRVggl2rEg3lHRVHjO9MAM
0LuY09eTYQ00hi8Bu8G8bg2cst353ZL2bg79hyrwlCp2SmR6gFAfGfRvaOQk4YFw+xPMHjbtiKFA
tQ8D+yjMj3RlKW/VCYQlbH+P2vJldqE7gwp2LRTuMneCNghpf3i1JfxIaCAHNN38lNFqtzevx8U/
9DM=
=ZgGt
-----END PGP SIGNATURE-----

--fV9LhnbvJnAivET8WWhvePEb0CdyEp75M--
