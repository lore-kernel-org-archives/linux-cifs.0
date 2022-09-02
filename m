Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E65C3C38145
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Sep 2022 14:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238774AbiIBOHR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Sep 2022 10:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238881AbiIBOHB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 2 Sep 2022 10:07:01 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0DEEE21
        for <linux-cifs@vger.kernel.org>; Fri,  2 Sep 2022 06:34:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bGpK5nRWXwVCNiQpEAvVCEZPS4SPRDw82sPPRmt+HTnWdrR57IPfEhSLZ0b9rxvkdqgij9J99pwMEHoHRsNPKoWXZvaSnIFN25mbWom6GxtBRAZdDjquSGrcxN0NJIJsLlp5lx8vFAhDTDlO/Bc8/e+QpMqc+arV4KVIR25lAa4jgtXPsuriI5xTO7DFJpOmmmHD9U5kyaeVzFTwHyabG3I6keK7rSnxTtUeRGBOkdyZ83zm8jQ+iH4l163NacRUriol/jjHy9Xy5GFdvuK9bsiGhbSYerbiHTXxka9Dzn5lzQ/oGuKf4mtvPy0be/YWI3hTzpKj/dlvReWGda/brQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LGyg/tUFYXQFTHCSyurfjLw70sbljTE8WNHOSE1NKrM=;
 b=Yf6G1ZfAKe3DYtHqPN9TPjqWRhIvUL3pKMa4j52acnMqn5PTjTsQNw7r4YgJ0aXSARQFO/MsuDB2Wx00ovPPmo6GaBPYtXJfGLM0HON7pHnxg13umrCiTIag0iRtaG90AXZIuPpvL/hbJZ7zMLVDwUAGe2QcOGfIGmGcpOgO92c7eWnfCX5RkW2PaelhnxCG21WA63dWUn4wUyLNcDHR4IV0pVRvnF9bKwfah9N7pG8fxJHAEqXSrWfo267uLPbYH6RI8wtIlu7shFJfOGnz06rmlPc4XL1ir4IvpPiRx5gejlHt9+YCl0CHn4R57ZvZ6BGzp4kdcXa94x/B0yYPug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BYAPR01MB4438.prod.exchangelabs.com (2603:10b6:a03:98::12) by
 SA0PR01MB6203.prod.exchangelabs.com (2603:10b6:806:e0::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.10; Fri, 2 Sep 2022 13:34:48 +0000
Received: from BYAPR01MB4438.prod.exchangelabs.com
 ([fe80::6d1c:4239:2299:c1f6]) by BYAPR01MB4438.prod.exchangelabs.com
 ([fe80::6d1c:4239:2299:c1f6%7]) with mapi id 15.20.5566.021; Fri, 2 Sep 2022
 13:34:48 +0000
Message-ID: <81dc5297-8169-74f1-2e8c-76983b81cdbb@talpey.com>
Date:   Fri, 2 Sep 2022 09:34:46 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v4 5/5] cifs: Refactor dialects in
 validate_negotiate_info_req to variable array
Content-Language: en-US
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com,
        linkinjeon@kernel.org, hyc.lee@gmail.com
References: <20220901142413.3351804-1-zhangxiaoxu5@huawei.com>
 <20220901142413.3351804-6-zhangxiaoxu5@huawei.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220901142413.3351804-6-zhangxiaoxu5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR05CA0016.namprd05.prod.outlook.com
 (2603:10b6:208:36e::22) To BYAPR01MB4438.prod.exchangelabs.com
 (2603:10b6:a03:98::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c01d05bf-7f6d-4601-7246-08da8ce7e810
X-MS-TrafficTypeDiagnostic: SA0PR01MB6203:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bj32K+aQQXC8AQnFP82XZYaOtKf1VdHs2GcBt89mYE9LD2rMCnpjcdrW7cglXo3JxVtjZ30UUQrFTVv9oibRR4hCcKdtSYqSU3yZMyBi9LTHzQBQ2kLspKY3NmOjtI7NJeUA/U3kTJ+u5kMezT9bw2sHNTjthXYvEZLmjagefSdLuUpditYKwXJHGMf5SAOJM8vNv+hh3vlvHbYVENPEeOpPhQIuoiTPz8ZJ5w26HtIUoZPz6Bov3QrJz9YXo61awublae5epcdyUo1oSJ2px03KsMx99kp9ZfDVeMHVqeoCtKNHBz5Dadr7C4/nmsTumkJRsDNNVNYHYvtsz1Z1Wghqibf3FdHnNgrTZgRMsy5wcgkt02iApn9lPO01uLHs+B1KJtokWUIQrplD/jkmjdtRhTYRJxwKRClPrXTAbbkejNvQ1yKjXY3IDXRrxI/JiRPNtsMZysN8kw2eSWo5QGPxu1dS8T1SFC6B+DvelZIgi5pq8oke7sAscVOQX9YvHV6qmg5UoBpALfka5puCkxruth8Cq6vtQO05oBLmBGNLrocByN7bi/KjLk6g3lK44X0ErX7fuL314ir3RXnPyiOZjK6yBVbEzGUDx02XPByFSXuO5Q40Iz0WrKpW7DOcZF5Tw/RwAxVXEGD4yr9eWfua+p+SpASRH1fQQSgV9KyfMtI06t8qDoXdMizaoSK1cZVn7/CrJ35+uoovrWpM6BSnJZukZ26HFJvCXVZF+HSbKyG5e6YTmrPnymNN2FiBaYLiarV8b03J9bSir4W3VlhXPggPDLfzJ62YnvwqUPdaNsHpQWjDPiBirY4J0T0+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB4438.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39830400003)(346002)(366004)(136003)(376002)(2616005)(15650500001)(31686004)(2906002)(36756003)(26005)(6512007)(186003)(66556008)(66476007)(7416002)(8936002)(5660300002)(921005)(8676002)(66946007)(316002)(52116002)(478600001)(41300700001)(6506007)(53546011)(6486002)(38350700002)(38100700002)(86362001)(31696002)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3g1bmhJNnA0LzQ4eksrVSt3SjM5alM2Q05kc3BVUjU5TUpqU3QyMEhqZ2ht?=
 =?utf-8?B?L1lkVWhjcWk0L3AyS2MwNEJZSllLbFNYZ2wvRTZEelcyeFlYdytXOVNMNHZ1?=
 =?utf-8?B?OFM2ZHp2M3NwWjlZZ2oxeTFzWjRpcG45cGNXRllQNkIxbUR3Z1RFQjJ0UVUw?=
 =?utf-8?B?RWdXMG10S2xnTG8rYkc5aEs5c1h2a0hPcGNseExnOXRXbEordTRUeXJDQXp3?=
 =?utf-8?B?V0dvQkdJR2lIdmN4amh2ZWtRTmI5K1VuWXVnckZJamVDdGY3NzZadTBObkhN?=
 =?utf-8?B?LzlpdTJZYjNuMjU5blhHblYzKy9qMGtTZHNGTDN6bFNFeWE1Y1cyVUlENTBs?=
 =?utf-8?B?djFHMkhYbFRwREZ5a3BXMGR4eFRaeVhQMXNwVTFlV1E4RUJ4RFVBZ1krcmtZ?=
 =?utf-8?B?LzB4QWhCYjNURVFzN2pJeHFEc0ZTWG9TNXdlRFBOVlY4bU5OcUE1Q3ZiVDlX?=
 =?utf-8?B?ampQS0tQTURFMzQrbGExOS90MVc3MkJvTG9hL0Y1T1R2Z3FXQTFSNVMzMFhS?=
 =?utf-8?B?ejJ0ZnF6VWxMT1l4RlFiQW1QOXRZVEcrTnpzcUE4Q3VydEFqQ1dGbzVoSWM4?=
 =?utf-8?B?d2EzdGdRaWNrd2RWV2dadFAvdThmSUptUXk1Z1pFVmFETVdhMGhhdVc0dGtI?=
 =?utf-8?B?U0YxQTc4eDdzcXZGTzJhUmkzYnVQNUh3QS9jMXdxcnNSWmNjZTA0ZkwzaWxW?=
 =?utf-8?B?Mm8yWEYzMDB2RzRYYUd3V3o2NG1kcDBmOVdZaFBXc0tZZWhCRWV1dllKbzFk?=
 =?utf-8?B?UG1Ba2U1Q1lLc29VQnhLNjBTUkZ4azMyQ3FsSG9vOUdrYUJncTEvSWJKSGxX?=
 =?utf-8?B?NEF6OStlQ0V4RkZ3a1NKMXY1bXlmc1VoRXByU3pJc0Qya2hqK1QzRHpjQUg3?=
 =?utf-8?B?WVpRejN3TUNxdVBNcm1kbDVDa05iaHIzWEN0c1JkM1BFT1B5NlVIa0gxMFNz?=
 =?utf-8?B?M2kyKzEyaUc3UHlHa201dDJXRUxLRFhLdEFuV3FHTmwzckVlNGNyc1BkQmRy?=
 =?utf-8?B?Nk5tT20vZndyUk1qdUhKYjJEenNnTnUrY0V0L2J5NmFvMHRkUG00cWFxaTdU?=
 =?utf-8?B?eFFtcy9UWjJFRHlDK2Fua2pHK2duQjRUL1NPY1BBS0xhMzJ4U0JTaXZyOVhs?=
 =?utf-8?B?c2xoOXQzcE9WV1Y5SUJESk1JdW5iQ3Rpaml1RVJoSE13cURyU2U3cVIrMnVX?=
 =?utf-8?B?M1h2S3FoeU5rYjA3T3d6Ni9oeEdTZ2I1U0l6WUEwMjQwbUNOZkYxSjZIajhI?=
 =?utf-8?B?ZGxBMTVNcS84Y2gvNVc0Z092L2VQd1EwVVcwSlNFTWxzTy85a05GWVF2dnc5?=
 =?utf-8?B?S3pGZE1kTXVWMWc5T0N4QWQ0RDhHWWJuazBQNzdaeVVyQzJWUmU5WGsyZXpt?=
 =?utf-8?B?NmRORFMwTE5MNTBXZ0NvWWNDTDAzZHg2VUR0Rll5SzdndUR0Tjg3Sk5teTNI?=
 =?utf-8?B?VnJtbThJeS8xcnZGL3dTbGxycldEM0srcExQRjZYNnVCU21RM0luSmp1WTRm?=
 =?utf-8?B?dkVlN01VejAxUWJzakNaVDQwdW9UWXhERG4wbFZVMDNtNnhzN0dxZ0l5TTJT?=
 =?utf-8?B?TEdJYmF5UkkrZnR3dVNJYWVuUXMzNk1sTEZsN280SW5NbDA1dWJ4aVlxWFJp?=
 =?utf-8?B?YkVMVUpOcXRIR2YwT2FKQnh1K2ZXRUljajg3ZkJlS25saS95WWp5NTVDSWpB?=
 =?utf-8?B?QXI5clU1aHhnUjNndFVNV2hqVnNSbGNuc2JNQkNpdk1FaGpLQ1VQWVZ4VTIy?=
 =?utf-8?B?bXZCM0xtU0RGRkl0SFAzWlc3SlRucktBcStHNVpzVlA3cFhnSm1EdDYvM2E2?=
 =?utf-8?B?REhReS9tbUhwWUFMeXBXV2V2bC9QKzV0VFpEYVRzZ0tHSXNCZTNnSEZMdTF3?=
 =?utf-8?B?WEE5QWVLQWJZOFJZU2tKaXV0d0hqd2Y0U3cwSUl1bGRGYk12UHVxbGRCVVp0?=
 =?utf-8?B?alFCanllRlFyb2JyWmFOTVNqdnNOQWh3Q0RTamZwZnhzZXV4TTZnUUFkUnJG?=
 =?utf-8?B?dytXTFVoS2lidlBFWkRxYkdhZVZNMjNXV3lZWTVvaVUxbDBNdDlDM1pkMkNu?=
 =?utf-8?B?NVhWZi9GT2JlOVQ1V3NaMHk4bVNSemp4Z3hDdWFSc3FIM3BNTTQ2RmlEK2hz?=
 =?utf-8?Q?AYqyEMhf8Ry+uLO7hDC3hL66z?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c01d05bf-7f6d-4601-7246-08da8ce7e810
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB4438.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 13:34:48.6791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CwyumlSKwncox1VyjegYyo37s5AGWJ52SCiDSLR1sIBDlCBQ7r0LubssK0ux6JYU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR01MB6203
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/1/2022 10:24 AM, Zhang Xiaoxu wrote:
> The length of the message FSCTL_VALIDATE_NEGOTIATE_INFO is
> depends on the count of the dialects, the dialects count is
> depending on the smb version, so the dialects should be
> variable array.
> 
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> ---
>   fs/cifs/smb2pdu.c         | 7 ++++---
>   fs/ksmbd/smb2pdu.c        | 2 +-
>   fs/smbfs_common/smb2pdu.h | 3 +--
>   3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 1fbb8ccf1ff6..82cd21c26c60 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1105,7 +1105,10 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>   	if (tcon->ses->session_flags & SMB2_SESSION_FLAG_IS_NULL)
>   		cifs_tcon_dbg(VFS, "Unexpected null user (anonymous) auth flag sent by server\n");
>   
> -	pneg_inbuf = kmalloc(sizeof(*pneg_inbuf), GFP_NOFS);
> +	inbuflen = sizeof(*pneg_inbuf) +
> +			sizeof(__le16) * server->vals->neg_dialect_cnt;

Good!

> +
> +	pneg_inbuf = kmalloc(inbuflen, GFP_NOFS);
>   	if (!pneg_inbuf)
>   		return -ENOMEM;
>   
> @@ -1129,8 +1132,6 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>   	pneg_inbuf->DialectCount = cpu_to_le16(server->vals->neg_dialect_cnt);
>   	memcpy(pneg_inbuf->Dialects, server->vals->neg_dialects,
>   		server->vals->neg_dialect_cnt * sizeof(__le16));
> -	inbuflen = offsetof(struct validate_negotiate_info_req, Dialects) +
> -		sizeof(pneg_inbuf->Dialects[0]) * server->vals->neg_dialect_cnt;
>   
>   	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>   		FSCTL_VALIDATE_NEGOTIATE_INFO,
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 7da0ec466887..52a524fd2f3b 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -7392,7 +7392,7 @@ static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,
>   	int ret = 0;
>   	int dialect;
>   
> -	if (in_buf_len < offsetof(struct validate_negotiate_info_req, Dialects) +
> +	if (in_buf_len < sizeof(*neg_req) +
>   			le16_to_cpu(neg_req->DialectCount) * sizeof(__le16))

This has the same issue as I mention in the patch 3 comment, it will
potentially dereference a non-present DialectCount field, and may
perform calculation on a negative value.

>   		return -EINVAL;
>   
> diff --git a/fs/smbfs_common/smb2pdu.h b/fs/smbfs_common/smb2pdu.h
> index 2cab413fffee..4780c72e9b3a 100644
> --- a/fs/smbfs_common/smb2pdu.h
> +++ b/fs/smbfs_common/smb2pdu.h
> @@ -1388,13 +1388,12 @@ struct reparse_symlink_data_buffer {
>   } __packed;
>   
>   /* See MS-FSCC 2.1.2.6 and cifspdu.h for struct reparse_posix_data */
> -
>   struct validate_negotiate_info_req {
>   	__le32 Capabilities;
>   	__u8   Guid[SMB2_CLIENT_GUID_SIZE];
>   	__le16 SecurityMode;
>   	__le16 DialectCount;
> -	__le16 Dialects[4]; /* BB expand this if autonegotiate > 4 dialects */
> +	__le16 Dialects[];
>   } __packed;
>   
>   struct validate_negotiate_info_rsp {
