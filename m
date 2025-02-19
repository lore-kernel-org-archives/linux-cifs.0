Received: from fabamailgate04.fabasoft.com (fabamailgate04.fabasoft.com [192.84.221.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA061E522
	for <linux-cifs@vger.kernel.org>; Wed, 19 Feb 2025 10:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.84.221.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739959883; cv=none; b=SskHfzAtY3f12VU53ibQX9n6My5WiGvoUpfmog6KtJCDyzBYms6o+r4J8pGuRSlbvRF3DJ1x3zKrSUvtSK93hP3TxztBf11L07WfJsdjCD0qOF+C2UnCS6diorwO7FVD6OCh9v+9oW0E5TZbhKsPe5LgQTXMiCZ17HSW5i6VzQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739959883; c=relaxed/simple;
	bh=eLIohWmPupn529jXvSRRdYDsd/AA0Lbl341PzGfHPUs=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=rtjGrBELPg8/D29aPL5nsFfnFcqGBIYbzbd6hY0Fzrn4KmMljXsmxdf97JKbgcVzOhrpeDVyLDyNHE4JOYiSxPuufkr8oebFGGTRy/yFUVplDTDne9L+SQnL+msVTLBFRY52IF9NxtmoP7vWWzpNv3VZdN4BKS2HhISRyi/Xgp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fabasoft.com; spf=pass smtp.mailfrom=fabasoft.com; arc=none smtp.client-ip=192.84.221.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fabasoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fabasoft.com
Received: from fabamailgate04.fabasoft.com (localhost [127.0.0.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by fabamailgate04.fabasoft.com (Fabasoft e-Mail Services) with ESMTPS id 803AE40380D8;
	Wed, 19 Feb 2025 11:04:50 +0100 (CET)
Received: from [127.0.0.1] (helo=fabamailgate04.fabasoft.com)
	by fabamailgate04.fabasoft.com with ESMTP (eXpurgate 4.51.0)
	(envelope-from <horst.reiterer@fabasoft.com>)
	id 67b5acc2-045d-7f0000012b03-7f000001e7e6-1
	for <multiple-recipients>; Wed, 19 Feb 2025 11:04:50 +0100
Received: from FABAEXCH01.fabagl.fabasoft.com (fabaexch01 [10.10.5.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by fabamailgate04.fabasoft.com (Fabasoft e-Mail Services) with ESMTPS;
	Wed, 19 Feb 2025 11:04:50 +0100 (CET)
Received: from FABAEXCH01.fabagl.fabasoft.com (10.10.5.4) by
 FABAEXCH01.fabagl.fabasoft.com (10.10.5.4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Wed, 19 Feb 2025 11:04:50 +0100
Received: from FABAEXCH01.fabagl.fabasoft.com ([fe80::c9d7:6a74:cdb8:4ed7]) by
 FABAEXCH01.fabagl.fabasoft.com ([fe80::c9d7:6a74:cdb8:4ed7%4]) with mapi id
 15.01.2507.044; Wed, 19 Feb 2025 11:04:50 +0100
From: "Reiterer, Horst" <horst.reiterer@fabasoft.com>
To: Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@manguebit.com>
CC: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: RE: [PATCH] smb: client: fix chmod(2) regression with ATTR_READONLY
Thread-Topic: [PATCH] smb: client: fix chmod(2) regression with ATTR_READONLY
Thread-Index: AduCtJRyurJeY+jcTpC1NDZnGlwmrg==
Date: Wed, 19 Feb 2025 10:04:50 +0000
Message-ID: <08e226c8df7246fbaf710f36b39ead4a@fabasoft.com>
Accept-Language: en-US, de-AT
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-purgate-ID: 152191::1739959490-CF3DDAC9-5FE6473A/0/0
X-purgate-type: clean
X-purgate-size: 4204
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean

SGksDQoNCnRoYW5rcywgU3RldmUgYW5kIFBhdWxvISBDb25zaWRlcmluZyB0aGUgc2V2ZXJpdHkg
KGNobW9kIGRvZXMgbm90IHRha2UgZWZmZWN0IGFueW1vcmUpIGFuZCB0aGUgZmFjdCB0aGF0IHRo
aXMgcmVncmVzc2lvbiB3YXMgY2F1c2VkIGJ5IGRyb3BwaW5nIGEgY29uZGl0aW9uIGluIHR3byBs
aW5lcyBvZiBjb2RlIHRoYXQgaXMgbWVyZWx5IGJlaW5nIHJlc3RvcmVkIGJ5IHRoZSBmaXggKGJh
c2ljYWxseSwgaXQncyBhIHBhcnRpYWwgcmV2ZXJ0KSwgaXMgdGhlcmUgYW55IHdheSB0byBwcmlv
cml0aXplIHRoaXMgY2hhbmdlIGFzIHRoZXJlJ3Mgbm8gcHJvZHVjdGlvbi1yZWFkeSB3b3JrYXJv
dW5kPyBJdCdzIGRpZmZpY3VsdCB0byBhdm9pZCB1cGRhdGluZyB0byA2LjYrIGF0IHRoaXMgcG9p
bnQuDQoNCkNoZWVycywNCg0KSG9yc3QgUmVpdGVyZXINCg0KLS0tLS1VcnNwcsO8bmdsaWNoZSBO
YWNocmljaHQtLS0tLQ0KVm9uOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4gDQpH
ZXNlbmRldDogTW9udGFnLCAxNy4gRmVicnVhciAyMDI1IDAwOjIwDQpBbjogUGF1bG8gQWxjYW50
YXJhIDxwY0BtYW5ndWViaXQuY29tPg0KQ2M6IGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnOyBS
ZWl0ZXJlciwgSG9yc3QgPGhvcnN0LnJlaXRlcmVyQGZhYmFzb2Z0LmNvbT4NCkJldHJlZmY6IFJl
OiBbUEFUQ0hdIHNtYjogY2xpZW50OiBmaXggY2htb2QoMikgcmVncmVzc2lvbiB3aXRoIEFUVFJf
UkVBRE9OTFkNCg0KdGVudGF0aXZlbHkgbWVyZ2VkIGludG8gY2lmcy0yLjYuZ2l0IGZvci1uZXh0
IHBlbmRpbmcgbW9yZSB0ZXN0aW5nIGFuZCByZXZpZXcNCg0KT24gU3VuLCBGZWIgMTYsIDIwMjUg
YXQgMzowMuKAr1BNIFBhdWxvIEFsY2FudGFyYSA8cGNAbWFuZ3VlYml0LmNvbT4gd3JvdGU6DQo+
DQo+IFdoZW4gdGhlIHVzZXIgc2V0cyBhIGZpbGUgb3IgZGlyZWN0b3J5IGFzIHJlYWQtb25seSAo
ZS5nLiB+U19JV1VHTyksIA0KPiB0aGUgY2xpZW50IHdpbGwgc2V0IHRoZSBBVFRSX1JFQURPTkxZ
IGF0dHJpYnV0ZSBieSBzZW5kaW5nIGFuIA0KPiBTTUIyX1NFVF9JTkZPIHJlcXVlc3QgdG8gdGhl
IHNlcnZlciBpbiBjaWZzX3NldGF0dHJfeyxub3VuaXh9KCksIGJ1dCANCj4gY2lmc0lub2RlSW5m
bzo6Y2lmc0F0dHJzIHdpbGwgYmUgbGVmdCB1bmNoYW5nZWQgYXMgdGhlIGNsaWVudCB3aWxsIA0K
PiBvbmx5IHVwZGF0ZSB0aGUgbmV3IGZpbGUgYXR0cmlidXRlcyBpbiB0aGUgbmV4dCBjYWxsIHRv
DQo+IHtzbWIzMTFfcG9zaXgsY2lmc31fZ2V0X2lub2RlX2luZm8oKSB3aXRoIHRoZSBuZXcgbWV0
YWRhdGEgZmlsbGVkIGluIA0KPiBAZGF0YSBwYXJhbWV0ZXIuDQo+DQo+IENvbW1pdCBhMTgyODBl
N2ZkZWEgKCJzbWI6IGNpbGVudDogc2V0IHJlcGFyc2UgbW91bnQgcG9pbnRzIGFzDQo+IGF1dG9t
b3VudHMiKSBtaXN0YWtlbmx5IHJlbW92ZWQgdGhlIEBkYXRhIE5VTEwgY2hlY2sgd2hlbiBjYWxs
aW5nIA0KPiBpc19pbm9kZV9jYWNoZV9nb29kKCksIHdoaWNoIGJyb2tlIHRoZSBhYm92ZSBjYXNl
IGFzIHRoZSBuZXcgDQo+IEFUVFJfUkVBRE9OTFkgYXR0cmlidXRlIHdvdWxkIGVuZCB1cCBub3Qg
YmVpbmcgdXBkYXRlZCBvbiBmaWxlcyB3aXRoIGEgDQo+IHJlYWQgbGVhc2UuDQo+DQo+IEZpeCB0
aGlzIGJ5IHVwZGF0aW5nIHRoZSBpbm9kZSB3aGVuZXZlciB3ZSBoYXZlIGNhY2hlZCBtZXRhZGF0
YSBpbiANCj4gQGRhdGEgcGFyYW1ldGVyLg0KPg0KPiBSZXBvcnRlZC1ieTogSG9yc3QgUmVpdGVy
ZXIgPGhvcnN0LnJlaXRlcmVyQGZhYmFzb2Z0LmNvbT4NCj4gQ2xvc2VzOiANCj4gaHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvci84NWExNjUwNGUwOTE0N2ExOTVhYzBhYWMxYzgwMTI4MEBmYWJhc29m
dC5jbw0KPiBtDQo+IEZpeGVzOiBhMTgyODBlN2ZkZWEgKCJzbWI6IGNpbGVudDogc2V0IHJlcGFy
c2UgbW91bnQgcG9pbnRzIGFzIA0KPiBhdXRvbW91bnRzIikNCj4gU2lnbmVkLW9mZi1ieTogUGF1
bG8gQWxjYW50YXJhIChSZWQgSGF0KSA8cGNAbWFuZ3VlYml0LmNvbT4NCj4gLS0tDQo+ICBmcy9z
bWIvY2xpZW50L2lub2RlLmMgfCA0ICsrLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlv
bnMoKyksIDIgZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9mcy9zbWIvY2xpZW50L2lu
b2RlLmMgYi9mcy9zbWIvY2xpZW50L2lub2RlLmMgaW5kZXggDQo+IDIxNDI0MDYxMjU0OS4uNjE2
MTQ5YzdmMGE1IDEwMDY0NA0KPiAtLS0gYS9mcy9zbWIvY2xpZW50L2lub2RlLmMNCj4gKysrIGIv
ZnMvc21iL2NsaWVudC9pbm9kZS5jDQo+IEBAIC0xNDIxLDcgKzE0MjEsNyBAQCBpbnQgY2lmc19n
ZXRfaW5vZGVfaW5mbyhzdHJ1Y3QgaW5vZGUgKippbm9kZSwNCj4gICAgICAgICBzdHJ1Y3QgY2lm
c19mYXR0ciBmYXR0ciA9IHt9Ow0KPiAgICAgICAgIGludCByYzsNCj4NCj4gLSAgICAgICBpZiAo
aXNfaW5vZGVfY2FjaGVfZ29vZCgqaW5vZGUpKSB7DQo+ICsgICAgICAgaWYgKCFkYXRhICYmIGlz
X2lub2RlX2NhY2hlX2dvb2QoKmlub2RlKSkgew0KPiAgICAgICAgICAgICAgICAgY2lmc19kYmco
RllJLCAiTm8gbmVlZCB0byByZXZhbGlkYXRlIGNhY2hlZCBpbm9kZSBzaXplc1xuIik7DQo+ICAg
ICAgICAgICAgICAgICByZXR1cm4gMDsNCj4gICAgICAgICB9DQo+IEBAIC0xNTIwLDcgKzE1MjAs
NyBAQCBpbnQgc21iMzExX3Bvc2l4X2dldF9pbm9kZV9pbmZvKHN0cnVjdCBpbm9kZSAqKmlub2Rl
LA0KPiAgICAgICAgIHN0cnVjdCBjaWZzX2ZhdHRyIGZhdHRyID0ge307DQo+ICAgICAgICAgaW50
IHJjOw0KPg0KPiAtICAgICAgIGlmIChpc19pbm9kZV9jYWNoZV9nb29kKCppbm9kZSkpIHsNCj4g
KyAgICAgICBpZiAoIWRhdGEgJiYgaXNfaW5vZGVfY2FjaGVfZ29vZCgqaW5vZGUpKSB7DQo+ICAg
ICAgICAgICAgICAgICBjaWZzX2RiZyhGWUksICJObyBuZWVkIHRvIHJldmFsaWRhdGUgY2FjaGVk
IGlub2RlIHNpemVzXG4iKTsNCj4gICAgICAgICAgICAgICAgIHJldHVybiAwOw0KPiAgICAgICAg
IH0NCj4gLS0NCj4gMi40OC4xDQo+DQoNCg0KLS0NClRoYW5rcywNCg0KU3RldmUNCg==
