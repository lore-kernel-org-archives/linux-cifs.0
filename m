Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BA7C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 21 Mar 2022 12:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244387AbiCUMMS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 21 Mar 2022 08:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234954AbiCUMMR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 21 Mar 2022 08:12:17 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D44916218E
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 05:10:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRRCK5hm5UI1XXugPwzzIKHKvdxcsbJCzNuQM5em5oP45xkTcDO6FV/QgTVgPOUrxJoIUWzVsnnsk7t4IeuS/VcGbokM1KRyzPWUBdzXj4WrwUp3QvMAWg43CDme2NsFSN73jXTV0RV5E/wyZRJEPzCYva+vx9dnHYVlrNeLYtXDkFNDa/1+XW0WhTarpdmZlkbqdhJLTKK7jiOhEaI/4C8oQHscRY8rFVUB/t8BhT4oa8sgMJhP+s8WZ9gFOyCPN+X/GPlkADRji6OXXcNzY2oG1RRXcQnVD8dNKr8NsrBh28nLKi2qv3Vck1EBlMiUBzwwnj5Gtakl4dXHDGjVQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BYsPYVzbz2EyAhPkbpVcfTRnUyqo/wBnZ1TFUUSmqww=;
 b=bHDsQ0/CwyZ+CUm8T4gQszP+V6kwTsHbfxqGV9zYrrmmW30uO+FC9f7mprHkFil/EXGQEC53Fq31xIA0suSLb8VwMlhfSlTosgHxOQrJOXiVl/1p41JF1UEHlOoYjL+/qYei816oztt77Q6oyn8F2F5DF1vaADbxJLB+5TF88VNpCWhwWVj+kI4K+cz+gx45+LvdwltgoUi8TRV7f210fNgQZleIi8DrXl1N6ra/2hVxqiNx3b8piFnBLUqj1PNNBGdZP5VmlU1FlLOkUiBNdcsdv7vrDqhkEWZ9Xpmqa8Q+6uWbyCHW5Iu3uuW8+JbcwjsiehScChpLQ9i27hWzig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MWHPR01MB2287.prod.exchangelabs.com (2603:10b6:300:27::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.17; Mon, 21 Mar 2022 12:10:50 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d%4]) with mapi id 15.20.5081.023; Mon, 21 Mar 2022
 12:10:50 +0000
Message-ID: <6ef3f7db-a6ed-62c7-226e-b2a20ef5b294@talpey.com>
Date:   Mon, 21 Mar 2022 08:10:47 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] cifs: fix bad fids sent over wire
Content-Language: en-US
To:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
References: <20220321002007.26903-1-pc@cjr.nz>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220321002007.26903-1-pc@cjr.nz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR02CA0005.namprd02.prod.outlook.com
 (2603:10b6:208:fc::18) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf270952-67f5-492e-e28b-08da0b33d6b4
X-MS-TrafficTypeDiagnostic: MWHPR01MB2287:EE_
X-Microsoft-Antispam-PRVS: <MWHPR01MB22871B3C15831E339F098A11D6169@MWHPR01MB2287.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lv5UXzAKH2qe2Uf7Ogo1cdKbQz+B/hvW8hchRww9DqS15pTa9j73DglmSokWuR+meuguOtIronS0JKxFGsXbkuFhvlc6Ba6Zh+Dy0e0x7QRmkzrR8ugt7rvwRq3ALCNrJEa2DeXfv1sE2EPmFnkFB9/r+jwlpEYlrKN94Hf23bL2x5swWmzAdyGnHdm1mLClLQ2vsDF5mf2gr9a8e8y06BIB6Ye3Vzer+SedxRpVs5fV5xCsXBwSilrjad0pLyTy0zMD2KA+D/iyleZ/Y2orOPzlI9olIYW3YdnYnRQumEwDwC3GD9RCnhDlgvz/GkPp47md9citHY88nvWUSFGn1Oi4Y9LUjui2mz1qSYJPoVDwCcptx8ljMs/NquykLn7QrBwGK2D5MicQD6QRo0ITTAgsCQOkMXHX/+uRf5vbpozqZIbXQTLlqOYaDyiT4GozFooi6/xHJwIkAQ9zcmpGIMguX7zUK/1AmgndxsWGgIy459rMxL63uYxoZJl5Sl3R78hRH+RrwqaitBTgmwPiELD7egpkb/bY6lYfKJ5xAgKnGSzaka964LMgKMb3rZEPyLD3+dy6rx48a456Pqabf3HZI6365F/fY2wrK4wJYdVyVY3tjDx81GK/L1zAg9BMTdxt+AqTAkuVDH6qDA2lakRzASOptL4ukP8geUnPjwZDZ2fFok8KH8U7levIEGn9rZ6MrdDRhONcqsMefzjTL8jmVwsvRt1K+iTQUtXBqmU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(346002)(136003)(396003)(376002)(39830400003)(6486002)(508600001)(2906002)(31696002)(83380400001)(66556008)(66946007)(66476007)(8676002)(316002)(86362001)(5660300002)(38350700002)(38100700002)(8936002)(36756003)(186003)(6666004)(26005)(6506007)(31686004)(6512007)(2616005)(52116002)(53546011)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFN6NXh2aFA5SE5UZ0RsUXFZT09ZVVBJOU1ubjI4bC8velk5MHNrOWFIOXA5?=
 =?utf-8?B?YjVHQlZyWENhbGgxdGM4eGpoVEdOMHg5VUl6clJibFd2QWtJemd3a2NDTkt4?=
 =?utf-8?B?bUp1OXZIK2w1ZTdycnJpc3NUQkpoWXI1Q054ek5WZTU1MGNsQWtlN2paQjJ4?=
 =?utf-8?B?c0JPeVQxVGZ6RW14eGx5SWt2TnB0YmJibU54U001YUhhOFJuTUVhUHRZQ1o1?=
 =?utf-8?B?OWpWdEhTVVI3RFZNNmZFam5xcVh4NjRzWUhsZnVGY2tTTWhjbi9TVEtObW5l?=
 =?utf-8?B?bitZN0dNNndRWnp6QlpHNUZEeGxTSjR5eUYzM2pUZTlNY1dTY0RlaUNQaXRu?=
 =?utf-8?B?ZnNtYkpDZUNWTXBtYS8zdXk3cXp0MmM3TnhjTFd4dEIrVHVqelFpR1B3YzlN?=
 =?utf-8?B?VW50b1hneTZZNVJLTk5ySS9obW8yck43SGlLTk9JR0xCNmt3TU1Vb1Z5ekhT?=
 =?utf-8?B?V1FwVzVGd0wyVDJqWmJ3TnEwdENxNmx2ZnY2MEE5aWpHWmlqZlV3b0NXSHFY?=
 =?utf-8?B?VkU1cEdpYnhSbThXQzQ5OExYWEkzam5TMHZvcWwraTNlNEhhRm5KTXY1ZTJP?=
 =?utf-8?B?cEFWWDF5Zlg0VFJ4WVlhU1lId2xKeHcvR2pXdUJnZG1RR2w3aGJ1eENhOXRV?=
 =?utf-8?B?M1VjYUl6WDFlbXQ4Sm5FZzBaWEtYbmNMaHZVTmw3WnhoMVRicDlVUDVOV0h4?=
 =?utf-8?B?dWttZjErSXdqRGNBWWNaNXNjeTNobkgxZVdqekhSZEtzd2ZJUjROcFpqY1ky?=
 =?utf-8?B?eXVZL0xQbnhkZUsxODNwa3RHRWNTOFo5VUw0U2xYajVoc3E0djUvcVN1d24v?=
 =?utf-8?B?OTlHdkdHZldydW5UTEx1bDVreHVOYlFGTVpodmNXRVFEZ1Z1N1Iza3dOb1Q2?=
 =?utf-8?B?aUhRUm1wUHJKUzFKc1huVlZtcStOQTBkVjgzSzhEQkRwbjlXQ1ozRTNwaEJY?=
 =?utf-8?B?b2dDK3BTMUhQNHFTdDQvMUJaOSsxb1NodDR1ckZPVkl6amtHNWtkdlZicEhw?=
 =?utf-8?B?Q0ZSL3ZYV0RhM0xIWkw4VkVVSWo0WG4xQ2cveWU4V215ZTdjT3d3UkdtcVVV?=
 =?utf-8?B?eXBDYVJrRDlmV20zZVNzT0RKM0pSbzNnNVNtL00wM1RKSjBnS0dVaFFNdDkw?=
 =?utf-8?B?ZDlMRCtiSHNsc0NaSnp6NjFtcmgwNk1YaVdRQU5YT21LSGptM1NydjIySlpZ?=
 =?utf-8?B?RnIvdktQTFoyUGRlWkRaNmJicVBwYUtLRnlKeGlkQ05xamR2U0lvYWVYeS84?=
 =?utf-8?B?KzZsRkxURGdObmFEdzZ4c2pTV2F2R0ltYXZ5amFLaTI0bGVnVVV2cXpFMEtS?=
 =?utf-8?B?YStTeUYySTdaTGVVQXhBa3RvUXcxMGw2anR5TGpuZ0pSYjJ0NFM0VXBibkt3?=
 =?utf-8?B?MklQaitqREw5QnU3MStNV2UzU0xNRnllalN4aHRkSFQ1TlZCVnJsNWN3TEJF?=
 =?utf-8?B?Y1NkN1pMaFFUYUJFaFdpR3EyclZBTERSSDN4c3Z0aHdqNng1Tis5dzh0RzZJ?=
 =?utf-8?B?SzRjSXdFQXFxd3RETkhPekNjM3JGM2IzRFFiYkZ0SlFKVU9USGFSSEs3OHgz?=
 =?utf-8?B?Z3FPY09iTXo0Z3ZKek5qdVNOZTdrd3Z1L045Zy9Kb0tyNzY0cmZqMmdwaW13?=
 =?utf-8?B?a0JUL0VodThTRmtkTHVMNGtWWWdXSjJ5N1hwOXV1cWNnSGllS3VMc3dPNFlJ?=
 =?utf-8?B?RU90UHNvaU1OdlNrL3BwcTFpemVvQVdRWGdqazFWU011VFNKTDE3eEo2TmJq?=
 =?utf-8?B?dnR1WTlsc1hyRFhybVAxaHo1cmY0ZVFFSXNuL0pzU3NZblM3S1ZTVXVPaldq?=
 =?utf-8?B?OUl5VnJDbHA4Mk1QR0hIYjJWTVFacll0M2ZYWnpxamMvdzI3K3llSWduaGJ2?=
 =?utf-8?B?Q3FxckFjQ2ExR3I0NmR6OUlxRmt5dTdqYWphd0hZTE1RSk5JbmQzUkRTNEhE?=
 =?utf-8?Q?VQSOT5nw+a0=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf270952-67f5-492e-e28b-08da0b33d6b4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 12:10:50.1637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ae8gn5cdWVIJg5c+qTRpAYexEHZsIiFYUsIiLar2zrgMFl8QsfgaQoKad92X6Vcx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR01MB2287
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 3/20/2022 8:20 PM, Paulo Alcantara wrote:
> The client used to partially convert the fids to le64, while storing
> or sending them by using host endianness.  This broke the client on
> big-endian machines.  Instead of converting them to le64, store them
> verbatim and then avoid byteswapping when sending them over wire.
> 
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>   fs/cifs/smb2misc.c |  4 ++--
>   fs/cifs/smb2ops.c  |  8 +++----
>   fs/cifs/smb2pdu.c  | 53 ++++++++++++++++++++--------------------------
>   3 files changed, 29 insertions(+), 36 deletions(-)
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

This conflicts with the statement "store them verbatim". Because the
rsp->{Persistent,Volatile}FileId fields are u64 (integer) types,
they are not being stored verbatim, they are being manipulated
by the CPU load/store instructions. Storing them into a u8[8]
array is more to the point.

If course, if the rsp structure is purely private to the code, then
the structure element type is similarly private. But a debugger, or
a future structure reference, may once again get it wrong

Are you rejecting the idea of using a byte array?

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
> index 7e7909b1ae11..178af70331f8 100644
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
> @@ -4312,10 +4307,8 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
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
