Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E49C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Oct 2022 15:50:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiJCPuy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Oct 2022 11:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiJCPuy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Oct 2022 11:50:54 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACE129822
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 08:50:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpG1Fzx+c509Kl0E5VKhTQSrOsq5RgtMxZi/pjrxbE02xcxOFKH1GKH7FORv0akmb7QBTs2meLKJkHyxGgPwfp6thYDBYij1rvKDF13XT1ZDfn3Hi4yC9QM8LJO2k+CyhBtI4TPs9us3Zr8eLt+Xsmxfz+P7lzzD7ts6iKQ0ODMFOCkGfFXm76ClecF9gyKYrkFjwcJ0Rx0tBcdjp1xfLviPdDaUIQ2UgXDIvipgPZfj6tL44QpIwoKlSwJrisDqYg9k0bJHSvDlMPsLagRzGQiwgj03OHDT7Ua4G5+3fEjrNo8/bK+DsDB9HiBi2faU7UJqHLwdx29W4TAG1QN/KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bqax2uzTxnOt34orTKd0u+kvyERTvxLG6cFc7h7PyHY=;
 b=CLhwk2BC9glvi9h6uAEb7OqMkTGXlMM80GLaD6l0EOxJeRAsinhTNeaBgu9vN/vAVKER24ZEtnYPC30YCFCtqw6nH7q7zQq8r6hmg4ZpN5zS7mqaZq3tIdDbGPIVAN3cc+AkXbGpV1kuWo4Gm4mWoT7JYiMhf70FlAOb38FCg6uZcg/DCUYpxac/aNX0UGxRyxJtCB1fclKGnp/dDPJ2PzkpuIkCKBdOTEc/6i5ON2BbQDLFUipwnn6I34L5q0A2pItFEYveXzHvSaDnSWNaUzZmdIK8DfL8DAtkmqDFZlHO+2fn49n3cG+1OJGB/5rDif0Np+7fBCsP9sS3l7ZP6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM6PR01MB5818.prod.exchangelabs.com (2603:10b6:5:1dd::24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.23; Mon, 3 Oct 2022 15:50:50 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef%5]) with mapi id 15.20.5676.028; Mon, 3 Oct 2022
 15:50:50 +0000
Message-ID: <9e982dfb-9f73-45df-37d3-f341a6445643@talpey.com>
Date:   Mon, 3 Oct 2022 11:50:47 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH][smb311 client] fix oops in smb3_calc_signature
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mtzWgXbod2tdZsRvZuhBZsv=H9Vf2GA3Q_bQe0nHhjfiQ@mail.gmail.com>
 <93bf9e29-32b6-7def-3595-598e59c8c46e@talpey.com>
 <20221003145326.nx2hjsugeiweb2uy@suse.de>
 <50e0c130-8836-8463-ec8f-fb7cfa6cd7ab@talpey.com>
 <20221003152043.6skowwnlwoidi3yl@suse.de>
 <026fba64-073d-fd2c-644e-1b53c77abc92@talpey.com>
 <CAH2r5mtH8F6FwPTMFO8fe6=LDbqjApuEiUw6cMr9ApL73ziA+g@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mtH8F6FwPTMFO8fe6=LDbqjApuEiUw6cMr9ApL73ziA+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0006.namprd02.prod.outlook.com
 (2603:10b6:207:3c::19) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|DM6PR01MB5818:EE_
X-MS-Office365-Filtering-Correlation-Id: e9b5b612-c829-4ef2-8140-08daa5570bc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ko8id9oYMdNKbrz7Qxa1x9GpVu6Y13sCCRFlbPu8OmP6wPR3XNdln+sXTQKlkF9fu+M6kiIITD1ghZUS5VGnkQ/xjjiaOAmIHDkSCtstkEyHZfzRjpA/HH7BMtpSLLyVfZcA8t4xKmniHBafDlQU6hjMueNqjJhUNG8u46HLLUxnOUBHIy48DVbREVWyNfzYHIM8jAQCawhdQPJxK8955ztzt7mEdWoXSRk8DU1WA64tC4IZA6pUrtTt35k9aRDM6LDxY1EcW3x+hn2QD0XPu8weDbAXskP8c8ni0IOTtdGzNYPjVxdnqV8fCvFANVHNqhtX5b2JH2HgPJwW4dU/LXzMbOsPDnTBbXOAeN8RRq/EpORuD2hH3SO+eMe/lWoyqWYvO+QopGF+klJso+zAScr8R1phvOJjbvL9QGds6kVPVSPilzBLO3YPUniEdvrNVjEIastiKHb5fAuKo2pismCEyVUyeebnjCyrKAMjbrO2lAD0eGYyIjapHz3S0jka+dRaCL5n7sTh6XyXL/uTeMpuhD1CQTqRqgrMniqS9P90zMV7UsoLbosWeQgJCYpIQx27YdoPQn3Vnkrq4BBQblGwIfpd8zB9LSfHR18TBQnNRtpEnpQ0QyHWp/cngj9sdiPbtY69wu5Ukzk/1+huOAbcIPsoTPRoaVhGtQaSViHd0GyIZcLxYTjxBd4Nl1FpWYCR4ML4OA+V8RHVjd/+dlfACziHbxanalgcMgfwTbYqZLdv25AoVajTfbXRdAa2UCg7/TV+Tn2uNYV/DKzQ0Nm9VdOwhLkksa9uI3Appb8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(376002)(39830400003)(366004)(346002)(451199015)(2616005)(86362001)(31696002)(83380400001)(38350700002)(38100700002)(5660300002)(41300700001)(66946007)(8936002)(66556008)(4326008)(66476007)(2906002)(26005)(6506007)(6512007)(478600001)(52116002)(53546011)(186003)(316002)(54906003)(8676002)(6666004)(6916009)(45080400002)(6486002)(36756003)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVg3TnVqK1IranBqcHhsV1V0OXZXMTdEd2UvOE9XLzVHcjdwTExvbzZ2V1Rz?=
 =?utf-8?B?Q0hrbHhtWjNueFVKZGNzVzRaam1MQVl2TnY4YVhXUGhYY3JnaW9Rd204VWoz?=
 =?utf-8?B?Z2NoclZPWXBZMHFvd1l1TlR2VUNuSmZvSkNyaWVFcUFuR01GT3FBc0pXaC9o?=
 =?utf-8?B?NWJsbGZ0SVdGdTFSV1JpQTNyRkwwVWFkSVZPTnRQRGVhcm1IU2FZU2UzVGFF?=
 =?utf-8?B?Uy83V0NjZkYrbkhjL0Q5VU1UZG4yQ0sybXdsWC9uOGwwT2F6Z3hoZ2NSb1pu?=
 =?utf-8?B?ckh1czlzRDFjSnRqNjF0MlhlNGZ3ZFF0UjgyOHE3RnZsV1FxazZMeE1jdkdH?=
 =?utf-8?B?MnJBYk1nUGo0SjIyV2tJZkE4Znc1OEFjNzFXbFpzNzlpMWM5clh6WFBES1c2?=
 =?utf-8?B?NzE3SHFLRklDOFB6Wmo3STRWeFdGV05ZYnlHSkh6SmVERmNlYmRDbWxZdVdx?=
 =?utf-8?B?RTBPODZ0Y0I3TXlwUzExMHIzcWFHdW4vRWYvTGVZQlZIRTVqZTllK2h1WVkr?=
 =?utf-8?B?dFlwU3N1U09qWUtKQjZFVVN0elM2R01YRjAxV3RDUTJDM2E5THcvVE9VbFYz?=
 =?utf-8?B?c0QxdmFmR0F1Wm5nYm93aFQ4N3dpNVVObEZrSHIzeWpsYnJnaCtIWGhTOEFl?=
 =?utf-8?B?NVdjMnJtb3pKWVlFNkpEbERZTWVTSUlkWUkrcVk3dGdHSG9aMGdXeUhRVFJr?=
 =?utf-8?B?Yk9Fa1JSUXZWZUhveEIvZjg2RmZhbWhhUW1UWjZBb3gzRmJsNGtWOEJZRWJP?=
 =?utf-8?B?bkpRQS9NSWZzNXlzTnpWOTNJMWRsRHVKbXpzZDU5S3hmN2swalF6NUp2R3hs?=
 =?utf-8?B?c2VMcnRDQzlUY3lnVkxQc0ZackV6aTIxNUxKTkw0bE95NjFLUmVpUVMvbnBn?=
 =?utf-8?B?cWZEV29CQWNmOUwxemZPQ2xoaFhFRW9EQWxDU1hpYS9BWCsyRTdKMkVORGhn?=
 =?utf-8?B?dENpeVFDbXJPek9TOHhlTEwxMVZMRjU3NmVwRk5FREFiTjd1dWtkQzkzQW9a?=
 =?utf-8?B?ZlVSRmVnd1ZuOVVHSUd5OFBTRlM5OVArRFkxVG9aNzNiY3BHT3dtKytsa0tJ?=
 =?utf-8?B?QURFeGhJaFQ0TWxKbnpLNEZhTlZKQTlTSWVRVDdPMXg5cVplcVh0WjUvam5a?=
 =?utf-8?B?OGNlVXFFY25FMHp1QjhQK2I1NEx6YWI1QTFCRUFCc0lqWjRsTkxnenlNcGF2?=
 =?utf-8?B?Wlg4OFJncEQ2UUFhRWExYkppKzFMYkZPQ0E3eWMyMWpEVERXVWRtZlFFSitu?=
 =?utf-8?B?TEZlRGJEdHl3VXVzSFBMUUkvaWtiNXFFTVJ2cUhFU2UvN0ZOK0hSY1FURk0x?=
 =?utf-8?B?QzJLellZZ1VRTGtmSmhGWWg3T1hvMWlLdFFmbHRyTCtlMWhoU2xTdTNlbXk4?=
 =?utf-8?B?UG5pY2cxVXRDL3pXejBlcTV6bEJ0TStNQTFsQzdjNXlXRjd1Yk9jNk9CV0Z2?=
 =?utf-8?B?Tm1EdlpEakdtR1JabmNBbG1xM015b3ZjRGt6VlpsYytIdTJFVHNRcjkrdkRG?=
 =?utf-8?B?MnpwQmE2T3VDL1hVeXNRWXJWQ05hVzJySkR6V2hMa1BIREUxbzJNZk9sTk9T?=
 =?utf-8?B?N1BZY0ZtekNGdERhOXdqejdKeDRiQjgyNWtKVDNseFF5R2hEN0ZUMEp4cWJq?=
 =?utf-8?B?MnI5RzcxZW8zMlBOV2ZTbGxPdzhRL0NSdHppREtBUERpeENVOUFpNWFYLzQ4?=
 =?utf-8?B?Q2tOQWxhcmZ1V2FVRlpiRVl0bURTQkk3MzhjZjJaZnpudTR6THdhbm9wSXQw?=
 =?utf-8?B?ZHdHeUZscEw4a0l2WG9COTJUMHN1RXRzS1I3Rm44amFadDJ6WDVpbWNBKzNH?=
 =?utf-8?B?dDVmakd4cmxjN2VlQWNTM1RFYkE5SmtSL3hGYU1Hd0FkaGQ3UG5JUE42dWpn?=
 =?utf-8?B?dEFzQ1IxQmFQRTgvVWRoVEtyQnU3TDhtb0hrR1dIMHRsL3BFV3VjMG5EbDNF?=
 =?utf-8?B?S3laUzA2VFlvNHpWOGVDbXVTSmR4TXVndGN4aUdOY0tEQm5WMHkxZVJHWXRr?=
 =?utf-8?B?ZmYzOVpBeHNoQU0ydEljc1pjTWloMjJIVVYvTHRpWHNjb1NCSkl6MllqLzhm?=
 =?utf-8?B?MWFNYXh0ZzBqTlhUSWRUdVR4V1pGT1RacjBZT1lBZ3BZcXpxWFVnNmQzN2lS?=
 =?utf-8?Q?Y9BuQDBXzMX+rmk2ZjL7CMkxm?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b5b612-c829-4ef2-8140-08daa5570bc1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 15:50:50.5721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ks/IkOnrHyHpm+QJssip1fZdZnGgH2+EokQh7yD9zNDmIy1kAD2nUYKQMF0VryKR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB5818
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/3/2022 11:32 AM, Steve French wrote:
> updated to include a similar initialization in smb2_calc_signature
> 

Acked-by: Tom Talpey <tom@talpey.com>

But I'd still love to see the tree this applies to!

Tom.

> See attached.
> 
> On Mon, Oct 3, 2022 at 10:27 AM Tom Talpey <tom@talpey.com> wrote:
>>
>> On 10/3/2022 11:20 AM, Enzo Matsumiya wrote:
>>> On 10/03, Tom Talpey wrote:
>>>> On 10/3/2022 10:53 AM, Enzo Matsumiya wrote:
>>>>> On 10/03, Tom Talpey wrote:
>>>>>> On 10/2/2022 11:54 PM, Steve French wrote:
>>>>>>> shash was not being initialized in one place in smb3_calc_signature
>>>>>>>
>>>>>>> Suggested-by: Enzo Matsumiya <ematsumiya@suse.de>
>>>>>>> Signed-off-by: Steve French <stfrench@microsoft.com>
>>>>>>>
>>>>>>
>>>>>> I don't see the issue. The shash pointer is initialized in both
>>>>>> arms of the "if (allocate_crypto)" block.
>>>>>
>>>>> True, but cifs_alloc_hash() returns 0 if *sdesc is not NULL, so
>>>>> crypto_shash_setkey() got stack garbage as sdesc.
>>>>
>>>> Sorry, I still don't get it.
>>>>
>>>>      if (allocate_crypto) {
>>>>          rc = cifs_alloc_hash("cmac(aes)", &hash, &sdesc);
>>>
>>> I think you're looking at an old HEAD.  We've hit this bug after my
>>> patch 10c6c7b0f060 "cifs: secmech: use shash_desc directly, remove sdesc"
>>
>> Aha. But I'm looking at Steve's current cifs-2.6. Where should
>> I be looking?
>>
>>
>> Tom.
>>
>>
>>> which changes the above line to:
>>>
>>>           rc = cifs_alloc_hash("cmac(aes)", &shash);
>>>
>>> In that patch, shash is the only struct to be initialized.
>>> cifs_alloc_hash() is:
>>>
>>> cifs_alloc_hash(const char *name, struct shash_desc **sdesc)
>>> {
>>>          int rc = 0;
>>>          struct crypto_shash *alg = NULL;
>>>
>>>          if (*sdesc)
>>>                  return 0;
>>> ...
>>>
>>> Hence, sdesc having the stack garbage, cifs_alloc_hash returns 0 and
>>> crypto_shash_setkey crashes.
>>>
>>>>          if (rc)
>>>>              return rc;
>>>>
>>>>          shash = &sdesc->shash;
>>>>      } else {
>>>>          hash = server->secmech.cmacaes;
>>>>          shash = &server->secmech.sdesccmacaes->shash;
>>>>      }
>>>>
>>>> The "shash" pointer is initialized one line later.
>>>> And, "sdesc" is already initilized to NULL.
>>>>
>>>> Steve's patch initializes "shash", but now you're referring to
>>>> sdesc, and it still looks correct to me. Confused...
>>>>
>>>>>> But if you do want to add this, them smb2_calc_signature has
>>>>>> the same code.
>>>>>
>>>>> True.  Steve will you add it to this patch please?
>>>>
>>>> FYI, smb2_calc_signature() also initializes sdesc, and not shash.
>>>> Does it not oops? Same code.
>>>>
>>>> Tom.
>>>
> 
> 
> 
