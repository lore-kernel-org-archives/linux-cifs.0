Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B74DC38145
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Sep 2022 20:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiIHUjt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Sep 2022 16:39:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiIHUjq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Sep 2022 16:39:46 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE8C2981B
        for <linux-cifs@vger.kernel.org>; Thu,  8 Sep 2022 13:39:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PyKno29FXJKgyZFHiebQmpZyVwf7vrtqV08nYXwEiXPTKx1vepXKeSOTdndcJGm4GGjSZw8DXmnEsFZTMaiPX3xiSUjhseziAZMZub1xsqgKNWt6XgsSQ01u1z/f1mTIhQAKnVLmspmZ/t0O7OxtSx7BcVFQdGnNBKa+wnS0PLSRtdgjQGXjCib5UbCLjtVsbA7E9T0HDybG2ybJ4oVjat84DXrPbIZl8hkdYDk2wU67XIghQsld4CeTSVy0+nFHzGdyBUBE+D3h3ttgKKQGavt3Ou+IlO+N7Oz8zggnxUY7PlJgkn05ksG2l5k2N4LnrjZ8esPl2RM1cG37mI72dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sGCGG1SxaX+sAL/yjJuYESmsdtHRu1T6qdtUDTgT1os=;
 b=VlNcejqIA9XeecxiR7yIhuQAyBWHWzeUdb+sE5X6PyVxS50Vfdcp82vSR0yt95pyBAAFb2x84rhcrov4yS7QAcPgcys8bXRfOyW7CZAzTewqfzrOTAz5Pl/MzCb5otK3drypULefGiyNQjlLetn8xdlzQut5WaPBb0fJjnp7aA5LRy0/NNjAOv1MtGwb6pamKS1k4uc3/ExY2SC7voJRObRs8YqGFxFi0vN/aoBXD7uQLHz21pGEM4Sk7JliQRw0k57wiiU41YAWTnBNOWBZImIo5+GINznX5Pod+8UhL0diYJ5IqN1AFoH4VrTZnJ1JtWA/BXRZN4xK1XpTyfEu2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM6PR01MB5337.prod.exchangelabs.com (2603:10b6:5:178::32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.18; Thu, 8 Sep 2022 20:39:41 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b%4]) with mapi id 15.20.5588.018; Thu, 8 Sep 2022
 20:39:41 +0000
Message-ID: <63cd9578-9cb8-60f8-ac56-0ceb497f1277@talpey.com>
Date:   Thu, 8 Sep 2022 16:39:39 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2] ksmbd: update documentation
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, hyc.lee@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com
References: <20220906015823.12390-1-linkinjeon@kernel.org>
 <356b6557-fa62-b611-8ef2-df9ca10a28c7@talpey.com>
 <CAKYAXd8bo2DS8HFpd=Gq3VFQ_P8rvBfSNAK08h6aSgKZ21cH1g@mail.gmail.com>
 <24137999-6349-f058-2f9e-b523f2d0a2e9@talpey.com>
 <CAKYAXd8h=Dxw0+vN3nOMeapHu8zUnLQ5dZ5wUTO2QgjpPQO44w@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd8h=Dxw0+vN3nOMeapHu8zUnLQ5dZ5wUTO2QgjpPQO44w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0052.prod.exchangelabs.com
 (2603:10b6:208:25::29) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a772985e-17ea-4581-9a6e-08da91da419a
X-MS-TrafficTypeDiagnostic: DM6PR01MB5337:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vukNg1fGqMVTvKJQybzXKbiS2o6Xfa7LkDanJvtUK0VhWuCbOwsLwKEvvhd7zpzn7HrqXI1XT+AgSkoqkM4za9rrSXl5a1xgOclTb7Ep+vQWVtdyWYlZ7L6VdjEXZMJPHJvezqQDoU4Y2t/ikNg4EJrUNT8s2fbQWsfJ1ji4sg05Zqntme1dR0YhV1iG4Ds/mCW1H36bA5XADceAsly+y8wiPSu76Bes6zORgAGhclGHYxNWU2BU6tQaUZDmaqhmqVZvUI4fpSdjmSrg7lJZdYK51zZoCTZzuXls36mgceZDNBclpOlpVSphDy1TxychG2lQ7CNs3xqal/ZFjA/KsRteEbIhZXP0aT63jn/P01MuS0Nwq/x/V5H0pA6ZktybpA5zXWD0srupeFKNfaB3RCQvAqfu+Cdaox+khy8hmtNkLHXeEADNPy5VbITD5eg2jE5amTHbmjfnYowbJd8Xbm9GH8QL9qtdVDcOYRLOq+puyoLwynZ0inxv5FL4Yc1QqlW6oO0SdZUoHnFlxsffsdAod0f0jWKBEhP8gr1K4B7vSAdDW76eQOisuU7U9HJ50Hixf0Ki+Kl70ky5MpuBM87ClK+eQ2CO7AEARShy5b/Yo0IvijyHe9/jmfHl8jMwpAATgyVykDSNmh95/D1+TZgo7hhIP/yDVBYXPIuH7zw+6CIjEwiIWVVn079uNOqvi1Uf8rtmuM0kd6Nzi7IhP9FMwnqw7Z+dXCEtR66jhNDXCXI4SSkjtKAdUYT/9XgR9yR2DZiEPVuNTqbHgeeAABQ7Z05R2wHRoYaucYjL0SM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39830400003)(136003)(396003)(376002)(346002)(83380400001)(6916009)(31686004)(26005)(6512007)(53546011)(6506007)(15650500001)(478600001)(31696002)(36756003)(8936002)(86362001)(52116002)(5660300002)(2906002)(66476007)(8676002)(66946007)(4326008)(2616005)(316002)(66556008)(186003)(38350700002)(41300700001)(6486002)(38100700002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Sm1BRG1DQ3BRanhyMkwxRkRPZFpHU2JSeFczWmlHUEhGTWt1N1lUOW81SC9X?=
 =?utf-8?B?eHowVDNTa2NTWDhpT1JQaDZLWjlzRTB6N3lYZ0hsNSsvRGpSbHF6dVNHVnN1?=
 =?utf-8?B?SUVQb2VPbFc1ZWo2eEVRQlQwQjloSlZHODRuQktzdllXZU9HOWZyTTIvbUhl?=
 =?utf-8?B?RHJwYjRiQXIrL2F6RCtHYjBHRU5Mc01xZWJMeVoxck5pL2RHKzRXRkJqQTFV?=
 =?utf-8?B?UUxwSUFMSUFlRkk1MExadlMreVFFS0xvVFVjRllYbHVBdlRLS0JPa1JIbzMx?=
 =?utf-8?B?WGRNWHpoL0tNMitpM28reGFPWU1EWUp5SXArN3QzbTYxZXcrSklwUW5GZ2Y2?=
 =?utf-8?B?ajQvcXFtMHVDdUpveEd1Z1hCS3V0U1NQbFFLNUIwanozZ2RBQTNWelFhM0dG?=
 =?utf-8?B?Z1ArTWtyeGdock5HeDUvejBvZExDZ2lCMGxOVzRoNVcvMFJ6bm1EQ2NqSmxE?=
 =?utf-8?B?QWxJRzlrbGRzaGNiSmd5TmNXdXFoTUxwaTlrbXJEVGE4VEdkUDQ0eFdQOStp?=
 =?utf-8?B?WjlybEhuQWJWVkMxZ2kxN28vVGpZc0IxaThMU3kzaHZHRkw3RkYxTnRQRGlh?=
 =?utf-8?B?YkdHQ1I2eW1EeVhLZDZqNWRRWUZxRDJZMHUyR2hJTnBONEJpRUlpd0c1RFVy?=
 =?utf-8?B?VE0wd1pyaEg3cWluaHdsOFJPQWpHL2ZLSFE3Q3hMTHNIVCtFazZFcFN5TzNK?=
 =?utf-8?B?UTI1a3dCSkxEOTR4UVNYMWNROEJnN1E2alFidGRMRElUbTVTSjBpaXlxRU83?=
 =?utf-8?B?TUxkaG5VYmZ3V3RQSHVxdUxBVVFINFZHSThhRjEvMEtGeko3ZHFOa251bDQ3?=
 =?utf-8?B?dm9PdXA5blo0VjNxVjRhMk4vQTBUc3BPcmxrUnhmbzh6ZkhOM0x1UFliRWNL?=
 =?utf-8?B?a2lSM3ZqT2tLcVVoQWxWWUtPVE5VUVVLdUxUMW82ZnRrcHNuVmliQmtCRG54?=
 =?utf-8?B?SmtmMndaMmcxbllwZkdUL254QmZhTnFaNUkxWXJVeHQ5alFBZUJ2M25LeFRo?=
 =?utf-8?B?OHIrcG5lUG11L2Qva1I3aVpLbEo0MFMwWVRzcEFKZm9odkdHemw1dnRVeG4z?=
 =?utf-8?B?WlM0Vko5TmV6aWVwYnMyMDI5STh1L1RJdG5Yb2lTdXo5eDhtMERGTFZBTitE?=
 =?utf-8?B?UkI5OHBVd2tCTEFXTm5pUmZkcmdGclBWTXQ4QzZsdXc5V2lXZkhmRUFJc2Vr?=
 =?utf-8?B?b0FLYm9sRFZoWmVHTXJ0ODFLb3EzWE1DaWxnZ1UxQ0ZLa2Z0ZFhlOGovSVlu?=
 =?utf-8?B?RXpjWklTTnlSR0pVRjljcFQwZTltRjREUWpJSDJqS25KQnNteExHVkMxblpq?=
 =?utf-8?B?K2d4Rm9DNldKZHkzV2wzTjFNcHVwL0d6TTluWm5UQkdlRjl6aWxYWHl4ZGdZ?=
 =?utf-8?B?Z2FSdXB5M0tRU1ZZRFJqQ1BiL0JsNUhxQ091VkszVk81OTJwRUw4UGhmdVEx?=
 =?utf-8?B?eGJzNktkZFUzWEtGbE5zcStIbFhSeHRwQVp6eTQvMjNBVFZaaVFHdG9vbmZW?=
 =?utf-8?B?T0hoTWluOHorQ24vUFc0WWIwMURZODJ5S2Q3ckM3WTJQT3RxTWZzUERYOVlx?=
 =?utf-8?B?dExXTzdUQ281U2l4Z2txRWdYQk02b200dUhzQm5GSWJnQmdpNEFRYkJkTmZG?=
 =?utf-8?B?cGc3ZHdYT0RTSS9HcitMS2ZNUVJQNmlzZ29ncjQ1WnJGYXJQTVJEcU4xZ1Vy?=
 =?utf-8?B?NXdMZytMYnVNMm5helg4aU92emdCRHcvMjBUa0U1c0UvOWxZNiszWU1VTE5F?=
 =?utf-8?B?NnNIaTVlMEtHMXdLK1pLZUFrUm0vVW9KTkkxV3lieUtocWxHczJkcXRQaE8r?=
 =?utf-8?B?S3l6ZW40cFRoRnpSZDhYQ1RMb1JxQ3gya2thQWpmTVhKT1RHZ2JaZU9oeEZj?=
 =?utf-8?B?c25mQ3hvWDI0MW5WaVRKR210NWRGNzdqdmZnR0FuT3Zac2NETUtkVTNwVnEx?=
 =?utf-8?B?MFNtRjUzTkhYQUZ4NVJyb0RPWEo3YXNDZGhsTDBSYTA1MDlyTnNxRGtpWmk4?=
 =?utf-8?B?Um55MnlIZ3dyWkgyZk83b2NQQytlaGV5cFFtYmlhYU02T1dNYXo4TEJQNXUw?=
 =?utf-8?B?UlNnRFM0YzN5d1VKU1lJUmdjeHFQSGRLZkI3c1o1ZjRXLzdraXkxZVVCSlFU?=
 =?utf-8?Q?CLew=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a772985e-17ea-4581-9a6e-08da91da419a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 20:39:41.7770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cb2syWo4fk1Mq01XHEKDO8vTTbJJ/MV5abhympyLXaulGWIk4HglTeWx4lYNHkjZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB5337
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/8/2022 10:28 AM, Namjae Jeon wrote:
> 2022-09-08 21:50 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> On 9/6/2022 7:46 PM, Namjae Jeon wrote:
>>> 2022-09-07 2:09 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>>> On 9/5/2022 9:58 PM, Namjae Jeon wrote:
>>>>> +3. Create /usr/local/etc/ksmbd/ksmbd.conf file, add SMB share in
>>>>> smb.conf
>>>>> file.
>>>>
>>>> Typo - "ksmbd.conf" -------------------------------------------------^
>>> Will fix it.
>>>>
>>>> Wouldn't the ksmbd.addshare command be a safer way to do this?
>>> ksmbd.addshare can't update global section now. So I thought it seems
>>> appropriate to edit ksmbd.conf directly in the initial running. If you
>>> still need to add, please let me know.
>>
>> I'm confused. If ksmbd.addshare can't add a share, what can it do?
> It can only add/delete/update the share section.

I still don't get it. A share section is just a section that starts
with [foo] where "foo" is not "global", right? And if ksmbd.addshare
can add one, why can't it be used in the example?

Tom.
