Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51DC8C433EF
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Mar 2022 18:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350174AbiCUSel (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Mar 2022 14:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238953AbiCUSek (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Mar 2022 14:34:40 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2049.outbound.protection.outlook.com [40.107.95.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71592FE5A
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 11:33:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nT07QmnV3436S0Ny7GpHm/Cf7gj1MYaZ9TGnzDDCxRp2lepvvRTyrkcl0j07HHLxsIfWK6OqRL1prGR0YHnidgOVX6DIpnScTzxma2bJec2yz+Kd/6s18f+sQOD7XmZf1eIw7TWbpIqJxf+nx+i2Cl79Zwg0Q/0JWUOuU2fgAltE/c34z3a+rFvDwbCKQKftG/pkpk0hW8+4AGT4a1sbUzGpnaqEjv6CIfwDBOWNad6c6QjcVTuZhKxnNSwLYIzWYtuqaZsuiwLdFvVPDFpuAVIsRMuLW1fMODbYvX2VPLfj8XGgFWh9e6I8A6pWf3THt8UsavtCdu218KxP0Cyopg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V6jZrnpOiyS88OzU/uPsxY7o+JgrRPEyP6bOp6LmWL8=;
 b=QodrhPGyaRby6ppuCTl7idy1QZtVYh3zqh2rIkJTAGmF5YQRgZdkZw0G90y3SSzo52t5nqh6o8bJFfY45hVZhMs+fF1ijitAzry5I6N2SKTvZ5MrcR0ocpkpasQbyiCp6kmQ2F7uWDcizUlIbHp3dylqGZU6Nvk4Y4ziKcAFCPsXvcIAwcu649SwA50Z4PWB/vFEjYvB+8yKg+RO82Jl9WFPqvrL0Yj3dOgqbq4smfewn3yjKJHzx8Fw4maA8EvIHTn03zbbD+KFTjShjrYtdBqt1yWxUc8uuygKJzlxY59ncC6dHj5yYLeIMOR6lU+jcRlzE0qX76hBPcuT/Q8iYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BL1PR01MB7819.prod.exchangelabs.com (2603:10b6:208:39b::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.17; Mon, 21 Mar 2022 18:33:10 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d%4]) with mapi id 15.20.5081.023; Mon, 21 Mar 2022
 18:33:10 +0000
Message-ID: <4fae4d1a-b6b0-d212-61fa-a6d6df8f2b6b@talpey.com>
Date:   Mon, 21 Mar 2022 14:33:08 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] cifs: fix bad fids sent over wire
Content-Language: en-US
To:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com, linkinjeon@kernel.org
References: <20220321160826.30814-1-pc@cjr.nz>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220321160826.30814-1-pc@cjr.nz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:208:2d::22) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 954dddf4-c5aa-4b26-0d7b-08da0b694052
X-MS-TrafficTypeDiagnostic: BL1PR01MB7819:EE_
X-Microsoft-Antispam-PRVS: <BL1PR01MB7819642C26C9C11AD777AE52D6169@BL1PR01MB7819.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ONght7FP9dnEe0oaR7TDEYW+QKtrrh3JWXhQqn6GCg524/R47pHhI8I/TXdr3BiXPg4eZQUg8BgF8lCevquG02apUF7ui/QQ62oNfAMSUSDVkiM7TQy/2PKBk9BXGCtdwewQ9X1k7Zb/k7tXGgwBH+smyi2VuspVz3b/CMasNvbPygqTnbMJyDX/b84+iSxnBNr2WnuWeDX5xRQXSZUcVswlSeSkgeO4mbJjJ9Z7uLnlVjBDICBCC5qS7RJMAqILxDAc1mJYG2Hnni6/OA8muAvIOctxT9R3U4byTGw4gEUV9c9PDOPngbjAz6UJkcDNrG1iY4JJnCrQxZWxbhfv3iUmG67MzREnoRtZcJDfmP1M84uUxU1yeyjFj5O20xlDdcoafU01KFahZ82X2nR0gwn3k6e2ukBcfkI+RR7iaN/JokDInssIjV5jC+N6Zd1lI2Kb0VO2XGFxUhPxWvdrRaBzgjch0PPYe2j02CNkQf2/weNQx330BKtj7MTmKj16cojZ+pT2iU89aG/Zw2ezEHv8SM3YUP1VRUC+aQoo+eV+8azoC/mH2m6BaUAUMQJS17zooDmv+RprochQ1UkytpPaFgErbVeXP2KHvyM4rq9hQ4ZFI/czJDrcDGwqPKr/O/sz7YXL8tABzaygN9xkfVO+QqYhHPPXohI5NHTrvKuGBzZqVpbOELeA+Ceu3Ak+SPskyhn/AFcLCO7706oiXI3v1vH8yyjCwwrcwgL+8RU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(376002)(39830400003)(136003)(366004)(396003)(66946007)(8936002)(8676002)(66556008)(36756003)(30864003)(5660300002)(66476007)(38100700002)(316002)(38350700002)(31696002)(86362001)(6486002)(53546011)(2906002)(52116002)(6506007)(6512007)(83380400001)(26005)(2616005)(186003)(31686004)(508600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bUhVZWlFcDN5bnErWnAvWkp1cHdSM0dJMFhZRFduMUN2bjlQd05zYW82NGdY?=
 =?utf-8?B?MkRGbEFuc1E3b05HNER6MzZkcSt3SC9yMlZZclBlcFV6VXNER0prQnVqY21C?=
 =?utf-8?B?TXFoNDNCMDJpMDArY3VmM3IxUUpSbzlZWVJpbXM3T2Q4eHlEWXl0ZWJtTlZi?=
 =?utf-8?B?dlR5djBoZTM1NFAyVUY5WC9nVHBrWlo3dnlHRjdaZnVqSVJ4V3dmV2poWU92?=
 =?utf-8?B?dE1FZW8xbDVVOHFtM0xDdDUwRk5jcnFwT2hXRTc3cEx4SlBvaURObmJBY2t4?=
 =?utf-8?B?Nzl2UVNWRVZaaXF1cytHRGwvbWIzT25hMTdTWHRpenlycXRKLzgrUFp1WGdL?=
 =?utf-8?B?TDBsWUZSWHQ1WlB1SjJzSVIzYml1NzdOaSt5YmVwN1VWcGpqVVh3dSt5d0hU?=
 =?utf-8?B?ZHllT0ZBejlwNk9DaENsS2Jta2VNdUtSeXBOUkNrZ0IyR1J0RnVwQW91aEE3?=
 =?utf-8?B?clVTbE1IWFdPZjRncEJPOUhmeWYycFJsM1p5TEtKSUlwZDMwaXlXZ1N6WUpw?=
 =?utf-8?B?WWg4cHRyaU16SXBOTVZMUDNUdVNZRnBhYlAxNUpjazI5QmtiUWc1Zy9xa0ZH?=
 =?utf-8?B?YzRPZ2NHQWpzN1lqUUtGT0RFSkJvemN1WHdaWnlYT2dnYTREdnZSRjUwT1d6?=
 =?utf-8?B?ZTIwNmlrOGpuQ0VrNHE3dVFJZnE0M3hjSzBwaEpsdTBCcnUrWFdSR2tsZ3FW?=
 =?utf-8?B?eG5qQVNwS0o3Q1Z1TnF3bzd1TnRBdGxkbXBod0tJeklNVTFSWHY4TnJMYndx?=
 =?utf-8?B?Mzg2aWRNRFc0VnAvRkZiZFlHc1lWanBXOE5ENFJwaHBxZkVxbVhPQTNBbUxr?=
 =?utf-8?B?YXV5ZjBLQkZVeXNpelU4U1pvbGM5eUw0OXFjVks5Z3pvdllmU2xUK3lEcnJT?=
 =?utf-8?B?QUNUdzdxTWlUdnY5QnEzN3A0S0ZNUjlXTnlBcnpqOGEzYXp5aFNSdWxXU1B5?=
 =?utf-8?B?dDR5YmVuOUF4VlFucjZRalpNdldYdDJUcXJWSEdHSlZQQnphdmZyT3NRamh5?=
 =?utf-8?B?Mm1OL1NUZzdtWStuZ0hWRVVWQjNrbDREam5HQkYvbi9DMk9sWFQ4eUdJV3Uz?=
 =?utf-8?B?VkFFTlpTUlNMK0dYZ2JwQldSZ3B3d0J2ME9Zc2txTzJCVEdycEVpaG5CL0xl?=
 =?utf-8?B?bnBJMkhiWU14elJydXpWWVlzZGQ5RWs3ZUtEbnNERC82MCtrNEFiR1UvQjF1?=
 =?utf-8?B?NWRHOGxXTFhwTGdmR0wvcTREbEpLUXA1M1RYUE1LWnc3WWlPV2VibnNWZmVZ?=
 =?utf-8?B?MVNIRndpMWJzZDF1NWIwRTYzWWxabXBTbHdsRllVQ0ZrSkEwVlFxQm5PaG5v?=
 =?utf-8?B?M3Z5azhOdTZpd3p1dEQyZUUrZGwzVWU4Q1dFWFJkd052Q09sTmJsYk13U0Rx?=
 =?utf-8?B?eENpUVExRXMvVCtWTUVpUzZKNnBKMTBFQm1qejV3ZlYxQ0p3d3g1S3Jsckdh?=
 =?utf-8?B?di96dE9jRFIyQVRjQWx2ZEpYR3dVcDN3WUx4NlNCSFV1bWhPcXJEb2V4eUNI?=
 =?utf-8?B?VlhZeCtaZnZmb0NkZk5MdElFZ2p4MDBVTTF2bUVZWko5OGZpbGtMZ0hrVnBI?=
 =?utf-8?B?UGdGd3N0MUY2M05ZWFJyVVJhaFFNSmtBTnBRaUdiaFpqYmE1NGRMeSt3bGo2?=
 =?utf-8?B?N2NGVDQ2ODNXbklHWkpVbHZMaWZ5ZWo2ejlJVmJxakpOd0dHN1pxOE40Z01T?=
 =?utf-8?B?Z081SEx6WExidFRYUnk2cDM5ZDVVemVpVmFRcitNM3ZaRzMxdEFSNUw1T2ZQ?=
 =?utf-8?B?cGUybHRKa0htQ3c1OCtrb1laVGJNNnhwMjVUSElaNVlXVEVobVE0dXVXSmZI?=
 =?utf-8?B?ampFZWRKUkFWTGlVV2VXbERNQ21iSlhsMG1rcmlzam5VTFVxRTkrY3VIcmhy?=
 =?utf-8?B?WVJ0SnZMUDR6VXZpcmFBRFl5TmlOYmtUMlZ6SGRhYXNIcG0zYWFGemozQ0x5?=
 =?utf-8?Q?MG/kbH1PrKCYQ57YjNV5V2jClnUdP+g/?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 954dddf4-c5aa-4b26-0d7b-08da0b694052
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 18:33:10.6655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5dQYwFjz0vJDAdxrM+/qJE/L7kC6P159TYBf/Bzn+kejNhv1AiL0Sa3ZYexAXM1v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR01MB7819
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I agree this is the most practical way to address the issue, and
any potential static checker warnings.

Have you tested on both endian clients I assume? Might be tricky
to catch all the ops/cases, especially that cancel.

Reviewed-By: Tom Talpey <tom@talpey.com>

On 3/21/2022 12:08 PM, Paulo Alcantara wrote:
> The client used to partially convert the fids to le64, while storing
> or sending them by using host endianness.  This broke the client on
> big-endian machines.  Instead of converting them to le64, store them
> as opaque integers and then avoid byteswapping when sending them over
> wire.
> 
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>   fs/cifs/smb2misc.c        |  4 +--
>   fs/cifs/smb2ops.c         |  8 ++---
>   fs/cifs/smb2pdu.c         | 63 +++++++++++++++++----------------------
>   fs/smbfs_common/smb2pdu.h | 24 +++++++--------
>   4 files changed, 46 insertions(+), 53 deletions(-)
> 
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index b25623e3fe3d..3b7c636be377 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -832,8 +832,8 @@ smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_Server_Info *serve
>   	rc = __smb2_handle_cancelled_cmd(tcon,
>   					 le16_to_cpu(hdr->Command),
>   					 le64_to_cpu(hdr->MessageId),
> -					 le64_to_cpu(rsp->PersistentFileId),
> -					 le64_to_cpu(rsp->VolatileFileId));
> +					 rsp->PersistentFileId,
> +					 rsp->VolatileFileId);
>   	if (rc)
>   		cifs_put_tcon(tcon);
>   
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 0ecd6e1832a1..c122530e5043 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -900,8 +900,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
>   	atomic_inc(&tcon->num_remote_opens);
>   
>   	o_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
> -	oparms.fid->persistent_fid = le64_to_cpu(o_rsp->PersistentFileId);
> -	oparms.fid->volatile_fid = le64_to_cpu(o_rsp->VolatileFileId);
> +	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
> +	oparms.fid->volatile_fid = o_rsp->VolatileFileId;
>   #ifdef CONFIG_CIFS_DEBUG2
>   	oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
>   #endif /* CIFS_DEBUG2 */
> @@ -2410,8 +2410,8 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
>   		cifs_dbg(FYI, "query_dir_first: open failed rc=%d\n", rc);
>   		goto qdf_free;
>   	}
> -	fid->persistent_fid = le64_to_cpu(op_rsp->PersistentFileId);
> -	fid->volatile_fid = le64_to_cpu(op_rsp->VolatileFileId);
> +	fid->persistent_fid = op_rsp->PersistentFileId;
> +	fid->volatile_fid = op_rsp->VolatileFileId;
>   
>   	/* Anything else than ENODATA means a genuine error */
>   	if (rc && rc != -ENODATA) {
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 7e7909b1ae11..7e15b0092243 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2734,13 +2734,10 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
>   		goto err_free_req;
>   	}
>   
> -	trace_smb3_posix_mkdir_done(xid, le64_to_cpu(rsp->PersistentFileId),
> -				    tcon->tid,
> -				    ses->Suid, CREATE_NOT_FILE,
> -				    FILE_WRITE_ATTRIBUTES);
> +	trace_smb3_posix_mkdir_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
> +				    CREATE_NOT_FILE, FILE_WRITE_ATTRIBUTES);
>   
> -	SMB2_close(xid, tcon, le64_to_cpu(rsp->PersistentFileId),
> -		   le64_to_cpu(rsp->VolatileFileId));
> +	SMB2_close(xid, tcon, rsp->PersistentFileId, rsp->VolatileFileId);
>   
>   	/* Eventually save off posix specific response info and timestaps */
>   
> @@ -3009,14 +3006,12 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
>   	} else if (rsp == NULL) /* unlikely to happen, but safer to check */
>   		goto creat_exit;
>   	else
> -		trace_smb3_open_done(xid, le64_to_cpu(rsp->PersistentFileId),
> -				     tcon->tid,
> -				     ses->Suid, oparms->create_options,
> -				     oparms->desired_access);
> +		trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
> +				     oparms->create_options, oparms->desired_access);
>   
>   	atomic_inc(&tcon->num_remote_opens);
> -	oparms->fid->persistent_fid = le64_to_cpu(rsp->PersistentFileId);
> -	oparms->fid->volatile_fid = le64_to_cpu(rsp->VolatileFileId);
> +	oparms->fid->persistent_fid = rsp->PersistentFileId;
> +	oparms->fid->volatile_fid = rsp->VolatileFileId;
>   	oparms->fid->access = oparms->desired_access;
>   #ifdef CONFIG_CIFS_DEBUG2
>   	oparms->fid->mid = le64_to_cpu(rsp->hdr.MessageId);
> @@ -3313,8 +3308,8 @@ SMB2_close_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
>   	if (rc)
>   		return rc;
>   
> -	req->PersistentFileId = cpu_to_le64(persistent_fid);
> -	req->VolatileFileId = cpu_to_le64(volatile_fid);
> +	req->PersistentFileId = persistent_fid;
> +	req->VolatileFileId = volatile_fid;
>   	if (query_attrs)
>   		req->Flags = SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB;
>   	else
> @@ -3677,8 +3672,8 @@ SMB2_notify_init(const unsigned int xid, struct smb_rqst *rqst,
>   	if (rc)
>   		return rc;
>   
> -	req->PersistentFileId = cpu_to_le64(persistent_fid);
> -	req->VolatileFileId = cpu_to_le64(volatile_fid);
> +	req->PersistentFileId = persistent_fid;
> +	req->VolatileFileId = volatile_fid;
>   	/* See note 354 of MS-SMB2, 64K max */
>   	req->OutputBufferLength =
>   		cpu_to_le32(SMB2_MAX_BUFFER_SIZE - MAX_SMB2_HDR_SIZE);
> @@ -3951,8 +3946,8 @@ SMB2_flush_init(const unsigned int xid, struct smb_rqst *rqst,
>   	if (rc)
>   		return rc;
>   
> -	req->PersistentFileId = cpu_to_le64(persistent_fid);
> -	req->VolatileFileId = cpu_to_le64(volatile_fid);
> +	req->PersistentFileId = persistent_fid;
> +	req->VolatileFileId = volatile_fid;
>   
>   	iov[0].iov_base = (char *)req;
>   	iov[0].iov_len = total_len;
> @@ -4033,8 +4028,8 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
>   	shdr = &req->hdr;
>   	shdr->Id.SyncId.ProcessId = cpu_to_le32(io_parms->pid);
>   
> -	req->PersistentFileId = cpu_to_le64(io_parms->persistent_fid);
> -	req->VolatileFileId = cpu_to_le64(io_parms->volatile_fid);
> +	req->PersistentFileId = io_parms->persistent_fid;
> +	req->VolatileFileId = io_parms->volatile_fid;
>   	req->ReadChannelInfoOffset = 0; /* reserved */
>   	req->ReadChannelInfoLength = 0; /* reserved */
>   	req->Channel = 0; /* reserved */
> @@ -4094,8 +4089,8 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
>   			 */
>   			shdr->SessionId = cpu_to_le64(0xFFFFFFFFFFFFFFFF);
>   			shdr->Id.SyncId.TreeId = cpu_to_le32(0xFFFFFFFF);
> -			req->PersistentFileId = cpu_to_le64(0xFFFFFFFFFFFFFFFF);
> -			req->VolatileFileId = cpu_to_le64(0xFFFFFFFFFFFFFFFF);
> +			req->PersistentFileId = (u64)-1;
> +			req->VolatileFileId = (u64)-1;
>   		}
>   	}
>   	if (remaining_bytes > io_parms->length)
> @@ -4307,21 +4302,19 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
>   			cifs_stats_fail_inc(io_parms->tcon, SMB2_READ_HE);
>   			cifs_dbg(VFS, "Send error in read = %d\n", rc);
>   			trace_smb3_read_err(xid,
> -					    le64_to_cpu(req->PersistentFileId),
> +					    req->PersistentFileId,
>   					    io_parms->tcon->tid, ses->Suid,
>   					    io_parms->offset, io_parms->length,
>   					    rc);
>   		} else
> -			trace_smb3_read_done(xid,
> -					     le64_to_cpu(req->PersistentFileId),
> -					     io_parms->tcon->tid, ses->Suid,
> -					     io_parms->offset, 0);
> +			trace_smb3_read_done(xid, req->PersistentFileId, io_parms->tcon->tid,
> +					     ses->Suid, io_parms->offset, 0);
>   		free_rsp_buf(resp_buftype, rsp_iov.iov_base);
>   		cifs_small_buf_release(req);
>   		return rc == -ENODATA ? 0 : rc;
>   	} else
>   		trace_smb3_read_done(xid,
> -				     le64_to_cpu(req->PersistentFileId),
> +				    req->PersistentFileId,
>   				    io_parms->tcon->tid, ses->Suid,
>   				    io_parms->offset, io_parms->length);
>   
> @@ -4463,8 +4456,8 @@ smb2_async_writev(struct cifs_writedata *wdata,
>   	shdr = (struct smb2_hdr *)req;
>   	shdr->Id.SyncId.ProcessId = cpu_to_le32(wdata->cfile->pid);
>   
> -	req->PersistentFileId = cpu_to_le64(wdata->cfile->fid.persistent_fid);
> -	req->VolatileFileId = cpu_to_le64(wdata->cfile->fid.volatile_fid);
> +	req->PersistentFileId = wdata->cfile->fid.persistent_fid;
> +	req->VolatileFileId = wdata->cfile->fid.volatile_fid;
>   	req->WriteChannelInfoOffset = 0;
>   	req->WriteChannelInfoLength = 0;
>   	req->Channel = 0;
> @@ -4562,7 +4555,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
>   
>   	if (rc) {
>   		trace_smb3_write_err(0 /* no xid */,
> -				     le64_to_cpu(req->PersistentFileId),
> +				     req->PersistentFileId,
>   				     tcon->tid, tcon->ses->Suid, wdata->offset,
>   				     wdata->bytes, rc);
>   		kref_put(&wdata->refcount, release);
> @@ -4615,8 +4608,8 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
>   
>   	req->hdr.Id.SyncId.ProcessId = cpu_to_le32(io_parms->pid);
>   
> -	req->PersistentFileId = cpu_to_le64(io_parms->persistent_fid);
> -	req->VolatileFileId = cpu_to_le64(io_parms->volatile_fid);
> +	req->PersistentFileId = io_parms->persistent_fid;
> +	req->VolatileFileId = io_parms->volatile_fid;
>   	req->WriteChannelInfoOffset = 0;
>   	req->WriteChannelInfoLength = 0;
>   	req->Channel = 0;
> @@ -4645,7 +4638,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
>   
>   	if (rc) {
>   		trace_smb3_write_err(xid,
> -				     le64_to_cpu(req->PersistentFileId),
> +				     req->PersistentFileId,
>   				     io_parms->tcon->tid,
>   				     io_parms->tcon->ses->Suid,
>   				     io_parms->offset, io_parms->length, rc);
> @@ -4654,7 +4647,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
>   	} else {
>   		*nbytes = le32_to_cpu(rsp->DataLength);
>   		trace_smb3_write_done(xid,
> -				      le64_to_cpu(req->PersistentFileId),
> +				      req->PersistentFileId,
>   				      io_parms->tcon->tid,
>   				      io_parms->tcon->ses->Suid,
>   				      io_parms->offset, *nbytes);
> diff --git a/fs/smbfs_common/smb2pdu.h b/fs/smbfs_common/smb2pdu.h
> index 38b8fc514860..6653b4be4556 100644
> --- a/fs/smbfs_common/smb2pdu.h
> +++ b/fs/smbfs_common/smb2pdu.h
> @@ -608,8 +608,8 @@ struct smb2_close_req {
>   	__le16 StructureSize;	/* Must be 24 */
>   	__le16 Flags;
>   	__le32 Reserved;
> -	__le64  PersistentFileId; /* opaque endianness */
> -	__le64  VolatileFileId; /* opaque endianness */
> +	__u64  PersistentFileId; /* opaque endianness */
> +	__u64  VolatileFileId; /* opaque endianness */
>   } __packed;
>   
>   /*
> @@ -653,8 +653,8 @@ struct smb2_read_req {
>   	__u8   Flags; /* MBZ unless SMB3.02 or later */
>   	__le32 Length;
>   	__le64 Offset;
> -	__le64  PersistentFileId;
> -	__le64  VolatileFileId;
> +	__u64  PersistentFileId;
> +	__u64  VolatileFileId;
>   	__le32 MinimumCount;
>   	__le32 Channel; /* MBZ except for SMB3 or later */
>   	__le32 RemainingBytes;
> @@ -692,8 +692,8 @@ struct smb2_write_req {
>   	__le16 DataOffset; /* offset from start of SMB2 header to write data */
>   	__le32 Length;
>   	__le64 Offset;
> -	__le64  PersistentFileId; /* opaque endianness */
> -	__le64  VolatileFileId; /* opaque endianness */
> +	__u64  PersistentFileId; /* opaque endianness */
> +	__u64  VolatileFileId; /* opaque endianness */
>   	__le32 Channel; /* MBZ unless SMB3.02 or later */
>   	__le32 RemainingBytes;
>   	__le16 WriteChannelInfoOffset;
> @@ -722,8 +722,8 @@ struct smb2_flush_req {
>   	__le16 StructureSize;	/* Must be 24 */
>   	__le16 Reserved1;
>   	__le32 Reserved2;
> -	__le64  PersistentFileId;
> -	__le64  VolatileFileId;
> +	__u64  PersistentFileId;
> +	__u64  VolatileFileId;
>   } __packed;
>   
>   struct smb2_flush_rsp {
> @@ -769,8 +769,8 @@ struct smb2_change_notify_req {
>   	__le16	StructureSize;
>   	__le16	Flags;
>   	__le32	OutputBufferLength;
> -	__le64	PersistentFileId; /* opaque endianness */
> -	__le64	VolatileFileId; /* opaque endianness */
> +	__u64	PersistentFileId; /* opaque endianness */
> +	__u64	VolatileFileId; /* opaque endianness */
>   	__le32	CompletionFilter;
>   	__u32	Reserved;
>   } __packed;
> @@ -978,8 +978,8 @@ struct smb2_create_rsp {
>   	__le64 EndofFile;
>   	__le32 FileAttributes;
>   	__le32 Reserved2;
> -	__le64  PersistentFileId;
> -	__le64  VolatileFileId;
> +	__u64  PersistentFileId;
> +	__u64  VolatileFileId;
>   	__le32 CreateContextsOffset;
>   	__le32 CreateContextsLength;
>   	__u8   Buffer[1];
