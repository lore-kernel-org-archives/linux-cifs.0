Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2095.outbound.protection.outlook.com [40.107.223.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0711ABEC6;
	Tue, 24 Sep 2024 18:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.95
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727201133; cv=fail; b=p899c+jwjiiG/BZ0kCsiHUlmYsWVkYelv+lry4lP/ATcTQwwB5X7p7EIq0cKFYt8uLLssdSoQ2U+dn+jfLrW3h3S1QW56u1L5vQttbUIngfVJzm2Dor/s9ExWzVHrjuim3/EuzBlPvp6kkFWm3s2/13AJdVe5NF/fEgV59IO4Rg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727201133; c=relaxed/simple;
	bh=MeUsmJW7hpkynhUTcjUAHLMED7L/VZuMtyUKyCal1ME=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=m8djWDlPbZD5z4vr07tqF1Ri5LKjrdgcuWh+DXbGNQ0BT9F8FxmrjQ/YUWvD2OaD4a5EA4QrYxfFk33WiXKYtpzTtw7WqhdY5xWXZc7va+PbUypVQZCx5Z1kApgLZKD7BrH2LOtVk6V76YRhj/istU8Ainpyk987vCs9DgOh7yA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.223.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pXsMqj6R3M7TcAqyxFxBeWtYTIJIS5RHOAFi9FoLvvPo0Bbi+pq5WqYtweEvuIQ+wFUcnMX2Gg6SvH8pA0Xum808Z1EbRRztJNDJkIILpFXuAm8s+35KZYTmjqoduZI8g/80CUqnlHAF5n7E8ZBhb/uMwWRkArV9/Koi3eg6zVVVH5Iv0COeKd7Y2XxY1Dad4aIbn1dKk7SYgHzux2LOTplzGKvX5vD4UuZ49MVmuv33rSrj7cPBAG9UqU+LD1gMEyVyBp+pxbQKPg6itHyWznMviyZJq3Hj2S0mkDRw/IA+mYA8GlMQPCm0VUy9D36M2ER0ImCwnJYithzy9Iu2FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fvNcUZRfpTP8EdAsa2fGUWsl2RUGQQIz5ZlST4PytcI=;
 b=lSFetjSngNi0DFL8LMns8S2peQnhoipPhmFHwZ6KVC5DDbCHTWME4+IlRZUgRpEHedY3WHvGOmW7aopat9PYiRNE7NY8boJ6dGqyKBXBluuhPeWKEaX7BoAam6w4vqdTRldDMkHxGD2MNMCon+UbpzdTDX3yV+SV/Hhm5HH8Xt/4Nn/lW5Dq/mY2ElICrlzFTCEJ9htjmX8lJKCeKaG6YyFixUhwmkRHimutebBODIA1ggGPLuTnOxR7D0uVT37RfwL398l1ySVzO2x0zW6wVEEzK5VX4NcVvBbBFp+f6Ha6tZQKsSF23eFbS2TGqXQaze2faXdB8meTmUGFkHKcIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4016.prod.exchangelabs.com (2603:10b6:805:aa::28) by
 DS7PR01MB7854.prod.exchangelabs.com (2603:10b6:8:81::18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.25; Tue, 24 Sep 2024 18:05:26 +0000
Received: from SN6PR01MB4016.prod.exchangelabs.com
 ([fe80::1fcb:ca70:b1b0:8ce5]) by SN6PR01MB4016.prod.exchangelabs.com
 ([fe80::1fcb:ca70:b1b0:8ce5%6]) with mapi id 15.20.7982.022; Tue, 24 Sep 2024
 18:05:26 +0000
Message-ID: <d6341fc4-1d9d-46af-b809-f30430b30455@talpey.com>
Date: Tue, 24 Sep 2024 14:05:18 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksmbd: Annotate struct copychunk_ioctl_req with
 __counted_by_le()
To: Thorsten Blum <thorsten.blum@linux.dev>,
 Namjae Jeon <linkinjeon@kernel.org>, Steve French <sfrench@samba.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <20240924102243.239811-2-thorsten.blum@linux.dev>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <20240924102243.239811-2-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN9PR03CA0954.namprd03.prod.outlook.com
 (2603:10b6:408:108::29) To SN6PR01MB4016.prod.exchangelabs.com
 (2603:10b6:805:aa::28)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4016:EE_|DS7PR01MB7854:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b582ff1-a81d-4cc1-2849-08dcdcc3779b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cGVZVDJQWVVUL3VmaUN1RmpEcDJoTXVWMzA3Y2hNbVNPMERmWnhUZzVuTW9k?=
 =?utf-8?B?cFlpWXJtUEhEdTFZdzZGdTdDdXhxNkRaVjB4K2dReDRQSHp4S1NrWEhublQr?=
 =?utf-8?B?ZXpIWDNtUHRhS2t4aGxQQWVmcFJFU3ZvOXN5cEhYMzN6ZThxMVphVEJBVXJX?=
 =?utf-8?B?NURCdHFtc1d0bHFUL05iNEFQWHNYOURSc0dYQk1ya0ZRbzQwQWJiKzRNUUNl?=
 =?utf-8?B?TjluV3VDUm5UVXNNaUxxaURZa3Fid2RQUFVZdDA2MjA3N3VxMTVWMFhQbHhv?=
 =?utf-8?B?VEVlU0tDUitxc2NVZGd5NUFzZE9hQlNxaURDWHVIMFRTWVhUalprV1lacW9r?=
 =?utf-8?B?Zkk5N3M0c2dBUmZXZmo1QTNUQTJoZWhscWdwTk5VdjRLa3V3cXpOcjlQZU53?=
 =?utf-8?B?aGw5cGpUNG0zaUdnQnprWk5FMG9raFhkQ2FCSWVEVVJtL0xINkV2ODg2c3hq?=
 =?utf-8?B?UXBtekNrYkc3cXh0Z2s1TlRkbHV4ei9oQ2RXR3dmTGVoOGtmWkl0SElzb2cr?=
 =?utf-8?B?dnM3Qy9DUzhoeDk4NGY2T1YwVHZ5MllCQ0hKSDZ3ZGpVeUsxQ3pIWlNXMjRT?=
 =?utf-8?B?S2tDb3kxT0JtWnFRL0lRSE5DcmdRSjBTaHFPbElhZHh2RVU0SDZJcmdSWG8v?=
 =?utf-8?B?OFp3SVlFR1FsMFpSOGhrUTJ4TVNiSVZoUGppQlZJdGFGNjFOQmhYRndQYlAw?=
 =?utf-8?B?aUpCYjRQcjhwL3lhdFRzTWtQeFlNaEc1cnRDT0YyN2p0YlJHMkRoa0ZNVVZS?=
 =?utf-8?B?UUlpeCtMNmNDZkZyU21pdC9MbVYyY1BjRHdrWGIwSm0vdHJ3UWRkc1RyRndL?=
 =?utf-8?B?Ui8rUHBseXNYR0crM3I2R0MrTjFob2w0aTdlVkRUOE90ZVJCYk1wTDFRSWNp?=
 =?utf-8?B?VVAxZ3JveVE2NlN3YXlSYmN1cHg4aVEybHZkbFdCVWVaV2xmenRNL0RPZ2Jo?=
 =?utf-8?B?U3RkWUNnVm8ycGZEZ2IwNFlxcEtDRGZEUFJNY0Y2dHR5c0EwNndkZkQ5YWtU?=
 =?utf-8?B?bDVTaThaOFpUdUdpY05YT1dOWnVYdFEvWkFxWTh0czBldU1VY2Zub05Qd1k1?=
 =?utf-8?B?bWdFbE4zWll6R3MvOFh3Tkx1cGJqamptQitMNnFOMi93NFhEOGQrQlQzbS9V?=
 =?utf-8?B?YkVrQThJb0wrNzBhTTV3VDV1WHZxTUVVR25NWU5GeHBHWEFIemNSU0dqM2VQ?=
 =?utf-8?B?T1Qwajk0elN5T1FsVkNKamNtR20zc3pQMk1LMXFibUNnWG5ZMkhxNWFaVUov?=
 =?utf-8?B?eTRyRDlVZTJ1QXU4SjFOenpMeU5pc0UwQ0hLTnhPNG9zTnhyR01vZlRhQnFO?=
 =?utf-8?B?L0pJSUdBLzdLNzNyRzdmaVdLSEFGaHFad0Z3K1VaYVovV3hacmRGVUJjU0Zn?=
 =?utf-8?B?RE1xNHhjME0rd2xWK3B0Ui9GaldEVy9OV0JWUWxWUUpZOUVlOHdNVGRHM2ZP?=
 =?utf-8?B?ajd1NmNnbGRLL0E5dmh0bXplMGUyR3dVR3E4aW1vSDBpZlBPdWZBbG5FaGdV?=
 =?utf-8?B?c0RiaXVPbm9USDA1U3FNb2l3TzEyWnRFNFY0eVNJZXdrbG9tTlBpM3NpMktS?=
 =?utf-8?B?OWhUcGhlUUZ5SWM4ZFU4ejFHajNTaTF5dFRhaHJzNHVTUGJObThXZHZSTFR6?=
 =?utf-8?B?QmVBd3p5QXhqbjMvWnhHRTUwQ1ZjSk1aQjdKaVVTSTRka0tXbU5lWDZ6YUcr?=
 =?utf-8?B?NHdubUw1QTRDbEJ3NTA0VFh2L2IxSDFjVXhhbHpQNFhMcHlSM21VR29kT1dV?=
 =?utf-8?B?WGdFTHhvSWFOMXg3c2ExL0dQaUM1TFM5THJoeVFSd01JRi9zbFpwZGpZQkhZ?=
 =?utf-8?B?Ym5tVW9kODdkdEoxekJLQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4016.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d3BuaEI1d05XcW9wbXhQUGRoWFRCVmluN1Yydm1TbXAyY2tBZ1dRNVVwcWVq?=
 =?utf-8?B?ekdFUHIzelhYSC9LVWJSOU91TmZMWUNpQWRTVlpnN2ZVTzhLNVMrSWp5SjNJ?=
 =?utf-8?B?ampySkhOSmF5SzNDNGNuREYvUXorS0NvTS85VzkybjRIcVBmcFZwK0Iwa3lI?=
 =?utf-8?B?Y0IzTyt6SW50aC9mcUtadE9LbmEyZmNnUjFlcU52MjBpakI4OGVERFFaaG1G?=
 =?utf-8?B?enlKTGxRK2VuQVIvbHlBM1pBd21XU0hvZGJhd1NtcnBjVE15Sm91YjlZQXlo?=
 =?utf-8?B?MmJrb0diMmhTOVNnZDlQOGxDMjdUeXdxUVNKTVNjWUovc0VHMTltWWdMa2xK?=
 =?utf-8?B?T3l4MXhHbVQ4Z0RLbCsycHRJbGwwV2pJUDQ2eWpKU05lWEtJcFN5ZWd2R09H?=
 =?utf-8?B?WWJieWdHcnBPWWo1UXdMaUU0RWRYRkh3YU1menY4cjVjSEMxNy94NHl5OGdh?=
 =?utf-8?B?SEV1enFUbVhuTmo1N0tpN0ZrT1dwMCs5Q29oZ2pMM3Rydnk0RmpkMXlwcmNr?=
 =?utf-8?B?aVhCbVlaQkhiaXRHMVoxOEkrYzB1a09JRzR2UzJSYlJ6K2k4MjltaGZadDVQ?=
 =?utf-8?B?MHlNZHJDRGtHSjRZcS9kdSs0Mnh0YUdlNXRPc0F6ODQrc3lscEtrTlg5V0tp?=
 =?utf-8?B?enpFQmFWTE0xdWNmQ2Zkd01OTnJHRElqZFFYS0lGVHZmV012bnBZYjg0R0FY?=
 =?utf-8?B?VkdBTHoveFV6bFZ1eWVzRTRRZS84U0g5QllhY0M4amtrSXE5Si9INEYwMnk1?=
 =?utf-8?B?MURRWi9ueEg5SWlObUp3bFlVRytJMWN6M3l0M3YvQUhpZGl4WjNwVzNSbWll?=
 =?utf-8?B?YzdGNTNnYVpHYkltLzFYTnhqMHQ2WFlhRG1rS2J5MzY5Skx2QXV1dmFJQ2Q4?=
 =?utf-8?B?d1I2L3JwWXZIejhDYzgzcjA3Y1plT0dDOGdQNndsd2NaZ1QxR0t0eHlsVDdI?=
 =?utf-8?B?ZmsyYXhnNzE1TDhLSmwxc0lzTzkySXBvQ296QlZ0UmtnVXdabDJBVGpoLzFW?=
 =?utf-8?B?QzVKMGwxTTJtZUVwVzN2MFlLSGlTNlU1bGEyNk9oNmFKTVNuTVZkM1lHVkQ2?=
 =?utf-8?B?OHJjUWNWNTF6UXNZTjM4R0J0U0hxcWlHMjh2TVVIR1pWbXJ1TEtDV01TclZx?=
 =?utf-8?B?RktkMEpCeTdaZk5JNk4xaUhqNDMxMldDNHlobnBiU3JocU9iS2NFYlRibnh6?=
 =?utf-8?B?cWVvZFNSeGRCc0JlSFUrczRjd0w1RS90dzduc2xFazV2N0l0V1RTenlSWFdT?=
 =?utf-8?B?TnVjaW81N05DcDVYdjI4UWZVQys3Tlhxd0wxdFdQTSsyRzBQZlgrNHVhcHNj?=
 =?utf-8?B?NUdrU296ckxNeDBXU0xrVHlpc1dXVGgvVEFNR0hqQ0Y2STdBcEhJSTVwOVhL?=
 =?utf-8?B?M2JRZnQvOWJHTllTVXRGYkZIMFVIbE1aanpUWENtQ3MxT3RjeFNybHBMTjQv?=
 =?utf-8?B?SGppcmhxUDFucWNmTDEyandpaUFwN3JyQ3BSTWNnc0lnQzBMR1FrQk5pcG15?=
 =?utf-8?B?bUVHUWhCd1h1NDVNT0FZNVhqVlBlWkNaaFVGZ2hYK01saDlidENPQXRjYlNi?=
 =?utf-8?B?SjczSkxqdFJlb1BpdGFpa0xhWHljNlcrQ1FUOVVpdlhXdEx2RmpyOXAvVHFl?=
 =?utf-8?B?aUJFeHRaMkZ5L211ckp3WlR1OUNQYXpsOVNwVGtMb1QreVRYQ3RuSXNlME5z?=
 =?utf-8?B?QkhnNDN2YzBHOGd4NnJDcFoxNndFYWR5d0pvR2p1WjA2STNvOWpHMGJBWW5N?=
 =?utf-8?B?d3F5MUJIOHNZNFgxbjNhZ3ZSak1ENko4bDlld1F1VVdoMFdOMkxDd1duTHZo?=
 =?utf-8?B?OEZ6VVFSY2xydUdxK3pOTi8xQkJUM3N1Q0dPeXdtR2UyaXBRcThxYzViZHZW?=
 =?utf-8?B?cmpJZ1BLK2V2R0ZzYW1aOVVTQUt6RWdFYjYzdnpZQURyV0dzZVdFZCtWMmpo?=
 =?utf-8?B?SFZXZjlYYldBQi9TUUxFQ0p3dmluQjZ6aGpUZzBUNkNoZmFHOGtHb1FjOUdI?=
 =?utf-8?B?S0xUcEJDdmgvYXhOaStCSDI1bUJSeWRXRmpPdnZxT3lDWTAzUTkrQVNEcktr?=
 =?utf-8?B?Qko1amNEL2ZKUXpRenR3c3lIaXpVcjZQRVZuVi9iaVVQRHhCQ0ZIUDZ4eFBo?=
 =?utf-8?Q?q3KI=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b582ff1-a81d-4cc1-2849-08dcdcc3779b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4016.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2024 18:05:26.4576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pGKIqxStzkEc50IPgdVk6QA7CwE/p+X9BuFjlxkwffysGaBjAtSyG3ZtxZTUbmPj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR01MB7854

On 9/24/2024 6:22 AM, Thorsten Blum wrote:
> Add the __counted_by_le compiler attribute to the flexible array member
> Chunks to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
> CONFIG_FORTIFY_SOURCE.
> 
> Read Chunks[0] after checking that ChunkCount is not 0.
> 
> Compile-tested only.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>   fs/smb/server/smb2pdu.c | 2 +-
>   fs/smb/server/smb2pdu.h | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 461c4fc682ac..0670bdf3e167 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -7565,7 +7565,6 @@ static int fsctl_copychunk(struct ksmbd_work *work,
>   	ci_rsp->TotalBytesWritten =
>   		cpu_to_le32(ksmbd_server_side_copy_max_total_size());
>   
> -	chunks = (struct srv_copychunk *)&ci_req->Chunks[0];
>   	chunk_count = le32_to_cpu(ci_req->ChunkCount);
>   	if (chunk_count == 0)
>   		goto out;
> @@ -7579,6 +7578,7 @@ static int fsctl_copychunk(struct ksmbd_work *work,
>   		return -EINVAL;
>   	}
>   
> +	chunks = (struct srv_copychunk *)&ci_req->Chunks[0];
>   	for (i = 0; i < chunk_count; i++) {
>   		if (le32_to_cpu(chunks[i].Length) == 0 ||
>   		    le32_to_cpu(chunks[i].Length) > ksmbd_server_side_copy_max_chunk_size())
> diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
> index 73aff20e22d0..f01121dbf358 100644
> --- a/fs/smb/server/smb2pdu.h
> +++ b/fs/smb/server/smb2pdu.h
> @@ -194,7 +194,7 @@ struct copychunk_ioctl_req {
>   	__le64 ResumeKey[3];
>   	__le32 ChunkCount;
>   	__le32 Reserved;
> -	__u8 Chunks[]; /* array of srv_copychunk */
> +	__u8 Chunks[] __counted_by_le(ChunkCount); /* array of srv_copychunk */
>   } __packed;
>   

This isn't correct. The u8 is just a raw buffer, copychunk structs are
marshaled into it, and they're 24 bytes each.

The better fix would be to type the buffer contents properly, but that
will have protocol implications and should be thoroughly tested.

NAK on this change for now.

Tom.


>   struct srv_copychunk {

