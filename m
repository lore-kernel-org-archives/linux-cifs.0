Return-Path: <SRS0=yIrz=UT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E676C43613
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Jun 2019 06:54:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE8802085A
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Jun 2019 06:54:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbfFTGyp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Jun 2019 02:54:45 -0400
Received: from mx.socionext.com ([202.248.49.38]:55610 "EHLO mx.socionext.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbfFTGyp (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 20 Jun 2019 02:54:45 -0400
Received: from unknown (HELO kinkan-ex.css.socionext.com) ([172.31.9.52])
  by mx.socionext.com with ESMTP; 20 Jun 2019 15:54:43 +0900
Received: from mail.mfilter.local (m-filter-2 [10.213.24.62])
        by kinkan-ex.css.socionext.com (Postfix) with ESMTP id D467318008D;
        Thu, 20 Jun 2019 15:54:43 +0900 (JST)
Received: from 10.213.24.1 (10.213.24.1) by m-FILTER with ESMTP; Thu, 20 Jun 2019 15:54:43 +0900
Received: from SOC-EX01V.e01.socionext.com (10.213.24.21) by
 SOC-EX03V.e01.socionext.com (10.213.24.23) with Microsoft SMTP Server (TLS)
 id 15.0.995.29; Thu, 20 Jun 2019 15:54:43 +0900
Received: from SOC-EX01V.e01.socionext.com ([10.213.24.21]) by
 SOC-EX01V.e01.socionext.com ([10.213.24.21]) with mapi id 15.00.0995.028;
 Thu, 20 Jun 2019 15:54:43 +0900
From:   <yamada.masahiro@socionext.com>
To:     <herbert@gondor.apana.org.au>, <stfrench@microsoft.com>,
        <linux-cifs@vger.kernel.org>
CC:     <masahiroy@kernel.org>
Subject: RE: cifs: Fix tracing build error with O=
Thread-Topic: cifs: Fix tracing build error with O=
Thread-Index: AQHVJzMQEej+zHNF8EizAwObw3VSVqakGQ2g
Date:   Thu, 20 Jun 2019 06:54:42 +0000
Message-ID: <9c994536a297449d843947ba9be05998@SOC-EX01V.e01.socionext.com>
References: <20190620064023.cwvcj5g4rgnmkmmn@gondor.apana.org.au>
In-Reply-To: <20190620064023.cwvcj5g4rgnmkmmn@gondor.apana.org.au>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-securitypolicycheck: OK by SHieldMailChecker v2.5.2
x-shieldmailcheckerpolicyversion: POLICY190117
x-originating-ip: [10.213.24.1]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

SGkgSGVyYmVydCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIZXJi
ZXJ0IFh1IFttYWlsdG86aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1XQ0KPiBTZW50OiBUaHVy
c2RheSwgSnVuZSAyMCwgMjAxOSAzOjQwIFBNDQo+IFRvOiBTdGV2ZSBGcmVuY2ggPHN0ZnJlbmNo
QG1pY3Jvc29mdC5jb20+OyBsaW51eC1jaWZzQHZnZXIua2VybmVsLm9yZw0KPiBDYzogWWFtYWRh
LCBNYXNhaGlyby8bJEI7M0VEGyhCIBskQj8/OTAbKEIgPHlhbWFkYS5tYXNhaGlyb0Bzb2Npb25l
eHQuY29tPg0KPiBTdWJqZWN0OiBjaWZzOiBGaXggdHJhY2luZyBidWlsZCBlcnJvciB3aXRoIE89
DQo+IA0KPiBDdXJyZW50bHkgaWYgeW91IGJ1aWxkIHRoZSBrZXJuZWwgd2l0aCBPPSB0aGVuIGZz
L2NpZnMgZmFpbHMgd2l0aDoNCj4gDQo+ICQgbWFrZSBPPWJ1aWxkDQo+IC4uLg0KPiAgIENDIFtN
XSAgZnMvY2lmcy90cmFjZS5vDQo+IEluIGZpbGUgaW5jbHVkZWQgZnJvbSAuLi9mcy9jaWZzL3Ry
YWNlLmg6ODQ2OjAsDQo+ICAgICAgICAgICAgICAgICAgZnJvbSAuLi9mcy9jaWZzL3RyYWNlLmM6
ODoNCj4gLi4vaW5jbHVkZS90cmFjZS9kZWZpbmVfdHJhY2UuaDo5NTo0MzogZmF0YWwgZXJyb3I6
IC4vdHJhY2UuaDogTm8gc3VjaA0KPiBmaWxlIG9yIGRpcmVjdG9yeQ0KPiAgI2luY2x1ZGUgVFJB
Q0VfSU5DTFVERShUUkFDRV9JTkNMVURFX0ZJTEUpDQo+ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBeDQo+IGNvbXBpbGF0aW9uIHRlcm1pbmF0ZWQuDQoNCg0KDQpX
aGljaCBrZXJuZWwgdmVyc2lvbiBhcmUgeW91IHRlc3Rpbmc/DQoNCkkgY2Fubm90IHJlcHJvZHVj
ZSB0aGUgYnVpbGQgZXJyb3Igb24gdGhlIGxhdGVzdCBMaW51cyB0cmVlLg0KDQoNCiQgbWFrZSBP
PWJ1aWxkIGFsbG1vZGNvbmZpZyBmcy9jaWZzLw0KDQpwZXJmZWN0bHkgd29ya3MgZm9yIG1lLg0K
DQoNCg0KSW4gZmFjdCwgS2J1aWxkIGF1dG9tYXRpY2FsbHkgYWRkcyAgIi1JICQoc3JjdHJlZSkv
JChzcmMpIg0KZm9yIE89Li4uIGJ1aWxkaW5nDQoNClNlZSB0aGlzIGNvZGU6DQoNCmh0dHBzOi8v
Z2l0aHViLmNvbS90b3J2YWxkcy9saW51eC9ibG9iL3Y1LjItcmM1L3NjcmlwdHMvTWFrZWZpbGUu
bGliI0wxNDQNCg0KDQpTbywgSSB3b25kZXIgd2h5IHlvdSBuZWVkIHRvIGR1cGxpY2F0ZSAiLUkg
JChzcmN0cmVlKS8kKHNyYykiDQoNCg0KVGhhbmtzLg0KDQoNCj4gDQo+IFRoZSByZWFzb24gaXMg
dGhhdCAtSSQoc3JjKSBleHBhbmRzIHRvIC1JZnMvY2lmcyB3aGljaCBkb2VzIG5vdA0KPiB3b3Jr
IHdpdGggTz0uICBUaGlzIHBhdGNoIGZpeGVzIGl0IGJ5IGFkZGluZyBzcmN0cmVlIHRvIHRoZSBm
cm9udC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEhlcmJlcnQgWHUgPGhlcmJlcnRAZ29uZG9yLmFw
YW5hLm9yZy5hdT4NCj4gDQo+IGRpZmYgLS1naXQgYS9mcy9jaWZzL01ha2VmaWxlIGIvZnMvY2lm
cy9NYWtlZmlsZQ0KPiBpbmRleCA1MWFmNjlhMWEzMjguLjYxNjE2M2RlZWUxOCAxMDA2NDQNCj4g
LS0tIGEvZnMvY2lmcy9NYWtlZmlsZQ0KPiArKysgYi9mcy9jaWZzL01ha2VmaWxlDQo+IEBAIC0y
LDcgKzIsNyBAQA0KPiAgIw0KPiAgIyBNYWtlZmlsZSBmb3IgTGludXggQ0lGUy9TTUIyL1NNQjMg
VkZTIGNsaWVudA0KPiAgIw0KPiAtY2NmbGFncy15ICs9IC1JJChzcmMpCQkjIG5lZWRlZCBmb3Ig
dHJhY2UgZXZlbnRzDQo+ICtjY2ZsYWdzLXkgKz0gLUkkKHNyY3RyZWUpLyQoc3JjKQkJIyBuZWVk
ZWQgZm9yIHRyYWNlDQo+IGV2ZW50cw0KPiAgb2JqLSQoQ09ORklHX0NJRlMpICs9IGNpZnMubw0K
PiANCj4gIGNpZnMteSA6PSB0cmFjZS5vIGNpZnNmcy5vIGNpZnNzbWIubyBjaWZzX2RlYnVnLm8g
Y29ubmVjdC5vIGRpci5vIGZpbGUubw0KPiBcDQo+IC0tDQo+IEVtYWlsOiBIZXJiZXJ0IFh1IDxo
ZXJiZXJ0QGdvbmRvci5hcGFuYS5vcmcuYXU+DQo+IEhvbWUgUGFnZTogaHR0cDovL2dvbmRvci5h
cGFuYS5vcmcuYXUvfmhlcmJlcnQvDQo+IFBHUCBLZXk6IGh0dHA6Ly9nb25kb3IuYXBhbmEub3Jn
LmF1L35oZXJiZXJ0L3B1YmtleS50eHQNCg==
