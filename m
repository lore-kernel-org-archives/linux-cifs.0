Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11022108.outbound.protection.outlook.com [40.107.209.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADBC16A956
	for <linux-cifs@vger.kernel.org>; Tue, 24 Feb 2026 04:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771908996; cv=fail; b=Bx+3JVTyIM6AzwLr13V9xiGWmmeIa08jQ4UNq0CwZjfe9OigF0vo0iM772TULlWrp9pmgMNggXMvWy2/lXyMbOfQQuuPa0onZg6w+KZlim3Zk60Lt4e0GMHwO0UhOFJI0AdBF5cQ+o7mZGa6VxKgm2N5Ac0Y7HVRXzMWd45gNEw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771908996; c=relaxed/simple;
	bh=qirhzmcMN6PmPfdcg5CKYf+/hB+2/2vBdSXYK5QOFtM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kRsfae+P7QNzxhue79oNPdv2EBLfyh6M/Lt0oLtzOKlEec7NrlBUiOg9wL3o+PKHQHnHJsZ9sBYn0+h015NVRHuSeojQeDGUAorl3msUtYuO0UaUDEg6vfGLAAgU4jd2+s9jqYKRLCG/CfVF15Y688+q5BNTbwynxqZ/vGMahgM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=capps.com; spf=pass smtp.mailfrom=capps.com; dkim=pass (2048-bit key) header.d=capps.com header.i=@capps.com header.b=G9ete2kv; arc=fail smtp.client-ip=40.107.209.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=capps.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=capps.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=capps.com header.i=@capps.com header.b="G9ete2kv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y+2OhTuZPGqsDHhW+Cs+4qIEipGyIgpMjyZTL1U8wH0JHD621wZmI4Zsj8WBI7M10LjeBw7mxFmHybaIe9/ndiCWc3prpIWPsljdhtAhtDXOKDId1DdAPORy0m9IYUYZi1XnXptsrpb5QiHnIFYDUop1kFsdoi07FY4N5dmRGSdIXIZmxUFs1D1RS0RbCyx9Na2fZhtbXHwXwywsFdreKFiq761Dmxfh0tjP7LP1TNne4kbXCG661W+wigUwxrq2nxSVCBJ/V5pj1dveJ2i8b+7NEizuhS5AVmg5RpzxDegq1S6oQnsvNLu9Zx1zW/3YiplrQoTd6y7B4irathfmFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qirhzmcMN6PmPfdcg5CKYf+/hB+2/2vBdSXYK5QOFtM=;
 b=nIjsMU5ShYnqTuVZHAuJ3UkN5EtKvYLdO5yHOOd9IGh+V6tx1LDLbvNgEu20FJGC8gMYZyGST7TAYUUynHY/bGtuC9V9zwO5e+zOxhVjWb5JE37MOWDi4YcfpqXyca/CVcb6gk3UQ/r7Pi8Z5thOmUKyWA7zv42ebCE4Z4yDSrRVZFbXikNsyMZ7yA40b8jGs/VStUB6Rk1BYkMESCNY2Nm7nDh/nR1MhTvDjQ4bQsfHLDjzyN/Bhp6jEUC60PgjYILUNbQYBLEZJaTWZb8zEo9pJK9dkD/hSu5o61wSGP0Nqr5JTlURcTJ6fStS0GGN8S/Ks+0uA2sOjPX7bXS6PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=capps.com; dmarc=pass action=none header.from=capps.com;
 dkim=pass header.d=capps.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=capps.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qirhzmcMN6PmPfdcg5CKYf+/hB+2/2vBdSXYK5QOFtM=;
 b=G9ete2kvlhmIhGemAyCeo6VuytY/bFxppiKuuOfaFiuROzphGY84/u/RN1HCM2wDk7+K5dwIpjWHRwl+0rWH1na76VBr3mFafHZj4NyhcigYUZwQlgF+1aI9l6Ne8Vuxg5rjz49xuq1uqH2oMcpCKDVOvz7iyTXC//tlMmKuSUzreBzBBpzPFQss3aAwJuEGKJrjJNIdf5z99355aUgluueY1ZQUKhi8tf9AeDvbtNzeZ/cqCIdeX9fiOPEzzThhDVqTD9J7S0sbItxCnZbqX28AaKyFhLVhzqo8t72lIVfN9IqVI6Igoc+p/+UnhoNYBH2Fg6P4Ay6ZWUD5/e00Fg==
Received: from BY1PR22MB5437.namprd22.prod.outlook.com (2603:10b6:a03:4b2::12)
 by SJ4PPF338EAB7E5.namprd22.prod.outlook.com (2603:10b6:a0f:fc02::f93) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 24 Feb
 2026 04:56:32 +0000
Received: from BY1PR22MB5437.namprd22.prod.outlook.com
 ([fe80::94e:e368:450c:8eb2]) by BY1PR22MB5437.namprd22.prod.outlook.com
 ([fe80::94e:e368:450c:8eb2%4]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 04:56:32 +0000
From: John Kendall <john@capps.com>
To: Steve French <smfrench@gmail.com>
CC: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: mount.smb3 error 0xc00000bb STATUS_NOT_SUPPORTED
Thread-Topic: mount.smb3 error 0xc00000bb STATUS_NOT_SUPPORTED
Thread-Index: AQHcpQyNzrd99MP1xUKbZU5w3u+JlbWRBceAgABD9wA=
Date: Tue, 24 Feb 2026 04:56:32 +0000
Message-ID: <A1EAC8BE-248A-44E0-A782-EEEE0C28E608@capps.com>
References: <CDC5B65B-2116-4FEF-AF59-AA41DBE2072B@capps.com>
 <CAH2r5mu15UrSSiFu6fvA7t_2KmxZG80o50nqNwr17Afk7_9Svg@mail.gmail.com>
In-Reply-To:
 <CAH2r5mu15UrSSiFu6fvA7t_2KmxZG80o50nqNwr17Afk7_9Svg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=capps.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY1PR22MB5437:EE_|SJ4PPF338EAB7E5:EE_
x-ms-office365-filtering-correlation-id: ad221408-31b9-4714-908f-08de73611464
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?ZDNvQXpPTlJud09BU0dxVWc5UFZtQkwvaTF0d2hwdzlZazdWY3lqbDgzRFpX?=
 =?utf-8?B?OWgrclFqRW5YNUdaMHlHSXd0SjBqdWFCZEM4QjlUbzU5OUhvVFEzWnpGSVB0?=
 =?utf-8?B?TlU4VDYwWWo5UDQ2cmVhcFd3WjRWK3BTWFNWa212MjlwT3RUY0hvUEEzWW1L?=
 =?utf-8?B?TjhjN29CY0R2UlNFOCtwaS81VlBPYW9uNk1UV2loN0g2d1JnNHIrT3hmdzNt?=
 =?utf-8?B?NU9aUzN1dnpCV0hyeXlWcUtRYmZZSWVBYVNxNkpzSlJEQzU4dEhYekVDbVlp?=
 =?utf-8?B?NnpSaUxpdHhnWHZROXlnUEdnM3pTT2RNY1A0VjZHMWJyczV4WWpXendDSVhB?=
 =?utf-8?B?NlVGV1JacS9OTHRGS3BBMU5vdk1NOU9UbFVXNExQcnowczZqY1hEMlNMZytX?=
 =?utf-8?B?NWY0WC9tUVkvQzRXQlRTbkluV3BsaURXeCtVbUhXRkpGZTBlK2NWUXBOVTJp?=
 =?utf-8?B?dmx1NGlrdXNOU1BNZThrRGZFYjVjeDU3S1prNW9oY3RFY1JGN3lWbDVGVWhP?=
 =?utf-8?B?c1dQTTQrWm1DbUk3cmtsWndDWkZjbkE3d29yd21jVktHMXExc0I5UkJlWW9Q?=
 =?utf-8?B?ck9zVnBNQ0U2b0NnRElSWUxxcDQ2a1NvOVQ2WjlLcG5PN2E5VXZQZkZIU0RP?=
 =?utf-8?B?UElTakZlYkdrWUJkSlU3dHBRTnVsczFYSzVHeHFHTURHNHlVcFAxeHR0TTB4?=
 =?utf-8?B?TEE2S3lBODlmV2JYTWlnSkFNTVd3L2NFcUx1L0NmMW9QMk9wVW43Q2tJMDlk?=
 =?utf-8?B?aW5iYUdTM2k4M1phMHh1N0xYWXplejJ0RUl1QUUvdXRQemVQUldjQkp4UzVx?=
 =?utf-8?B?cjRrVVVjelBmckZuL3dNTkR2eGVvcnhMNGZoK3RVcDlsalZNMHpFY2pBYXdw?=
 =?utf-8?B?U3ErNGRRTTZSQUh2WjZ4eWdpMkc5ZndmMGsrVU4xMmJ6VjRQU21OYkgvSDd3?=
 =?utf-8?B?dUpYL0hOK1RCTll6K1BCVFQ3NFJLU1RwN0VmSzgxcVEybWp0UEoyWWpwVGlm?=
 =?utf-8?B?WTlsZGppWjFzVUxFcU9ISTNLWnpLWVFzem1BUXdvMWhkanVVVEt4b2liNTRH?=
 =?utf-8?B?aHhIbWxpd1B0cmFxc0ZpcVZ0RGlGTVo3cExFWHhxYWMxTWFVOHh2NjN1aElL?=
 =?utf-8?B?Q3hzclpQYjF1bWwrOUwxeEYvUkRCNEVWdkFOakhlZGlRSGxEcnNtZTNlSndj?=
 =?utf-8?B?RzFkMVE2WWdKRVovZDQyNGVzRWxmK3M5b1JZUXVoU0srRXgrejhzenNGb3RU?=
 =?utf-8?B?QkhTTUNTR1FRUHh0eUJBb01teEh1L281VGRNMkI5WHQ2ZHF2Mm5vQzk5NTBr?=
 =?utf-8?B?SWxObk96OWdUOFYyNHJFU3JJdzloTGlFV1RWQnpvTTRYL3VBNDNWZktTeXB6?=
 =?utf-8?B?UTBPOENya2ttR1Vyd1Z6UWIxclhiNHZWQTBOdEt5K1lTenRRejlZeU1RWE9a?=
 =?utf-8?B?eXZZZ1NDb0VrZG9CSDU5S0RlSHFJUC83TFJud2RVNWM4cUNTV1cyaVRoMGUr?=
 =?utf-8?B?Qk5kTzFBWU40bDhNVFpnVzExY2V0K0ZMbGZ2U1BnT1pCVEJsclNqQnNSbUV5?=
 =?utf-8?B?WW1EUDAvdVhPYVpHd0lFOFo0UjEzZHhpWG5sZUJ1Z0xmVzdzaFluRlEzMi9y?=
 =?utf-8?B?aVErMXlJMHVCQVBEZk4xZGxua0tYa0hhWXJPRWZ3QXlSbE5SaVU5ejRyTThD?=
 =?utf-8?B?OGpDemZ0UmFMQ1JXR1NrckZwZ2Uxb3YrNlhHWTZUMTFNeHBad1MxOUVPMGtq?=
 =?utf-8?B?K0hKTXdQcDVKVjJQYVQrVTliVFdnMy9mSlJCR2Y2WHVHd3J0MkU0WUo3bThC?=
 =?utf-8?B?My9Gb2RObC8weGo3MjlUbG93VHJXUWo5bnYxQVJDeEFteEhJL29kYUZFbTBk?=
 =?utf-8?B?WXV3clcrQU9Hd1F4SG5NTk9NQnJYN01Ed2Ria0tJQXVjUTh4NWR3eWhpbVdT?=
 =?utf-8?B?U3hZR3RZOFpRbk9qbGtwWmNsSEtKS3F4NlRCNGV6bCtnczQwNFpxamN4eTNn?=
 =?utf-8?B?SThJMHNTdjdJaFVnN0FwM0kxQ0owb0s0NHZjWkdtYjhwZzBjTUN6Y29hTjUy?=
 =?utf-8?B?L3ZXOEcyTEFyQ0h5ZjcreWxCaWwxd3V6MGZOeWdQVk5SZ3ZXaURidlM5VEha?=
 =?utf-8?B?cGhxc3JMTjdOYkVDRjFGRkFuUXJ3Y29IVStMY1RDVndZbnV6NnVSM05venl0?=
 =?utf-8?Q?pFC52AzSsO2qRCNI0Zwr244=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY1PR22MB5437.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TWJIWlJWdndobkFyWVY5U0JhUVNtbjlhV3VuREJ6cFhETTNxZ2t5VXhQWFVF?=
 =?utf-8?B?NTdSVTl2bjNRZHpkckZRSlZzYkxnRXVDYXlibFJrS3lmWXRWVENxUVJENlpw?=
 =?utf-8?B?cVB4R3gwUUV4cXJlbWNjVENYTGpieE1taDhOSDVFUHZPbEx1bzRZVmpxQm10?=
 =?utf-8?B?UnlDb0k4NEhRcU1wd3Z4ME9kSGpldllvejIvQnlGMllCckdKQjkrQyt1d0tl?=
 =?utf-8?B?dzQzbXBRRHljeitzOHZDcFZ4cUNKbUdKenExdUVLODYxSlorc2Q1a0NaK0ty?=
 =?utf-8?B?SC9UTC9nUmtOR0JybTA4dDR5UGdnVE5lUDBDVENsbU9DSVp6V29JcndaTG9p?=
 =?utf-8?B?dk14NnJZU1IxZHNLRW5GOWpQVG5rLzFTMFdvaXF1MUMzNGRkeExIM2tnT2Js?=
 =?utf-8?B?cFFvRXZjbzVWd04vZWdSM0VEUy9XOC9sckpoQ0tYbUlkbDVjOWFzN1EyQldC?=
 =?utf-8?B?ZklpeHI2L1QzY3hDTW1URk9LUEl4ei90b01yU0Nna0VmTkxqT2YwazliaURo?=
 =?utf-8?B?a0VHYVVCWlR3Y3R2SVI4ejZUUStLUmw3L29QRTZCSDgzZnMvNUc0QjlxaXcw?=
 =?utf-8?B?NENKOUUyS3NCS0U4cEVac3pxNjRlaWdPU0FYQVdkYzNTZ0ZWa085L25saHJI?=
 =?utf-8?B?RXZYbU41dGM0SDhrekRYTUxoMForYi9PRDB1MXNSd0xidXFXTjlWQjhEM2Jv?=
 =?utf-8?B?WFY5bjdGSFhvcFBwbUVhcHlLSUdoYm55S3dBS3d3OVRpSXd2WHFHV3hYenFZ?=
 =?utf-8?B?V0htMUZmb3NZbE13bGwrMTdpQ0VscWNhdHpqM3lXS2ZpczErT1JtQlFjNzE2?=
 =?utf-8?B?S3BGdTdmSkt4UTBGbjRtZFd2ai9Pd2xOOFQzL09QK1NFbWpUd293YUtENDFM?=
 =?utf-8?B?Um0vWDhhZnNhZjZ2cWVZSU4ybHRjc1RXM1VFRk9DKzRJNVE2V21LdGRWSURw?=
 =?utf-8?B?cWpnSlhCWCtOL0szSmpwdENKZUhpUHlvdE96UXFVSk5DSndHUTB6WDA2cy9V?=
 =?utf-8?B?YWExT2RPdWdvV1Ztd0VqQlpsUXZxNnhaRjJPem5lempqa2xEUGJFeTZWSjBG?=
 =?utf-8?B?ZTJyNUdEUGRsU2ExTTZHTmRaZnVaYTgrNnV5SDRZV2VOdFRZUUorT0xkMXFI?=
 =?utf-8?B?OEJBd252RVlDVXgzbWtpbGI3ZXEzdVVFOHQ4NHhhd1RxdktoNVNhZkx6U3pU?=
 =?utf-8?B?akRDZzR2Y3FmS0plS3RWNzQzWjh3a1ZGUkVuUlZYWHE1OGROMW0yNkpzNHFJ?=
 =?utf-8?B?cllaYXc1SmtCdFJmMDN3K292eTlpOFZGNENXUDZrQmI5aE1KTWozeitiSHZG?=
 =?utf-8?B?QU5YVXF4Uk1IYUE4ekZHSlEwUHRLREY3cHk0RE5UMU1HMndrZXlia25MSHN0?=
 =?utf-8?B?SFRZUFZFN1ZMREtjcEY3Q3RpN0FtN2pkSjliR29PeEM2M3RCaUxwSDB5bXRv?=
 =?utf-8?B?NElnUzlCT1lsTStpYXhtMjI2TngycmZONXVKZldnYUxsTGpqNmFRZWpuSXBI?=
 =?utf-8?B?dlYvd0dXSEZYdjlXK0VZR2crV2R0MFVnc2JIeFhYclhHQ2NZdllZYWpaQmEv?=
 =?utf-8?B?MDBhZDFWNjR6bUpBbHEydnZVM2lQOElPQmhaV2JlY0lDVm5EQ0lSTjdaWitV?=
 =?utf-8?B?SitBRXhxNGIxSHNHQVJWcDhkUm9oeThwTnVBOWlya2ZHYXlKKytTQmpUMVhp?=
 =?utf-8?B?RFhlRmUreks4RmpmQW1DWGZmRzBLcVY1UVkxT0JyVmc4ckVveGlVRDhYR01x?=
 =?utf-8?B?djBKakkzamFBVyszZzBQSGxVMG5HalpCS01jOGhOTU9BcXVQcVdUNzFaZnh6?=
 =?utf-8?B?WkRPV3dVY0JtM1FzaFh4TGM4REd6T0s2RWRPcWxZNUM5T2svbEhVelpCNG9I?=
 =?utf-8?B?djN3WENFOEU1T1FYaVVCVXJJK01mK3R6aWZLL0lOT25xYWdvYURoU0JiVUdL?=
 =?utf-8?B?ait1dndUSUJpQkw2WDNCVzNJUDdnQVRyZWNIQng5VmZjNjZVZzcxalZ1Tmgw?=
 =?utf-8?B?cXFtOE03aythb0pZM0dRUEpITzlKb3pHVEZxL2xXRHc2bGxkSFowOU5Ddk9s?=
 =?utf-8?B?dlBZTnprYzdOSWtmQ3psM2NPUlJFRldtSUNoWnIxeVFBdUNLMXRhMWNxRkdi?=
 =?utf-8?B?RlpjazV6REJmRk1CNE1nWGpJZmk1c29ZSlM2aDBKMmxrWVJxaW9ndjdieWNV?=
 =?utf-8?B?Zy9ORXRMcjN4SGdjOXlOa2s3eEVTTlBHUUZZZ1B6ckdscU1Id2RIT09rUGNP?=
 =?utf-8?B?L3RLY3E1YlJPNVFUeHAxbWZsUnZGRGd4ZFNKUHJHK1FzVDZ0ZUxuOTdGNHlt?=
 =?utf-8?B?SUF4TUwwREl4Q3U1eE5WSWFzWVhtL2hpbzhONStkbi9ucjhmYWV6UT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <321ADADCBA4E3B46BB0BF8C7B6F2B6E5@namprd22.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: capps.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY1PR22MB5437.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad221408-31b9-4714-908f-08de73611464
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2026 04:56:32.4047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5424fedc-061f-453d-8f8e-1ab52d9fef49
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T2zI7ZSuSkvX5MjnRIAqBGFKyhlvZNag8rmHXSVDZoQBVVrK6zfRAlcCPcxlK9cZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ4PPF338EAB7E5

U3RldmUsDQpUaGUgc2VydmVyIGlzIFdpbmRvd3MgU2VydmVyIDIwMTkuIEkgd2FzIGFibGUgdG8g
ZGV0ZXJtaW5lLCB3aXRoIGEgbG90IG9mIGhlbHAgZnJvbSBQYXVsbywgdGhhdCB0aGUgc2VydmVy
IHdhcyAoc3VkZGVubHkpIG5vdCBhY2NlcHRpbmcgYW55IHZlcnNpb24gb2YgTlRMTSwgbGVhdmlu
ZyBrZXJiZXJvcyBhcyB0aGUgb25seSBvcHRpb24uIEkgd2FzIG5vdCBhd2FyZSBvZiBuZXcgZWZm
b3J0cyB0byBoYXJkZW4gQUQgdGhhdCBpbmNsdWRlcyBzaHV0dGluZyBkb3duIGFsbCBOVExNIGFu
ZCBhbGxvd2luZyBvbmx5IGtlcmJlcm9zLg0KDQpTbyBteSBtb3VudC5jaWZzIGlzc3VlIGlzIHNv
bHZlZC4NCg0KVGhhbmtzLA0KSm9obg0KDQoNCg0KDQoNCj4gT24gRmViIDIzLCAyMDI2LCBhdCA0
OjUz4oCvUE0sIFN0ZXZlIEZyZW5jaCA8c21mcmVuY2hAZ21haWwuY29tPiB3cm90ZToNCj4gDQo+
IFdoYXQgaXMgc2VydmVyIHR5cGU/IElzIGl0IHBvc3NpYmxlIHRoYXQgaXQgaXMgZmFpbGluZyBi
ZWNhdXNlIG9mIEtlcmJlcm9zIHZzIG50bG12Mj8gSGF2ZSB5b3UgY29tcGFyZWQgdGhlIFdpcmVz
aGFyayB0cmFjZSBvZiBzdWNjZXNzIHZzIGZhaWx1cmU/IERvZXMgaXQgd29yayBmaW5lIHRvIHlv
dXIgc2VydmVyIHdpdGggYSBtb2Rlcm4gY2xpZW50ICg1LjE0IGtlcm5lbCBpcyBmaXZlIHllYXJz
IG9sZCk/IERpZCBpdCB1c2VkIHRvIHdvcmsgb24geW91ciBjbGllbnQgYW5kIHJlY2VudCBzdGFi
bGUga2VybmVsIHBhdGNoIHJlZ3Jlc3MgaXQ/DQo+IA0KPiBUaGFua3MsDQo+IA0KPiBTdGV2ZQ0K
DQo=
