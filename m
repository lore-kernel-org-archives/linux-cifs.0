Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39F56C54EE9
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Sep 2022 14:01:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237090AbiIBOBc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Sep 2022 10:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237132AbiIBN7a (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 2 Sep 2022 09:59:30 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 986E61403ED
        for <linux-cifs@vger.kernel.org>; Fri,  2 Sep 2022 06:31:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fBMM+1X2P7N9CADQ7uWWc0Z1SXK9qKdmlsU0eF8127F3wjRqWdS4rCaCU6D4Cdaah2xi3d5heOtDnJZlAyLun6Jm5QANx3DnqQ+Rgh2lMx+K78QzcNmyOW+EOtninVpCHCiPGmCUGMrPfYg0H03LjF9qJ5Xkp8cjSZfdFt1liXYpt3+Smnagds18BLeq0eQbn674ODEfZaj75wJmeSTrgiiFyjbJx634YFyN3agC8GbEj5Uy1PUKRxjrQ7x+SIcEQx7P8tt4SSQwtRkq/iIg8XcGNI8lgWlYt1oARI55zsnp60J3cUkwCb1sJbcBNCPyudruwg3xvjc0cj0jER5esw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=898jbZdSwj6V0kAbF/2e6BmYXHKtpUs0pgC/C980tPo=;
 b=NKPfSeS/dEOqu3yzR6BMA9bFpHoQBekYFI2Z2/MyRPtpwX9DruIxGmafihZ/RgsWw/efcu4g+8UnIEkHV2WVBxK2ly0PdHdn5Sezd2CNi5t+5hbp4QiGAw/rNKmHNZC6zVjSYF+eO8o+WdFc1AIS1SgyqIIibT2EeqYo/TfbqvRJnRAWs9x58mBG2pmKUUkQRzteDEV/kWnK8olwyOum8Wr6tn20/l5/cZNtkf/59W8AhLRnPbiby3FQhhdihyOCfj1oPBmwWlswZ2geIdaJRh94eArRnt/I+h07aUspbbV92Awh6hD+Jn6IXryNP23YSWB9PW2wC+KG9g2EvxzdRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BYAPR01MB4438.prod.exchangelabs.com (2603:10b6:a03:98::12) by
 SA0PR01MB6203.prod.exchangelabs.com (2603:10b6:806:e0::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.10; Fri, 2 Sep 2022 13:31:32 +0000
Received: from BYAPR01MB4438.prod.exchangelabs.com
 ([fe80::6d1c:4239:2299:c1f6]) by BYAPR01MB4438.prod.exchangelabs.com
 ([fe80::6d1c:4239:2299:c1f6%7]) with mapi id 15.20.5566.021; Fri, 2 Sep 2022
 13:31:31 +0000
Message-ID: <6e829386-6939-091e-8669-90b2aeb1cec2@talpey.com>
Date:   Fri, 2 Sep 2022 09:31:28 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v4 4/5] cifs: Add neg dialects info to smb version values
Content-Language: en-US
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com,
        linkinjeon@kernel.org, hyc.lee@gmail.com
References: <20220901142413.3351804-1-zhangxiaoxu5@huawei.com>
 <20220901142413.3351804-5-zhangxiaoxu5@huawei.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220901142413.3351804-5-zhangxiaoxu5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0081.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::26) To BYAPR01MB4438.prod.exchangelabs.com
 (2603:10b6:a03:98::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed5a3146-57db-4d7c-a342-08da8ce772b9
X-MS-TrafficTypeDiagnostic: SA0PR01MB6203:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XmE4Pk9/JFcNwxHdEVTt/YGhiRDG4axb663iXdDV0k6iC4MqKVR1l3xImbGd1QX4JIna7s7Fg9ZGh59m0P7YqkINYNy0r6Zpqsviuv5qXPFpITmeEgug1R8hk2EX+WDncU8QLKQtxU/giXnGE/oXdZ4clgR7PfTxNmjV/sVtl5caI/RcNmh1ZtKWP9d16DnOf8w9cE5kZGNZaXpYXArg3Zo3VsnNLuMpmIGQGVvNP+1As92CprhmBtZANQzMnfWYoWolqAnFlmj5B/PLh4MnCepDl1sNoK1Bnb9M166FHFgwyjn2gll0OHRt2HhDWgTQhOdx9I8t/9QagirCRfPInCgOvOGb42gdrB1s+hZ2kAqISxXVHOYOt+5YFwWrPb9e5IkD3QHcFNBKhqS1afXUky14lHa7muO31AbTABvzBpG8UuNMQ1C0cokUq+/hVp/S3n8xS6xZDUtI/+zkC4oLUzjynCZilg88BwyGURq6+oV07s1HUj2GpvHKTb44WF6O2G17aXUiv6s+AqTJK0tYjK5yId05HCPHFBFlkHwUskLtGsSK/NPF3HxJ13LdS7jh5RCEKsmVlgareqpBZmK53RkCmtF7aUZteULZCw0wFuLr375RVPpSQQ6lmawDzknGQaxiXCSvz6Wh/BPbCP9IGHcOzYfUIaYFvpmvIWhTQLFBMbDqGcX/MoXPjXZlWpnSkEUOQg2DA1dZohKHz35yGQW0MBRzghjn447etDlLuwbYGwtebAocmIq7nuBhyVummxd3t8fqKGFs2S4kTRcgDiCWBw97dbaEu3YE7yHHFqQ++GJofgZgMt1+oQW4WUbC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB4438.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39830400003)(346002)(366004)(136003)(376002)(2616005)(31686004)(2906002)(36756003)(26005)(6512007)(186003)(66556008)(66476007)(7416002)(8936002)(5660300002)(921005)(8676002)(66946007)(316002)(52116002)(478600001)(41300700001)(6506007)(53546011)(6666004)(6486002)(38350700002)(38100700002)(86362001)(31696002)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2JLUE9sc2NMeWZBZzlXNXJPSTBnRTBnTjNKQUdWcHZqc1plM1Bja0RuSmRr?=
 =?utf-8?B?R2tUWHV6SU1GN2tkZzA1a201VnVQN3V2c1hDNVBLSlJrTXJ3NjhJWVhwZ2Ny?=
 =?utf-8?B?dFZxZVBQU1lGQWo3aEx3cmd2TVZrNzM2c2VHV2U2UWdZV2ZhNjV6VjNYT3F1?=
 =?utf-8?B?YmxSbHBoUnYzdDVCVkFUSXhsSVRVbW5qczVaOUgwSE9NcDlYZEpUWHFJQVFw?=
 =?utf-8?B?UFd4OE84K0pIOW1VT2dzMTkvRjdnUVJkdGpKUlFoblNHZlRhQ2VhTzNPazNG?=
 =?utf-8?B?NWtIeTVITkJxUHE1Sko2MEkzdmhDREdmKzRIR3M1bC82Slh3cFN0L0F6YmRm?=
 =?utf-8?B?WURuelNjTjcxWGFVMloyN0dmdlBQU3lnc2txZWEzYzRHaytnMnEvUXhKZ1Z6?=
 =?utf-8?B?MFc4UVJjdWZicGl4d1pKTEhVWUZPMU11YnJhNmF3NWN2N1lHNktNZE9XenRU?=
 =?utf-8?B?YWd5OElIRHdYd3JKVlF5TjZOaTdCUTF0RE43N0VFWkxtaXA3K294QXJ5TWpF?=
 =?utf-8?B?Y0Q4WE1XTkpOR0M1WG5xc01XQUZxQ1FrN0ZLNk9Db0hDY1RtTGZqdFlGY2dh?=
 =?utf-8?B?T3VOMzcrRHZqOVBNcmVEVGkzdDVLZzhyc0N1blZ6T21GSzVvY0g2VzAxVGRp?=
 =?utf-8?B?Y1luTFFrRFpWVmxML0hkY0hOcml0R3g0OHgvT1RVbVBkalNsOWRRY1Y5K1Ft?=
 =?utf-8?B?aU9nb1cycDFQT2pncGpZNHRNcXZ0ZEwxSjRPTjBuNjBVMVJaZm9zeG9tQVp2?=
 =?utf-8?B?WC9rQ2kwdjNlbHBvWDNJUDR2cm9JeUpvRVJjbFlTK2UvVlhrMG01cWloMmJD?=
 =?utf-8?B?YU9sVTdmMnYzV1FZSS9PUm5XUzJsOGVPam5kOC9MbEQyKzB0MkFvTm5QQWdY?=
 =?utf-8?B?dGFQQ1FPVmZrU3NlK0xxZE5LWnFWdUxLNTl1UTByNmJ2UzFpRGl0TkMzY2hT?=
 =?utf-8?B?VytUNHo3LzZoWHd2aVA1Z1piM2VVUy9ERHl3R05EUzZmaG1NajNObXVtdW9X?=
 =?utf-8?B?TnFNM2xMdGdVVlJZOTlCcHN1QkREbjcvMHhCbDM5T09NVTVYRkw2TWFhRkg5?=
 =?utf-8?B?cmRZYTd6NDRpWWIra3NMWmtjbU5CVU84dVpDNjVjWXFPemlVR3dFeW1OZzdR?=
 =?utf-8?B?U3RiR1pBbzhKa3VyZHd6ZFRLKy8zWlpuWkZQRFJOZzFNdGgwOTVaNWJoS0Ew?=
 =?utf-8?B?ZTI3NXc2SHV5c3MxWUVObXpha3VGWUphV1JTcDRYbmRMU0VlbXFlU0tvdTl1?=
 =?utf-8?B?SW9sT25zQVpxYkJDZm9CVTgyVmVMWlV5TVJQZGxwV2RXQy9vbUtaS0pLWXlL?=
 =?utf-8?B?Mnk0VDV6K0l2aGRYMmxTRmMzRTZvWFV1d0NTdWpLQjZueDNzVVdMSi9KSlQ0?=
 =?utf-8?B?NGpVTW9ac1d4cXJweUhHWUxGY1QxRVJHRGFZK3hDMThJbEZYKzlsdFowTHhS?=
 =?utf-8?B?c1VmT3pSOHpGMnZFbThYYUJHSEVqYXp2MUxjVG1tVnY2WUJ3c2l2MnVINUtU?=
 =?utf-8?B?ejMvdVJTMFVZQkgwRFdMejJFYS9SNUE0SW4vcmVoajFya0V5V0hxNnUxUitI?=
 =?utf-8?B?ZFh4bDIydGhJNVE3Y2JDcGEyRnlHUTJBSVdrU05TcDFkUlhBZWdLNkZZRDdZ?=
 =?utf-8?B?NGVxMWxVTElYTUtobFVhSGJMOVI4WFNUSkdRTHNwOWJSd2M3Zk1ZQ3Bwbm5v?=
 =?utf-8?B?b1YrZTBBNzNOMlR3bmF6RWcrV08vZ01pemtZQlp0Q1E1THJZeFFqU3FhVkcv?=
 =?utf-8?B?MFdDU2dSVkF3SHN5ZFExYVhlZE92TndFYXJRbEZQTmFNOXhzdW9WdE82dU1U?=
 =?utf-8?B?eVYzVzJEOVNsT0hqTG9wVVVVelFhKzhpS000NlJLRGZ1V3B4bFB0d2swYXAr?=
 =?utf-8?B?RjhjS1ZJci9ocXJVWGhWZEFSRDBMMUY0SkJyalRNZDh1Q09GZnpSSlRaMTBU?=
 =?utf-8?B?ei94QzBsdEZ0cFMwdjV1WW1rTiszMjdIQTgxTkh6ZUUwWWUrOHB1dU9qZG91?=
 =?utf-8?B?M0o1WWI4ZHVVUTF5NkpKdURWdjJaTkpmaDZiRGFXcHZxd3FQejA2QzdTTENy?=
 =?utf-8?B?aWFpYkRMTjBubzFyK0tJbGUvWm9nUUNZMzQ5WUJoUU9NTDZNWkVkcE1lN0ZM?=
 =?utf-8?Q?X/Zfz6NtfaLhGj04qaB0fAkLL?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5a3146-57db-4d7c-a342-08da8ce772b9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB4438.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 13:31:31.8948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: laH9RL4fbtSw8nHLqn+b6qrv2+YryYQ+zETOOJGzyD508RKRmkClP+Sb5eEeGC0i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR01MB6203
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Is this really necessary? It's nice and all, but there aren't
any new SMB2/3 dialects coming down the pike. I'm ambivalent
about changing the code unless there's an actual issue, for
the purpose of maintaining stable, etc. Steve?

Acked-by: Tom Talpey <tom@talpey.com>

On 9/1/2022 10:24 AM, Zhang Xiaoxu wrote:
> The dialects information when negotiate with server is
> depends on the smb version, add it to the version values
> and make code simple.
> 
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
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
> index 421be43af425..3df330806490 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -5664,6 +5664,12 @@ struct smb_version_values smb21_values = {
>   	.create_lease_size = sizeof(struct create_lease),
>   };
>   
> +__le16 smb3any_neg_dialects[] = {
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
> +__le16 smbdefault_neg_dialects[] = {
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
> +__le16 smb30_neg_dialects[] = {
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
> +__le16 smb302_neg_dialects[] = {
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
> +__le16 smb311_neg_dialects[] = {
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
> index 37f422eb3876..1fbb8ccf1ff6 100644
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
> @@ -1143,34 +1126,11 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
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
