Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B4AC433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Oct 2022 15:28:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiJCP2B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Oct 2022 11:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiJCP2A (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Oct 2022 11:28:00 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2065.outbound.protection.outlook.com [40.107.243.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980976410
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 08:27:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJBUsHapphlYhq3oqBGxPDsEX/IJinCfQUMio3d36O/r/+ItmYWNRuosRJU2G5NhuzWDg2jytZYvcOhz16xbP05nT/PhDM5490uMGYBsYJVT4B1ADjX4gkmD+7imi00bTDxHVntEpxYyb+4R/cyW0LbxiEPW5imFOAYanebExSOxcggPGN+l15TXbKRxWOLMUfeJFXZNNYiY7/n24magWUFjeV0P3kR2SJTEinoV6Ob00OJyMyLBGk713WNXa3/SZzY2cmIUihcPAJ/EZg6FEkzto43ykcsgZUi8+R2aOIHQ2AOURXqOqlpYqvFoe2gBVuYqICMgdpSECvxjWUDB2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xeCyRoQvtIDYAcG215adUYWowEBzxgsi9ThW6odoXo8=;
 b=DULYbCow+onFkN/5hYqXEjfHFZAG9J6mi7e3OPfCxdLduxlVdhCTEGxe/h4DKeXPGf4y8oRfA+2qdf3zGCd7wXBfpMhDyUYu0RGoJe5T80rtSRwmTIOIRy+gMqVUE0dYP0ESWINf+h6SsSzKGLNo6kRHdhGTc0hDQXV8pm5OFf02yCgTxTHShauF6Wt+OoTbYxSl0UTuluM5t3Tba80P8wMI835SX2NnMplyi6UijowjP9CP9qhr9BjOMld0M/yAAiKVOb59aSSMxjr37ibkGfwvRc7A7kQGgMgX+JY1BSqVF0iwC2cWeHOBE9G67+dPrERuJJFQn6hksEycttcNUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SN6PR01MB4911.prod.exchangelabs.com (2603:10b6:805:c6::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.15; Mon, 3 Oct 2022 15:27:56 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::454c:df56:b524:13ef%5]) with mapi id 15.20.5676.028; Mon, 3 Oct 2022
 15:27:56 +0000
Message-ID: <026fba64-073d-fd2c-644e-1b53c77abc92@talpey.com>
Date:   Mon, 3 Oct 2022 11:27:53 -0400
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
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20221003152043.6skowwnlwoidi3yl@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0359.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::34) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SN6PR01MB4911:EE_
X-MS-Office365-Filtering-Correlation-Id: fe5f8a0d-f778-487c-0196-08daa553d886
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gvSj9+qB3hVhyvSa1eRUwIy89jnhRR2gyU+5yLr9Nfv7U0WjcqvDP0O1E7sG7g75N2NqCjnRcPh1gQoWbo4iF/8/u8hpMMqGwwTY/RSXiDGTIm8MumVzlWf02t7eIUj0a/4+OknHR3fPODgpbIyzW/6lLhZ3YqiXqrgJaZbR3uJsDzUbDXvyjn2LYHPKiHpVUigsxEUmAA0q9l1yhj0Z+uGIZZthz0rY1NEUk6deJgFq8n9cX1S31UYCe5ggiXIdRzutFTxPsN5zyC5KcdpOPFRhkHDunHxrFGKFfOQfWRdD9w7oYR+bsUxURTogT+t/67ClTmyOUGGqKJluign2RFo5qFtpB6AX7iCp00VSi+ETx+WPFlpgYyaELtQT3yCrNiyV9iQVdVIcwHJkrilNjWIA4lH5DZ+q2bastAM0Sqw2kbfR02HoXipK7KTJgF7WsOVmkHHZJ7DDkFmmnt8y76PERrURd/sRHDhFUsceW4bSbjb3aPr82r6UR8gYPmYtzcnIt0auIsJxZM1Mg5mQzvcyanFaaAH7UEyqxJZLLcXZdOBCd/csVb5Rs+E8A14uLwMjV7+Vj3uq3c53hpbheQ4YXOGZisZMogz1uxr/l3EfDpNOWtW4b0x4qBbIQyv9Hwbg1tmDEXsqHULDVwnwzHNymTRp+cGaSZDaaOZx+dUJFYdy9AZU+sKZyrN7vJAeHw5Kz6QyQBesVlB3VMQQ7XlnfmFVcmok6R0G/3pN35I2TcvzssAZkKBQM4RXvZMScjfBb0jPeKGKINbBl2QKHfeAYZ+2CbgJLQTXTEVbzqc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(376002)(136003)(39830400003)(366004)(451199015)(45080400002)(38350700002)(38100700002)(5660300002)(6486002)(478600001)(2906002)(6512007)(4326008)(83380400001)(86362001)(66946007)(66556008)(66476007)(6916009)(26005)(54906003)(6666004)(41300700001)(53546011)(31696002)(6506007)(52116002)(316002)(31686004)(36756003)(8936002)(186003)(8676002)(2616005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QW1ORE1uNUs4eSs1eDg2Rml6YmdTS3I5L1l1M2Jyai9sNEtsK0dVUFZwY3Qy?=
 =?utf-8?B?Tjk2TllqU1ZvUXlnWEpESlAzTk1qNHZMQXljUG5pRHB1OVdRWjI2eE1YOERt?=
 =?utf-8?B?Sk0zUlBiWkJUSTlSaUZJYzg3U1pyWkZvSCtTYzdnVTl5UVA1bWZJZFdZS3VK?=
 =?utf-8?B?VitHSTM0c2VrK2l0SmNzdmFldVJxRGNoclVTaG4xQkZmQjZ2Z1hwL3FOcGNF?=
 =?utf-8?B?RG1SMWVPNVo4LzE2RzUzbGxXeEthRnpVdVBCQVVwYm1sd0p0aXp4UEVWQjAx?=
 =?utf-8?B?KzlSUUJJQmZmbEhmK0hzREZLZHdXVGlRSVpvbmVUWkQ0Nlh5WXFLb0VFT04w?=
 =?utf-8?B?U1JWOTAzRkI1UGgvOHB2Y1FwUXUwTXFLaHN1YVlPWFBTV2NhQitvTTRON3dt?=
 =?utf-8?B?WkhhejkrWTlVYWJyODdJUGRLSnVSRGRaRjlKTFpROUJiT2NVOXVYWnBvcFpW?=
 =?utf-8?B?OHBsTExQd0Q4elpkMUhYQnpCa3V4K1psNFJjcjdScGZ6RnNDSy9YeEFtdDdn?=
 =?utf-8?B?bGR1TDZBSjRUYVVZSzZpbzNxSzlEekVtUi8xMS9qZEU0YXhsN3pta1FJYU13?=
 =?utf-8?B?RW1CcGVMMmFLR2pzYUZwcWtnZVNWckgza0dqMXFOSFBJb0lCbG1RdEVFMldF?=
 =?utf-8?B?SWZkRkN3Qnh1cjg2WmlDQjY4T1BSZFE3U1Zyam9HMDdBYzNPbWVDNkdzZjZO?=
 =?utf-8?B?OVlRNEZKaEQvSEdCQmdoZ2VJeTZwQzRHYThpZ0ZkcjloSHpHRW03K25Xdlls?=
 =?utf-8?B?Rkw3R1ZLb2NYS1FNb09nTWxjekJHWG41Qkp4QjR2NlVpK2U3aGFPNmpuNXh1?=
 =?utf-8?B?V3YxcGxSazJSVUdmdHpBbkVkZnBKZm5WL3NPV0RNM015b3l3UHpBblVsdTc3?=
 =?utf-8?B?ZG5DZ2FBL3dqcDIwY2l6SXpVRG8xRVZXZGdzZ2lITk1TZWF3dGtvMGNRRTdu?=
 =?utf-8?B?QzNrMFBqTjNVZXVnS0d6bzZDVkRpQjR2MFpQZUxDaURHMTM5M1M4UEswbitj?=
 =?utf-8?B?eWlWUDN0MzBNRnh6emZWaVhCU2N4MUJ1VkY4QWl2WDBFNjZiUXREUVdWdUNH?=
 =?utf-8?B?SHZsSDc1Qm0xS3ZoTmNSR1ZiVVBrNzhuYnhJdHV1bHJ6ZVVGWEY4c0lPellM?=
 =?utf-8?B?YXJCdldlUDhWVHZvQjRuNDgwSkNHWGVBRGpoa1VGdlNmZWlQR2k0aDA3K2d3?=
 =?utf-8?B?UHhoNk9BdjBWWUo3VnEwUCtaVHFaRi9BamdId3AwYmpNU09XVzhjUVM3b2o4?=
 =?utf-8?B?SERRSmR2Z2JRTTlBd0xYcDkrNmZzVldiUjRnaTdLdjkrQlNjZmdCVnVjWGZh?=
 =?utf-8?B?STJxS3ZOM1FLdDFPT09CN20xZ09HUXhDRnc5U2lDaVhSdERXNG5CR0NLbGFF?=
 =?utf-8?B?dUEwb1d6bFI1d2dTa2t1YTROR29MMjlyKzNTL09PelVyZ0p3cUlnL0pwWFRW?=
 =?utf-8?B?Y2V0cjZEbVhuSG5kUTNxNnp3ZnRyc2ZaK3N2Wmk2eGQvWGNPaTRxWWppMGZp?=
 =?utf-8?B?ZEZCa0JCRHprK2ZiZkd0ZU9Vd2ptS0wwQ05sZ2t5clpBNGFkNFBsUFgyVVcy?=
 =?utf-8?B?OCtvSmwwY0xrc0N6TzdxWkE4cVp3SzBUSkpxM0pFcUpGYXhpeHZyQTV0TFhU?=
 =?utf-8?B?VWJmdTZoMmh1QVdmdE9saU9XWExwSTdkQ3JZc3IwSm0xRTdZazJZZjNxMFd1?=
 =?utf-8?B?aDBSVFRieVJnUk9JQmRVNlBiL1JBcFVZVU9rZFF6RE1ndUdueGdmVEFxa3BZ?=
 =?utf-8?B?TjhDRVp0UnRIZHNnOXlSQkIvU2ltSExMTWlxSWNpMTh2blhveUVHd1NjSHM0?=
 =?utf-8?B?U1IwbzZlek5CbXZ3c1c1RlhjTnZ6SHc1MXZKWmFxcUs3ZXZFblVKYU56UVgz?=
 =?utf-8?B?c0E0VCtaUENpcTIydjZ0MENLR3FnVHNVN2ErRU9uQ1lvLys5WFJoOTAwU3hs?=
 =?utf-8?B?ZDRQR2JkKzFxaXd0VG8zQWhDMy9sekI0UzNRc0hVYlFKTFlkS005OVNKakhH?=
 =?utf-8?B?cVFBcjBpSEc1ZEc4Rmp5TTJ5c2luY2JLUEE5NWNXMytmVG84d0ZZVE94dSts?=
 =?utf-8?B?cUgzR2d2T25aR0F5dWxLUTFXUE9IbEhJOGppZ2JFNGJ4UldjdXozdE5DdWdP?=
 =?utf-8?Q?aRCeTHKzTkDMDTJn83qSUEh+e?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe5f8a0d-f778-487c-0196-08daa553d886
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2022 15:27:56.1437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9FckOAmZtAp6zkCrkadAUnjxyByyMd1srF1pi8mlu93r9VPqPgS1LPdSnITheQao
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB4911
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/3/2022 11:20 AM, Enzo Matsumiya wrote:
> On 10/03, Tom Talpey wrote:
>> On 10/3/2022 10:53 AM, Enzo Matsumiya wrote:
>>> On 10/03, Tom Talpey wrote:
>>>> On 10/2/2022 11:54 PM, Steve French wrote:
>>>>> shash was not being initialized in one place in smb3_calc_signature
>>>>>
>>>>> Suggested-by: Enzo Matsumiya <ematsumiya@suse.de>
>>>>> Signed-off-by: Steve French <stfrench@microsoft.com>
>>>>>
>>>>
>>>> I don't see the issue. The shash pointer is initialized in both
>>>> arms of the "if (allocate_crypto)" block.
>>>
>>> True, but cifs_alloc_hash() returns 0 if *sdesc is not NULL, so
>>> crypto_shash_setkey() got stack garbage as sdesc.
>>
>> Sorry, I still don't get it.
>>
>>     if (allocate_crypto) {
>>         rc = cifs_alloc_hash("cmac(aes)", &hash, &sdesc);
> 
> I think you're looking at an old HEAD.  We've hit this bug after my
> patch 10c6c7b0f060 "cifs: secmech: use shash_desc directly, remove sdesc"

Aha. But I'm looking at Steve's current cifs-2.6. Where should
I be looking?


Tom.


> which changes the above line to:
> 
>          rc = cifs_alloc_hash("cmac(aes)", &shash);
> 
> In that patch, shash is the only struct to be initialized.
> cifs_alloc_hash() is:
> 
> cifs_alloc_hash(const char *name, struct shash_desc **sdesc)
> {
>         int rc = 0;
>         struct crypto_shash *alg = NULL;
> 
>         if (*sdesc)
>                 return 0;
> ...
> 
> Hence, sdesc having the stack garbage, cifs_alloc_hash returns 0 and
> crypto_shash_setkey crashes.
> 
>>         if (rc)
>>             return rc;
>>
>>         shash = &sdesc->shash;
>>     } else {
>>         hash = server->secmech.cmacaes;
>>         shash = &server->secmech.sdesccmacaes->shash;
>>     }
>>
>> The "shash" pointer is initialized one line later.
>> And, "sdesc" is already initilized to NULL.
>>
>> Steve's patch initializes "shash", but now you're referring to
>> sdesc, and it still looks correct to me. Confused...
>>
>>>> But if you do want to add this, them smb2_calc_signature has
>>>> the same code.
>>>
>>> True.  Steve will you add it to this patch please?
>>
>> FYI, smb2_calc_signature() also initializes sdesc, and not shash.
>> Does it not oops? Same code.
>>
>> Tom.
> 
