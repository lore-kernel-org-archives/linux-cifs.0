Received: from fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.197.217.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D553827707;
	Tue, 14 Jul 2026 16:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=18.197.217.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784046197; cv=fail; b=jua8BYXSBfFAetMCIlT4KNjpDLNUNM1YvJqOP5zxZflfQkHD/bVDiP4VV7kjJLlXWKNYOiEWLCZeE6znMRHkhwBXck1pyePyVLyujmP3+RpJhIdR1SCU/SzGxs+xYZRg4d9wKHgiHv/r6iLENZn/AC2uRDeTwbJNS/q8w5gOBCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784046197; c=relaxed/simple;
	bh=GFiPXbrX2avW+c9IgTJH3VjOLA/WICbUupaNpKFpVGI=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ulqninmp4Dh3e40qk8KsSap9VVvNH50SAqF7Cifo/nrCufNlsXdFPMPR1khTm1h0YjYjUMD5d/o1bIcCKTv8pBkqsyRAVcFkIiabG1CCIC6SuRqhPOZ4AwI64iirg4ddG6aVsvJHrBR+t02GpsvdukInPWX0wqGRI9dHyuCpYOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=B38bC9Fq; arc=fail smtp.client-ip=18.197.217.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="B38bC9Fq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1784046195; x=1815582195;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=GFiPXbrX2avW+c9IgTJH3VjOLA/WICbUupaNpKFpVGI=;
  b=B38bC9FqhKE4aDJZfqKoQUwIhYl7Gaf0QQqGq6O+LsUQFatrv1BQHrpJ
   uZjTSxWCdVWXlyhKqIIIi/pZoiGOXcXRycal4iPvFKGr/ARsgv9E/abJD
   eWrlT/4b5b7tw4wdnl1bGDIgMHQH7do53NF+csMQ5KQ5QMtr+653vKpZV
   imAmMhjs/6G0qDM9X5sbGCsqcpseC2Hud91nIvZxiyC1rVWejKQoWaG90
   6FUvO8FvuIDHKyMw7cKwgC3EDN1hELuZ800ZIcolnaRVs+FQIiGjJZwXe
   LsjnbjsyxScwxY/j+8Zd2pYZY+cCtMOHxyntzpfB1SBJ76xhMgZrWWBTC
   g==;
X-CSE-ConnectionGUID: vsSRDMruQfuU9RQ4Zje5BA==
X-CSE-MsgGUID: hdlDf9JuT2ao6kbmM8q5Zg==
X-IronPort-AV: E=Sophos;i="6.25,164,1779148800"; 
   d="scan'208";a="16456235"
Subject: Re: [PATCH] smb: client: set SB_I_NODEV to prevent device node injection
Thread-Topic: [PATCH] smb: client: set SB_I_NODEV to prevent device node injection
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 16:23:11 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:18360]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.40.209:2525] with esmtp (Farcaster)
 id 2ddd0704-72ac-4fbc-a462-6ca2d0064329; Tue, 14 Jul 2026 16:23:10 +0000 (UTC)
X-Farcaster-Flow-ID: 2ddd0704-72ac-4fbc-a462-6ca2d0064329
Received: from EX19EXOEUC001.ant.amazon.com (10.252.51.133) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 14 Jul 2026 16:23:10 +0000
Received: from FR6P281CU001.outbound.protection.outlook.com (10.252.50.44) by
 EX19EXOEUC001.ant.amazon.com (10.252.51.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43
 via Frontend Transport; Tue, 14 Jul 2026 16:23:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ehg6/N+f64djBBoNwLZYbpTu5fe0OfHgpBvYs0/eLHtL9+Z37iKQwn+UluSf0KxmOE7xfhSMxCiQdIasB/Cy0Q2PkrdnbDyttnFbEy0pOHCO5d8Ue0jBTxHPEU2avmgsf/pENbSKZ/Y6hG2mSQWtimQZTLsEkjj/23FpRi8MNz5hZh8h54I7s5vVItDUpyGTtXPRgmLf+ZafEV0ffY/8mh2lkHRX+zAc32dZqZAq6n/1eDp2WsKIotLwdCR9s/o4c24hX8LVw/U0pqw94G8WMNZRAy8QHpSaotNOOTe7EFqYvZBZ/A15WzwrZNnhNAI8jP2bPdIUNtlwsl4n2Miebg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GFiPXbrX2avW+c9IgTJH3VjOLA/WICbUupaNpKFpVGI=;
 b=E8oUy0UUZ1tuBjDTi12xFvPsQJAP1R1Q2G0O8LUGj1LmwW96HbndWVuZ7wI0FRfwVneG7UaTy/MjDX21M0uNu8RDCX6lAtyiVG/aujlm1kXKfGchitkL1FX1/oGIpifBzlpyrJh2nNCfy+YrLc05W4aB9XabmG95RdurLjwluxM02/9kutobaanlBJnU4w0Z/MJYy+N8P4SQhJqcEz8J3WE/WP7Hkwv06hQuGLRo8xuTPyHNwda1y8SJnGzVnYhGseWEN3vXkRI201RnCZMn4yLL05kFaP3ZSu6Z3mb+45glzQZpsT3CUQCQmaC3yRy5kpN1RJIjoJwnbxrvXnObIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.de; dmarc=pass action=none header.from=amazon.de;
 dkim=pass header.d=amazon.de; arc=none
Received: from FR5P281MB5091.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:192::5)
 by BEZP281MB2406.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:5c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.9; Tue, 14 Jul
 2026 16:23:07 +0000
Received: from FR5P281MB5091.DEUP281.PROD.OUTLOOK.COM
 ([fe80::c925:fc90:3cb8:6964]) by FR5P281MB5091.DEUP281.PROD.OUTLOOK.COM
 ([fe80::c925:fc90:3cb8:6964%6]) with mapi id 15.21.0202.018; Tue, 14 Jul 2026
 16:23:07 +0000
From: "Manthey, Norbert" <nmanthey@amazon.de>
To: Steve French <smfrench@gmail.com>, "Doebel, Bjoern" <doebel@amazon.de>
CC: Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg
	<ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, "Tom
 Talpey" <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>, linux-fsdevel
	<linux-fsdevel@vger.kernel.org>
Thread-Index: AQHdD7tTP2bz0NwOh0yZdyax3UPbl7ZlbwiAgAFGY1Q=
Date: Tue, 14 Jul 2026 16:23:07 +0000
Message-ID: <FR5P281MB509177A7DE157E6D72EC05B3CFFD2@FR5P281MB5091.DEUP281.PROD.OUTLOOK.COM>
References: <20260709155440.2132459-3-doebel@amazon.de>
 <CAH2r5msvEGdEJvyV5sWcZjQ0SjMOwXP_Ad4eKN7etHtXS1vwbA@mail.gmail.com>
In-Reply-To: <CAH2r5msvEGdEJvyV5sWcZjQ0SjMOwXP_Ad4eKN7etHtXS1vwbA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amazon.de;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FR5P281MB5091:EE_|BEZP281MB2406:EE_
x-ms-office365-filtering-correlation-id: 8fe29fb8-a3ec-4a4f-ef02-08dee1c43058
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|38070700021|18002099003|22082099003|4143699003|56012099006|11063799006;
x-microsoft-antispam-message-info: 37zJF5LIv+wMQL0/IWFW72zr6iiuFTWAnBhBp9xWc15Uij8v51V5ymN8OIDWWTUq4Kx/eJwiAyLgaoew9fkG1L1CZMxJKAMg3PeY0OcE5u/P8WJr/0DsWmmc5G9QVOKzX3eNKKSqz0zxdaKs1vYbCcgyymgdDtxzbjPv7gOILsgOlgbnjCZiRqsdQemo59XSO+SB/xDXMAa5hlgJI2RM07cFNbx1nZvvhr/wuM0QL0ZYOe1hOf15IE143pysRDcFGNCYVnUugqH9ab+dzOkAQqaDoznIo0VSZuqFgJdMl5oYtg/aLG2w3A7Z+++FbKeVIPjnm+remIboEjwPq5VNIYRzQWaQAHr939JZPbgj+Znhk4zKkSNUsjw/4/C8Jx/XEbGNfVfB7nRtSQhEvIdezNArwGoZ3J72KseFgeRvDTQhy9gX0qogMFXMXPOPz8Md3hDOYN266dh+clGyJBqf/TmQTNJxgYp1962re8Hp3tUy8jM1A2OKT5bJ/MUDqZwJ00wG5lw156Bz4muoBomsMNi/Tr2qHmilrVTB0ccwP6HMwNeD7wT5hxmXJsedu50UN+DDKoBJJPXWTTclVTxYYm/MAkIkTl4f5m16IxNU2gTh3K3TF60EqM2BNM/r0c/R9X8RFEliRVq8CUovByp2pcKVZ9CwdQLhebV652GZ7gTciqJFCxOYGzMcg56IWi43LrJ53qkSUpvGVUzRy3a/P8lwCCuHTppHEMPyYU2qVT8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR5P281MB5091.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(38070700021)(18002099003)(22082099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a3A4MTlBS0xDTE9MUUNDcDVzVG1aS0JlOTFpZFBpRWZFNzVXUnorRGVYWUk4?=
 =?utf-8?B?RTEzaEg2bmhmVzRhdHh6QkxsNGI5SzBTMnB2OW1LcWxvZmlCSWxnT2lYUXM0?=
 =?utf-8?B?U3Nrb0dFc1hGOUZVRzlpNS9YOXNLaVIyZVlIZzUyQk9sSGZiOTgxOGQrSTQz?=
 =?utf-8?B?NW1tNWIvTnRsU1Nod2xKNDRTVElMei9aREdqbVFra1BIZVN0eTBERCszVTEr?=
 =?utf-8?B?bHZTellMOWNUS0twQU1rd2ROZnBMN0s0ZWo1T21aSXRFdGVLTEp5Yms0M2Fz?=
 =?utf-8?B?RVFtd09pZHk3dzRGTjNSQlpraXFjSHMxQU5oNGR6ZEN0ZUxmYjJaK0RDczhQ?=
 =?utf-8?B?QndoR0JJSGFpbmU4djVXMUEyUGpMV29RVHF6a0twdFZKbTV0UVhCRXpHZi85?=
 =?utf-8?B?bDE5aEYrNjZ2SnQweDNhSzJOVmtpeE53dzZzUmpER0M2UmlLZGZKdk02RVhk?=
 =?utf-8?B?aUx4NWMxbzFUM3BGenNEMkl0dFBGYXllT2MxTUl0ek82dkZQMk8wOVlVSWQ3?=
 =?utf-8?B?K2p6V010NlptVUgzUkg0MHpGN1B3UzJ4OFFoeVY4Y1F2aEh5UDE0U1UwV1Mr?=
 =?utf-8?B?cEgxMFZCcEZLWHVIOXJJTlhiRXZvWDlndndCNHpzZU5XRXR3WnV5ZFF1T0E5?=
 =?utf-8?B?SERjRkVzbzMxR2U4dzI1bGgyM3h0ZjVzR3ZsTm12R3NJbHlyZE1QbnNUazFS?=
 =?utf-8?B?NWo4bFYza1JTYTlhcXNFQUYram5XT2dQTmt6TjlFTFF3MStNUXFqRWczb2d2?=
 =?utf-8?B?NEhnbUFUYmFIWU1aRlNrVDlVY01Wbk1VQUJFM2pHaVhnWm80M3Nyc1dSM0lS?=
 =?utf-8?B?TjZZcFJEcDdUdnNCUU9hakEvblpzQVVYUVVBNjZtUUN1WUtWR29vc01SMkFy?=
 =?utf-8?B?NGx3cmZNMzgrTmRDcG5ONmR5eEwyU2tKWkRGK2FreFFzbjBjOWlJR05WZFZ2?=
 =?utf-8?B?c1JqOWRHNEZKWjZWTlpsZ0NGRC9nTTJ3cG9MNExPYzRyQkJsTmNQcjF6dGpU?=
 =?utf-8?B?T0hDTGN2MjlFeXlIR2ZuRFRNRHdlbGVQQWFEYm9VOE45V2dXckxyOEhOSG1T?=
 =?utf-8?B?VTBSNk1iVVc5VjVPc25MS3BEK1FOTDZhSnJGTlNoa21xemVSaUp1QjRIN3Z0?=
 =?utf-8?B?ZzRpTFY5bzhSbStMZENSNk5hTmF3UDhhQnRDOXBuSDZweUtWYkg2bURLZjIw?=
 =?utf-8?B?Y29XNmdXckxwSHYrSEd3NjN5QUtMckVlMlYzSkx2QjUrOFVXdURJNmFUMnpu?=
 =?utf-8?B?NktsUXNjMkZ0OUwycUJIMU1JRlNvZy84RTBocWlRMDU5QWlMOFZzWjdrVTVq?=
 =?utf-8?B?VWxMRCtheFB6UnFybitxcGdKaUMxdFZEUTJ0aDV4UDhuZ0RDcEZOTk5KZHRU?=
 =?utf-8?B?WDdHc3U3V0hxUlRFRlVZRmNLR2s4U05WK25uWE91RkVFS1RvVjlvWkJSejB1?=
 =?utf-8?B?d0FZK25PMUVDZGVuZFJFRXdhQzNKUmNYQXNLYkxFOVRtS3BhTyt3Z095ZGkv?=
 =?utf-8?B?NGRKd1VsQjJWQ1VxeWN4QUoza2JMWkdKQWMwMy9yR09YWFFLdE5TejNlNWdp?=
 =?utf-8?B?b1d0cW9WNjk2bTF2cFdKK0UvcXl0YjFDa1BqRVh1V0h6bTRnNXk0d1lvTk9X?=
 =?utf-8?B?M2ZYbkdaZnZ3ODJoZE9kRThzTFZlVGtnQW16aXBpRnhuNmh2aTZEc09wN21n?=
 =?utf-8?B?OGNqMFBYUFNlQ0JiVFhoemc2eS9xQmRubVRPSnAzcnR5dXhHNFZMTTY2SXYy?=
 =?utf-8?B?RXI5dEZIZGVuZjlEcG9JVk1tZStRNmErLytyVkVWbHRNU2M3TVdMam9YZXYx?=
 =?utf-8?B?QTNuN3hmK2p1UUJOWHhFUzNGZXg3OVA1UnpjSkwzVFZidHFEc3hqd0wzMm9C?=
 =?utf-8?B?L015Z1NaQzAxQXo1cytubHFqalRQKzVpekpUWXA0SWlsMWFGbmdRWVlHSG1R?=
 =?utf-8?B?VlFvWk9uaWVKQjhRZ2orclFseGt2TjlrbEFFaThheDhOdERza0dLNnNqdjZG?=
 =?utf-8?B?SnFQVys3TWNtRDgxYThGMktSSWM0OXUrQVJqdkwyTkhhWTFDTUVPZkZ4dlM1?=
 =?utf-8?B?bkZJdUxKL2tqVGFjdnZHK0QrSUxwUUtwa0krcDVQdnN3eGhLaFZ6V3llQmUr?=
 =?utf-8?B?VnFIUVkvMVF0OFpQR3RnME9OYS9qMHN2RUNxeUJTS3k0UlJwblpEa1VTUVR4?=
 =?utf-8?B?UXdEeFVNVFBrTXFSYmIwV1M0VjlONEVoL1NDM1RrN2c0M2tTWFVjaWpCS0dE?=
 =?utf-8?B?TndVb1p2VDZYSmZIZkhTSkJzRVdZQTkzQWxnNEZ1ckVyNVQ4bVBZVUZZdk8r?=
 =?utf-8?Q?C7Qu0/EzMzwyaD7L5o?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Bj9kw2iIaFS6mQiUEhtbl8QD/7FG9T3jIWupK8zjJQ+v8d2cIbEb/xYER9MueziZlXIn3F+AJxlCIXxJC+RoUpxGMCsKHYAs6+cEfoTS1Cb8MEehx4twU+4JYr+doH0PcOGh2RmNDi3QToIFD6NFVw/9I+Dqti43X6aD3J6WZfBVBcwDz5EdXz8tfw3A1WfPEVVEC0Uv1HMWunTDFOMj5Yto/X0bvJ21dSkusm3ncu72joy9MXDAJVkLefBMw3JxTdAPIIyU/fmc0pdwNps/PEwL7qpeHLns8wwUKT+mZyhy5qzPQwq08X5YuIPzHNLeya7Xbmtq1UhOxH0lPPys9A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FR5P281MB5091.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fe29fb8-a3ec-4a4f-ef02-08dee1c43058
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2026 16:23:07.3927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: epkT3SPXotx/ElJgkcDYmfICVSq4HPMYzKFVe0hArGHWLzb+EnJQD2o6wGw2ory7xjYb98qdAQrXbN618sDsPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BEZP281MB2406
X-OriginatorOrg: amazon.de

SGkgU3RldmUsCgpUaGUgaXNzdWUgaXMgdGhhdCB0aGUgY2xpZW50IHRha2VzIHRoZSBkZXZpY2Ug
bm9kZSdzIG1vZGUgc3RyYWlnaHQKZnJvbSB0aGUgc2VydmVyLiBTbyBhIG1hbGljaW91cy9jb21w
cm9taXNlZCBTTUIgc2VydmVyIGNhbiBkZWZpbmUgYQpkZXZpY2Ugbm9kZSAodHlwZSArIG1ham9y
L21pbm9yICsgcGVybWlzc2lvbnMpIG9uIHRoZSBjbGllbnQgdGhhdCB0aGUKYWRtaW4gbmV2ZXIg
Y3JlYXRlZCBhbmQgY2Fubm90IG90aGVyd2lzZSBjb25zdHJhaW4gLS0gdGhlIG9ubHkga25vYgps
ZWZ0IHRvIGJsb2NrIGl0IGlzIHRoZSAibm9kZXYiIG1vdW50IG9wdGlvbi4gVGhhdCdzIHdoeSB3
ZSBpbnRyb2R1Y2UKdGhlIGNoYW5nZSB1c2luZyBTQl9JX05PREVWIGhlcmUuCgpXZSBkaWQgYW5h
bHl6ZSB0aGUgQ0lGUyBjb2RlLCBhbmQgZm91bmQgdGhpcyBtaXNzaW5nIHNlY3VyaXR5IGNoZWNr
cy4KV2UgaGF2ZSBhIHJlcHJvZHVjZXIgdGhhdCBhbGxvd3MgYSBtYWxpY2lvdXMgc2VydmVyIGFu
ZCBsb2NhbCB1c2VyIHRvCmVsZXZhdGUgcHJpdmlsZWdlcyBieSBpbnRyb2R1Y2luZyBhIG5ldyBk
ZXZpY2UgaW4gdGhlIG1vdW50LgoKQmVzdCwKTm9yYmVydAoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fXwpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdtYWlsLmNv
bT4KU2VudDogVGh1cnNkYXksIEp1bHkgOSwgMjAyNiA3OjIwIFBNClRvOiBEb2ViZWwsIEJqb2Vy
biA8ZG9lYmVsQGFtYXpvbi5kZT4KQ2M6IFBhdWxvIEFsY2FudGFyYSA8cGNAbWFuZ3VlYml0Lm9y
Zz47IFJvbm5pZSBTYWhsYmVyZyA8cm9ubmllc2FobGJlcmdAZ21haWwuY29tPjsgU2h5YW0gUHJh
c2FkIE4gPHNwcmFzYWRAbWljcm9zb2Z0LmNvbT47IFRvbSBUYWxwZXkgPHRvbUB0YWxwZXkuY29t
PjsgQmhhcmF0aCBTTSA8YmhhcmF0aHNtQG1pY3Jvc29mdC5jb20+OyBsaW51eC1jaWZzQHZnZXIu
a2VybmVsLm9yZyA8bGludXgtY2lmc0B2Z2VyLmtlcm5lbC5vcmc+OyBsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnIDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnPjsgc2FtYmEtdGVjaG5p
Y2FsQGxpc3RzLnNhbWJhLm9yZyA8c2FtYmEtdGVjaG5pY2FsQGxpc3RzLnNhbWJhLm9yZz47IHN0
YWJsZUB2Z2VyLmtlcm5lbC5vcmcgPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+OyBNYW50aGV5LCBO
b3JiZXJ0IDxubWFudGhleUBhbWF6b24uZGU+OyBsaW51eC1mc2RldmVsIDxsaW51eC1mc2RldmVs
QHZnZXIua2VybmVsLm9yZz4KU3ViamVjdDogUkU6IFtFWFRFUk5BTF0gW1BBVENIXSBzbWI6IGNs
aWVudDogc2V0IFNCX0lfTk9ERVYgdG8gcHJldmVudCBkZXZpY2Ugbm9kZSBpbmplY3Rpb24KwqAK
Q0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZyb20gb3V0c2lkZSBvZiB0aGUgb3JnYW5p
emF0aW9uLiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZS4KCgoK
U2V0dGluZyBTQl9JX05PREVWIGlzIGFwcGFyZW50bHkgbm90IGRvbmUgZm9yIGFueSByZW1vdGUg
ZmlsZXN5c3RlbXMsCmFuZCBBSSBzZWFyY2ggY29uZmlybWVkIHRoYXQgaXQgcHJvYmFibHkgaXNu
J3QgYSBnb29kIGlkZWEgdG8gc2V0IGl0CmZvciByZW1vdGUgZnMuwqAgSXQgaXMgbW9yZSBvZiBh
IHRoaW5nIGluIHBzZXVkb2ZpbGVzeXN0ZW1zIGFuZCBub3QKbmVlZGVkIGZvciBuZXR3b3JrIGZp
bGVzeXN0ZW1zLgoKZS5nLgoKIklzIHRoZXJlIGFueSBiZW5lZml0IHRvIHNldHRpbmcgU0JfSV9O
T0RFVj8KClRvZGF5LCBwcm9iYWJseSBub3QuSWYgeW91IGdyZXAgdGhlIGtlcm5lbCwgeW91J2xs
IGZpbmQgU0JfSV9OT0RFViBpcwp1c2VkIGluIG9ubHkgYSBoYW5kZnVsIG9mIHBsYWNlcywgYW5k
IHRob3NlIHBsYWNlcyBnZW5lcmFsbHkgaW52b2x2ZQpwc2V1ZG8tZmlsZXN5c3RlbXMgb3IgaW50
ZXJuYWwgVkZTIGFzc3VtcHRpb25zIHJhdGhlciB0aGFuIHJlbW90ZQpzdG9yYWdlLsKgIFNldHRp
bmcgaXQgb24gQ0lGUyBvciBORlMgaXMgdW5saWtlbHkgdG8gY2hhbmdlIGJlaGF2aW9yLApiZWNh
dXNlIHRob3NlIGZpbGVzeXN0ZW1zIGhhdmUgd29ya2VkIGNvcnJlY3RseSBmb3IgZGVjYWRlcyB3
aXRob3V0Cml0LiBNb3N0IHJlbW90ZSBmaWxlc3lzdGVtcyBkb24ndCBzZXQgc19pZmxhZ3MgYmVj
YXVzZSBhbG1vc3Qgbm9uZSBvZgp0aGUgU0JfSV8qIGZsYWdzIGFyZSBpbnRlbmRlZCBhcyBnZW5l
cmljIGZpbGVzeXN0ZW0gY2FwYWJpbGl0eSBmbGFncy4KVGhleSdyZSBtb3N0bHkgaW50ZXJuYWwg
VkZTIHN0YXRlLCBhbmQgU0JfSV9OT0RFViBpbiBwYXJ0aWN1bGFyIGhhcyBhCnZlcnkgc3BlY2lm
aWMgcHVycG9zZS7CoCBTQl9JX05PREVWIGRvZXMgbm90IG1lYW4gInRoaXMgZmlsZXN5c3RlbQpj
b250YWlucyBubyBkZXZpY2Ugbm9kZXMuIiBJdCBtZWFucyBzb21ldGhpbmcgY2xvc2VyIHRvOsKg
IFRoaXMKc3VwZXJibG9jayBpcyBub3QgYXNzb2NpYXRlZCB3aXRoIGEgYmxvY2sgZGV2aWNlLgpv
ciBtb3JlIHByZWNpc2VseTogVGhlIFZGUyBzaG91bGQgbm90IGV4cGVjdCBhIGJhY2tpbmcgc3Ry
dWN0CmJsb2NrX2RldmljZSBmb3IgdGhpcyBzdXBlcmJsb2NrLiIKCkhhcyBzb21ldGhpbmcgY2hh
bmdlZD/CoCBIb3cgZGlkIHRoaXMgcXVlc3Rpb24gYWJvdXQgU0JfSV9OT0RFViBjb21lIHVwPwoK
T24gVGh1LCBKdWwgOSwgMjAyNiBhdCAxMTowNeKAr0FNIEJqb2VybiBEb2ViZWwgPGRvZWJlbEBh
bWF6b24uZGU+IHdyb3RlOgo+Cj4gRnJvbTogTm9yYmVydCBNYW50aGV5IDxubWFudGhleUBhbWF6
b24uZGU+Cj4KPiBTZXQgU0JfSV9OT0RFViBvbiB0aGUgc3VwZXJibG9jayBieSBkZWZhdWx0IGZv
ciBDSUZTIG1vdW50cy4gVGhpcyBpcwo+IGNvbnNpc3RlbnQgd2l0aCBob3cgb3RoZXIgZmlsZXN5
c3RlbXMgaGFuZGxlIHVudHJ1c3RlZCByZW1vdGUgY29udGVudAo+IGFuZCBwcmV2ZW50cyB0aGUg
c2VydmVyIHNpZGUgZnJvbSBpbmplY3RpbmcgZGV2aWNlIG5vZGVzIG9uIHRoZSBjbGllbnQuCj4K
PiBGaXhlczogMmU0NTY0YjMxYjY0NSAoInNtYjM6IGFkZCBzdXBwb3J0IGZvciBzdGF0IG9mIFdT
TCByZXBhcnNlIHBvaW50cyBmb3Igc3BlY2lhbCBmaWxlIHR5cGVzIikKPiBTaWduZWQtb2ZmLWJ5
OiBOb3JiZXJ0IE1hbnRoZXkgPG5tYW50aGV5QGFtYXpvbi5kZT4KPiBBc3Npc3RlZC1ieTogS2ly
bzpjbGF1ZGUtb3B1cy00LjYKPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZwo+IC0tLQo+wqAg
ZnMvc21iL2NsaWVudC9jaWZzZnMuYyB8IDMgKysrCj7CoCAxIGZpbGUgY2hhbmdlZCwgMyBpbnNl
cnRpb25zKCspCj4KPiBkaWZmIC0tZ2l0IGEvZnMvc21iL2NsaWVudC9jaWZzZnMuYyBiL2ZzL3Nt
Yi9jbGllbnQvY2lmc2ZzLmMKPiBpbmRleCBlYTRmYzBmYTY4Y2FjLi4zNWVlZTJmOTg5OWQ1IDEw
MDY0NAo+IC0tLSBhL2ZzL3NtYi9jbGllbnQvY2lmc2ZzLmMKPiArKysgYi9mcy9zbWIvY2xpZW50
L2NpZnNmcy5jCj4gQEAgLTIwOCw2ICsyMDgsOSBAQCBjaWZzX3JlYWRfc3VwZXIoc3RydWN0IHN1
cGVyX2Jsb2NrICpzYikKPsKgwqDCoMKgwqDCoMKgwqAgaWYgKHNiZmxhZ3MgJiBDSUZTX01PVU5U
X1BPU0lYQUNMKQo+wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2ItPnNfZmxhZ3Mg
fD0gU0JfUE9TSVhBQ0w7Cj4KPiArwqDCoMKgwqDCoMKgIC8qIFByZXZlbnQgZGV2aWNlIG5vZGUg
b3BlbnMgZnJvbSByZW1vdGUgZmlsZXN5c3RlbSBieSBkZWZhdWx0ICovCj4gK8KgwqDCoMKgwqDC
oCBzYi0+c19pZmxhZ3MgfD0gU0JfSV9OT0RFVjsKPiArCj7CoMKgwqDCoMKgwqDCoMKgIGlmICh0
Y29uLT5zbmFwc2hvdF90aW1lKQo+wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc2It
PnNfZmxhZ3MgfD0gU0JfUkRPTkxZOwo+Cj4gLS0KPiAyLjUwLjEKPgo+CgoKLS0KVGhhbmtzLAoK
U3RldmU=
