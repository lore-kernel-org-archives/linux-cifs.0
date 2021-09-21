Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1234C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 07:38:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0FA860F6B
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 07:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhIUHkV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 03:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbhIUHkV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Sep 2021 03:40:21 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B4FC061574
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 00:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=FwR9rMLLI+BTQCJw8XtXkgZxnrkxV7cAzZPJ40KEvv8=; b=1wSEuBmCP8Jn72kZHIdYeYq0PB
        S2jkNxAulYdKYQ3Cmt/22hSqI/SXTgiFOCANULi9pgPHWpbNLUBOefqsIaz9CIaVsflg+phsjGmol
        womBb9FzIi++hKNymSZqgZx85Fst4iLdUSd0mqSW3SgIV2OdpusQNPCLW13SZhdzfLRYWwgr+KZ57
        9tKttJ2wHWXJBR1R7KXdn3C9TSNyc9npCTVoIQms1vCy6InKVGzTr/hhgGtHYlK8emj/uSQK/c3Wt
        tVPWTt5pTvGTbckPstVzdExsr0guMolLa7B4yvSBr45d7MSEmc94tA+7IeYZtdKlLAmjb3pEKO8Gh
        5VXmUEAoSrd9bdYAycglOeZAtflZPA1UgdnrmTqCbPNmJrDqrfMM3FH1dfT2SfQt41im3ptqujSTG
        a607WHRM/xp3zZ4Ww36NhpH9aES2n3nraeauKMN3jgFiv91p+qpEq0UdZg8wrOfHqr1JRU9CIKcT5
        +pHBBaaeMTpjImy1h8Vnf3Qz;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mSaMc-0077cm-SM; Tue, 21 Sep 2021 07:38:51 +0000
Subject: Re: [PATCH v2] ksmbd: add request buffer validation in smb2_set_info
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
References: <20210921044040.624769-1-linkinjeon@kernel.org>
 <20210921044040.624769-2-linkinjeon@kernel.org>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <d9f2a3c9-b9fb-9896-b318-466563e9cd56@samba.org>
Date:   Tue, 21 Sep 2021 09:38:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210921044040.624769-2-linkinjeon@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fBlGQpGy8flkyPxPdPXQuasXMlSo5Bqqe"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fBlGQpGy8flkyPxPdPXQuasXMlSo5Bqqe
Content-Type: multipart/mixed; boundary="d8wWkM6Z6bbNBqjgeU8ySJA2xeKF17Em4";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Steve French <smfrench@gmail.com>
Message-ID: <d9f2a3c9-b9fb-9896-b318-466563e9cd56@samba.org>
Subject: Re: [PATCH v2] ksmbd: add request buffer validation in smb2_set_info
References: <20210921044040.624769-1-linkinjeon@kernel.org>
 <20210921044040.624769-2-linkinjeon@kernel.org>
In-Reply-To: <20210921044040.624769-2-linkinjeon@kernel.org>

--d8wWkM6Z6bbNBqjgeU8ySJA2xeKF17Em4
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Namjae,


Am 21.09.21 um 06:40 schrieb Namjae Jeon:
> Add buffer validation in smb2_set_info.
>=20
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   v2:
>     - smb2_set_info infolevel functions take structure pointer argument=
=2E
>=20

perfect, thanks! One nitpick: we should either split out the=20
smb2_file_basic_info fix into a preceeding commit or at least mention it =

in the commit message.

With that change: reviewed-by: me.

Thanks!
-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--d8wWkM6Z6bbNBqjgeU8ySJA2xeKF17Em4--

--fBlGQpGy8flkyPxPdPXQuasXMlSo5Bqqe
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFJjAkFAwAAAAAACgkQqh6bcSY5nka1
exAAgF0eqf5nMekx3jmkVJi9YrRo2I3/WhfVnkeES2xSTGJw2tOwCvbRy0jAnwYM4xbyN7/cKSJZ
DvToSGHnfsZ32b0JWKW4pPOtt4Z2cgbD/F2K1V9kiK/YdeLcJpf9Gr45cevAE9P6snOQQNqruwzs
Buh+K481gm4UJdFNPs2A2gHSSQI/VVXIVGx7dEF8bgOQwq/+OQB/KGwpVv75+eRrnYQzku9L1dNI
QmIj8zHmWojp0Sqn00CueEM2I3AmlL5CuFVEEDya1Cy/OeH0topZ8DKNpfkF9bHTQ1skwyN0umUh
nDW96Ol4lq1nKuhX72+4y4on7ImjAOGmBF/wBPBOLGhTkhFa6Aj8h3LfStuym+pDKhbRV82obTG/
dCLH9UdsWJwsgv6hwpOfEHw3MvylS4IU3zCD3qq2XeXBasWI0LGUID7f6sI32CZ6oKidWYYtW+9H
RxmII2bxEx5mOUD6AnGBoXx4Sm/nJ5haewzED1C85gNMa+YQTXnacSmf0/pNSwUadcvptN7OdO2B
YuNtbbkYfXUyY7yQkNQ4Rk95tHnS6+YqBYTzawAfzJ0z3gWEzZqSG1ZZGy18ss9fVzONFNS/e+K+
nrkgaBFJdWQym7zmpAqSjzmKe6BO5NJid2RxIWw//1kiXbN8U0uFwMlqjOtSsR42+eK8IsMRmxay
xcU=
=6d+5
-----END PGP SIGNATURE-----

--fBlGQpGy8flkyPxPdPXQuasXMlSo5Bqqe--
