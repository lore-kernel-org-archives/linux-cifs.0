Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 995C2C433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Jan 2022 18:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbiACSbo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Jan 2022 13:31:44 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:54532 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiACSbn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Jan 2022 13:31:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1641234703; x=1672770703;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=tN4iZjZLS7DP6Jmfhj7DIdFy3wbKmLky1l9OODny6zg=;
  b=YM0Byjnbvh0MxOGxngUvDIIoVbnQFLzKHpDW8rfnmfP4bk3BewzCfhxY
   keMujcoP7p+Dnr3XQvzeIxHYf8O5klGk3QFKE4FFxIE1va7EQvxTzSvQM
   q7c6zwhz3+SPWGk7uKtafuZBCqMJksQnpHWY/kVe4FJr0SPBHeRBWSSen
   Q=;
X-IronPort-AV: E=Sophos;i="5.88,258,1635206400"; 
   d="scan'208";a="167760262"
Subject: Re: [PATCH] cifs: fix set of group SID via NTSD xattrs
Thread-Topic: [PATCH] cifs: fix set of group SID via NTSD xattrs
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 03 Jan 2022 18:31:42 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com (Postfix) with ESMTPS id 44917422CB;
        Mon,  3 Jan 2022 18:31:41 +0000 (UTC)
Received: from EX13D11UEE002.ant.amazon.com (10.43.62.113) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 3 Jan 2022 18:31:40 +0000
Received: from EX13D11UEE004.ant.amazon.com (10.43.62.104) by
 EX13D11UEE002.ant.amazon.com (10.43.62.113) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Mon, 3 Jan 2022 18:31:40 +0000
Received: from EX13D11UEE004.ant.amazon.com ([10.43.62.104]) by
 EX13D11UEE004.ant.amazon.com ([10.43.62.104]) with mapi id 15.00.1497.026;
 Mon, 3 Jan 2022 18:31:40 +0000
From:   "Protopopov, Boris" <pboris@amazon.com>
To:     Amir Goldstein <amir73il@gmail.com>
CC:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <pshilovsky@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Thread-Index: AQHYALFobvizg40BHEe6zXFOv0dDQKxRMF6AgABsr4D//64KAA==
Date:   Mon, 3 Jan 2022 18:31:40 +0000
Message-ID: <916BEE4D-0F14-4978-8A4F-97E57D3DF108@amazon.com>
References: <20220103145025.3867146-1-amir73il@gmail.com>
 <69FC68E2-31C6-493A-BC60-ED1DF5860FC2@amazon.com>
 <CAOQ4uxjY3b5_1WCL3hpy27h3VkGfH1+6BTKF35aXexjuFvE+cA@mail.gmail.com>
In-Reply-To: <CAOQ4uxjY3b5_1WCL3hpy27h3VkGfH1+6BTKF35aXexjuFvE+cA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.60.244]
Content-Type: text/plain; charset="utf-8"
Content-ID: <598E0453849A91408085A3DAAA7D89F0@amazon.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

SGksIEFtaXIsDQpJIGFncmVlIHRoZSBsYW5ndWFnZSBpcyBhbWJpZ3VvdXMuIEkgYWxzbyB0aGlu
ayB0aGF0IGluY2x1ZGluZyB0aGUgZmxhZyBzaG91bGQgbm90IGJlIGhhcm1mdWwgaW4gYW55IHdh
eSAoSSBkbyBub3QgcmVjYWxsIG9ic2VydmluZyBhbnkgdW53YW50ZWQgc2lkZSBlZmZlY3RzKS4N
ClRoYW5rcyBmb3IgYWRkcmVzc2luZyB0aGUgaXNzdWUgZm91bmQgaW4gdGVzdGluZyB3aXRoIFNh
bWJhIQ0KQm9yaXMuIA0KDQrvu79PbiAxLzMvMjIsIDE6MjYgUE0sICJBbWlyIEdvbGRzdGVpbiIg
PGFtaXI3M2lsQGdtYWlsLmNvbT4gd3JvdGU6DQoNCiAgICBDQVVUSU9OOiBUaGlzIGVtYWlsIG9y
aWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGljayBs
aW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhlIHNlbmRl
ciBhbmQga25vdyB0aGUgY29udGVudCBpcyBzYWZlLg0KDQoNCg0KICAgIE9uIE1vbiwgSmFuIDMs
IDIwMjIgYXQgNjo1NiBQTSBQcm90b3BvcG92LCBCb3JpcyA8cGJvcmlzQGFtYXpvbi5jb20+IHdy
b3RlOg0KICAgID4NCiAgICA+IEhlbGxvLCBBbWlyLA0KICAgID4NCiAgICA+IEl0IGhhcyBiZWVu
IGEgd2hpbGUsIGJ1dCBJIHJlY2FsbCB0aGF0IGZyb20gbXkgcmVhZGluZyBvZiB0aGUgTVMgZG9j
cywgdGhlIG5vdGlvbiBvZiAib3duZXIiIHdhcyBzdXBwb3NlZCB0byBpbmNsdWRlIGJvdGggdXNl
ciBhbmQgdGhlIHByaW1hcnkgZ3JvdXAgU0lEcywgd2hpY2ggaXMgd2h5IHRoZSBjb21tZW50cyBp
biB0aGUgY29kZSBkaWQgbm90IGNhbGwgb3V0IGdyb3VwcyBleHBsaWNpdGx5Lg0KICAgID4gSSBh
bHNvIHJlY2FsbCB0aGF0IGR1cmluZyBkZXZlbG9wbWVudCwgSSB0ZXN0ZWQgd2l0aCBDSUZTX0FD
TF9HUk9VUCBmbGFnIGFnYWluc3QgV2luZG93cyAyMDEyIGFuZCAyMDE5IHNlcnZlcnMsIGFuZCBk
aWQgbm90IHNlZSBhIGRpZmZlcmVuY2UuIEkgZGlkIG5vdCB0ZXN0IGFnYWluc3QgU2FtYmEsIHdo
aWNoIGNsZWFybHksIHNob3dlZCBhbiBpc3N1ZSBkaXNjdXNzZWQgYmVsb3cuDQoNCiAgICBJbnRl
cmVzdGluZy4NCiAgICBJIGFkbWl0IHRoYXQgdGhlIGxhbmd1YWdlIG9mIHRoZSBkb2NzIGlzIGFt
YmlndW91czoNCiAgICBodHRwczovL2RvY3MubWljcm9zb2Z0LmNvbS9lbi11cy9vcGVuc3BlY3Mv
d2luZG93c19wcm90b2NvbHMvbXMtc21iMi9lZTk2MTRjNC1iZTU0LTRhM2MtOThmMS03NjlhNzAz
MmEwZTQNCiAgICAiLi4uZmxhZ3MgaW5kaWNhdGluZyB3aGF0IHNlY3VyaXR5IGF0dHJpYnV0ZXMg
TVVTVCBiZSBhcHBsaWVkIi4NCiAgICBTbyBhdHRyaWJ1dGVzIHdob3NlIGZsYWcgaXMgbm90IHNl
dCAoZS5nLiBncm91cCBTSUQpIE1BWSBiZSBhcHBsaWVkIG9yDQogICAgTVVTVCBOT1QgYmUgYXBw
bGllZD8NCiAgICBQZXJoYXBzIHNhbWJhIHdvdWxkIHdhbnQgdG8gYmUgYXMgcmVsYXhlZCBhcyBX
aW5kb3dzIGFib3V0IHRoZSBBQ0xfR1JPVVAgZmxhZy4NCg0KICAgIEluIGFueSBjYXNlLCBJIGRv
bid0IHNlZSBhIHJlYXNvbiBub3QgdG8gc2V0IHRoZSBmbGFnIHdoZW4gdGhlIGdyb3VwDQogICAg
U0lEIGluZm9ybWF0aW9uDQogICAgaXMgcHJlc2VudC4NCg0KICAgIFRoYW5rcywNCiAgICBBbWly
Lg0KDQogICAgPg0KICAgID4gQm9yaXMuDQogICAgPg0KICAgID4gT24gMS8zLzIyLCA5OjUxIEFN
LCAiQW1pciBHb2xkc3RlaW4iIDxhbWlyNzNpbEBnbWFpbC5jb20+IHdyb3RlOg0KICAgID4NCiAg
ICA+ICAgICBDQVVUSU9OOiBUaGlzIGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRo
ZSBvcmdhbml6YXRpb24uIERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3UgY2FuIGNvbmZpcm0gdGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVudCBpcyBz
YWZlLg0KICAgID4NCiAgICA+DQogICAgPg0KICAgID4gICAgICdzZXRjaWZzYWNsIC1nIDxTSUQ+
JyBzaWxlbnRseSBmYWlscyB0byBzZXQgdGhlIGdyb3VwIFNJRCBvbiBzZXJ2ZXIuDQogICAgPg0K
ICAgID4gICAgIEFjdHVhbGx5LCB0aGUgYnVnIGV4aXN0ZWQgc2luY2UgY29tbWl0IDQzODQ3MWI2
Nzk2MyAoIkNJRlM6IEFkZCBzdXBwb3J0DQogICAgPiAgICAgZm9yIHNldHRpbmcgb3duZXIgaW5m
bywgZG9zIGF0dHJpYnV0ZXMsIGFuZCBjcmVhdGUgdGltZSIpLCBidXQgdGhpcyBmaXgNCiAgICA+
ICAgICB3aWxsIG5vdCBhcHBseSBjbGVhbmx5IHRvIGtlcm5lbCB2ZXJzaW9ucyA8PSB2NS4xMC4N
CiAgICA+DQogICAgPiAgICAgRml4ZXM6IGE5MzUyZWU5MjZlYiAoIlNNQjM6IEFkZCBzdXBwb3J0
IGZvciBnZXR0aW5nIGFuZCBzZXR0aW5nIFNBQ0xzIikNCiAgICA+ICAgICBTaWduZWQtb2ZmLWJ5
OiBBbWlyIEdvbGRzdGVpbiA8YW1pcjczaWxAZ21haWwuY29tPg0KICAgID4gICAgIC0tLQ0KICAg
ID4NCiAgICA+ICAgICBCb3JpcywNCiAgICA+DQogICAgPiAgICAgSSBhbSBhIGxpdHRsZSBjb25m
dXNlZCBmcm9tIHRoZSBjb21tZW50cyBpbiB0aGUgY29kZSBhbiBlbWFpbHMuDQogICAgPiAgICAg
SW4gdGhpcyB0aHJlYWQgWzFdIHlvdSB3cm90ZSB0aGF0IHlvdSB0ZXN0ZWQgInNldHRpbmcvZ2V0
dGluZyB0aGUgb3duZXIsDQogICAgPiAgICAgREFDTCwgYW5kIFNBQ0wuLi4iLg0KICAgID4NCiAg
ICA+ICAgICBEb2VzIGl0IG1lYW4gdGhhdCB5b3UgZGlkIG5vdCB0ZXN0IHNldHRpbmcgZ3JvdXAg
U0lEPw0KICAgID4NCiAgICA+ICAgICBJdCBpcyBhbHNvIGNvbmZ1c2luZyB0aGF0IGNvbW1lbnRz
IGluIHRoZSBjb2RlIHNheXMgLyogb3duZXIgcGx1cyBEQUNMICovDQogICAgPiAgICAgYW5kIC8q
IG93bmVyL0RBQ0wvU0FDTCAqLy4NCiAgICA+ICAgICBEb2VzIGl0IG1lYW4gdGhhdCBzZXR0aW5n
IGdyb3VwIFNJRCBpcyBub3Qgc3VwcG9zZWQgdG8gYmUgc3VwcG9ydGVkPw0KICAgID4gICAgIE9y
IHdhcyB0aGlzIGp1c3QgYW4gb3ZlcnNpZ2h0Pw0KICAgID4NCiAgICA+ICAgICBBbnl3YXksIHdp
dGggdGhpcyBwYXRjaCwgc2V0Y2lmc2FjbCAtZyA8U0lEPiB3b3JrcyBhcyBleHBlY3RlZCwNCiAg
ICA+ICAgICBhdCBsZWFzdCB3aGVuIHRoZSBzZXJ2ZXIgaXMgc2FtYmEuDQogICAgPg0KICAgID4g
ICAgIFRoYW5rcywNCiAgICA+ICAgICBBbWlyLg0KICAgID4NCiAgICA+DQogICAgPiAgICAgWzFd
IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWNpZnMvQ0FIaEtwUTdQd2dEeXNTM25VQUEw
QUxMZE1acW56RzZxNndMMXRtbjNhcU9Qd1pieXlnQG1haWwuZ21haWwuY29tLw0KICAgID4NCiAg
ICA+ICAgICAgZnMvY2lmcy94YXR0ci5jIHwgMiArKw0KICAgID4gICAgICAxIGZpbGUgY2hhbmdl
ZCwgMiBpbnNlcnRpb25zKCspDQogICAgPg0KICAgID4gICAgIGRpZmYgLS1naXQgYS9mcy9jaWZz
L3hhdHRyLmMgYi9mcy9jaWZzL3hhdHRyLmMNCiAgICA+ICAgICBpbmRleCA3ZDhiNzJkNjdjODAu
LjlkNDg2ZmJiZmJiZCAxMDA2NDQNCiAgICA+ICAgICAtLS0gYS9mcy9jaWZzL3hhdHRyLmMNCiAg
ICA+ICAgICArKysgYi9mcy9jaWZzL3hhdHRyLmMNCiAgICA+ICAgICBAQCAtMTc1LDExICsxNzUs
MTMgQEAgc3RhdGljIGludCBjaWZzX3hhdHRyX3NldChjb25zdCBzdHJ1Y3QgeGF0dHJfaGFuZGxl
ciAqaGFuZGxlciwNCiAgICA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN3
aXRjaCAoaGFuZGxlci0+ZmxhZ3MpIHsNCiAgICA+ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIGNhc2UgWEFUVFJfQ0lGU19OVFNEX0ZVTEw6DQogICAgPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGFjbGZsYWdzID0gKENJRlNfQUNMX09XTkVS
IHwNCiAgICA+ICAgICArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgQ0lGU19BQ0xfR1JPVVAgfA0KICAgID4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBDSUZTX0FDTF9EQUNMIHwNCiAgICA+ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgQ0lG
U19BQ0xfU0FDTCk7DQogICAgPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIGJyZWFrOw0KICAgID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
Y2FzZSBYQVRUUl9DSUZTX05UU0Q6DQogICAgPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGFjbGZsYWdzID0gKENJRlNfQUNMX09XTkVSIHwNCiAgICA+ICAgICAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgQ0lGU19B
Q0xfR1JPVVAgfA0KICAgID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBDSUZTX0FDTF9EQUNMKTsNCiAgICA+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQogICAgPiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICBjYXNlIFhBVFRSX0NJRlNfQUNMOg0KICAgID4gICAgIC0tDQog
ICAgPiAgICAgMi4yNS4xDQogICAgPg0KICAgID4NCg0K
