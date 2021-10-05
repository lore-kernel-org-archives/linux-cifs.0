Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B61C433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 19:28:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAF0261181
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 19:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235176AbhJETaG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 15:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhJETaG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Oct 2021 15:30:06 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72BE5C061749
        for <linux-cifs@vger.kernel.org>; Tue,  5 Oct 2021 12:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=vSZk50Yi28vjoO9j2DH8l1Q3NdLahZw3m0wPnwgqK7I=; b=vRtbTDsKHeFhpO5WRf4XAV+f0Y
        /0UkNPx+78ep+wOOG6oTsg/MDNyu5NGjXv6j56i/p0zR+As73BrfAQZo2xZrrlZfjmlS1xTVpnbvg
        w0InxMMfS5xjw25Y7JvqtJaWNUyReIIwVj8PHyOKgGKfHNWWiROP+8AaxeH9ketquPH2HNro06LDa
        3yAUgUbLxVNgq7GQBCCvdUWZlKYHiTr8HaeVIc64cHPIai/Oq/QUe8fJ4WM0k8kmV8OaWPK0Lfp0B
        +5a4oFV7gv7a+b/6O9YRdVyuxIm60JNMwIbJgUWPoj2Jv/urtJncePsQjc2J+EhzpIvq8aQhI/dZg
        8rl7hcs+nLoWQkp45BwMug4pnc1Zg9xg2f5dHfrYJIpdupVsQT5nknR1j41gg8c2vmY5e9H1u4nej
        GkBIzAYwmlFbXDZY/iP/j5ZDhpYsQ6iTLPr+K+CES309MF0Qfu1+Bs4a5Ya+k4ygW3+iMXchc67g3
        gk7wmEB32FJOJmHCtJ4A3YYF;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mXq6n-001hNc-BB; Tue, 05 Oct 2021 19:28:13 +0000
Message-ID: <cc20019e-7c51-1b8f-bc29-dcdaadeaed7b@samba.org>
Date:   Tue, 5 Oct 2021 21:28:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v6 07/14] ksmbd: use ksmbd_req_buf_next() in
 ksmbd_smb2_check_message()
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
References: <20211002131212.130629-1-slow@samba.org>
 <20211002131212.130629-8-slow@samba.org>
 <CAKYAXd_jYHCnUbOoBGpsAPo_=H3wsbXcE8LOaAgvZT+dXzpPEA@mail.gmail.com>
 <84fca1c3-2ee2-2a13-d367-6878b56f200a@samba.org>
 <CAH2r5mukpkfuf951rVC97EBA8KLVPc3chF2+33Ms31uR_ty5dg@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <CAH2r5mukpkfuf951rVC97EBA8KLVPc3chF2+33Ms31uR_ty5dg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------WMfW3ngQUlbHlD8BcoO5XcZJ"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------WMfW3ngQUlbHlD8BcoO5XcZJ
Content-Type: multipart/mixed; boundary="------------gqsXElebjNcCgd7B0Sr5EZ4F";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>,
 Tom Talpey <tom@talpey.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Hyunchul Lee <hyc.lee@gmail.com>
Message-ID: <cc20019e-7c51-1b8f-bc29-dcdaadeaed7b@samba.org>
Subject: Re: [PATCH v6 07/14] ksmbd: use ksmbd_req_buf_next() in
 ksmbd_smb2_check_message()
References: <20211002131212.130629-1-slow@samba.org>
 <20211002131212.130629-8-slow@samba.org>
 <CAKYAXd_jYHCnUbOoBGpsAPo_=H3wsbXcE8LOaAgvZT+dXzpPEA@mail.gmail.com>
 <84fca1c3-2ee2-2a13-d367-6878b56f200a@samba.org>
 <CAH2r5mukpkfuf951rVC97EBA8KLVPc3chF2+33Ms31uR_ty5dg@mail.gmail.com>
In-Reply-To: <CAH2r5mukpkfuf951rVC97EBA8KLVPc3chF2+33Ms31uR_ty5dg@mail.gmail.com>

--------------gqsXElebjNcCgd7B0Sr5EZ4F
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMDUuMTAuMjEgdW0gMjA6NDMgc2NocmllYiBTdGV2ZSBGcmVuY2g6DQo+IFR5cGljYWxs
eSBrZXJuZWwgc3R5bGUgZW5jb3VyYWdlcyBldmVuIGEgYnJpZWYgZGVzY3JpcHRpb24gaW4g
YWxsDQo+IGNoYW5nZXNldHMgKGV2ZW4gdHJpdmlhbCBvbmVzKSBlLmcuDQo+IA0KPiAiU2lt
cGxpZmllcyBtZXNzYWdlIHBhcnNpbmcgc2xpZ2h0bHkuICBObyBjaGFuZ2UgaW4gYmVoYXZp
b3IiDQoNClN1cmUsIEkgY291bGQgYWRkIHRoaXMuIE90b2gNCg0KYmNmMTMwZjlkZmJhY2Nm
OTEzNzZhNDRiMThmNTFlZDgwMDc4NDBkNg0KDQo6KQ0KDQpUbyBtZSBpdCBkb2Vzbid0IG1h
a2Ugc2Vuc2UuDQoNCkNoZWVycyENCi1zbG93DQoNCi0tIA0KUmFscGggQm9laG1lLCBTYW1i
YSBUZWFtICAgICAgICAgICAgICAgICBodHRwczovL3NhbWJhLm9yZy8NClNlck5ldCBTYW1i
YSBUZWFtIExlYWQgICAgICBodHRwczovL3Nlcm5ldC5kZS9lbi90ZWFtLXNhbWJhDQo=

--------------gqsXElebjNcCgd7B0Sr5EZ4F--

--------------WMfW3ngQUlbHlD8BcoO5XcZJ
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFcp0wFAwAAAAAACgkQqh6bcSY5nka7
MRAAslHBG6riIST3llAmCizszSivV/HT8NXG7ehUQ8+VuMtwoBMeYLXi6RmYZNjW+ZbKGVaNac82
9lIbJHOUoRCyxXme59XXcXAAojxZh81J4njjuYTDZEPNZbxbIfkGgpAwablhFMQBF5UppL3y2F/N
8M8eOvQkMlXcjgoKRHzo7WYZRoqqfbYWlZem4QtIhvH0u5vmHRzE4Cn+t4e59q2LUatHWl82Pu2W
eWTSDbmdgx4KGoIgP/ul6yUl/qA9jcQQn2pfswhwimR4If4jBPz89jawthjrDB+A6qe0z9sD1CSx
LhfYkElk1RgQQY4zBo6WucA7R0k2LJ6E/S71YPwOTkr4vCE/eygsub2NhPxUGgZEZnEkt7CAKP7X
WGD2Zabv3uV9oeQE5I/+/oBVjmsImakJTMJHbI/ju3fn8OUw+KjO4lWtlM26APzErJorBXz6Onk1
hlBXDwyAaZW7IcSSobNZ3/v51/wKNZ+NYiO1qGuiTn+Eg6Z42rd0dAT7Of6Shsr8jgWqD8rKaAPF
JXPOXrsW4Vbq03DRIGM5b3WNjqhnjQtdnPh3uB5QHv5YDvv7Zok2fXblNjh3Fm3B7NhNx4lE1jX1
+IGhsG5J/UbZDppJtvrbQsL1MwLYVkfmX7jgdqFOWyDoTAD0MYagONLt0Z0zhknbtvC2KSJViUEa
pqY=
=YxUl
-----END PGP SIGNATURE-----

--------------WMfW3ngQUlbHlD8BcoO5XcZJ--
