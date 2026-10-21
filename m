Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.122
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792596728;
	b=VuF7d9Wieg7Z4D37bPw5W9V0eiW+cmuJIehkrnM6j9+IJVPKjPKI/OjgE7K7uYVUiqJC
	 dyYRcwltvbQn98A5RQvDhcVG/M3BLzKZalkzQwuIFfn7tVjc7tv0OIkF2Jm2H5UVdk9GA
	 i5w/2sHba8wCqUFc8PrCQoqIMeHHMYdeWWhMBgqQrctsXgLB5COQi6jkMnSK9JCgzJMVZ
	 mVUX9Q1MAxMUufMtXTgkJMdt/WL1tcOa+bd/M38GsWsoeSc9DpAzHknI3US5UhHDEqQXX
	 O2dZ/qU25UbaXoecvta6+fjrYyCIAh82rjpoNC2it0DHx/76LetKs3BtlAu9GXb4+tg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792596728;
	h=DMARC-Filter:Received:Received:Message-ID:Date:User-Agent:Subject:To:
	 Cc:References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=VY4/2EbML0oS/EYkPdnDhgkVZ8qPwL57pJ2Mlk3u4bQ=;
	b=1tyqfsWqnTwF7W8pdtiebau2srRy84VwLZMn3gs/JPZl0bC005m/dY/F/pVqb8YIrfQ6
	 KgeJISeUnWQb7T64tYTFOwng5Hd1j1SS5mHF2bFi4/VF183opHAA+eKlBS9pfeGSTWvb1
	 0CyTNCwNlYqMh2X+Swa5ExMqN3BvvnXen+NKFBoUKONRmSBMCgZuz5AMu3aDCuTKViPUe
	 gGq6IoShRSLMHX8eRyEHwyhwuGpq9ZDkXC7832EF5PDVmYd7uhH6Ft4mJH1HiY0nQj3i6
	 bGqrAvwptyqu4jHCz/vTM1X5g8TXkwtu8fAkcc/tt3MymvV7puxfmHOSvC8D1tG2WDQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=talpey.com;
	spf=pass smtp.mailfrom=talpey.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.209.122
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11022122.outbound.protection.outlook.com [40.107.209.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BC6606A31E;
	Wed, 21 Oct 2026 15:32:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45BC6606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SdWFnYKjQqCnIMUexgOkmPDrMBrj8yw/U1M0tZayqVl8g6K8N089WurRgs+3ry7de2KPlQeMKIbT5yOvolQv9YqOCa5T8oejCh8QFRpR12wKw/cKIAkWrrbcCGVl99m0DSES/+q3WFYgDZllJe728lA0j8Tq5b1c3fccXDSlhQVBbuMkGYKPh+WF9mtNdnIr+jDksaLNJMNvXU0OPs7uwSCzVx9p0nMHxadUk09rH81X6Cf4ChPvZMBatFd8FuYsRnE98IS472vjnTlp7pQhSTzgRI52U9+iHs1xXyo67WzFcE/axG85miFR30/tc1iNK6qzJdzbT9zdmoZdnHuHVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VY4/2EbML0oS/EYkPdnDhgkVZ8qPwL57pJ2Mlk3u4bQ=;
 b=JIBoF1OMY+pE1m8HmIjwEbAsWami/qH+vmThhnnH/OkZHWZ56QkLv8ZXKpeOQFzTGe4rbcRL9B35io5vqPo85niJJMs3DeQffg90qPh/raaMFk5hvXHhPo4KEajXMODJfeMCNUkGYlbkBK4MqgFpzOwNzw62Y5fGcLQnB7N2NbTpBaXZomNRs1EONSTdtnfygRQ8Nyi8w990JYkICkgM1pKbiKSH8s1dcuhGPq11CW/NVYSs+7gZgL8j0sy1CAQcdXdBc/pY84DFF9IJNdjB3wbGltUBhOYiDMQfFnKD+JRfput9jz2a4WJcwnK9hqMPUvBycs8q0A5/tFEYjvr6Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from PH0PR01MB6344.prod.exchangelabs.com (2603:10b6:510:18::16) by
 LV2PR01MB459893.prod.exchangelabs.com (2603:10b6:408:3a8::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.2; Wed, 21 Oct 2026 15:32:04 +0000
Received: from PH0PR01MB6344.prod.exchangelabs.com
 ([fe80::eddb:aaf5:fd79:2b08]) by PH0PR01MB6344.prod.exchangelabs.com
 ([fe80::eddb:aaf5:fd79:2b08%6]) with mapi id 15.21.0569.000; Wed, 21 Oct 2026
 15:32:03 +0000
Message-ID: <655e5d4f-7890-4956-88d2-cb571be218d6@talpey.com>
Date: Wed, 21 Oct 2026 11:31:53 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] smb/client(cifs): prepare for locking changes.
To: Christian Brauner <brauner@kernel.org>, NeilBrown <neil@brown.name>
Cc: Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>,
 Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260928012812.2890035-1-neilb@ownmail.net>
 <20261021-sodbrennen-ausdruck-kurven-72d0b7cc7db9@brauner>
From: Tom Talpey <tom@talpey.com>
Content-Language: en-US
In-Reply-To: <20261021-sodbrennen-ausdruck-kurven-72d0b7cc7db9@brauner>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR0101CA0155.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::28) To PH0PR01MB6344.prod.exchangelabs.com
 (2603:10b6:510:18::16)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR01MB6344:EE_|LV2PR01MB459893:EE_
X-MS-Office365-Filtering-Correlation-Id: 59189865-6f73-4edd-de4c-08df2f887525
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|18002099003|22082099003|10067099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info:
	qdiZDXQNfLgu35slC9MSmzTLY84fMM+47eYmatE2ZCKtodGOgSgCOVYrtt+B0OHl6AYgt+L7u/m5EnyJzXVzcPP2xXTLEJF7z1tZVafqnzQqntmk1PJsu3kO588F8WNgKcBpy4rvo2w5FPB5kVe+KpB1tJwY7LawHoK/O0KpOF93OZ917jrSa2kTAYGoY59DbzAiy7T6/hL8SgE3s1F/VapNU7QFsz5l8aayvjLXtS3dZ9PVbjVVAJtOzHv8sl9szygI9hPzRJ7C6H+ezgDoXJJFbAF3lNOMedNPKUUgvuCp1wTrMF8nggBQIfkMxaTNwZWs6h1Y9ZpB0cGdmiha1+2XbDssVud13lHn8p+eTo5cOhS5jiNgbZIqI/oyF8spXm75ag4ziSos7LYXjPlbMqDS5KkTas1wLrCIX4qLsKmRyBJcGSuwAobwIw9Q53IXpsmGTlKBlaFyzuk3G6UQHrOkiuerLcym/H6Es0SXq8J7JDWtjwbUHswmI/tkUfpyMAf5N9MGvr3xktA1kOf6IW5sFS1dPp02FcUWDCAmUnG0Ipc8PuywAsYcori+HCzFIc6Satn1UTJjE8I3W7PtcZ54/KZ5NCv3wYNL/mb+v1OLJUoMCahfAWVya/wA3eVhEIfA2lmkDFFzvXLsAUPQwaiuLzaNEgrqm4SG05sn51E=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR01MB6344.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(18002099003)(22082099003)(10067099003)(4143699003)(56012099006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K0lIWTA4RlFXWEkvQjBPbVd4N2VGTDFTdlZDRDlqRTFraDhBUmpwQlFRNVNo?=
 =?utf-8?B?S29ZVk92V04wREJxYmtpOC9vQWVMK0lPUXhJTzdXQzI1MXIxZy9yMEVUWWpX?=
 =?utf-8?B?NlVHV1VRRFFvMkR6MEtxQnQwUnlDSWNrRUVFTkVzREM4NW5lS3hQNFM5UlJ0?=
 =?utf-8?B?d1NBTmd4V3Qxb29MNCsxaW40OTBrcmI5VzVYdFJJUWtXY0Q3ZitLOFAzRXJC?=
 =?utf-8?B?azJuUEZiZUxLc3MvaVo3Y0lSdFRBOVd0eExWd3hYb2E3QndUYkgrS1ZtZ0Zj?=
 =?utf-8?B?Q0VlTit6b0ZKSTZmZzhYVHRlUHlVZGR1NzJ4c25VMWQ5YTdicmthYzRybEJD?=
 =?utf-8?B?WU1Sd2d0RHlPRzBCRWxRRGRlRThjd2JLZTNDMUJGLzZBVGJEbDRXVjNuWEtK?=
 =?utf-8?B?dzRUSTJWcUdMcUd4TDc1TUliLytCeCtoVDNzVXMwME1mamU0NWliMkRPbmlU?=
 =?utf-8?B?Sis4QVNMeUY5T2ExVU1SbnhLYUtMbW5sdW43a0E5VGVybEN3RGkzSlpnQjhC?=
 =?utf-8?B?MC9QUTF1Y1dEbWYwQVZKS05MWURBZDlvNWRaMjZFT2tLZE9YemhaOWlaSVJi?=
 =?utf-8?B?cnI5T0M0TzU4ZndpZ2tEbEFCVW5jY3RhbERmdmg4Yy9YUHg1ckNXQ012bWFz?=
 =?utf-8?B?bVhxd0xUV1UrcWhXRDFhd1NLTU9BZFdZRG4rS1JwVURHN3N1enhrVW44aC80?=
 =?utf-8?B?aVlpSjRrek5JeUlhN1NCZlFJdThhTkpNbCs3QmxrQ0kxem1oQ2lmTk5tcjF2?=
 =?utf-8?B?T2VKZnVreEhMMnA0cnoxTXprdmF3NTVkVGhlbFNoK3M5cHQ2NVoxNElYZWxK?=
 =?utf-8?B?a1RjUW83aFh4bCsvVWIrS1BFZmRjTmdaa0QybWtGaHFJR1RNNENQSlNmQW5E?=
 =?utf-8?B?cmthZ3ZTa2V2dHIwekhIaUJ1SnppSTQwbzg4UjZWU25pamtyTTVzQ3hZaG5z?=
 =?utf-8?B?RzFCNHNHbm5PZktlWEFSV0xnQ2RGaUNtZjhWOGZJK0p2N0tETkVYNWZuNnJB?=
 =?utf-8?B?SGFrbzdqMVRsbWlqSFVRdS9zWjVxSE1ldDNKQjF1ZXNSSjVJMVdqeVk4aUZw?=
 =?utf-8?B?WktxaUw1ZFl5SDk2cHZGU1Z2MEVqU0YvQXBDUDBCSUd3dHUrMlFUNXBCTDZa?=
 =?utf-8?B?clRlV0JtNzJ0RUl6eEt0bHo1VkNIanpqYzExS0FoL3hTL0Z4a3VZczNtYmha?=
 =?utf-8?B?bGpISCt0ckRXTXJpRDZvUFVOWEVaQ284Y0FJRXhHQXZHbHZWTlhaL2pTRkg0?=
 =?utf-8?B?R3lJZFpqQlQyZVZ1WmpWVmQzaUJvc1l1LzdiMW9lWUxUcEVnejhXZE9SdFVU?=
 =?utf-8?B?akNza0lncGxGdjFEbDN4dDlrbjdZb1huN2llM1AwWjVBN1dFc0wzeTJrSUhO?=
 =?utf-8?B?Vkxad1JqOHNhRytzeTdpRy9iZ2NxUkdjVHlEc2xYUTdwUlloUkJNeWFCVlkz?=
 =?utf-8?B?NEk2dXIyVVBtaG1EeHlEU0R0dGpJZmQvTG55eWdNSXNoZVlOZVZHeXlYbm5i?=
 =?utf-8?B?cUl1L3JJTnhiOUpFVzRMWkk5bm1Xc3Fyc0dsOFNqYXNqYjFzeFVPSXFtcnly?=
 =?utf-8?B?RHVkMkQyWFdBd0NCVUtiTmhmWjZCRjg4NVhsK1hDdElIS2Z0V1VTK3BZVjFu?=
 =?utf-8?B?T2FTTlVGTmNLTmZmbi9aUkdLYk85QWRNRzJ6eEhqWUFtUjh2RjNWQ2YxcTFF?=
 =?utf-8?B?SkRRbktoS1hqSGhQcjVqM0MxOG1DY3FkMm5kc3AxOFRIL3hLVVFIeDlYaEgr?=
 =?utf-8?B?TGx1bnRMZzlSeksrcTc0Nll3cmhTdzg3eXNyOVFxVUNUU1ViSDYyR0lzdUNk?=
 =?utf-8?B?Tmlwa2V4cmkxanlVZmVkdDVIQTJJaFZHendzRDRrbUkrQnJCOFBHWnBNZ3lj?=
 =?utf-8?B?bXJnMUcxSENuTFVMQnNWNXhyWnhyYzJhTzN3bEtMSHZtaUN4MGFjRXJuVi9v?=
 =?utf-8?B?ZXowKzJJTWNqcnA1N1R1Sjg2NDUvV3BsaFpYVjVwZnV6Wmtsa1hLdmZsMlBZ?=
 =?utf-8?B?VmFQVXI3S3dITEQ0NmxlUG9ZdVBkbjlSY0N0VlRnMkhzbUJyUW8zYWY3dFBO?=
 =?utf-8?B?Z2NNaENkdjY2aFdKckQ3N2h1M283bm5saXpSU29vYjN1NFhsVUNacnd6by9u?=
 =?utf-8?B?dXVBU0I3WHh3Rnl2U3F5eVJYM2s3OW55VGlNcjdNK2pOOTBsd1VsakJHZnps?=
 =?utf-8?B?NFBmaHFFY3JNSE4yZ0VhVnlRUkJTMFlnMVUyc2dFZzhMVytMOEhRV2xFaUVi?=
 =?utf-8?B?Rmc3L25rYko5NXB3T1pBd20zelBTYi9hbUs4cGFSUDBMVTMzalA1UTYycFJ1?=
 =?utf-8?Q?RKaO/0vktMwuR6DcaC?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59189865-6f73-4edd-de4c-08df2f887525
X-MS-Exchange-CrossTenant-AuthSource: PH0PR01MB6344.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 15:32:03.9226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ij/rQVrBrp2Q3FyAxf71nXRPspQafAIS+sqy6zfUFOiOqqBLAoxI3WfgGCRI0hiA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB459893

On 10/21/2026 5:55 AM, Christian Brauner wrote:
> On Mon, Sep 28, 2026 at 11:25:01AM +1000, NeilBrown wrote:
>> I am working on changes to directory locking.  The medium term goal is
>> to lift d_alloc_parallel() locking above i_rwsem, so d_alloc_paralle()
>> can be run unlocked, and consequently cannot be called when ->i_rwsem is
>> held.
>>
>> The requires:
>>   1/ that d_alloc_parallel() not be called while i_rwsem is held.  cifs
>>      does this in a couple of places.  A new interface d_alloc_trylock()
>>      is now available and can be used instead.
>>
>>   2/ a dentry must not be d_drop()ed while an operation is ongoing, as an
>>      unlocked d_alloc_parallel() would then be able to create a new
>>      dentry with the same name.  In particular d_rehash() must be phased
>>      out as it won't be safe.  This particularly affects the mechanism to
>>      block lookups/revalidates while an unlink/rename is happening.  The
>>      mechanism is changed to use one similar to how NFS addresses this
>>      needed, though using the new LOOKUP_PRIVATE flag.
>>
>> The patches depend on patches recently added to the vfs tree.  I would
>> prefer these land in that tree too with an Acked-by or similar from cifs
>> maintainers.
> 
> Can do, will need an Ack.
I will defer to Paulo for the Ack, but for the series, modulo my nit
on DCACHE_BLOCKED:

Reviewed-by: Tom Talpey <tom@talpey.com>
