Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.43.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793027425;
	b=J7RLbqBiPEa2jNX8+3oAJ9ZKmYrrjQh9OHaCxZtSJcT6hVayZpBnQMw78CcddCrkMmiR
	 ywzAh0HDE5bOqJoHZPulNSHCkJPYDywIOoaTJ2QbhU6iKAqypEddkgWQkT6qmeBCfZ9S1
	 87MiEpwF/oFgMXsgwmVItb6vezl9wzKmAIJiOJmqzHo53r25iNOS81LH/0FnPFp6x3fTa
	 XhQtLyg5cbndHFWQw3nJpMBBAbY/Si3JoVJ60ws1wY0/wZ2o4X5d7+zijFagx9bfIx7eu
	 esPa85knUoSecLHqA60KVBHTDmUZwsSy118M7jxk88QdNPZ46O9kv0N3ncJcIaXo+7A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793027425;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 X-Microsoft-Original-Message-ID:MIME-Version:
	 X-MS-Exchange-MessageSentRepresentingType:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=GDoT1f97HMSzIl27AFxsGzgU14gBpQzsSaLQbUyRuPE=;
	b=wEGKMnxOZ/AQMEyVWQdWRc9CpJ1HlP4F4NCfE+FBY341Tee1p83uv7jiX+q3nIbyMt6v
	 ZxatILU5UeilpOrVvCiAWHqXIb7dVJf0La4NThuNorMLH6NUGkuAslOOqLggoukuvAtJC
	 TAoWhxcs7xiYa/jAi78OBUS1jfolY2v5wWLgT2RGFrN1iVC5z6JlI/iPhnSPREsmFJlqK
	 nXAGXzU/T4wrxhpl0OlSObz4rbnixSeLks/zeojO/bbzsai2YP+Cr4gFIi2F1bkYHVjvf
	 yFH7+qEYvy1AC6YG7QCiOVi4bMmlOQfMPQfW5LQUD6sLBltijmq/CWcXbMfO3+l7kRw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=H6SaLBsy;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.43.51
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazolkn19012051.outbound.protection.outlook.com [52.103.43.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AD1606A322;
	Mon, 26 Oct 2026 15:10:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60AD1606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=H6SaLBsy
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GBnjFoaY82rKqndjkb/0vOq1UsFy+zE73zJo2UavlyxOF5zfnXhuaB0weM27TuPR4B2mgk+EdxT+ZlV0B3E8ADJ2cU1rVtaQZxy0QmXpN6XMb7LEjwObHrswgaXHAJK6qL7GfAvffXSZQ8ZsooRlSiKVLk45LxvlOk70UIr0sn++4g5KPhAl9r2TcsFv6Q+Ju8oIqpngFvsMMw34KZAMmU4nuX6sC9EZYZYtp+lujM7OUR1Xg1zOa7cHsnYD3dvi3gXz+fRuLzFxd9pytXohldz0iHZnYQGpBAwStJyao+8UtZYG65/7yXwUQSIw1CbFizMb5kBRCequYhCP9Nf/dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GDoT1f97HMSzIl27AFxsGzgU14gBpQzsSaLQbUyRuPE=;
 b=KCvZShQuI3KV+bhn6kAOBhagxjvawXWQFSR80dLhPDmqjjOgheXVTaqMTQlNcjx5haOq81lQCKd/nYZUPYx9Q50XnT1PMYfCXV7Ok/CxAC/yavlfTpYqjZsYPGT73ojGsR/7ECRshuACHzZ/3arpeFW8i1LiuVKZtXoW3Y1mGMd7ktGeOnuA+qnufN3IC4Lz1MRPkgV6b0DN10cM8HVd/WOwydioMYbsteAdEPl0HPr+voaa0oXY7Q1PbRkdK3/hPODk5G2LwFATra6nxyrNqgzsrEC4j7e+fmYRtySxnxevKH+3iomK81IhbdKryI2ZVtjDU/M5uF+fvdY58M+LbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GDoT1f97HMSzIl27AFxsGzgU14gBpQzsSaLQbUyRuPE=;
 b=H6SaLBsyIpgtKU+xc9Nw3xb1YWc/wFeAqeNtQ6CAQGOKUwMM3/dKBML45Bo8D0gduc33S9KtA6m/5uMQl3q7RoHbetvN6mGCdEl18cY/2bzDsMfY+0+8U/f3MGqWqJ9AUCx6pmHhf7/DcushBx8qrFCqTl/5f4aWZ/lksKSVNZS3gLRBCIjNm0cpGPLUMs6lQLHQ7mL8UKBdPcSQG8eAsxZRQ5ToLnKSKGO6+OFfcQzUZzP6ePz3HRB0WbMSepqivJV6YwlxVQJqqc/8l+xVVimseEGHvlFUOvZWJtJU3NBc2BJ+127wa1xEAzB50Dqw55CjXmTlgqCto2h1ZuBNrQ==
Received: from TYZPR02MB6959.apcprd02.prod.outlook.com (2603:1096:405:2a::5)
 by TYZPR02MB5641.apcprd02.prod.outlook.com (2603:1096:400:1c6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Mon, 26 Oct
 2026 15:10:19 +0000
Received: from TYZPR02MB6959.apcprd02.prod.outlook.com
 ([fe80::c0fb:a6d1:aa86:9d23]) by TYZPR02MB6959.apcprd02.prod.outlook.com
 ([fe80::c0fb:a6d1:aa86:9d23%6]) with mapi id 15.21.0546.021; Mon, 26 Oct 2026
 15:10:18 +0000
Message-ID:
 <SEYPR02MB6964E0F5B1BC850603A3CA61E6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
Date: Mon, 26 Oct 2026 23:09:58 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] ksmbd: fix named-pipe reply loss with small output
 buffers
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey
 <tom@talpey.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <SEYPR02MB69642EAEE79F3CF02F782597E6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
 <SEYPR02MB69641633E70AC3FBF14BB14FE6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
 <CAKYAXd9vAUH6J_Mbx3ZTzGT9U+unoOsdDL4j_Q8UsDypW3a82g@mail.gmail.com>
Content-Language: en-US
From: Wang Zhaolong <wangzhaolong3@outlook.com>
In-Reply-To: <CAKYAXd9vAUH6J_Mbx3ZTzGT9U+unoOsdDL4j_Q8UsDypW3a82g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR17CA0022.namprd17.prod.outlook.com
 (2603:10b6:610:53::32) To SEYPR02MB6964.apcprd02.prod.outlook.com
 (2603:1096:101:1a4::8)
X-Microsoft-Original-Message-ID:
 <b886d50c-e8e8-4f07-ad9c-17267f2f7f74@outlook.com>
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
X-MS-Office365-Filtering-Correlation-Id: 7a8f537b-9e99-4e1e-d588-08df33733d61
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|24021099003|19110799012|12121999013|25010399006|8060799015|4140399003|41001999006|5072599009|24121999003|6090799003|22091999003|51005399006|15080799012|23021999003|40105399003|10035399007|26121999007|3412199025|440099028;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z1Z5b2h2SUQ3QjNBTzhkcXNPRUR3WnE3cmUzVXFaMGVDclRLcDJ5NjNaeDg4?=
 =?utf-8?B?cENuMnJLYmc0SHJnS0ZNVG9NTWhDb2Z4N1JxTEtkclFHWmdRdzYvUGFWZG14?=
 =?utf-8?B?K0xHMXhpZE56djhybTY5OVZoK2s2OTRsRjgzdXYvQzd5ZHVKMjRFSGlLTTVP?=
 =?utf-8?B?aHIxTGRBSE02OEQ4cWQ2dkk5V3ZFWkNWOWRTNWZld1YrbytVSE11UzBTejVX?=
 =?utf-8?B?UzBkTGJzTTNTemprMXB5eUtWWlBNZ1JTd0dVbWVZR21lQVU2SnRMS2lVTCto?=
 =?utf-8?B?Q0ROU0E3WHB3SlY0eFpkMGw2eGRpMUY1M0VMdzRabVdKNWkrYTJMOVVzK3pl?=
 =?utf-8?B?RWlFSlNXS1ZyVDdhM3BDeThGVkhSd0RQd1NpaVZrc3NXQThtL2FoWktrajFD?=
 =?utf-8?B?OHY3KzhtSW1MWTlqdzMycEQ2MUdOTFZXUUUxUzhOVFVsSENkOHF6QUpDTkV5?=
 =?utf-8?B?OThUU2xGTFBtWStxbkQvWi94bXFRZzhLZmFRWjhzMTVVcndEMmNJcTJocklw?=
 =?utf-8?B?Z3N3Q0VhaWx0bDR2K1lKejdiOWxDaTJoLzhBUENEZFZja2JIYlg2Z2F1YVV3?=
 =?utf-8?B?U3lycVppcDdhWHRNbnl4K3h1VUtZWTUxWnNrK2dsVGY3TTZtcmtSRGJ3WkFq?=
 =?utf-8?B?QjJDZklndTltcHNDeFB1allaMzdsK2RhN2hUSW9aeE9IYVdtSnBRYld4Qlhu?=
 =?utf-8?B?ZDR2MG8yN1pJWkdKa3RmR21zTmdlekFqQml0a0NLMjhaS0NVV3lvazdtTjJC?=
 =?utf-8?B?WHE3aDFSYlkxU3NLZnFRMGxjdEFwNWgyZkhGRU9aM3htZkZMWHoyTStjQ1R4?=
 =?utf-8?B?OEdtWWRPU0VyOGZGNlUvU2VYMjVOYk1yMVRGS3h3OVh4TXIzWXJDdk0vNzJ0?=
 =?utf-8?B?cmgyRkNNdzh4aXZRK0xvWC84OVFLZnE1eXZ5aFB4SWFQSmhqUm4zTk9ZR0lR?=
 =?utf-8?B?Y0QydlI2RmJCM3ovSkpHK0hwekVMTHloa2N2eEFTL3d0QkJma2JqbDJuZkhW?=
 =?utf-8?B?MVNXd3RSNHpZZWlYa2ZGcGRpNkVxT243dWhaSzBoRkxjQm5ETVNsNHdJTDZP?=
 =?utf-8?B?Ujl5enNKcUJCaEQvbE80V1lFN0poYUpYQ29naVB3RFpCUldacERRN0FMMWln?=
 =?utf-8?B?WHlDZUE1NjNwYmNWYnMyR2pNWlR0NTFxekt5ZXVyU3dLVG9KRlFYWHVhckpD?=
 =?utf-8?B?eVYxUVFZTVI0dENZbGQ1d2QydXYrcGV6Rlp5d1oxK0JFcjRKUzNGbUxzcjAz?=
 =?utf-8?B?ZlpwREM4Rm1pZ2JBdnh3Y1NKcUxUUTNZWjdSV2czaXRraWdhT0xwT29FZlR3?=
 =?utf-8?B?ZlBReVR1VDAyeE9jUDJxWTVPMTVBbTNOQ3ZrUlRyWG1LRXowQzBFSXgxam9V?=
 =?utf-8?B?UTNxWk16c3R0cFg4N1pySWg0eis2b3J6Ui9lWG82YUFmZzU3TkxRVWk5WXVY?=
 =?utf-8?B?U00xQWhzU2EzTW93ZWlnb3FkTk5TQ09HUEZ1VkM0cjlvNzR2T1Z1NkJmQmVi?=
 =?utf-8?Q?jH9Slw=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RG04N0c1em51RDNFUGh0UnRXeGs4OHlnK0JGSDRMNForMjkwUVJqR1NNOTlz?=
 =?utf-8?B?Q2lQWEtCK0JuYXQrWndJWURVbmQ1Y0RJZGc5TXUzUUJaOFN3YUFnVEdLeGth?=
 =?utf-8?B?V2lPRHJjcU9ONndiWHZsYlcxOGZXTVkvQjFkb0N5bS9ZbGtiTkxjZ3Q0eFQx?=
 =?utf-8?B?dVlnWGw2R3RPMUtEczZwSHFWa3E5MklDTndBdUwxOFhMbTdvcTJNRnN5UFd3?=
 =?utf-8?B?ZWYvenF5WXVuZDRqY1VlbThEZ2dkSERyaE5PUXd0T0RKejRTTisxakhROG05?=
 =?utf-8?B?Ym9vSE83WXp0WXk4YW5xSXE4OGdvTlVBQXEwWUdJN01Ed1llUmxlOVJiRjFB?=
 =?utf-8?B?MXYyb0NvdDRSdk95T3p3NGxraW5aa3NoZkc4TGVMdTIzbTUwUGJXN2RkT3FB?=
 =?utf-8?B?akZac3MwMmhSdzFXeXY0eFk5MHA2QWFKU2x3YVdyUkQyL1M3dkFZTExEM2R4?=
 =?utf-8?B?VEY2N0E0ZTRicGtlU0JuaDdpQTFkd3I2NnhsNkdhN01DVkpDVjFxcnhYbWFK?=
 =?utf-8?B?N09BYnZqRldXRXUvakZZMjZQK1pQMnRKWFZZbUNCckprUUlmVWFpWHpkNDlV?=
 =?utf-8?B?eGJKUWxKSmI1MWd3LzNlZFBZYkZuZ3B5UEE1b1ZOQnlBejJJR0I1UTJTOHg0?=
 =?utf-8?B?UUZqelVJRHptcUdKanF3dER2L0N3SDA2TExnMHphN25TWmRtaWlnNzArdjlt?=
 =?utf-8?B?WWpTbUxGTWtDWFBHMWYwa0l4MGgwOHMwblFLbktsT1dnaGMrZ2dTNE0xa2hM?=
 =?utf-8?B?ZXdla011aVI1UzN1TW40VTd4SmtLUExPTldjM1pMTlFhQS9BeFdMZTdFcnBK?=
 =?utf-8?B?cUlYQ1FmVWx6c1BEb0hzKzUvYXRlT1V1WDVodERPc0JnNkN5OG5kVHBUV1hP?=
 =?utf-8?B?TEtTQlBDWFdGcUJTM1lGWEJjSUx6QkRFUVMxYnRkR3pKUEVJdnY3RE1hejZt?=
 =?utf-8?B?b3YySXRwbnlKZWRiMGVDMFd2eWs1Qkc1UmNHUXI2T0pOMDduSCszUGF6OElY?=
 =?utf-8?B?TlF0U1M1MGJ1RzU5ZlplNEVSejdFbk9RUTFqc3J5MGxPWkRLNFJqSGgxR2hm?=
 =?utf-8?B?bkMzUHN1a2xiT2FldXVVdy9ZT1haZUp0SENFSHRVd1ZySmVDR2ZNbjBNQmE3?=
 =?utf-8?B?Z2tqbEd2SVJkU29WbElaQWNZK0RZM1ZraTF1TjVqWGtvbTh2QVR2bnEyTUxm?=
 =?utf-8?B?cmNEUXFFQnlWeTZ5Nmg3K2tzWm1JYlJGc09pbDhmTkZtek5MeTdEWG0wNTg0?=
 =?utf-8?B?ckxPY0JEeTFWeUREbkoxR2U1RUUyR0FURWJMbDlMK1QxRnZiNjJVS25ZeHYy?=
 =?utf-8?B?aVpFVC9SdXVxMENmRmJoelVrNTRuNFRYd0RWcXB6M09JTGcveW80QVhZNlJv?=
 =?utf-8?B?c2dCK1FET1dsOEZ1MkhrVFkwSmVsUW90Mk9UUnJSNllZR1YwYmRDbkdDdFpQ?=
 =?utf-8?B?MlptQ0RWTVQvOVF6WDlSTFV6YlJxM1dwUFQ4LzRCL2VtdkxRMmhnSVh2R29D?=
 =?utf-8?B?S3ZtSEtrTUJUSlk3ZVIrT2hLZ2I5dmxWbnVZcUhuK3NhSGd3aEpVcEoxVzlC?=
 =?utf-8?B?WFhKOEphZDc1SkhYK3FrRW9aQmVMRCtjNG9McFY1Y1BZc01KVXF1T0RDbGlx?=
 =?utf-8?B?RDU0UkJETmVab1RQTkFlZ0VnQnNhME9MOVZkRWZWY3VBSjFRUlBxT1JxbzlC?=
 =?utf-8?B?Y2czQ2VkNHZZQ01nbndSbndYZW5uUXU4aVpOZzQ0UEFMaFI3cXdtYlJjbEdu?=
 =?utf-8?B?NXZkN0x6RTFvSmpGSDh6cGh2WUNIeElIY2RpczIxNWJ1b01aQTFtR1ZXODNj?=
 =?utf-8?B?dUJqaFpxQmpSYk1Nd0JOUlM0M0hiMnduNHRiTnNDZzYzTFAyTkMzczRzSWNj?=
 =?utf-8?B?aUcrVGhzQTFkU2wvMGV3S1lUOE44T1dPL3RmU3BldXpyZHM4Slp6MVh0U3d3?=
 =?utf-8?Q?P6wba2oAv5g=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a8f537b-9e99-4e1e-d588-08df33733d61
X-MS-Exchange-CrossTenant-AuthSource: SEYPR02MB6964.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2026 15:10:18.8183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR02MB5641

Hi Namjae,

> 
> if (rpc->pending)
>     rsp->hdr.Status = STATUS_BUFFER_OVERFLOW;
> Should we add this check ?
> 
>> +       goto done;
>>
>> +empty:
>> +       err = ksmbd_iov_pin_rsp(work, rsp,
>> +                               offsetof(struct smb2_read_rsp, Buffer));
>> +       if (err)
>> +               goto out_put;
>> +done:
>>         rsp->StructureSize = cpu_to_le16(17);
>>         rsp->DataOffset = 80;
>>         rsp->Reserved = 0;
>> @@ -9349,7 +9375,6 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
>>         rsp->hdr.Status = smb2_pipe_error_status(err,
>>                                                 STATUS_UNEXPECTED_IO_ERROR);
>>         smb2_set_err_rsp(work);
>> -       kvfree(rpc_resp);
>>         return err;
>>  }
>>
>> @@ -9947,7 +9972,7 @@ static noinline int smb2_write_pipe(struct ksmbd_work *work)
>>         if (IS_ERR(rpc)) {
>>                 err = PTR_ERR(rpc);
>>                 rsp->hdr.Status = smb2_pipe_error_status(err,
>> -                                                       STATUS_INVALID_HANDLE);
>> +                                                        STATUS_INVALID_HANDLE);
>>                 smb2_set_err_rsp(work);
>>                 return err;
>>         }
>> @@ -11440,20 +11465,25 @@ static int fsctl_pipe_transceive(struct ksmbd_work *work, u64 id,
>>         struct ksmbd_rpc_command *rpc_resp;
>>         struct ksmbd_session_rpc *rpc;
>>         char *data_buf = (char *)req + le32_to_cpu(req->InputOffset);
>> -       unsigned int nbytes;
>> -       int err;
>> +       unsigned int nbytes = 0;
>> +       int ret;
>>
>>         rpc = ksmbd_session_rpc_get(work, id);
>>         if (IS_ERR(rpc)) {
>> -               err = PTR_ERR(rpc);
>> -               rsp->hdr.Status = smb2_pipe_error_status(err,
>> -                                                       STATUS_INVALID_PARAMETER);
>> +               ret = PTR_ERR(rpc);
>> +               rsp->hdr.Status = smb2_pipe_error_status(ret,
>> +                                                STATUS_INVALID_PARAMETER);
>>                 smb2_set_err_rsp(work);
>>                 return 0;
>>         }
>>
>> -       rpc_resp = ksmbd_rpc_ioctl(work->sess, rpc, data_buf,
>> -                                  le32_to_cpu(req->InputCount));
>> +       /* Write new input without reading past an already buffered reply. */
>> +       if (rpc->pending)
>> +               rpc_resp = ksmbd_rpc_write(work->sess, rpc, data_buf,
>> +                                          le32_to_cpu(req->InputCount));
>> +       else
>> +               rpc_resp = ksmbd_rpc_ioctl(work->sess, rpc, data_buf,
>> +                                          le32_to_cpu(req->InputCount));
> This WRITE leaves KSMBD_DCERPC_RETURN_READY set in mountd. After the
> cached reply is drained, the next TRANSCEIVE can return the previous
> reply without processing its own input.
> 
> Thanks.


Thanks for catching this.

I reproduced the sequence you described and confirmed the problem.

For the READ path, your suggested STATUS_BUFFER_OVERFLOW check looks
appropriate when a positive-length read leaves unread bytes from
the same reply.

For TRANSCEIVE, I think the correct fix needs some discussion.
One possibility is to return STATUS_PIPE_BUSY when cached reply
data remains, without issuing another IPC request or consuming the
cached data. The client would need to drain that reply through READ
before submitting another transaction. MS-FSCC §2.3.48[1] lists
PIPE_BUSY for a pipe containing unread data.

However, I would like to confirm that this is the intended behavior
for this SMB2 path before preparing v4. Simply omitting the WRITE
and returning cached data would still silently discard the input.

Would rejecting the transaction with STATUS_PIPE_BUSY be appropriate
here, or would you prefer a different approach?

[1] https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/f48cecf1-98d8-48dc-926f-2f3a48f07cf6

Thanks,
Wang Zhaolong
