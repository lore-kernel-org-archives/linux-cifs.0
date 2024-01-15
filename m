Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3C417587;
	Mon, 15 Jan 2024 14:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="sNLiRA5q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1705328932; x=1736864932;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xQGPj3byAT3xg6HXEqj6hk569ABSLScKNqtUQXksmrM=;
  b=sNLiRA5qbNqo115OH8sbWSg/zwK8g5z9O8WaNYc73pO/flvE2Ss08yjH
   R4EK8LirwpChvbX9Y/X02sASzBsTgXfyFsaZ3qGc120rWb1uOQYNmYP48
   dB7bd2HXAItgMDm689UzqvAnXAmpMqpY44vTCjUErPK0LLHH03/0UsalS
   o=;
X-IronPort-AV: E=Sophos;i="6.04,196,1695686400"; 
   d="scan'208";a="627714016"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-3554bfcf.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2024 14:28:49 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan2.iad.amazon.com [10.32.235.34])
	by email-inbound-relay-iad-1e-m6i4x-3554bfcf.us-east-1.amazon.com (Postfix) with ESMTPS id D4C2080745;
	Mon, 15 Jan 2024 14:28:47 +0000 (UTC)
Received: from EX19MTAEUB001.ant.amazon.com [10.0.10.100:63692]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.29.188:2525] with esmtp (Farcaster)
 id 301d6222-fbf0-458d-8c25-f5fc5317250b; Mon, 15 Jan 2024 14:28:46 +0000 (UTC)
X-Farcaster-Flow-ID: 301d6222-fbf0-458d-8c25-f5fc5317250b
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 15 Jan 2024 14:28:46 +0000
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19D018EUA004.ant.amazon.com (10.252.50.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 15 Jan 2024 14:28:46 +0000
Received: from EX19D018EUA004.ant.amazon.com ([fe80::e53:84f8:3456:a97d]) by
 EX19D018EUA004.ant.amazon.com ([fe80::e53:84f8:3456:a97d%3]) with mapi id
 15.02.1118.040; Mon, 15 Jan 2024 14:28:46 +0000
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
Thread-Index: AQHaR75LM7i+fdSIyUGAeQeGznKGwbDa7s2A
Date: Mon, 15 Jan 2024 14:28:45 +0000
Message-ID: <9B20AAD6-2C27-4791-8CA9-D7DB912EDC86@amazon.com>
References: <53F11617-D406-47C6-8CA7-5BE26EB042BE@amazon.com>
In-Reply-To: <53F11617-D406-47C6-8CA7-5BE26EB042BE@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-ID: <75A5AEE301C0BB4982CC698F97CE44DE@amazon.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

VG8gYmUgY2xlYXIgaGVyZSB3ZSBoYXZlIGFscmVhZHkgdGVzdGVkIDUuMTAuMjA2IGFuZCA1LjE1
LjE0NiB3aXRoIHRoZSBwcm9wb3NlZCBmaXggDQphbmQgd2Ugbm8gbG9uZ2VyIHNlZSB0aGUgcmVw
b3J0ZWQgQ0lGUyBtb3VudGluZyBmYWlsdXJlLg0KDQpIYXplbQ0KDQrvu79PbiAxNS8wMS8yMDI0
LCAxNDoyMywgIk1vaGFtZWQgQWJ1ZWxmb3RvaCwgSGF6ZW0iIDxhYnVlaGF6ZUBhbWF6b24uY29t
IDxtYWlsdG86YWJ1ZWhhemVAYW1hem9uLmNvbT4+IHdyb3RlOg0KDQoNCkl0IGxvb2tzIGxpa2Ug
Ym90aCA1LjE1LjE0NiBhbmQgNS4xMC4yMDYgYXJlIGltcGFjdGVkIGJ5IHRoaXMgcmVncmVzc2lv
biBhcyB0aGV5IGJvdGggaGF2ZSB0aGUNCmJhZCBjb21taXQgMzNlYWU2NWM2ZiAoc21iOiBjbGll
bnQ6IGZpeCBPT0IgaW4gU01CMl9xdWVyeV9pbmZvX2luaXQoKSkuIFdlIHRyaWVkIHRvDQphcHBs
eSB0aGUgcHJvcG9zZWQgZml4IGViM2UyOGMxZTg5YiAoInNtYjM6IFJlcGxhY2Ugc21iMnBkdSAx
LWVsZW1lbnQgDQphcnJheXMgd2l0aCBmbGV4LWFycmF5c+KAnSkgYnV0IHRoZXJlIGFyZSBhIGxv
dCBvZiBkZXBlbmRlbmNpZXMgcmVxdWlyZWQgdG8gZG8gdGhlIGJhY2twb3J0Lg0KSXMgaXQgcG9z
c2libGUgdG8gY29uc2lkZXIgdGhlIHNpbXBsZSBmaXggdGhhdCBQYXVsbyBwcm9wb3NlZCBhcyBh
IHNvbHV0aW9uIGZvciA1LjEwIGFuZCA1LjE1Lg0KV2Ugd2VyZSBsdWNreSB3aXRoIDUuNCBhcyBp
dCBkb2VzbuKAmXQgaGF2ZSB0aGUgYmFkIGNvbW1pdCBiZWNhdXNlIG9mIG1lcmdlIGNvbmZsaWN0
IHJlcG9ydGVkDQppbiBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMzEyMjg1Ny1kb3Vi
bGluZy1jcmF6ZWQtMjdmNEBncmVna2gvVC8jbTNhYTAwOWMzMzI5OTkyNjhmNzEzNjEyMzdhY2U2
ZGVkOTExMGYwZDAgPGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDIzMTIyODU3LWRvdWJs
aW5nLWNyYXplZC0yN2Y0QGdyZWdraC9ULyNtM2FhMDA5YzMzMjk5OTI2OGY3MTM2MTIzN2FjZTZk
ZWQ5MTEwZjBkMD4NCg0KDQpkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9zbWIycGR1LmMgYi9m
cy9zbWIvY2xpZW50L3NtYjJwZHUuYw0KaW5kZXggMDVmZjhhNDU3YTNkLi5hZWQ1MDY3NjYxZGUg
MTAwNjQ0DQotLS0gYS9mcy9zbWIvY2xpZW50L3NtYjJwZHUuYw0KKysrIGIvZnMvc21iL2NsaWVu
dC9zbWIycGR1LmMNCkBAIC0zNTU2LDcgKzM1NTYsNyBAQCBTTUIyX3F1ZXJ5X2luZm9faW5pdChz
dHJ1Y3QgY2lmc190Y29uICp0Y29uLCBzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsDQoN
Cg0KaW92WzBdLmlvdl9iYXNlID0gKGNoYXIgKilyZXE7DQovKiAxIGZvciBCdWZmZXIgKi8NCi0g
aW92WzBdLmlvdl9sZW4gPSBsZW47DQorIGlvdlswXS5pb3ZfbGVuID0gbGVuIC0gMTsNCnJldHVy
biAwOw0KfQ0KDQoNCkhhemVtDQoNCg==
