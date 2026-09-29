Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11022122.outbound.protection.outlook.com [52.101.48.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E8D2367D3
	for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 17:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790701252; cv=fail; b=L6yD7NE8KlzsePn5Rh1HC7mxNqHqLiqkTtqhgvzIo60LIOFihiXVepA0gT+WlvmQcvmcLbSZOE80E/pzrQiLjpMlu7hVFfmPMmDfHdtO3/HnwxC1gBK9LA50eC8TWpQY9mVXbly75LYnB2wtSvx+ug1LXjdThBPrpbtaOzIWQAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790701252; c=relaxed/simple;
	bh=+Z4RS7JOl+XLF/EoXY6ehKQiu03ofntJpGI946ynRw0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=u0IYrVvXFwF7icaiBTUBVAwWUMg2OPWtTSiz8nHRZkyae0ACupzj8GxuR8xkfqhSJH0e/QjU+HUlACc0V7BWmV/HK0asbHfteEM+dwziM4Cez0GfFx9x5+dHJ3Bqt0OKrnOWfneDRKwQGASaRnr3fxv7DxpYFVAQHIJPJKGiCDo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.48.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nh9/rXalSxtcXQgM8rvvqYEgpjoCvFywkl8wtTpOu3xm9+IVqFLuOqcG6r/BcoYVQqzqv0ixw0zGRwEO8++LQgqv4pEw/N76L2e3x61ycl0c7WR7ujlIj3iAXJEtJUX/GlhwFgq7Q2d0ke4CVEX2n3THqMjLwCN37eJOR4RIRv3yBBKOJ77LHN4Ha+Kzl65tRe9vKmpmCHhlErnI6YgMP2i+gqMoDDLAyUhiraaxCUwYkdgU1KKk/jVBjIrI9uNvMcLA0gKEAvg1pyc2L3Kt5xWcSb8k4u3sg58OYN8RvX+ejteaYAOvtTIFQCC/+2T0wLtckBbQTW33ZDAP9rFvCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Z4RS7JOl+XLF/EoXY6ehKQiu03ofntJpGI946ynRw0=;
 b=JpDpUfsafTwXoweVib5ZRDITsLYKZppv/eaQslWGQoSe1erZTHI8ztWRrFVrJKFmNiiXTWw3XA6YuFQxPNkS0Fqo6TN9rsCWyzQ2fzZN563ovKkjvWRDwCKW1JtQnMU6XW5XtDeexgMxWHSMgf4wscahbtNi70s+J7CwuwvDCZ3SNqji0agPWHr498JfsOU+DBU4hkQC6ySxDtmHuLfdlNx4BLvTiz1XfvGQk8U678QfZjCJzT3hzv7JlLV85uYjA8dbDhpe/rznPnoAFGzXVjGQCXRG0cJGHgsOO2qL6YG2lCnVsTi7op+L6KZtv269HLJCWxNE0HfP0rz1aRQR3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from MW4PR01MB6338.prod.exchangelabs.com (2603:10b6:303:7b::15) by
 IA1PR01MB9137.prod.exchangelabs.com (2603:10b6:208:594::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.24; Tue, 29 Sep 2026 17:00:43 +0000
Received: from MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761]) by MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761%2]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 17:00:42 +0000
Message-ID: <e4941a3b-e155-4319-b53e-d6e70fe67969@talpey.com>
Date: Tue, 29 Sep 2026 10:00:40 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] ksmbd: no check that transform SessionId matches inner one
 on encrypted requests
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Dairui Zhang <zhangdairui@gmail.com>, linux-cifs@vger.kernel.org,
 Steve French <sfrench@samba.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Paulo Alcantara <pc@manguebit.org>
References: <20260925174623.1640482-1-zhangdairui@gmail.com>
 <CAKYAXd-3Q3WboGm=s=t-BYf_t6HgiGLTm8CboLNUsEU1VvBzMA@mail.gmail.com>
 <6fa542de-3008-4f11-9923-b6f7fbdd24b6@talpey.com>
 <CAKYAXd8yTKp5nh7Mc9_Cw9RY323cEZF0EAn6uc72AJS4mOaaKQ@mail.gmail.com>
From: Tom Talpey <tom@talpey.com>
Content-Language: en-US
In-Reply-To: <CAKYAXd8yTKp5nh7Mc9_Cw9RY323cEZF0EAn6uc72AJS4mOaaKQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH8P223CA0016.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:510:2db::35) To MW4PR01MB6338.prod.exchangelabs.com
 (2603:10b6:303:7b::15)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR01MB6338:EE_|IA1PR01MB9137:EE_
X-MS-Office365-Filtering-Correlation-Id: 440057c5-2f99-4d1d-eee7-08df1e4b326a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|10067099003|3023799007|18002099003|22082099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	5pGfv+E039R/OArkRyBWXR5gFrDGjYgpzv5eJ/4pqZCZSjnPHLHWhEiQxfKaHzFxJ0WgNH143Ld8apXGoKqN4Dcw/3iNeUgrVqJvFFxv+xLaBGW8CW4Vpm+WKyx4gx00RTwkfjnk3Jc9sCotYOQXJpbGpbuqDPDvJKCVP7Hi09MbHptnLEjlGE6hUsjCm8Zx6ntBiIA08NfuDnGLWHi+l09IbU+hP4KKZIbYqSSJkZQWc+3S6urOm0L/zEDwEUPLvAKdjNsmZt6/VnOPyQ4IOuFJGn1lKcsRPVNoNX/ZYYkrgvdnLIx9eqSTQ0lHzXe+lA/py4WhJkADaEapfOwIbNK24rINwEyEFc/Zu7P+e+vn6KzczpqcTZoqNhQ6XKSwfSIGqXIRbTSsEz+TYgZMVbfj2SnDnVzYcaHExuXaHbUV/MHxPbPf79Cx/nk6+4s3W8xkcCrGJ0lfEFNyn/tlmjk5fCd6zIS5otWHDXhKax1fm4+VMwzZjyjzFMUkJyEb67hx/2gXxJN3kvHOIvMzROp+2u4m1CoZpuioocnP71VZU+iYrr5ggr9RdwcB9S3cXKLlmXDQ9FTlj7NVoZTMrggtqGQRfWTLLpDlJQBmqwvu57WzOgb9L0zdS1zDZvaJiSlc3wbk+VhJ6GbwW5+1hqr1q15FMoFPfbqMDDXQHLM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR01MB6338.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(10067099003)(3023799007)(18002099003)(22082099003)(4143699003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T1p3R2VHOElVeWJkM2I0YzMrSG9lQ0luUGJ6dGo5c2p6NEZaNE9RVjFMbXFW?=
 =?utf-8?B?NEJyOFJhdDVEcjJyWG45akViUSs3T05QMnB5MWV2S2Fxc1BFU2pKdEJDVFFC?=
 =?utf-8?B?ZmlmQngxTFFmUXU4ZGRleE40czJsNkd2di84d3dkY3VzMVl5elV1TUJiaEpn?=
 =?utf-8?B?czRVK0tzUitFNTBZRXZGWFJveFF2UUhwOGdFaWhCOVdmNW91ZjJadkk4VE0w?=
 =?utf-8?B?aEVLODlMOWw4cmp6WmtsaERNODdHVjRsc1E2bTUrd0pIYmpWdUhxbUY3TjdZ?=
 =?utf-8?B?ODZod0FZeWNzSDM0MHRoenp3dm9vT2E1UCt1UFBCUTVnL2M2V3NXc1VYUkN6?=
 =?utf-8?B?U3hLek1ncUtVWXRuM3BPOW5DVVJPeW8vdkFHRFJsZklaNmV2QzJ2WG9BTmF4?=
 =?utf-8?B?SFVnSm9WWG9jSll6UFZQbnF3akhuSE1CUlh5bkZWY2xtcm8rVEdCd2NDU244?=
 =?utf-8?B?Slg1NmczV21RUEFnMlZNU3VqeWpHZCtjOEhQM3RvZTdVNi9iV0kwVWVPTVBt?=
 =?utf-8?B?Z241emJDYmViYXRVckVqWm1vbkpObkJoejh2WjlaV1V3RkdNYzVEWUh0ZHRQ?=
 =?utf-8?B?YWRZaVczVzJjaGh2b0ZhdmJucnRsVGF0dEVPbzdKSVN1dlBVbnRxeUJrS1Mv?=
 =?utf-8?B?bkdhbEZrUnd6endDQVBtcDA5RkxCN1ozQTJPbXpPS0hzaG5VYTJIOEZmUmxF?=
 =?utf-8?B?YXVyWUczeFBVcWV6Rjl1THhNTzlVNVdHVU1XN2VuK1J3NVR3cVNWN3FnUDRu?=
 =?utf-8?B?UjFNSzNvZ05nV2NhNTQxTmhaRG1NVCtiLzg4UFNrSHFONldWM3k4TGpZdWxx?=
 =?utf-8?B?K0RvRlhlaGpTZWtsbnQ2SVpodUdOcmIxUlZEY2dLdE9HYnVYb0U1RWtqTVk2?=
 =?utf-8?B?Z0pSck95a2ZCM3JLZE1hUytVVkpnYWtEelArT1Y5WlBrQTRsR0hVdzA2emdE?=
 =?utf-8?B?blRJZ0R1dzUwOGVxNTdqaVBvN0xNNmwvSVFPcnA4ZWZwOEY0RVBXNkFkYmZ5?=
 =?utf-8?B?N0FwZjI5cTFRYkdFdjVIdG5VSTYzamJRQnZGWW9NcW40Ryt4RW5kSldOYzFC?=
 =?utf-8?B?aHV4d3h4dmFxV3RMSjF3NVEvR1ZKUHdUT3M3QzQzQVRZbTdmZFpWNE5Lb1lw?=
 =?utf-8?B?eFlUbUlaZGpCZ096SmxLYnNaK1JPbnBFOHF5eDdpMVpxbmpOWE5xVUwxUk53?=
 =?utf-8?B?VU1ncVBSaUw0akNRKy9ONmhHVzVZN0RGYVh3RS82eGUyamxjditCM3dsVW9F?=
 =?utf-8?B?RTJiVHhET3cyMmpRVnNDL2FsdUVWLy8yZkVVTkNTK1JLVkIycks0N0tVQWo3?=
 =?utf-8?B?SFdHVHVKK1VBZVVUVjArcWZvRWVmNm1udXErZno1Zy80dkFQeVJDTTNIM3FP?=
 =?utf-8?B?aXprVHRKaFM4R3FYOU1VYWFFNm01cTdqUjZ2YjFnSFBqWW1yMmpIU1AxbDVR?=
 =?utf-8?B?eWNDbEhyNVJaZmtUcDZ4MTIrYVhTMGVRdmNRdlhDS0pDWWp3a3FFREYybUhZ?=
 =?utf-8?B?VWN6M0JDeDJBVVJaNTRtYlpockx1dHlzOUVQQTFHWXNpV1liTm1lODRhREZz?=
 =?utf-8?B?dGJHZEczS0RoSFdDZWJnNFE2bE1MRlArZkN4ZU5JL0JvMWpJTGRTTXJZWlRR?=
 =?utf-8?B?dmdwNUhuQVIvZ0FKZGVXOU01ZnBkS3BoNHVZOW5FcnZoc3B4ZXZpWGRGU2FY?=
 =?utf-8?B?UkRiWnl1ZkRrUWRTNUVLUnV6WndpclUyeS83N3dLRlRMZnhmUEhkeDZUTjJE?=
 =?utf-8?B?cGoxbGVCbTZzNUo2a3NnWWlFejAzL3o3clpPMGMrOTMwZUEyVEVHa2hHZ3Bz?=
 =?utf-8?B?RDhGTzFuSkIrTlNYL3VKUXhJUHFEVlpQYkNBUWFYbFJOamRJZFNpSkR4UldW?=
 =?utf-8?B?aCtYMEFhSjllMm5QYmF3SUp0cVdadTljWGY1MzlTeFQ0OGt3dnRSMTZwK0E0?=
 =?utf-8?B?c0RYdmVZZlRTa1ZzYnE0aVBYRTRWdjFtVkVnbHE2S2tVa1V1L2h5Ti9lVERT?=
 =?utf-8?B?T25MMzlkSnhDcEg2UWQyNzdoWjI3SnVSdFBiNWp5SjZXU2hSM1JJbCt2ZzFW?=
 =?utf-8?B?RnJZRmFyVHk4RGEvSWRwQ2NtV05aNjR2cXFMcTJkVGJkelBMajFFeUZvSEhT?=
 =?utf-8?B?Zmh4WjlRYWFJQW91LzhyaEdOc0tZV0RwODMwL0taOE1TTXRqMlZnQnZWTVg3?=
 =?utf-8?B?ZlJYeDhYY3BCZ0pXK3BGcElXQzJZdDFDcmhkbFBoNlJaOWU2TjQrUVhXRUxC?=
 =?utf-8?B?dUk1ZmJHSy9idDljVEFkSUVYT3lyN2NmM1h6VFhWY25id1Y4Y1diVG0xVXpH?=
 =?utf-8?Q?VAAR8hR+EO9FwrumUB?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 440057c5-2f99-4d1d-eee7-08df1e4b326a
X-MS-Exchange-CrossTenant-AuthSource: MW4PR01MB6338.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 17:00:42.9296
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bfWF7NFMxwHmRv3/hje1eJwuyPhjbvM7bjhEFcC6YH9EOj1pQe0NnU1vbFlaAS9Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR01MB9137

On 9/26/2026 6:24 PM, Namjae Jeon wrote:
> On Sun, Sep 27, 2026 at 9:25 AM Tom Talpey <tom@talpey.com> wrote:
>>
>> On 9/25/2026 4:45 PM, Namjae Jeon wrote:
>>>> Suggested fix: compare the transform SessionId with the inner one
>>>> after decryption and drop the connection on mismatch. Happy to send
>>>> a patch if that approach sounds right.
>>> Thanks for the detailed report. Please send the patch to the mailing
>>> list and me.
>> I agree that there appears to be an issue, but it may need some more
>> analysis of MS-SMB2 section 3.2.5.1.1.1.
>>
>> This in particular.
>>> As I read MS-SMB2, the server is supposed to verify the two
>>> SessionIds match and treat a mismatch as a protocol error.
>>
>> MS-SMB2 does have explicit requirements that the server MUST check
>> for equality (and drop the connection if unequal), but there is one
>> SHOULD attached to a behavior note stating an exception that doesn't
>> seem appropriate. So there may be a document issue which should be
>> resolved before deciding.
>>
>> Some of us are at the SDC IOLab in Santa Clara this week, I'll bring
>> it up with the Microsoft folks here and report back.
> Thanks for looking into this. I’ll wait for your update!
I did get a chance to look into it and there were some hyperlink issues
with the behavior notes in the document I downloaded, which have been
fixed. MS-SMB2 was updated just yesterday!

The situation is interesting however. On the client side, any difference
in the encryption transform and message sessionid's is basically fatal
and the connection is broken.

On the server, the received sessionid can validly differ if the message
is an encrypted compound, in certain cases.

Section 3.3.5.2.1.1 says:

>  The server MUST verify if any of the following conditions are true and, if so, the server MUST
> disconnect the connection as specified in section 3.3.7.1:
>  For a singleton request and the first operation of a compounded request,
>  The size of the decrypted message is less than the size of the SMB2 Header
>  SMB2_FLAGS_RELATED_OPERATIONS is set in the Flags field of the SMB2 header of
> the request
>  The SessionId field in the SMB2 header of the request is not equal to
> Request.TransformSessionId.
>  In a compounded request, for each operation in the compounded chain except the first
> one, SMB2_FLAGS_RELATED_OPERATIONS is not set in the Flags field of the SMB2
> header of the operation and SessionId in the SMB2 header of the operation is not equal
> to Request.TransformSessionId.

Because I'm not sure what version of MS-SMB2 was referred to in the
fix comments, it would be good to re-verify against this text since it
may have changed.

Bottom line, the server must drop the connection on any mismatch for
singletons, and for the first operation in a compound. But subsequent
operations in the compound may differ if !RELATED, yet must fail if
not!

Tom.
