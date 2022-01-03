Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B713BC433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Jan 2022 16:56:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiACQ4G (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Jan 2022 11:56:06 -0500
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:22513 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiACQ4G (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Jan 2022 11:56:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641228966; x=1672764966;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=u5++/tRleuXfaSvhkivfMg75D3kJejNAiAaxDrnqMBE=;
  b=mjvnbJxXol2YpEm8mA3wlueqHx3FY3zD00K65Dy4lToZ7q5SuFPkGPP/
   F9kud5Ydsu2xouTV/kFSKIHzvK+Taqz0MTn93qMlPM1C7n/OuYs6YTXM3
   1SKK/5BUOb352IbsXg3GN1Xb1ERuyYgKtBkk+7dknKlKO5NzkjX18UKPX
   k=;
X-IronPort-AV: E=Sophos;i="5.88,258,1635206400"; 
   d="scan'208";a="52312812"
Subject: Re: [PATCH] cifs: fix set of group SID via NTSD xattrs
Thread-Topic: [PATCH] cifs: fix set of group SID via NTSD xattrs
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 03 Jan 2022 16:56:05 +0000
Received: from EX13MTAUEE002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-c92fe759.us-east-1.amazon.com (Postfix) with ESMTPS id 797AFC0952;
        Mon,  3 Jan 2022 16:56:03 +0000 (UTC)
Received: from EX13D11UEE002.ant.amazon.com (10.43.62.113) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 3 Jan 2022 16:56:02 +0000
Received: from EX13D11UEE004.ant.amazon.com (10.43.62.104) by
 EX13D11UEE002.ant.amazon.com (10.43.62.113) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 3 Jan 2022 16:56:01 +0000
Received: from EX13D11UEE004.ant.amazon.com ([10.43.62.104]) by
 EX13D11UEE004.ant.amazon.com ([10.43.62.104]) with mapi id 15.00.1497.026;
 Mon, 3 Jan 2022 16:56:02 +0000
From:   "Protopopov, Boris" <pboris@amazon.com>
To:     Amir Goldstein <amir73il@gmail.com>,
        Steve French <smfrench@gmail.com>
CC:     Pavel Shilovsky <pshilovsky@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Thread-Index: AQHYALFobvizg40BHEe6zXFOv0dDQKxRMF6A
Date:   Mon, 3 Jan 2022 16:56:02 +0000
Message-ID: <69FC68E2-31C6-493A-BC60-ED1DF5860FC2@amazon.com>
References: <20220103145025.3867146-1-amir73il@gmail.com>
In-Reply-To: <20220103145025.3867146-1-amir73il@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.60.244]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C8C8F05678DF93459E189DD3F0968EF9@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

SGVsbG8sIEFtaXIsIA0KDQpJdCBoYXMgYmVlbiBhIHdoaWxlLCBidXQgSSByZWNhbGwgdGhhdCBm
cm9tIG15IHJlYWRpbmcgb2YgdGhlIE1TIGRvY3MsIHRoZSBub3Rpb24gb2YgIm93bmVyIiB3YXMg
c3VwcG9zZWQgdG8gaW5jbHVkZSBib3RoIHVzZXIgYW5kIHRoZSBwcmltYXJ5IGdyb3VwIFNJRHMs
IHdoaWNoIGlzIHdoeSB0aGUgY29tbWVudHMgaW4gdGhlIGNvZGUgZGlkIG5vdCBjYWxsIG91dCBn
cm91cHMgZXhwbGljaXRseS4NCkkgYWxzbyByZWNhbGwgdGhhdCBkdXJpbmcgZGV2ZWxvcG1lbnQs
IEkgdGVzdGVkIHdpdGggQ0lGU19BQ0xfR1JPVVAgZmxhZyBhZ2FpbnN0IFdpbmRvd3MgMjAxMiBh
bmQgMjAxOSBzZXJ2ZXJzLCBhbmQgZGlkIG5vdCBzZWUgYSBkaWZmZXJlbmNlLiBJIGRpZCBub3Qg
dGVzdCBhZ2FpbnN0IFNhbWJhLCB3aGljaCBjbGVhcmx5LCBzaG93ZWQgYW4gaXNzdWUgZGlzY3Vz
c2VkIGJlbG93Lg0KDQpCb3Jpcy4NCg0K77u/T24gMS8zLzIyLCA5OjUxIEFNLCAiQW1pciBHb2xk
c3RlaW4iIDxhbWlyNzNpbEBnbWFpbC5jb20+IHdyb3RlOg0KDQogICAgQ0FVVElPTjogVGhpcyBl
bWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5pemF0aW9uLiBEbyBub3Qg
Y2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGNhbiBjb25maXJtIHRo
ZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCg0KDQoNCiAgICAnc2V0Y2lm
c2FjbCAtZyA8U0lEPicgc2lsZW50bHkgZmFpbHMgdG8gc2V0IHRoZSBncm91cCBTSUQgb24gc2Vy
dmVyLg0KDQogICAgQWN0dWFsbHksIHRoZSBidWcgZXhpc3RlZCBzaW5jZSBjb21taXQgNDM4NDcx
YjY3OTYzICgiQ0lGUzogQWRkIHN1cHBvcnQNCiAgICBmb3Igc2V0dGluZyBvd25lciBpbmZvLCBk
b3MgYXR0cmlidXRlcywgYW5kIGNyZWF0ZSB0aW1lIiksIGJ1dCB0aGlzIGZpeA0KICAgIHdpbGwg
bm90IGFwcGx5IGNsZWFubHkgdG8ga2VybmVsIHZlcnNpb25zIDw9IHY1LjEwLg0KDQogICAgRml4
ZXM6IGE5MzUyZWU5MjZlYiAoIlNNQjM6IEFkZCBzdXBwb3J0IGZvciBnZXR0aW5nIGFuZCBzZXR0
aW5nIFNBQ0xzIikNCiAgICBTaWduZWQtb2ZmLWJ5OiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxA
Z21haWwuY29tPg0KICAgIC0tLQ0KDQogICAgQm9yaXMsDQoNCiAgICBJIGFtIGEgbGl0dGxlIGNv
bmZ1c2VkIGZyb20gdGhlIGNvbW1lbnRzIGluIHRoZSBjb2RlIGFuIGVtYWlscy4NCiAgICBJbiB0
aGlzIHRocmVhZCBbMV0geW91IHdyb3RlIHRoYXQgeW91IHRlc3RlZCAic2V0dGluZy9nZXR0aW5n
IHRoZSBvd25lciwNCiAgICBEQUNMLCBhbmQgU0FDTC4uLiIuDQoNCiAgICBEb2VzIGl0IG1lYW4g
dGhhdCB5b3UgZGlkIG5vdCB0ZXN0IHNldHRpbmcgZ3JvdXAgU0lEPw0KDQogICAgSXQgaXMgYWxz
byBjb25mdXNpbmcgdGhhdCBjb21tZW50cyBpbiB0aGUgY29kZSBzYXlzIC8qIG93bmVyIHBsdXMg
REFDTCAqLw0KICAgIGFuZCAvKiBvd25lci9EQUNML1NBQ0wgKi8uDQogICAgRG9lcyBpdCBtZWFu
IHRoYXQgc2V0dGluZyBncm91cCBTSUQgaXMgbm90IHN1cHBvc2VkIHRvIGJlIHN1cHBvcnRlZD8N
CiAgICBPciB3YXMgdGhpcyBqdXN0IGFuIG92ZXJzaWdodD8NCg0KICAgIEFueXdheSwgd2l0aCB0
aGlzIHBhdGNoLCBzZXRjaWZzYWNsIC1nIDxTSUQ+IHdvcmtzIGFzIGV4cGVjdGVkLA0KICAgIGF0
IGxlYXN0IHdoZW4gdGhlIHNlcnZlciBpcyBzYW1iYS4NCg0KICAgIFRoYW5rcywNCiAgICBBbWly
Lg0KDQoNCiAgICBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtY2lmcy9DQUhoS3BR
N1B3Z0R5c1MzblVBQTBBTExkTVpxbnpHNnE2d0wxdG1uM2FxT1B3WmJ5eWdAbWFpbC5nbWFpbC5j
b20vDQoNCiAgICAgZnMvY2lmcy94YXR0ci5jIHwgMiArKw0KICAgICAxIGZpbGUgY2hhbmdlZCwg
MiBpbnNlcnRpb25zKCspDQoNCiAgICBkaWZmIC0tZ2l0IGEvZnMvY2lmcy94YXR0ci5jIGIvZnMv
Y2lmcy94YXR0ci5jDQogICAgaW5kZXggN2Q4YjcyZDY3YzgwLi45ZDQ4NmZiYmZiYmQgMTAwNjQ0
DQogICAgLS0tIGEvZnMvY2lmcy94YXR0ci5jDQogICAgKysrIGIvZnMvY2lmcy94YXR0ci5jDQog
ICAgQEAgLTE3NSwxMSArMTc1LDEzIEBAIHN0YXRpYyBpbnQgY2lmc194YXR0cl9zZXQoY29uc3Qg
c3RydWN0IHhhdHRyX2hhbmRsZXIgKmhhbmRsZXIsDQogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBzd2l0Y2ggKGhhbmRsZXItPmZsYWdzKSB7DQogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBjYXNlIFhBVFRSX0NJRlNfTlRTRF9GVUxMOg0KICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBhY2xmbGFncyA9IChDSUZTX0FDTF9PV05F
UiB8DQogICAgKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIENJRlNfQUNMX0dST1VQIHwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgQ0lGU19BQ0xfREFDTCB8DQogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIENJRlNfQUNMX1NBQ0wpOw0KICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBicmVhazsNCiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNhc2UgWEFUVFJfQ0lGU19OVFNEOg0KICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBhY2xmbGFncyA9IChDSUZTX0FD
TF9PV05FUiB8DQogICAgKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIENJRlNfQUNMX0dST1VQIHwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgQ0lGU19BQ0xfREFDTCk7DQogICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGJyZWFrOw0KICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgY2FzZSBYQVRUUl9DSUZTX0FDTDoNCiAgICAtLQ0KICAgIDIuMjUu
MQ0KDQoNCg==
