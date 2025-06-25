Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2122.outbound.protection.outlook.com [40.107.243.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342D8278E5A
	for <linux-cifs@vger.kernel.org>; Wed, 25 Jun 2025 16:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750870385; cv=fail; b=upYMceI0pyyhR7S/jcfCo/Woxj4LtuG9VNPPJO9izg801mzpqed12FYfrscqfXltMZlnWzUE/pbSYfqJeABg6QA6ULE1+p8ZaQVGlNYfOAEdseBypOgKnPJXuuz8INuLapW14Y/SrjAu523hw/eginznv83NYX3v1u4ENzJRKRA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750870385; c=relaxed/simple;
	bh=lGn+Q73YDrZ0p5TRZCyg0Yspy8RwlxQxoTxMG3w1yhk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MeaIrYmgzTf2n8CE8kiHJ4bGEA+Ew9YCwrhLtHwfE5h6+mttLBJFeWEqyxpqZiU/sKL7nhr5TCUVqR9Mp4z7PsXxqAofn3aQHF/XHwsiaMgWVsTSF9DhFayRfOYv7tLnOKYaySp/SzbPDcHy3YloAL7OgO0RCyH65A5mHxnPIO4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.243.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J6uPzMVId9Es75jALnjhxwEe+k195UkQAdNZ4l8BUHZvw1ai2R+Y/gm277w/NIbLUFPi3YpAqG8O5ixVjoHNNJNcB3U5TQkF6rCF+FkT+51WoCbIrIeQYT/6/+XHBWqGt1NPkGaCS0TPy+YeLO41T/2a0IssWurOvy9E1Uhcp6j1hUvJ/3dVl7iCL19rn9UUa8CA0dgrHY9gJ2Ns2i5FUkv6KRr/gAXE1W3zPFOQSx7GwfHqnhEGTuQdzEScHRPPIDldFdOCZEuGQmehl7snlOUijhLYPmpmh/PMu14otiAUmITnemHWKDutX9GpvqGMKT0JTWDTl49cZweJamiOEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pfhXerauO0lVYzKVyh+xIJmQ1vPGhSE0yvjyIZ7PWv4=;
 b=yIsZAQVEGF9O+mRQG4GahQyKcZZ5BsJz2qZYaOY7gxqF+TH1+mdtFc8DlHxefWFCK8+zLw/HAZr5KCOBJLUZ5L0Peh8yUeRNKQ4GSQ4vRtbty463RGfqAK52DYQ1bheIbCiMRKXKQi/rF1xn1JMYklfMp4gebix81kw3OK7J8OoqceClSU0XdeeD3HPC0CYcJe7qQbQJ5szHoVifxi3WqM9uqtR3ZZiNXZsUSPrYjeFJMXbp3LNjQyj9qTxSMiK+sjJ3GJUM4QwQE5VWNhCZjU1LttXLsnxRK8mU/0GQLhO2kJl+8E3aaxFUEJwEhiqJJ5+HE9FDoTVYaMfp+X93Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BL3PR01MB7099.prod.exchangelabs.com (2603:10b6:208:33a::10) by
 BN3PR01MB9234.prod.exchangelabs.com (2603:10b6:408:2ca::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.29; Wed, 25 Jun 2025 16:53:00 +0000
Received: from BL3PR01MB7099.prod.exchangelabs.com
 ([fe80::e81a:4618:5784:7106]) by BL3PR01MB7099.prod.exchangelabs.com
 ([fe80::e81a:4618:5784:7106%5]) with mapi id 15.20.8880.015; Wed, 25 Jun 2025
 16:53:00 +0000
Message-ID: <31a6b9ce-9839-41d4-8b22-3d3c4db95e2c@talpey.com>
Date: Wed, 25 Jun 2025 12:53:01 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] smb: client: let smbd_post_send_iter() respect the
 peers max_send_size and transmit all data
To: Steve French <smfrench@gmail.com>, David Howells <dhowells@redhat.com>
Cc: Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, stable+noautosel@kernel.org,
 Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
References: <20250625081638.944583-1-metze@samba.org>
 <1288833.1750842098@warthog.procyon.org.uk>
 <CAH2r5mutiF0D6_SGSguYD2zbJCtZj454DQQMGO8JmJ9VtyqSmA@mail.gmail.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mutiF0D6_SGSguYD2zbJCtZj454DQQMGO8JmJ9VtyqSmA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR20CA0029.namprd20.prod.outlook.com
 (2603:10b6:208:e8::42) To BL3PR01MB7099.prod.exchangelabs.com
 (2603:10b6:208:33a::10)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR01MB7099:EE_|BN3PR01MB9234:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c8e4a0b-b744-4dcd-ff9f-08ddb408be73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V3I4ZytJN1hjZEw1RmVzZk9RWC9BMThVS2JmY1drWFJwSWNUOG5Ec2tROG1Q?=
 =?utf-8?B?dUdpYThBKzJOQko5R3JWVnNGTTQ0cTE3bFRzWkRuYS9RRUQxUnN3ZjludHIy?=
 =?utf-8?B?anhodWhOYmFGcERjVTV4YzdEVTVMb2RCaGNIem9YV0kvRUZWcmxJVXlmUHlj?=
 =?utf-8?B?WlJNTU1oWjM4NGt0YnExSWRqZ0tkcklscUtXYVJCM05yb3RTalFiQlhCUThK?=
 =?utf-8?B?Uy9xRVk0aUF6cW94dG5HcW5qdlc5amRpbFNpRit4dGczYXBYeTZTelYrdXBT?=
 =?utf-8?B?ODdncmkwZGtOQXBySnhOUVFJUXBpNHVGd1Q4MDBkZDVLTy94ZDhtZGMwVXhj?=
 =?utf-8?B?dCtyUnN0MEIvMjg0U1p4UGhOMlQyclZvSnpyZzg3SkZQeWkyVDdaOWVxZnlI?=
 =?utf-8?B?T2xQVjNmM0R6dTAyN01SV2FCejhTaEt2dnFIVTlkSnFBcGYxbDVpSW5VSUFO?=
 =?utf-8?B?TXdmWGtCNUhLRGxpbTNYclkwZmF2czV5bVdvWmg1K05XZEFyNklmVHBrVmoz?=
 =?utf-8?B?ZXpOYm5CeTBROEZhQzlqUXMxMEtNTHpRQm9XUUpmbUpGOVhTTHRYUHh0dlFS?=
 =?utf-8?B?MjE5ZkFwcVZKMlkwZlgxWjF3bGIyUUdBSmNYUkhVRy9tL1l4WVI1WlBlVHZn?=
 =?utf-8?B?WUppOTFDdCtwTC9FN1R0WExacDJ2TFBhYVNNT1JzNG84aGF0TXVHZzhDaFAv?=
 =?utf-8?B?R1MwWGNCUVZ3QTU5WnVBTmEyS3Btc3NDZjBpSTZvNnBOYmpHZ0VNV3NNSGcw?=
 =?utf-8?B?cEZOUUVjbHU3STB1WktNTjAwS0FyRUxqa0swOXBnSGtmWFpVZHMvejdnMTVj?=
 =?utf-8?B?VzNSZHJDNWlPTndreTlTeVA4dFJHRndNK2hYUWtrMzdob3RVZlNadjBobm12?=
 =?utf-8?B?TnU1c05wUFlCSm1RZXRtR0JpL213ZUdqS1hoUXh6b2FOemhiVFVhYi84R1Za?=
 =?utf-8?B?OUh6YUxZVkR4UzVST1VwTXA3bEZhRkYyNkkwaEJDcGVHY2ZlZy9EbEFMN2Fo?=
 =?utf-8?B?eW1QMkw1RE1WRzFnS0U0VW9hVjYrZmZyY2lpTDF2SEl5bUw5Q1dERGFRV1JY?=
 =?utf-8?B?SVdVeDVYc3lBTDFLWXdxbjRYeG5UNUNKdEVPNFZUTk1Pd05xUWZJL3Z3UTdh?=
 =?utf-8?B?VVZKbzRTRDlYZHRGa1YrZE9jOXpXZ0IrTWQrN05Ic05aSUlUZ2xuUHR5THlR?=
 =?utf-8?B?ZnIyRTdlK0xnK1J0VDhGcElSNEJlTDB2K1NTNW5IMEEyOTd5Z2JFdUg2T2k0?=
 =?utf-8?B?MmpNM1E3c2N4TzRwcDhhRFFkU2pxSk4vaGs5bTFFZDVXaU5CS0RNSk84MGhZ?=
 =?utf-8?B?NElWOE1MbWc1WkRJNVpvRkhkK2wxaDQ2NXBQOVMwRWY1a0h0MGk2di93SFRQ?=
 =?utf-8?B?OVhMSk9iVzNZZ3BZL2RSdEVReDFzd3lIS2RtcDNlbG9TeWs4cS9kTEx5VDdS?=
 =?utf-8?B?cUpKNW8xbi8weDVWWmx3ZEF2L2x6aDVuVktFQkhMbUIzZHdIcU8rUFBWbWVO?=
 =?utf-8?B?Y1JINUtUNEdWMUMxYjB5SjMyOW9PVm9KQVQ5cFRsTHFZakdJWFd1QTNCMll5?=
 =?utf-8?B?SjdLdXhvMk5RbGx5R3FzMGl6TkJpSkpsYi9JWTBVY2I1ZDlGaGt2VE5uWTVF?=
 =?utf-8?B?WlI1WE94Q1pxbzZ0YzhJN0MrQWpBM1NRTTJ3Qk9MNjBiNUQ1bmViV3pzc1NI?=
 =?utf-8?B?NHMwVW1CU1JCOTh1T2N6Y3dSUE1vUy9RbWIxMmdhYVZyNTZGVG1qU0w0SFZH?=
 =?utf-8?B?M0RBY0g2UysrcytSZTlrQWJSUGZ4bHM3L3R3VXlSYTVlVVVpcjZ0Y09PTlFF?=
 =?utf-8?B?VVZrSGJoRFBjeWx6NHBKbFhsRWJFNGR1THZMUVdBV1RUdm1vTHFCS3hjdEM4?=
 =?utf-8?B?UWNNSTNBU3lYSzdocW1sVklQcjRLWm1aLzdDdkdSMWFXU1R2RWVKUFk4SmRK?=
 =?utf-8?Q?KcWxxJ9UYqU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR01MB7099.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c2tNWENieU0wSWJ3K0E4ZzBMcmhqOXU1Y3FFQWdBWUNQR2prUnNUNnY0OEZ1?=
 =?utf-8?B?SlJ4dUM0dHIwOU0vVlUrRHAwUnBPNkJDRU5KaGpjenNXWXhleURuOExlL0dY?=
 =?utf-8?B?T0RQVHdxUEdCNDIxTDdMck5xUjFPV21FNndkb21tSUdabmt1c1FlWXBsZTlI?=
 =?utf-8?B?b1JwYngyTVY2YWZLWDJOcWFIOTYvdmxjeVNzaytBNnFnTVBFR1Z1ejBKV0F4?=
 =?utf-8?B?SEx2MCtTMmJZQUt4U1lyOHlLWThjaXN2bjRGcHc4eWxJakFwcnR6bDIrVkJl?=
 =?utf-8?B?TmIyMkxZb2hTaGpMUjUrRGRRMXU1Tk1FYThoTzVBL3NySnVDcWJ4N2Mvc3lY?=
 =?utf-8?B?L3Yydmc2UHdlVDBJVENScG1wNktGdGZ3ZllzSm9PRkhSOHVtaktraS9vV1Zx?=
 =?utf-8?B?bkQwQWRsMXV0cUplSDZIRGJxNHJqSExFZ0xrdDNwY0UzeEV4ZmluN1FBTDFS?=
 =?utf-8?B?UU10YXMxRzBZOWZYcUR5V2VxY3BvWElNS1JqekxuM1dUb0VnaEN0VzNMRlpK?=
 =?utf-8?B?eUx6TVU4SlJvYVhtWVV3MURTTURVM284Q3huSVVjSERmRlR0a2xsQlFJZHYr?=
 =?utf-8?B?NCtEbSttUUMrNHR3bk5OOVBjQWZCWU13dzVqTTdWeFVvNnRyanI4K29yWWpK?=
 =?utf-8?B?TE5oRkU5UXE1WEw4RjM2Y2F3QmNOaUJZYzdRVUYwMlNPbHI2Z3N6aVRkTEZp?=
 =?utf-8?B?UHQwSHNzbFNtMUxjSmFhZlVqa1NvQnR5azZUdktySzloc1NZYWFYNEo3VitP?=
 =?utf-8?B?NGRsSHdRc1JaM2xPY1hzYTd5b0cxSjk3RlRmZWxxMW13WG04WjFkZTZWOUVJ?=
 =?utf-8?B?T1QzNGdNVVVlTHZrMHdPRWsrWFlqWUh2SDN3VStXZnczSm1EbWh3aFhJUTZX?=
 =?utf-8?B?TTZVbzVvRGVqYTV6RWtGUm52Z3dheXQ3UnFFTlM5aTVoV0tkVVk5YlcxVWlo?=
 =?utf-8?B?alA1TC8rM0owQVJiUUJxYVhXeXJlY2RIcGpXdWZSaFR3L3Vwb1daalBTUTEr?=
 =?utf-8?B?ZkZPR2I5TldiSllzZE5BRHVYb0plM1lJalhWdVAvR3MxS2UrSUJwajNOaFZm?=
 =?utf-8?B?WlZPUWhmZWRVZTd1NGhlSThaN2llZm1LS3dPQStzTnhNLzlxYzk2ZmZhemV1?=
 =?utf-8?B?NFhybXgwcXlDU0RMbExscXJ6NFhLSGw1S0dGS1BHNkhtSmtPK3B3S3AvN3BC?=
 =?utf-8?B?M0k4YmpTUWx2bFozQ3A5WjRwMlVaMk1ST0h4QzFheTJkSnJ5MmsrQVA1SFQy?=
 =?utf-8?B?ZVNQWWY4MXRWTXRQekMvWUE0UTJEN24ySEUvcU5ZWVJzYlNKd0R0WUpvYTJB?=
 =?utf-8?B?VjlQUDJoZEo5ckZaOXE2WG5jOFVJcWczMGJ6S1ArMmg3VDlvTE5vQ1ZNTGJs?=
 =?utf-8?B?dFJyUUNsNFQyUlVHcEdSejZrWi9JVmNFTnNic0NGY1kzNTRjcysvU0NKUGRh?=
 =?utf-8?B?cDZKZjlJTlZrZk9YdVBEdUV2c0VtTkJyYjZBT3Q1S2tpblUwRVZwRHM5TURI?=
 =?utf-8?B?Y20vYjFybzUyQVFaam50N1JmZzNnUk5xWmc1d0hMSlFoRm5yQ0k3bmd2eWRy?=
 =?utf-8?B?Rzh5b0FFQldKcWVWbDQxd2d6YTR4bmxNaitIL2tDT0dIL0pRdWdaMDFtTys5?=
 =?utf-8?B?YmhDeXRtZ05yWFMxalkzVjBhNW9tRUZ5TWdWWnZhekpFTnN1OE1vVEJ4ZU1F?=
 =?utf-8?B?d2tRU2JqVllJREdyMFRSSGh1dTdGZXJKaEVqRFdzbzlqRnpIRHVzMkJFM1ZR?=
 =?utf-8?B?blBLUmpBbWhEMUlCYm9BcFM3QkRDd0EyYTBTS2R5bXUwS2ljV1N3alg4MVdv?=
 =?utf-8?B?K1U1WUx5WEgrTWdYQ3RXWDRnb3RDWUlGU3BHeW44OXltd2pjRW1XWVdPMXlw?=
 =?utf-8?B?bGRmU3lscVZZb0k3MTZXL1pOYlo2Ty9JUXJrdTVyb2d4UnlrS25FeDZsS2Za?=
 =?utf-8?B?RkJoM1p4VEMzYU0rRCtsTExpL2pSTUJaZ3RIVDB2YWpSTWdLdWJyN0dDZExJ?=
 =?utf-8?B?bWdFeGExQXNoOXRyUThwZFdHTWVNSVRvUDl0WURwVEI5Uk83SGdhOEliclVx?=
 =?utf-8?B?Y2pZcjNhN2huanlEbHlXQWp3cEZ2ZDV1ekFMR3VQaFA0WVZlcGQxTzRoMmNk?=
 =?utf-8?Q?oYK8=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c8e4a0b-b744-4dcd-ff9f-08ddb408be73
X-MS-Exchange-CrossTenant-AuthSource: BL3PR01MB7099.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 16:53:00.6375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cfz6sbDKz8Ors7j747JZYYnICvMd+8cOQIEnGEuC7WZpMYHP1HAIQn1S3yesY/L6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR01MB9234

LGTM

Reviewed-by: Tom Talpey <tom@talpey.com>


It appears that the "type 2 code 2" terminate packet the client is
receiving is actually incorrect, it should be a "type 2 code 5" to
properly indicate the length error. The siw maintainer suggests I
send a patch, which I'll do.

Metze - the samba.org server is rejecting me as a spammer based on
some sort of IP address blacklist. I don't have any way to fix that,
so I'm sorry if you only see my replies on the list.

Tom.

On 6/25/2025 12:17 PM, Steve French wrote:
> Added to cifs-2.6.git for-next and updated with rb and tested-by from
> David and tested-by from Meetakshi
> 
> On Wed, Jun 25, 2025 at 4:03 AM David Howells <dhowells@redhat.com> wrote:
>>
>> Stefan Metzmacher <metze@samba.org> wrote:
>>
>>> We should not send smbdirect_data_transfer messages larger than
>>> the negotiated max_send_size, typically 1364 bytes, which means
>>> 24 bytes of the smbdirect_data_transfer header + 1340 payload bytes.
>>>
>>> This happened when doing an SMB2 write with more than 1340 bytes
>>> (which is done inline as it's below rdma_readwrite_threshold).
>>>
>>> It means the peer resets the connection.
>>>
>>> When testing between cifs.ko and ksmbd.ko something like this
>>> is logged:
>>>
>>> client:
>>>
>>>      CIFS: VFS: RDMA transport re-established
>>>      siw: got TERMINATE. layer 1, type 2, code 2
>>>      siw: got TERMINATE. layer 1, type 2, code 2
>>>      siw: got TERMINATE. layer 1, type 2, code 2
>>>      siw: got TERMINATE. layer 1, type 2, code 2
>>>      siw: got TERMINATE. layer 1, type 2, code 2
>>>      siw: got TERMINATE. layer 1, type 2, code 2
>>>      siw: got TERMINATE. layer 1, type 2, code 2
>>>      siw: got TERMINATE. layer 1, type 2, code 2
>>>      siw: got TERMINATE. layer 1, type 2, code 2
>>>      CIFS: VFS: \\carina Send error in SessSetup = -11
>>>      smb2_reconnect: 12 callbacks suppressed
>>>      CIFS: VFS: reconnect tcon failed rc = -11
>>>      CIFS: VFS: reconnect tcon failed rc = -11
>>>      CIFS: VFS: reconnect tcon failed rc = -11
>>>      CIFS: VFS: SMB: Zero rsize calculated, using minimum value 65536
>>>
>>> and:
>>>
>>>      CIFS: VFS: RDMA transport re-established
>>>      siw: got TERMINATE. layer 1, type 2, code 2
>>>      CIFS: VFS: smbd_recv:1894 disconnected
>>>      siw: got TERMINATE. layer 1, type 2, code 2
>>>
>>> The ksmbd dmesg is showing things like:
>>>
>>>      smb_direct: Recv error. status='local length error (1)' opcode=128
>>>      smb_direct: disconnected
>>>      smb_direct: Recv error. status='local length error (1)' opcode=128
>>>      ksmbd: smb_direct: disconnected
>>>      ksmbd: sock_read failed: -107
>>>
>>> As smbd_post_send_iter() limits the transmitted number of bytes
>>> we need loop over it in order to transmit the whole iter.
>>>
>>> Cc: Steve French <sfrench@samba.org>
>>> Cc: David Howells <dhowells@redhat.com>
>>> Cc: Tom Talpey <tom@talpey.com>
>>> Cc: linux-cifs@vger.kernel.org
>>> Cc: <stable+noautosel@kernel.org> # sp->max_send_size should be info->max_send_size in backports
>>> Fixes: 3d78fe73fa12 ("cifs: Build the RDMA SGE list directly from an iterator")
>>> Signed-off-by: Stefan Metzmacher <metze@samba.org>
>>
>> Reviewed-by: David Howells <dhowells@redhat.com>
>> Tested-by: David Howells <dhowells@redhat.com>
>>
>>
> 
> 

