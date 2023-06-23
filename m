Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CDA6EB64D7
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Jun 2023 16:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbjFWQWb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Jun 2023 12:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjFWQWa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 23 Jun 2023 12:22:30 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6030D2133
        for <linux-cifs@vger.kernel.org>; Fri, 23 Jun 2023 09:22:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g/6O2NwMrSwOgcokyTUwhZ1Xcq6udPXMNtq19pWWInLH5o5KxPfTGbJtYLyPNWbQ155dl0gqnV8t5rV7AINCikfghSy37DZvN9It3yGcvA2ybOngHWVZdfONdJ6KQkJRzyhEebWU8kCCyAn7V2cRtE8XOHDjhpFKNI92n3UHdjwm3/jsFxp+kPVfiAhfxNoI459jGYXGqhnNXyYCQ+AErjhziJm+XTBovfMQWWGihCU+T/W1fvVPzKuUD2Jk9nqST3lzhljXfA9vU0JEGNB2yzy0QjmdTenKJVBqZ+nAW/FMH2OiOlbZxVGfSN7WhdEZRpVjhO/TN3LxKc2rmktQWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fj1W48+hoIN8Vc16JfxhZIwCGpArPRyCsf7ZxEOhFE4=;
 b=JP1vPSslZO7F3CTqRPtOxVzbEfnMc/qmZ92FwN854/Zsg1kY4Ybhh0vnm8sMVoZI4mAdnYQJ0oIxA4ojc1LU5xusze9Qq3H/bu6rm4RYXK/Cju12QFgqY6dgHAuOQs+zf384vYQMibyyeVAtQGld7rQijfH5kUsrPKLKfeMsbzEVXM+tj8KCGrhOlPH+T8S7IJi9oybXWmrYTMWGJz1t6U1G5vHK++b33k0+LZdPyqpjE3mezGfILKb5vygaYYtjXuenWAiNMd3ndKmiw7Is3N/qB3cKA/h8JWpyJMMK6p51S26tzBD0HYjMJp9BPZSCh538zRh3acr7zhPugj3evw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BN0PR01MB6943.prod.exchangelabs.com (2603:10b6:408:16b::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6521.26; Fri, 23 Jun 2023 16:22:18 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::17e9:7e30:6603:23bc%5]) with mapi id 15.20.6521.023; Fri, 23 Jun 2023
 16:22:18 +0000
Message-ID: <9a9b5fc2-8905-7169-90d9-d0ee3454f5a6@talpey.com>
Date:   Fri, 23 Jun 2023 12:22:11 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 3/6] cifs: add a warning when the in-flight count goes
 negative
Content-Language: en-US
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org, pc@cjr.nz, bharathsm.hsk@gmail.com,
        Shyam Prasad N <sprasad@microsoft.com>
References: <20230609174659.60327-1-sprasad@microsoft.com>
 <20230609174659.60327-3-sprasad@microsoft.com>
 <CAH2r5mtKozDLH+y-6ASL1mb_v5g9=TxjekRGO=L_AxJjfhrKnQ@mail.gmail.com>
 <CANT5p=pa39qfZxu0jDp01L1AtvQTqoGdk1cB3jwq-rGOY-2+hg@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CANT5p=pa39qfZxu0jDp01L1AtvQTqoGdk1cB3jwq-rGOY-2+hg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS9PR01CA0015.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:540::28) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|BN0PR01MB6943:EE_
X-MS-Office365-Filtering-Correlation-Id: afe82f30-456a-4915-a28a-08db74060362
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rtPrui9hzhp6C9oHWf2VU2DRnBeMHu788yJjDPoXYnV9VU8RztDZvYYbVZbP9v6vH9G4yCKGGsImH46OABUYIepQfKD9DoOwCubDPG82G6MIVH0sC70kuOOHYPIPdywnJxMf27nFH35XGvFuaCjMLSzabgJSAi+BC5XqvG2TsMbRSELrYtQdKONKQ80e7cI8OnM4Fwcx1hCdzDXWDYDWwWzrSSOEuVH7XPJpHgQiALdm0XvURRl5EfiVtFp2jSwJj17dal0AyQzbACknxc8i8POVh9ccGoXy4I8a/n9iuRtv92q9XT0BZ+sHu0MC6VL4IZy4KCqD2pqyPY4zQjUfD29FH8R4Lx6BG4qb6TMevhoGWOfKTCnUCYyKTwRkmszZxv3z60s0MnGndDLgJ36jux59bA/MKWAb/9tTxV4NJ8b8zYi8onRiP6uBZ+JjeJZvAV7FmtXyTCbLmL829RWywlzMhznYdWMdOHSmAZRrKjLBxAFLOFeNp8bNDDS1i1WmPoEHvM0v6cwalJ/zwakRaefyQumHf0cCKZyMcsX3nljOZ5j/keMEAHbcDmsrIAFuvIUDxoUVVIOdIMq4Y8H7YlwecKtseWEzAhTCLKYym+fn2O45hzLqNKB/RKex8qfJtLEIBm2uagTwONSQT3K/qg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39840400004)(366004)(136003)(376002)(346002)(451199021)(110136005)(478600001)(45080400002)(6512007)(26005)(6506007)(53546011)(52116002)(6666004)(6486002)(5660300002)(2906002)(36756003)(4326008)(66556008)(66476007)(66946007)(31696002)(86362001)(8936002)(8676002)(41300700001)(316002)(31686004)(38350700002)(38100700002)(2616005)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0xBa3lEVlFYa0g0b2RFNGxRQmlJR2tEZHBYalJ0d2l4cHZxenMrb1RvMm44?=
 =?utf-8?B?ckc1dUJhT1MwZktoRzVFd3hoOEc1VENVY0NLMlNSNXR4cjdrNCtzWUlPcTNJ?=
 =?utf-8?B?ZFFmNzUwRWRNeCtKdmM2dWlvbDV6VDJpNHEyVytIRDl4R2FhbXRjenBHcHFS?=
 =?utf-8?B?NlA5c3lReHpZbzRncTZjMUpXWE9scjRxemdxNkd3NkJTclpiMzk5Lzh4RFhp?=
 =?utf-8?B?V2w2c1pxMHdvZHR2cEVUSlR1WkdVbVJRVWU2Q2crMm9Sb21DdTdWdXBPbSs3?=
 =?utf-8?B?WE4vcTI2Nk5wOEtxSTA3Y2ZMRVduWFhuUG9hbWtDSklJOFplOHBuNHJjWFMv?=
 =?utf-8?B?VkhPeXZteU9OWUpXMVhzRXl6SU1pVWxRWGtzdHRLODlFcXRtSlkva2s2akVZ?=
 =?utf-8?B?M28vQkliY09hVlAyM2lYbjA1TjQ0Rm04OUZXd1ZoMi9wR1NaMjQxM1ZvVnZJ?=
 =?utf-8?B?OXgzVUVYMVVhV0NYUFBEaW9rdGdZQU1oNEgvYXhiVmxkMys2dU5mMWdpcE9D?=
 =?utf-8?B?S29yVGdxUzJ0M0NyOHNteGRCWUM4aXZ0Sm1PaTRSdGUxS3puYTB3bkV1bWFN?=
 =?utf-8?B?QVN5TFBWanRSTnJzc2w4akdOZy9OMUlJR2czOWpvR2xYMXRBYzgrUk1YS29p?=
 =?utf-8?B?VzAweXQ0bzdxcDFpNFR3bUpDUjA1dFYzcVA4aVVFSXYxTnNBRkFMRmRQTGkz?=
 =?utf-8?B?cFZTeWNXMzh2Qm5DZ1FIaVpDSjJsRzU3eVQwWWswdnkyL1hVQkhzakJsUGhr?=
 =?utf-8?B?QUdxM3h0TXNUaVZLd1dValY1U285S2IwZUhOSjNLeXN1SWdVdW5SN0pxcFVP?=
 =?utf-8?B?M2ZRcVh6SWhiWWFEbFROS0R0dW5nWTN3MzFSOHRxL1RGTS8vNDNPUFBIZG9u?=
 =?utf-8?B?YmdCTzhJbnlOZmd1L3pZTWJJYThBS29vN3BiWWdrY0VoZnFBQWF5eE9VcTZp?=
 =?utf-8?B?b1RmWU5xY0VWSVRqSmxXc3BqTXcxMVZTV0t6UGd5RGZCcWtJcXZWVDlIN014?=
 =?utf-8?B?VUI0VDc5UzYvdTVXK2FWM3pyM1IrMEQ4UXV6MzZRQUlQcTBlZUxoM0Y5VEho?=
 =?utf-8?B?YlBIY0x6T256bUhMSTY5cEkrNWdoTWxMWlhJOFVPVkl6aWJKc2xaZ1NNM05u?=
 =?utf-8?B?SnNtVU5sZWtrTTRGbHNBbHduSjdmbFRTSHlqMlRDOXVsaFR3bzVuSE9QS2Zs?=
 =?utf-8?B?cTVjYzdhcVNLcXRIZmVHZ2s5dm9LZEFHcDhCYm9qVllaWVZISzRoaXY0YkF0?=
 =?utf-8?B?UkpnN3NRMjEwS09pRklXTXIvL3V0VmNKcEo3S3VoMDJycWxzRnFQemlkWjZO?=
 =?utf-8?B?b1dlNFBNNEs0bkRWaGVXbXZPb0Y5emFLdVZ4bzdCd2dlS3lMdFl1S1hKQW1B?=
 =?utf-8?B?WHF4ZnlXT3ZWL29ZWHdnT1JzUmVsaHFLV01hS3RLU1l4WjBhUTZ6UTFNYUpT?=
 =?utf-8?B?OU1aL3plQ3d1NkJ6SWdLQ1NhVE1ycEt2Wngzc0EreHBtWkhVQUtPeG95WmNP?=
 =?utf-8?B?REJzWXptQXBkSHRKUW1oWi9VMlJ4WEtKT1JvU3lFVDNSZkV5RzJRMk1rcWpu?=
 =?utf-8?B?SWg4ckJQVmlOSkdEUG44bFR0aVRYSGFSQ0NXNG95NFFkQllVY1J4bHNvTytJ?=
 =?utf-8?B?MyttclQxSmhZaGVwRm8xdFZFUFFVaUNaVHI5LzlVUEhOTUU5T0JXZ05lZzZ1?=
 =?utf-8?B?R003M1pJZXJvTnhHVDQ1S2RqSHoxTFNHaEhZWlpVcFNSRm1MOVNYR0Jlb2di?=
 =?utf-8?B?eXE4MFdNcWNrT3RoTkpEcGhnWnA3U3JOdFMvYXgzcVlmSHhrQXYyQXkxNFFU?=
 =?utf-8?B?bUJhNWQvdW5GRW5nY0dNTW9vS0J6ZE9IMnJaTzBIK3g0YW5OeXh4dGF2WE40?=
 =?utf-8?B?MXdQUUczTlVnd0xXbldiTWRYQ0drdXNudW5zZ0xFa3g5amE1OGdsczMvUEl1?=
 =?utf-8?B?bVBxcUtscGJDdmw2ZTg1R3VKb3paNVFXWThTMFZyT2tzcGN5RHRpS0c0RC8z?=
 =?utf-8?B?Q1VhOFFtWW1Ya0ZVZ0JGN3ZyRWJOUkN5SVN0QkxtR1lzVXFLNXQwZTRNL0U1?=
 =?utf-8?B?eWp0V29sakRsVkhZY29QMHMrWjJNRTh3L1JLd0xONWxnTFZVUGUzMENQbHJi?=
 =?utf-8?Q?G/NWpTJddi9ifPrYdYXRTGL85?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afe82f30-456a-4915-a28a-08db74060362
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 16:22:18.0418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0MGU6od3d6HCQdja4/ALosQhZyEf3GDVPqrrm9VchSuaE9enJpZJ7Uvfj4j7qCFA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR01MB6943
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 6/11/2023 4:01 AM, Shyam Prasad N wrote:
> On Sun, Jun 11, 2023 at 1:19 AM Steve French <smfrench@gmail.com> wrote:
>>
>> should this be a warn once? Could it get very noisy?
>>
>> On Fri, Jun 9, 2023 at 12:47 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>>>
>>> We've seen the in-flight count go into negative with some
>>> internal stress testing in Microsoft.
>>>
>>> Adding a WARN when this happens, in hope of understanding
>>> why this happens when it happens.
>>>
>>> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
>>> ---
>>>   fs/smb/client/smb2ops.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
>>> index 6e3be58cfe49..43162915e03c 100644
>>> --- a/fs/smb/client/smb2ops.c
>>> +++ b/fs/smb/client/smb2ops.c
>>> @@ -91,6 +91,7 @@ smb2_add_credits(struct TCP_Server_Info *server,
>>>                                              server->conn_id, server->hostname, *val,
>>>                                              add, server->in_flight);
>>>          }
>>> +       WARN_ON(server->in_flight == 0);
>>>          server->in_flight--;
>>>          if (server->in_flight == 0 &&
>>>             ((optype & CIFS_OP_MASK) != CIFS_NEG_OP) &&
>>> --
>>> 2.34.1
>>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
> 
> Makes sense. We can have a warn once.

Which sounds great, but isn't this connection basically toast?
It's not super helpful to just whine. Why not clamp it at zero?

Tom.
