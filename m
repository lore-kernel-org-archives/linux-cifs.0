Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.43.53
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792511530;
	b=YicJ78jNWj4QT4AWiDPYpZDiVhOvsZMzE95JPJN9n6k6utFakw/uevJztSmk6r3NXE4+
	 +bS4OBfUnLRd/edF3stJHuNNdVRX5Rp8jnQUXBVThNey0V3jfg3H1P7mNX4ii1+9GpQGV
	 GGqtDvlwsnCv5QGhV4QzIGE4Zoj3h6dWCeZlFNvHedfUoZc3eLsUDtvL1UcH7OGZlKcmx
	 MPmDdDXFJI4taFEIPLPIsXABiD3njS+m9jlRr86iDKDR0MYYeX19xctjialcOUNeLVMw3
	 p8uNP4FOZRMt5J1Xsgnwb0Q5xhwrPNGGuNFBZzUMsZ9LxSQWgx4Aye0IlQv2mbHSjow==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792511530;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 X-Microsoft-Original-Message-ID:MIME-Version:
	 X-MS-Exchange-MessageSentRepresentingType:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SLBlob-MailProps:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=6mZHLU3zUMMWvUu1GjUtycxzpu8CI1O53Rcm3RF0eVk=;
	b=UK8sD9coM9Ynpv5Chk+WetQQJLVj92TT0WuTifSLiMyE8gRsgNaWbapt8ZHoUlu7F3VG
	 7lcz5udjdLVTeP+bxQPwquj6Sj9r9YFvyWUq7GHoT2kjTGYL04/ARKSbvC3SUbT7F6uxW
	 Q5zx989DScPh0yQG2glOPeoJEHNu7oOE8GGCjMGWdo1ndZCEtO4oteJhf4wepdP+waFSP
	 2fG3As5dUEr7fMSBWRJjCaOgLSYwFc+Ex7dOPm1d+SFNmjAsjNXZRlSsAMay1YbeckelT
	 I61t7hvqRbVw8Tov9Jv5WCRcrAfzDowiadAnwN4huZFopSX90PezRuIcmYfyfPfpwbA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=J+YV8ozL;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.43.53
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012053.outbound.protection.outlook.com [52.103.43.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC66606A319;
	Tue, 20 Oct 2026 15:52:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCC66606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=J+YV8ozL
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YkUKFoOKdeTprQQgFTKTIirE+SpEiqEvrZAMHUzTPePf7oVYBsZW1SC6Qcy4cb47SIxzonmvccuppopp9J4rakDmniS70wkkZM6siemK1NOou2c+1A5h4NpyRzY58p8vlMyLAKTqQS7HAMPJQKs/ER6hVb63hPg0v9x3w7cIViDm3E9bTc0ap0Q5YqIhLSN25OfW9HQqxaUo7ulZ+lOGbgIoXImFeF2M0v4Drd2d0yV9Iv4cZwomPNuihIuwt0qiYWCRzYfSPox4tgAJbt5kT8vf+cHzkyb7rRyV+8ZnhcyO0qHXObq1XjhsuhAZ789UYO0+YUVVMRLVgjdJJVU3Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6mZHLU3zUMMWvUu1GjUtycxzpu8CI1O53Rcm3RF0eVk=;
 b=mB9/99G8jvlAdk2X4nHeICR2c5HSlgqd8uYzYKzvUc6duhocK2qOZ3Rx5iUsIrufspWSEPSwlclWRQb0eOeVMkHDubVNwW8LBLuY4oRqPt3IsMelSf1c9S0gk+Jw8Xe3TL+bMx/BgrUkjP4h5pEd6SN6E2V1ANaIifHvTi2bsOadvodNbcipnAmbXDsCnwxVeyTU80DUngLV1lZv6ZdL4vG6ef2L2ayRRjdTSmHh1BmgUBYwn2FYpwJWTrr7uqKSAPwtqM9TszhpKAmgOrCh5sanTymIsFNmIs6ZC3daGaYQdW8VEImj8dxd/IBmRdQrofLuvaVjoh6A96vQ1XfRtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6mZHLU3zUMMWvUu1GjUtycxzpu8CI1O53Rcm3RF0eVk=;
 b=J+YV8ozLQo2igwNxJOcfCDUcpEQZbg/XZ2Cr5uA7YROGRBQ/XCzx79FDNRazZSVkjOuHHCLOu+9S23gJxn1nll9GIg3ZWKWj7AkDbCl2gpIs0svW16RB4pFffnJaj2aOV2kAAIlcCPKUvljjBj/lT1VzDhAZRC9it/Qjh8/d7oaA2WHhqTMdS56qe9J9XZ7539k+zaw4ao4e029r7vY0zoQh4L4JCfY9/Nt/P7LSg/KMr+2dzra1S33mIOuaXqQF9RSptAFGpmaOup6ccyThF1HDVvYnNEnNMSnPvqACYJU+XuU7xgEG86oJeYHhm4a2Sfbf0Zdz2gJQhRpMmT72OA==
Received: from TYZPR02MB6959.apcprd02.prod.outlook.com (2603:1096:405:2a::5)
 by TYZPR02MB5641.apcprd02.prod.outlook.com (2603:1096:400:1c6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Tue, 20 Oct
 2026 15:52:04 +0000
Received: from TYZPR02MB6959.apcprd02.prod.outlook.com
 ([fe80::c0fb:a6d1:aa86:9d23]) by TYZPR02MB6959.apcprd02.prod.outlook.com
 ([fe80::c0fb:a6d1:aa86:9d23%6]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 15:52:03 +0000
Message-ID:
 <TYZPR02MB6959812BFC392957EDDA8C67E6672@TYZPR02MB6959.apcprd02.prod.outlook.com>
Date: Tue, 20 Oct 2026 23:51:59 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] ksmbd: NTLM pass-through to a domain controller
To: Ralph Boehme <slow@samba.org>, Stefan Metzmacher <metze@samba.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Jan Koester <jan.koester@gmx.net>
Cc: linux-cifs@vger.kernel.org, Sergey Senozhatsky
 <senozhatsky@chromium.org>, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Wang Zhaolong <wangzhaolong@fygo.io>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 wang zhaolong <wangzhaolong@fnnas.com>
References: <cover.1792345559.git.jan.koester@gmx.net>
 <CAKYAXd_2AUVQFZWcmk55fBU2Rk-REb-onj38whT=kNCuZ=COew@mail.gmail.com>
 <0cadbdcf-6074-449c-98f9-3aeda3756160@samba.org>
 <TYZPR02MB6959BC66EECFB5D178F92012E6672@TYZPR02MB6959.apcprd02.prod.outlook.com>
 <9b5b0f6c-9105-4e30-8608-6f222b0e2a6e@samba.org>
Content-Language: en-US
From: Wang Zhaolong <wangzhaolong3@outlook.com>
In-Reply-To: <9b5b0f6c-9105-4e30-8608-6f222b0e2a6e@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0188.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:382::17) To TYZPR02MB6959.apcprd02.prod.outlook.com
 (2603:1096:405:2a::5)
X-Microsoft-Original-Message-ID:
 <a19b6097-2765-41d7-9e04-bef5b829dc40@outlook.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR02MB6959:EE_|TYZPR02MB5641:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d12c0d0-bc0d-48fa-fd6c-08df2ec2157b
X-MS-Exchange-SLBlob-MailProps:
	5fu/r660v9Mj6U6kz+12O9pZy2TuKGHDukIP6VgrZk3xoXBMKzY5Iq9Hxo2n1i0zase0ENvbH0Jax+vtaS+tN1dS2FIQUDbL46CFfNTXiWjc63tcKH9BcBxLJOt1JbozixthjGJK/IQVcJbf75jflE/bNAxS3JFzGJw8KBubxkSsLBUzknI08PqsKRUKeAe/hFe99BscCiHJEcNVdaQNroaL0ukDBnAz6cbbfLHXdMJ2NAq+niN4wH2sU/mT6gMVoKUXPSkwsKiLfobMo+hM6Onj1PF3YhDVO2zccJJyb6wh6qKx98oxEYY7ZkCelqtMTRp2YSHbHxlmemtHAAuj4z5DfJFldawkPK7kqUupVm1IoKR0RvZaGnw7YEb6fPuACDv7FYZavTo3fPSweAS3wqBsocpYACoqkMeg+jthtY6L7PRLlB5a7uPM68pc8Xa1VeZEliwBTGDYbQKtKnFvhn+A8B2FeGRwtxa30tIWvj6yBvEl3oi6vRofGwG1hncXmigsQG6651o/A2M95xNOtphCZt13ATLr6Ov10XsxQyqdYeHFnQeN2Akr8JtnSgyGRS0p0BGNKnrRo6GL+/yRssOymPgsFxgITVUDKj4gpMWdh4pTVxZ7nsJlmvMkUj/olx8DLz1HgNJUqubbd+JpwCYAdczNRxvz1Indjomk9PGwkxcI4462MH9xt0rmFDDJoyI/XHjmmDNcuqYfJTjpmG7jgQyjBivx93JKZ16EDCA=
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|24021099003|8060799015|19110799012|6050399003|4140399003|5072599009|51005399006|24121999003|22091999003|15080799012|23021999003|6090799003|12091999003|40105399003|26121999007|3430499035|19061999003|56899033|440099028|3412199025;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YUY4dEZ3cFJJUGFEbWE1Y0F1Y3lvVkUxSUV2S3ZVcTNVNS9QUUJpK2JpWUpI?=
 =?utf-8?B?VDZqUWNDYm1TcEFHS0Z4UVdEQ0pYNGtXd1pqd1BrN2NYdnRJSGMxZnBrTSti?=
 =?utf-8?B?eFNsaHk2dG1ndWhUM2pZcmVCYjA4b21sVm9DOWJCbXU2cldEODZiRXd0Kzl4?=
 =?utf-8?B?cE9jRTVwUnBEanRGMjJhZzVMUEFSRWx2K2gzcnZ6UTJ5eWUreGRnSE12bmF2?=
 =?utf-8?B?ZGNUYmIvWFRiQWZvK1EyWm0yOS9ZTjF0cVRoSXd1UHBhU0d5VW4xU3FWWGZI?=
 =?utf-8?B?aWxibnZJclgraXFaRDdGSWVJUDdqQTZkVTV5MWU1U2ZJNFdQOXRraXE4N2Nz?=
 =?utf-8?B?OUxKZ0tKQ3ZtTktrQTVLREtZRVBob1lGcTZHQkJzQjhrcWhkbFZZVXhFdHBa?=
 =?utf-8?B?ckplWGJQbUdaYlZWNUFZSGFxZG44QTM1djhNT2xYckdINVVXK2g4bkQ2dnU1?=
 =?utf-8?B?a3NKeUpqb0piR2Vwa2QrMjN3cFZQMnJqSVZvdjZqOXlBQkRDYXRKZ2JUZzFE?=
 =?utf-8?B?a1A2bWxPZmg4MkF2dDM0RkVtQnlnQnk3NVhCZnY0dytWQ2FLQ0V0Mk5ncTNh?=
 =?utf-8?B?cTZKYWlHTXlqZS9Bc0RDelZsOFZiZWg5cVA0dlR0K1Z3akVZaTVBR3RUVDYv?=
 =?utf-8?B?alB6SFhqd3h0a3Z5QTl2S2hsS1NYMXZIUmp5eVlSNkswanZ5UjJ5SklZK1c4?=
 =?utf-8?B?VjJ1bnB0T2JCS2tjMVZOZG5tdDBENldEcUoyeUprRzlRTXBSQ2hMdXhRbStX?=
 =?utf-8?B?c21PNDJsYlRXc3dEdVQzdndyVmNsdFdVcUMwOEIzZ0dBWFhlNVR1Y243V1Zh?=
 =?utf-8?B?azJHQ0lsMERHRDh1dHNEVE1PYXhlSFo4Z0J5N2craXE1NkVrV3BiUkVneXhk?=
 =?utf-8?B?VlBEVjRuNDZpdWVKcjZ3OE5rV0V6QkdZS2lkSEZhd05tWWlhWUwxeWJJVTE4?=
 =?utf-8?B?eG1WUWVpS3JNaTdGclJ2cElrTGVJWWxUS2laY1RhZTh3d1ZuNVRrSjJyelhI?=
 =?utf-8?B?RXdpY3I1VDd1cXE1ZTUyNWNTRmQrZ1MxMVJJOE1HZW00T01Ga3dsTjRJc28y?=
 =?utf-8?B?elV5RSs0MGNOWjdPdUlSd25NVm5CT29tcE94bUNaTlhhU2V2SkV2QnVjMnpz?=
 =?utf-8?B?ZGZzem5PMm05WFlZTVFEVjBxNG9LaXd6NHBWcmtjQ09Xa1VZRjA0Y1F5UmNa?=
 =?utf-8?B?TVFGOTlRVEJtT2ZCcXA4VkxMZk5qbnoyZ3hUNTBsR2RIZjh0N0ZFbnE3V0FU?=
 =?utf-8?B?OUt5YlU5U3hPaGNmUkJ6SGFBdFZsbVMzOURyQ1pGOS85ZGJVRlZOS21ybXhZ?=
 =?utf-8?B?c1RwaUpLZmxoWHN4TXE4NHZDSE9rL0piVEp2ZTJMSDBuU3ZCLzB5M2RGT1Y0?=
 =?utf-8?B?dlJUUS9FdmFBdlhsVlUvOHJDUStDUkROWnJBTmUwOEh0TVZzc2VaV2t3NjU0?=
 =?utf-8?B?aWwveldNZzM1a09RVTNUWEdidWs1VUNiSURyanN5VUxJUVBKZ0JjSDdNMW5K?=
 =?utf-8?Q?a4k1/ilKCLLau7n4CZ+wMY+vLrJ?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YlhEZ0t4aXhUZ25nM0tyeTA4NEM1WVk4SDd2OFIwbUtyUlZncU81QlBxcXdu?=
 =?utf-8?B?ZFFWZis1VnpwZDJWSW5uZ2dWbkovdlpTaEZ0Y2VyclVKN3YvdnluM3A1Z1pm?=
 =?utf-8?B?VzlEUTJFQXI0NUlZaXdiK2RVNnEwNTRiWGVFcTNCVHlydlFXRWxLNzlRenQx?=
 =?utf-8?B?T0svdTVQRkhja1lVVDVPcndqVEl4ZHVla1lURGVrWk05VFh4b1NVV1JQVkhD?=
 =?utf-8?B?d1hiSm5JQWpXenV6WElFMDlwWi9zNTVXc2hXTCtiSElmZGxobGYvZ3RQWlpW?=
 =?utf-8?B?dU5vUnFwdlQwSEFNZ1JVRktYdEplK2tjaFpQRFVCWTJTM0Q1cjBvTGVkdmZM?=
 =?utf-8?B?WldDMi9YTkZQTElRR2Q5WXV0SndXdUZNSmFjcUtrUjVvRjVlOVNFVTk3aDVL?=
 =?utf-8?B?eHVJZlM5bVltR0Y2Qk43V2prMXlkK2xOdTV4cGVTY1JCOG5FcDJ2VTZibkZO?=
 =?utf-8?B?UCtQb0kxT2tISy8yb3BWdWtyODhIV2NRTWtGYkV2cUdQRkZvSGN2UHFid1dG?=
 =?utf-8?B?RDZOaGhOb0ZkcDkvMnd3WUo4d09neVRWVGNPVkg4OHlXZ1NQRVlKeTR0NjY1?=
 =?utf-8?B?dVk0ZDhBaGsyM29uaWZQMHNDOW14Q0U0UEJHRGUzRlo5VWU5VExLSmFhS1lo?=
 =?utf-8?B?WEpTTVNiM2xHNis4b0ZwMmZIZzB0Mm9DckpSa2hQT3NPS0NlUzVKVkdxaWFt?=
 =?utf-8?B?ck03OFNBNVJaN3lEU1ZVWTE2aExFREx3TWJjZ09RbXVYRlN1bXdMb0tiNXBI?=
 =?utf-8?B?OThmcWgyTE51cmFFeW9xYW1DWWxPNVgvMG5nMys2TzQ0bzhmcVRZS0ViMkJx?=
 =?utf-8?B?SlN4SjlBbmgzcFhEejdsVjJxSytCVHVSQzAxVXVjckluOU5lWGRGTW5ZL2hL?=
 =?utf-8?B?cUtmZnZ0cjVSOUZtRUsvRldPeGpMRnh0K1lmZDVUaG8zNWhNUUIrR3RLK05x?=
 =?utf-8?B?SzdjNFd2NTVseW1OODQ1aUFxaWdTVVJIdFIyNm9jU1V6UHVaSkVmTWJLM3lM?=
 =?utf-8?B?Zitjbkl2ZkVSK0xQQU1MWlVmK1h6TGdYQzJYOEcwTG1jd3BzS1dOVEVkS1U1?=
 =?utf-8?B?VExDelJENHAvU0xOWk44QjVXRWo1ekVENE5OaFJ2ZGRhMi8vVDRqY3ZDVUcx?=
 =?utf-8?B?a3R1OHlFa1J5dCt4Nzc1V3NmUDRHVzRkVGtQK2U4bnRPQUNOR1NKV0kzMU5R?=
 =?utf-8?B?WHlOZ1B6TFEzQ2J6dVBBRFVFbGdySXRHRlN0OVNuM3JnQXJxdkVHaFp1engw?=
 =?utf-8?B?TUt3RXhQNnc4Sk9GU2RDeEVYRUprVWdFYmNUNFpraUlSVzhuSnlBc29hMXow?=
 =?utf-8?B?V055MjhLcUFCMGNONnd0MHJycDl1TmtNdm1UUXlxSjlQV3NpRW9aSG1uQVY2?=
 =?utf-8?B?T2p1YmNlRzFkUDFSQ1dTNmVrVlU2NmRVZUxZOEhLQVB0bDhmd0ZuRUdSU21u?=
 =?utf-8?B?LzRWaW03Rk5CTjZlMERvbzlqWVVvaHRhWnhKMlFPcE55TWdPOXVoV09SK3lQ?=
 =?utf-8?B?VFloQWR5SjU3VGQ1cGJjcFJ2dHRJU1VIblNoUHN1TXlrRGkzRW1qanF2U3BH?=
 =?utf-8?B?cWFlZ3ErSDQ2WW11eXB6UXZhVUVVSXh4QzI2S09hc0VScTFHUWlId0dRbXdt?=
 =?utf-8?B?cHMzZkI3RUNTVEt5amwxcmdxMjhFOVFvNjFQZXpOYmhLT1lUV0xJZHJmMVRF?=
 =?utf-8?B?NHZIaGttZ29jelBaWWxlYmhBUyt5TmFQZWRZNGVIMGMyelJKTWRHc1U4QVMx?=
 =?utf-8?B?bGpmRzVza1ZqSEMxT0xQQnczS2lpTG5uaUFhUWhIVGJzUnFab0hZMll0SnJG?=
 =?utf-8?B?L0FhYk9yTWVwZzJ5eE41SjNWYUFGNUpBbDhadkdYVy8wV0hiQ1FoRlpacVND?=
 =?utf-8?B?ZFJ6ODZONVRFaC9BaGE0VUg1a2xJRXNKVCtVamFzTTdRbkQ3eU83NlBTYVgx?=
 =?utf-8?Q?733ji9EsUHw=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d12c0d0-bc0d-48fa-fd6c-08df2ec2157b
X-MS-Exchange-CrossTenant-AuthSource: TYZPR02MB6959.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 15:52:03.1250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR02MB5641

Hi Ralph,

 
> may I ask: why? What's the benefit over using something mature and Open Source that already does all that and more?
> 
> Just curious. :)
> 
> Cheers!
> -slow


Fair question! :)

When I first had this idea, integration between ksmbd and Samba's AD services
was still fairly limited, so I started thinking about a more tightly
integrated solution for ksmbd-based NAS systems.

It's great to see the community making progress on this, including Jan's
recent patches. I'm happy to see that happening.

At the same time, I'd still like to try something different: a small,
Rust-based AD DC built with ksmbd in mind. I don't know yet whether it'll offer
any real advantages over Samba, but I think it's worth exploring.

Cheers,
Wang Zhaolong
