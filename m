Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2130.outbound.protection.outlook.com [40.107.92.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10539244E8C
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 19:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.130
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750360937; cv=fail; b=aSfzvP49VKT8b0AgLr2LvXAkU/FIIP9XfoTP/uvZ5CpTv7QVVnAkg8K3sHR27xJH6QB7x9vuvwr+rs//z+Y6JeVXtCIGMElO8ABIgnuNkewxiUxIvvA6B9Kg3LBaSDiaFpt8/4MmRDkV5ocZ6OB3MenKC13W/wpa/0AnlhCCWkk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750360937; c=relaxed/simple;
	bh=N1ZqLTk58EpQQRwsH2vQtmdB+PtGNURHhZYd8SvMOEE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=X+9b76WCut84g/vypjS4iOGCmAQb8ZzU3VafOFAuuzZMkrvhXHDTf2Q1ytSHGnEKomZL1e5uMyEIaYos6B+woTaebIyWaz6nAcJX2edI+KayAfcgxNFzBy7z7ruVY4J/Y0h0/mipqIEi/VPogdRVf6b8CaRGRCp3f+r1mKd0zBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.92.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V69EUcfBnny9LN/reHB6JZ1mwCkYpq0mqLAo1Yjir/2EgXVyRRL2n+29E5cpG+r0SIZy3yTLYkIT3jX/QzGFnISjE/ZZLi6+XocAPxAk5+1B2UB+4rOrRXtXjorUE+npIIKi9VIabJYNS8RESRW2TJz/51IA6d+RCW7DPAxhfpwodDQDhEseIu1b9DuEiK91YIzWWeIYVSOOLNr9VRZ6CcEcggVMwQLO4d6Ho3JryJx7HTA47fc9u+TixPlsIqmjSAiknbsbw4l4PAtK4cSwNoefqg3BSj+ecgFIHiJATXcUiUWN6biz+xdodehNo8cfQc6KsqAWIEUfYkfudZlukQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jRT+a21BaujRFfldDNAhgsXTVU2Oc75Te7qMxwQEW9g=;
 b=Ko9o4ni/5Z+ggFa5+6k+YJH9xrUrDAd+zrhT3DVONB9Seg9T11MrnD2ipV16XEzSlfULSdaa6E0f8Krxz6s68Q7fQn2EcKnzdXy4c40dqk71VxsYZsE47GjeEDPIXJOG2H+joJhj4vwK9gPosTqqHIRj2UDB+LExde8FdGeEmj7Z8RV1PtXuEpD9LVY4z6vtvkFV8J1GLIxJ5lt7igebGRBQiaj8l7Cvgxuh/GRCn6qSH6Maow05xlHdNn+3ol2QYPEH6wpu+zqntRYKIxTvzV7+5IfZtD02j0aVKYYAFnZWNItc0zVWSnSiqZePyaEaaO8pOhGByBNasTdZowjvIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BL3PR01MB7099.prod.exchangelabs.com (2603:10b6:208:33a::10) by
 CH0PR01MB7186.prod.exchangelabs.com (2603:10b6:610:f8::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.21; Thu, 19 Jun 2025 19:22:10 +0000
Received: from BL3PR01MB7099.prod.exchangelabs.com
 ([fe80::e81a:4618:5784:7106]) by BL3PR01MB7099.prod.exchangelabs.com
 ([fe80::e81a:4618:5784:7106%5]) with mapi id 15.20.8835.027; Thu, 19 Jun 2025
 19:22:10 +0000
Message-ID: <e07c9bab-5750-4a50-8b38-4ce8c1a214d6@talpey.com>
Date: Thu, 19 Jun 2025 15:22:11 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] smb: client: let smbd_post_send_iter() respect the
 peers max_send_size and transmit all data
To: Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org
Cc: Steve French <sfrench@samba.org>, David Howells <dhowells@redhat.com>
References: <cover.1750264849.git.metze@samba.org>
 <8ecf5dc585af7abb37f3fabac6eb0f9f3273da85.1750264849.git.metze@samba.org>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <8ecf5dc585af7abb37f3fabac6eb0f9f3273da85.1750264849.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN0PR03CA0016.namprd03.prod.outlook.com
 (2603:10b6:208:52f::18) To BL3PR01MB7099.prod.exchangelabs.com
 (2603:10b6:208:33a::10)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR01MB7099:EE_|CH0PR01MB7186:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dec6154-7fbf-4b24-34e2-08ddaf669694
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R2pHaW9ZRE9hL0xpbHUvLzFMWnk3MkpLajZKMWxiY0ZVMytJTTUvNkcxcjVq?=
 =?utf-8?B?M0huWVFKdXErV0drOHBlNThZbWNpdlBIU2FSZ0kwV0NDdmUvWGgyM1B4Q016?=
 =?utf-8?B?Z3FSc0NtUS82V3FXcGk4UURaOXBrV0UzQXlWcWtpOUkveFZoYVd5dEk2TkxX?=
 =?utf-8?B?RVM0NU9qVk43UGxqL002V0YycWFsd3lhQncwSmpIcnFSN3dKMUt6M2I2NDdM?=
 =?utf-8?B?cDZYSGZNSngxaWo2dnAybVJOeG9vMkovdkVoSDh1K0U0aHhEc1pWTldZNHAy?=
 =?utf-8?B?VDV6TnJLc1hqbnhBZ1NtK29PRitZT1pCRCtpd1F0QWozUnlZam0yZ1hMN2xo?=
 =?utf-8?B?RmVjR3RIckE0b3o3SkVKN2pEZkpzL2tIaThyN2d2V3gvVGlrYlBqRFhFazdx?=
 =?utf-8?B?SDlYZ2JVUlppWlFiOGdGYkRoQWRmcFR5aWl4MU9LeTNwbWx5WHY1Z3hycncw?=
 =?utf-8?B?cnV4WFNxYUhidTNSVUlTTG5hTmg3QkJJelNTejBTeTB1anJDUXZ3bEhFY3ht?=
 =?utf-8?B?eVRjbUNnS0o3NzR2Q21BQkRMdG1kWTBaYlJoVi9Nc0ZNdExQNmxBOTdhTmNQ?=
 =?utf-8?B?bGIxNkpJSjNGRlppaFR5c0ZaVGc3Rk8wTVFKbUpJM2crenpRU0c1THFHMzlG?=
 =?utf-8?B?YXUvaEtqekx5TUQyaElCenZMR2FmejdFL0F6bHQ3M05PWWtxL3hHek56M25U?=
 =?utf-8?B?STVUSzJ4TXJGTlRQbytXcmVJMWdnQy9ycnBLcmpRWkNvY0pncHlZWU9Ncmp3?=
 =?utf-8?B?ZzhuTm9XUWh2anAxRUt3Tm9LM1A1VGE3dGtXcUpPaXNkaEVLTUFBdU1Sdndt?=
 =?utf-8?B?VDA5NFBrNGdZc2YwMHRPQis4SFVEYWljMElWclFpSHdPVHpSVkZzS2I1cUYy?=
 =?utf-8?B?TUZTOVZpb0ZJYnd4VmhuN3VadTFNblA4ekV0cnBXZUN3SXQ4MElhL2ZBYUE4?=
 =?utf-8?B?S0FtMUlnQ0QwWTZLWGhOOFpoNVNPcnhMVFB3TGhWbE03b2xQaXg5R0ZsYkZR?=
 =?utf-8?B?bEZ1L0l3UGpLQnNEWG5UZVR1dzdlVXBKN1lVekZTNTFzSjRXSUlSQU1HZmU5?=
 =?utf-8?B?ZXlhR0llWnZDWTdraDBkV0hHeTVCcTVhRlhwRFNjSEVjem9jbWV5UHZaZWkx?=
 =?utf-8?B?QlBBWlNEQm11RXp0YmtiMGV6SzFjcmdLbE55RmNueTlLVzhrMEVvdktWOWZa?=
 =?utf-8?B?NzlRYldndTFMc0k3T0FEaWNZeEhXaG9wTG5iTitqMHdDNUVSMmd2b21GWElz?=
 =?utf-8?B?NnJXVUhBNHJrVk5qUTFPQkJLMWoyMTlBYmVJeGhyaUZSQ2N5S1d6ZWVBNnJw?=
 =?utf-8?B?YkFqRjBCUzN5cTNlUngxWS96a1hTUk9KMndFWVNoNVpVZFdEK0ZWWHliQTU3?=
 =?utf-8?B?RDV5WlAza1BiNjN6YXY3ZXRGYkkxZGNzWlF3RVhKNEJQbEt1Y21RSXdYamxZ?=
 =?utf-8?B?alNybTd1VjVEQ216Q0E0eHpCUm5TWG9uN09kV1d0Ym0yS2h0WHpaQXJtWXQ5?=
 =?utf-8?B?QUpnQnVNOGhaUHZvbkxBSTVZTHltQXFxaFNZV0ZoQ291ZkVnU1BCL2pYME5m?=
 =?utf-8?B?ZWhRMWZlN2VmS3ptTnZ4NHBHKzlJQ29TYUs0V0gzMmVlOG5lbjVKRWxlcUd6?=
 =?utf-8?B?YWZQaTRiTFkwR2NiUU1jQlRaVzdxR3RnYWJDVUErcE9WUmF3MWpTYVZOMU9I?=
 =?utf-8?B?c0RzcmpQdGVVMFpHTFVoQSs4cW5mL2VtdzBCU1RPWGY5MkFYdUtJSFNnMENo?=
 =?utf-8?B?SDV4cUo3cmFUaGw5QnVwRG9obmFUdlBuWUxjOWFHT0dxTTJ0WUk2ZzlCaEJx?=
 =?utf-8?B?NzNBTGd1YSs2V0RQbDVpT3g2MlRFQTdRN3hkdW5JU2xXWGRMRVRtZDJ3cjQ2?=
 =?utf-8?B?TXdjR3hrbmUxemsrS1Y1d1ZEdVhDZHFpRlJIWWhxRm53M1UrUmw2MXg3bms2?=
 =?utf-8?Q?X8UcKeXAAYY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR01MB7099.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZUlQMXJveTl4b2o5d09TUUFPOTdJOFhzaU1icE1Fa01iSWRWdUlMb0U0Qk5T?=
 =?utf-8?B?WjBtcEFWMFllQW9BY0k3N2xieEQwOUo2RjNrTURjclJNeFpYNzdsTENKVHk4?=
 =?utf-8?B?M0ZwWEVXOC9BZlBuaVJ3V004T25yUzJxbjVrSE5yRXFXNXo5ZmY2Y2x4ZGlo?=
 =?utf-8?B?dDlCMVowTHZXUW9kNytDek0xNmhJV1pub1c2OVNVODltMlhicy9CMUFsTU01?=
 =?utf-8?B?ajhXUzQ4MnpheUU4aFd6QlRrMzJiN01FMzg3L1pVM3hMUm52YXk2MXhUam5y?=
 =?utf-8?B?U3dDaWpCbzlLQ2kvUzNtQzFrRjVSQ21Fa0xjS1lrUXVBME11cEtXNHhqelBE?=
 =?utf-8?B?d21QcDU0Q1FsVitaVWdzYmVyeDFtTTJuendvK3RReThMbEZNaHp2WU9VWXBo?=
 =?utf-8?B?M3RhUG5RTldoTHdoeTVoNmR5a21KQVdFb2lERFNHRlhQZFhYTm9lRFFmbDlk?=
 =?utf-8?B?U0UvZi9WNlJ4QU43dHhNUVNyZ09vODIrallicHFRTWQxSDRFdE5TMmN6M0xL?=
 =?utf-8?B?ZFB3Zk9IVEYrSVNwdnluK1BRSElCSzdIbUM0ZFE5cUdPQWwwSHFlcEdsbHNP?=
 =?utf-8?B?K0lwSWtUNFgzTExKT3JnYklyVUdjc2xoYlhxNnIrZ3YvcnNJWkZrVTBDWE9F?=
 =?utf-8?B?aWVlTTBYeHk5TndaaWtTejBXeWhNU0RyQ29OMGx1U3QyZkYraG5OcnA3d1h3?=
 =?utf-8?B?VmNwdHo1ZnJ0aVdVTUZpa3ZNemFrcERkOXNva24vOHN2bkhPbFVhWlp5bk9U?=
 =?utf-8?B?ZmNENmdHakNMS1RyQWJXa0xLRjFOUFlYdXZtQXVHMXUrdTF5T3YwWmQ3aG90?=
 =?utf-8?B?TmhPVXNWanVqdTA2dnZmNnAybVFsSklFNUM5ZFdsZ29sa01CQk9ZalY0bmJk?=
 =?utf-8?B?dUw3Q2hjbU9wbTVPYmQrcTlCbmdGbEt0eUVvWEVIanlmWks4Z0ptcVFBckZj?=
 =?utf-8?B?NFg2cHE2NFR4ejNRakdYSDU5WmNBcWljajhKSG5hTkNpTk94bitHbnMwSXpl?=
 =?utf-8?B?VDdxd3pBbHBTa2kxS0JFZzFuZGhrdHZaQk45QWRoY3NqS2hUb1lpUWs2Mnha?=
 =?utf-8?B?RWdvK2JHUlF6Z0d5UmVxbER0S09GZFhQbHhEWlIxQTVNZGNuOHlKR3ZUZHEr?=
 =?utf-8?B?SVhVUHBLSVJ6Q053UUcxTVBrazVIbHJscjlxMll1cGxPQi9lTTRlQ2x4RVlT?=
 =?utf-8?B?aDBoektwaTdVZnJNN1kyLzc2Mmg5Sy9ZYnNlKzBHTS8wenNNN2FuZWxDczV5?=
 =?utf-8?B?bytvRmZYRWtGS0JDRVcvejU4eWszMUxNMXFBVEgvMzh6NjV0L2Y4VUhRaVM4?=
 =?utf-8?B?aHNVM3pzMEt5YThqcXpaRjJmR0JwbnEwQnJmN05lajZBK0UvRWNjVjZ5cEZj?=
 =?utf-8?B?UnRGdGZCeUwyWUhiV2x6emdnUFVxVUJ5M3pVSnU3TllzMThDV2hLNGhPTWlu?=
 =?utf-8?B?TmxvU2NkdEdUUGhHbVVFL0Y0OHhHYkZLYkZXY0pvNkJjTXk3UXVGc05iWElq?=
 =?utf-8?B?OW43RUFqc2dYNEN1Q1dPYlBlb2p3YTZIb1ZyOWwrVjVmK1hQUnBIS25zQkR6?=
 =?utf-8?B?SjJIZkRVeXg4NXRtdGp4M1hVTVR0UW1OalBVbVJUNDV0V2hqTUorb0UwaEc3?=
 =?utf-8?B?TFhRaE1kUEdoajd0Qlp6SGZVd0RSTnRkTk5adS90K201VFpqRkkwMU01WW5D?=
 =?utf-8?B?aVRxY3JYTWpIcFk4blFsVldyWUR2SU9GR3JvTnp6U0YvMWxINXRXb2NMVGtL?=
 =?utf-8?B?dDlzOGdmeDVvNWN3UW9ZYWxHY1E1SkNvMWxhenB3ZmRIZXV0eVA0bGs5ZFQ0?=
 =?utf-8?B?YVRaUW9OaUNWOWdISzRjWmx1RnJJaDZuNElueW1Ga2hZcHpISjBFUTI0Wk1v?=
 =?utf-8?B?MHBMQ0lVUWRMSG9vMHFPWnhuZlRHN1AyOGJYV3FUTGtMUm5XWE9JM0c4cGdR?=
 =?utf-8?B?MytvK25LcFdnMWdUQVhISmNaS01KUWRqM28ycmhRellOUXVvZ0xIUGFhaGVZ?=
 =?utf-8?B?VWVYOVNrYlNTbnlsc2FPUUlJUjNJSytlMWZOMzlYcGpsS3M5ckJOTEZndlI4?=
 =?utf-8?B?b2l6RzJ5Z3orOWZYY1Q2WXErTDZLWVpTdVY4MEhhbytlOG5iL1phSEJyWXNo?=
 =?utf-8?Q?mD94=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dec6154-7fbf-4b24-34e2-08ddaf669694
X-MS-Exchange-CrossTenant-AuthSource: BL3PR01MB7099.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2025 19:22:10.5935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hUbtAkgaIhrTab1R7gif/kLRzfk9+Jtd899sZMO4PL7XqqCkRKT25ZQ33nNUM2Ok
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB7186

On 6/18/2025 12:51 PM, Stefan Metzmacher wrote:
> We should not send smbdirect_data_transfer messages larger than
> the negotiated max_send_size, typically 1364 bytes, which means
> 24 bytes of the smbdirect_data_transfer header + 1340 payload bytes.
> 
> This happened when doing an SMB2 write with more than 1340 bytes
> (which is done inline as it's below rdma_readwrite_threshold).
> 
> It means the peer resets the connection.

Obviously needs fixing but I'm unclear on the proposed change.
See below.

> Note for stable sp->max_send_size needs to be info->max_send_size:

So this is important and maybe needs more than this comment, which
is not really something that should go upstream since future stable
kernels won't apply. Recommend deleting this and sending a separate
patch.

>    @@ -895,7 +895,7 @@ static int smbd_post_send_iter(struct smbd_connection *info,
>                            .direction      = DMA_TO_DEVICE,
>                    };
>                    size_t payload_len = min_t(size_t, *_remaining_data_length,
>    -                                          sp->max_send_size - sizeof(*packet));
>    +                                          info->max_send_size - sizeof(*packet));
> 
>                    rc = smb_extract_iter_to_rdma(iter, payload_len,
>                                                  &extract);
> 
> cc: Steve French <sfrench@samba.org>
> cc: David Howells <dhowells@redhat.com>
> cc: Tom Talpey <tom@talpey.com>
> cc: linux-cifs@vger.kernel.org
> Fixes: 3d78fe73fa12 ("cifs: Build the RDMA SGE list directly from an iterator")
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>   fs/smb/client/smbdirect.c | 18 ++++++++++++++----
>   1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> index cbc85bca006f..3a41dcbbff81 100644
> --- a/fs/smb/client/smbdirect.c
> +++ b/fs/smb/client/smbdirect.c
> @@ -842,7 +842,7 @@ static int smbd_post_send(struct smbd_connection *info,
>   
>   static int smbd_post_send_iter(struct smbd_connection *info,
>   			       struct iov_iter *iter,
> -			       int *_remaining_data_length)
> +			       unsigned int *_remaining_data_length)
>   {
>   	struct smbdirect_socket *sc = &info->socket;
>   	struct smbdirect_socket_parameters *sp = &sc->parameters;
> @@ -907,8 +907,10 @@ static int smbd_post_send_iter(struct smbd_connection *info,
>   			.local_dma_lkey	= sc->ib.pd->local_dma_lkey,
>   			.direction	= DMA_TO_DEVICE,
>   		};
> +		size_t payload_len = min_t(size_t, *_remaining_data_length,
> +					   sp->max_send_size - sizeof(*packet));
>   
> -		rc = smb_extract_iter_to_rdma(iter, *_remaining_data_length,
> +		rc = smb_extract_iter_to_rdma(iter, payload_len,
>   					      &extract);
>   		if (rc < 0)
>   			goto err_dma;
> @@ -970,8 +972,16 @@ static int smbd_post_send_iter(struct smbd_connection *info,
>   	request->sge[0].lkey = sc->ib.pd->local_dma_lkey;
>   
>   	rc = smbd_post_send(info, request);
> -	if (!rc)
> +	if (!rc) {
> +		if (iter && iov_iter_count(iter) > 0) {
> +			/*
> +			 * There is more data to send
> +			 */
> +			goto wait_credit;

But, shouldn't the caller have done this overflow check, and looped on
the fragments and credits? It seems wrong to push the credit check down
to this level.

> +		}
> +
>   		return 0;
> +	}
>   
>   err_dma:
>   	for (i = 0; i < request->num_sge; i++)
> @@ -1007,7 +1017,7 @@ static int smbd_post_send_iter(struct smbd_connection *info,
>    */
>   static int smbd_post_send_empty(struct smbd_connection *info)
>   {
> -	int remaining_data_length = 0;
> +	unsigned int remaining_data_length = 0;

Does this fix something??

>   
>   	info->count_send_empty++;
>   	return smbd_post_send_iter(info, NULL, &remaining_data_length);

Tom.
