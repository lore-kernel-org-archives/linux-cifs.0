Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D653CC433FE
	for <linux-cifs@archiver.kernel.org>; Sun,  2 Oct 2022 00:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbiJBAiP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 1 Oct 2022 20:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiJBAiO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 1 Oct 2022 20:38:14 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2068.outbound.protection.outlook.com [40.107.212.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E5B54CAA
        for <linux-cifs@vger.kernel.org>; Sat,  1 Oct 2022 17:38:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OimvIBTeFtc6yPJhjNMPbHxEDZg1dz4u4L+9O0AY3OfXr8mplsza3KgfeJR/C2zY5TqwpXbMoY+70eCuihlYj3RByHmTIeipMzm75Kb1j2R1KVPFNd2faWf/Rq0pVNl3onEFeu3y1Oh5xdey9/84Nux0LdtCe9+p+40OW1Paf9qooUODjRQ5NPW2hCVuM9NlOwJ86xYKRx8tU4oe1loH1Kb7CvZmrydIbRVbF3qb9PO/3J8XxaN1gOk8yJL3hH6XntVWQOkCKClQCAU8c2DEc65hTozO8Zulr+gHyVhCsPxqjcYh75c2PK1ec1s9xbfwNj2zuJQZCHMMwsYnMXyD/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UR6brUHbMGOebpSQ522eBOTCRv4frx329VVwYV2K+Oc=;
 b=Y6rZfW/aeKp30zmY9nh0pRgYXz0I7nsuIMud9HVJX3f/Aoza/wZvnq7L1I4If/8maVw4aYDcLaCFBaM+IDWbPuRo+Fygus2F+DFJKWRdYsmLb9Ct0SXa5Aaxg8ZxC/kDya0LYDVA9A97yjpmA6ZrDROF64B+EcPHEKBL9Hk6BAfP0+SAXOMDTu3XpQvnG8gHQvV9bdHUruI5AxUqebMN3ZFOknOanWjfocbwJGd7Byg8x06wj0ibTxpbyYjlvzmfD5RTBJUuJ8PKeYyuiKi0ieyhUxxHDv99ASJShOJAl5BxmvhECoBrUd9DHrXfASsd5HLDd32I+Y0vlzoDba8nLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 CY1PR01MB2073.prod.exchangelabs.com (2a01:111:e400:c61a::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.23; Sun, 2 Oct 2022 00:38:09 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::5c62:b328:156a:2ded]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::5c62:b328:156a:2ded%7]) with mapi id 15.20.5676.020; Sun, 2 Oct 2022
 00:38:09 +0000
Message-ID: <f7710758-996a-6bf5-4d7c-5c295577c965@talpey.com>
Date:   Sat, 1 Oct 2022 20:38:06 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v3] ksmbd: validate share name from share config response
Content-Language: en-US
To:     =?UTF-8?Q?Atte_Heikkil=c3=a4?= <atteh.mailbox@gmail.com>
Cc:     linkinjeon@kernel.org, linux-cifs@vger.kernel.org
References: <3156964e-ef5d-2963-9945-04bcecabe896@talpey.com>
 <20221002002521.2236-1-atteh.mailbox@gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20221002002521.2236-1-atteh.mailbox@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR02CA0138.namprd02.prod.outlook.com
 (2603:10b6:208:35::43) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|CY1PR01MB2073:EE_
X-MS-Office365-Filtering-Correlation-Id: a2fa9935-5ceb-48ab-4e59-08daa40e6145
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vSdcjU4ukN3KW+guuC9d7kQEEmP0gi8SPUyaotbEOEq39y1G8EtO/eQAulibyPTDrgCkoqbcZ/MT6PBTGLJc5yFOalmWa2G7RJN3rbXv1c113O2dxWN7XJQq31RO782yUsbnGqQY5DF0OM3Crb9/ia1h6chzgJLXzOIdst3qxA9M/kWeejnrhZXtrHsguO2qJThvE3sVuQ2S0GmzF/mSlMw/Ls3CboNZuYsfjHoiu3JvYt7GQcTObUQMw+OcLXHAOB3aYU/1m57QzU1aPPJc/rmfwp9GOZawBWjcV2hJXCgzmLtUbY64gUlW5bxsgjV51tOxkyecvfXaMFwP3SCuk2fWBOgMZym68M01wFh56T9cbcgxdbZcpypymCSsk03inGgKqHoEz4oQMYzkY6IYTqBfn2PLIh6VPiJ9EQjwVdYyFSpuknJDr0g7rUZcDPULsWQ1sifI3Zb/UHtHc9BP48ELZ05ToPmviWohNBFJEwIqC22nyRV1jWdL8JASM0wyKthrtf5A3A8jX3EvxiCCBn4HjmA5iqZwVwf9XNdVEwAdYKBsia8t9PqOg7Cn5Tahvguij1uT/C1MrHVh0f4hKr4PjE7BtpJ9jneGePUTDCw2H3mYpePr+9PNsjlmrGxaCm3Y1KWN07E2Ed++LEVh5GRtcQuUFw3ZpFjMijuwOon/lCVrWQ2/hmtHKUueURLe3S7C5MRw8NGX5y+vnvOMvUYXbYolm40gzRwdFzXM2KDB8CM1AAQelJsYSynCZwRIxbBk+89Df9sRKsvdiYEVnR2EWHJz6lk9WjLapr6yw+4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(346002)(376002)(39830400003)(451199015)(53546011)(36756003)(66946007)(6512007)(4326008)(41300700001)(8676002)(26005)(66476007)(15650500001)(2906002)(5660300002)(8936002)(2616005)(86362001)(31696002)(186003)(478600001)(6666004)(6486002)(38100700002)(316002)(66556008)(83380400001)(6506007)(6916009)(52116002)(38350700002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MG4rR2Fsc1JiNDhvZ1BFaytNWU1vTVVvZ1FGTjN2bEhNd2xwZktZT21Pc0NR?=
 =?utf-8?B?ajJzUHQyN2JENWN3WmRZWDd4ZnVEM3ZaWktrYWZDdVBDYzdYSWVDQkVmY2JJ?=
 =?utf-8?B?S2RKM29hV0VZUG9oK05MbGVlU2h6TUYwc3psVXpPdit3SGtocHY3dkp2SEpH?=
 =?utf-8?B?OWgzaU8zVTBIQVVhZ2Y5eUh1Mm5LR2VvRXFxb1FaSlB0Z05BcWJKT09IMXhD?=
 =?utf-8?B?MThqL01QbkxaZzFHY3dDTy8xRXdiTm4rT2ZCeklYenZkUjNDTFJ0SUVjTU5P?=
 =?utf-8?B?RjJkNGUwQ2t4VW1XZ2xsV2loa2hyNjc0TUdCVDRIU2pFRjY3WjRRS05sRkVB?=
 =?utf-8?B?VVI2OURGZkJzcks0THhCQnNNMmtmYzYxZG5BMVppWlp5a2J3QllBd0o3ZWU3?=
 =?utf-8?B?dXduMkZXS3pnb2J1dlpBaGpVVmNUVG9MUTNRTDNJYmt1SU4waERvRzhVMEZC?=
 =?utf-8?B?SVpiT2Q1M3BGWGNzWjF4UFcvY0lYL2szKzlEZjdIM3Q3V0wvbDhiamg3TFpq?=
 =?utf-8?B?RTd6dnc5S2FvcUJ4RDlWRlRwSFFGeDU5MlNRUXUwYlhYVWFsSzJhY0xUcWRF?=
 =?utf-8?B?RHVPU0NWMm1HL1NkcGIwS0tOMTdBNHU3M21RSWYwTFFzYzgxWVpzblhmd1hJ?=
 =?utf-8?B?bHAzTTVuQVd5S3lGQmIwZHJ4MU9QVkJpMlNrWGZxMlJKbTExUXo5VWxjRG0w?=
 =?utf-8?B?VHl6ZkhQazBzVU1oZGxrYmFVUmhsdGRjMEU0YkNnUFJxcWZBSzREeEhDOGhz?=
 =?utf-8?B?dnorUXI3MXNCU2JBeFF2eXdIY2N5YVJCT2JNTlpRc1YxbDBCZXhzcjZEbFVE?=
 =?utf-8?B?UFdZTFRmc3BBN05kQTc4WkhKN3ZJT0FydWVYN0tacG9lM0VoeVI0V1JWZW9F?=
 =?utf-8?B?OVZ0dnhpQTJtN1QyYVdGUVUwcERiYUlrcDBhTnp1b09GV3JzUFNuYXo2L3BI?=
 =?utf-8?B?cllHOXFMZExGZTZWRXBaZXR1UXhMaVovV1FRZG5mVFpHY3ZtYUM0YmN4eHhk?=
 =?utf-8?B?RUdGTzNCOXMrTHNGYjF3TTIxaHNwMHR5cHZTbUdPZSszeFRzeXNUUW9EQmJH?=
 =?utf-8?B?enZCV25xSGJhc2VoT3BDTTIrS0xSNlFoOU1uMys4TTVqbW8rMXgyVk9NWVNL?=
 =?utf-8?B?aDUrWXhGa1B5Q3F0R1IybC9FenZkeHErbytEckpuNm94T1Q0UXVZZ2Z4NWdo?=
 =?utf-8?B?K1BVM3hzdTlkalBveXpPcGZCb2Q2UGxFNzlKV0FUdlNzVUtTcHZYNktTTVVM?=
 =?utf-8?B?V2VXRDVReGJqdGxhcGNFU3ZjUUpPMnExbGFFM0JuaFlGMHhNby9TVkdmQnha?=
 =?utf-8?B?MG8zNm02UjNEWm10VjFqNFJibXE2YmlJWm4rbHQrYnlSQXVpQXpQTEE4SzBx?=
 =?utf-8?B?aGpYRHhpZnprM3Flckd4b3NmU0NJbks0NnczdU50aU5oQnl0SnJick5uYmxj?=
 =?utf-8?B?cEZHcXMvcTQwc2ZpQ0tOV3VySlo5UXdvaXBwYjd0NTdtNFJKc1FTYzJCbnJR?=
 =?utf-8?B?b2Z2NGJ6UDlCeFZPNEVCNjJ4Zk1XeFdoZFdhUWtXZ1BOaEhsa1pWbXhYQ1dh?=
 =?utf-8?B?dEtic04rNFJ3SzM5ZjFyT2F1c01TUG9kOWl3b0szOUJXeWE4RFFJaTZIYkNo?=
 =?utf-8?B?Ti9LaVQ5b2NFUE5FQ0ZOM0xXMlNFbGI2VVRvM0FzVTdxVFRaTGhHUnBXVjVR?=
 =?utf-8?B?WWQrekcwaEhQMXdLZjlNNitkbDVEdE5TY1Z1aURBUTV1OHJJTytvSHBrTkI2?=
 =?utf-8?B?ZkRYWjZZYlVSQnRsY0pnRkpCdkgwL0dveExYWkszaDVnM3hlMlcwKzdJdGEx?=
 =?utf-8?B?STA5OEdXc2tkTjROWWZzVG5Lem8yeDdFTHRGVlExTjFVcWFjcmY0QkRyMkhO?=
 =?utf-8?B?enM1VllTK0xiY1labjR6WWZ2RitRdjB6cEx1WjhXMHRtNHBjYzFFV090UkhN?=
 =?utf-8?B?aVgyL3BHWmplUnFPczFpcFZscjV6OE9wT1M3eGhWaUttOGthaHBqSjNFbzM2?=
 =?utf-8?B?QzF1YUtSK21TcWI4VVRpc0MwUkZIQzd6em9rU0RialJMRHBMV0FUeW9OZ0pj?=
 =?utf-8?B?bnJzU2dldUVhSHpnbys0ZDBYa082bC8xRmlPc0swOTcycHBkemVMNnZBTlJ1?=
 =?utf-8?Q?Bqb0dHJCB/3PpNOh2xIpy6QBu?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2fa9935-5ceb-48ab-4e59-08daa40e6145
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2022 00:38:09.6025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 91jKhFUJ2Qt0jR9fVkfmytsPXnj+ImH0u4G1LNLmh2tULxCgr31Sp1bBdFRGObN7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR01MB2073
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/1/2022 8:25 PM, Atte Heikkilä wrote:
> On Sat, 1 Oct 2022 19:20:52 -0400, Tom Talpey wrote:
>> On 10/1/2022 6:53 PM, Atte Heikkilä wrote:
>>> Share config response may contain the share name without casefolding as
>>> it is known to the user space daemon. When it is present, casefold and
>>> compare it to the share name the share config request was made with. If
>>> they differ, we have a share config which is incompatible with the way
>>> share config caching is done. This is the case when CONFIG_UNICODE is
>>> not set, the share name contains non-ASCII characters, and those non-
>>> ASCII characters do not match those in the share name known to user
>>> space. In other words, when CONFIG_UNICODE is not set, UTF-8 share
>>> names now work but are only case-insensitive in the ASCII range.
>>>
>>> Signed-off-by: Atte Heikkilä <atteh.mailbox@gmail.com>
>>> ---
>>>   v3:
>>>     - removed initial strcmp() check since it could only save a call to
>>>       ksmbd_casefold_sharename() for matching ASCII-only share names
>>>
>>>   v2:
>>>     - no changes were made
>>>
>>>   fs/ksmbd/ksmbd_netlink.h     |  3 ++-
>>>   fs/ksmbd/mgmt/share_config.c | 20 +++++++++++++++++---
>>>   fs/ksmbd/mgmt/share_config.h |  4 +++-
>>>   fs/ksmbd/mgmt/tree_connect.c |  4 ++--
>>>   fs/ksmbd/misc.c              |  4 ++--
>>>   fs/ksmbd/misc.h              |  1 +
>>>   6 files changed, 27 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
>>> index e0cbcfa98c7e..ff07c67f4565 100644
>>> --- a/fs/ksmbd/ksmbd_netlink.h
>>> +++ b/fs/ksmbd/ksmbd_netlink.h
>>> @@ -163,7 +163,8 @@ struct ksmbd_share_config_response {
>>>       __u16    force_directory_mode;
>>>       __u16    force_uid;
>>>       __u16    force_gid;
>>> -    __u32    reserved[128];        /* Reserved room */
>>> +    __s8    share_name[KSMBD_REQ_MAX_SHARE_NAME];
>>> +    __u32    reserved[112];        /* Reserved room */
>>
>> Because this is a protocol/abi definition, it may be good practice
>> to code as
>>     __u32    reserved[128 - KSMBD_REQ_MAX_SHARE_NAME];
>> just in case the sharename constant changes in future.
>>
> 
> You are right. That would probably be better.
> 
>>>       __u32    veto_list_sz;
>>>       __s8    ____payload[];
>>>   };
>>> diff --git a/fs/ksmbd/mgmt/share_config.c b/fs/ksmbd/mgmt/share_config.c
>>> index 5d039704c23c..c62e87b67247 100644
>>> --- a/fs/ksmbd/mgmt/share_config.c
>>> +++ b/fs/ksmbd/mgmt/share_config.c
>>> @@ -16,6 +16,7 @@
>>>   #include "user_config.h"
>>>   #include "user_session.h"
>>>   #include "../transport_ipc.h"
>>> +#include "../misc.h"
>>>   #define SHARE_HASH_BITS        3
>>>   static DEFINE_HASHTABLE(shares_table, SHARE_HASH_BITS);
>>> @@ -119,7 +120,8 @@ static int parse_veto_list(struct 
>>> ksmbd_share_config *share,
>>>       return 0;
>>>   }
>>> -static struct ksmbd_share_config *share_config_request(const char 
>>> *name)
>>> +static struct ksmbd_share_config *share_config_request(struct 
>>> unicode_map *um,
>>> +                               const char *name)
>>>   {
>>>       struct ksmbd_share_config_response *resp;
>>>       struct ksmbd_share_config *share = NULL;
>>> @@ -133,6 +135,17 @@ static struct ksmbd_share_config 
>>> *share_config_request(const char *name)
>>>       if (resp->flags == KSMBD_SHARE_FLAG_INVALID)
>>>           goto out;
>>> +    if (*resp->share_name) {
>>> +        char *cf_resp_name;
>>> +        bool equal;
>>> +
>>> +        cf_resp_name = ksmbd_casefold_sharename(um, resp->share_name);
>>> +        equal = cf_resp_name && !strcmp(cf_resp_name, name);
>>
>> This is a little bit hard to parse. So, if the casefolding returns
>> a non-null string, and the result does not equal the original name?
>> Maybe because it's evaluating a pointer as a bool, and using "!" to
>> evaluate the strcpy result is the confusing part, to me.
>>
>>     equal = cf_resp_name != NULL && strcmp(cf_resp_name, name) 0= 0;
>>
> 
> It should be `!IS_ERR(cf_resp_name) && !strcmp(cf_resp_name, name)'.

Aha - ok that's better (but I still have to pause after seeing "!strcmp")

> The share name in the share config response is the actual share name
> which is known to user space. It is then casefolded according to the
> kernel's capabilities, which is either utf8_casefold() or tolower().
> If it differs from the casefolded form of the share name used by the
> client, then the client-used share name is incompatible with the way
> the kernel does share config caching.
> 
>> Also, strcmp() gets a lot of attention in the kernel these days. Is
>> this guaranteed safe?
> 
> Both are always null-terminated if that is what you are asking.

Ok, but are they guaranteed to be ascii? Isn't strcmp doing an octet
based comparison?

Ned Pyle has a hilarious demo where he sets a servername to the Bacon
emoji, and a share name to Eggs-emoji, or something. I'm not sure if
he creates a Fork-emoji file, but it's something like that. He then
proceeds to show how it all works with Windows. I just don't want to
see us running over the end of crazy unterminated or Unicode expansion
strings.

> Tom, thank you very much for taking a look. I would not have noticed my
> careless mistake otherwise.
> 
>>
>>> +        kfree(cf_resp_name);
>>> +        if (!equal)
>>> +            goto out;
>>> +    }
>>> +
>>>       share = kzalloc(sizeof(struct ksmbd_share_config), GFP_KERNEL);
>>>       if (!share)
>>>           goto out;
>>> @@ -190,7 +203,8 @@ static struct ksmbd_share_config 
>>> *share_config_request(const char *name)
>>>       return share;
>>>   }
>>> -struct ksmbd_share_config *ksmbd_share_config_get(const char *name)
>>> +struct ksmbd_share_config *ksmbd_share_config_get(struct unicode_map 
>>> *um,
>>> +                          const char *name)
>>>   {
>>>       struct ksmbd_share_config *share;
>>> @@ -202,7 +216,7 @@ struct ksmbd_share_config 
>>> *ksmbd_share_config_get(const char *name)
>>>       if (share)
>>>           return share;
>>> -    return share_config_request(name);
>>> +    return share_config_request(um, name);
>>>   }
>>>   bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
>>> diff --git a/fs/ksmbd/mgmt/share_config.h b/fs/ksmbd/mgmt/share_config.h
>>> index 7f7e89ecfe61..3fd338293942 100644
>>> --- a/fs/ksmbd/mgmt/share_config.h
>>> +++ b/fs/ksmbd/mgmt/share_config.h
>>> @@ -9,6 +9,7 @@
>>>   #include <linux/workqueue.h>
>>>   #include <linux/hashtable.h>
>>>   #include <linux/path.h>
>>> +#include <linux/unicode.h>
>>>   struct ksmbd_share_config {
>>>       char            *name;
>>> @@ -74,7 +75,8 @@ static inline void ksmbd_share_config_put(struct 
>>> ksmbd_share_config *share)
>>>       __ksmbd_share_config_put(share);
>>>   }
>>> -struct ksmbd_share_config *ksmbd_share_config_get(const char *name);
>>> +struct ksmbd_share_config *ksmbd_share_config_get(struct unicode_map 
>>> *um,
>>> +                          const char *name);
>>>   bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
>>>                      const char *filename);
>>>   #endif /* __SHARE_CONFIG_MANAGEMENT_H__ */
>>> diff --git a/fs/ksmbd/mgmt/tree_connect.c b/fs/ksmbd/mgmt/tree_connect.c
>>> index 867c0286b901..8ce17b3fb8da 100644
>>> --- a/fs/ksmbd/mgmt/tree_connect.c
>>> +++ b/fs/ksmbd/mgmt/tree_connect.c
>>> @@ -26,7 +26,7 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn, 
>>> struct ksmbd_session *sess,
>>>       struct sockaddr *peer_addr;
>>>       int ret;
>>> -    sc = ksmbd_share_config_get(share_name);
>>> +    sc = ksmbd_share_config_get(conn->um, share_name);
>>>       if (!sc)
>>
>> Another pointer boolean evaluation, but I guess this one is existing.
>>
>>>           return status;
>>> @@ -61,7 +61,7 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn, 
>>> struct ksmbd_session *sess,
>>>           struct ksmbd_share_config *new_sc;
>>>           ksmbd_share_config_del(sc);
>>> -        new_sc = ksmbd_share_config_get(share_name);
>>> +        new_sc = ksmbd_share_config_get(conn->um, share_name);
>>>           if (!new_sc) {
>>
>> Ditto
>>>               pr_err("Failed to update stale share config\n");
>>>               status.ret = -ESTALE;
>>> diff --git a/fs/ksmbd/misc.c b/fs/ksmbd/misc.c
>>> index 28459b1efaa8..9e8afaa686e3 100644
>>> --- a/fs/ksmbd/misc.c
>>> +++ b/fs/ksmbd/misc.c
>>> @@ -227,7 +227,7 @@ void ksmbd_conv_path_to_windows(char *path)
>>>       strreplace(path, '/', '\\');
>>>   }
>>> -static char *casefold_sharename(struct unicode_map *um, const char 
>>> *name)
>>> +char *ksmbd_casefold_sharename(struct unicode_map *um, const char 
>>> *name)
>>>   {
>>>       char *cf_name;
>>>       int cf_len;
>>> @@ -273,7 +273,7 @@ char *ksmbd_extract_sharename(struct unicode_map 
>>> *um, const char *treename)
>>>           name = (pos + 1);
>>>       /* caller has to free the memory */
>>> -    return casefold_sharename(um, name);
>>> +    return ksmbd_casefold_sharename(um, name);
>>>   }
>>>   /**
>>> diff --git a/fs/ksmbd/misc.h b/fs/ksmbd/misc.h
>>> index cc72f4e6baf2..1facfcd21200 100644
>>> --- a/fs/ksmbd/misc.h
>>> +++ b/fs/ksmbd/misc.h
>>> @@ -20,6 +20,7 @@ int get_nlink(struct kstat *st);
>>>   void ksmbd_conv_path_to_unix(char *path);
>>>   void ksmbd_strip_last_slash(char *path);
>>>   void ksmbd_conv_path_to_windows(char *path);
>>> +char *ksmbd_casefold_sharename(struct unicode_map *um, const char 
>>> *name);
>>>   char *ksmbd_extract_sharename(struct unicode_map *um, const char 
>>> *treename);
>>>   char *convert_to_unix_name(struct ksmbd_share_config *share, const 
>>> char *name);
>>
> 
