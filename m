Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F7AC4332F
	for <linux-cifs@archiver.kernel.org>; Wed, 21 Dec 2022 16:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231569AbiLUQrK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 21 Dec 2022 11:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233234AbiLUQrJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 21 Dec 2022 11:47:09 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FECD24979
        for <linux-cifs@vger.kernel.org>; Wed, 21 Dec 2022 08:47:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YAW0BvYasbTm4+YOUi8fulXGa9ufpxlCevmiuhix1wbmQbLzoVfvdQhGcLSMPptch+NAhFNGmyb1kTAH+fXhGM+5xQJm/JW/EO4P1uQIM/ZfLbnm8bMU8nferyeQYedAFgRKxzSXUHi0NR9FYtm0i9RYuAS0c/VZAjgTKQOG8M2X/jquoLMV+QGnggdrtw7nYYcRMxbUz6YPeYB6KaEBD9sFPJLjEDhe/qASwMltRFyNX8vHVQZvj6CsIV63jvNLASrcnk10joa7Ap5FZkz4MaZXfh1q3UD5xvxSRzGX2ftvdHQxPuFFxUTFX7fI8bbuLjf2aXiY9DfpZ61yk6KU2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2HRhZUCPxSRcVI43kD/1i6DQEvjTOeNysHHx2vLEV7Q=;
 b=eAmih0QW9+ByDKQmuD0aCBQv0PSQByToSq1U1ts9+vv9m7aYSl9qRLxF+btlHKoLcIVgEHrNZaXDuEtnZ52SaSlca/GxtbpwXJ3YsrRLRIZcfPzl3ZGgOWnTT21fwvmgxDvCZaZRI/fAvwFZdfFcB3kRW60WstmCMMi+3R2wM+bLhYMwbTrFvczpntsOpj3ttWrhnth4Bclumhe+t1BqKNHocwMdWUFCcxvPY+0yDB+DHL037s+ZkZK7Osv4SFWVY7tr6GXk0z7raTe84S+UvwWEJnA0jP5Gik4TQ0d6lfXDUkyiqk6ZNEkGu1cRDAZ2NCjsU0izN4YeyMD8XfeLVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB5621.prod.exchangelabs.com (2603:10b6:a03:118::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.12; Wed, 21 Dec 2022 16:47:01 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d8d6:449f:967:ccb5%7]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 16:47:01 +0000
Message-ID: <73b86766-75cf-cc1e-0d21-01eaeea71a49@talpey.com>
Date:   Wed, 21 Dec 2022 11:46:59 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] cifs: use the least loaded channel for sending requests
Content-Language: en-US
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Bharath S M <bharathsm@microsoft.com>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aurelien.aptel@gmail.com>
References: <CANT5p=oKQEB6HnopL=jAd0pxd-+OukcfrVgc76X-suShqUiA9w@mail.gmail.com>
 <CAH2r5muGBpwvpt6tTXDj2s=UHhJyG1=p94mcTaZ7QbrpuZ2R+w@mail.gmail.com>
 <6b39f048-b292-a0fd-af8a-abad97d22ed7@talpey.com>
 <CANT5p=rje_XAHySDoxL50C6=EUkvdawN4neU+0xyvFDLAbYW6A@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CANT5p=rje_XAHySDoxL50C6=EUkvdawN4neU+0xyvFDLAbYW6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:208:91::36) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|BYAPR01MB5621:EE_
X-MS-Office365-Filtering-Correlation-Id: 28845931-9e71-4dab-fadf-08dae372fb49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f3MaZV5oRneLe3R+coZZ/Xh6bxaZS35lrD0nPTICTW3zH4F7MyQ0RyFlpH6M0BAVvGhbpK4Q2rZD+en+/sqrygJhJong3jjD8KPSK7atI5Igg9zuw8EjqN4eOgdgW0sJtsOe2hiumEVLl2LMQ+KVrkKkrEbg4wmi5mbtNbKwduUHru2PhYnRIzfFgJULlPQXSB4lSbb72yxjTuWQ/6le4tk28Km0lBy+1v0uA7uTLKTq+WkXaOTs04iv/PgGdYNLthcK9oHzYTSPYI26+RAplUBqXcDSVH/8BHepy8MBI2FlnM808PUM4haWtefBmYkhHUzLkYZ1k9suUV5osXuE/ZC7MRNxqkgBBF/oAnenu9AULTvqQ++F8/yhsu593mZ2HncrgxIaEwWAivi5FBWov60vBZCakgMrzUJhLFrj+nTPRw4hhTO0grd+L6dqjJMwqBj0TQ9Do6+W/zVDTLlKdpQBx8rgzato1uRG4Ip1ntVzTroYU7xlVBBSJHAYuLHb16k35yfDm6C6SFvxzuGtKb/c8ij3SV5MJtjPt+5KyIsHwLW6gNPXlNBfWN/xK+BceAJ2EoVzyY8/ClmmGPW2z7TL+ArruJzxcEnjUFyUByv4HudoLw0ZH37T9MVazOviUm4nlNC6o1bLOs6c9U7uLr3zzopdbuvKFOtwITFHxsrfYv8+GHZ62tNAsa2XwrsRZuDHs1Wfmr1YHMam/Ou9ZFes8wGNkII2gP6zmNJvWRcY3n+HqML4rmTvPOHI2mbC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39830400003)(366004)(396003)(376002)(346002)(451199015)(478600001)(966005)(316002)(6486002)(52116002)(2906002)(45080400002)(6512007)(36756003)(54906003)(6916009)(83380400001)(38100700002)(31696002)(38350700002)(86362001)(186003)(2616005)(6506007)(26005)(53546011)(8936002)(5660300002)(31686004)(4326008)(8676002)(66946007)(66556008)(66476007)(41300700001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0tCSGxCWEQwNnFlaTIyeHRubDQ5OTRFaXZnaGJpeTk4VHk4OWx1K0I4eFI1?=
 =?utf-8?B?bTIzMnlqT3M4NWRnVXpUZHJxY0lrN1BURkh5M1dNWmZWWmQrSUpMbWxCSHFm?=
 =?utf-8?B?aUFjeWNMRXJjYk1hTXBYaUxCRkhNRjNEbFpNdkpTdWlIUTY0aHNjMDNxL096?=
 =?utf-8?B?RnVpM3pid3RWWFc5U2ZnZUpjRXVyR09OU01vS2U5VktweDU2dG00bDQxZTZW?=
 =?utf-8?B?SVdVRVZUWkVqZjdWM1VEYkVwV2sxMXpJanNvVmhzV3FIcjJEL0JqOU1IV1dY?=
 =?utf-8?B?aUFOMCtmNWY4RkFObHgzZ0wxVDZvSU03SE9MZmxHM3FaSTVUSDhLWFVEdDI5?=
 =?utf-8?B?Z21IelhNTHoyTFhGSHhIUWRDQ24rN3VoVVgrVzkvVnBpUWlKdE93R3VGSG1i?=
 =?utf-8?B?VDJuQThKM3Nwd0lJU1ZiRWJQTHltWWhTVm4wZmx1UUxHQXpsMFRtd2tpYXg5?=
 =?utf-8?B?WlMyeng4WXlrN2laQUFLdnRFTnAyUXlSdWR6elIzeVNpN1dHSE5Sb2wwWjI4?=
 =?utf-8?B?MEFOeHVhcmpIeUNHWWZmT3lDRHVTa3RFZE1uK2Y4Q0JmM1FEblRXT2c0UU90?=
 =?utf-8?B?clBMME56SGZiT2tMMjFzZG9lVHB6YTBUYk1ZZWRseDRVbmU4OGIrcytDMENT?=
 =?utf-8?B?NTByWkhTQk1TQnNYSTdFMnB2UmVTNDBwVHQySmZPaUJWZGk2WjVTejJVU0Nz?=
 =?utf-8?B?YWZyMUxQQVozOWF4RHVJaDZqL25DQXByRDM0MFFQYTBweng5TGdTZkV1QlU5?=
 =?utf-8?B?U3E3MVNGT1ZtMVN1NXZGTmltRU55VjJ5RFVMZFR4WEthazRwK09EaHJKUmNh?=
 =?utf-8?B?cDJjWVNxZEF6NW1IWTJGS1ZXZHNOY09RN2Fxa1hvcUFmNFp4WDlRR2NWNzRD?=
 =?utf-8?B?dk5jcktJdktYSXhzUEhRNUJYamE0ZWlDQmJtTnZ5YmZ0K3VsMjVCMUxwNEYr?=
 =?utf-8?B?OCsrUWhxelhkWWtoTzBJY2hNQ0NiK0VQZ0lrZERYMG1hKzFrQ0VZZUE2VFRL?=
 =?utf-8?B?UFdjYVJ1QTRKbllWbUdYV3YyMXdKbTFqYVI0a1NqNlI3c2Y5T2M5N0dWMlgz?=
 =?utf-8?B?RGVYVHJTM0tjMXgwNGN3T2pWUXhheGE1TFl1WFpSOERHNTE3VDZyT0Z0RmN3?=
 =?utf-8?B?Z3dHVGJzM1VCTFFzeWJXNGVaMEUxajFVeFVyZUFyczNkRC9uUWpxRlBlb1Jv?=
 =?utf-8?B?SHJTbFJUUXRBNXZSbS9nNjZlM0FqWHJPNUFzVjJXY2s0T25jbnYvaDhMczgx?=
 =?utf-8?B?UnplSW0vS1pFUzJVQnpXTmxRQWE1SmZlVTFxMUFGZnFSdUZOcmJzbXFpRlkv?=
 =?utf-8?B?Q3Y5bjNrS1NLS3YvMG9KMUQwL1hwRHVnUGloM3l3UVkwKyszbjNNdVRRdTRa?=
 =?utf-8?B?SEY1ZWppZzRSMVVvOVFIYzBKN0dXQkNaK1pUaUNIbEZISFV0Q2tMNzB4dFdN?=
 =?utf-8?B?NTF0RFhhTG1yd1J4OVZFTEpiM25QbnlvOGIyWUd6RXJmOENwTHFFdmJlVGtH?=
 =?utf-8?B?cFZUM3pScWphYlpGaUZxZk5ydTJvMkticThwNFNkS25PS051RDBiYk9UeVp4?=
 =?utf-8?B?amtuN05sZ1NpWitYSUE5eDNId1lod2ExZjhQOG80MThRSUxLSmIzZzY1c3Ji?=
 =?utf-8?B?TGQ5M0lMTnhiSE1kUnlURklaVmQrV0xBMjBKcnJQN0RnNVBicUF6L2pMREtM?=
 =?utf-8?B?T3pBMS82T1J5TXg4SVJNeGYyVjFqTUhQTzVKUmFlU3pueTRWUmlFRmtaWXdx?=
 =?utf-8?B?cXJndmtYZzVMTE9OcSs2UTFOOUlaUWJSdUtNRy9ZVGt4Zks1REx3TU9QOVVq?=
 =?utf-8?B?a2NlazFySUs3OWU1SHhuWmh0Qi9mM0dPK0c4RTgvZUtQOWlsTVpSbTl1M2E3?=
 =?utf-8?B?U2hvNlZDS1FWWFhjQ3JUeHlPQ1JvRnlnZ3RZYjZ5b0tDRVRqQjBpMlhlS0g2?=
 =?utf-8?B?Wkg3SzRpQitTM2o5WFF3UG4vbC83ajdIU1BnWjdjVWhLL09GS3NPcFJUZUpC?=
 =?utf-8?B?OGtvYU9GcEpPb1ZpT0k5c2YyWXVjSjFWSUpBcWdOZ0l1elVhRUNwWU0xWVJH?=
 =?utf-8?B?U1Z1aEkyNUhnVGFJb0FLWFA2NXB2bkUzVSt0eDNybTlUMHlzUHU2S0hhb0M3?=
 =?utf-8?Q?LgAs=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28845931-9e71-4dab-fadf-08dae372fb49
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2022 16:47:01.2583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ET4rnUQZuFIgwCyXmNh+JvEzNIv1fG6Ehd1BZumyhyD1RgpQRrqJ8hrYk6rS6WyA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB5621
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Question on this:

 > We will not be mixing traffic here. Channel bandwidth and type are
 > considered while establishing a new channel.
 > This change is only for distributing the requests among the channels
 > for the session.

I disagree. The iface_cmp() function in cifsglob.h returns a positive
value for all interfaces which are as fast or faster than the one
being compared-to. And weirdly, it only looks at rdma_capable when the
speeds are equal, and it ignores rss_capable unless rdma_capable
matches.

It also makes the following questionable assumption:

     * The iface_list is assumed to be sorted by speed.

In parse_server_interfaces(), new eligible entries are added in the
order the server returns them. The protocol doesn't require this! It's
entirely implementation specific.

In any event, I think if the client connects to a server on a 1GbE
interface, and discovers a 10GbE one, it will mix traffic on both.
In the current code, every other operation will switch interfaces.
In your code, it will only slightly prefer the 10GbE, when bulk data
begins to backlog the 1GbE.

So, unless you fix iface_cmp, and rework the selection logic in
parse_server_interfaces, I don't think the change does much.

What about the runtime selection?

Tom.



On 12/21/2022 10:33 AM, Shyam Prasad N wrote:
> On Tue, Dec 20, 2022 at 11:48 PM Tom Talpey <tom@talpey.com> wrote:
>>
>> I'd suggest a runtime configuration, personally. A config option
>> is undesirable, because it's very difficult to deploy. A module
>> parameter is only slightly better. The channel selection is a
>> natural for a runtime per-operation decision. And for the record,
>> I think a round-robin selection is a bad approach. Personally
>> I'd just yank it.
> 
> Hi Tom,
> 
> Thanks for taking a look at this.
> I was considering doing so. But was unsure if we'll still need a way
> to do round robin.
> Steve/Aurelien: Any objections to just remove the round-robin approach?
> 
>>
>> I'm uneasy about ignoring the channel bandwidth and channel type.
>> Low bandwidth channels, or mixing RDMA and non-RDMA, are going to
>> be very problematic for bulk data. In fact, the Windows client
>> never mixes such alternatives, it always selects identical link
>> speeds and transport types. The traffic will always find a way to
>> block on the slowest/worst connection.
>>
>> Do you feel there is some advantage to mixing traffic? If so, can
>> you elaborate on that?
> 
> We will not be mixing traffic here. Channel bandwidth and type are
> considered while establishing a new channel.
> This change is only for distributing the requests among the channels
> for the session.
> 
> That said, those decisions are sub-optimal today, IMO.
> I plan to send out some changes there too.
> 
>>
>> The patch you link to doesn't seem complete. If min_in_flight is
>> initialized to -1, how does the server->in_flight < min_in_flight
>> test ever return true?
> 
> min_in_flight is declared as unsigned and then assigned to -1.
> I'm relying on the compiler to use the max value for the unsigned int
> based on this.
> Perhaps I should have been more explicit by assigning this to
> UINT_MAX. Will do so now.
> 
>>
>> Tom.
>>
>> On 12/20/2022 9:47 AM, Steve French wrote:
>>> maybe a module load parm would be easier to use than kernel config
>>> option (and give more realistic test comparison data for many)
>>>
>>> On Tue, Dec 20, 2022 at 7:29 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>>>>
>>>> Hi Steve,
>>>>
>>>> Below is a patch for a new channel allocation strategy that we've been
>>>> discussing for some time now. It uses the least loaded channel to send
>>>> requests as compared to the simple round robin. This will help
>>>> especially in cases where the server is not consuming requests at the
>>>> same rate across the channels.
>>>>
>>>> I've put the changes behind a config option that has a default value of true.
>>>> This way, we have an option to switch to the current default of round
>>>> robin when needed.
>>>>
>>>> Please review.
>>>>
>>>> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/28b96fd89f7d746fc2b6c68682527214a55463f9.patch
>>>>
>>>> --
>>>> Regards,
>>>> Shyam
>>>
>>>
>>>
> 
> 
> 
