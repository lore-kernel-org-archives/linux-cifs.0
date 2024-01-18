Received: from DEU01-FR2-obe.outbound.protection.outlook.com (mail-fr2deu01on2067.outbound.protection.outlook.com [40.107.135.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD1D24A1C
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jan 2024 11:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.135.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705576934; cv=fail; b=D4/FDIF0vJyMHppN2nfm58KV40NJWsHAaI0OUOnM0vsNcwoJR/FtmMAjo5ccRi0fGEpw33ZkHg2FSpJfsFZ23oUc91Avwr7mL69BSI9JfX3AfXgbvsLGmadgasXQ4lLWxEB0Qwi6kfKUKLKfLhOgLT46dKQkXG0pDomJ/hW2/ek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705576934; c=relaxed/simple;
	bh=xNuiVxYq3BBJGGgXwjyZ9UBduK8gPzshTIy/Yw0AFWU=;
	h=ARC-Message-Signature:ARC-Authentication-Results:DKIM-Signature:
	 Received:Received:From:To:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 X-MS-Has-Attach:X-MS-TNEF-Correlator:x-ms-publictraffictype:
	 x-ms-traffictypediagnostic:x-ms-office365-filtering-correlation-id:
	 x-ms-exchange-atpmessageproperties:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped; b=du82wRXsc3oaVPnuExykzzgxuPKY1bV6j6zjyZJVpNq8il9ONZza7/5j2M4GcrwabHo44Yt7EL9N4Omqzx8O2Opl3PH/JAOZZbZvpqJowd6GDR58gicCskQv0XSeiXsEG/Hh0/HIshPZRR7hYPxdUFdLTa+PyXGXar9uwGJ3scg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=seven.one; spf=pass smtp.mailfrom=seven.one; dkim=pass (2048-bit key) header.d=seven.one header.i=@seven.one header.b=qo2Iyw6D; arc=fail smtp.client-ip=40.107.135.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=seven.one
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seven.one
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=seven.one header.i=@seven.one header.b="qo2Iyw6D"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tpu38IyrvaEMja8QpMn5IEIjSKHFBIrgTVEUkXogDKGKwlHozWmy1jqi6NMDvagx6SWXj9YdHl03r3ne1yaGQU1ut1t0D4/dgE6s/NRh4f93QdjrDYH/EkG9VdPFTC3+qOdvamcx7jW/eAHe+PGHFix4Wp7xiBh9DsKdHtJah6+iYoOooJoh3PTCHZO1YLfV55TBz7sypN5W6ZinV9MPdKQQ/HTaAwtD1BGrz7Mh+/QhE+JPv3Zh2Zvp+ZC1JwA8TSqjOP6hZsZG/o9A/g6mph8nrjbMfouQCQOxK1HwEtJfMBMhc7JJu9mGCU7atWmxDwsfpq2YJSX3aikewfO8CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uoSbM5mBtg0C6A637oad2w7Dr+uJDYNzoVlfQvwMOus=;
 b=dvmVOy30mYpZxItt/n5/kXikp5nSCRbsHZp/cKql68UsVtlBgdBJouFw6c8V7yJCGJTv70TI9BEr8+VjPm4F2BbCd61mnSqHy3D4CEoZ8EBNhgDVVyGGcFfyPIT3d+dMDzJVWk45c/pX/76D3PIJsNVtNpldIakAmROX1kDiaXx4TzGYF0/VdPQUNU9Ty0YhaICOepkaTylSotmncrTjhBbnSK/pnpDSq5PveKHu5/WmXQCM0orhL5oMxdEmY4ckcO4dfmixw6drYo1qrgDTCKenVbrhTp4SbYuHpSkyG3lRMsdf3ciXNZLCNrJpALRDIxPxJLsnInzKZnxlO7UJXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seven.one; dmarc=pass action=none header.from=seven.one;
 dkim=pass header.d=seven.one; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seven.one;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uoSbM5mBtg0C6A637oad2w7Dr+uJDYNzoVlfQvwMOus=;
 b=qo2Iyw6DtpLzwqWnhtZli6LvUSXCMQC4ljCvj7uZco/OXZP+nqgny42QZDnlnNOAim16obG+He62PlpPpTvjMQxacZxfdW7SBGt1PjGs8c8yvz7P4/56zJjpTunxxu/K9SLeD1z9okv7A+/MH3TR5NPy+xmsquSjPXlwOz8etu/fF3t3v2LsRg4goe53eVeJ0O3UCcq7ivR2MyTg2903r9WIsdJjmiG1lG4plIcBQx2a0koP8ImqKWKpCxoAnR81one/UQ/7K41qUXXH/vjE27kX1Qx0fVurIc/v38a2K90DcAJLtQjkrSLHra1U/aPemi7a4Lux19KUmmF1fAm+mw==
Received: from BE1P281MB1505.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:1c::11)
 by FR3P281MB3149.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:5c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7202.24; Thu, 18 Jan
 2024 11:22:09 +0000
Received: from BE1P281MB1505.DEUP281.PROD.OUTLOOK.COM
 ([fe80::67c9:3f16:a04d:f3b1]) by BE1P281MB1505.DEUP281.PROD.OUTLOOK.COM
 ([fe80::67c9:3f16:a04d:f3b1%4]) with mapi id 15.20.7181.022; Thu, 18 Jan 2024
 11:22:09 +0000
From: "Schwalm, Florian" <Florian.Schwalm@seven.one>
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH 0/1] cifs.upcall: enable ccache init from keytab for
 multiuser mount sessions
Thread-Topic: [PATCH 0/1] cifs.upcall: enable ccache init from keytab for
 multiuser mount sessions
Thread-Index: AQHaSUirolX4uJJn4kuzW/l1DtS4ibDfbpPQ
Date: Thu, 18 Jan 2024 11:22:09 +0000
Message-ID:
 <BE1P281MB1505A914104F471109674EF7EB712@BE1P281MB1505.DEUP281.PROD.OUTLOOK.COM>
References: <20240117132534.2623424-1-Florian.Schwalm@seven.one>
In-Reply-To: <20240117132534.2623424-1-Florian.Schwalm@seven.one>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seven.one;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BE1P281MB1505:EE_|FR3P281MB3149:EE_
x-ms-office365-filtering-correlation-id: 58c56e5e-1f9b-4a0e-4e6a-08dc1817b5d1
x-ms-exchange-atpmessageproperties: SA
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 n7lCFx91EIn5QObbX7N3YKeDVsykmIGAylLjDqeL0PfaWX7Gqk7BKimPioYztfRKtLynqaPdSSS/8mna1zJrrxnzcYGXi4svifHw4NBZeEzTuUngCFtTTdoUokUwm5DkPjYt5kcyJ7qBwi2/uJC3QN21VGXL2prd0V4TO2+0+3HuqDmhG70/rg1x9mwqE5uCPfAzskSzlUgplCqlr9cQ9rtlSbneWVfMDWoklIQBM1+uNt+GmbFJBk9DXZOlOI7gUktsc571HpmLEHrkc7RH3UJFQ6+h97XeH4KExNvY62Ff11R2srLtd9eHAN0xQnuuxFi03+pgKjNogjbxLnFF6VYS8LoL0x1YG/FDgkhrNZYS/92bFsUfMYebLv7mtdQivOjMbH1ypyk2RKTBA3zHH407aEylZxfyIS1haYM68OnAH+3Ax2rEP+76gA/kwnSyH9nyxXNHNc7OGoNYNc0MQgDucoPvYV//p+2iqapOj9Y+7F6zZPT59xxXi8KE8ODwmOLsdz5sjRlUlqNoxR8v9TLPqf0S+LZoRM1J7Zob1otMqd0Z0QxZZoDmb0ueJVjZXaQektOqjW2YaV+B5eOTcQSDtIoBp6IxBenqmwTlFQUS8lLBogcLyWNyyIqanfbk
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BE1P281MB1505.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(366004)(136003)(376002)(64100799003)(1800799012)(186009)(451199024)(122000001)(38100700002)(83380400001)(55016003)(66574015)(26005)(478600001)(9686003)(7696005)(71200400001)(6506007)(66556008)(76116006)(66476007)(6916009)(66946007)(316002)(8936002)(52536014)(8676002)(64756008)(66446008)(86362001)(5660300002)(41300700001)(38070700009)(33656002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?Oy1gXKi3UjHkg/T+4OVS46mu99IOkDv3mexrh59IGf1jGgfgT/lhYp9NvO?=
 =?iso-8859-1?Q?kz00+NEi9J/qaUf8NL8Jcs0Ke+fRD2+sX7cR43GETw3eaVALZqEQ6Rf67y?=
 =?iso-8859-1?Q?c5emz/pgxUR+FiIRM+rObUQKOpGhyBTy8py9hF9b2QmTwmASO12m22iHm1?=
 =?iso-8859-1?Q?IzsSPnILQUV5TsirJJSvMesISarZHyzmsRmQPaS8W31xV1uRbfYPY+/gwW?=
 =?iso-8859-1?Q?mQ5fJJk/sHfRY8UhVr1y3KnQ7T2NuVD+IRySi9Ilco4tyjU3EB0Ypafg61?=
 =?iso-8859-1?Q?XNV9f20eZtPJ/xkRHBL979zyVXJtk10Qs1CT2uLhv/puyR5KvkNa7T3F8Y?=
 =?iso-8859-1?Q?YEJJwIrzYD3CRNjpzdAgvm+2L3r/y0WY/Yv3011F2khweJyy2Yo18hde7O?=
 =?iso-8859-1?Q?S1RJkOMj+kiQ6IYriWvChgPpXIpYkBaUWtF6LnRIagYxsLvy7I0maRYRl6?=
 =?iso-8859-1?Q?uEppojB8o319lAgA9i+M6d3wBFMgE2bAo0tnypYMUBKwZcFIleayBCGhh6?=
 =?iso-8859-1?Q?fLEPNJNPT0ownb/4BfamUMdc5uyjyur+X271tjIWQPmGCUkUAbKjwW2kn0?=
 =?iso-8859-1?Q?O710Jp/Cpppz33s0UmaolpUHHLS8vPA+QatfDz0lF7AU8Zxqu6YW0/PPCV?=
 =?iso-8859-1?Q?oMqzrePpRJPERpn9ALwLTV2KXzFyeSLg4Ogasj+N53Q6W0hNGCgDzTOYn9?=
 =?iso-8859-1?Q?RESyoZu75j6RZCfMTRWInbJrh4E+TXeb6pYCjV4zZL+IuLkYeabEM+RkbM?=
 =?iso-8859-1?Q?BH8hw6rz6GhjURQ3RWZZaKl6zSrAopezjFuEFC4dqGB4YGizEDu2gD7V62?=
 =?iso-8859-1?Q?g3mkSiLbie0in17dBBJpjKrfIRBvarqnYAixCWY3mrhHSHhmd76kiVdh/m?=
 =?iso-8859-1?Q?0wJPp8uvEY0A3kjdgvWkraKN/PaVdasOH9G45mD18OVfvMqiKwdyvoBmdP?=
 =?iso-8859-1?Q?jOW+UhJr6aRUSK7I1ZNagJOlCah+6K+fljo7yztOtaEAILtiMLX21uvBof?=
 =?iso-8859-1?Q?Yw2IVM2H9yRgn4VjAkwon7B0SZ2g7mz1ZnOhYlRrT1TI/8eQqSiVYxvqlO?=
 =?iso-8859-1?Q?yEHiYoaNmA7R6rFbUR+s9tkWZ8omO1YCMuebookCTQcQfhky05+UUyV9SJ?=
 =?iso-8859-1?Q?DjaCVXzgcfwGJFrQiSH+RU6vEtUMxG4NjIA4IUd2ZNv00oFTqjn1kuWveq?=
 =?iso-8859-1?Q?VtLqWitACqzZa0YZNV7oC8qVlfpt6osmLRpjYi+RCmgvUPm40se+HrVZb8?=
 =?iso-8859-1?Q?QCnuHIgy2mbUhI5QPR+JXDjsgs2CM2SEIp/SP2g9fqmFgmNhxX7OW3qUkK?=
 =?iso-8859-1?Q?h8dlIcwf8vsjc7ZbD1cAxAA4ZXs54LC9KY9u/NNINmrctdoo/VKwYTM51Z?=
 =?iso-8859-1?Q?ZjDIm+TsLnS5ukKty64vdsWcT+UbdGHuco7DdswM90qbrPf3kOGgunu/3F?=
 =?iso-8859-1?Q?jzdGfg5mdb2zHljG5DHd+X67SPV8wJC8NhxjvZrLIH6HYhbaGkPg40Yztk?=
 =?iso-8859-1?Q?hoYGfBBdDRV5OWehuos5KPkNVm3ZGFm5dhx9DGCLZ72irNpubd/oIdYsWK?=
 =?iso-8859-1?Q?uNjFHRcTVnWvXCASmLl6wXxkRxGis1tFGhOJCmXdqSVesOINGwQ3GLq+x7?=
 =?iso-8859-1?Q?6k16mmB0eJFZ0oc5nv4YwJAnNlJYjjVbBx?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: seven.one
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BE1P281MB1505.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 58c56e5e-1f9b-4a0e-4e6a-08dc1817b5d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2024 11:22:09.3120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3825a6f3-24cb-47d4-8aa2-35d3e5891324
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DamX/h4TZGWtcxS9WkpWJRwj6uQcsPGD9zIAhXkE3D7KtCqiGSjwx6IKjOB90AqB/AzortW/5KNqfwbMWC26VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR3P281MB3149

Looking further into the issue my use case may be solved by using the gsspr=
oxy feature implemented two years ago.
The patch may still be useful if you want to support this in cifs-utils its=
elf. Though probably another patch would be advisable to support per-user k=
eytabs so we do not need to combine user credentials in a shared keytab. I =
can try to work on this if you think this would be a valuable addition. If =
you conclude that this is sufficiently solved by gssproxy, though, that wou=
ld also be fine.

-----Urspr=FCngliche Nachricht-----
Von: Schwalm, Florian <Florian.Schwalm@seven.one>=20
Gesendet: Mittwoch, 17. Januar 2024 14:26
An: linux-cifs@vger.kernel.org
Cc: Schwalm, Florian <Florian.Schwalm@seven.one>
Betreff: [PATCH 0/1] cifs.upcall: enable ccache init from keytab for multiu=
ser mount sessions

While trying to configure kerberized SMB on some of my department's machine=
s I failed to achieve the desired scenario. The idea was that multiple serv=
ice users on the machines each authenticate with their own credentials on a=
 multiuser mount.
Since those service users are used for non-interactive tasks the credential=
s should be initialized automatically from the keytab provided to cifs.upca=
ll.
In debugging the connection and looking at the source code of cifs.upcall a=
s well as the cifs kernel module I noticed that the keytab is only used if =
the key description provided by the kernel specifies a username. This is no=
t the case for individual user sessions of a multiuser mount. Since we alre=
ady scrape a gid from the passwd nss db based on the provided uid, I though=
t there would be no harm in doing so as well for the username in case none =
is provided. This is what the provided patch implements. By deriving the us=
ername for the user sessions we enable those sessions to initialize themsel=
ves from the keytab as well.

If there is an established way to configure this without requiring my patch=
, please tell me where to look.

Also, please take extra care in reviewing this patch. I haven't written any=
 C in a long time.

Florian Schwalm (1):
  cifs.upcall: enable ccache init from keytab for multiuser mount
    sessions

 cifs.upcall.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

--
2.39.3

