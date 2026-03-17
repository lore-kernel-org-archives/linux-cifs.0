Received: from SY2PR01CU004.outbound.protection.outlook.com (mail-australiaeastazon11021072.outbound.protection.outlook.com [40.107.39.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C460392C55;
	Tue, 17 Mar 2026 21:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.39.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773783345; cv=fail; b=LcwuMP9KHuqNJtu2nAZNjzy0mjAcXmFdfemGK4SIdYv5s0sWoZJ9otLn0Ava93F8yh9TNX3WJOPJzMgvOLboik/aGppNTbkCGcxA5O74gr/nDC7Nuvkrh0z9RO8uU5fqYJdvf631QgZC9GJ9Fo1lAciqKYIDXV6C59lyuZmML6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773783345; c=relaxed/simple;
	bh=Yiuw2nEmkM/FYzQxzSCWeHbGCLpzkU2/1c+JAMBAYnQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Zj7pxIWORHFE/8NIxMMbuFSisuftwMtdJh8ZNoo89s78KERJUAMN0nAXENNyk5517KCXVL1MB0x+urA3WOndH1MdGorV/sEYXXgoPYrMAgOHieKnT/4JWEthX39+CrF8VCJo4scufzhfdJuhKOz3cFaF4QevFbfMCrLiUiseUpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verivus.com; spf=pass smtp.mailfrom=verivus.com; dkim=pass (2048-bit key) header.d=verivus.com header.i=@verivus.com header.b=jQ2zICLp; arc=fail smtp.client-ip=40.107.39.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verivus.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verivus.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=verivus.com header.i=@verivus.com header.b="jQ2zICLp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f8UyM1+jo7hgdzdOdFtWT9T+TfhOtB4btxURSRlTwJ13b6dI+Aa2m8JzYMubVM2mVxgXBxZPTPTF1RGBfWqCgrnMkzo5l61lXZylwCKUe2XZHjZMSO/Cua4alWteQM3KQOn/J+7yl7v7Zr5ZlwZVdoz/9Jkvcy0DxbyA6shEJ9Fi6Np88zvOh9XaBy3tW4JWmuSiLw9bsWnL1/btNukPZ1e+hz5mk9OGMbfAwkaL8GIwfy2cKiLf0ea9rd422ugUz8BEbMHCVkg1JOmGDGk47tBtPeqNCW31gf/ssF865b8PGS09BijybSzUlZPfwsv37iZ+aKAw8sdxeIn4hyMCzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yiuw2nEmkM/FYzQxzSCWeHbGCLpzkU2/1c+JAMBAYnQ=;
 b=MECl1XPqL4mOYOQXzPW6hPTUHnj3wmZLkfvtRT+kn+ZNV6RNiTtMtAO6TwUWq+pFFHTDaWNnsm2PfxXv7WxkZenRq7F2Iu3joKPaSVzMMDamRvbugXVh/JPPp0nqu5ECr/xL7iQ5XricDPK5RM7sm6h6m1BrG05oXPbLlgZa0i7mOHs/6WNDe5FKht3hCcbdPy1q4qoR7ukYgMGYkOBrFxZRt2Lr5GsL7eCGs6Zt4JZQQhplA+R8nQrfk4RZ8q6uK2ymiqJ/HndUKMfY6I/VZbbqMvf8YEFfHKh7siSUx5ZQV3rfvtHxvwwfIyXCqbm5XVaMmy4lq4j0pATyy5Kx0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=verivus.com; dmarc=pass action=none header.from=verivus.com;
 dkim=pass header.d=verivus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verivus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yiuw2nEmkM/FYzQxzSCWeHbGCLpzkU2/1c+JAMBAYnQ=;
 b=jQ2zICLpMSQirJ0RBspVm6rakg/SsIsWsnV650wqF+XR5FR5PPGaHzdbqZr3GhDQfFAC0tGQIu20lIdOumVGwuyrGcuuWtzp2Yqe13KbN5KhXew3aRxqr/1nw4+MPX7FtSXFbHYHURcourkK0yP++zHKLwlI2DUYtw57r0ErkE3SNEyMzEzd1sfPhHG9o9TMA4//OQaTZuZ4qobt3pkxF33j76Sy6H1AMENbJc2N7j2pCxA6xq3UvzdQhhrSZYOfBaV+85X2EVuhmtka3k0nF9COCmUlgZv/u4Y5CMff6K9nEevIVyDrtUC4S4flbFPwXZp36zTgru8q61bgiu0hgg==
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM (2603:10c6:220:22a::5)
 by ME0P300MB1376.AUSP300.PROD.OUTLOOK.COM (2603:10c6:220:24a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Tue, 17 Mar
 2026 21:35:38 +0000
Received: from ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2]) by ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM
 ([fe80::1e3f:9cb9:4a95:b5a2%5]) with mapi id 15.20.9723.018; Tue, 17 Mar 2026
 21:35:38 +0000
From: Werner Kasselman <werner@verivus.com>
To: Steve French <smfrench@gmail.com>, ChenXiaoSong
	<chenxiaosong@chenxiaosong.com>
CC: Namjae Jeon <linkinjeon@kernel.org>, Sergey Senozhatsky
	<senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] ksmbd: fix memory leaks and NULL deref in smb2_lock()
Thread-Topic: [PATCH v2] ksmbd: fix memory leaks and NULL deref in smb2_lock()
Thread-Index: AQHctfL97tBqj4F1oEO2D0vU5/26+rWykQUAgACrLgCAAAODoA==
Date: Tue, 17 Mar 2026 21:35:38 +0000
Message-ID:
 <ME0P300MB0853D7D1495A6E07EF120724BD41A@ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM>
References: <20260317094653.2236624-1-werner@verivus.com>
 <02e11b2c-a472-46ac-95a4-ffe7013c3133@chenxiaosong.com>
 <CAH2r5mvCJW4tNhbDRMCuAZOfzrS2FKusiRY3ym-0dF4PfT8c=Q@mail.gmail.com>
In-Reply-To:
 <CAH2r5mvCJW4tNhbDRMCuAZOfzrS2FKusiRY3ym-0dF4PfT8c=Q@mail.gmail.com>
Accept-Language: en-AU, en-AT, en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=verivus.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ME0P300MB0853:EE_|ME0P300MB1376:EE_
x-ms-office365-filtering-correlation-id: 16775077-c854-4d2d-6ad3-08de846d21a7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|38070700021|22082099003|56012099003|18002099003|83080400003;
x-microsoft-antispam-message-info:
 UOdZc9YGPEdPHkVL8MiASbgUzSBiX8BLNG3O25tFtQglimPfdNmZixKJSUCTo1iXaX8eWTPc6WIAHN7zHMIJejN/Ymb/ika0UUQUByfgt88K0h53DqruBJwVOG4tOtold0Zr9+94mF2p9kRtdWhIe208pTMUOEDKQh1KVM8a+IL0/3v7kBOT2QmZB2iRzjQJBqR4vOMjiClWg4BNCyN7ar8DPfDcm9QWLivkmRopjpEu/eiu1fuG+hdlO8nHpwfReqOuIsxBhrOvKqd1dGxd3xpX23x6/NQS+EAsGtR17JkogJYb1f5i8il85qPhhmlTLf6rQzOF6vqxvlgbNqkhy7/aq6EnymcxfbFSiYIDoE2f9aB4P8/nL3lWoiFHIAnlTFAnlgTCndx2nzpEj4kFzlloGlJRNjWoQ3RKZqpst37l2UHMIhA2PJIQGPNbHzVPGQSoN1SbShQ6wnj0+alx3+9/nJSOambgsiICG9Rhpp9NJJ+RoF1lEXrmDRaye88IEWClgVQi6zjsrO1d/+HxpgRumeABsW5nG/iv+lJBrV7Oa/Wrd0BH3udQOTIOWtKZx7XIXwTnttRfspw5LZLtKYeWg4APtZ97CwKDwAGifiXR7LfenYMHBy5vazgdzOZd3ASeBFHRAF9gSj4Z7EWVB6W2bWkvDiQfzDswLnMOQQ9bS4XUAB1+l+P3pJkXZismV+0gFZ56n4Yx7CcA8hBJi3fd9MJtsWy2TxxiuCrYmM6w9A9+9/OrwNilr/MLzY+r7UaulM/Ykq0CFO5eY5tv5g==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ME0P300MB0853.AUSP300.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700021)(22082099003)(56012099003)(18002099003)(83080400003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MnpHUTkwVHY0a20rQkJGSUtNT1pkM0ZUNG84R2xONU5wS3IwbDdNc3RocUtS?=
 =?utf-8?B?Z1JTeGEwdXBFdDNueEVTaUJyaEV3RVpwcnJ4SEsxUjBpd0VQeHEzN3JFRmZk?=
 =?utf-8?B?R0tmeCtES0tFRk11NUZoYlh4bjVqSk00M2pYMEF4TkN3MS85ektCK2p0cWZE?=
 =?utf-8?B?ZGtSOUVZNTlZeUhJKzlNaXJFRFRvYUZVMkU3WWtpbGJPbTUzclJjOHRmeUNG?=
 =?utf-8?B?QTBZS1VCeXVxK0RITjZsMjdIZE15NktndXF3MWdRUTZ2VTl2TDJYaS9HREg4?=
 =?utf-8?B?QlBiTVBLRzVkSWhSUmplQTB5OFVFTm8xUXdZYkEvM0xKOEpFUlVWNDlNcXNs?=
 =?utf-8?B?bnp6L3ZYckQ2bzVnKzhSVnEzWFFHM3lFN3I1R3JXMXV2V1pwTGllSFhpak9L?=
 =?utf-8?B?eXluTFN0bGhHVVQ5bGJPaVhLYWRvdkR6bXd4empnUm0rcUF1M1d0ZzQ4bnd4?=
 =?utf-8?B?SnBCajRmc0tXKzZnM2dSemRwdUw3R0h1dUcvODR1Rkd1WldVajJEbXZDajVn?=
 =?utf-8?B?UGpud0JMcHdOK2VBd0JjUEFDWGE0LzRiaXN4b3RKS3B0c2VkNjhjZk1MTW1q?=
 =?utf-8?B?YjNLUThLUzZwMDRvTDhqRWQ2NXdPUGp0WmFaZ3d3MmtIYXV1aWhXcXZ2ekhO?=
 =?utf-8?B?MC9jZXFoeHg4RHhEOG00bnNzZmtHQ2N4ekRXRStVQzZTaUZxSi94K2hoc1pK?=
 =?utf-8?B?MUx2ZENaZEwwUWRudjkyZUZrcStTVXlvUlF5cGJMOXl5bG9oNTM1SHJjWUpH?=
 =?utf-8?B?aEt6NFZGNWxXdFluSFc3MHI3OUUrR1JSY1AxbDd6TDZETTZnODFMU1JySFFL?=
 =?utf-8?B?ZnZDaFhxbjdpQi8vbTgycVVTV0w4NWIwY3lzZ0ZEYzZaLzFFQkFkY29NdWNu?=
 =?utf-8?B?cmJqUm5XNE1SMVcyamtFQzNOQVJNamVXZmRJY2MwNmc4Wjd4TXp6Qlh2RlRy?=
 =?utf-8?B?anV3ZUJoa0hSU3VsU0hQNUpMUXAvOUdiRkxSS2lzdVFNSEJWN2U2UEFHSnBF?=
 =?utf-8?B?dzVXLzdLcTVYbzhudEZ4b3l4YTF1U2o0aG4zZzJQd1hXVmlPWEZwUDdNTnlw?=
 =?utf-8?B?aWxqMFFGQTNlZXlBcmY1UnFxOW5oRUMvTThyZjFFSld1Vi9UMVJtMDhTdDY3?=
 =?utf-8?B?RXFZcUpIRUlia1lNMlh2YUk2UXphdG1hajdtSFdGRys5T3JOaTArME1sQlRw?=
 =?utf-8?B?SURWYjFNRlRFRFA3OEhTczYrKzRkMlFpbkxoSkVHY0FMK3VJd0JvZ3hUeUY5?=
 =?utf-8?B?L3Zvd1o1Ty92RWhYdCtzbTh6Wk1JVkxiRHhOY0d4ME5yZVNjV2U0SjN5TmQy?=
 =?utf-8?B?SGdlMU8wQlNjZjlWOWNWM2NNSVZMMzNLQVBWZXliSnJqeFBIaFdKWEpuSzlQ?=
 =?utf-8?B?c21vam0xOTNzZ2dJYnRJbjkxK2VtNnBWQ1o0UE5EN0I4Sytnb1pJSFN6b2pS?=
 =?utf-8?B?OWxsYTBhYUg0eWZvckI1Y0FRKzYxQ1ZYR3AxaGZuWDhHNHVwWE80WFB6MXU1?=
 =?utf-8?B?dFZUK0JsV2ZUaWxSdDRyemRSMnZTRXVVaGxxQU9PaVdnWVA0L1JKVTgwZk5r?=
 =?utf-8?B?YlhGZU9Mb25Fd1B0dXVzOHNCekgxTkM0emFsNXpJRGNDL2dlMmJrU2J6VnA1?=
 =?utf-8?B?V09XVDlWNURBU2dqMmRaWDdXQWMxY0ZjOGtVUkFaczJ4cVY0SjhOYkZGVE5n?=
 =?utf-8?B?NHVoWDBYL3luMXBEVXB5SXAvYnEyYmJVTjVMZmI1Q3JYelEyTUNheHdOdW9q?=
 =?utf-8?B?dkEzL2pQZCsyckVPaXJXbGRRL2lidWswZnB0UWR3VWI3MDJUMmFsWmZxNWpv?=
 =?utf-8?B?TFZ2NWJSSVVmZHRZUzZxZWZPeDl6YUdPTmV3L0xKdmZwNWE1c1BDVzE1b1Ni?=
 =?utf-8?B?NnJwMHlBb3FzaE54NkcwNmg0YjRJT1NwbkJMSTJNdnAzeUdIMi9FTHBXQlE4?=
 =?utf-8?B?a2RIVnRiN2Z6NHdENUh4VUc2a1EzWnVyL0o4dnlDQzlPWmhMVDZHb2ExRDFI?=
 =?utf-8?B?SDFNWnhnNEN6Z2VMMGJjdkhlaE5yWExBUGVOeHNTWTRhRytlM0N3VDlYWUtF?=
 =?utf-8?B?cmFCUjZYaWxDNlBkUUZpNnhVTW1KZUJGelRhYVp3bjM0WkdnNDRPTWU2SFlY?=
 =?utf-8?B?VlBxaFIwRjFhTHRQZ1EvYW9oOHZpVllld1lWL0FBaCtkSk90U2NhclYyYUVm?=
 =?utf-8?B?L2NPRVh2aDI4RzVUazQrVElHS1FlalJ0YnY3bXQ3RkYxVVl6MXdxdzh6VnVZ?=
 =?utf-8?B?V2pUNU5NY3lad1ROdWdvMEJHM1hNMWt5RnBXcXR1MmI4UUgrV0dGdDQxTmln?=
 =?utf-8?Q?hsHdwiosX/M/BMcwbZ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 16775077-c854-4d2d-6ad3-08de846d21a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2026 21:35:38.3721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: ccdcedb0-4edc-4cc8-9791-c44ee6610030
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5AZNqC5eIlyiFVeglkUeBnsBhCrydRSSfhqvsR2w29zbDblG8A7CsugskEdoq1+DHL3JhKjzkjBCFd1Lx2l2yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ME0P300MB1376

SGkgU3RldmUsDQoNClRoZSBTYXNoaWtvIHJldmlldyBjb25maXJtcyB0aGUgcGF0Y2ggYWRkcmVz
c2VzIGl0cyBzdGF0ZWQgZ29hbHMuDQpUaGUgb25lIHF1ZXN0aW9uIGl0IHJhaXNlczoNCg0KV2hl
dGhlciB0aGUgYXN5bW1ldHJ5IGJldHdlZW4gVU5MT0NLIGFuZCBub24tVU5MT0NLIGVycm9yIGhh
bmRsaW5nIGFsaWducyB3aXRoIHRoZSBTTUIyIHNwZWNpZmljYXRpb24uDQoNClRoaXMgYXN5bW1l
dHJ5IGlzIHByZS1leGlzdGluZyBiZWhhdmlvciDigJQgbm9uLUVOT0VOVCB1bmxvY2sgZXJyb3Jz
ICAgYXJlIHNpbGVudGx5IHNraXBwZWQgaW4gdGhlIGN1cnJlbnQgY29kZS4gVGhpcyBwYXRjaCBw
cmVzZXJ2ZXMgdGhhdCBiZWhhdmlvcjsgaXQgb25seSBmaXhlcyB0aGUgcmVzb3VyY2UgbGVha3Mg
YW5kIE5VTEwgZGVyZWYgb24gdGhlIGVycm9yIHBhdGhzLiBUaGUgVU5MT0NLL25vbi1VTkxPQ0sg
ZGlmZmVyZW5jZSB3b3VsZCBiZSBhIHNlcGFyYXRlIGRpc2N1c3Npb24gaWYgaXQgbmVlZHMgY2hh
bmdpbmcuDQoNCldlcm5lcg0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogU3Rl
dmUgRnJlbmNoIDxzbWZyZW5jaEBnbWFpbC5jb20+IA0KU2VudDogV2VkbmVzZGF5LCAxOCBNYXJj
aCAyMDI2IDc6MjIgQU0NClRvOiBDaGVuWGlhb1NvbmcgPGNoZW54aWFvc29uZ0BjaGVueGlhb3Nv
bmcuY29tPg0KQ2M6IFdlcm5lciBLYXNzZWxtYW4gPHdlcm5lckB2ZXJpdnVzLmFpPjsgTmFtamFl
IEplb24gPGxpbmtpbmplb25Aa2VybmVsLm9yZz47IFNlcmdleSBTZW5vemhhdHNreSA8c2Vub3po
YXRza3lAY2hyb21pdW0ub3JnPjsgVG9tIFRhbHBleSA8dG9tQHRhbHBleS5jb20+OyBsaW51eC1j
aWZzQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgc3RhYmxl
QHZnZXIua2VybmVsLm9yZw0KU3ViamVjdDogUmU6IFtQQVRDSCB2Ml0ga3NtYmQ6IGZpeCBtZW1v
cnkgbGVha3MgYW5kIE5VTEwgZGVyZWYgaW4gc21iMl9sb2NrKCkNCg0KSSBzZWUgdGhhdCBTYXNo
aWtvIGhhZCBBSSByZXZpZXcgY29tbWVudHMgb24gdGhlIHBhdGNoOg0KDQpodHRwczovL3Nhc2hp
a28uZGV2LyMvcGF0Y2hzZXQvMjAyNjAzMTcwOTQ2NTMuMjIzNjYyNC0xLXdlcm5lciU0MHZlcml2
dXMuY29tDQoNCk9uIFR1ZSwgTWFyIDE3LCAyMDI2IGF0IDY6MTDigK9BTSBDaGVuWGlhb1Nvbmcg
PGNoZW54aWFvc29uZ0BjaGVueGlhb3NvbmcuY29tPiB3cm90ZToNCj4NCj4gTG9va3MgZ29vZC4g
RmVlbCBmcmVlIHRvIGFkZDoNCj4gUmV2aWV3ZWQtYnk6IENoZW5YaWFvU29uZyA8Y2hlbnhpYW9z
b25nQGt5bGlub3MuY24+DQo+DQo+IE9uIDMvMTcvMjYgMTc6NDYsIFdlcm5lciBLYXNzZWxtYW4g
d3JvdGU6DQo+ID4gc21iMl9sb2NrKCkgaGFzIHRocmVlIGVycm9yIGhhbmRsaW5nIGlzc3VlcyBh
ZnRlciBsaXN0X2RlbCgpIA0KPiA+IGRldGFjaGVzIHNtYl9sb2NrIGZyb20gbG9ja19saXN0IGF0
IG5vX2NoZWNrX2NsOg0KPiA+DQo+ID4gMSkgSWYgdmZzX2xvY2tfZmlsZSgpIHJldHVybnMgYW4g
dW5leHBlY3RlZCBlcnJvciBpbiB0aGUgbm9uLVVOTE9DSw0KPiA+ICAgICBwYXRoLCBnb3RvIG91
dCBsZWFrcyBzbWJfbG9jayBhbmQgaXRzIGZsb2NrIGJlY2F1c2UgdGhlIG91dDoNCj4gPiAgICAg
aGFuZGxlciBvbmx5IGl0ZXJhdGVzIGxvY2tfbGlzdCBhbmQgcm9sbGJhY2tfbGlzdCwgbmVpdGhl
ciBvZg0KPiA+ICAgICB3aGljaCBjb250YWlucyB0aGUgZGV0YWNoZWQgc21iX2xvY2suDQo+ID4N
Cj4gPiAyKSBJZiB2ZnNfbG9ja19maWxlKCkgcmV0dXJucyAtRU5PRU5UIGluIHRoZSBVTkxPQ0sg
cGF0aCwgZ290byBvdXQNCj4gPiAgICAgbGVha3Mgc21iX2xvY2sgYW5kIGZsb2NrIGZvciB0aGUg
c2FtZSByZWFzb24uICBUaGUgZXJyb3IgY29kZQ0KPiA+ICAgICByZXR1cm5lZCB0byB0aGUgZGlz
cGF0Y2hlciBpcyBhbHNvIHN0YWxlLg0KPiA+DQo+ID4gMykgSW4gdGhlIHJvbGxiYWNrIHBhdGgs
IHNtYl9mbG9ja19pbml0KCkgY2FuIHJldHVybiBOVUxMIG9uDQo+ID4gICAgIGFsbG9jYXRpb24g
ZmFpbHVyZS4gIFRoZSByZXN1bHQgaXMgZGVyZWZlcmVuY2VkIHVuY29uZGl0aW9uYWxseSwNCj4g
PiAgICAgY2F1c2luZyBhIGtlcm5lbCBOVUxMIHBvaW50ZXIgZGVyZWZlcmVuY2UuICBBZGQgYSBO
VUxMIGNoZWNrIHRvDQo+ID4gICAgIHByZXZlbnQgdGhlIGNyYXNoIGFuZCBjbGVhbiB1cCB0aGUg
Ym9va2tlZXBpbmc7IHRoZSBWRlMgbG9jaw0KPiA+ICAgICBpdHNlbGYgY2Fubm90IGJlIHJvbGxl
ZCBiYWNrIHdpdGhvdXQgdGhlIGFsbG9jYXRpb24gYW5kIHdpbGwgYmUNCj4gPiAgICAgcmVsZWFz
ZWQgYXQgZmlsZSBvciBjb25uZWN0aW9uIHRlYXJkb3duLg0KPiA+DQo+ID4gRml4IGNhc2VzIDEg
YW5kIDIgYnkgaG9pc3RpbmcgdGhlIGxvY2tzX2ZyZWVfbG9jaygpL2tmcmVlKCkgdG8gDQo+ID4g
YmVmb3JlIHRoZSBpZighcmMpIGNoZWNrIGluIHRoZSBVTkxPQ0sgYnJhbmNoIHNvIGFsbCBleGl0
IHBhdGhzIA0KPiA+IHNoYXJlIG9uZSBmcmVlIHNpdGUsIGFuZCBieSBmcmVlaW5nIHNtYl9sb2Nr
IGFuZCBmbG9jayBiZWZvcmUgZ290byANCj4gPiBvdXQgaW4gdGhlIG5vbi1VTkxPQ0sgYnJhbmNo
LiAgUHJvcGFnYXRlIHRoZSBjb3JyZWN0IGVycm9yIGNvZGUgaW4gYm90aCBjYXNlcy4NCj4gPiBG
aXggY2FzZSAzIGJ5IHdyYXBwaW5nIHRoZSBWRlMgdW5sb2NrIGluIGFuIGlmKHJsb2NrKSBndWFy
ZCBhbmQgDQo+ID4gYWRkaW5nIGEgTlVMTCBjaGVjayBmb3IgbG9ja3NfZnJlZV9sb2NrKHJsb2Nr
KSBpbiB0aGUgc2hhcmVkIGNsZWFudXAuDQo+ID4NCj4gPiBGb3VuZCB2aWEgY2FsbC1ncmFwaCBh
bmFseXNpcyB1c2luZyBzcXJ5Lg0KPiA+DQo+ID4gRml4ZXM6IGUyZjM0NDgxYjI0ZCAoImNpZnNk
OiBhZGQgc2VydmVyLXNpZGUgcHJvY2VkdXJlcyBmb3IgU01CMyIpIA0KPiA+IENjOnN0YWJsZUB2
Z2VyLmtlcm5lbC5vcmcNCj4gPiBTdWdnZXN0ZWQtYnk6IENoZW5YaWFvU29uZzxjaGVueGlhb3Nv
bmdAa3lsaW5vcy5jbj4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBXZXJuZXIgS2Fzc2VsbWFuPHdlcm5l
ckB2ZXJpdnVzLmNvbT4NCj4gPiAtLS0NCj4gPiAgIGZzL3NtYi9zZXJ2ZXIvc21iMnBkdS5jIHwg
MjcgKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tDQo+ID4gICAxIGZpbGUgY2hhbmdlZCwgMTgg
aW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMoLSkNCj4NCg0KDQotLQ0KVGhhbmtzLA0KDQpTdGV2
ZQ0K
