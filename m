Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F430ECAAD1
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Sep 2022 18:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiIASwm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Sep 2022 14:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiIASwl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Sep 2022 14:52:41 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551C795AF0
        for <linux-cifs@vger.kernel.org>; Thu,  1 Sep 2022 11:52:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F7DTpTnRPS6AJPn8jAFrFQO17Yq90+Mk9m7VzKab6/MoV9NcV1hCWGN713ta1MCREYN9+K7A1EsVokJp5BoIwky2itTSSZyL7q4fl+MDpMWyRdupD6T5psmo/IDGXC60v/avxHjoAT8Y1E8M2CQXyXdmgs3yrkwDVEx0wEB5yZtuc0ufEC0c/rBsg7mhw6L6AReQNx1uSf7RTjB61NV+iVjDSz+ne5e0oR93CQra1AzKENGUKFGjtmEz7pK7HONEGzwzWTmf+C/vFr7M1+fLVrOJzXTywEUq26AidopNDqT6gpR6vK9tTq+vcZrf0g+yhHasPhBxtwlc4zlOf9qzJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6RvifJnvTUfKf+Mto3HEHs4N4kx4nV8GklWBMe3GYBo=;
 b=AGe3c7S0RhbkE0pc8QU0NY+baZjryuNddCSFBRHG5u25/SLZv0VLjVqV35IGo4CymGEzyh3PtgONTbVRnr05gS33TVVtKy8uE8mlW5xXAF5Ah4ple4dPDU0irYhTKpjifBdqbZYau5KdSDeGL8WRZY/kXtd8LXmvweaRKLjnyZ36DOFjHKFXpS++RRUFlLJyeXV+ZwRsPHkhgInCy4CVrkdmJ54w1R2QrcT0hlsWr3Ee6hMvVHOx3MXARv/2edsgjxdw2cABX28xHdHLkmpqR/3o+2KD1LVDTx71HWE3PykmQIRqzbzSAP1RL9dby24VKCSAezbX+2Dg7kPnbT4A8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MN2PR01MB5886.prod.exchangelabs.com (2603:10b6:208:188::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.12; Thu, 1 Sep 2022 18:52:36 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b%4]) with mapi id 15.20.5566.021; Thu, 1 Sep 2022
 18:52:36 +0000
Message-ID: <b6a1bc91-0aae-2520-9fb8-dfe6caa46315@talpey.com>
Date:   Thu, 1 Sep 2022 14:52:34 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 1/2] ksmbd: update documentation
Content-Language: en-US
To:     Jeremy Allison <jra@samba.org>, atheik <atteh.mailbox@gmail.com>
Cc:     hyc.lee@gmail.com, linkinjeon@kernel.org,
        linux-cifs@vger.kernel.org, senozhatsky@chromium.org,
        smfrench@gmail.com
References: <YxDaZxljVqC/4Riu@jeremy-acer>
 <20220901174108.24621-1-atteh.mailbox@gmail.com>
 <YxD6SEN9/3rEWaNR@jeremy-acer>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <YxD6SEN9/3rEWaNR@jeremy-acer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:208:23a::8) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58ffce86-33bc-40e6-f3da-08da8c4b22fb
X-MS-TrafficTypeDiagnostic: MN2PR01MB5886:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hYnSuEn6oFkT5y3TpHe3PPzLu7RMDHqY5UkNKgmqzG9Tv1HCdwGyb3xrrgeUkgSSBzsfhSgoqqZKJBOuRDwhdzEKybAo7lVY0qA3bQT6kgowF8/3cHevGCJyba2lBN2kBYql0lhF4MNcud4E8epYOzK3y8JfsM5pOAuNCrcgFgTwBSyJO5ff7QnTIasc3odc1Y99pZL8sYgmZZMrASpG1aE6m2aPaj53NgxnQqbzhRJPYsYuvhL0SNhczPyMvn6iFNC/i4wSeBtqLrTGtfuGdmRzcxykXK+VA//grhIh5Cqtgp5/2tkn7iZqvaxB6+WrcSz+SkvBASRs104kr8vvOYdXKBNDUHG5byv3+jCkHcqgABNaf5N33IdZFgnPKr2Yo9sQ7ISO43EQLx2jqi/KRaWGPY+3Baeyu2ymRhCz1FdThcTu2miE1X4/CxLyCScS7ZbDMmHLGYxZoWf1ZV5NRxSOPYtpuQBJsXZC6nWjSWLELq8byz0BXATClur8KNFz/20qOLElcwRuLejqIcv67bqxsfYNNQzbnsjXK81qzx+2zFJiwMKCmF6Nfwno7ihxmAOgkuFkZeJn/40VkkevHA7vhXavmbc4XZaP5j1VHRWay2FaJSsfyeo0plUQJWyUcY2mQeJyo5urwf1ILMh6NCE/TdMMKwnui8voIItcV9zYGocXwDU6gqNUnl5xReuAkSK7zt40DaYw4DSjLyPdc0TICsvKHGSSlWnLQLAJG/abTJlcOujJh2lFCoY5wNSrERdhk4PaiEVQAGDXKMZkxO4zWQAOrBC42whnFWeeNG8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(39830400003)(346002)(396003)(136003)(376002)(366004)(186003)(2616005)(66476007)(66556008)(38100700002)(38350700002)(6486002)(4326008)(8676002)(316002)(36756003)(66946007)(31686004)(110136005)(478600001)(86362001)(52116002)(53546011)(8936002)(6512007)(31696002)(26005)(2906002)(6506007)(41300700001)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGFDZE0xNVUzbEk3Tmo5Unp5alRWZmo0M01MdS90Tm5pb2FTZndlWjVLS3hK?=
 =?utf-8?B?WC80RmVFS1FvYURaSHRNeUZleHU3d2ZSQ3ZtTTMybUxnTGhaUnB1c2Fqc1RR?=
 =?utf-8?B?bEhQdzhhQWYwVFY1RmppMklwVkg0TllBTUcrMk44YnFsS09Qa0tvdjJXRmQv?=
 =?utf-8?B?bDMxV2RmT2RvTzNFbCsvYXV0VUwvLzFiYVJBU1gxSTlqMERWMEdrMTRZZU1l?=
 =?utf-8?B?YUYwOUExQ0llcWdpbEJBSmNkVkhpVmhmc2tFb1dYUEJXeVBDa1RxcEFEMXNo?=
 =?utf-8?B?TDR2dXBGQmNLQ1RTTW8yUi9ENzVtYWQ0alNEQWF0RjAxNFg2VzhwK0xaaTBK?=
 =?utf-8?B?TGNPWHpjRmR2MTYzcDcwc2Q0dFI3R1JIdFlDaUsxU1FhcmRMVXVKME1peUlP?=
 =?utf-8?B?RWE4c05HY2prTmV4Z3FhUDNOUTcvankydkY5TENmSGNRd1lZY0xXdy9MREpn?=
 =?utf-8?B?ak9NU05TS0srT3p2c2Zjb0Y1M25wbDJQYlRmMUFvS0pXdnJQTm44UUNDdWRo?=
 =?utf-8?B?VlVBNnFMM1BCNGsrVlZtcDBDdVk4ZEVyYXBmcDlQZjZIYW5QREtwbWZoS0RS?=
 =?utf-8?B?ZlFWc0lqVlBLWjNCRGZGL1FtVXAvZFUxUmhlblViV1lxbWEvdklhOG1RNjla?=
 =?utf-8?B?NEFZeTAzWWRIMjlhY0dVQ1RqUGdxdTNYY3o3YWt4TE5sRVF6VmpGTzdJVmI4?=
 =?utf-8?B?TXlIL0cvT09NNjFZS1o5ZVg0Vk5McW9FaE9LL2gvcGJQa2FGdGkvMkdZUitj?=
 =?utf-8?B?MWRtOVJ1cUQ5M2lvblN1OXBxT1gzREI0Vk95dFpRbTRlMGcvdnJxREE3Wnlw?=
 =?utf-8?B?WHVoVjhSako3b1hodTNNSkRFWS9zc1hBOXdCYWlsUUF4VHRTZlJSOWVZNWdy?=
 =?utf-8?B?L2NLRFZJK20vUkNsT0M2a2FudEJ3b21heU9DaVVjamJIbk5oeFVZRmducTNF?=
 =?utf-8?B?Zk1JU04zU3ZqV3MvejZvZFZIOURoZmFqaFVRNU1HblZwbDNTWVZRZjVLV1Fn?=
 =?utf-8?B?UmZBYTNXVy9PbU0yeWd4cEdwZGkzbit5R2x4UmprblJJbzlDTzBOYS9kK2Vt?=
 =?utf-8?B?eWh6Zk5GSFdtVzBMcGdrNEdBbDhYemVUekduSUZDRWxFcWtWQ1pFYm9Pa1pZ?=
 =?utf-8?B?SHRPQnBuVkd3SWNYMUFtSFpGb3QzcEM2Zmc0WnlMdzdMQjdmNWJmTjRlYTVP?=
 =?utf-8?B?SHhNV21BaHd3VHVKYzhob2l2ZktSUUU3YzRPZklMb3VyWm93WEYxL1Npc1FE?=
 =?utf-8?B?dHZ2aE9MaVNSY2tGcEZydDF2Zkc3U2twVW4zU2ZVWkhneWZNVk1QOEd2MFdl?=
 =?utf-8?B?MFVWQ2loMDk1bDhDQjBjb3cvRUIzTUY4RVZWdk00V1ViRWMvZ0dKU2JsVVl1?=
 =?utf-8?B?UFk3NS91VEJrRjBPSnRLZGhOaSsvcHV4SUhCWklCd2MzWnkvbHZlWlR5STFQ?=
 =?utf-8?B?ekJkejZiNDN6YW81cmd6d24zSm8zeERwNXR2SlFhZHZHUjI0UmdYck1GVVNP?=
 =?utf-8?B?L3JuK1VjTFhtWTNrNWNCYXp4dUxMR3FvM0cwZmNkNUYyMGFkU1c2REJFeHhi?=
 =?utf-8?B?WHJoUmNiY2g0M09NM3IwNjQzTDBmTGkwUHBTSk9hUzIzVmRrcng4REVXSmlu?=
 =?utf-8?B?U3VWaXpNR2ZIaTF4WTYvdlhxL0NPR1BpWnJMZ1lHNG1YSmtRUHUwUEZxY0Vn?=
 =?utf-8?B?WlFmRDVTTmRBN2drenc0TEszTnc3NmRYZ2s0eGE2T2o0emJLZ2twOThhb25N?=
 =?utf-8?B?QWNaL1JqVzN5d3llMmRPL0JkUS9zcmozLy9sd2FmcHhrUXE2OWloakJ6a3Ni?=
 =?utf-8?B?RmFFRDBvbVhtNHVOSlo3bXk5ZGR4MUt4WVVNbFJEWUNCa3E0UWp5THdyWWpr?=
 =?utf-8?B?bm50YzhtZTNPRlFITlZPSUxiNmxESXcrQWdkQmxITk5PNFovMkVRbE9DNkpv?=
 =?utf-8?B?YkFTeG9rYXVjY3l3bDcyNnlYUkF4QnZlbnJLN1huSzBxNzd3TXFuMkI4LzVU?=
 =?utf-8?B?UUZkVmY4T2dhNXFqWUlKQU56Mi8vZWs4QVhpYUUvU2h6N0JOeS81TzZMTk0v?=
 =?utf-8?B?dFpCTkxGR3VmQ3BrbUpoVEdvZTFjbmJMNWxmYWRrZjY1U1BHZWhobDVGbnds?=
 =?utf-8?Q?eoY6yzL3NI+9En3kPYg3xUv8r?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58ffce86-33bc-40e6-f3da-08da8c4b22fb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 18:52:36.5750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YyGbLXlONFS81VXcXhNyYpRuDBc13RC870o2kn1eItWe+4C+mU27CPt4OS0/in95
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR01MB5886
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/1/2022 2:30 PM, Jeremy Allison wrote:
> On Thu, Sep 01, 2022 at 08:41:08PM +0300, atheik wrote:
>> On Thu, 1 Sep 2022 09:14:31 -0700, Jeremy Allison wrote:
>>> On Thu, Sep 01, 2022 at 09:06:07AM -0400, Tom Talpey wrote:
>>>>
>>>> Ok, two things. What I found strange is the "man smb.conf.5ksmbd", and
>>>> as you say that should be man 5k smb.conf. Sounds ok to me.
>>>>
>>>> But the second thing I'm concerned about is the reuse of the smb.conf
>>>> filename. It's perfectly possible to install both Samba and ksmbd on
>>>> a system, they can be configured to use different ports, listen on
>>>> different interfaces, or any number of other deployment approaches.
>>>>
>>>> And, Samba provides MUCH more than an SMB server, and configures many
>>>> other services in smb.conf. So I feel ksmbd should avoid such filename
>>>> conflicts. To me, calling it "ksmbd.conf" is much more logical.
>>>
>>> +1 from me. Having 2 conflicting file contents both wanting
>>> to be called smb.conf is a disaster waiting to happen.
>>
>> ksmbd-tools clearly has a goal of being compatible with smb.conf(5) of
>> Samba when it comes to the common subset of functionality they share.
>> ksmbd-tools has 7 global parameters that Samba does not have, but other
>> than, share parameters and global parameters of ksmbd-tools are subset
>> of those in Samba. Samba and ksmbd-tools do not have any conflicting
>> file locations. The smb.conf(5ksmbd) man page of ksmbd-tools does not
>> collide with and never overshadows smb.conf(5) of Samba. Please, help
>> me understand what sort of disaster this could lead to.
> 
> Samba adds and or changes functionality in smb.conf all
> the time, without coordination with ksmbd. If you call
> your config file smb.conf then we would have to coordinate
> with you before any changes.

And vice-versa. For example, ksmbd supports RDMA and can be
configured to use interfaces with kernel-internal names,
for example "enp2s0" or "mlx5/1". These files do not in fact
subset one another, in either direction.

> Over time, the meaning/use/names of parameters will drift
> apart leading to possible conflicts.

Personally I think they're already in conflict, having taken
several days to work them all out wile setting up my new
machines. And, um, I think I know what I'm doing. Heaven
help the newbie.

> Plus it leads to massive user confusion (am I running
> smbd or ksmbd ? How do I tell ? etc.).

+1

Tom.

> It is simple hygene to keep these names separate.
> 
> Please do so.
> 
