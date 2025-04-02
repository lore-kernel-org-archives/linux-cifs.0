Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2136.outbound.protection.outlook.com [40.107.243.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECEA719006B
	for <linux-cifs@vger.kernel.org>; Wed,  2 Apr 2025 18:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.136
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743617110; cv=fail; b=V6SQmqMlydX8rqVQ0uFUlxeHxl/sRP+iZTEpKwkSjF7jvdOTxvjV6mdc/MzdyWTHi+hzFgVgqwx8GgUQuJmA/C1qrcU6iee77Q6AWOH1XYI6QDrWbeK35+aNr+HDMWiHwvghOHqtchFFB4wvlYBJzwlUagLHfLJPifMKwMWNHzc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743617110; c=relaxed/simple;
	bh=qYDQ5dW38m4r/xX81zM02QAN8Kr/jB6ehMcp8/Q1bG0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AuVRY6NlaJ/7Rgv0vPFANlpMI4MkmWWAyhPFPDqeR4TvtISSO3WQGU7yt3ev9QavWJvg09QW/5droc1OZjf1Dc/nPmeXiJL/YVqAfte2J3Cvrw1hON2zL5vs1gp6LqlRw/ysn8ulVSAIlfqDj579kaPK8Q4ekg9ac35LPHAEo1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.243.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iv4HsFJHgdcg2KFmgkavy69l2V5u9Q1NgT17TPFOv1pqhqtTN195zWKK1EavSZQ7QNmaO6kAqCqU+fDPgFA69/V0kF6i7yt+yHWqRtKF4oN1Wj71qqxpAZPlgR5FCk+zKGAOrgNjcNuhTVUgSlop9Z8EJhRyT95SLMULdcUaXDrrE7S6OHiBkqwdb/51jCw7JSMxHwEXkaFnwurmF265utErHfR6v7YmtjSzvypWkFLTtArKLpMBQSczeoO9G0Rlc0ycg2x/HCD5cQNZ4//fvNkWcigIfA0gJyHNK4vQxy+ddZBXOgq5jNwEicmQW/jCUjPcC5qQkc7glD8Y2OusJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=44zwrrRKygczuNOjD59rFFYe9oePslUF7uzOR9hJpZE=;
 b=fgKgXKBVatcCyEanoHBbpHD9FQBQWhPI6blnXtNGVGiu0F2Al8qrYtZpTGTHnVQP++whKaLxpXdOWGMOVvc71QLBc2KlGpb7g0ABpO7FJ1gtFJsOXfGfJ8HrcAwCKz7KkAghud9+kN+xzXKJhe78ZUnJ59ZzAZ5Buuo9AQ67WezBDTuu4SD0sP0mcCdOeqyYNIhqTtE1d+oOVdev3INEp8nVYee3vCMLAxTvZ/qwTXrwTwbxFFmrtPrdCbjJ4zEiEXs0oiQTGe/MeCTBY7M/77ThYeMXJPrpRxtrulf5WHbo5a7Po0E2VG4I9ZBjFyHDBtDIQFzyeVOBdABFSapPFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB3854.prod.exchangelabs.com (2603:10b6:805:19::20) by
 CH3PR01MB8489.prod.exchangelabs.com (2603:10b6:610:1a3::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.49; Wed, 2 Apr 2025 18:05:02 +0000
Received: from SN6PR01MB3854.prod.exchangelabs.com
 ([fe80::66af:6788:adc5:f856]) by SN6PR01MB3854.prod.exchangelabs.com
 ([fe80::66af:6788:adc5:f856%5]) with mapi id 15.20.8534.052; Wed, 2 Apr 2025
 18:04:55 +0000
Message-ID: <b8dbed47-8824-4b3a-b373-061e139ee7a4@talpey.com>
Date: Wed, 2 Apr 2025 14:04:57 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: cifs RDMA restrictions
To: Steve French <smfrench@gmail.com>, David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>, Stefan Metzmacher <metze@samba.org>,
 Paulo Alcantara <pc@manguebit.com>, Matthew Wilcox <willy@infradead.org>,
 CIFS <linux-cifs@vger.kernel.org>
References: <78c910b0-3391-484e-aa44-42e2f9ff4637@talpey.com>
 <563557.1743526559@warthog.procyon.org.uk>
 <659109.1743536087@warthog.procyon.org.uk>
 <7e1fc71c-2821-4294-833c-746c5fd7ee69@talpey.com>
 <803441.1743613785@warthog.procyon.org.uk>
 <CAH2r5ms2J06tJr4VEVDgmcj_1uqOnhYzbC1ybrMWDm=f8wVDoA@mail.gmail.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5ms2J06tJr4VEVDgmcj_1uqOnhYzbC1ybrMWDm=f8wVDoA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR16CA0066.namprd16.prod.outlook.com
 (2603:10b6:208:234::35) To SN6PR01MB3854.prod.exchangelabs.com
 (2603:10b6:805:19::20)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB3854:EE_|CH3PR01MB8489:EE_
X-MS-Office365-Filtering-Correlation-Id: 54e5c9c5-d4f6-4e67-5a82-08dd7210dfac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Mmd4WWdyZ2VnMnZKeElrR3pwVDRzYmxkS2xTd1FKT2MyTGFXTU02ZWp1VEtk?=
 =?utf-8?B?dDFUMmdwa0RyMkZQeUpEOVQ1SUs1dTJwcEdnSGNwQmtGdXFOQWs1NHpxVWJM?=
 =?utf-8?B?QnROSlVHL1hlZDlSRGZQUmZtS3lYZllubUdJTElvaXY5UXNoNkNnNldFb0Ra?=
 =?utf-8?B?dU9NYmxBMkFEVXlGQ001WmRNNElET2ZmUVpEZDY1L0RzcGgvRDlWUWZsVFhh?=
 =?utf-8?B?Q2JrRTRIN2NOVFRWYUVOUm1vS3AzZXZWWjRXVDkxTnR4MU9ablF1cmxVVjZC?=
 =?utf-8?B?Mk9URVczNndyUzdlUDFJcFM0VThRRGl2VVZHZ0dKMXoyWmFjN0dpck5oQ1ZX?=
 =?utf-8?B?V1RMVkt2VjlGWEw1d1RJNzRhYW4yOUZzM2IyRVdoN0grQTBDZ296SzVSRUdY?=
 =?utf-8?B?eENTSWZlSDFXelowb0tidmhtZVFmcUI1ZzM4a3pnZnBXK0drQlpENUQ0aXZr?=
 =?utf-8?B?ZkRMQVN3cHZTQW5OWDhlMWhuazdlR21obWZCNDJTRTVMUXcyQTdaUXBoK0xx?=
 =?utf-8?B?THFXYnV4UzRxMEVPR01vdVNvL1I4NTdPZjR1djNvVEQzMFVNdXljU2w5Ui9P?=
 =?utf-8?B?WW84MzZrTklaTDV0eXAycnZIa0U0dTFhbmZkdDg3SHJLYUR6aHZ1a0xHQU9T?=
 =?utf-8?B?VmlaMFNzNzhJQXRlK2hvaFVROWVKWmxvQjFJSys3d3UvVlMwWlZKY0lPS29X?=
 =?utf-8?B?YXA0YTlBUnVGUWUyL0p3ODN1ZVMwcXpnZUE0MjBKcFRZS1k2dnIxVmxaSnAx?=
 =?utf-8?B?bjdJSTFwTndzamxIcVFudmdnYVUvZ0hEQlloeFNEMXRNeEVJaHJSeFhpY2lj?=
 =?utf-8?B?RmNMM2t0Z1dYRThVVUdPK3RiVlgxMzFmN1JXc0w2K1ZLZmxxQkFNVGxPemNI?=
 =?utf-8?B?YkYrRzJmS0FQQlF6VnVseVpiSWhiYWgvQnl2KzBrQ0hLc0tpbHlCVjFRbHZk?=
 =?utf-8?B?YWRzdndmakhRUmpjUUFjdi8zZEk1MktmMUdsOGd0bTNmL1JjVUJMOE9qbnd3?=
 =?utf-8?B?WnUxKzM2T1l6T2Vmc2lMS3Y1SFhOZllHa1o4aUdwWWJ2TGdvRnpLUy9oSjhy?=
 =?utf-8?B?ZlVqbnZjMmVRNkdXYTFKY1JBdHRIdFNaMnljMExMQlc4VWNtcERTcDltOTFS?=
 =?utf-8?B?Zy9pOXVMa0NSdnJIdWVxaUVOVU83OWVYbXFaQVk0RDdtQy9YNVp2VDBha3pi?=
 =?utf-8?B?Ly82blZHTS9zczg4V0FKQ1k2aDJ2V1kxbTZPalE5YzB2MjdnVnlWREl1Z1pW?=
 =?utf-8?B?c285MUFidXJNTEkvQ21qY2p4clFGZnBxQ0FTWFJ6YVVPTFVqdUJMMGlUODFC?=
 =?utf-8?B?TXBjV0U2aTRLZHRZVjV2RGR2VHVGYmx3Qy9lVzlRWjZZY1lOVUZuai9nQnB5?=
 =?utf-8?B?OElSMHFkY055TFEwMi95L0RJcll1WGpZYStabGVQWjRPVFpzdk1RNU9mZUpo?=
 =?utf-8?B?djRQZWRDQjVVMytLNEErT2NyYjNYZjAxeHhTNCs3ajBrU0hzSWcrN0Vpam4v?=
 =?utf-8?B?aUhSZXFoSUZTY25nQlBBL1hsSHNqZjdGZWJ6UmpXTWQ0L080d084azFOczJN?=
 =?utf-8?B?SDMzVW10NG5WK1JyQjhvR0RLaGlQOFpZS3psYTNDQjk3T2xXSmJ2SEZmTHBX?=
 =?utf-8?B?Ry9IL1J2aENVYkdiWnpXNW9aZlI5WmVSNmM0Rk5EeE9xZ1ZDWWRySWxPUnZU?=
 =?utf-8?B?d3ZEQ2NpK21jUC91anVYUGE4K3FUeG45c1VlNDFFYVArOXVGRUR5WkMxdFJN?=
 =?utf-8?B?Zi94WCtwcmpkUWZzZUtBZ3QvOG0wd3VlZkRoc0drQXY3R3VyMXpkNTU1YlZF?=
 =?utf-8?B?WG5uOE1QQ3BiSHUrM3ZNenBlL0JpdG1ZOVpsQ09VUUlVcFlWZS9sZGh6V01u?=
 =?utf-8?Q?SHAFTXevXD/np?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB3854.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MUNYWkIvQTAwM0tuVmVuQ29Fb0JLWDRqL3dBWE05ZnBabHNDUHZrTU1tdGlv?=
 =?utf-8?B?MmttZmVnVzBIblFzWWM4Z2d2Qmd2eHJwcFVvVWtpR0FKb3ladno2REhTT2E2?=
 =?utf-8?B?VThoRHd1WFVUYVhzMnZnZDhZOU5BUVY5N0pRTHgwZDJyZElRcFFlSElsaGNC?=
 =?utf-8?B?ME1QNkhJUW9PaHFxNjFwYldNbUdDM2MzTjNjOVNmV3d6S0RRYTVBZldrRVh3?=
 =?utf-8?B?V3N2eEtES3h3N1FVYnEyRi9SZ0VTd0xicDJJaXBML2ZqemtZbURxbEcreSsx?=
 =?utf-8?B?MDhJMEVFTFNjR3hteWVBM2hxenRHQ0N2V0RTQmpuaXNlcXRrdW8zZEIrU2l0?=
 =?utf-8?B?RC8zNUVzM3lWVGUyWGI0bkNTYmYvb1BGY05WaDR4QUFLSmxucFFOeDVjbEtQ?=
 =?utf-8?B?WDJ1UWJEYTBUb3RjZGtXNXk4SERYalQ0dU15bzI5NEJHZmEzd0k3WCt1MTIy?=
 =?utf-8?B?RkxoL2RXY0VHck4yaVlEaGl6OCtVQlZ3NmJlZlM4YUFMT0VZQnZPYVR3Y3NM?=
 =?utf-8?B?TFpXcmoxWVR3cXRQWE5MRERoMENXYzNVbmtsbUdrMWZmWFNSdnQySHpuTFpm?=
 =?utf-8?B?NTlKbU5LTHJKOEErS29RT21teVVXQ256NEJCY3FEYkY4OTY2akdHM3dwbkt5?=
 =?utf-8?B?akMwcXFvYkZ0MUM2ZWtsUGZ2RXNmaEFiVEN3THJFWU5DcTFXd3ZHeFVBV0p6?=
 =?utf-8?B?bWhUZjcvQXZLbndTNVpMYW1LMENscU82NElMNER0NHU2WXorWkRmL1BLamFs?=
 =?utf-8?B?V3V0RDBqWUhiUTBqTWQyaGs2dUZ0SnpYalhHQkUwbldoZjJmbG9uUmhSb3hp?=
 =?utf-8?B?bkkzZExJdFRvMUZNaFUyRElqV09ROUF5MkJza2ZrejZQV3JaRURhZ3QzTTY5?=
 =?utf-8?B?OW1TYzl2RHNMOGhOY013MnM0aUVhZ2JhUFoydjBqUzhiSDRTVDVscXBZaGNX?=
 =?utf-8?B?Z0cxUTRMeUlKZTBvYnBCODdPRmdrZjJCVXdwc2VjR2NEQ1RabTg4VmpEMVdR?=
 =?utf-8?B?OVBDSEg0b1JGVDkwZVRrUzRMV0dGdEliS0FhMG1kcXRUdlcwbFd3Q3ZBTGsv?=
 =?utf-8?B?cE01UVVPTnZzRGlkMGVSZGcyQnIwZmN5Mm9nTlhEcGtnNDh6RzYvOWhZQTd6?=
 =?utf-8?B?c3ZwNjhxVzgxTTlrNEM1WnczRk1VRnFWU2N0ZFFqTDVOLzhtWEl2ZUNsK2VQ?=
 =?utf-8?B?Qit4dGphNEtiWUZFOEliVlhSMGNEbGM5U0JLV2daeENOYmZrRzl2VXE5YXI4?=
 =?utf-8?B?Y2NQQnRTTjhFRlA2dW01YjdvNUp5WHlxVGQ5MFlhZUpHeVRJTlVtMFhJTHFz?=
 =?utf-8?B?R0U0ZDNhZ1ovTzIxN3c2aEQySzBTWU8vclozMmdXSit1TUtWNXFHZmtKb1JR?=
 =?utf-8?B?cEN2WEZZS2YzMmpHdEhJM1hpWjFXUFkxc29mUEpTczN0Ylg1bThPRWhCRzhz?=
 =?utf-8?B?SWF2WTNmbVBkTHdIT1dTU0pRQkswZ1BvakF3dkljclQweExXV2VUVmhheDFr?=
 =?utf-8?B?SWNOMjFjYmV2bDNwWFpKWjRob3NBYWdnSzc4L25ybGFYOFhTMExhY0s1Q2h3?=
 =?utf-8?B?Wkx4YXhxT3RkK2doVUNBTGNOdDNrRGFFejBES1RHQ01CeHk2Nkl5cElaZ29C?=
 =?utf-8?B?TFp6OFhOVDkwZkljckN1U25jQkVKb3dKVDRvUXBtTkJVamNjMzFqNkk0K1FF?=
 =?utf-8?B?SE1rZjY2ckM0YnhKY1NQUkdGcTRxUkZqekZzQzdLd1Q3aWdpWUZLYjZvUk04?=
 =?utf-8?B?U2k4UFVpTmpCR1RLR01TNTluWStUcEs5OVNsbFBhdWt4eU4weXdrQVBoSzhU?=
 =?utf-8?B?NnNYaFNtaUdDSXhBdHoyTGswMElONDNKaEtjdENTSUhQd2ROQmlySTlBNEJV?=
 =?utf-8?B?eWl5NytVRklvaGxLNFlib25BdFFjcE1Cd3M2Mk02eS9NWTBZbWRLRGJGdXRK?=
 =?utf-8?B?RkZlVEtYVEdocFNKVGFkd1B1VlI4Tkl3QVVodGVMSFRqWmh6LzZjUVBWV2dI?=
 =?utf-8?B?K1NXT291THlvdDBKcUJGRXo3eThsQ2FGZHZtSzNhUU8rQmhsaGJZQzBKMmdz?=
 =?utf-8?B?VDI4OGVCNVQ1dndFR3RCNEd0SjNYOERPbmpyL0xOdmxZNmlWakVOenorcmVi?=
 =?utf-8?Q?ULN0=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54e5c9c5-d4f6-4e67-5a82-08dd7210dfac
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB3854.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 18:04:55.6687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2IXKtQKkOtHL4n4EE+4zFPtfTgHnEoe0QoyFJGR3JrkQ6cKQ7unCSlmAxB9Inq0/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR01MB8489

On 4/2/2025 1:13 PM, Steve French wrote:
>  > Is there a way to query the RDMA layer as to its limits?
> 
> Would the smb311 query interfaces fsctl response have enough info on the 
> adapter properties?

These are in the adapter attributes, queryable via the verbs.
The value is stored in client/smbdirect.c "max_frmr_depth", and
is initialized in smbd_ia_open() line 654-ish:

	info->max_frmr_depth = min_t(int,
		smbd_max_frmr_depth,
		info->id->device->attrs.max_fast_reg_page_list_len);

Note while it's called the "page list', it's really just the
sge list, because each element can have more-or-less arbitrary
length. Typically 16 elements is table stakes for an adapter,
many are capable of much higher, though with certain performance
trivia.

Steve, this is a local-only value and not related at all to the
query interfaces fsctl, which is returning the server's adapter
list.

Tom.


> Thanks,
> 
> Steve
> 
> On Wed, Apr 2, 2025, 12:10 PM David Howells <dhowells@redhat.com 
> <mailto:dhowells@redhat.com>> wrote:
> 
>     Tom Talpey <tom@talpey.com <mailto:tom@talpey.com>> wrote:
> 
>      > > But, will the device handle that?  And can the DMA API map a
>     single buffer
>      > > that big with the IOMMU?  And does it need aligning to a larger
>     pow-of-2
>      > > granule?
>      >
>      > Yes, maybe and no.
>      > 1 - The device just expects a base and length, so size is not an
>     issue.
>      > 2 - The IOMMU is a platform question, if it's in use and the mapping
>      >     allows, it should work.
>      > 3 - No specific alignment required.
> 
>     Is there a way to query the RDMA layer as to its limits?
> 
>     David
> 
> 

