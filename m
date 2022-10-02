Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6050C433FE
	for <linux-cifs@archiver.kernel.org>; Sun,  2 Oct 2022 18:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiJBSex (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiJBSev (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 2 Oct 2022 14:34:51 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E72011163
        for <linux-cifs@vger.kernel.org>; Sun,  2 Oct 2022 11:34:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a7iYY/HN2EYm0760EDk9chKvgmVWKq/gBp16DcK4vHdW4Ia8aoBNFZ8nJvJzZedUbiBug+yf8CoQgzPD7Jk1/g/V9+r8x37DM6cVcKtVmZ+R2OKgqSTCKL6oipS7Oo8/VKvrw1484VHGyF5b3aLSQdVxNqB/IyercF466pXXn4kGtgZBXDW+taveFFYvJbWEje64KrlcyRaksPVEVUQV5PUzp+co14+SGbxeGS5jdICp5OZ41dKflfWxEF1oduLyqc/X/6ER33XASNokXnL2jHtpzcQauyYUrkpJwspPIurPp/+O6uA6aLYpJGTH9SBK+WER4+eNduNIitzrAszUOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WXHGMs7SHYmYQRov6D7O4DvHD+JFgM2hwD0frmXlht0=;
 b=m01WVWlo5q64iB4o+k0Yhf1LOP8alIRW1R5Ed6G6LLxYqhubhn/s/G1+TQADUDOzRShwzTWJgJNHuKOUF78R/UvaSxmsXyYuoK4U389akpSELz6+Twt47uPKK+KkiSYOcXQWlXhW2uL+nF2uQRngx5cK4JrL2vWW1GXqm6aPwLlF4GTMPlh2xM2XGZEGQkOOVXghj5k8wcpcTnGqEky9M8nijR02/hLLz3OozhBD4UzuOsfPqUaONE+ClpygYHnd0xIJYTeGmkITR0UAY/oNJPpD6cNbvtFwbRwZEgh3tde8r6Mk70EH3gVT5TZPlSH+Wvirve3GnK7c0ttsoKR2Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM6PR01MB6074.prod.exchangelabs.com (2603:10b6:5:204::18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17; Sun, 2 Oct 2022 18:34:46 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef%5]) with mapi id 15.20.5676.028; Sun, 2 Oct 2022
 18:34:45 +0000
Message-ID: <baba86a7-060b-c878-95ed-0310def52850@talpey.com>
Date:   Sun, 2 Oct 2022 14:34:43 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v4] ksmbd: validate share name from share config response
Content-Language: en-US
To:     =?UTF-8?Q?Atte_Heikkil=c3=a4?= <atteh.mailbox@gmail.com>
Cc:     linkinjeon@kernel.org, linux-cifs@vger.kernel.org
References: <20221002024628.106816-1-atteh.mailbox@gmail.com>
 <20221002154021.10926-1-atteh.mailbox@gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20221002154021.10926-1-atteh.mailbox@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR01CA0004.prod.exchangelabs.com (2603:10b6:208:10c::17)
 To SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|DM6PR01MB6074:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e3657de-d4f4-4fbd-f775-08daa4a4c736
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XFi53QyoYHB2UqdoPGG/sHuGp56yHRWbojXusUA6LdZzwNYa2bDee/PxfnQsGEjtezKQOKE5Qb72mLIkDKi/wOKQ2L9BM8Ylo5jD/b3kVVwyglu2q8ALa5LGnR+CU5XQP9uoA8YOJuYyD7lqjJ4MnShzwK/8Z8vw1Xi4uVqollalIC153lZWs3sE2AqF/R7cUR46W8xbdRbzm1wfLO/mZPGVkrdvwSOqXBoUoFz0iWQawmqW4eUatHLCIsu7i+39ZwE2ij93Hyoc0kOSrFOIqlZCCSbF0mAwqs8C/eruXq4TSMvD/xeSNcGQgICFoyoH/Yqf9RtPW8Ei5+mcUtFOdzUH6w32MuhhAdInwe2tIOs8z7kkyMwxyxmAH3hyk+lU0CmJf3zBG+lXGEbFNyGVffx2EgQbOcEH7/3ykkNRZeXDfROvn8cCU8neolplezCNkXijW5CT9zlgiUV5QkY0lTzgR1uo1yuwuh0d9IIOJ910nMoYRW9ErZLIvJ5/pb9SCJpfzx+drApKbdSVyefSSJ8OXrXFtWqXcRfDLzvArhQlwVuoqeNZKK53EY3gkwoa9SthiG/zUvAY0dnMZTGE2lIaLHYj4x6Kmmf1pfvt3ooTVLdpwP5ez12UwP8XQfOjWiu6ZNk78n5zwXA012BBsSqq6Sf6zYIeEJ2SwaGwBMQvMya0NMoxOiHwUQhyBvJxT9H46VSSnqLjIZPL0JMzvnWHGkOqiptUXOMQQFXjlshZFyy4pT6TST8c+9nxZC+dZKFbUy/biaeToh7RII8xojDYUntOjjIpR8k98WP6oMA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(366004)(39830400003)(396003)(451199015)(31686004)(36756003)(316002)(6916009)(86362001)(31696002)(186003)(38350700002)(83380400001)(38100700002)(2616005)(26005)(6512007)(53546011)(6506007)(478600001)(6486002)(66476007)(66946007)(66556008)(52116002)(8676002)(4326008)(5660300002)(15650500001)(2906002)(41300700001)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjhjZDlvVmJqbXdTNEhtbThkeE1CQXJBY3oxWDEyaTVwejRMUVZOdWx3dkVU?=
 =?utf-8?B?ejdlN2poSDNNY2FCTTlQaVNkaW9ueEdiRVpGOVdvblJUWmdqVWhyZUNSdHJM?=
 =?utf-8?B?eFQwYkd6VkFiOHJ5VUVlL3JlY0FJMzFCWUJSTWNkOEtiZFV2N2dEL00rdTly?=
 =?utf-8?B?QlhPWEtOcjBwalpFNDJFTmh3c0J6T20vNG43aUVadWlTYjNkRXJCL3BKakhq?=
 =?utf-8?B?aXUwUTRIZUV0VTRBT1Y2VTJhalExWTZXYXVQQkFiN0pEN1AvSTNEOWZvdEVs?=
 =?utf-8?B?S1JEOE00N2pxcFNwNHJiMmZ1d0R1d1dOWi9waGs2ZGYyNGlhcjZHZTdZaHhB?=
 =?utf-8?B?YmhmSDdKTldVdE9oNUVXVktUV2NXZ0g5VWNxekRwVU90WmFTY3J2SlJzcVdS?=
 =?utf-8?B?MXQxQit5R1NZOW85bHpXVVV1NFZScFpTeWkydnVCaGZmNloycDRDSTRwd1lS?=
 =?utf-8?B?d1R6WCtIWWl4eWFFSVNmNHJiRm1OT2wvdnZKQWptSHNYK0lvaHNtQ1pDSUNI?=
 =?utf-8?B?Z3NFalErTmhyNEdjOGFqUHBFQUxUYTVTSGhVVUE5K0hQYmp5WEpjUFl5TTZF?=
 =?utf-8?B?ekE1dWQ0Z1lsaEJSdHViQXcxM2djWjhLcUpwYW53ZWhqR1JYeDNuYW56Q05S?=
 =?utf-8?B?YXFFem5iQTI4dWNmUUpCYnpuMCt5U0o3cWNDMWxRazY4bmI5N0VrNlJ6RXNp?=
 =?utf-8?B?ek9sWXNEZzNmNndiRnlVcElISE1maDZzSEpqWDhSU1pZckVnZnNBdGVndHIy?=
 =?utf-8?B?dDJwZ1lYby9ET2NNTEhhUm4vWXk1dVA5NzAxa3lKaGVDbDdtY1lCTkdQK1lS?=
 =?utf-8?B?U2JKODV1Y1lNVUM0WGtsRHdiTVZKdGZ6VWtYczM1bG82cncySENEVFRlZXB2?=
 =?utf-8?B?NHZQVFFPRXV4WC9FS2hCY2tHRnd6R3dzV1lFckVzSWFONmpObnZmMWw4T3pN?=
 =?utf-8?B?VW1JcjJaWXJCQXNvNm8wZ0x6a29jOUZ1Q3Z4b1lTQTQ4R1krMlZ4Q3R1a205?=
 =?utf-8?B?aGFTUnFVbUo0dEpjbjl2YzBsTEtzNDlyRk1ta0VaL0RRdDhxaWdNMUMxYndO?=
 =?utf-8?B?aHJXMDlIQ083Sy90bUpaSThOZ3FsZzZIZ2RCUW1MM2c0L1NJYmhMUDNqUG9m?=
 =?utf-8?B?K1JxcjlseE1iVnluTERDbW1vVjY3T2JVRzhSM3MvRGtMSzhlblFkR1BNamZD?=
 =?utf-8?B?Y1kxNU5yQXRFNWF0YlBGazFUYUpEeTU3Y01IbnMvV2RCMFJUSXVxMHh2VzFC?=
 =?utf-8?B?VHdzbHRndjc2cWxwYUNvdks0VVhNOXJicU1TalZxVElIbklDQXd3WUhXM3Ja?=
 =?utf-8?B?bWRRN0FvQkRXR2gwWStOWWF1Qm5tbTNUNGpkSUtaR1hBSVFKTUVSRC9sOWJy?=
 =?utf-8?B?eWJ6eVoxQ2pzZmdDMDNUcDV6TGdRZ0lQS3pZeGgrR29WYXIydWN0UWp5b284?=
 =?utf-8?B?SmdsRytwVTJlSzhyUUV1NXlUZmNub0ovSTJ4RkFOUUg1Zkx6Ykp1QUNFOTJy?=
 =?utf-8?B?Y0VUZDVKcS9MS3JuR1l1alFTZ29nNXd2KzR6bDc4YnU1ZldaRjJ4NUVSQVo2?=
 =?utf-8?B?M2N3TjZHU09Hd0xpaWY1STZCTklteGg3cG5xM2FFSDl1Nmw4WGxuckVMQ0Nn?=
 =?utf-8?B?RVFKUk8wc2NjRkViL1UzSDdBSlMxc0p3UVdDcW9qTHhCQitpalRqM2dKcmxY?=
 =?utf-8?B?TWl3R2pxcVNGcnVNeStKYUVxcm1XK1k4OGY5SjJGZkU5LytWdE1jK0pCdnQ0?=
 =?utf-8?B?S2FBU1hNZ0xUdVozVHprZ1RXZ3kvK3BKdWxCdnhZNnNsMUhTcWg2RWFIVjJt?=
 =?utf-8?B?MURXcXEzNWxoOHdqMnh0bFQ3c3EvNEpCdHJJUUw0TTQ2VW9zUjNXQ3BsVnBR?=
 =?utf-8?B?TGdUK0t3eWozKzNqSC9CZ2pjN2hwdTRKYWpHVFVib2hiWTBnZnVPOTNyRnVW?=
 =?utf-8?B?M1JQMlBVbDF2ZGZXaE5mT2hxMkNRYys1WXQwc2ZiVTc4Y0dkaloralJHRjZL?=
 =?utf-8?B?L094NWtka090UXk1VnkzTXVnS3M0dGwwMW9Lckx5L0VYd0RyMFpkVjlQaWJ2?=
 =?utf-8?B?ditYY3JvRndKUVRCeFdqcjdmR052RHA2TXRvMEJnZU5jbE45VWlKREZiVHUx?=
 =?utf-8?Q?x6XM+FsHwqI0lfDXHBKthHbwA?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e3657de-d4f4-4fbd-f775-08daa4a4c736
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2022 18:34:45.5674
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5mek23EfKSzfcmUsUIqzAYCggJft9dzFpUXYCboQmsrkkwvCHzMti9DNw3Kvl/jv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB6074
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/2/2022 11:40 AM, Atte Heikkilä wrote:
> On Sun,  2 Oct 2022 05:46:28 +0300, Atte Heikkilä wrote:
>> ...
>> diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
>> index e0cbcfa98c7e..ff07c67f4565 100644
>> --- a/fs/ksmbd/ksmbd_netlink.h
>> +++ b/fs/ksmbd/ksmbd_netlink.h
>> @@ -163,7 +163,8 @@ struct ksmbd_share_config_response {
>>   	__u16	force_directory_mode;
>>   	__u16	force_uid;
>>   	__u16	force_gid;
>> -	__u32	reserved[128];		/* Reserved room */
>> +	__s8	share_name[KSMBD_REQ_MAX_SHARE_NAME];
>> +	__u32	reserved[112];		/* Reserved room */

I notice you still have "112" here, did you reject my suggestion
to code the size relative to KSMBD_REQ_MAX_SHARE_NAME?

Either way I think I made a flawed suggestion. The "reserved" field
is __u32 but the KSMBD_REQ_MAX_SHARE_NAME is __s8. So, two things:

- why is share_name an __s8? Wouldn't __u8 be more appropriate?
- why is reserved a __u32? ISTM that __u8 would also be a better
   choice, and then the size would be "512 - KSMBD_REQ_MAX_SHARE_NAME".


>>   	__u32	veto_list_sz;
>>   	__s8	____payload[];
>>   };
>> diff --git a/fs/ksmbd/mgmt/share_config.c b/fs/ksmbd/mgmt/share_config.c
>> index 5d039704c23c..dfb4bb365891 100644
>> --- a/fs/ksmbd/mgmt/share_config.c
>> +++ b/fs/ksmbd/mgmt/share_config.c
>> @@ -16,6 +16,7 @@
>>   #include "user_config.h"
>>   #include "user_session.h"
>>   #include "../transport_ipc.h"
>> +#include "../misc.h"
>>   
>>   #define SHARE_HASH_BITS		3
>>   static DEFINE_HASHTABLE(shares_table, SHARE_HASH_BITS);
>> @@ -119,7 +120,8 @@ static int parse_veto_list(struct ksmbd_share_config *share,
>>   	return 0;
>>   }
>>   
>> -static struct ksmbd_share_config *share_config_request(const char *name)
>> +static struct ksmbd_share_config *share_config_request(struct unicode_map *um,
>> +						       const char *name)
>>   {
>>   	struct ksmbd_share_config_response *resp;
>>   	struct ksmbd_share_config *share = NULL;
>> @@ -133,6 +135,17 @@ static struct ksmbd_share_config *share_config_request(const char *name)
>>   	if (resp->flags == KSMBD_SHARE_FLAG_INVALID)
>>   		goto out;
>>   
>> +	if (*resp->share_name) {
>> +		char *cf_resp_name;
>> +		bool equal;
>> +
>> +		cf_resp_name = ksmbd_casefold_sharename(um, resp->share_name);
>> +		equal = !IS_ERR(cf_resp_name) && !strcmp(cf_resp_name, name);
>> +		kfree(cf_resp_name);
> 
> Well, kfree() is *not* a no-op for ERR_PTR() like it is for NULL so
> this patch is not good either. At least I'm running out of ways to get
> this wrong.

:)

Tom.


> 
>> +		if (!equal)
>> +			goto out;
>> +	}
>> +
>>   	share = kzalloc(sizeof(struct ksmbd_share_config), GFP_KERNEL);
>>   	if (!share)
>>   		goto out;
>> @@ -190,7 +203,8 @@ static struct ksmbd_share_config *share_config_request(const char *name)
>>   	return share;
>>   }
>>   
>> -struct ksmbd_share_config *ksmbd_share_config_get(const char *name)
>> +struct ksmbd_share_config *ksmbd_share_config_get(struct unicode_map *um,
>> +						  const char *name)
>>   {
>>   	struct ksmbd_share_config *share;
>>   
>> @@ -202,7 +216,7 @@ struct ksmbd_share_config *ksmbd_share_config_get(const char *name)
>>   
>>   	if (share)
>>   		return share;
>> -	return share_config_request(name);
>> +	return share_config_request(um, name);
>>   }
>>   
>>   bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
>> diff --git a/fs/ksmbd/mgmt/share_config.h b/fs/ksmbd/mgmt/share_config.h
>> index 7f7e89ecfe61..3fd338293942 100644
>> --- a/fs/ksmbd/mgmt/share_config.h
>> +++ b/fs/ksmbd/mgmt/share_config.h
>> @@ -9,6 +9,7 @@
>>   #include <linux/workqueue.h>
>>   #include <linux/hashtable.h>
>>   #include <linux/path.h>
>> +#include <linux/unicode.h>
>>   
>>   struct ksmbd_share_config {
>>   	char			*name;
>> @@ -74,7 +75,8 @@ static inline void ksmbd_share_config_put(struct ksmbd_share_config *share)
>>   	__ksmbd_share_config_put(share);
>>   }
>>   
>> -struct ksmbd_share_config *ksmbd_share_config_get(const char *name);
>> +struct ksmbd_share_config *ksmbd_share_config_get(struct unicode_map *um,
>> +						  const char *name);
>>   bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
>>   			       const char *filename);
>>   #endif /* __SHARE_CONFIG_MANAGEMENT_H__ */
>> diff --git a/fs/ksmbd/mgmt/tree_connect.c b/fs/ksmbd/mgmt/tree_connect.c
>> index 867c0286b901..8ce17b3fb8da 100644
>> --- a/fs/ksmbd/mgmt/tree_connect.c
>> +++ b/fs/ksmbd/mgmt/tree_connect.c
>> @@ -26,7 +26,7 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
>>   	struct sockaddr *peer_addr;
>>   	int ret;
>>   
>> -	sc = ksmbd_share_config_get(share_name);
>> +	sc = ksmbd_share_config_get(conn->um, share_name);
>>   	if (!sc)
>>   		return status;
>>   
>> @@ -61,7 +61,7 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
>>   		struct ksmbd_share_config *new_sc;
>>   
>>   		ksmbd_share_config_del(sc);
>> -		new_sc = ksmbd_share_config_get(share_name);
>> +		new_sc = ksmbd_share_config_get(conn->um, share_name);
>>   		if (!new_sc) {
>>   			pr_err("Failed to update stale share config\n");
>>   			status.ret = -ESTALE;
>> diff --git a/fs/ksmbd/misc.c b/fs/ksmbd/misc.c
>> index 28459b1efaa8..9e8afaa686e3 100644
>> --- a/fs/ksmbd/misc.c
>> +++ b/fs/ksmbd/misc.c
>> @@ -227,7 +227,7 @@ void ksmbd_conv_path_to_windows(char *path)
>>   	strreplace(path, '/', '\\');
>>   }
>>   
>> -static char *casefold_sharename(struct unicode_map *um, const char *name)
>> +char *ksmbd_casefold_sharename(struct unicode_map *um, const char *name)
>>   {
>>   	char *cf_name;
>>   	int cf_len;
>> @@ -273,7 +273,7 @@ char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename)
>>   		name = (pos + 1);
>>   
>>   	/* caller has to free the memory */
>> -	return casefold_sharename(um, name);
>> +	return ksmbd_casefold_sharename(um, name);
>>   }
>>   
>>   /**
>> diff --git a/fs/ksmbd/misc.h b/fs/ksmbd/misc.h
>> index cc72f4e6baf2..1facfcd21200 100644
>> --- a/fs/ksmbd/misc.h
>> +++ b/fs/ksmbd/misc.h
>> @@ -20,6 +20,7 @@ int get_nlink(struct kstat *st);
>>   void ksmbd_conv_path_to_unix(char *path);
>>   void ksmbd_strip_last_slash(char *path);
>>   void ksmbd_conv_path_to_windows(char *path);
>> +char *ksmbd_casefold_sharename(struct unicode_map *um, const char *name);
>>   char *ksmbd_extract_sharename(struct unicode_map *um, const char *treename);
>>   char *convert_to_unix_name(struct ksmbd_share_config *share, const char *name);
>>   
>> -- 
>> 2.37.3
>>
>>
> 
