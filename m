Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11020089.outbound.protection.outlook.com [52.101.193.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C7D238D42
	for <linux-cifs@vger.kernel.org>; Mon, 17 Feb 2025 21:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739826487; cv=fail; b=owpdc5GAl/vZ/wVtC7HwBZAZutDO1xsP1L7pTF3+AQovMTy+mZY9Xm6sWxWBMFTwufBtGmOZNeMZLN9BnJVrE8LJ2q4/dwsFnzTzxj0TSRrUu9WHaMXSlgdi3c96tycKdQN+ork88MNFspz00HMsg+ciRhY4rlaG7n88SuKAcJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739826487; c=relaxed/simple;
	bh=Kaq8NdJJh5GmsOwU+W5jjHjUkR5OON8ZWHG6bo5L2gY=;
	h=Message-ID:Date:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oJ/RPA0Mu/tKeXMHf50KsGSmj0NRt18sruSMaQ/b4tMdA/ZdrSAskxphDA6riAy1mDk4oo+YQDGiIwVLe3p68FQ/7CmJ4BVKT6IeForM2DRWpdyJzeSYJpnLtt1dtfS4Gd3AWnOeuOuC4xs83DBS7FbtZAOijIRBXgBVdv2UgmM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=52.101.193.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z7iSZ/uZ1QGC9bTNixGDZGBxTYvwGE5xwuepclAu8HoB2gZQsy7npI53iePvY+DCXfObEb4P/Ox/eM3C8CMv7SNVejF4WA6I835d4AqydVQRzJ0r7Ae/x2RiSZK2/xOxrmUDE8+T6wTRU5HB9S+ZaZ5r24pfGqX1TbYl7XOlOSH9oIbJTVM2kWDjA22AD+hFCrSiL26uTlcnHlR3YeNG0YEpBRDlPSOqnQOBcjLVc0NDXGMUAZ0pS2o8M+rdYvZ7Inqg9bIs0gIGNXYcZ5JW839+j+TJopKb9XMnTdHudTUXJpBSJGWxo/W6BFTWxJ3d7kpB9kTOrKuB98+t0bLR7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q+RhLhgMc57+vxhHyNW2yUPW15hdNogZdxoBSKL/AxM=;
 b=VRGWXR8xGvlN7OzLJj1MiOdgZmF8celPwp1i8XBIXFx+Kyp1Ac+f2zLprh7ACmJiuVs0BvL2D3nRNv5MEwUdDzZV8TE+dRIx9dV6CidJ2/PCmbUkdMT+sVhPe7g6Iy9Uum1LJswTdXuKR22xGZf2obSWUr/n6vmF8VjNkfPSPGWjpZIa4GtLzrMz+X8Cuk7GpM8hmAFxPR3y+b/Mgzt9QTTgjCK5G/UvTOQpvGxZ4awhfCsVOmqtZgtpNnygHbc8j9jU64Uz3B4EDt+bZsBzw6usUc7yOFw4Z7+Ad287sU4ibla1nm0Nv/o/4SSWuJIrj8DjMH+BQLESkKtPicn0gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB5246.prod.exchangelabs.com (2603:10b6:805:d8::14) by
 DS7PR01MB7663.prod.exchangelabs.com (2603:10b6:8:7a::13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.5; Mon, 17 Feb 2025 21:07:57 +0000
Received: from SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90]) by SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90%7]) with mapi id 15.20.8466.009; Mon, 17 Feb 2025
 21:07:57 +0000
Message-ID: <069e1547-8006-4c7e-9f82-3c0178aa81b8@talpey.com>
Date: Mon, 17 Feb 2025 16:07:48 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: If source address specified on mount, it should force destination
 address to be same type (IPv4 vs IPv6)
To: Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@manguebit.com>,
 David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mtxd=2Qz-ABKbGJ3FeghR6jBb+P5ZsMo7E=V6UXwpXokQ@mail.gmail.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mtxd=2Qz-ABKbGJ3FeghR6jBb+P5ZsMo7E=V6UXwpXokQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:208:23a::25) To SN6PR01MB5246.prod.exchangelabs.com
 (2603:10b6:805:d8::14)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB5246:EE_|DS7PR01MB7663:EE_
X-MS-Office365-Filtering-Correlation-Id: 49c73c12-6b1c-4b4e-689f-08dd4f972700
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cC9Ca3pzZEgvTkFKT2JER0dPYVpNcFQwZmdDeEJpRnloOVZNWDlOTGhCdGF4?=
 =?utf-8?B?Z0IvZ2owb3FxOEo0dTcxVUxFOVlzSzQxcWlSandmZGU1R1FzRmdZOXFyQ1VI?=
 =?utf-8?B?S1BGbUFzMk5idjdiNnovU1BtajV2SVdobG1nUUN3MjdYYjZIUkpDdFNoM3dr?=
 =?utf-8?B?ZE90MXV2RWxXQzFvSWU1TXBuWk01N2ZLaXladG0vRWFiUUxSWmhuL1hWUE5F?=
 =?utf-8?B?emoyWXZzL1MwVWlDcXBqTXcwYnJYSmNDK0o3a0U2MnR6YmdyTmpaamxKeU1K?=
 =?utf-8?B?Ny9uZkpENFROTU9qOUhSUmk1MW1KQVluZGUycnU1TG9na0VmcFhWT1gxcDJk?=
 =?utf-8?B?anpjWkJnNGVXVXZuRmJEb1lMSmYvK2p1b2xBVDRsalg4YWMvaDZjVzZ0bnVQ?=
 =?utf-8?B?Rzd3SkdTVjAzZTlJdFpVazBJZGxQb0cxaWlNWUt4YlJZZkF5c3Q3VUJoZTRY?=
 =?utf-8?B?OExuK1BRc3BabmRaYlp0bk1kdFlIbTJvQTdtallJcE10Y2JJWDUvWHFBUCtJ?=
 =?utf-8?B?TlNJS0RNSW1WV0pIcGw3K1dKbExzTEl4eDdIUmd4UFBZdTVFakh5aE9tcktC?=
 =?utf-8?B?M0Y1ZzUzRkdrekdLLytScUhoekN5U2QzSy8vTk44QnZZOU56UEh6R0ZzYUVI?=
 =?utf-8?B?NXhxWDJJd0Zydi9EaU1rdUNwM2ZoNDJFYVJVYldSL3V5V0FheG1wOG1ieFpn?=
 =?utf-8?B?ZEl4SVUxUE5ieDhjN2FxdDRlSjFzS2IyeElxdTNlUW1lOWoyOVlGTGx5b0lq?=
 =?utf-8?B?UklBR1A3ZHhqWmRyRWFRUFNTR29CdVQzV0grTmcxYUYvbFAyZUlmQWxRRGFo?=
 =?utf-8?B?UytoQ3JqWjNKZS9DOS9QUTY1OUFXV0RxL3RyRUhRRW5OR1dEYVloZmpLbit4?=
 =?utf-8?B?cUdQRmFXL1VqbzFHYUVUaGpCQnNIdUFUcVNXK05STnVSY2duTDVlRERwNW5B?=
 =?utf-8?B?OHFuWDVCU1h4cFJvSFdFUWVReHkrUXVrOTB5S0pQakt1QnV0NmtRelRxbVNi?=
 =?utf-8?B?OFE2NUVLd3hlbHBKZ1ZSdXR5S0d4K0lMaTdoenplYVhIUXBRVkxUemVlc2gz?=
 =?utf-8?B?MGpaS3VabXpLS084ZnpQVTJBdDF1bU1FUWpibnE2Z2w3Qi9tRWJGdnA5Snl3?=
 =?utf-8?B?NHFjdjJPK1M5TTNTUTdnM0hJV04xRXVmSW11dVVYekNoaUhtaTBZRkt2dC9y?=
 =?utf-8?B?dWliSVA4c0tPM0lBZmRPYVNUQlNnY1dyeUhvUXFvK01tdEdhQTczNlEraFRR?=
 =?utf-8?B?OWwyUUdWR3VSOEh1SHVrNG8vc3pDU3FTVm84TFAwcjVRZWNoWFhOUnluNGZp?=
 =?utf-8?B?L00wczI2aHpiYW9xd0NBRnhLamJQOTJtM2ZmNjViRHZMRk5pZHVoZjczVVBu?=
 =?utf-8?B?VkwzR1BEZU5yQ2owVGUyeGMrMkJJa2pBM0t4bUh3cFpYcThKM3ZKZ2E5RmpX?=
 =?utf-8?B?YzdhVk5IZE5MYjNJM0tMTFRVVjAxSUN6ZUExdnltN3NOMkR6SWttWHcraHNN?=
 =?utf-8?B?N2JSMHhycEhVWk5hSTd6dlh6amgwWGRpR0RYazVBZnpzMlRFY0x5WStoV2ww?=
 =?utf-8?B?WTdveWlsZkRlSWIrYm8yYTRhQkxkWk8yNDI3eVVBR1IveXpjckw0RVlyRTV3?=
 =?utf-8?B?NU9RM0Y2SnBQaHZzWFZwTU9EZnZnbkplM2d5QlErSFRwdm9EUWwyNlJjbDY0?=
 =?utf-8?B?Wjk5SFJBYzMrVFh1bi81ZW9JN3dKVHZmcmwvTHFqZFVOV3loUDNOSFhjY3F3?=
 =?utf-8?B?UHQ5OERHRi9IWlg0Rjh5QzcyQTZWbHEzOVJ1a1Rpcmk5c1VjN05OYjlEazZx?=
 =?utf-8?B?aXRWT0U5bUtWc1FqNlhhdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB5246.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a2RETTVOWFR4dlZkSnRiTWk2Wk9mSkc3VkhxUG0vNlp0bTVqK2tIbHBIeEZJ?=
 =?utf-8?B?OGJJUlNvZjdqMk5ESXdFb1pPK1E0T0pLbnBmSDN5YUNQRmFobXFvajNvcEpp?=
 =?utf-8?B?dFVxYzN3Yk4vRUhtNVo4Ri81eC9tcmVSNUluZVRORWR0UitpdGI2ZkpTS2tx?=
 =?utf-8?B?ME9iK1BSc3cvV2YvVlE1TXN2a1ZwbVJUYnN1UFFrUzlON3RnR2hISERCbnZI?=
 =?utf-8?B?RTFydXBlaHlodjhjeXVibzA0QlZhVmNPMHpBVTE3WDZHZk8xZHVuRGpBV1Nw?=
 =?utf-8?B?aUZ4eDhia2Y3ME9jSU1QN2poNlFUTjlMRGxTOStqUmNDMjRCbjRBMVlrQjNa?=
 =?utf-8?B?eXMxWEpGS1M4Q1BlT25BOWlmNEovZVJFVXFVUUZFSGJiczE3em1HWEdFQzdP?=
 =?utf-8?B?UnNmdjNwQnl4cDYrRHRNMVdoT0xiazdwOThZSTgwRlVHN0tYNnpndEgyYngw?=
 =?utf-8?B?S0VJZVBJZ3kzRzdjTmh0SDJKNDVvcFRvTkdMVVVhZkN1MlBsdUIvOWlaNXRw?=
 =?utf-8?B?YkJKNXhXL3ZkanJReGk2R3RkcTFWNUlDeVZrbEMxU2lKMUNuTE1Pc21sMGFo?=
 =?utf-8?B?eU81bmRUVWNMK21aK2lORHJyNVkrN0dLcFcrdjl2aC9neWtMVFl1ckk5T3RO?=
 =?utf-8?B?SE92MUZrRlVKMSs5OEZNMDhGKzdiazZ2c2o3VEN1L1Zicy9Wd1c1eHorYlEy?=
 =?utf-8?B?ZGhLdW9kNVFjRDFtSjJrVExldTZSWGJaRGhDbkJ3TjhaSDlDTlNRaVZZZ252?=
 =?utf-8?B?OU4yUEtPeGI3RzRvY3Fjb211UEFZMFAzV1JqaXBzTHZiM2xFcEhqMmhDNkZS?=
 =?utf-8?B?T3oyWk1nWE5OYzB2QU1jMkIvRVNUTjB0cG1KWnhKZGc1aXVnZytUNFQ3WHlk?=
 =?utf-8?B?dE5ZSlo2N0Zka3grTDBQaFc2WGdQYTZobGtwYS91dXY0SFI5QjNBZEdUQ1J1?=
 =?utf-8?B?Ri8zMzhvaDByODZrRHlhaDFzS2g0d09zNUdmUTNHYmlhZmVRTGJUVlk2dzls?=
 =?utf-8?B?Q3hYSGgySGFlcVN6Y0RNYUhKTC84R2RGWU5TS01rRlRDUXB2SWV3R0cva3pi?=
 =?utf-8?B?L1kwRFZtbWNIbytQRERBS2R4clJxajJ3SDNjcHZZQUxDL1B6TmtBMklKdzFK?=
 =?utf-8?B?ci9aMFphOURSdEppMDR3Q2V2cDFlQUxQWGd5T2hBQTN4Ny9NTXNWbGhFZ1J3?=
 =?utf-8?B?RElobWRMaU1pTlhlU0kxTHdhaUI0c21Oa1VoWDdudzRHdlhGVlc0Y1lKajY0?=
 =?utf-8?B?djZNamxQR3NvajhJRmxhWERjR1RmVjBmWnlncjNHRVRabVdSVjJUbGdqQmoz?=
 =?utf-8?B?Q2ZlMlliTlJGS1BFYUtXOWlBQWdyb0Q1ZmJxRi9pdzhCNWYxcXAwbWhkQ3Ry?=
 =?utf-8?B?cmkyd0gxM29OZXZ1WHpwcExFYndrM0xZdGYrb01maWhicmV5cGtUNjN1SUtj?=
 =?utf-8?B?ekFwR1lxMFhPbVRtWjhldmN5Rnh1c3RSOXVxUkp2WUhRdUtYT1dHeW0ycmVu?=
 =?utf-8?B?UW5MVGNYWTJkaXloUHpSdnVLOTJSNnd5cmVEQXgvL3JlNXlXc1V4cC9ZWjhS?=
 =?utf-8?B?Um9LbjgwUG9LOEk5UERUTHNQRGFCNyttQTVOeUxWbVpyL2hIbS90ZVc4SzRo?=
 =?utf-8?B?OW1UL1ZuajZ4cERRSUJCTTBQbGkxdEVyNTRJVjNHNkF5RmhkMEJoYll6UlFx?=
 =?utf-8?B?U0lMTElFVVNQRWJSL29keTZQcHAxL0VwWm1TVXFvWDdEQkZxdytMOHEvK3du?=
 =?utf-8?B?dGUzbjhVb2dZM3VxcXZuZVhkNGZoSXJoNm9hd0owdWl2YWVPeFNnaFgrMWt3?=
 =?utf-8?B?RTNKWTJvbnRtQUFrTk1ERFNSd0IrL1NzUEt3QWZvaUlsalBCck5xUG00Y2Er?=
 =?utf-8?B?UXJNWFlWcGU0cmMwZEdCYUNYRHVMcDh4NnYyZkZtNU9EQzdzOGVPbStFeGFs?=
 =?utf-8?B?dkJyZkZZWjlJZXo3ZGpzRi9tRTZ2R1NoL0JERXF4Z1FyRU1TMHk3VXZrT3pV?=
 =?utf-8?B?cGlvOC9sS3l3S283akJTWjZudVJkOGVnU1U0UXZJRlMraVJidUhVVXZ4R0t6?=
 =?utf-8?B?Yk5kNzYyaVEvRWdadmtmQTRjSUN1bWgyQnRldGxSMGM0QlcrdUUxK1J5My9a?=
 =?utf-8?Q?JdyA=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49c73c12-6b1c-4b4e-689f-08dd4f972700
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB5246.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2025 21:07:57.0821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iHb/M3vyzbLyTKsc8DvzzuIQrmzfZEODBTCAI8eqgdJ/8sSHMRfFcV0h33jNn+t3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR01MB7663

On 2/17/2025 1:27 PM, Steve French wrote:
> Noticed this old bug today when cleaning up emails.
> 
> When the user specifies a srcaddr on mount, the DNS resolution of the
> host name should only look for the same type of address (ie IPv4 if
> srcaddr is IPv4, IPv6 if IPv6) right?
> 
> Any thoughts on how this was handled in other protocols?

What is this "srcaddr" witchcraft that thou dost utter? :)

There isn't such an option in mount.nfs that I'm aware of.
And, it isn't documented in mount.cifs either.

It seems like a hack on top of a hack to match the DNS result
to the type of the specified srcaddr. If the server supports
both IP versions and the DNS record exposes them, won't the
same issue occur on "normal" mounts?

I would not see this playing nicely with multichannel, btw.
Or RDMA. Probably other scenarios.

Tom.


> 
> https://bugzilla.kernel.org/show_bug.cgi?id=218523
> 

