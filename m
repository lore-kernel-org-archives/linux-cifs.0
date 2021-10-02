Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CDBC433F5
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 12:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91EA261B07
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 12:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbhJBMKH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 08:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbhJBMKD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Oct 2021 08:10:03 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08AE0C061570
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 05:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=spUg7Q3SJGZkVEPjgiONMRgKTIzCbAKsWWiEMKUyCyg=; b=vb58QA5Ty/URB0MvF3w3JtgNo0
        nllI7iIH7jVHziRG+nwEVWDCGATEer2Lz9N2dzobmIU1WHrqhRawL5EBaMOS3x172dsSQcv1a5a0h
        ONLSEpRfhcy+wKmaAbg3VnXQdkDgDXPfHPEm2ODJVnfmvI93/nGYZf7VbFPEW6+06xwP3l2d4iS+0
        R/N7/6EDzCxjbhv3UDiTat3Ithig8/zMMZgtaauCpxw6CXsL9RHFYUalTE5Rzg4ULKyzb/LDIEvn5
        LMZzi9yd9/hBz2X7kwzlCce3stR9XTSZHsFCa6/v+WyU1ucW6PAl688cP7LaMx4ah9g8QGH6+4ww6
        0gHsze5sGeTm5SIwqvprxa+1E9e0I9/vVmTatALMQkXi1A0ToWnMJhsbheAIRNdCf/38BQDIm5jlu
        cyTD1OF4QUuFZbrUxfkYNd8mxqkphuzWNX8s51Xye+cqWfhIvjL7b9wSHaeApvKLFxMGBH0Hy+XNp
        XKeUGEztdUB/UE7K2gorLPAE;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWdoO-001DLW-5I; Sat, 02 Oct 2021 12:08:16 +0000
Message-ID: <93da95f5-231d-7f06-f3e7-3209f84b395d@samba.org>
Date:   Sat, 2 Oct 2021 14:08:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v5 18/20] ksmdb: make smb2_get_ksmbd_tcon() callable with
 chained PDUs
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
References: <20211001120421.327245-1-slow@samba.org>
 <20211001120421.327245-19-slow@samba.org>
 <CAKYAXd_rfAXxhzPmr6rkZB2m5uJKSyD7qQqHempE7cCYdr1WQQ@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <CAKYAXd_rfAXxhzPmr6rkZB2m5uJKSyD7qQqHempE7cCYdr1WQQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------GTL3qzOoQ1vYPVLrdNtKCzAp"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------GTL3qzOoQ1vYPVLrdNtKCzAp
Content-Type: multipart/mixed; boundary="------------MmmvSM2bnZZeN9TKdacXSw0P";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Steve French
 <smfrench@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>
Message-ID: <93da95f5-231d-7f06-f3e7-3209f84b395d@samba.org>
Subject: Re: [PATCH v5 18/20] ksmdb: make smb2_get_ksmbd_tcon() callable with
 chained PDUs
References: <20211001120421.327245-1-slow@samba.org>
 <20211001120421.327245-19-slow@samba.org>
 <CAKYAXd_rfAXxhzPmr6rkZB2m5uJKSyD7qQqHempE7cCYdr1WQQ@mail.gmail.com>
In-Reply-To: <CAKYAXd_rfAXxhzPmr6rkZB2m5uJKSyD7qQqHempE7cCYdr1WQQ@mail.gmail.com>

--------------MmmvSM2bnZZeN9TKdacXSw0P
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMDIuMTAuMjEgdW0gMDg6MDAgc2NocmllYiBOYW1qYWUgSmVvbjoNCj4gMjAyMS0xMC0w
MSAyMTowNCBHTVQrMDk6MDAsIFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1iYS5vcmc+Og0KPj4g
QWxzbyB0cmFjayB0aGUgdGNvbiBpZCBvZiBjb21wb3VuZCByZXF1ZXN0cy4NCj4+DQo+PiBD
YzogTmFtamFlIEplb24gPGxpbmtpbmplb25Aa2VybmVsLm9yZz4NCj4+IENjOiBUb20gVGFs
cGV5IDx0b21AdGFscGV5LmNvbT4NCj4+IENjOiBSb25uaWUgU2FobGJlcmcgPHJvbm5pZXNh
aGxiZXJnQGdtYWlsLmNvbT4NCj4+IENjOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWls
LmNvbT4NCj4+IENjOiBIeXVuY2h1bCBMZWUgPGh5Yy5sZWVAZ21haWwuY29tPg0KPj4gU2ln
bmVkLW9mZi1ieTogUmFscGggQm9laG1lIDxzbG93QHNhbWJhLm9yZz4NCj4+IC0tLQ0KPj4g
ICBmcy9rc21iZC9rc21iZF93b3JrLmggfCAxICsNCj4+ICAgZnMva3NtYmQvc21iMnBkdS5j
ICAgIHwgOSArKysrKysrKy0NCj4+ICAgMiBmaWxlcyBjaGFuZ2VkLCA5IGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb24oLSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZnMva3NtYmQva3NtYmRf
d29yay5oIGIvZnMva3NtYmQva3NtYmRfd29yay5oDQo+PiBpbmRleCBmNzE1NmJjNTAwNDku
LjkxMzYzZDUwODkwOSAxMDA2NDQNCj4+IC0tLSBhL2ZzL2tzbWJkL2tzbWJkX3dvcmsuaA0K
Pj4gKysrIGIvZnMva3NtYmQva3NtYmRfd29yay5oDQo+PiBAQCAtNDYsNiArNDYsNyBAQCBz
dHJ1Y3Qga3NtYmRfd29yayB7DQo+PiAgIAl1NjQJCQkJY29tcG91bmRfZmlkOw0KPj4gICAJ
dTY0CQkJCWNvbXBvdW5kX3BmaWQ7DQo+PiAgIAl1NjQJCQkJY29tcG91bmRfc2lkOw0KPj4g
Kwl1MzIJCQkJY29tcG91bmRfdGlkOw0KPj4NCj4+ICAgCWNvbnN0IHN0cnVjdCBjcmVkCQkq
c2F2ZWRfY3JlZDsNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZnMva3NtYmQvc21iMnBkdS5jIGIv
ZnMva3NtYmQvc21iMnBkdS5jDQo+PiBpbmRleCA3ZDMzNDRiNTUxOWMuLjViMWZlYWQwNWM0
OSAxMDA2NDQNCj4+IC0tLSBhL2ZzL2tzbWJkL3NtYjJwZHUuYw0KPj4gKysrIGIvZnMva3Nt
YmQvc21iMnBkdS5jDQo+PiBAQCAtOTgsNiArOTgsOCBAQCBpbnQgc21iMl9nZXRfa3NtYmRf
dGNvbihzdHJ1Y3Qga3NtYmRfd29yayAqd29yaykNCj4+ICAgCWludCB0cmVlX2lkOw0KPj4N
Cj4+ICAgCXdvcmstPnRjb24gPSBOVUxMOw0KPj4gKwl3b3JrLT5jb21wb3VuZF90aWQgPSAw
Ow0KPj4gKw0KPj4gICAJaWYgKGNtZCA9PSBTTUIyX1RSRUVfQ09OTkVDVF9IRSB8fA0KPj4g
ICAJICAgIGNtZCA9PSAgU01CMl9DQU5DRUxfSEUgfHwNCj4+ICAgCSAgICBjbWQgPT0gIFNN
QjJfTE9HT0ZGX0hFKSB7DQo+PiBAQCAtMTEwLDEzICsxMTIsMTggQEAgaW50IHNtYjJfZ2V0
X2tzbWJkX3Rjb24oc3RydWN0IGtzbWJkX3dvcmsgKndvcmspDQo+PiAgIAkJcmV0dXJuIC1F
Tk9FTlQ7DQo+PiAgIAl9DQo+Pg0KPj4gLQl0cmVlX2lkID0gbGUzMl90b19jcHUocmVxX2hk
ci0+SWQuU3luY0lkLlRyZWVJZCk7DQo+PiArCWlmIChyZXFfaGRyLT5GbGFncyAmIFNNQjJf
RkxBR1NfUkVMQVRFRF9PUEVSQVRJT05TKQ0KPj4gKwkJdHJlZV9pZCA9IHdvcmstPmNvbXBv
dW5kX3RpZDsNCj4gV2VsbCwgSXNuJ3QgdGhhdCBhIHBlcmZvcm1hbmNlIGRlZ3JhZGF0aW9u
IGR1ZSB0byB1bm5lZWRlZCBsb29rdXBzPw0KDQpJIHdvdWxkbid0IHRoaW5rIHRoYXQgdGhp
cyBoYXMgYW55IG5vdGljYWJsZSBwZXJmb3JtYW5jZSBpbXBhY3QsIGhhcyBpdD8gDQpUaGlz
IHdheSB0aGUgbG9naWMgaXMgZWFzeSB0byBmb2xsb3csIGJ1dCBJJ2xsIHJld3JpdGUgdG8g
YXZvaWQgdGhlIA0KbG9va3VwIGZvciByZWxhdGVkIG9wZXJhdGlvbnMuDQoNCi1zbG93DQoN
Ci0tIA0KUmFscGggQm9laG1lLCBTYW1iYSBUZWFtICAgICAgICAgICAgICAgICBodHRwczov
L3NhbWJhLm9yZy8NClNlck5ldCBTYW1iYSBUZWFtIExlYWQgICAgICBodHRwczovL3Nlcm5l
dC5kZS9lbi90ZWFtLXNhbWJhDQo=

--------------MmmvSM2bnZZeN9TKdacXSw0P--

--------------GTL3qzOoQ1vYPVLrdNtKCzAp
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFYS68FAwAAAAAACgkQqh6bcSY5nkbn
ew//YyW0BUS6NCokA2F/bfc8WIyiNmJ5VzHlPa/R0JEVFFFuJI/VxYqXBenSBotWimYNcq7wUJW8
71J1y1znyzYvNqsoriNqVFNRKCRl6OLRN/N8ZmgomVbsqWOaWHuBemZ+4eIWoqS7Ppo8cvIoHnRz
3VmEeVKQs4l4w33i34Mso9k6SO0hZKGuE7+BcsGZqaAGIDmElDuWPmIXGJNkRLrNQyeyf48Gn9W8
xf6qvNcXsNu7Z/nVZNhmlyzC8Dm21TmuKXbGiCBgDWDoN//Lp9OkUZmIybvYbJn7PRnrvYEdi7nv
BG6xKw4PLqDdGAzkq3PCiHWTArJa78r0TGYqfakfNVMTc5Z4a00BQ34dSHTUdnu8ScA8MGTgNEGj
Xq/0VH7wxwTyYjHzPQH707APB1e9ruV8HlP+fUr0niqn61GCCtWoZjTahYnt8PH5tSMKKWjYfqFr
6YzCIezQZ2GgWsZ2jCttxtE/MC3Z/2RVSPkuGMfT/n8BX4fEmY6So4v4B+iT1U6KceAcErrkkVkR
aCaoy8Y+JVpILnBR8LLju28crrHFVIQQwh4BWNcirUN4AD22wH+xNTRJFRRk75MgDGuZqv8Z68cg
iVR/q/csC3kQ9Lw8KLLYoqM6+flaupki0/QOl5nuIPQct/jptmZoVCySelZQLqHriG8UfLBkRVaV
SdA=
=MoDl
-----END PGP SIGNATURE-----

--------------GTL3qzOoQ1vYPVLrdNtKCzAp--
