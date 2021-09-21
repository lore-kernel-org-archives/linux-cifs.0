Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B883C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 08:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD53D61181
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 08:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhIUILC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Sep 2021 04:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhIUILB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Sep 2021 04:11:01 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB76DC061574
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 01:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Date:Message-ID:From:Cc:To;
        bh=ZhUNTWsUHLEf11FmK3d26Tm4t2dU93MjIRyDaivdoLE=; b=TRDuTNr1phTpsa+0JHVcZWD+65
        DtmxGo8Cts3gQvFEPusVMsVi/7vWzKiQ8gMKucFE2AsOghHkBJAHCQxn2fdT9KjS1cx5BHMnoImSq
        z5oAZGXraE11wuCN9mTxj5KmNialLOW1KkC9tPBCtvjrsgafnpGd6TqkgpsSduQQbcCnrORw8pxt+
        39sLn88Y1cHc2SNrAfLOnTk8yUfL147pysxQ4NZvkBEC545l24K7y3F4BSL+q0xd6jKkjnLghFXB6
        Q7bb14Dd6bO8PPIozOG/j7w3jHXvHY3eeBApNCNbWcQSbSDvOpY/dKWLI0Y6XwME74tu8wgAoZQFO
        cWzD43K4uBsLmytg+CpeW6N8Enp3GV8neIUPtHNJmmBc9bdI0lImiFlSon32FqJXuss8dNcHOtzPu
        kM4Iai2WZG2GQ4avnrVtR5rJk86HXqPItqGQts/SChJBg7tqsJ1pfwxSyEels0+G1o5R0qyp16u/i
        M5AdhwE7bdm9KUQC6+xoEFZd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mSaqJ-0077nO-TW; Tue, 21 Sep 2021 08:09:32 +0000
Subject: Re: [PATCH v2 3/4] ksmbd: add validation for FILE_FULL_EA_INFORMATION
 of smb2_get_info
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
References: <20210919021315.642856-1-linkinjeon@kernel.org>
 <20210919021315.642856-4-linkinjeon@kernel.org>
From:   Ralph Boehme <slow@samba.org>
Message-ID: <d283266c-64a6-8e1b-7e92-964b8b8d8686@samba.org>
Date:   Tue, 21 Sep 2021 10:09:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210919021315.642856-4-linkinjeon@kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="luDQYENZItuHaeFVBoXuDf9TVt5Kjn0Ff"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--luDQYENZItuHaeFVBoXuDf9TVt5Kjn0Ff
Content-Type: multipart/mixed; boundary="0gyTisoBdMsVGhEiiZqpuwBRkgIhBvwho";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Steve French <smfrench@gmail.com>
Message-ID: <d283266c-64a6-8e1b-7e92-964b8b8d8686@samba.org>
Subject: Re: [PATCH v2 3/4] ksmbd: add validation for FILE_FULL_EA_INFORMATION
 of smb2_get_info
References: <20210919021315.642856-1-linkinjeon@kernel.org>
 <20210919021315.642856-4-linkinjeon@kernel.org>
In-Reply-To: <20210919021315.642856-4-linkinjeon@kernel.org>

--0gyTisoBdMsVGhEiiZqpuwBRkgIhBvwho
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Am 19.09.21 um 04:13 schrieb Namjae Jeon:
> Add validation to check whether req->InputBufferLength is smaller than
> smb2_ea_info_req structure size.
>=20
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Ralph B=C3=B6hme <slow@samba.org>
> Cc: Steve French <smfrench@gmail.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>

reviewed-by: me.

Thanks!
-slow

--=20
Ralph Boehme, Samba Team                 https://samba.org/
SerNet Samba Team Lead      https://sernet.de/en/team-samba


--0gyTisoBdMsVGhEiiZqpuwBRkgIhBvwho--

--luDQYENZItuHaeFVBoXuDf9TVt5Kjn0Ff
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFJkzsFAwAAAAAACgkQqh6bcSY5nkaS
/BAAgyuuy3i2vW0qIkE6s9QszAF4KeWM5Jw45BJB4ugTFoXLsBcOlR1QSsrroDNbeDSUfbnlbcyg
ge8EKBcOFsdHvSe+eQoCNoekcgRlGHJ2rolZAEpQvn2o0Qs9rQ2mBxhk9GICBc5ZpaYfEKDLG7EE
qjbDCLbUZ+QbbmHQY+V+oXkt9UEJN+ZUsfk52K3dUvUzp0vX3Kc+Y5PT886fxme2aTtdSf7x1BLx
t30F0ao04ayMwkCg+fkp6RH+GT3VZ/dp3Ux5u7lAVhSifJ3F/B1VL8hYY6hSRTCm8s+kkdVhap+L
orYBqBE9Cj2TZzsV/x/31GmXkRwz0gItYsVkGsuNKqTcHwqnO81A0udZJigAwFLuiu7FEM6YNKW/
TK3acyN2aLJGPCpnxouswTCr01BwhKU3kfK4kznTF2S9CLXjKWz/DI2HkAPwkx7vshfBwDICSbku
pjvFgYQ5qxQNhIuZVBnRyQid/Jid6SKhMgdwygc1DBHKjoRDnu2VWHLiYxYCGiwR54XR+nug+8qw
iD+XN5evttfC/Y5pjlm2mSZQVObTkJPgzYTwm5ZM9/fF+Z/6QWkn0SgJjQHtN6mlevpXnpi3QBFm
VJFlhwa23Re+ckCycr9My1gCoq1YOGnRP0apEDNHLcnv8zbBmgDUVcRKkmGhAjimxA5P4wcaF7m6
ym8=
=wZIh
-----END PGP SIGNATURE-----

--luDQYENZItuHaeFVBoXuDf9TVt5Kjn0Ff--
