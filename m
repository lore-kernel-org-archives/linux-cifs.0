Received: from fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.75.33.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682A049553C;
	Wed, 15 Jul 2026 17:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=3.75.33.185
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784136479; cv=fail; b=JWkdFoXiyoHBgShDAvAR6V5+FBbEprmtE8Y7j49D09QothAq1e4pU3zf8ODZI9O2hlhWlk4ZoNbdYkdZLaRmyd+QdMJbujAUo5p7h5kStsboR10ASuq80EAnWe/ebAb32f2dw8P6jaF9D8S1J1A9HDwjo69CFooITMoiFehRAOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784136479; c=relaxed/simple;
	bh=SDW+xF6cEGpsItYWkTn8QRFv0CXquDWs5rAFapDr0P0=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YG5UbP3gnxBnxfvREtfFPAd1P3xBP1Y0TBUJ7umQPq6HScDtxz+u1OEGQtc6IPLACPmDW2m5i4sAPZy682Mo1jlk/tP19S1/YMnjzUYv5lFA0eqXn7xEdKPrIs7LlRh6i3DAA2GXP+NYbNK9c9TPag/LyhWkWCZ+Ud0I1MiRfCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=k1tPtdzB; arc=fail smtp.client-ip=3.75.33.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="k1tPtdzB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1784136475; x=1815672475;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=SDW+xF6cEGpsItYWkTn8QRFv0CXquDWs5rAFapDr0P0=;
  b=k1tPtdzBGCUhPXvPB2fgpz+9nHVzA32jeyS8yo8jMCBiKLZ05CHcAXj6
   3FCIp/oUvGvj2giXV1BYOcoOwQ2WfPh8kHaKzE2mxIHohM4A7FcTO9z/t
   nXs1/1ItoRFa1BgL6rh0hSGUIF1upcOD/OvDk5Yndmc65XyzaIFf70bwO
   LLrRUT33/sTQLQEAvPg+p24M3zLwYYANGxl2AxjSmB1FXVnHimEeR2VFK
   PGL/Vu8B6QBat1HIBCtz/OXfuzPTAco/y0DPy7AnT2dusVA25hnX49Yob
   vmFFt6ipH85cVjQqT8C/L2OGJDWmpdDSHnlGx58Niq0eTTg9QoUui596c
   A==;
X-CSE-ConnectionGUID: XL0kjWdYSuq+WAP9SxevnA==
X-CSE-MsgGUID: JdHXd41ZThWy5BEPKbEmnw==
X-IronPort-AV: E=Sophos;i="6.25,165,1779148800"; 
   d="scan'208";a="16519403"
Subject: Re: [PATCH] smb: client: set SB_I_NODEV to prevent device node injection
Thread-Topic: [PATCH] smb: client: set SB_I_NODEV to prevent device node injection
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 17:27:49 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.233:15207]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.14.42:2525] with esmtp (Farcaster)
 id 104ed7ee-5c37-4ad7-ac6e-0c076c4fbae5; Wed, 15 Jul 2026 17:27:49 +0000 (UTC)
X-Farcaster-Flow-ID: 104ed7ee-5c37-4ad7-ac6e-0c076c4fbae5
Received: from EX19EXOEUB001.ant.amazon.com (10.252.51.80) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 15 Jul 2026 17:27:49 +0000
Received: from EX19EXOEUC002.ant.amazon.com (10.252.51.145) by
 EX19EXOEUB001.ant.amazon.com (10.252.51.80) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 15 Jul 2026 17:27:49 +0000
Received: from FR6P281CU001.outbound.protection.outlook.com (10.252.51.94) by
 EX19EXOEUC002.ant.amazon.com (10.252.51.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43
 via Frontend Transport; Wed, 15 Jul 2026 17:27:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ePIPEtP7s4qb7wtwRi0Xes84KMYv+8Cqt+AQrjsrHWcTYBYUFB0d7Ob79ek55Km3ud9tBEBInsAn28gqLYAXTttn4v/7ax2xIKmodiEjHb4Zg1rT91tBJHfIpUApy7Ev+lhOuNPB5GIg1coZqWFDHrDJ+wwnkGs1DIdEOLNe4ldw+I/5ds8AhE36QdGJe2sU8QmKb9sovayVX9Lxo6PbIdmK5/kFSpqubWF170qAiLwrfblKu8Xwrcx/Em2QUj05x/2qO4fkY89irJ73Y06Bj39raEZ3BPCuNKMDPGNfBtKrizF6i4jelrjiWo/llh3rLcv6X4BsTR5uxqQ9ax+odw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SDW+xF6cEGpsItYWkTn8QRFv0CXquDWs5rAFapDr0P0=;
 b=ExVpZtB9mu+0/bXNQp6kPP6kYedv4ID0bHs9cSbeh5KJwpOJgtJjC6dVBVuAMHVzyJJ0pLK+sQkCpz5XUjPt5dKM0+T9u//nlv1/M9Vwoj7n878ZrbUvVvnBlhfsYgLWeGqzO78rQEgPa8YzAt4m0EiEyLBhrXFrxCsNSMwXpiT318w2S75p9dCwrFTrPJAWhRPVgsQhQ2URbDYRgcxm3c97NHDlOeGr4IbUC2mHlZC8tNyqlXdpIQ9TiP+eNePLidXHqnNWkc3i39FG2Nw/K6y0CD27aLXia/wncWB2I3SHQgIcKdY62UwqowqcNdyk2HJ+/GJCMtxoxbFeKXPTRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.de; dmarc=pass action=none header.from=amazon.de;
 dkim=pass header.d=amazon.de; arc=none
Received: from FR5P281MB5091.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:192::5)
 by FR1PPF70F09C7DD.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d18::f58) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.11; Wed, 15 Jul
 2026 17:27:45 +0000
Received: from FR5P281MB5091.DEUP281.PROD.OUTLOOK.COM
 ([fe80::c925:fc90:3cb8:6964]) by FR5P281MB5091.DEUP281.PROD.OUTLOOK.COM
 ([fe80::c925:fc90:3cb8:6964%6]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 17:27:45 +0000
From: "Manthey, Norbert" <nmanthey@amazon.de>
To: Steve French <smfrench@gmail.com>
CC: "Doebel, Bjoern" <doebel@amazon.de>, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
	<sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
	<bharathsm@microsoft.com>, "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "samba-technical@lists.samba.org"
	<samba-technical@lists.samba.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	David Howells <dhowells@redhat.com>
Thread-Index: AQHdD7tTP2bz0NwOh0yZdyax3UPbl7ZlbwiAgAFGY1SABt6mgIABStAz
Date: Wed, 15 Jul 2026 17:27:45 +0000
Message-ID: <FR5P281MB509126A065753950A95D97A2CFF82@FR5P281MB5091.DEUP281.PROD.OUTLOOK.COM>
References: <20260709155440.2132459-3-doebel@amazon.de>
 <CAH2r5msvEGdEJvyV5sWcZjQ0SjMOwXP_Ad4eKN7etHtXS1vwbA@mail.gmail.com>
 <FR5P281MB509177A7DE157E6D72EC05B3CFFD2@FR5P281MB5091.DEUP281.PROD.OUTLOOK.COM>
 <CAH2r5ms-_Z1c3twqt8i_syyXpi1jtBJm15GuvRhUXEk8BVwAQw@mail.gmail.com>
In-Reply-To: <CAH2r5ms-_Z1c3twqt8i_syyXpi1jtBJm15GuvRhUXEk8BVwAQw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amazon.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FR5P281MB5091:EE_|FR1PPF70F09C7DD:EE_
x-ms-office365-filtering-correlation-id: 9ce76c2c-cf10-4ab7-71a2-08dee296625a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|10067099003|22082099003|18002099003|4143699003|56012099006|38070700021|11063799006;
x-microsoft-antispam-message-info: wIE1wWLmwWwiFHvnysEEhiSKWRPo27f/3sJAoaon4Bdw0L4xQzMi/1PEdgStbGoEbXAQ0cORacHPpFEYMhzqr+Kz1jpNvuB7bYaqh1W0RWZaFmqDgASQiZghM4e080cc0HthHoVee6lM9FFIVawCpuaMM/xwL+VJw3fQdrgLNoXNQ08yziPYuqaqih4i+YBVv0ewcS5v6SYJ21zW445JXDcRa+n87cQlYaoswbyPxYzgTiwr0p+ccnz1E3T76Hz1CmTjKH5/0PkL36C8Y8vHl+gLwuZ0R+4qfnXotX38GGCGZy5YmYCS9kRKQxT6yZi/UApNU8su1MOQgVck1FiOcGXugPEEQtShYKE6nE9JaF82I20xfCd2S3NdnuISUP11Dczfngay8HYji0mh974FjFWQJ0kfsGL79LPAb4xHoyxhZPQwFNa4s88LZAYitch3ZlvjaSM/Khs9U7piPjBipYe5A7nSILn9CyyE6ue7hpqGVL5TSYGyCFM0h5gbf7L91UgCJthIm/JKc/TUwFFa4hxppvotfc1GqmDluKQvjgMbVloQc/KrrRHRrF2YTTBni3uNvLSsx2WQ7Ian9EH9Y1ulVpqZ/eRxqaMuCNANM5gLU6OQ2hy4DmWspAjjuO+Yd8gkPGCVoHTu35waF2ZU8YuOon3jdkwL95i5sfBVclc9ItiYeTGLnrNe/Q5YcGsU/988S1Q7EV0NLi8bdJ8KAIkkmSSLEKd3PVDhxQNQtiU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR5P281MB5091.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(10067099003)(22082099003)(18002099003)(4143699003)(56012099006)(38070700021)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXJpdzBNclIyZzRKOWYxZXhBVmQxTnJYSlFTZW5GWjd4QTBrcG0vMkV0Ym5Q?=
 =?utf-8?B?Y0ZmWUZ4S2tJK3ZnempmYm8yL3BzdXJ2Zm1od1Zia29XM29obFRTMUFQbGZ2?=
 =?utf-8?B?SDBaeE5DdE1VQmN4VW5sWmljM0xzb2dXTjR3Y2RrN0RMaXg0TVZuUitsUmlU?=
 =?utf-8?B?ZFZtdkJUMFpqcS9kNG8vVjAxMkdwa3RHYlVBemN0UlNWcmdlZzhwT1RObzlW?=
 =?utf-8?B?OTFmUGplQ2N0ZTlwUkpxUnhIelJQNW9RTjB6RURSNG9UUC9hTUYrUUgxM1Zm?=
 =?utf-8?B?YWlmZTB4UXArWGpMOGJTcGN6bld0MDAyY2hCd0ZNalBOaXFmamo4eEhadysv?=
 =?utf-8?B?Y2taTEt2d3hha0lrc1FETmNXNHAxNzVKTWw4ZVBaYWRFZDMrNThhMWc4bGtL?=
 =?utf-8?B?RlRjcTEvVkFhRnZGREZmNm9DQzRSWlBrck9rZS9MN1EvaWdSWGs5UGUrbGph?=
 =?utf-8?B?S2ZCRS9hZFZVNERWdmlXZkJlZndZOVdqQks4VHpuUmtSTDZXbW5sNExGR3Jk?=
 =?utf-8?B?NFI2a0x0c3RpNkhZU2VQTWt6MHFTeEM0N1BsWHJIRUQ4SzJEeUZ2SGFHcmdy?=
 =?utf-8?B?UmJtTlZ2dXpUYWNYa3pzNmMrTDFzY0JxVnR0eHp5VTRwUDZLdStSamZoN0RQ?=
 =?utf-8?B?ZkJKRmlvVDZNb3NaZ0IwVVZsSGV1MmdpeU1wNnFXQXU3R1BWelpjdm0zMU05?=
 =?utf-8?B?Y2VEZXRLSmNSWEZDTUlxMGtPRkNZZlpnVU91RndVbStKNWRkVmdVVWZnd0lr?=
 =?utf-8?B?emxINUlWakZMNCtxWWxhRitLZ3E1NjAzNWlZd2RTWS9xSGozRHlwZ05Vd3NH?=
 =?utf-8?B?WWN4bjlTNzBBemhxaWdUNis2aWRxTzJnSS82Rm1NdGVqMUFRK0hia29sTTBv?=
 =?utf-8?B?ejNmL1kwNVdnak1iTCtNWG9rZEVIOEVkTGdpcnJpcVl5WWZmMWVFUVdJS3FS?=
 =?utf-8?B?Y0lKZjY4U1hrdUFXS3Q2RFFVYWxZdHplL0pBRTJWQU9ScXZ0YUd6Q0lKRkpk?=
 =?utf-8?B?bmtuQkE3dGxQS0luRHp6T2ZzaUQ3RTJ3MDc4ampCT1dsWTZLY09ScTc4VGR0?=
 =?utf-8?B?L1NHbTFtTDViTXI1VkR4Q0pWYjJZNDZ6Z2FYVGJ4N3FXbzFvSmhDNFZqZVFS?=
 =?utf-8?B?cENoTURwMVZ6OGZUSEdvYVhPSUlEUW5VbHlGWHVIZ3c4V3ZidC9VbnN6S1NP?=
 =?utf-8?B?d1BuaDlzMUV1dVhZNnpEdzMrbGVka3QwQkRXQmYyalZDeUNnTVdCL1VUZGNz?=
 =?utf-8?B?aHVaVE5WaWYzeXJ0eE9rMWVONHVUUjhpRlY3Vno1VDhzd2x2Y3I2RmVuTnY1?=
 =?utf-8?B?dTExY1lqZHdzY2lja2YzVXpVQkJ3aHVnM1ZZV2NabzBmbjZ2ekM5YXJOSHFE?=
 =?utf-8?B?S1RsalVXdkUyVWZKeU9MRkFPTTRRVFJWR3ZSZWtqY2ZWL3hhclI3S3FLRnph?=
 =?utf-8?B?NlZrOUNXRkh2S3p3VkwzSm1UakpRRnZRTFJRN0UwTUt2RHRqTy9VVWhiRUJ4?=
 =?utf-8?B?M2pGbUtxY215eWNqL0pvOWpjbGM4MG5OR3o2Z1czNlRZZmlQZElVVHVsYkQ5?=
 =?utf-8?B?YzFVeXVoaVhXQ1lSTU9KMGYvdTNuZEF6R0hvRkFsTkVzVnlKRXh0cm9HMFNV?=
 =?utf-8?B?OVlGQko5b2ViTC8xQUYveGZteVVCMlFVSFdKZnZzdmZPSnBCTVBPSytaR2hV?=
 =?utf-8?B?TERZNXhaZ0VHbHA1eFdJamhlSHRReXFHbThLQ0pheHVxTFFNTHZqUVFqeG5P?=
 =?utf-8?B?dkJLRkhyajRVNUltSXBOemhUV05ML2ZtWVlablVjSnM2eFRhMGo0WDlobk95?=
 =?utf-8?B?QWVrUXVlcU14bjcraDRkcmU0ZFEyV2hkTmlyN056alRXZmVDc2xIaVJoK25s?=
 =?utf-8?B?QVZPVGlMd3FwbFZwYnBURGwrM0RBQmQ5V0VjZjF3ZVdETWt0Z1ZQalErVWVH?=
 =?utf-8?B?ZWcvSFp4alRFOWU0QVhVbDZoby96dlJ4bXF0WG5POHZKZ1Z2UVVRMVZpUU0w?=
 =?utf-8?B?Q1drOWw2V0JMM2orQ25Nem5ocHVLWUR6NzNMSUI5eGpvTjZnS3JXaU9oOVpN?=
 =?utf-8?B?UUZLMEplcnkwWGVVdEJYdWlodEFOM2ZkVkdBUGNnVGVnRU5FMjE2dDZLRTFM?=
 =?utf-8?B?eHpubHMwL3p6d0ZrU2RoUXlNR2toa1JXYUh3QW1idUNlQUhWQ0F1NWNXTC8x?=
 =?utf-8?B?MmVnTHRHMkE0dzZ1YU5aeWE0My82MXp0RGwyUDNqUHc1MXZKRFZpd3M0T20v?=
 =?utf-8?B?ZmZHa1Z1bUhldklUUFQ2Vkx1bDBWWkdCZkc0Ty9BSnRPOUd6UHFGbHYrSklt?=
 =?utf-8?Q?vVmL/vpxq0K3Lm3PG5?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: bgeeoZThypW5CIATI/RLfEfG2DIXQq4XZudUCACYJokhs8SNdIr341UyUHETySgBtKkelKdtwUU+gruYfunFslepcvzgELssQwFAeCByeh/O+Wn/HZvC0qdn6V/eyCNJ7xUFMrFCVBk1VU/KViZ5zkudYMXDpUs1kTgiJ7QNj/DtJUUKxfzW9Th21avVVe0u1c0T9Nk+F43SBv1x+o4RPfHeJj6G0HmnF+DX0NXqu4mPFwcxslg5A1nPYkTx4usb13Ohi3EKZPVUf4J2ONWeoHd4XmhHwmnF9eboug/fFMxAH47qHrHEDKus4+iWKdO8hx2L8M0b4/Ntdpb9Ae//yg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FR5P281MB5091.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ce76c2c-cf10-4ab7-71a2-08dee296625a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2026 17:27:45.6023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QJj3ZPGw1ekIcJbB6f2N0Da/tCOME/uHovctm2MKgXvtI1d/24fiHEDbINZSs3i2/vMVLQV7P9P+fDZqBvHpjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR1PPF70F09C7DD
X-OriginatorOrg: amazon.de

VGhpcyBpcyBsaWtlbHkuIFdlIGRpZCBub3QgaW52ZXN0aWdhdGUgdGhlIG90aGVyIGZpbGUgc3lz
dGVtcy4gV2UndmUgYmVlbiBsb29raW5nIHNwZWNpZmljYWxseSBpbnRvIENJRlMuIEFzIEkgYW0g
bm90IGEgZmlsZSBzeXN0ZW0gZXhwZXJ0LCBJJ2QgYXBwcmVjaWF0ZSBoZWxwIGFuZCBndWlkYW5j
ZSBmcm9tIGV4cGVydHMgb24gdGhpcy4KClRoYW5rcywKTm9yYmVydAoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdt
YWlsLmNvbT4KU2VudDogVHVlc2RheSwgSnVseSAxNCwgMjAyNiAxMTo0MyBQTQpUbzogTWFudGhl
eSwgTm9yYmVydCA8bm1hbnRoZXlAYW1hem9uLmRlPgpDYzogRG9lYmVsLCBCam9lcm4gPGRvZWJl
bEBhbWF6b24uZGU+OyBQYXVsbyBBbGNhbnRhcmEgPHBjQG1hbmd1ZWJpdC5vcmc+OyBSb25uaWUg
U2FobGJlcmcgPHJvbm5pZXNhaGxiZXJnQGdtYWlsLmNvbT47IFNoeWFtIFByYXNhZCBOIDxzcHJh
c2FkQG1pY3Jvc29mdC5jb20+OyBUb20gVGFscGV5IDx0b21AdGFscGV5LmNvbT47IEJoYXJhdGgg
U00gPGJoYXJhdGhzbUBtaWNyb3NvZnQuY29tPjsgbGludXgtY2lmc0B2Z2VyLmtlcm5lbC5vcmcg
PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPjsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9y
ZyA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47IHNhbWJhLXRlY2huaWNhbEBsaXN0cy5z
YW1iYS5vcmcgPHNhbWJhLXRlY2huaWNhbEBsaXN0cy5zYW1iYS5vcmc+OyBzdGFibGVAdmdlci5r
ZXJuZWwub3JnIDxzdGFibGVAdmdlci5rZXJuZWwub3JnPjsgbGludXgtZnNkZXZlbCA8bGludXgt
ZnNkZXZlbEB2Z2VyLmtlcm5lbC5vcmc+OyBEYXZpZCBIb3dlbGxzIDxkaG93ZWxsc0ByZWRoYXQu
Y29tPgpTdWJqZWN0OiBSRTogW0VYVEVSTkFMXSBbUEFUQ0hdIHNtYjogY2xpZW50OiBzZXQgU0Jf
SV9OT0RFViB0byBwcmV2ZW50IGRldmljZSBub2RlIGluamVjdGlvbgrCoApDQVVUSU9OOiBUaGlz
IGVtYWlsIG9yaWdpbmF0ZWQgZnJvbSBvdXRzaWRlIG9mIHRoZSBvcmdhbml6YXRpb24uIERvIG5v
dCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgY2FuIGNvbmZpcm0g
dGhlIHNlbmRlciBhbmQga25vdyB0aGUgY29udGVudCBpcyBzYWZlLgoKCgpJZiB0aGlzIGlzIG5l
ZWRlZCBmb3IgY2lmcy5rbyB3b3VsZG4ndCB0aGlzIGFsc28gYmUgbmVlZGVkIGZvciBBRlMsCk5G
UywgQ0VQSCBhbmQgb3RoZXJzPwoKT24gVHVlLCBKdWwgMTQsIDIwMjYgYXQgMTE6MjPigK9BTSBN
YW50aGV5LCBOb3JiZXJ0IDxubWFudGhleUBhbWF6b24uZGU+IHdyb3RlOgo+Cj4gSGkgU3RldmUs
Cj4KPiBUaGUgaXNzdWUgaXMgdGhhdCB0aGUgY2xpZW50IHRha2VzIHRoZSBkZXZpY2Ugbm9kZSdz
IG1vZGUgc3RyYWlnaHQKPiBmcm9tIHRoZSBzZXJ2ZXIuIFNvIGEgbWFsaWNpb3VzL2NvbXByb21p
c2VkIFNNQiBzZXJ2ZXIgY2FuIGRlZmluZSBhCj4gZGV2aWNlIG5vZGUgKHR5cGUgKyBtYWpvci9t
aW5vciArIHBlcm1pc3Npb25zKSBvbiB0aGUgY2xpZW50IHRoYXQgdGhlCj4gYWRtaW4gbmV2ZXIg
Y3JlYXRlZCBhbmQgY2Fubm90IG90aGVyd2lzZSBjb25zdHJhaW4gLS0gdGhlIG9ubHkga25vYgo+
IGxlZnQgdG8gYmxvY2sgaXQgaXMgdGhlICJub2RldiIgbW91bnQgb3B0aW9uLiBUaGF0J3Mgd2h5
IHdlIGludHJvZHVjZQo+IHRoZSBjaGFuZ2UgdXNpbmcgU0JfSV9OT0RFViBoZXJlLgo+Cj4gV2Ug
ZGlkIGFuYWx5emUgdGhlIENJRlMgY29kZSwgYW5kIGZvdW5kIHRoaXMgbWlzc2luZyBzZWN1cml0
eSBjaGVja3MuCj4gV2UgaGF2ZSBhIHJlcHJvZHVjZXIgdGhhdCBhbGxvd3MgYSBtYWxpY2lvdXMg
c2VydmVyIGFuZCBsb2NhbCB1c2VyIHRvCj4gZWxldmF0ZSBwcml2aWxlZ2VzIGJ5IGludHJvZHVj
aW5nIGEgbmV3IGRldmljZSBpbiB0aGUgbW91bnQuCj4KPiBCZXN0LAo+IE5vcmJlcnQKPgo+IF9f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KPiBGcm9tOiBTdGV2ZSBGcmVu
Y2ggPHNtZnJlbmNoQGdtYWlsLmNvbT4KPiBTZW50OiBUaHVyc2RheSwgSnVseSA5LCAyMDI2IDc6
MjAgUE0KPiBUbzogRG9lYmVsLCBCam9lcm4gPGRvZWJlbEBhbWF6b24uZGU+Cj4gQ2M6IFBhdWxv
IEFsY2FudGFyYSA8cGNAbWFuZ3VlYml0Lm9yZz47IFJvbm5pZSBTYWhsYmVyZyA8cm9ubmllc2Fo
bGJlcmdAZ21haWwuY29tPjsgU2h5YW0gUHJhc2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0LmNvbT47
IFRvbSBUYWxwZXkgPHRvbUB0YWxwZXkuY29tPjsgQmhhcmF0aCBTTSA8YmhhcmF0aHNtQG1pY3Jv
c29mdC5jb20+OyBsaW51eC1jaWZzQHZnZXIua2VybmVsLm9yZyA8bGludXgtY2lmc0B2Z2VyLmtl
cm5lbC5vcmc+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnIDxsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnPjsgc2FtYmEtdGVjaG5pY2FsQGxpc3RzLnNhbWJhLm9yZyA8c2FtYmEtdGVj
aG5pY2FsQGxpc3RzLnNhbWJhLm9yZz47IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcgPHN0YWJsZUB2
Z2VyLmtlcm5lbC5vcmc+OyBNYW50aGV5LCBOb3JiZXJ0IDxubWFudGhleUBhbWF6b24uZGU+OyBs
aW51eC1mc2RldmVsIDxsaW51eC1mc2RldmVsQHZnZXIua2VybmVsLm9yZz4KPiBTdWJqZWN0OiBS
RTogW0VYVEVSTkFMXSBbUEFUQ0hdIHNtYjogY2xpZW50OiBzZXQgU0JfSV9OT0RFViB0byBwcmV2
ZW50IGRldmljZSBub2RlIGluamVjdGlvbgo+Cj4gQ0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5h
dGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5pemF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mg
b3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5k
IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4KPgo+Cj4KPiBTZXR0aW5nIFNCX0lfTk9ERVYgaXMg
YXBwYXJlbnRseSBub3QgZG9uZSBmb3IgYW55IHJlbW90ZSBmaWxlc3lzdGVtcywKPiBhbmQgQUkg
c2VhcmNoIGNvbmZpcm1lZCB0aGF0IGl0IHByb2JhYmx5IGlzbid0IGEgZ29vZCBpZGVhIHRvIHNl
dCBpdAo+IGZvciByZW1vdGUgZnMuwqAgSXQgaXMgbW9yZSBvZiBhIHRoaW5nIGluIHBzZXVkb2Zp
bGVzeXN0ZW1zIGFuZCBub3QKPiBuZWVkZWQgZm9yIG5ldHdvcmsgZmlsZXN5c3RlbXMuCj4KPiBl
LmcuCj4KPiAiSXMgdGhlcmUgYW55IGJlbmVmaXQgdG8gc2V0dGluZyBTQl9JX05PREVWPwo+Cj4g
VG9kYXksIHByb2JhYmx5IG5vdC5JZiB5b3UgZ3JlcCB0aGUga2VybmVsLCB5b3UnbGwgZmluZCBT
Ql9JX05PREVWIGlzCj4gdXNlZCBpbiBvbmx5IGEgaGFuZGZ1bCBvZiBwbGFjZXMsIGFuZCB0aG9z
ZSBwbGFjZXMgZ2VuZXJhbGx5IGludm9sdmUKPiBwc2V1ZG8tZmlsZXN5c3RlbXMgb3IgaW50ZXJu
YWwgVkZTIGFzc3VtcHRpb25zIHJhdGhlciB0aGFuIHJlbW90ZQo+IHN0b3JhZ2UuwqAgU2V0dGlu
ZyBpdCBvbiBDSUZTIG9yIE5GUyBpcyB1bmxpa2VseSB0byBjaGFuZ2UgYmVoYXZpb3IsCj4gYmVj
YXVzZSB0aG9zZSBmaWxlc3lzdGVtcyBoYXZlIHdvcmtlZCBjb3JyZWN0bHkgZm9yIGRlY2FkZXMg
d2l0aG91dAo+IGl0LiBNb3N0IHJlbW90ZSBmaWxlc3lzdGVtcyBkb24ndCBzZXQgc19pZmxhZ3Mg
YmVjYXVzZSBhbG1vc3Qgbm9uZSBvZgo+IHRoZSBTQl9JXyogZmxhZ3MgYXJlIGludGVuZGVkIGFz
IGdlbmVyaWMgZmlsZXN5c3RlbSBjYXBhYmlsaXR5IGZsYWdzLgo+IFRoZXkncmUgbW9zdGx5IGlu
dGVybmFsIFZGUyBzdGF0ZSwgYW5kIFNCX0lfTk9ERVYgaW4gcGFydGljdWxhciBoYXMgYQo+IHZl
cnkgc3BlY2lmaWMgcHVycG9zZS7CoCBTQl9JX05PREVWIGRvZXMgbm90IG1lYW4gInRoaXMgZmls
ZXN5c3RlbQo+IGNvbnRhaW5zIG5vIGRldmljZSBub2Rlcy4iIEl0IG1lYW5zIHNvbWV0aGluZyBj
bG9zZXIgdG86wqAgVGhpcwo+IHN1cGVyYmxvY2sgaXMgbm90IGFzc29jaWF0ZWQgd2l0aCBhIGJs
b2NrIGRldmljZS4KPiBvciBtb3JlIHByZWNpc2VseTogVGhlIFZGUyBzaG91bGQgbm90IGV4cGVj
dCBhIGJhY2tpbmcgc3RydWN0Cj4gYmxvY2tfZGV2aWNlIGZvciB0aGlzIHN1cGVyYmxvY2suIgo+
Cj4gSGFzIHNvbWV0aGluZyBjaGFuZ2VkP8KgIEhvdyBkaWQgdGhpcyBxdWVzdGlvbiBhYm91dCBT
Ql9JX05PREVWIGNvbWUgdXA/Cj4KPiBPbiBUaHUsIEp1bCA5LCAyMDI2IGF0IDExOjA14oCvQU0g
QmpvZXJuIERvZWJlbCA8ZG9lYmVsQGFtYXpvbi5kZT4gd3JvdGU6Cj4gPgo+ID4gRnJvbTogTm9y
YmVydCBNYW50aGV5IDxubWFudGhleUBhbWF6b24uZGU+Cj4gPgo+ID4gU2V0IFNCX0lfTk9ERVYg
b24gdGhlIHN1cGVyYmxvY2sgYnkgZGVmYXVsdCBmb3IgQ0lGUyBtb3VudHMuIFRoaXMgaXMKPiA+
IGNvbnNpc3RlbnQgd2l0aCBob3cgb3RoZXIgZmlsZXN5c3RlbXMgaGFuZGxlIHVudHJ1c3RlZCBy
ZW1vdGUgY29udGVudAo+ID4gYW5kIHByZXZlbnRzIHRoZSBzZXJ2ZXIgc2lkZSBmcm9tIGluamVj
dGluZyBkZXZpY2Ugbm9kZXMgb24gdGhlIGNsaWVudC4KPiA+Cj4gPiBGaXhlczogMmU0NTY0YjMx
YjY0NSAoInNtYjM6IGFkZCBzdXBwb3J0IGZvciBzdGF0IG9mIFdTTCByZXBhcnNlIHBvaW50cyBm
b3Igc3BlY2lhbCBmaWxlIHR5cGVzIikKPiA+IFNpZ25lZC1vZmYtYnk6IE5vcmJlcnQgTWFudGhl
eSA8bm1hbnRoZXlAYW1hem9uLmRlPgo+ID4gQXNzaXN0ZWQtYnk6IEtpcm86Y2xhdWRlLW9wdXMt
NC42Cj4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwo+ID4gLS0tCj4gPsKgIGZzL3NtYi9j
bGllbnQvY2lmc2ZzLmMgfCAzICsrKwo+ID7CoCAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25z
KCspCj4gPgo+ID4gZGlmZiAtLWdpdCBhL2ZzL3NtYi9jbGllbnQvY2lmc2ZzLmMgYi9mcy9zbWIv
Y2xpZW50L2NpZnNmcy5jCj4gPiBpbmRleCBlYTRmYzBmYTY4Y2FjLi4zNWVlZTJmOTg5OWQ1IDEw
MDY0NAo+ID4gLS0tIGEvZnMvc21iL2NsaWVudC9jaWZzZnMuYwo+ID4gKysrIGIvZnMvc21iL2Ns
aWVudC9jaWZzZnMuYwo+ID4gQEAgLTIwOCw2ICsyMDgsOSBAQCBjaWZzX3JlYWRfc3VwZXIoc3Ry
dWN0IHN1cGVyX2Jsb2NrICpzYikKPiA+wqDCoMKgwqDCoMKgwqDCoCBpZiAoc2JmbGFncyAmIENJ
RlNfTU9VTlRfUE9TSVhBQ0wpCj4gPsKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNi
LT5zX2ZsYWdzIHw9IFNCX1BPU0lYQUNMOwo+ID4KPiA+ICvCoMKgwqDCoMKgwqAgLyogUHJldmVu
dCBkZXZpY2Ugbm9kZSBvcGVucyBmcm9tIHJlbW90ZSBmaWxlc3lzdGVtIGJ5IGRlZmF1bHQgKi8K
PiA+ICvCoMKgwqDCoMKgwqAgc2ItPnNfaWZsYWdzIHw9IFNCX0lfTk9ERVY7Cj4gPiArCj4gPsKg
wqDCoMKgwqDCoMKgwqAgaWYgKHRjb24tPnNuYXBzaG90X3RpbWUpCj4gPsKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIHNiLT5zX2ZsYWdzIHw9IFNCX1JET05MWTsKPiA+Cj4gPiAtLQo+
ID4gMi41MC4xCj4gPgo+ID4KPgo+Cj4gLS0KPiBUaGFua3MsCj4KPiBTdGV2ZQoKCgotLQpUaGFu
a3MsCgpTdGV2ZQ==
