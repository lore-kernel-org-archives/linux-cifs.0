Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6495C433FE
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 07:46:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82D4261038
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 07:46:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhJEHs3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 03:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbhJEHs2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Oct 2021 03:48:28 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8F9C061745
        for <linux-cifs@vger.kernel.org>; Tue,  5 Oct 2021 00:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=3pgicdbRmVWMAtDPhbyns3zHXMpFnlYunosspXiqYu8=; b=il1SlE7wzS8i5bb0KYHMt4SmaH
        kYCd+32ih+j+dwhv0+Kso0AyNl0NtOJBqxgAMZwQkdeQg1ODQN5N1Rt7cgHa+H86srWd00tgVV5BV
        NfTtH/H8XaURDyCFtVpJ0YnWUlJOPwZ6HaqBbcvyRGAZ/yqGlwpQ3tFLUOY5/Qu3X8YTt0ZxG3Rjh
        9RGUW97sw+qJnC/naFOGtP+ununyfcPIL2eQt6Qu/FJbWqYPc9+VwWYW+ZqOGnpKObT6I8e6sSIgX
        WgsDwBlJO4M7fQ3xg2hGfYXjnPYvPMX3k5kF1HRAqVX2NcBAh2Vk3ILt2wX0VclfDy3F7oI7ed4wd
        J6fxTA8f6sZ3S1REPQtjhE8AkHUdy759TPQvKfdR4ujVxNAQjkFtaG+DXXapoYiANm3JNVaIFjUKH
        4I2t7zXaDqjxIOulIO0/9KN9fWcDYJl2gPRr+YKNMtdAoqUX0ZCigJqkVA/mWW/TYuOs98MRChjDJ
        CwJMOna4KyxWrtgFPFpwS1C4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mXf9m-001bOi-Pt; Tue, 05 Oct 2021 07:46:34 +0000
Message-ID: <2565d01b-0145-fe8b-1ce4-9c8f2e658b62@samba.org>
Date:   Tue, 5 Oct 2021 09:46:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v7 3/9] ksmbd: add and use ksmbd_smb2_cur_pdu_buflen() in
 ksmbd_smb2_check_message()
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
References: <20211005050343.268514-1-slow@samba.org>
 <20211005050343.268514-4-slow@samba.org>
 <CAKYAXd8TxcswXC3oySaLKOuCGzV2Dvfdv_1DaG9S_ErY_MvDMQ@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <CAKYAXd8TxcswXC3oySaLKOuCGzV2Dvfdv_1DaG9S_ErY_MvDMQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------nFAVWxW7eiYqn0yKOhLOj0L6"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------nFAVWxW7eiYqn0yKOhLOj0L6
Content-Type: multipart/mixed; boundary="------------ipoBx5C5Y6NyIIrHlRslevmY";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Steve French
 <smfrench@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>
Message-ID: <2565d01b-0145-fe8b-1ce4-9c8f2e658b62@samba.org>
Subject: Re: [PATCH v7 3/9] ksmbd: add and use ksmbd_smb2_cur_pdu_buflen() in
 ksmbd_smb2_check_message()
References: <20211005050343.268514-1-slow@samba.org>
 <20211005050343.268514-4-slow@samba.org>
 <CAKYAXd8TxcswXC3oySaLKOuCGzV2Dvfdv_1DaG9S_ErY_MvDMQ@mail.gmail.com>
In-Reply-To: <CAKYAXd8TxcswXC3oySaLKOuCGzV2Dvfdv_1DaG9S_ErY_MvDMQ@mail.gmail.com>

--------------ipoBx5C5Y6NyIIrHlRslevmY
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMDUuMTAuMjEgdW0gMDk6Mjkgc2NocmllYiBOYW1qYWUgSmVvbjoNCj4gMjAyMS0xMC0w
NSAxNDowMyBHTVQrMDk6MDAsIFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1iYS5vcmc+Og0KPj4g
LQkJaWYgKEFMSUdOKGNsY19sZW4sIDgpID09IGxlbikNCj4+ICsJCWlmIChBTElHTihjbGNf
bGVuLCA4KSA9PSBBTElHTihsZW4sIDgpKQ0KPiBDYW4gSSBrbm93IHdoeSB5b3UgYWxpZ24g
cmZjMTAwMiBsZW4gd2l0aCA4IGhlcmUgPw0KDQp0aGlzIHNob3VsZCBtYXRjaCB0aGUgcHJl
dmlvdXMgYmVoYXZpb3VyIHdoZXJlIGZvciBjb21wb3VuZCByZXF1ZXN0cyB3ZSANCmNhbGxl
ZCByb3VuZF91cChsZW4sIDgpLg0KDQpUaGlzIGNvdWxkIGJlIGRvbmUgZGlmZmVyZW50bHkg
dGhvdWdoOg0KDQpsZW4gPSBrc21iZF9zbWIyX2N1cl9wZHVfYnVmbGVuKHdvcmspOw0KaWYg
KHdvcmstPm5leHRfc21iMl9yY3ZfaGRyX29mZikNCiAgICAgICAgIGxlbiA9IEFMSUdOKGxl
biwgOCk7DQoNCmFuZCB0aGVuIGp1c3QgZG8NCg0KICAgICAgICAgICAgICAgICBpZiAoQUxJ
R04oY2xjX2xlbiwgOCkgPT0gbGVuKQ0KDQotc2xvdw0KDQotLSANClJhbHBoIEJvZWhtZSwg
U2FtYmEgVGVhbSAgICAgICAgICAgICAgICAgaHR0cHM6Ly9zYW1iYS5vcmcvDQpTZXJOZXQg
U2FtYmEgVGVhbSBMZWFkICAgICAgaHR0cHM6Ly9zZXJuZXQuZGUvZW4vdGVhbS1zYW1iYQ0K


--------------ipoBx5C5Y6NyIIrHlRslevmY--

--------------nFAVWxW7eiYqn0yKOhLOj0L6
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFcAtgFAwAAAAAACgkQqh6bcSY5nkY4
AQ//bB/V/08UN84D1hJD1679NfL5dTb5c86KdjYAtuqHsFYftGxFbGB0Z+x7O3xIEzsvOZIe6VNo
IoY+G2rhPbPetp3Vi0wvMSu47vc+qCPt5THSi5gY8yXa8U4fjTpsZVzYqY4chqLxHp25tJyf/YtY
h12bF0eLx4Rnq+D8yuqQmJFEtwQkyysz39UApjpeqnNXVJ3tsPOpl4ermrymT/RGOU27i5jOa5Ux
TZE7hqm7cfd/Nd9UZq9rzeShokl4uBjSvafVnkovLOx/S+AI9WdrHgyBFIIQu96bYzHw+8+xOceo
2ORZb4cz/jTSGuKkutAeFAdJHAWJuQcPFMsYo5W/bhe4I5pIOEKGemLcfX+0B2SwdfpgsQuSRqsg
pwMYJqhWaGobHSFgAJ0Fbu8mem1ViLPuIn9nFRTzXM2XnHUXq+UxFmcS9Z6gw5/d+mDIAO/Ty6y8
G84CLlc2AXY4T5LWJiHfa+/btv/1jxuKGIn5jKrdVZReuXZYS4aCsboF3IBcHNiQHekgKVZcCSFe
djgvJWauCimUYeJQgOXPxNrKjif3xgAlW2Py/wJ0XAUUezCy3EQL8lni95cS6+50W/vpaFPLywsg
3KsdurtS50ZcceuKMgED6QlmA4bvm3iEaZWTO82AXzNznlkzCqlCDopX9+wOPGjusXvkHdJXZV3D
RBw=
=lx7v
-----END PGP SIGNATURE-----

--------------nFAVWxW7eiYqn0yKOhLOj0L6--
