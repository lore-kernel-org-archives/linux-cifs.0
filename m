Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C85FC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 13:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEBDD61153
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 13:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232339AbhIVNkx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 09:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232301AbhIVNkv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Sep 2021 09:40:51 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4F0DC061574
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 06:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=bCDi+ieacjYC8JSdokjZzuqTTjI5WCp6WoCmdvWXUbg=; b=10euabEsyDiwUycYMARM0BpWju
        51mqWNfg2Z7/ZCQfVSNcteN50xwm6i6oroxRsCMTUK7n58oD9yVWnvokWQln/4M3BYeIR3eAS7QiC
        mzs8iIwdVhhA4LYmqm1YBlJ4lMISMLRYFn1gkzbAOms0Bgm/LfjyUcZxd7QPapKbbeFt3FnXFYimZ
        Jft41ApLvp9rbLrBnvHU/yTaEKAdFXG6aOoyAt0h7gfO+qCe8iDBrwKDm2ifEU/gkVuUEWj8fywYV
        r7CAgeSJ+gVPfISDtTW8PFxIA/CXt7AiTkU0M3M//T9xh0+SKwnQ1ZLml1XORjrXxD+F+EcbADgWw
        jLnRXMYNvA4GKrbfvBIHDJagLbHa2joPxqTywXJgO9yXwJB48akwZqVEzq14pwOl9mmIIJ93V5jq2
        07P2SritWtDPeOHHsmj1pp9YXQjpIaA21ta8XIRCD3ZcCn1B+8ngjyHGWuB503Hs4VRcoGZeg/fI4
        9K4Xr5tazcj/MdKPZf0aeq6o;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mT2T1-007Ke5-7Y; Wed, 22 Sep 2021 13:39:19 +0000
Subject: Re: [PATCH v3] ksmbd: add request buffer validation in smb2_set_info
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
References: <20210922041932.663796-1-linkinjeon@kernel.org>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <aec0390e-fca6-bb2b-f8e5-3b2336042e48@samba.org>
Date:   Wed, 22 Sep 2021 15:39:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210922041932.663796-1-linkinjeon@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rqgN9AdJNlOr0obrkqS8dua8VeJ4d7DyX"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rqgN9AdJNlOr0obrkqS8dua8VeJ4d7DyX
Content-Type: multipart/mixed; boundary="bEYrhTKsGhs92qxNFImmpWeCubf4eFiau";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: Tom Talpey <tom@talpey.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Steve French <smfrench@gmail.com>
Message-ID: <aec0390e-fca6-bb2b-f8e5-3b2336042e48@samba.org>
Subject: Re: [PATCH v3] ksmbd: add request buffer validation in smb2_set_info
References: <20210922041932.663796-1-linkinjeon@kernel.org>
In-Reply-To: <20210922041932.663796-1-linkinjeon@kernel.org>

--bEYrhTKsGhs92qxNFImmpWeCubf4eFiau
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Namjae,

patch looks great. One nitpick.

Am 22.09.21 um 06:19 schrieb Namjae Jeon:
> Add buffer validation in smb2_set_info, and remove unused variable
> in set_file_basic_info. and smb2_set_info infolevel functions take
> structure pointer argument.
> ...
> +struct smb2_file_basic_info { /* data block encoding of response to le=
vel 18 */
> +	__le64 CreationTime;	/* Beginning of FILE_BASIC_INFO equivalent */
> +	__le64 LastAccessTime;
> +	__le64 LastWriteTime;
> +	__le64 ChangeTime;
> +	__le32 Attributes;
> +	__u32  Pad1;		/* End of FILE_BASIC_INFO_INFO equivalent */
> +} __packed;
> +

adding struct smb2_file_basic_info and the fix in the handler should be=20
done in a preceeding commit.

Thanks!
-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--bEYrhTKsGhs92qxNFImmpWeCubf4eFiau--

--rqgN9AdJNlOr0obrkqS8dua8VeJ4d7DyX
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFLMgYFAwAAAAAACgkQqh6bcSY5nkYY
nQ/9Er2zkbjPaHRTfFGFrL5RqGcPtHTL1Vd5GMExEaoe3vObfDvSpz6R8da3Vbt7F+m39dub2uvn
FympdBPTGDIJ2E9DSe6aQkE2rk7l0UPil5FiS/pYj6Yp5NXOcJPK69eM9HnRLz0y4NxBz+jZ+URD
gUCKsWkxxBdupmVrcMEinlM7fiRIluKARtJCrK4CUvvd/L36zlMQ4c+u4yioHcHsmfM8ZRg0s1Xf
PYfk1VBtE7ogCx62l4iI29E6wxYN0TUCAsve2cAxTEKdXeAPa+fb5PkL7y0ncyejw53OHy4EcUM+
2Rqa7pL8m4pBIiUeud7lybtQveqLt0Aa1qqkJqpj3fwJij8QN1QwzXo72BU2dTu6LOqv0oyJyb0i
Utk0vBgTgeLXE+OfElx7ix0T6VsbejZDKEPk9RVohmgSOC1+ad/21AgfCggFjSwnYAPhPklnmnL1
keUmqm91hOZ1xJvMWcPTNtAmvgK7VZFhbWrXEOPImYwuv8kG2050wCHn4OnBIesO7kL7shp64gjN
6bB8Sc2GAeUNOiQALSltZEbADIAwPDitoHed4BI+SNMwAWeB554avmSxUDGK0KtSXiZZJTDQJ2rZ
o5ejGmBFPP67v8fwso0U5YV1B1WpsAPIWDctOvW3uKzt2KDafrYJFbJMqCtgBYHt54NYqAz3z0+0
0iE=
=zWs/
-----END PGP SIGNATURE-----

--rqgN9AdJNlOr0obrkqS8dua8VeJ4d7DyX--
