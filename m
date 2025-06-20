Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2091.outbound.protection.outlook.com [40.107.223.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44EA614F70
	for <linux-cifs@vger.kernel.org>; Fri, 20 Jun 2025 13:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.91
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750426442; cv=fail; b=HdLGri0Th8znFjwKP0zGT+WgKYVMhI+Cqb431we1B3+mN3Qqr0dyBe3EPJpwHyhyurQdJ4HTfDP1qI09/g47tywJmlR75h+sxcJTkJeeKAB+p8tu1KwRWrnDLLZVjPurVa7RzLzSZQ+JbAtJrWtyKfIzsT8NyLewyO48OacF+JU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750426442; c=relaxed/simple;
	bh=2OQUwNThZ5P+n60K6DAVqqm9eWJVlxwx2HExCN04POU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=T93Vpmid6h/BdnE0gII37J4tG/Ic2KU04c5bLawkwiMpBACxorP2X5DzWqIapTSDJaVjmVzmZSjBpt0OTQuCaYh/BNyqOh3UA0d2xX9q6KiQyltkJG276xeuHMpxmrh1S5pr9wjKPQ5TbzvRsYftnXzB8VxcdXFFwASTOJPz2T8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.223.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yM5EatmmOtN1r6fIDZ9H5vAEbNaWVeTwhR3iruoHhgJ1uguAct0LpDDoUtq27q5+zVvubG0aQm8woCxdd8V9AxC/qzqDSRsi/Jx5AOmoVbZCTh10ptBs0EAa1EzbEp8J1I7dOvmKSjhdlYXF1As5g/yl+/nzxBtUeIo05+qtOnDQYRvX/4jXt6pqqk7vA0mbLgxwo6EhOJ7YCro1K0inl0JyInv0lsqSw/xRgzfgvbHvLW5RkbDM/GXu/jqovnfKbd0wEugBYsnJIE+3sWpZF0KyUNifdlFZCazq6QW7Iqnb+m65ovN1KzPO1jtd3nvTdliHGJ790X4aLjOXqiycHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qvheQVQZMl/5yqlM2tCjctLfCMJGMtZKoLxqFE2bWQs=;
 b=jQIH0Uj6JRDdvfKyzw9hgQkqAD/XhKWCGlGe5AdF5xHIISCt0VdbTKsLGL8gAA3rMb6jGx6N1dv4LKUJqmyyyBDwtx5ungQnqniu0OlLhfEK3TnCAaKu94ABjrQetLeKXrMeHzdaHtyaxRUjMdHoGeiYOV8tEC39HnwMu5Uk4K5e6JlwFOqyK1P/UONEGWm3e3gjMAKs1T2uSVM4kazJPry6cCC51egvMJEuusxzLLjPogZaXhSq7td1/0bXVqiwehO6iIIrXRHN1qH8MToWgB8IIJhklQDp6yFRJgVLF/AQjpap5+EqmomhWy3HD8DazO/wzVmz5MQR8mroKS+/fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BL3PR01MB7099.prod.exchangelabs.com (2603:10b6:208:33a::10) by
 SJ0PR01MB7509.prod.exchangelabs.com (2603:10b6:a03:3dd::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.22; Fri, 20 Jun 2025 13:33:56 +0000
Received: from BL3PR01MB7099.prod.exchangelabs.com
 ([fe80::e81a:4618:5784:7106]) by BL3PR01MB7099.prod.exchangelabs.com
 ([fe80::e81a:4618:5784:7106%5]) with mapi id 15.20.8835.027; Fri, 20 Jun 2025
 13:33:55 +0000
Message-ID: <1a05a3ed-87ae-453c-a205-f621262e4fea@talpey.com>
Date: Fri, 20 Jun 2025 09:33:49 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] smb: client: let smbd_post_send_iter() respect the
 peers max_send_size and transmit all data
To: David Howells <dhowells@redhat.com>
Cc: Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org,
 Steve French <sfrench@samba.org>
References: <e07c9bab-5750-4a50-8b38-4ce8c1a214d6@talpey.com>
 <cover.1750264849.git.metze@samba.org>
 <8ecf5dc585af7abb37f3fabac6eb0f9f3273da85.1750264849.git.metze@samba.org>
 <962036.1750422586@warthog.procyon.org.uk>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <962036.1750422586@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P222CA0017.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::22) To BL3PR01MB7099.prod.exchangelabs.com
 (2603:10b6:208:33a::10)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR01MB7099:EE_|SJ0PR01MB7509:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e8bc643-a087-4cd6-1676-08ddafff1a9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZkozTFp5VnYvUW8vc1RMN2N1Zit2RkNYcDI1c2R6bzBsYmJXK2FDUFVoaGhK?=
 =?utf-8?B?SkRQbnRQaXlwVjVmeWgzall0cWNLZ3NnL0ROOWJ1OHE1Q09MaFdlUitLdG0x?=
 =?utf-8?B?UWhTTndqeVo3TndXQkRDem03ZHVPRGxscmhUcTFnUTVENStpZDVJcWhRbDVk?=
 =?utf-8?B?OGlEWVVSalNGd0ZwbDBrTk9HNDRSQXlTYU1MMCtaRVlmOXBKMVdhNmwzZVJF?=
 =?utf-8?B?L1RrbnhWQXpJY2tOWUUwSFdZSWZtNXY4UHhCaytyOU12alUvWkNTdjFDRS9G?=
 =?utf-8?B?YnpvbGMvbmVvQ3YyOE4vejl3WUJxVWg3ZFV0TURlK2dYTnl6eDBZQUZiZjBH?=
 =?utf-8?B?RlB6ZUw0VlBzL2IzemRIVXdQVlpGR0RraEg5dkJscWdXNlpQcUY3N1NOQUFY?=
 =?utf-8?B?b1VhalkwL0tWUk80VndLdUduS2FmbjF2V1NNRnpRWGh4SHBJeFlQejJLZzFL?=
 =?utf-8?B?Q1lHNmhoSjZvYmxrMGdQZDJIazRlS3lvb0QwMG5xbWNpbVJFREVpbzZWTXBq?=
 =?utf-8?B?UFJLREdwazVSZjdLTlg2YTd0dXV2R2Q2cTAzYVNubmFUN3l0b0daOEJZbnI0?=
 =?utf-8?B?SkZtMWpIemRSeTJhVlNuM0RiYWVvNW4xOUVjVldGSFB4dkJzNE5MY1JQb2xx?=
 =?utf-8?B?WGpPeTcxM1h4VStCd2NBWlF3T0srdU1EeHBFTExqelJPWk5hY0xwYmRleGR2?=
 =?utf-8?B?TThOakNMNlNPdTNDS2pUbythUDd5V0U1T2p2eXZLQzlzMndjV2NwcWhmcVJ4?=
 =?utf-8?B?Rm1WTWQydUpkL3lMdml0TUdCVWhYLzlYL0tvVklPckRZU05jQTU2SWlxdS9J?=
 =?utf-8?B?Qjd2WnJTRnZBZXlHZE1FOU5Tdzh0UGpnYThENDVpbElPanFZSXRvbmNmLzNU?=
 =?utf-8?B?Zk8zZ2hqd0JSb0pOM1dBdjVWVlFPeGFtcE5YOEc4THlCU0Q4WnNxVHpidC9s?=
 =?utf-8?B?YXF2ZDNZRFZMY0ZYY1lzaTgvR1FOUGppbFh3Z3NJVnFRL2E0OXpCTlFSSHlh?=
 =?utf-8?B?NFh0NW5SbWx5eDdaeHVyRThOUi9zWVRpRlZkSmxEWHh0WnBEZjVkSnZXV0pY?=
 =?utf-8?B?SEFkNmRCMXdVM0JsUWxKWjJnREVyUS92WW5UWTVCYks0VzBhVVFtdnlrQm9O?=
 =?utf-8?B?SGFrUzJUL3FUaHdQWWZqcWRDU2hHd0xwOU5jNEd6T3dDQUZHS1J6cFpNTXdD?=
 =?utf-8?B?bkk0VEh1cURkYWJHOUlUMXR1ZmI1RTAxYjNKZkNTcHYyTm0vQWtkcDBucGh6?=
 =?utf-8?B?SS9uR28vRy9tdWhtZGdCWnRQTk43dHB4SzlJOUZpU3RXQVdtKy9Cdlh1WExT?=
 =?utf-8?B?ekk2WXpZa1BMdVNRQlM1MGRqcDhlNGFKeldJaDQ5ejdmZkI1S014alFkZ2xL?=
 =?utf-8?B?cVJTZmZIWlJ5YnVyYmtmWnVSRXpFbEZJRmdMMmsxU3FBb0FQVUIxR0VoUmIy?=
 =?utf-8?B?MEhLWW8wR3FRL1prblQzVVJTTFN0T0lTY3pzR0VnRWs2VFU1VUQ2eTNhVmJI?=
 =?utf-8?B?L3hVMUhlMEY4ZnptRHBqaXZLU3NYWHo2UzFCb1FMS3Fxci9idFpXVWFMUFJH?=
 =?utf-8?B?dVBjUGVheDIrVHFWWnl1NHBrL1ZBV25FOGJaYnUrS1A5ZTVsZ1NZWDJSM25x?=
 =?utf-8?B?ZHVZY3dNNDgxZjV4cDUyZWRoaHdoMzhyTGJjbVRaKzBtcUJGWUxGb2RYbFFz?=
 =?utf-8?B?ZTNRejlkbWIzTHFaL3k3RHloSE96Y3BBb01tTzRRRFFHRkJXVklqSVQvK0dK?=
 =?utf-8?B?MWdWcmlEVnVRckFrRERlRVo2Y25IRzc2dEtKZFlGeU9EaFVZQjBPNzNFeEUv?=
 =?utf-8?B?dm9HcWVGVENtUGlKRG1qYXBKb2V2TnpXQllvSm1oRWdEbFRzaU9zTDlWT3hT?=
 =?utf-8?B?MG1hYjdSVDJaMzJ0emh6UlNZcDE1Z1g0d3hoQjBuMnMxYUo0OUtkRzBMVzcx?=
 =?utf-8?Q?FBebtkE74K0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR01MB7099.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmN1aExzR0VsQWxUbVpiNVRpbXhtbzUwQ0J4S0xSRWpJZ1JVUFNGVitMdjV1?=
 =?utf-8?B?TTM3eEdyVVdhTUEyK3NoWWdoVnQ3UjBLR1lkTU01K1dXeVN2TWE1dXhYU2FV?=
 =?utf-8?B?NzlNYTYxQlkraXhldmxRNEJFS1R3MnhPMzU4MWIwQ2dJVnFjb1BSeWtTcCsv?=
 =?utf-8?B?U3lGTkFCdzZSeW53b3BkUEdIRXBpV2RuS0hIL2ppVlFsOUNISFNkcXJ1VlhX?=
 =?utf-8?B?QUxURjNtZk5YeVRkaXplZlhXM2hTOFdNWHY2ajhtQjZsRjMvT0JCNHRWTGhO?=
 =?utf-8?B?MldYdXZRZDJZbGhrR0laZFcwYW5sME9RYkRiRHBPMCtPc2txWjVHWDZmTzFN?=
 =?utf-8?B?VzVDV3JIYy83MS9IRkRjRXd0enhscHJtOTk0NHJYNk91Tlk4UDltTTV4bWF5?=
 =?utf-8?B?eE1DMVBSY3JGenhYaGVmV1lrK1FjbjZzSHJtaDhPQ1UvZlpoV2RVNHZ3aWtt?=
 =?utf-8?B?U29kVkl6SmVpdFFoWkR0OThMa28wTWZGN202NVYxQmh2Ym5pc0w2K2JVVG9J?=
 =?utf-8?B?S0xzV3BQSzNVTjAyT25VT0h5cDNHZDZYWG9UOW81RkJOMTU4R2VLbTRJdjBk?=
 =?utf-8?B?TytUMjNpYkxHb2ttNHgrUkMvSTRGckVKZ2JibG1UaTN6MXQyMnc1eS8wSTlD?=
 =?utf-8?B?SDJZZzhLMEdBeTBmUnpvbmVWVlE4ZG1Sd1Y4WXRtYUlKVVBZUy8rczErS3Jo?=
 =?utf-8?B?T0VTaVpWNDhaMEhqblE3YmJnT0FoRldSZTJUbWJLOUJHTmlFTEJ3eHJzdUpM?=
 =?utf-8?B?M2g3aW1rZTFmLzdvWklnU0FvQVV3c1lKWkIreXY1emkzY1ZmL0hzTzBFb21h?=
 =?utf-8?B?T2h1dkR5Y01oZmlKOXM0anVXbVEyWTNaREpQSzFrVjUyOW02dHBkeC9IN2FN?=
 =?utf-8?B?a3ltR2FjQ2pCSzJHU1ZPbi9sVUdkaGlDelg3bG5jNFFoWjRwSVdWUXZtNUNr?=
 =?utf-8?B?ZkxWNitId3Z6VDk4VXByeCtQQ2hWN0crMFBQY0M5RTkrNG5INWNvbjYyZi84?=
 =?utf-8?B?NlU3c1QvWTRwWXNDeTFWeDl0UjVEQkNLRHFwQkNQaWMwc3JwZGxDQTl3TWhR?=
 =?utf-8?B?MEoza3VVY3dRS2xlaXMxU0RrRG45QzNNVUQwOTF3QWMybGFwalAxMHlXMTZ1?=
 =?utf-8?B?UHl3TTRuRW43VVV4d2xUVFBnbHBtaTI0a01kTDdRQ2toc0dQZXQrUnhFTkJX?=
 =?utf-8?B?NDR4emh1S2VyRG5zaDd4VmhPTzZWSzFFOEUwWWc3a1p1ZkN2T0V3dGlKRjRC?=
 =?utf-8?B?S3crOHg5Q3FQaXNYUzZXWDdDeGhzK2JENS9NVkw2THBaSG9GN2FUdlRSYlBB?=
 =?utf-8?B?clF3ZE9sSkpma0IrQUNwUzIrdHFBWnVpV1N5RUIzZWVkaHR2eWN4K2t1S3Zl?=
 =?utf-8?B?dkZ2RmJ4TnZkTi91RmF1WlpRTjhxV0FtaUxGOTh2ZWpWcnNDU3J0ak5sdUFD?=
 =?utf-8?B?MUpkdlVGV2JUbmREdXBZaFRKMWRXN2VxbTlVa2xyYUhXMGdQMGVUVXo1SUlS?=
 =?utf-8?B?bFdSL0lKc3EvSzdZUmp3czc0YS9HdFJ2R3cyUkZTYWhCWENQdTZ4UjdGNWRY?=
 =?utf-8?B?SW8zL1hLaEJKTVlYcnBWV3pqU29zY1Rac0crZVcvN0NhOGlGQ2tkTHdwNDNH?=
 =?utf-8?B?TjBhRTZub0Q2VEgzWjFNOWN5czk3ajl0SXlFTXdDQVpmQXhxSENIaUtzanFt?=
 =?utf-8?B?ejFIREYxaHlEQnp6QnFPZk52WGdlRmQ2dTJUUDZzSnZHeDhOMGxUQXNUMVI2?=
 =?utf-8?B?UXhSV0NEa1V2RlNiU0ZpNzlCdCtLbmdXUmFBTkxDbXdjMHlwa1Z1L0hkVVcr?=
 =?utf-8?B?aU96WGxUbXNUUEZGYjFCSDVrbGJhdzNkb1pBODFUcjE5NkEzUERjdHBzcDNP?=
 =?utf-8?B?N2w3bGliVkg2VC8xMFpXQmNlajVHZ3lrODJxYWFWd2t1aHk0OHNLcEkzbEti?=
 =?utf-8?B?azg1Ni9tekhucE9mZTFMaG5zMHZjYWFXZnlJY01lbkxpemYrYmoyWDJQaGtI?=
 =?utf-8?B?YVg0ZlRoZ0syZk9OdmtlSW1LQ1F6UVdLZk1MWmNFRENyZEc3RGlwNUc4Rnd3?=
 =?utf-8?B?bFl3V0c2OTZEYk9kOEFzejQxd1lKSjNhdFRPYmd4dXhUbWJGMzIyd2tsdDhl?=
 =?utf-8?Q?dNUg=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e8bc643-a087-4cd6-1676-08ddafff1a9e
X-MS-Exchange-CrossTenant-AuthSource: BL3PR01MB7099.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 13:33:55.6895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3p7YS200MKCjrVlb1Q3n4G8VNzGb+ZCloMui+Wkubhdkxp2pWrsivA1kLb+Q5iHz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB7509

On 6/20/2025 8:29 AM, David Howells wrote:
> Tom Talpey <tom@talpey.com> wrote:
> 
>>> +		if (iter && iov_iter_count(iter) > 0) {
>>> +			/*
>>> +			 * There is more data to send
>>> +			 */
>>> +			goto wait_credit;
>>
>> But, shouldn't the caller have done this overflow check, and looped on
>> the fragments and credits? It seems wrong to push the credit check down
>> to this level.
> 
> Fair point.  There's retry handling in the netfs layer - though that only
> applies to reads and writes that go through that.  Can RDMA be used to
> transfer data for other large calls?  Dir enumeration or ioctl, for instance.
No, the SMB3 protocol only uses RDMA direct placement for the payload
of a read or write. All message headers, plus fsctl and other operation
payloads are transported via these smbdirect datagrams.

Most SMB3 messages are of a fairly small and well-defined size so this
greatly simplifies the transport layering. Fsctls are limited to 64KB
and since they generally transmit structured data (as opposed to bulk),
they don't benefit much from RDMA either.

My comment on the layering was because the code did not used to do
this, therefore it seems this is a fundamental change, which I'd greatly
prefer to avoid.

Tom.
