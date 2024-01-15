Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01AC17586;
	Mon, 15 Jan 2024 14:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="XkZ1Ghen"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1705328577; x=1736864577;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=Utvj7x9E+Orvhkvt+ss9gfCqsK5WXaOixgloOQjRA2g=;
  b=XkZ1GhenHjo56OiDzy+r2BqdtxamSpD1XTr+an/lbAZOjKRdQ7V+yYvC
   UcXVHYlvbCs6A75MSBG3S+kWseNFVomJvYmgJ+saFImX7iIBHl5geMjIO
   qdl7bNE4OGcdNRflJCI/2Bpw6bZrjhRk9+eCxdYsmzSsnWaGyg4caEfop
   M=;
X-IronPort-AV: E=Sophos;i="6.04,196,1695686400"; 
   d="scan'208";a="266097149"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-7dc0ecf1.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2024 14:22:50 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan2.iad.amazon.com [10.32.235.34])
	by email-inbound-relay-iad-1e-m6i4x-7dc0ecf1.us-east-1.amazon.com (Postfix) with ESMTPS id 568B880500;
	Mon, 15 Jan 2024 14:22:47 +0000 (UTC)
Received: from EX19MTAEUC002.ant.amazon.com [10.0.10.100:29382]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.25.75:2525] with esmtp (Farcaster)
 id 3c7a9486-e5d4-4d34-ac8e-444257e5892d; Mon, 15 Jan 2024 14:22:45 +0000 (UTC)
X-Farcaster-Flow-ID: 3c7a9486-e5d4-4d34-ac8e-444257e5892d
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 15 Jan 2024 14:22:39 +0000
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19D018EUA004.ant.amazon.com (10.252.50.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 15 Jan 2024 14:22:39 +0000
Received: from EX19D018EUA004.ant.amazon.com ([fe80::e53:84f8:3456:a97d]) by
 EX19D018EUA004.ant.amazon.com ([fe80::e53:84f8:3456:a97d%3]) with mapi id
 15.02.1118.040; Mon, 15 Jan 2024 14:22:39 +0000
From: "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
To: "pc@manguebit.com" <pc@manguebit.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"leonardo@schenkel.net" <leonardo@schenkel.net>, "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>, "m.weissbach@info-gate.de"
	<m.weissbach@info-gate.de>, "regressions@lists.linux.dev"
	<regressions@lists.linux.dev>, "sairon@sairon.cz" <sairon@sairon.cz>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
Thread-Topic: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
Thread-Index: AQHaR75LM7i+fdSIyUGAeQeGznKGwQ==
Date: Mon, 15 Jan 2024 14:22:39 +0000
Message-ID: <53F11617-D406-47C6-8CA7-5BE26EB042BE@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <8512E8F2A2DA9442B640A06EBF6E406E@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

SXQgbG9va3MgbGlrZSBib3RoIDUuMTUuMTQ2IGFuZCA1LjEwLjIwNiBhcmUgaW1wYWN0ZWQgYnkg
dGhpcyByZWdyZXNzaW9uIGFzIHRoZXkgYm90aCBoYXZlIHRoZQ0KYmFkIGNvbW1pdCAzM2VhZTY1
YzZmIChzbWI6IGNsaWVudDogZml4IE9PQiBpbiBTTUIyX3F1ZXJ5X2luZm9faW5pdCgpKS4gV2Ug
dHJpZWQgdG8NCmFwcGx5IHRoZSBwcm9wb3NlZCBmaXggZWIzZTI4YzFlODliICgic21iMzogUmVw
bGFjZSBzbWIycGR1IDEtZWxlbWVudCANCmFycmF5cyB3aXRoIGZsZXgtYXJyYXlz4oCdKSBidXQg
dGhlcmUgYXJlIGEgbG90IG9mIGRlcGVuZGVuY2llcyByZXF1aXJlZCB0byBkbyB0aGUgYmFja3Bv
cnQuDQpJcyBpdCBwb3NzaWJsZSB0byBjb25zaWRlciB0aGUgc2ltcGxlIGZpeCB0aGF0IFBhdWxv
IHByb3Bvc2VkIGFzIGEgc29sdXRpb24gZm9yIDUuMTAgYW5kIDUuMTUuDQpXZSB3ZXJlIGx1Y2t5
IHdpdGggNS40IGFzIGl0IGRvZXNu4oCZdCBoYXZlIHRoZSBiYWQgY29tbWl0IGJlY2F1c2Ugb2Yg
bWVyZ2UgY29uZmxpY3QgcmVwb3J0ZWQNCmluIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8y
MDIzMTIyODU3LWRvdWJsaW5nLWNyYXplZC0yN2Y0QGdyZWdraC9ULyNtM2FhMDA5YzMzMjk5OTI2
OGY3MTM2MTIzN2FjZTZkZWQ5MTEwZjBkMA0KDQpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9z
bWIycGR1LmMgYi9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYw0KCWluZGV4IDA1ZmY4YTQ1N2EzZC4u
YWVkNTA2NzY2MWRlIDEwMDY0NA0KCS0tLSBhL2ZzL3NtYi9jbGllbnQvc21iMnBkdS5jDQoJKysr
IGIvZnMvc21iL2NsaWVudC9zbWIycGR1LmMNCglAQCAtMzU1Niw3ICszNTU2LDcgQEAgU01CMl9x
dWVyeV9pbmZvX2luaXQoc3RydWN0IGNpZnNfdGNvbiAqdGNvbiwgc3RydWN0IFRDUF9TZXJ2ZXJf
SW5mbyAqc2VydmVyLA0KCSANCgkgCWlvdlswXS5pb3ZfYmFzZSA9IChjaGFyICopcmVxOw0KCSAJ
LyogMSBmb3IgQnVmZmVyICovDQoJLQlpb3ZbMF0uaW92X2xlbiA9IGxlbjsNCgkrCWlvdlswXS5p
b3ZfbGVuID0gbGVuIC0gMTsNCgkgCXJldHVybiAwOw0KCSB9DQoNCkhhemVt
