Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54CD2C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 14:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F45D611C9
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 14:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbhIVOXa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 10:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232720AbhIVOXa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Sep 2021 10:23:30 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD1AC061574
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 07:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=HkL5INDI0X82nySQlJSpupd7MsR/SZcL41OFFOK6WFI=; b=27y7j/zm6U2QJOM2npCxT41JS2
        xpMIOQVOa8EmHt6d9Y0G+61g/auVXiu92UhXua4A9nFHiXnkoLIJTebzxfikux4anmEShOekkAGeF
        c3jt8uRPiWx/rauJi3VrAzZIJK4wrKDxmnGYkszy8kbJxXJetVeHzKCtF6lhVkBKJm//9EhuCPYLC
        TN7Lc5oppj9gPwA4K44/ujJhjYI0CUXBOYZvsa43uyEcmWFJD1mhXFDeJOSx+8AzwExD8E03bee06
        SRw1uKHeL52NxS6zEiVGYGd5Tg9N0wv7vl8pzquQy9PvP+7O32Ap8AVKjFXWYwvmlUYZaCXbbz6uZ
        vjSvOLDiyQcSs5T1u8F3wiG43lJQEecpDdRSOnh55aG1XOHkdsFhgb57SlJWqo6SpasYciEeQwzEF
        XRrUFRgFvos4hq3LxD0ZOqqL1G5u1wlEjG0ldObpDh0BxaI8nYl6ArkNyII2vWOYiDvqL/2VlMJq0
        1U7QaQ7lxY2z13n/oQpXExxk;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mT38I-007KyR-40; Wed, 22 Sep 2021 14:21:58 +0000
Subject: Re: [PATCH] ksmbd: check protocol id in ksmbd_verify_smb_message()
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
References: <20210922120057.45789-1-linkinjeon@kernel.org>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <bfda546b-3ab4-64f9-ff7f-599e25a2b2f8@samba.org>
Date:   Wed, 22 Sep 2021 16:21:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210922120057.45789-1-linkinjeon@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IzNzhYFZGqN1ffTl3m3fxfmR6UBUcCGtQ"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IzNzhYFZGqN1ffTl3m3fxfmR6UBUcCGtQ
Content-Type: multipart/mixed; boundary="3Gjv1XVKSssNeeID3WP39TLNlGnioTPqs";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Steve French <smfrench@gmail.com>, Ronnie Sahlberg <lsahlber@redhat.com>
Message-ID: <bfda546b-3ab4-64f9-ff7f-599e25a2b2f8@samba.org>
Subject: Re: [PATCH] ksmbd: check protocol id in ksmbd_verify_smb_message()
References: <20210922120057.45789-1-linkinjeon@kernel.org>
In-Reply-To: <20210922120057.45789-1-linkinjeon@kernel.org>

--3Gjv1XVKSssNeeID3WP39TLNlGnioTPqs
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 22.09.21 um 14:00 schrieb Namjae Jeon:
> When second smb2 pdu has invalid protocol id, ksmbd doesn't detect it
> and allow to process smb2 request. This patch add the check it in
> ksmbd_verify_smb_message() and don't use protocol id of smb2 request as=

> protocol id of response.
>=20
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

reviewed-by: me.

-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--3Gjv1XVKSssNeeID3WP39TLNlGnioTPqs--

--IzNzhYFZGqN1ffTl3m3fxfmR6UBUcCGtQ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFLPAUFAwAAAAAACgkQqh6bcSY5nkY8
PA/9F6i0eE2rg/0/rt7A5/OufobSYFWaA5/Qz1k9rEVti1Wc6X5AkIHbIn/hHV6FKsVmd+S6hBdl
zscx5KQX/VMuI5+98v+e65NXpjdtCQEOosoe026FjpHIfhWstV16P+dQWIaa5O0vBs77fg6S7piG
6WhP55LfB5Fe4ENLoOznHhWF8il4TOUTQU1Pl2F0BLjPY29vdBHZrPFnadld/84QK4A885c7lZ//
fGLMTd+WNLiAKywOrz/LH8Z6wUQNFkhc0L4rmbmS/eCbE1eJ9elZGt6X/X+oI/Kg+TUj5YTO3FX5
ILGT9khZhQWcAER2Hkecq3HlYEigfQaVDL64HunpqLqz4hKPPH8Kwtc36GKf8fJyLe9AAl6cR96g
UcAcHgvMEnTjomRKt2so6XZvZeVdre6qOib/zXd58VMnef8sechnW+vCm6R0jFf4NQus54nqdj2z
aTvr9xy3qVRAWyiMZr45sxM6bzhQm+6wffj8PfXvUq7gxHP22qZl+qSFJQcOO//Vhug0uEnNUBiJ
4BjqzbmbNsYxKWV6yKBFaUpXVoLBvdiylBSOIXtCY383OqcPfbMpYBpMrGptlMABHy9HpS6L4xKg
mb8V+lbiH+x+DZ9CnNcfr3Qc3Y0GVZs/7rAAMQ1dC0JXmDI/sir35fz7ly261RhQ7i5RZZSWhObK
BZA=
=tcia
-----END PGP SIGNATURE-----

--IzNzhYFZGqN1ffTl3m3fxfmR6UBUcCGtQ--
