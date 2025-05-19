Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2122.outbound.protection.outlook.com [40.107.220.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFACD276041
	for <linux-cifs@vger.kernel.org>; Mon, 19 May 2025 11:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747653601; cv=fail; b=fg7n99rnMJXtPsWeVJdDlTroOlQAuqw6OagnheCA3TxDtHtuMm4UPhHyAicL/vYX7sovucarg+hW86Mwha6q3lFedX+0RSoLFGy3JYPAtp7yd9sMmFWPLrJp3H7QxJ2h1kDczJzv6Kh0pUBgE9cCuTMTJk9cUqRrqiChOEcufDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747653601; c=relaxed/simple;
	bh=w/UkvQswerfET3nXjPb2ReRiZFKKGXtkHh4tfDT/tno=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oTccHmOZeSqcGrlRUJV8gEq/oCd5aPl/9sBB8rmYSiHZomZ4Erh5NemKl9KCilbheUDaKHEhRrSxa8ZrIRtscRLmzISqClPLW53Uw1FzZJ0mKguP3rTVufQyYQtagHYZdk2M8NisWi2MA/TXdbZ3MudEDX1uCgAI/CHoLCKJj6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.220.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qWu5lUXhQGZ7vnpa67mpdwOY4FeIOpAl8OHLPrZBtH0OkdyuAo1dlnp45ezqMkTuA5hu+gzSRrzKB7AwOiKOciZb9lhaqsFZcotF0kUL7EMUGyg2apVShbzAdnReBiJRdkMRHfbClFsn8shKVpX/CiCCoCpA05ZPnS+g9P8IN7caZ4bTW0nfdS3wzS9NYPJXzVwjhuJHZ9EabVi6qbhXtwOe/5pbY1Eehwl/yc6bXRuxvxZvg+WymdU/UseX00MTMzvA3RdxWJmgaKj5OXN54TILe/fSm3RmGXH3Yj3TmfMn60VckRPEPigi7pV7AguEm0y4or20N08+hIqfEQ0YFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vpwGvLaectgY47K3p67Op4v/IFJ1xGLbWFhgxSJX06M=;
 b=W1Ft+1CPGaQVMdawMZ6I2xSDB2i3XWXM6fDe6IEOeXQ2pMFHgfcdSK02LYAN+cHznwjyB1LFrTT8grQxQheOQKQQcsDkbCdgqVMj5a3TJf9FwW0bOgON5NrG7V+U8CMLsoBIGI2nUhhiE/uxCnTlh1KPMGat1JQ7IJ3IHimNGoR/2ZHXoGPV4CTdEq8QtrW1mzIsKtBvWG4M85qgN5C17QQDsPlUPqb69kUbIK5FES8ymMhcRhcaj7r7E3Xj5vokhMJJlM2Q84yaL2KHeqIKhhkvmn1Hjr7ZaXze9X9asBTkIDMBnIH0xXrb8bvmZJMjMLt9YykZeKgWqlIT0h9hzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB3854.prod.exchangelabs.com (2603:10b6:805:19::20) by
 DS7PR01MB7782.prod.exchangelabs.com (2603:10b6:8:7d::17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.32; Mon, 19 May 2025 11:19:55 +0000
Received: from SN6PR01MB3854.prod.exchangelabs.com
 ([fe80::66af:6788:adc5:f856]) by SN6PR01MB3854.prod.exchangelabs.com
 ([fe80::66af:6788:adc5:f856%6]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 11:19:53 +0000
Message-ID: <d1ba8e76-9912-4f62-9274-1b6c1158a07e@talpey.com>
Date: Mon, 19 May 2025 07:19:47 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: ksmbd: use list_first_entry_or_null for opinfo_get_list()
To: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Cc: Steve French <smfrench@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Dan Carpenter <dan.carpenter@linaro.org>
References: <CAKYAXd9COYLK-jagbrFu5uSMb4NEYF8YqkhqH5CzVYCBQ9PBnw@mail.gmail.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd9COYLK-jagbrFu5uSMb4NEYF8YqkhqH5CzVYCBQ9PBnw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR18CA0002.namprd18.prod.outlook.com
 (2603:10b6:208:23c::7) To SN6PR01MB3854.prod.exchangelabs.com
 (2603:10b6:805:19::20)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB3854:EE_|DS7PR01MB7782:EE_
X-MS-Office365-Filtering-Correlation-Id: cb937381-9b07-4587-3b72-08dd96c71357
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7053199007|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?M21yKzA4ZFc4MEoxUVlLaWY3ZStYd3VXWFBMMm8vaHgyZ2UxVkxiazB5ZHZX?=
 =?utf-8?B?V0tOdEIwV1ZNNE9RQTRqWVRJNDlsTmV5KzA3UlJUT0xkRm1TckpoK3dsQ1Vs?=
 =?utf-8?B?YVBDKzhjbjNuOUZXZmVuMHdTaW5uS0N3QTdmOVlua0RQWWdLbHczb2xwMFZh?=
 =?utf-8?B?dDRJTDVNVFJGRG4waTlYT2lBbDZVU29hY05RMkdZREhWMkNTbGRmclhyS2xU?=
 =?utf-8?B?Tlg0aC9wUDkvNHN1akQyaC9pdXZwaWVkSU9tTHRVK0d6djNQYXBydytadjhU?=
 =?utf-8?B?MGxqSE9JT0dWc05aZFlubS9UclduOS9paHJSNHBLdW9rU3czS2NoWlRRdytC?=
 =?utf-8?B?d0VpQzVUTE5ueUc0NDlzRC9oTlMxeEh0R2IyR3ZFbG9paXJZNjJRdlhUaFlV?=
 =?utf-8?B?MjY3SUxMYnMycVgyWTFXMS95QzZDREtzRldXdmpLbVVDbUtvdDExNFJ5eExq?=
 =?utf-8?B?M3ZpN0F6S2hscFlmK0kwVjFMQzRmN3IzNlZCbktWOElMQmtXazFOVWV1cE12?=
 =?utf-8?B?NEZEK3BzcWp1bGlQRm1NZTBiTmMyOHJtazdxa3NPYVpnS2Z0ZlJmekt0WHJO?=
 =?utf-8?B?S28vMndvSjAwb0xUTHlpT2s1VEp2OS94K01WYUh2cW1pME1CM1FQVEl1YzVw?=
 =?utf-8?B?VjhkODZjMkgxTFNDUFFaQ0NrN1VubTZiNjVDQ1pCTW5UeDRNUTZLQWZoYTVy?=
 =?utf-8?B?ZWtzd29PYjhqQmhUNHlkZ2Zrd0VjRDE5MGZCeXVjUGc3aEliUEJqQTlpaTc5?=
 =?utf-8?B?MkMrMlI1WE82cmhtTjJDbDd4QzRDbzZBcVFWWDM1eGdVSmh4K09FR2tjcDdq?=
 =?utf-8?B?REsxSWp1MGZxNHkyU08xMU5hQUI5Y1gvTFpVcDdQV01qd2QwQUsyWnBnSjVH?=
 =?utf-8?B?dy9YTVRZYW4wQzZVRFlMTnJGR3lEYUhMcFZ2WVVoTEFxSVJCU0JLdTYya050?=
 =?utf-8?B?SE90ZVRWRXhvUkZCMUtqeXNkTUVCTGdXWDcxaGs4c212aC96d2ZLQllxTjcz?=
 =?utf-8?B?R0JBQnV4aS8zaXh0Nmp5QVZhSGRmYnBiV1pRVU90dEdGL0R6Vld1VGVJajlE?=
 =?utf-8?B?b21zcUpPbWsyQ2hWZ3JoY2s4Wk1wTzdwMDBNTDFzZmc2RW4xcnRVRVcveHZu?=
 =?utf-8?B?THN5bGE2ZlJqVmZ2M2tCVTdIb1VUbXk2UXFENzVha2hLWFVDb1g0Zld5Y2dD?=
 =?utf-8?B?ZklTNU9YNWFLdUxSbGtZMC9yNXNsVkFsSTVBd1VaR2M3Z3NBNkJOaE9EeGFu?=
 =?utf-8?B?b2lTL3BCcUlFQlltSk9jNU05TlJMWXQ3SGlFSzlDWU1HZGpqRCsyM2VTY0xn?=
 =?utf-8?B?TjZOQTBselVZR0lMUFU1eHJGRkJYazdONHNobEtwK0ZZRTJQQko2S1BQS0lG?=
 =?utf-8?B?MEozNjRyUVBCemdRd29OSVVqSUlJaWJsVmpWQlppRGlQcUxCeHg1a2syWkJa?=
 =?utf-8?B?aDhXOHlTVDdZQWN1RFVmQ0lpeDkrUlhOMUUvVU5XNXYwZWFvakdpdCs4eUdh?=
 =?utf-8?B?T0tmSFZTZE1oNFMvNmZtTm9wbGVUUWtjcWNiTytZMXdlbFpIWlovbGpweWxW?=
 =?utf-8?B?RkprQTFjSlFNNkRJT1NmQ3k0Y3RWVnk1Z0x5OU1TR3I2Z1NMRzcyYTR3RWhy?=
 =?utf-8?B?cHAxUUFWZCt6UDJiYXJ3dUF2V281Y1FIYnNPL1hWQ21jVzJxYXhVeWFOM0kv?=
 =?utf-8?B?R1JYQlF3ZnBSNzJkS2FIM3RlRUVKRis1YUorNWQ5SkExc2F4OUVPdWpIQmpO?=
 =?utf-8?B?S1ZJV1ZYcnJtcmg0ZjVrQkVkQllyQXd2TWhtOENBSVdlYVBPcGZuMG5oTUF4?=
 =?utf-8?B?TTQyei9HK0cxamxkY0pxV2FMWjQzU1QzQ0NkUHJPTkxiNXBXdTEwbHg1YmhO?=
 =?utf-8?B?RUNFWUNxVjdmeENnOUttWHNpV2VpQXlHQnVSSDVqUExSdmVxeXl0WGIrRW9l?=
 =?utf-8?Q?Clb21oi00Us=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB3854.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007)(13003099007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dEo0ajc4KzNMZ0VvWVVERk1TMm11SVNyckJlTzJqYVR0OSt5S3hNaERPQ3JU?=
 =?utf-8?B?R0I4Mm9HZzNIUTFvT1pYR1BlM2lvS2pQbXd1UlFqSFkxbnNyc0Q5M0hYTTZV?=
 =?utf-8?B?NDJxZkRzcVl4RkVyYzdpNnM4YzNjREtZWGEwY3lCajYrUVllbGFoVkxEdldK?=
 =?utf-8?B?dUN4dUM5VjhWVGNreDJhZlorVysvK2FTUGh3WkpNdWZOWDFvRFhmeXlLeDl3?=
 =?utf-8?B?VUFlbk84WlNrNC9ZR1NqL0grUUNuVGNmdXRkTEJJYnJ6UXZrL3EzWUp3Tjgv?=
 =?utf-8?B?U0lCMEZxOElpb0Fwc2MvVHdGeENDVzJLSlRKZ1dDbnFxRVVSb2VMdFVlYUp2?=
 =?utf-8?B?UEt5RGs2RnhhU3NrNThib0lNYzhMdzhwQ2JHNUlJU1BpTmhQZ25IYWJ2TjNN?=
 =?utf-8?B?OFJzNXFMaU8vQUNKdHlNYW0yNG4vMms5bkpadkQxbVp3bkhMdFozeXdNNTdO?=
 =?utf-8?B?dzMwNnJydjlTbnQ5V3MzNTlpMEdpckNYVkVPbHh2a1R5MUxja2xsZDIzVWo3?=
 =?utf-8?B?VVMxNnRSOThDUVBBME5hY0VrWWUwcytJSXJJaTJwQUNxUml5dU8zQ0VhTFpJ?=
 =?utf-8?B?VThmVEZpbmROQjZlRGFmSUp0SGtCOXB3U2FUbGpxaDlOREQ5bk1CcktjL2l1?=
 =?utf-8?B?SUN6SW1EY0kxYmxLRTFydXVMMjRuVWJMQ1NXMWxLblMyK3JGT2tpSU1YbXNh?=
 =?utf-8?B?YXNpdEM2YnNGZmRQYkI2WTJ3Qm0xWWtxaGt6SG5adFQwVFdjYTA5dU9aMjYv?=
 =?utf-8?B?MFpMS2VWaDNVV1YxL3dTeG1xdXpoUk80VWVpM3JRSUNrV0lUWVkrV2gzVXpB?=
 =?utf-8?B?MGdLV3NJbjlPbmU0OUJIVVd4TjB5NDMra0tnNEluRytmMFJ0MjJuQzcxOXBw?=
 =?utf-8?B?M0E2dDV5Q3oyMmpUbFZTbC9xNWNWQWhaSERFLzM0K2JGZjQzWWJwM2xhc09K?=
 =?utf-8?B?NVMyelNZNENDQVBBcytMTXczTnJKSU9XNFNKaXV4SmtlREY0b25xVUJBMThi?=
 =?utf-8?B?WlRoR2FvZSs5ak4wU08xM2VtUHFNRHk5bXBSbUlSSWs5bUFGSjFJLzVMZHdm?=
 =?utf-8?B?Vm5STWsvejNEOUY0UFBxaVBiOWZZRnB5MmZWRFBkTlR4TDlRd29PeHBUWWtR?=
 =?utf-8?B?QnhURXIwMkk3OFJoeXAzMFBRWWpaM1ZKTUpYRDk5NGw4ZGUrdFBYVUV0cEhr?=
 =?utf-8?B?ajY3d1JQRndvcTgzN1JMSVBUNENHSTNiWUh0cjFWbEtaVTRqZ1dmeHhpckw1?=
 =?utf-8?B?ZytwNzE1eEUxbUlRaGJmUzF2aXlqVERUNXZrY0RhSzQzN2hRK2tDRWsyZlZN?=
 =?utf-8?B?b0F1ZU5EMlJMR3FiMkNpbTBQWjMxQzRqTEkyeTh3cVowa25FQlBDbXBmMEt1?=
 =?utf-8?B?RVU3Vk5BTi9heFArUlRaTHByZmE0VE5kSXBWRXlDL2p3K0tCR1YyVWtTWFNM?=
 =?utf-8?B?ZmpJdXhWcGRuMTNkUWllTnJ3dWwyNDJmL0hQbW1teEJYV3ROUTR4RVBGdEJr?=
 =?utf-8?B?N1ZXeEJCTWFrMlRNRWNEWkx6RnRPK2FtV2VabzZLYzFFSDc1NjJaSGZvZFY5?=
 =?utf-8?B?YmpHNkJDcU01RWRPeWVHbGlGV3duQ0JYWnFsZEtwNHgxNzg5aStJQzZhUmNi?=
 =?utf-8?B?Y0lYR2paTGhITWV5TEFpK2d1bzNNVWtqT0psMDhKVXBHMUNnWVlUdStJdFox?=
 =?utf-8?B?cEpJMTRTTEN6Z0Z6L0JKK2haQStWMkw5NGg2OHBnZzErQkdGb1JRTWVzTUlS?=
 =?utf-8?B?UWFpcXNSeDNXbXI2NXFoTzFmNkRWRGpQUW9NTG9lZDB4VXphcWtYZGgrdGdS?=
 =?utf-8?B?Nk11UXFhOUwxNC9pZFZvRFBYTkFOa296cUZZYXZrNCs2cWl4S1UzVVBaQXBi?=
 =?utf-8?B?WVpCTmRaVVB4N1c4bmxGc09SYkRCOExKTCtHZVlzNUVhWVpKbkxQVmZPSktQ?=
 =?utf-8?B?REgyZUFQVFpTWHIrSEsySVIveXI5M0IwcnBTVkhZdXFsRHd3YWsyQ3dQMFdG?=
 =?utf-8?B?K1JxRmJGdDYyckVHaHVxcElFQ1FmcEhzMHF3ZGtUWjVyR0ZERktZSTlQc2Vl?=
 =?utf-8?B?VTJtQ0RUcDVsT1N6WFgwaDFVMHc4cm5meGtIQ1diZjFNb2d6dkhNdkpsYk1M?=
 =?utf-8?Q?FQYY=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb937381-9b07-4587-3b72-08dd96c71357
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB3854.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 11:19:53.1914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QxkaVAjnzFXao3cWBUSM50AZZWXdkcxXyx8NEzTfdk257tGuXr/zHGN6hoBLZ8CG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR01MB7782

On 5/18/2025 8:33 PM, Namjae Jeon wrote:
> The list_first_entry() macro never returns NULL.  If the list is
> empty then it returns an invalid pointer.  Use list_first_entry_or_null()
> to check if the list is empty.
> 
> Reported-by: kernel test robot <lkp@intel.com <mailto:lkp@intel.com>>
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org 
> <mailto:dan.carpenter@linaro.org>>
> Closes: https://lore.kernel.org/r/202505080231.7OXwq4Te-lkp@intel.com/ 
> <https://lore.kernel.org/r/202505080231.7OXwq4Te-lkp@intel.com/>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org 
> <mailto:linkinjeon@kernel.org>>
> Signed-off-by: Steve French <stfrench@microsoft.com 
> <mailto:stfrench@microsoft.com>>
> ---
>   fs/smb/server/oplock.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
> index 03f606afad93..c20f3aa03157 100644
> --- a/fs/smb/server/oplock.c
> +++ b/fs/smb/server/oplock.c
> @@ -146,12 +146,14 @@ static struct oplock_info *opinfo_get_list(struct 
> ksmbd_inode *ci)
>   {
>          struct oplock_info *opinfo;
> 
> -       if (list_empty(&ci->m_op_list))
> +       down_read(&ci->m_lock);
> +       if (list_empty(&ci->m_op_list)) {

I don't understand why this is still testing list_empty().
Isn't that the point of the new list_first_entry_or_null() below?

Tom.

> +               up_read(&ci->m_lock);
>                  return NULL;
> +       }
> 
> -       down_read(&ci->m_lock);
> -       opinfo = list_first_entry(&ci->m_op_list, struct oplock_info,
> -                                       op_entry);
> +       opinfo = list_first_entry_or_null(&ci->m_op_list, struct 
> oplock_info,
> +                                         op_entry);
>          if (opinfo) {
>                  if (opinfo->conn == NULL ||
>                      !atomic_inc_not_zero(&opinfo->refcount))
> -- 
> 2.34.1

