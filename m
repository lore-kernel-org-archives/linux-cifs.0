Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11021083.outbound.protection.outlook.com [40.93.194.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0E81885AD
	for <linux-cifs@vger.kernel.org>; Fri, 27 Dec 2024 16:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735316523; cv=fail; b=eC9D3DmvfBk3Stag1EB0EWKiwAjDslmY4QP8HJ32UhMumY7ZGVoPscGMbQ+YF1no1P5sSkpmHIrZeZ3mnRMMVKiDHC+JgIAs10Dc4uNaraUEDfNKuARCtyhAwXCu7NlkkEg7kr5kKDoJGdcOJHT53HVFDFt8FjT+OIwndLWOtrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735316523; c=relaxed/simple;
	bh=qHSUZuI31TiODTE933mgn7G9DII9/PBWvmvw5WKHggQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LI/+XZlnPWMyNck1tQXWztYxu60jIdZVR3adZ21jccGPrRygFOLPUixq8oCeQIyPwJ0yB6du+QSHFHpE4d60cygMik9yIijPnqheovV0VUSAPwrb2TUrvEC9sOajFkkcUksaaap7yQy55NO4DnIvhhxzJTmmsf6F2oO7rEva2fw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.93.194.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QlUua3rF+vqqEs1O0jOkqihz6jMI+QGinUXPmtAAYMOBt6cDk1ka4yP+y4FnBcrlw7y+xojxmOgcLQeX5glCQ5tROmFljkKB4MeXEhinhTobeZmvfpuZcALIKbvFuZ2Dls2gVu4zJC/bZwUILVXZ9++NYRNocjz6IRDFZ46i6ZJdF2bqkGQcHZtB1nikAyi8tOlE+53wpo303v5pz0G/CPB14eTryIXer8rzsw4nE/p8/GUc2Ho+HDXP3Hu/EMr+bvcHJyyuoX2F/+olrRBlnwBIF+BzdU5UnzJB202Xq22tWK9Aql1Ko24ich0UhhYHpvGhFUjio4KtiW5fNJb1Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9dD4vmOFK6fNATn3HcD6SSyQUEg/SFVFoF8KzX2ZMyw=;
 b=V2WDpsxkv5K7BMpojNUtSAQ4WiCtVyVpooKyrROUbVmDUw1A1FXtxSvmAU8EoXkBnZT8ybt+D88tV0DJj2WuQ131rCiZ6wNUHQ+R7M6rzPpkR9bHt+h2xTC+Hy0PjbgmTiRlrziQm4QwGdV4d0NlzD3c594Gl0QM1bDxRa/rtucXiNJOoKmcndTc1zyCeVNDN1bGKBJ6axbZPPT/clQ6+N5S+Rg52EczSorRzlVPfa9FrEZMHmMJBK3mY4wzat5XNXvfjMTC3H/Bou6ct1Uageff+cNE1UwPw9I3rhBQXbodBbMkwt0x3fLV1scr53LkUnsbB5NMmZ8nEowTXwjvEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BYAPR01MB5238.prod.exchangelabs.com (2603:10b6:a03:91::18) by
 LV2PR01MB7766.prod.exchangelabs.com (2603:10b6:408:171::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8293.16; Fri, 27 Dec 2024 16:21:52 +0000
Received: from BYAPR01MB5238.prod.exchangelabs.com
 ([fe80::cfee:d989:4f94:cef0]) by BYAPR01MB5238.prod.exchangelabs.com
 ([fe80::cfee:d989:4f94:cef0%6]) with mapi id 15.20.8314.001; Fri, 27 Dec 2024
 16:21:52 +0000
Message-ID: <76c28623-b255-4589-8bad-7e576cd1687c@talpey.com>
Date: Fri, 27 Dec 2024 11:21:49 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: SMB2 DELETE vs UNLINK
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
 Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
References: <20241006103127.4f3mix7lhbgqgutg@pali>
 <20241225144742.zef64foqrc6752o7@pali>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <20241225144742.zef64foqrc6752o7@pali>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BN7PR06CA0038.namprd06.prod.outlook.com
 (2603:10b6:408:34::15) To BYAPR01MB5238.prod.exchangelabs.com
 (2603:10b6:a03:91::18)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR01MB5238:EE_|LV2PR01MB7766:EE_
X-MS-Office365-Filtering-Correlation-Id: ea27845b-38a7-4e68-e792-08dd2692926b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VHpNQjROdmdOaVJodU1YYTk5ckJSY3N4MGhrQS9LQk42d1dyeStzdXNLMXdZ?=
 =?utf-8?B?bFh0dzIycnN3WGYyVW91b2N6S04wa0JlbXNPRkJMWTR4OGx3VTY0R1hWVnkz?=
 =?utf-8?B?S0xOZyt4UEMwamtZUW9GL1dNaXMxeTc1SEZIZzdOUDJTelpta1A5VzJTUTdY?=
 =?utf-8?B?WE1ycE5hZGtVTk9ENDRmcFA0SEVFcXNyQ1FwOWMvWkNJNUJ3RUR4bm9wUWNz?=
 =?utf-8?B?MjJuRSszMmtWUFpQMEpjMzJNK1A1cWZ1Mm5oSzdtZ2pwM010WFB6c09ia0xs?=
 =?utf-8?B?cnQwZkNwWUhOUkJIcXlpckpiT3VqWDIxcEZLNW1zcWFwdFNIbW5LNEV5bStM?=
 =?utf-8?B?V3MwUld5V0dlNzQyK0FyelpiWXJCVVNhWFQ0TjhOa250aHFmTkZKcjgxWnlm?=
 =?utf-8?B?dXJxdGJGaXdISVZWZE1hajJZaytBamZ0M1AyK2E3N3VZUjNqdUJvVU1YdWVS?=
 =?utf-8?B?N3A1c0ZkZE1OQ0pYTGY1b2xVQkFvbHIwWUNSb1dDM3ExZzBaaVFUazJvRzFu?=
 =?utf-8?B?VTU2UXlQajk5THZoNVF0ekVUbHZZWjBNbFM0Uk1MUnk5b0RMZXNaK2U3Y0dO?=
 =?utf-8?B?SzM4WU5iNHdvemFKRnd3dGRNYUtXSTI5cTkwNDdTb2hXVlBqY0I5VkRBYzFB?=
 =?utf-8?B?WncxQWdIcUUyQ3ZPT1FxaHNiMldJN3hxUjZENnhadGpwOWw0ZFZpbGp6S1Fw?=
 =?utf-8?B?UlpzaUdmWmd0aGExWUJ3dTlldWh3MVFHVGs2THFsMmkrdVFDSHIwRjlvMTI5?=
 =?utf-8?B?OGtPQnEyUGNZTDlvNGw2VmVZVUp3ekxMTm1ycHhTTktrL0cvdnJVQWxrc0xm?=
 =?utf-8?B?T29SanJMdnpJcnVTZlN1WTZsR2NYUlhGajE4TzB3TWJ3QmhhbkduN0k3b1Mr?=
 =?utf-8?B?NWxudWU1TVZQN2d4OEp2SEVETllPREJ5ek9CUS90SCttM3dJdmxSK0hIbGxV?=
 =?utf-8?B?ekl2MEJnTVE0RVFaSVRmTkJrQ08rK3VPV1pzcTVxU2o2Wk10MC94WWtVOUtI?=
 =?utf-8?B?SW5OVFliUE9NU0JmSHY5Umh3MUxLTHEvVHFhSWNjdDNHMWU2L0hkYXZMUUJM?=
 =?utf-8?B?Z3BsOTN4TXliaUNaOGxmY1VnSXBVbkpPN2wvMmM4cUllWHNQb3duV2tIZ2pF?=
 =?utf-8?B?QW4zdjd5STFhMGJjUU5Lb1hWSVltdlpKempIZHFVNUdZaEt2US9PNGlCV1hY?=
 =?utf-8?B?YTZRUTB6N0NpSTJweEhXb1V4WTJPNWE1Vk5CbmJ0TnVxSG9tOVpxeko5Vll4?=
 =?utf-8?B?OFJLUjRjRU5QdFo1dWlIWWtzUnJYdi9qM0dNbWdsbGJ1LzMza2UxdzlPcVNs?=
 =?utf-8?B?S2JTOTRQMDYzR3J6cktZZS9COUQrT0dQYzR3aEFtTzR0TEtVTUQyUkxqMnVH?=
 =?utf-8?B?U1NSTlBudDc3ZXk3V3FvTGRaZXI1TVdkclB0czJIeXUvNDlHV3RTL0dia1JI?=
 =?utf-8?B?Zk53aythR3plUW1JQ1NhNnpHNm5acnYzU1JiNUFPK3ZSVUtYNVdxMDZoeXF4?=
 =?utf-8?B?cnhxODdxbWlrbDU1RVpleXNCZ0tzSWNsaUJiVTFQeGxYdjh6bVhDTHFzUmxF?=
 =?utf-8?B?L0liTUh3ZWM5TDN6L1NVVVdxNmMyM3NDZkUyalJuditDd2gxcXhEaVh4U2lN?=
 =?utf-8?B?T2xWNmpVRDRQZGNGcG4rcDdjejNseXBISXF2YUJyMEg4NnVKU0hQNU96eUo0?=
 =?utf-8?B?UEJKaGplOGVXMmZsUC9VaUVoaVBjak9qdjZvNVlzeGg2OVBtUnp1T1IvcC9z?=
 =?utf-8?B?aEV5cXE4S09ONE4zT1Y3MTF5S0hlUTlLTGVVVklkUkhFcDdzcTUvT1R3V2k1?=
 =?utf-8?B?bVBIZ2U0QndVZ0t4NTRMUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB5238.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SjJrRlR5N0xFeVU1VDBBYVB3amlDbkQ1SkJSRkU0QXhZYi9nUURJR0pYTm8w?=
 =?utf-8?B?NzhIVksvNGIvdzFYVndCdUhqTGpEK0pDOCtmZlg3TEdpUEFRZ1ZWaVNhQ0wx?=
 =?utf-8?B?c1ZIRHMyampBc2xIYWJyd1lPUnBucGFyTDdiekZ3QUIzcDBqK24wVXBadUVS?=
 =?utf-8?B?bmEwUWh6M1RXWFdKcmU2UDFCcHpERGd0TlNCaTVHcElaVGFaUmdSYkFLcTYz?=
 =?utf-8?B?Qm9LM04xWFIvVVJTTzI5TEQ2djVGYUJIWUNKVEsxSGlBcVN2QXVaaXlva0pa?=
 =?utf-8?B?TXZyY1pJcUkwUmwrcjRuR2Fnd1N1cFJkdzdDcitWcWpxcFM1V2pkSk1sZ0lE?=
 =?utf-8?B?djduQnFNOXZPWGpyenIyYkdKckJuWHJucG56LzZ4eXRJNitZM1NuU3FsNUN1?=
 =?utf-8?B?K04yZE5sQ0FjUWQ0eDErQlJ0WkpPRjY4SUtBVFJaN0JDVVRMVEp3WGNoTStz?=
 =?utf-8?B?ZG5LcG9SZmE2WnVZUEhIOGw0WTJoOXJlSE43Y3hGWVJtYm9YWlNVdWdzd1o4?=
 =?utf-8?B?bHM0Y2Jidk5ockVsQ0JvcnBWeXFQOFFSckFwejVwdUpYQUNXMVFrU2kzdDNo?=
 =?utf-8?B?TE1mZUIrRE93Ym5ESWdEdEp0YXMxTmVWL3JCUnNOSG13dUJqQUlrdFhDNGZ3?=
 =?utf-8?B?bWpDUFk5TXNWdktobnZnZkhkUWk5djJYS3Y4ZE1XY1RMdGJkUklOZmZLSUFt?=
 =?utf-8?B?MGNCdlhsOHhPS1JEU2RGY3BtMDdJdzBwd2Juci9CcytUWENKNGxlMHVER1E5?=
 =?utf-8?B?UUJhUk1rWWJ3OGhjaVZsT1pzM245QlcxNWVkQTZnSmJGQmRZS0ZOeGtRc2tI?=
 =?utf-8?B?bzlVY1J6SlhKWTZwWnkvL25PdWtMYXc0WnJqdktRVFBmVWdCZ24vMHV5YmpY?=
 =?utf-8?B?YzZveWlmRmVudjg4SGdCOEdZT1ZhTlJKaXE5cWFyK3c4VHBkQVp3d09iN3Z1?=
 =?utf-8?B?d1U3VHhMby9Na2JhRmpoT2daMXZQTzBCdmprZ2xuQXc4a2doMnZkVStNTVNp?=
 =?utf-8?B?TURmbEVGeWFEa1g0WWZZdloyNUU3MnczeTVlZVNac25rS3ZHNW96LzE3OGJz?=
 =?utf-8?B?blo1OGlUeW5MZDhlNWVzMFlHR0htcEJxTDN0L3d6M1h3Y3hpRWlqS0dtczB5?=
 =?utf-8?B?QmdaVUpZanpaZ2ltZzFiNEZpZVpYNmRGQjVGL3NGandGd3JabGFrQTRValhk?=
 =?utf-8?B?aC9tRklIVkdtamFrTWU1ZVNGdURxWktWWjVRVFRPdG9vK2s3eHIwdkY3bWlt?=
 =?utf-8?B?d0RvQTQ0eEZndnpSZG96UVNjOW1UM1VlSnBmSnJjVXRqQU9QSThGdnVUUnNM?=
 =?utf-8?B?SG5qa0g5K29WemlwelZEWU9GZURxNzR3eE9DUlhTelJIU3NqZUdEcmw5Y1cz?=
 =?utf-8?B?S2s4cWtQcnRBZE9uY2gzZWRNRnQzZFFjYjhFT3NxbjNPSE0vdS9GOWttUWJr?=
 =?utf-8?B?SDdQV3hPTkR4NjZlOGdKYmIxbXE1UTVQVDRTa0VhdXk0MFN6dXNhWW1PdC9P?=
 =?utf-8?B?TmNvZDdVTWRGRU5ScE1ZUEtnbklDUUFaRzFlUUwzUE5rQUROeDk1WFdnL0Ev?=
 =?utf-8?B?Vk9sU3dZMVN2TDFCNnY5VW9aVmRWbHNTLzd5T1N4QmgyTk1MUnRXVHdzZVBK?=
 =?utf-8?B?Yko5cTYzemc3dDJNVG42RnBTenhCVUpTeWMrRm5EcXpxRnE3aVBqOWIyN2NE?=
 =?utf-8?B?bTlLZFZNbGp5c1Q0bWM1OUorbFN6cU9rODNLOXg3eVBodk9PczUxUlNucjho?=
 =?utf-8?B?MzBRS29yeGNlbHNIT0hOS0ZaTzM3WENvczg4OFlncVBzdGowS1FBelJKR3JN?=
 =?utf-8?B?ck1XNEV1K0t6MG5MYWFaNjV1WjZxQ0hUQWlvUkpEUlVLRmtVSFlsZWJoYjNo?=
 =?utf-8?B?clh0ODBzSnpzTEZmRExQUjI5QitDTEdiUkJJWDNicytFL2lXa0crYXJtV1lD?=
 =?utf-8?B?RmZhb1pKbmdxak1SbDB2blE5T214aHRMTlpxSzEyeFNrZ3Z2Nm9DdWZkZVp1?=
 =?utf-8?B?RGg2cmtkeGMvV0dBby9FS1diUmQwc2laZ1JLZWUxbk1udDA0WENQLzNCcm51?=
 =?utf-8?B?KzJrVXRWSnVyckNZR3QyYkFoWlB1Q3VYYm9SV0o0M2RDdWQ5Y2tQK2o1cEts?=
 =?utf-8?Q?G/As=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea27845b-38a7-4e68-e792-08dd2692926b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB5238.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2024 16:21:52.1829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E3318vRiVlrDV1B8dtF90vFW2pjQpE3ebvgRZSI+qVvBqINuRH2a4WF9AcJ7JY3z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7766

On 12/25/2024 9:47 AM, Pali Rohár wrote:
> On Sunday 06 October 2024 12:31:27 Pali Rohár wrote:
>> Hello,
>>
>> Windows NT systems and SMB2 protocol support only DELETE operation which
>> unlinks file from the directory after the last client/process closes the
>> opened handle.
>>
>> So when file is opened by more client/processes and somebody wants to
>> unlink that file, it stay in the directory until the last client/process
>> stop using it.
>>
>> This DELETE operation can be issued either by CLOSE request on handle
>> opened by DELETE_ON_CLOSE flag, or by SET_INFO request with class 13
>> (FileDispositionInformation) and with set DeletePending flag.
>>
>>
>> But starting with Windows 10, version 1709, there is support also for
>> UNLINK operation, via class 64 (FileDispositionInformationEx) [1] where
>> is FILE_DISPOSITION_POSIX_SEMANTICS flag [2] which does UNLINK after
>> CLOSE and let file content usable for all other processes. Internally
>> Windows NT kernel moves this file on NTFS from its directory into some
>> hidden are. Which is de-facto same as what is POSIX unlink. There is
>> also class 65 (FileRenameInformationEx) which is allows to issue POSIX
>> rename (unlink the target if it exists).
>>
>> What do you think about using & implementing this functionality for the
>> Linux unlink operation? As the class numbers are already reserved and
>> documented, I think that it could make sense to use them also over SMB
>> on POSIX systems.
>>
>>
>> Also there is another flag FILE_DISPOSITION_IGNORE_READONLY_ATTRIBUTE
>> which can be useful for unlink. It allows to unlink also file which has
>> read-only attribute set. So no need to do that racy (unset-readonly,
>> set-delete-pending, set-read-only) compound on files with more file
>> hardlinks.
>>
>> I think that this is something which SMB3 POSIX extensions can use and
>> do not have to invent new extensions for the same functionality.
>>
>>
>> [1] - https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/wdm/ne-wdm-_file_information_class
>> [2] - https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntddk/ns-ntddk-_file_disposition_information_ex
>> [3] - https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntifs/ns-ntifs-_file_rename_information
> 
> And now I figured out that struct FILE_FS_ATTRIBUTE_INFORMATION which
> has member FileSystemAttributes contains new documented bit:
> 
> 0x00000400 - FILE_SUPPORTS_POSIX_UNLINK_RENAME
> The file system supports POSIX-style delete and rename operations.
> 
> See Windows NT spec:
> https://learn.microsoft.com/en-us/windows-hardware/drivers/ddi/ntifs/ns-ntifs-_file_fs_attribute_information
> 
> Interesting is that this struct FILE_FS_ATTRIBUTE_INFORMATION is
> available over SMB protocol too but bit value 0x00000400 is not
> documented in [MS-FSCC] section 2.5.1 FileFsAttributeInformation:
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/ebc7e6e5-4650-4e54-b17c-cf60f6fbeeaa
> 
> So it really looks like that POSIX unlink is prepared for SMB, just is
> not documented or implemented in Windows yet.
> 
> Maybe somebody could ask Microsoft documentation team for more details?
We absolutely should do this, if the bit is visible remotely then it's
an obvious omission. If it can be set remotely, even better.

Feel free to raise the issue yourself! Simply email "dochelp@microsoft.com".
Send as much supporting evidence as you have gathered.

Tom.
