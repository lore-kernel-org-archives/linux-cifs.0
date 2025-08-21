Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2090.outbound.protection.outlook.com [40.107.101.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26C620B80B
	for <linux-cifs@vger.kernel.org>; Thu, 21 Aug 2025 16:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.90
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755794713; cv=fail; b=rK4IPia8+rnSC25Q6uYE1DsNoFHx/nq/wzoFHDGwCCtHhqnqWhvbQEtEteKZZDREyvAC1qtPiJy+UWB3FznYdCp6LqLmw52AItvabO4K6rMPn8gPDaVI3y7WE4/7hpm3QffHJ6IiC70wm3UdXbl4Cb2mOp3xkTIDmK6Cdh0Ah9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755794713; c=relaxed/simple;
	bh=XTgTFH3UiQazkCTbPrRGerDuDqZA3FuyBjpO4ntchFk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rvBdzXdM0/+3vWecIUmUq5ZKNMP7wjI1EK8xg7KtYT4auvIx6ARlGHMCLpQ09gJoPPdNGQw84RBbJbz3wssnB/Y7+sGOxXXGVarFDKM4w+bLOw0395PmCTFR16ZpPfW2Hx7EpW3GQyb72VJ6X1Jf7Go8MgdLkwFrj68IUPFr7Po=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.101.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HXMf5ouklKsd6onKe1Q3eYhGsNyA6YojsRgBqytQLctUcEPS1mG8Y5jbcEaVFM5zzC7IiyRK48RDqxw7XbvHmLuyiV6qcW31hXhD/mjLkDHZk6hyAyQYodYC/Tk5IWBKxYp8Udq4LlY+6QAnEL1c+b3NiNOFz112Ycy0r8qOgCjMn9lzgU5WH/ceFVmGAeIwhriPyUjRJ/48UdvzAFkxJ6sfRctK1DHnq8rh2Wwl3t2Pb5t6YXdN8ca5Y6L9oUZWO+cRevY/KztkZQLt3s78db8g9E6Og0DVF/KZD8V42nmWL1FHBzTdK0CtMTAxVItZ9C32bfFeAAlT66QUeOrcTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zEutz55hOw55rPeZq9kaG3zj7Etl+lgUkMRLtNldo0g=;
 b=Cf5dqzDGUKb33Wcc3//w/B1miGioglwVyOHlT+LBOZ06Me8sG0UCh0bKO+w3ERZ295wh6EdwZN8VGyQLBsjwefK3ZSuL9CsYB9TZdFaVnZbCkNWQiVsmXdJvCflDlgdOBOJZFOpjmoGkWH8QcBL5uLlWZARaSXsTUtLm9E+ZB1pb/MGiJ73hH85PyGWPHE+notPHFIkBbfmINV2JgG6fCaU43Bobk5KsyFe3VF4rk52mXY5c3SXuuFf6A7olot1ZcOrE7ukv0oIc4Pel0BCvkpGVGxMkDHhSsv7HVZ77pfiYo1E7uVI/1HegUai1ZcG1hjxU0+Z9g6Bz9bU35Gq1WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from DM5PR0102MB3414.prod.exchangelabs.com (2603:10b6:4:a8::22) by
 CH2PR01MB9101.prod.exchangelabs.com (2603:10b6:610:27c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.13; Thu, 21 Aug 2025 16:45:09 +0000
Received: from DM5PR0102MB3414.prod.exchangelabs.com
 ([fe80::cc85:45b5:e6fe:e2db]) by DM5PR0102MB3414.prod.exchangelabs.com
 ([fe80::cc85:45b5:e6fe:e2db%5]) with mapi id 15.20.9031.021; Thu, 21 Aug 2025
 16:45:09 +0000
Message-ID: <a0ab409a-bb90-4a15-a8aa-a18f9f6a0b0d@talpey.com>
Date: Thu, 21 Aug 2025 12:44:59 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] smb: server: fix IRD/ORD negotiation with the client
To: Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>
References: <20250821092751.35815-1-metze@samba.org>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <20250821092751.35815-1-metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR22CA0021.namprd22.prod.outlook.com
 (2603:10b6:208:238::26) To DM5PR0102MB3414.prod.exchangelabs.com
 (2603:10b6:4:a8::22)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR0102MB3414:EE_|CH2PR01MB9101:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ac3a865-9479-42c9-00ba-08dde0d21718
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cWY2bEc5UDlMcm8yS3l4RGkyVktYVzl3NE5PWEhsaHM1NE56QVh2TzZjdjJk?=
 =?utf-8?B?ankya2tFVTIzYTFscEVtUC9TbGtwblRMQzFjUXlPU0JKdmptZk5DTkR2Um9U?=
 =?utf-8?B?SjVRaWJObFZ1b3lIbjZGcFJPd3lqcUl4TnYzTEtEVEFlbzVjU0Vjd2hZRGFS?=
 =?utf-8?B?RHo3Q3pHalN2YytubzUyN2RzVTM2b3pleGhVZ2FZUUhGMlR2SHRJS0xyUXhV?=
 =?utf-8?B?YWZTdlFwWXlZL3BEVnp1bDZyditOZDV0Zi9YNkpqcW9DdEhETzY5TGNDaWQx?=
 =?utf-8?B?NDZlRGoxYVpGS2hWMUdIclpQZ1hHNTBDb1ZBdDBGdFpZTm5wS0x2YlV2NGdQ?=
 =?utf-8?B?eGh4YzQyQUd3ZDFKNFB3U29tamVPRzE2bDNQSytma1djTjB0VTNhUlBpOXJs?=
 =?utf-8?B?d0NzMjJ1VjJrUmdBMVBnVXorZXl5NWIvSzAva0NkeE9QckZmUURXNG5zbjZX?=
 =?utf-8?B?Ly85VFNtamJ4ZEhJYndQYys1b0NWTzRnSk5JWE9vdnBDeEhuTzl0L1Zpalcz?=
 =?utf-8?B?dTZURFFEclQyN1N6U2JCMURGNGV1dkRpaExjSXREaUNRZDVHS0lPTnNya0k2?=
 =?utf-8?B?VzNyWWNkd254M1pDd2ZoRXU0bDVnRFh3Y0NBYjlnZm1ndzVBT2lTVDZKZjhm?=
 =?utf-8?B?K3JsQ1E4bk5IdGFBc1JRSFE4bzk4Rk9vbXh3bHBuM1pTM3JUWTRiVDNmaUto?=
 =?utf-8?B?emN0cXZMNEk0V0JHUCtFL1JYbUxPaGZ5dDBpa1FBVjZjOVJnb3NwbERucHc4?=
 =?utf-8?B?WUdaRGVEcjlpNEhBcnVsUWxyNWtJVk1IMjRYYm1EdG5YVVNRb01rSldyYmd0?=
 =?utf-8?B?R01FTk94NXEzZ2NRNjh3cG5PRVlXbGRmMUliR2plMmVGNC92TXFiaE9zRlg2?=
 =?utf-8?B?dVBJL2JJY1EvWW91ODFmeSsyZGE3MkQxbFhjWWRyNVRSanQ2RGF2a080TEc3?=
 =?utf-8?B?aks2VXkzVmUzZDFJZFIrTlNBWkN3cHc4eXVrOW1WS3JFUXo4NGtpQkF3ZGtG?=
 =?utf-8?B?cjgrQmd5WHJicjZMTVpKcDFiUy9uRXE3Sk9nQ0llaEw1QW5hRk1IZTd1eGZY?=
 =?utf-8?B?S2c2cExWOXJ4OHhQRVRZNFdPSzNBeUtZVjZKYVlZSi9yZ1JBZU9Ka3M3cStz?=
 =?utf-8?B?SzU4V2NLcHVkd05GdmhVMkExS3ozcmN2QUxZaFpWbi9vejcxWVFTUW1FS0pv?=
 =?utf-8?B?TmhEQTZQNjhjUmNqdjJLUDJwb1lEOTJyNHRqY05NTmcreHNEclhlOGxWa1Yv?=
 =?utf-8?B?SFVkZzM3alA1R3ZJVjhJSXNoSTY1VERtZi9TdXVUTFBUMWMyVjdic2hzMUxW?=
 =?utf-8?B?SE5tVHpLMHJhb3EyZTh1RFd4V1RoaW5GenNvTFNBVzFTQzFFcHVQN2tibnJa?=
 =?utf-8?B?NHQzcm9HU1BuaytMbUhySVpNcU9RYXY5UytWVUlhYW80S1BFTFhzcG4rQm9x?=
 =?utf-8?B?QjBIUllReTQ3aTVVUXVFWFFjR1FzRytoNkozNG83ZVh3YWVhT25nenNTMGNE?=
 =?utf-8?B?VUNXZVZPODAvUkdQMnFvaklmWXp1U3M0UElXUjJ4VmVFbWVya1dDY3pUeHlF?=
 =?utf-8?B?Y3IxbVFYU2R1akErUElJUUUvR1hoQlBIOXZydWN6dFI5aXN5TElNT0NMTVND?=
 =?utf-8?B?V0hncS9JVitnSjVRbUtWZHhXRmJORWtjd2ZPWUFKNGhsdzNuK1dPV1o3VzFn?=
 =?utf-8?B?anU5bG5tUW9TMDdobTFiVG5SVEZmOEZGalJXRGdTQzc2Q2NhN21XNzBJNklU?=
 =?utf-8?B?M2NReWdOYzFqb0NKZXpVbXl0Z3B3UUVleHVCZ2IrV203MjZsR3F2WE82aVVv?=
 =?utf-8?B?ekNHSVI1dEMwOVQ4VUMrZ2xaSmNWQXMvc2pjWStlejc1REgxaDVKa3JnR0Za?=
 =?utf-8?B?ckYxcUZ5cm9RTUhETGJsd0Njd28vSzNiM0lrTVl6Y3YrMHZkQXpibXBFY0Mv?=
 =?utf-8?Q?YC294T+OJkA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR0102MB3414.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c2xCRG0zWFZuQXU4TzlsbTFwS3dtK1B3Mmt0UXlQR2oxaEwxMnl1N0YxU20z?=
 =?utf-8?B?T1lFMFdIenltTC9pcHVaUkRQdnpzMTcwejRsSis0aHJtUW05WFB0VGFBbzdQ?=
 =?utf-8?B?NDZ2b295TkNROC9lNDJnL1pKd2dnQWdORnVUWUUrSzBoL0Evd2ZRZ1V3OGlU?=
 =?utf-8?B?Y0tjcTk3SzgrcFNOa05VWHB3TGp0K1JZd1RjbGVoRkhJUW1laWswQ001bUNR?=
 =?utf-8?B?bm0zZEhpQkJ6WWRkV0lmclZSWGNBMzlNL0p0RTQzbmFHQkNpT2tCVFBjOVlv?=
 =?utf-8?B?ZkpNTzJDeGZ2YW9EaGphUGJnYkliMDRrQmh0STZzdmRGc0hETm16TW5qVVAx?=
 =?utf-8?B?OG9HYWtTSVcxLzJZbGhnVmRjdnRvTEdmYi9ESVNyWFJycmFVSnJac3hUTVB1?=
 =?utf-8?B?cHN6U0g1R3J3QmNjSUlrYUZORmVvL3hNZjZ0c2lSaDBqN0FYc3U1eTBuRDl4?=
 =?utf-8?B?YkcrSkE1cVpSblVjUzJWbUVLcEhTMWdpRWx4Ni84UTNlWlAyeTlFY2pyRDg2?=
 =?utf-8?B?dkNmeW52bXNkZHFOb3ZDdmFQelRsdFFOQzdGL2RENEhQK3VWNXFLbjl1MW1G?=
 =?utf-8?B?VkRMZTQ3RXg1bWR1MS9NVmUxZkExQTk2S29kQ0RDKzJBL2pSWXpBbFZxbFcx?=
 =?utf-8?B?RFhjZG1mdndjRjU3R3laeURZYVFGakp0NEhWREZVZ0Z6TGNOdFJQakxjSnJ2?=
 =?utf-8?B?emZDakh4VE85aVU0VkowZ3J1WXZ4SWROaEdkc0dMNlppWUxpL0NSK0tsNlky?=
 =?utf-8?B?VnZJWUp3YWM1dUg3NXBPMkF0NzJqL1dUS21BTnpOb01CZERJYnFnWXJTOGw1?=
 =?utf-8?B?b3V3bStsTTJHc0lTc1g4OG1LMXByOWVYOFVJd25rMEVvaTJhdG9IKzhkR3pM?=
 =?utf-8?B?TGE2MGdVUGNDQ25RNWhSUUl3WEtoclBCVmxVTE1kNTlrTjdyN1Q0SWdTNnVk?=
 =?utf-8?B?VUNYMFpFM2p4UFBlS3FVZnZuRmZWaHZKL2k5TXN5akRaRjE5K3l0VXNsRi83?=
 =?utf-8?B?cVg1QVV3Q3NXMDRnZHUwM0dOTDhlMVYzRCswZHl6SzdMOWpjbnNVVmpDR0JC?=
 =?utf-8?B?L2NJQ0NaWVJMcHkzWGU4Sk9CRTZ1SHRhb3QzTkRKMWJqb0QxM21hRmU5WlVp?=
 =?utf-8?B?S3YwbUtwMnZoODNaekpIUnhwbGVpZFVSbjFzditxVFlwU3dOMzR0ZXlCNVdT?=
 =?utf-8?B?TmF3OGgzZlNDT3IrZXoxT0h5dkJydUwvbGR6cXlOdHJidDlZTDJLNUk0L2dm?=
 =?utf-8?B?c0VkS2FUbU9KckVJL3R4TmppdnBISDUzS3FYa2p3dWd2QkxSWkRXcExPRndG?=
 =?utf-8?B?YXVYMFczWnR1a3dDTVU5RUw2d0F4NUViczNGa1UvRithek5DbmNCRGNEMmg4?=
 =?utf-8?B?bFlSZFplTG9kKzNleE5tcTlGR3dlajg0WnhkR1VuRkpadEpQOU9OblovTXJa?=
 =?utf-8?B?QzhpbFV4KzdYY0lpcVZpd25PRnlpQ3A4OUszUTlZb3BuMk83eHdSRFp0SGxL?=
 =?utf-8?B?WnhRWXBibDRmTzFMWWF3QUdmNGUrbU9ycVJpUGxGNVVORmNOY2p2cTJ6OUNI?=
 =?utf-8?B?dytwUGlCQVVsWUQrSWJVM1F2NFdZWU52UnRxNnZzUDZybVk3REhEajQyNktk?=
 =?utf-8?B?S1BMbmJrOU1OaDVLU093aDhleDNEYjkvR2k4elYzUlFnZWNRb25BTHhjMk5j?=
 =?utf-8?B?cWZqaFFzNEVYbm9yV2puMnBGVzUxUUduKzhoYlJkTzRmN0pURG9xK1VWT2ls?=
 =?utf-8?B?VERxZ3dXTzVnTkRjTXhnUkdDd0V4U2ZuTG9XZ0ZVSG5ORHJwY2tqaDhzWHJ0?=
 =?utf-8?B?NU9INEdyTmh4N2xmZERCdmhuRTcwV0U2THE0bWhyTW0waGFRTVdQclpLRDN2?=
 =?utf-8?B?V1cvdU96Zzh5Z0ZpeWJQVGJ2TGlIVEFkNlJxOUdzOEFGYnMvV01pUUNlRFpO?=
 =?utf-8?B?M0M1eC9LZ3JxeGdTc2lURnlNNThlaVBWeENXWEI0Rm5JVE5qUWN3NllVRXhG?=
 =?utf-8?B?MG5FYlFuWXIxbmpwL043RE8yZUdXMEphVWhWUVpoTk1XeHR5UGZubmJKYkdv?=
 =?utf-8?B?MVFTVmU1WFFPMTNQbXB5YS9JTHZqRGJlUU0zb2U5VTM1cXppdE9NN0tKZzU3?=
 =?utf-8?Q?1uc/ljRX8Bdl0KIYkrECxycpU?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ac3a865-9479-42c9-00ba-08dde0d21718
X-MS-Exchange-CrossTenant-AuthSource: DM5PR0102MB3414.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 16:45:09.3032
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jFXwiqAsq66t6B3d5oTqAgtchfwEzTVhu7v/4S7ZF5W+K5+gRy7NZpK6HVO72hNu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR01MB9101

On 8/21/2025 5:27 AM, Stefan Metzmacher wrote:
> Already do real negotiation in smb_direct_handle_connect_request()
> where we see the requested initiator_depth and responder_resources
> from the client.
> 
> We should should detect legacy iwarp clients using MPA v1
> with the custom IRD/ORD negotiation.
> 
> We need to send the custom IRD/ORD in big endian,
> but we need to try to let clients with broken requests
> using little endian (older cifs.ko) to work.
> 
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>   fs/smb/server/transport_rdma.c | 101 ++++++++++++++++++++++++++++-----
>   1 file changed, 87 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
> index 5466aa8c39b1..20d1f53ca989 100644
> --- a/fs/smb/server/transport_rdma.c
> +++ b/fs/smb/server/transport_rdma.c
> @@ -153,6 +153,10 @@ struct smb_direct_transport {
>   	struct work_struct	disconnect_work;
>   
>   	bool			negotiation_requested;
> +
> +	bool			legacy_iwarp;
> +	u8			initiator_depth;
> +	u8			responder_resources;

Why are these limited to 255? I could foresee peers requesting large
numbers, or over (very) high latency links. Also, the MPA
protocol extension allows up to 2^14.



>   };
>   
>   #define KSMBD_TRANS(t) ((struct ksmbd_transport *)&((t)->transport))
> @@ -347,6 +351,9 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
>   	t->cm_id = cm_id;
>   	cm_id->context = t;
>   
> +	t->initiator_depth = SMB_DIRECT_CM_INITIATOR_DEPTH;
> +	t->responder_resources = 1;
> +
>   	t->status = SMB_DIRECT_CS_NEW;
>   	init_waitqueue_head(&t->wait_status);
>   
> @@ -1616,21 +1623,21 @@ static int smb_direct_send_negotiate_response(struct smb_direct_transport *t,
>   static int smb_direct_accept_client(struct smb_direct_transport *t)
>   {
>   	struct rdma_conn_param conn_param;
> -	struct ib_port_immutable port_immutable;
> -	u32 ird_ord_hdr[2];
> +	__be32 ird_ord_hdr[2];
>   	int ret;
>   
> +	/*
> +	 * smb_direct_handle_connect_request()
> +	 * already negotiated t->initiator_depth
> +	 * and t->responder_resources
> +	 */
>   	memset(&conn_param, 0, sizeof(conn_param));
> -	conn_param.initiator_depth = min_t(u8, t->cm_id->device->attrs.max_qp_rd_atom,
> -					   SMB_DIRECT_CM_INITIATOR_DEPTH);
> -	conn_param.responder_resources = 0;
> -
> -	t->cm_id->device->ops.get_port_immutable(t->cm_id->device,
> -						 t->cm_id->port_num,
> -						 &port_immutable);
> -	if (port_immutable.core_cap_flags & RDMA_CORE_PORT_IWARP) {
> -		ird_ord_hdr[0] = conn_param.responder_resources;
> -		ird_ord_hdr[1] = 1;
> +	conn_param.initiator_depth = t->initiator_depth;
> +	conn_param.responder_resources = t->responder_resources;
> +
> +	if (t->legacy_iwarp) {
> +		ird_ord_hdr[0] = cpu_to_be32(conn_param.responder_resources);
> +		ird_ord_hdr[1] = cpu_to_be32(conn_param.initiator_depth);

Ditto previous comment.

>   		conn_param.private_data = ird_ord_hdr;
>   		conn_param.private_data_len = sizeof(ird_ord_hdr);
>   	} else {
> @@ -2016,10 +2023,13 @@ static bool rdma_frwr_is_supported(struct ib_device_attr *attrs)
>   	return true;
>   }
>   
> -static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id)
> +static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id,
> +					     struct rdma_cm_event *event)
>   {
>   	struct smb_direct_transport *t;
>   	struct task_struct *handler;
> +	u8 peer_initiator_depth;
> +	u8 peer_responder_resources;

Ditto previous comment.

>   	int ret;
>   
>   	if (!rdma_frwr_is_supported(&new_cm_id->device->attrs)) {
> @@ -2033,6 +2043,69 @@ static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id)
>   	if (!t)
>   		return -ENOMEM;
>   
> +	peer_initiator_depth = event->param.conn.initiator_depth;
> +	peer_responder_resources = event->param.conn.responder_resources;
> +	if (rdma_protocol_iwarp(new_cm_id->device, new_cm_id->port_num) &&
> +	    event->param.conn.private_data_len == 8)
> +	{
> +		/*
> +		 * Legacy clients with only iWarp MPA v1 support
> +		 * need a private blob in order to negotiate
> +		 * the IRD/ORD values.
> +		 */
> +		const __be32 *ird_ord_hdr = event->param.conn.private_data;
> +		u32 ird32 = be32_to_cpu(ird_ord_hdr[0]);
> +		u32 ord32 = be32_to_cpu(ird_ord_hdr[1]);
> +
> +		/*
> +		 * cifs.ko sends the legacy IRD/ORD negotiation
> +		 * event if iWarp MPA v2 was used.

This is very confusing - what "legacy IRD/ORD negotiation"? And, did
you really mean MPA _V2_?

> +		 *
> +		 * Here we check that the values match and only
> +		 * mark the client as legacy if they don't match.


I am troubled by this - if the peer is violating the protocol, we
should not perpetuate it. And if the peer truly meant what it said,
then we've overridden it.


> +		 */
> +		if ((u32)peer_initiator_depth != ird32 ||
> +		    (u32)peer_responder_resources != ord32)
> +		{
> +			/*
> +			 * There are broken clients (old cifs.ko)
> +			 * using little endian and also
> +			 * struct rdma_conn_param only uses u8
> +			 * for initiator_depth and responder_resources,
> +			 * so we truncate the value to U8_MAX.

We should not do this. I presume any such peer worked previously.
Why violate the protocol now???

Tom.

> +			 *
> +			 * smb_direct_accept_client() will then
> +			 * do the real negotiation in order to
> +			 * select the minimum between client and
> +			 * server.
> +			 */
> +			ird32 = min_t(u32, ird32, U8_MAX);
> +			ord32 = min_t(u32, ord32, U8_MAX);
> +
> +			t->legacy_iwarp = true;
> +			peer_initiator_depth = (u8)ird32;
> +			peer_responder_resources = (u8)ord32;
> +		}
> +	}
> +
> +	/*
> +	 * First set what the we as server are able to support
> +	 */
> +	t->initiator_depth = min_t(u8, t->initiator_depth,
> +				   new_cm_id->device->attrs.max_qp_rd_atom);
> +
> +	/*
> +	 * negotiate the value by using the minimum
> +	 * between client and server if the client provided
> +	 * non 0 values.
> +	 */
> +	if (peer_initiator_depth != 0)
> +		t->initiator_depth = min_t(u8, t->initiator_depth,
> +					   peer_initiator_depth);
> +	if (peer_responder_resources != 0)
> +		t->responder_resources = min_t(u8, t->responder_resources,
> +					       peer_responder_resources);
> +
>   	ret = smb_direct_connect(t);
>   	if (ret)
>   		goto out_err;
> @@ -2057,7 +2130,7 @@ static int smb_direct_listen_handler(struct rdma_cm_id *cm_id,
>   {
>   	switch (event->event) {
>   	case RDMA_CM_EVENT_CONNECT_REQUEST: {
> -		int ret = smb_direct_handle_connect_request(cm_id);
> +		int ret = smb_direct_handle_connect_request(cm_id, event);
>   
>   		if (ret) {
>   			pr_err("Can't create transport: %d\n", ret);

