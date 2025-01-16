Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2121.outbound.protection.outlook.com [40.107.223.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26E822D4E6;
	Thu, 16 Jan 2025 18:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.121
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737050580; cv=fail; b=lwexr93Xx/jPyL9wROSS87DjoiY6GFy9WphD4974ClfdCOJlhF2w/0bRKwK5xDsOkmJE2yqfQBGm299L6uol6LTtWIrAUiDcdL6P+fU2wMnRw7Nz7qb6/cK2fEfII0ofTNPcHE1/nBhmFWrpDzcAA6sEmiPVRHD41VqThO74elo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737050580; c=relaxed/simple;
	bh=M2l5MoO0yz5WiTsOxsX24AWLgA7CVWqocdpHdmW2m1A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qe4XnDeEXuUcUaE6SfS4wlRyI9SkoxyE8iEp1+W1b1UZk7mODlT/cWy7d7v2W3QYZvK7ZEJ5qqi7cdQQP4gthqAqCqhBN0CwKJBGneyh/62j9YrjQRabCECphg6W+vE2qFaxlADBH9FovBAagH1vms+jDre/niBsvbX7PjtwvOE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.223.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QnCMj5ZilKvHcvbYYT6W2MJaUtNeoWyNUGHtHO7fb1IkB3AzefnDZsbmoAjLLV7CtwxCaXHCtJA4Kld+M4z5CPZ2NgyMW7qm/94KDlI9pCqAzAiabzSAAPCAWd9YHJ5jPp9sHsholfoPkTyfL4guQF+IvIW19mw2uPJXME6aU568E2mtdq97e7c87pqRjf/E63Hoe8jFbz2FhhWuaparc05hHzdX5+i41wsAn3wh0PrIkP8nJcPzNdL6b3GFJMnStsnfjxmW+Fu9Vyahdy40rOYdEvnylyW43LLwZZp6/QCzMzlb2iIDIOlt+45zM593L1ty4klxl8612lI7QLZc4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LR4o0NbUvvutr9wjADCXFcR5s+Eny9aDxgrukgzrFWA=;
 b=RJH4agwmY2L3qlucd1fiCqDOv/lg6NqYMmP4izhnORVs7o/weaY9fsxOor+Z7+kcadtqstFLz0Db3kJ0xe2KTYfTi9TCw8O67zmMO1bLIlrZ97P7vGJtqFWtBun1brIiDn3zddYSw9uXWG9DO56hKXZ7eWS7WrP7p/rAbQL8VMwXnpxfjyhc/I5zLSTTjxCPZIiUsD76sK/epf2MTBU/os70P91SD9Y52ZNknT7sFOQ8LUdSUimXW9rFjMzpDxZ8e2b0aV/jJFRjrJl+X2L6WS7j2CgSc5osSn15kWxnk5mxnQvWOATnbJ8CEAp2g82Pr3jZQqwaMVztnAygS1YxgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB5246.prod.exchangelabs.com (2603:10b6:805:d8::14) by
 SJ0PR01MB6288.prod.exchangelabs.com (2603:10b6:a03:29a::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.13; Thu, 16 Jan 2025 18:02:56 +0000
Received: from SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90]) by SN6PR01MB5246.prod.exchangelabs.com
 ([fe80::cf18:495f:c6c:ec90%5]) with mapi id 15.20.8356.003; Thu, 16 Jan 2025
 18:02:56 +0000
Message-ID: <80f4901d-1261-4e74-b22e-a205928cf4ad@talpey.com>
Date: Thu, 16 Jan 2025 13:02:51 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: correctly handle ErrorContextData as a
 flexible array
To: Liang Jie <buaajxlj@163.com>, sfrench@samba.org
Cc: pc@manguebit.com, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 bharathsm@microsoft.com, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 Liang Jie <liangjie@lixiang.com>
References: <20250116072948.682402-1-buaajxlj@163.com>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <20250116072948.682402-1-buaajxlj@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR14CA0006.namprd14.prod.outlook.com
 (2603:10b6:208:23e::11) To SN6PR01MB5246.prod.exchangelabs.com
 (2603:10b6:805:d8::14)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB5246:EE_|SJ0PR01MB6288:EE_
X-MS-Office365-Filtering-Correlation-Id: 1932ab2c-c606-465f-a5cf-08dd365800e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YlJiY2w3STRmbUt4ZnhHc1QwY25WU2F2YmhJV3lEektuZVpFb0xUNHV2Vkhv?=
 =?utf-8?B?VE43LzFZem5UTWltOGhsT1JSK3VWNHdPN1ZmRTFsUDFGZ3M4amQ4QTJhMEFK?=
 =?utf-8?B?REloRjd3MnE3UFV3VlArU1E0bGRzRFhpa1JzdU5vN20wODVRNVdCa21la0Nx?=
 =?utf-8?B?S3RqdEtPRC9KeWZlUlFRV0RVT3hNT3N6cFBaaC9FVHBkMHBVSVYyejdRbEJy?=
 =?utf-8?B?TW1wNGZtbmYyeEhvcyt0bUFzNG50ZVM1akNGSlcyNmJZaGNwK2ozM0loSmRt?=
 =?utf-8?B?Qnp4VkpyUWtMVVh3VzRJNk5QY2haYjVTek5UZzJySWZZNFEwSzg1SmQ3UEZr?=
 =?utf-8?B?K2pMTFJrRTNqQm5CMDZnYUYrMktDOUxwQjNlV0RiL3A3WVRJZEVDSW5TZDBS?=
 =?utf-8?B?cTBISDlJby9lYURKa1BxdWR0Q1g3dmJveWszYmpzTytjUWh0RTNvWXJwSUow?=
 =?utf-8?B?cElsOXB0VWNEbU13S1ROZ251RThlLzBXRUwrK1lTdld5OXMvQ0M0bmptNmI3?=
 =?utf-8?B?WDlyeVJHUklDZjF4TjBjSWZuMW5xSUpCQjVUR2RQZDJGMTBoc3l0Q0htTWUz?=
 =?utf-8?B?ay9NNjJLTkw3MEFHR3hCRWk2Mlc0NUxtM3JZazNFdjRIWGhzWHF2cXBJbEl5?=
 =?utf-8?B?L1FxMnFHelM4V2JpbUFnOFdHemNUeXFTakh4TkltdlpSa1JUc21Od0N2NVB2?=
 =?utf-8?B?SmpIZ1ZXQ3dncFg5aGxRVFErRWhaVzdiYWxiY3Vrd3Iyakl4bmdtSHhOeWVI?=
 =?utf-8?B?dWdrZEZLMnRLKzBBbXh4cUo0UC8va2owVWMxZVlSRFp1SUprQkxHdkE5a0Jr?=
 =?utf-8?B?bWk2TzdYYzBFTW5jR3o1T2VvYUpQZTZVKzRpU2JHQkE3ZkhjWGdZRjhtNmVB?=
 =?utf-8?B?bDVWb2UzYXB3SXFzVzRQNG9Ub3NIeEpBeDJwbFdIbllnSkpkeGJ0aWlYVnYx?=
 =?utf-8?B?dGxUdUVJb3M0Q3hveE9aRWFCSERtSXcrbitXV2JWdnpvYXdrbHo3dzlaUXNP?=
 =?utf-8?B?UjRMOGZydnpPcnFkWUJ6UnZ4cytxeDVpNVVlalhvanh3WXFhdk40SCt0ZjNy?=
 =?utf-8?B?Tm9SMzhveThCK0JGdVdUUSs0QnI2U1drZ3dXSGU1R0pnUllsWnJtSHBuUzFD?=
 =?utf-8?B?OEdhcE5ndXFnWW8zUFNsYVF0aHFwRTFOc0o3STJpWGVKSWlyTHhmSkQ4dGdF?=
 =?utf-8?B?YVBDZEcxV1ZkMEJnMFNOcnBXclFDaTJUTkVydWVadGFLS3dyWHZkUFVlQWZm?=
 =?utf-8?B?K1lja0FKcDlMVVhhNGcwRTVDWWNibk5wNkJOUmRRTUNyZG01MHdLMjZqM1R6?=
 =?utf-8?B?bU9wQUZTV2hmTlEvVEJxZU8wRG5WdDROcmhiUlduU1IzWnZTNkJhYWowanJZ?=
 =?utf-8?B?clF1eGVlS1g1RXpLMmNPVDZLcXdXUFZZVWtJSldOV1ZpWUEvMkM1aDdWZWR5?=
 =?utf-8?B?YXlrWnp6aTB6SnIyVm9FNklJN2ZMOStJMjFDenA2NlFBQVFmNFVrZEdRQ3J3?=
 =?utf-8?B?emdQa3FBR2xlS2JkbU1FUVRyOEdLYXZHdVpRSXBrd3B1MXJhVDdKdWtETkhE?=
 =?utf-8?B?aHlYN0pzN2pkOVc4MU1xQUFwUnFNMmYrM0NFTFFOVXNZdW9wWmlnQXdpZ2dF?=
 =?utf-8?B?c2w3amhVWFVHMzlNclRtbHZrTGo2WlNzaFM3UGRvU2ZwaEY2RmlRR2xWWDJw?=
 =?utf-8?B?WThBR1IrTEpWMWlmck1rOEZVM2NHbk9pTE92UVo5d2RpaWVhd2xzdFVuem0x?=
 =?utf-8?B?LzJHQ203cGorVXdMM0ZVZFlxbTNadXBRbE5UdWlKckFUYUg2dmRoVWM2OWR5?=
 =?utf-8?B?MzFIVVJ3aklRUWUrUzExWkZCZzgwU0Zxd0hvWDNmRWRQejFBcWFINWY0MWV0?=
 =?utf-8?Q?Rigp1xMQYzghN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB5246.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NDlwN0xmY1JYR1krU1FnWkVTRlJ6a0ZlQkZ3VkFZMlN4MG0vdUxLWGp3bkFz?=
 =?utf-8?B?WWs2bXlmV0p2WHRaSkhvMU43SnQyckJuZlhLUTNoV0VVTHk3YU41MGh4Yksx?=
 =?utf-8?B?ekdmOHpwTE9IVDVncnVpUjdzbVN5MjVyVVFzQjVIUWNwaWtreXhIbnR3S0lL?=
 =?utf-8?B?YkRGdnZuYmZiaWhIdWFTclFsa0lSSzRTNlh4VUdTVHU1djB6dnpaWXI0cmpC?=
 =?utf-8?B?OXZGUDRVNzdyWi82RHNKeUJoVzJPcjBZNlZXVW12V0tQNkpGR3RaakNnU2M3?=
 =?utf-8?B?Uld5MFdoa0VHTmE0d1RPOUc1a21PSThxK0UyL2FXWlN0Nm9IMlBkM1YwOU5P?=
 =?utf-8?B?bGYvVDUrY2Y3QTB0RTVKaTBtOUlBSkJyRERHbmw2YmlxaVh2dHAvV1Urc24v?=
 =?utf-8?B?a2p2d1c3Y3lYc1FnTE9TbmpwRUNDc1lJVkpsZFRzSUJ3QTlYYjVtSE0wLy90?=
 =?utf-8?B?UjU0bzl2eWtjZE9WR05GS3RSMUluSXRpRjAvV1g2TVRmWWV6U0hFV3pISGlY?=
 =?utf-8?B?RkgrQUpSb3BaTXNZSkRDS2tMb25PbmNMSEtrWGl5ei9QMjRRRVYyeUh3NWZJ?=
 =?utf-8?B?VnJlQ1k1Vy9TNC9FeFZUQU1mQmdpaEd2RWh2OVZQVDV5MnovS0w4dzJXSG44?=
 =?utf-8?B?VmhiTTFBMlpoUGtQTjB2K25JUlF3Mmk4SzlmM3R2NHc1ZHM3UXJuVEdjUXQ3?=
 =?utf-8?B?UVVqTjNoQ0lmbHdrUGdkSHJoaWtIOE82SjVwM2FFUWN3blpUUzRzNkU4WnZ6?=
 =?utf-8?B?dy9mLzZJT0ZZQVJSai9IcFMxeTh2OWFINld3K2szdG01b081N2dZSWRkVWtR?=
 =?utf-8?B?aEkrQk9sdDEwRVZPVU5sRVkzQkMzYVVpbkxhZ2ZlZkZpSlE5RmkvcXFtaEoy?=
 =?utf-8?B?RzhUZ04zREtVTkxYQVZPeXNHSHlYVkFmbnVUM2ZhenQzckRSTHJIcUpFK2Yr?=
 =?utf-8?B?K2ZxZGc3OWp2VTI5dU5LemlMSkkwazd1NVNYZ0pWK0VMd2gwV0Q3dmVseUJD?=
 =?utf-8?B?Ulp0TEpSb1p4Vnl1Z0loNThzNDg3eVFLZHBSU2ZyMjdLK2tmZEo4VHIrMjFK?=
 =?utf-8?B?cHZIS2dRMUtNU3dOdDdFbnVkbDg0eGlib3Bxd3RxTnVNNEFlUWdkbVFOejVp?=
 =?utf-8?B?dnEzYTBKbHFHZTBDNlEzK0ZwcHNUL3ZVNzVuVUtGcmo0OFFHVFNqVVVkb29I?=
 =?utf-8?B?aVN4dkhLcjdrbUI0OFFCSEpXTDMxa1ZQSkg4Ym5jZVVVL0JNbnBZWTkwZGdh?=
 =?utf-8?B?VTFORURkU2ErTmpld1k2YXExUWdpQUNWRDcrRUxRdk9wdHhhMy9CN3B2OXg1?=
 =?utf-8?B?KzVidDN5VVJ4WjFLaEQzN21IbS9KUVBIdmZjMFZ4NGx2Q0prUHU2VmZ4TDBx?=
 =?utf-8?B?SGZiMGxJbnZLZkRBKy9BS3pSOG5Vd0lQK3dGdmVrdSs2UUtMd0FxRGZmY1M0?=
 =?utf-8?B?a0N0cVhFaFA1N05xRHNKSVhRM3JCR2hwVXVxRmdhN09ySmh5RjJadVZZT2dT?=
 =?utf-8?B?ZVRBNFJaa2pkT3FieFRQaFBsUk1IRGVnNEovdjBOWkhYamUzMFhuTGFwanVx?=
 =?utf-8?B?Vk1oY0JhZjkxOTMwam9lSHJRU2wxOEV5ZXUyeStmTWdlWGx5QWYxcHE3UlFR?=
 =?utf-8?B?STkzdlEvSXpSVStKMGNrWjNsY08xY2N0aHNHUU56Z3Q3L3IxWEUrMzZBZ0xa?=
 =?utf-8?B?dWFCTm9uRTZJOTgwS3VJSTl6a2RwVFRIeEM0dW5vcnNlVVBDb25NVHppVWMv?=
 =?utf-8?B?R2I3V3RreFJ2K25qYjBQUC9lZUZSVnR6OTdHRlRCRDkzdFRVMmoxb3JYeEQz?=
 =?utf-8?B?ZnEyZWVrSE9HQ3lQcUN4R3ZGdjd3c1RELzd6dWRDTXJyRjdwWkJ3bHU5bzIx?=
 =?utf-8?B?alVIVHptckhJZGw0ZlFqeTgzVk14NGZLQTh5NEVYWVdQemxtUTVrT3J4YmZa?=
 =?utf-8?B?anhpQkp5aG9BOWo5a0lkU09MbHc1OXlmQnZCMUdXS2lSQndKZmlTSWxQclFV?=
 =?utf-8?B?VXlJU3IvaTBGdVlIRDlnKzMrK09DdG0zaGZFWUwvR2dGUzFOYm52cjczNDZU?=
 =?utf-8?B?SW10MjI1TXFHa2JPeEJDNFZ4Y2hyaTB6eXd1ZE5GTU4za0VXdlR2QWVEem1x?=
 =?utf-8?Q?1P34=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1932ab2c-c606-465f-a5cf-08dd365800e8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB5246.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2025 18:02:55.8229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X0f9cKfQEQaFiqbrt3pjR04HxUshWeyRIwm85Vxl1z5LxCLQ9ikrz9gL5fL/BWx7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB6288

On 1/16/2025 2:29 AM, Liang Jie wrote:
> From: Liang Jie <liangjie@lixiang.com>
> 
> The `smb2_symlink_err_rsp` structure was previously defined with
> `ErrorContextData` as a single `__u8` byte. However, the `ErrorContextData`
> field is intended to be a variable-length array based on `ErrorDataLength`.
> This mismatch leads to incorrect pointer arithmetic and potential memory
> access issues when processing error contexts.
> 
> Updates the `ErrorContextData` field to be a flexible array
> (`__u8 ErrorContextData[]`). Additionally, it modifies the corresponding
> casts in the `symlink_data()` function to properly handle the flexible
> array, ensuring correct memory calculations and data handling.

Is there some reason you didn't also add the __counted_by_le attribute
to reference the ErrorDataLength protocol field?

Tom.

> 
> These changes improve the robustness of SMB2 symlink error processing.
> 
> Signed-off-by: Liang Jie <liangjie@lixiang.com>
> ---
>   fs/smb/client/smb2file.c | 4 ++--
>   fs/smb/client/smb2pdu.h  | 2 +-
>   2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
> index e836bc2193dd..9ec44eab8dbc 100644
> --- a/fs/smb/client/smb2file.c
> +++ b/fs/smb/client/smb2file.c
> @@ -42,14 +42,14 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
>   		end = (struct smb2_error_context_rsp *)((u8 *)err + iov->iov_len);
>   		do {
>   			if (le32_to_cpu(p->ErrorId) == SMB2_ERROR_ID_DEFAULT) {
> -				sym = (struct smb2_symlink_err_rsp *)&p->ErrorContextData;
> +				sym = (struct smb2_symlink_err_rsp *)p->ErrorContextData;
>   				break;
>   			}
>   			cifs_dbg(FYI, "%s: skipping unhandled error context: 0x%x\n",
>   				 __func__, le32_to_cpu(p->ErrorId));
>   
>   			len = ALIGN(le32_to_cpu(p->ErrorDataLength), 8);
> -			p = (struct smb2_error_context_rsp *)((u8 *)&p->ErrorContextData + len);
> +			p = (struct smb2_error_context_rsp *)(p->ErrorContextData + len);
>   		} while (p < end);
>   	} else if (le32_to_cpu(err->ByteCount) >= sizeof(*sym) &&
>   		   iov->iov_len >= SMB2_SYMLINK_STRUCT_SIZE) {
> diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
> index 076d9e83e1a0..ba2696352634 100644
> --- a/fs/smb/client/smb2pdu.h
> +++ b/fs/smb/client/smb2pdu.h
> @@ -79,7 +79,7 @@ struct smb2_symlink_err_rsp {
>   struct smb2_error_context_rsp {
>   	__le32 ErrorDataLength;
>   	__le32 ErrorId;
> -	__u8  ErrorContextData; /* ErrorDataLength long array */
> +	__u8  ErrorContextData[]; /* ErrorDataLength long array */
>   } __packed;
>   
>   /* ErrorId values */

