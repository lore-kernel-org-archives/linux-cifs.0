Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012057.outbound.protection.outlook.com [52.101.48.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4664A405C4A
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 11:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784548296; cv=fail; b=W35tDb1MIpcFx2wbCSs0XoUn+If1R1v0RAFptYSoBFMUaDnUnvOGXS0vWbcByyynUnitITXahaJWMoDAmaooBEQxf4t7K1Zwq/PvGJCq1/iBwZdK+XmDMDxPUMT0yYpzRhaHlRrIWDVRkUGego8PJvlvEubFOq0+vdPvdMd9v/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784548296; c=relaxed/simple;
	bh=2SS6UMv9XU4SxCBAhbrLAvTX7ImqhbfYjRVPrSBCuLY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HpnirrgxWXPxtvo4WNvC947TSVK/mVDHoLOK5FDZRkG/w5KZYvGz7PFZsqBe4fUlsZL+YBUOJpYxVPV2Foy1WUOpXViGWujOmMuIVrZZE37fNyVGe3A5A0I3/cRPXQ5PUjwdym8ru9dKE8mpX3iMyRd7iblBvWvR2GLAre6VRFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gehealthcare.com; spf=pass smtp.mailfrom=gehealthcare.com; dkim=pass (2048-bit key) header.d=gehealthcare.com header.i=@gehealthcare.com header.b=nf5NdSDr; arc=fail smtp.client-ip=52.101.48.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gehealthcare.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gehealthcare.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gehealthcare.com header.i=@gehealthcare.com header.b="nf5NdSDr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jQkRcTMe7YANS32GkJHZ8GaGwkVStF6tNf0kJTWmUSQZHdbcb6CT8r6W5rvIXhrCvfb3QwdrZPlgbcHAl0y+n708LNP9z1+1H1SezTxwKkZEgTofLhq0Mx/4LmMSXWbaW/jYN/rTqxdSMZeVGSVMACzC0PPA6oDZ8e6y5uZn0vFvr56bii3oa1v0gkPlo3l0Z0EpR/VSgYfUwOwsqYmzCm2n3Be6I5Nivzi5v7wICCfUXh78BSvadfthheK3rlglwhpY5/S9l2jFpMvPRbivE94uh/3pfP5heGHccSYHCw+CNFLYxRNIhhN66HSXhwQQ3guE+DzqLwCPKWqb5+8vtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2SS6UMv9XU4SxCBAhbrLAvTX7ImqhbfYjRVPrSBCuLY=;
 b=rxKXwQSY149ujXErv3x4I6YTAF6dsTUuuhxttvBg2btezzp89K/MdbNoky5417Ml9Zao0Rmm+JU2B6QEITsrT19lV4yC+tM+TK5JP/T+MZI7j970hUg+qcUY6GHINR1cHENPAR5iK5PlDA+zP/jOw1D2jvUon0J51kKcLPZbL/ADa0N3/Tw+jzQ7ou6Xibna09FsSOmY8oRYls75kRYOFYdD0dwMqk4NaSoECW5NgIm7lfR+0dJ3BuVUO2Djo3DaHKPvc465NB0acHpyrK3xH4gU8gy/HBTVO77F6jD3r2cxMM5/XL0MhURB9nl8A1OPbR6WFBd7d2iJ1ZYixK0UIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gehealthcare.com; dmarc=pass action=none
 header.from=gehealthcare.com; dkim=pass header.d=gehealthcare.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gehealthcare.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2SS6UMv9XU4SxCBAhbrLAvTX7ImqhbfYjRVPrSBCuLY=;
 b=nf5NdSDrl+Qhoe1hencrZ8VTvpTeYRTRGsdZHZI70VlYE6nz+zE69oBUK67aS6rGxYAV66+knd7GY9TNES9bnJ3vWmXsvu7aMSJxDuLhpOaewhIj2qo+iG27kvEy9d5ony7XpyImwO02yw4bV9DZu191+VJDEG1kqzKPFsidnzGsl//BgtT54q1oqwpbEmubO4fmg0qIk7IGhpsDMU6LxOvHHlE35jyU7BnwzcYT9kSU0ED/8dVHJWQ7RXMmmmjGn3UEsYzVin39hPraX+DqHuajPf1SsDE4qNSDFZ4c9St43rRvVONacAcdL6vQvaECmWmMDM5l49TfVkcPUSdH3g==
Received: from SN4PR22MB2888.namprd22.prod.outlook.com (2603:10b6:806:20b::14)
 by PH7PR22MB3161.namprd22.prod.outlook.com (2603:10b6:510:13e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.12; Mon, 20 Jul
 2026 11:51:32 +0000
Received: from SN4PR22MB2888.namprd22.prod.outlook.com
 ([fe80::3f8e:f720:488d:3441]) by SN4PR22MB2888.namprd22.prod.outlook.com
 ([fe80::3f8e:f720:488d:3441%5]) with mapi id 15.21.0223.017; Mon, 20 Jul 2026
 11:51:32 +0000
From: "Birtwhistle, Daniel" <daniel.birtwhistle@gehealthcare.com>
To: Greg KH <gregkh@linuxfoundation.org>, Willy Tarreau <w@1wt.eu>
CC: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: [BUG 1/3] smb: client: SMB2/3 signature failures are logged but
 the response is accepted
Thread-Topic: [BUG 1/3] smb: client: SMB2/3 signature failures are logged but
 the response is accepted
Thread-Index: AQHdF6iRtdczLk+zuESZipdBMHnh1LZ17l2AgABd3Po=
Date: Mon, 20 Jul 2026 11:51:32 +0000
Message-ID:
 <SN4PR22MB2888A3C1128344C813F25B22EEC32@SN4PR22MB2888.namprd22.prod.outlook.com>
References:
 <SN4PR22MB28883DAF57E0B4D4BFB1C22AEEC42@SN4PR22MB2888.namprd22.prod.outlook.com>
 <2026072010-affront-blog-f082@gregkh>
In-Reply-To: <2026072010-affront-blog-f082@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gehealthcare.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN4PR22MB2888:EE_|PH7PR22MB3161:EE_
x-ms-office365-filtering-correlation-id: 0534ad06-36c1-4fa7-7e71-08dee6553e0a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|376014|366016|1800799024|38070700021|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info:
 84w0ROzk/M2esVPhJy5Kh7vMSizT0jmRKUqhxk2lVyRUa7Hs1q3nREtIFHsTNKs/SSLfmuh9zktKsfkbKyw6kJvZTnoSDeJkHG5/KZeIaAXHVBz8FAYvRDp8LdjVnSL94wL8rlJTOcygjO4mMFSmjQp0LTkutSEHre4Dp0VK2BHlTU5wiHcuFB2YsAQkvyoe5FpYlwAkTqjElN1iz7GBTHhUwGOniW2OdF4WtwHSae3TbdftZ1ZSHtKG6f/OHMEcZjgCISF5S0dze81N0KVMtxr9bbMg7r0xT8B8p/pzkNADpJ8OpjyTWj4nANdrD1Evdg8D83WcUSEzGisVh5si1bdrVB9tT5I7K0MM93DRH38WMRn5emRbfsO4tWEhUGTEDNWURWHwVFZrELgl9+Iy9xd7s9aHVVvUkUdhRJNhmhl2mSLJ6DMpaoEeosceFQXbUh7rvbtsNpVbXRu4Xx043Fvbs94ZL3aSWKYVOogVrWYIT3lU9Ond5sfo1L6HvpaVjQYcKIwcuVFbsEjH9lWs96nD45zcG4jFHSV1zz5noghJ6fVBAGCdeyjoq+U6gtlWebZd7nosNMc3bALWhkkvKzQNOWsnf4JkmeVSX8/rRgzZbSuVrhKpZlFlqpRZHbhMMfwHdgTRHlEhMXtdBF4syghIEIYrtD1EO8QqwgpnT+VI3ZOWKtDgYT6wzJuqBU7SW5HcUQIH7QvcFh0c0VW6RBbhhYoa1Kmu4QPxvCaaZRg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR22MB2888.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(366016)(1800799024)(38070700021)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?Windows-1252?Q?tqzdhRbRIzVimkuqsB1pBZxXkiaxnOjAuMJqNfIXmFLwQoysrSXKOjXF?=
 =?Windows-1252?Q?Q5+GawM/LtcucX7J0SkJfkc/e4QSXTAlUEz/aXVQDETl+BC3bIVd66vr?=
 =?Windows-1252?Q?4CH/AGTPqjGP1cLNPz8xPjiS4hQHlg7+rGVhRCTYkv5UHczeKkFie2tL?=
 =?Windows-1252?Q?0L+L6RTiE/QbxMwQzDU50ZyNt0dvrRh/13ybtCp2Jciq6ZHZ2Dck8M+/?=
 =?Windows-1252?Q?U+A14QveaqsHNSbnPFbO5Ou/xwmuXoR3utUwnVd4pI8xpG1CDo2Kdn2B?=
 =?Windows-1252?Q?Ij4vVpTCZ/6R+yUXFhL8kYviG60QRybVh3v8WMh0NfUrM6lN1YA5NH4e?=
 =?Windows-1252?Q?RPM6wnY89cMiKdHu4TDn/bw89PA/WCnXkIwHHjHKkDRLrOcGv8q64rTs?=
 =?Windows-1252?Q?RLgvut4yGyko/KX5LJTuh9K3BSji6H+hYznkaz4uSvI5j+CEps0mwjAF?=
 =?Windows-1252?Q?2lPApUUlptETvhodvx2mpLeyxcyz2gRm58yRJHZGbXA5+nz9GIKBFvfq?=
 =?Windows-1252?Q?B1rN5RvvPsJWHSLBeAyMznuNgX6Kb15U7v/VCY8EggR36TkoPiAWPl1b?=
 =?Windows-1252?Q?LoAXLqYfLJsURizqsPhYILt5Gtqzs7h11uA+qhMvykXxInOqApl0+eIK?=
 =?Windows-1252?Q?qiF6X+TbJ0gsV3SqSxW6lNydwUJxG/mghrSiM4LwuXfgPU5xzDABK9d9?=
 =?Windows-1252?Q?Fj8V+m0lOtNMT7MAc4GFtQRIuHYRqLRx+72SwXNUGS3hWbLltZSh/mK6?=
 =?Windows-1252?Q?DvXLDmU9lHb39h9dPm5Mvn5fxujG5vX+akJWwmU1r/HZojqpwsuz9oI6?=
 =?Windows-1252?Q?9uQMJFPLfW1svUtX5mH931X+O0FMQLprQB3YLIDCvu4mRN7e0NBGOJuQ?=
 =?Windows-1252?Q?0chl4BnaDe8z4qVAMaz2q8qyShZQ0i5KTB92IqfEd8yyf09S49kYGUm5?=
 =?Windows-1252?Q?UKRR/mY9nj+F8qWvtSWMC1FqEcsIileTrhBMkoB32f9RHBWYKXMco/Aq?=
 =?Windows-1252?Q?SfZbnSeuiCMQZRAG2hqgY3GzLG81r7oHRqiZCnDy76smZvA6qf/ovJAl?=
 =?Windows-1252?Q?KAwPbwfmHI+feui+pTW09/SW0cioMW/ZY3qNWhvGmLv5QN6r+BN6My5V?=
 =?Windows-1252?Q?J4S50eim0gboaBWaKbiXPLEiWssL0ypQ0+Wo0wEU068bs7nk4pwVkZUV?=
 =?Windows-1252?Q?AqQlViSQqjq9uPNnA/eAGCaW67eftFCMZMcsBfFzc5xxrZnTPi7zGc8k?=
 =?Windows-1252?Q?IpHbMKPIsBVH0CGT7NxMKF5zQcO8QWV4uGrnS/Js663d6ivg0Pz1rqfp?=
 =?Windows-1252?Q?1KlPu3buedGWjM2BjAPEnmngoF/DvAyqWnS5HsiKYDq3fO41hY5WQoMH?=
 =?Windows-1252?Q?9rdSFB0DFMepyva0qqdNQZxTU0lm99VqGFohOFbzFt5ba1F2ECICKSJk?=
 =?Windows-1252?Q?x4sJBNSqExa6HH2ooig5HjrupnfdYS90Q/vTpNqYJwCHq2cUKnAU1bIu?=
 =?Windows-1252?Q?g5CH925OQGOMj0vkxdgQ3of54yM8zNh3V32/FGxemZ80f2cBqrcnyad3?=
 =?Windows-1252?Q?nheWliWzF2RyohUZS0Z+iztH5lIE1sAjMQRl3xdUu4ePNmncEiUEggZM?=
 =?Windows-1252?Q?HSv83N8Vx36eIgVp9gfcnETeETLjJIaiGYpJIvZ+ltlOBHq2NXqBJkBF?=
 =?Windows-1252?Q?JmrVhM8c9KeJCaqrTfpxtb4YHVo8LXNIKc0TiBzd2jPU3Gkb2fSDbu1E?=
 =?Windows-1252?Q?TIyp25pHh3k6xJv8n3Sc4ejpqjLta2NqSdKBj1CdVaVzUywulD+NA2/K?=
 =?Windows-1252?Q?DzZnHv3Nxmv9yi6OOZajr72M2wdwsjNmepVyqhn4nnw8gh5eyRSTyJHe?=
 =?Windows-1252?Q?BuHsZK55EhN4jw=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: gehealthcare.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR22MB2888.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0534ad06-36c1-4fa7-7e71-08dee6553e0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2026 11:51:32.0191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9a309606-d6ec-4188-a28a-298812b4bbbf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iuRMoLF7TqCcZaFHBRBq1xBB+TU3bBvCckmOlcKjDtI2/slvBjeubVLLMNOxi+r/58664XhSHhpgko/9NpNog+AgJg9e04fbyO8l35pO8yY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR22MB3161


Thanks, Greg and Willy. Understood. I=92ll prepare separate patches for the=
 three reports following Documentation/process/submitting-patches.rst. I=92=
ll keep any reproducer off the public list and provide it privately to the =
relevant maintainers if needed. I=92ll also omit security@kernel.org from f=
urther public-list messages.

________________________________________
From: Greg KH <gregkh@linuxfoundation.org>
Sent: Monday, July 20, 2026 2:13 AM
To: Birtwhistle, Daniel
Cc: Steve French; Paulo Alcantara; linux-cifs@vger.kernel.org; security@ker=
nel.org
Subject: Re: [BUG 1/3] smb: client: SMB2/3 signature failures are logged bu=
t the response is accepted

CAUTION: This email originated from outside of GE HealthCare. Only open lin=
ks or attachments if you trust the sender. Report suspicious emails using O=
utlook=92s =93Report=94 button.

On Sun, Jul 19, 2026 at 06:05:01PM +0000, Birtwhistle, Daniel wrote:
> Hello Steve, Paulo, and linux-cifs maintainers,
>
> My name is Daniel Birtwhistle. In my role, I assess security properties o=
f
> software inherited by GE HealthCare products. I am writing personally as =
the
> researcher and technical contact.
>
> This is the first of three coordinated CIFS client reports. This message =
covers
> response-signature enforcement. The companions cover server-provided syml=
inks
> escaping mount confinement and client-required sealing being dropped afte=
r
> reconnect; all three defects have different fixes and can be classified
> independently.

As you sent these to a public list, no need to get security@kernel.org
involved.

Also:

> I have the minimal candidate patch, source harness, raw transcript, trace
> results and matched controls. I have not posted or attached the reproduce=
r,
> but can provide it directly for review and can test a maintainer-proposed=
 fix.

Always send patches, as the documentation asks, so you can get full
credit for resolving the issue if the fix is correct.

Same for the other 2 emails you sent.

thanks,

greg k-h
