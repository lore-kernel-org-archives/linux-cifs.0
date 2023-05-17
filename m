Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A865C77B75
	for <linux-cifs@archiver.kernel.org>; Wed, 17 May 2023 11:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjEQLZQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 May 2023 07:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbjEQLZQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 May 2023 07:25:16 -0400
X-Greylist: delayed 2092 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 17 May 2023 04:25:15 PDT
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 145883A90
        for <linux-cifs@vger.kernel.org>; Wed, 17 May 2023 04:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=05sK6Dgf5YCIrdK3jWZ7EbBHgxHfDf/ZqT56PL1HRZU=; b=C3P1luwoTNufQOb2+L0XJjws9o
        G5CTefPwjzNKUBme4pU8OxCDVVbIxG2b3BWWyCcL7IQS2ORzw39l/WSyR8w7ek4VVp1t9VNOd5BKy
        dZhHrtMqH+FqvVX1eAOFnUTAAdIaCcaQY4AGhQvh0Ha0XWLxrJZgl02zoAy+xufgHgHTvec0N8MRz
        r590Vff/s7+h78r8+RhdfO5jK3MEkTpLvdYkqBf4RsWCO+mlpIeFS8b8vl8CmmRfYjBsxYmu39Orp
        DoYdG5aBaYdOTkawXS35k06oWhCaNwSnBizDfSERwrMmahySR3NDGT/Hk6OvwY+tiIAYxzu+3CWQi
        NhVB/guPKqL2AolczXmx6Uq1aeuNRIti4km64AwDTaZUd7m8BIU3FNz+a3X8tp5p5AbluxQ3ZFfNV
        s7IZlWA/idrRHrDV/cQXiumlkxG/LhmlHySNht5oBSuzzwIwSGkreP88bN6GJfClVALdMznCXjQSG
        qLQpr271nCjQoA7TPKmmMkJ5;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pzEja-009WMa-LY; Wed, 17 May 2023 10:50:18 +0000
Message-ID: <8c79fa5a-d84b-13dc-73d6-27dbbd21dbfa@samba.org>
Date:   Wed, 17 May 2023 12:50:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] cifs: Close deferred files that may be open via hard
 links
Content-Language: en-US, de-DE
To:     Ross Lagerwall <ross.lagerwall@citrix.com>,
        Tom Talpey <tom@talpey.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Cc:     Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Rohith Surabattula <rohiths@microsoft.com>
References: <20230516150153.1864023-1-ross.lagerwall@citrix.com>
 <55740ab3-e020-df8c-07bc-02386486539f@talpey.com>
 <DM6PR03MB5372810EDDBE8C9A5192B1F3F07E9@DM6PR03MB5372.namprd03.prod.outlook.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <DM6PR03MB5372810EDDBE8C9A5192B1F3F07E9@DM6PR03MB5372.namprd03.prod.outlook.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------3AHEAzBgDjGuZzUw0rI0fgIG"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------3AHEAzBgDjGuZzUw0rI0fgIG
Content-Type: multipart/mixed; boundary="------------ADLAv35GnHLOSUpkDGTfOKNi";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Ross Lagerwall <ross.lagerwall@citrix.com>, Tom Talpey <tom@talpey.com>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
 Ronnie Sahlberg <lsahlber@redhat.com>, Shyam Prasad N
 <sprasad@microsoft.com>, Rohith Surabattula <rohiths@microsoft.com>
Message-ID: <8c79fa5a-d84b-13dc-73d6-27dbbd21dbfa@samba.org>
Subject: Re: [PATCH] cifs: Close deferred files that may be open via hard
 links
References: <20230516150153.1864023-1-ross.lagerwall@citrix.com>
 <55740ab3-e020-df8c-07bc-02386486539f@talpey.com>
 <DM6PR03MB5372810EDDBE8C9A5192B1F3F07E9@DM6PR03MB5372.namprd03.prod.outlook.com>
In-Reply-To: <DM6PR03MB5372810EDDBE8C9A5192B1F3F07E9@DM6PR03MB5372.namprd03.prod.outlook.com>

--------------ADLAv35GnHLOSUpkDGTfOKNi
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gNS8xNy8yMyAxMDoyNywgUm9zcyBMYWdlcndhbGwgd3JvdGU6DQo+IEluIGFueSBjYXNl
LCBJIGhhdmUgYXR0YWNoZWQgYSBwYWNrZXQgdHJhY2UgZnJvbSBydW5uaW5nIHRoZSBhYm92
ZQ0KPiBQeXRob24gcmVwcm9kdWNlci4NCg0KYWZhaWN0IHRoZSBTVEFUVVNfSU5WQUxJRF9Q
QVJBTUVURVIgY29tZXMgZnJvbSB0aGUgbGVhc2UgY29kZSBhcyB5b3UncmUgDQpwYXNzaW5n
IHRoZSBzYW1lIGxlYXNlIGtleSBmb3IgdGhlIG9wZW4gb24gdGhlIGxpbmsgd2hpY2ggaXMg
aWxsZWdhbCBhZmFpci4NCg0KQ2FuIHlvdSByZXRyeSB0aGUgZXhwZXJpbWVudCB3aXRob3V0
IHJlcXVlc3RpbmcgYSBsZWFzZSBvciBlbnN1cmluZyB0aGUgDQpzZWNvbmQgb3BlbiBvbiB0
aGUgbGluayB1c2VzIGEgZGlmZmVyZW50IGxlYXNlIGtleT8NCg0KLXNsb3cNCg==

--------------ADLAv35GnHLOSUpkDGTfOKNi--

--------------3AHEAzBgDjGuZzUw0rI0fgIG
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmRksWkFAwAAAAAACgkQqh6bcSY5nkZh
3w/9F+tvc4K/BYbAXKpQr9rL41oWtL9CgQ7URsOUgzPpoeFya5YM8K42cd+rF+gE7jJn2UHkn9AT
0SjB128nCLv64xoUqJRTRDVTvX4Qht0PMFtI6mC3C5CneurcW2kQxQ57ASByXdeI31M851u+k3oi
TDRna9WFKYha61U/3wjPIEiVEeKnqS2o9VpAd1NV2EpehTB31MIqJYy/o6KUiunhzF24py0aZLTA
akKy3Rie4t/t5dbfhKvYgDXpZiFjsyBqYXx2tci5LHsdfsPb7sTtgc8d5sqQDlDRcgEMcQYXjSPM
fhve7XR6NOV9Vd1W3fbEGsLi4V/NZFeI2oaZuXdGC9gEiMAdnJb+2Wh8guShfpOOZnkgPwNSMH8k
rrmVNZ2gQGrQgMTSsL1jeOaIMKUHnDQl/hsUwAmNDVq8IsFll5mF9ZZ/5Hx2bsVUuxYHnASEAWwk
Ysuy0njkcPbESbLnPtdNrfWcai0+y4CBi5vTztwEh3AvTnAbD49G35CiRlCTlS7raKRBrwq3tT7P
gY8o0wUh0NYgAu7H9TJuUEKBZ3dviJWVWFwVfemu9JDxWToPY8QPeX1yKazgVLR5xZZe5bwqw8+5
vgUU8rbYxQvoDy7foWlAlYhf3U9exiAsalH3FzlOxnStDE0ivDjcRIDdE90s/C9zLb065oQ1iEN5
rv0=
=J4wF
-----END PGP SIGNATURE-----

--------------3AHEAzBgDjGuZzUw0rI0fgIG--
