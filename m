Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11022085.outbound.protection.outlook.com [52.101.48.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7794A22A4EE
	for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 00:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790468739; cv=fail; b=prBirbfGQ5VcvIjIuHmiWLLv7DeNM833Ya3quA7CHV0FDOLe+eIomxEvrkQjyLxlSM5RSWrFsFcH0n97i/SOZA+tQin2oqStVRvKllCYog5hQEs+3sT1jfNge6w+euW0rxnqjuaC5ouMEH9XLqX8VvbQtMxR24UNCtZXTENf7Cs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790468739; c=relaxed/simple;
	bh=Mt38ae8CoL3LPtReBQMxp3EbGZk9IG2zFtJ9Wxv3c+w=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=IWnGMdZkg4jBsCYSimtsFZz8UvAFjG1WnROMzitdXbC6I0p4M1MdUjKZfazunjkvsPH73lV/iOsBpPvhGehbN09krrq0NzRjN3ATwanDPzyulHT/v5CI43OVoLRJBiyWn1i30kOd0wZdEcHbnqqBG5g7jbLS4ragUor02hS7YDg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.48.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v75Az+gUiTFoNYoqvBe/Qj05apMaqkD3OXvFKsSe4n32u0CYQeVaTAbExGzywiOqx0FyUyjN8rfOEZjilhnVdpgVC27OR0tZoVbDyc0Wef+UaB4L2UCPubC4nNWl9xXFqzqX/L496dzbHLEdb/u5IhsWEFALy80bwBeyeFjubeLo9Pqdk9LSw6fLX2v5U5Rn4ulUaBn2aKe6xsxthfO5cFpv432WwC9hZMoW2SPhsDvLlssSeQpyxwrdPa/UFvuaAznsfqad6jCqjKbzlYdydOlORw4UVsnY0JyFIYTj5sqpi4IYxKkBWx6UPG5ltuqNUAAHG2lSi4fNO18NCNudjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mt38ae8CoL3LPtReBQMxp3EbGZk9IG2zFtJ9Wxv3c+w=;
 b=ULSiRXjOEB7Zb7Ka6Qt2opYQwy3VJwtc4Z1f0xRPQdvULqpBVcaTtkNoIQVKBuqb+o9ZHsZwrniUCvsfj0hdHFgfrj7bxEtgkyClpRyQmo9GTDjEoGY7UrK8bXvv5PRbkgWrYfd1CBsn5zfgjjESDvqD9hY3tSQgpkAmnzspNufxa04gKnJ8YE4e9efTnpXhReSwLI/OpR5ZW7EnyJ77proQjSvortzqFTk41wMPOT+c07dMoO3brL86Eo//ASJ79ah4I84vahMNw29ES533Z/fVlGYM3a7ha4N8/rRAhMzRC+PhiSFhMT5GkffEZVJ+cvnVMUOeu9U6LHm0cngvig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from MW4PR01MB6338.prod.exchangelabs.com (2603:10b6:303:7b::15) by
 DS0PR01MB8033.prod.exchangelabs.com (2603:10b6:8:149::10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.21; Sun, 27 Sep 2026 00:25:35 +0000
Received: from MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761]) by MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761%2]) with mapi id 15.21.0451.014; Sun, 27 Sep 2026
 00:25:35 +0000
Message-ID: <6fa542de-3008-4f11-9923-b6f7fbdd24b6@talpey.com>
Date: Sat, 26 Sep 2026 17:25:31 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] ksmbd: no check that transform SessionId matches inner one
 on encrypted requests
To: Namjae Jeon <linkinjeon@kernel.org>, Dairui Zhang <zhangdairui@gmail.com>
Cc: linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Paulo Alcantara <pc@manguebit.org>
References: <20260925174623.1640482-1-zhangdairui@gmail.com>
 <CAKYAXd-3Q3WboGm=s=t-BYf_t6HgiGLTm8CboLNUsEU1VvBzMA@mail.gmail.com>
From: Tom Talpey <tom@talpey.com>
Content-Language: en-US
In-Reply-To: <CAKYAXd-3Q3WboGm=s=t-BYf_t6HgiGLTm8CboLNUsEU1VvBzMA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0342.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::17) To MW4PR01MB6338.prod.exchangelabs.com
 (2603:10b6:303:7b::15)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR01MB6338:EE_|DS0PR01MB8033:EE_
X-MS-Office365-Filtering-Correlation-Id: 0070f2d6-48ee-464c-5426-08df1c2dd8de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|3023799007|10067099003|56012099006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	m8eLBsXzSBhmJ4IuzZyjpksNo/1ukaVQ55MjMsHo7D35OC7g9TJBZx7eesm5LcVu4pHXXSyC37lY9cmguFjnmXyGy5CgAbASkXybLjpEFOs2APNtPKuJexIF85CXpVt+2hPmEZ6mBA2ESVL2BwG74cN1JbTG+msgAUfyRPSt1jVcbqYHZPUMOFppMQO5lAiDtZSDM0yLy5FZlwFzdM8w+tZ8cP951omU/uTxtIRoGQj/Ro7X4iT4O/LxX2MZF+DIZDKfQw5eVBW4CL/eUo0VhQ4jDjx4bCaoM785ustjGUI1yCogoswYaXAtGCBAnFm/nMnLomlRhKp5GWzoojMx3m7o7wYETG71l6TGh9fPc+g0kXeoqVjQhhe4JsQxyemA/VAvuIaBdSjk3cemCyznMlr/4TgKM3OjgmMz22WXt4AHNd64WL7jn9sXCwu9MPQhjx9feOtg7YlUCwDZ1CLDwVajpOCtMLkoW3jMjU3wUp5xWWIS8pszMI8IaWSuzODwXUHndXw5fQlL/SNTwwVC+F7SLRxTMCGRNJKN+rywL4nIxAtsD3NhZnAfPLyEnXYmYPsJ5jn6VHowYTvBCz4m+ALBB/Ezwg0TSLYYDmtBgvq8kTgBGMETea3SPwuLzJEFdHJ0xOJZH7mWwIpnnu3FevEtOHn+6Z6R6m25FdYuKqk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR01MB6338.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(3023799007)(10067099003)(56012099006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TXhpY1lwbXEyK1NnTlNUbERZeHVxbzBZVFlhSnk5SXNVSTRrTHhXV25oUU1J?=
 =?utf-8?B?NHE5Q005akdLYi8yQjBMQ3RRdStVZ1JPeVpsYjJ1UGpUdEIxWVhxeEF6dTlE?=
 =?utf-8?B?NzJRYmEvcjFmSExTSmhZYjRHcHVORzlJdDYveWlKR2VBS3RYNkJ4T3FpdE9R?=
 =?utf-8?B?eFdyVnlrK0V0V2N2aDZ0TXZwRkZoWndUYnEvaXJmOS9MUUlNWHFYdVlOS0JV?=
 =?utf-8?B?Qlk2SXp3bm1qQTFjQjZyMzl2T2ErZWNrcitaV3NaZ0ljVVdrMlVZY3VvbjYv?=
 =?utf-8?B?enFEbjFTS0MzYW51dmxaZnZBM2VDQXpuV0M0QnorZERwQnJtclpmYSswdm84?=
 =?utf-8?B?dEFvQ2hDWTczSFVCUi9SRWVBeWU3b0c1d0xpMlhSUDI0ZHZJMldNc2k3VnBL?=
 =?utf-8?B?cXhBNzFOck1PZzZRc2EzbXQ1d2pWK0xnL3pvYUNJb01ZdlFOWHIwYi9YeHlD?=
 =?utf-8?B?cUk0dlQ0ODBlSG9VdE4zVElPUVYvdzl0R1RHeFhhL092elo3ZG1BY2xmR2Ji?=
 =?utf-8?B?cTZrTld4ek56NkYwL3U0K2VMTXF2clZMNndveVdwem5iR015OVhlVC80N1pX?=
 =?utf-8?B?TjFjUjBYYnpXS3RxekR4Y3RoQStHWWppMW9FcEZvdEpvUXJTM0hibFVxV1Zz?=
 =?utf-8?B?QzlkTHFJc0RySkZvVm9jSUF4UDJ4WE8wekNDR25OS3htT3NJZnJZYms1TzZL?=
 =?utf-8?B?QXJkbzdZdHRUZTh4U2R2eGRWZGJqOWEvVjlUYXdFdUgvMWNaYUgzak9Ld2Ru?=
 =?utf-8?B?eEpYVCtodUdzdHFjU0JNUFlNNnRKd0NyUlRkd2h1M1V5c0RMYTJRMU5ZdHVV?=
 =?utf-8?B?SUNpQmNIQlhEd2E5aTdFR0xOZjRxZnYwT2NhUitkdE1UbTAyckZpd01XTnN4?=
 =?utf-8?B?Um5sT05aNitTYWgrREc2VWU4SUV1TXVVa2NuMW16a2RyRzlFRlVWTnl1VGgy?=
 =?utf-8?B?bFpMaTRmR2NzUTk4K0Y1VFUzdXFrR2NxQUZzeXNsSnpLcVpaWFcrRXhaQ08w?=
 =?utf-8?B?V3Rha0M1ZVVvRHhTME44Zk5kdmpReTdsK3hwV1kxdTJlWFFTNTN5aG9iY1lC?=
 =?utf-8?B?MWNrNWNHRWhrWXh6MDNyUlAwS29ycGhvKzlwcEwvaG5Ib1dNaGdkVHdmeEwr?=
 =?utf-8?B?YnA0Qmd2ZW9mOXZZbkR6VEVneWorTE5CeVNKMTBleUVQWjI0QnFxUGl6VnZ6?=
 =?utf-8?B?bCtUanYzdHJFaTIzUVVNT2EyZ2VRMWs4ZmU3MmV2WHBzc29LVHErN1JNanl2?=
 =?utf-8?B?cnpjSVZjc2ZCUjRVc2UzeVMwZU5TaDFqZFRTc2dHRkVUdjZPWXExbk13TzVR?=
 =?utf-8?B?eE1vc0VUcjZLTmRkNk1UZ0ZiSEg1V2dIcjRSZ3VIdENyQ3dsbWZ4Y0tVQ1d1?=
 =?utf-8?B?bHVhS2lFTGxpdCtKVm4zOGMzYUNtYUkxVHV4bHYydWIvWlMwWndER05FcjJJ?=
 =?utf-8?B?bUVrSWt5RG9aMnFWNGl2d0VCVXQwY29KOFlzVHNtb1N0aXgyWDdXVldmSzFM?=
 =?utf-8?B?a3ZRVGlINHRGNDM5cGY5akFKcGloOWxsSTF6a09Sbkdnd2JXMGZ4TDdPWGpU?=
 =?utf-8?B?Tjl2K21hY25PMzJzcHZhUVJ4THJML0pWaTFaL2s2OW5uanhha1BucWtDaWdP?=
 =?utf-8?B?aHJQMGlWVjM3ZFY1U2pYMnpKTXZSTjlFVFB3U1hyVEFNTHdDOHBXN2VvS3ls?=
 =?utf-8?B?TUxZNTBtcU81K2Jwc2FSaWRtSzJFZ2Fza1dDZDBXTU1CdlBGVG83dUMzbkJF?=
 =?utf-8?B?aU03NUtkb0Y4a1l2SUJPUktQdHR5ZzY1RTZkazA3Zis3WlVORktKTklyNUNo?=
 =?utf-8?B?Nm5wQmZmSmdkTVZ0Rm9paC9aV2RjMWVXaktrY0JUV0tUYXRoejVYbEIreU5r?=
 =?utf-8?B?bmlsaWFEY2pZclNTek1GUkNJaUljZHdxazNiNDlzMW5DT2NMNFJEejRUNjJP?=
 =?utf-8?B?M3BaVnNKclF1ZHZTMSt2eHdXUlgzOHlRM1YxemRjYVJuODBLbUpjSWZyczZW?=
 =?utf-8?B?RmYrY2k4bnNQWXpPTTNGWTJ3UVRzaDV5dDhWemtYUDVNVnh4bHgwRG5ranR0?=
 =?utf-8?B?L0QxODVjb2Y2dVdlS2M3VVkyVGZUMXNnUGIrNnpueUdsYWpVZStVTUxsSFZ2?=
 =?utf-8?B?K04vL1ZESnNFNWJVdmUrQkJ5cnhPWGd0S1orRFAzK1dzNVYwM2h6U0VINWRL?=
 =?utf-8?B?NlRPMmlkamh2SG1lL0ZKR25rWGM0QUpudHBuMlRjNFZ0M1hoT3psUW5YaUJq?=
 =?utf-8?B?eE1XTVJRQnBkYTMyeURHMmtpTStZb2VndFhPZUFlT2lydXNvOVd5VXV0cXI5?=
 =?utf-8?Q?dVUarG5xCw8uFemnu6?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0070f2d6-48ee-464c-5426-08df1c2dd8de
X-MS-Exchange-CrossTenant-AuthSource: MW4PR01MB6338.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2026 00:25:34.9950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0TkgqgTBxPY9DB2MZeHFqg0LwYRx1qdTFJPMtb4z4Me3xJc6DeUAghhbSPw5P17l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR01MB8033

On 9/25/2026 4:45 PM, Namjae Jeon wrote:
>> Suggested fix: compare the transform SessionId with the inner one
>> after decryption and drop the connection on mismatch. Happy to send
>> a patch if that approach sounds right.
> Thanks for the detailed report. Please send the patch to the mailing
> list and me.
I agree that there appears to be an issue, but it may need some more
analysis of MS-SMB2 section 3.2.5.1.1.1.

This in particular.
> As I read MS-SMB2, the server is supposed to verify the two
> SessionIds match and treat a mismatch as a protocol error.

MS-SMB2 does have explicit requirements that the server MUST check
for equality (and drop the connection if unequal), but there is one
SHOULD attached to a behavior note stating an exception that doesn't
seem appropriate. So there may be a document issue which should be
resolved before deciding.

Some of us are at the SDC IOLab in Santa Clara this week, I'll bring
it up with the Microsoft folks here and report back.

Tom.
