Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11021095.outbound.protection.outlook.com [52.101.62.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A511DF991
	for <linux-cifs@vger.kernel.org>; Thu, 10 Apr 2025 11:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744283239; cv=fail; b=HbGJ03R9wRY9GbtJmBygPuhslTjpLZUusJ2uwjsPoyomixnmJcJaEXn1guqklsTGOaVTiSD9ye/Kenh/pmpt1zm4iN5FB10J6HsPmYk/satHmohQ6SLOcozVdg6EiirIFhDcILGQSgpn6oPiga5lgN4bdE7wpvXk9IxRLE3W138=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744283239; c=relaxed/simple;
	bh=Tn3qL0jtCTcJwQUXnKW4n/4WMLejJ1zmiNvaVHwYSp8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ukwaiTSxB5X8t5ceZWBcdxyoz+MfFWElIRrHXfBJqiyqG66xxGsqJBvTYDy+djjjXEnk7MECthUOgm4DxnlVnjJwS7lOUID6thCgV3m0loS3q0jbnPtvUrG2O2l5w7AMtO+tLhsuA+3/nAx5cEIe41vRNlElu+TiADmSzNoIHjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=gA3MxOvf; arc=fail smtp.client-ip=52.101.62.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="gA3MxOvf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bMEFPvN9L8e+z5T69P83a4SSUzBoqsbifaeMigfzbu8XYSglF4HK5ZEbBPdHNqin3I1kOgtRq4VckHEPNwNKEZwTeyPsw/HkH+V2Yxwf4dom1ZNxdYwuLSn7Qr4G0bqMgSM20U8CUsuYJ9/C8QLfcNX2HwgczDIgRdQXHuZGfcpLjfHn9CNGdVI+q3AHGzgtnslHeM9dtHmUrpuTJL5hpuXjgiHx2AwFd+sa0ZcX4X7/D2Nu8ehmnIc6Ll1NSMb5ZFQ+L2RxqvQu7175RzxLan4sCumxpMHVI5Owu2VIC4oitzIHvGsJxuGHwjG45qo9JaFqFHAXuUhLTbZ1mBPz5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tn3qL0jtCTcJwQUXnKW4n/4WMLejJ1zmiNvaVHwYSp8=;
 b=Lkdtx4AJBaQWIS6IRE5yy/LqqCJEVle4M4zoMCVEUBfLb+P9WeHzZjyt4irLk30l6H2pW7JIz5mJjuMLKf7J4nmbR5bARIfkJLD/CiBVuJixeK4fO1g7mZV/nAfBgZWKIkBRarwbGt32PoQsAfBqx+54T1VS1aCRrxSEbfym/gnYWziymUXAZQabqI8NwLvbao37k0tQWsnH7JWhpggUHDhTIc62gX5k642tH6s0qTpAq+G9Oo2GdZusYMYhi3gx9aJp50OG5XvEyGwZuDDaKlRGi9njlXAwUHHDjzbC2VpZm/BUDJG3EhrE7vImI52KjCjZ+Yk3POLBiU0utAOIlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tn3qL0jtCTcJwQUXnKW4n/4WMLejJ1zmiNvaVHwYSp8=;
 b=gA3MxOvfyoWA8nL2IEY7qZCwo0iPdRKL47euHa8uAZYzZwXiMM6c3++Ors49qi8lM28dLjaChjBCdY8ehZ4gFBQD6ccI2czCPNEt6VU3gopjzzA26l3PqJB7ngY1MRc4rtJsbhPt4cRDchRzK1RwdOTfi+ANHapdAzvkCFfKwR4=
Received: from LV2PR21MB3157.namprd21.prod.outlook.com (2603:10b6:408:175::15)
 by LV3PR21MB4224.namprd21.prod.outlook.com (2603:10b6:408:275::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.11; Thu, 10 Apr
 2025 11:07:14 +0000
Received: from LV2PR21MB3157.namprd21.prod.outlook.com
 ([fe80::d2c9:dd57:a941:892b]) by LV2PR21MB3157.namprd21.prod.outlook.com
 ([fe80::d2c9:dd57:a941:892b%4]) with mapi id 15.20.8655.011; Thu, 10 Apr 2025
 11:07:14 +0000
From: Obaid Farooqi <obaidf@microsoft.com>
To: Ralph Boehme <slow@samba.org>
CC: smfrench <smfrench@gmail.com>, tom <tom@talpey.com>,
	=?iso-8859-1?Q?Pali_Roh=E1r?= <pali@kernel.org>, CIFS
	<linux-cifs@vger.kernel.org>, Microsoft Support <supportmail@microsoft.com>
Subject: RE: [EXTERNAL] Fwd: SMB2 DELETE vs UNLINK -
 TrackingID#2504090040009564
Thread-Topic: [EXTERNAL] Fwd: SMB2 DELETE vs UNLINK -
 TrackingID#2504090040009564
Thread-Index: AQHbqWgWsRQPRENabkua8fA464e5AbOcvjOw
Date: Thu, 10 Apr 2025 11:07:13 +0000
Message-ID:
 <LV2PR21MB31576391E902DD819ADE3A5AC6B72@LV2PR21MB3157.namprd21.prod.outlook.com>
References: <20250408224309.kscufcpvgiedx27v@pali>
 <6f5031e9-36d4-4521-a07a-6892cc5ce8a3@samba.org>
 <MWHPR21MB45241411805698FB51F0F4F294B42@MWHPR21MB4524.namprd21.prod.outlook.com>
In-Reply-To:
 <MWHPR21MB45241411805698FB51F0F4F294B42@MWHPR21MB4524.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=e0f4e4df-0c76-4b14-9017-4b36a34561c4;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2025-04-09T15:55:35Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Tag=10,
 3, 0, 1;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR21MB3157:EE_|LV3PR21MB4224:EE_
x-ms-office365-filtering-correlation-id: a5db45d7-75c6-4032-9805-08dd781fd941
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|10070799003|38070700018|13003099007;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?b3aYjIwHh4jQ0hAFHniakCT8wKIToCh4iw/h6W1oz41jYuuTqE7a7xi2x2?=
 =?iso-8859-1?Q?yHJk/wo+5/u7kqhi+URGPHTzTYEtodKSprS//i7Ean11nBMrGg9Y3PjR5A?=
 =?iso-8859-1?Q?5R6Mmq8NWS/O97oRHF0dkKtWIeDgY7se7KlsUGSCXLT1+WFAWk9OuIRvhh?=
 =?iso-8859-1?Q?BXyuI9taAQtB6QJCr3J4waPK3Jl4JsQ2405SGkgJg4adwMxZWQghDo/GNo?=
 =?iso-8859-1?Q?0BecDYX61fN1+gNiz+ZOKh5L8FflbpRioJIoWjlx2VB537NeEsBG7yi+T9?=
 =?iso-8859-1?Q?WcbhuS9Ll9/jXAj6eE3KzC2MdG3K3WxAMhUtgEVdPRxXDKVutYxv7gReEz?=
 =?iso-8859-1?Q?Kjbt/A8VcjThH8Qy8X2CxuYp/BPCQYSOQ976oy4MIVJqlAqvhlNE6+upfW?=
 =?iso-8859-1?Q?f1dUrkuwA6SVd62M9XEQy1NB/mnv3KDj2aGF1OFHyAU/6tHg+KzPORvkoP?=
 =?iso-8859-1?Q?3WWGqfu0LnyW2ki8pM/17tw8Z8pPWzbG63BuenageZYkdtogL0UOjewO6U?=
 =?iso-8859-1?Q?tc/cv5hZdSlSzoJTCWUHqLR/iZLxu8nGAGkxUwfw1hvVSMBBerA9Z0C2Fk?=
 =?iso-8859-1?Q?YV8DWev7WlRAKFdVa1imnnYwNPLr38ui8nBMZ8/MttRTc8mzKJR4XBlW5F?=
 =?iso-8859-1?Q?dfD3oiiGZmLz405lVkD6RRJ7SlZYUR5cJ4xBctIQsxyQ4HTwOUxF7NF6uf?=
 =?iso-8859-1?Q?K6PGOA7+4CMCXxXV7sjLRaKlkwipZC1jt8p969BhHiC+LtJruc0os7cbl2?=
 =?iso-8859-1?Q?kDiZwjfDOWoGz/pSiniUKSx+0TVuGD+j+Gd9LZ1b49S/OT7C6t1s+5p9BJ?=
 =?iso-8859-1?Q?V9qMY/CiYuwl9TLjbkWwXzLcYQ4mc4FIpJ0n2OUaT587Qn1slTLnGGdpxP?=
 =?iso-8859-1?Q?y237XD8zqskCpzf+2bR+t4UESTXivjo4pbh5QSIkdAYTkX5sIygZ6mWKpj?=
 =?iso-8859-1?Q?3V3Nv3zK6/pCw0H4qS3i0LgMiIyiJPGhL/4RnW88S+PPk/O6hpsAPILwsh?=
 =?iso-8859-1?Q?iYem/o00VtVjEO+6nBId9j8zxsAlT4HNevWZEk57nrDS9oa2fg5Y4yGW3v?=
 =?iso-8859-1?Q?i6VAp+5D6l/furbVTZu7MUYX13rdo/Eqtjvk0oElabipfnFFkwSKm0SBPb?=
 =?iso-8859-1?Q?2tqcGBbWpClbvRrXx2LqSfqSYeSqaHnTejEVtW8sJ/HHuyZF8XOBhJtO7d?=
 =?iso-8859-1?Q?UI65tMiw4XB+QWpQRoDn/6M7EHeqGkpacWwLJr75IwidqIbVRhVAIWB+jU?=
 =?iso-8859-1?Q?RFhtRnPB53T2AgAGhDCBq1Z9aXUXHOXlvUosy9EI1duKRgPycdxs05S146?=
 =?iso-8859-1?Q?3PATSMfb4KPT0GqhwHyVRadjNPpD14Jvt7+7C6CenkGiG+2oh2zTinnU85?=
 =?iso-8859-1?Q?4Xkas3MhUPokcR1OXzHoZJcn4BbTv+P2fVrrJNZDcVNEHc1Vazsv8xtQvO?=
 =?iso-8859-1?Q?2BxN62DHK53MEUqe5gETunJn464L0vmxG9+ywI0wOfkJv82UcvXE99Autw?=
 =?iso-8859-1?Q?A=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR21MB3157.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(10070799003)(38070700018)(13003099007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?70MK1kt+Bg0NV2AJvhmIUXlSp9vfhRSVDAqBU7Dn8StjVM5nnPd8dFCDFT?=
 =?iso-8859-1?Q?R+6FFVxm14cuqoDGkf66TqvNrceskMqiGZBppoGhucQFLQ2U8Kbmlv0Fr9?=
 =?iso-8859-1?Q?dbGGfMDvM2HO54cxkOYeSBmKAnyFw2Jk5hzaUg/Qqqy0zXbAaB0mKqMlYn?=
 =?iso-8859-1?Q?ywDzK2ySwPzr1kATOf0fz/HT15NnOI3sTcSSMyaTbKhKXuaD71sX3febD7?=
 =?iso-8859-1?Q?iNOuttFMR2VgruFA3sYdWX9TgYev2Fs48XMzaBgAXiDmvuBaks3I3AFxNB?=
 =?iso-8859-1?Q?3tRSNKVYPwn8LHxMnJxqezuKt97425oGR68Rk9yUB75Cg6VdBzBohKIe3Y?=
 =?iso-8859-1?Q?xhU9OIYl5b+stgX9Lb5kxie10JZ7AYePIm+YQWaJnMKhsBVEXgxY9KAATl?=
 =?iso-8859-1?Q?eR8e+8uSma6P46bUmiTTo2rDqZPxR9+5TfNWgfq/ZuPmHyHaCDbfbKEKzr?=
 =?iso-8859-1?Q?A8rcgUjW+tj/VV2x7LqNzkr3GsH69CfShMqkL8UYNIrQOA519x8gVln6+1?=
 =?iso-8859-1?Q?DQedw8BOlGEqtpa4UfghkkvAS1GtMuS8oxxcNlUfNOG7y+AIIBt4qgpSvN?=
 =?iso-8859-1?Q?Dnm+D+eyWOca3jHxCYnLXUmiAvhyHVmonfGUSqYwT0LsenDX+PeAMLmaDu?=
 =?iso-8859-1?Q?EoyNYH0xCAOE1PJ1Gt9YpbrJvdjQZqasbeUn2fuwduA2YR2RrMmXQiNx2d?=
 =?iso-8859-1?Q?frE4oVF2qbkmq51TETj9huq8kuKlvJ2eTB4u1bKdSWPF3adbTTCQEBIEkN?=
 =?iso-8859-1?Q?JgRJO8RHxlhds557qB/3toQ+RDRbaboaJhms52T0lH1rWEZwTmzD0ibXS+?=
 =?iso-8859-1?Q?R042xrG9a1FvZzspASKhLXEt3dLvpK8DwjfaM6JDeoCLtdTYTIXfbvg7d1?=
 =?iso-8859-1?Q?BqtRFZVBWkYPek+z9SofZS6ONHDNCf1wllaOKL2yY4Wo5aBzbt0LuBR/jp?=
 =?iso-8859-1?Q?YOjW7Rzup5DOjZrACkuDopDC3+cWt/8GDTMkcEdBlRu0xxAmAQxlRH0/pU?=
 =?iso-8859-1?Q?Dzvs7pzgYvEImkQQvO5j5l9TVgxLYwWlvxhMcUSjKLpV7QwnB7dcKWt/R6?=
 =?iso-8859-1?Q?AE5wxrQUwdzL6HIOFuOcxoe88G99TB2yUQsVJZ1f23btbyk+IjgoDPv8TK?=
 =?iso-8859-1?Q?mgfB+LyTFQ/f2vh3J701HpuzNAJq834ZAjcJVX7ihVkP+lat3RrpDI0DIx?=
 =?iso-8859-1?Q?mZ5rPDltiGItkcr5FAOvwde2q/Eba2jsuBluIB2eHriY7aANzbAwQ0BU1K?=
 =?iso-8859-1?Q?Ku+/tXZ/SKO8ah4b0qANO6yeFU1KR4PUVFtPEA/0o/lUm7AEH9V4TZE2DL?=
 =?iso-8859-1?Q?Le4iQ+NQnELwEJGJlamRaQkNPp3EypZwcoM/em3kJjsvbcv3chjjepgonJ?=
 =?iso-8859-1?Q?mv9ECgYA4N08CnodamaQVRj6KsC1pmr5Bw64xQUGImWLVUkwXUElB3lgth?=
 =?iso-8859-1?Q?2wdt7PAkYHtPOWRliY0aRm/B/BHFPEwNkklv+d/o1zRGH3EyMSb8dl7x0y?=
 =?iso-8859-1?Q?UokkHMfsIvMzeSYWMGzffyKIWrBM8YJSyyTk747Kawfys8mSCZ48uKN5NU?=
 =?iso-8859-1?Q?r7o1e+HgfUnAhzJJ7bIDeFh1fLIEWeXZssV4olBzE1Dn//5QB6GHANhwBf?=
 =?iso-8859-1?Q?SuT7EaOBZ8qXMJVoBPinenMy9tWS3xkqTiFh2/mjT1MvjdqnqckIJNFbH/?=
 =?iso-8859-1?Q?IDUW1yuraDr+vegjI5dLZLAeYN14fUkIauNH7+hm?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR21MB3157.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5db45d7-75c6-4032-9805-08dd781fd941
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2025 11:07:14.0189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4XcXIHwkxBns/ww2uz86sKdYROz0NLWEQ/Huq1coHv6Ml/sIzGCm/H+bNvESmqd+RlCcquEuyQCISBzcnSI3wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR21MB4224

Hi Ralph, Tom:
I'll help you with this issue and will be in touch as soon as I have an ans=
wer.

Regards,
Obaid Farooqi
Escalation Engineer | Microsoft
-----Original Message-----
From: Michael Bowen <Mike.Bowen@microsoft.com>
Sent: Wednesday, April 9, 2025 8:57 PM
To: Ralph Boehme <slow@samba.org>
Cc: smfrench <smfrench@gmail.com>; tom <tom@talpey.com>; Pali Roh=E1r <pali=
@kernel.org>; CIFS <linux-cifs@vger.kernel.org>; Microsoft Support <support=
mail@microsoft.com>
Subject: RE: [EXTERNAL] Fwd: SMB2 DELETE vs UNLINK - TrackingID#25040900400=
09564

[DocHelp to bcc]

Hi Ralph,

Thanks for your question about SMB2. We've created case number 250409004000=
9564 to track this issue. One of our engineers will contact you soon.

Best regards,
Michael Bowen
Microsoft Open Specifications Support

-----Original Message-----
From: Ralph Boehme <slow@samba.org>
Sent: Tuesday, April 8, 2025 11:51 PM
To: Interoperability Documentation Help <dochelp@microsoft.com>
Cc: smfrench <smfrench@gmail.com>; tom <tom@talpey.com>; Pali Roh=E1r <pali=
@kernel.org>; CIFS <linux-cifs@vger.kernel.org>
Subject: [EXTERNAL] Fwd: SMB2 DELETE vs UNLINK

Hello dochelp,

it seems the updates for POSIX unlink and rename made it into MS-FSCC

<https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/f1f8=
8b22-15c6-4081-a899-788511ae2ed9>

but I don't see accompanying updates to MS-FSA and, if supported over SMB, =
MS-SMB2.

Is this coming? If this is supported over SMB by Windows it is not sufficie=
nt to have it burried in MS-FSCC. :)

Thanks!
-slow

-------- Forwarded Message --------
Subject: Re: SMB2 DELETE vs UNLINK
Date: Wed, 9 Apr 2025 00:43:09 +0200
From: Pali Roh=E1r <pali@kernel.org>
To: linux-cifs@vger.kernel.org
CC: Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>, Paulo Al=
cantara <pc@manguebit.com>, Namjae Jeon <linkinjeon@kernel.org>, Ralph Boeh=
me <slow@samba.org>

On Friday 27 December 2024 19:51:30 Pali Roh=E1r wrote:
> On Friday 27 December 2024 11:43:58 Tom Talpey wrote:
> > On 12/27/2024 11:32 AM, Pali Roh=E1r wrote:
> > > On Friday 27 December 2024 11:21:49 Tom Talpey wrote:
> > > > Feel free to raise the issue yourself! Simply email "dochelp@micros=
oft.com".
> > > > Send as much supporting evidence as you have gathered.
> > > >
> > > > Tom.
> > >
> > > Ok. I can do it. Should I include somebody else into copy?
> >
> > Sure, you may include me, tell them I sent you. :)
> >
> > Tom.
> >
>
> Just note for others that I have already sent email to dochelp.

Hello, I have good news!

dochelp on 04/07/2025 updated MS-FSCC documentation and now it contains the=
 structures to issue the POSIX UNLINK and RENAME operations.

https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/f1f88=
b22-15c6-4081-a899-788511ae2ed9
MS-FSCC 7 Change Tracking

https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/2e860=
264-018a-47b3-8555-565a13b35a45
MS-FSCC 2.4.12 FileDispositionInformationEx has FILE_DISPOSITION_POSIX_SEMA=
NTICS

https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/42175=
51b-d2c0-42cb-9dc1-69a716cf6d0c
MS-FSCC 2.4.43 FileRenameInformationEx has FILE_RENAME_REPLACE_IF_EXISTS
+ FILE_RENAME_POSIX_SEMANTICS

https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/ebc7e=
6e5-4650-4e54-b17c-cf60f6fbeeaa
MS-FSCC 2.5.1 FileFsAttributeInformation has FILE_SUPPORTS_POSIX_UNLINK_REN=
AME

So now both classic Windows DELETE and POSIX UNLINK is available and docume=
nted.
