Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2132.outbound.protection.outlook.com [40.107.102.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13ADB18A95A
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jan 2025 17:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.132
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736444965; cv=fail; b=hN3Pmhto4+QgQ8kuPeqCD0+mgEEN7N/A0tCuGLiJZ7x8xLlrlCGXq6K2N3zzNLamhR2gQ6BQ/ZOv8UzDTuLCm5OPEo1d/RsJLTqP9px+t9R6UetzdqL+sJCu+SIh3c6/P72BZEEK6FNSUN9u0LMX6OJnzGajsW/b5aNI0he8xqw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736444965; c=relaxed/simple;
	bh=l5kWvvYM0/dbbXHMo12S8Emj5ZdOVjo3XeEo7lDpgVc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=W830gy4e2iWuJYtdos/SnoTGJFYa+oEyeCfQeJOe9dvap6crRwdzbYxYag9RXxebZba6+TcN/MoNGv7gmr80YxnmLo4Je0HyJQbu1DWije9zSG+H72yVpnxzuHS+eiT7rFd1xEBKfBB0DRt4kIwaVw9Mm+KQ206DEZok579O4gs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.102.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kz7qdyGlq9d5U4L0sUPG+O9i/mu8LJaBrPSHG3dyxALRw/YmT6oOMywGw9cRonV66O5rLe3q4eysze4tPsQcRGxdgA2oAoOaHuHy0f8O7C4cQh0tWQFi7tJMMnHV1x0QEReGEx28xPAYu9zIlAg29vcM7vwzvBGTP0phRIvwudpbArzQoYHsGeSmV+lKx0PHxkX/vLtxvFCu+ZFQMY0UPeBWjy3wl2g2tvPOCWOQdtnDs5/5wLoXkwdXHc7mRR+6ELt7bRwOHjaL9WWvk5a+7rEX7xCj0tLtyLGKoTdupva8v6jvWW5X5u7eK35r8WDFw9MbF4M3eudMQ0m3h4Xr6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WeJz65xP25S1dhjopz6vmhUzG3QO16lgK+I1D2QDb+g=;
 b=vUns2shYtq2neySVg5eIj2yuwZwoXIqZXYk23Y9iFjV4MG46GbbPIT9RUpp2v6ki9qyVIj7iGHI5EdxiJzSuMzEeTMX4dKacH2hzl0yje+u2MpZud0rZmUZVykahsXMqQa4OaDIOUq7xh4SGYkK2SNwuZ1mw2ssnu2MIzql/Hoj7rpDuQ1rV7kHRiZE14ow3vdwAE6PjW3XftUtdbohQqBqLUvT7ioUfVwSEIdcr79QOMhMFwjxo14OtqNBh6606c5I0h+BQATsW1SOLGeVo5jviBryP7bfD2fddTu4uM8WewsJzo0+RiNmyHxlONgVeE+m1wXCGqdoLnZ7+A+uB0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB5246.prod.exchangelabs.com (2603:10b6:805:d8::14) by
 CH7PR01MB9049.prod.exchangelabs.com (2603:10b6:610:24b::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.6; Thu, 9 Jan 2025 17:49:19 +0000
Received: from SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90]) by SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90%5]) with mapi id 15.20.8335.003; Thu, 9 Jan 2025
 17:49:19 +0000
Message-ID: <b2936a7b-770a-4806-8bde-9f0742600679@talpey.com>
Date: Thu, 9 Jan 2025 12:49:16 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] net/smc: Fix lookup of netdev by using
 ib_device_get_netdev()
To: Kangjing Huang <huangkangjing@gmail.com>,
 Christoph Hellwig <hch@infradead.org>, Leon Romanovsky <leon@kernel.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
References: <20241106135910.GF5006@unreal>
 <20241107125643.04f97394.pasic@linux.ibm.com>
 <CAKYAXd9QD5N-mYdGv5Sf1Bx6uBUwghCOWfvYC=_PC_2wDvao+w@mail.gmail.com>
 <20241108175906.GB189042@unreal>
 <CAPbmFQZc4gq7fiTbHGYgaaS=Zj49G-nSRB85=Je0KrX2eVjyoQ@mail.gmail.com>
 <CAKYAXd9cueHa4Sj=nDUiQW0a5QBxTmrfVNxS=m8w35QxLXk25g@mail.gmail.com>
 <6b77112c-7470-470a-813a-b7d599228e0d@app.fastmail.com>
 <CAPbmFQZL4us=CLvORKkEDBr+23zgLTSFDUUqv7OmBxdaSir_YA@mail.gmail.com>
 <20241219165616.GF82731@unreal>
 <CAPbmFQbyouZXsUzOiGXSoQrvjOQooVY8yHZe2VjnX3P-cscdxQ@mail.gmail.com>
 <Z3-CrT64eQdPQIDu@infradead.org>
 <CAPbmFQawOrGmgYrg8z73E4hCiE3JAw7e1SGS0BApbQCfv90xzA@mail.gmail.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <CAPbmFQawOrGmgYrg8z73E4hCiE3JAw7e1SGS0BApbQCfv90xzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0017.namprd13.prod.outlook.com
 (2603:10b6:208:256::22) To SN6PR01MB5246.prod.exchangelabs.com
 (2603:10b6:805:d8::14)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB5246:EE_|CH7PR01MB9049:EE_
X-MS-Office365-Filtering-Correlation-Id: 63b2a9ff-0c04-45ba-85d6-08dd30d5f161
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SURTUVdQTjlwL3lBSU45RDM5cGxEVmZqYXFid29jeFIwOVRZZ2VONEN1cVl5?=
 =?utf-8?B?MndITGFjTmF1Ymwya0x3dE53TEY0Tnh6MjRhYzZqYnJreUZqRzU0RFBQMkl4?=
 =?utf-8?B?eU1vbC82V213amc0cDFQd3hEbFBuaE11MkY0VG53YWhjQVFsWnYvdkVFb2Vv?=
 =?utf-8?B?VkNIMm9CcVRvREU4aXFKbGlmOCtNNlVCVmZCa29uYldPVU9rK0R5cGRmTWVN?=
 =?utf-8?B?R25nYlVyRXJhcHY1K2FXejhsaUhEREpLZFRWK0FsRUJ2UjM4d21hdW1hNys4?=
 =?utf-8?B?Sk5ENERFdk1GODNLSFpTRnF1REI0YngzTnBISUtiU1lLSTg3RHNZTE5uOWdq?=
 =?utf-8?B?eWlCUVBpaXhxRlJHMVM4cVllZmQxR0hvZHRvUndQU3V0TktRM3N1azkwNFRY?=
 =?utf-8?B?MHdXN2N3SHQrQTZoS0FiVjhyT0x3K0dnaGJDVVF3QTdhcFZIR3Y3VHFSZWMy?=
 =?utf-8?B?V2hkUzJFa2xVZTRhUTd4eUMrajN0SmFHSzNzaVA4Mys0Z0Fvc0JSSlBNdGZh?=
 =?utf-8?B?UDl2QWtoQmRXR2FoeGUrb0ZmVFNKd0lHVmJUc0h0WVlZSENWRWF6VWpSSk15?=
 =?utf-8?B?S1IrT1k5Qmo0a0F3aHd0eEk1UTBlUDh3N2RFWlhUTDdpUDdjWXloUTBwRE51?=
 =?utf-8?B?MFl5RTZtUHlVMVJ4eUp2N2w5b3lQdjZQTzdBV3UrNUFkcS90WFpzeWZvZlRl?=
 =?utf-8?B?TTNhNnlKd0hzODBRdWlwVUpWaEQ4ZVJHcFFmTUk2ZEx4R1ovRDA2RGh6U3dm?=
 =?utf-8?B?ZjFoblJQRWVnNG5pU2RmVmZjNURMSjRuSU15MW1sWDg3Sm5nS0t3M2pBc3lj?=
 =?utf-8?B?cDhyZy9ydDBBdEpVeWZDY3M2Q2JPUHdVQlhYSzZCNzVTci9VSWlRSHhTY1JR?=
 =?utf-8?B?bGN6ZnB6Wk5ueTVJM2xzbS83cmk4OVAwZ3NNSGd0VzZURlNtQjZnVFRaQ3pk?=
 =?utf-8?B?NHJuNHA3MngrN0NIcCszb0tKZFFmUHZuVjRjMEhNa1ZvTFRweW5xS3ZDT3pE?=
 =?utf-8?B?WXcxZW43cVhXSW9FdDliSklIMmt5RHhzOUc4VGxxT3dMZ29CZ0diMU9GaVN3?=
 =?utf-8?B?UmlHOGlsZHJDZjg5QnRQTnlKRERBTXBLS082OW1RMVN0NjgxSXBBZVlaMDJS?=
 =?utf-8?B?WjZjNUV5RkN2eWEwdnJxMUZ2dEZibjlHbHdyT0dnYTJBMkJKU1V3a1N2aDY3?=
 =?utf-8?B?WldMS1o4UFg2YUZsU1JyTjgvdHQ2aGFZclFPbmVBTHJMblpjbjZXSVlzdlJB?=
 =?utf-8?B?RUJvZzFFOTdidTU4dFN1Rno3UUFkSWhuS1NzbjVJSStkbmVTYjZnWGllUnZv?=
 =?utf-8?B?UDI4YWVKSmxqNkNic1hOOHpKSzFGa1Q4ZkVlSTFpTFY4R0tKc1lBUHI0UjJ4?=
 =?utf-8?B?R1NLdVAyR3FMMEVFRDQvNlRmZmlIeDZxZW1TZFcyOVpuUGVDM0xhZGZYUHBL?=
 =?utf-8?B?Mzk1Y3JwTlh0Rnl3bkZlcGx3UXQvaXVyVzVEckROcFdCNDM2OGgrNWxKellH?=
 =?utf-8?B?YUVqODdTVEcrUUdzaTFkOGdUdjh6U21Ccks0WjJCeTNsVFZHell0R0ZlQ0xs?=
 =?utf-8?B?STVQaCtQUkdjd21hTy9yTUR2Um5tV1U1bVFvWGwrZjBLeU1JalVLN29EZjA2?=
 =?utf-8?B?MXF0MHlTZjIwb2c2RFg1VEFiZ0x5RE8vOVFxUE9Vdm5ZUnM3aWdISksyclI0?=
 =?utf-8?B?dW1JL00ycnJtMEZLNTdnVU5GYjVJeGowWUlPMDEvNXRHWGxyOW55TUJldkk3?=
 =?utf-8?B?NDdrZDVZSmNzS3c3TGx1ZHdQTkNTOUZnQVhwc2J3TUlKZ24xcGNrOUJRSDMz?=
 =?utf-8?B?ZDhwN1U0SnVuZWROSjA1UT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB5246.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VVBqQXJXb0tTS21oalRlYXhpMmlZOEM4bC9aSlNVYXA3eUxjM3ZTUmVGSU9T?=
 =?utf-8?B?UktYaytoY1F1MWFYalBFWjlUSWlKVnVhS0QzM1VoTkxCTTJsc2pmZ0FBM1ow?=
 =?utf-8?B?NkhFWjBaNkVaUk9XN0FtazgrWi94NGZaVm94ZjlCUHpRSUV6WUQwYTNnaVcv?=
 =?utf-8?B?UnQwRlBVaStnNkE1Mzd4Rk9mbUhCZ2JPT3BzNzRQNjd0Z3hYUHg3QllWTjls?=
 =?utf-8?B?WGpqWHpIZGJOSGk4c3dSQTNFbHBmV0JpVS9JdndDYU5aT2xKSXZ6NktSSExI?=
 =?utf-8?B?UWhISmM0dTdzd2lrRzY2dUU0dXBqVEFsOGxMRUYrbzZOay9xL3NPN1gzaVJI?=
 =?utf-8?B?WTI0VmxxeE1QZE9uTGkybG9scEduQ3MzSG1Zdks3TnRsbHlVdGErdkRXNU51?=
 =?utf-8?B?YjNxaXBYdzJlaml4eHhJQUlqcFdSV3VqdjZoY1VhK1EvM0NWL3BlbkR2clQy?=
 =?utf-8?B?Sk5GNTFLWGZHSkVTSEZKMUNGMTdGb0ovVmRRZEtTUE82eGxIYUNITkxEZFl6?=
 =?utf-8?B?MERLWXRYUG5yd2VSUU9SdWNkVUd6dGFqY3Z2VjRhZC9YSEhlZWpic2YwRE1P?=
 =?utf-8?B?emdtd1ljaWpHYmtVaHJyT0phWUFTdXJ6Tm9BY1VSR1orVngzb0tvQURLZzQw?=
 =?utf-8?B?MERrcGR0OTg1anhKLzVDTlV5TVBVQWRLVmo5ZWtOQXZUbHhCWG5ZUE1BdjVJ?=
 =?utf-8?B?VmlOZTRUUjBYYWtlU2QrWmY3SGU1OTJ6dFRENWlPNkJEM0t6b0FVNDFQUjhP?=
 =?utf-8?B?SlM1aUxqeVRFSUk0WU5JdnJUVUdCeDl1WVJkTGJIQ3hrK2k4NEtVckNTaGtz?=
 =?utf-8?B?ay9OSmRRWno4RTZKM1JIN0FmZzNRb0FEVkdPYmNYbFN5clRDMHFKVEtCd1cz?=
 =?utf-8?B?SkdwRmdKTzlNcDZxR0luZndsQnMzb1NUYWROOHB1Wkk3UEpFbG1iY3JQL0da?=
 =?utf-8?B?SWw1MFVUQXRSVzgrcHhwT2ptYUdsUllSUTdrNGpiamVxalZQbmlOQk9GbVBK?=
 =?utf-8?B?aklVa29sK3M0ajA3aW5GS3lTMGh4QXhFdjZqb3Y3dkNVR2xxc1htV3J4UWZT?=
 =?utf-8?B?SFpXS3N4OGxwaEFGWUc1L1l0a0doSGRWdzVEMHZwTlJJYXN5Wi9jVXlkS3Vq?=
 =?utf-8?B?ajEyempsY3YrTThJSlgwNVEvSEdMRE85Z2tvRThNOUlyTUJRd0ViWU5SQlhw?=
 =?utf-8?B?bnB4OFpNb3Y2aGR5cWoxcElIQ2VzcENJZFZWYzNEN2R4cHBJVzdPY01jeWpY?=
 =?utf-8?B?L0I4N3AzUXJUZWlIM3RYUjRXRXAxZE53WVc1akxrN1U3TlZuTDd5VXdmTVdF?=
 =?utf-8?B?OS95RWhOb25YV1pqMzB5SExBNjFWTWxKWEpFQzdYeGt1dnkxSnFwOUs3S2Ny?=
 =?utf-8?B?ZnprOC9heHFCQlU0UFlOQmN2YVRodUxCejBwRUxzV0htNWI4OXlTU05RZmw3?=
 =?utf-8?B?aklzQjIyL1dKRGRqbU1QWHcrZTJPbmRJcGtzM0lnbVJ0RS92eiswVW9vcTl1?=
 =?utf-8?B?cVhJSnpwNDU2SGUvZG1zR1ZBbEU5WTdhaGdBLys3eU5PZnRHUzJIUWc0WE5a?=
 =?utf-8?B?SkxFV0E3bmd6Z2hiK0VoeTFxVjNlbHdEVnhNanozdHBtY0JreENvd25ycEVZ?=
 =?utf-8?B?TG5vbmJDckVtSHZXbWh3ZldqbVN5U2RyVTFjd1lpaERnYVRYOFpsbEhBUGxh?=
 =?utf-8?B?bG1TRFdMME9DcHVUL1hNVnNUbzZpc3A2S0NpYVpyM1U4WnZmVURQb2NQeVZ6?=
 =?utf-8?B?WFFDVDZxR096MFhoL2lYTXhOWk01ZTMwekVDM2dkbDRaQjNSM3VQejdYdlkr?=
 =?utf-8?B?blVrU3oyOWM1QzRpeXcxekN1b29oUVpZMzdrUHJWc3JOWEFQVlV2ek5CNjNz?=
 =?utf-8?B?bkI0VWxTUVlidVUxTmhaYVJNNDdYR3BJaTdVdEY3aHFEOHhzTklSN1ZDRXNz?=
 =?utf-8?B?RHdDMjY4WE9zd0k0VlZSSWhHd1pBQ0c5M0YxbmV6cFMxeXRES3JvZXVDZHJ2?=
 =?utf-8?B?VUJYR3lZMGl1MG5GZnEva1UyMnlLZUxGSE9DRWIrY1YwQUZxRHhiMWYveU03?=
 =?utf-8?B?NTBwVkxFRW1MSSs5cEhEbWhLZmM4c0Z3YjlKM2p3N0YrN1dKU3dnTUQ2UTlZ?=
 =?utf-8?Q?SWks=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63b2a9ff-0c04-45ba-85d6-08dd30d5f161
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB5246.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2025 17:49:19.3880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jtZ+1Qu3JifNIyJuS4wn7B/C9JOLi8wLdlaYKWkh6XSaWGOZx9g+5nXowNEgjLDZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH7PR01MB9049

On 1/9/2025 5:43 AM, Kangjing Huang wrote:
> On Thu, Jan 9, 2025 at 8:02 AM Christoph Hellwig <hch@infradead.org> wrote:
>>
>> On Tue, Jan 07, 2025 at 10:51:19PM +0000, Kangjing Huang wrote:
>>> This is good to know. However, since the SMB protocol explicitly calls
>>> for enumeration of all network interfaces on the server host,
>>> including their RDMA capabilities, I believe this is a sensible
>>> exception to the layering rule. Or is there anyway else to do this
>>> enumeration from the kernel space?
>>
>> No, it's not a sensible exception.  It's a massive data leak and a
>> completely idiotic protocol feasture Linux should not support.  If the
>> protocol requires a lsit of network interfaces, a Linux server should
>> require explicitly require that list to be configured and not expose
>> private information to the untrusted network.
>>
> 
> I see the point. I wasn't thinking about it from the security
> perspective too much and would agree with you on this argument about
> data leaks.
> 
> The protocol itself is not necessarily unsecured, since in the spec it
> calls for enumeration in an "implementation-specific manner"[1]. I
> would interpret that as the implementation could enumerate interfaces
> as it sees fit to its functional and security perspectives. The spec
> only requires the server to always return a list of client-usable
> interfaces, that does not need to always be the full interface list.

Absolutely. Windows has a number of filters on both sides to decide
which interfaces to advertise (server) and which to actually connect
to (client). For example, back-end cluster interfaces are never
exposed via QUERY_NETWORK_INTERFACES.

The ksmbd.conf file already has the "interfaces=" stanza, perhaps
you/we should simply consider using that list as the base. This
effectively would force the "bind interfaces only" flag to true
for RDMA adapters however. Making system-specific lists like these
explicitly opt-in is rarely popular.

Another alternative is to use the rdma_cm, which is the actual thing
controlling the listeners. When it begins listening on an adapter,
perhaps there's a callout that ksmbd can monitor to enumerate the
endpoints that will respond to 445/5445.

Tom.

> 
> That being said, from ksmbd's implementation perspective, this
> definitely needs to be something to be explicitly configured.
> 
> ref: [1](https://winprotocoldoc.z19.web.core.windows.net/MS-SMB2/%5bMS-SMB2%5d-240729.pdf)
> sec 3.3.5.15.11
> 
> On Thu, Jan 9, 2025 at 7:59 AM Leon Romanovsky <leon@kernel.org> wrote:
> ...
> 
>> Except SMB spec, why do you need to provide "RDMA-capable" information?
>> Is it must? What will it give to the users? Why can't you treat IPoIB
>> like any other netdevice?
> 
> ...
> 
>> Let's start with an answer to more simple question: "why do you need
>> this capability flag?"
> 
> The short answer is: a Windows client requires this flag to be present
> to actually utilize RDMA.
> 
> Long answer:
> 
> Although SMB-Direct (Microsoft speak for SMB over RDMA) protocol
> technically is just wrapping SMB packets in RDMA transport, allowing
> for a SMB connection to be completely handshaked and established in
> RDMA context, without any need for transferring ip packets. This kind
> of connection seems to be never happening for the actual client
> implementation in Windows.
> 
> Under Windows, SMB Direct is only enabled when SMB multichannel is
> enabled. And there is no way for the user to specify if they want to
> connect to the IPoIB endpoint or RDMA endpoint - the client simply
> connects to the ip interface first, uses the aforementioned IOCTL
> request to query the RDMA capabilities for all interfaces, and upon
> finding usable RDMA-capable interfaces, opens preferred data channels
> on RDMA transport to carry the actual data.
> 
> As far as I know there is no way from a Windows user's perspective to
> modify this behavior and upon disabling SMB multichannel, SMB will
> just disable RDMA support and transfer everything over IP. The RDMA
> transport is only "automatically upgraded to", no explicit
> configurations are available whatsoever.
> 
> So if ksmbd does not send out capability flags to indicate the Windows
> client to initiate RDMA transport as a side channel, the client will
> just keep working with connections on the ip stack and the user can
> never utilize RDMA.
> 
> To be clear: I would strongly agree that the Windows client's behavior
> here is pretty stupid and is just outright dumb design. In configuring
> my two-workstation setup utilizing this protocol, the no-config design
> of the Windows side has created far more problems than it has solved.
> It also somehow brought me here submitting my first kernel patch.
> However if we want any interoperability of ksmbd with Windows clients
> on the RDMA front, we would need to implement the IOCTL response to
> some degree and send out the RDMA capability flags.
> 
> My apologies for not making this context earlier, I was too
> hyper-focused on the code itself to fall into the classic XY problem
> trap.
> 
> Disclaimer: all my knowledge and research about windows client is
> limited to the edition I have access to (Windows 10 Pro Workstation),
> I have no idea if Windows server edition's client is different.
> 
> ...
> 
>>
>> Yes, ib_device_get_by_netdev and get_netdev are intended to perform
>> lookup of ib device based on underlying netdev, but in IPoIB case you
>> are interested in ib device based on upper netdev.
>>
>> So this leads to another question, if user didn't ask to connect SMB to
>> IB device and chose netdevice (IPoIB) instead, why are you still forcing
>> him to take IB path? If it is not user's decision and you are choosing
>> devices from the list, you already have in your list the IB device which
>> is connected to IPoIB.
> 
> This is related to the long answer to the first question. Basically
> using a Windows client the user cannot make decisions to use RDMA or
> not, it is not the decision of the server, either - the client will
> enumerate the interfaces and make decisions for the user. And due to
> the presence of SMB multichannel, the ip interface receiving the
> interface enumeration request is not even guaranteed to be the
> connected IPoIB interface - the multichannel protocol is designed to
> work with service discovery, where it is totally possible that the
> initial connection will be established on another data path, before
> the client discovers another better path potentially with RDMA
> capability. The only way for ksmbd to be fully compatible with these
> is to implement the interface enumeration to some degree. Although I
> am indeed convinced that this needs to be explicitly configured to
> avoid any security risks.
> 
> Thanks
> 
> 
>>
>> Thanks
> 
> 
> 
> 
> --
> Kangjing "Chaser" Huang
> 
> 

