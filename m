Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F472C433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 08:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3C8961184
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Oct 2021 08:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237832AbhJFIwg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Oct 2021 04:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237703AbhJFIwf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 6 Oct 2021 04:52:35 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0B6DC061749
        for <linux-cifs@vger.kernel.org>; Wed,  6 Oct 2021 01:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=0I9LdEhLHU6em9MUnwphc+DYh6YadIdSbV55cpLtGHs=; b=oYe9E7G0xovyIpDI3tS8qSwNnU
        eaH3Qez6xFB4/JrdSGMemPXivk704BNX6Ff1MhMdesbueSknaGufx4Rq7/gn6WTY4YbdjyaLTUidW
        1311Pqv0nCyfZuPaTDa0nBE86xoHDybEv9L73As3Da2x/bL7rsvLwYq6+ALImuj7eN/zfMnwSJc2L
        JZPPtu0M1I1/Yji6sZy+alQVd/M5st7v0w/Q/vyZLFYKSxt4+YEumYOv9L/i3qOj4zen/v7gIaeJz
        ZD+EbM049DMEs6ptLcwpjVi7ctnAwVJMiwzyFyilnWR2IiJw6G9xPIWPrK2ElNfmf3W/8m3Dgl6oW
        ya2pSgUWoqrdCl2ixxBkCj7126uGrovv6Pmcj1ktzh9sm1OXBd4BKlAeBL3i5j3YSHy6xsWjotU+K
        smdThMA+VDalTcFoRCRaVCqFZ/i5MUquOSGD2qmChG87WZIoEuR/RLMwRiIhmrQAqDcpQBgKNIyMP
        mm8Tcfh82PuLiDSm2ceVmISX;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mY2dN-001nLU-47; Wed, 06 Oct 2021 08:50:41 +0000
Message-ID: <64519e7d-d82f-91f6-5c8c-ce9aa8935b30@samba.org>
Date:   Wed, 6 Oct 2021 10:50:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] ksmbd: improve credits management
Content-Language: en-US
To:     Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
References: <20211005100026.250280-1-hyc.lee@gmail.com>
 <de0ecb81-0313-266e-cc5b-94ec40201141@samba.org>
 <CANFS6basCNTcN7Myz0bAd_LTXEji43HiqLE0B8McpaemUjSp8Q@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <CANFS6basCNTcN7Myz0bAd_LTXEji43HiqLE0B8McpaemUjSp8Q@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------JFzpnDdJzzAC5P4BbX0p7dPc"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------JFzpnDdJzzAC5P4BbX0p7dPc
Content-Type: multipart/mixed; boundary="------------gorU1g8rR7B1qQtuv0KFBeDI";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Hyunchul Lee <hyc.lee@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs <linux-cifs@vger.kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Steve French <smfrench@gmail.com>
Message-ID: <64519e7d-d82f-91f6-5c8c-ce9aa8935b30@samba.org>
Subject: Re: [PATCH] ksmbd: improve credits management
References: <20211005100026.250280-1-hyc.lee@gmail.com>
 <de0ecb81-0313-266e-cc5b-94ec40201141@samba.org>
 <CANFS6basCNTcN7Myz0bAd_LTXEji43HiqLE0B8McpaemUjSp8Q@mail.gmail.com>
In-Reply-To: <CANFS6basCNTcN7Myz0bAd_LTXEji43HiqLE0B8McpaemUjSp8Q@mail.gmail.com>

--------------gorU1g8rR7B1qQtuv0KFBeDI
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMDYuMTAuMjEgdW0gMTA6NDMgc2NocmllYiBIeXVuY2h1bCBMZWU6DQo+IE9rYXksIEkg
d2lsbCBkcm9wIHRoaXMgaW4gdGhlIHBhdGNoLiBBbmQgY291bGQgeW91IGVsYWJvcmF0ZQ0K
PiBvbiB0aGUgc2l0dWF0aW9uIHRoYXQgY2xpZW50cyBjYXVzZSB0aGUgcHJvYmxlbT8NCg0K
dGhlIGNsaWVudCB3aWxsIGp1c3Qgc3dhbXAgeW91IHdpdGggSU8gcmVxdWVzdHMgYW5kIHlv
dSd2ZSBsb3N0IGNvbnRyb2wgDQpvdmVyIHRoZSBjcmVkaXR0aW5nIHdpbmRvdy4gSWlyYyBp
biBTYW1iYSB0aGlzIHJlc3VsdGVkIGluIE9PTSBkdWUgdG8gDQp0aGUgbWFueSBidWZmZXIg
YWxsb2NhdGlvbnMgZm9yIHRoZSBpbi1wcm9jZXNzIElPIHJlcXVlc3RzLg0KDQotc2xvdw0K
DQotLSANClJhbHBoIEJvZWhtZSwgU2FtYmEgVGVhbSAgICAgICAgICAgICAgICAgaHR0cHM6
Ly9zYW1iYS5vcmcvDQpTZXJOZXQgU2FtYmEgVGVhbSBMZWFkICAgICAgaHR0cHM6Ly9zZXJu
ZXQuZGUvZW4vdGVhbS1zYW1iYQ0K

--------------gorU1g8rR7B1qQtuv0KFBeDI--

--------------JFzpnDdJzzAC5P4BbX0p7dPc
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFdY2AFAwAAAAAACgkQqh6bcSY5nkZo
EQ//ef3N96G9eCOnknEWVmaOqsTYvsfognzMkhomX7HtbC/l1LdGb471GTG7TcGBYp3mL+gy3Y5L
xFxHcSY82nFCCcHad3t2u0/i+y/DDPhqzLT/9KXAV72RXAiSXi9NeAWTm6i9g/wDLsATIaTLe3Hm
3G8EsRvYcxNfq2IQgevGeTWRXOVEn4NdMuZBS3V/PJ5wN6qlnqyC27RmHRmfd2XH8SWj/4+6X1DH
pIx62W4+mceU4uIB/H36kQSw+F63c/k9NS10OES0R7Pabyhz70oQgLUM6NZ3lqMjGt0uMsvV0r36
yhk4QdoDHgWxGfnpdkdq9Bfo0piqRiBgPUudlPQxIS8WGcuga2di+MA8FSXcySkJAnTdXPniFHyk
vGvgYiXJ6aY64EVRhA3dMzM0YZ0EcUb6hQ9Ib2fzdpzcFf65FyTlB8DQfg4fKRUiOU0p37xjH5bu
uDA8RoNYUTm8nN4hkjGYWoVEPaMYqUk5mSprLlRG5S73FSHS1iZssMFIf/snehHozcZVqk1dJvok
MiNIVarwFpbE1AT0tt1uurakyK1ia7lQPAlglHwfH/bqoycSC0e4ym8QWChUSBe0/kCZWzPt5bl/
ueT0ExZC2gMNv7Q5lL5uQKQU19uf/lgNjC4CKPqNk/AJ4wYpM5TnY45ZK1TFocjBNuru3xjZ6Zix
zjw=
=g2PT
-----END PGP SIGNATURE-----

--------------JFzpnDdJzzAC5P4BbX0p7dPc--
