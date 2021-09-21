Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5E38C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 08:32:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C268160F6E
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 08:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhIUIdr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 04:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbhIUIdq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Sep 2021 04:33:46 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794DCC061574
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 01:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=UgKM5Q5HdcA4PPF4MpEqvB8i1QGxLd0ce5svdhSXzkQ=; b=G3B9b4mxb5EAh+ssKDeZjH+1NV
        gPf3jK5Qmbs5QEK7z8wNE7QdI0qYLukdY7LK7W6P2AQcaHvD6bHcIiMK82P4lYGixCN02eHXYQKi2
        2v/fZ1EFAbHeuS6JvL5pGrSVgie5ATFqmE1Shx7+BjmsTrwU2nJw1RSwqf+TUK0SCCQ/24HNpO5TL
        JDLdvooYh8BS2McuKG/X72zVxAuXaDlZobsMHPy69FccOBQIFUv3ixb26DTewL4cjjzDAKJtnStuv
        lIFJ9GXIPBctVCq3NNK1tCojYvxxyjwMcexhaTuGbynpJSJqZzfeBomffV6QtaP0kjUxnRAfpEKMK
        8l2BpWGnJZ8lyBb9Hph2Q13kYgo/DDw3IdXMwoCUAMk8IWZFN2QjliiCbzKIuO5rEQR8rMYRJmtH+
        Q0Lv91scKV10Zhspx9kUIl3G+0MZ6WDqcOjrtXDxXIkapHupq3+76KlExM8ea+15hL+itQ9loBl9v
        +7cwbwvDESz8jbozzGDQNrTq;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mSbCK-0077xO-7k; Tue, 21 Sep 2021 08:32:16 +0000
Subject: Re: [PATCH v2 4/4] ksmbd: add buffer validation for
 SMB2_CREATE_CONTEXT
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
References: <20210919021315.642856-1-linkinjeon@kernel.org>
 <20210919021315.642856-5-linkinjeon@kernel.org>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <3ab97b10-d94c-6cb2-0134-a4f3878a5ee2@samba.org>
Date:   Tue, 21 Sep 2021 10:32:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210919021315.642856-5-linkinjeon@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DoDOjZdbCxVESmn2xiZxpqYrrcRkDk4i0"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DoDOjZdbCxVESmn2xiZxpqYrrcRkDk4i0
Content-Type: multipart/mixed; boundary="yKdJkY1uEMK385JwrV9QRCWmSQQkECLly";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: Hyunchul Lee <hyc.lee@gmail.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Steve French <smfrench@gmail.com>
Message-ID: <3ab97b10-d94c-6cb2-0134-a4f3878a5ee2@samba.org>
Subject: Re: [PATCH v2 4/4] ksmbd: add buffer validation for
 SMB2_CREATE_CONTEXT
References: <20210919021315.642856-1-linkinjeon@kernel.org>
 <20210919021315.642856-5-linkinjeon@kernel.org>
In-Reply-To: <20210919021315.642856-5-linkinjeon@kernel.org>

--yKdJkY1uEMK385JwrV9QRCWmSQQkECLly
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Namjae,

thanks! One nitpick below.

Am 19.09.21 um 04:13 schrieb Namjae Jeon:
> From: Hyunchul Lee <hyc.lee@gmail.com>
>=20
> Add buffer validation for SMB2_CREATE_CONTEXT.
>=20
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/ksmbd/oplock.c  | 35 +++++++++++++++++++++++++----------
>   fs/ksmbd/smb2pdu.c | 25 ++++++++++++++++++++++++-
>   fs/ksmbd/smbacl.c  |  9 ++++++++-
>   3 files changed, 57 insertions(+), 12 deletions(-)
>=20
> diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
> index 16b6236d1bd2..3fd2713f2282 100644
> --- a/fs/ksmbd/oplock.c
> +++ b/fs/ksmbd/oplock.c
> @@ -1451,26 +1451,41 @@ struct lease_ctx_info *parse_lease_state(void *=
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
> +	unsigned int next =3D 0;
> +	unsigned int name_off, name_len, value_off, value_len;
>  =20
>   	data_offset =3D (char *)req + 4 + le32_to_cpu(req->CreateContextsOff=
set);
> +	data_end =3D data_offset + le32_to_cpu(req->CreateContextsLength);
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
> +
> +		if ((char *)cc + name_off + name_len > data_end ||
> +		    (value_len && (char *)cc + value_off + value_len > data_end))
> +			return ERR_PTR(-EINVAL);
> +		else if (next && (next < name_off + name_len ||
> +			 (value_len && next < value_off + value_len)))
> +			return ERR_PTR(-EINVAL);

The else is a bit confusing and not needed. Also, Samba has a few=20
additional checks, I wonder whether we should add those two:

                 if ((next & 0x7) !=3D 0 ||
                     next > remaining ||
                     name_offset !=3D 16 ||
                     name_length < 4 ||
                     name_offset + name_length > remaining ||
                     (data_offset & 0x7) !=3D 0 ||
                     (data_offset && (data_offset < name_offset +=20
name_length)) ||
                     (data_offset > remaining) ||
                     (data_offset + (uint64_t)data_length > remaining)) {=

                         return NT_STATUS_INVALID_PARAMETER;
                 }

Other then that lgtm.

Thanks!
-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--yKdJkY1uEMK385JwrV9QRCWmSQQkECLly--

--DoDOjZdbCxVESmn2xiZxpqYrrcRkDk4i0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFJmI8FAwAAAAAACgkQqh6bcSY5nkY3
OA//Uym9Mr+eKZyhYxUF2Wve8+mQEjdqMBAgUYlWPrKyKjMd7UOHtN4OobXuOOpXcFiyADBd/TgH
krFVyzgFbaRk8c35FELQBwjcdUtLqLf5T8wo2uZhGSupPskzqe84qbDz1g/y+yLsnthF131SvkmY
ijCgO7Fm1FNPBDrBDCEDpa8GbGPjOYHR1s5Z7KWL0NCm39nyj3GOJ4rNfSW385tsP488HJDRNogZ
4A2hO0NTgcMYlA93KxB6ywHqJuUx5BL4uJlpWru7VA4sdJdZsq9lMYCB3jSFl5Sh7XQWhcwT/Uuf
1LEK/rWgBhg8i3YrvwjERSHn4puJWAdzz7LVCDPHhNtHX6cCf6MW4CMwg1xWUMpgzRt3qk6umQvQ
kqe6NpTsIiNv9wU4Bst/5ed2w7N8oMwqiHQmh6yZxOw63a7ezw6q4ZSAfsJEU9ej1e9nCeTQJElD
XoU454uX4kMFh4UHIpkdnP5ItnO3ZuMv/SldfAtDycxuEHBnW95AjGJy0YMxS+8r/Co2gX+8+iJz
Zapbq6wAPhsgoOc2rNk+koA5FufHUccce3KSurVeLQhaxoxT44HQ4Qgagmck/d5j13FYZakCyetY
2s8c4+zPPw1/DdoENZZYB36cEWnZ48zcm48yXT5oEzaIukT2fSKWorw/Ylfwz4qiR1Q0W7Ly1zbK
WeE=
=ELIj
-----END PGP SIGNATURE-----

--DoDOjZdbCxVESmn2xiZxpqYrrcRkDk4i0--
