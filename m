Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF759CA0FE6
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Sep 2023 09:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbjIAJEd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Sep 2023 05:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbjIAJEc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Sep 2023 05:04:32 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C15110D4
        for <linux-cifs@vger.kernel.org>; Fri,  1 Sep 2023 02:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=EuUtPRb/aTdUHvXwGru8XYpaypD0qd9vy+7RkpOK3Q4=; b=xmE9qJXdfHSV5oHYMdHJYiK9UG
        l3Rz+HwLHeutcQ7UHx6QNmI+RilM92hKvpgCvKDhIiOIQOdALe9bSbfM/nlA7kwJje0zEuljiiwQx
        zxaYty7qtGohdKZUYsb/aOinNcZes9r94nmQ3f/KOyjwxRDpOyJFXYsSdGxw4vvuY1tdH3yAxzf0m
        SGB2heOlPtymiCUd3WU4bH/oWMIr7SQNPcc3ttSsihx/R8N+UXHfODxpCkJdB3HN2/XaDdxn/Qj3/
        pKJnSyFANiaJpur03uezmmD2Tc/xMKeiOIABxrrfkqg98SqQY8MXi2AEbmOVMI/tME0OSAtSuF5jG
        s68SKN9gr9hvZ2J2TEgEJLSOUxo41045QPfXVY0U7eRKH+aERkH/j8Hfk/BRhiKmr1JYB3Y1IvVR3
        002kUdekS8i8cChTUtk3WXipDj2R+ICMxyKY6fPueqgPOy52dN3DIlVY3sYiYwK9jHOO1yGFyZNAz
        6GGYacz5b1R9NwJw0TAg0Yhh;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qc04k-00BDQp-36;
        Fri, 01 Sep 2023 09:04:23 +0000
Message-ID: <7ed6285e-8278-9b20-2512-6bcac4a21af9@samba.org>
Date:   Fri, 1 Sep 2023 11:04:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH][SMB3] allow controlling length of time directory entries
 are cached with dir leases
Content-Language: en-US, de-DE
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>,
        Tom Talpey <tom@talpey.com>
References: <CAH2r5mt99zVnZfTP_9Z4BNEa2L8Yw=8ds1USPhasbO06hLaGjQ@mail.gmail.com>
 <CAH2r5muP+oM1rDn0CMc1KbrV2-kwprreQ58Jj5CDRD3u7-G1yg@mail.gmail.com>
From:   Ralph Boehme <slow@samba.org>
In-Reply-To: <CAH2r5muP+oM1rDn0CMc1KbrV2-kwprreQ58Jj5CDRD3u7-G1yg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ve86xlQMW8EMuMhpDvHgp7jz"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ve86xlQMW8EMuMhpDvHgp7jz
Content-Type: multipart/mixed; boundary="------------mZLK5W2mPrpOZu7FRmkQM3Ex";
 protected-headers="v1"
From: Ralph Boehme <slow@samba.org>
To: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>
Cc: ronnie sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <nspmangalore@gmail.com>,
 Bharath S M <bharathsm@microsoft.com>, Tom Talpey <tom@talpey.com>
Message-ID: <7ed6285e-8278-9b20-2512-6bcac4a21af9@samba.org>
Subject: Re: [PATCH][SMB3] allow controlling length of time directory entries
 are cached with dir leases
References: <CAH2r5mt99zVnZfTP_9Z4BNEa2L8Yw=8ds1USPhasbO06hLaGjQ@mail.gmail.com>
 <CAH2r5muP+oM1rDn0CMc1KbrV2-kwprreQ58Jj5CDRD3u7-G1yg@mail.gmail.com>
In-Reply-To: <CAH2r5muP+oM1rDn0CMc1KbrV2-kwprreQ58Jj5CDRD3u7-G1yg@mail.gmail.com>

--------------mZLK5W2mPrpOZu7FRmkQM3Ex
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SnVzdCB3b25kZXJpbmc6IGhvdyBkb2VzIGEgV2luZG93cyBjbGllbnQgaGFuZGxlIHRoaXM/
IERvZXMgaXQgdXNlIGEgDQp0aW1lb3V0IHRvbz8gV2hpY2ggb25lPyA2MCBzZWNvbmRzIHN0
aWxsIHNlZW0gcmF0aGVyIHNob3J0Lg0KDQotc2xvdw0KDQpPbiA4LzMxLzIzIDA1OjUyLCBT
dGV2ZSBGcmVuY2ggd3JvdGU6DQo+IHVwZGF0ZWQgcGF0Y2ggd2l0aCBCYXJhdGgncyBzdWdn
ZXN0aW9uIG9mIHJlbmFtaW5nIGl0IGZyb20NCj4gL3N5cy9tb2R1bGUvY2lmcy9wYXJhbWV0
ZXJzL21heF9kaXJfY2FjaGUgdG8NCj4gL3N5cy9tb2R1bGUvY2lmcy9wYXJhbWV0ZXJzL2Rp
cl9jYWNoZV90aW1lb3V0IGFuZCBhbHNvIGNoYW5nZWQgaXQgc28NCj4gaWYgc2V0IHRvIHpl
cm8gd2UgZGlzYWJsZQ0KPiBkaXJlY3RvcnkgZW50cnkgY2FjaGluZy4NCj4gDQo+IFNlZSBh
dHRhY2hlZC4NCj4gDQo+IE9uIFN1biwgQXVnIDI3LCAyMDIzIGF0IDEyOjEy4oCvQU0gU3Rl
dmUgRnJlbmNoIDxzbWZyZW5jaEBnbWFpbC5jb20+IHdyb3RlOg0KPj4NCj4+IEN1cnJlbnRs
eSB3aXRoIGRpcmVjdG9yeSBsZWFzZXMgd2UgY2FjaGUgZGlyZWN0b3J5IGNvbnRlbnRzIGZv
ciBhIGZpeGVkIHBlcmlvZA0KPj4gb2YgdGltZSAoZGVmYXVsdCAzMCBzZWNvbmRzKSBidXQg
Zm9yIG1hbnkgd29ya2xvYWRzIHRoaXMgaXMgdG9vIHNob3J0LiAgQWxsb3cNCj4+IGNvbmZp
Z3VyaW5nIHRoZSBtYXhpbXVtIGFtb3VudCBvZiB0aW1lIGRpcmVjdG9yeSBlbnRyaWVzIGFy
ZSBjYWNoZWQgd2hlbiBhDQo+PiBkaXJlY3RvcnkgbGVhc2UgaXMgaGVsZCBvbiB0aGF0IGRp
cmVjdG9yeSAoYW5kIHNldCBkZWZhdWx0IHRpbWVvdXQgdG8NCj4+IDYwIHNlY29uZHMpLg0K
Pj4gQWRkIG1vZHVsZSBsb2FkIHBhcm0gIm1heF9kaXJfY2FjaGUiDQo+Pg0KPj4gRm9yIGV4
YW1wbGUgdG8gc2V0IHRoZSB0aW1lb3V0IHRvIDEwIG1pbnV0ZXMgeW91IHdvdWxkIGRvOg0K
Pj4NCj4+ICAgIGVjaG8gNjAwID4gL3N5cy9tb2R1bGUvY2lmcy9wYXJhbWV0ZXJzL21heF9k
aXJfY2FjaGUNCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNo
QG1pY3Jvc29mdC5jb20+DQo+PiAtLS0NCj4+ICAgZnMvc21iL2NsaWVudC9jYWNoZWRfZGly
LmMgfCAgMiArLQ0KPj4gICBmcy9zbWIvY2xpZW50L2NpZnNmcy5jICAgICB8IDEyICsrKysr
KysrKysrKw0KPj4gICBmcy9zbWIvY2xpZW50L2NpZnNnbG9iLmggICB8ICAxICsNCj4+ICAg
MyBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+Pg0K
Pj4gZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvY2FjaGVkX2Rpci5jIGIvZnMvc21iL2Ns
aWVudC9jYWNoZWRfZGlyLmMNCj4+IGluZGV4IDJkNWU5YTlkNWI4Yi4uZTQ4YTkwMmVmZDUy
IDEwMDY0NA0KPj4gLS0tIGEvZnMvc21iL2NsaWVudC9jYWNoZWRfZGlyLmMNCj4+ICsrKyBi
L2ZzL3NtYi9jbGllbnQvY2FjaGVkX2Rpci5jDQo+PiBAQCAtNTgyLDcgKzU4Miw3IEBAIGNp
ZnNfY2ZpZHNfbGF1bmRyb21hdF90aHJlYWQodm9pZCAqcCkNCj4+ICAgIHJldHVybiAwOw0K
Pj4gICAgc3Bpbl9sb2NrKCZjZmlkcy0+Y2ZpZF9saXN0X2xvY2spOw0KPj4gICAgbGlzdF9m
b3JfZWFjaF9lbnRyeV9zYWZlKGNmaWQsIHEsICZjZmlkcy0+ZW50cmllcywgZW50cnkpIHsN
Cj4+IC0gaWYgKHRpbWVfYWZ0ZXIoamlmZmllcywgY2ZpZC0+dGltZSArIEhaICogMzApKSB7
DQo+PiArIGlmICh0aW1lX2FmdGVyKGppZmZpZXMsIGNmaWQtPnRpbWUgKyBIWiAqIG1heF9k
aXJfY2FjaGUpKSB7DQo+PiAgICBsaXN0X2RlbCgmY2ZpZC0+ZW50cnkpOw0KPj4gICAgbGlz
dF9hZGQoJmNmaWQtPmVudHJ5LCAmZW50cnkpOw0KPj4gICAgY2ZpZHMtPm51bV9lbnRyaWVz
LS07DQo+PiBkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jaWZzZnMuYyBiL2ZzL3NtYi9j
bGllbnQvY2lmc2ZzLmMNCj4+IGluZGV4IGQ0OWZkMmJmNzFiMC4uN2E4OTcxOGQyYTU5IDEw
MDY0NA0KPj4gLS0tIGEvZnMvc21iL2NsaWVudC9jaWZzZnMuYw0KPj4gKysrIGIvZnMvc21i
L2NsaWVudC9jaWZzZnMuYw0KPj4gQEAgLTExNyw2ICsxMTcsMTAgQEAgbW9kdWxlX3BhcmFt
KGNpZnNfbWF4X3BlbmRpbmcsIHVpbnQsIDA0NDQpOw0KPj4gICBNT0RVTEVfUEFSTV9ERVND
KGNpZnNfbWF4X3BlbmRpbmcsICJTaW11bHRhbmVvdXMgcmVxdWVzdHMgdG8gc2VydmVyIGZv
ciAiDQo+PiAgICAgICAiQ0lGUy9TTUIxIGRpYWxlY3QgKE4vQSBmb3IgU01CMykgIg0KPj4g
ICAgICAgIkRlZmF1bHQ6IDMyNzY3IFJhbmdlOiAyIHRvIDMyNzY3LiIpOw0KPj4gK3Vuc2ln
bmVkIGludCBtYXhfZGlyX2NhY2hlID0gNjA7DQo+PiArbW9kdWxlX3BhcmFtKG1heF9kaXJf
Y2FjaGUsIHVpbnQsIDA2NDQpOw0KPj4gK01PRFVMRV9QQVJNX0RFU0MobWF4X2Rpcl9jYWNo
ZSwgIk51bWJlciBvZiBzZWNvbmRzIHRvIGNhY2hlIGRpcmVjdG9yeQ0KPj4gY29udGVudHMg
Zm9yIHdoaWNoIHdlIGhhdmUgYSBsZWFzZS4gRGVmYXVsdDogNjAgIg0KPj4gKyAiUmFuZ2U6
IDEgdG8gNjUwMDAgc2Vjb25kcyIpOw0KPj4gICAjaWZkZWYgQ09ORklHX0NJRlNfU1RBVFMy
DQo+PiAgIHVuc2lnbmVkIGludCBzbG93X3JzcF90aHJlc2hvbGQgPSAxOw0KPj4gICBtb2R1
bGVfcGFyYW0oc2xvd19yc3BfdGhyZXNob2xkLCB1aW50LCAwNjQ0KTsNCj4+IEBAIC0xNjc5
LDYgKzE2ODMsMTQgQEAgaW5pdF9jaWZzKHZvaWQpDQo+PiAgICBDSUZTX01BWF9SRVEpOw0K
Pj4gICAgfQ0KPj4NCj4+ICsgaWYgKG1heF9kaXJfY2FjaGUgPCAxKSB7DQo+PiArIG1heF9k
aXJfY2FjaGUgPSAxOw0KPj4gKyBjaWZzX2RiZyhWRlMsICJtYXhfZGlyX2NhY2hlIHRpbWVv
dXQgc2V0IHRvIG1pbiBvZiAxIHNlY29uZFxuIik7DQo+PiArIH0gZWxzZSBpZiAobWF4X2Rp
cl9jYWNoZSA+IDY1MDAwKSB7DQo+PiArIG1heF9kaXJfY2FjaGUgPSA2NTAwMDsNCj4+ICsg
Y2lmc19kYmcoVkZTLCAibWF4X2Rpcl9jYWNoZSB0aW1lb3V0IHNldCB0byBtYXggb2YgNjUw
MDAgc2Vjb25kc1xuIik7DQo+PiArIH0NCj4+ICsNCj4+ICAgIGNpZnNpb2Rfd3EgPSBhbGxv
Y193b3JrcXVldWUoImNpZnNpb2QiLCBXUV9GUkVFWkFCTEV8V1FfTUVNX1JFQ0xBSU0sIDAp
Ow0KPj4gICAgaWYgKCFjaWZzaW9kX3dxKSB7DQo+PiAgICByYyA9IC1FTk9NRU07DQo+PiBk
aWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jaWZzZ2xvYi5oIGIvZnMvc21iL2NsaWVudC9j
aWZzZ2xvYi5oDQo+PiBpbmRleCAyNTllMjMxZjhiNGYuLjdhZWVhYTI2MGNjZSAxMDA2NDQN
Cj4+IC0tLSBhL2ZzL3NtYi9jbGllbnQvY2lmc2dsb2IuaA0KPj4gKysrIGIvZnMvc21iL2Ns
aWVudC9jaWZzZ2xvYi5oDQo+PiBAQCAtMjAxNiw2ICsyMDE2LDcgQEAgZXh0ZXJuIHVuc2ln
bmVkIGludCBDSUZTTWF4QnVmU2l6ZTsgIC8qIG1heCBzaXplDQo+PiBub3QgaW5jbHVkaW5n
IGhkciAqLw0KPj4gICBleHRlcm4gdW5zaWduZWQgaW50IGNpZnNfbWluX3JjdjsgICAgLyog
bWluIHNpemUgb2YgYmlnIG50d3JrIGJ1ZiBwb29sICovDQo+PiAgIGV4dGVybiB1bnNpZ25l
ZCBpbnQgY2lmc19taW5fc21hbGw7ICAvKiBtaW4gc2l6ZSBvZiBzbWFsbCBidWYgcG9vbCAq
Lw0KPj4gICBleHRlcm4gdW5zaWduZWQgaW50IGNpZnNfbWF4X3BlbmRpbmc7IC8qIE1BWCBy
ZXF1ZXN0cyBhdCBvbmNlIHRvIHNlcnZlciovDQo+PiArZXh0ZXJuIHVuc2lnbmVkIGludCBt
YXhfZGlyX2NhY2hlOyAvKiBtYXggdGltZSBmb3IgZGlyZWN0b3J5IGxlYXNlDQo+PiBjYWNo
aW5nIG9mIGRpciAqLw0KPj4gICBleHRlcm4gYm9vbCBkaXNhYmxlX2xlZ2FjeV9kaWFsZWN0
czsgIC8qIGZvcmJpZCB2ZXJzPTEuMCBhbmQgdmVycz0yLjAgbW91bnRzICovDQo+PiAgIGV4
dGVybiBhdG9taWNfdCBtaWRfY291bnQ7DQo+Pg0KPj4NCj4+IC0tDQo+PiBUaGFua3MsDQo+
Pg0KPj4gU3RldmUNCj4gDQo+IA0KPiANCg0K

--------------mZLK5W2mPrpOZu7FRmkQM3Ex--

--------------ve86xlQMW8EMuMhpDvHgp7jz
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEE+uLGCIokJSBRxVnkqh6bcSY5nkYFAmTxqRYFAwAAAAAACgkQqh6bcSY5nkYN
Bw/+K6nkRV52X9hlBFIuzXtsGMuKxvZtQK2tK4LPJtiVZ6qH3nvH+XwcoAHcXYzfl1hdvwrSEHUO
TOXjAPn65MOLb29YsSU2nAMtzEVdDVhFaAExkQCD5prCjIEMr9yTZb61I6YyJxnQYuUB8+Wf464y
NrwWpQMTUFxrQyXpiSfBrgV3TDJt1YYTcApKSygnh0IFfTC++SZmUtSHUkL+JSMaArxQWD1L7MVS
Te2h1vqY0g8SjZtsTaYrpg8MvkNW+43U1gDVptgxZJzjVIhwSG1YzEDd3RhiUU7kSdTp8wXXVO/y
D9tpqHdgUw8V19soq8IkwQDdVazq+zD0GWqrE7PCQTgtFAv2ZDveRRSFWbiUvqDm6zfScLZt7XOc
o3dRVF1NeP+xgfwA06GHK2GhBgpXNCBaVzej/3hNHOhr3OupODgqRmPRiPsiB/CbBvn/jSHWy0By
2UZ98D7fXXntUPQbN7HkT8seYntI3LUhPYxmY8O4VZn/RX/bcfOvHpcHPHg3KjbgqAy5c28YP+dE
SmregNkkuzQ/l6oAizdrgRShdQs+0q8GsBafIXgGa2XXqeP0pSRPyGUxXnhxj0lhw3HW2LhiPp9F
b7MvftvRDNjveCZ3jzVIAIbn86uwoex65SLKTYGQmcFSWWPa6cNsWMGaiZDsHePWsPY+gQnywbaj
cNE=
=ISVV
-----END PGP SIGNATURE-----

--------------ve86xlQMW8EMuMhpDvHgp7jz--
