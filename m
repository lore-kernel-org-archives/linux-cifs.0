Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11022142.outbound.protection.outlook.com [40.93.195.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A315E2773CA
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 15:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.142
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780761030; cv=fail; b=d2OrJYfrMSA19X64XvZWUnWlPvcJdPO/nXsnVnHvyxxTN0XvuU/6xf5Y69Iz8Esyk54Ylemi2T+MfQewn1noqlzubu6MXeNC7uPM1WPfweaEFffrUfK9loCLc/+nMP8J4mO0z23YvhL/TKzovXUshCYAJvzeWBhAn9FisSBGtAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780761030; c=relaxed/simple;
	bh=In8+5ejoWHzURr5keZam6T5lSUH9cQt8Pzg9kxBuZ7k=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WB9lKxpe9I4u2/+4CZTkJGbNykMM/daGVjQKJSxPZ0aWjeb9QN/CcNNdutpvGTIcoVohQROvuFoGbSFiE7JY6ATr6rTbQ5is5R691eI6iuUq3MsTGpkxmI3GENJX4qCyW3RGy2up37vForvbtf108OPHaav2woNyIDXPrIWAC1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.93.195.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bD/ATfdDFaOCMzN75VzOOQjFFPftQ092NGmY+wISMAoZUvtaleL8ozI1OF3ofgOgKY2eB/f6OjZ3VEgvt+wvqywEGbKUBgy29Y0lBF32TdDwerNnxOd+tOObzft6CngUFxHeDJ3cjYkQicv36r82m0FpAJZKqSdXJN1iKdMsBW4MOhzez9I5igkeq4+eLPW+pGOlBgSV9XlhNxVpiOGSPgWcksoGkVXWluaQm6nS5sbDb9/jtcwRz3ivq5o0Vz9kn+TiY5Dfi7b6TBlDq2p1bIxwL4Skfzz32laDnMg1Zw/iM4PLPVmHb/InQMjdBDfXJasRlDxavz7IuUdb2R2AkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5BmbJQkNz0z7dneueI64HV9jSZHgWb1PEsRUck2ZBnk=;
 b=qQDkWYjLseQJSPlChZDffdQvZQ3Ouf2mRE78A4kiLIWLOkx5z8LB/k5P8LRaUN6CWEP4W7f2mC52kEE+MbJfNMCql3cohujNfvKbUD3t/qgQ8GloC8W2kmqxFX4VqVvc268QM2LzDf5HzZ9PqUne8KDmdKb5cZNcOB1FpdxW7V4L5CFS0TMYiH6ZVyqWihx9Nau+T1UdSCmFBUIm/uLfYiNWKV33ry311VrFpA6Y+QwB6SES6rzZc4t8gxeXNS9DvE0eBETrndtLvHyham/RxcUONOuDDsZqmwc9zo/VL0lyTLiRd9CqOoCXX1kmb90t7Wyt3bO9U9PQft+XmEmU3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from MW4PR01MB6338.prod.exchangelabs.com (2603:10b6:303:7b::15) by
 SA7PR01MB994295.prod.exchangelabs.com (2603:10b6:806:4ce::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.9; Sat, 6 Jun 2026 15:50:27 +0000
Received: from MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761]) by MW4PR01MB6338.prod.exchangelabs.com
 ([fe80::e7ad:d8fa:59db:4761%6]) with mapi id 15.21.0092.010; Sat, 6 Jun 2026
 15:50:27 +0000
Message-ID: <897cebdd-5cc2-45e0-89bf-f93c3306521e@talpey.com>
Date: Sat, 6 Jun 2026 11:50:26 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] smb/server: implement FSCTL_GET_COMPRESSION ioctl
 handler
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.org>,
 ronnie sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Bharath S M
 <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>,
 David Howells <dhowells@redhat.com>,
 "Stefan (metze) Metzmacher" <metze@samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
References: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com>
 <20260606092601.299698-4-chenxiaosong@chenxiaosong.com>
 <CAKYAXd-DeND_0vjHTrbTaWMjvMAk3dpiDFp0XJyK756C8AiJRw@mail.gmail.com>
 <CAH2r5mtmggcLnkBrFOX-ob4KC=v8LmfOGfmzH0X-WR5nxNTceQ@mail.gmail.com>
 <CAKYAXd8V9XYaRLFviyBTxLQuWAsvDuab1nmuX_i4v4nY8j6iHQ@mail.gmail.com>
 <7b58996f-270f-486c-bba2-0e3971c11b91@chenxiaosong.com>
From: Tom Talpey <tom@talpey.com>
Content-Language: en-US
In-Reply-To: <7b58996f-270f-486c-bba2-0e3971c11b91@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR04CA0024.namprd04.prod.outlook.com
 (2603:10b6:5:334::29) To MW4PR01MB6338.prod.exchangelabs.com
 (2603:10b6:303:7b::15)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR01MB6338:EE_|SA7PR01MB994295:EE_
X-MS-Office365-Filtering-Correlation-Id: 5627153e-e8e2-4e8e-e0af-08dec3e35433
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|4143699003|56012099006|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	CUcZ49kCcuHq/T8OnuqfDLa5auWl0sPMocdyjeXVpjLYlhUde+4P3j5AdG7uGSoYLnSiUhkXm/0gnw48wi4u+wY1fhnYHZamCeD0JX4POC5Wp+XKsRljzrJYZ+7pMZY01/5hJQC4RKnUS4hoO49OTSBdk+50IHaetnXe2x5rKN1qPYJo57zGIWpClQg5ExnN9ohUtsJeUq04XyKPqIMHAssClLM9cENesoAuyongb1GjRZ7DumUvPvIwj931+YTYmkWfHXU7JJ0trzYq5gK9wOHz8kfL2S1LoU9MxSaFRe7BWZAgGZdCvlC1sZSSIqYIWXIQBG6ZjP+OeL3sNq1tibW8Mb0Pr5Acv3IXIWPTtxMWevD4e6B0USaCY8b23a8tkOEGMa/zQ//qDwvVcHAXoLWJxknNd5u/gVGs7JMDLCNb5WKZ7sp0ODdvtXLib8JaMydlaK7tqeYCB4r3SIDZHou6dmCUGtZna8GqpNbCOhcvqVAivs4/jDHEjVls9OFoVGa1M3oSLh8PcgaYNarn0tf9OKlJTLcixO47OGZMSOOXZOn5e+ILajT9XzvEtUN9dY32ygN+2ggWu/beQIXCM2rGrxHlCBQH1sSmUOCt76+aGVg0KjR7ciQvVlTr+glvV/K+6Oxbb6qPu8TsFY71u2yI+S0EjVXtu8NpBpomcntQ/wJDkgO+26r3S0SHnm/LMQCyf9AlrDUoevdQztJYeQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR01MB6338.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(4143699003)(56012099006)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OGo4TVVkVjhoaURaSDVBTHpGdTI0d2hrZE9vUk5lUGxBQTlBdEw3Y2RxR3hm?=
 =?utf-8?B?N28xZlpxMnd6b2Q4aDJqQVBUdDNOQXFoNHlyb3AwZWJXcjVHWHRTV245c2l4?=
 =?utf-8?B?akZZSlZtQU9sOGtiMHRaaEZDejYwY1BQejlEeEx4SWo2UnJ0QlltUU1mOEpN?=
 =?utf-8?B?TGcwSDMyZEJIUGdBZjV0YlZBQ1F2T3RhMExDUTYyL0psS3BhbU1ocm1VK1V4?=
 =?utf-8?B?Z1UzYTFPbURGdHRQby8ySXlhUXcwWGtLbHpJeHc5a2pXUkVUWm1iWlo1OFcy?=
 =?utf-8?B?U0ZRM04vZ3VCWHdLOW4zQzZBR3BDS0N2U1Z1Zko2UU5BbnlyYVZVNm9MVER5?=
 =?utf-8?B?bEJKbi85OUNBL2hLeHA1eEhvMXZYOG44US9jY3RCd1RHSlpnV21NalVoQzB5?=
 =?utf-8?B?a3BTQ0NhcWNkc0dpYkREVlFjZjZkYlJ0UTAyNjk4ZEV2cWVaaGJkWEpWVlZn?=
 =?utf-8?B?TTBuL21UaWgwYWQ5bS9BUkk5eFlRNzR2amVndVNpc0NzMHNPY0R2Ti8zY1RM?=
 =?utf-8?B?cnM4ZjZoSW9JME9XUWs4UC9YdFRTSUxOL2FXTHpNUHBObWRmYzduM2NaOEZz?=
 =?utf-8?B?UklEQnBiWEl1UndIVzl2NEJHYXlUbnFVSGRicFppMjNCcDluc2VzY1pIRzAr?=
 =?utf-8?B?c1diV2F5RTM2S09JcVVHSEpoTFdvaXU0NUNBU2dRd1hFN1ZPWDBaUnQ2amlv?=
 =?utf-8?B?RVpuK1pnS084KzIySnROZ0QvY3RzWmFlYW05cDhJQUk3ZS9mcy9KNHdObHlP?=
 =?utf-8?B?alBFcWNoOENrNnpvZzFJZllMNlRRaXFsRGhmZFIxV2Fyb2ttVE5SUG0vT0xw?=
 =?utf-8?B?anUwdzFZeVVjWUkzYkRNRzJMOGpUbXJtZGlHZVl0bGZQVUJOcm9wRDNodDRP?=
 =?utf-8?B?WWFHOFh3UmF5clFiT0ZlMXRwUzg2cU1YQ2NlakFDYTR6ZjBMVFpBSzE1N09l?=
 =?utf-8?B?bytkRkd0dGVpeDdlTmMxQlFTWEV2SjAweTZTVVlVOTFHTkJiYzJuOUx3VENo?=
 =?utf-8?B?S1BwZ3QxUnZUSDBwZGY1YnRIQUJkY29hKzE2NDcwWTdYOUJpRHZYVWJyTmpQ?=
 =?utf-8?B?bjBJTVhEUTJQSVFUejIyL3VzSzFIT3dhMHhqNlpsVHI4NU5oQ1h6RHErQjVZ?=
 =?utf-8?B?VVRYcHBRbzdPYXM0YjVJNkZuTFZJd05QdG5ObXlIcm55aXRkWUV1WVpLcVVZ?=
 =?utf-8?B?bE03UmtMRmprMktZd1AxRkMzak1EMHppZHcxRytna1NJKzMwRjJjOFB2UmM2?=
 =?utf-8?B?TGNuZEV4ZXRhTHUySDJHaVBKUEo4eE5EWURkY2RKeVNrcmttZXByVDR0Q252?=
 =?utf-8?B?LzdOc0U1S2gwcWF2Z2puZGI1Vy9YaVRoV2VlUGJZRnpTTUNEM01RTE9xRk5v?=
 =?utf-8?B?NEo5ZWhtcTF6cUJESHp0THFiQXJKUGhYeXdnSEpmOEd4eXlDQzk4TnNMcFJW?=
 =?utf-8?B?T0pBeVZHL0ZyUk40YUsvbGdhUUJVNm5CbURHWU9NU0EzRm5wMUJERGpPZ24y?=
 =?utf-8?B?RlR4MlZhdjRabnJ4U0RNenhZY2oySXN6RkNaR2Nra21hRHhBOS9Ib2FMVEJm?=
 =?utf-8?B?bGUrSFBhdkI0U2FISC9Qd21hTG5ldUlJRTBPK0psSmNocVV3ZVR5VXI3TXZB?=
 =?utf-8?B?eURiUElrbExyOVpZT2g5ckYvSTJmM0FSak9hUEt4dWNoWGJTd2EzNlFDTFFS?=
 =?utf-8?B?NVY5TUgzSmxQcjJSVHo0SzhmZWY4UFU0Rm85Sll5YjcxVGU5NWZ4UVZtSUFJ?=
 =?utf-8?B?K0RUb3lwZTZoV05ybEROTzh4bVl4RWJwa2NaeTd5MDhDc0IzZnI3Y283Y2pZ?=
 =?utf-8?B?eFNmMloyOER1Yk13ank0di9WYnZrU3p2Z1FyNC8yWVVrVkQ2dlZNanpBWllR?=
 =?utf-8?B?K2diWXlDVFJyQk54ajgxWFg2Y2pmRG9aWkJtY1RvamVmb3k3TnpWS0ZMRTV2?=
 =?utf-8?B?NGRkS0g1TGZDWDBZb096TkJYSU5vUndBNVVyRThtalhSYW9YZzEvVjJGcHFr?=
 =?utf-8?B?UVI5QXdkelZZOTFqcnRaMDh2U3c0SGc0OXp4QUdXOWFjUTY3ZW9GMERxbEpz?=
 =?utf-8?B?TzhDclV4dDBBS21kOE1kSEU3enN5cng0WXNqQTVDbVBWdmRhWlI5SnllYjdv?=
 =?utf-8?B?R2tTUVVYY0p6Q0hEUkVzdUk3dUhTMzBHblVsK2dwRUpNWHhteE1aMCtlaTlJ?=
 =?utf-8?B?UkZCdXNZQ2Zqc0xLUFA5Qm45ejRhSDliTkpQSy9ZK0IrL1dOZFp3amNFK1l3?=
 =?utf-8?B?bHdpK1R6a3oyTWtER0tVQlgwM1JLalVkS1pSREpJZHJSVjhaUG14NHdiM281?=
 =?utf-8?Q?mHrn9hrpWMfNHoLali?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5627153e-e8e2-4e8e-e0af-08dec3e35433
X-MS-Exchange-CrossTenant-AuthSource: MW4PR01MB6338.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2026 15:50:27.2194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cyipL+LpzRHzPh61G4Q+zaGkT2tLh7CZ3j5d+hrDc8XsQrA8DOOoKcvFvkRHzefA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA7PR01MB994295

On 6/6/2026 11:14 AM, ChenXiaoSong wrote:
> It's more likely a specification error (an omission).
> 
> 在 2026/6/6 22:35, Namjae Jeon 写道:
>> See:
>> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms- 
>> fscc/62de177d-ed90-4884-ae04-9de52f1180f1
>>
>> It is defined in the FSCTL_SET_COMPRESSION request but not in the
>> FSCTL_GET_COMPRESSION response. This patch is for
>> FSCTL_GET_COMPRESSION. I'm not sure if it's a specification error or
>> if it's intentional.

Not at all - it's intentional on both counts. In a request, it
signals that the client doesn't request any specific algorithm
and will decompress whatever the server chooses. Remember, the
possible algorithms are already known.

In a response, it can't be unspecified (default). So it's never
returned. The server basically translates DEFAULT to what it
actually used.

Ok, pedantic specification language aside, there is only one
compression algorithm defined. But the server needs to inspect
a request for DEFAULT so the code in ksmbd needs the token in
the common header file to perform this check.


Tom.
