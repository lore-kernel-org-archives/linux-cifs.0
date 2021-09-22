Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D3EC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 14:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF4CE60F56
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 14:17:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233926AbhIVOTP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 10:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbhIVOTO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Sep 2021 10:19:14 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69390C061574
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 07:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=C//T0TygXYK/6akxNrlBFkir4MbEnKwyrHD8jL0ukho=; b=SR/yZHLu6sIhv+kj4M7nL2c5Gb
        rBd39oc0Le/47d9+676PBmnobhK3DcPgJLHln0B2hc+u0z54eWamSV+4yY7JrvIBrTxiYszp4kPpV
        TctJ3sXXEdqH01x1NAuIiaGbaHGDgAiE8Y7YUvT1TAFH71S1/6W5dYHIPeGAS9oiNGigkTHywrdpT
        2vXi35tLx75edXhSfv8r828z30knrLX49HVdkbKr0YHG46lfuS+WjkuyxjG2nRYzAL64mWEnKyrvL
        hwJTz8iDPK7ixmeRJO14JqDjLR8qI6/TFApydeEpNd2sIZKFJ54Mjo32cSBT89h8oIWyfB3tEBdje
        6DXOmxDKaZq6l2xwGifijbbsrfAxiUAcLhIXVvBtZ5PNlnu7V9NMYLkYlehKnYxtA87+eICNQQMnd
        hwMjpZrrf5b1l2O01OdoIyg0jR9n5PEjo+HuRgtGQNljc/4xOoVgMVFn29S1yIAypDOeoyCc5iB7w
        v+6v6tKPZ7fjzYpJRwRxPsuI;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mT34A-007Kva-2L; Wed, 22 Sep 2021 14:17:42 +0000
Subject: Re: [PATCH v2 2/3] ksmbd: add validation in smb2 negotiate
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
References: <20210921225109.6388-1-linkinjeon@kernel.org>
 <20210921225109.6388-2-linkinjeon@kernel.org>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <433e36b5-f07c-0105-fd30-c7bb4cb8957d@samba.org>
Date:   Wed, 22 Sep 2021 16:17:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210921225109.6388-2-linkinjeon@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ImC7L7qyWDBQCfPuR6kOScIJyj6YwcVp4"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ImC7L7qyWDBQCfPuR6kOScIJyj6YwcVp4
Content-Type: multipart/mixed; boundary="IaM5IBiz5h1rJAp7dSDyEiA1RWtjqyuKY";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Steve French <smfrench@gmail.com>
Message-ID: <433e36b5-f07c-0105-fd30-c7bb4cb8957d@samba.org>
Subject: Re: [PATCH v2 2/3] ksmbd: add validation in smb2 negotiate
References: <20210921225109.6388-1-linkinjeon@kernel.org>
 <20210921225109.6388-2-linkinjeon@kernel.org>
In-Reply-To: <20210921225109.6388-2-linkinjeon@kernel.org>

--IaM5IBiz5h1rJAp7dSDyEiA1RWtjqyuKY
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Namjae

patch looks great! Few nitpicks below.

Am 22.09.21 um 00:51 schrieb Namjae Jeon:
> This patch add validation to check request buffer check in smb2
> negotiate.
>=20
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/ksmbd/smb2pdu.c    | 41 ++++++++++++++++++++++++++++++++++++++++-
>   fs/ksmbd/smb_common.c | 22 ++++++++++++++++++++--
>   2 files changed, 60 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index baf7ce31d557..1fe37ad4e5bc 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -1071,7 +1071,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work=
)
>   	struct ksmbd_conn *conn =3D work->conn;
>   	struct smb2_negotiate_req *req =3D work->request_buf;
>   	struct smb2_negotiate_rsp *rsp =3D work->response_buf;
> -	int rc =3D 0;
> +	int rc =3D 0, smb2_buf_len, smb2_neg_size;

I guess all len variables should use unsigned types to facilitate well=20
defined overflow checks.

>   	__le32 status;
>  =20
>   	ksmbd_debug(SMB, "Received negotiate request\n");
> @@ -1089,6 +1089,45 @@ int smb2_handle_negotiate(struct ksmbd_work *wor=
k)
>   		goto err_out;
>   	}
>  =20
> +	smb2_buf_len =3D get_rfc1002_len(work->request_buf);
> +	smb2_neg_size =3D offsetof(struct smb2_negotiate_req, Dialects) - 4;
> +	if (conn->dialect =3D=3D SMB311_PROT_ID) {
> +		int nego_ctxt_off =3D le32_to_cpu(req->NegotiateContextOffset);
> +		int nego_ctxt_count =3D le16_to_cpu(req->NegotiateContextCount);
> +
> +		if (smb2_buf_len < nego_ctxt_off + nego_ctxt_count) {

overflow check needed for 32 bit arch?

> +			rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
> +			rc =3D -EINVAL;
> +			goto err_out;
> +		}
> +
> +		if (smb2_neg_size > nego_ctxt_off) {
> +			rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
> +			rc =3D -EINVAL;
> +			goto err_out;
> +		}
> +
> +		if (smb2_neg_size + le16_to_cpu(req->DialectCount) * sizeof(__le16) =
>
> +		    nego_ctxt_off) {
> +			rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
> +			rc =3D -EINVAL;
> +			goto err_out;
> +		}
> +	} else {
> +		if (smb2_neg_size > smb2_buf_len) {
> +			rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
> +			rc =3D -EINVAL;
> +			goto err_out;
> +		}
> +
> +		if (smb2_neg_size + le16_to_cpu(req->DialectCount) * sizeof(__le16) =
>
> +		    smb2_buf_len) {
> +			rsp->hdr.Status =3D STATUS_INVALID_PARAMETER;
> +			rc =3D -EINVAL;
> +			goto err_out;
> +		}
> +	}
> +
>   	conn->cli_cap =3D le32_to_cpu(req->Capabilities);
>   	switch (conn->dialect) {
>   	case SMB311_PROT_ID:
> diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
> index 1da67217698d..da17b21ac685 100644
> --- a/fs/ksmbd/smb_common.c
> +++ b/fs/ksmbd/smb_common.c
> @@ -229,13 +229,22 @@ int ksmbd_lookup_dialect_by_id(__le16 *cli_dialec=
ts, __le16 dialects_count)
>  =20
>   static int ksmbd_negotiate_smb_dialect(void *buf)
>   {
> -	__le32 proto;
> +	int smb_buf_length =3D get_rfc1002_len(buf);

unsigned

Thanks!
-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--IaM5IBiz5h1rJAp7dSDyEiA1RWtjqyuKY--

--ImC7L7qyWDBQCfPuR6kOScIJyj6YwcVp4
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFLOwQFAwAAAAAACgkQqh6bcSY5nkaJ
mxAAopErJoN3UoatTCd1vomYQWlsP75IeTR/e4mEbUqt46Nfka79zvQUnggJSQfq0fsUUVGHzK09
OzJkmXdIs7CUa/Mb5dieP69yA0PZZmGSQgI+rJ7aKvuO/b+sw7A7UvSUJ1LsY8mXMn2EHvxhqHgn
7iXReoFNpxCJztNobXmCP6t7eK/gKvhi4uValhXovV0y5DfjvDdkFQg9Sw+nQnnzTwJdFp0jKsSA
1bR0IJ9TSazmX8/3S9pGWtYO9FXW826g1oHQaCyi9pKaA8IThyAyWIQPcaqRDKSDi2t2pxLuWZ/1
LpFuCrz1D3pg1VXqoAebvbfVMlj9M2hUAQCDWmuduyM5pb6oAU2kvtkW3JemBaxSbn5rnD3xvbnz
V5pJG7HRhA2VLFoOTtqlPwUfj6Wn7STPLEzeKWvbfvOkdDNkWjdXE4JxOwTnSOi/45WuP09awTji
aatjwHIIoGqTLmAxEJTQprC3BAwZQglL+HIfABStlqNddzSEOjIgOz0pQOTcX1LJytoBV1xlJfZ3
sOmopA0TXspNPTgJ0FwSxG9aAZz7yMWKubnflO6w/GDgqzX46zQW9GgVVtOWNTa3rtkGtaDBD6vP
KcOAyEyKnslRSopf07komRT9hD0+QysT3GBHaE0zRvTe4BLwS7HxSCh4z+WZfAu2MLKeccGhuVqQ
k1o=
=B1d2
-----END PGP SIGNATURE-----

--ImC7L7qyWDBQCfPuR6kOScIJyj6YwcVp4--
