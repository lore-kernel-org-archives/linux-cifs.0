Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E5CC433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Mar 2022 12:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240165AbiCSMIV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Mar 2022 08:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236834AbiCSMIU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 19 Mar 2022 08:08:20 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2077.outbound.protection.outlook.com [40.107.243.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE4865EA
        for <linux-cifs@vger.kernel.org>; Sat, 19 Mar 2022 05:07:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UeylnTk9S07Y82kYDVcntE6Ns0wxWpdMz7Wuwq16LtBcXretIvbfKhf+u1EjLfNZWADLMib/f1jb3dI7gw0sJF4YYPGyCgn/NoDbaHMF7irS+n7AQAhKE0RyBoYoAVr58ySevUpspmbBrj4zcuUnDgFMq2rERh/tkAmnrp/zjPQXtpFCT9zE5mr6m34iH0I/8WixnxDPv5MJK3uOjnaolVjHvFVsQ4BwYIEb0BKV5/mQdh8Fdg5qC9SY29oOPqBWUYoijj2iqoB4gkJhKNNrhN0aQi1XhVs6ND+LIdKxseIxOTYXEESaydxB6wJDx4YWl2tsEBcesQPSCmGm3wgvhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=20I8+CudqdNNR9LB1ern9g/ABgowOOP5r+d3N3zlSOc=;
 b=RfGKLaiIYHouLtkjEYZPfdyOqDFlO3Aaa86Ppy1neuvYTAPYusw9Fo15WfHfkS/knoLbw0zO+0sk9x8hVc1D4pDqNQi/eVa4vnG9XPWFziI/esACCEJyB08k2NjCvrfHzsfTAYqn/d9AFH0rAyB4q7UFdZ6v3KDSC5oMsatxV1EhJLAlCg9yJx9mfu4PvHx265aRV0ErM/FyuuIKlO8QRSQEw5NO+HW5QHg7d28EqsxaHnAKgl0IO9Cdi8RE0+nU/hmbmqsV2Lk1z1k57OdCC/alSJdtAGKm+BPG3ZTg4yEl/cOaxpWsEu4kBLYEzHqVsyNzigskLo/POxy6nyUwdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SN6PR0102MB3440.prod.exchangelabs.com (2603:10b6:805:7::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.19; Sat, 19 Mar 2022 12:06:57 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d%4]) with mapi id 15.20.5081.016; Sat, 19 Mar 2022
 12:06:57 +0000
Message-ID: <570f1f21-ecd2-6f88-e78f-7c57a22ba7e9@talpey.com>
Date:   Sat, 19 Mar 2022 08:06:55 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] cifs: fix bad fids sent over wire
Content-Language: en-US
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Paulo Alcantara <pc@cjr.nz>
References: <CAH2r5mvG6jmUKVi4zqRouFgYSjYxJjTExjmPtH64PAjFahE8dQ@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAH2r5mvG6jmUKVi4zqRouFgYSjYxJjTExjmPtH64PAjFahE8dQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR01CA0029.prod.exchangelabs.com (2603:10b6:208:71::42)
 To SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 292036cb-91e9-4d2f-861c-08da09a0f767
X-MS-TrafficTypeDiagnostic: SN6PR0102MB3440:EE_
X-Microsoft-Antispam-PRVS: <SN6PR0102MB34408A3730B7B70C66CF3AEDD6149@SN6PR0102MB3440.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6lmBiwHeCcSpFmpNlbsyNTFqXNE65SfVvDemvveBMXrieeqn76S5gellsUITQM+W6AwmSH6JhlCnEGcfnrtFCjxxNCTyzVXNvIwcgGNxfJcUfYe98bSJ08iu8T2ASnS+xk1UkDHck1L2lS6ntnyWZ63pnVniCe1oCalET9iZSmf37FVd5eaMaJMf9HxN6vksS2C+GUwzkDC1hNWGnP39zmCtfWlng0JRWEkfDbRFaJlNM3K8XBDnjxQ4ZdwEgvbCXymBFW9hP1BzBHd5Mdvcv/JMtcWHdNoHE4gQbm2Pzmyxt4jkvEwLXaJUdxb4h4ckTjgalPHZ9VqFiMM4utTHu4//eJxjvcfoXgZckHOfBShEGfYbieDziZifG7h58vFatDZocejuyXOxYkh868gNNVpyscsAd+ontDGV1m7sfm1XSkg3nwaLDN3oRDrp0CCsYGISUOPpm7jUwKQ11dmCGcVJlsF0s+A5K6xBJ/frbYaUNKF9bKFIa0UWz+xNNpbdgoOY2pcd+uqEpkleS+I9C0POQBtmHQlgKMEDXrhMzAy57hmlwxo0bNNoxvfYrJ3WAeTqqBa6iGnEnYI2lF2+ytmNzLtCFzLXcKaGZ2PdnmJLnLQ/2DQI0gdBclebwWmytRpnL1n+ncNE7oFt1IIN8v63mv0GMd5nGB4+sxS7du+BJFwt5SEY1wnP12hwlSVVJJXeu/pLAUehLzIxAFtuzjWA9GOYFmQzC/R6nrdvYb4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(376002)(346002)(396003)(136003)(39830400003)(38100700002)(38350700002)(316002)(966005)(2906002)(6486002)(110136005)(8936002)(5660300002)(66476007)(66556008)(66946007)(4326008)(4744005)(8676002)(2616005)(26005)(186003)(6512007)(508600001)(53546011)(36756003)(52116002)(6506007)(31686004)(31696002)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VkdBSmtYdDk4WTBBV05XNXpVbUpsUWpEKzBKZDdnZVNOaUsrckhNQ09CY3Yr?=
 =?utf-8?B?S1JaVVFkcFoxR2NBVjZuZzFpTnVpTzdienZ4UEVuTVJoNFZqRk5hR3ZvOExS?=
 =?utf-8?B?KzFSaHdScnNidWRmSGhrOHhvWjZwdWVUbnZoUEdldkFIUEY2VW52ajlUU3lY?=
 =?utf-8?B?eUdPakhMQ0JuazA0RVdnZ014OVVXUWVEZHNsVURZYUhTbHAzN1orUUNhbU5l?=
 =?utf-8?B?WGNNV3loMkNxY3gzZmFmV1crVVFmNDBhMS9tSGRscE9LYUZqRHNFSm42L1FQ?=
 =?utf-8?B?NXRNbWd6OUFVUWI4QkFQU1VzTEVJSEI5S3AvR0pxa045NlZwOGw3ZVhvRzZE?=
 =?utf-8?B?YlhwMHRUV25ybzB2ZnNURHdwLzl6TVhoQmFQTXVFeEpuVlRHZFFiT0hlS01o?=
 =?utf-8?B?eUJIazhXcm4zSXlOQUlhOHBGMWhKdkNrdTZsL0lOTEttYUthQythVnNjVzE4?=
 =?utf-8?B?dWFYM2EwVkUxZFFybWVqQ1VmYW5hSld6Z3o5ZVFQeFRmWTJBQ2NqQndCWnNG?=
 =?utf-8?B?bFBzY2ZlelpqaDdNZlQxUWdqdjlVS2xYNzMzTzlhZTMyNXV5YXBta3h6dGc1?=
 =?utf-8?B?WlNtMHFuSy9HSE1OT1pWRGlyQnBSRjh5QitKbDhlM2RocnZKVFA0RGVMQ2RW?=
 =?utf-8?B?VUltSkhxVlFSZkw2WC9NZHdxWnN0VnB3aERNUk1SaDNJbVBuMVpuSVp4K0Q5?=
 =?utf-8?B?WDNHMEdib2xkdnNYMlB1WDVVQ255UU1QK3NaWTlKYW9sUjBMOGRuT1JtR0F0?=
 =?utf-8?B?ZlkrcHYvQkJ4endDeVoxNDkwMTNObTJneG1xY1M5WG5xRXEvamNBVjJ0Qmww?=
 =?utf-8?B?SGxQam5IYm9mOVBMVGtmUUd4UStIZWczTjBVSURPQzg1S1hXSGxteXFYZlRH?=
 =?utf-8?B?ektmZExRNHYyZ0JodmRxbDhTdlMxTllrOWhtaDNvdHd0YlJwVS9Uc2wxc0FM?=
 =?utf-8?B?djBudGw0M1N2cnQ5bU5MbXBkTzZXdk5TTWh5VUlVbXQ5RnNSbjJEeUorSVlm?=
 =?utf-8?B?b2JyeUYyRXRFM3lsWkdGc2xtY1Q1b0dna2xFOWkyckxYV3JwekttcXAzLzZo?=
 =?utf-8?B?Y2psVFY0RHpDbndFTDVGeG14d2J4TllsbzBDdzZ4bnZ5UnNFSVR6RVIxQmNh?=
 =?utf-8?B?bTVYazJ3NnMzc2FlV052eUEzczRGSExLekdWaWowQzE0WGM4cCsrNVpRUkNh?=
 =?utf-8?B?MTV3WWRtdUhhem56NGJZaGwzWXhVb0t4cnVCME1qOUxqdHhqQ2I1U0E4dFh4?=
 =?utf-8?B?MTJKSXIxeTgvZEg2eEdmcGwxa21ZbWFkZXVTSGNIOWxqdlFjUDRKMmI2akNL?=
 =?utf-8?B?RDhBallxYlVxbTc0NUdDTWg5RFNCU1FMbVNGTjBsUzRHUko4aW9FRHU5NVlr?=
 =?utf-8?B?Vlliamo3YThidXcxQk1MMnEzL1hsbk1PVzF1R1NDUDNZMEkvMTVFWUdaTDhY?=
 =?utf-8?B?ZGhHL1VrUXI2bHQzdXB2a0RmNGpTUnV1enBZNWoxQ2xibWRMMkt6OExCY01I?=
 =?utf-8?B?Q1Q1d2FpQXVWUGFQaFdxMERFek1EWGNQSG9vV05teE5UeFhmMUVNSFN3d0x6?=
 =?utf-8?B?cmQ3ZUp3TnhLTHBzekRSK2VOWmxHTzhUTklkTTJBU3BSaDVIQ2lRUVpKSzNR?=
 =?utf-8?B?TUtlZzc5dGFiRWR1RlprZkV4Y2hqZWZ6eHpFcnBseFVwYVloS1Z3KzJSZGE5?=
 =?utf-8?B?ZHp3Y3JYbWdHZXdjb1NNN3B4Wkpod1VQZ2lXUzdaRVEwRENuaDFaWVo2MEZN?=
 =?utf-8?B?Qk81YkxpQm5jRXhNanFUWU5rS3cvQ21WOXM1ZVhoUlhSakdBN1ZqOU5jSUpt?=
 =?utf-8?B?WFhUK1NKc3B0MnZHQTVMVDMzK1BYVHhSZC9XS29lMHRucTZEeTVpY21lakJZ?=
 =?utf-8?B?di91MHNZT2wyWTZKcWdyTkVQT2htS3E4cUFQcjFneUFVby9TenVLU1dUaEc4?=
 =?utf-8?Q?v6Cl12RoKzg=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 292036cb-91e9-4d2f-861c-08da09a0f767
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2022 12:06:57.8551
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UfN5bhc02HBvfHeWCOE97OS3xmcqdiIKX4kYsHtb0bPgsDHFY/f1SulbGVTkds+l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR0102MB3440
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


On 3/19/2022 12:23 AM, Steve French wrote:
> Any comments on Paulo's patch? It fixes an endian conversion problem
> that can affect file ids used on big endian archs.  I will add cc:
> stable
> 
> https://git.cjr.nz/linux.git/commit/?h=cifs-bad-fid-fixes&id=a857bb6b15646a7946fafb281878ddf498107dc3

It seems a bad idea to be storing opaque fields in le64 integers, then 
byteswapping them when they go back on the wire. Wouldn't it be better 
to make them u8[8] arrays and just use memcpy/memcmp?

Tom.
