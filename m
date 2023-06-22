Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8662FEB64DC
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jun 2023 21:10:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbjFVVKr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Jun 2023 17:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbjFVVK3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Jun 2023 17:10:29 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20601.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::601])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA8930CF
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 14:09:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRue0BFcZkhRib5SoKUhYhOh4zhuLc0Hp73xZu0oYmTubzfpWf2r5lI9iueaqESgmjNaOF78/ypSkS7+1TCWolgkAev0SJIVCXwV66Msq+2SS0yQM2bu/G3K2a7vaj1dhZlOdfX+Po8Y+bJ4WFTRdP5KoV0d9FVGiTNtzZTFiTC2+p7aaDSGxfxwonZnzEZ6n9hUXZZtIngSxdLfxMuJttvL6cfGAJmttwR1eqepOgC75OXIDIioPR1tWJ2c2GfSUhvibWzjHvyymkwQ6HoGK3PZfEDuO7j3mQicUFjD4ZZ6CEoYIuVbY7KAfd8JBNHe5A+tFlemfNSv+kV4adUoCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=goec6HDNGkBQO2uewm3fwji7ssIUKXkL2z0hdU6ophQ=;
 b=fvPUZIa4BWe152pQYsfl1yzS+vzekkQxMpByqBGLxQRPe7ZQhkZI3iBa6xJW/d3sa8htZMukYcwpB3m0E0nTxPLAh/5mBbvmjsQdEdgo6I9t3/yQ8YjsrUKQX+ZyC3V5TQrEQBwRxzDebcxZqIW+847z/cBwpIF9cDZwEFFaWYmO1hBNIzRSBa4bRkOeMarXEl3bvyCf91zB7OrW5pRr8uar47y/DUHbfPUMJ662ydMFP6gned26bpwpPDwm+Iw9QD4NkUqdm/2FDdgzbfSlkxuxQYBJM2rLkFSYCqB+GaWPOBJtkiQf6zwZa4Q8f8Tyw4XP83XiimWnadAHOAfyBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 LV2PR01MB7645.prod.exchangelabs.com (2603:10b6:408:17a::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6521.24; Thu, 22 Jun 2023 21:07:16 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc%5]) with mapi id 15.20.6521.023; Thu, 22 Jun 2023
 21:07:16 +0000
Message-ID: <6b4aa9b0-eb2a-c8ae-2388-52d561d025e6@talpey.com>
Date:   Thu, 22 Jun 2023 17:07:14 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [SMB CLIENT][PATCH] do not reserve too many oplock credits
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mvuuCeQQKN+RRxoELjf9NOfLNOwgOjBbxdUKYiowsbY_w@mail.gmail.com>
 <CANT5p=rO7KX9KJVJ+tQVfdYXtORQbHvbR0zZq2Gjd5nvOmWjvw@mail.gmail.com>
 <CAH2r5mv5ac0eEJ0eYGKmb6AvYXhY2Uq4srt9UjcZ5fn5TWoyog@mail.gmail.com>
 <45a81a0a-8c16-ac04-65e4-b30d522b8912@talpey.com>
 <CAH2r5muO_zVHFu8trM1uV40poi4G2eVdMXcOGcfABcOfaKNBhg@mail.gmail.com>
 <CANT5p=rsK+a8pgSbMdV59EAEx7EoCe7_irZuUz7mHb+TxkM06w@mail.gmail.com>
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CANT5p=rsK+a8pgSbMdV59EAEx7EoCe7_irZuUz7mHb+TxkM06w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR01CA0007.prod.exchangelabs.com (2603:10b6:208:71::20)
 To SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|LV2PR01MB7645:EE_
X-MS-Office365-Filtering-Correlation-Id: f9a52662-7937-426f-0fe3-08db7364a83e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yffdWWpGeZV/nuzHwW0tKUAMFn1l+RUvLtgrIiTjDGfu2LNootWC1JpR0fqMN5wUUK89jGdn5r0XgHECgbXqwmNZMaUvBjGC6Hx4u8cSlXSQMPHC2okQtC3Ejcd4TnIfxy91OQ7n3fD6yS3ausRPnzrNvUSK696BazEO7GUSm1AftcG4Gv24+on9k+8qwGV22uOeIqBE8CjUN9QX98sR2nTCFxUy+R54ue8llLNFeqQlzLDhJhoAbZIipRdv87/+W30l/Sv5jM3530ArOq3KLT6AXLFNA590IG3aZT9kg6ZYuEZ4s697HYxtHKJXcG/v8mR1H0fIz7oQk7gJF7a92AfRFW4LtSW72xGblMPURLFIRhWbnysEOWViLji4AgQH04rgnZM6jPevofq8NOSdtjNr8Gl+i6zPetGh6oK6FzzVcWx+CxHpSCzLeXzuD6MHrVTifBytlWcVtuTVWUmusnwbV+HEVKOE8mEFNPKWAXFiW2dwKNBPbpAF4KBIJamlWM8ENT2J3OheeH+RJw3GZmrqG46oB38v1se0TtqCBBublr2gR/OBwq6rTSCe+3snIREXL1g0j1qWrFfNU4xyjCUrEiZp49DswIQLQJqm+r64n0QT3PQTNanNNPF4mSLqnh3Z9U+9LEtwSIJxRn8K3RUlvO49rpp8P5M9j5gnDFMPKkA5YmS2fHamF7rnzt7G
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(376002)(39840400004)(396003)(346002)(451199021)(6506007)(8676002)(8936002)(31686004)(36756003)(66476007)(66946007)(66556008)(478600001)(316002)(5660300002)(4326008)(2906002)(110136005)(41300700001)(86362001)(31696002)(6486002)(38100700002)(38350700002)(53546011)(186003)(52116002)(6512007)(26005)(83380400001)(2616005)(522954003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnlaekdaM1Y3MHBIWkdSYzJBNXVLcy95NTNvQjd1R1F6Z2VBWTNVaEVQVGla?=
 =?utf-8?B?RGY4dFpiR2VsNGxWdkNUb3grV2pSelNmdlNJc084aVh3MUQ3WHNZQUF1Yjlo?=
 =?utf-8?B?dWN0M1VCOU16WGtXaGxyYnpkSGRMYnVsZmZyamFFb0RBaVE3SFdCaldKdkRG?=
 =?utf-8?B?eVZQRm1CcDcyWGY3NzFmWXNwZkxDQlR0dzJtaEZNQWp0SW10WFBzNEc5WU9U?=
 =?utf-8?B?V3VNSnVOVmIvY0ppdW4rejV4Z2JqTGRzME5DZEMyS2FPdHpSWkFNWmpRaXN4?=
 =?utf-8?B?S2FUNlNIVlNVWHVaTW9zeW9tZm9xRytJOGV6dnVrdzJqZWlyLzByekUrUm9p?=
 =?utf-8?B?YU51YUJ2SEVsanpPWTZjS0JINWRMRVVSUFJkY0c5dGI4VXpzMWdZNVhIcERs?=
 =?utf-8?B?V0VBMkRaajgySFBveXdldDQrb3lUL21GcXh1QU4zOXMzK2E0SGxaemJZb2gz?=
 =?utf-8?B?NmsvVDV1RFBPTmFlZ3QrM0MyVjFIMmltbmxlVzJBU3ordHIvMG1yNEU1clN5?=
 =?utf-8?B?aVc4ZDBKN28xUzZNNnlHWlRZTlJhMU5WOEx3TmM0K0hWKzFJZHM2WVRzT3dU?=
 =?utf-8?B?c0szeFROUjhIeTRLVnJtQXV4MHlIbGU3TGlUeEowQy90a1VLUGRqQzdEaWMy?=
 =?utf-8?B?WnducW1jQ2tpNHZzcFBXdzdtcURWOVlKVWlMZGVZY1dBUzJqVGsrVjRjQUVG?=
 =?utf-8?B?QzhwTlYyd3ZPZzlZdFBIVVIwL1NTWllyNXNudzRjRExuU2NqcVdoTEE5S1cr?=
 =?utf-8?B?V1F1ZDdoQSt4WW1obkpaMTZDcjhvc2JTV0NQMy91RWx4WWkzNjdyamdZRWhD?=
 =?utf-8?B?dU4rNi9qREJHN0RDaDA0NE91S001eVA4RE9UeG1ObWJoQ05ZWFhkZGV1czB2?=
 =?utf-8?B?Tk5sb2Q3c0lwY0J0WGo2dCtMK3l2MmIweFdvbmRvTlpQY0VMWDNia1hwSXpX?=
 =?utf-8?B?Z0FjaytGYkR3Z0FZZU1FNjJ6OXJ4M0JPVzJIRU1kanRkZGxtQSt1L2NuekQr?=
 =?utf-8?B?cXN6OTFGMzRKVmJ1LzZHK3pXZldOSGlUY25Zc1ZuSDAyTXpnNjBqVmc2Wmk3?=
 =?utf-8?B?ZkhrVEVPSG1NZmhnYWE2OXZjM1o4R3AwelE0dVl2c3lDRFZpSVhFN3hhTkY0?=
 =?utf-8?B?Tm1MZHJJNTJwcVFmbnFOanFhVWlWQk9xMEh5S0ozVzNPQkpoempkdjRIZDRR?=
 =?utf-8?B?MWEvQnhrbHIxNjF5TE5nSHU2R3pUd2NOY2ZaRUM2cHVVanhHM2I2bjRzaEM5?=
 =?utf-8?B?czdpRTZrY0t5QXF5YTVybEdWTE40b2gyUEkwTXA3VTVIS1g1aGdxTzBUcnlJ?=
 =?utf-8?B?SGdMZ0ZoS2h0ZGNhdjFCYy8rVW5oTmQ5RG1uNmRBUnNIbkxJcTUwRklUMWY3?=
 =?utf-8?B?cEdmQ2JPTTFZcjFsdGpuZFZRcUtBSmJSUU4xMXpqeDBJaGFhZ2VSclYvaEph?=
 =?utf-8?B?RTJXcGtWY2U2ZzBZT3lCOTBXNEJhM1lLRnJJVGtuTFE3VlIxSkpCaHczSHV3?=
 =?utf-8?B?U0ZsM3hQQVc0bEdPZDBpU3hvYU5pcGxmQXBISkl0UVlIVWpRbklrRi9HbldX?=
 =?utf-8?B?MTZxcmRCQURNVVIxdVhVZWx6MmxsK1g1ZThmeVpITE92Y1lXOFhSMkROQjh2?=
 =?utf-8?B?WE1EYzhoSXdYTWJ5WFYrcDZ0YVBlSTBLV2xmL0Fvck9WMTd1VmlZYTN5OVkr?=
 =?utf-8?B?WC9yeEFYbDFqTzdSNUFGNnhpNlRoTXAra2RPR3NvcWp0M0lydWVwSVZOa0Fz?=
 =?utf-8?B?ay9JU2cwSzU0akUrcDhqMFIxdzRCSnNDY3lsbUpNamR6U3B3dlp1VElOc1o3?=
 =?utf-8?B?bVJtclJIaXEvaFhzSFJNSm1aWEx0MlJQMDRWZ05KZmZMRXBGQzcvNVJlaTlu?=
 =?utf-8?B?OWVJN1E3dkF0QzJLMmljbFhQZzVVOUROc3g4WEJvTVFUYUhyZmpzejB4ckph?=
 =?utf-8?B?YnJlYWR1cHZDdjgxMEZhNW43WVpab3JXQmlsVnQyWTFaM2RtRHlhV0lHcm1u?=
 =?utf-8?B?UWxXL0pmUDJwM2FWYXIyUm9wdlhBd3Frc1BtL0lwL0xDenpFaVdSdW53Z0JV?=
 =?utf-8?B?NzU1TXE3ZEEwQk9ZWTEvMW1uUVVoOXhnb2xCOGZyZHcvbWZETmxEQW1OaG1i?=
 =?utf-8?Q?zKYMeVgEhPZtgmq5a4MQuro/l?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9a52662-7937-426f-0fe3-08db7364a83e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2023 21:07:16.6014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lrZUyMDPefKrsREtCSvkIbxa1Dxd0BJ9c/++VXaj2by4N8u0rc1s/8W6WaA8IpSG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7645
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 6/22/2023 2:42 AM, Shyam Prasad N wrote:
> On Thu, Jun 22, 2023 at 10:26 AM Steve French <smfrench@gmail.com> wrote:
>>
>> On Wed, Jun 21, 2023 at 1:25 PM Tom Talpey <tom@talpey.com> wrote:
>>>
>>> On 6/20/2023 11:57 PM, Steve French wrote:
>>>>> Why this value of 10? I would go with 1, since we already reserve 1
>>>> credit for oplocks. If the reasoning is to have enough credits to send multiple
>>>> lease/oplock acks, we should change the reserved count altogether.
>>>>
>>>> I think there could be some value in sending multiple lease break
>>>> responses (ie allow oplock credits to be a few more than 1), but my
>>>> main reasoning for this was to pick some number that was "safe"
>>>> (allowing 10 oplock/lease-break credits while in flight count is
>>>> non-zero is unlikely to be a problem) and would be unlikely to change
>>>> existing behavior.
>>>>
>>>> My thinking was that today's code allows oplock credits to be above 1
>>>> (and keep growing in the server scenario you noticed) while multiple
>>>> requests continue to be in flight - so there could potentially be a
>>>> performance benefit during this period of high activity in having a
>>>> few lease breaks in flight at one time and unlikely to hurt anything -
>>>> but more importantly if we change the code to never allow oplock/lease
>>>> credits to be above one we could (unlikely but possible) have subtle
>>>> behavior changes that trigger a bug (since we would then have cases to
>>>> at least some servers where we never have two lease breaks in flight).
>>>> It seemed harmless to set the threshold to something slightly more
>>>> than one (so multiple lease breaks in flight would still be possible
>>>> and thus behavior would not change - but risk of credit starvation is
>>>> gone).    If you prefer - I could pick a number like 2 or 3 credits
>>>> instead of 10.  My intent was just to make it extremely unlikely that
>>>> any behavior would change (but would still fix the possible credit
>>>> starvation scenario) - so 2 or 3 would also probably be fine.
>>>
>>> What do you mean by "oplock credits"? There's no such field in the
>>> protocol. Is this some sort of reserved pool
>>
>> The client divides the total credits granted by the server into three
>> buckets (see struct TCP_Server_Info)
>>          int echo_credits;  /* echo reserved slots */
>>          int oplock_credits;  /* lease/oplock break reserved slots */
>>          int credits;  /* credits reserved for all other operation types */
>>
>> If we run low on credits we can disable (temporarily) leases and
>> sending echo requests so we can continue to send other requests (open,
>> read, write, close etc.).    As an example, if the server has granted
>> us 512 credits (total) if there were 4 large writes that were
>> responded to very slowly (and used up all of our credits), we could
>> time out if the write responses were very slow - since we would have
>> no way of sending an echo request periodically to see if the server
>> were still alive) - since we have 1 credit reserved for echo requests
>> though, even if the responses to the writes were slow, we would be
>> able to ping the server with an echo request to make sure it is still
>> alive.   Similarly (and this can be very important with some servers
>> who could hold up granting credits if a lease break is pending) - we
>> have to be able to respond to a lease break even if all of our credits
>> are used up with large reads or writes so we reserve at least one
>> credit for sending lease break responses.
>>
>> The easiest way to think about this is that we reserve 1 credit for
>> echo and 1 credit for leases (although it can grow larger as we saw in
>> some server scenarios when they grant us more credits on lease break
>> responses than we asked for), but all the reset (all other remaining
>> credits) are available to send read or write or open or close (etc.).
>>    When requests in flight goes back to zero we rebalance credits to
>> make sure we still have 1 reserved for echo and 1 reserved for
>> oplock/lease break responses (and everything else for the other
>> operation types).
>>
>> The scenario we were having a problem with though was one in which
>> requests inflight stayed above 0 for a long time and the server often
>> granted more credits than we asked for on lease break responses - this
>> caused the number of oplock/lease credits reserved to be larger than
>> the amount of credits for everything else and eventually starved the
>> client credits needed for normal operations (this would normally not
>> be an issue but the number of requests in flight stayed above zero for
>> a long time which kept us from rebalancing credits, and moving credits
>> back into the main credit pool from the oplock/lease break reserved
>> category - which could significantly hurt performance).
>>
>> There is normally not a problem with having more than one credit in
>> the lease break pool, but when it grows particularly large it could
>> hurt performance (or even hang).
>>
>>
>>
>>
>>
>>> If so, I really don't think any constant is appropriate. If the client
>>> can't calculate an expected number, we should keep it quite small.
> 
> Hi Steve,
> 
> During response handling, in case oplock_credits reach 0, we anyhow
> have it stealing one credit from regular credits today...
>          else if (server->in_flight > 0 && server->oplock_credits == 0 &&
>                   server->oplocks) {
>                  if (server->credits > 1) {
>                          server->credits--;
>                          server->oplock_credits++;
>                  }
>          }
> 
> So I don't think we need to reserve more than 1 credits for
> oplock_credits at all.
> I think the behaviour would not be affected by restricting oplock_credits to 1.

Good! And I really really hope we don't ever set echo_credits higher
than 1 either. I see no point in parallelizing the nearly-useless echo
procedure.

Tom.
