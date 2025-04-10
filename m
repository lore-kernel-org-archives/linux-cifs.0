Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11020118.outbound.protection.outlook.com [52.101.51.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E364A1C3BEB
	for <linux-cifs@vger.kernel.org>; Thu, 10 Apr 2025 05:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.51.118
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744264628; cv=fail; b=GmzMPo5k3ItfUNMmz2kbVXlZd9eYj7imysmz8Y4sZyHN4sWf0r7ncBr6jVVhv3XN12oJNL0+e2QXft95WDFUrml44unT3kIlTd6IV2TIDSuU7KqPax70gutMePqt//cbA3xiw2tHQzd59FwIKwrU3fgS5dn0PMvbcu0D+0PSWP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744264628; c=relaxed/simple;
	bh=ATtBT/nijlUQpRZm3ncaaxd8fQ1T47wUs8BloZqx8tA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kDChshjq/6dKl9GdbHRcCFAibekZQTlqUP9hBrid4bOfosxOhZuj8g9DgydjDlN7ITUlitUjjLCpQRWmjBfOr3W6NDJnMLS5aOMB2QQgaakmWrFtHcGKUZYC6LW5pTg9hndbq9rt/4SbbfYyPcO/JFIWsqBjhR7orIRggtpz8Sk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.51.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ceblrqvUIlmhs0/8olHv8zGXHzcIS1u8hTMwP9ISxNuVhwWeX9mN86Gb67HpS40TWxVN492YquWWoF6vwpreebg9OZCdOnqgDghh30Y032fhoPkstZ1AP3VT3KrCCcQrraugBxaKgaHNu43WZD/skWqlAM0rMaqNYiQi7eouti09T/ldyOVKuFnC+4oT0qa4zXamTe67Y2sLmLCFvd2SO+8esmjew8RruD+RfBnA/g6xwF/1xEiBlXqjaFvp5oIQoM9Z87vr7eV9g/c6AEdTltKdXhjQeEIyd/CZY10GYwBOaRaKjas/mT461frgel7Nv2f+6CBpNeF4rI6XOyN10A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NgE6kIfKPqn65e4Bfj1tuy6RutJzrFU2Hsq26GkkZss=;
 b=QiIViyE84oi8HtX3DG/1913f2s1CdVekVXYbY39kgFr2BzR++cG+3BIRnojIwL6htZOUeqdL0Qfl/S0JcZYkJIGrfNU/X5SuqlgI1QUDv4NzshKpmMomJTi7pWzMc2/NnJVUW6Gje9v77egOBk0mWzfX3QmjHf+67iIZyJ4oaxnM49lXv2JqdgxyDES+/PjtcZvpPddFKB1JtbAf3+AnrQ1+2d2Bj3GFv+YUWDqpUYAVfUqOYMYdapeolJ0OWSTXUL8Yt4mUca7ExnTmJSirnGAgsnVEP+fomH0/ArmH+qoD6zcOjyA2yztdv7JSJoqdbPmLV3pVXXpmFs0K1NefhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB3854.prod.exchangelabs.com (2603:10b6:805:19::20) by
 DS4PR01MB9249.prod.exchangelabs.com (2603:10b6:8:281::15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8606.34; Thu, 10 Apr 2025 05:57:04 +0000
Received: from SN6PR01MB3854.prod.exchangelabs.com
 ([fe80::66af:6788:adc5:f856]) by SN6PR01MB3854.prod.exchangelabs.com
 ([fe80::66af:6788:adc5:f856%6]) with mapi id 15.20.8606.033; Thu, 10 Apr 2025
 05:57:04 +0000
Message-ID: <97c13b13-56f2-4c43-b851-e14ccb891933@talpey.com>
Date: Thu, 10 Apr 2025 07:57:00 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [EXTERNAL] Fwd: SMB2 DELETE vs UNLINK -
 TrackingID#2504090040009564
To: Michael Bowen <Mike.Bowen@microsoft.com>, Ralph Boehme <slow@samba.org>
Cc: smfrench <smfrench@gmail.com>, =?UTF-8?Q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, CIFS <linux-cifs@vger.kernel.org>,
 Microsoft Support <supportmail@microsoft.com>
References: <20250408224309.kscufcpvgiedx27v@pali>
 <6f5031e9-36d4-4521-a07a-6892cc5ce8a3@samba.org>
 <MWHPR21MB45241411805698FB51F0F4F294B42@MWHPR21MB4524.namprd21.prod.outlook.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <MWHPR21MB45241411805698FB51F0F4F294B42@MWHPR21MB4524.namprd21.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0212.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:e4::11) To SN6PR01MB3854.prod.exchangelabs.com
 (2603:10b6:805:19::20)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB3854:EE_|DS4PR01MB9249:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f2472f8-3150-42d1-f175-08dd77f48519
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?akI0MXljLy9GQ1dRcmdxV2JyMXdhQzRGSXlFaGhmcSszWGM4dGVzcnYvblR3?=
 =?utf-8?B?bWxhdzdPSzdsNUJ4eVA5b293MjFvOG9HamllTTFLV0p4cmlGa3hGNHh5Nk1L?=
 =?utf-8?B?anhxN3BZNzBNdlJ1aXVWT0tJbE9pQ2pJZEVKL3czd2RvbHNIdFN0c0grMWpZ?=
 =?utf-8?B?SVV4UHpOMU5rZ0pxdDZNVTg3dVN6dEVYWlAzMmNTbUVEbGhYRFF5bXB1Rng4?=
 =?utf-8?B?ZDhTWFg4Wll0VmpRMFJoT0Z1NHRnWjhsNXBEMHo0bWVwd1JBNjhFQThpbFBo?=
 =?utf-8?B?b0crNWcvQ09oKzM5N3g2MktSNnY1VnU4c3YrNlFVRkN2bjVMZlY0MGpqckYx?=
 =?utf-8?B?VURGKzE4SVV2U2czR3dBL3BpeUR2Y1BwOUJjNjhTVzRrKytaSVAzRjdObGsw?=
 =?utf-8?B?enU4K0lJYzNEanNURHNHb053VzVFV045elJnSCtMK3ZQRTZpUkJEZDdQWXd1?=
 =?utf-8?B?QUZjaUcyVjZCL0ttangxTGNUT0dJVVZhQkxBakxMUjVSNGpMczgvTCtWMTNK?=
 =?utf-8?B?T3BscjQ4OWdmQTIxazI2YjBQckEydGRhbWFmK0VJOE43SWk5VzB5SksxMVdi?=
 =?utf-8?B?YlNFYlFyWDVZeVliVGVHME1yOXE0TDlvVGp2b3lWZnp3eVR1L2lubU91SlNF?=
 =?utf-8?B?dWg3ek10dXptTTEyblhEdEVoeU9MbVhPTGlDTVNRL1VBSkpPZ2dETXozZHJx?=
 =?utf-8?B?dDVPMjM3R0szSVo0ak9RQkkyc2Q1aTd4d3NZV2JISDg2YWhISWF5YUhPVVlt?=
 =?utf-8?B?VnNXQXN2MVg3RTZkNTFVSS9MaDFHNkcrK1JQUml5RVg5REpMUENsR20wSGxq?=
 =?utf-8?B?Wmg3Rm9nTm9tZElYNnN5bGswdWk0dEJ1SUlQOVREK1VRTE02K3dSaTFZS0lR?=
 =?utf-8?B?cjhBb21BZCs5eGhob3Z5cmFoWUEwZlRzZWFlRklseTh5YnF2Y2RmWkJLaGx3?=
 =?utf-8?B?RjhTakNQWXBWZmlQTHhPRGFqU1ZFQ0VXYkk5SU5sMmVINm9nNzBhalhhZE1i?=
 =?utf-8?B?aFlvWHUrSFEzV1RTL0JyQ1dtZ3NVdDJCRUpTTXVLQWVOdHV4U2JrdnM1UWd1?=
 =?utf-8?B?NnBFQ1FpMjVDQkM4M25hV2gybkZFRCtReG5GNmNXZnlGSjFIWG9ISnRZcGJ5?=
 =?utf-8?B?aHJJRlEreTZyZFE1bVdWTTRHWE90S1VOMXNkS0ZHT1VkOWw5L3pGcWxFenZD?=
 =?utf-8?B?Ukhwb3RkYlZ6OFNONU5Yd0RzS0hkOGIraWhJcnFTcUdIRGk2NzRvT01qV01s?=
 =?utf-8?B?c25XV0I0K2l5ZUVlcTBLbnp1emMxK0hwTUxyMUF2WmlCVFh3RFN5czNZLzZF?=
 =?utf-8?B?QStTalh5VDBoeC9LS3VqZ0VqVDlmaHFHOEJ1U042TEIvY012bUIwcVBqemxr?=
 =?utf-8?B?QXFtVU81Yzc1Q3ovWHRXU1paWFYxaWYvT0F0bFA4Rnk5Zk9BUGVmVmEyKzM5?=
 =?utf-8?B?cTZTZUtlUXZ0ZkxEbUk5bFBrMGgvL25TNjlGazJuUnVmSmNBU3REOWlCenJr?=
 =?utf-8?B?VXEySDh4WEplclV3YWp6VzBpc2tJZTk0UkN0eEx0aE9OZlZBcVdnQjBZYjNj?=
 =?utf-8?B?VHlzTk1qMFRQRWp3NkNXNzlZNU1rUUdBMGUra1o5eTVoQnBWUlh0LzlrU0hH?=
 =?utf-8?B?ME5EWElnYlFkNFNheWxkK2V2R09jem1ZMFI3NE84aSt3aUl2SDR5R0FuZmN1?=
 =?utf-8?B?VnpIbHVaRkdtVzZtMGwzNktVS1lWd3llZ3dhdXd5bXJ1QXRtWVo3amtJTkRR?=
 =?utf-8?B?YnN1OVBrNzFMaFpxa1VsQU9NQ0d5clJrYVVJbHBhdnJMMFpBYnNsclZJWnl1?=
 =?utf-8?Q?LTlqbNzTKsnc2pyJ/nUoXB5/KwUKmKV9Ld7z8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB3854.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(13003099007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S2JmWXpNN2JZcEQwSTlFc0JKZzFMbS9sd3QwVGpCUHBuL3R5VVphK2lGb1oy?=
 =?utf-8?B?VDRSeDhON0lWYzRmU2RXb1p6S3RmZXU2aHVXd2RxcW1yd3dSSVFDVWw0bXVv?=
 =?utf-8?B?ZzhSbnR5TGJHaElVdnY2V3Z6SjhQS2JBNUxWU2F6Um9HZk9uNlFlWlFoeUtK?=
 =?utf-8?B?MmV1YzhzWmtQWnhjTk0wWVBDeVZWSkRMV0lsejFzTnoraXg4cEQrYUNsbVI5?=
 =?utf-8?B?SWJBOTZrSjYvaFI4c0NzeW5HSjU2RWg1TjlYOE5ncWJwSFJDUlIybFRaaGlC?=
 =?utf-8?B?WXFFZ2NBd3AxdysvRXcrdE1mbW9XMUJaekpvaEFzOU1oUWVXV3lWOWVKQzE2?=
 =?utf-8?B?Um9xUXlKckNtSzgzalVSbmQxTi9mcEJpaXlUVm93SnROb0RVQ295dG1SWVZl?=
 =?utf-8?B?eWQ3UXRhbmFzc3NYRXBMM2NDMHhwY2E3SjN4Z05qYW1MUERCbEFoSzFVYnQ0?=
 =?utf-8?B?eGpkRnQrM09EdHdlYTdWc1JMWGtrZVg2aDZpQ1NZZC9MdjlJY2tGcUdINExS?=
 =?utf-8?B?cnZxdHBRTFdzSHByWnN3VG1xYjdwQ0JGQ3BhdUl0Tjl5dWlaTURxSlZpMzFU?=
 =?utf-8?B?amllYlBkVEpQSXZiRkpVWTBMQU1xT21yS3hLNmdKalNxK3c3bTFuaHNacGJo?=
 =?utf-8?B?ci94dlNaRXhXMC9FN0dpeVppR3JCNHo0K0w4MXFkWmdDRjlEUmlwOGlCeFFi?=
 =?utf-8?B?aTAvRU9FMXZGam5OeDl0NUlic0krL2tIeVBEZnVJbDN1em9vSzNrbWx5YVRV?=
 =?utf-8?B?SWo5Tm5NTWZVVlpqVTNUNm02SEdEUC9rbE1wbEo0Z1MyOHNzSVQwR3hycE5v?=
 =?utf-8?B?anEwalA1WXJqQ05JQVdkSC9LQTNLRFZsL0xjcFBCYlBOM2R1cmtDczgrTnVx?=
 =?utf-8?B?Ty9Bdm11NXRPWHo4eVAydk1FSDd5WGNBbzdSTzk2anVpVHlJU0VxMHV3elcv?=
 =?utf-8?B?Y1NZOHNkMXArQjBvbFMwTHV1WnJFeGxRVDJGUGFhM2ZYdVU3QmljaXlGU3o3?=
 =?utf-8?B?U2xuR2xhd1QwQm41cXdhWWtaUEZMcFN5T05jSHF6bWxpeDV0anYyeVpOTUQz?=
 =?utf-8?B?Z1NGU09NZ1JvVTNIUFEyQlpUQVNWL3VYalg1NVFPRElEbFVQZTFncngxVDJX?=
 =?utf-8?B?QUM2ZGZRYXQrcWhtK0hiUUZSODhYOUZiUGdZUkprd0J2UURuNHRHcTA3c3Nm?=
 =?utf-8?B?V09Qb01ockdscWx1eVhRMi8wUU9TRkhEVGd1L1hCZ0VrSWVKeE53Vko1eGVL?=
 =?utf-8?B?VHF2SDJ5cS9sbHI2Yk9sbmhwQVdVdlI1S1hrSm83Y2MvdW96WWFkYmZON1NY?=
 =?utf-8?B?RktUbDkzWTFUaVlyUTRpUkVNZGFLOVFaa3d4c1ZXUGxUY29JdGZYVGNkcG0y?=
 =?utf-8?B?eWJUNG0rclB0eVQ4RVpVLzdZdkJSZFByc1EzY28yejFjNWpyUmwxOWQ5aVU2?=
 =?utf-8?B?dFJ3MXF5NTQ0RFl1em9nckp0YXFQem1hVkVMcjhzR29YZTN5Y1Z3Mmc3VStR?=
 =?utf-8?B?dUlFWkV2SkR3UDRlaGhCMDZkVWJQNHVhRXlmRU1uNkR3ZE5TUFdCelo1S0E3?=
 =?utf-8?B?S2h5K3dKekFrY3BrMERucWNXd0taMit4c2JnYmpzcDk2blRlRG9GdGxQTUhm?=
 =?utf-8?B?Sk5MYUkzSFBpTzJRMnU3Z0RPWnVMU0hZY1hwZW5ZbzhETFViZzhGRTg1UTJa?=
 =?utf-8?B?d2dxZ2s1WnB2Q1JYczErcnVQNEpJenBEWUViNVhHM29MUUdWNjYyZUVrRmU0?=
 =?utf-8?B?dFI2aUdheVV5NWxuNlQ4bW5mbG40MkF5RFVYc0FCNFlMN3Q3MFpHcCtORW4r?=
 =?utf-8?B?TDFvOVJ0YjZDSFlyK3ZIaENLMDl2eDQ0cEJva0ZLaEh4djh4TnZBdGZSMXg0?=
 =?utf-8?B?WERjaWRmRDBROG12cGJhQnNiQ3hNVHVLZFc4RTdRVHU0b0wzZlFwRDcxQXRV?=
 =?utf-8?B?R3MvZmlSVjYvaVh3MmRjc1hWTGl5QUZqT00vZEExTGl4aXlUK0pGVWwwQzFl?=
 =?utf-8?B?b1AyYnFHdUVVam1FVkdPTkYrRVlvNFZrVUJUaUU2dVRVdXVOYjEvNEZaWVZw?=
 =?utf-8?B?VkI0Mmc2SlZXZUVFN0FQZXVPUDBETHZQUXFJYzdGNVRIMU0yU28rRmhCNkp1?=
 =?utf-8?Q?CM7s=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f2472f8-3150-42d1-f175-08dd77f48519
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB3854.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 05:57:04.7184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X9FsZ0RhlxddXigbmnN0/QQLXggoYLONaPJGaJajQ2QyF05jbzvDJzGn7eEuE27I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR01MB9249

Thank you Michael and yes, processing rules in the SMB and filesystem
components are necessary. To which I'll add, which Windows SKUs actually
perform them (behavior notes).

Tom.

On 4/9/2025 5:57 PM, Michael Bowen wrote:
> [DocHelp to bcc]
> 
> Hi Ralph,
> 
> Thanks for your question about SMB2. We've created case number 2504090040009564 to track this issue. One of our engineers will contact you soon.
> 
> Best regards,
> Michael Bowen
> Microsoft Open Specifications Support
> 
> -----Original Message-----
> From: Ralph Boehme <slow@samba.org>
> Sent: Tuesday, April 8, 2025 11:51 PM
> To: Interoperability Documentation Help <dochelp@microsoft.com>
> Cc: smfrench <smfrench@gmail.com>; tom <tom@talpey.com>; Pali Rohár <pali@kernel.org>; CIFS <linux-cifs@vger.kernel.org>
> Subject: [EXTERNAL] Fwd: SMB2 DELETE vs UNLINK
> 
> Hello dochelp,
> 
> it seems the updates for POSIX unlink and rename made it into MS-FSCC
> 
> <https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/f1f88b22-15c6-4081-a899-788511ae2ed9>
> 
> but I don't see accompanying updates to MS-FSA and, if supported over SMB, MS-SMB2.
> 
> Is this coming? If this is supported over SMB by Windows it is not sufficient to have it burried in MS-FSCC. :)
> 
> Thanks!
> -slow
> 
> -------- Forwarded Message --------
> Subject: Re: SMB2 DELETE vs UNLINK
> Date: Wed, 9 Apr 2025 00:43:09 +0200
> From: Pali Rohár <pali@kernel.org>
> To: linux-cifs@vger.kernel.org
> CC: Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, Namjae Jeon <linkinjeon@kernel.org>, Ralph Boehme <slow@samba.org>
> 
> On Friday 27 December 2024 19:51:30 Pali Rohár wrote:
>> On Friday 27 December 2024 11:43:58 Tom Talpey wrote:
>>> On 12/27/2024 11:32 AM, Pali Rohár wrote:
>>>> On Friday 27 December 2024 11:21:49 Tom Talpey wrote:
>>>>> Feel free to raise the issue yourself! Simply email "dochelp@microsoft.com".
>>>>> Send as much supporting evidence as you have gathered.
>>>>>
>>>>> Tom.
>>>>
>>>> Ok. I can do it. Should I include somebody else into copy?
>>>
>>> Sure, you may include me, tell them I sent you. :)
>>>
>>> Tom.
>>>
>>
>> Just note for others that I have already sent email to dochelp.
> 
> Hello, I have good news!
> 
> dochelp on 04/07/2025 updated MS-FSCC documentation and now it contains the structures to issue the POSIX UNLINK and RENAME operations.
> 
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/f1f88b22-15c6-4081-a899-788511ae2ed9
> MS-FSCC 7 Change Tracking
> 
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/2e860264-018a-47b3-8555-565a13b35a45
> MS-FSCC 2.4.12 FileDispositionInformationEx has FILE_DISPOSITION_POSIX_SEMANTICS
> 
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/4217551b-d2c0-42cb-9dc1-69a716cf6d0c
> MS-FSCC 2.4.43 FileRenameInformationEx has FILE_RENAME_REPLACE_IF_EXISTS
> + FILE_RENAME_POSIX_SEMANTICS
> 
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/ebc7e6e5-4650-4e54-b17c-cf60f6fbeeaa
> MS-FSCC 2.5.1 FileFsAttributeInformation has FILE_SUPPORTS_POSIX_UNLINK_RENAME
> 
> So now both classic Windows DELETE and POSIX UNLINK is available and documented.

