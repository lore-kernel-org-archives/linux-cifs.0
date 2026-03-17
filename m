Received: from MEUPR01CU001.outbound.protection.outlook.com (mail-australiasoutheastazon11020120.outbound.protection.outlook.com [52.101.152.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A4334A788;
	Tue, 17 Mar 2026 06:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.152.120
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773730404; cv=fail; b=aJO3nbHyFS3MHTl9MkYBm0gArhszsLUsuHRRDmhFhovVOm9jN/faLbT9GULiHhIUlVFUDxIsSTk0iLmju+W9ibrqUwmgTNjLzjONxLQ2nvsotf/LSfqEETixkvgDIUnqKxtx7ZbivISM/iCRrcpdU7Qzv8eUk4hct1rfnOof3rc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773730404; c=relaxed/simple;
	bh=LxiZ1oSOv/4xZUoKnMIlp1AMbfOg0GtzfUdxsvjsMqA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TFPH/eaKmYF88+LvsK7tJJtIXMq738PwIvba+6h/B/2Mif5RSct3yZOb5+2DreOsB4U1VRWans08byjZLZYg2RBljweP8xmmHcYQlP9aWBvXXPZypJc1uSaCj2oqiMBW9BsFs0u012FSaq6RdZpV61ekLQBeFNbiIYp33mqc8HU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verivus.com; spf=pass smtp.mailfrom=verivus.com; dkim=pass (2048-bit key) header.d=verivus.com header.i=@verivus.com header.b=LcdBL31I; arc=fail smtp.client-ip=52.101.152.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verivus.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verivus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=verivus.com header.i=@verivus.com header.b="LcdBL31I"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J/vmHtSJ5fHRVdrp1nmg6+1fha+rD7Yj2fsBgyKIm+KipwajxuzjYvdwuNiJ2URhQS14L9Yytj6WkyacOZBoabY/8kDuyWbkl1Z/SIM9DblPPJDvCe6H75ilrQZm1jqe08oi2TIoamnwQNMU6bIdeyDMbTKQXs1iQLy4Ydp2nix0xSy/WNHwwHRq/px1kdSGPNTzVQIsum/CYjAHHVWw1WLo7ej5wNJr9aMHjKQ+xf3skM2HSvfNvFQdfm1vQOJWhnEmi9Nnl3wcSkooG35BZd//Hux2YXWx19dBAYWyv3AHzU56IeLXjUDt8uJdZT0Nu722x01Ei/d2hVqzURDQlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LxiZ1oSOv/4xZUoKnMIlp1AMbfOg0GtzfUdxsvjsMqA=;
 b=i1jJ9SmxDZ6FuBdOLW4T7Obf126fv7PLs5Jt051rZDGJ7UziZNYWU5ALk2r3CZB5TviHz935+dGtUQfiXicFJvJkdb/hdANXSb8YS/zPGoKLbjhLrMssm22AmyQa0kZ9Fb0R6NfHlWJX634I+84HiWVdpl9oqj6dbSfz0ukrIIw4WLVwFT9NG1J/FdgJUVOSZ4a1ozek45WWrlPVQfDrRMy4pSsqt1P8D+NILv3ISSj6UYcZ4SvdRywtUcA3ai3xLZ7FACizVaGKjtSbTymrGN9TJGfmCshLtirJQyfOjkEB4xRUmoaceRawoufKzFcQtvjgUNHGqZHjceIYZ/VoOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verivus.com; dmarc=pass action=none header.from=verivus.com;
 dkim=pass header.d=verivus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verivus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxiZ1oSOv/4xZUoKnMIlp1AMbfOg0GtzfUdxsvjsMqA=;
 b=LcdBL31IHzbBwVegw48EatFnS1oQWU0KVg8JOz5YgZ8sfM5tk5cUrzLgTNo2KnO7gOMgFLDjBSFdl9L99U3vtbAn5GW/Da/drQ88adySHTx6I00N9yBWV9AenFr/eSm7HKs3hqmlaWDk3ZzTinK7vsnveb9z7ubcJrAvAKUZoQSM1DAbMpAIK6U4peFEF93gq/9GFrpx2VAZeWRiIOEzRoDzNHoPb3TLJin/USMiTmUSvoNm/bDy18jXr2JU4zrwAr3og1PBDiLLw6T+IIRSGEE+6yvkLtaedM/tsGzaEKkHAlfpUGjavRaqQ0rT6iqDVSgw28ibwv9xuWP06T6SYg==
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM (2603:10c6:220:22a::5)
 by SY3PPF4AB8A3515.AUSP300.PROD.OUTLOOK.COM (2603:10c6:18::493) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 06:53:17 +0000
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2]) by ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2%5]) with mapi id 15.20.9723.018; Tue, 17 Mar 2026
 06:53:17 +0000
From: Werner Kasselman <werner@verivus.com>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>
CC: "linkinjeon@kernel.org" <linkinjeon@kernel.org>, "smfrench@gmail.com"
	<smfrench@gmail.com>, "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] ksmbd: fix use-after-free and NULL deref in
 smb_grant_oplock()
Thread-Topic: [PATCH] ksmbd: fix use-after-free and NULL deref in
 smb_grant_oplock()
Thread-Index: AQHctbRGGoonuVIAdUaXnTGLgDaKVbWyRGCAgAAA4YCAAAIHgIAAARZw
Date: Tue, 17 Mar 2026 06:53:17 +0000
Message-ID:
 <ME0P300MB08530E8735AFBC630825BDF0BD41A@ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM>
References: <20260317021757.962692-1-werner@verivus.com>
 <6b98c261-b17b-45a8-ab09-efdb0d658f4e@chenxiaosong.com>
 <ME0P300MB0853F9FCE2F9C416FE3820B0BD41A@ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM>
 <1e0882ea-4e59-4b70-b1ae-90fde86c252b@chenxiaosong.com>
In-Reply-To: <1e0882ea-4e59-4b70-b1ae-90fde86c252b@chenxiaosong.com>
Accept-Language: en-AU, en-AT, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=verivus.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ME0P300MB0853:EE_|SY3PPF4AB8A3515:EE_
x-ms-office365-filtering-correlation-id: e75b742c-1cda-48a9-4b08-08de83f1de8a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|18002099003|22082099003|56012099003;
x-microsoft-antispam-message-info:
 xKd/06JJJjA6fJjBCXRY9rnx1RU7lY7xZx0HQbn7KQ3OcdXcfKA0gja4WTGQEr8gHvn/Yd3l8eZiZ2WDdxmN8t5Yk57BzuLW+vYqFpBpKGdf/fUaKN53bzFk0U11bXu1x/UbAINsutkBQubGu/gsfH2Wp20+EuToFTgq2zShGJ+S1MEqSHpfCIdzOKAE1FpevwIXxYlLuuvk6DcMjaifITdVYDtZhO3EV5NcM+D0BY4fo5ECjuO0YTFdjYmyK6ewDKvlrUA7mGdNnWoXGKyaQswzx9vtbkWmeBxLV4H1neSLUWj3CQQf3H/60Qg4JgRy4L2aAnJ1I8NtVcKS8W8tdOe5RE7kNmIDhreOH4xoSMYYqdE9+c9J+mt0zyidvn+oJXK4SDOUoXNXVjTr3P2T5gikFHfampWP8PTnm4n3iyPf6MsMql17X/TEFBjp6NfBsq2Dh0ZFOjnZrpQdHQNHYFfiac7Gvftpo/sz1dIDqjumxcnmr+I16Ggi86FmLfbnuEgnGhcvcxZ7/kVP0BU5lUM1oqa/SD4/BDtshpp6y9BRG7QrxzbAdfsz0iIqfrkLYx6lTELevwJ2C/T4kBUrEqGGRMxwDXrxnlUd9fppFs4lNU4T1qO2bdEN6zpz2uWaZ339ovHNuKqMjF23O0d7Nf3fTzMwe/INf8e43l5LfC0d7IBeIs3uPn0schAxAXjwsV+9rT8ypp7pIlay58txz/8qClcZawRkD6ooU3EJr0W8t1FYgtTsXbIq+kzjCnc5rFNsBQ5QM67z0ZZWeJ/4jwirkEOqU5jlDyQjUNxsdP8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?b2ZraGszS2dZOTlma2FLRWFCeEQ1cTZVTzRlUFAxSEJVSWxkQnZWRSt1RzVE?=
 =?utf-8?B?NUZMSEMvSm1jcTBybjFQN3d2NHFGd2hCZ1dSN1RCSVpoL1ZEdTcvbDJaTFdy?=
 =?utf-8?B?WTl2NkZIOWVwL0pBQ216djJudWUra09CVFpkb2U5elRYa1ZUc1RSelQ1dXo0?=
 =?utf-8?B?aTQrVDFrcDc4MUFGMTR3dk04RGFlUzQ3VzJWVnhaV2ZDSFU1cWZ5MW1OWldS?=
 =?utf-8?B?VGxyeHVTVEdYQzRPSVQvejF4N2hJUTNXdmRRSUE0dWtLQVB3M1lPdGlsaDBT?=
 =?utf-8?B?eFBWcU5wd2c0MTRQMHBPLzVWRzA0ci9nTGVjb2VIN054NUxhVEJYdHRnUHdM?=
 =?utf-8?B?WCsyaWNYYTFkblZSL3E3RFlhWUVQc1R1NlJmRE5ucVRBb0Z4REdwL3RRV3Mw?=
 =?utf-8?B?M01qSml5Sm96YmIzQ1NRakpmamJuWGlYTWF4a2NzRCtjVlNpaWtEdkRwNlpN?=
 =?utf-8?B?WVhCd21MQit0dUN2c09RZW1WTStlZmh3WXo3TUFOdkpVb1EvREJhWmtxdHRa?=
 =?utf-8?B?dWVaQktZcDV2MUJ2SGdPRGNSekMxanVhRzBsYjNJQU9QNE1rZGFOQkVXRXpQ?=
 =?utf-8?B?YWJzcTMzT3hlanpwK3gwMEZmbnpnR1Y0YnBtQkw4Qi80UVZQaE1za3BMWHpq?=
 =?utf-8?B?NmNMalh6RkpUbkF2VlZEWmlDZGZTVFRxdW01S2NWcUp4U1dwbDJZRnBRMDBH?=
 =?utf-8?B?dlpYMjFOc0dMSEFRanAwMmdDRkZQS3YyVkJFQnphTkVUTFpzNkZQWWNzbVhL?=
 =?utf-8?B?ZVBUeTR0b0U0Rk04R2NCMXVlWHc0UTZ4YmpSWXhIWEROWTZJMkJCeXU0WUVl?=
 =?utf-8?B?dytpbkptYy9oMldYcWhYaEJTbWdua3hSUlppdE1XUWowdVl5UG9LQkFLZC9n?=
 =?utf-8?B?MVRvME51NWNRdWJYZ3RuR3VVc0JJZE1xVjFCc3JPVlhWMTFzTHU5QkJCM1dG?=
 =?utf-8?B?a2JLVmdTTUo4SjJiZDQzaDQwdUsxanNlR2tVbmRXcm0xZjlUUXlvRVN4WFdx?=
 =?utf-8?B?N3R6Q3hiejhDRTkzU2xTY01KSks0cEs4WlhrUCsvOEN5Qkl2blQwL2dObjNG?=
 =?utf-8?B?L0pacHZJMzFGKzFjcGJsdVNEQThKQzBQaUt3NmF1ZFVJdmVrTVVPeE14RVNw?=
 =?utf-8?B?SjdmLzhVbzJxdFoxQk9XSm85T0pVYy91S0NtZFhFWE56eERwbmxaOENjUmpR?=
 =?utf-8?B?cldXQlh4YnF1YkVnYUs0RDhUUUM5aGgzVkNNMU9PQWdTS1ROc21lM2htdmQv?=
 =?utf-8?B?N21ZQXdibU5XakFUU0pxcG1lemJKc2NWM255bnNORUhPZGd1cUtaTm8xckxP?=
 =?utf-8?B?VjNyc0lTejVuSGU3a2dxVUFVZk5hZU05MlQ5bmNlMkkrU2JHQVpYdFJSNUZI?=
 =?utf-8?B?b1VvNkxxOVRveTFWb2pZVkxZdGtBZ3JaK3ZBa1RJazBOZUdHZTUxOGFPVjBO?=
 =?utf-8?B?S21BVnlFNUZHSFJQYkRJQjZ5eFNoTTlNYlpubnl3VkNRNlR2T3p3NHlGUE1F?=
 =?utf-8?B?TTJaamg3TE5UQnZSelFpUWpqL0ZDV2dMSjNrdkxDcytVY0NqbGltSHFxZW5P?=
 =?utf-8?B?QmdLVUU2SExGNGVtZHdhRnplUTBpMTIvQW5Jdk1xc0dDaVd6eDhhWmlTY3hO?=
 =?utf-8?B?ZlYxZHo1Qms4QnMxT1ZBYVpWUmFLWU83cXBkZlcwemVqTEZ6SEs2MFZKdU9F?=
 =?utf-8?B?M2RxWjI0L0pOM0M1UmFsOWZINFNoOGFKNGdJeGZ4VkFnM2ZEdFBNeTE0Ykc3?=
 =?utf-8?B?cUw3YkRNU254bEFsR3ZtY2piaEt2YlBjWnlqRXpoQlV4Um5Ia3c3RzdwMFpL?=
 =?utf-8?B?UStwTmgvVTQzT2Nhd20wVzh6UzFyM2JxdzZsTm4xVUh4amh2ZXpFM0E5bndp?=
 =?utf-8?B?N1NBZWtPWXRrNnZHSjVGMEtTN2JCS1cvNVZrYkRyTytRc2NuMjNVY0diSE9R?=
 =?utf-8?B?VTBZTXg5Q0J4b1E3QlVRZW5QRXo1aE1KR05Eek13dGU2MHB5Nmg4V1RtRVI4?=
 =?utf-8?B?RTBBS0ZQUHQ1UUpoazdaLytlQUMyNXo3T1orNnBFSUM5d3NYZUt2bUEzMjNB?=
 =?utf-8?B?R0JiamxmbDM5N1V2OEh5Ky8weUxaWWU3YVQrN1NYMjFWbGdLcTRKNWpUR3JB?=
 =?utf-8?B?WnBpS0NDT1pqYXJJaGJMWTBwTUFock1pdm1XeFVOZDk2MUdQOHFDSEZBNVIr?=
 =?utf-8?B?b1VVQmdMMm94SGlNU2Y3UjN2cWJyZWlnbkRwWUVIS1hHSHNpT1BtMXJqY1g3?=
 =?utf-8?B?Zi94aHlleVBxbVBrenVXb3ZRcEJDTzN6aEFMVCt1RlF6YXhMcmZ5SWtRQjhk?=
 =?utf-8?Q?fiRhmmQOmJxJpwEHY0?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: verivus.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e75b742c-1cda-48a9-4b08-08de83f1de8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2026 06:53:17.6863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ccdcedb0-4edc-4cc8-9791-c44ee6610030
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jvtH1D8Q5XZeRPHg0qK5BqQ0tKid7b8nyulEEB6lavd1pUwzpuoVXjKVomUS4nWjrhSVCOCAEKIiOBY5r6dmfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY3PPF4AB8A3515

Zm9ybWF0LXBhdGNoIGdyYWJiZWQgdGhlIHdyb25nIGRpZmYsIHNvcnJ5LiAgSG9tZXIgRCdvaCEN
Cg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IENoZW5YaWFvU29uZyA8Y2hlbnhp
YW9zb25nQGNoZW54aWFvc29uZy5jb20+IA0KU2VudDogVHVlc2RheSwgMTcgTWFyY2ggMjAyNiA0
OjQzIFBNDQpUbzogV2VybmVyIEthc3NlbG1hbiA8d2VybmVyQHZlcml2dXMuY29tPjsgQ2hlblhp
YW9Tb25nIDxjaGVueGlhb3NvbmdAY2hlbnhpYW9zb25nLmNvbT47IGxpbnV4LWNpZnNAdmdlci5r
ZXJuZWwub3JnDQpDYzogbGlua2luamVvbkBrZXJuZWwub3JnOyBzbWZyZW5jaEBnbWFpbC5jb207
IHNlbm96aGF0c2t5QGNocm9taXVtLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsg
c3RhYmxlQHZnZXIua2VybmVsLm9yZw0KU3ViamVjdDogUmU6IFtQQVRDSF0ga3NtYmQ6IGZpeCB1
c2UtYWZ0ZXItZnJlZSBhbmQgTlVMTCBkZXJlZiBpbiBzbWJfZ3JhbnRfb3Bsb2NrKCkNCg0KSSBq
dXN0IHNhdyB5b3VyIHYyIHBhdGNoLCBhbmQgaXQgc2VlbXMgdG8gYmUgdGhlIHNhbWUgYXMgdjE6
IA0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtY2lmcy8yMDI2MDMxNzA2MzQ1Ni4xNjk2
ODUzLTEtd2VybmVyQHZlcml2dXMuY29tLw0KDQpUaGFua3MsDQpDaGVuWGlhb1NvbmcgPGNoZW54
aWFvc29uZ0BjaGVueGlhb3NvbmcuY29tPg0KDQrlnKggMjAyNi8zLzE3IDE0OjM2LCBXZXJuZXIg
S2Fzc2VsbWFuIOWGmemBkzoNCj4gSSBzZW50IGFuIGVhcmxpZXIgdmVyc2lvbiBvZiB0aGUgcGF0
Y2ggYnkgbWlzdGFrZS4gVGhlIHZlcnNpb24gd2l0aCB0aGUgY29tcGxldGUgY2hhbmdlcyAoaW5j
bHVkaW5nIGFsbG9jX2xlYXNlX3RhYmxlKCkgc3BsaXQgYW5kIGFkZF9sZWFzZV9nbG9iYWxfbGlz
dCgpIHNpZ25hdHVyZSBjaGFuZ2UpIHdhcyBjb21taXR0ZWQgbG9jYWxseSBidXQgdGhlIGVtYWls
IHdlbnQgb3V0IGJlZm9yZSB0aGUgZmluYWwgYW1lbmQuIEkgYXBvbG9naXNlIGZvciB0aGUgY29u
ZnVzaW9uLg0KPiANCj4gSSB3aWxsIHJlc2VuZCB0aGUgY29ycmVjdCBwYXRjaCBhcyB2Mi4gVGhl
IGZ1bGwgZGlmZiBpcyArNDUvLTI3IGxpbmVzIGFuZCBpbmNsdWRlczoNCj4gICAtIE5ldyBhbGxv
Y19sZWFzZV90YWJsZSgpIGhlbHBlciAoZXh0cmFjdGVkIGZyb20gYWRkX2xlYXNlX2dsb2JhbF9s
aXN0KQ0KPiAgIC0gYWRkX2xlYXNlX2dsb2JhbF9saXN0KCkgY2hhbmdlZCB0byB0YWtlIHByZWFs
bG9jYXRlZCBsZWFzZV90YWJsZSwgcmV0dXJuIHR5cGUgY2hhbmdlZCBmcm9tIGludCB0byB2b2lk
DQo+ICAgLSBzbWJfZ3JhbnRfb3Bsb2NrKCkgcmVzdHJ1Y3R1cmVkOiBzZXQgb19mcCwgcHJlYWxs
b2NhdGUsIHRoZW4gcHVibGlzaA0KPiAgIC0gRXJyb3IgcGF0aCB1c2VzIG9waW5mb19wdXQoKSBp
bnN0ZWFkIG9mIF9fZnJlZV9vcGluZm8oKQ0KDQo=
