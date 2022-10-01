Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18078C433FE
	for <linux-cifs@archiver.kernel.org>; Sat,  1 Oct 2022 23:21:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbiJAXVB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 1 Oct 2022 19:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiJAXU7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 1 Oct 2022 19:20:59 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2081.outbound.protection.outlook.com [40.107.96.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5590B578A1
        for <linux-cifs@vger.kernel.org>; Sat,  1 Oct 2022 16:20:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BQp/c1Yag+Wu9/whw/gIxVAb35l/x2zoEkUEUcYHqW6d1UZYDc3FmZuPjJZIgv79LGTXzEplsLe+1eZhrHvGgG+xh597nopxCO+dZjU/jD2Albr/nA+kKqNVvthnVZ4iGg0vqsgehKNboEnV5mVr3gkrh1YO7WUTqKaw9OWmq7bO813M/cOjPYJbhb8fUlhQ54affvQwxxnx5l9uGevxT652KhpH3IOWKDfAeYOpJncjXPrRRhBOBXdQ7cBCf8oV6NHw3JFFRv4KvxVFatwYCUeETaYe8QAoVmg66uPHmg0xABtcch28Olm/f17KTgmcmwH3I4SshkhyuVsi27hVTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gqnYFIftAkpVuhjn5oEBEo25WyAEzyqxKCUPudXlXU8=;
 b=VdkMkxuRo7NVcYSVULdTKiDJpBym9g1sNVIvW3d3X4VuQWPNrR4aLF4CZ/wsy8TakBLc4EcAtmLbKZxkRTdSKh1/jOrDtRtjDLGrJKvPbbVOXCZyrwqgZY/G4DXeE4cqaj5c8J5rxDXFfvJwU/pVHWvebv5Px51j1vmfBuc9hJwkrYREcRuhoYSwhUa2Yi+SsQSRkGfQXXJYWuWPvd7ZSb2Dl6LPzzRkgKXNOAmWO40xVRrkvpLNGv0/GyZkthZu/ihnBqXPrdC+CciYEevyjifCJZOj/yM10oterlJaMjHDCvK0eMgoc/kn/fHXaQp+RmtHwiqsKETSJTlcOsUYMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SN6PR01MB4256.prod.exchangelabs.com (2603:10b6:805:ae::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.18; Sat, 1 Oct 2022 23:20:55 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::5c62:b328:156a:2ded]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::5c62:b328:156a:2ded%7]) with mapi id 15.20.5676.020; Sat, 1 Oct 2022
 23:20:54 +0000
Message-ID: <3156964e-ef5d-2963-9945-04bcecabe896@talpey.com>
Date:   Sat, 1 Oct 2022 19:20:52 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v3] ksmbd: validate share name from share config response
Content-Language: en-US
To:     =?UTF-8?Q?Atte_Heikkil=c3=a4?= <atteh.mailbox@gmail.com>,
        linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org
References: <20221001225324.21771-1-atteh.mailbox@gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20221001225324.21771-1-atteh.mailbox@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0329.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::34) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SN6PR01MB4256:EE_
X-MS-Office365-Filtering-Correlation-Id: 025bcd7f-5618-49f3-3ad7-08daa40396c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CCHidJteAkkwb35o8qyQ9l3dcGtVtRc25qu5C3Q7VLeECvldRD7N6azelGn85FmgVbBKyApAoDfGuyjF6FHZ/7OBFmd8TSAMNs8Gv67ryPOHf2KCKxs/zWEavptZqL6d+keLUOWeC9rLXR2KgW8cUT8mohiP0xEJm1+8e3irSM21W8x0qnldUF7DWlHVPAJXNoqP9CQ97WMnCCUjNvXQhBW4/5f73aztTcx0s35Pzj1hZp3Iyry9mVdKQF7mr/DZzpJ89sz6jQuxeXQ0VsCWHcBLO7SCSqfzoVIwwFOGSumazuYn3xYFRJ6wKfK/jExNfZnWiB7F6bx+ySD7B/8qC+jzVnh6+TCqoPVmhL4Bv89mjevK5TpMhUwSRc21GxW1Tc1sQv/GPhSdGqYYSsLX3Jj01v6h/xzMtMsSLXQ5UMTpu8/4eJ13i94MI2W3p1NB6wC3ID4BVODgmIWo3DNG1aPhDTt+SIeofmzuHqsP8ruREJFLHqURCojHsDpipZylE7C6T2HD8SrFrhxChroV1ZO961MyuFjz09+LhrsiY/RLKjC7CxNQiXKdvtBguBP0gDwLK0Bw8HQi5O+G2E1P4eixPp5ueSWNB/LT5B96qPLJ1xawmmochub75Kzc68CEDQ7VLEy+TgmB3WR6Kp37f5VQ26v9GzVmyd2mnSohD4j+Mo5j+oACZ++2Ltt4beDPtcmudzhC/TbvmNNXSdTNEwpdmwQG3Wa8MpjG89jGn9UmOW6ta/2BQEKHtjvE7u+dRaxykQJsLU0yr7vh21No/aC/l+tiA3Q3Cu6iMfuWF4o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(39830400003)(396003)(136003)(451199015)(41300700001)(8936002)(53546011)(66476007)(2906002)(6506007)(66946007)(4326008)(6486002)(478600001)(66556008)(52116002)(38350700002)(15650500001)(31696002)(6512007)(86362001)(2616005)(186003)(26005)(38100700002)(5660300002)(83380400001)(316002)(8676002)(31686004)(36756003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWJKdkFvUFIzU0xXeUltNFR6aGMwVUJSOTlSRjA4K1l5L29hVXBqN0hYWnBn?=
 =?utf-8?B?L2RPN3hIUWVad2JaNWZQSlc2Q1FEcEZsQzRFOWVFVGdwT0JUWmtjbFlBTlNF?=
 =?utf-8?B?THFiWGEvcjQ3aTdFQkZRM2VpRXNUeXpNNTBySkF6SkNMNGpUOGVZTXAvMEVF?=
 =?utf-8?B?Rk5Wd3ArbCtsWmM1ZXpuVVlpU3ZsNEwwSkc2UUF1aEVnZGlxckFhT20wMStU?=
 =?utf-8?B?cFNZQVd5YVN4ZldFY0JIdVdlbWpsVjM5UEpDOW9OaitZd2tzSDA5TGtkd0ph?=
 =?utf-8?B?SFNNeW50MkNQVFd0ZS9IOTlvaDhSQkRueFFNR2swNUdRRFNwazd2dDFIdlRp?=
 =?utf-8?B?dGhza2RRRW9EVEh4aXlwWDBYY3RBbmUvZmc3cmpYdHhiVldsSU1hL1ZZazZz?=
 =?utf-8?B?aHQ2M29KM0YrcWMrZmVUMnJ4WkFuZURrYUZPd3ZPSkZQeGNmOGlqNGhRdE91?=
 =?utf-8?B?RU5NN1NmTGJicm0wUVAxSENXdlo5cDNCTEpzSEl5MGJhdG5PWmxEYmlCTlBB?=
 =?utf-8?B?a3BwVVp2OHJCbmZ5OWthaGJHRTBxMWdlSVhON1ZaVTBBY3cxNVNoRUFWTHN0?=
 =?utf-8?B?N3FGQ2ZjTmtEZzczNjRjTFFPQThQMkRMUWVHenZ4WVlTcmlqSlQwQVNLUzRu?=
 =?utf-8?B?Wmw1Y3ZQNjdQclFpWHBUOGdTZ1libi93L2ZXRWlROTJxN2srTHhUTEdQNkJs?=
 =?utf-8?B?ZnVRbVdXN3pPN042M1pQbGFQUnV0aWgrT0cwMVFCN0lBYWpvUGozUDd1ZHNt?=
 =?utf-8?B?azZQaTg2c3dTSS85Y0laLzlVcnpSUy9KSUs5WkVOcXRzUDlSeGNiNHYzbG5S?=
 =?utf-8?B?R05TMkVCVjJ2L09tTW1GeldDTjJyY1Y3cUdpTXFMT3AvcHNEeTIvUzRkNHB0?=
 =?utf-8?B?M2h2U296SCt0dHZrcTRMU2xFdUVIUW50RmhUbU9MMVJpK0tONnRCeUQxaloy?=
 =?utf-8?B?c0xoQjA5T2hkY3l1VkJtRGNQWGU5M0hpUTVYVHQ1eElVbWpUZTZFN09TVUVr?=
 =?utf-8?B?Z2NOVWJ6a2hyeWdEQnprcVJrYzZZWGMxUWJ1dVZ3S2grN2toZE1zbUxUSzBQ?=
 =?utf-8?B?dVVodUF1UW9TT090VUNFa29SUXlKOTZCdlpWeTJnYTFZU2Y3UEF5aHkyVGNX?=
 =?utf-8?B?UXlQYlhCVThvVldZUnIxcFhpVDZYeFZ1dk1PRjBWRjN5dldZL2VtTW13dzRD?=
 =?utf-8?B?NFpCZW9xc2lQR2Y3YlhoTnpiNXQwOENJR2ZZUnh6c2hzWjRITGswNnQzZzVa?=
 =?utf-8?B?b09wY0JqUG05dWdIeG1pT2N4UjEzZ0Y5VlFadU1vNTNRYWFPeDFhUzNjaFlE?=
 =?utf-8?B?alhWSGhQZDF6dC9XQ0pqWkZkU29XajBWaUQ0elY5UWxqUDhyOHE0ZG4vZk9M?=
 =?utf-8?B?Vm1YaTA3d2tVUkRoYldGdDE4U2NTTktMQmNsVVRQZk9Mb2wraTg2c282Tm9L?=
 =?utf-8?B?citQK0tkVHJJVUYxakxGT1FhOEYxSDgvSDRqUVpJdkJHcVZEZjVZRk5lMTZL?=
 =?utf-8?B?RDZnRWgvaStOV29sR0hSUXpFYzVvZTh3U2FrSDBXOXdWRVM3MUdETXRzdUJT?=
 =?utf-8?B?NFVzNkZwUTdoeHlBVXhLa1hsMW1aeTlWdHE5MWVVdng3SWxsaE9PV3Y3SUlM?=
 =?utf-8?B?WDVhK3dtTHErU0h5VnFHclVsaDByVTZUM3lHdGhpanMycVEvcFBoZDFNUThm?=
 =?utf-8?B?dDNUc2JmQ2RVeVl0TUlPaGdJSWl6MlVsRi9rYzJSL2JrRE5rTWJTVFZlZ0JR?=
 =?utf-8?B?dTBGRWVNNGpxc0lsTEJXbERKbEVPV3JGT00wOXJQVi81VEJKZXFsbHVIQ1F6?=
 =?utf-8?B?R2ZZRUdTUUg0S2lvbHlzckJSYzRyN0Z0REkxQlhGWVdTenhnak1HL2R4RUlC?=
 =?utf-8?B?SWdyNGhHOUloM3dBcWR5N0tMdC9kVGtiYzZOTUpCWEFqQXYvUDcwdUdPTjlr?=
 =?utf-8?B?RDVpUHIzVzdma3gwU2NqN0dxeUZ4WkZ1ZFF6NnV1MkxiRjN3NG5MckYzK3VG?=
 =?utf-8?B?NExqcjk0bkFCS0RsZmpWT3pmT0lITEhab0ZQbEVkVzUvUjhXa1R0bmVPaUtY?=
 =?utf-8?B?d0JnRTF1REgrb0tiU1dWNk9RMi9NWUtjYjk2c3RzcWMzUlJnNUpSYTN2TUlL?=
 =?utf-8?Q?0euM0LI4IL0Gef64YYf6vjWTr?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 025bcd7f-5618-49f3-3ad7-08daa40396c4
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 23:20:54.9208
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: szjY86SQU+FbMEOF0EHR1A8DMWs6YEZEUlypzVaJpNYX9SKVit9mcrDvLIlMnCwK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB4256
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/1/2022 6:53 PM, Atte Heikkilä wrote:
> Share config response may contain the share name without casefolding as
> it is known to the user space daemon. When it is present, casefold and
> compare it to the share name the share config request was made with. If
> they differ, we have a share config which is incompatible with the way
> share config caching is done. This is the case when CONFIG_UNICODE is
> not set, the share name contains non-ASCII characters, and those non-
> ASCII characters do not match those in the share name known to user
> space. In other words, when CONFIG_UNICODE is not set, UTF-8 share
> names now work but are only case-insensitive in the ASCII range.
> 
> Signed-off-by: Atte Heikkilä <atteh.mailbox@gmail.com>
> ---
>   v3:
>     - removed initial strcmp() check since it could only save a call to
>       ksmbd_casefold_sharename() for matching ASCII-only share names
> 
>   v2:
>     - no changes were made
> 
>   fs/ksmbd/ksmbd_netlink.h     |  3 ++-
>   fs/ksmbd/mgmt/share_config.c | 20 +++++++++++++++++---
>   fs/ksmbd/mgmt/share_config.h |  4 +++-
>   fs/ksmbd/mgmt/tree_connect.c |  4 ++--
>   fs/ksmbd/misc.c              |  4 ++--
>   fs/ksmbd/misc.h              |  1 +
>   6 files changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
> index e0cbcfa98c7e..ff07c67f4565 100644
> --- a/fs/ksmbd/ksmbd_netlink.h
> +++ b/fs/ksmbd/ksmbd_netlink.h
> @@ -163,7 +163,8 @@ struct ksmbd_share_config_response {
>   	__u16	force_directory_mode;
>   	__u16	force_uid;
>   	__u16	force_gid;
> -	__u32	reserved[128];		/* Reserved room */
> +	__s8	share_name[KSMBD_REQ_MAX_SHARE_NAME];
> +	__u32	reserved[112];		/* Reserved room */

Because this is a protocol/abi definition, it may be good practice
to code as
	__u32	reserved[128 - KSMBD_REQ_MAX_SHARE_NAME];
just in case the sharename constant changes in future.

>   	__u32	veto_list_sz;
>   	__s8	____payload[];
>   };
> diff --git a/fs/ksmbd/mgmt/share_config.c b/fs/ksmbd/mgmt/share_config.c
> index 5d039704c23c..c62e87b67247 100644
> --- a/fs/ksmbd/mgmt/share_config.c
> +++ b/fs/ksmbd/mgmt/share_config.c
> @@ -16,6 +16,7 @@
>   #include "user_config.h"
>   #include "user_session.h"
>   #include "../transport_ipc.h"
> +#include "../misc.h"
>   
>   #define SHARE_HASH_BITS		3
>   static DEFINE_HASHTABLE(shares_table, SHARE_HASH_BITS);
> @@ -119,7 +120,8 @@ static int parse_veto_list(struct ksmbd_share_config *share,
>   	return 0;
>   }
>   
> -static struct ksmbd_share_config *share_config_request(const char *name)
> +static struct ksmbd_share_config *share_config_request(struct unicode_map *um,
> +						       const char *name)
>   {
>   	struct ksmbd_share_config_response *resp;
>   	struct ksmbd_share_config *share = NULL;
> @@ -133,6 +135,17 @@ static struct ksmbd_share_config *share_config_request(const char *name)
>   	if (resp->flags == KSMBD_SHARE_FLAG_INVALID)
>   		goto out;
>   
> +	if (*resp->share_name) {
> +		char *cf_resp_name;
> +		bool equal;
> +
> +		cf_resp_name = ksmbd_casefold_sharename(um, resp->share_name);
> +		equal = cf_resp_name && !strcmp(cf_resp_name, name);

This is a little bit hard to parse. So, if the casefolding returns
a non-null string, and the result does not equal the original name?
Maybe because it's evaluating a pointer as a bool, and using "!" to
evaluate the strcpy result is the confusing part, to me.

	equal = cf_resp_name != NULL && strcmp(cf_resp_name, name) 0= 0;

Also, strcmp() gets a lot of attention in the kernel these days. Is
this guaranteed safe?

> +		kfree(cf_resp_name);
> +		if (!equal)
> +			goto out;
> +	}
> +
>   	share = kzalloc(sizeof(struct ksmbd_share_config), GFP_KERNEL);
>   	if (!share)
>   		goto out;
> @@ -190,7 +203,8 @@ static struct ksmbd_share_config *share_config_request(const char *name)
>   	return share;
>   }
>   
> -struct ksmbd_share_config *ksmbd_share_config_get(const char *name)
> +struct ksmbd_share_config *ksmbd_share_config_get(struct unicode_map *um,
> +						  const char *name)
>   {
>   	struct ksmbd_share_config *share;
>   
> @@ -202,7 +216,7 @@ struct ksmbd_share_config *ksmbd_share_config_get(const char *name)
>   
>   	if (share)
>   		return share;
> -	return share_config_request(name);
> +	return share_config_request(um, name);
>   }
>   
>   bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
> diff --git a/fs/ksmbd/mgmt/share_config.h b/fs/ksmbd/mgmt/share_config.h
> index 7f7e89ecfe61..3fd338293942 100644
> --- a/fs/ksmbd/mgmt/share_config.h
> +++ b/fs/ksmbd/mgmt/share_config.h
> @@ -9,6 +9,7 @@
>   #include <linux/workqueue.h>
>   #include <linux/hashtable.h>
>   #include <linux/path.h>
> +#include <linux/unicode.h>
>   
>   struct ksmbd_share_config {
>   	char			*name;
> @@ -74,7 +75,8 @@ static inline void ksmbd_share_config_put(struct ksmbd_share_config *share)
>   	__ksmbd_share_config_put(share);
>   }
>   
> -struct ksmbd_share_config *ksmbd_share_config_get(const char *name);
> +struct ksmbd_share_config *ksmbd_share_config_get(struct unicode_map *um,
> +						  const char *name);
>   bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
>   			       const char *filename);
>   #endif /* __SHARE_CONFIG_MANAGEMENT_H__ */
> diff --git a/fs/ksmbd/mgmt/tree_connect.c b/fs/ksmbd/mgmt/tree_connect.c
> index 867c0286b901..8ce17b3fb8da 100644
> --- a/fs/ksmbd/mgmt/tree_connect.c
> +++ b/fs/ksmbd/mgmt/tree_connect.c
> @@ -26,7 +26,7 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
>   	struct sockaddr *peer_addr;
>   	int ret;
>   
> -	sc = ksmbd_share_config_get(share_name);
> +	sc = ksmbd_share_config_get(conn->um, share_name);
>   	if (!sc)

Another pointer boolean evaluation, but I guess this one is existing.

>   		return status;
>   
> @@ -61,7 +61,7 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
>   		struct ksmbd_share_config *new_sc;
>   
>   		ksmbd_share_config_del(sc);
> -		new_sc = ksmbd_share_config_get(share_name);
> +		new_sc = ksmbd_share_config_get(conn->um, share_name);
>   		if (!new_sc) {

Ditto
>   			pr_err("Failed to update stale share config\n");
>   			status.ret = -ESTALE;
> diff --git a/fs/ksmbd/misc.c b/fs/ksmbd/misc.c
> index 28459b1efaa8..9e8afaa686e3 100644
> --- a/fs/ksmbd/misc.c
> +++ b/fs/ksmbd/misc.c
> @@ -227,7 +227,7 @@ void ksmbd_conv_path_to_windows(char *path)
>   	strreplace(path, '/', '\\');
>   }
>   
> -static char *casefold_sharename(struct unicode_map *um, const char *name)
> +char *ksmbd_casefold_sharename(struct unicode_map *um, const char *name)
>   {
>   	char *cf_name;
>   	int cf_len;
> @@ -273,7 +273,7 @@ char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename)
>   		name = (pos + 1);
>   
>   	/* caller has to free the memory */
> -	return casefold_sharename(um, name);
> +	return ksmbd_casefold_sharename(um, name);
>   }
>   
>   /**
> diff --git a/fs/ksmbd/misc.h b/fs/ksmbd/misc.h
> index cc72f4e6baf2..1facfcd21200 100644
> --- a/fs/ksmbd/misc.h
> +++ b/fs/ksmbd/misc.h
> @@ -20,6 +20,7 @@ int get_nlink(struct kstat *st);
>   void ksmbd_conv_path_to_unix(char *path);
>   void ksmbd_strip_last_slash(char *path);
>   void ksmbd_conv_path_to_windows(char *path);
> +char *ksmbd_casefold_sharename(struct unicode_map *um, const char *name);
>   char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename);
>   char *convert_to_unix_name(struct ksmbd_share_config *share, const char *name);
>   
