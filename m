Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11022104.outbound.protection.outlook.com [52.101.48.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8499F175A71
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 14:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780756917; cv=fail; b=tcKd2Mlg/9c3jkhDHfdjp1B4qGro1Xz+MrH2X0D4lPyWDTksawaInqrzBCG3LUBBHxiYLFn5wqHSgN+eiZzuFnODFD9vh6HrW9DSZFLDRST5tEJJwucGGYk+mlYpm7O0W+VJViXgTpcjGJsr94cAZ7PSC5LWtSLWaD4IUMvQzbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780756917; c=relaxed/simple;
	bh=/4PffgeqFwTrFiQwnmk/fS+cj2v4YI2XcuXrWDUDpmg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RdQth0Fq/9jInQQMsF37SkadhiiMAFgWkL9d253+0KIGGYUNeALUPWbtggzP8ZchTP1QOvdynm6Ae03duIQ8gRvlAbTbA6BaqiuFdbXUxyIBKYmc/YMaOkqrwhMByH8qe8mz55rvXw7tuGV/nHK9FmXwTOp0wLZwjPASkfsitvo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.48.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KIgbhm5BF85e8jeY0zoHO3dvjqx4KlPQYKu/HV6sXWxAJKIcnS/ZC8ghzuW3NpLcx80rkgor1cgFr35xCVZG3oWn1yIUrdeyDp55ik8Iv60yBstkT5+E6Awzp2Lc0CVxZibZ0rRMKnfVLLFO42LarIkA1vUKEzEBfz0Ba3pY9DFeSrZNlr4P9ltFVI3OGbWcsQWwpXrSVfRhirH1w78PNUooMVf+cnuJgOwvZRbqXVLOt1Wq3D1UQ7r/iYk4mJUJmAjvuhPke7thTPvHKSzEBmE+hLkzDftegQeXYk9Io7fZ9qDFs88kR59Gl9c1BIErzzxszieX6Mxo2j81kaMwlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dpr77Ljlic10Yc+90nivesL+4gTeocc4EYP5DwNtZq4=;
 b=zOcWNAVb1Ps+YIbD8OWUeGnym1DVAAJtk624yvRLwXywpQpEEPXQob9PhCvbcvb1VTqTcfXJwiIwHX9OsvkHLWT81r9dCY0+KF3SAB+IxDKO8d/JOPZbiBWl4h0S2A5H0zdIC1lercnvr63LkqD971y9gUGuq8MLUUrYNX2oQGn/A5VWIEiChPfw1qUcMN/TRvlUgXMmG+lKKr5cty6MxNZ+nfpMzHBsHt6C+FRaIde88YJ6VmejGCXVdq+I4MD0oT55AzQ/jBmAWgtqbIlEcPcGPseiLzMR2KVJFxUUPeRPAabiDbysz/EFwgv3TM8Kvi0Zq+WelMKuYMidyuurjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from MW4PR01MB6338.prod.exchangelabs.com (2603:10b6:303:7b::15) by
 SJ0PR01MB6224.prod.exchangelabs.com (2603:10b6:a03:2a3::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.11; Sat, 6 Jun 2026 14:41:51 +0000
Received: from MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761]) by MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761%6]) with mapi id 15.21.0092.010; Sat, 6 Jun 2026
 14:41:49 +0000
Message-ID: <de411d1c-36ba-4fb5-94cd-4ac6026e0465@talpey.com>
Date: Sat, 6 Jun 2026 10:41:46 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] smb: move compression definitions into common/fscc.h
To: Namjae Jeon <linkinjeon@kernel.org>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com, metze@samba.org, linux-cifs@vger.kernel.org
References: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com>
 <20260606092601.299698-2-chenxiaosong@chenxiaosong.com>
 <CAKYAXd-inU4rYZ=P0SmLUwDdL-x=QtJuBPdSg2DRKZMF-KuLDg@mail.gmail.com>
 <a4502395-735d-4c90-a116-754a3e91137b@chenxiaosong.com>
 <CAKYAXd-H6PoLQ+4CTMFg0UvRB7m8V+UinVQRcCB1yk-icB0rrQ@mail.gmail.com>
From: Tom Talpey <tom@talpey.com>
Content-Language: en-US
In-Reply-To: <CAKYAXd-H6PoLQ+4CTMFg0UvRB7m8V+UinVQRcCB1yk-icB0rrQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YQBPR01CA0011.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::19)
 To MW4PR01MB6338.prod.exchangelabs.com (2603:10b6:303:7b::15)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR01MB6338:EE_|SJ0PR01MB6224:EE_
X-MS-Office365-Filtering-Correlation-Id: f733c6ba-ba28-4612-13c0-08dec3d9bda1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|18002099003|22082099003|3023799007|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	B5L6lK4AZorMe740bAFVP4ltLFCLXJgN/ovER1MKA9GyEY57Syz4LpMeFDOCCBrBkDwWN1goDHnkR9/Sl2qgVXIS28DiPvRjmJTPfIxDkm4d2VaBK2KUpJ6qkfCdeLWvU/SyH+nJeMdUe7YnA/pwG7ke3BAmwN0tmliRfPcyd7rs5feX+lMgNPGW6VhTn6GukMMvCzOKdhEpEgdUxoNv8UFTnYdID4GLo5eo7oAEh9gwncQavzthBDExLVE2xMrL8u7fMFbcKtcu0oMR6ZA9eVQ3p/5jmTKnH53CGzSsGswDA0DP+yCk0TYROCNT2PAkeQOHjpZKFxgQawtW4xYcjjreRJCgSGr0RCzYFHrDSQyNmPypKFtlCEFiDPOdrRUniHt3hQoe0cH5LqdTqQ2ySZ7Fm9wiSL29b6mEozVeyijpLiO15ChZykwpCUHILWsRtz65wAxhqvjcQflKOCyMba7Qafk0BLXV29ZtYwn7N38ISBD8nze0a7tCnUofOZ7UTfqZMoY2JtRouGSioV8mdMaxetYWcSfM3i8oVBpXDbDas34bRAgb4bJjU1ebrxP2yDffhOZRxwdRKqM4p8fAs3zRbkLimnYgz3sC2OtZIyMPJH9Ugq50/39IjvXcFpuwfSx9wFtjezkG5weNOWtkwemXp4mZ3yltxewZuVRYJ4m7Kodl3A+gubaSc3meEB4u
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR01MB6338.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(18002099003)(22082099003)(3023799007)(56012099006)(4143699003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WHJBdnFZeTA5M09XOFRWeU15OGxBU2pFc2tBdFFxNUlITUlPSSszOTExWFo5?=
 =?utf-8?B?ejhyaEh0aVNEMmJvaFdLZUVDaGwyaitxcHFHMHZFUmpoQ0dKVEdoeVdXdm5B?=
 =?utf-8?B?YkpRZFNMY0NZSWlJT2g2Y1kxb0Z0d2lHM05aYmZpaHFrRWQzWFkzaE9sRll2?=
 =?utf-8?B?bUlZUWhQTFcva0hDNkNoZVdkanFnQm1UVC9Ld0xxa1lRUDRUQ1pZcFVWZlNL?=
 =?utf-8?B?QUlKaU9IZUpYOGkwRGxROU1MWHUrT0taK29wYzBtTHBtOUVQaGZHMGdXdnlD?=
 =?utf-8?B?NXJmRVhXTFd1SmFHV1ZlcnJNYXlpYkJlNFBVdDE4aHpWb3EzM2FQZUNLbk1Z?=
 =?utf-8?B?Y0ZKQkxiUUwzdHNmaEpwQ0ErV3VPS2RsZlFmOXZtT0M4eDlwYmlVQklDMGJC?=
 =?utf-8?B?UEErTkhYdlFsbFVvT1BVTTd2OHFLeUNFcStBNC9MdXZHQUJ0WXY2QXpxMUdz?=
 =?utf-8?B?WnNXTjZNZXd0aXBBUmV0WjBlK3pyR0phaHBWL1NiYlVJL2JjdzM5NnBodjUy?=
 =?utf-8?B?cTJ3K3gyOVJvdkRjL0RYY0hybWNOdExmTE1oYzNYNkYxblBpdjJKZkhpbHBJ?=
 =?utf-8?B?WUJBb2VlRlpuOWNPREwwNVpXZmNoclJMQVFVckxzUStnWDlJMTBveEJ3eTJ3?=
 =?utf-8?B?cDRmQnNpM3RtNExFUU9sYXFvVFdYeFVXSC85RllSdE5aRGdsdmIwRnd2a2ha?=
 =?utf-8?B?Si8yS2lQcHJGdVFLMU9BRTlpNmpHaDdaUWxmNTc0WGdnaXpZOWd5NDhNUUU1?=
 =?utf-8?B?RGlQSHMzQlAvYnQveklSeCtNVDZyR0JiMkV0cHZDNysrdVRPU2lSQ1k3N2RW?=
 =?utf-8?B?VS9LY0ozMnA5dG5NSUtKMUxNLzJaMk1RU1RqQ0U2cW5IVUI0OWpVMGhCQzRM?=
 =?utf-8?B?RWRiWjNPNVk2QjR6Rk83Mng2Q0twUG1Xa1lRNHNIWFRWT28yMXdzWHZkdmJT?=
 =?utf-8?B?ZjJHZ3JBb2tpUmlzd2k3dEFiUmhhUm9WSnNZMWhWb0JxdXczeTBlK3FyUzNG?=
 =?utf-8?B?aEpwTUNLU01oSXQ2QUp4eHU3YmFjWGNpVm1BUGI1WitadHRFQkhBQzFoN1F2?=
 =?utf-8?B?UWFIeFo2T09abWViUi9GZERPVmdjKzMrQjArR3BnaDlvRHRBbmxCeUFkd05X?=
 =?utf-8?B?d29lelJib3IrSUhNWTRuSEJlaDBya1VqNnRIQWx1R2RORXFSV3BSMzJZYWds?=
 =?utf-8?B?RFk2d2FnYkhpRVNOTXFnNDA1aURtY3JmTkdLYUd3QVphOGc4aStKb2IzUEY4?=
 =?utf-8?B?dzFFQUp6dEVOUyt4WTVoZ0J3bkFyb00vSHJaSG9PLzRrTG1hdnMyYUE3ZWg5?=
 =?utf-8?B?U2x3aS9kUFBQZ05vd3R2VUsxdW1yYVVYRHA0K3RlMjlqSGVHZVBNZTBvdWkz?=
 =?utf-8?B?dHpYTm5NTks3eE9EME90S0laQ0VCa0luWkxPNDNyVjMxUXFncFVLNVF6YWVR?=
 =?utf-8?B?bjdTL3JFVGdSMTFqUTJtQWMrUlc2YkhjNzJrOG9sSWwvVEF2ZWdYcnNwL1Fj?=
 =?utf-8?B?ZGl2WStyQ21QcWF4R29qQmxBVE9XdzRVdnlDSDFHWDB1MElCcUdvZkFUaVlu?=
 =?utf-8?B?MUxQdXVWTjhOcTk1OFN2ZkNabmVraFg5ZHlzL29IeDdJL2NhRmMzVEN6ZjNp?=
 =?utf-8?B?WEpralFiK3QwRXdXQW8yRjNNZkRXMVRJcWFIbjdpRi9ZSlU5WlF4VTB3Tmkz?=
 =?utf-8?B?MVF2bURWNVl2STZDNTlTblY4Yll1cThYSUc3Y2MxUDl3WDFlTlcxakVYY0c5?=
 =?utf-8?B?Tk9wU2RtdHZEa0xyLzVpZ2FnVDZ5VmNZdjBqaFlRZXNWSStCcDNsQkZIdmo2?=
 =?utf-8?B?bUszaXZNdjB0OUxpTTdXZi9LRUgyQnNybGJONG1weW44V3NoTzlGMU4wV1FS?=
 =?utf-8?B?QmxaeU5oRElmcWZZV09YVUZLY0tqaDJUSFNWK2txRlQvZnoyZDFUQmNvbW55?=
 =?utf-8?B?bDIybldSREtYa21ucDJpU2lXSGc3U2xtS1lCMkE1Y3BJSlExTEJraHpDaCtY?=
 =?utf-8?B?SFJSZDJ0WWRlcTMvNW5GWk5RRWdZMDdNZW5SMkxCZENFcGJ3SUZoc2ltSXFB?=
 =?utf-8?B?dzU4MlpLZ1ZZUTlEZzVhUGc1c2I0djBjTjB0bzM3aTFkY3Vjc2djQWhaN2Qw?=
 =?utf-8?B?WjdxTDNCcTdvditRdkZuanVjUGZNeE1RS2wvajhPUUxSeDhFUE1YcEhBTXBO?=
 =?utf-8?B?ckJac0o5VW5IcFJ5NXh1UlNibmVnM1lxNUhqRnI1MURSdFJ1SndtU1U0Mlkw?=
 =?utf-8?B?THNpL1JjVDdZWE13cXFqN2ZIVUJrdEhhUndPdnpMQTRzRW1PY0ZPUVpzTVVW?=
 =?utf-8?Q?vWxc3UF7qsPjNk2UfY?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f733c6ba-ba28-4612-13c0-08dec3d9bda1
X-MS-Exchange-CrossTenant-AuthSource: MW4PR01MB6338.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2026 14:41:49.2455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Hco4dFPqMAGgI/xbXplooYlGvmlSAJJn8TILGZnYISQEroKvMuVx/IjIQrUFV4/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB6224

On 6/6/2026 10:18 AM, Namjae Jeon wrote:
> On Sat, Jun 6, 2026 at 10:51 PM ChenXiaoSong
> <chenxiaosong@chenxiaosong.com> wrote:
>>
>> Please see MS-FSCC 2.3.67:
>> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/77f650a3-e3a2-4a25-baac-4bf9b36bcc46
> What does COMPRESSION_FORMAT_DEFAULT mean? default?
> 

It's a behavior (choice), and the Windows Behavior note states
what Windows implements. Per the WBN link in the quoted fragment:

   <62> Section 2.3.67: Equivalent to COMPRESSION_FORMAT_LZNT1.

Tom.
