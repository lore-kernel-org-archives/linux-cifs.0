Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE280C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 14:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A17A660F56
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 14:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbhIVOZ2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 10:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbhIVOZ2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Sep 2021 10:25:28 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41245C061574
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 07:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=dSIXSqe0YRkNpO4cmUJRaP8fZA2YzsEV1PfGl1kkBbA=; b=ynu8g2ehZgiyMiBxK/38j8b0jW
        2t/kDABB6DHRTXNYhJ3J46x1UnswTXMFLyAcpb0H0q82sKbNTGMJy9gzWk38NrJz+FfjBzKkKXOhb
        HvnKpejAAw6Qc9yBYsRnnOLnSZLnqWFUa/pWQTIy48N9bpnNHI9CanHOpS15uTVniFh5JpFEbCEk2
        CNbsIF7tt5SrcYZ+M5+Aq3DxlWMFhA3SX37XVPOE/pwM06MIcLXS7QoZTyzo9E/2efWaHvWGm3jPU
        mGVLPfxduzKhGlq0b9TTs30a7enLdfu7KZ8tNh5txRxsQmQore72yUMMZ0n44CDn4a1pKx8eps5ax
        Z+XMkz6zYpCPkqiQ0MME7n//rZ2VhFKmJE2M8Kpl7AZlg6p+uBmtL11R5U9yLYMiawlL8ayIpaAg1
        BIku/OfHatwtXV9r95nEtBnMH9I9J5T3qPgVMUKssy2UHn5lCqXu/JRz/+JP/8VoWDQoddLmgcRUR
        BMEa/7zfV35SJSxE4x1YrXpt;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mT3AB-007Kzx-WC; Wed, 22 Sep 2021 14:23:56 +0000
Subject: Re: [PATCH v3] ksmbd: fix invalid request buffer access in compound
 request
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
References: <20210922120143.45953-1-linkinjeon@kernel.org>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <447d958e-2470-4ddb-2064-0aeaf1a47ba0@samba.org>
Date:   Wed, 22 Sep 2021 16:23:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210922120143.45953-1-linkinjeon@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="naszP1nsxbjdBvGA1ZFvp5zAR3FIZiCwe"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--naszP1nsxbjdBvGA1ZFvp5zAR3FIZiCwe
Content-Type: multipart/mixed; boundary="tMaKQlQMxHkZts6JwAPulWFSZAKnOw74h";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Steve French <smfrench@gmail.com>, Ronnie Sahlberg <lsahlber@redhat.com>
Message-ID: <447d958e-2470-4ddb-2064-0aeaf1a47ba0@samba.org>
Subject: Re: [PATCH v3] ksmbd: fix invalid request buffer access in compound
 request
References: <20210922120143.45953-1-linkinjeon@kernel.org>
In-Reply-To: <20210922120143.45953-1-linkinjeon@kernel.org>

--tMaKQlQMxHkZts6JwAPulWFSZAKnOw74h
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 22.09.21 um 14:01 schrieb Namjae Jeon:
> Ronnie reported invalid request buffer access in chained command when
> inserting garbage value to NextCommand of compound request.
> This patch add validation check to avoid this issue.
>=20
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>    v2:
>     - fix integer overflow from work->next_smb2_rcv_hdr_off.
>    v3:
>     - check next command offset and at least header size of next pdu at=

>       the same time.
>   fs/ksmbd/smb2pdu.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>=20
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 4f11eb85bb6b..3d250e2539e6 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -466,6 +466,13 @@ bool is_chained_smb2_message(struct ksmbd_work *wo=
rk)
>  =20
>   	hdr =3D ksmbd_req_buf_next(work);
>   	if (le32_to_cpu(hdr->NextCommand) > 0) {
> +		if ((u64)work->next_smb2_rcv_hdr_off + le32_to_cpu(hdr->NextCommand)=
 + 64 >
> +		    get_rfc1002_len(work->request_buf)) {

is this safe from overflows on 32 bit arch?

Thanks!
-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--tMaKQlQMxHkZts6JwAPulWFSZAKnOw74h--

--naszP1nsxbjdBvGA1ZFvp5zAR3FIZiCwe
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFLPHsFAwAAAAAACgkQqh6bcSY5nkZB
UA/+KbRW99J6MgR6Cpih0QaRhWGMT4JIniAvG46nQkoJhEKLK5I1mMmqejURBqdrRJSaqku0PCXk
7PKu7rvK32f5vaqH6e8O+t8w5A6B8DA3LN/Ab7+cTSap1zfwIKVi++7w3UKQ3ETz8ytNsBLJs9ht
XP1jfumk55kesg3JD1kbD7xDU1iTXb6a/Jl4fyV5JdLLhMES08nNugpdO5lHtCQWO126nIGaVOHV
KDKcPwynMxhsU725CzRN05IKhlY8hNCU5FZkGIYKamMm2SE4io622u84MLzytl25xO81evauctZp
icxTg6I54+9AT6n3lC4owHELVbGgpLFDeOTCclX2oykUGe1z5zHYJ0nyln52azpMXrOqL/OXe/uK
vTC1dr7y8NOQMQW2nWyCDGIiDUQDiuWj/u19555aNJMWUvI6RdJiOl7/Z7jm+uFL1fJD5Fz36kjF
A0CQsE5muLODNfWFIS/Ai3rWUOqgr2x+VE013k2YmADlhUGal6OSnf3ssulwq926yMihb4ZjXPTk
sbLMk57CkY4o9zFowCYfSI/4SPiWsm75406GhCjKKs4yvW8x5s5/Zqqkd/TWtcMD22Fkxli0oS1O
hn8CQ2Q9VoJn+v+Ag9PNfSb3LpoyaCdmfDVEStaVz54vOeEKSxd0C6TEJEqDjrkyZ7hSnv9aTc8m
KrM=
=L+MU
-----END PGP SIGNATURE-----

--naszP1nsxbjdBvGA1ZFvp5zAR3FIZiCwe--
