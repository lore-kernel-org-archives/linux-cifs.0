Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA47C54EBC
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Jan 2023 02:17:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjAKCR2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Jan 2023 21:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjAKCR1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Jan 2023 21:17:27 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EF63898
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 18:17:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lbx4tFa6IcqODT1oq698rv9INHMRzTTsnUmrfAtIQWE9CR3wK4Kh8Gx0CF8zvGlYVIGkTDblgkJUiug4ilaaGdEkD+bkyFoNEbKcT7hW26PEF0pIcteaAWhrSzNuS6j/1/G/BHaR5yk52fbvviy62GNpd4RE0TwcFhWMbdMMFXmSyMWjF4th93sEPeWwSsL7gRebPAbjUd5y3cov17goDXKNzExQlKmEah5gnzPjeCyDHeUBkTFFsmUxIubu0GRuPlG9CGS4IdiCKPQ9wz1rVIMyZmOpPH2vsb6HGdTheDBFN6kxrdJatbX3nlqEODsrhn9hXSWXGv1DtVH22LrNzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nv7tAlaoec2nldFO6AcXTJBPrk0YqhCbE3uPF96caQ8=;
 b=RkymxItcnW/yRgQiN3gbRyewfTkPVcAnwXrJO7/8GSYW5MU8SPCNweW55zTozAS4LKVyZaZNtp2MrsDGw1g0iDtZAyxaiDhFW/V77tG56m8OmIDS+w/x7rP9LNYX6R0AxCnZ7+M3QvF6jyoZQgXHnA2a2VYopiXo6zCPhyAYhIp5Rxp3x+FcH+w5xotPmyaG9amB+nb5bLWpcfEjDxPUuKiseTXvAuQxyeo2u/ysxxEL6ASSW30rCCEhrRFtsXN5mBbPUf40cugjZv4HES6xbkpiXu5C5E6ldrSr28Dqvbde1DvpO8cQoNosaN/ub9mtxwYVuZzFGAQ7u5UZxodINg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MWHPR01MB3264.prod.exchangelabs.com (2603:10b6:300:fc::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Wed, 11 Jan 2023 02:17:18 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5%7]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 02:17:17 +0000
Message-ID: <c928a1db-1240-4fc1-2034-cfbdcf536c51@talpey.com>
Date:   Tue, 10 Jan 2023 21:17:16 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Connection sharing in SMB multichannel
Content-Language: en-US
To:     =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aurelien.aptel@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Bharath S M <bharathsm@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
References: <CANT5p=p5vHbitjNMCJ56xT48m0amNaWKhfnASCwcHha3ZvTErQ@mail.gmail.com>
 <CA+5B0FOrTzfqoij0NBTn8wnGodqpAtMCatkAfvpYGPmHp8aPzA@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CA+5B0FOrTzfqoij0NBTn8wnGodqpAtMCatkAfvpYGPmHp8aPzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0244.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::9) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|MWHPR01MB3264:EE_
X-MS-Office365-Filtering-Correlation-Id: 1fd41310-5fcf-487e-3251-08daf379f64e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iNZjUVGjFWeIwA9JNNjTOyZ87EsNBwfMmHz88K7e6q+hPMquCPkdyM3iEMbGkai7u79QNMtAQa1fYkgKz1UHO2W38C2xkUbNb/TNpB4Sz6tE4j39KPZpmyspuENQBX1LzevaWzIbAXUx8ovCNUuCsOQ5kpNzY1holuOlO+54t37q9UKTOavI1H6KSX3elKoa19PvEMluK+G9//3XsO+evc8nw3zF3oCD4b/oviQkrBtQxDTd85PcNJ2Xi563RnwaajrPMgu4BvglOYjCIi42eGJdaFjb5yRVEJqtVdx/RasQAVrfNWq52scxd+qq9eaTV0qLEbLjkNIvKxKqjv9rmN/IW6fm1HI/pIaK/IiCTCn4bg62FURHZ/nGI3GXxwK9SNJKEOgT6gi8p77u9ZoEBbkDRybvcuhenSGVsb7XmxS9c4HR6388mjsCCE3TinERm5vBpclJLEEmcrsbBUAZS4f44PGhXa6Pd2RkaEnPj1aaL/KO19YD0uwMoKVWxntGxLFR9MUO5lWTCB2WcGHc66Kd5ZJ/AQFVzW4WpZ2iFQxPfvJMlrQ0po2uMjEtmeN5g9pi6u/WuG+uzBh/BIhFXhV6TgMcy09PN+TUqgskS2ScZTDE7UtS7+54f0b78BwDXV3dcsAzHAWna1RYhhCbav4hgb04/L8yU0i7xImDo0IzixUys98wq/WA2SDbinUMgAMlCz/1KK6fzShnHr/mofFh7Inu86jciI/TYkxRAO7WmXO56LgUTsM5+evLlEs8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(376002)(366004)(136003)(346002)(396003)(451199015)(8676002)(66946007)(66476007)(66556008)(316002)(52116002)(4326008)(110136005)(54906003)(2906002)(5660300002)(8936002)(41300700001)(66574015)(36756003)(31696002)(966005)(83380400001)(478600001)(53546011)(6486002)(6506007)(38100700002)(2616005)(26005)(6512007)(86362001)(186003)(31686004)(38350700002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d0tRenNLNURqWU5sdXFCY3JXNE1sNU50SW1aVTFoZWxoU1djTjhSVkZKYnZB?=
 =?utf-8?B?cldDRERMYWVtQnozcmxnajlINExtZGQxN05IQldQVlZWU3pML2hmZ21jbS9k?=
 =?utf-8?B?eHRrNEZJNjZ0TVA1VG9zemRpV25taE4wbzlSYkZhZWtwbWk2ZW9YL3FwYkxx?=
 =?utf-8?B?WDg4dVJBZWVtY04zb05VOHFOcU9PUlNRWlBSVWF3eFpIQ1FJRmJlOURIdWVQ?=
 =?utf-8?B?NGZmT2dBTDJ3RmlqV2FwU3dyc1JKWEhqNVl5NTJ4UWlNMVpLajkrRjlDejBM?=
 =?utf-8?B?ZHlraG9NdGxzRG9Vd3JJNFJIQU9UNmRXQUxCZ3VTbnI3UWNoaENDbDZ6V2Zz?=
 =?utf-8?B?L2E2WGpSTGtUb1lxVjc5ZzY4NmRCTXFrZlNldWsydWNTcjExYW1hZXE4ekNV?=
 =?utf-8?B?SXZ0aUExa2g5SnkzVnhHRkJpTGdRRU93YWV0OHNjYjN2RWw3K1VjZ0syWTY5?=
 =?utf-8?B?TVhPcElOT0xaZGRObkl5RUJ5RXdKMEZqdEFNWEZReHlCZndnSmxuc09Dbnk3?=
 =?utf-8?B?NFA3c2ZOaEdMRk1pSkUweUxEREc2czlwbkRwTlM3SWVWeGt4a3EzTVhjYVRu?=
 =?utf-8?B?VSs4NW1mcWxCcXU2bHZMeTdlcGZOSUhjdk9RRUhOSEJBMGlRajR5TytVZE9M?=
 =?utf-8?B?VkRiVnlLZEV3ZldUbi85RUVsVnBNVjVwUkV1a2oreFNWRnhVN1JPbkIyTERD?=
 =?utf-8?B?WWROWGlWVWdQd3hsNWt2RGo3QW1BMGJ3aFNzZWxMRlExRkYvWnV3SE5jTGFC?=
 =?utf-8?B?RFlWYnZmR20xM2dXZGJyUURYV3JndmpVQ1B6NWNnYzdrMVRDaURUbW5Ha3NY?=
 =?utf-8?B?T0lUUklEelpKTStCSTlIL2JDVExPbzJQWmZiSHZOOUZsME9iSWVleVVtbDRE?=
 =?utf-8?B?UUdQdkRWYndTS2JSTVEvTnFMa3k5d3grQ243clFnMkZnYlZKbmptRHlaMDRu?=
 =?utf-8?B?dkdVeS9oZjBoSkRFY3hCZ2t2RnU5TDBGT25aNDZYSzhsWUdoaGZVOGFGM2l3?=
 =?utf-8?B?UXZNT1M3Q0F3azNPMi96WlBqU0pQVzdHS1J0WVlYeG5HSURoOXEvSGluOTBS?=
 =?utf-8?B?TmFYdTZUWS83Y2wxdDVUcktEU3ptcFNUczlkTTFQeDlacmF6Tkc4YlMxODRU?=
 =?utf-8?B?eWFremM2RTQycWx4YU5KbktpNzNCQmMwVkZZWHhBdk5IZVZtUUdOa3ZFdVov?=
 =?utf-8?B?aHBTeE9VakRUcjJCY0kyUWI0RjVWcVZDZncwRmFGOGtkUVRaUmRwc0N0eVNE?=
 =?utf-8?B?MjVnK2U0RzlGQVpoMU10Nll5Yk5TdW1CMjZBeVBXcjNVcWVzRVhjNC9SM1pr?=
 =?utf-8?B?WFR0YWJDMHJFN0s1K2gyTFJkQzRiZlBYRnpWcTR5cFR1azluTXdDS1pwTkFh?=
 =?utf-8?B?N2VXMkhHL2lrMklCa1lSN1UreVEyeDh6U1c2RlFWQmFtR0djQVlSLzdPTzJZ?=
 =?utf-8?B?SDU4VVdBQlZ5WjJ5VGRrMnBTak82bUVJcVBUWVVHK0pISmZ6amdxQm92ck16?=
 =?utf-8?B?eVZKY2xjYlUyODM2RnFCcG1QL1RkZnIzYmdwNTdTNUx0OXZocU1ubXNXbndB?=
 =?utf-8?B?VVBybS9WeG01SHByNHp4cld3R2xkQWxpRGRvTEtzbWxaM0QyNXRQL0ZxZkxM?=
 =?utf-8?B?eDZCZGYzdW90R0Zyd0IxRlJZdXJJVUpzRDNDKzZMbURHdXlta1ZUWTRLa2xU?=
 =?utf-8?B?QnB6STJUV1dnU1gyV01tTlZzZDg2VHo0QUZHR21DeC9GSi84VytFeFYwZk5C?=
 =?utf-8?B?cStKakFTUVJpUFR2VmpCdHVNQjNOQWloOFoyTGp2d2RFcmVGMHpOcnU5SktG?=
 =?utf-8?B?eFlqYTh0UVNGcXc2ZlJMcTFWTmtyMHdXdG9NSG5LL2RDVFdGdElhamJwL0hI?=
 =?utf-8?B?RjU4NGVlVjZXRlltUXo4ZFhSN3VTbitDT212RDZxWEEyRkJGYU42VWkzQm1y?=
 =?utf-8?B?dDZnd0V6WEFTV3ptMWNnQlZOa1ozOU5aeUtyUnRuaVpHVVFIalVVdGVsa3Ns?=
 =?utf-8?B?VVRKdEVjRVM2MVorN2ZPRGlKTlJXQUQvMWZOUWUvNHFKaldCZys4K0RpOER5?=
 =?utf-8?B?bG9yc3djS3ZaZTFqS3l1QmJ4TmZhV01yQzVOV0F3Q0FjWjRwdjRuU2NxMDc2?=
 =?utf-8?Q?LKxH7arheT1Sx8hbLKueXFPjg?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fd41310-5fcf-487e-3251-08daf379f64e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 02:17:17.6664
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3QN1Qex1MHBZF7OMSA0Xpt57SZIPkkzJJM8M3YU81+gv4r6dyQN3EqxygTjWjsYM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR01MB3264
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 1/10/2023 8:00 AM, Aurélien Aptel wrote:
> Hey Shyam,
> 
> I remember thinking that channels should be part of the server too
> when I started working on this but switched it up to session as I kept
> working on it and finding it was the right choice.

Channels are absolutely a property of the session. Server multichannel
enables their use, but the decision to actually use them is per-session.

> I don't remember all the details so my comments will be a bit vague.
> 
> On Tue, Jan 10, 2023 at 10:16 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>> 1.
>> The way connections are organized today, the connections of primary
>> channels of sessions can be shared among different sessions and their
>> channels. However, connections to secondary channels are not shared.
>> i.e. created with nosharesock.
>> Is there a reason why we have it that way?

That sounds wrong. Normally we want to share connections, to preserve
resources. Howe3ver, for certain greedy flows, it may be a good idea to
create dedicated channels (connections). This is a policy decision, and
should not be wired-in.

>> We could have a pool of connections for a particular server. When new
>> channels are to be created for a session, we could simply pick
>> connections from this pool.

Yes and no. There are similar reasons to avoid using pooled channels.
Performance is one obvious one - some connections may be faster (RDMA),
or tuned for specific advantages (lower latency, more secure). Selection
of channel should allow for certain types of filtering.

>> Another approach could be not to share sockets for any of the channels
>> of multichannel mounts. This way, multichannel would implicitly mean
>> nosharesock. Assuming that multichannel is being used for performance
>> reasons, this would actually make a lot of sense. Each channel would
>> create new connection to the server, and take advantage of number of
>> interfaces and RSS capabilities of server interfaces.
>> I'm planning to take the latter approach for now, since it's easier.
>> Please let me know about your opinions on this.
> 
> First, in the abstract models, Channels are kept in the Session object.
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/8174c219-2224-4009-b96a-06d84eccb3ae
> 
> Channels and sessions are intertwined. Channels signing keys depend on
> the session it is connected to (See "3.2.5.3.1 Handling a New
> Authentication" and "3.2.5.3.3 Handling Session Binding").
> Think carefully on what should be done on disconnect/reconnect.
> Especially if the channel is shared with multiple sessions.

Yes, absolutely. Shared channels require careful processing when a
disconnect is used. It's incredibly rude to close a shared connection.

> Problem with the pool approach is mount options might require
> different connections so sharing is not so easy. And reconnecting
> might involve different fallbacks (dfs) for different sessions.
> 
> You should see the server struct as the "final destination". Once it's
> picked we know it's going there.
> 
>> 2.
>> Today, the interface list for a server hangs off the session struct. Why?
>> Doesn't it make more sense to hang it off the server struct? With my
>> recent changes to query the interface list from the server
>> periodically, each tcon is querying this and keeping the results in
>> the session struct.
>> I plan to move this to the server struct too. And avoid having to
>> query this too many times unnecessarily. Please let me know if you see
>> a reason not to do this.

This makes sense, but only if the channel selection is sensibly
filterable. A non-RDMA mount should not be selecting an RDMA
channel. An encrypted share may want to prefer an adapter which
can support bus or CPU affinity. Etc.

> It's more convenient to have the interface list at the same place as
> the channel list but it could be moved I suppose.
> In the abstract model it's in the server apparently.
> 
>> 4.
>> I also feel that the way an interface is selected today for
>> multichannel will not scale.
>> We keep selecting the fastest server interface, if it supports RSS.
>> IMO, we should be distributing the requests among the server
>> interfaces, based on the interface speed adveritsed.

That's part of it, definitely. "Fastest" is hard to measure. Fast
as in latency? Bandwidth? CPU overhead?

> RSS means the interface can process packets in parallel queues. The
> problem is we don't know how many queues it has.

Yup. RSS is only a hint. It's not a metric.

> I'm not sure you can find an optimal algorithm for all NIC
> vendor/driver combinations. Probably you need to do some tests with a
> bunch of different HW or find someone knowledgeable.
>  From my small experience now at mellanox/nvidia I have yet to see less
> than 8 rx/combined queues. You can get/set the number with ethtool
> -l/-L.

RSS is only meaningful on the machine doing the receiving, in this
case, the server. The client has no clue how to optimize that. But
assuming a handful of RSS queues is a good idea. Personally I'd
avoid a number as large as 8. But over time, cores are increasing,
so it's a crapshoot.

> I've set the max channel connection to 16 at the time but I still
> don't know what large scale high-speed deployment of SMB look like.
> For what it's worth, in the NVMe-TCP tests I'm doing at the moment and
> the systems we use to test (fio reads with a 100gbs eth nic with 63 hw
> queues, 96 cores cpu on the host&target, reading from a null block
> target), we get diminishing returns around 24 parallel connections. I
> don't know how transferable this data point is.

16 seems high, especially on a gigabit interface. At hundreds of Gb,
well, that's possibly different. I'd avoid making too many assumptions
(guesses!).

Tom.

> On that topic, for best performance, some possible future project
> could be to assign steering rules on the client to force each channel
> packet processing on different cpus and making sure the cpus are the
> same as the demultiplex thread (avoids context switches and
> contentions). See
> https://www.kernel.org/doc/Documentation/networking/scaling.txt
> (warning, not an easy read lol)
> 
> Cheers,
> 
