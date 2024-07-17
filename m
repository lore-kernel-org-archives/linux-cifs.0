Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11020078.outbound.protection.outlook.com [52.101.61.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F50439FEB
	for <linux-cifs@vger.kernel.org>; Wed, 17 Jul 2024 11:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721215103; cv=fail; b=NYA7iHr6xs10amDdpdewVAnZ1rVJnAlS+bmfwk9oBw7nN1SN3BWp3ZA0YwnciyEGJDR8dNdGQrQHlpqMjIu4NyORYJlJ7qY+vi073j3NTg/S/OHfJBwL9IMMg9xBp6BsDnsp4TsrT8ANFy5xy4eXOjB4++NN9Hc25/XLHhXfR7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721215103; c=relaxed/simple;
	bh=YBb6dpV6H+SJV8S1lneeRrIeZsp/9BvO+oLxrGgpW/c=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kE17aUD0eeXYCZt7qIC+dcdn4RDyRaX6fJEjMKiHK4f8yEYK0sNtnWj27RM9sup8xUeH3OO1pk0Z0ok+ROQg79Nl/N7Fpo3c5CSjStxNJPh1TGHQqRILDye/cl+DKNVLzs5NJD/EGrjJQxuQlbXjav2ZMJc9BgnHvUysfABrgKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.61.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=facoGDIgTALXycaC/sF1NTOaVOqozIY3dR9qGbg6fcgrruxgyTKw+H3bBswK9dWW/KSVcMJZMqkY+XodojPVLMqFfsYu2TmfNsvFs/e/O1H6EY+Hn/bY6+12qoQO/8Hdeqdf5Sn1K6lCq24Yw1jZZOC+7NdI+05VLUZVQzvBK95E/LU/FbTDvDYkbirBRBVKFLVMqqbCKWX1Q2HxEGJSjIcB70Olp/bHVDub0IEoxtQz4i3NlF2OYyOMDZpZjuTmQd9JshTWA1B2ecPs0uDwI7fHgkHFmR2O1ZYtE+68TREVgRn+FdbGZTS4PgDNn54Ca5SIAgdTT2AuDBp+v+FLGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uVwOfyPDkE536rSuISmV+O4fzF/OoiPJSj6NtDv9FAQ=;
 b=WKA2DD42Wmx0gY4CvswDs13ke32uGRtr0BfNC2BCGTUrywPOi5AyMKhBbWn+RlIChFIcJWrFxjdEM1u1Vv5ijLrmQcqw7zYCIVZl9OVg+UF45wO9wbEtNgJJKDoXsulg92BJRj+sg8i0OoqQF+Zo1G3LoBCoe/pevS/gy2q4ELaF9D+t3g6B4WQGOL2+jT9LKchfdJeC1TBh4QKM5EWMgY31kemY5a36aK97F4VltlsOORNxavzRSqSf0M/dzHYUJhGOzdoTkHMaw+azNJs5yMFWhWKm1PNGt0zaP8jWQjJy4c+5t9b9EUNftpsBBI/jjoGd0+Ms+SONu0qVxBXqbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from CH0PR01MB7170.prod.exchangelabs.com (2603:10b6:610:f8::12) by
 SA6PR01MB8997.prod.exchangelabs.com (2603:10b6:806:42b::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7762.29; Wed, 17 Jul 2024 11:18:18 +0000
Received: from CH0PR01MB7170.prod.exchangelabs.com
 ([fe80::97c:561d:465f:8511]) by CH0PR01MB7170.prod.exchangelabs.com
 ([fe80::97c:561d:465f:8511%7]) with mapi id 15.20.7784.015; Wed, 17 Jul 2024
 11:18:18 +0000
Message-ID: <13f9879c-5286-4469-880c-1f5782a6e702@talpey.com>
Date: Wed, 17 Jul 2024 07:18:16 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: Return SMB2_CREATE_FLAG_REPARSEPOINT in create response
To: Carson Buttars <carson@et.byu.edu>,
 samba-technical <samba-technical@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
References: <64d192b4-8ab9-44f4-a1e5-a62ff5ed0d20@et.byu.edu>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <64d192b4-8ab9-44f4-a1e5-a62ff5ed0d20@et.byu.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:208:36e::15) To CH0PR01MB7170.prod.exchangelabs.com
 (2603:10b6:610:f8::12)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB7170:EE_|SA6PR01MB8997:EE_
X-MS-Office365-Filtering-Correlation-Id: 342bade2-83c1-41e6-e2d1-08dca65228e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cUJHcFIrYVN0dXE0WE1SZ0JlUDJJalpwLzJwNElvYktnSTUrMjhHQlQ1Y2w4?=
 =?utf-8?B?RnJlTExZdWRkL01sR2lRMlhxdk1NL2wzZE8wdFFpK0N6Ym9qbElqSi9JSlI0?=
 =?utf-8?B?NnZCWnNwOUF0aXJhK2VPWWZwZjE2aGJPakVRQTFXMmp6MzJ4Y2tFZDVWQXF4?=
 =?utf-8?B?RlozbVdJRlYxMEsvaDloZVRGbWZEWndiNkY4ZzRrWUFHNUdVb3doTGRZZ0Nm?=
 =?utf-8?B?MTJBUWFqSnlaWVFsZWROb0p5dVJ4ZDQ1Y1dxc2FiSEdRcHRJUFpVb0VJK3hE?=
 =?utf-8?B?NTEvMm4zMmVWV2JoWWVCVGFwZFhHN3pnbGZ5L0R4MVVDbHozZzdKTS9RSEhI?=
 =?utf-8?B?NlZyT00wUEQzRXdheVZLQkkrRGFUU0ZBZ1I3Nlc5OExhZU9QVXhBM3BnWkhI?=
 =?utf-8?B?VzV1T2J2bGNPb21IdmdvRERUT0J4UXVaanlKR1Z6ZFczTFhQR3U0SXJQdUhi?=
 =?utf-8?B?K3duTUo5TDVFQUIyVitXc01va3FpR2xqUU5qL3NPNnVtY0kzdmRLTmtqc3BT?=
 =?utf-8?B?MFV3dmxEWVlhdUlPSVFIVnI0QTRORlM4QlZrREJIVmhsODEwVVo4TlBhMC9k?=
 =?utf-8?B?S3V1TnJ3VW4yMHI5MWdGemZQZTFKbmdDbm1aMng2OWc0WUdkbk5FL1hQbU91?=
 =?utf-8?B?NUVOdlBZUUxwTFZRNEhqV0N2NDkyd0RocXU4RW95ODlJR2lWeG9SUVA3bU5h?=
 =?utf-8?B?VGNXSTFqM0hwUjlGMjhZdXlIVUc2ek95Q0E4UE5RM3B1L0swMmFUME1KRWpQ?=
 =?utf-8?B?NExUMHFSL2dFNk91VUxxN2toeGhIcFFLWU1NckFNTVUxLzN0UW0rVFFxeEhu?=
 =?utf-8?B?NUFLVEE2ZzFPUE5aT2ozdVlxSFU4MmFDdGk2QTlNMnNsUmxWOUVKUHAvTVEz?=
 =?utf-8?B?UjBHdE4zUjBGUEZTRG1FMHBiWTIwZzBXZlFjMjZvU1VudllWNkFaZ0V1dzV4?=
 =?utf-8?B?bWozQUIyK2p2RHBFVDZUTm1pazVCaEQwdTFXb21zNi8xNmlEWDRJeTdXUkRa?=
 =?utf-8?B?TEwrRFFYdk5sQ1l4cXhPVFc3SENrenBWYjFMclh0QUZHQ1hjUW5TejlueEIx?=
 =?utf-8?B?cUtPYm9LMGczT1YzSUZQeDVmYVg1VDB1R05hcUd0SDV5cTdlaWdHLzJFNnZX?=
 =?utf-8?B?VkxVakd1WjdTaTFaMVFJNkgwakcrL2pFOEFjcFJDYWhXaUZKMTRhOW1qalNR?=
 =?utf-8?B?NHdUUDF5emJwdWhwUlhKVTRUNkxlNzBMcjJMNmlDVERDa1R0aEJhNXFsRitv?=
 =?utf-8?B?bHEydVFpUVFDS1YwS2xOdmUwbjJtSDlKODBHNkJsNzJnTnFsaEFnOWdrVkY2?=
 =?utf-8?B?akE3UjI5d0VlWG81OXU5RDBsdy9KMFAvc2pZb3c1Zk1SRVRBa2NtU3I2R3BI?=
 =?utf-8?B?dDlBUFRHMG5LbENLTUN0S1l4czl6c1k0S2hIRk9tU1lYQXBsd1dBMitrQ29D?=
 =?utf-8?B?dXF1bmM2M1N3anBQWWJNeHdMVm41NjI4N1BuSTVnNXF2amw1MzRqMUN3SThC?=
 =?utf-8?B?blpXNC9jNnBnNmdvS3kwMjBZbkdIa0pDVXQ1VkpXYWcrclJmL251d0ZUMzhS?=
 =?utf-8?B?S216akpKTi94SVZyYktmaGdZS0NIdktZYy9jT3oyQSt5OXliRlVtSStzcFVU?=
 =?utf-8?B?eXI2VDRhdzIwTFRSQ1pRWnd0OGZuMHFIb0hjRDJmRFMrVzFuNHlmNFYzQm5N?=
 =?utf-8?B?N2d5aXJOeS9xYkxjNjFGOHc1SXpjeVhxdTR2cEJkWFNWYks3WDhpV3BBbkpm?=
 =?utf-8?Q?6Zk0z5g21m6DU9b40M=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7170.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZkJNZGxQcjhyN2I4ODNaWDZMNFFDd2ZlZWQyUlAvRG5RNHBzVnAyUjVtWDZP?=
 =?utf-8?B?eHdPSUFVYkd3MCtMTnF0VW1CZUxBV1lTVjZGc3RlaGNxMmRDai9ZSUxhdzRv?=
 =?utf-8?B?aDVyalVKQ1g5am9MdUU4ckhrbDB4NnR6aUkvcmJFSnNtdk5PZEd6Yi9QdUtU?=
 =?utf-8?B?TGJUd1hQcE5oY3RpSVBYWkh5SkgxNnA0VEdiYjZEK20xUVZMTkhscllCV3JN?=
 =?utf-8?B?c2J6bmJsN1NsQkpyNXZtbktIYUF6RGVCZWJjREpxQXl6ZlU1aWR5cTNWQkVT?=
 =?utf-8?B?Q2EzNDUyWEx2UkhkQzdQNkdvM2VPNXcrNWo5N2VrWkJlQVlkUWcrRllNK1lp?=
 =?utf-8?B?M24wWndCQWpLVVpKNzJ6WHRSM1BXblhOSGtuZC9vMGNPYTlyL29POGdZd0Y3?=
 =?utf-8?B?S042SEpxRHpzTmtrU1BUblo2OFZ4VlZEZk9icHhGblZRSVh3VWNYMXVyZDll?=
 =?utf-8?B?M253b05pOW1GRldMUFNWdVJVUndITVBCOGRKV0VtN2ZpQzB6Y3FDRWNDckhW?=
 =?utf-8?B?TFBRYktQcVI1MnR3MUt0Rk9WN2lpSEllK29Ga1grakxHamJKTlRodWZ5RFJE?=
 =?utf-8?B?NFdhSzBZeDV0WmRhYUlzb2MzNm9PT2hEQWpBVUQ1aUliLytXdE96TzZkcDlZ?=
 =?utf-8?B?Z1VYano0RkhpNWNsM05LcUZjcnJJcC9FNDhKOGxHY09vdXo2VzBGcUQrSGF6?=
 =?utf-8?B?LzNES3NJVG5EdW44RzZIVDZ3N3VDeXpTcHBiVGRjbUdyK2JzaW54R3dIZFVk?=
 =?utf-8?B?VTltbkJGaXNyRDNhQitUMXdMSlhxSG9TV1NFcG9BRGZtZjgvemZ0ckRWTVNE?=
 =?utf-8?B?T0pvZ3E5ZFdxZU5lTEZiUFNiVEF6VUcxVmZXZzd2amFUZzdmWGV3UVRqTjdy?=
 =?utf-8?B?R0lxbTVTQldSRkwzKzdVdDU5dlE4QlJqQ1Blci9MVndCeWlqZHQ3VC9OVHJH?=
 =?utf-8?B?R2hYeENZV0FrR1hZdnJOWmlSMU9xdlpJVXUveEYzOUlwb2k0QmFJYW9aYXdt?=
 =?utf-8?B?QmJ3ME0zdFY4VjFvQnZTWjVVSjN1bmdoUlpVZnRqckJpRzdYdU42TFJ5RE9V?=
 =?utf-8?B?TE5FMHFBOEhFZFYvYWJKOWRKMXhEQ0g3UzMzcllSU2dkZHY2Skx0WEY1SUhB?=
 =?utf-8?B?UlR6WlQxSENrdXhpWmNhNzVqd2t2MUgrMDNMeWtqLzlFQTRkOVVIM1ZHcjA1?=
 =?utf-8?B?M1JXY3dONXFSVWpHUFVEYWRWYWJ5dGljdWhHZERUUnJHdnN0VGpvT3VuaHQ4?=
 =?utf-8?B?Wkk3cG9aa0hTMGhobUtLSTN1bkdPTXJZYkFjMDJ5TFoxditkVHRlWWFoTU13?=
 =?utf-8?B?ZmsvRGorUUJWTzRRenF4TkZuWmhUYkFTVUk0MEdCZ2FkSjRyQmk3ekpZV2ZI?=
 =?utf-8?B?dVlwMmMxelI0ZSs5c2gydVhtL3Aramp2bXkwQ3I3NFRGVnprendyNkpUVDBv?=
 =?utf-8?B?R1Z0b1JxdFhKaFZDcy9XYm5BQjJOQzZFcGNJOVBFK2U4VWthelpiaVZRTXNM?=
 =?utf-8?B?UEFacXJ3Nzd2d1JnZ3p1US9RQ0wxcG1pRFVIMVg5cDhReFVERHpHTGVvTEw0?=
 =?utf-8?B?WkQvRnlKYytiTTdsM3YxSlQraWJ0VFNQeW80UTNNa2ZQblB2aGprRVdmTk9x?=
 =?utf-8?B?UE9sTjlUcXQwa3EyWmtRZDduZHBsY0pubjdsZkJSa2ttL2E3bnI1ejVNYjFC?=
 =?utf-8?B?RmNld2MrTVZGbmwybGk3RDlGWlpITCsrelA1Uml2MWJLYWdOdXNDLzRvdjdW?=
 =?utf-8?B?aWtrL284bXNLYWtmM0ZlcURCaTlDeEdhazJxUkdJMkxtbEtBV0VwbnZTTTJE?=
 =?utf-8?B?SExuKzNuRW4rNHJZQW9mSTlGVTFURHNBSDRCT3ZqMjRMcXBnd1VGckdFU1Ir?=
 =?utf-8?B?Y0VrNHVrV25YbUJaaVJGYk9LNWNoN2NZRGNMcFR4MDErM252UzZDaXV6bGll?=
 =?utf-8?B?VnJSU3VpNXBiRndxOU9UTkhXNEt6MmJ1ck1qeThhT1FOQncwZVdvSStjeW15?=
 =?utf-8?B?YzZwY0JQbWZkUmorUVNiM0dWSlJTQWk5R2hsdTNtNlhwemNPdTNRNlh5VTVy?=
 =?utf-8?B?c0VaQjM2ZUpjR0IyMXQ0TkcxM0RQVXFyYi9YUEptZzNrRDh3ZlBmN01HbDhT?=
 =?utf-8?Q?DDgE=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 342bade2-83c1-41e6-e2d1-08dca65228e2
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7170.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2024 11:18:18.4239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qe72xzV3NLQpLs0DzM7LxmL/bt98+mI2shXEv9hpFX5HvBcCxJE5ykvjrd+7oaG2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR01MB8997

On 7/16/2024 6:08 PM, Carson Buttars via samba-technical wrote:
> Hello all,
> 
> I just completed the mountpoint detection patch I've been working on, 
> and feedback on it would be great. Here is a link to it: 3141 
> <https://gitlab.com/samba-team/samba/-/merge_requests/3141>.
> 
> In working on this, I also stumbled upon the 
> SMB2_CREATE_FLAG_REPARSEPOINT (MS-SMB2 2.2.14 
> <https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/d166aa9e-0b53-410e-b35e-3933d8131927>) field in the create request, and it seems to not be implemented in any way. There's not a lot of information on it, but as far as I understand, it should be returned if the requested file is opened without the FILE_OPEN_REPARSE_POINT create option and the file is a in fact a reparse point. Am I understanding that right? Is there a good reason to or to not implement it?

[really adding client list this time]

The protocol requires the server to set it, and the Linux client does
inspect it, so clearly yes it should be implemented.

The Linux client sets a reparse_point boolean in the cifs_open_info_data
here:

 
https://elixir.bootlin.com/linux/latest/source/fs/smb/client/smb2inode.c#L851

But the document is silent on what the Windows client does, so it might
be worth raising a dochelp issue to clarify - I'll do that. I'm guessing
it will lead to incorrect behavior, but it's pretty much a corner case.

Good catch. Adding Linux client list btw.

Tom.
