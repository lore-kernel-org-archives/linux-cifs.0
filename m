Received: from SY8PR01CU002.outbound.protection.outlook.com (mail-australiaeastazon11020122.outbound.protection.outlook.com [52.101.150.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D187878F4A;
	Tue, 17 Mar 2026 06:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.150.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773729420; cv=fail; b=Q8vCSl58vlFPPahYBigz3e3hgTnqS/pYC0LLdGuf2p0G6RolXtP1W2C5QHpyby76Iwtpg4BO142nroqrz9tKNEMso/el9iwEIjATuFebn5zqzeVEJBR4a9h3yUHpBu0/4RveYZN7pYBhZHa0RPCBenj4SMtsTERsOV5OCJVKwXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773729420; c=relaxed/simple;
	bh=6agmYGVN/WoE3gvhMIGE/sUySDT1rxkpr4+eAQQ8ymE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZqC97upOUwf9Q5fQIQ+pXvNQdWhaW5p9BE1WTUu3BqAkHyBJQX1RH7Vqygk+LHRAYjvZtetaxwwYNtkKzaLulKHbwwJG/97vtTKoFnYtrz5jpPeSvCTmk6Hhl8+PWGkTALumpaK7J8e66jUq6NtTyOLok+Qun8g9nFDcOhNS8xE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verivus.com; spf=pass smtp.mailfrom=verivus.com; dkim=pass (2048-bit key) header.d=verivus.com header.i=@verivus.com header.b=Ppv6cUKd; arc=fail smtp.client-ip=52.101.150.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verivus.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verivus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=verivus.com header.i=@verivus.com header.b="Ppv6cUKd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W7+s5pBpQvGCj8K5RHB4hJSfH5N2PmFsqCoPpERt2YaE69YJ/BUsVfrJcF0dPDtScZ1ZNSc9uJ2CjCv+jGlgQ4Td9Tfgu2FRXw1aZ0v0axVhN3oHDKi/JHniAwKYQSl8Lqead5TLLHQomUT0Z1j/HugzJQJzI3kk6yWahGnC4ATZZ7eFlOgME1TOVLtOKChuA2jXpbmBfaq8wKOrJWaBJ3uhah7toBuo6rxGw4gJQIfNnFB7aEBquEgrp3FaYhwDeiCrbubYRQfRt28/ylAF2EglwDkTYTvFooU78Zpni/H6nD7FU7pogIChcPhDHUjSyFd+lDvktQGkC4IqyJpgjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6agmYGVN/WoE3gvhMIGE/sUySDT1rxkpr4+eAQQ8ymE=;
 b=yBf0vpbfCf1TKqo93sGUvcFTSoZCehPatUZsBPzqgz3jGQhTiSETR3wsk8+ewziIXypkwQrKsMcYBcDZe1sPqJC+MP7J9b+K1wHPt9yR0HutnDRL7tQFv9Zw7u2m0zOWxPz5RowDBPnPuY0mjuzDW5J4fmH7p/KqZyldr+k747R70MrQiamvdJP6xvp/cxx9bxWQQ+B1ze3eUHKOb7+4NClFmJRJ2DuRiuzX/IKfv63yP/CYSneriotAzT3L/KEatGYci3s1ELtju/i9iBQlKsK9KsCqNTB+fRTM+UsgmGsa1pOozEHhbbCbUgKCKpov+vtOuFrUf+RJPDGAnKdMoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verivus.com; dmarc=pass action=none header.from=verivus.com;
 dkim=pass header.d=verivus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verivus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6agmYGVN/WoE3gvhMIGE/sUySDT1rxkpr4+eAQQ8ymE=;
 b=Ppv6cUKdacFNZEdoFFH+LI7a6hKyzBCIOoGJu2f0FY+3bW7H+DFySXg1dBh2NPrCRLK7ksBuMtz8pafocXrwiiQtqgRM314j1jAwe285/4iDGL5BHtsLcxaQnwH6dMHSeiAOycFEsQb165gsdFtr4TcX70TAtP44+Xwmddv10gcs6PREvfoEGpG99ot2ayqjwxDOr9ukCvQz7yLD1ZNneI5E6Zt/hKnkKyAwOiGk2hEI+1Mn1Etzioa/B6QfaxIQtlMXZBkwYnqvb+TCZBmSCwAok9MCC1kK0qrbOaWXEenDgper++8+p90Kdw+UDDOmf5A2B8+J1MMOzsPkDoUk4Q==
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM (2603:10c6:220:22a::5)
 by SY3PPF9691F1569.AUSP300.PROD.OUTLOOK.COM (2603:10c6:18::4a2) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 06:36:53 +0000
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2]) by ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2%5]) with mapi id 15.20.9723.018; Tue, 17 Mar 2026
 06:36:53 +0000
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
Thread-Index: AQHctbRGGoonuVIAdUaXnTGLgDaKVbWyRGCAgAAA4YA=
Date: Tue, 17 Mar 2026 06:36:53 +0000
Message-ID:
 <ME0P300MB0853F9FCE2F9C416FE3820B0BD41A@ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM>
References: <20260317021757.962692-1-werner@verivus.com>
 <6b98c261-b17b-45a8-ab09-efdb0d658f4e@chenxiaosong.com>
In-Reply-To: <6b98c261-b17b-45a8-ab09-efdb0d658f4e@chenxiaosong.com>
Accept-Language: en-AU, en-AT, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=verivus.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ME0P300MB0853:EE_|SY3PPF9691F1569:EE_
x-ms-office365-filtering-correlation-id: 8d9e09c8-f59c-45f7-f1c3-08de83ef93ec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|38070700021|18002099003|56012099003|22082099003;
x-microsoft-antispam-message-info:
 K5NMaPSZJQl3DHp2f72GVEyh86SVsLDqMynRUOk5Gk2QWi0A8O4ZKEplrg1BM+vzub7rleMRjBq5DRsOjETOqiMB2BlnVLePyJYG4Rea2JyGhSsSdYLLNB5UqhXajmvMSoNK39MwKcN0xcGeIHGIU3k/4wk+dd9dhAwuc1jmSmLKqqfmUu8bZzTU0lKzZU4UfmEzoxTsPQhUQHDZ4KslJIR5hxs8nTlfL/5UeKOZ2YuGY8LftPFM1erb/z7Pb98NTVC0UfCViO73TYkLnG9qgvJ2Ssc6GohJ68sd2avXvAk9DvCO98L6WPld0Gw1iFspG19vuRXUNcdzuKFbX+44Dptp1mk+OAufXpClx3GWUlHvRcFmpcaSUM9Nh4Qj4UUDVWbtMVjz/iH5XqQ2nNyj5gm0o5DkkyP1BiEYE2QGjVWM/6yFl3KLpmvQ49H4ZJhSwwtSOZUXA7/oZNi9jDAfEnW5zZIbAHonsxr7+KJ80WusFZth5UGJlp4pOUwaNZztE7HRwq+/PNlrtoufUvish/3UctZlF4elH9JhFzddE3ojBGca0JYF+zAp+Xvs+FvZXN8puM9H2JeuAkUMWjAjFS9TCgRVOjMlFkcK5SICwqjVfcaE71DyWIxDZXNBHWBKiZ39hBKBab2h8fkfldQJ4C5EwxzE2dZXNP5Xd2Rwy8R38oB0lzjAGGosKsyqub1BjcD8Uc9RDjTSv4YRixvoMgtQVkDsHZ1iYnIkECAiDiJt3rMDfQ+l+W+HrJ1Jhkzq98E1rouKlsBcmy5XszWOZUmdPMe4z/ApohHo+Lf65Nc=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dnJJcW1PakFreEdQREZjTVpJa3dQcDhxRmRiVG9Bb25JZXNPNTB1dTlQclNO?=
 =?utf-8?B?bHNiTG10VEVzSnNCSlBrcEZqb3BoTVQ0b21jSUxWdHVINU1vSEZqbWFVOXNC?=
 =?utf-8?B?ZTJCdkpOeGtDQ2tkaGRpWU1mZWNVUDBrUzFsNExQWVp2SS9CLytPQmFQYTRE?=
 =?utf-8?B?NmFiRnZ2UjVtMWJwdGYvaTJpOHB6RzM0V05rei9TWXNwSGFIWSt0OXBsRjlH?=
 =?utf-8?B?SW9VV1lZaFljdG55YzEvUHRxMlF0WUZrTWV5Tyt2NUVnRXlMbnhQeGJhU3pD?=
 =?utf-8?B?dnpxckhoelVYVjMyRXJOdkZOTUNoaE9ucEpjSTU5OXN5UnBKNlJXOEd5WmtL?=
 =?utf-8?B?TllJYXhjT04xRmc3WDZqc3AzTEsybVhZQ3NydWI2OTcwaXJwdG5SMCs1U1E5?=
 =?utf-8?B?VS9OdzJpWi8xTnVkVU9SWmNtandadk1GelNkVkYwemo1TklFdGZZVjRiTURI?=
 =?utf-8?B?VE5OSkJJeWNpZlc4QVAwNkRWQ2hpdGJsZm1xL1RRMHo3d3hlOUp5YXVHcFhZ?=
 =?utf-8?B?V2s3ajV4Q2pwaFZQbTdXUFRCZGRkMS9FSno0RnlHOG9FTjFtRzBKN0FWZ3Vx?=
 =?utf-8?B?ZXViQ1FVaDVzU3lCR2hrVHkzbGdRb1M3SjFzNk0zTkYwb1hyeHQ2ZitTdVBp?=
 =?utf-8?B?MEVtMFcvbUNqcmpqR1N4bEE4cHVCSVVJUGZJQjlIK1BmRGUxajF0c3ZXZjBE?=
 =?utf-8?B?WWFBeWI2REtrVk91MnNNSUt3amJLVUF4bXJ0WW1CWXVTaFhadXNLK0x1QmFU?=
 =?utf-8?B?UWZLVERrMm1NYTdpTURaY2xKNlh6VEdZYjc5L0hRaGdocmh2MlZieGZvbTg4?=
 =?utf-8?B?UDIwcTcwcmlsY0tMb2tLM2R2REhac1M1OHVCWitRSHpEQ2VUVGdQbjE2Z0Jz?=
 =?utf-8?B?b2FMcXdiZTNYcUQ1NUJ5dEt5Z2JlVTBXT0E4OXBCL09GMWUrZE5TMnZVSmpE?=
 =?utf-8?B?VGttWU55UTJrWU01R3FEdFk3Szh1bmpXU3FTdnlyZmpHQWVFRFQraFIwWnlj?=
 =?utf-8?B?a1lQYWE0VGtrMmZBSWFDS1FWSWVvNlNHVU1XcE1FSHVYaDhzbmNpRkgzR054?=
 =?utf-8?B?M0dycDF1VEJrTnJSOVhYc1hiTk5OQllLUytFU0hhcy8ydDdvV1VXQzRNVWFE?=
 =?utf-8?B?T2N3UzNNYkFRNmJvY1VHTml4SVN2b2l1NFpUaXJJVWp5YUlZZzNka3pJc1J6?=
 =?utf-8?B?SzFJaEdjWmJiQ1dlMUlyb211MGh4bm1VR1JxelpxQnhOUWE1V3hPT3dLUTEz?=
 =?utf-8?B?UEdOUFlGd0F3cGYwSlorUUd3d2RCeERvRGwyVzZXZ0VPRTRvSzdiRFZ6MFJ3?=
 =?utf-8?B?ait1SVQ3cldmOEtWNkdhbXRhZEpNZzdub3NwcHQ2alhKU1M5UndhVlQxeCtE?=
 =?utf-8?B?bHltdU5DWjZURUoyM1FveXdBUTJjeWZMUXV1ckhDcGY3Q2hIYzdPMVFsY2tY?=
 =?utf-8?B?ZUtEc1c1V2JmdzFJLzIrUHhBcUxMN1dZVHlTQW9BeVdUZUNReVJLVy9maFFH?=
 =?utf-8?B?bEJySU1CS0o5RVZveGVoM2VmZlkzY1oyYTFGdk9ad0VhK3J1aHNwd09KdEFo?=
 =?utf-8?B?Ukt6ZzBNM0xpU1pUSFBZT20zU3NvbllTb2R0MkJZMFNraHZrZjVOQ3Jja3Ni?=
 =?utf-8?B?UXhqaCsrSW50OS9CNVp3UWROYVNRRzQ5blZYVmUyL1h1emIzZFlmU1hUSkx3?=
 =?utf-8?B?eG9yNGFERkk0RU9LRFI4bjF4SDlNazRKTWRKMDBQZDBLLzlTY0xoZVZTRDRj?=
 =?utf-8?B?SDR3YnhpVFN6blU1UDVYNnRkMmhESnN5eXpYRk5tYm0rNUY0NDRIemdyUlhZ?=
 =?utf-8?B?MVVHR3pXZ1FiTGJFK29ndW5kYVAweHRSNTcyTms5aUI3TnZNalpqbDJtRlNK?=
 =?utf-8?B?NnN2WVc1TitNVzdWMTlNSy9zR0k1dnA4NjBuTWpMUkQwbVVZd2FPMFF0SWI0?=
 =?utf-8?B?bEQzSUNFZXRMSG9pWmpKc3BQZzdOdW1DYm1ON2ZlRkJFaUtxK3NKWHJGcGl2?=
 =?utf-8?B?Rnk1elRNWTkrRDdBYVI4bDdpbnJWWXNPaGFwdkh1YWViS1prVXBpeStFNGYv?=
 =?utf-8?B?S1NiOG9zYlZ2UTYwckN2aHg1SnlSd2dwa3VaOStXTmM1Qkl5WlhBNnArWnNw?=
 =?utf-8?B?WmVDeDMrVjd2THJITzk1OGE4ZTZiRmFtZEMxRVVUbkZsN3IvNlZxMkgvTzho?=
 =?utf-8?B?Nlg1TEpJL0NqSGUvR3NSWG45QkVSVlBuQzRMZU14Q2pnRnQwWVozQnBWbzF5?=
 =?utf-8?B?alA3Q3B2MXNXYnd1akptM1U2TWJld2g4NUVEQ0IrOFUrbER3cmxHWGF0RTU5?=
 =?utf-8?Q?n69s4fxjilw6naZ2g8?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d9e09c8-f59c-45f7-f1c3-08de83ef93ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2026 06:36:53.5302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ccdcedb0-4edc-4cc8-9791-c44ee6610030
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ASZoQ9Sn/niekSuu26t7LdmxhqXQXIuYBAjUqia82EV6LFTMzyPnP/hthggnOm1vmjd3On3SlmDiFCiCZTpOSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY3PPF9691F1569

SSBzZW50IGFuIGVhcmxpZXIgdmVyc2lvbiBvZiB0aGUgcGF0Y2ggYnkgbWlzdGFrZS4gVGhlIHZl
cnNpb24gd2l0aCB0aGUgY29tcGxldGUgY2hhbmdlcyAoaW5jbHVkaW5nIGFsbG9jX2xlYXNlX3Rh
YmxlKCkgc3BsaXQgYW5kIGFkZF9sZWFzZV9nbG9iYWxfbGlzdCgpIHNpZ25hdHVyZSBjaGFuZ2Up
IHdhcyBjb21taXR0ZWQgbG9jYWxseSBidXQgdGhlIGVtYWlsIHdlbnQgb3V0IGJlZm9yZSB0aGUg
ZmluYWwgYW1lbmQuIEkgYXBvbG9naXNlIGZvciB0aGUgY29uZnVzaW9uLg0KDQpJIHdpbGwgcmVz
ZW5kIHRoZSBjb3JyZWN0IHBhdGNoIGFzIHYyLiBUaGUgZnVsbCBkaWZmIGlzICs0NS8tMjcgbGlu
ZXMgYW5kIGluY2x1ZGVzOg0KIC0gTmV3IGFsbG9jX2xlYXNlX3RhYmxlKCkgaGVscGVyIChleHRy
YWN0ZWQgZnJvbSBhZGRfbGVhc2VfZ2xvYmFsX2xpc3QpDQogLSBhZGRfbGVhc2VfZ2xvYmFsX2xp
c3QoKSBjaGFuZ2VkIHRvIHRha2UgcHJlYWxsb2NhdGVkIGxlYXNlX3RhYmxlLCByZXR1cm4gdHlw
ZSBjaGFuZ2VkIGZyb20gaW50IHRvIHZvaWQNCiAtIHNtYl9ncmFudF9vcGxvY2soKSByZXN0cnVj
dHVyZWQ6IHNldCBvX2ZwLCBwcmVhbGxvY2F0ZSwgdGhlbiBwdWJsaXNoDQogLSBFcnJvciBwYXRo
IHVzZXMgb3BpbmZvX3B1dCgpIGluc3RlYWQgb2YgX19mcmVlX29waW5mbygpDQoNCktpbmQgcmVn
YXJkcywNCldlcm5lcg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogQ2hlblhp
YW9Tb25nIDxjaGVueGlhb3NvbmdAY2hlbnhpYW9zb25nLmNvbT4gDQpTZW50OiBUdWVzZGF5LCAx
NyBNYXJjaCAyMDI2IDQ6MzMgUE0NClRvOiBXZXJuZXIgS2Fzc2VsbWFuIDx3ZXJuZXJAdmVyaXZ1
cy5haT47IGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnDQpDYzogbGlua2luamVvbkBrZXJuZWwu
b3JnOyBzbWZyZW5jaEBnbWFpbC5jb207IHNlbm96aGF0c2t5QGNocm9taXVtLm9yZzsgbGludXgt
a2VybmVsQHZnZXIua2VybmVsLm9yZzsgc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KU3ViamVjdDog
UmU6IFtQQVRDSF0ga3NtYmQ6IGZpeCB1c2UtYWZ0ZXItZnJlZSBhbmQgTlVMTCBkZXJlZiBpbiBz
bWJfZ3JhbnRfb3Bsb2NrKCkNCg0KSGkgV2VybmVyLA0KDQpUaGFua3MgZm9yIHlvdXIgcGF0Y2gu
IEl0IHNlZW1zIHRoZSBjaGFuZ2VzIGJlbG93IGFyZSBub3QgaW5jbHVkZWQuIERvIHlvdSBoYXZl
IGFueSBmb2xsb3ctdXAgcGF0Y2hlcyB0aGF0IGhhdmVuJ3QgYmVlbiBzdWJtaXR0ZWQgeWV0Pw0K
DQpUaGFua3MsDQpDaGVuWGlhb1NvbmcgPGNoZW54aWFvc29uZ0BjaGVueGlhb3NvbmcuY29tPg0K
DQrlnKggMjAyNi8zLzE3IDEwOjE4LCBXZXJuZXIgS2Fzc2VsbWFuIOWGmemBkzoNCj4gLSBQcmVh
bGxvY2F0ZSBsZWFzZV90YWJsZSB2aWEgYWxsb2NfbGVhc2VfdGFibGUoKSBiZWZvcmUgb3BpbmZv
X2FkZCgpDQo+ICAgIHNvIGFkZF9sZWFzZV9nbG9iYWxfbGlzdCgpIGJlY29tZXMgaW5mYWxsaWJs
ZSBhZnRlciBwdWJsaWNhdGlvbi4NCj4gLSBLZWVwIHRoZSBvcmlnaW5hbCBtX29wX2xpc3QgcHVi
bGljYXRpb24gb3JkZXIgKG9waW5mb19hZGQgYmVmb3JlDQo+ICAgIGxlYXNlIGxpc3QpIHNvIGNv
bmN1cnJlbnQgb3BlbnMgdmlhIHNhbWVfY2xpZW50X2hhc19sZWFzZSgpIGFuZA0KPiAgICBvcGlu
Zm9fZ2V0X2xpc3QoKSBzdGlsbCBzZWUgdGhlIGluLWZsaWdodCBncmFudC4NCj4gLSBVc2Ugb3Bp
bmZvX3B1dCgpIGluc3RlYWQgb2YgX19mcmVlX29waW5mbygpIG9uIGVycl9vdXQgc28gdGhhdA0K
PiAgICB0aGUgUkNVLWRlZmVycmVkIGZyZWUgcGF0aCBpcyB1c2VkLg0KPiANCj4gVGhpcyBhbHNv
IHJlcXVpcmVzIHNwbGl0dGluZyBhZGRfbGVhc2VfZ2xvYmFsX2xpc3QoKSB0byB0YWtlIGEgDQo+
IHByZWFsbG9jYXRlZCBsZWFzZV90YWJsZSBhbmQgY2hhbmdpbmcgaXRzIHJldHVybiB0eXBlIGZy
b20gaW50IHRvIA0KPiB2b2lkLCBzaW5jZSBpdCBjYW4gbm8gbG9uZ2VyIGZhaWwuDQoNCg==
