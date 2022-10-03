Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D0BC433FE
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Oct 2022 14:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbiJCOOp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Oct 2022 10:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiJCOOp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Oct 2022 10:14:45 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2074.outbound.protection.outlook.com [40.107.244.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E3A64D5
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 07:14:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLROds4sbBVKgJkSzw2LTw6/kjF7yHmRoNFhyMdg7h4AsdKEgkDKtYqyH2hQFd4fmm3/Du5hNvs3ig4BMj+u5eBn8NGAWw10iMZ6IpSeix+/RTodtzltgH/1fnsMb7AFequw3x3ZLDjECYv4CLPVYz2aAsocj8IXqhOPd6nfsiN6EOdoaAbcwnQwcHdFNSYSHNnGZ/gYNLuIxJROiCaEgK7pPsCkurNYyBGOsc8HJcQ0b0PVsX/q6UxTl3e6TKukVSMSkWSK45aOEbNvh3L7yXbiwg/ktugnqYcitkT5n48wa3PU0p1FBo0pKEYtSK7UuORY49+Npa8DjCXAVk14Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t6DVT/L+jFkzZZb22a3iu/o8bp6FU3MF6MCciqbitio=;
 b=elJPC8AZYpl3wbeAJqVd7NwNXfCesE1hEyk0GTqjgh3y+1z2u60cpDDYutSDNS8eQqb30F8LvPxPRnd/XjKkrqolZBlcaukM9GXprC0i/W5TcRmxoNPE1OolIRcRUy/K38mRNNopgkMOhvww9dH5v+dJjovpnQjBtu8xTFXPos148ibA8QhDvFDld67NVp260zNCsFn2bWu66kfAa1pab80Jqw6McIuH/MKbPuU6zt4Orur2I/Q/+oaDzn/yDtgV3TVxeTTGHVrbaG4rf0mb4EeNvQVnxW7TxERoKO0nJPlcHyQ8Wxp57ePefeyspblQp6pYR0GkbmKhYjBn8JGQGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 CO1PR01MB7354.prod.exchangelabs.com (2603:10b6:303:159::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17; Mon, 3 Oct 2022 14:14:38 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef%5]) with mapi id 15.20.5676.028; Mon, 3 Oct 2022
 14:14:38 +0000
Message-ID: <ed654e60-2a3b-22fe-2fcd-6f42e8905add@talpey.com>
Date:   Mon, 3 Oct 2022 10:14:35 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v4] ksmbd: validate share name from share config response
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>,
        =?UTF-8?Q?Atte_Heikkil=c3=a4?= <atteh.mailbox@gmail.com>
Cc:     linux-cifs@vger.kernel.org
References: <baba86a7-060b-c878-95ed-0310def52850@talpey.com>
 <20221002212137.156711-1-atteh.mailbox@gmail.com>
 <CAKYAXd__JiXd2YBnAmLwtBMuRkw4penZYrASsrxepm7UaZBBrw@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd__JiXd2YBnAmLwtBMuRkw4penZYrASsrxepm7UaZBBrw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0068.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::13) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|CO1PR01MB7354:EE_
X-MS-Office365-Filtering-Correlation-Id: 13a61c92-87ee-4007-a5d8-08daa5499b4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +m8l7HWGJcqjVdXKjP55hQ94jsTuiBba4w9bdO56MiKELCDjI1cLyuazajrPHEnKx+x8IDsF2+FJVDWZOb7SZ+zfrX6wdcq2ATHY9t1ALqctJbCvxcgJaIlZ4ouuz1ytkAqZbUG9R071GNoRs7PLwMuoJYHkdwikdh0RRj0g/zo4kWNqFSMeXXgFuLT1rEZ0BIbCXmeLizOErI4ou3+pVNa5JM153I+GiTC0k6PKdGF1G4SlKwazwSPgbcnkm+LEaQyNjxE+2E4A2p4EPKEnP+K6JUD4qaU7uB6poRaDOmWEL46BepaJYcAwkpKETVle2e/pmUYhgiI3PQuA1w505o7lI8sS/ns/ijQH/ZXE0Pi00SwmMlLd8BnlTnpXJxn5iHzhWoJkRjQYYyCOBcvG0TKlJ6zZpNair2FqIAk+9DD2cw/JbnX3+bXPT8pXpseBpUUIqDDwYR71M3I29YsEKe9eMoKC8385eZljZT98AroKjd2eFl+UAhHMpy9zeg1gxCuwyyPz5WFFGNDIVdgth7jC4OVMf6daFSUWaOnZyoebvm4O1gVmk/P6eaANwzAfheymUJhjHAa7pC7jTDGHp9JgA8cubUm6S1ONBQdTJf1AkVuId8zLCTjjicCIF1ia6wVqE+jiPRE/RgRQxq8UceQdwmA4163Swd6KqMvVRf9RubS4M9qGBLuaNAShN8JeapPJMYfogVT5zskikvmtFBD5hTuSB2SoLCLds8AA6cW0KPzfiiPOlD99nrjRbcnsru0VLKd3ZRq2TweMckUqzeP1uRau+Ulc1VpID6haLMY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(396003)(39830400003)(136003)(451199015)(26005)(66556008)(4326008)(8676002)(6512007)(2906002)(66946007)(15650500001)(86362001)(36756003)(186003)(2616005)(5660300002)(66476007)(8936002)(31696002)(478600001)(6486002)(316002)(83380400001)(41300700001)(6666004)(53546011)(6506007)(38100700002)(52116002)(38350700002)(31686004)(110136005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S2tMTTBnUEVFNFhmRmJkajlWM0hVeTkxeWZ4SDVEcXE1RVZxcWxzc0N1N3hM?=
 =?utf-8?B?L0NxdmFGWUZHWWpGWGtic1NWMUJ6ZldIVXlYRVRuL3dPejZXa0V3ME9raVBi?=
 =?utf-8?B?Rk9LbnpyOWxjamovNWp2YzZNcmpuZndwaTJLVW5ueUpuNW5wZys2NSttU1lO?=
 =?utf-8?B?alM3NkozdE9qbFU4MnI2QmM5UzZENnZHaU9sc2diMW5xVDJFTkRoRVhRWE5h?=
 =?utf-8?B?L3V5VVhqcDZmSVZlMFovWS83MkhZc2FCQUp6cTNEK1loZllIQ3ZHWXNqTXdU?=
 =?utf-8?B?L2RHNnJyM1Z4dmxOV0dCanFWeG5Xa2pDMFRIWFN6bDc0RW0rNGtmSDg1MGt1?=
 =?utf-8?B?NVJaYmVNMkxSQktRSWZVQUFlckplN05vc3JIT2ZXVDRhRHlnTVFIenMvWEo5?=
 =?utf-8?B?MlpkSXlPUnJYTi9CR1BxTUVYY0JtK2l5SVNYVjJOMUpLZC9qdUsrUGQva3dL?=
 =?utf-8?B?cXU3ZkJ0eGVLZFVFdHgrQVA1d1VtUkhJZkRpWFNDZFA1Q1Y2NXk5QVRwT1J3?=
 =?utf-8?B?eStPZlJDb2hCSW90ckZyWGtzc0llQnhoUy9DZWUrRWxSMm04MjFMTVErRVVz?=
 =?utf-8?B?NFkzU2dBY0ViSFQvZVFSUWN4aUM5bUY1YjhNTWg2QWFpcnR0Q3ZLaWVidVQr?=
 =?utf-8?B?LzFXNGVCeTRRWjhZclhseldzTk9SUUp3SEIwOU84U0NsUVQ1MnBjNnBKT2ZE?=
 =?utf-8?B?V3crRUxBakdTL1d1LzBUR3pnc2k0NTB2QUg3NnpxbHZjWGtSMHREZ3BZa295?=
 =?utf-8?B?WEp2MDNPYkoxNHgzSUhPdGZZdUw2TE5WNDBwaytHdWJDQ0Y5UFdPSUpFODB5?=
 =?utf-8?B?OC9zWU94SkhkS29MRXB3NnpGMGtSekJuWXo0dm0yNy9PeUpJRFJzTGFBYWpE?=
 =?utf-8?B?SEZ6ZlRGc0FWM2lUc0RhNG5RU1lpaGJSUEdtb2c1Q2xlVHhNQWNweWVUbXF3?=
 =?utf-8?B?Zkd3NlI1MnVwQlljN3NreDBpNWJNT0RBZUJweWtFK1UrdmZzbUNoUHVuZVll?=
 =?utf-8?B?TEVXc2IxVVFwc0JCbENFM0JkNnByWEpoNndiMzVwZlRZY3dwYWdFeDRueGpw?=
 =?utf-8?B?T3dsTVhQWEtCZEJYRGlpTDV6NW1VczBZWjZhMWpjQ0I5NUZmWVlha3BDRi9v?=
 =?utf-8?B?NS8wL2FRSmkzMTVMcnJiS1VNRFB0Y0lndm5KSlpaTVVnSTIzdnRzR3JCdXZs?=
 =?utf-8?B?aVFEa1paSVNEbEFkMGhZcjd1azhDa1RjNmhzblAyc0U5bENjdzExNGZEREsy?=
 =?utf-8?B?ZzRVMnlzQnhPU2gyYmptTSszU0tlcjVMSTRFRjZqa0Q3MHh5MUc3L3lwejMy?=
 =?utf-8?B?MEhtZlAwTWhPKzNYL0tNTElpRlVhOU1Ld0ZTakZURVVTaGtod1hTYWp0dm9z?=
 =?utf-8?B?U2k2WDFsbHIzNW9UYTlWRjN3MVVRdXozcFErMmtBdnhpejFDWFIrMkpuSmhm?=
 =?utf-8?B?VHcwbGlaMVU2cm4venlDNUZOamlZaHVJcGQvanB1Y0tlMXpQZytjc3ppV0g0?=
 =?utf-8?B?MlFyeTNTdGxHMEhXWG5KeVJsaGN5MnREbTFwSzJSS1ZjSCtVUGhldjJCdXVH?=
 =?utf-8?B?S1FLc3NDT1V4R2RKcm9qOEVuSkg3YkhuaUhTZVFQY0NSVURBcDg0NDBTSVJI?=
 =?utf-8?B?bEVPbkFNTzgydHdXclZpOFlKWlJvZHlKOWVaSnB6aHRkTEx6ZG1ST1FIeThO?=
 =?utf-8?B?anBOYVdsQTRCZnVzUTkwaXFRYmVPbFp0N2Z1eXczTVEzOUcrZldIdDVFVHl0?=
 =?utf-8?B?aTlEME9DaUNEWWFFTmhiVTBySU1TRmZZN3RHT09ScWd0TVBobERpWjd0K1Fn?=
 =?utf-8?B?K2p0b0VVNXhtcURNTUpiZUgvYXV0V0VUWURHNVNQZndmbUY1SHdVdEVkU01y?=
 =?utf-8?B?dmRKSGtOend1OThRWUxzS05Mb3lXUURBL0VMOUp2aGJ4VDhrRmZuZ0pYTVJk?=
 =?utf-8?B?RVMyZWg3cGoxSmpOWHR0eERxVXVlcjJydlpGaE9QSitkVXY5TnhMUnVIRko0?=
 =?utf-8?B?aWNINlMxYVNWUVhoc0NSaVdlKzF6ZkhiTXg4R3BtMkhsMWRJLzhmeUlUY3p6?=
 =?utf-8?B?Q1d2KzFRSTBVajErZjBxWC9vcHZVb1A0RXpuR252WVJTQW1xRzJYNWpoTGhM?=
 =?utf-8?Q?xgF4=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13a61c92-87ee-4007-a5d8-08daa5499b4f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 14:14:38.5261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iL2ZrxWsNPK3svMSDFYTEhgkv+6F+T0ZR8o5RYmbv5yt/HGPxUipveBOp8vGh+dz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR01MB7354
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/2/2022 10:06 PM, Namjae Jeon wrote:
> 2022-10-03 6:21 GMT+09:00, Atte Heikkilä <atteh.mailbox@gmail.com>:
>> On Sun, 2 Oct 2022 14:34:43 -0400, Tom Talpey wrote:
>>> On 10/2/2022 11:40 AM, Atte Heikkilä wrote:
>>>> On Sun,  2 Oct 2022 05:46:28 +0300, Atte Heikkilä wrote:
>>>>> ...
>>>>> diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
>>>>> index e0cbcfa98c7e..ff07c67f4565 100644
>>>>> --- a/fs/ksmbd/ksmbd_netlink.h
>>>>> +++ b/fs/ksmbd/ksmbd_netlink.h
>>>>> @@ -163,7 +163,8 @@ struct ksmbd_share_config_response {
>>>>>    	__u16	force_directory_mode;
>>>>>    	__u16	force_uid;
>>>>>    	__u16	force_gid;
>>>>> -	__u32	reserved[128];		/* Reserved room */
>>>>> +	__s8	share_name[KSMBD_REQ_MAX_SHARE_NAME];
>>>>> +	__u32	reserved[112];		/* Reserved room */
>>>
>>> I notice you still have "112" here, did you reject my suggestion
>>> to code the size relative to KSMBD_REQ_MAX_SHARE_NAME?
>>>
>>
>> If size of `reserved' should be relative, then it would be:
>> 128 - DIV_ROUND_UP(KSMBD_REQ_MAX_SHARE_NAME, sizeof(__u32))
>>
>> Since ksmbd-tools already has the 112 (128-64/4), I thought to keep the
>> kernel side consistent with it for now.
>>
>>> Either way I think I made a flawed suggestion. The "reserved" field
>>> is __u32 but the KSMBD_REQ_MAX_SHARE_NAME is __s8. So, two things:
>>>
>>> - why is share_name an __s8? Wouldn't __u8 be more appropriate?
>>
>> As I understand it, the only reason for `__s8' over `__u8' here is that
>> `char' is most often a signed type.
>>
>>> - why is reserved a __u32? ISTM that __u8 would also be a better
>>>     choice, and then the size would be "512 - KSMBD_REQ_MAX_SHARE_NAME".
>>>
>>>
>>
>> I don't know why `reserved' is `__u32'. I agree that it would be better
>> if it was `__u8'.
> We can make another patch for both ksmbd/ksmbd-tools later.

Two copies of this whole structure is a bug waiting to happen.

The best approach would be to place the definition in a single shared
header file. And it may need some sort of version stamp, if that huge
"reserved" block is to be used.

I believe the kernel include/uapi tree is an established place for this
type of user/kernel interface definition. A side benefit is that because
of the ABI implications, changes there are pretty well-vetted.

Tom.

>>
>>>>>    	__u32	veto_list_sz;
>>>>>    	__s8	____payload[];
>>>>>    };
>>>>> diff --git a/fs/ksmbd/mgmt/share_config.c
>>>>> b/fs/ksmbd/mgmt/share_config.c
>>>>> index 5d039704c23c..dfb4bb365891 100644
>>>>> --- a/fs/ksmbd/mgmt/share_config.c
>>>>> +++ b/fs/ksmbd/mgmt/share_config.c
>>>>> @@ -16,6 +16,7 @@
>>>>>    #include "user_config.h"
>>>>>    #include "user_session.h"
>>>>>    #include "../transport_ipc.h"
>>>>> +#include "../misc.h"
>>>>>
>>>>>    #define SHARE_HASH_BITS		3
>>>>>    static DEFINE_HASHTABLE(shares_table, SHARE_HASH_BITS);
>>>>> @@ -119,7 +120,8 @@ static int parse_veto_list(struct ksmbd_share_config
>>>>> *share,
>>>>>    	return 0;
>>>>>    }
>>>>>
>>>>> -static struct ksmbd_share_config *share_config_request(const char
>>>>> *name)
>>>>> +static struct ksmbd_share_config *share_config_request(struct
>>>>> unicode_map *um,
>>>>> +						       const char *name)
>>>>>    {
>>>>>    	struct ksmbd_share_config_response *resp;
>>>>>    	struct ksmbd_share_config *share = NULL;
>>>>> @@ -133,6 +135,17 @@ static struct ksmbd_share_config
>>>>> *share_config_request(const char *name)
>>>>>    	if (resp->flags == KSMBD_SHARE_FLAG_INVALID)
>>>>>    		goto out;
>>>>>
>>>>> +	if (*resp->share_name) {
>>>>> +		char *cf_resp_name;
>>>>> +		bool equal;
>>>>> +
>>>>> +		cf_resp_name = ksmbd_casefold_sharename(um, resp->share_name);
>>>>> +		equal = !IS_ERR(cf_resp_name) && !strcmp(cf_resp_name, name);
>>>>> +		kfree(cf_resp_name);
>>>>
>>>> Well, kfree() is *not* a no-op for ERR_PTR() like it is for NULL so
>>>> this patch is not good either. At least I'm running out of ways to get
>>>> this wrong.
>>>
>>> :)
>>>
>>> Tom.
>>>
>>>
>>>>
>>>>> +		if (!equal)
>>>>> +			goto out;
>>>>> +	}
>>>>> +
>>>>>    	share = kzalloc(sizeof(struct ksmbd_share_config), GFP_KERNEL);
>>>>>    	if (!share)
>>>>>    		goto out;
>>>>> @@ -190,7 +203,8 @@ static struct ksmbd_share_config
>>>>> *share_config_request(const char *name)
>>>>>    	return share;
>>>>>    }
>>>>>
>>>>> -struct ksmbd_share_config *ksmbd_share_config_get(const char *name)
>>>>> +struct ksmbd_share_config *ksmbd_share_config_get(struct unicode_map
>>>>> *um,
>>>>> +						  const char *name)
>>>>>    {
>>>>>    	struct ksmbd_share_config *share;
>>>>>
>>>>> @@ -202,7 +216,7 @@ struct ksmbd_share_config
>>>>> *ksmbd_share_config_get(const char *name)
>>>>>
>>>>>    	if (share)
>>>>>    		return share;
>>>>> -	return share_config_request(name);
>>>>> +	return share_config_request(um, name);
>>>>>    }
>>>>>
>>>>>    bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
>>>>> diff --git a/fs/ksmbd/mgmt/share_config.h
>>>>> b/fs/ksmbd/mgmt/share_config.h
>>>>> index 7f7e89ecfe61..3fd338293942 100644
>>>>> --- a/fs/ksmbd/mgmt/share_config.h
>>>>> +++ b/fs/ksmbd/mgmt/share_config.h
>>>>> @@ -9,6 +9,7 @@
>>>>>    #include <linux/workqueue.h>
>>>>>    #include <linux/hashtable.h>
>>>>>    #include <linux/path.h>
>>>>> +#include <linux/unicode.h>
>>>>>
>>>>>    struct ksmbd_share_config {
>>>>>    	char			*name;
>>>>> @@ -74,7 +75,8 @@ static inline void ksmbd_share_config_put(struct
>>>>> ksmbd_share_config *share)
>>>>>    	__ksmbd_share_config_put(share);
>>>>>    }
>>>>>
>>>>> -struct ksmbd_share_config *ksmbd_share_config_get(const char *name);
>>>>> +struct ksmbd_share_config *ksmbd_share_config_get(struct unicode_map
>>>>> *um,
>>>>> +						  const char *name);
>>>>>    bool ksmbd_share_veto_filename(struct ksmbd_share_config *share,
>>>>>    			       const char *filename);
>>>>>    #endif /* __SHARE_CONFIG_MANAGEMENT_H__ */
>>>>> diff --git a/fs/ksmbd/mgmt/tree_connect.c
>>>>> b/fs/ksmbd/mgmt/tree_connect.c
>>>>> index 867c0286b901..8ce17b3fb8da 100644
>>>>> --- a/fs/ksmbd/mgmt/tree_connect.c
>>>>> +++ b/fs/ksmbd/mgmt/tree_connect.c
>>>>> @@ -26,7 +26,7 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn,
>>>>> struct ksmbd_session *sess,
>>>>>    	struct sockaddr *peer_addr;
>>>>>    	int ret;
>>>>>
>>>>> -	sc = ksmbd_share_config_get(share_name);
>>>>> +	sc = ksmbd_share_config_get(conn->um, share_name);
>>>>>    	if (!sc)
>>>>>    		return status;
>>>>>
>>>>> @@ -61,7 +61,7 @@ ksmbd_tree_conn_connect(struct ksmbd_conn *conn,
>>>>> struct ksmbd_session *sess,
>>>>>    		struct ksmbd_share_config *new_sc;
>>>>>
>>>>>    		ksmbd_share_config_del(sc);
>>>>> -		new_sc = ksmbd_share_config_get(share_name);
>>>>> +		new_sc = ksmbd_share_config_get(conn->um, share_name);
>>>>>    		if (!new_sc) {
>>>>>    			pr_err("Failed to update stale share config\n");
>>>>>    			status.ret = -ESTALE;
>>>>> diff --git a/fs/ksmbd/misc.c b/fs/ksmbd/misc.c
>>>>> index 28459b1efaa8..9e8afaa686e3 100644
>>>>> --- a/fs/ksmbd/misc.c
>>>>> +++ b/fs/ksmbd/misc.c
>>>>> @@ -227,7 +227,7 @@ void ksmbd_conv_path_to_windows(char *path)
>>>>>    	strreplace(path, '/', '\\');
>>>>>    }
>>>>>
>>>>> -static char *casefold_sharename(struct unicode_map *um, const char
>>>>> *name)
>>>>> +char *ksmbd_casefold_sharename(struct unicode_map *um, const char
>>>>> *name)
>>>>>    {
>>>>>    	char *cf_name;
>>>>>    	int cf_len;
>>>>> @@ -273,7 +273,7 @@ char *ksmbd_extract_sharename(struct unicode_map
>>>>> *um, const char *treename)
>>>>>    		name = (pos + 1);
>>>>>
>>>>>    	/* caller has to free the memory */
>>>>> -	return casefold_sharename(um, name);
>>>>> +	return ksmbd_casefold_sharename(um, name);
>>>>>    }
>>>>>
>>>>>    /**
>>>>> diff --git a/fs/ksmbd/misc.h b/fs/ksmbd/misc.h
>>>>> index cc72f4e6baf2..1facfcd21200 100644
>>>>> --- a/fs/ksmbd/misc.h
>>>>> +++ b/fs/ksmbd/misc.h
>>>>> @@ -20,6 +20,7 @@ int get_nlink(struct kstat *st);
>>>>>    void ksmbd_conv_path_to_unix(char *path);
>>>>>    void ksmbd_strip_last_slash(char *path);
>>>>>    void ksmbd_conv_path_to_windows(char *path);
>>>>> +char *ksmbd_casefold_sharename(struct unicode_map *um, const char
>>>>> *name);
>>>>>    char *ksmbd_extract_sharename(struct unicode_map *um, const char
>>>>> *treename);
>>>>>    char *convert_to_unix_name(struct ksmbd_share_config *share, const
>>>>> char *name);
>>>>>
>>>>> --
>>>>> 2.37.3
>>>>>
>>>>>
>>>>
>>>
>>
> 
