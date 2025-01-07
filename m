Received: from CY4PR02CU008.outbound.protection.outlook.com (mail-westcentralusazon11021097.outbound.protection.outlook.com [40.93.199.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEBD18C035;
	Tue,  7 Jan 2025 21:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.199.97
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736283877; cv=fail; b=j8QAwQR3GBC9nJ99YER77UADuuWpr1AQ18i4ColmRUPOx2hIm6SngLnf0snzR3MmMRrX2BZPbseCOgyLxG6YUtoLS/D0/zZj4mHkxJkpHQZQ35M8FBsgyANKzSfyXXlG5UynGkJ8vMxzDyGtUMwg/4cwBW8DIzsIWYM6Nqn0vkQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736283877; c=relaxed/simple;
	bh=kuI2e2EHPjfiIvOzcmHt1HlRpBoZ6ikzeNDZrLDmTSw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fg1v5U6vLDAg9JAzepOWEFABjzadMhd1buz1pRwJuOJOKVFcpPUA31/tVZ8KauQoDp6i4XDVckRTHTrXU7YYG/KdfQ9vw5YtCWN7W5N8I4+iTnfNhVQ9f7trEjIHXJso7UE4WCqZfHPeTBbRo+qBnW+ZMpbK1Cw87k9xoN7St0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.93.199.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NuEj4A0TygkVF/kmUGM+iuTanareCc8+ILUguKFjz0VW8Hjpxye+bKSW+9u6GWLaGz15Y5yYx3w6HQ/o+PVA7NXvrG0TuxFJw4VmAQC41ZR8BLCDd94IY72aAMdB3YuHK8cN7qrcwm/DLz2pAqbS9nJmAtYpDeeqF9+NLuhvAEXV/9x/p+dqZpInhnL+lg6U+WcYTteGSypk1kGofKGfHHxPWOQ08nDIxUX7xSqObycZldomrhIMdkFQqgGvQ5Du/M6Q3cBjVuaSFu9XbcI0PSmCRSxzrpZy/OQMEXKMV1sBdUS6uqWwfR5uOhfxsf+hRfRy16DoFhaMsqsgtKWmaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mZynK2SpA18lFgPmGHuoFJWFzGNQcJVAh9s/k8Fs6d0=;
 b=J1uPMLvKKyA62j3PIboBmkTqCArUm+NYKfWaOyI35fNTCBiBhEiz0NTm5dkfravvu76+DpC6YsdG6Gq5j2nXIgfaygTbOQKhacm19KXQuU2SthVmTIPreKMDpgRbsQBG4Gu9ojs+CnxoEV30qrtUmkUhFA5M3DjanAt8Xdoort+09+4ymrIJuYAl0+rsOd6Nn+YVo2se5rTTSq7mZIPopEsP8Ii+JHYk6Dk9V/JDRG7TOwTuMJofWHy3dcUGdUXasB0CAkThBSa6U36F6gqdJ4UyJbD8KPH1lJ+UQMFDvVHNUI8xtwZn/rwFSw5/60feKgpuBi6MnwgjMHMnSw2UMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB5246.prod.exchangelabs.com (2603:10b6:805:d8::14) by
 MN0PR01MB7875.prod.exchangelabs.com (2603:10b6:208:382::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.9; Tue, 7 Jan 2025 21:04:28 +0000
Received: from SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90]) by SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90%5]) with mapi id 15.20.8335.003; Tue, 7 Jan 2025
 21:04:28 +0000
Message-ID: <d013fffa-8ed3-4c96-90a1-df2e7f45380b@talpey.com>
Date: Tue, 7 Jan 2025 16:04:26 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ksmbd: fix possibly wrong init value for RDMA buffer
 size
To: He Wang <xw897002528@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <sfrench@samba.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250106033956.27445-1-xw897002528@gmail.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <20250106033956.27445-1-xw897002528@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LV3P220CA0009.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:234::18) To SN6PR01MB5246.prod.exchangelabs.com
 (2603:10b6:805:d8::14)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB5246:EE_|MN0PR01MB7875:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bae43f0-4782-45c6-7b11-08dd2f5edfa7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?amFLRjZCOFd0aUp6bG5oNUxUZDY2STBTbkFCcTZYdjEzbU41a1JuN0Z5N2dr?=
 =?utf-8?B?OGpDcUFSWlZHY29PSlJHNlFCcTZiNzF6UWtXV2RSRUhiandDRDRCRG1Walhr?=
 =?utf-8?B?eGdEZ0h1b2orUk9xNlJzSEs3VXdjZ0xXYXRKQU93bHJWTWpOMXoyeXdaMklV?=
 =?utf-8?B?aFhpQlNYUytObmNIUFlDSHJlb0lHa25GRGZoTDdjUncwbWdpblVFYndkQnJy?=
 =?utf-8?B?MWRFSXJrUmhCV2tZMFBtdVhxdk43SWljaEVFd1NqWEUwcFViNmFadXpVTGo0?=
 =?utf-8?B?bDVVSWdGMFVnSFVwaW8rWWhDOUZmWkVVNG01S01XMEdPSlZwK1BUWDB3NGJU?=
 =?utf-8?B?aFEzR3E3UHNZWndoY1JJeW4vY0J5aUNFSWxwL3pPL2VrUmNtbFNmOU9FZGdn?=
 =?utf-8?B?NTNmNmdsMHQraCtlb0RTb1pWdndreDNPclZNSUVYZkZrekFBVXlVNklWUThh?=
 =?utf-8?B?Yi9DbE1lMENPeWFFbDJlTm9FV2pnbjZSbnpnMUtWL2pCZUt5QkFBSzFaTHp6?=
 =?utf-8?B?QmRjaGw4RXRORm1VSnpHR0FyYURaSklGVHFnK09lWEJ4QWg0OXBHN2duWVhU?=
 =?utf-8?B?Z3BEazBjSXp5akcyeUMvK3NLR2RyM2FZbXM4dkE1Sm5xT0VrdExJMk5ZTjc5?=
 =?utf-8?B?MmZFaFRqMU9qRXhsSTc0dUVGWmpWR2ZZaUJ4d0U3ZkJNZVVJMkZQMG9qSC85?=
 =?utf-8?B?T1NodUJSeis1T1hVVVhwUGpqeDBMOGtXUUxVODNuZ0g0aWZLUWVuVHFIR29x?=
 =?utf-8?B?RGo3WDVsOG8yMlFUeGVtaHd3MlZxeUh6d2tEQVdkd0c0UkJ2TWJ4UkkyeDE3?=
 =?utf-8?B?YnQvVlQvWmF3andHKzVxWC95RlhVV1hWNzl3bmg1VE9oTWpDQURsQkpLUjY4?=
 =?utf-8?B?U05sQnJzbGdwOWp3cmtTcHlRTk14YmRWSHV0STFjdUxpeStTY1NtSmc5cFVP?=
 =?utf-8?B?cW9ES1JJQWRhUDhoSld3dHU4aERXeWQ0dEIxVDkybXEvbWNMUEV2ZEI2c09r?=
 =?utf-8?B?NSt6eHk5eTNNTnd2S1VRMkFpS3lWN2tkWTJ4Q3BvR3g5SXBpMEIrUEZOQW1X?=
 =?utf-8?B?cTV6ZzNhL1N2WWF0bUoxSERHWWhrTExsQUlHVnNURDJTNytXM0xsZjJxWm9J?=
 =?utf-8?B?L0l0U0VUVURXRXQ5WGJXN2pIb3ZxbmdnYlVlQnovOVpSVnIwYmtLZXJGNGpz?=
 =?utf-8?B?VGFQaGhPT1VxYUw0VTA1UG9RN2trcGVPbmhEU1B0bjVzVm5EamxwRGtyUVho?=
 =?utf-8?B?NGhDWUQ1Qzc2bGRjK2dYYmFXR3JtV1p2Q01IRkp3QjJoS0FIQm10MXpURm5K?=
 =?utf-8?B?SEZrS3hDa2F5VTVMS1ZXZFR2WWFveE0ycHZSLzBlZER2V0xmNEFpcVFIRW9Y?=
 =?utf-8?B?dUV5WVZPSGtVT2lEejZhU3hPUGZqV1k5SExVcjZvNXFNN2EveFpGaE1BSDZp?=
 =?utf-8?B?cmx4MjRGeDNUNjBCT0hhemptT2hVdDgzV2tEZlRsR1lSQ2tZbmtwb1FNY0Fr?=
 =?utf-8?B?YVlVYWJQSVluRXVOYXpxR1hvaTd4Q0ZLQjAwck1jLzhlNXdmODYwUFFRSk1Y?=
 =?utf-8?B?MzA5UWxrZm9lcU80K0NuL0VPck11VDhPeTdTZTFKRFVCZkdaQ0VuaFljci9H?=
 =?utf-8?B?QVVZc2s0THQzR0FpdG96UzVLWWtCTWhpVTk1VXNrbGNKWUdXRzBEWGlZVEta?=
 =?utf-8?B?bzNiL211MVI1S21zTnIyVlh6akdDWG9xMHBPZXNPRkxwVnJVa2RLZWM3cndG?=
 =?utf-8?B?Zmo5eE9GamdPbU1HcFBrY2hUejIvZ1ErZFBkVXN0YWpvOE1jYStmb1dsT0NS?=
 =?utf-8?B?VGQwVTNjZzFNdDdZdEZiTHRzL2lsTW1ZYlU5K3FCbTVhTkZJY1dzUjlJSWN4?=
 =?utf-8?Q?Rlnp696RplkP2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB5246.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QUdudVBiT3U1L3ZNUVF0YkF0QzBucmNlSnlCTzdsQjVLNEFMLzVlcUxOelF5?=
 =?utf-8?B?S0V0S2ZoS2xVa2pkYjJVWHA0cHJER1YyNjdGNER5alpwQjNBbngvbTVHNndq?=
 =?utf-8?B?bnVBcEUrMUI1bW5LSmxLWVNCNUJPZVdoV2tBU3BFSUtoVmxiamdvVXE1MS9w?=
 =?utf-8?B?Y0F4U0kvYkhiTnYvWUF3Rkt0VjRFZHV6eVRudmdoV1NQN3IzRnNxQTZDS2tL?=
 =?utf-8?B?SjZ1cGwyL1J0Y0RqczR5eWJNbHJnZ0J3d1RDRDhLbjNFMDhiLzlVQWJzNlFF?=
 =?utf-8?B?aE9LTXorTTFaUk9saDZZaG9Wc2VVa25pL1lRUHAvc3E2ZXlxem9LYktGVWZh?=
 =?utf-8?B?T0FUM2FSVFJCMGVWRHZoZzNlamxsTWg3Tjl4ZFQ0VFBCWFBSUGJGdGM4SkJY?=
 =?utf-8?B?RE1NWndwTFpEQTBLU3RYVnVxWnJGdHNzOTlJTm1YUTVrZnVnNEg1MVVVVFNC?=
 =?utf-8?B?SnY2ZnpqZFdSeXBGakRHL2dBMVNrNzFhZk82THlqNnMzL2xENXFTSHhBamo2?=
 =?utf-8?B?Y1NNTERONTNEdXpzdmlrTys1dTJJVG9GUVhTdDFnQlRNQzNYSldSYUhxK0Jt?=
 =?utf-8?B?dnkwZkphV1dLQjJxTGdiUnJKUHZxSjNMT05TSVlkOVVmdTdFUDkvN3VmUnVW?=
 =?utf-8?B?WHZGeVcxLzNHR2ptaEtHOE1DZ0w3MGxxbm9oTDNuQnNKcTBlMlg5RTBBaWk3?=
 =?utf-8?B?clAyKzlrTk1kZFBsMzhNV3VKT3E5WW5yTFpyakszTTd4SEYxUGg4YWRJcVBh?=
 =?utf-8?B?d0xzYUxuNFQ5enF2YytEUTN5aEFBRWdnTUxEdDlIeGNNMEJPQm5tOHNPUExM?=
 =?utf-8?B?d1BzMVhZd2drTlUwUEdRTlZGZXEwbmN2TkNnQm9HR1YwUTAyN05tMjd4QXJr?=
 =?utf-8?B?K2xjSVFUQU0rekJOZWRIdDY5cUtITGJ3WWFFcXh1aGYzemgxOTV4MUQwUTMy?=
 =?utf-8?B?Y3JiWjNOY1dncnpVRHdDZU9OcGN5M3BYR09OajhKUGhlUDdQb2hPNW5ta3E4?=
 =?utf-8?B?cDNKc0wyZ1dqTmgrYXRCdXp1UjgyOENaQlZZS2ttZEZDeE00QTI5bG94NGNp?=
 =?utf-8?B?OFR6L09SdEk4Y1dNdE1CTHJmcXU4bTJncVVRMmFBaHdPNFlEdi9EcWxLZFJk?=
 =?utf-8?B?eXdqb0lNbGY4VFlJc3lpN05GdTdKSURmRTJDYy9id3p1UlJUU1oxWmxEcXZs?=
 =?utf-8?B?RDUzQ083M1A2SWR5ZExMb2s1WTBVWVJkWm5ZemtPWjNtNUUwbFZHK2VtY0pX?=
 =?utf-8?B?VlJIRGpYMWJ2L1p3M0JmL1FvR0VybDJLUlFlNUQ2L2p3dys5dHUzNExWYlZz?=
 =?utf-8?B?QVIxTzExczFTWUpVOXFtMnBBQ1M2aG13NEc3Sjkxd254SXZRbXlIM1NObFB4?=
 =?utf-8?B?aG45bFQ2LzllSG9MeFVBdDBvdEVOWmV1RVc2TTE0TjBiZ2RjZW9MVjQ3TVFj?=
 =?utf-8?B?ZGxRUUpLOXVmYXJyeXEyVmkveGNROGpHMU9OU3h6VEFxTmJNYUdBVHpUSFl5?=
 =?utf-8?B?VERUQ2dkMU1BbVk3SXpqOCtJeW9zM2N4RU1vUVpqNkprcU82cDY2YTdTR0lO?=
 =?utf-8?B?SzZJYm9RTGovazh6K2lZN3d5clVJT01ZU3JXd05MbnljSjdycjhZZE1oNS9U?=
 =?utf-8?B?ZUxFcXltbk5QdCtzdW8rbjI4MkRZM0dWeXlyM2FZZHNEOUdVSUtlRGxUWjFm?=
 =?utf-8?B?VzFTMlQvRTFiR0drK1g5SWw4R1IraWh5cC84TmpDVHk3RVdXbDEwbS9JdUVM?=
 =?utf-8?B?UXhqQ24rSitOSEE1Q0d5RHdEZlNsZ1pLbGlWcGFCa3Q0QkFSRE5TTDFrZHA5?=
 =?utf-8?B?Sk9XQnZCb0JBQkhkS1Q0M25ITFZ6TEV1c0FxeXpRSFJ3UFdCdEFhYlpLMzNI?=
 =?utf-8?B?UGdSUXdXRktScThFcm1tcDkzNGNkSThnR1JsS0VoVnRpam5LdjQ4bnRoUk1v?=
 =?utf-8?B?UVhQL25iMkd4TDJ0azFrOW9jUGdYQmZOcnVmOFpOenNPWXdwSXJyWXA4UGJI?=
 =?utf-8?B?OW8vdWlNNk9iemtWbmo2U1FBZW1BeTFsWW9ScmV3ZmtHOHBBRFhSUWNvUFVE?=
 =?utf-8?B?S2JjL2VJSE45NzM0cG9PZGV2YlBNWVlYQzI2NG4rVDUxejNVUUovQ0lML2Ur?=
 =?utf-8?Q?PVMg=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bae43f0-4782-45c6-7b11-08dd2f5edfa7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB5246.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 21:04:28.3600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7XRwowrxV0feIMm9bpUhl5ZNoa9dQA35Etg8FhKIc3lMiiHPQ5EVevpPUqc6wx9g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR01MB7875

On 1/5/2025 10:39 PM, He Wang wrote:
> Field `initiator_depth` is for incoming request.
> 
> According to the man page, `max_qp_rd_atom` is the maximum number of
> outstanding packaets, and `max_qp_init_rd_atom` is the maximum depth of
> incoming requests.

I do not believe this is correct, what "man page" are you referring to?
The commit message is definitely wrong. Neither value is referring to
generic "maximum packets" nor "incoming requests".

The max_qp_rd_atom is the "ORD" or outgoing read/atomic request depth.
The ksmbd server uses this to control RDMA Read requests to fetch data
from the client for certain SMB3_WRITE operations. (SMB Direct does not
use atomics)

The max_qp_init_rd_atom is the "IRD" or incoming read/atomic request
depth. The SMB3 protocol does not allow clients to request data from
servers via RDMA Read. This is absolutely by design, and the server
therefore does not use this value.

In practice, many RDMA providers set the rd_atom and rd_init_atom to
the same value, but this change would appear to break SMB Direct write
functionality when operating over providers that do not.

So, NAK.

Namjae, you should revert your upstream commit.

Tom.

> 
> Signed-off-by: He Wang <xw897002528@gmail.com>
> ---
>   fs/smb/server/transport_rdma.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
> index 0ef3c9f0b..c6dbbbb32 100644
> --- a/fs/smb/server/transport_rdma.c
> +++ b/fs/smb/server/transport_rdma.c
> @@ -1640,7 +1640,7 @@ static int smb_direct_accept_client(struct smb_direct_transport *t)
>   	int ret;
>   
>   	memset(&conn_param, 0, sizeof(conn_param));
> -	conn_param.initiator_depth = min_t(u8, t->cm_id->device->attrs.max_qp_rd_atom,
> +	conn_param.initiator_depth = min_t(u8, t->cm_id->device->attrs.max_qp_init_rd_atom,
>   					   SMB_DIRECT_CM_INITIATOR_DEPTH);
>   	conn_param.responder_resources = 0;
>   

