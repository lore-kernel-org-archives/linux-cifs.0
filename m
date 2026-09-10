Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazolkn19010004.outbound.protection.outlook.com [52.103.32.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFAF4BFE85;
	Thu, 10 Sep 2026 00:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.32.4
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788999690; cv=fail; b=dS05f0I/BD6esUGfs43t720vwdaaCcvyMmpUXn6RiDFycReAhXWYxLcOCyBsEWizp7V8VxD6rgqXx+lX0AhsQbR6ainKMI+GDMoQV7hCcuTDJdXJroEq415bNfDhD1xr6eYiRntcmEItK2TUhwaYczy1gFRJY2AGN28rXBzJmpk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788999690; c=relaxed/simple;
	bh=UogbowRpOA5Zb0cRMGXh8KnD+g40QbkugWOWrfF3CVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b1WXNtMtgUTFVPHXsN1QyQqn/kjry3afi04C8TPTEcdotnpVU1VF0ttqQ2w6E8f9Hlo+uFo0oWb5r2xwg7d62q0QVs8f6Ji23VwMGpPH7w44OXfd/pKb027AgNE2BBRoCp21ox1FW56qSplrMmuV7yCCbPAeUSVYuEuGH+p7PBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk; spf=pass smtp.mailfrom=hotmail.co.uk; dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b=t54vhIt3; arc=fail smtp.client-ip=52.103.32.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=HOTMAIL.CO.UK header.i=@HOTMAIL.CO.UK header.b="t54vhIt3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iGvdE6BXo6IOsUGjTTLJ/xbC9euIEqfcKuD3Tp7uj01O/h1lxnz9fSPykmsBuI/xXDQ+rGQ1mymtvhxwvGSR9R6LauTQb22dnqh4FbZtpI/InfpTcIe12jwwl8b8tD5P+ssXzSpVWNbIiwcRfsWr9XKkSvoOfKk/XI3qbRbFLGDu2eSOR1gprxoA7fQ2W0nL0kiK7qEoOSQeCqMN0BwxwXjT9/UfI9opVpedUC5gAF6rwzHVa3wKGPjrS5sNdqda1tkOpKMcH+pRugKuUD84wFdFnwMtIBQLl5TsqrTPD0oxpakaF5gX93EBSrCPIEU7iwqsy26Naf3b1oJR1FCiKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UogbowRpOA5Zb0cRMGXh8KnD+g40QbkugWOWrfF3CVo=;
 b=jmXAeu9iYSYtKT6JSgDOgun10VIyiuMGa00FmzLZD6NTaqDhl0vBIRt9+K46c4rEYLWQwGMC6B5rN513T7APZ/fCKafgPEo8XNnuc2VybH4zQou5hEdWNO8jz5/dS/k2o/KTRjz2EusXuBFb9t41sD2gJ0jL5VGTat/crHzqvE1urAQAx2sTeLXfasWywmREBbuhZ1k1OE6fnEXNeJltWJweV7rkmI3FMA9KO7K9fWy+q0XbnxFGThhMzOqaz4e8lZNG7MSSJengvoh2Sqs3E2W1b/bt8VPeQYQwfyuKVKdWEx3L/8TCmKLkrsFBfbKh0LIl1av4JyEhs/e5nWteQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=HOTMAIL.CO.UK;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UogbowRpOA5Zb0cRMGXh8KnD+g40QbkugWOWrfF3CVo=;
 b=t54vhIt3FsPgd68JM+k+187KLgXU/xw1P/nsl5uHKybVzJrzJQjnJ2L3D3ZWAYYDwqLuNqilcGJ3KrtF0a9bc47b/ol0EZwaMrlIX/vJQ2CKnTd/ocml6Fn/ncFQMsb9r9Npvj+8sQXokmgBStIhOUQkrOQPdcOZPA10JvWoKZcUOYX7ohF3BPsIs2m2J9B9b5M5Qjj1uMjGJWbJzlRYktC7NNBeYQRHGl6JJEBX+x/FrLTqW8NMvKxPIB5pwpni4yqbCx4q/bDSm3JCM8t3h22w+fEDL1REXimJpJe/8cfhUqdcgZHTROXJHauOX6vRJL3nFATWKYrAFHVd5VwyBw==
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:344::22)
 by AS4P251MB0636.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:4bf::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.9; Thu, 10 Sep
 2026 00:21:27 +0000
Received: from AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352]) by AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 ([fe80::2952:d4d0:4ba:8352%3]) with mapi id 15.21.0406.007; Thu, 10 Sep 2026
 00:21:27 +0000
From: Aamir Ahmed <elb12345@hotmail.co.uk>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>
Cc: Aamir Ahmed <elb12345@hotmail.co.uk>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] ksmbd: deny access for an empty DACL instead of granting the request
Date: Thu, 10 Sep 2026 01:21:21 +0100
Message-ID:
 <AS8P251MB0001730F6EE172EDA5481ED1C8BF2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.53.0.windows.1
In-Reply-To: <AS8P251MB000152D9BF4B8E0601640661C8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
References: <AS8P251MB000152D9BF4B8E0601640661C8B32@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0248.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::19) To AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:344::22)
X-Microsoft-Original-Message-ID:
 <20260910002122.31983-1-elb12345@hotmail.co.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8P251MB0001:EE_|AS4P251MB0636:EE_
X-MS-Office365-Filtering-Correlation-Id: fa7dd91b-85c2-42bb-ef70-08df0ed1740d
X-MS-Exchange-SLBlob-MailProps:
	zZTkHIKWWP9ynys4vMVANsqrUe+CJJVr+ElIdYguCBb8ie55pT8RhTEcnhrcwCIBdsliCLAPdAsWSkKcENrwROdsp+V7X5gCNL6cFKaUea8XhDDQqoTvhHjQvV9eWp8UoUOdQpyExfdsl+xIXagc/MKK/I5zFx3iyBkECyL0bKBCFH310fo10lgJfuy9PV+g3kp8gNJaAjjw7gDbHZmPV3yWSS6Okt0MeguunfY+y1idoBn4x3ToCx3H/VutJQ8/TjZ46eGzKschk12dQrTb2nfz2o9kHn37m8f3REkG3OuhGfCemZbWYNPbUp4k0jW9q75vDVAIwoDHn2jic66PBHr1d5V6LTjahLyyJ8D4vGykha8Fl+5BBhkIneV+kWF9LgVdJyKC8sA4dAj6XEa3mlmQTt4HMfhFzmn6QwDCP0e/jr/23BeTsIEikLOf3blIes1QSSgIl2YpjDSn0D/eC7t2+rQWqH9CVXs+acKOA+qN+aE2LPcC2jUyM5cjUl62mFJ3t4m0RKECceizXpezIWEcJjkEKq2yjR21JGSfwTO6FBcBDnAKpSZX8WKeSFvyPHNxcT50E3f3UPhKHQVwzHVblFN5scxdzI/mVrv7Tb5C8rrZ8DniD/vWULLc38l8ANa+FUHJjrJOimpj8Wgr/LEjT4ciGtL8BaEZ1n+hK9t5njqtZobBCw==
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|24021099003|55001999006|6090799003|5072599009|25031999004|23021999003|37011999003|25010399006|51005399006|19110799012|15080799012|8060799015|440099028|26104999009|3412199025|40105399003|2607281247196008|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z3p1Rm1aZm9lSWFrUjN0aGw0aVNiQlVaUnRQa2xwb21RbXZxemlBbUwvVTJH?=
 =?utf-8?B?Uk5QZXU3WEwxcXBzUG1OQk5kbk03dXQvVmEvRW5qUEh5MGVrL2J4TFM5NXpF?=
 =?utf-8?B?cXRvZXorb1hOWmJoRENvSnZpQUM4OEFJeFk1THhOajhJQUlyUnE1cjNOMWVz?=
 =?utf-8?B?RG1OdGc0WlM1d1pQaHR2UzAyL2tKeG5EeFlSTEdralkzallNeXZFejlET1Bn?=
 =?utf-8?B?blZ2d1ZwUmNZTjNzdkRWRGdILzdRSy9BWWlXL3VwSFJlSVZMRkwwSXdZZC9k?=
 =?utf-8?B?Zml2cTc2NEdualFoNm5odXdmNFpyNlRBbXhuZ1FQa3pZNk1JVEMzeUdVc29h?=
 =?utf-8?B?RW9DY29PQlRsK2VuUHhDSlZuZ2E0QWlZcklSdGpGUE5VZXVLU2h6dStITEdM?=
 =?utf-8?B?U0MydXF1Ylo0VmhPbm1zbjRUL2U0RWpncXJ4QTlGbWxuTDhyNGVsUFdZbzgx?=
 =?utf-8?B?aEtqMVEvWTBEUS9OVmdHaVJoZTRTcnNrd25sYjNrRVBudjMxRThTRlRHS2pY?=
 =?utf-8?B?L3lIdW1JT3N2ZUVRcG5Wai9JYTNoeWRjb290eU9NNTVsRjVrVUZpRjd0UTRE?=
 =?utf-8?B?Nk9QOEN0N3FDNHIrQ2Z1R2VkL09HU2I5YUlCc2luNFZoWGpGVXhSZDAySWU1?=
 =?utf-8?B?T1JEaHlPK3cyalFxb0RCR1VGZHhUdzIwQlpucmE1UytVWElyTENBSld4ZG1y?=
 =?utf-8?B?VXp1c0NLRVNKenJ5OHBKWDVBZVJ6NVlVaGg2bmpseldHRHFkektGR0IybjhK?=
 =?utf-8?B?alJXR3VVTm04N3JZZ3VtalI0amJzMk44OXhORXZpZEE2TzBRRjhWd1B2Wndz?=
 =?utf-8?B?cWxMV1J0YmNkWXVaY3dhVXhqbkR0VWpVcE1UWFNlaEl1ZVlhbnh0TkdPSEpk?=
 =?utf-8?B?bHZtQVpSUWxpZjhOTk9ISGFEcWcyaStvYzlPWFZHSGpDUHpYZUt4N1NyVjNO?=
 =?utf-8?B?UGhaZFR6aVZGdDVnQUNLL3BoeWFTeG0yeEhETWJtTWJ2VUtYL0VLRHlmNnIr?=
 =?utf-8?B?eHlFZWV3NUFQQ011a05xaloxayt1UjJMMTM1M0xtSlVsQXNEL1FTajV6S2Q2?=
 =?utf-8?B?N3RDZGtvbEIzQTdvZ0lZSGkxWXh5RjQza2pRQTBwM0VTWVB4V0VQQmZFTVFC?=
 =?utf-8?B?RFpuUFJZKzVJbHJZMW9rNUUxZHlGQ2RYdjNoc0thVXBtVi9SVGNoRWxwMVl2?=
 =?utf-8?B?Sk5LMWhLR2JxSlpCTzBuYUZ5dVB1RTlIRW53cW40cVNEQ0dSQjdRc2N3Vy9i?=
 =?utf-8?B?ZjVscUVKYzFIMU5ZaGJseTExQXVwUVV1eFNMcHFOWVdaU0lEQTJJOUlWRFZP?=
 =?utf-8?B?eU5MeE94Qm1kbjl4aHdSQkwweGY4a0RWOFFLZlVwRlNUTGxRQ2lVclpkM2Nz?=
 =?utf-8?B?VE8xM3ZHWU5WR1NtRGpPNXpkMkVoM2poTXZKa2pjeUNWd2JCVnVyNHRxcnFh?=
 =?utf-8?B?UHVUd1M5cEpjMWQ1R1lYb0Y3UDJJaGVpck1DZVZ3PT0=?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QlR6UUpXUVRyRnprM1A1VnpoR0dyVjEzSWFseFNpNGJpbnpPVXBPYlFVYXpj?=
 =?utf-8?B?U2lQZDI1OFhhd3JZSndwUWtJSm1zWlU2SDlFc0YzeE91NVhSUllzNWg0a3dt?=
 =?utf-8?B?aHRsZHQ4OXNmcFFONUo2a3R3NXhSRkIrMVVGdnZaWDlKN3E4d2FEOFZkSWh2?=
 =?utf-8?B?L0NtRE45YW14dnZRUklEUlFIYW02aVg5MXkzUlphUE8yZDdsRktFNEJCV0s2?=
 =?utf-8?B?WUFBT2hhVXVQUHdSV2RxMm9HTUVCdEV3T3h2SDFYWCtNRjVQWTFKQTBCOVlF?=
 =?utf-8?B?MnRGUEg1SUE2WVVyM3JIRGExWDB5bHQ1K2hHaDB2SlFUYmhxUVE4OXQybkVl?=
 =?utf-8?B?L3AxcXhRZTI4dy85M0txMy9TK0pHcEhVRk5xbUtOcTVIVFIrN3h5THZDTDcv?=
 =?utf-8?B?TVQzbjRUdU00OThrWmJUeHRNSExrem5RMjB0dmNoZU5hd3ZVUkxmejh0Z29M?=
 =?utf-8?B?UzVURStNbHdXOHJ4WnlnZk5IaGs5SURucDRXaDM5dDI2RkRiUC80VFAwL1Iy?=
 =?utf-8?B?c3dyUU81YVE3NGFOZjdGOUV2RHNYejNha2Fzd2NPMTVBMnlLcy9EcmxtTkph?=
 =?utf-8?B?S255a2VpVGhRU21oNjBsRUgzVWdWR29IUWJ1N3NaYjZhSXVPMU1NZ1VmT0tE?=
 =?utf-8?B?SElETVU3Zy9yQmlsV1VxVk1DSWtoWDVxSC9QaVc1N2Z1b0hqQWVTVGxzV3M0?=
 =?utf-8?B?YTNTckRrNStoT2NYODhNVjlIZHNWMUwvWmlYcndJUGwwaHRwUHpjaHdpdlpF?=
 =?utf-8?B?SVBiR0M4eHVKdEpIaFlsWTdPVWdjMFVKcXFMS0VrdWFUUHRSRC85aVo5N2hD?=
 =?utf-8?B?RzlWbDV3NWxZaUJkdWNJNEhFZ3pacHBTU0srT1I3RnlTYnpGUlJ0NldFdUNq?=
 =?utf-8?B?eGhTcVhpNnJLc3RmelRXdEFNZDhWaHZibzBoY1RYajNNdUdsTmVmREZmMEVZ?=
 =?utf-8?B?UGZFNForNS96SStDU0gvZlpnZHErTmZMZVdUSzBBL2locWxRcXp4ZG9QWnZR?=
 =?utf-8?B?U2VpRDZlMXkzRFJZN1VrTGNlL2JvVS9QcEFyM21YSTdsa3VHeWk3cjZCUndY?=
 =?utf-8?B?elFiM1RRZll4MXRkZzAzZ0hCSWEzU1lHRlEydTVXWmtzc0RmUWFmZ0ptaEdO?=
 =?utf-8?B?WUVQMDRtUVNVMzFOMzZVRmIzNTg5RjNWbmQ5bEwwNTd1ZnMxVmQzSDdDc0JJ?=
 =?utf-8?B?eERtSEx4V3lhblIwejlvRUpsWHBwL0JiOEhyOUk3YXFhWG9scUVDa1F5WkQ4?=
 =?utf-8?B?VGNwMU44MHcvL04wQ2E5Y3I0c1ZhM3RHM1V0aysxaUUrbmZIc3NoRDRsZWw2?=
 =?utf-8?B?SDN4eGk5b0ZPeUF6cHhOSzY5WmZ0SDczcTJ0eXJNWGF3cHBtV2E1MEhQMXM3?=
 =?utf-8?B?NCttUzlKWWt1cFJ5WHFGRktkL3FLRGFHbzdJRWFaN1Zvb1dEM2c5SVRYWHVB?=
 =?utf-8?B?L3N1RVpBWGF6cEJPWDc3dDJHMnY3eEpzcGhhNFRNTVNReldZMjBXM2VDSXAy?=
 =?utf-8?B?M1VEeXU4Uk5oQWpNWGw1YXN0Nm9jOFdHRVlSNW91ckVzRnJidGZwcGZXMHM5?=
 =?utf-8?B?ajRldkVpQ2hBL21Kb1VzUWNWZ0doTCtnMmVpbjdHWkpxSUhNSWF1cGlGS1k0?=
 =?utf-8?B?dGtXeWdRMElCM2JUdWdsUkV3NnRUY0VSczl5eE5Ua20wT2g5NkQrV2NuUnAr?=
 =?utf-8?B?c2hFOUx2VlNFYTB3QmZMV3RtUGxuTXpqK1JUeW9mUnJhYXFHN2VKM09NdkRt?=
 =?utf-8?B?Z2hZNnRrNS9zaUZONVpQWTFPRHNaK1k1a2NJSGtlK3JGcGhDQmxMZXJBajFm?=
 =?utf-8?B?SDRodThNcTJvcFdzTWxCclcyZVhuektkcGZ6Q0NJTkNYdzVFMTR3RXFiRXU3?=
 =?utf-8?B?czUyNUowaUVsbEpNK2loYWVvUVJ2RVBzcVhHQ2tZVE41NktqcE55WnBzTHFx?=
 =?utf-8?Q?x0W6uCCDvlD+h5sULlrspQoslzLosvZ2?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-fe3f5.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: fa7dd91b-85c2-42bb-ef70-08df0ed1740d
X-MS-Exchange-CrossTenant-AuthSource: AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 00:21:27.0535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4P251MB0636

I missed a tag on this one.

Could you add it when you apply the patch:

Assisted-by: LLM

Happy to send a v2 with it instead if you prefer.

Kind Regards

Aamir A.
