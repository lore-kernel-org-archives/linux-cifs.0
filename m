Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E3CCECAAA1
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Sep 2022 18:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiIOS5H (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Sep 2022 14:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIOS5G (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Sep 2022 14:57:06 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2A93CBE4
        for <linux-cifs@vger.kernel.org>; Thu, 15 Sep 2022 11:57:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VypZ2HwJ+fLwK+e4L/CRu+rFIzsbSegyF+tng/CW42lM2lrJi+Hy/bqdiDSk4LbsdYYHuwuavXwlCujDYrw+d2e67W35yx1tlT1MZ/09LUjFep5VBIEcYME09G0fwXMWSW2+Ibn7sM+vny0XsX99YAZjKGRZZEyEpk4mP0d4Vu52mKpoAKHZqoObfgK8MsEHANSVFZlVMDbe6XmBb2Mlz41kdnM/jYrLTXQhVHhEWkKmOl6JyXcxTnIrrqy2s8gEJQbtgRIgVXlFSxg3K81VqWnXjFGE4XC1Zw63KalhheVuuWAHLc1iZNEiTau9DQKFxQipy3pbSmrePYQGeTHO2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MrL5yutEEEX56YS7QUsB3v77oVwjVJn42bdQruDd+l8=;
 b=Il8NqGGoNy56AAOazz8YooR/GJN8iuJloQQrJxtJrqqbtPjxRw3BgnWdqh2u9LE/KEepAOwfN7pLkJhdgXNwPCttgZ0Dnjns73R6MGKaDcSEgaOQaBNetJCmjL2/jpdayriYUSdyymrm3iSOY0vQAumQxJt2tq+vRdLj7s/Bf7VzR3NdCj6z9nGEbOe/HXtV8dKixBAWUGin31X3yNmG4IRLcFWRTKfF/6wcCr0XpeSUwonGULVzZMCFY66m0ldyfh0afc74y1PMtTr1hrTHEPKwmF7Yn/NHzTOSt2voZWq/AlLLXKkUPRKgZXS0m6HBhVSrW3z93Onyknkmq8iFTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM5PR0102MB3509.prod.exchangelabs.com (2603:10b6:4:a0::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.15; Thu, 15 Sep 2022 18:57:02 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::4dc8:c035:7271:4df8]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::4dc8:c035:7271:4df8%4]) with mapi id 15.20.5612.023; Thu, 15 Sep 2022
 18:57:02 +0000
Message-ID: <e2fdcb1e-b59e-30d9-2e12-b7674f2cc878@talpey.com>
Date:   Thu, 15 Sep 2022 11:56:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v6 5/5] cifs: Refactor dialects in
 validate_negotiate_info_req to variable array
Content-Language: en-US
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com,
        linkinjeon@kernel.org, hyc.lee@gmail.com
References: <20220914021741.2672982-1-zhangxiaoxu5@huawei.com>
 <20220914021741.2672982-6-zhangxiaoxu5@huawei.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220914021741.2672982-6-zhangxiaoxu5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0073.namprd03.prod.outlook.com
 (2603:10b6:a03:331::18) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|DM5PR0102MB3509:EE_
X-MS-Office365-Filtering-Correlation-Id: 198095df-3c3e-448f-989b-08da974c12bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fSTUl9YG9mKwk8iLrwOuRZKPr7uOs+eLJ4OPy2mWABI5/ka1OsRnOQfovEsu128GvKklDnrrbs8l364EINzTxMV0rZW2oVoBeAqRkCR5ZnpqhQRSnU7rnKr0RCCtlVAQtw++KZHtFFSTEqdxp9XhpSIeSPvI9CZcSJBLuo4s0He8fvOz1/Jz4X5rUR1LmBnTuuwGlmYUrJ0CW3+n65U4JzMBHWUFw3hWbH8O+2sLQ/9TCzZTYLNKhNzFgnMi992QEtMqdPMxpTX3Jn1M/KYYBe06vhnyeF4MWxEpc37crDZd1Ol7S/UQdM7DxTsmXnst1mnPqLuIqasGNAsYf3WeJdePLEsQbOOJTz10HcMq7JVG7zE4z4MXyFt0PWyzsQVj+I/hzIr31FIvVjieI7fdrLP2ef3cCmKRTu3HgNNk8H1dNw3vxJwD8cNfTdBRCu/Ol+QQcCFd3hZNYULPnowcXsSqDb4gvjasRA5UXhW/CdDBATJjI5RRfqrR1+VL81h6NBuLQUhAhBd3nF3GDH5kx/nh/z+moyvQJzocYS0ppvhj6yR1bfJt9k/SmK5gY/bNrXFWtn4szQzq23FKem0uCOC6ChvniVcPt/GWvszAMuw0JGs84VfaAiLMcdD2Io51COOEBIfWoQWrhpY6tjAaE8s2eDKlBw+OFGjuItLHz0STkxCi2SUDUvdgdEf0wcKB7db9HlXjIXfSUEmwlqWMvdUVBUkuaagiIGHHme9QwrYFes4iZybsu2yAFaz8rko7RZGDlLmTS9aASSASzNewFMWRW8ZIKO3bMk8O0Mg5jkzPkr/h+IUCvt7tUyoxomsI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(396003)(39830400003)(366004)(451199015)(31686004)(316002)(66556008)(66946007)(66476007)(8676002)(6486002)(186003)(478600001)(15650500001)(921005)(6666004)(2906002)(41300700001)(8936002)(7416002)(5660300002)(86362001)(2616005)(31696002)(83380400001)(53546011)(52116002)(38350700002)(38100700002)(6506007)(36756003)(26005)(6512007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHB6YllQMWpDZzNNMG9tRWxZb1dxYWFSNUNsTTJFSHA5NUd5QU50eG1LRjR0?=
 =?utf-8?B?R241MDNMUjhVU0Jyc0Q4QmxGQzdLbXJqSEJOeStmU3MzUStrMEZLdFRKNnVI?=
 =?utf-8?B?bmZCSnkzdGxTWUhxSzF6K2p6cWJmYXpUai9KYXMvby95YS9hRlQ5cVJZcFpS?=
 =?utf-8?B?VXBrLzRUczArSERWRlJkd1YwOTNyNDlzamxhV2JDNFNmWmQwcHFiTnlGTW1I?=
 =?utf-8?B?UzVSVmQ3eUUrZHYwcFdTY0hzamdjQWRQMjFEakFQZXhLRWxuK2JRZWVMTVNv?=
 =?utf-8?B?TkdWUVc5SlJUN1Fhc25ZQU5XNWIzdDhCdVUwTlg4SkE4R2h1MzQ2QTBUdEJn?=
 =?utf-8?B?cDByOStManNTNTRkeTJ1dEYyQmxLRkRlb1Ryall6ZDFJL3BwYWRLaEpXWTJF?=
 =?utf-8?B?K044aWZqVlU0S1lIeFJHUXFyaVJBRXJMTS92d0VQL2hrRFVVcFUzczFoakdY?=
 =?utf-8?B?UnNKMkkzb0JOSDBzTVBaYU91QkZSMEZiblRienE4L2NYRXRieWhuOHk4OTh5?=
 =?utf-8?B?NzN5MXcvaGhIRHR5U1QxdVpLQ3kxNlpvVFVtWUY3Nk1NK2RMZC84b1RobWZR?=
 =?utf-8?B?N1hUdWJFdjJuZDQ4aWxxYlV1M0llNnhDSEw1STlPWGZMNVFiN0dDQWE5aEkz?=
 =?utf-8?B?M0tCQXl4S3orREs2K2VPQ0hHNDM1MTFJZnVDN1RMVE5CUE93cmdrblN3LzhD?=
 =?utf-8?B?dG9tSmUwMnF5Y1luSzQ3WVE5eWEzWElmb3dOS3NvMmtMYlFhZ3REMjIzd1pQ?=
 =?utf-8?B?RjVBT2poMGczMWRnV0hoR0dvNzFpblRYZEExSS8yTW5SaU4raGhWbnJSOUFH?=
 =?utf-8?B?S2FJcktMeE10NjluWHVrckNvNy93RzA5RHJadm1VS0xaNU8yT3J6M3NycCt3?=
 =?utf-8?B?UjZLUkJrQjBvSnJwMGdOaWkxYXlESk15UVVqSThSaHBpYUNrN3ZXZkhHSis5?=
 =?utf-8?B?YUY4OFBSTVRseTN6M3V3ZDRXeGxzTUJ5VEdHdGxZZGFMZUJ2dmI2WGxmMVV2?=
 =?utf-8?B?bUJyeUJnZDRML1dPeFlxc3h1VjNkS05hY1lkUTJzbVh5WnptNDBSWm9lZXZO?=
 =?utf-8?B?eE96aHNPS3NRaXl2WFNETVduaStOVldUckNtMDNjOXdzdnYrSTR0OTlRNTZ2?=
 =?utf-8?B?THcxbnJYTGkxRnFFVE1QaHh4NFBIZi84VmdFQXVFaE1vN0FTaXVwOVV3L2Fl?=
 =?utf-8?B?M3RGUzB3NXlrUGtlWWgzRWFiNFc0QUZsR1FiUkQzVzAraWJtcXVIc0JERlhF?=
 =?utf-8?B?Qi9JQm9vbzArSVQxdXRJbUYrR1Q0dzBzN0tEcFlqWjVZUHhNb1VKR1pGKzJx?=
 =?utf-8?B?ZXI3dDZHMldyWG4ySUhscmtuN1NWaEpzem5MK1hiNDV6QWN5TjlOeFd2eENk?=
 =?utf-8?B?emJzcXEyVDFEeWp6WVY0OXY4bWtqS0JvV1pyUGM1L0VQbnlNQnUvb0tXdk0r?=
 =?utf-8?B?MlNIbmF0Z3JRb2FGYXRHRkZMR0czK2lHcWtnUlNLbVA2TFRGWHNsYVA4aEx3?=
 =?utf-8?B?UEhmc0E4VGdFTll6VnBNYkRJQzBlMFFZNWRCeDMvYitjOUpTUlpONjY3dDdj?=
 =?utf-8?B?UXVHS2ZkZ2JNNENOVDZFMDYxK0pVYVVUOVo0Yy8rMzlzdTd6TGZFWnl2UDZZ?=
 =?utf-8?B?S3k2ejBCaVBJbjZWbTR5Y3dGSURLSGZWNHpabERaL0xmcmFNMjRjMWRTcHZT?=
 =?utf-8?B?MEtZMkl3RERaejFJUTJNWU9wMjJZRmV5SUlDRmxnYW8rRk55ZUJXbDJRZVZo?=
 =?utf-8?B?bUdsU2ZVY2src1BUSGpXNUFGU1BhOGZjWnBoMU9zQVZ5NGxWaWE2dWk1NFlG?=
 =?utf-8?B?L3N3aXpaOGlsZnpCWkNMMjRRVG1UY3NsQnFUVGhBYjB1MWJEYmRPLzZGbGhW?=
 =?utf-8?B?cFAyY3pwcHBIMU5qYjZpZy8wSHJyNUhaelpKdGdKbDVLMno2V3VFWWdvUXVU?=
 =?utf-8?B?WGtwcWxkU3RJL0Fldm1wYThVUDFYQndzYWk2M2ZGcFYyc3NhQTNKdFA4d1NP?=
 =?utf-8?B?OUVkbFZRTjNaam1NR2ltYUQyRHVsVEZ4OGJGWmxNTTQ1a24rVFMwMXZqNkFi?=
 =?utf-8?B?eE5NaEtHWDRZcE9WU3dNS3JHanFpcDNhRUlwc0hxR051WktXZEl5SHIrdExL?=
 =?utf-8?Q?PXJaqWRN8SymShiY8YkcV5hca?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 198095df-3c3e-448f-989b-08da974c12bf
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 18:57:02.0451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qKM2/8W2AaRf/+0+Mcl7NmyMendXmmVhc/rdpB6bHA6XsCTPG+jX+2WfAjyVzLrO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0102MB3509
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/13/2022 7:17 PM, Zhang Xiaoxu wrote:
> The length of the message FSCTL_VALIDATE_NEGOTIATE_INFO is
> depends on the count of the dialects, the dialects count is
> depending on the smb version, so the dialects should be
> variable array.
> 
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> ---
>   fs/cifs/smb2pdu.c         | 7 ++++---
>   fs/ksmbd/smb2pdu.c        | 5 ++---
>   fs/smbfs_common/smb2pdu.h | 3 +--
>   3 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 482ed480fbc6..70a3fce85e7c 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1107,7 +1107,10 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>   	if (tcon->ses->session_flags & SMB2_SESSION_FLAG_IS_NULL)
>   		cifs_tcon_dbg(VFS, "Unexpected null user (anonymous) auth flag sent by server\n");
>   
> -	pneg_inbuf = kmalloc(sizeof(*pneg_inbuf), GFP_NOFS);
> +	inbuflen = sizeof(*pneg_inbuf) +
> +			sizeof(__le16) * server->vals->neg_dialect_cnt;

I think this still needs to check the neg_dialect_cnt field for
sanity. we've established that it's now safe to dereference it,
but if the client sends 0xFFFF as a count, this will allocate
a bit over 128KB, uselessly.

I suggest limiting the dialect count to some sane smaller value,
perhaps 8 is a safe choice.

> +
> +	pneg_inbuf = kmalloc(inbuflen, GFP_NOFS);
>   	if (!pneg_inbuf)
>   		return -ENOMEM;
>   
> @@ -1131,8 +1134,6 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>   	pneg_inbuf->DialectCount = cpu_to_le16(server->vals->neg_dialect_cnt);
>   	memcpy(pneg_inbuf->Dialects, server->vals->neg_dialects,
>   		server->vals->neg_dialect_cnt * sizeof(__le16));
> -	inbuflen = offsetof(struct validate_negotiate_info_req, Dialects) +
> -		sizeof(pneg_inbuf->Dialects[0]) * server->vals->neg_dialect_cnt;
>   
>   	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>   		FSCTL_VALIDATE_NEGOTIATE_INFO,
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 09ae601e64f9..aa86f31aa2cd 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -7392,7 +7392,7 @@ static int fsctl_validate_negotiate_info(struct ksmbd_conn *conn,
>   	int ret = 0;
>   	int dialect;
>   
> -	if (in_buf_len < offsetof(struct validate_negotiate_info_req, Dialects) +
> +	if (in_buf_len < sizeof(*neg_req) +
>   			le16_to_cpu(neg_req->DialectCount) * sizeof(__le16))
>   		return -EINVAL;

Here, it may be a valid check without the limit check, because it's
verifying that the message was properly constructed.

Tom.

> @@ -7640,8 +7640,7 @@ int smb2_ioctl(struct ksmbd_work *work)
>   			goto out;
>   		}
>   
> -		if (in_buf_len < offsetof(struct validate_negotiate_info_req,
> -					  Dialects)) {
> +		if (in_buf_len < sizeof(struct validate_negotiate_info_req)) {
>   			ret = -EINVAL;
>   			goto out;
>   		}
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
