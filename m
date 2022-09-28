Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF14C04A95
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Sep 2022 15:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbiI1PFO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 11:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234087AbiI1PFN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 11:05:13 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26D724BEC
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 08:05:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gY6oBWLYChsN4je4JX6z5KFBZP2oqhe6m0px6JXkTa2z0bKUNiTPylbngZnBX/2bNPbfhboo9BLjwXuvRJos/h9hLj15AXK3aWqR28cjc2fQoFmka0w/17alu1sot1TIUzLj6NlNnzYdo8pktK72rVIKHmMGd+3qfxI9AwJ1Pt1EuTPN54dXpOieWNavjx3Sxm7XOgNA8G7Fjd3LM0E/30gix6sScJpHk8Y9mZhVjkU83ozNBaobd2zs/+R+2wGOrcnEN8dGl+05TD+Iv42juD5K5p4fzJk6OO2Oj9y5MdHlW/SL1M6xXg6ZRp8MkUjwchdJqVebw0O4NS7ed0YSiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yG5F790Iy2F4iCbgOaaGClETkO5CzsGDuVFIi0nOyUw=;
 b=mB1PGPOBDf+J/2vt+oDU6nECzT8HaM05DWVd8el7RFb/dPfzmUNiAuZn8Ble1u8ertylrOuSiaRqnfuTYatZU/wy10WSM4W2erdMGJZGguBFjCNNVycd6WWlkV2l9cn2vWtOXsL1ApMXJw6Dmk/6ea5eYumEMo/Twi2D9zBetKJelLGGKJwzoBXseg5nyhrEBzPbjA7zhmuhzP2a6xz4USt7J4BTcBC7h0aD+3Ce7lXPxx1xeRqRWUX5jwV1gJNrqmP/pLs5gJMUWOFHG/Aj0mZPUxDuliF3tpVzKP/GTM8oibuZBb/VCfZBLojFORxiQguwfCbMwwJR+Q/mVRhDVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 PH0PR01MB6262.prod.exchangelabs.com (2603:10b6:510:b::10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17; Wed, 28 Sep 2022 15:05:09 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0%3]) with mapi id 15.20.5654.014; Wed, 28 Sep 2022
 15:05:09 +0000
Message-ID: <2cbf804b-a692-ad45-4ec4-4676f15d48f2@talpey.com>
Date:   Wed, 28 Sep 2022 11:05:08 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [RFC PATCH] cifs: fix signature check for error responses
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
References: <20220922223216.4730-1-ematsumiya@suse.de>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220922223216.4730-1-ematsumiya@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR08CA0003.namprd08.prod.outlook.com
 (2603:10b6:208:239::8) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|PH0PR01MB6262:EE_
X-MS-Office365-Filtering-Correlation-Id: b3fbcd81-09b6-427d-6c1b-08daa162d58f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UNhraUswyT6PiboNmR/bTsEGlY6lWizVkwWy/BBlvbxSzoCRVG/S1+dCc6clzKq4jZgjuqJvgTAUdTdj/4OXM2qZCBlQD7JaMukQL9N116eVMslzosZxSR3DDUOsP9s1A47gDOgniFDwmT1hCeNi6cUcP86ulBRvHwkkCwVkaIWjxhIAKZEtBRXTTlM90Dit0g/cmlsB7k71RSqZl0lj6Xpm+6b+hWIcLZ+2w14KuZq3aIYT+3Rz4TYSaD6wjnCTuOP0A3T7ZRI9/D2r5PnECfvmouBpX6kFTnSySYv3vTiCZBIdS6Oom3Idz4zYrQQ2Tbijo3qBs8En4K735oUZiC3zj6HgAWBsr320gdBRBPDA+2WlWY9iJXPJyklE26TFPrrPuD7q8sclEi53TkzKnLmWUqgqVwhzcgADY9aoBIMt3oaGbqZ/f+efGiT+H7k+Ubq5I6e0Zanuus3mUI0vGJQMHC7tRPFS1CXNcjNEXvEaYYOfT4zm21H/uZCfEvGgidrKbB9Ni+uZZGgYqlQhKhyKQE/5a1hgbgzTXlK53Qt6aBgiFzUTd+VAsN/kf+gpMGK/PuaXTw8qGdfMNYYh9Chk/mXnndQrWCgvPaC1r0EX4NqWgvZhKo/uiLfy7w7RMiC7Pz6jPW2CKfxhSJkE4AG/aq0szffcPTIJed+QXfM2emfayEMCEI9tzuDMeQatj6PeuRDuhgY36WRFR/38WFKh5f63f8bVfTgvpBr18DNVCBQZ0CplW3tSi3C8IdS+96Nqms+ZLamxUG/AaB3Ypp/f06ViAQ+KvpVR7oZWi47MRmRz5KfHKVLHX4ydM8Zlgsg19sgq2r6V8vXEvjILOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(376002)(346002)(366004)(396003)(136003)(451199015)(186003)(2616005)(2906002)(31686004)(66476007)(66946007)(8676002)(4326008)(66556008)(41300700001)(36756003)(478600001)(316002)(966005)(86362001)(6486002)(6506007)(31696002)(26005)(6512007)(8936002)(53546011)(52116002)(5660300002)(38100700002)(38350700002)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0F5OHM0dE5FT0ZBdDR0Mm5EdFhrdEJOWG53STd2ZExKMzhZTm84RTgxblUy?=
 =?utf-8?B?Zmt3enpzQnpRSkJRNGRkRHRIYXlLVW50ajE1dDQ5RzZDYjVKVXlnTkNFWTZ4?=
 =?utf-8?B?bHdMOWFnWUhxOGI2S3Vqd2x0WVpBTGJUMUwzek43QkJOWllmSjhNUHUzYzNH?=
 =?utf-8?B?NmZHNUlFekhJdUZ0YnRmamlDSG5ucEFVbGFLWEsrTVJnMG5hUlVycmlEa1la?=
 =?utf-8?B?UUNSUWVuYnVYSkt5UFhTVDdyTExtekRQODZjQVZudUYvLzkrUG9NNGE1ck81?=
 =?utf-8?B?d29nQm4ybXk0VWV0azVVcDNPVGRiM0hBbklyaEI5VU4xeFkyZW1aUFhxU3Ft?=
 =?utf-8?B?bUhJUVpxSENIaWVGYVlNNzFwdmZNNFZJT3A0ZFptcEVHN0Nob1ZXMXhoY3N3?=
 =?utf-8?B?ZjZ3WHBGZGVCYmxzdytMKzBSeG91RS9XR1l6ODBCc2lIVGJKRXhkRXZ3bjNE?=
 =?utf-8?B?Z3lNazlobVZhbWVkdmprTGNvczVCMGVLek9MN0Qxa2NKQWVqRU0wQWo4d0tJ?=
 =?utf-8?B?MDdPY0RwNmlSU3h3L3R5K1p6S25ZRTVxd0JIUWJTcUtMWHZ3MHdqZ0loU3lO?=
 =?utf-8?B?OTNLQklZUVpFNlNaL0lYOE1xWTNBQTFnMEZQYWppYjRQOUYxblFuNTc0aWFq?=
 =?utf-8?B?RXFSNWcvUS9aUENuR1Z5c1hROXFNOFBIcE5zejZOdW5wUE1nOGtNVlY1bnBv?=
 =?utf-8?B?YWxtbHBxMGQ3Slg2L1A2TnRiVlhWQStTcnhlRkdyWXVTdjZVK3d1Q1ozRnZN?=
 =?utf-8?B?SWNWb3k3M3R4MzJkcGxiQndjMlBuWE9WeHpFbDVlUlByekJRTzhpSDQ1OWFG?=
 =?utf-8?B?cGk5Mk5UTjNVZUVWZGIwcnlsUWhPV2lWUUE1eUMySVFiZlBjNFl0eVFCT0M4?=
 =?utf-8?B?OTY2bkRvazZhdDZJSmZ1QTJORnRjdDB0am13bUVmK1ZPZFNEVHlROCtpRmJi?=
 =?utf-8?B?SXNxLzBHY3hZekVGT3Z2OVdJckhZQWRoL2dCc0ZBSDZsbWRMWGt4eUhJLzRB?=
 =?utf-8?B?MSsyNUVzWFZFbE5pcTN2V29qR1IvTEIzYXFrWkdUcjdzSDlkQTRVRUhoVU1B?=
 =?utf-8?B?T25mTGVjbFNTR2RrelZDeFh2ajJyMkpnVVFuQllVRm0xc0JKNjhGbndUUUgy?=
 =?utf-8?B?dU1ZQU5ncGJac1Ztd0tJZWNaY0xkM20vdS9GMzJSS1pCdXZZYTV6eGpEYzRl?=
 =?utf-8?B?dmUwOFpzUEV5RkJNN3B3dUIwOGVkNjEzZFB2OFdqYm5tT0NyRk95OE4vWXFW?=
 =?utf-8?B?WUFsWlBLVVpoQlNYaW5wN1FsdEdsOWhpTVpUbEVUSTR5ajgweUZRaGFUREJL?=
 =?utf-8?B?VGxNdE1LdWFyQlpqZXdBMFh2M3NTeTVTWTFma2FHc2dLc0hmK0s3TVFLOHBw?=
 =?utf-8?B?d3c2Sy9TKzV0dGxLbHNieE44c0xKc3piQzYyYWlRRVlBeXV6TmIyT3Nmc2tu?=
 =?utf-8?B?U2k4alRoMks1emd1UHZCcU5DV1dNVlR0QlN1MFZKNG00OE5TdHpLaHJSRDI0?=
 =?utf-8?B?OXdqWDJFNVl6dVo2WFhDV2daS3BPRzNIMUxGRmNpSkV3QlBoWDhyelBkR29F?=
 =?utf-8?B?YUxkWVhzODFnRis1SVIyK2hYRGt5Y0VWRzFFOUV2NjM0WFJDUXphKytSK2VQ?=
 =?utf-8?B?TWlzNEJ3blhCUEk1THNOZmlBNmEyV1dFUC9RQXh4QnhFUGExaEFzSUhmNjYy?=
 =?utf-8?B?SXA0MTE3UWZ4UlVNWDFGRlc1TUkxSlh0WktVcmNQMDY4amp1Wm40c2VBYThS?=
 =?utf-8?B?Qys4Wnl1N29jZWorOXBuNmtlQkE5aHpNL29xVDZWRWQ5NU5EVlJsdnd6bGVt?=
 =?utf-8?B?dk1DNnc4dHlTN2VQMWRncDF1eU5jOC9vN2lSRnQ3VUI3ZGxlVnc1aDkwaDZ0?=
 =?utf-8?B?YVdObDQ1eFd0bFkwbC80R09RRWFLQ3ZOZTdzZWNpT2V1TjhFRG9CZ3NldkRh?=
 =?utf-8?B?RGp1RnRyVkE2L05hWDlsMUhzZGNZRUxqdEVYMWpRRGRXc3FDUUd0a1BESXhS?=
 =?utf-8?B?NGZ1NG82Wmo2a1FpaG02djdhSHNjN3ZXaHBLWFR0ZldDd1I4WEJPZlN4MWZT?=
 =?utf-8?B?MWI0WExINXhub1UvNmFZOG5hcnhRQXp1YjdZL0szdlhrOURuWEFxUk4reTN6?=
 =?utf-8?Q?MPNteRVvNpE5CD+NMgbOg9dou?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3fbcd81-09b6-427d-6c1b-08daa162d58f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 15:05:08.9878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xWb10lk8MnNwvBQK7TRIK/t8WRlkHLrjy+cERvPtUWxRICWOt9e+Xlt7P5MCSM8G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6262
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/22/2022 6:32 PM, Enzo Matsumiya wrote:
> Hi all,
> 
> This patch is the (apparent) correct way to fix the issues regarding some
> messages with invalid signatures. My previous patch
> https://lore.kernel.org/linux-cifs/20220918235442.2981-1-ematsumiya@suse.de/
> was wrong because a) it covered up the real issue (*), and b) I could never
> again "reproduce" the "race" -- I had other patches in place when I tested it,
> and (thus?) the system memory was not in "pristine" conditions, so it's very
> likely that there's no race at all.
> 
> (*) Thanks a lot to Tom Talpey for pointing me to the right direction here.
> 
> Since it sucks to be wrong twice, I'm sending this one as RFC because I
> wanted to confirm some things:
> 
>    1) Can I rely on the fact that status != STATUS_SUCCESS means no variable
>       data in the message?  I could only infer from the spec, but not really
>       confirm.

Technically, I think the answer is "no" but practically speaking maybe
"yes".

Not all errors are actually errors however, e.g. STOPPED_ON_SYMLINK and
the additional error contexts which accompany it. We definitely don't
want to skip validation of those.

There's also STATUS_PENDING, but that's special because it isn't actually
a response, it's just a "hang on I'm busy" that carries no other
data.

Finally, MS-SMB2 lists a few others in section 2.2.2.2, all of which
need validation I think.

>    2) (probably only in async cases) When the signature fails, for whatever
>       reason, we don't take any action.  This doesn't seem right IMHO,
>       e.g. if the message is spoofed, we show a warning that the signatures
>       doesn't match, but I would expect at least for the operation to stop,
>       or maybe even a complete dis/reconnect.

I don't think so. The spec calls for dropping the message, and after
all it could have been simple packet corruption. The retries will sort
it out.

Absolutely positively do not print a message for each received packet,
good or bad.

>    3) For SMB1, I couldn't really use generic/465 as a real confirmation for
>       this because it says "O_DIRECT is not supported".  From reading the
>       code and 'man mount.cifs' I understood that this is supported, so what
>       gives?  Worth noting that I don't follow/use/test SMB1 too much.
>       The patch does work for other cases I tried though.

Honestly, I don't think we care. No amount of patching can possibly
save SMB1.

Tom.

> I hope someone can address my questions/concerts above, and please let me
> know if the patch is technically and semantically correct.
> 
> Patch follows.
> 
> 
> Enzo
> 
> --------
> When verifying a response's signature, the computation will go through
> the iov buffer (header + response structs) and the over the page data, to
> verify any dynamic data appended to the message (usually on an SMB2 READ
> response).
> 
> When the response is an error, however, specifically on async reads,
> the page data is allocated before receiving the expected data.  Being
> "valid" data (from the signature computation POV; non-NULL, >0 pages),
> it's included in the parsing and generates an invalid signature for the
> message.
> 
> Fix this by checking if the status is non-zero, and skip the page data
> if it is.  The issue happens in all protocol versions, and this fix
> applies to all.
> 
> This issue can be observed with xfstests generic/465.
> 
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>   fs/cifs/cifsencrypt.c | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
> 
> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> index 46f5718754f9..e3260bb436b3 100644
> --- a/fs/cifs/cifsencrypt.c
> +++ b/fs/cifs/cifsencrypt.c
> @@ -32,15 +32,28 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
>   	int rc;
>   	struct kvec *iov = rqst->rq_iov;
>   	int n_vec = rqst->rq_nvec;
> +	bool has_error = false;
>   
>   	/* iov[0] is actual data and not the rfc1002 length for SMB2+ */
>   	if (!is_smb1(server)) {
> +		struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
> +
>   		if (iov[0].iov_len <= 4)
>   			return -EIO;
> +
> +		if (shdr->Status != 0)
> +			has_error = true;
> +
>   		i = 0;
>   	} else {
> +		struct smb_hdr *hdr = (struct smb_hdr *)iov[1].iov_base;
> +
>   		if (n_vec < 2 || iov[0].iov_len != 4)
>   			return -EIO;
> +
> +		if (hdr->Status.CifsError != 0)
> +			has_error = true;
> +
>   		i = 1; /* skip rfc1002 length */
>   	}
>   
> @@ -61,6 +74,9 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
>   		}
>   	}
>   
> +	if (has_error)
> +		goto out_final;
> +
>   	/* now hash over the rq_pages array */
>   	for (i = 0; i < rqst->rq_npages; i++) {
>   		void *kaddr;
> @@ -81,6 +97,7 @@ int __cifs_calc_signature(struct smb_rqst *rqst,
>   		kunmap(rqst->rq_pages[i]);
>   	}
>   
> +out_final:
>   	rc = crypto_shash_final(shash, signature);
>   	if (rc)
>   		cifs_dbg(VFS, "%s: Could not generate hash\n", __func__);
