Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2080.outbound.protection.outlook.com [40.107.100.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7FA1FC4
	for <linux-cifs@vger.kernel.org>; Mon, 18 Dec 2023 01:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kA9eH073+uqt1QRfctNyTl0255AgrefUH6FfOr3F/Wlu5D8DdgBMskctA6dlZpDv2wyu+jnUvoMpxCMHzi+1JW2PSUjQHGMh1f0H3nsT6SoXzhe6gFVVwYUo6utsTLnnuW0U7ggXywl4uyIjILENtP6yaZxAjru3vr+R9i6Xkk4Qb/hA3ZaPNnsOFBpNVJJX2N69lVwT94EWoUxubldb2yC873dMOaidz/7YlUHPE4+rVawThQVpHRj3j0YkuyDpaPdMjXN9UBPUv1z5k3J4CkUXmm/F6TzOh7Y1vzxbW9zFVMsOe2fHn5cC/qel3bSKpZCsu1FP7XFT8wLedBXeiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BkUU85XChN0Xi4V9pm7mjR80Z1vVq2HU5FW5VpcpPq4=;
 b=XsCI2V8iVEiyF1tjvBaHloH8M6+44lm0WYLh6+JBdz2FMHWyB6qlWBr8ptWqCAkLSrsX3cjy4YJEJU84LQj+aLyVeEXItsnR2CUIZkY/SY3qAWHCJBmh2rZMIXYe7u0MK6ILEGavxtsTxWQtwZpL072Xd+jROhPYRj9eCNK2danBKlRLlu5Lm8AGy2X87rFI8+JSVqrGrIsymJajxMj0ZvTzCUhQN29jwc2WhKK4YFGhDJttfTxggOQzL+oAqK2rQVk3Ix3YREFfG71zbwmF0z74OovSrwYRr7BDuIy3BjvgI+PMyruBFWdm2MbJKumZL0QUcHxsSf0sGgJbBWF2RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 PH0PR01MB6167.prod.exchangelabs.com (2603:10b6:510:14::5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.37; Mon, 18 Dec 2023 01:34:02 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com ([fe80::e38:e84:76d4:5061])
 by SN6PR01MB4445.prod.exchangelabs.com ([fe80::e38:e84:76d4:5061%2]) with
 mapi id 15.20.7091.034; Mon, 18 Dec 2023 01:34:02 +0000
Message-ID: <80c916d6-6759-4590-9636-a3f393be4652@talpey.com>
Date: Sun, 17 Dec 2023 20:33:57 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] ksmbd: set v2 lease version on lease upgrade
Content-Language: en-US
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, senozhatsky@chromium.org,
 atteh.mailbox@gmail.com
References: <20231216122938.4511-1-linkinjeon@kernel.org>
 <4cdd0fbb-2afe-497c-ade3-e445c5c0ae53@talpey.com>
 <CAKYAXd_X8Ono47BMPc-4UQVLJe-PSdRFLD5WxK-Vbs=5KbDTyg@mail.gmail.com>
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd_X8Ono47BMPc-4UQVLJe-PSdRFLD5WxK-Vbs=5KbDTyg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0078.namprd02.prod.outlook.com
 (2603:10b6:208:51::19) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|PH0PR01MB6167:EE_
X-MS-Office365-Filtering-Correlation-Id: c5b10b0d-aa68-4f74-9c87-08dbff6969f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9usDEjoljuN51zTgLQa5+6OYgW9MkcstRIPDAbZ0h14FkgSBn6vPIwUMgu3nj3eDHeqmVumL0jg/nkInJmAhUaPMLF9CiiPUmnVBdW7s0z45NKb6Qqes/KVt+5SWp7FqimeG0HR/0iwFY+ob5SvhhaO5yaCDcauKuc5AGYbwEG+r/etFZRzRldYRVFLokHhT4bENBN7VzYD6nlCcLPYIWdSHlo59NCryDDNxIcWDETN5hhlRGyEgt2Xa9pKQGWuFCLnUVje/ZkneBxWfCWBV4ULiDGfHiOkFA9QNJrLmSSUz7clL2Y9gCHgZPdKJVM7AQHi3lzfzwFGx7r1xXvYfKZnFp0Jcje7mCSFKPGY1sF+qB/V+xnV9Z9679wPsSgdgUMdKlQTPmsvYH7gVK6N3GNzcfleapUejlkDCEAzApqD5dXmeBIdhn6baK159/wSWIGnpA+muIXOaCukN+tfrKVlckcbT8Hf9EAlBCTGKxdF1GpXutLwIBDcVR7gyJBbMCd3LgFxfFZlKmB+HQHoGbBeILUTz2c6FdhmSSO5O0IEG8MGWXBAEGiHbHelFoFVqLwvNXAZVCiVilAdbv1jGacQRxpHjixADnMssRAaj9rK29ptGzBUL6YfpQ+2REVrS
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(39830400003)(396003)(136003)(376002)(366004)(346002)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(83380400001)(53546011)(2616005)(26005)(38100700002)(8936002)(8676002)(5660300002)(316002)(66946007)(4326008)(41300700001)(2906002)(4001150100001)(478600001)(6486002)(6506007)(6512007)(6666004)(66476007)(66556008)(6916009)(36756003)(31696002)(86362001)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RWpKNUhGWjVPUzV6d2ltSUxjV1V0eGZNcFRtcUJkQ2haby9uSWdvRGlwK1l5?=
 =?utf-8?B?OTUzcnRCdFBPWm4yU2ZLWFF5NFhoRnpwMDE0VmdkdDlBM0lRUzF2RHd1bDha?=
 =?utf-8?B?NnFhbHpxUlo3NWdNanFCcm9FdGJZUFNZZUkxSGQwWU9aR2RYakVrWDVJY2lD?=
 =?utf-8?B?YWdvZlRuNzN6dDFkT1crdXZuR1FibXF1c2MzY2IreFBLR0ZMN0JTUzI2MXgw?=
 =?utf-8?B?S2kwQTFOeGNIWlJyd3ZlN2s3aXJuR3N0NVhZQzQvY1JObk5DcWRHak9hdHph?=
 =?utf-8?B?ZUNtVmtVNnErNTQ5bVFFeno5bldON1dpVVY2VTMrNkZTTndvSkFITmhJdTJs?=
 =?utf-8?B?Z1hWbzREcFNZK25EWWIwSHNFUmRIOEZHOVFkbm5ISVhOOVF1WTFacGVISUtt?=
 =?utf-8?B?Y1RPMitVQnVjaGk1aFNESUNydm9lUTZOamlWRGVwbkxRbURHOHNpNGtzL3J0?=
 =?utf-8?B?cDVjKzZteHZuSnZHdDVSV2x6YWZ5alN1NHg0Q2RZQzNNKzdCUkZQenZSY29s?=
 =?utf-8?B?eWRQYXUrUHpZUWIvcjdibmMzM2VjbU1KVFI3N0J1N1NEc3V3cVMxQko5YnNU?=
 =?utf-8?B?VWJYZG1WbDErRlNtN0EraXB2eFk4dHFnWHZ6OUdmbXI1UEhmNStkcFJ6a1Jo?=
 =?utf-8?B?WnpjZXMvZ0pYUE5aRHo0ZmZnSjA1SkNBVnFDVEZNWEJibjRHbFEyQ0I4Yytw?=
 =?utf-8?B?K0doSG5nZk81WFdGeWY2U25HejdjUDBqdTNMSUsxbW9nbHE3YnBvSlh3RUg2?=
 =?utf-8?B?eGlkbXQwbzhUL01qM09oclRVdUFUMU5TamN1MHRWZVRmaFp2dnc2b2J3WHBw?=
 =?utf-8?B?QklwMEtMeVdkSERMaldMRUUyTDIwVUdWYnZJUWVqV2ZDYUtLYjU1dWw3azMz?=
 =?utf-8?B?ZS82UzBwTlREb3J6UDhnTGh1RUFDTkFwZ09sKzZmU3ZnVWVGcklWZzRveU9h?=
 =?utf-8?B?a1Q3M2FzMTFpR0dETGFNMCtHL01nalNmVUY3Yk1uYW1Kd1VLN2grcUtrU1No?=
 =?utf-8?B?d0Q5dFErZWd1dEhORzc3OUN6TnBGQjEyZzQzd1lQWitkR01BVjY5M1FxQmF4?=
 =?utf-8?B?RVNJMzZUamI4TFZrbExUazlMRjBhZEVMWlRYT2paNTdub0Q1VFFDUmlmd3Zy?=
 =?utf-8?B?Ym9wTHpSZUZJTVdaWE5nY3BucWF1RDZXTmVkVDg3MlRRaXJjSmxpTG1ncE9m?=
 =?utf-8?B?ME5RSi9sVDArMFg3L0cyZlpNcHN6dzIzZjZzOFNxcFRaK1J3M09LamtEK280?=
 =?utf-8?B?UHB1ZFl0K3FNTW1kSGlQbnBWbEJKZjN4ZkFCaGlBSFB1SlcybEFsMjdFQzI3?=
 =?utf-8?B?RXFsTWVhQkdFZkg1aktqZDAwdGtsL1VTYUVMK2RkUVBZUVZUaHE4KzRMN3RM?=
 =?utf-8?B?N00rZEVnZmdCZ3Bpdi9aWTd6YnRFTFhYeHRZK3orQldLa09GT2R0Uk10T3pO?=
 =?utf-8?B?N3piaFZ3b1VrTWd1YXVkUjRqbHhKTEU4Y0c2dnhBOWZmYUtEVHJERmNyUzcx?=
 =?utf-8?B?TGlVQ0trMkhXbEtSYXhhMzlvZmd2MERLUVRsUzRQSG5aemhiMHp0TjZTYVRa?=
 =?utf-8?B?QVlvL1FodDlVeGdrL0tXLzZHQ1gyWUhkc2hvYXVZeXpRdnhQczdMRWNYeVYx?=
 =?utf-8?B?VzR1cUF6T3hwc3RCb200WFRsMTVONGpIRys4WDdGanFnNGFwbEkxakk4ZlRC?=
 =?utf-8?B?VSt1cjkxNk0xMmNhTVBoMmZiVE4vNldRL0RQcHNVTGdQak1hMjdxQVY4SmIy?=
 =?utf-8?B?UmwxUk0xZnlqMXlCZjJOcnpseUhnMzhZcWx2L3d3d21JajJ5YnljSkVuUnI5?=
 =?utf-8?B?TnZVdFBmVTFIMGVsNGswT2pNNUo0RHg1R29lbDhuclV3QXVlQmhSNnBWTk0y?=
 =?utf-8?B?Y2srRm9ZMjh2R2JkSzVxallORE0xQ1RVZkVMT3huZ3RxaWxzak5vN1FCUWo1?=
 =?utf-8?B?WUNhQzY5N2svYzY3WUhETWNuMUJIdUkzdmkrOWhNZTNXVEVhaE1hc0U3d2hZ?=
 =?utf-8?B?eEJsL0hRSHpReWhuVkcxSkh0b2tlQ1FCL1JidXA3SXNKcmZVYUFaMWE1ZXNr?=
 =?utf-8?B?VHpNa3ZMdUJNZ3U4Nk1wbnhNV1IwaW85MGRzMjRwUXpsYmNXQWQrb1pHUERJ?=
 =?utf-8?Q?fQX8a4kFzNljsuT5cxYOTvD4J?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5b10b0d-aa68-4f74-9c87-08dbff6969f9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2023 01:34:01.9466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nqXz1DsT/UTc2Xpw9NtEJIkHdL1yZyl+lx8+NeZ7JCGH5Q2T2/5GOCubAtekXiRF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6167

On 12/17/2023 6:58 PM, Namjae Jeon wrote:
> 2023-12-16 22:37 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> On 12/16/2023 7:29 AM, Namjae Jeon wrote:
>>> If file opened with v2 lease is upgraded with v1 lease, smb server
>>
>> Can you elaborate on this scenario? Lease v1 is SMB2, while v2 is SMB3.
>> So how can the same client expect to do both? And how can the server
>> support that?
> This patch is to fix smb2.lease.epoch2 testcase in smbtorture.
> This test case assumes the following scenario:
>   1. smb2 create with v2 lease(R, LEASE1 key)
>   2. smb server return smb2 create response with v2 lease context(R,
> LEASE1 key, epoch + 1)
>   3. smb2 create with v1 lease(RH, LEASE1 key)
>   4. smb server return smb2 create response with v2 lease context(RH,
> LEASE1 key, epoch + 2)

Oh, this makes my head hurt. The protocol requires the client to never
mix REQUEST_LEASE and REQUEST_LEASE_V2 on a connection (as I quoted
below).

BUT! There is no requirement for the server to enforce this, and in fact
a requirement instead that it merge v1 and v2 leases, where possible.
This kinda sorta makes sense for SMB2.1 and SMB3+ interop. But it opens
up this ambiguity!

Practically speaking, I don't think this should ever happen, given a
conformantly written client. But the patch does appear to match the
required server behavior.

So, reluctantly...

Acked-by: Tom Talpey <tom@talpey.com>


> 
> i.e. If same client(same lease key) try to open a file that is being
> opened with v2 lease with v1 lease, smb server should return v2 lease
> create context to client.
> 
>>
>> MS-SMB2:
>>
>>> 3.2.4.3.8 Requesting a Lease on a File or a Directory
>> ...
>>> If Connection.Dialect belongs to the SMB 3.x dialect family, the client
>>> MUST attach an
>>> SMB2_CREATE_REQUEST_LEASE_V2 create context to the request. The create
>>> context MUST be
>>> formatted as described in section 2.2.13.2.10 with the following values
>> ...
>>> If Connection.Dialect is equal to "2.1", the client MUST attach an
>>> SMB2_CREATE_REQUEST_LEASE
>>> create context to the request. The create context MUST be formatted as
>>> described in section
>>> 2.2.13.2.8, with the LeaseState value provided by the application
>>
>>
>>
>> Tom.
>>
>>> should response v2 lease create context to client.
>>> This patch fix smb2.lease.v2_epoch2 test failure.
>>>
>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>> ---
>>>    fs/smb/server/oplock.c | 1 +
>>>    1 file changed, 1 insertion(+)
>>>
>>> diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
>>> index 562b180459a1..9a19d8b06c8c 100644
>>> --- a/fs/smb/server/oplock.c
>>> +++ b/fs/smb/server/oplock.c
>>> @@ -1036,6 +1036,7 @@ static void copy_lease(struct oplock_info *op1,
>>> struct oplock_info *op2)
>>>    	lease2->duration = lease1->duration;
>>>    	lease2->flags = lease1->flags;
>>>    	lease2->epoch = lease1->epoch++;
>>> +	lease2->version = lease1->version;
>>>    }
>>>
>>>    static int add_lease_global_list(struct oplock_info *opinfo)
>>
> 
