Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2133.outbound.protection.outlook.com [40.107.93.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7637143C62
	for <linux-cifs@vger.kernel.org>; Tue, 21 May 2024 15:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.133
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716304213; cv=fail; b=jMDd7SnuFq0GK45XW914gEToedOOaClj68upsIWDDqR5Ej0GjRCQf4W3j2KOh3W+9dv8i2Coj1L1sMUJ0qySE4VykKGM5p1lEP4Nu4MEgMegS/h2GKpv8cLBFhSpsERznjXbKulxHmPK7c8h3xBRYlwSkT0aieLONTO7Y33DXLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716304213; c=relaxed/simple;
	bh=nTVOXFHpG+iSAE/d05zW7vU2Q696UuY/bKGdgeTz7eA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NMJumP21vxxyp0HbvfA2hv77FKSDqEgHJLN4+8GKhYswjRtYLaHTYMvrYqnCilsocLQiM7ucX6av+zM/V8IYmRsWzU2wLtnqIrL4p35qmmaHpkcBVzqbgACL0kutq2nApTIsCXNOhKbyzs9lVNNOsSREa/uRFflUGXyixeSPXcQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com; spf=pass smtp.mailfrom=talpey.com; arc=fail smtp.client-ip=40.107.93.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=talpey.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=talpey.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgcCvpCHr4N7KJcl8YTkTzPKOebfQp6rbX0ssqabfL9Lyhb8AmT2WQs1KRMbSIm3aghWf61MSS3plgHLv5OdY8MrSP1Qmwj8eOkVea4JG4AcT+cll9S/XWOBseAo91IGzIwcanh5SpH2ElfD2P1p6+BdvKJkKGg7u5TnnP9aPLcwXA3o/RbHk/AWCbJWrrhW5uwOwBtaFOYVyp9bbThZEOq55asG1wrPXtiRVRU4nYCGxnrE8L/NdbbNJoSn3C3o87BiZqA459SvW2Zfts9cKv4TqijJgXdQeIrXiVjA1Gz3AQd5fyNSNpah4h0HGn90T2OFr4MKurOQKmkT9MlV+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LGlQcureo1tlhu5UYJphTiCXR2JYyqv0HFeatynQkfY=;
 b=OyxApDKVOuKlgUV3k6guN7d4grp85qh6dsPecnPC6bBv2+p8Bbn3zSszC/78qFq2LozjzdW1fIzsRC75nEYdQ1HGtV/xgnccdGUSZRby6QEsmKsd0i3kHTzVNT+GpzdACtcO+PaAmKIQdj9M9oiDTaQReyp9IG8mKrMAQ2JW1yTNrnzBu131vo6Mj5Gr6JDunapRFCFhjrBCOztZ+R5RP/fZ0N+qLdldkX70WLWupahr+qFCDO0owuoJR4yL5qdITCBslOeQSlfr40OaFbCd5YTasn4eiTOjtNE/cYuYBD22QIPVampBNYV5dTHnqMLi5Eh+zfb40+Fc0pZ0sf1hXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from CH0PR01MB7170.prod.exchangelabs.com (2603:10b6:610:f8::12) by
 CO1PR01MB6549.prod.exchangelabs.com (2603:10b6:303:f7::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.36; Tue, 21 May 2024 15:10:07 +0000
Received: from CH0PR01MB7170.prod.exchangelabs.com
 ([fe80::97c:561d:465f:8511]) by CH0PR01MB7170.prod.exchangelabs.com
 ([fe80::97c:561d:465f:8511%4]) with mapi id 15.20.7587.035; Tue, 21 May 2024
 15:10:07 +0000
Message-ID: <c67c96ed-c9e6-4689-8f68-d56ddab71708@talpey.com>
Date: Tue, 21 May 2024 11:10:02 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ksmbd: avoid reclaiming expired durable opens by the
 client
To: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, senozhatsky@chromium.org, atteh.mailbox@gmail.com
References: <20240521135753.5108-1-linkinjeon@kernel.org>
Content-Language: en-US
From: Tom Talpey <tom@talpey.com>
In-Reply-To: <20240521135753.5108-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0095.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::10) To CH0PR01MB7170.prod.exchangelabs.com
 (2603:10b6:610:f8::12)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB7170:EE_|CO1PR01MB6549:EE_
X-MS-Office365-Filtering-Correlation-Id: ed234a4a-128c-4fcf-0601-08dc79a819ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R0FLMVloanoxSHAyMkFTelZYdFAvaWZiaXh4Zjl4RHg2YUlKVmFaNVpUd002?=
 =?utf-8?B?czB0bWNGVVVHcmhUWkhBNTBuQ2pnNEhlbWp6Z2pOWU9lNU96TFl0eDM3NzQ3?=
 =?utf-8?B?MVF3Y0JpSms5Ny94YnlpQ1RIVmI0NVhSeDBxY2wxZ3I4MVl5TnVRaFBQVUF4?=
 =?utf-8?B?TENxbG9VQVZaOU1zMFJFdFU4MUVPN2EyWDNwcnVwWFp5djF2ai9jMDZ3eGNq?=
 =?utf-8?B?M2xwVXRYd2dTa21jbmZ1TzNzejcva1RXUGdLVFJOei90alNqY0owcFk2RnFS?=
 =?utf-8?B?VnFOKzlXNjZCWWhiZndTMVh0Qm1YMjRYMzlFS2RnaDJ1RXhkWTZ1YUxmYU1w?=
 =?utf-8?B?UTBsOUYwNUF1M3RDYmRjc0kvQXlxNG40aDBRQ21MeGNBcWFJeFZIZjY2WDNP?=
 =?utf-8?B?aGZyc1BzNjliZ2V6Q2ZxYjZvZUw4WWpyVEdYV3dHR0pGRlZVc0UrczdENy9P?=
 =?utf-8?B?TnY0RTQ4NWU3VHNWUm5OQ3JOVVJ5bllkcnJJTnFFbStQSXZRalhYZEhTZkxy?=
 =?utf-8?B?YlpVM2Jna1M3TFB4Tk8wK3UwdXZuMlN4UW9HcDR0Q05IZzZFYlRvcFduUzVi?=
 =?utf-8?B?c0dHVlQwZWUzMlEzK1QvN2tVMDRobXhnUjQvQVdVMHhVTlhPTGVGOEJvRFh6?=
 =?utf-8?B?V2dXd1J1QnV0eFdUTFVrYzdaZjY5SC81WjhBd2xyV2tKdEVWc0tFbHBhYlMv?=
 =?utf-8?B?K05TcEJxY3FaMU1hTUhLMzFvM1RZVW8wM0RxVHBqckxaQ21PUVpic3RCUFVC?=
 =?utf-8?B?WTcxYjdoMDYwQzJxd2w3eDUrcHpWM3ZaYnV4MHM2dzh6R0JFTU84Zy9jWUZ5?=
 =?utf-8?B?TzhxZ1ZyM25YbXpraHFDc0ljZ29PVkxyTTNzTlV4UW1LV2FUdE5GSkJzSVRl?=
 =?utf-8?B?WklPRkk5Z1dic3puc0g5c09TOU5RMmpxSkpHcDhMaHZ3UDh0SmdHUGtJRmRP?=
 =?utf-8?B?OXBTQW9iZW8yOEtSdE1CemxVa1RwMVB4TElmeW9rVy9ZN2xYK1FrQlRRMTkw?=
 =?utf-8?B?UW85Smh1UmtkMUxRckpiU0R2V09BeU5ZL0Q0YmloTGt1WmhmVDY2c2laTlVH?=
 =?utf-8?B?YWNCQitoaS90dHlPUDdVVjQvaHVmdmJiR0kxWVpmWUowRGZ1cTY2cGtTZW5R?=
 =?utf-8?B?Zi9makg1ME9BdkthKzZZbnNSMGFQOGFId1Yxa1F0bmFVTTZLVURRRlJlZGth?=
 =?utf-8?B?YTJkN1VrTTJVNmRSc1pUZ2tXVDRBdnhqZGtXa2RicjdHN0dCVHlwaDZUcWcw?=
 =?utf-8?B?cXFjai8zMGs0NENwSjBxVjY5dTVmK0Y5aUovQStCczkwZUdUQmRZYVY5M0N4?=
 =?utf-8?B?bzZVeWExRkRBR2dCMVJ1L0RGaGorL1NybjVTblBnZmpIQ29SQmdiUFd4UmFP?=
 =?utf-8?B?UUlVbkQyTExkazY0bE16Q1RJZGVjeGhqRGZQSWlmS1JtY1dtcklvY2ZVelpF?=
 =?utf-8?B?MW8rSTZLZ0hiWC9hdmFZcitNTjVYYWNuaGdzcjhQUkNjRkdIQ3VjM1hxc21a?=
 =?utf-8?B?UXBZWEFJckxPaFNYWUc2VXlKVi8wQ0p4Qjl3N3JYTkY5OS83b3VTRzcyQTA1?=
 =?utf-8?B?STh5REZYRW5kY0FLYmkyM1A0dE01K0s0Sml3Y2xXc2hlSW5ETE9uZlA0M2JG?=
 =?utf-8?B?bG5WdUU4QVhyb3VvN0dKNGVhQ1R2bU13ZnBvb290clFKSXF2QXRTUldwUTFW?=
 =?utf-8?B?aFpVbG5Kb0U0NzVlKytOSDM0QUwySFhrU1RKK0k0ZklKTjB4UkhlMFNBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7170.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d0p3T0ZiTWdIQ0IwZjRoUHpkUTZGVnJmUVMzRm9qWkpiaW1nZTFCQ1FoY283?=
 =?utf-8?B?RHkrNGFGYlZJOXIvLzk5TXRVck1iQVVFc05tUi91VzVXNFdUcUcvTjZFOXR0?=
 =?utf-8?B?dnMydzR2WUlDZHZBWEloeUlHL2MrQitPaUVnSjl4WWJ5VjlxeFVsOVkyaGs4?=
 =?utf-8?B?VW1LOFI0L0g5ckU3NFp1c2RRRUJCc3dhMjFEV1VYSEtIWU1jbVdYeVJ3cDEr?=
 =?utf-8?B?VyttelR1cW8zMHRQYzIrdXcvRXNJYlNHVkNYVHRjKytKRUxSUUtNd2dYZ2VV?=
 =?utf-8?B?OEYzWHI5clh5Z1F3OE9uc0QyZnB2YnhPZ0o2VXdQcjgrVnJ1ZC9mdElDckRz?=
 =?utf-8?B?dHBHQU9nSnUvUVRpTlJRWjhGOUViR3dsNTJBRHZjeUx6ODJkc1RjZTNDWFM2?=
 =?utf-8?B?Mk9ZZWdyTDZvMVRNaXRBWlRPdGRBUStySVpYMklyKzlmZzZGMThwZjNucGYx?=
 =?utf-8?B?WVI1ek13VkJKS1FTQ0gzdEtma0wzTTlCei9UdG1ObERkVnFsL3QzUzZqT2xR?=
 =?utf-8?B?Z3VDTjUwWEM5bGFiSjFyL01YZnhRb0RScjVsUFRHQzM0Z1c5OUxVdWtDY0FW?=
 =?utf-8?B?dXkwa1RWU0dncjdiNlFnQm1NeTN5c2JDSlRXTnlHcUh4YmNJTzFYOUNTdjM0?=
 =?utf-8?B?dmZYYXJ3Vzk0WXM1WFRyS2xTQ1Y3SWNsTW9LSHUzQWc0YUl3dW92N3ZqeS9w?=
 =?utf-8?B?Q3lwMkpVMFJSUWptanhTY3Zrb2VmMVlJSnROaVNna0szaGJ5c1VuTm1FWG5Z?=
 =?utf-8?B?eTl4WXUzT21oZERUWVFBRzVzMWpsblBFK2kyZ2RlVUNja3NFZTRVWEZOL2FJ?=
 =?utf-8?B?b1pNakNLL3NzVDVBRWVrNXRocUdyUm1QZjl2RitDajdZR3dxOURhYnFLaW1I?=
 =?utf-8?B?b3RzcklqNDJZTnZmUlNSNSticVN4akRrMGpyZjlBTjlIQ1RaWDVKbnpZK3Vl?=
 =?utf-8?B?R201WjRlZjBPSUp1WnltczlrdEN6Mm1rcG9GME1UUkNJajJQOTdIcDYzWTVv?=
 =?utf-8?B?WXliVDBjY3V5akhSWThqbjA0WDFiczFScXJKNlhvb0tUTVB4UDZVckI3TERv?=
 =?utf-8?B?bUlMOWoxRHpKR1JiMFNUQWcxaWltZlNuWWpyNEJlUE1tZ25RSHpZT3dVMTZq?=
 =?utf-8?B?Z0xsVWlXTzdRajhocnpLOUZsU2RjU1h6THZRU1ZsUDRHYVhTZ00zb0R1Sy8r?=
 =?utf-8?B?emJSRkpuNVpCK1RLOHlZcnlVOXo5Z0hEOEdwN0sxL3puYVUvcWtONXRPd042?=
 =?utf-8?B?cEVTaUUvdVJzNlhxY2R1NitlQ3MwVFNJT3hPS1MwT3pHdTM4MGd3RGl5QWRn?=
 =?utf-8?B?a1dwbnp0aFlWZjVXV0ZlWGR4Q3RCS2NhN0ttcjFnc1J3YTVMZ1VsUmR3UlpI?=
 =?utf-8?B?V2dnUWRRaUJVakZyVWFpZzJpZ0l4a1lid0NVMzhXdmdwcS9WdkMyQUJXNmZT?=
 =?utf-8?B?VUx0eUVrV3RvVVNaelNxT00xMUZYa1RqQVNhL2dueFkrWklSZENPYWFucEZa?=
 =?utf-8?B?UUE1Y0pOcUMrQ21oRGFxaHV2YjNSYWV2OUY0blEyaDI5Z2p5WjVNdzZPY0pv?=
 =?utf-8?B?eXlkNUVQWEFNTzZkT3Fzck5sZDFRcDVZV2tvc3R2anhMVWNTdHA4TlgwZnJE?=
 =?utf-8?B?RWhiMW45UW1qNG9tQlc5VGV5bTdmSm9qWC9laEttaFFPUU9pNGxtenJmZ0k0?=
 =?utf-8?B?VjUzQUZrbTBCMi9hMHRySVptZVcxeHk1ekpVQzliZ2hEamFwU3pyVDNuTlhC?=
 =?utf-8?B?Rll2dmU3THBzcDUzS3EydmE4RDVnaHlrUGg4Q2pwMkVrMTNmMnp3VlJTM1Ew?=
 =?utf-8?B?WVc1S0RQRnQweEYyY3NpM3NXVjIxeldhQkJna0hYeDNLTlcvUjNWeVRaRktl?=
 =?utf-8?B?TU94aGtMSE84elVFL0ZBYXRtNkliaFBZaTFTOEluVlVERG80UXFMelpSTDFZ?=
 =?utf-8?B?YWFNY21UTDVuWEx4Ymg4UXdrVng4TjJBdHIxYy9LU3VqQ1g3MnlIS3ViN296?=
 =?utf-8?B?b1ErMnJNK1djUGZ4WFRYakU4S0RaeWRrNFJndUJRdXAxRFpEQjUzeUNObHRt?=
 =?utf-8?B?M1h4NnRIVXZtMFZOaWdGUmZod3I3TmNPVG1YUytUdzRZZXZ2M0dWWS9TN0xY?=
 =?utf-8?Q?7T9MU9coFtmrIaCvC6rzltITY?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed234a4a-128c-4fcf-0601-08dc79a819ab
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7170.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2024 15:10:07.3409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M/yK/Im9yxyf4jVmmDD0oUZOa6SlGn7N8SUs1Ne0p7xH8e1Z9QxTH3PT+FphB2hD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR01MB6549

On 5/21/2024 9:57 AM, Namjae Jeon wrote:
> The expired durable opens should not be reclaimed by client.
> This patch add ->durable_scavenger_timeout to fp and check it in
> ksmbd_lookup_durable_fd().
> 
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/smb/server/vfs_cache.c | 9 ++++++++-
>   fs/smb/server/vfs_cache.h | 1 +
>   2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
> index 6cb599cd287e..a6804545db28 100644
> --- a/fs/smb/server/vfs_cache.c
> +++ b/fs/smb/server/vfs_cache.c
> @@ -476,7 +476,10 @@ struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id)
>   	struct ksmbd_file *fp;
>   
>   	fp = __ksmbd_lookup_fd(&global_ft, id);
> -	if (fp && fp->conn) {
> +	if (fp && (fp->conn ||
> +		   (fp->durable_scavenger_timeout &&
> +		    (fp->durable_scavenger_timeout <
> +		     jiffies_to_msecs(jiffies))))) {

Do I understand correctly that this case means the fd is valid,
and only the durable timeout has been exceeded?

If so, I believe it is overly strict behavior. MS-SMB2 specifically
states that the timer is a lower bound:

> 3.3.2.2 Durable Open Scavenger Timer This timer controls the amount
> of time the server keeps a durable handle active after the
> underlying transport connection to the client is lost.<210> The
> server MUST keep the durable handle active for at least this amount
> of time, except in the cases of an oplock break indicated by the
> object store as specified in section 3.3.4.6, administrative actions,
> or resource constraints.
What defect does this patch fix?

Tom.


>   		ksmbd_put_durable_fd(fp);
>   		fp = NULL;
>   	}
> @@ -717,6 +720,10 @@ static bool session_fd_check(struct ksmbd_tree_connect *tcon,
>   	fp->tcon = NULL;
>   	fp->volatile_id = KSMBD_NO_FID;
>   
> +	if (fp->durable_timeout)
> +		fp->durable_scavenger_timeout =
> +			jiffies_to_msecs(jiffies) + fp->durable_timeout;
> +
>   	return true;
>   }
>   
> diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
> index 5a225e7055f1..f2ab1514e81a 100644
> --- a/fs/smb/server/vfs_cache.h
> +++ b/fs/smb/server/vfs_cache.h
> @@ -101,6 +101,7 @@ struct ksmbd_file {
>   	struct list_head		lock_list;
>   
>   	int				durable_timeout;
> +	int				durable_scavenger_timeout;
>   
>   	/* if ls is happening on directory, below is valid*/
>   	struct ksmbd_readdir_data	readdir_data;
