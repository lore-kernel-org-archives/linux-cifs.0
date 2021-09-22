Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87469C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 13:08:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CF5B61100
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 13:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbhIVNKI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 09:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbhIVNKI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Sep 2021 09:10:08 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0ACAC061574
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 06:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=pWf/1hXhSXdC0Mi4wNkLOzVlGDAcxL9FN8DC38GwXdU=; b=DGJsZ5xZCvbc7tlaYF38ky2F+p
        eRc2nvlQtGNuU3UhVUXesKErw/dKz4t1hW05huNawrIdn9JWm5o5M6Opv//y+oW8ua7O0qs0bcUcw
        53EhssFYR0t7mUDqhOCyXOzA0cOLxETgzcJ+QtMz+P438CwCONcIaF+ntZqyQgv/hbthTx5PSDB+B
        F1lAru9cZVKybdXKrwSvOKjuCu+g3jFzpGvuG5wrUfUeslJLNf28zWncdAsxZQM5bZw7GrJEJJ6m5
        kot2zyCMmOWaPqykYBuiLoY3fYussL74kSF5G5vJg+QtktQVac90eoYzqRW2m9P1Lzo5L3fsNez28
        EWMCDo1I37jIjA/D23OAX7BLuWZUNXefcSxeFFCl9wnAuF50vNqfBEl2v6SKpZIFiwNPYCBlgBnAk
        I9BVH2D6TByjxIO0zJeCGvvCzYNnppgKA+7H+gh+mXbOqSiLqe0mFxZUETfQ9omHTkJMABavEjB8d
        v9dK1AtKRtBrbddyf3JeOTXG;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mT1zH-007KPM-Fp; Wed, 22 Sep 2021 13:08:35 +0000
Subject: Re: [PATCH v3] ksmbd: add buffer validation for SMB2_CREATE_CONTEXT
To:     Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
References: <20210922012651.513888-1-hyc.lee@gmail.com>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <90804f93-9a51-9562-758f-b63ab71c9f74@samba.org>
Date:   Wed, 22 Sep 2021 15:08:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210922012651.513888-1-hyc.lee@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AEW5TeqV5VqperQspIznt4G6ek1az5MnL"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AEW5TeqV5VqperQspIznt4G6ek1az5MnL
Content-Type: multipart/mixed; boundary="dTSAVN9yxj6XdSdodhxeRR1qtJEWrVe2s";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>
Message-ID: <90804f93-9a51-9562-758f-b63ab71c9f74@samba.org>
Subject: Re: [PATCH v3] ksmbd: add buffer validation for SMB2_CREATE_CONTEXT
References: <20210922012651.513888-1-hyc.lee@gmail.com>
In-Reply-To: <20210922012651.513888-1-hyc.lee@gmail.com>

--dTSAVN9yxj6XdSdodhxeRR1qtJEWrVe2s
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Hyunchul,

patch looks excellent, few more nitpicks below.

Am 22.09.21 um 03:26 schrieb Hyunchul Lee:
> Add buffer validation for SMB2_CREATE_CONTEXT.
>=20
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph Boehme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
> Changes from v2:
>   - check struct create_context's fields more in smb2_find_context_vals=

>     (suggested by Ralph Boehme).
>=20
>   fs/ksmbd/oplock.c  | 34 ++++++++++++++++++++++++----------
>   fs/ksmbd/smb2pdu.c | 25 ++++++++++++++++++++++++-
>   fs/ksmbd/smbacl.c  |  9 ++++++++-
>   3 files changed, 56 insertions(+), 12 deletions(-)
>=20
> diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
> index 16b6236d1bd2..8f743913b1cf 100644
> --- a/fs/ksmbd/oplock.c
> +++ b/fs/ksmbd/oplock.c
> @@ -1451,26 +1451,40 @@ struct lease_ctx_info *parse_lease_state(void *=
open_req)
>    */
>   struct create_context *smb2_find_context_vals(void *open_req, const c=
har *tag)
>   {
> -	char *data_offset;
> +	struct smb2_create_req *req =3D (struct smb2_create_req *)open_req;
>   	struct create_context *cc;
> -	unsigned int next =3D 0;
> +	char *data_offset, *data_end;
>   	char *name;
> -	struct smb2_create_req *req =3D (struct smb2_create_req *)open_req;

this line is only moved, not changed. Can we remove this change from the =

diff?

> +	unsigned int next =3D 0;
> +	unsigned int name_off, name_len, value_off, value_len;
>  =20
>   	data_offset =3D (char *)req + 4 + le32_to_cpu(req->CreateContextsOff=
set);
> +	data_end =3D data_offset + le32_to_cpu(req->CreateContextsLength);

do we need overflow checks here? At least on 32-bit arch this could=20
easily overflow.

>   	cc =3D (struct create_context *)data_offset;
>   	do {
> -		int val;
> -
>   		cc =3D (struct create_context *)((char *)cc + next);
> -		name =3D le16_to_cpu(cc->NameOffset) + (char *)cc;
> -		val =3D le16_to_cpu(cc->NameLength);
> -		if (val < 4)
> +		if ((char *)cc + offsetof(struct create_context, Buffer) >
> +		    data_end)
>   			return ERR_PTR(-EINVAL);
>  =20
> -		if (memcmp(name, tag, val) =3D=3D 0)
> -			return cc;
>   		next =3D le32_to_cpu(cc->Next);
> +		name_off =3D le16_to_cpu(cc->NameOffset);
> +		name_len =3D le16_to_cpu(cc->NameLength);
> +		value_off =3D le16_to_cpu(cc->DataOffset);
> +		value_len =3D le32_to_cpu(cc->DataLength);

same here: possible overflow checks needed?

> +
> +		if ((next & 0x7) !=3D 0 ||
> +		    name_off !=3D 16 ||
> +		    name_len < 4 ||
> +		    (char *)cc + name_off + name_len > data_end ||
> +		    (value_off & 0x7) !=3D 0 ||
> +		    (value_off && value_off < name_off + name_len) ||

I guess this must be

	    (value_off && (value_off < name_off + name_len)) ||

> +		    (char *)cc + value_off + value_len > data_end)
> +			return ERR_PTR(-EINVAL);
> +
> +		name =3D (char *)cc + name_off;
> +		if (memcmp(name, tag, name_len) =3D=3D 0)
> +			return cc;
>   	} while (next !=3D 0);
>  =20
>   	return NULL;
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index c86164dc70bb..976490bfd93c 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -2377,6 +2377,10 @@ static int smb2_create_sd_buffer(struct ksmbd_wo=
rk *work,
>   	ksmbd_debug(SMB,
>   		    "Set ACLs using SMB2_CREATE_SD_BUFFER context\n");
>   	sd_buf =3D (struct create_sd_buf_req *)context;
> +	if (le16_to_cpu(context->DataOffset) +
> +	    le32_to_cpu(context->DataLength) <
> +	    sizeof(struct create_sd_buf_req))
> +		return -EINVAL;
>   	return set_info_sec(work->conn, work->tcon, path, &sd_buf->ntsd,
>   			    le32_to_cpu(sd_buf->ccontext.DataLength), true);
>   }
> @@ -2577,6 +2581,12 @@ int smb2_open(struct ksmbd_work *work)
>   			goto err_out1;
>   		} else if (context) {
>   			ea_buf =3D (struct create_ea_buf_req *)context;
> +			if (le16_to_cpu(context->DataOffset) +
> +			    le32_to_cpu(context->DataLength) <
> +			    sizeof(struct create_ea_buf_req)) {
> +				rc =3D -EINVAL;
> +				goto err_out1;
> +			}
>   			if (req->CreateOptions & FILE_NO_EA_KNOWLEDGE_LE) {
>   				rsp->hdr.Status =3D STATUS_ACCESS_DENIED;
>   				rc =3D -EACCES;
> @@ -2615,6 +2625,12 @@ int smb2_open(struct ksmbd_work *work)
>   			} else if (context) {
>   				struct create_posix *posix =3D
>   					(struct create_posix *)context;
> +				if (le16_to_cpu(context->DataOffset) +
> +				    le32_to_cpu(context->DataLength) <
> +				    sizeof(struct create_posix)) {
> +					rc =3D -EINVAL;
> +					goto err_out1;
> +				}
>   				ksmbd_debug(SMB, "get posix context\n");
>  =20
>   				posix_mode =3D le32_to_cpu(posix->Mode);
> @@ -3019,9 +3035,16 @@ int smb2_open(struct ksmbd_work *work)
>   			rc =3D PTR_ERR(az_req);
>   			goto err_out;
>   		} else if (az_req) {
> -			loff_t alloc_size =3D le64_to_cpu(az_req->AllocationSize);
> +			loff_t alloc_size;
>   			int err;
>  =20
> +			if (le16_to_cpu(az_req->ccontext.DataOffset) +
> +			    le32_to_cpu(az_req->ccontext.DataLength) <
> +			    sizeof(struct create_alloc_size_req)) {
> +				rc =3D -EINVAL;
> +				goto err_out;
> +			}
> +			alloc_size =3D le64_to_cpu(az_req->AllocationSize);
>   			ksmbd_debug(SMB,
>   				    "request smb2 create allocate size : %llu\n",
>   				    alloc_size);
> diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
> index 0a95cdec8c80..f67567e1e178 100644
> --- a/fs/ksmbd/smbacl.c
> +++ b/fs/ksmbd/smbacl.c
> @@ -392,7 +392,7 @@ static void parse_dacl(struct user_namespace *user_=
ns,
>   		return;
>  =20
>   	/* validate that we do not go past end of acl */
> -	if (end_of_acl <=3D (char *)pdacl ||
> +	if (end_of_acl < (char *)pdacl + sizeof(struct smb_acl) ||
>   	    end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size)) {
>   		pr_err("ACL too small to parse DACL\n");
>   		return;
> @@ -434,6 +434,10 @@ static void parse_dacl(struct user_namespace *user=
_ns,
>   		ppace[i] =3D (struct smb_ace *)(acl_base + acl_size);
>   		acl_base =3D (char *)ppace[i];
>   		acl_size =3D le16_to_cpu(ppace[i]->size);

overflow check needed?

> +
> +		if (acl_base + acl_size > end_of_acl)
> +			break;
> +
>   		ppace[i]->access_req =3D
>   			smb_map_generic_desired_access(ppace[i]->access_req);
>  =20
> @@ -807,6 +811,9 @@ int parse_sec_desc(struct user_namespace *user_ns, =
struct smb_ntsd *pntsd,
>   	if (!pntsd)
>   		return -EIO;
>  =20
> +	if (acl_len < sizeof(struct smb_ntsd))
> +		return -EINVAL;
> +
>   	owner_sid_ptr =3D (struct smb_sid *)((char *)pntsd +
>   			le32_to_cpu(pntsd->osidoffset));
>   	group_sid_ptr =3D (struct smb_sid *)((char *)pntsd +
>=20

Thanks!
-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--dTSAVN9yxj6XdSdodhxeRR1qtJEWrVe2s--

--AEW5TeqV5VqperQspIznt4G6ek1az5MnL
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFLKtIFAwAAAAAACgkQqh6bcSY5nkZh
Bg/9HT6riRCHInEJ3okpJvpxjqdCCJKohuOssoXfEyMbhCWrCii1nEYIhnI54Dry7/CHkcQmpD23
+E9JTF99q4airj8eFE0SHs35uiQT9Nx+gepNzDBf98k1oYypSgdFIW2akv9Oh1THWqegYR3g43SQ
pZ0uLPlxzTBjGkiF4fQB38u/iQ6vETEq6Bm/bef2lOktzGfh8KlmiWYI+dCJC3czfuzkC1YnsPQ8
7vFxa0k3nNppVpo+M7yBPUVyXuff/5YsFVwKKCs6m0Sm1sWuC78NAm/4nlcLeRAfGLVDl81wE8sw
aoFyI5nDQRstex0iIjH2oOUgSki/N2rNwBv+UVjrj5/9EERXR9ZKrehO17Bdm+44ZtEH0c+uilrg
CoylKGJ6gFTeWfL0Jk46vhP+yMBEg0Gf6LGVYYSSti9AgwQbeFaJGz6c2uBcIIST1lmybZB6dKXb
2HSWthrJDGNa4Gq3oWIF5m2if7NRs+eZmIZN+qCzI9rieFRjYY5wGRz4bKs7bttMNX12QeiJX2ih
OjtpKTNn8Ub620vUkXwZx1Daw3kDWWEW0Frls7tdZHSy/E9mYhPvSXnLPh3uzK0639tKhzs+Ay3y
mIfozn4Baz7NVVnf0fZbzx9S1ovY9fNpkwMRPGLf5QcXfUQY6w7LXkE3Q5+ikbUX3qxL3lzPi6/J
rvs=
=QKgq
-----END PGP SIGNATURE-----

--AEW5TeqV5VqperQspIznt4G6ek1az5MnL--
