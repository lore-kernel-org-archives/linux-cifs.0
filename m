Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8DF0C32771
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Sep 2022 18:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiIOSrb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Sep 2022 14:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIOSra (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Sep 2022 14:47:30 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725909A955
        for <linux-cifs@vger.kernel.org>; Thu, 15 Sep 2022 11:47:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yl7f8A9yiroNd1HEDA2oLu7i9pzNxSrMHokYouTOOVoYL10MTY5Z6Ego6O4ByXQLlAw2wU6lm6Qk4uryJHHtCMQ0O8AbNo1U3VW0gOu1+ufYhWBCOCpVjZZ2S5HZO9CXvOZHYPUcbMfm+wQtuNrbfTOR98Mu3CMzH+B2GLe9jXf3pQBOkRAUscPYOVDSwB7Lw7fVCzjFl9eyBcHZ6szSN+tbjOoJWOw9STTTxvMSsTru0CSDBbmz0aenbKrivg3K0zAF8Dyj/1tNFTvfHmD5HdGHZSKUDbPpBo772YOiKau0LAepUBxZFaCnFSX006fyeAAQHTAbuW7FNpSt124YsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ijaROKPhK9qI5cVnzrEshIGiMmWnBKDm1H4lh0e5Ykk=;
 b=g2GJz11P/bOi0I+pqhcAxBVzdT8MYUKOK76UwZUvrUseGLR09ZEqfv7KKN45Qqj5xlSMT1WS9hxbqtxhLGVrKooMRDWtnggmC1RzQa3AnrO9bNMJhoetsPvoZOLj9Y1TxywZ/os92fXxxILumNvUWAQY2kWumlY5sM5QnW7HLtBBb8CGl9zWbaL7DzNTIeLxg3ErgnPCIuH8iVNneoJfU7sZ66qfgDZCWCmm07uGNpgIz0YQvmWIxT5ETTdUdn+qfvS5RpQ+Jnl+yN4w99DmCCEq/iD73wYyJZN6yvN9t5K5oIvduYfTIuhFb9TSi3OpxMt+pGYI5w+5e6MVtxT8WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 PH0PR01MB6745.prod.exchangelabs.com (2603:10b6:510:96::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.19; Thu, 15 Sep 2022 18:47:27 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::4dc8:c035:7271:4df8]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::4dc8:c035:7271:4df8%4]) with mapi id 15.20.5612.023; Thu, 15 Sep 2022
 18:47:27 +0000
Message-ID: <66eeb466-de8d-8747-f942-6a6f2fbc74b4@talpey.com>
Date:   Thu, 15 Sep 2022 11:47:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v6 4/5] cifs: Add neg dialects info to smb version values
Content-Language: en-US
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com,
        linkinjeon@kernel.org, hyc.lee@gmail.com
References: <20220914021741.2672982-1-zhangxiaoxu5@huawei.com>
 <20220914021741.2672982-5-zhangxiaoxu5@huawei.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220914021741.2672982-5-zhangxiaoxu5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0009.prod.exchangelabs.com (2603:10b6:a02:80::22)
 To SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|PH0PR01MB6745:EE_
X-MS-Office365-Filtering-Correlation-Id: 045348da-2142-4777-e666-08da974abc41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ra3YeKGFB6+GeQyqBT/GvsIJu8F7HegmEjaTIT8UItOnwU5XoZ6Vwroc92wq8HhLsl7xHQ7hE+9QWc1oPTNjizs6ruMGNkheLQKEEO5oyGFh8xBgoQ2Y42FD/b6c07eFdr52AonwodaytM6nfPRMzlYJWme8ZjdMvM8XSqnySz2ww1/vXJsdaEgwBM8YxkNLoS6G99RdRXEyXrSAk3RCF8GxnAFARjym+iSe8DlKWzW7WTCu+r+blK1hgXM7j1vS07GNRXPiHJAx6z7QbHL27IeDQzJqnhwZnK8tRfqthbC6mfvUWff+D8SUSoLRxNpbtKQ/OPrYCdCxIlOTSTaSPKmvSNPjn23hHhLWNkHTijAife4ZxpUOuQvJ/pl0vcBWygl22t6GV54ZDtSHkMCFFN9KMR2O6tNKvBUOWPfH00Jz81T542SgvnpvZbPhQp1tfPEKNFlZfMxwWdaIkz9qLVh2xP2XACxiyoCwI0ciDB81wa/THqEwUYPTVs8XGKBAU9w7HWceu/+UbcEAPdiiq/lIVXj1WA/MqSmVZ+1TgMQ1CLRBfx1k5sejLMmoSNFi+CAXpGkXaF2Dq/wG1Fb4HhUMZScOcK6PrJZJl/LWBecMdwoWN/A/TzC0d28pR+Mp4dKUn1KrAZrznxL4Z/wUqGjcoez/iz60vodfVhK8qhVrGQWzprOiUhHMEY7yLHdYlQxWIklCbN4N4PzfcErKdDEsd366bfZLzPyzYRt8qU4n27tIZ+fzd4f2+sw+IslAFDutybce1WDXOYyMTpmf4oJTq1EbYfbO+4VyZs3943apiqcl4cAwgXXYuN6+6mm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(39830400003)(346002)(376002)(451199015)(186003)(7416002)(31696002)(8936002)(52116002)(6486002)(921005)(86362001)(53546011)(41300700001)(38350700002)(316002)(478600001)(6506007)(83380400001)(2616005)(6666004)(38100700002)(31686004)(66556008)(5660300002)(66946007)(36756003)(6512007)(26005)(8676002)(66476007)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1FLbUlWRDc5bWZGQ0c4Sk84YUpPaElkY1RKKzVuZ3NXeTVvTDJ5Q0VpY3pl?=
 =?utf-8?B?azJ2QjluSXB5c05FU0RsMDc5UEE1dkl0NkNJekdCZGJXcjhlTWh5ZTdIZlMy?=
 =?utf-8?B?MkFweUc1ME5NcEVoTjdiQVBueDhMZkRQRVkvdS9oN3RKQTBXazg4UzQvc0Vl?=
 =?utf-8?B?NEpsSlk2NHZuOThqSkhQQ2lnTEtFTFM0SnorcUNOSjB3U1RCcituaFduenpR?=
 =?utf-8?B?UEVYUHVoT0pVc1VGTUJtSGRvcCtpdm9HQ2tJN3VKenFRRzFDRnlaZkl6elVm?=
 =?utf-8?B?SEwyYUE2TGRhWVlZMzYwVUR0MWFJdzV6M3diWFFnWDlHclpUaUN3N1NhZmhZ?=
 =?utf-8?B?NHhQaVBtVHpsMmVNK2tFYytrbE1FSDUzd3lpRm45RGpaOHpObCtYMGlsVHRC?=
 =?utf-8?B?a2dPMEtpNmJVZUFhOUJxZXdidG5Zam00dHFwV2xqSmFhODN4WmJLZFd4NkVh?=
 =?utf-8?B?MXAyVVFPVVNlUWxOeDB5eU1vbkxEUDVwZXZNdUI4ZWR1MFVOU0sya3dQTUcx?=
 =?utf-8?B?RHQ0YjQ5NHdvQ1lwOUo5MTRiVE15SzZJRkI0RWd0T2VoUS9SazZBRGw2M2tK?=
 =?utf-8?B?bnpMUUNOWGtnNjlvNEJHV2ZzSDVBWEFDaGNBZEhnbUJST3VBcG1rSnRwdkxk?=
 =?utf-8?B?NVJrUlJEQWtVWWYyNUdGcllJUVVFc3RFc3k5a0ZwNFlpNFppZklXZ1NQY3ky?=
 =?utf-8?B?QWZKbDhYYkxmczVuRlFpeDNTbTB5L0RoTXcxUjdUVWNjYkRub3cvUXBOeTlG?=
 =?utf-8?B?dTZpQkhMeGhlVDFDWmpMdG9JcGR6U3FHaE9tTWRmaEVuRDM1a3loV3hnSWg1?=
 =?utf-8?B?ZWMycy8rZlM1bE1nbUFVRTI3VFpzVUV6QmQzak5ZbHJQT1VLcURuRElEaUgx?=
 =?utf-8?B?WGwvMitUQ0R0Tkd2S1pDbUNFWjEyUmowRHRia1FVUlhzeG5kSkVodjViOEpH?=
 =?utf-8?B?VzhUU2tqUmdLRjJRc0hYelpCdGVCczlwZEVqTzFpOG5BMEZQclJBK3RLMmMr?=
 =?utf-8?B?OGZzTFN6cjdJbm12MjBOUktIMzRnSEVUUVJWTXBPZlZ5UTZicnI3Ny9mMW5O?=
 =?utf-8?B?dUJBY2JRZXZTbmhRbS9OaVB1SGZJdkdScTVhcW92VC9NN2JnS2JSVHI0bjlx?=
 =?utf-8?B?aGFJUDdVMHl3VDJJcVBDL2lhTnBLbWJoVWtsOHVCcmJoaEpLZ25ZV1RRRkZl?=
 =?utf-8?B?UTNrdnJmei9JRWdVc0hwS0FXUjFzalZEc3pIRE5LMTg1T0g4Tkx0NGl2bGxY?=
 =?utf-8?B?NnltMjEyVVdveEhMNFc0S0RYRUIydEgzRDNqanRIWVo4andlSzNndXV1QWV6?=
 =?utf-8?B?MVhFM0hvTGpiaXhRVm8wUFFIOVh6WGJ2YVNEUE1PVTAzLzh1YnU3OVdMTWlr?=
 =?utf-8?B?c0hrTTJEa0d1OUx1RW4vT1ZXc2pvOGNKdmFGbEdjUUlzMkxGY0F5UFErUlVn?=
 =?utf-8?B?WFNQa0EvK3psWGNnNlNaS25qbDEvY2FvRWNGSXBDNXg5Z1JiV25RcS9lemhj?=
 =?utf-8?B?S0Z0UXRUMTVrdkVremxLdmJSMmNsU3pkYnR6SXJNRjBtVHQyQWc1KzQrbTJh?=
 =?utf-8?B?aGQzbHVyc1FOeHd5bHVZUmxoOXJTcng4enJKMzJJcTgyanJqQ24zS2dvb1Bs?=
 =?utf-8?B?QXFsNTd1TWxKbmJRNzZteFdJUG1UMHhPbHFzcHdzT01TcnBSaWlTRXp5ZVFM?=
 =?utf-8?B?aHJsZ2dvQnB2VTd5c2ZVVm15SVY3WUpEeUVhMEpDNHBBeUg3VHViU1Y1Tmgv?=
 =?utf-8?B?NFNUd1NHNVVTU2V5TEI1d2wvS055NkY2MEZmL2Jpb1lmWFpLMSsvQkk4R1RP?=
 =?utf-8?B?a1RPT0UwRFA3ZWZBRWZWa2FsTUhJUzZLZXZueTJPTlN6MlVwdm1CUTVnQXpn?=
 =?utf-8?B?a2NvcGEyU2FGVUE5TzVGKzliZFYwNDdzSWNVRTdyMFlVYjgvVzdYaDdzRUlz?=
 =?utf-8?B?WURMcDVQL3FmZDlwSm1FTlVsM2cvWS9PajJ3Q05iL1NEZUovN3QzeVcreHNU?=
 =?utf-8?B?UkhxclRHb0gzamxGMFkyNlFQWnh5K1N4ZEZDN3hKZlVBaFFhR0F5KzJtaWRU?=
 =?utf-8?B?Y21hcDZ6cWFJZHliVjBjV0NIRnk3VnlaZTA3aHNiY2xNMEpRcHJIelduN3Vm?=
 =?utf-8?Q?sMz4=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 045348da-2142-4777-e666-08da974abc41
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 18:47:27.0030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O/FAkRUCSTMUOfTX6eGwfk80uvF5CrLNB6TVzE0NSNBRlBsxPIemXW36A5fqlGgQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6745
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve, your opinion on including this? You may have missed the
question I asked earlier in the thread:

> Is this really necessary? It's nice and all, but there aren't
> any new SMB2/3 dialects coming down the pike. I'm ambivalent
> about changing the code unless there's an actual issue, for
> the purpose of maintaining stable, etc. Steve? 

Tom.

On 9/13/2022 7:17 PM, Zhang Xiaoxu wrote:
> The dialects information when negotiate with server is
> depends on the smb version, add it to the version values
> and make code simple.
> 
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> Acked-by: Tom Talpey <tom@talpey.com>
> ---
>   fs/cifs/cifsglob.h |  2 ++
>   fs/cifs/smb2ops.c  | 35 ++++++++++++++++++++++++++++
>   fs/cifs/smb2pdu.c  | 58 +++++++---------------------------------------
>   3 files changed, 46 insertions(+), 49 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index ae7f571a7dba..376421b63738 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -553,6 +553,8 @@ struct smb_version_values {
>   	__u16		signing_enabled;
>   	__u16		signing_required;
>   	size_t		create_lease_size;
> +	int		neg_dialect_cnt;
> +	__le16		*neg_dialects;
>   };
>   
>   #define HEADER_SIZE(server) (server->vals->header_size)
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 421be43af425..e1407124c761 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -5664,6 +5664,12 @@ struct smb_version_values smb21_values = {
>   	.create_lease_size = sizeof(struct create_lease),
>   };
>   
> +static __le16 smb3any_neg_dialects[] = {
> +	cpu_to_le16(SMB30_PROT_ID),
> +	cpu_to_le16(SMB302_PROT_ID),
> +	cpu_to_le16(SMB311_PROT_ID)
> +};
> +
>   struct smb_version_values smb3any_values = {
>   	.version_string = SMB3ANY_VERSION_STRING,
>   	.protocol_id = SMB302_PROT_ID, /* doesn't matter, send protocol array */
> @@ -5683,6 +5689,15 @@ struct smb_version_values smb3any_values = {
>   	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
>   	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
>   	.create_lease_size = sizeof(struct create_lease_v2),
> +	.neg_dialect_cnt = ARRAY_SIZE(smb3any_neg_dialects),
> +	.neg_dialects = smb3any_neg_dialects,
> +};
> +
> +static __le16 smbdefault_neg_dialects[] = {
> +	cpu_to_le16(SMB21_PROT_ID),
> +	cpu_to_le16(SMB30_PROT_ID),
> +	cpu_to_le16(SMB302_PROT_ID),
> +	cpu_to_le16(SMB311_PROT_ID)
>   };
>   
>   struct smb_version_values smbdefault_values = {
> @@ -5704,6 +5719,12 @@ struct smb_version_values smbdefault_values = {
>   	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
>   	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
>   	.create_lease_size = sizeof(struct create_lease_v2),
> +	.neg_dialect_cnt = ARRAY_SIZE(smbdefault_neg_dialects),
> +	.neg_dialects = smbdefault_neg_dialects,
> +};
> +
> +static __le16 smb30_neg_dialects[] = {
> +	cpu_to_le16(SMB30_PROT_ID),
>   };
>   
>   struct smb_version_values smb30_values = {
> @@ -5725,6 +5746,12 @@ struct smb_version_values smb30_values = {
>   	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
>   	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
>   	.create_lease_size = sizeof(struct create_lease_v2),
> +	.neg_dialect_cnt = ARRAY_SIZE(smb30_neg_dialects),
> +	.neg_dialects = smb30_neg_dialects,
> +};
> +
> +static __le16 smb302_neg_dialects[] = {
> +	cpu_to_le16(SMB302_PROT_ID),
>   };
>   
>   struct smb_version_values smb302_values = {
> @@ -5746,6 +5773,12 @@ struct smb_version_values smb302_values = {
>   	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
>   	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
>   	.create_lease_size = sizeof(struct create_lease_v2),
> +	.neg_dialect_cnt = ARRAY_SIZE(smb302_neg_dialects),
> +	.neg_dialects = smb302_neg_dialects,
> +};
> +
> +static __le16 smb311_neg_dialects[] = {
> +	cpu_to_le16(SMB311_PROT_ID),
>   };
>   
>   struct smb_version_values smb311_values = {
> @@ -5767,4 +5800,6 @@ struct smb_version_values smb311_values = {
>   	.signing_enabled = SMB2_NEGOTIATE_SIGNING_ENABLED | SMB2_NEGOTIATE_SIGNING_REQUIRED,
>   	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
>   	.create_lease_size = sizeof(struct create_lease_v2),
> +	.neg_dialect_cnt = ARRAY_SIZE(smb311_neg_dialects),
> +	.neg_dialects = smb311_neg_dialects,
>   };
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 223056097b54..482ed480fbc6 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -897,27 +897,10 @@ SMB2_negotiate(const unsigned int xid,
>   	memset(server->preauth_sha_hash, 0, SMB2_PREAUTH_HASH_SIZE);
>   	memset(ses->preauth_sha_hash, 0, SMB2_PREAUTH_HASH_SIZE);
>   
> -	if (strcmp(server->vals->version_string,
> -		   SMB3ANY_VERSION_STRING) == 0) {
> -		req->Dialects[0] = cpu_to_le16(SMB30_PROT_ID);
> -		req->Dialects[1] = cpu_to_le16(SMB302_PROT_ID);
> -		req->Dialects[2] = cpu_to_le16(SMB311_PROT_ID);
> -		req->DialectCount = cpu_to_le16(3);
> -		total_len += 6;
> -	} else if (strcmp(server->vals->version_string,
> -		   SMBDEFAULT_VERSION_STRING) == 0) {
> -		req->Dialects[0] = cpu_to_le16(SMB21_PROT_ID);
> -		req->Dialects[1] = cpu_to_le16(SMB30_PROT_ID);
> -		req->Dialects[2] = cpu_to_le16(SMB302_PROT_ID);
> -		req->Dialects[3] = cpu_to_le16(SMB311_PROT_ID);
> -		req->DialectCount = cpu_to_le16(4);
> -		total_len += 8;
> -	} else {
> -		/* otherwise send specific dialect */
> -		req->Dialects[0] = cpu_to_le16(server->vals->protocol_id);
> -		req->DialectCount = cpu_to_le16(1);
> -		total_len += 2;
> -	}
> +	req->DialectCount = cpu_to_le16(server->vals->neg_dialect_cnt);
> +	memcpy(req->Dialects, server->vals->neg_dialects,
> +		sizeof(__le16) * server->vals->neg_dialect_cnt);
> +	total_len += sizeof(__le16) * server->vals->neg_dialect_cnt;
>   
>   	/* only one of SMB2 signing flags may be set in SMB2 request */
>   	if (ses->sign)
> @@ -1145,34 +1128,11 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
>   	else
>   		pneg_inbuf->SecurityMode = 0;
>   
> -
> -	if (strcmp(server->vals->version_string,
> -		SMB3ANY_VERSION_STRING) == 0) {
> -		pneg_inbuf->Dialects[0] = cpu_to_le16(SMB30_PROT_ID);
> -		pneg_inbuf->Dialects[1] = cpu_to_le16(SMB302_PROT_ID);
> -		pneg_inbuf->Dialects[2] = cpu_to_le16(SMB311_PROT_ID);
> -		pneg_inbuf->DialectCount = cpu_to_le16(3);
> -		/* SMB 2.1 not included so subtract one dialect from len */
> -		inbuflen = sizeof(*pneg_inbuf) -
> -				(sizeof(pneg_inbuf->Dialects[0]));
> -	} else if (strcmp(server->vals->version_string,
> -		SMBDEFAULT_VERSION_STRING) == 0) {
> -		pneg_inbuf->Dialects[0] = cpu_to_le16(SMB21_PROT_ID);
> -		pneg_inbuf->Dialects[1] = cpu_to_le16(SMB30_PROT_ID);
> -		pneg_inbuf->Dialects[2] = cpu_to_le16(SMB302_PROT_ID);
> -		pneg_inbuf->Dialects[3] = cpu_to_le16(SMB311_PROT_ID);
> -		pneg_inbuf->DialectCount = cpu_to_le16(4);
> -		/* structure is big enough for 4 dialects */
> -		inbuflen = sizeof(*pneg_inbuf);
> -	} else {
> -		/* otherwise specific dialect was requested */
> -		pneg_inbuf->Dialects[0] =
> -			cpu_to_le16(server->vals->protocol_id);
> -		pneg_inbuf->DialectCount = cpu_to_le16(1);
> -		/* structure is big enough for 4 dialects, sending only 1 */
> -		inbuflen = sizeof(*pneg_inbuf) -
> -				sizeof(pneg_inbuf->Dialects[0]) * 3;
> -	}
> +	pneg_inbuf->DialectCount = cpu_to_le16(server->vals->neg_dialect_cnt);
> +	memcpy(pneg_inbuf->Dialects, server->vals->neg_dialects,
> +		server->vals->neg_dialect_cnt * sizeof(__le16));
> +	inbuflen = offsetof(struct validate_negotiate_info_req, Dialects) +
> +		sizeof(pneg_inbuf->Dialects[0]) * server->vals->neg_dialect_cnt;
>   
>   	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>   		FSCTL_VALIDATE_NEGOTIATE_INFO,
