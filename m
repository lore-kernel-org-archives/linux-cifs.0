Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBB12ECAAD2
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Sep 2022 23:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbiIAXyd convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Sep 2022 19:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234321AbiIAXyc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Sep 2022 19:54:32 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8315065261
        for <linux-cifs@vger.kernel.org>; Thu,  1 Sep 2022 16:54:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vb1HobgNBoGSAh6CiEhj+DywK3tzFAWIYCp4CbOEwkieDHjSCsjPtxNUAjngG6CNjqhqlwPfNb/fd6YxxB4q2cSIZUwJSCaEXkoC+UjQvQsnzsS7RB7X9tnoH5M1A4yRAeUql36MrWv3Khjbp2I+ccmtOkd3hKL5zoXRpJMkOhGOj/c/Rcbqej9zx2nmA80fQTjKHkhLiuahWolVntRf37pKlYJcwb1NCWq+7Wzr/GEddSHju7/ZcGDQiNeA6nHo/1QZg77Jz/Ugx1IN3zmUI2AunUGXaD+ktMaCVw6rb4bl4HSI66UeDAJnQuQDX2iNkr+HZac5jubi6rQ1aVFgNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xIf80I7UzV+71UDt3ZzjNrJXO6/lXih3sQvSojBbVFc=;
 b=AtPBTi2SOEHCygrkkNnDIJmx72MOcL958QnOnvSoI/c0pNK4WJgHcfFJB4b1/wwtQ1M6HDZWCmG7OHoCVf9rK5TR/SwouuXEwBwwCS69xWr5Z8s0V7LdlMapssmwK5IPmYX77oD0GC8omqGaPks1pGK5Qxg4gtTaboVHBthcSIYyvasV2KKiSs5GnGlz5HJAnpkQV9R2BbfrUFUpXaAaWOlW2jSQPqKxz2yHoqC71RIUN0nW+sBiNqNYsrblOS/pOEgSbqB4E2eb+wBEXVMsHXDIoz0ZE6GRoe78WqGXQDnTV3Bjcd+97RRl6R8NCRdjaVCBss893m9ujNOxzmWmzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BL0PR01MB4836.prod.exchangelabs.com (2603:10b6:208:30::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.21; Thu, 1 Sep 2022 23:54:29 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b%4]) with mapi id 15.20.5566.021; Thu, 1 Sep 2022
 23:54:29 +0000
Date:   Thu, 1 Sep 2022 23:54:26 +0000 (UTC)
From:   Tom Talpey <tom@talpey.com>
To:     Steve French <smfrench@gmail.com>
Cc:     Jeremy Allison <jra@samba.org>, atheik <atteh.mailbox@gmail.com>,
        Hyeoncheol Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Message-ID: <ef9ab522-47a4-4c05-aef0-d81feb309343@talpey.com>
In-Reply-To: <CAH2r5muR48e+x1DNiV3=oRvwBC6exW6Xg_bGVfu2OGQovqUoQA@mail.gmail.com>
References: <YxDaZxljVqC/4Riu@jeremy-acer> <20220901174108.24621-1-atteh.mailbox@gmail.com> <YxD6SEN9/3rEWaNR@jeremy-acer> <b6a1bc91-0aae-2520-9fb8-dfe6caa46315@talpey.com> <CAH2r5muR48e+x1DNiV3=oRvwBC6exW6Xg_bGVfu2OGQovqUoQA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: update documentation
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Correlation-ID: <ef9ab522-47a4-4c05-aef0-d81feb309343@talpey.com>
X-ClientProxiedBy: BLAPR03CA0093.namprd03.prod.outlook.com
 (2603:10b6:208:32a::8) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed771f04-4b6c-414f-ccc9-08da8c754f0d
X-MS-TrafficTypeDiagnostic: BL0PR01MB4836:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q3arjgpHs6yexEDY4fik0Jvw9vAk9aZ6+1B86SCKyi64fINhQEODnyn5U4FDXuI6Y6paxpJxs68YmaUraxkYztNsaFM/2gdcv0bhCzha51PYXV2Ljuw98fwnuY6oz5X+WQ1selWa3i8FrtOVZ7r++eVzf+mNI6DYOeeX6a0u/GUdDF6VadE6OLr/L4sJuX4kT/pqP1sAYAhvQAAroyDr3fVE55arFeznaz85JOoZQ6Zx1SpbiBUkbPWbpR+DhXMmwo/IWXHwthEsyigqmycz8+D2TNxtUUqgM9KD0P/jjZSkCOpvl1w1quG3EqQ/vpv4hl/n6mZJivmoCJoMg9gLV+R7Np26Hg8plx9ZkRaghBHFYXCjlsE6icDpEFSLSRsbL2oxmhkaMwBIQhGRlfYIo8l4FyVsYCOxjRfKgWxO2tW8dy6Xcw5U1Jv4CxV3aNxqApKAP7vn9nJRd491317wNUMHYyQypTRrb1OTVxf+0FgzYBUiaevs1U3Nh0UtlgabKNfvdTiJJxU0hJFpHRMEgWuhxfNWvsOr5dVtjP7BDhUBpK0KEVl6c04pLYfFCepiO1/YW7gkzPjgJcnWo5IBOQ/Xu4DF/vh2/yFLvnI2jGP8pucvZKAXI/xAnIJyGWRmXRbH5t6PbHaFlrMYruKPnlXC+VTgU8gPI1GG+bKtoe2kxu2pFteXPIazumpCF9m2PBEJSLuacRc9J4KRvojxSiDwciNNWdG6/sxA8TD4civ9oQmChGMC4wMm7orz28Vojuu8ln8XnYTqsUhJkD1HUCPDCxgvaB51MtSEysMMdGw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39830400003)(366004)(376002)(136003)(346002)(2616005)(186003)(38350700002)(38100700002)(316002)(66476007)(66946007)(31686004)(8676002)(66556008)(36756003)(54906003)(6916009)(84970400001)(53546011)(52116002)(26005)(5660300002)(6512007)(6666004)(6506007)(4326008)(2906002)(6486002)(478600001)(86362001)(41300700001)(31696002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjBSMjhqQkRoZkk2b1dTQXZTQWVuVHF6ZytDZEIya24wY2pENzhubzlkNVdm?=
 =?utf-8?B?YTJIYTBSeDNCUy90d1p2QVBzQTZGNDRkZ1pldzR4YjM1SE9SSzZKR2x0L0Fi?=
 =?utf-8?B?M1MxTTNXRmpXZmlzQTRWblI2OUY5RFhvOWV6clBOc3hoUFFabmU0aEl0UDFO?=
 =?utf-8?B?UW1MKzlLRnY4K3pURmprejJQaXhaSnN2bERaS213ZVJNUFQ1aDhZN2cwd1Vu?=
 =?utf-8?B?WVNZRnlEU0lnQklNbnN3Q3ZWOXAwUUpXakVXRVRpODNieEdkZVlSUVI0MGN2?=
 =?utf-8?B?eUQzNkEvZkVFYU5EcmdhL0dJSVJ0aW03bEUxMDl6cmlPdUdTVnNJT09NSy9j?=
 =?utf-8?B?bVNCQytOSDNVWHgxcy9GNHVlUWlzU1dJVlFuSVYrWGFiVlRXc003aGMwYStB?=
 =?utf-8?B?NmNaL3RROVRaMmNqb1E5N2ZjQnpWTXhGWFlsdlo0elc3ODVxTE40SWZnL2V5?=
 =?utf-8?B?cXdIRkdwUnJxTitIS3FBNEh6ZVpHdklJZWRLTEREaWNuOWVYd2VyU2NyU2I2?=
 =?utf-8?B?MzBEbXI2Sit4eDRWYXBFOXF1YXh2K1JvVVB5eXh3dlRncTdKdmpjSk5BS25j?=
 =?utf-8?B?MFRjL2dSdkEwNTI3d2JDTnYycnlLeHNibEVjQ0Fzd2Y3bEJ1SmZUeG50UEtn?=
 =?utf-8?B?R1VLQXBJWU5JZWZ5dHBFMExiYVVuOXc3QW5xV3lOSXZJdHIvTlNzZW5Hd2lv?=
 =?utf-8?B?RjBud1NKNGhkWDVVMUl3UWk0KzZ4cDFTODh6VWdKck92RjFlN0hnRWwyb3kw?=
 =?utf-8?B?ckVXZFplbWJqbEcvNUJySUFMT0lzU3pIcEd6YUFzdUZWQnRUMXVHT0tNVnVT?=
 =?utf-8?B?MU5XMDlkOFVnRnRVc1c1TlAwY05PNElxeXVtMmk5ZG01bnozRVE5R3c2Zmk4?=
 =?utf-8?B?WWlOQlJRekQxWGdMcVhxQnhORjhFWG44K0dHT1B3aGJrZ2tqS0t3UWdxNUwz?=
 =?utf-8?B?ZFBqeThXdlZuMS9HbHF1VHFRRU1Zb3Z0Qm1IeStaVUFOWFJEVWVRLzZ4eHdn?=
 =?utf-8?B?S3Y3b2hXTEw5REd4RDlieHNjbjY1VzRKQStGMnJmdDhabC9HYVdFYWhVWXdR?=
 =?utf-8?B?WTY3WmJhU2xZaTF3ZWppUEVHMHNUMkpoYVZiRlRnZm5qY29RajQ1MW5YeVVV?=
 =?utf-8?B?ZldaQUNuVFNMYmhNV21qVUNaSXl5YitiYVAvZHZOR2NmcG02UGRqUUVabEtS?=
 =?utf-8?B?VFFjTldFc2YzcmpaOUo1SGxtai9MRktnNnNHbGN6K1FRekg2bmNnM09NSHZa?=
 =?utf-8?B?VFhSaGhONW9BV2xobWt2STdSSng4NVhvWGdJTDJlS0VZT1pzTWFheVJST1Jo?=
 =?utf-8?B?aExoNFdQOU5KcXVibFFZT0pJWk1YK3pTOXRMd3FYWVRlVTQ5K2UwNnA1UXUy?=
 =?utf-8?B?WllkbWRoWHFaS3VXNWx6QWdnVVVoeTZJbHozaHQ4Vjg3N0dzQUk2aVJrdGUz?=
 =?utf-8?B?ZUhIb2NHejNvVHBsRW5OMTR1Vk5mMXpwWjhLTkZzK25wWUZCWS9ab3VaeExr?=
 =?utf-8?B?QjU1M243UHFWRnM0SEo2UVBvNzVCSHM4TG4yV05CWjdEbnZCSGlrc1kzTldK?=
 =?utf-8?B?V2U1VEprRFBpcm5obkNSSnNjbHgxcDgwNnBETmVlSFVOeElnTWdBRnpnTzZu?=
 =?utf-8?B?SEpsWU4rcjQ5cmVkaEwxM203NWtXQUNJNk9Ib0xHZ2tIK3piS3ZuMjJHcy90?=
 =?utf-8?B?ZUxQd0hZNDVVNFV6bXNmanZOM0IyQThKZzYxaW5tNzIxUjFRblJBdFUxOER1?=
 =?utf-8?B?Sm9EdTVxME9YS1ZJOHRYM3BrMktsQTZ2Ujh5eTViNjQ0SXZpSHIwblRBeUJ0?=
 =?utf-8?B?VDNxRE83c2tGdjlLMHhVKzBxaDY1UTBvNkF2R1M5cm16dXN2YjRacXVsVXRR?=
 =?utf-8?B?cDVJdmNSTU1CUnpOQ1hCaTRwcHA0SENGTU5NRlFyQkZDL01uMUxMN1FTbytu?=
 =?utf-8?B?U1VLdmR2VXMrRU5EWFo3blVrOXNyY0k4aWZNTjlLMFVKSTJjTFRwNkRVdVBt?=
 =?utf-8?B?QmJKVk1TSUNiMUkrOXJONkxDMDFMNUlXNUZxblJsQWRCQ1BuYVVNVWhudVd0?=
 =?utf-8?B?cjRLMmFLNk8vSDhhcFM1djVMengwV1QyOGZPMTUyVG0yS25abk51TExnbEhY?=
 =?utf-8?Q?jPyv4UzHE810wR94zTpaj579G?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed771f04-4b6c-414f-ccc9-08da8c754f0d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 23:54:29.3275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 52OoVJMT18cOzIl86pP9JtbSJWKufuPdT0ZhoFXXrTWGi2NXRDB5nL3XotO8SoTm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR01MB4836
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I've got a couple, for example I cooked an RDMA-only one which I'm using for testing that ignores regular adapters and therefore can coexist with Samba. Only takes a few lines. Now, if the Ubuntu package manager wouldn't prevent me from installing both Samba and ksmbd-tools, it would be easier to deploy. :(


Sep 1, 2022 6:26:17 PM Steve French <smfrench@gmail.com>:

> I do think that one obvious thing that is missing is a simple python
> script or slightly more complex GUI tool that would allow better
> autoconfiguring a share for ksmbd without having to understand the
> ksmbd.conf/smb.conf format (and a different tool for Samba - although
> to be fair for Samba various vendors and some distros have tools to do
> this), but in the short term, a few more example smb.conf/ksmbd.conf
> files might help (maybe in the wiki?)
> 
> On Thu, Sep 1, 2022 at 1:52 PM Tom Talpey <tom@talpey.com> wrote:
>> 
>> On 9/1/2022 2:30 PM, Jeremy Allison wrote:
>>> On Thu, Sep 01, 2022 at 08:41:08PM +0300, atheik wrote:
>>>> On Thu, 1 Sep 2022 09:14:31 -0700, Jeremy Allison wrote:
>>>>> On Thu, Sep 01, 2022 at 09:06:07AM -0400, Tom Talpey wrote:
>>>>>> …
>>>>> 
>>>>> +1 from me. Having 2 conflicting file contents both wanting
>>>>> to be called smb.conf is a disaster waiting to happen.
>>>> 
>>>> ksmbd-tools clearly has a goal of being compatible with smb.conf(5) of
>>>> Samba when it comes to the common subset of functionality they share.
>>>> ksmbd-tools has 7 global parameters that Samba does not have, but other
>>>> than, share parameters and global parameters of ksmbd-tools are subset
>>>> of those in Samba. Samba and ksmbd-tools do not have any conflicting
>>>> file locations. The smb.conf(5ksmbd) man page of ksmbd-tools does not
>>>> collide with and never overshadows smb.conf(5) of Samba. Please, help
>>>> me understand what sort of disaster this could lead to.
>>> 
>>> Samba adds and or changes functionality in smb.conf all
>>> the time, without coordination with ksmbd. If you call
>>> your config file smb.conf then we would have to coordinate
>>> with you before any changes.
>> 
>> And vice-versa. For example, ksmbd supports RDMA and can be
>> configured to use interfaces with kernel-internal names,
>> for example "enp2s0" or "mlx5/1". These files do not in fact
>> subset one another, in either direction.
>> 
>>> Over time, the meaning/use/names of parameters will drift
>>> apart leading to possible conflicts.
>> 
>> Personally I think they're already in conflict, having taken
>> several days to work them all out wile setting up my new
>> machines. And, um, I think I know what I'm doing. Heaven
>> help the newbie.
>> 
>>> Plus it leads to massive user confusion (am I running
>>> smbd or ksmbd ? How do I tell ? etc.).
>> 
>> +1
>> 
>> Tom.
>> 
>>> It is simple hygene to keep these names separate.
>>> 
>>> Please do so.
>>> 
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
