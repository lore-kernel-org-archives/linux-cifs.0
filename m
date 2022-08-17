Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7C4CC25B08
	for <linux-cifs@archiver.kernel.org>; Wed, 17 Aug 2022 21:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242354AbiHQVQu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 17 Aug 2022 17:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242358AbiHQVQp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 17 Aug 2022 17:16:45 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06275A3466
        for <linux-cifs@vger.kernel.org>; Wed, 17 Aug 2022 14:16:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLGYmKWKCUx8CiSTiU0y8U0g6f2Epgs91Po2pxonzs3lGFpBKEHWiIRKSrAL0EM7qTUBg+mLPN/yAJynJgjvWckCzkNxtyy9F0bEsKs1hbyjCrB7s8uTWbzJEpWPCqSZKwbCoJCwePjdhcbp+CZxfbg5d7k6IJ+AaAmVznPDqIFAV+ODzc3M/gRj7JRckis07thPDFw7AH215BubMEV4AnJv15UqLRVWy08lYZZNTXbg2QE+0F+5JFoyAzrN6s38b1F1jdu5Ib5Yn4WgU4qs6PYOL9j3Y9VWlTHJYq7FjmkwwdTSL4KlE37zGDkbWCKEe8hE4W988xWZZm0psCX/eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kVwWVeQIlOuAHqINqnPz4xL1RLqKRPhQ/UzhMFJzLfw=;
 b=EedbhcgbVll3DRL1WK22uY0ILbaM4PdzNsNJQ+taQkBwkli/TzuPXKICZwXaPDDoJKtoagRO1XAo3bAmguSNPeW4nCGhPzKOgr+0G3k21i1P0EQ4UhHBgMMH9pQInI+RVeAXFLvo+XwEhtaFMiEqly/TawaJhEQuwVpEr0MBmrY6kVA+MLz2I1FOWwaV9X3luN1jn2UlB/LeCV+WKl0eD6h9bYIj0FETxZcgfaF2hND7cINCfN+OmRbWeIEOIKchxDYUTttcGUiilEK3BNSZnZZGgECGk2A8nWA1n/E8tZy82lzfMEYNjJDOD8Pu4MvOWnQPMU45thEMF1miqQB5Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB3798.prod.exchangelabs.com (2603:10b6:a02:90::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.16; Wed, 17 Aug 2022 21:16:38 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5504.028; Wed, 17 Aug 2022
 21:16:38 +0000
Message-ID: <96bdcbe9-0847-e3ec-29e6-0d38fcc11999@talpey.com>
Date:   Wed, 17 Aug 2022 17:16:38 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [PATCH] cifs: remove useless parameter 'is_fsctl' from
 SMB2_ioctl()
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
References: <20220817190834.15137-1-ematsumiya@suse.de>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220817190834.15137-1-ematsumiya@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0376.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::21) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c6b4e08b-ae9e-4aac-4d6c-08da8095c5d6
X-MS-TrafficTypeDiagnostic: BYAPR01MB3798:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U/LxKbYd2FwoaFS+NaJt46vk/vbV5TuRJNrIzbndTJORxEhYRzGV/UTnpsQrgOeAU3s7rvlvKvwVcrE+JkrBPrqVCCnMQbZobxDRZToav1mx2QrmHccOFn5XQeESfjXm+uAlrXi8S25HcBtUc71UfSqcSxi1xiRM0fm4to/hBZM69J7XU1BvvjpjMUtW8NYd4B/OCrYH+nj/cJHZWd3SbTtYDbc52wkFdkejOpX+qir85LQ4kQi9KA5vRfsQAjDNGWKjAifdzig2cyEsKTiANFsDuPk7f3gEB/yd0IL5hAeuRAsQig69Y4ZEy7f4UikL1cDnL9aVgTh8ds5vjlkw4MopdfrH0WOGVLABf5T/CM4z8wx2kZMgz9pjNbXWgz/QDD6ABuZzfKv6+CJSymtgi8Mv1W0qz/Tm1Dxql1SGu7jKR5l89hWTrYrpVbpI6USs2iqL2ehIJ79IGBV5CLPpe8R49lnrCgRFNkahzYH86ryZLVFe5IHOSXXrHeUFF+SobZKUYMFCvPhwrLe6yTIp4WrfrrERG0U4SQ0iY6QoeSJDwYCBUQCt9NuHXQ/EwQGPu3QkDdBmtcOomk3NDIedmcflL5F2DDabY2MXjnMQRs2ZZTkh5AsvEg376Y4IbesqfYvGSfgGYxwPjtAKM3JimADwI7TclOUV3GZityCCK8u4PuLyfmNPdw7BbPh/E9ANppXr0qRZaqc3gtYtGIpTZM0kMz5U4znfvrdMSibqkqLkURkCHCwwqx7wXOD9GDjvaZinrq2cnUt7b1dQrPlzMt1lQq84gO88BeEgVrDNmt8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(376002)(366004)(396003)(39830400003)(30864003)(6512007)(26005)(41300700001)(2906002)(6506007)(52116002)(6486002)(83380400001)(478600001)(53546011)(5660300002)(8936002)(186003)(8676002)(86362001)(4326008)(38100700002)(31696002)(2616005)(38350700002)(31686004)(66476007)(36756003)(66556008)(66946007)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Qmh4WUNHMzRXcUNhL1hpSkhmeTNVS2I4VW9VOWVIM0JrUEpCZ2tCVkxqdHNv?=
 =?utf-8?B?UGFiNnVXcklpOEY5TUZOWkhBVUpKMnBBcWVFdk0rYlhSU1Jzdk1XWGZKMlJR?=
 =?utf-8?B?NnBRT1lEUjlUQi9SZEVUNGp4K1VyWDZTRkx0WjkyRjE4Uk5ac0U3YWpmRTRt?=
 =?utf-8?B?U3FMT3VBNHZtdWtla21MZ2d3OG5jMXV4dno5aGlTTG5KdS9WUFlMZGxPSnE2?=
 =?utf-8?B?TlBVZHE3ZnQ0N01VWUlYVXp6L3ltTXladXk0TWxoNUo2Q05FejNGOTFHRzlk?=
 =?utf-8?B?dFVzUXBUMitJTFcrN1hWbkluUkZnWFMxakhXamZkOGpIMnM4NmJRSmJlZ1lU?=
 =?utf-8?B?VVZUcEtBK1BLOFlRYTlCbElrYzAyVjNWaCtFbkw4ZDZNY1AvSTdSU1pEWUov?=
 =?utf-8?B?WXhBUWRKL0RnWCtITEFIQVNSTGFvK0QweERuT3dtdWs4b3ZkNFhqSitHR1NZ?=
 =?utf-8?B?SHpjN3BQQmx4NEZZT1l4RUdHNWVTTGd6YUo0alRTM0wzSyswU3ZicWFIb2Qz?=
 =?utf-8?B?ODlXSjVHaFA1WWRwNlk1b012a3ZYQkVVekVBcjd4UC8vN2RYQ3U4SXBaOXp5?=
 =?utf-8?B?dm1UN05KT3EyM1RUSEpacTQzTFVJMGhKcTNVV0NsMHBBZDBHY1NSRzhkb3d1?=
 =?utf-8?B?cFZqcnRFeXNVMHVJdXc5NkQzZmVRbGtnekZGbU42dE1QNW0xRW8yL28vMDVP?=
 =?utf-8?B?MmU1U1lCaDQ0NEtGL09ORTY3YjNxL2hhNHRXQXl4MEl6T25BMHlaTWVpVmht?=
 =?utf-8?B?a2VIbFJlNlBWUkhLcDNTQ0dCT1k2dEFYUW5SakQvcVJiajJBcVVkYmEzdTRs?=
 =?utf-8?B?UitVcHE1V3NrSmUvUVluYy9GY3hkK0oyc0lOWlhWWTZqR3pIZ25oQkhiMzVv?=
 =?utf-8?B?YkRaWGE3SGt1WmkrUU1xMWs1VXpFWGZkOE5sM3lHZDF3TXBPS0E4SDZpazJ1?=
 =?utf-8?B?TjQ4Sk1QSTVrQ0k3Z2tOTk9zVUtETzdQRVl2Z2w4ZW50Nis1Z0sxT2RRM2Nt?=
 =?utf-8?B?bXV1aEY0eFAzdHJlZzh0RXVVeU9zYk11UzlxWVhhOWtRd0ZhZFMzMWdkbHg3?=
 =?utf-8?B?dHduQ3lwbjZVQjhDK2ZoR2tENXRMZ3BwNGVHTTNmZDVBYTZ0WE1YeE9rWXR1?=
 =?utf-8?B?eXZZYWc3QS9hK3BNd3hPMFl0TDl1NGdyamdOSmNRV214NEc4MFROYk5RWVND?=
 =?utf-8?B?Y0R6enRFY0RsT1VWdkliaUg1V2FYQ0NhSGcvMzdSMFFpclBwV0lxd0VLUnN5?=
 =?utf-8?B?b0Y4TVIrc3VEazBQdDVaU1RaNm1MOGpiNlR2QmlFR3F0RXlFa0lOZncvUVJs?=
 =?utf-8?B?cVZDdkdEbzBOMkJ3VHNIeFFzdy9RNUhUNmh1V2Y2ZUJ6S0VhdjlUeTVnRUVi?=
 =?utf-8?B?QmFNMEprd0R6aTVLUmMxbW91dGRFT3ljUDc0a2pUQ0Y2dFZXaG4xVUFIN1RF?=
 =?utf-8?B?VEs4Qi9DWDBLeW9PQlhZbGhBT21ZNElHYjg1MUxOdC93MFJlWjV6R3NYcExi?=
 =?utf-8?B?NDFmeFhXNUZrY2QvLzZ0ejgyNEV5WmlVZkpZMUYxd0NCSzFZVU5qNTE0d3px?=
 =?utf-8?B?UU04R2RtQmxhaHphVjg4SG5Md3h6Rzc2amNnMkV3Vm9LeVRWckZuOFpTTjdQ?=
 =?utf-8?B?RVdlT3MxSlNQRU81dnN1YlZjdWN4TFlETi9jcDcwRW9YeW5lY0YvdHVTcmxw?=
 =?utf-8?B?YUdIR0craHQ0aGZKRVY3bUk2R0lUUXNCa3c3a3FsWnlXTllYcnRjOGZKUnRV?=
 =?utf-8?B?ODZ4MUd1dG0vWGJsSDZzdEg4dEkrc0ZzZnR3MkNSdkNsNlB3VkJadi9reU9p?=
 =?utf-8?B?SjZEV0ttLzhjQldhdkJuSHJxbWFFT0ROK0hqdWlXK2t3MkcxdUI0ZHN4SE85?=
 =?utf-8?B?djBlQzlVTHppem1IZVB2M2ZGSngzaTJyZDBpWHI0V2I2ZnFaVnFyenFwb3Zw?=
 =?utf-8?B?VnNZbVNGNTJpdE93R0RzK3Y5c1B3OFI2YUFZNkR4YWpUNFBQSk53dnJKTytk?=
 =?utf-8?B?Wld4TTkvcStlaTdJcktOQ0h3ZHY1allkYkZVa25GMnhxMjRYK0FjZ0FNcDJz?=
 =?utf-8?B?R2E3SXNncFl1N0pSbVNUd2IrdU1tRFpCWW8xOFpzUDBJejJ2Qi9PSUxMZFE5?=
 =?utf-8?Q?H1Bg=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6b4e08b-ae9e-4aac-4d6c-08da8095c5d6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 21:16:38.5859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PTtUSZevYOKwWZvVtogNRULh3qqrpM/GL4IIsSH/Syui+zhe+AlREtPx0+tL5Cxl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB3798
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

It might be worth considering changing the name from SMB2_ioctl()
to be SMB2_fsctl(). Maybe for extra credit, even though there should
be no callers:

int SMB2_ioctl()
{
	return -EOPNOTSUPP;
}

Reviewed-by: Tom Talpey <tom@talpey.com>



On 8/17/2022 3:08 PM, Enzo Matsumiya wrote:
> SMB2_ioctl() is always called with is_fsctl = true, so doesn't make any
> sense to have it at all.
> 
> Thus, always set SMB2_0_IOCTL_IS_FSCTL flag on the request.
> 
> Also, as per MS-SMB2 3.3.5.15 "Receiving an SMB2 IOCTL Request", servers
> must fail the request if the request flags is zero anyway.
> 
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>   fs/cifs/smb2file.c  |  1 -
>   fs/cifs/smb2ops.c   | 35 +++++++++++++----------------------
>   fs/cifs/smb2pdu.c   | 20 +++++++++-----------
>   fs/cifs/smb2proto.h |  4 ++--
>   4 files changed, 24 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
> index f5dcc4940b6d..9dfd2dd612c2 100644
> --- a/fs/cifs/smb2file.c
> +++ b/fs/cifs/smb2file.c
> @@ -61,7 +61,6 @@ smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
>   		nr_ioctl_req.Reserved = 0;
>   		rc = SMB2_ioctl(xid, oparms->tcon, fid->persistent_fid,
>   			fid->volatile_fid, FSCTL_LMR_REQUEST_RESILIENCY,
> -			true /* is_fsctl */,
>   			(char *)&nr_ioctl_req, sizeof(nr_ioctl_req),
>   			CIFSMaxBufSize, NULL, NULL /* no return info */);
>   		if (rc == -EOPNOTSUPP) {
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index f406af596887..c8ada000de7f 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -681,7 +681,7 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon)
>   	struct cifs_ses *ses = tcon->ses;
>   
>   	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
> -			FSCTL_QUERY_NETWORK_INTERFACE_INFO, true /* is_fsctl */,
> +			FSCTL_QUERY_NETWORK_INTERFACE_INFO,
>   			NULL /* no data input */, 0 /* no data input */,
>   			CIFSMaxBufSize, (char **)&out_buf, &ret_data_len);
>   	if (rc == -EOPNOTSUPP) {
> @@ -1323,9 +1323,8 @@ SMB2_request_res_key(const unsigned int xid, struct cifs_tcon *tcon,
>   	struct resume_key_req *res_key;
>   
>   	rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
> -			FSCTL_SRV_REQUEST_RESUME_KEY, true /* is_fsctl */,
> -			NULL, 0 /* no input */, CIFSMaxBufSize,
> -			(char **)&res_key, &ret_data_len);
> +			FSCTL_SRV_REQUEST_RESUME_KEY, NULL, 0 /* no input */,
> +			CIFSMaxBufSize, (char **)&res_key, &ret_data_len);
>   
>   	if (rc == -EOPNOTSUPP) {
>   		pr_warn_once("Server share %s does not support copy range\n", tcon->treeName);
> @@ -1467,7 +1466,7 @@ smb2_ioctl_query_info(const unsigned int xid,
>   		rqst[1].rq_nvec = SMB2_IOCTL_IOV_SIZE;
>   
>   		rc = SMB2_ioctl_init(tcon, server, &rqst[1], COMPOUND_FID, COMPOUND_FID,
> -				     qi.info_type, true, buffer, qi.output_buffer_length,
> +				     qi.info_type, buffer, qi.output_buffer_length,
>   				     CIFSMaxBufSize - MAX_SMB2_CREATE_RESPONSE_SIZE -
>   				     MAX_SMB2_CLOSE_RESPONSE_SIZE);
>   		free_req1_func = SMB2_ioctl_free;
> @@ -1643,9 +1642,8 @@ smb2_copychunk_range(const unsigned int xid,
>   		retbuf = NULL;
>   		rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
>   			trgtfile->fid.volatile_fid, FSCTL_SRV_COPYCHUNK_WRITE,
> -			true /* is_fsctl */, (char *)pcchunk,
> -			sizeof(struct copychunk_ioctl),	CIFSMaxBufSize,
> -			(char **)&retbuf, &ret_data_len);
> +			(char *)pcchunk, sizeof(struct copychunk_ioctl),
> +			CIFSMaxBufSize, (char **)&retbuf, &ret_data_len);
>   		if (rc == 0) {
>   			if (ret_data_len !=
>   					sizeof(struct copychunk_ioctl_rsp)) {
> @@ -1805,7 +1803,6 @@ static bool smb2_set_sparse(const unsigned int xid, struct cifs_tcon *tcon,
>   
>   	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>   			cfile->fid.volatile_fid, FSCTL_SET_SPARSE,
> -			true /* is_fctl */,
>   			&setsparse, 1, CIFSMaxBufSize, NULL, NULL);
>   	if (rc) {
>   		tcon->broken_sparse_sup = true;
> @@ -1888,7 +1885,6 @@ smb2_duplicate_extents(const unsigned int xid,
>   	rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
>   			trgtfile->fid.volatile_fid,
>   			FSCTL_DUPLICATE_EXTENTS_TO_FILE,
> -			true /* is_fsctl */,
>   			(char *)&dup_ext_buf,
>   			sizeof(struct duplicate_extents_to_file),
>   			CIFSMaxBufSize, NULL,
> @@ -1923,7 +1919,6 @@ smb3_set_integrity(const unsigned int xid, struct cifs_tcon *tcon,
>   	return SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>   			cfile->fid.volatile_fid,
>   			FSCTL_SET_INTEGRITY_INFORMATION,
> -			true /* is_fsctl */,
>   			(char *)&integr_info,
>   			sizeof(struct fsctl_set_integrity_information_req),
>   			CIFSMaxBufSize, NULL,
> @@ -1976,7 +1971,6 @@ smb3_enum_snapshots(const unsigned int xid, struct cifs_tcon *tcon,
>   	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>   			cfile->fid.volatile_fid,
>   			FSCTL_SRV_ENUMERATE_SNAPSHOTS,
> -			true /* is_fsctl */,
>   			NULL, 0 /* no input data */, max_response_size,
>   			(char **)&retbuf,
>   			&ret_data_len);
> @@ -2699,7 +2693,6 @@ smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
>   	do {
>   		rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>   				FSCTL_DFS_GET_REFERRALS,
> -				true /* is_fsctl */,
>   				(char *)dfs_req, dfs_req_size, CIFSMaxBufSize,
>   				(char **)&dfs_rsp, &dfs_rsp_size);
>   		if (!is_retryable_error(rc))
> @@ -2906,8 +2899,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
>   
>   	rc = SMB2_ioctl_init(tcon, server,
>   			     &rqst[1], fid.persistent_fid,
> -			     fid.volatile_fid, FSCTL_GET_REPARSE_POINT,
> -			     true /* is_fctl */, NULL, 0,
> +			     fid.volatile_fid, FSCTL_GET_REPARSE_POINT, NULL, 0,
>   			     CIFSMaxBufSize -
>   			     MAX_SMB2_CREATE_RESPONSE_SIZE -
>   			     MAX_SMB2_CLOSE_RESPONSE_SIZE);
> @@ -3087,8 +3079,7 @@ smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
>   
>   	rc = SMB2_ioctl_init(tcon, server,
>   			     &rqst[1], COMPOUND_FID,
> -			     COMPOUND_FID, FSCTL_GET_REPARSE_POINT,
> -			     true /* is_fctl */, NULL, 0,
> +			     COMPOUND_FID, FSCTL_GET_REPARSE_POINT, NULL, 0,
>   			     CIFSMaxBufSize -
>   			     MAX_SMB2_CREATE_RESPONSE_SIZE -
>   			     MAX_SMB2_CLOSE_RESPONSE_SIZE);
> @@ -3358,7 +3349,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
>   	fsctl_buf.BeyondFinalZero = cpu_to_le64(offset + len);
>   
>   	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
> -			cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA, true,
> +			cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
>   			(char *)&fsctl_buf,
>   			sizeof(struct file_zero_data_information),
>   			0, NULL, NULL);
> @@ -3421,7 +3412,7 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
>   
>   	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>   			cfile->fid.volatile_fid, FSCTL_SET_ZERO_DATA,
> -			true /* is_fctl */, (char *)&fsctl_buf,
> +			(char *)&fsctl_buf,
>   			sizeof(struct file_zero_data_information),
>   			CIFSMaxBufSize, NULL, NULL);
>   	free_xid(xid);
> @@ -3481,7 +3472,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
>   	in_data.length = cpu_to_le64(len);
>   	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>   			cfile->fid.volatile_fid,
> -			FSCTL_QUERY_ALLOCATED_RANGES, true,
> +			FSCTL_QUERY_ALLOCATED_RANGES,
>   			(char *)&in_data, sizeof(in_data),
>   			1024 * sizeof(struct file_allocated_range_buffer),
>   			(char **)&out_data, &out_data_len);
> @@ -3802,7 +3793,7 @@ static loff_t smb3_llseek(struct file *file, struct cifs_tcon *tcon, loff_t offs
>   
>   	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>   			cfile->fid.volatile_fid,
> -			FSCTL_QUERY_ALLOCATED_RANGES, true,
> +			FSCTL_QUERY_ALLOCATED_RANGES,
>   			(char *)&in_data, sizeof(in_data),
>   			sizeof(struct file_allocated_range_buffer),
>   			(char **)&out_data, &out_data_len);
> @@ -3862,7 +3853,7 @@ static int smb3_fiemap(struct cifs_tcon *tcon,
>   
>   	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
>   			cfile->fid.volatile_fid,
> -			FSCTL_QUERY_ALLOCATED_RANGES, true,
> +			FSCTL_QUERY_ALLOCATED_RANGES,
>   			(char *)&in_data, sizeof(in_data),
>   			1024 * sizeof(struct file_allocated_range_buffer),
>   			(char **)&out_data, &out_data_len);
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 9b31ea946d45..918152fb8582 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1173,7 +1173,7 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>   	}
>   
>   	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
> -		FSCTL_VALIDATE_NEGOTIATE_INFO, true /* is_fsctl */,
> +		FSCTL_VALIDATE_NEGOTIATE_INFO,
>   		(char *)pneg_inbuf, inbuflen, CIFSMaxBufSize,
>   		(char **)&pneg_rsp, &rsplen);
>   	if (rc == -EOPNOTSUPP) {
> @@ -3056,7 +3056,7 @@ int
>   SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
>   		struct smb_rqst *rqst,
>   		u64 persistent_fid, u64 volatile_fid, u32 opcode,
> -		bool is_fsctl, char *in_data, u32 indatalen,
> +		char *in_data, u32 indatalen,
>   		__u32 max_response_size)
>   {
>   	struct smb2_ioctl_req *req;
> @@ -3131,10 +3131,8 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
>   	req->hdr.CreditCharge =
>   		cpu_to_le16(DIV_ROUND_UP(max(indatalen, max_response_size),
>   					 SMB2_MAX_BUFFER_SIZE));
> -	if (is_fsctl)
> -		req->Flags = cpu_to_le32(SMB2_0_IOCTL_IS_FSCTL);
> -	else
> -		req->Flags = 0;
> +	/* always an FSCTL (for now) */
> +	req->Flags = cpu_to_le32(SMB2_0_IOCTL_IS_FSCTL);
>   
>   	/* validate negotiate request must be signed - see MS-SMB2 3.2.5.5 */
>   	if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO)
> @@ -3161,9 +3159,9 @@ SMB2_ioctl_free(struct smb_rqst *rqst)
>    */
>   int
>   SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
> -	   u64 volatile_fid, u32 opcode, bool is_fsctl,
> -	   char *in_data, u32 indatalen, u32 max_out_data_len,
> -	   char **out_data, u32 *plen /* returned data len */)
> +	   u64 volatile_fid, u32 opcode, char *in_data, u32 indatalen,
> +	   u32 max_out_data_len, char **out_data,
> +	   u32 *plen /* returned data len */)
>   {
>   	struct smb_rqst rqst;
>   	struct smb2_ioctl_rsp *rsp = NULL;
> @@ -3205,7 +3203,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
>   
>   	rc = SMB2_ioctl_init(tcon, server,
>   			     &rqst, persistent_fid, volatile_fid, opcode,
> -			     is_fsctl, in_data, indatalen, max_out_data_len);
> +			     in_data, indatalen, max_out_data_len);
>   	if (rc)
>   		goto ioctl_exit;
>   
> @@ -3297,7 +3295,7 @@ SMB2_set_compression(const unsigned int xid, struct cifs_tcon *tcon,
>   			cpu_to_le16(COMPRESSION_FORMAT_DEFAULT);
>   
>   	rc = SMB2_ioctl(xid, tcon, persistent_fid, volatile_fid,
> -			FSCTL_SET_COMPRESSION, true /* is_fsctl */,
> +			FSCTL_SET_COMPRESSION,
>   			(char *)&fsctl_input /* data input */,
>   			2 /* in data len */, CIFSMaxBufSize /* max out data */,
>   			&ret_data /* out data */, NULL);
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index 51c5bf4a338a..7001317de9dc 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -137,13 +137,13 @@ extern int SMB2_open_init(struct cifs_tcon *tcon,
>   extern void SMB2_open_free(struct smb_rqst *rqst);
>   extern int SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon,
>   		     u64 persistent_fid, u64 volatile_fid, u32 opcode,
> -		     bool is_fsctl, char *in_data, u32 indatalen, u32 maxoutlen,
> +		     char *in_data, u32 indatalen, u32 maxoutlen,
>   		     char **out_data, u32 *plen /* returned data len */);
>   extern int SMB2_ioctl_init(struct cifs_tcon *tcon,
>   			   struct TCP_Server_Info *server,
>   			   struct smb_rqst *rqst,
>   			   u64 persistent_fid, u64 volatile_fid, u32 opcode,
> -			   bool is_fsctl, char *in_data, u32 indatalen,
> +			   char *in_data, u32 indatalen,
>   			   __u32 max_response_size);
>   extern void SMB2_ioctl_free(struct smb_rqst *rqst);
>   extern int SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
