Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 771A4C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 12:53:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5652E610A4
	for <linux-cifs@archiver.kernel.org>; Thu, 30 Sep 2021 12:53:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351133AbhI3MzC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 30 Sep 2021 08:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351051AbhI3MzB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 30 Sep 2021 08:55:01 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B347AC06176A
        for <linux-cifs@vger.kernel.org>; Thu, 30 Sep 2021 05:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=hUu18Dxh7upZxeWEivrXM563jmPeHBDfJXHhLe/peDo=; b=F6av1YAd3+O58f003+UHaSZ4ZW
        e+XvRz5QaQI24vJOfqnLFEzS9ypE0L8MLkHcg75zn/Y3I0ei1Iggt+CmyT7qvZPyhU7N7r8T0mtKQ
        cMWJVO4FvOuMq5pX3nt5FAc74txhVZRdply3kJKbo/t0TKrBhRMqZov0y00/9y+UnWBBRqYf0V/eP
        54SiOnNm8/++skPuPHsoxulfvg5aAlZzwFicuCToYnTwPOyKp/yG5wgDiFY+YiOIj/zuPx5Vvn0KR
        02v4cECKaky/qDOCPThFEk1S5CvBDL7IKEh/B07EXs6FBgtppNmF4IE+xOKxtvKKaMFOgcZFLtbGX
        nrGxtnc+mcvo9N59YhzDRzrYMw0kSGoU6DtONl8KlMibgBVY7Hzon2RBtS+AqjwFNon5pq/WUNWT6
        NJU6J4DXHj6ZAP7lRSnoQ4LCUs6JGE2qxNQ2d/cxh1w4rBEsEaydGGejeOqpMhQgpTMMryQduiP89
        rgFBwEoYynsaURuLV50paroW;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mVvYp-000swP-SZ; Thu, 30 Sep 2021 12:53:16 +0000
Message-ID: <2b536a89-cba6-88a0-b7d8-c5435d183679@samba.org>
Date:   Thu, 30 Sep 2021 14:53:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v4 0/9] ksmbd: a bunch of patches that is being reviewed
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
References: <20210929084501.94846-1-linkinjeon@kernel.org>
 <bf665917-cf8c-30ca-4ce0-4614adaf0988@samba.org>
 <CAKYAXd-A4FLznKAVesfOiSpNy0KPAkXUppN4rkbGPBMdBMQLkA@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <CAKYAXd-A4FLznKAVesfOiSpNy0KPAkXUppN4rkbGPBMdBMQLkA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------6q0lEgC0P3rgv0M0ceUP5qs9"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------6q0lEgC0P3rgv0M0ceUP5qs9
Content-Type: multipart/mixed; boundary="------------uJuk0vQgi07Qkn9r92tS50XE";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Steve French
 <smfrench@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Message-ID: <2b536a89-cba6-88a0-b7d8-c5435d183679@samba.org>
Subject: Re: [PATCH v4 0/9] ksmbd: a bunch of patches that is being reviewed
References: <20210929084501.94846-1-linkinjeon@kernel.org>
 <bf665917-cf8c-30ca-4ce0-4614adaf0988@samba.org>
 <CAKYAXd-A4FLznKAVesfOiSpNy0KPAkXUppN4rkbGPBMdBMQLkA@mail.gmail.com>
In-Reply-To: <CAKYAXd-A4FLznKAVesfOiSpNy0KPAkXUppN4rkbGPBMdBMQLkA@mail.gmail.com>

--------------uJuk0vQgi07Qkn9r92tS50XE
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

QW0gMzAuMDkuMjEgdW0gMDM6MDEgc2NocmllYiBOYW1qYWUgSmVvbjoNCj4gMjAyMS0wOS0z
MCAyOjU1IEdNVCswOTowMCwgUmFscGggQm9laG1lIDxzbG93QHNhbWJhLm9yZz46DQo+PiBB
bSAyOS4wOS4yMSB1bSAxMDo0NCBzY2hyaWViIE5hbWphZSBKZW9uOg0KPj4+IENjOiBUb20g
VGFscGV5IDx0b21AdGFscGV5LmNvbT4NCj4+PiBDYzogUm9ubmllIFNhaGxiZXJnIDxyb25u
aWVzYWhsYmVyZ0BnbWFpbC5jb20+DQo+Pj4gQ2M6IFJhbHBoIELDtmhtZSA8c2xvd0BzYW1i
YS5vcmc+DQo+Pj4gQ2M6IFN0ZXZlIEZyZW5jaCA8c21mcmVuY2hAZ21haWwuY29tPg0KPj4+
IENjOiBIeXVuY2h1bCBMZWUgPGh5Yy5sZWVAZ21haWwuY29tPg0KPj4+IENjOiBTZXJnZXkg
U2Vub3poYXRza3kgPHNlbm96aGF0c2t5QGNocm9taXVtLm9yZz4NCj4+Pg0KPj4+IHYyOg0K
Pj4+ICAgICAtIHVwZGF0ZSBjb21tZW50cyBvZiBzbWIyX2dldF9kYXRhX2FyZWFfbGVuKCku
DQo+Pj4gICAgIC0gZml4IHdyb25nIGJ1ZmZlciBzaXplIGNoZWNrIGluIGZzY3RsX3F1ZXJ5
X2lmYWNlX2luZm9faW9jdGwoKS4NCj4+PiAgICAgLSBmaXggMzJiaXQgb3ZlcmZsb3cgaW4g
c21iMl9zZXRfaW5mby4NCj4+Pg0KPj4+IHYzOg0KPj4+ICAgICAtIGFkZCBidWZmZXIgY2hl
Y2sgZm9yIEJ5dGVDb3VudCBvZiBzbWIgbmVnb3RpYXRlIHJlcXVlc3QuDQo+Pj4gICAgIC0g
TW92ZWQgYnVmZmVyIGNoZWNrIG9mIHRvIHRoZSB0b3Agb2YgbG9vcCB0byBhdm9pZCB1bm5l
ZWRlZCBiZWhhdmlvcg0KPj4+IHdoZW4NCj4+PiAgICAgICBvdXRfYnVmX2xlbiBpcyBzbWFs
bGVyIHRoYW4gbmV0d29ya19pbnRlcmZhY2VfaW5mb19pb2N0bF9yc3AuDQo+Pj4gICAgIC0g
Z2V0IGNvcnJlY3Qgb3V0X2J1Zl9sZW4gd2hpY2ggZG9lc24ndCBleGNlZWQgbWF4IHN0cmVh
bSBwcm90b2NvbA0KPj4+IGxlbmd0aC4NCj4+PiAgICAgLSBzdWJ0cmFjdCBzaW5nbGUgc21i
Ml9sb2NrX2VsZW1lbnQgZm9yIGNvcnJlY3QgYnVmZmVyIHNpemUgY2hlY2sgaW4NCj4+PiAg
ICAgICBrc21iZF9zbWIyX2NoZWNrX21lc3NhZ2UoKS4NCj4+Pg0KPj4+IHY0Og0KPj4+ICAg
ICAtIHVzZSB3b3JrLT5yZXNwb25zZV9zeiBmb3Igb3V0X2J1Zl9sZW4gY2FsY3VsYXRpb24g
aW4gc21iMl9pb2N0bC4NCj4+PiAgICAgLSBtb3ZlIHNtYjJfbmVnIHNpemUgY2hlY2sgdG8g
YWJvdmUgdG8gdmFsaWRhdGUgTmVnb3RpYXRlQ29udGV4dE9mZnNldA0KPj4+ICAgICAgIGZp
ZWxkLg0KPj4+ICAgICAtIHJlbW92ZSB1bm5lZWRlZCBkaWFsZWN0IGNoZWNrcyBpbiBzbWIy
X3Nlc3Nfc2V0dXAoKSBhbmQNCj4+PiAgICAgICBzbWIyX2hhbmRsZV9uZWdvdGlhdGUoKS4N
Cj4+PiAgICAgLSBzcGxpdCBzbWIyX3NldF9pbmZvIHBhdGNoIGludG8gdHdvIHBhdGNoZXMo
ZGVjbGFyaW5nDQo+Pj4gICAgICAgc21iMl9maWxlX2Jhc2ljX2luZm8gYW5kIGJ1ZmZlciBj
aGVjaykNCj4+DQo+PiBpdCBsb29rcyBsaWtlIHlvdSBkcm9wcGVkIGFsbCBteSBwYXRjaGVz
IGFuZCBkaWRuJ3QgY29tbWVudCBvbiB0aGUNCj4+IFNRVUFTSEVTIHRoYXQgcG9pbnRlZCBh
dCBzb21lIGlzc3Vlcy4NCj4+DQo+PiBEaWQgSSBtaXNzIGFueXRoaW5nIHdoZXJlIHlvdSBl
eHBsYWluZWQgd2h5IHlvdSBkaWQgdGhpcz8NCj4gUGxlYXNlIHNlZSB2NCBjaGFuZ2UgbGlz
dCBpbiB0aGlzIGNvdmVyIGxldHRlcg0KPiAgICAtIHVzZSB3b3JrLT5yZXNwb25zZV9zeiBm
b3Igb3V0X2J1Zl9sZW4gY2FsY3VsYXRpb24gaW4gc21iMl9pb2N0bC4NCj4gICAgLSBzcGxp
dCBzbWIyX3NldF9pbmZvIHBhdGNoIGludG8gdHdvIHBhdGNoZXMoZGVjbGFyaW5nLi4uDQo+
IA0KPiBJIGRpZG4ndCBhcHBseSAiU1FVQVNIOiBhdCB0aGlzIGxheWVyIHdlIHNob3VsZCBv
bmx5IGFnYWluc3QgdGhlDQo+IE1BWF9TVFJFQU1fUFJPVF9MRU4g4oCmIg0KPiBiZWNhdXNl
IHNtYjIgaGVhZGVyIGlzIHVzZWQgYmVmb3JlIGtzbWJkX3ZlcmlmeV9zbWJfbWVzc2FnZSBp
cyByZWFjaGVkLg0KPiBTZWUgaW5pdF9yc3BfaGRyIGFuZCBjaGVja191c2VyX3Nlc3Npb24o
KSBpbiBfX2hhbmRsZV9rc21iZF93b3JrKCkuDQoNCkxldCBtZSBjaGVjay4NCg0KPiBIYXZl
IHlvdSBjaGVja2VkIG15IGNvbW1lbnRzIG9uIHlvdXIgc3F1YXNoIHBhdGNoZXMgb2YgZ2l0
aHViID8NCj4gSSBkaWRuJ3QgZ2V0IGFueSByZXNwb25zZSBmcm9tIHlvdSA6KQ0KDQpPaCBt
eSEgTG9va3MgbGlrZSBJIGRpZG4ndCBnZXQgZ2l0aHViIGVtYWlsIG5vdGlmaWNhdGlvbnMg
c28gSSB3YXNuJ3QgDQphd2FyZSBvZiB5b3VyIGNvbW1lbnRzLi4uIFNvcnJ5ISA6KSBDdXJy
ZW50bHkgdGFraW5nIGEgbG9vay4NCg0KPj4NCj4+IFRoZSBjaGFuZ2VzIEkgbWFkZSBpbWhv
IGNvbnNvbGlkYXRlZCB0aGUgU01CMiBQRFUgcGFja2V0IHNpemUgY2hlY2tpbmcNCj4+IGxv
Z2ljLiBXaXRoIHlvdXIgY2hhbmdlcyB0aGUgY2hlY2sgZm9yIHZhbGlkIFNNQjIgUERVIHNp
emVzIG9mIGNvbXBvdW5kDQo+PiBvZmZzZXRzIGlzIHNwcmVhZCBhY3Jvc3MgdGhlIG5ldHdv
cmsgcmVjZWl2ZSBsYXllciBhbmQgdGhlIGNvbXBvdW5kDQo+PiBwYXJzaW5nIGxheWVyLg0K
Pj4NCj4+IFRoZSBjaGFuZ2VzIEkgbWFkZSwgYWRkaW5nIGEgbmljZSBoZWxwZXIgZnVuY3Rp
b24gYWxvbmcgdGhlIHdheSwgbW92ZWQNCj4+IHRoZSBjb3JlIFBEVSB2YWxpZGF0aW9uIGlu
dG8gdGhlIGZ1bmN0aW9uIHdlcmUgaXQgc2hvdWxkIGJlIGRvbmU6IGluc2lkZQ0KPj4ga3Nt
YmRfc21iMl9jaGVja19tZXNzYWdlKCkuDQo+IGtzbWJkIGlzIGNoZWNraW5nIHdoZXRoZXIg
c2Vzc2lvbiBpZCBhbmQgdHJlZSBpZCBhcmUgdmFpbGQgaW4gc21iDQo+IGhlYWRlciBiZWZv
cmUgcHJvY2Vzc2luZyBzbWIgcmVxdWVzdHMuIA0KDQp5ZXMsIHRoaXMgd2FzIG5leHQgb24g
bXkgbGlzdCwgc29ycnkgZm9yZ290IHRvIG1lbnRpb24gdGhpcy4gQWZhaWN0IGluIA0KdGhl
IGN1cnJlbnQgY29kZSB0aGUgc2Vzc2lvbiBhbmQgdGNvbiBjaGVja3MgYXJlIG9ubHkgZG9u
ZSBvbmNlIG9uIHRoZSANCmZpcnN0IFNNQjIgUERVIGZvciBhIHNlcmllcyBvZiBjb21wb3Vu
ZCBub24tcmVsYXRlZCBQRFVzLCB3aGlsZSBmb3IgDQpub24tcmVsYXRlZCBQRFVzIHRoZSBj
YWxscyB0byBjaGVja191c2VyX3Nlc3Npb24oKSBhbmQgDQpzbWIyX2dldF9rc21iZF90Y29u
KCkgc2hvdWxkIGJlIHByb2JhYmx5IGJlIGRvbmUgaW5zaWRlIA0KX19wcm9jZXNzX3JlcXVl
c3QoKSwgb3IgZXZlbnR1YWxseSBqdXN0IGluc2lkZSBrc21iZF9zbWIyX2NoZWNrX21lc3Nh
Z2UoKS4NCg0KPiBpc19jaGFpbmVkX3NtYjJfbWVzc2FnZSBpcw0KPiBjaGVja2luZyBuZXh0
IGNvbW1hbmQgaGVhZGVyIHNpemUuDQo+Pg0KPj4gWW91IGFsc28gZHJvcHBlZCB0aGUgZml4
IGZvciB0aGUgcG9zc2libGUgaW52YWxpZCByZWFkIGluDQo+PiBrc21iZF92ZXJpZnlfc21i
X21lc3NhZ2UoKSBvZiB0aGUgcHJvdG9jb2xfaWQgZmllbGQuDQo+IFdoZXJlID8gWW91IGFy
ZSBzYXlpbmcgeW91ciBwYXRjaCBpbiBnaXRodWIgPyBJZiBpdCBpcyByaWdodCwgSSBkaWRu
J3QgZHJvcC4NCg0KdGhpcyBvbmU6DQoNCjxodHRwczovL2dpdGh1Yi5jb20vc21mcmVuY2gv
c21iMy1rZXJuZWwvY29tbWl0L2ZmYzQxMGYxZDE5YTBmMDZhOTUyYzdmMjhlOWJjYTRmYTRi
ZDRhNzQ+DQoNCkFuZCBhbHNvIHRoZSBjbGVhbnVwIGNvbW1pdHMgdXNpbmcga3NtYmRfcmVx
X2J1Zl9uZXh0KCkgaW4gYSBmZXcgcGxhY2VzLg0KDQo+PiBJIG1pZ2h0IGJlIG1pc3Npbmcg
c29tZXRoaW5nIGJlY2F1c2UgSSdtIHN0aWxsIG5ldyB0byB0aGUgY29kZS4gQnV0DQo+PiBn
ZW5lcmFsbHkgd2UgcmVhbGx5IHNhbml0aXplIHRoZSBsb2dpYyB3aGlsZSB3ZSdyZSBhdCBp
dCBub3cgaW5zdGVhZCBvZg0KPj4gYWRkaW5nIGJhbmQgYWlkcyBldmVyeXdoZXJlLg0KPiBJ
IHNhdyB5b3VyIHBhdGNoIGFuZCBpdCdzIG5pY2UuIEhvd2V2ZXIsIHdlIGhhdmUgbm90IHll
dCBhZ3JlZWQgb24NCj4gd2hlcmUgdGhlIHJldmlldyB3aWxsIGJlIGNvbmR1Y3RlZC4gWW91
IGFsc28gZGlkbid0IHJlc3BvbmQgdG8gbXkNCj4gY29tbWVudHMgb24gbXkgc3F1YXNoIHBh
dGNoIGluIHlvdXIgZ2l0aHViLiBTbyBJIHRob3VnaHQgSSdkIHRha2UgYQ0KPiBkZWVwZXIg
bG9vayBpZiB5b3Ugc2VuZCB0aGUgcGF0Y2ggdG8gdGhlIGxpc3QuDQoNCkkgcmVhbGl6ZSB0
aGF0IG15IHdlbGwgdGhvdWdodCBpZGVhIHRvIGlkZWEgb2Ygc2ltcGxpZnlpbmcgdGhpbmdz
IGJ5IA0KcHVzaGluZyBteSBsYXJnZXIgY2hhbmdlcyB0byBnaXRodWIgaXMgbm90IGdvaW5n
IHZlcnkgd2VsbC4gOikgVGhlcmVmb3IgDQpJJ2xsIHJlc3VibWl0IHRoZSBwYXRjaHNldCB0
byB0aGUgTUwgbGF0ZXIgb24uDQoNCkZ3aXcsIGhlcmUncyBpcyB3aGF0IGFuIGFjdHVhbCBy
ZXZpZXcgb24gZ2l0aHViIG9uIGEgTVIgd291bGQgbG9vayBsaWtlOg0KDQo8aHR0cHM6Ly9n
aXRodWIuY29tL3NtZnJlbmNoL3NtYjMta2VybmVsL3B1bGwvNzI+DQoNClRoaXMgd2FzIGp1
c3QgYW4gZXhwZXJpbWVudC4gSXQgZGVtb25zdHJhdGVzIGEgZmV3IGZlYXR1cmVzOiB0cmFj
a2luZyANCmNvbW1lbnRzLCB0cmFja2luZyBuZXcgcHVzaGVzIHRvIHRoZSBzb3VyY2UgYnJh
bmNoIGFuZCBvdGhlciByZWxhdGVkIA0KYWN0aW9ucy4NCg0KTm90ZSB0aGF0IEknbSBOT1Qg
UFJPUE9TSU5HIHVzaW5nIGdpdGh1YiBNUnMgcmlnaHQgYXdheS4gSnVzdCBzaG93aW5nIA0K
d2hhdCdzIHBvc3NpYmxlLiA6KQ0KDQotc2xvdw0KDQotLSANClJhbHBoIEJvZWhtZSwgU2Ft
YmEgVGVhbSAgICAgICAgICAgICAgICAgaHR0cHM6Ly9zYW1iYS5vcmcvDQpTZXJOZXQgU2Ft
YmEgVGVhbSBMZWFkICAgICAgaHR0cHM6Ly9zZXJuZXQuZGUvZW4vdGVhbS1zYW1iYQ0K

--------------uJuk0vQgi07Qkn9r92tS50XE--

--------------6q0lEgC0P3rgv0M0ceUP5qs9
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmFVszoFAwAAAAAACgkQqh6bcSY5nkZk
fxAAr+yI1TZNVhM0JoEtawjSYUaKbq+uCgZVGTPxM5lK/B1tYxJMBl6DnLrpXhaHhiS1HGGXu5Lw
1ruLRRdN8r2sF4R8aTQHmTfSNIafIZ+tlHe0wncaEWYPigc00LAMMasr7o+rRpMPW9N8N53OcWqA
t+PFnUhreYWn7ZL1ftDbAdASUpuGKPiL7+aZV1n21IZPoejFc+rdkV0ucwu9Y+tAWS9uzq3LGi3n
Aj1BhgxiAnN3CjcZZW0+cYSOWNodRgBrv+0iImPsXxlulg/FPLvDQi+EPll8o1b1/Bnrt+6PzHCZ
Jz4GiWWaKDxg7hK9tcdF2LFaOFh7iPTK3ADNICy7EYEPQ/+gW4FsNOXIHTJlIK5Cgy4a60BJaYwr
OuKIvDB9mW38qZctUrF1/hOlCiR23tzSh3wJ3Vijm/PT5oz7i0daB+lZclklMK8vRTPsl1AaFd1L
mwU7Josq+u9hWhr8CIGKtGfWhjpf0r2pEDpBsY9hOHjMnipdDmybwIBCopeBBoRXPQFCM6NtCyZ3
CYvHwPeW8Rio/IFM/+U/LScH5JjEeGku+h4ToPyK3Ot8l2UfcZNl05RI/VbJzSHvo+9T1F6w8+hJ
jDDQvpU9WgRsS750V07SJO8iZ5LTEWrdGKPY3G/Om+sIawacX5omw+PHOplzcPH8IEsvwFVAw6gc
hHE=
=m34s
-----END PGP SIGNATURE-----

--------------6q0lEgC0P3rgv0M0ceUP5qs9--
