Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2097.outbound.protection.outlook.com [40.107.236.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71BD514A60D
	for <linux-cifs@vger.kernel.org>; Thu, 23 May 2024 13:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.97
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716471360; cv=fail; b=TOI01T0AUW0cgOq3Yzf6uNZkS31Bk+msOBoTpJUjfJ4hf1NNywAOTmIOgpH/fGwQ0KQpA/seUdX800IlBlV2S+AbTfaBqXksZrUz5S2uhUogpjnsew2IV0fIdFQ6v9I2McOuQMOzjF5iuKEEPqhmLqrWwnBIlj7JOcYkKXuZA0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716471360; c=relaxed/simple;
	bh=WnpC2qTDinBuHmM9UCPRUz6URnxtyrpfD2sgKJyO+tI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=D/rPTcMV0FZNlPGID8V42gLMo2dyLSO2yCthW7UMK1Kh5JkqF4Tlq1blCeYFqacAmQF4QbLWDMbb0kkghknaP7FHHIn1SzUyVWo8d+AuIPjoM5lHfocNCWfEcBjSSBxtAEOc+JAUem9tdYNMptd2kVdPlhR4e6Gc8+c3nPhU88I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.236.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fK8koKWDZT4CwkKThxdD8k4pHiOxJ/tiCQVmHuHXUmjHoilwAJMKoXGjmD4bmnKi634HJhRITwpMgc9a6O9lDALPUVMlcbPxM1C/4ibA18LBbqWVTMXC3AxG1XxwPXof7WSLbzRO14tUhCxb8xhQZXonQ+mwcREuKoV/nycOBJsP296ZMNrB80gtIU0Sk0m3yf9FjsmBQq0YIa++GVjauSrV4qFcPmi2rurgtK8pW/TDYaehUn4rmQ9dKfZ1+TMZ26aNHGRWtkRhrkTvFqi8lyHVSgwkSTZS1SRIPOmr7U30QKOylXcnyI3yfoTkdlmPOVgoDvkeQUUhPiFd3d3r4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PdagyqrO97yFMWUp51gJ4PsrMetNjj4L0CHU9OknUq0=;
 b=SRPZ9jinpCnlUcMLvlBn9aKOxVMDRh9cZajq49m9y7ZzboUHBVVKZCNzuEbqsMcbQwzcBuu4CjVTD7iYE327kpKnBVb3amXarTETAG63ahz5r/t5enAw4mrcSoShsaDv7rhU/sS3jKgt8/I06/557gXT7gXhVzPjaHta9w/1M7RTeJwVxEUvrJD8thHlffOPoFi08FEcV4HHMEhwCMuYj48iRqvZj26Z/Zy8YzgyKGuyG+welmWIyut3x9/ugYEPj2KhRPUQGTJ6n/CgldZg8MVW6OcqSzcASqMNgIQSALBfT3rPsHw2ku5Tc4XuTtbXHksY1ztGVeUcEKgil1m/VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from CH0PR01MB7170.prod.exchangelabs.com (2603:10b6:610:f8::12) by
 SA3PR01MB8038.prod.exchangelabs.com (2603:10b6:806:312::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.27; Thu, 23 May 2024 13:35:54 +0000
Received: from CH0PR01MB7170.prod.exchangelabs.com
 ([fe80::97c:561d:465f:8511]) by CH0PR01MB7170.prod.exchangelabs.com
 ([fe80::97c:561d:465f:8511%4]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 13:35:54 +0000
Message-ID: <dd393a75-667e-4c5e-8f00-060b8a78da69@talpey.com>
Date: Thu, 23 May 2024 09:35:52 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ksmbd: avoid reclaiming expired durable opens by the
 client
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, senozhatsky@chromium.org,
 atteh.mailbox@gmail.com
References: <20240521135753.5108-1-linkinjeon@kernel.org>
 <c67c96ed-c9e6-4689-8f68-d56ddab71708@talpey.com>
 <CAKYAXd9iXrmh17gutKYPFGs31vBwN94HOGd-fvVCo66RQnazUw@mail.gmail.com>
 <14fa6bf0-00e4-4716-8569-a85e411228eb@talpey.com>
 <CAKYAXd_NBDSmirpO45T0tgu9XCGr4MSK+DW=NCqGFLSe8uY06A@mail.gmail.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd_NBDSmirpO45T0tgu9XCGr4MSK+DW=NCqGFLSe8uY06A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR05CA0043.namprd05.prod.outlook.com
 (2603:10b6:208:236::12) To CH0PR01MB7170.prod.exchangelabs.com
 (2603:10b6:610:f8::12)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB7170:EE_|SA3PR01MB8038:EE_
X-MS-Office365-Filtering-Correlation-Id: e36062cd-3763-4841-867a-08dc7b2d44e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dVhnZGxJZG9rZGh1MSs3WmgxdlJqTWJpWm1aWWtlTVYrY3pEektWSUs5V3lO?=
 =?utf-8?B?SGZlcjlIRiswQ0FJU3lTMVdYS1RTakk2ME4wbW9manZiS0dyRVllNndxMXVq?=
 =?utf-8?B?UVdMZEZMWG5wb2tjcmIvTkE2WS91eitQRW5ydktDT0p0a2ZEdFFVSVFYUEkw?=
 =?utf-8?B?eWI1T0pwdFF6WGZLT3UxRnc5VlhYMkd4a0tIbzR4TEl3REo3YkUrMnhyOHZN?=
 =?utf-8?B?b3d4NXhUc3daN2N4RlY1L0huMWdUZ00xaVBlU0dNYlhZTy9uZGcwTnRwOFFL?=
 =?utf-8?B?a0dJblo4UGRZQWNXVkNrWGR1TklqTElDd05JOW9uMTZoM056UzBXZUFuUnc1?=
 =?utf-8?B?QWQ3QTFISCtEOVJJN0VLNE5HVHd2RkdSUXNFcnpiT01GRTlsVUUyM3dKS25a?=
 =?utf-8?B?NFBOeHV5cHVDUHhENWMxd1BaSkduc3Z1MXdBS3g2RFNRSlNJZUFMbTRrSHU4?=
 =?utf-8?B?RmFzOFJWNjdsMDl2TVRMUWlxQlVjZUxCUUlnQkZyQXFxM0gzMDdKditEQ0ZS?=
 =?utf-8?B?TVd2T1BqajU2VXZwSXlKWEJIMkt3eHN6STFzWXBHOUFTUzNMRGJYU0x3aUFs?=
 =?utf-8?B?c2kzQU9FelpmQVhLbGpkUUdCWnVMNW1ic1d4Sy9IZG9EK0Jrd0ZUckVpblp0?=
 =?utf-8?B?YkJVT3p0V1pZVFlRSlRLZ3VxRkJjakErdDFsN0lWTXpIL1JCU0lRMjR4SDJB?=
 =?utf-8?B?M2phVVdPSVMzWnRObnFpeEw0WHNJUGFuSjFuaVNwenRJMUFkNHlLcDlISnA1?=
 =?utf-8?B?ck81dTJlRTZvOTV0SFRwMXFFcjBRTnptdW1XSGZwTFJ4YXRCZkluZG4rVkV4?=
 =?utf-8?B?MCtjWHd6QnFBblgxOFNYai95NEtIOU1QZ2RvWUo1dWNyTjB0N0txMnRGWWV4?=
 =?utf-8?B?NUR3NzJZNm1qZTJhT0JHa3BsSE9JTUcwSmsvY045OWtPSVBDMis0NFB0Vm5L?=
 =?utf-8?B?OFJqaUZFSHNEUk9WdmJ6dFZidWRIblYxSkdkbWxhZThVUGVDK1Y3UlcydkNm?=
 =?utf-8?B?a0c4Z0FUSFRpaGVqZGg0OWY5aTFlZzR4dThSNlVLRVNJNHgzVmgyZnhFVDlH?=
 =?utf-8?B?MGI1VEg1RU5aLytvMHRFNVd6LzVwQjU3Z1UrUEhNc09XUXp6VU1CWFNJdUZB?=
 =?utf-8?B?cnhKMHJWQzRBdmgvZkp3NjZ4ZVl3TEdZcURoamdxOVlVMWtOQmtkam55MkFl?=
 =?utf-8?B?a0xIODM4RWVlV3ZhbFFWbjdTb2VlZDhDeno1bldvMVJMQUJLTVdscDVKS0RY?=
 =?utf-8?B?WC9pVWIzcjFkd1lJZWl4VldweTJLLzg2ZEkya0JLNVh6VFRGODRyTVNhZ1JR?=
 =?utf-8?B?UmZQWUlNSEJFcStjaDY2N3o5aUg2SnFhQkxGckFuMy9pdmwxMlNGZ282V3Mr?=
 =?utf-8?B?cFR5Z2VuZm1BamMvZlAwa3NITkZLSzd2SC9zcEJFbUlGVWdxZzFSODlKN01C?=
 =?utf-8?B?aHg1MEdHRTBKcVAySFJWRWRRckk4bk9acUpYZHYzbGJTV1BRTlo5UVY3eDJJ?=
 =?utf-8?B?WFRodlEzMGdUY09aejlWaHVTQUcwWklWTXJCVDRibUI1RW81WVJESXNINlhL?=
 =?utf-8?B?d0t4YUhZYit3YVdRT1AwNXUxYnp0cVVrdGdKRHl6Q1dqYVc2dU43VEtGY25Y?=
 =?utf-8?B?bC9PYXdxTW01a3kyMDBUbkVBWWpQcktLTmhZWmRranQweFM4QjU5MXBocHpP?=
 =?utf-8?B?LzFhQlpka0hYSHA4STlUQ0pRb3BuK1daWWV3dVhsVjZpYUp4MHViVXdRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7170.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UG8rbG1hOFpXWnB3NmZuRk13K29IYmhrMUJ1RGRuWEFyMDRpWFhYcUsvc0Uw?=
 =?utf-8?B?dEF6emNGakc4d3dqSXpwbFdsSi8xbVVXMmZsZ05qRUJkN0xITzN0SElpRWVV?=
 =?utf-8?B?d0FGUHJMVk1ja3BpWnhSS0NhL3RmTXcyV0dqcjFxRlBiNGtSQjBtMDg2UlVJ?=
 =?utf-8?B?UXZNdXUzSlNNUWc0Zk9BQVdkM3J6cnkxSGREd2piVnc3cnk4bGJSNXR6ekxl?=
 =?utf-8?B?WWd2NjljTmFFdkR5QWc3RlovMGUzcjlBaDRwWFh0OXB1V05rS1kyd1pnWnZa?=
 =?utf-8?B?TlVsU1NFakZYazd0QTZuMTY3d2VRbGppa3Z0SkhDN0NLQjIwczJmaHBmRnNJ?=
 =?utf-8?B?L3d1MUFZMlZIdmdvUU5CaGFqaVB3YktWLzJJQTR1WWZRVFR2YUkyYlczYXlS?=
 =?utf-8?B?YWVQU2VTM3MwUWluOHR6MkFOYkRnL3dDZVZNOE4vNUIzY0QyMmFRdFZIazVM?=
 =?utf-8?B?WVVMOTQrMndhYU1vcjZFQ29sMnB6SmFHRHVpYjJPRmtpNWlZODZBWlNJaHVy?=
 =?utf-8?B?bjhmdHUyRjh4L093WFNlanNmVmtJMUVwWDhacGF6OE9HQXNTTFRpL3M2WERZ?=
 =?utf-8?B?SXFWRE5qaDBNUndiZVdxNXphYjNubFlJRVhtTkY5WTdnTHlJNHdkanhhdEVH?=
 =?utf-8?B?bEptOWNpdXR3MDc1UGlHbXFyZGE2RzRWTGJIZTRKOUhiSEF5Q1M2OHY0MEo0?=
 =?utf-8?B?S0JjbGxzaHpoSUZGUHdVeEhwVkh5VU5FUGV1WVM5UEp6MHgrWjZzTmV3YldV?=
 =?utf-8?B?ejdLZVVMbVppeGZvK0NZZDQ2RXMwVUkyZTVkTjloeFJRM3B6M3ZkaGNjT212?=
 =?utf-8?B?UEtrSU84QTY3ZkdEc3JIYk5iU2ZXNEdzWW1RQks0Uk9xZnlRdHBTanIxUHQy?=
 =?utf-8?B?ekZvWHpIWDNuM29mYkRwVFhPK2gyTWVzdEtwbG1UT3BFbkh2bmI4VzNtK0lC?=
 =?utf-8?B?SWVRU2JFQ3hsaktpRWdDUjd4cGVZV2x1U05vYUF4YlkzbkJUaGx2VTJMVE1T?=
 =?utf-8?B?ZnJ2eEk2cGJaNEw4Vnh1QXZwMjRzbGJ2cFZFZnByaXJySEY4b3hoQVkxZ21p?=
 =?utf-8?B?TWRmbUgyNkFuSkw5dEttVzRlZkJ4TnFYTCs5dy9yUTN6WTBjbkJzWXN0cFBU?=
 =?utf-8?B?amtGT0RHU0N4dmtZM1pDSE9vazBESjVNeFEzNm9QSUthOUp3bytUMnBXRnBV?=
 =?utf-8?B?Z1owcURNMFgvbSt6aVZUTFB4Q0xlckhaVnNwS05UZkg4a1dMdDZaVWZNdzFa?=
 =?utf-8?B?YVlRSElUaldabjF6RzN5MlE1VU9Ta0FQSHJmVGRMcjRWcjZTbUNINWdpdk5P?=
 =?utf-8?B?UEhyN3FSR1BTK01aanFCbFltRkhXV0g2T2J3dk5GQVY3czNvTmw2NmF5M0Mx?=
 =?utf-8?B?VHJHZE9EZ0VIeEpJZlhkaUhkWmZmMWRENTBTTDRqZFFWSzhDY1JOd3h4MlRR?=
 =?utf-8?B?WG1yRVltL0FFRytHcEVaNUx1SVZSbmEyOXpZdDRXWFg3YzlBdEl2Ylk1THhU?=
 =?utf-8?B?WWtjZEpnMFl3MWZDeFNwRjUrY2tzeXp2akQ3dGZqNUwwa3A0MDA3cGNHMTc1?=
 =?utf-8?B?N1diZzN2RHkybjkxclhnL20rVEdTMU1sSExNSjJlQnZEbGJnQ1IxUUJRWVAx?=
 =?utf-8?B?RWZTOXZFOXZQeEg1RGtXNmI0aW9kZWEzdUcvbW11SG1adm9ObjlSNnpqZlc1?=
 =?utf-8?B?a0NFL0hpTTRXRFl0VGp1bllyUCtoSkpLb2dma2tkRGh4VUpMcGcweUFlbHUw?=
 =?utf-8?B?eUM0RlFCV3NxRXM5cDlWRjdsNG5HRVIrSmxyV1Q5SkFQNTNZNkp5MUI2YTcy?=
 =?utf-8?B?eVg5L0tkWkVuTG5sQVlOcnQ5RTRWaWx6SE12MEZXc092ckI1RlRyckwzZXVZ?=
 =?utf-8?B?T2FuaE85NFFEQS9OK1NzcU5EZ0FxbEszMjBxNGhqQjhvSThWWGtKUEs4bEJ4?=
 =?utf-8?B?NHN3bjBKWGZ2USt2VG1sYU1zMFUrWURYdGRORlYvK2pyaWlJZkdSRWFWZzlo?=
 =?utf-8?B?cHEyMHV2RU9KcUhxZXNFSnJ0RmN1TWdNU29ZSHZMK1RPUmE2Uk9rM3hvQjA2?=
 =?utf-8?B?Z3BQWjZrbExWOEMwdE8wek92Ly8rNmdGT1ZOcTd4OEZ1UU5yNzRCNWhjejU2?=
 =?utf-8?Q?tUU1NqsDE//1XLt0KIYnHCm9m?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e36062cd-3763-4841-867a-08dc7b2d44e2
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7170.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 13:35:54.0613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h1JSMdG67wEAuLlG81e19epjux4NqSAzp15y7Z0BnIYX5CIgKt8CYZhRHVeLsr+S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR01MB8038

On 5/22/2024 7:31 PM, Namjae Jeon wrote:
> 2024년 5월 23일 (목) 오전 4:47, Tom Talpey <tom@talpey.com>님이 작성:
>>
>> On 5/22/2024 1:13 AM, Namjae Jeon wrote:
>>> 2024년 5월 22일 (수) 오전 12:10, Tom Talpey <tom@talpey.com>님이 작성:
>>>>
>>>> On 5/21/2024 9:57 AM, Namjae Jeon wrote:
>>>>> The expired durable opens should not be reclaimed by client.
>>>>> This patch add ->durable_scavenger_timeout to fp and check it in
>>>>> ksmbd_lookup_durable_fd().
>>>>>
>>>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>>>> ---
>>>>>     fs/smb/server/vfs_cache.c | 9 ++++++++-
>>>>>     fs/smb/server/vfs_cache.h | 1 +
>>>>>     2 files changed, 9 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
>>>>> index 6cb599cd287e..a6804545db28 100644
>>>>> --- a/fs/smb/server/vfs_cache.c
>>>>> +++ b/fs/smb/server/vfs_cache.c
>>>>> @@ -476,7 +476,10 @@ struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id)
>>>>>         struct ksmbd_file *fp;
>>>>>
>>>>>         fp = __ksmbd_lookup_fd(&global_ft, id);
>>>>> -     if (fp && fp->conn) {
>>>>> +     if (fp && (fp->conn ||
>>>>> +                (fp->durable_scavenger_timeout &&
>>>>> +                 (fp->durable_scavenger_timeout <
>>>>> +                  jiffies_to_msecs(jiffies))))) {
>>>>
>>>> Do I understand correctly that this case means the fd is valid,
>>>> and only the durable timeout has been exceeded?
>>> Yes.
>>>>
>>>> If so, I believe it is overly strict behavior. MS-SMB2 specifically
>>>> states that the timer is a lower bound:
>>>>
>>>>> 3.3.2.2 Durable Open Scavenger Timer This timer controls the amount
>>>>> of time the server keeps a durable handle active after the
>>>>> underlying transport connection to the client is lost.<210> The
>>>>> server MUST keep the durable handle active for at least this amount
>>>>> of time, except in the cases of an oplock break indicated by the
>>>>> object store as specified in section 3.3.4.6, administrative actions,
>>>>> or resource constraints.
>>>> What defect does this patch fix?
>>> Durable open scavenger timer has not been added yet.
>>> I will be adding this timer with this next patch. Nonetheless, this
>>> patch is needed.
>>> i.e. we need both ones.
>>
>> So this code has no effect until then? And presumably, the scavenger
>> will be closing the fd, so it won't have any effect later, either.
> Not at all. We can first take steps to prevent the timeout of durable v2
> open from being used. There is absolutely no harm in this.

I disagree with "no harm".

As I said, the new behavior is more strict than MS-SMB2, and therefore
also stricter than Windows behavior.

Additionally, in the absence of a yet-to-be-written scavenger, this
means that fd's will remain cached and unclosed by ksmbd. The client,
in turn, will reopen the file, which seems like a source of sharing
violations, which become unrecallable in fact.

Finally, from a code standpoint, I still don't see why it's being
added before the scavenger functionality is even ready to review.

Tom.

> Thanks.
>>
>> The patch should not be applied at this time, and the full change
>> should be reviewed when it's ready.
>>
>> Tom.
>>
>>> Thanks!
>>>>
>>>> Tom.
>>>>
>>>>
>>>>>                 ksmbd_put_durable_fd(fp);
>>>>>                 fp = NULL;
>>>>>         }
>>>>> @@ -717,6 +720,10 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
>>>>>         fp->tcon = NULL;
>>>>>         fp->volatile_id = KSMBD_NO_FID;
>>>>>
>>>>> +     if (fp->durable_timeout)
>>>>> +             fp->durable_scavenger_timeout =
>>>>> +                     jiffies_to_msecs(jiffies) + fp->durable_timeout;
>>>>> +
>>>>>         return true;
>>>>>     }
>>>>>
>>>>> diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
>>>>> index 5a225e7055f1..f2ab1514e81a 100644
>>>>> --- a/fs/smb/server/vfs_cache.h
>>>>> +++ b/fs/smb/server/vfs_cache.h
>>>>> @@ -101,6 +101,7 @@ struct ksmbd_file {
>>>>>         struct list_head                lock_list;
>>>>>
>>>>>         int                             durable_timeout;
>>>>> +     int                             durable_scavenger_timeout;
>>>>>
>>>>>         /* if ls is happening on directory, below is valid*/
>>>>>         struct ksmbd_readdir_data       readdir_data;
>>>
> 
