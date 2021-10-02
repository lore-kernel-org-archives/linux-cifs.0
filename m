Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EEB5C433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 11:55:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06EF661AF7
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 11:55:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbhJBL5U (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 07:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbhJBL5S (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Oct 2021 07:57:18 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAF0C061570
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 04:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=RX+VebUCJf7kaCY+lydv/gT76Qy4CmjwnMRKXMQiWKc=; b=WG7uFnM06yomixsbKVeCKBbmPS
        G/pJ560ToSPJuegDF5iFQroijffkRee+Hn+wbDQ0GQAM2HqwlyA5fjMLcfmprgDiEpoxenRh1H1Km
        NJ9Vg/s82x6tQ6JLWYi02byax5OSu1mk2+xztLmWEjlEEmeBHGGihwvObUc+VNmIHLZLkVGbUkFSG
        itZQ53kBKfZV+4E9X6DX7xtAJZopx9QX/0nfND88iD2Z8ZJ/UUUtGOU26ehxESH66pofvFBDEQtuy
        eh0MzILf0w5k00MSCftsj01JjiILMwZRAdbSSTs+lZfNqbeiG6EaTeQZTz78FmkiuxP1kHJ9JU9xa
        m7hgmqGxh6CJX36eNaafJPesxKfal/bCu7fu6b4SdgBHrUNhLmzw3NmVOFadjS3iKkByIPMpUfPm/
        LMOpzhKzdhxZJbOQ11bDpU6gVKvHpq+3wkPRJ+5g6hXXpNcouJ9SfjrPlWKwY5NpxZiWYWFX+UJ9m
        L4OhnH4RD0sATG8fFs+T4vKX;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWdc2-001DIF-BP; Sat, 02 Oct 2021 11:55:30 +0000
Message-ID: <355eb55e-0859-080b-cf86-effef7b9773e@samba.org>
Date:   Sat, 2 Oct 2021 13:55:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v5 14/20] ksmbd: add ksmbd_smb2_cur_pdu_buflen()
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
References: <20211001120421.327245-1-slow@samba.org>
 <20211001120421.327245-15-slow@samba.org>
 <CAKYAXd_i+L0CwnS4zSpaRq7Yrnq0myEaoAYs6T9mD9+CkUM1pg@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <CAKYAXd_i+L0CwnS4zSpaRq7Yrnq0myEaoAYs6T9mD9+CkUM1pg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ljsAaR9OOUqeaQRhdloo8CsG"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ljsAaR9OOUqeaQRhdloo8CsG
Content-Type: multipart/mixed; boundary="------------WFO6tXmP782KzQYMLaCWA35b";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Steve French
 <smfrench@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>
Message-ID: <355eb55e-0859-080b-cf86-effef7b9773e@samba.org>
Subject: Re: [PATCH v5 14/20] ksmbd: add ksmbd_smb2_cur_pdu_buflen()
References: <20211001120421.327245-1-slow@samba.org>
 <20211001120421.327245-15-slow@samba.org>
 <CAKYAXd_i+L0CwnS4zSpaRq7Yrnq0myEaoAYs6T9mD9+CkUM1pg@mail.gmail.com>
In-Reply-To: <CAKYAXd_i+L0CwnS4zSpaRq7Yrnq0myEaoAYs6T9mD9+CkUM1pg@mail.gmail.com>

--------------WFO6tXmP782KzQYMLaCWA35b
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMDIuMTAuMjEgdW0gMDc6NDkgc2NocmllYiBOYW1qYWUgSmVvbjoNCj4gMjAyMS0xMC0w
MSAyMTowNCBHTVQrMDk6MDAsIFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1iYS5vcmc+Og0KPj4g
Q2M6IE5hbWphZSBKZW9uIDxsaW5raW5qZW9uQGtlcm5lbC5vcmc+DQo+PiBDYzogVG9tIFRh
bHBleSA8dG9tQHRhbHBleS5jb20+DQo+PiBDYzogUm9ubmllIFNhaGxiZXJnIDxyb25uaWVz
YWhsYmVyZ0BnbWFpbC5jb20+DQo+PiBDYzogU3RldmUgRnJlbmNoIDxzbWZyZW5jaEBnbWFp
bC5jb20+DQo+PiBDYzogSHl1bmNodWwgTGVlIDxoeWMubGVlQGdtYWlsLmNvbT4NCj4+IFNp
Z25lZC1vZmYtYnk6IFJhbHBoIEJvZWhtZSA8c2xvd0BzYW1iYS5vcmc+DQo+PiAtLS0NCj4+
ICAgZnMva3NtYmQvc21iMm1pc2MuYyB8IDI1ICsrKysrKysrKysrKysrKysrKysrKysrKysN
Cj4+ICAgZnMva3NtYmQvc21iMnBkdS5oICB8ICAxICsNCj4+ICAgMiBmaWxlcyBjaGFuZ2Vk
LCAyNiBpbnNlcnRpb25zKCspDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2ZzL2tzbWJkL3NtYjJt
aXNjLmMgYi9mcy9rc21iZC9zbWIybWlzYy5jDQo+PiBpbmRleCAyY2MwMzFjMzk1MTQuLjc2
ZjUzZGI3ZGI4ZCAxMDA2NDQNCj4+IC0tLSBhL2ZzL2tzbWJkL3NtYjJtaXNjLmMNCj4+ICsr
KyBiL2ZzL2tzbWJkL3NtYjJtaXNjLmMNCj4+IEBAIC00MjcsMyArNDI3LDI4IEBAIGludCBz
bWIyX25lZ290aWF0ZV9yZXF1ZXN0KHN0cnVjdCBrc21iZF93b3JrICp3b3JrKQ0KPj4gICB7
DQo+PiAgIAlyZXR1cm4ga3NtYmRfc21iX25lZ290aWF0ZV9jb21tb24od29yaywgU01CMl9O
RUdPVElBVEVfSEUpOw0KPj4gICB9DQo+PiArDQo+PiArLyoqDQo+PiArICoga3NtYmRfc21i
Ml9jdXJfcGR1X2J1ZmxlbigpIC0gR2V0IGxlbiBvZiBjdXJyZW50IFNNQjIgUERVIGJ1ZmZl
cg0KPj4gKyAqIFRoaXMgcmV0dXJucyB0aGUgbGVuZ2h0IGluY2x1ZGluZyBhbnkgcG9zc2li
bGUgcGFkZGluZy4NCj4+ICsgKiBAd29yazogc21iIHdvcmsgY29udGFpbmluZyByZXF1ZXN0
IGJ1ZmZlcg0KPj4gKyAqLw0KPj4gK3Vuc2lnbmVkIGludCBrc21iZF9zbWIyX2N1cl9wZHVf
YnVmbGVuKHN0cnVjdCBrc21iZF93b3JrICp3b3JrKQ0KPj4gK3sNCj4gVGhpcyBwYXRjaCB3
aWxsIGNhdXNlIHVudXNlZCBmdW5jdGlvbiBidWlsZCB3YXJuaW5nLiBzbyBuZWVkIHRvDQo+
IGNvbWJpbmUgaXQgd2l0aCAia3NtYmQ6IHVzZSBrc21iZF9zbWIyX2N1cl9wZHVfYnVmbGVu
KCkgaW4NCj4ga3NtYmRfc21iMl9jaGVja19tZXNzYWdlKCkgIg0KDQpvaywgZ29pbmcgdG8g
c3F1YXNoIHRoaXMgaW50byBhbm90aGVyIGNvbW1pdCB0aGF0IHVzZXMgdGhlIGZ1bmN0aW9u
Lg0KDQotc2xvdw0KDQotLSANClJhbHBoIEJvZWhtZSwgU2FtYmEgVGVhbSAgICAgICAgICAg
ICAgICAgaHR0cHM6Ly9zYW1iYS5vcmcvDQpTZXJOZXQgU2FtYmEgVGVhbSBMZWFkICAgICAg
aHR0cHM6Ly9zZXJuZXQuZGUvZW4vdGVhbS1zYW1iYQ0K

--------------WFO6tXmP782KzQYMLaCWA35b--

--------------ljsAaR9OOUqeaQRhdloo8CsG
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFYSLEFAwAAAAAACgkQqh6bcSY5nkZd
Nw//S3+tnp3kZ7Z5e+2BHQy8n2De9D+U2n2gY52y60u+mX5uuLqXBVKjTDXKUhhUpxHRkkNRbXa6
eaHVGGp+/JXWjtiia0sHDAcvqXUiGbrDd/b0g2Roj+VLQne7tnqr+2TzEb86J8nSuaove/dIQPR9
HqWF6F2yLrgkWkqWglJetvAegj3c5huf93XZegleTUue5MKz04Ub4k++ZL/2iYOc7deEhjJY9Yim
/nCcaaAi+LL/7eREtH4eRccu8KYhRd3SgWucNfnyJ9fIrNDpL73wwN65cM18Lu8SXCBbjj+UIV6G
dvPCdluwNmoMwS5hZI6xbHENG7ZRoAIBhhfEhUxDlhyyo1DZrqJDm47xQywb7P5f1HMtmP3RX/nf
27RdvN6xPi+XGcva0JPyRey+qGuLb35DtaxnTeOK3cx/pwk8oAgyCpr56HYN7OpNBoM+DqK0eNnN
3k2LNCP9qtz7hOElvPWyb3QQfhcrZJIBRqv+AOZLb5+/1uiSUSE+7jTvEuPf16fXzc1I9ubr76Jo
9yC/5cAeHRBHfNg96nFQeLpZDc9tzWA/0DRBgiZtnuHDV/3zhHrNhsfsTBaMcT/+kWyXt7bPY5e1
6lsHSZnP+qvgq0IIQt2roT9kacEHe8Lk29gPeZFGovVTwO2P72jk2BZcu6EUKnz+UuR8m642k7PP
dpg=
=rmIH
-----END PGP SIGNATURE-----

--------------ljsAaR9OOUqeaQRhdloo8CsG--
