Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A36E1773B;
	Mon, 15 Jan 2024 15:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="WRrt7Jey"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1705332657; x=1736868657;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=exV8y98u2bqs6A3YBmKFr5+VHizS0jgEfcutRDhdhcc=;
  b=WRrt7JeyZ1j1DkBT83ePvjarAcsM9v3+PK1larVAzca9+nAkhnupjwsN
   ub0YvWw54nbYuU2HGdy2f6oPgBnLsYlO3Pj2H1UtSfjLANjhlFmZ39gru
   68xMey+CxIkCq+6vvdb5BbQs5Wj2+bH/BIaIJyRELVtDteQCoWylQoEDA
   4=;
X-IronPort-AV: E=Sophos;i="6.04,196,1695686400"; 
   d="scan'208";a="266111465"
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with "Resource
 temporarily unavailable"
Thread-Topic: [REGRESSION 6.1.70] system calls with CIFS mounts failing with "Resource
 temporarily unavailable"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-1cca8d67.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2024 15:30:51 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan3.pdx.amazon.com [10.39.38.70])
	by email-inbound-relay-pdx-2a-m6i4x-1cca8d67.us-west-2.amazon.com (Postfix) with ESMTPS id 39B8880787;
	Mon, 15 Jan 2024 15:30:50 +0000 (UTC)
Received: from EX19MTAEUB001.ant.amazon.com [10.0.43.254:39326]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.32.109:2525] with esmtp (Farcaster)
 id 3c596a8e-e340-42e3-9d79-ef203a7de35c; Mon, 15 Jan 2024 15:30:49 +0000 (UTC)
X-Farcaster-Flow-ID: 3c596a8e-e340-42e3-9d79-ef203a7de35c
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 15 Jan 2024 15:30:46 +0000
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19D018EUA004.ant.amazon.com (10.252.50.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 15 Jan 2024 15:30:46 +0000
Received: from EX19D018EUA004.ant.amazon.com ([fe80::e53:84f8:3456:a97d]) by
 EX19D018EUA004.ant.amazon.com ([fe80::e53:84f8:3456:a97d%3]) with mapi id
 15.02.1118.040; Mon, 15 Jan 2024 15:30:46 +0000
From: "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "pc@manguebit.com" <pc@manguebit.com>, "leonardo@schenkel.net"
	<leonardo@schenkel.net>, "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>, "m.weissbach@info-gate.de"
	<m.weissbach@info-gate.de>, "regressions@lists.linux.dev"
	<regressions@lists.linux.dev>, "sairon@sairon.cz" <sairon@sairon.cz>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Thread-Index: AQHaR75LM7i+fdSIyUGAeQeGznKGwbDa7s2AgAANc4CAAAPggA==
Date: Mon, 15 Jan 2024 15:30:46 +0000
Message-ID: <716A5E86-9D25-4729-BF65-90AC2A335301@amazon.com>
References: <53F11617-D406-47C6-8CA7-5BE26EB042BE@amazon.com>
 <9B20AAD6-2C27-4791-8CA9-D7DB912EDC86@amazon.com>
 <2024011521-feed-vanish-5626@gregkh>
In-Reply-To: <2024011521-feed-vanish-5626@gregkh>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <F63379A1EA730042A9C297CAB8C22BE5@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

VGhhbmtzIEdyZWcsIEkgd2lsbCBzdWJtaXQgc2VwYXJhdGUgcGF0Y2ggaW5jbHVzaW9uIHJlcXVl
c3RzIGZvciANCmZpeGluZyB0aGlzIG9uIDUuMTUgYW5kIDUuMTAuDQoNCkhhemVtDQoNCu+7v09u
IDE1LzAxLzIwMjQsIDE1OjE3LCAiZ3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmcgPG1haWx0bzpn
cmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4iIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZyA8
bWFpbHRvOmdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPj4gd3JvdGU6DQoNCg0KQ0FVVElPTjog
VGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5pemF0aW9uLiBE
byBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGNhbiBjb25m
aXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4NCg0KDQoNCg0KDQoN
Ck9uIE1vbiwgSmFuIDE1LCAyMDI0IGF0IDAyOjI4OjQ1UE0gKzAwMDAsIE1vaGFtZWQgQWJ1ZWxm
b3RvaCwgSGF6ZW0gd3JvdGU6DQo+IFRvIGJlIGNsZWFyIGhlcmUgd2UgaGF2ZSBhbHJlYWR5IHRl
c3RlZCA1LjEwLjIwNiBhbmQgNS4xNS4xNDYgd2l0aCB0aGUgcHJvcG9zZWQgZml4DQo+IGFuZCB3
ZSBubyBsb25nZXIgc2VlIHRoZSByZXBvcnRlZCBDSUZTIG1vdW50aW5nIGZhaWx1cmUuDQoNCg0K
UGxlYXNlIGRvbid0IHRvcC1wb3N0IDooDQoNCg0KQW55d2F5LCBwbGVhc2Ugc3VibWl0IHRoaXMg
aW4gYSBmb3JtIHRoYXQgaXQgY2FuIGJlIGFwcGxpZWQgaW4sIGFzLWlzLA0KdGhlcmUncyBub3Ro
aW5nIEkgY2FuIGRvIHdpdGggdGhpcy4uLg0KDQoNCnRoYW5rcywNCg0KDQpncmVnIGstaA0KDQoN
Cg0KDQoNCg==
