Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AEF8C54EE9
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 20:56:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiITU4M (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Sep 2022 16:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiITU4L (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Sep 2022 16:56:11 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AE26B16A
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 13:56:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SsscL8XiSQSZQ0mCiTeAPxKhcO3QXHro3XgYTGpdTDiNtsOuQvt3Cxd3dx4irXp+URP6jZZimclu7mD0FEkHhj5WAl0adtIuAPIdLTeG6J22WhyeiHZUWO2DZNyjxkG7OhIi+9zVn3Sn1bUBHzCjoViABqYZpxbAmdCgNSyMtKcfNS/4fFPS4G4ZktNMOfpUuYMzz3nw057MN0eg9l1bEZAOye+hgUjgU46ZVVu18AbABIxcShKWfFCVk911FXOTMdqU7uOj7kNJ4hFyrP/N+oIbeolD6Y/UNkMC8tKkf5roBUT5l68VFIHmctPj5EJqt/v1j+AOvRTbFW7eCH1Wrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5w6gKZ9Zo3I2OfnVNp+LBTvmW7CbNPKAHxypAgx/Y74=;
 b=N1IGsR1p0y6j1q1YAr/OhD7R9ouZK6JaS1/D8yoyo0B1H2yxMUX9UBcpdB6ApJvSIH3007rpbeZrbkbnIQyQMqFUZVqb3mD1+kyU+OP1qXbFtVkTvE02yfarsLTl8ehySicjkjrd7h2yUBdE3pozhMuqFIlHV+igZuHytRdE6S6055XKagQIqM33tA/JV/FhmYnIGk3jDM5ul5fkMueX1g1xY4VMhTcxyIyReXq9mheO0A7RNZvW1ZWEMwLUeZQKpyJjvNhudxQ33NUJ7GVI4/b+Jfr/oBVjRH32VI2A+d4vbHUgk9r8RLAxVIaGBoULItHHUp3KvORG8k3ej+9nYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BYAPR01MB4438.prod.exchangelabs.com (2603:10b6:a03:98::12) by
 DM6PR01MB3692.prod.exchangelabs.com (2603:10b6:5:92::26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.17; Tue, 20 Sep 2022 20:56:08 +0000
Received: from BYAPR01MB4438.prod.exchangelabs.com ([fe80::9219:212:e722:6c8])
 by BYAPR01MB4438.prod.exchangelabs.com ([fe80::9219:212:e722:6c8%5]) with
 mapi id 15.20.5632.021; Tue, 20 Sep 2022 20:56:08 +0000
Message-ID: <37a76dc7-da11-f3d5-4727-92ab19a66c0a@talpey.com>
Date:   Tue, 20 Sep 2022 16:56:06 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 1/3] ksmbd: change security id to the one samba used for
 posix extension
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org,
        atteh.mailbox@gmail.com
References: <20220920132045.5055-1-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220920132045.5055-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR01CA0003.prod.exchangelabs.com (2603:10b6:208:71::16)
 To BYAPR01MB4438.prod.exchangelabs.com (2603:10b6:a03:98::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR01MB4438:EE_|DM6PR01MB3692:EE_
X-MS-Office365-Filtering-Correlation-Id: 07b3cf0b-f08c-4cee-694a-08da9b4a8a74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dXxTdpBUDMtjHIc7c5Xmiop7QgNiQ2mxSnnNWpDiW19SUlJJCf6i8Bp28iNq4yYCKkdw62l6/UIMaJLHStamQ6Z9oitGRdqq4qMK/EioNxkkSzuJUim9Iq/1s6jHXuCcSxoQPsdtGC/RSB/U4CAVouiLD9lRdg5utmf0RkznIqXNS1S6N0SmAfYixAjv2hDbsb4O7Uca8lkUn0AN53ufRocVoj3jLXqktIKojh67WRm8F5VQrNEhEe7DtYSiys7ciRQG3utCJLxxSapaFWdr+ovE4Oxr0H9aQCZFz88GJxDYM56cb2YFvtMKsU9CCGdBU6e9QgkXCfSqoX0YgzWC14DqJ/TIIqtdPOeUvMrIir1hKYTZUYdmWXLchjlbggzjCCRU/v57yG0Wf5QVbySfPiT877FgagmeJ45cCDTaej7b7y/1eKh8gzZk1C4W6OZI+XG+OFDnV4JEvEI+bxtZySrUPMkQvmqtktp7gEGM0yPChipomquiR8KnduK7amSL146hSGGQQklc47fgzbhDv2Cxh23Bho6lAcGKyglfw4/9ofwvkx1hv9j7hmKQ7ZINFiGicxUK2dXW9ytKMiAjYE2pgmZhZFh80tgWQUNEl0cClTtPWA0nVwY5bh2AF43aaV6Om5z1f7N0bG0PfQzve2pMJ6FN2dJX1sVOnO3juJFUq8Cm1u8XGFRs0zy5MCq7Lfv/DvaWEjhq40ukYGbJM2LgJx9nvttMi8nd0gooqKFQUnJW6lsy5g9IaoLpz1aqUcXCR2CTyRos6YIEKh7pUKW++7vz3VqoxXk5iCd0L2s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB4438.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(366004)(396003)(376002)(346002)(136003)(451199015)(38100700002)(38350700002)(8936002)(31696002)(86362001)(31686004)(36756003)(83380400001)(2906002)(6512007)(52116002)(186003)(6506007)(15650500001)(2616005)(41300700001)(478600001)(26005)(53546011)(6486002)(5660300002)(316002)(8676002)(4326008)(66556008)(66476007)(66946007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjNLdm10dTA5SXBDakw3cGxobDFwRmR4Y05tYm50MlNiTURxd01lZVdEQWR0?=
 =?utf-8?B?anNqSHE1K3ZCcWRzejlPRnFaTlBmUmJpRUNFQkEzYkNaTG91OG5CSENyajBC?=
 =?utf-8?B?bFgzWGZzQW05eUZSdlRpTmpoVmFFQ0tsNzQ3cm1HR2dwY1hMN1F0L1V3ODdl?=
 =?utf-8?B?SmU5MEE0WHpyWWVCeWF6MndnZkFvY3FKWVNXVUYycFJjdFVNSFJaby9VVk56?=
 =?utf-8?B?enBBQVU3QzdyZ0xIdTlxT1ZCNFpmdmtlVlJJRm9lV3Bna04yNFdQOXZaaXpW?=
 =?utf-8?B?V0ROWVhTRWxIUlR5dmxYbldKQ2IwSkg0TGZPeXBicG1kTElZUlJMTG5tUGxN?=
 =?utf-8?B?QjNFT3RObitMalNSRXlub2gxejRzSCtXM3hZeWlrMjIzTks1N3psR0Y1Tlp3?=
 =?utf-8?B?N29NdWpWUysvYUR0eURnenFJdjgwVkdaZU5mekhwTDZTWlBQUHRhbDliSVZ1?=
 =?utf-8?B?djhUZWhtQ2dUeCtEeFFuT0FjL0xkZzlPRXpiQzh6N0NmSmZmUFNCM0p2TStm?=
 =?utf-8?B?RnhBbWJlUThQZ200Wkt6cWViVTNWYTZ4R0hKM3lnR3FiWFJLN1JES21RVk1q?=
 =?utf-8?B?cVhqbGZtTGhENnh0Qkc0R0M3Q0RDMUFpM0Jhelk5YnRBTDB5L1RPemVmYVd1?=
 =?utf-8?B?TER6clVYQVRQcld0MktYaXY5VktiL3pka3FxUHRrVE1qVUJTMFRvMXdkT0g5?=
 =?utf-8?B?eVVmT0prb3JRQXE3YWxhZGxQdWg0MlVvTDEzTWRHTndTUHBKcDdkTG5UckRS?=
 =?utf-8?B?aVpRK20yUy9SQ0U0ekJKaThKSncwQmtLbm1ZU0tBb3ByUmhkYk81b1M2cmVY?=
 =?utf-8?B?cERrd3V4eUJneFcvbGhpZHlEMVRYQnplaHBBSmdMRVNLREtZUVBhV2VJclc0?=
 =?utf-8?B?TWhONEZ4K2lrK252N29wSUhLRFJ0NkgrT3FXUGlNdCtPOFpOaC9PeDhlcTdp?=
 =?utf-8?B?V3UvQi9EcXJwVm5ybVlTd0txKytnUU9idWtGNysrbWEwU0xRaEVjNXNrL1JY?=
 =?utf-8?B?TVcxdlNEUGc3OFdSTEJkL3VZbHRRZ21VbldJdVdlU3pCRVRLR0VoSG1iS0RQ?=
 =?utf-8?B?d2trVExrQVU4QVVvS05MYk81L2R4N0VsY3ZSYk04THFmTElFMTlCOENBazE4?=
 =?utf-8?B?Qmo0VEt2VWZKdXpROW5SM3V6UkxtaWpxbm1iTXcyemN6VXBMdytVbkxXRTlu?=
 =?utf-8?B?cUpld041dEthUVJHVlN3ZnMrWCtGbFlhM0VtZk9kcXU3ZkxNL1phT0R4VVlK?=
 =?utf-8?B?MlpnT3BsdjBEVjluWjRLVjN1emt5Q0xIRzlsZm9nUUtqNFI5QTQ2d3QyUzZL?=
 =?utf-8?B?NmowUHZSQkYvZmNIa1crcWRzM3AwR0Y5VVpnQ2Exa3gzRytvbG9vNWQ1RlFG?=
 =?utf-8?B?WGw4YUNpM1JrUDlkdm1ITys1OUlmaElXYm1QTjAvNkpGQm93R3VCWmMwZkJs?=
 =?utf-8?B?dVE1SDNabFNmaHlJSVlDSkFMenMzRnNYWXNYK21Yb1VUQ0pldmswMTkxU044?=
 =?utf-8?B?Q0tBbHMxL2JGZzhPcmxDMFYzWjQ4WjU5NzVLZG56WWJOcFV3SzdEWmRpaytN?=
 =?utf-8?B?aGZZbmF2bHR1VGtGemZ4ZCtnUDBQNlpuRFUyZHNpN2hLZTcyZ0FFNzVMZlRw?=
 =?utf-8?B?bGdXaEF1amE0cm8yRjRXNVB1WVNadi9MN0xod1I0Nm5pWDRveXdNNWlha0ZP?=
 =?utf-8?B?bUZyRk1UaUQ1bzBKNSt2UW1LaG5IcUphQ2YrUFBPQzlBSGxGampuNGI2T1Nh?=
 =?utf-8?B?Zk8wZzhSME1scnFaN2NOY3EvSXVqTVRYTUh4WmcrbW1UdktHWTl0RkljMW50?=
 =?utf-8?B?ZlhDbWNIaHgrSlZUL2ppTWRZOWp2QWFOOEVsd1E2U0hxM1RadWZSSnM1bU1j?=
 =?utf-8?B?WFF3WWlZd0ZBenF4d0F3d2NXdGVIQXQ3TnlZdXE5NXdRL2wxQThWRHdwKzhu?=
 =?utf-8?B?Zko1UU5yeWhIMUs4Zk5LTWgzYWdXaXpBV3JXYmdZR042MEI1K3FJSEluTU9n?=
 =?utf-8?B?aWRGREtJTDBieWFJRjlua1BaSEk2bWJmVkpZSUpERWw2MjhVWnNiZCtnZFdY?=
 =?utf-8?B?d0UwbVRsbWd5YXRGaXRRVEVOSGJUTG5HU2lGVjltT2ppSTE5aXhhYUxrZml5?=
 =?utf-8?Q?9JiENoJXgakJdbDGgtIY7L5cZ?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07b3cf0b-f08c-4cee-694a-08da9b4a8a74
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB4438.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 20:56:08.0835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PsNfSjwsU+Nu1dk8rBh8VGnMoiqFLb+9tWhBF1g98pI7dM230q+xRXXbuuGSliG1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB3692
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/20/2022 9:20 AM, Namjae Jeon wrote:
> Samba set SIDOWNER and SIDUNIX_GROUP in create posix context and
> set SIDUNIX_USER/GROUP in other sids for posix extension.
> This patch change security id to the one samba used.
> 
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/ksmbd/oplock.c  | 6 +++---
>   fs/ksmbd/smb2pdu.c | 4 ++--
>   fs/ksmbd/smb2pdu.h | 4 ++--
>   3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
> index 2e56dac1fa6e..c26f02086783 100644
> --- a/fs/ksmbd/oplock.c
> +++ b/fs/ksmbd/oplock.c
> @@ -1616,7 +1616,7 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
>   	memset(buf, 0, sizeof(struct create_posix_rsp));
>   	buf->ccontext.DataOffset = cpu_to_le16(offsetof
>   			(struct create_posix_rsp, nlink));
> -	buf->ccontext.DataLength = cpu_to_le32(52);
> +	buf->ccontext.DataLength = cpu_to_le32(56);

"56" is a weird thing to code here. Can it be expressed as an
offsetof or some sort of sizeof, for clarity and robustness?

>   	buf->ccontext.NameOffset = cpu_to_le16(offsetof
>   			(struct create_posix_rsp, Name));
>   	buf->ccontext.NameLength = cpu_to_le16(POSIX_CTXT_DATA_LEN);
> @@ -1642,9 +1642,9 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp)
>   	buf->reparse_tag = cpu_to_le32(fp->volatile_id);
>   	buf->mode = cpu_to_le32(inode->i_mode);
>   	id_to_sid(from_kuid_munged(&init_user_ns, vfsuid_into_kuid(vfsuid)),
> -		  SIDNFS_USER, (struct smb_sid *)&buf->SidBuffer[0]);
> +		  SIDOWNER, (struct smb_sid *)&buf->SidBuffer[0]);
>   	id_to_sid(from_kgid_munged(&init_user_ns, vfsgid_into_kgid(vfsgid)),
> -		  SIDNFS_GROUP, (struct smb_sid *)&buf->SidBuffer[20]);
> +		  SIDUNIX_GROUP, (struct smb_sid *)&buf->SidBuffer[28]);

Same comment for "28". offsetof(2 shorts and a sid), right?

>   }
>   
>   /*
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index f33a04e9e458..bc6c7ce17ea8 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -3573,9 +3573,9 @@ static int smb2_populate_readdir_entry(struct ksmbd_conn *conn, int info_level,
>   		if (d_info->hide_dot_file && d_info->name[0] == '.')
>   			posix_info->DosAttributes |= FILE_ATTRIBUTE_HIDDEN_LE;
>   		id_to_sid(from_kuid_munged(&init_user_ns, ksmbd_kstat->kstat->uid),
> -			  SIDNFS_USER, (struct smb_sid *)&posix_info->SidBuffer[0]);
> +			  SIDUNIX_USER, (struct smb_sid *)&posix_info->SidBuffer[0]);
>   		id_to_sid(from_kgid_munged(&init_user_ns, ksmbd_kstat->kstat->gid),
> -			  SIDNFS_GROUP, (struct smb_sid *)&posix_info->SidBuffer[20]);
> +			  SIDUNIX_GROUP, (struct smb_sid *)&posix_info->SidBuffer[16]);

And for "16", although now I'm also confused why it's 4 *less* than
before.


>   		memcpy(posix_info->name, conv_name, conv_len);
>   		posix_info->name_len = cpu_to_le32(conv_len);
>   		posix_info->NextEntryOffset = cpu_to_le32(next_entry_offset);
> diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
> index af455278d005..32c525bf790a 100644
> --- a/fs/ksmbd/smb2pdu.h
> +++ b/fs/ksmbd/smb2pdu.h
> @@ -158,7 +158,7 @@ struct create_posix_rsp {
>   	__le32 nlink;
>   	__le32 reparse_tag;
>   	__le32 mode;
> -	u8 SidBuffer[40];
> +	u8 SidBuffer[44];
>   } __packed;
>   
>   struct smb2_buffer_desc_v1 {
> @@ -439,7 +439,7 @@ struct smb2_posix_info {
>   	__le32 HardLinks;
>   	__le32 ReparseTag;
>   	__le32 Mode;
> -	u8 SidBuffer[40];
> +	u8 SidBuffer[32];

Ok, so it's one buffer, which contains 2 sids? Ick.

>   	__le32 name_len;
>   	u8 name[1];
>   	/*
