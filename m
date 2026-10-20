Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.43.74
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792504501;
	b=E3jKjSH8VmsONJv/PfmKDKQV6LvNv4+sWsebSxu6+12QdeYO6DUfmr7bbZYWxvInUSt1
	 r+9gnrNGyo1atQmkzyzgU9ru3f15ihqC3RuHG4MnA7AErLCb0QZXPZj0mxcTKMLYfBQYx
	 nMwVAfvtkfu/yo8gCrPi4ZW4uCpThxuao5Wm8ubOQAU2dHaNctmRtb3ouJP4PxydAzFha
	 5woEtAIywPwu+QHII6jGbuQXY9IT9sdtTLAVX+wviqhcGXhfB+vBtPCaDT9UTPFSZd52f
	 jgekIhhz+SdHzmpCOO+rI/ma4DIiQIMp2bSDEPzrqc//l/XGj9stVtWJOHM5n916WKA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792504501;
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
	bh=46/rT3lF4sfx/hGrGWwp+TkOHQdlKVF+5rB2lYityig=;
	b=JqMT2HIfdcMyjnDjIgZBwW0e1Jm3ChRJIFuENT1siFCseG3wpU0NwyEsgEuw+6v6iP0+
	 F2zJwCp9kYS7JGwzOXohA3VykxwyDd4+4/AS+S+1sCAj3YTisgswUHWYvUs0OhvbXIjPr
	 rw1UQld/aAKDhM2lZhBK4EAu62qcEqlp+BIOuAE+NW2ycO6Owwo0BER+GF73ZSZa8wHyK
	 hM4YvvbYXGn13nIpSNZfZno3OJz3iTS4LGo7DnYacLbKhqIMgftyHUg3sdS2DmZiSN4pr
	 OLSU/uIO8WJaeC57nILTfONSE0D9m+QAxWSgwkkoqsDw0STgGV59LJX9cNJRwo48rOw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=outlook.com;
	spf=pass smtp.mailfrom=outlook.com;
	dkim=pass header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=IyfoJGPd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.103.43.74
Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazolkn19013074.outbound.protection.outlook.com [52.103.43.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB28606AB0B;
	Tue, 20 Oct 2026 13:55:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFB28606AB0B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=outlook.com header.i=@outlook.com header.a=rsa-sha256 header.s=selector1 header.b=IyfoJGPd
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Akf9pmrWaJjmUYSuGjUqgGbAkOOjTLDZtyKC4P2HYcbDRaFhrMPybOQ4rlgOxWHr/aVQIAQB0evVQKQ0+vdCDuWNzUA9neoQKOHXZfk8AgkngBOCWS0X8pd1OmX/Gwpp+5OC0BgeT5+GqjKkYeUF8nrTTDZ53hA8wnJJJ1kifTKKb0YysskaKu7pYXUt9/d8X4T6ApeSFkxfXT0B2qAf4sAACJ+1mj6svp0Q3oSe9443mW5uTDTCDIBKOS0CCDQatDLGr1pDCRUg5jlNcQsKetF8rRlNJIZM6QqOsSUqgJ03mXQflaryr6cLg1MU3tk42Mcy2dIkj8AhX41HIAT4Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=46/rT3lF4sfx/hGrGWwp+TkOHQdlKVF+5rB2lYityig=;
 b=ofcEG8U6wcHPzOXdVQwOoccBMP1B6+nEfNMGDnPlxK7cLMox21iECZDzVcDSqcc2rtUPFOcvAmjufcnJVwWaS4Ba9bGMJhnwVHNMP4HM2bRSyDvYYaNci9yQQ3e8N+gDl+xPhhFPWLpp/PtriLoECTBSJXuUYEXDy8DU2aFtCZOEb/0XAnpmxshwvkPBQ4NC/FtkN9WnysSEeJWNKtel0PMkfFx7c0ny/64oFTPkOHPoTF+rpB/kbsMtdjn6eAkKQlSAzLt/d+s6fzHZ2+UC+fbyTZQu62IWVy8yBUJ3mbGEOXyGj+sGielN99ATOXg+KXAGULbt3m73EP+8t8niiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46/rT3lF4sfx/hGrGWwp+TkOHQdlKVF+5rB2lYityig=;
 b=IyfoJGPd5uUiQZnT5AhCsXkzLxSAErtjiEuXU0J0CHpyN/DOmkiwc0eBOy247tTUSs4i+emcBjVPAJZvFM7MGR9QzFkAMrolgqp875V6ieeeqcC/d3b2PtyAyxN9kt5heGdIiK/jeX64qxIpmngXTTcQHmctywPyR1zn02SjKzJu/XG9p/qkM1oYSoaD7bQYuVxtI9UIuW5ABitSwSnBI9ZnHMBJuKsa6X/GXQNiYb5DXhkF+2oW5MeVFNUnILyCb596SNXml8kYwmdUAwEwQ7tTMkHaifMjOb6B2V4w6og8jB3L3J5Wcuj5kr47fL5Cx83crjOi+rFYab6E6sGk3A==
Received: from TYZPR02MB6959.apcprd02.prod.outlook.com (2603:1096:405:2a::5)
 by SG2PR02MB5901.apcprd02.prod.outlook.com (2603:1096:4:1d2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Tue, 20 Oct
 2026 13:54:54 +0000
Received: from TYZPR02MB6959.apcprd02.prod.outlook.com
 ([fe80::c0fb:a6d1:aa86:9d23]) by TYZPR02MB6959.apcprd02.prod.outlook.com
 ([fe80::c0fb:a6d1:aa86:9d23%6]) with mapi id 15.21.0522.017; Tue, 20 Oct 2026
 13:54:54 +0000
Message-ID:
 <TYZPR02MB6959BC66EECFB5D178F92012E6672@TYZPR02MB6959.apcprd02.prod.outlook.com>
Date: Tue, 20 Oct 2026 21:54:51 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] ksmbd: NTLM pass-through to a domain controller
To: Stefan Metzmacher <metze@samba.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Jan Koester <jan.koester@gmx.net>
Cc: linux-cifs@vger.kernel.org, Sergey Senozhatsky
 <senozhatsky@chromium.org>, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Wang Zhaolong <wangzhaolong@fygo.io>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 wang zhaolong <wangzhaolong@fnnas.com>
References: <cover.1792345559.git.jan.koester@gmx.net>
 <CAKYAXd_2AUVQFZWcmk55fBU2Rk-REb-onj38whT=kNCuZ=COew@mail.gmail.com>
 <0cadbdcf-6074-449c-98f9-3aeda3756160@samba.org>
Content-Language: en-US
From: Wang Zhaolong <wangzhaolong3@outlook.com>
In-Reply-To: <0cadbdcf-6074-449c-98f9-3aeda3756160@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCPR01CA0175.jpnprd01.prod.outlook.com
 (2603:1096:400:2b2::15) To TYZPR02MB6959.apcprd02.prod.outlook.com
 (2603:1096:405:2a::5)
X-Microsoft-Original-Message-ID:
 <e8ff4805-69fd-4e32-acc7-ce1977aaed49@outlook.com>
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
X-MS-TrafficTypeDiagnostic: TYZPR02MB6959:EE_|SG2PR02MB5901:EE_
X-MS-Office365-Filtering-Correlation-Id: cfe554ca-41bf-407a-b781-08df2eb1b7fd
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|22091999003|24121999003|6090799003|41001999006|15080799012|23021999003|5072599009|20031999006|24071999003|39105399006|6050399003|19110799012|8060799015|12121999013|4140399003|24021099003|19061999003|3412199025|440099028|26121999007|3430499035|41105399003|40105399003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UFN6UFpHM3BEWkNsSlBabGFRZ0lLajMyd2k0SjAzdnloYkE1eDhlRXlMNnNG?=
 =?utf-8?B?ZGV0VXN1QkNSTTlTT09tNXVzM05USm5IZkJNMFE5Rkdrc2pYSVBBR2J3RkhU?=
 =?utf-8?B?cU9DOEllM2dpLzRGeUljN0RTcVhLQkxaNmRJTWc1RzlDS01kVkJCcTg0am5k?=
 =?utf-8?B?NCt6RmZ1STFISUNnbTdqNDh3eUFHOTU1ZnVXTFhDODZMTHBjYTkxeWZ3bzZt?=
 =?utf-8?B?RGtPc3E3U3dCeGJSRlRsLy9GeExOYTZxOU5mZUwvM3hYQ2VPMU5JQmtDUFIy?=
 =?utf-8?B?TXZxZlpzcnhDTWJZZ0cydGQ2emRHdHdYOVZONWg0R0Z3bWZNOGgxdENSV3VW?=
 =?utf-8?B?MnVDai84ckVLYUx0L3RNMjFsUmsveW5OVDcrSU5vZUFDVTJXYmUzdTdzZWhh?=
 =?utf-8?B?cUpBWjdGRjAxcy8xNm1mUDlPalZkdnNCMjNiUGRjdnU4N3NqLzFyT1UwcHpu?=
 =?utf-8?B?TUVyK0ZVVlZhVkhWZDNMMjVFQ2lKbzF4ZjM1RU9UbEs1U01SWldjSzgzbzRy?=
 =?utf-8?B?MVdQMmFlYW12THlyeUQ3MVpUck1TWlpva3p0cVZGNU5FTytXWVhpNDV2WVVX?=
 =?utf-8?B?S09FS2ZwQ0VraVJkUVRnd2c5ZG5WRGFZSjBJK0d4d0hYUVJXRCs2TE1ZdUty?=
 =?utf-8?B?YU1ZeFlVSE9FTHpKOEtYdGx3L2kzeDRFQTR5ZGx3R0hONk93S1FTcXNBaFNQ?=
 =?utf-8?B?OHhrWmRxdWh1OFdkYUFhVzY0M3hhMU4yMlg1Mk9vV25xaFJGbWVMWUhiTUtR?=
 =?utf-8?B?WjJLQjZ3aDJLRmtLeExtOVZqRlUxVVFhTk5OeXVQQ2xtU1QzcWNpZW96RVd2?=
 =?utf-8?B?THJvNFBXaXFsQXNib3o5TXNsSHZscEp5cnR4NENLVVZqeUVvK1RpZGoyWlZE?=
 =?utf-8?B?bVZsSTlGLzdEWDJIamF0dmpWVlJyRHR3Zm1MRWNsZDYvRHVuaFNkWWJPS3NS?=
 =?utf-8?B?bUJNalFTbUV2NXdzWERKSjhhZHRBakRWNmFQT1cxSWFmeU90QVhocW5EdUtS?=
 =?utf-8?B?Y0NvN2UwQUU4ZGgwSXFJS0RwNldUK0RIc0oyZWptWmkrRk9odjJvZ3Y3dVdp?=
 =?utf-8?B?NjY3bWF0YjNxQVcvSTQrVVk5alZLZ1lSWktEQ0lWTGhKNGlDWFBKRDRla1Ey?=
 =?utf-8?B?QzFyV2xxWU1iYkNqc3l4cHhIOUJ3aFUrM3l1cGFHbExKWFZCZmxhN25VUi80?=
 =?utf-8?B?aEdhYkQ1S3BncGduSU1aQ1VQQmJVWTMyVzNXQW4rRU5MTnlVR1h4OTF6S24z?=
 =?utf-8?B?TjdSMlVXSUIwM1VpSGVTMUZZR3FZUXA1c09oaklpSGV2SnlrY1VETTlkelZO?=
 =?utf-8?B?aHNaaVllZm8xSGpTdUZsYkhhUGw5OERmZDRVaC9ubUMvNEwrdUJNZ1c2dE4w?=
 =?utf-8?B?azY4YnQ4SEZjaUtIeDM2dG5PcTRtYUNYcE44dVhIdWlPUlJnb2xLRWljRkRt?=
 =?utf-8?B?c084SEJIcWIyNjNVRTdra2ZaaitjWkVhYUZCVTdCY3FJNTUvVE5QUVZMaE1O?=
 =?utf-8?B?ZGhoNnB6ZXFXZUhBd2JsU0tkNUtoSVJrN1VhemcrOUtNMHlUV1BvY3NyZXMr?=
 =?utf-8?B?REFZcURkK0lSaWJ1Njh5NWxoWkJWU2FsTTlvajZzK0p2WWd2S1ZPOXpBSEVW?=
 =?utf-8?B?ZHhtRDg3SmFVdi9FQ21BNkpudVd0b2tYTU5uZnM5cUthaGRFTDZwTDhBZXJW?=
 =?utf-8?Q?QENGQECC5HcgcgeLH8VC?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?b3FEeXpDSmJzby9uSHV2OUMwZXZhcXdPeWpCR1ArV04yY0p3TEpZd2YycHBi?=
 =?utf-8?B?UllHNlB0ZjRmQXZia1VmNEdUTXhZTzRUOXZldnFkMERLYjhhSDl2VjNoSXky?=
 =?utf-8?B?UmN0RlQvVVhpMXBpU3ltMHd1cVJySENjb1lYdmovaWJ1YjZydGFHQnp6Ukxu?=
 =?utf-8?B?V0VFdlJzYkFiN3J2cEtvVmkyR1BSK2hrR2hCanFkeGtkbHlNOVBVcUx3Qmtz?=
 =?utf-8?B?NzlyTjhaN0xJQmFQeTN2Y0QrVjVxMmJ2UFVBVTZWSHRQOGwvdERXSXFOZm81?=
 =?utf-8?B?OWJvU1RVem4xY3g2d0ZGcU9SRGsxWkg0Q2xIR205b05FYlJsLzRpcEVuUHBI?=
 =?utf-8?B?bmxBRnV6SUpuNkdzdmdqNU9tVmxKWFozR2p1ZytDVzlGU0lnVm5KRGg4eUgx?=
 =?utf-8?B?OWNOZmNJYTFCTnVzcFIrZ1ZtMHBZK0RRUExrZmFmZCthTlRzNU9OUzdsdzVq?=
 =?utf-8?B?d2hMeFZpUDVWMElhREpTN2htbldpSW5NckMvdnFtQzJZSHh2Z08xc2FDZXdr?=
 =?utf-8?B?NEZ4Vkx5Um0vVVdBNlJzZ3B1OFJRbEUxZHhMSHd4bi9BZWZlTGpwd01SL1FX?=
 =?utf-8?B?TEZrekdKdVFJQzM3cE44UTAyVkphcFRiaWFhOGU3OTlrVlIvMEZBckUrdWcy?=
 =?utf-8?B?bXdBcVJKVHMyd2ZtT2dvd2xLZ1pTY3VvblgvdlUyb3RNdDNsTU5MWXFNVG9T?=
 =?utf-8?B?UkpIR2dGYk9UbHhYcy9ZbTRkUFBJK0J5WHV6UXNDQWRENmxuZWVtVEtiM2tl?=
 =?utf-8?B?NUFVNzhLdzJpRklMUi8yU21CRTF2T25yNkYveU1sc3RUeFk1UVh0dU5PUWR2?=
 =?utf-8?B?emgyUHJ6ZEZGQllncVVsbnpCNVNVOGpLanVWTHZUaWsreDhlME96WVdZMkNE?=
 =?utf-8?B?cmVZd2MrVEVuMG8xdFY0YVFRSVlXcmhRenEyZmlsWmNPUE5qcWRXUkkydldM?=
 =?utf-8?B?N3o5LzU1b1JJVGFLSndCZStjMzRhbXNYaVlBTXdtdVNuTmJvQUpNSlNRUnBJ?=
 =?utf-8?B?WFZBVUN3b2VYWmlxZ0pKSVIrVzNOTFVDNEJFOEs2c21KK1A2Y0NvVzhBV3hF?=
 =?utf-8?B?eVk3a0VvUGxKYWFwYktNQVN3dWJicml2RVVYU0tXL1BreE8yQkpsUE83czZi?=
 =?utf-8?B?ZCtqTWRLRlZhcC92NFhBNk9VaVBPV0ZNRTFYMm5VN1lhZHN3UldNSlpqbGh0?=
 =?utf-8?B?a1BubUFOWWdFUXNmLzBrRC9abVhEcVlSNk1PdkFRQlUwTjZjNDc4dSsraGI4?=
 =?utf-8?B?SnFkaFczaUVYSjcyanVvTklEblpTamcrNS90UDZXSmloUFNDN0o5cTlGeVN2?=
 =?utf-8?B?WXBaeEEzRFp2Y0kyeUVRZDcxSnAzNkE3RDhYNzRndnozOGVEaHo1T2VCb3lB?=
 =?utf-8?B?b3RoYmpmcTgreVlpMittTjZOUnRhQnhDN0IrQUxiV3NGbnAzblRhM1cxZzdi?=
 =?utf-8?B?d3k3Z0RyMjdXQTJxOCtwVTdsemc3OHRJdWt3Mytjc01DVDF0NHp4a3o3MWJo?=
 =?utf-8?B?V1gyZnl0UTY4ZEMrNUJLU2lJbzFidjh1UjROVEZMSmM2RmNLL1Vad2k2azRO?=
 =?utf-8?B?R2lFQWZXNGFuTUdFR1lGYUovYVVvQUpMdmFIeW53RjM1RmJmU2VFYkxMdy94?=
 =?utf-8?B?TmFUNUJoUzZ1cGN2VXNNLytKY3JkaStpWU90MnY0Mk5BUXlUTDVxZ3dEOE9u?=
 =?utf-8?B?NExDS0JIK3FrSXM0dGNyQUhwWnlhb3R0NzczQkRKL1ZJVkdFa0VHRk9PSEJ0?=
 =?utf-8?B?eGNSL1dVbFZTTTcxZWVrc00wSm9ZakJVV0NhRUVJd0F2bmV0RTRvczltbDJn?=
 =?utf-8?B?RGcyMGJPeHI5cUdUeHFZZzd3TVRxeGpFS1BvMDZHZjlTL3dBZGZVTzhvK0hk?=
 =?utf-8?B?MVJJcFBJL0kzRU5vV3hZYUJLTEd6RkJBM1paVDZqbHkrNUE9PQ==?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfe554ca-41bf-407a-b781-08df2eb1b7fd
X-MS-Exchange-CrossTenant-AuthSource: TYZPR02MB6959.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 13:54:54.3426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR02MB5901

Hi Stefan, Namjae, Jan,

Thanks for bringing me into the discussion, and sorry for the delayed response.

> And Wang, what are the AD/DC features?

I'm working on adding Active Directory Domain Controller support to ksmbd,
rather than just allowing ksmbd to join an existing AD domain as a member
server.

The initial goal is a single writable AD domain controller, supporting one
forest, one domain and one site, with most of the new AD services implemented
in Rust userspace components.

The planned functionality includes:

- AD directory services, including LDAP, DNS and CLDAP discovery.
- Kerberos KDC and PAC support.
- NETLOGON and domain secure-channel functionality.
- Integration with ksmbd authentication, identity mapping and authorization.
- Windows domain join and logon, including SYSVOL/NETLOGON and Group Policy support.

The existing ksmbd kernel SMB data path would remain in place, while the
AD services and directory/account management would primarily live in userspace.

The implementation is still at an early stage, with some initial discovery,
directory and credential-management components in place. A fully functional
AD DC is still a long way off.

> why making this NTLM specific, I think it would be good to the whole session setup
> blob exchange to userspace, so that authentication is not used in kernel at all?
> And it will also help when IAKERB and other things will be implemented later.
> It would also be good to have the infrastructure working with winbindd being
> the bridge to the domain.

I think keeping authentication protocol handling and identity services in
userspace is worth considering, particularly as support for additional
authentication mechanisms is introduced.

However, I haven't evaluated the implications of moving the entire SMB Session
Setup authentication exchange to userspace yet, so I don't have a concrete
proposal for that interface at this point.

I also understand Namjae's preference for keeping the current NTLM pass-through
changes minimal.

Jan's patches primarily address authentication against an existing domain controller,
while my work aims to implement the domain controller services themselves. These are
different goals, but there may be opportunities to share or align some of the
userspace authentication and NETLOGON infrastructure.

I'd be happy to discuss the architecture and coordinate the development to avoid
overlapping work.

Best regards,
Wang Zhaolong
