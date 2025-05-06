Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11020126.outbound.protection.outlook.com [52.101.51.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A461547C9
	for <linux-cifs@vger.kernel.org>; Tue,  6 May 2025 19:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.51.126
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746558023; cv=fail; b=Fh8gDY0JauOVzJIcTPCpKoXPbkMI2CSHrKpwrVPcDJaq7tpe8a/9zjSpy6HRahXq/IW59Bo6bVpXcBCa5e/Mq0vxUuVGq07QgMsw25Wa24RK6ipELlPL4iD4Lzc5AYwIq42DeqS83Rx7bmK4iHGRe2/EWZUUVPVm08/hPY4TmmQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746558023; c=relaxed/simple;
	bh=X2HlTKghqTYVZl9rEkT9VLIeer/PhQ49mQDKdWGhgxE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E0yeIU+NoGEYqH34e0TvIkpHCNycD3W6lPIc9/ZDYN3w4IRJMUAroIH1ppX2j/IpBmwdgQLvy8+/mptS3sPRImtPQ9Y/YsXLuU2TlIUbUmcgDupSGGq2PlDnT4IAtDRmH9CSxhANsBW01PPk8iFR3scHqXvHNZXMgmvcxXtvCzE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=Tle24979; arc=fail smtp.client-ip=52.101.51.126
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="Tle24979"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a+6fSfnu2DT3MGuWl9zPeHqqQi+NVnnIZZvKQYT3e0RojK5g876bd/pfMZpDpUV051ctJxKI/ppbQYeV1YwfSG1MQgQxRlH7fA8gUzS5hYSZ2u4V22HveACDOuo7OTxwWwZD1W1vqfjoP/c7yhWrTLN0vRqehttHEubJtxminB8hDxoEna3hJEcQ9OzVqZ8S/abu1cywLFIW4cRT2ENajv6Fj/fg6u3FiBB1AY7vbrY5OZgo7yF9YTanoF1NPbU07Mm07L3dCB1JDF04kDv2oEo/WjefNFSYCKKkPKGK+zjkyeAQTeJTaUi93rsllza5dvSd60y7OOskIBTZOqG+pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X2HlTKghqTYVZl9rEkT9VLIeer/PhQ49mQDKdWGhgxE=;
 b=dsZc8VEic5iWAEfrm/FDyjNGuv+ar0N68A1CoavW/AYGUiEX+fvaXoJBkH5orv9KWOY+LEUVa7O1xkCxWJa134IrsYBhdUZVmPOlzO8MBa/nrBph/Dm9y90FEWYs9Y7fnwrd65PImPGr3wXfkdh503ZSYNkImr4GE/6GfLltAKZRWDtOoLXNd0sYy7agAT0aaKjolYnENA2QgM95DhlUm5YSPZbXEMWrBnv63O5opog3nunaUSpJVo0X9JJFVM/dpB3Fj9UakaFt2X6wGoOx//YFYrhHk5fpl5hfyU1pCWAsvCYUUneUcg4XVCQjrrVb79yD7GMGMchqRd1dfvnvMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X2HlTKghqTYVZl9rEkT9VLIeer/PhQ49mQDKdWGhgxE=;
 b=Tle249796a8dnLaHmokYqAtuH6rlj//p0uVR8cZZhz1cNOHALZKJNnVOmWKmhWeRdppBo56la96Hev7mYWS9xY5NAF0fXUaUu5vNtiIco2QFuQMwwN+1gNyac/sVvhRTzev+OCByw8D0sjHc/0exl4i1ZxI73wHjuVdg1Jh68Ms=
Received: from LV2PR21MB3157.namprd21.prod.outlook.com (2603:10b6:408:175::15)
 by BN2PEPF00004D3A.namprd21.prod.outlook.com (2603:10b6:40f:fc02::245) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.10; Tue, 6 May
 2025 19:00:17 +0000
Received: from LV2PR21MB3157.namprd21.prod.outlook.com
 ([fe80::d2c9:dd57:a941:892b]) by LV2PR21MB3157.namprd21.prod.outlook.com
 ([fe80::d2c9:dd57:a941:892b%4]) with mapi id 15.20.8722.009; Tue, 6 May 2025
 19:00:17 +0000
From: Obaid Farooqi <obaidf@microsoft.com>
To: Ralph Boehme <slow@samba.org>
CC: smfrench <smfrench@gmail.com>, tom <tom@talpey.com>,
	=?iso-8859-1?Q?Pali_Roh=E1r?= <pali@kernel.org>, CIFS
	<linux-cifs@vger.kernel.org>, Microsoft Support <supportmail@microsoft.com>
Subject: RE: [EXTERNAL] Fwd: SMB2 DELETE vs UNLINK -
 TrackingID#2504090040009564
Thread-Topic: [EXTERNAL] Fwd: SMB2 DELETE vs UNLINK -
 TrackingID#2504090040009564
Thread-Index: AQHbqWgWsRQPRENabkua8fA464e5AbOcvjOwgAaMRpA=
Date: Tue, 6 May 2025 19:00:17 +0000
Message-ID:
 <LV2PR21MB315742A5FFB78BC2889E138AC689A@LV2PR21MB3157.namprd21.prod.outlook.com>
References: <20250408224309.kscufcpvgiedx27v@pali>
 <6f5031e9-36d4-4521-a07a-6892cc5ce8a3@samba.org>
 <MWHPR21MB45241411805698FB51F0F4F294B42@MWHPR21MB4524.namprd21.prod.outlook.com>
 <LV2PR21MB31576391E902DD819ADE3A5AC6B72@LV2PR21MB3157.namprd21.prod.outlook.com>
In-Reply-To:
 <LV2PR21MB31576391E902DD819ADE3A5AC6B72@LV2PR21MB3157.namprd21.prod.outlook.com>
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
x-ms-traffictypediagnostic: LV2PR21MB3157:EE_|BN2PEPF00004D3A:EE_
x-ms-office365-filtering-correlation-id: 91e099c1-ea9a-44d1-0b4d-08dd8cd03d98
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|10070799003|13003099007|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?M5AqCf7t6vkN/Qm1OhliFzZNbBlcDQI8P2DOHny9hG9YWlKnu54dJJnd7k?=
 =?iso-8859-1?Q?/YxYTaRylCYFW1N8JxVfHlfeNSYsDm5uvvOFBBEkdXSunNV2tYsdQiQG2F?=
 =?iso-8859-1?Q?o5prBzcbDVeW1PtZ0fLErTJtrdheUnrFRUNyijAxulhjxwsoO1W5A/xuYg?=
 =?iso-8859-1?Q?wzKoOOdx3vaQlUH2UGWp7wS0iTVvzZAVWg34ZSTpK4s4/OwoIKKX68BHoM?=
 =?iso-8859-1?Q?zDLp+xGoYnb7J81XCAiQbmh7nwXbxcsvYznNlp8zxTBHuxfyrRQD9s7IGI?=
 =?iso-8859-1?Q?tayWKR0c6y5uAYMqN3k5VTtYV8n7w7LT4mNKHJt4JXuxRXhqFIQsoI1+25?=
 =?iso-8859-1?Q?tMQ/UTj6hPztllWIrMnsj9gDbBHhHbAGOAiFLksE8q9kGZOk1UvtIbi98v?=
 =?iso-8859-1?Q?9p24R+XVQGy0VBfUng5H80ax9vS42w5QnksSoFeDRVRyAu5lP/0JjVrGm5?=
 =?iso-8859-1?Q?E/qlqxcWUkIiUi3pHklVPPHXkrvYPMaroY4afMMmiqE20bdI4ddcV6gRf+?=
 =?iso-8859-1?Q?YQ8ST4Ibrg2kqBmZwritDPt+SjPuWX6K6QgD0+HpTCpRMB9sp/x5ga9wPW?=
 =?iso-8859-1?Q?nKkzQ9pyRKcF3sClrAMG6NC/NN2x+mFiCBsuoTvUI7whQyoT9O7to/YV7x?=
 =?iso-8859-1?Q?9DN43AiHSRjS0DA2wy3sAoRg38gzo3Zs78kOyrBQAZkX7TpiFqp4zexdnY?=
 =?iso-8859-1?Q?YDtTbLpCO8t2Q81t63he/T4gSMdX5S/3kJ3Nw5hIiVL65JobCPSW1b8To1?=
 =?iso-8859-1?Q?d/i9rzuoqK3lUUg0rtQJSZpy9MO4GtJDbchB1CzaiUIDT51Nv1iGLWiAs8?=
 =?iso-8859-1?Q?2Uv/w7F2dVKOMlJzty3qb3IAofDpJNBCOPfk6waAfY3+YXFt/0k5guZwQ4?=
 =?iso-8859-1?Q?nSl2dZ0lYyj7tI7vFg2VKBBhj4KBty4RtKmzTyEZHfUcEgnanfTQpOpkV8?=
 =?iso-8859-1?Q?kVShcTAb1+y87IPa9vkIFUptLMQEbBu8ET7h/2m/hDb8Pu2rnNO4DVhneM?=
 =?iso-8859-1?Q?fmaclqs4Kbei7d9vcX2OR1m2hq/3ZLHsevzuO+ELrzJHCtJE96c8wboURe?=
 =?iso-8859-1?Q?hGlFAAL4JKxBQWbF2NDHwMOHFdKsegQHM68XW4rk9KwNrwecLXPjPXxo6M?=
 =?iso-8859-1?Q?c+S4KbcUbPnd9w7t1iBXOoGcrGJNGtl4oi0fhl8op/pYvxJ99ZdQImV1XB?=
 =?iso-8859-1?Q?BUFwAX1h+WqHsQEtAqiHyVpD5iA74HCH+Wyqad6g681QWnCuwfCSgLaV/N?=
 =?iso-8859-1?Q?vkF2TNeXYMVDADK62DcTE3wE1FXqJ3rm2VXdsEJTeLkvQ957Et+/VT6ONQ?=
 =?iso-8859-1?Q?sQhvE+Osse/fqXq5lK2ujxeeHCEkRZvsYf+iB3hJpU1aU/OKjbR6fIoBw/?=
 =?iso-8859-1?Q?GVnQECG6xXINkMbFYFWip6WJ2zt4kDJpaC6VpP2z6Fb1gzsUKbzSHXlYus?=
 =?iso-8859-1?Q?uaQldWSz0xnRV+7+fMimm7mYhPaoGkGHYYctCmPISQjhav8hgE/kH4sHcU?=
 =?iso-8859-1?Q?eDmPpTs3RlDRRQFB5YKN57ekEz+sJw8Ew74nDZEtQJRHUM5wVu1jK5hCvA?=
 =?iso-8859-1?Q?eAkLBMU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR21MB3157.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(10070799003)(13003099007)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?AN4/YhDZ0JP69Vz57ipPnKsrNTFb4CfappjKqxJyre36Fg1Ffj5EFu/zkS?=
 =?iso-8859-1?Q?i5MpNIPGF5MQlwmuXVfgpKtFSUPURZI6bJpVZXpu/FKZmvScqJjAbXYFn7?=
 =?iso-8859-1?Q?myJBknqdx5r/i7Mrftp6O909hMxPJ3PPTOswsvRgP83QsmIJRTb90Hv6g4?=
 =?iso-8859-1?Q?BdKUIwKFdCbnbzbfprwqipwMRq7SxfRSg3/Uo8ZetHj78wCs7NEK2YblNt?=
 =?iso-8859-1?Q?HKnqUg8A9OxlHmRxIdEUMv3F6AMOK3TGDP5dVMuMKJ4GJ9qG0FpNaP5zTb?=
 =?iso-8859-1?Q?JDH3bSFoGDyadhUcThLBGR32/H2CtAxfMc24R4wWSkq1xYc79b53hE2BMH?=
 =?iso-8859-1?Q?geFO+O78qSWoGf57fdWiiqj/RZHAV7jvML305L7x8UMw1PxsswOGtoyewu?=
 =?iso-8859-1?Q?MM66TXidhTLSAdUkXe+Wgo1494is5KHBsG5AlETDvmt4fClEnnHtEcyEYG?=
 =?iso-8859-1?Q?s3JoQ2mdBvjgy2SScMF17WUlA+GTHcS4amiWEZAcSSesuwISKmrOECP+O+?=
 =?iso-8859-1?Q?4YPC00Wtb+pko9yS1UxF4EGTM48x5eEJ0c0ajRDOsSaIuKqdBCXKtBBCak?=
 =?iso-8859-1?Q?qfjLpj0p3fObsvhFa3t3fcZ2A/QfCtg4Anno9rj74lwgKMQwrExY6S9KLc?=
 =?iso-8859-1?Q?uWlgL3nLhRGt8s6jrMTVKbrVUUVgVKISzLHVtzR5fUP4APrcAt996VcBhr?=
 =?iso-8859-1?Q?LK/7sQUhVSd+wmCJavXKJUj0v9BZFXl+5zTmQHJvTvHEOvQloFZ+XDSxKQ?=
 =?iso-8859-1?Q?i5cOSsQZcIKIlnCsb1iccmJCXF172Js7yvTQRymXxkMRo0ys+Zg0DMfh3h?=
 =?iso-8859-1?Q?PtQ6Zvgk87Sr7A2QTnPgBzhz5MulMmYF6/Kp7BrQYlq0yKn+0ULN6n1phE?=
 =?iso-8859-1?Q?tL3GzLPvDCFhFNGYmrfNZOtEG2SAXVDwDU2swi3bcsXnrhHx6s7t0IrPto?=
 =?iso-8859-1?Q?XirOO243ZVYDgCwh8KrcacZiGTr+Cn/b3MXbpy2wo+ia8NuZqJhTr+luIz?=
 =?iso-8859-1?Q?hs45kuToTFqKOfXJGLi9PhhZO0erXB0tYayRH7eBAZx17RU2v7SIrT1dIc?=
 =?iso-8859-1?Q?Ohqd5oI7Q7l4KcwYosIk2Yt2HSH0M9GnkTuVUBpVElvQNZCI4587m707ZD?=
 =?iso-8859-1?Q?8KVzasQ0ng6GrZ2spvDNIct2ARoCi4rvHu9b4CYTkCM7ZrQhdammFFpIWh?=
 =?iso-8859-1?Q?I3n/X091f1bL+3s0wKA1e65vpjVuRgGdVKojYQRTB9zbRS8siURyKuaDzk?=
 =?iso-8859-1?Q?4H9ZuTjxjVwAL8MuZLyinZktbFjYu4dYm3DmIVcOJ+Fej7AYsPjzKtePZ6?=
 =?iso-8859-1?Q?DTBCCB9U0/tbK5pYpZrxGr65lmCQpnS9iwVFR4O6Vc4E8yviLsluahZlhu?=
 =?iso-8859-1?Q?jumpkfk10EPABsY1Yc7yXUSx4SHPlmSuyjnZDWmAbdMW01yHNKxCPFvltp?=
 =?iso-8859-1?Q?vIQvYwnxQS4IK9la/zAGgnIXA698LPx6a0Rz0E6VaLDi45iGE9qr3rogTO?=
 =?iso-8859-1?Q?gUD1zbKnSiRwveqCdIIeRXAy6z74MFVk1mx90A70fN24SyLuul/oFmt8ip?=
 =?iso-8859-1?Q?sjfS4j4+xTy+x/RGJwoHFnuvO8cgD7H9fBAbN3wKQJNpLONnyOU4v2qRBC?=
 =?iso-8859-1?Q?9IGYnc3WrLHEDt/YBEP3btYujyWxVerPPLXKxCUh4Xdgn7sn8QLA+n1BW8?=
 =?iso-8859-1?Q?G2i7bT8PULFRrVwkyNZbJRVb9imVi6oEAxQ8gt+T?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 91e099c1-ea9a-44d1-0b4d-08dd8cd03d98
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2025 19:00:17.0715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BY1+NIN85dluAlJ7fQIpakD0YiiAQCDUPONtxuEq+KokuuM/91WhsoT44pa1ELNPgT19OAPVYl+MIMCMV+rULw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN2PEPF00004D3A

Hi Ralph:
FileDispositionInformationEx, is for use locally, as documented in MS-FSCC.=
 MS-SMB2 and MS-SMB both do not support it but Pali have been able to use M=
S-SMB pass-through mechanism to send this information level to the object s=
tore who acts on it and deletes the file.
MS-FSCC is already updated and you can see the changes in the current relea=
se.
MS-SMB was updated as follows:
"
<133> Section 3.3.5.10.6:
...
If Information Level is set to an undefined value (0x0428) in the request, =
Windows Server 2022
does not process the request but sends a success response.
"
The above statement is to document the pass through behavior that Pali was =
able to produce. This does not tell the whole story, so I have filed a bug =
to make it more complete.

MS-FSA does not mention FileDispositionInformationEx. The reason is because=
 FileDispositionInformationEx is local. But since Pali has been able to sen=
d FileDispositionInformationEx on the wire, I have filed a bug to add a sec=
tion about FileDispositionInformationEx and information about POSIX semanti=
cs.

Please let me know if this does not answer your question.

Regards,
Obaid Farooqi
Escalation Engineer | Microsoft

-----Original Message-----
From: Obaid Farooqi
Sent: Thursday, April 10, 2025 6:07 AM
To: Ralph Boehme <slow@samba.org>
Cc: smfrench <smfrench@gmail.com>; tom <tom@talpey.com>; Pali Roh=E1r <pali=
@kernel.org>; CIFS <linux-cifs@vger.kernel.org>; Microsoft Support <support=
mail@microsoft.com>
Subject: RE: [EXTERNAL] Fwd: SMB2 DELETE vs UNLINK - TrackingID#25040900400=
09564

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
