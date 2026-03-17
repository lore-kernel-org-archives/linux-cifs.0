Received: from SY2PR01CU004.outbound.protection.outlook.com (mail-australiaeastazon11021133.outbound.protection.outlook.com [40.107.39.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F302A330D24;
	Tue, 17 Mar 2026 21:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.39.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773783726; cv=fail; b=QnCw7stFiWJE6bWJ/Xn1in1BteCkmckp7fNBvEbf/2fL8uB+vAtP1SdfzzjRpUSjpABiu50fE/hxkx0o1Xfi4LNEI10zyeTai6Bbjarp9esPnAM+OPHnKFqqfTYXxDbEwLtbhlQ43ZXLs6sar/m292JkUv2srswKZZB+jXRZr1s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773783726; c=relaxed/simple;
	bh=lZcl8jRAwdtqmd4IE2zO1igVuba51SzrLemitB9mU8o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ajebysORT+Nyz8/7Sj4/MZ7Hj4/tcpyG3f+XH1GdXF+V+s45vsQSLPc65r2773rCioVe5SU57/iJxPizqkcTONPkA3guPNgd2MkOHXN/rfFnxE0XwG/gfXUwPLsvHP06wJQN+1X2o/d7PvaMr0pjRVWlKSvGO2wW7jnIiEJxlKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verivus.com; spf=pass smtp.mailfrom=verivus.com; dkim=pass (2048-bit key) header.d=verivus.com header.i=@verivus.com header.b=tP9FAPic; arc=fail smtp.client-ip=40.107.39.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verivus.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verivus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=verivus.com header.i=@verivus.com header.b="tP9FAPic"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Akj+6Jly0scJWO+V/E47M+hNmvV7epyiNm+WYZ1Ie6qBiC+CFCTNobRbkpLaiiNTV6/S96LbuBqS2Wt3SFcLuxU62IEG6IYkwDTQHTzEMHY5q1w8zy3WVD6htDRJk+dlIctS8VU1oXF1iBSJs7RC1OWtxYyqFLEHCgwJ/HlD6rvi6RUT/2+gk0BJ9JEPXjZ3ynHHCSEMZCjpqzo9xmtpe27T09nXZDq1rj3YgWngMcFl4WTxC+50Rl4bktQxQ0hkij3gTN6F36NSatbP/6h5KEXwIhkcQkczK54mllpfMmpS/DZAqQiItsanXVPTW9uGur2xrX/e1DY77avZcriEqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lZcl8jRAwdtqmd4IE2zO1igVuba51SzrLemitB9mU8o=;
 b=xU23CMuNp4KaL2Yo9/zvcs75zE7TyYClzI0VoDVKIpr545/8PGlGgRGcEO7UdM1waDAzAnvoAJGZlMhi7gjq2VjqZ96SrqZS93bzqSVZakIWlAs9OOQ5Ts2lBmgzgbPQsI4d0IJ9Ew41j6T4RWt0IPcVUzXTfzQTgR0FANsjbJyRnsry1qAVhSRqqJEG6LykOCKjTUkWAUOCeRX09hFnGsUBUK1zWy/WCitESCJ60wpHAigzdC2tgGnW/+p/12txP57XH6eQlOq4N1SYhS6sRvPIt0NOWUWMTD6qhzrk1PkUciR8+YVYjkPxre8Gl5D0oypORA/umd2lgOIBdXjUlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verivus.com; dmarc=pass action=none header.from=verivus.com;
 dkim=pass header.d=verivus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verivus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lZcl8jRAwdtqmd4IE2zO1igVuba51SzrLemitB9mU8o=;
 b=tP9FAPicVHH2dh2skuN0NPHDMNbIiOyivUNyEQ+QGrLoNf4YtVc/cRtmwjXGQIDkQ4sEKzYpBf4+3kYsiLXjfKwhvLpo265v4a7qqybMZcVMPMxDIsHWM+QBAgqWyTf8UqxBLOKARnsSozT+K8LziU779c48npq4jZtGMUqfOfjBx7T1NMw6fODLIKFi1XtK/tpYFCpmJxbrqVACQbcfj++ReWN2JBdTXAYtxdSY5x5NmhjBD1sQUTAQjIFpmA6brdO67wHN5y0w6iOZ1XYHxMMmXw5eOzoKUpWAKLM2M6xSHA7bFzwnlBkKa16fnBY0bLGwQKrCFySpI2Ia05eoDA==
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM (2603:10c6:220:22a::5)
 by ME0P300MB1376.AUSP300.PROD.OUTLOOK.COM (2603:10c6:220:24a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 21:42:01 +0000
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2]) by ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2%5]) with mapi id 15.20.9723.018; Tue, 17 Mar 2026
 21:42:01 +0000
From: Werner Kasselman <werner@verivus.com>
To: Steve French <smfrench@gmail.com>, ChenXiaoSong
	<chenxiaosong@chenxiaosong.com>
CC: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"linkinjeon@kernel.org" <linkinjeon@kernel.org>, "senozhatsky@chromium.org"
	<senozhatsky@chromium.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: RE: [PATCH v3] ksmbd: fix use-after-free and NULL deref in
 smb_grant_oplock()
Thread-Topic: [PATCH v3] ksmbd: fix use-after-free and NULL deref in
 smb_grant_oplock()
Thread-Index: AQHctdquQ6RAMNJ6J0uWDLxUujB7AbWyYQqAgADc1QCAAAJpUA==
Date: Tue, 17 Mar 2026 21:42:00 +0000
Message-ID:
 <ME0P300MB08539CE2C65B16E25B703EE3BD41A@ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM>
References: <20260317065253.1743552-1-werner@verivus.com>
 <435dda9f-93f5-41db-9d21-70371d31857b@chenxiaosong.com>
 <CAH2r5mvRpUJpXSgeQdQ_ssjz=skeFAFPKQ3u1YZ9Z1jtsjf87A@mail.gmail.com>
In-Reply-To:
 <CAH2r5mvRpUJpXSgeQdQ_ssjz=skeFAFPKQ3u1YZ9Z1jtsjf87A@mail.gmail.com>
Accept-Language: en-AU, en-AT, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=verivus.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ME0P300MB0853:EE_|ME0P300MB1376:EE_
x-ms-office365-filtering-correlation-id: 528a445c-e91d-436a-a331-08de846e05af
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|56012099003|18002099003|83080400003;
x-microsoft-antispam-message-info:
 Zyk4WAzICpioj3ikolcnzEc8NDAhKqtZlyLgmc7B/PIRpg1JU+haGbZ2po4wCiNThCiYYoYu7NSKOO4l3iBblLDZ2uDjFA9iRoOUjS+RgnwzivB/A2ItHgokoiTgMc6xYm0BJBgnBQX8EZ7nUMEV5XcNe/a4I4OdZtZ7nTEnj81ln5q/pmXE0DE+55XPu2TBV6U8VZ7qKBKJ/BlTfiSDWvVv2hjJiQOUFMSw4oALoszNL+9ULAuSDQogsVh18GbEFPJl8rEluQJkvUeRIBLl6ItTTUjGF63i2RwKcN8m7S5pfeDAqV5CEPm30WluIqm8RicxbTQM22GlyLL+OGUcz0ZUkR5yhEtMqRxkek+bHiwOdQHAF7wWrsOs90oNf01ylXCs9fWdWbDowMO9cgGKdLuBHTZxMDXMHHMXR8/Em8499yI5UsoMPu+7wnyqZc+MKt2j40HEDji/+NDFmVYBduDGclM+ZGRD9YxSISR+C2MS2tNmawQXOE3oN3dOAX1wdc5ftQuNsGk406W0Y75zG90loJHfJ773+E9P7ioDrJwjOwp1pgICW3tZwFF/tnBuU5JMA5xsKbNb+s/ZC5rDg9ILMFiVSbaxXUFLyMB8Rwu7Js1P3DFul7tGep4ApMUonrlYFgDuQEpUB03lTLiuUvMh6Tz03dRD0nvBbbL9TE5ARGgX2sptDur9xVuTXFlsQeMFTWJz67QxtD73rbpoYT69ToFO5it3jTylibWkDmst9b8BdsDCHfIFmw1kFfiAgSM+cAlNWmpc24qgOdcVyQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(56012099003)(18002099003)(83080400003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MVdKTDVwNEsxTnFidnd0WXdiNGxjN3MxUFVBNnoxaWRsRm9tdVpET2xJSzUw?=
 =?utf-8?B?TWhia1BoT2xvMFdRNFhPQ0JrQ08xZm50QXNvRU1mNTJyY0NWWnJvMGhQczNi?=
 =?utf-8?B?VDAwcW5IbzNLVGJuM2RoTy80OEVjekVvUVNLZjJXSFQ3RTdYeXFVZGdPdHpQ?=
 =?utf-8?B?cUVkTVYzWUpVQWx3eEtTOGRPYno1ZmJsbEJLd3ZxK0E1b2NsQSs1N1Q1cFpK?=
 =?utf-8?B?dGFicUx0UEFZS3JYYjZNVUs0dWtncklKZXhDU2NON1pLcjU5QnBqTUdjUHRB?=
 =?utf-8?B?YVdSL0g2WFZ3dnJoR1VyTndyWVhlTHFlYnlFbnBrakFYNFd4dXYyR05ybzA2?=
 =?utf-8?B?NDZBNDg0K01GYkpJS0VmSE1XMkxmaUtqbForaDFtL2Rvd0dxZmwvSHJiVjhJ?=
 =?utf-8?B?M005cVh5TUFKUTNkSXFGdmlVNlRmUC9yUlRpekdNVk90QzVLV3V5bEppTm0y?=
 =?utf-8?B?TVBQYnFYZzd1SXlyYlBvRkJGWUk3anRxZXE0cEdjSFlzRkxueEh4SGJBMFYr?=
 =?utf-8?B?TFRvK0hzdmh5eTVzUVFZdWtUSFlJU3hzTS9ycWZyRFZNU2xMN21OTDI3aHdq?=
 =?utf-8?B?cjJFRk5DUHBoSGdudnZQUkdmM2ludUlPaU1rSEl6UEE3M1ZqNkU4VnU4eVA5?=
 =?utf-8?B?bzVQTHI5bUh4ZzFkQ1J2SlhwMlNtaTBjU2pKS2h0R29qTjlXbkN0TUpNUzVw?=
 =?utf-8?B?SENkMFZFaXJNQ0c4N0NGK29ZSDdFWEErcFV2SEI0RXUrOWd4RWVYa0xqemNG?=
 =?utf-8?B?OTVYNXJxVUNWZXMraFBpWXlDUHQvUEd1U25XYWNlbjFvRUUrd2hRT0JZdmk0?=
 =?utf-8?B?ZUppZ2h2VitwSllTcHA5WEpTV3RFTExncHlhY1pxRjJrU3gvaWp3UUFyQjZK?=
 =?utf-8?B?dVRYL0dYTkhNbE1LSy8rNFFWSWxLLzJlZy9Scmk0ZFlDT1FaUjQ0OWNYczJw?=
 =?utf-8?B?MDZNeU8zc2VGOVFZUWs2eVZMSEMxamdYekQ5SkRydzZLWjhNMTUwcTNOZ0JJ?=
 =?utf-8?B?aFVJMk94K0MwRkZYT3pVcXdPQ3FFWk5aM1dBMzlBVXRxMXFFdnJiYVpZV1hS?=
 =?utf-8?B?cEJzSGVBdGRUbCt1MmVCcVhiUmxxdW1hbUJmc1RCeXJWc2RpQ0kwdXAzNUo1?=
 =?utf-8?B?QkxSTit4U2pYTlQreWNhMXQyRXJ1WVc1MGNsUW11VEduNGxRNzNLcjBPa1Jk?=
 =?utf-8?B?L3JhWVBrMzQ0bUE5N2F3RzZYSmlHTjhPSjNZM0ZXYU1qaUtHZXNqeTRDcVdZ?=
 =?utf-8?B?T2p4VU9OeEtIZi84VWxXV3NMRkVWaHY4K2l4RVFxZS9HV2RJa0FCNGJhemFx?=
 =?utf-8?B?NEo4SDJNRDB0S1BLY1hXWlhtN2hkaTU2UDNRNkZqQ2g0N1RzWUE3KzkzNjJx?=
 =?utf-8?B?UW93bktaM1h5WitPNUJXeGllRVRkL1AwYmRmbzFwcHlBWXZhSlFWS1JvRlpN?=
 =?utf-8?B?bTBsWmVWSGNIdUxONHlkZSsyK0E1aTJZSWlPaER3eEI0QkdTNHloa2tvR3JC?=
 =?utf-8?B?NGovc1NvUHNqUW1rSkF6bUh4WXBCUlZKc1M3U1d0bnhWQTVnNTNabThXODZE?=
 =?utf-8?B?dDBCOTVkSDVzSFQxdGJBRHJzaXRzdWlSVmhIYm5aN1FmejNZOFpjTmZYOWhC?=
 =?utf-8?B?bnBVWm9NWjlVTkU2bXZOV0xPcUlacGlZclZ6YXo3bTQzYjFuL3NPN01FeSt5?=
 =?utf-8?B?T25kYWhqeSthSTBJeTBHRzlrZDFhb2R1TXlSVFRHOVlxRkdsS3JjeTRiSW9J?=
 =?utf-8?B?SGFZL2pncEdib3JhbEhFRmtJa1FlVGZYWHFLR3dlbk1NZ2F5VFB1ZFFLUjRJ?=
 =?utf-8?B?MlNiNFRpNWNXT25LVHRUbkZGb1Q2OFVSM2ovc1hLcjFlNHBFYlJINXlKdm1Q?=
 =?utf-8?B?YmRiM1g0ZHlsVGlrb25BZVlRUW51NlAyRWFOWUp6VXNYMFhBVlpXUlJqK1Nl?=
 =?utf-8?B?TTgrdXc2Wlp4cUpwVm5sUGhRRjF0bDlpbVZPZ2xUSE1IZVZBVFpPMUpQZTR4?=
 =?utf-8?B?cGp6SGF3ZTJ6ZjcreFNtZTdFYkxJRDNzZXd1UHBLWlRmd0VCKzFkRkpDS3BW?=
 =?utf-8?B?YmZJclBjd0VIQUxJTVdZZnBCZVZNcGs3SlpFeHNLN290UlJmdmFZUWxZa1Bt?=
 =?utf-8?B?M1VWYW1ydjRwY0VLQUhyb0Y5MnhLQXBEZFRoSzZHSkc5RVZhbWw2MGgwK3dj?=
 =?utf-8?B?MTBYd2R1cDVJeVdUYXVaSEdNMlIrVDdBSU5vN1hHdWdkbTRjUWdjTnVwNW9B?=
 =?utf-8?B?WnFkVURmYXdBNnlGL3g1TUI2aUlxUVhDOFBuN01GTVFYcjdTNGVVb2w4KzNY?=
 =?utf-8?Q?4q6u42r8DzQWxaLPor?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 528a445c-e91d-436a-a331-08de846e05af
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2026 21:42:00.9401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ccdcedb0-4edc-4cc8-9791-c44ee6610030
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YHrJawosZ50i9JwH6agrYDWHllL9kfb8ekgeC1nID6bk3X+EcqMsSSdTG3b8GTql94/EaCvtwwhyP91WoTeJtA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ME0P300MB1376

SGkgU3RldmUsDQoNClRoYW5rcyBmb3IgZmxhZ2dpbmcuIEkgcmV2aWV3ZWQgdGhlIFNhc2hpa28g
Y29tbWVudHMsIGhlcmUncyBhIHN1bW1hcnk6DQoNCjEpIFVBRiByaXNrIG9uIGZwIGZyb20gZWFy
bGllciBhc3NpZ25tZW50LCBub3QgYSBjb25jZXJuLiBUaGUgY2FsbGVyIChzbWIyX29wZW4pIGhv
bGRzIGEgcmVmZXJlbmNlIHRvIGZwIHRocm91Z2hvdXQgc21iX2dyYW50X29wbG9jaygpLCBzbyBp
dCBjYW5ub3QgYmUgZnJlZWQgZHVyaW5nIGV4ZWN1dGlvbi4NCg0KMikgUkNVIGxvY2tpbmcgaW4g
bGVhc2UgbGlzdCBpdGVyYXRpb24gKGZpbmRfc2FtZV9sZWFzZV9rZXksIGxvb2t1cF9sZWFzZV9p
bl90YWJsZSBkcm9wcGluZyByY3VfcmVhZF91bmxvY2sgbWlkLXRyYXZlcnNhbCkuIFRoaXMgaXMg
YSBwcmUtZXhpc3RpbmcgcGF0dGVybiwgbm90IGludHJvZHVjZWQgYnkgdGhpcyBwYXRjaC4gV29y
dGggYSBzZXBhcmF0ZSBhdWRpdCBidXQgb3V0IG9mIHNjb3BlIGZvciB0aGlzIGZpeCBpbWhvLg0K
DQozKSBOVUxMIGRlcmVmIHdpbmRvdyBvbiBvcGluZm8tPm9fZnA6IFRoaXMgaXMgZXhhY3RseSB0
aGUgYnVnIHRoaXMgcGF0Y2ggZml4ZXMsIGkuZS4gY29uY3VycmVudCByZWFkZXJzIGNvdWxkIHNl
ZSBvcGluZm8gb24gdGhlIGxlYXNlIGxpc3QgYmVmb3JlIG9fZnAgd2FzIGFzc2lnbmVkLg0KDQo0
KSBSZWZlcmVuY2UgY291bnQgbWFuYWdlbWVudCBpbiBlcnJvciBwYXRoczogb3BpbmZvX3B1dCgp
IHVzYWdlIGlzIHVuY2hhbmdlZCBieSB0aGlzIHBhdGNoLiBUaGUgcmVvcmRlcmluZyBtb3ZlcyBv
X2ZwIGFzc2lnbm1lbnQgYmVmb3JlIGxpc3QgcHVibGljYXRpb24gYnV0IGRvZXNuJ3QgY2hhbmdl
IHJlZmNvdW50IHNlbWFudGljcy4NCg0KUG9pbnRzIDEsIDIsIGFuZCA0IGFyZSBlaXRoZXIgZmFs
c2UgcG9zaXRpdmVzIG9yIHByZS1leGlzdGluZyBwYXR0ZXJucyBvdXRzaWRlIHRoZSBzY29wZSBv
ZiB0aGlzIGZpeCwgaGFwcHkgdG8gYmUgY29ycmVjdGVkIHRob3VnaC4NCg0KV2VybmVyDQoNCi0t
LS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBTdGV2ZSBGcmVuY2ggPHNtZnJlbmNoQGdt
YWlsLmNvbT4gDQpTZW50OiBXZWRuZXNkYXksIDE4IE1hcmNoIDIwMjYgNzoyNyBBTQ0KVG86IENo
ZW5YaWFvU29uZyA8Y2hlbnhpYW9zb25nQGNoZW54aWFvc29uZy5jb20+DQpDYzogV2VybmVyIEth
c3NlbG1hbiA8d2VybmVyQHZlcml2dXMuYWk+OyBsaW51eC1jaWZzQHZnZXIua2VybmVsLm9yZzsg
bGlua2luamVvbkBrZXJuZWwub3JnOyBzZW5vemhhdHNreUBjaHJvbWl1bS5vcmc7IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc7IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNClN1YmplY3Q6IFJl
OiBbUEFUQ0ggdjNdIGtzbWJkOiBmaXggdXNlLWFmdGVyLWZyZWUgYW5kIE5VTEwgZGVyZWYgaW4g
c21iX2dyYW50X29wbG9jaygpDQoNCkkgc2VlIHNvbWUgQUkgcmV2aWV3IGNvbW1lbnRzIGZyb20g
U2FzaGlrbzoNCmh0dHBzOi8vc2FzaGlrby5kZXYvIy9wYXRjaHNldC8yMDI2MDMxNzA2NTI1My4x
NzQzNTUyLTEtd2VybmVyJTQwdmVyaXZ1cy5jb20NCg0KT24gVHVlLCBNYXIgMTcsIDIwMjYgYXQg
MzoxN+KAr0FNIENoZW5YaWFvU29uZyA8Y2hlbnhpYW9zb25nQGNoZW54aWFvc29uZy5jb20+IHdy
b3RlOg0KPg0KPiBMb29rcyBnb29kIHRvIG1lIHNvIGZhci4gT3RoZXJzIGNhbiBjb250aW51ZSB0
aGUgcmV2aWV3Lg0KPg0KPiBUaGFua3MsDQo+IENoZW5YaWFvU29uZyA8Y2hlbnhpYW9zb25nQGt5
bGlub3MuY24+DQo+DQo+IE9uIDMvMTcvMjYgMTQ6NTIsIFdlcm5lciBLYXNzZWxtYW4gd3JvdGU6
DQo+ID4gc21iX2dyYW50X29wbG9jaygpIGhhcyB0d28gaXNzdWVzIGluIHRoZSBvcGxvY2sgcHVi
bGljYXRpb24gc2VxdWVuY2U6DQo+ID4NCj4gPiAxKSBvcGluZm8gaXMgbGlua2VkIGludG8gY2kt
Pm1fb3BfbGlzdCAodmlhIG9waW5mb19hZGQpIGJlZm9yZQ0KPiA+ICAgICBhZGRfbGVhc2VfZ2xv
YmFsX2xpc3QoKSBpcyBjYWxsZWQuICBJZiBhZGRfbGVhc2VfZ2xvYmFsX2xpc3QoKQ0KPiA+ICAg
ICBmYWlscyAoa21hbGxvYyByZXR1cm5zIE5VTEwpLCB0aGUgZXJyb3IgcGF0aCBmcmVlcyB0aGUg
b3BpbmZvDQo+ID4gICAgIHZpYSBfX2ZyZWVfb3BpbmZvKCkgd2hpbGUgaXQgaXMgc3RpbGwgbGlu
a2VkIGluIGNpLT5tX29wX2xpc3QuDQo+ID4gICAgIENvbmN1cnJlbnQgbV9vcF9saXN0IHJlYWRl
cnMgKG9waW5mb19nZXRfbGlzdCwgb3IgZGlyZWN0IGl0ZXJhdGlvbg0KPiA+ICAgICBpbiBzbWJf
YnJlYWtfYWxsX2xldklJX29wbG9jaykgZGVyZWZlcmVuY2UgdGhlIGZyZWVkIG5vZGUuDQo+ID4N
Cj4gPiAyKSBvcGluZm8tPm9fZnAgaXMgYXNzaWduZWQgYWZ0ZXIgYWRkX2xlYXNlX2dsb2JhbF9s
aXN0KCkgcHVibGlzaGVzDQo+ID4gICAgIHRoZSBvcGluZm8gb24gdGhlIGdsb2JhbCBsZWFzZSBs
aXN0LiAgQSBjb25jdXJyZW50DQo+ID4gICAgIGZpbmRfc2FtZV9sZWFzZV9rZXkoKSBjYW4gd2Fs
ayB0aGUgbGVhc2UgbGlzdCBhbmQgZGVyZWZlcmVuY2UNCj4gPiAgICAgb3BpbmZvLT5vX2ZwLT5m
X2NpIHdoaWxlIG9fZnAgaXMgc3RpbGwgTlVMTC4NCj4gPg0KPiA+IEZpeCBieSByZXN0cnVjdHVy
aW5nIHRoZSBwdWJsaWNhdGlvbiBzZXF1ZW5jZSB0byBlbGltaW5hdGUgDQo+ID4gcG9zdC1wdWJs
aXNoDQo+ID4gZmFpbHVyZToNCj4gPg0KPiA+IC0gU2V0IG9waW5mby0+b19mcCBiZWZvcmUgYW55
IGxpc3QgcHVibGljYXRpb24gKGZpeGVzIE5VTEwgZGVyZWYpLg0KPiA+IC0gUHJlYWxsb2NhdGUg
bGVhc2VfdGFibGUgdmlhIGFsbG9jX2xlYXNlX3RhYmxlKCkgYmVmb3JlIG9waW5mb19hZGQoKQ0K
PiA+ICAgIHNvIGFkZF9sZWFzZV9nbG9iYWxfbGlzdCgpIGJlY29tZXMgaW5mYWxsaWJsZSBhZnRl
ciBwdWJsaWNhdGlvbi4NCj4gPiAtIEtlZXAgdGhlIG9yaWdpbmFsIG1fb3BfbGlzdCBwdWJsaWNh
dGlvbiBvcmRlciAob3BpbmZvX2FkZCBiZWZvcmUNCj4gPiAgICBsZWFzZSBsaXN0KSBzbyBjb25j
dXJyZW50IG9wZW5zIHZpYSBzYW1lX2NsaWVudF9oYXNfbGVhc2UoKSBhbmQNCj4gPiAgICBvcGlu
Zm9fZ2V0X2xpc3QoKSBzdGlsbCBzZWUgdGhlIGluLWZsaWdodCBncmFudC4NCj4gPiAtIFVzZSBv
cGluZm9fcHV0KCkgaW5zdGVhZCBvZiBfX2ZyZWVfb3BpbmZvKCkgb24gZXJyX291dCBzbyB0aGF0
DQo+ID4gICAgdGhlIFJDVS1kZWZlcnJlZCBmcmVlIHBhdGggaXMgdXNlZC4NCj4gPg0KPiA+IFRo
aXMgYWxzbyByZXF1aXJlcyBzcGxpdHRpbmcgYWRkX2xlYXNlX2dsb2JhbF9saXN0KCkgdG8gdGFr
ZSBhIA0KPiA+IHByZWFsbG9jYXRlZCBsZWFzZV90YWJsZSBhbmQgY2hhbmdpbmcgaXRzIHJldHVy
biB0eXBlIGZyb20gaW50IHRvIA0KPiA+IHZvaWQsIHNpbmNlIGl0IGNhbiBubyBsb25nZXIgZmFp
bC4NCj4gPg0KPiA+IEZpeGVzOiBlMmYzNDQ4MWIyNGQgKCJjaWZzZDogYWRkIHNlcnZlci1zaWRl
IHByb2NlZHVyZXMgZm9yIFNNQjMiKQ0KPiA+IEZpeGVzOiAxZGZkMDYyY2FhMTYgKCJrc21iZDog
Zml4IHVzZS1hZnRlci1mcmVlIGJ5IHVzaW5nIGNhbGxfcmN1KCkgDQo+ID4gZm9yIG9wbG9ja19p
bmZvIikNCj4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiA+IFNpZ25lZC1vZmYtYnk6
IFdlcm5lciBLYXNzZWxtYW4gPHdlcm5lckB2ZXJpdnVzLmNvbT4NCg0KDQoNCi0tDQpUaGFua3Ms
DQoNClN0ZXZlDQo=
