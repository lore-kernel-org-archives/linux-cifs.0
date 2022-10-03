Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C6ADC4332F
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Oct 2022 19:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiJCTGH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Oct 2022 15:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiJCTGF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Oct 2022 15:06:05 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597BD3FD5C
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 12:06:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BEu412ucgva22EYq5gRsVqxA6dYQ38CIQBY/eeulJ468D5+YwUGiZS+Qi3ZJbMI9FgpOBwtQbW5K+wo0Ozysk0Blq3BXN4Ia7hh9jCOryBYte6boiBRjiiiI370FVcvKHK0GlPt520Vp2EGqErNNenQW150qY1LVz9XmXXLeLEW9lDyn1j+gQNWphZJlEQMID53PEdVqUoEzr+rjry1WP/ecg1GkZCtuLIbncDn9MYcJiw/thpOuCR1U+35t+BVA81GjbvNj7GXWORZuGiqH3vXJOvkehjwBiF5VvYvFcz107Ud5+AhPEHT+K7V7VXcdvwq6wDoOSBcRalzHS1Bvxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IqMvpioZnsLbPcYnoQU6DJBiD6PkKJ4Cb/Vv5yxk3cw=;
 b=Qyi6+kfL4u6QFM0dQlIXNLu3taux7/pYfk/DrbRKJoMsjdo7Y92FXinuyQH1cOLQoVI4Qec1KCUOtlLO7lUkECkYQdVdmYUXb0n1ooO4T7/fyYJZ/AgdB8npOM+kjZfUc23wnvW2F8k2HIRrkgTKf0HC2H/Esjm6CGIDOjGsgM5ji6uwh+tdwYicFqG3i5ZtHWyGwGq3jOecM+QVhj23jExr1IkkybQeEjO5D0LGMbbOCGcAQe5roz6bFcW+CvmKvJE7exQEeVBMrfSMsDOrP+JVdWBBzzLc/heOF7KsewFyHuvycDNPqRLZZICx43UQQIW5a7ZffF8REIte0tC6Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MW2PR0102MB3451.prod.exchangelabs.com (2603:10b6:302:10::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.24; Mon, 3 Oct 2022 19:05:58 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef%5]) with mapi id 15.20.5676.028; Mon, 3 Oct 2022
 19:05:57 +0000
Message-ID: <5c6757cc-7983-c6ca-e651-bb62a71a5b66@talpey.com>
Date:   Mon, 3 Oct 2022 15:05:55 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH][smb311 client] fix oops in smb3_calc_signature
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mtzWgXbod2tdZsRvZuhBZsv=H9Vf2GA3Q_bQe0nHhjfiQ@mail.gmail.com>
 <93bf9e29-32b6-7def-3595-598e59c8c46e@talpey.com>
 <20221003145326.nx2hjsugeiweb2uy@suse.de>
 <50e0c130-8836-8463-ec8f-fb7cfa6cd7ab@talpey.com>
 <20221003152043.6skowwnlwoidi3yl@suse.de>
 <026fba64-073d-fd2c-644e-1b53c77abc92@talpey.com>
 <20221003163936.ztb7ysxvvka7mzex@suse.de>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20221003163936.ztb7ysxvvka7mzex@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR16CA0016.namprd16.prod.outlook.com
 (2603:10b6:208:134::29) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|MW2PR0102MB3451:EE_
X-MS-Office365-Filtering-Correlation-Id: 31e33f60-23be-49e8-e59a-08daa5724dc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2w0QI1oBRiFzYLHC0r41ojtmN98oo/NgzBbQ5/ygm1Pl2i1liiJUG9llG6eENF3q9D+KbN6kpVXVZiAu3XTt9eBiNZxWOlIEcKPsq6JlDNIi4eOIJb5hXPqYtlj/wVwR8T7uSkjk2Zs42TXY6gK31uG6DMDpqLq2E4BHEhJOEwTeg+Q9oL73gYUYZlR5CgN3an1oisZ30rLg/HffNTPD7VOd6AXccP5KE4BKXTD/fkC/4KmeUEv5IT668b4InUtVv/Yp/C93HUREhD5SUNH9qO3eEW59kXlt9MfMGG+juXJSfWyFuZbJXgdFhQEWi6WqbIHL1c6J6H5nyMV+629cay9I5v57d87HRW9orjlZZO91tdvWZIIQSEkz3p47rV2QyxCThr/EIWIPo+OMXuXIkeX1HYsCfMKc1TfE/qzY4gzOUzBzytngi6Vvo9ooL8BeAlGyX59wCVpVN4VUv/Iy88+g535lzhj/F4eIHlKuKOmyFOCRjLSSAbUUP5EeFxDbXXo2a0rjUkRDzcdlqz1ktkKdNtKCPvbqLEuZLuimy/pDCzRVFpIbsRFztPRvr3ViYEPCezZrGWqXogmH/6Xx70y1gceOXmOS160UrCG384V30zypfN4I/dS6/N0AcNEYfmW8znW84wY/JijTPKE/H3VTfUJ8b6KLgq1up3bXHzjtfjSEikiB6hchN/SwYea+V1M+sn6/yEhupNIRP4nfF40DoqzYD57/kBtsYJak5ktfJT6L0UIuIyLl836dBPtz+an7amepmFxmbKLRMvTxD+tkP+xkeAEmoz+Zhp+t1LE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(136003)(396003)(39830400003)(346002)(451199015)(2616005)(186003)(38100700002)(38350700002)(2906002)(41300700001)(8936002)(5660300002)(8676002)(6486002)(45080400002)(478600001)(52116002)(6512007)(83380400001)(53546011)(6506007)(316002)(66476007)(26005)(4326008)(66946007)(66556008)(54906003)(31686004)(36756003)(6916009)(31696002)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2tkbkNKMzFJemhVODlMbFdVejY3Tmd2bmhEY0ZySWlTM0ZIcWVkV2c5Uk1r?=
 =?utf-8?B?c3NHS09oN0RMeWRaeTlXbmxpUVBIWWxWNUlINUx1RnY1MTdWTHAyV2dKTndG?=
 =?utf-8?B?c2dPUEJNUEZ0K05NNGRGVjVUL05KU0lpVUdDeGVpVmw5eFN2bVJ1SHlsNDlt?=
 =?utf-8?B?KzczdTFpMk95U0FDcjdmS0tlUVdUeTNxUnNRRGg3NlFzdEtxa2FYL1NaL2do?=
 =?utf-8?B?czZudXlGRjUzS1hLN3hVdW5ib2hDMjJveVUraFlWR2t6K091MkFiNDcrY3JU?=
 =?utf-8?B?aTFxemdYb3A0VmxGY3NEQXV4cmtQRkxtZEdQRW5HdWQ5amJFYm5VcElxSkNV?=
 =?utf-8?B?cE1JOEQ1M0pzRDkwdTRXMnNLOXlHYXE1RFR4bVNxRmJpcjVGY2NNczNwMllN?=
 =?utf-8?B?QWs2MEJETzB6R3h6L2hDTnZ0dU1QR3FmeWlib0NYNU9ueXAxZE53QTIwYVd0?=
 =?utf-8?B?Mk9PaFR4am00bVZEZTVXYm1ib1o5L2hKTC84TW52ZThvNmNhUU40NkZPajVM?=
 =?utf-8?B?OGpGaGdxbmZ2eXVPV1drVFFiR0ZVNGpzbXpnSm8xckwyTnQ5Mzd3U0xYbDBo?=
 =?utf-8?B?by84NVpqM3dkUW1QeHJhdmJyOXdwVFNsMncrVUVyUG9ucWNUSjlFdDJJM29w?=
 =?utf-8?B?aDFPWHhxaVFtTGY3Tnd5UjZlaVZRQ093UGxFb09UREYzcUt0UXViNUpQejBz?=
 =?utf-8?B?RWxRRHVCVExhdWVvN2F0K1NnQjdtRzFWZ1RneVFJN2h3OU52L25WeWU3TnpG?=
 =?utf-8?B?TXdiZlk5L1hjNzZLN3YrWTJaeG1uVkJjeHZEQ3hHWmNZbUIrRkp6OWlSYjhR?=
 =?utf-8?B?bllnREE0RlFCcnJuYXN1cEV3M2NFb29XUk9Tbko2cTJCM1V0TmcxQ2RmZWpt?=
 =?utf-8?B?b1hCVm5sSHdOWExTSUhtdEx0aXA3VFY2QzBvMXFINFpmaXdMY1k3UTRETWtv?=
 =?utf-8?B?b09qNFBibmJwaVhWNkJTcjhqRFN5dzF3TlhLenFlVVRnNG1OVFpCbENubGVu?=
 =?utf-8?B?VkduVVdRMlVqdWcySFh6WVlrbHl4M0lOSFpCWHA2Y2NGbXlCTkpPMmQ5U3dH?=
 =?utf-8?B?VVZRUHE1WTlKU0U3UzJiYklLVzdsS2hldzdwSytzbFJuRlJDNlJ6amdNMjBr?=
 =?utf-8?B?Z3prZjNsbnN6TU5yU00zTlBKMGZzVzlYbXBYM3lpRW9UR0lTZkZyU3B3OWt3?=
 =?utf-8?B?S29DektQNHkvYWphOU16dFZVdlBuMHdFczlJSGRvT3RjQUpnWmVyMGMybGtY?=
 =?utf-8?B?c3Z3YVdVbmppb3hEc2M4d1FoZDVraG0vdzJZYStIVFZwV2pOUE9INjBRck1p?=
 =?utf-8?B?OVZjZncwYlMvUWd2QTFkQmFsTFYxOVJWb3BNVWs2bm1OUFhjRExETUtJcmdF?=
 =?utf-8?B?VnZLdXBTRmRNTlhRR0FmaUVRSWp6T0l1Yjk1MHpwUjFJRGdKN1AyK2ZjVXpX?=
 =?utf-8?B?Vk1kR1FpRTQ0TUNnUEp1dGJ5SzhRVHNYVlZMNjg4Y2lMVUxTSlpQK0lITXNW?=
 =?utf-8?B?M1dQWnI2dDNSamc5M1FldFVJOGdSZzR2dlRieXRMMnczbnpDcXNTanQxRzBB?=
 =?utf-8?B?cHpmQzhQcDNvT2kvOVlZUGk1V2tTZEtJd3ZwZTN5ZjEvWG13RWpkd3ZMTnJN?=
 =?utf-8?B?cW1VTEEzK21yc3kwc1FSOUhjZldHMzlicFBhQVRNQlhnZDNRMjE4QUducExN?=
 =?utf-8?B?U1R5alJpSWU1eFhQeEZPaXNSemFHZGYwdFoyNDF2SzhEZGREZlYrTC9JWlR3?=
 =?utf-8?B?bGNWTjUvbldoczk2Zk50YWJjSkJwNGVGWm0vRGVySEV5UDlVTXZGbGZ0RGhz?=
 =?utf-8?B?N1dhTUp5VjF6Y0pKZUdxSHZwZE00cmd2ZGZmdXhxMEpmMkYyWGNTM1pWNmhT?=
 =?utf-8?B?SC9OWVJOT2xiMkZxUXd2dnFYRERpU0RIbjN4MnpxblRNUFpMLzF0V1ZOY2cx?=
 =?utf-8?B?RzJnQmJuWkhYaWZDRzFZVzQxOFNSMmw5TUJyZDhhOElWL0VIbmk5RFVPajFQ?=
 =?utf-8?B?NTBkOHp1blVFUTNFZlF6UGwwdHREdXRSRWpRMGVVWXk3cy9YY0VxWUV2ZVIy?=
 =?utf-8?B?YzkvaHV1akdpbFlSYWhFTVRYM28wYUlWVWxTRDIrSkJuZm1qd1JJY25seG9m?=
 =?utf-8?Q?Mh91KrYlnCg8K7NRUptSM/o+2?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e33f60-23be-49e8-e59a-08daa5724dc8
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 19:05:57.8400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bcdolABno83SvVix6A8HAgUqNEIkCIlasgR3QbxlWHqj4FQHzXf23i8D2o4cpuk6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR0102MB3451
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/3/2022 12:39 PM, Enzo Matsumiya wrote:
> On 10/03, Tom Talpey wrote:
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
>>>>     if (allocate_crypto) {
>>>>         rc = cifs_alloc_hash("cmac(aes)", &hash, &sdesc);
>>>
>>> I think you're looking at an old HEAD.  We've hit this bug after my
>>> patch 10c6c7b0f060 "cifs: secmech: use shash_desc directly, remove 
>>> sdesc"
>>
>> Aha. But I'm looking at Steve's current cifs-2.6. Where should
>> I be looking?
> 
> It's in cifs-2.6 for-next branch, HEAD 11b1c98d0986 (already has the fix
> for smb2_calc_signature).

I can't see branches from the git.samba.org web interface.

Are there any browsing alternatives to pulling a full repo? Using
git on WSL is really, really slow.

Tom.

> 
> 
>> Tom.
> 
> Cheers,
> 
> Enzo
> 
>>> which changes the above line to:
>>>
>>>         rc = cifs_alloc_hash("cmac(aes)", &shash);
>>>
>>> In that patch, shash is the only struct to be initialized.
>>> cifs_alloc_hash() is:
>>>
>>> cifs_alloc_hash(const char *name, struct shash_desc **sdesc)
>>> {
>>>        int rc = 0;
>>>        struct crypto_shash *alg = NULL;
>>>
>>>        if (*sdesc)
>>>                return 0;
>>> ...
>>>
>>> Hence, sdesc having the stack garbage, cifs_alloc_hash returns 0 and
>>> crypto_shash_setkey crashes.
>>>
>>>>         if (rc)
>>>>             return rc;
>>>>
>>>>         shash = &sdesc->shash;
>>>>     } else {
>>>>         hash = server->secmech.cmacaes;
>>>>         shash = &server->secmech.sdesccmacaes->shash;
>>>>     }
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
>>>>> True.  Steve will you add it to this patch please?
>>>>
>>>> FYI, smb2_calc_signature() also initializes sdesc, and not shash.
>>>> Does it not oops? Same code.
>>>>
>>>> Tom.
>>>
> 
