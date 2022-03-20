Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BFBBC433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 20 Mar 2022 01:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244618AbiCTBqw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Mar 2022 21:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234519AbiCTBqv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 19 Mar 2022 21:46:51 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D192156784
        for <linux-cifs@vger.kernel.org>; Sat, 19 Mar 2022 18:45:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KadvzZs7vuKdLeLxHuVG2TFcPMq+j0nDfEP+Q3/hKGaSGvBrerJQoeRwd2OfC27FsIocvokJOUDcnpGbnWScXozl085nJeiXqS8+d/vL8BytXJ6zzhkFzhfxX4+QTCr5U9hciP+4Kqixd7vN/JJCdSjKrgt6loywaz8w9+skvYiIWKrXloM33HQsGda+QFmvQgpBicshOEoTCnyWBabuDHoFBVL1VDxQ7BK/AYC4vl0ua2HoJG0n9tNgESf97Q1kBiOHSfpesuugdnphXr/MRADg3gmhSPp0a2Gfw+I9Xm0QhOvlBPv0OCxRxCpSmSQ+4JNnVDosluWWmvAp8V05mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ywzR+/kH7L45WiDFG1WU3A+KXSh91Qv77BqzBS3wr3s=;
 b=MLSc7s+HMwiNOwOmFFYVGIA4LhefTccXQdSnefVWKpEpBVNAf/iXDrO/zQ9VQFOh7LfQSlvJiYZaxVTU4GB/vvqowMIz9KZSpnHnScP8I45wB+n1uR8WTNMEDwEqKajoqMUQtzJFAmTaRa8zHDJPGAufJFXaBIAzO4KmfGScbOBoArOSAB94OvYENtAPoJKRrqMmGdvU8dH7KXUTDpXt0UfkZsGQEykSJ7Txw4WyuzvDCNdFAlKRCLC7u2Rdq8JDy2EsAbisAd22evfevnOorYLdjr7eF+aeNyzln5Ffumt+uxkrBi8HT80NkQpbZ56Wv8q3GisgKpHrVFhgE/zTgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM5PR01MB2474.prod.exchangelabs.com (2603:10b6:3:3c::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.17; Sun, 20 Mar 2022 01:45:26 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::3452:1c0a:743a:602d%4]) with mapi id 15.20.5081.022; Sun, 20 Mar 2022
 01:45:25 +0000
Message-ID: <1ab1e73c-566c-7f1f-6cbf-5502b99611e8@talpey.com>
Date:   Sat, 19 Mar 2022 21:45:23 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] cifs: fix bad fids sent over wire
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <smfrench@gmail.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mvG6jmUKVi4zqRouFgYSjYxJjTExjmPtH64PAjFahE8dQ@mail.gmail.com>
 <570f1f21-ecd2-6f88-e78f-7c57a22ba7e9@talpey.com>
 <283E0E80-BDAA-45B4-B627-C7BF44C0D126@cjr.nz>
 <CAH2r5mv2E=zQ+nVjMuLGvz3CGMLxM2Cq4aUEnLd3ieRCQTOM8Q@mail.gmail.com>
 <CAKYAXd_dUnBLmAutFVWpOczRH-3U21vR51nHsNTjAVfUk1KEig@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd_dUnBLmAutFVWpOczRH-3U21vR51nHsNTjAVfUk1KEig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1P221CA0018.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::30) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 141ff1a9-3087-4dd4-c6b0-08da0a134e12
X-MS-TrafficTypeDiagnostic: DM5PR01MB2474:EE_
X-Microsoft-Antispam-PRVS: <DM5PR01MB247459F4E8FBF4CAD85A1CD2D6159@DM5PR01MB2474.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lfwdfv+Gct/M53f5usf8FlL3n7Ii4uYNNyfMTmujDq8wbpFVUIIrETkDLRl1f9h/27pKgK8Bu2ngZGNHTe4UBMOrUAkqHap3V7mbWybTgDbZs7L+a/D2fLXJ51p5rygLd/Zl9vmUiWizJhJRr0CayuQ+mt0H8Am+EOz+twbbP8Wdib24cAX6uMX/e2qaGOiieuqcRbNjX/0C7Q8Tc39oy0Bv3q3HyEIUYCmNfR5bksmEfh4ucMSglLOl52b6qf+mbOxPN8j0E5RU4LFMDAhNntyykXJvGi2LMUiCSlf4GeAcDb26dDf1WH2YifYvhKDps32UK9brkH8Z/w4TAa5FbbftDcoSGkIlT0tQ7plHzUga7zLTI3EHpbZwRCytuT/RIcXX+bEcP1TAxHS2zorusgFwFhhludwUxN2ms0lXFPu5+jDpcadFW/dyEzr379I6CZPGdD3nD1cALO/M0a4jcpQ8fDFNrYWAl4YrGCpt96FM1x7nIkONR1kA8zOTvkUZ6Ws83dTmVvcNyRwgM+2KZ0I5G3qEfYulHbFRgFcs/VhT8fEJvMaasF0htZvEUx97PHfP+8BSqdIU4si4aG2xHgJniJ9FrlQhsXqG8guzyxbrA/I5soSFdIp1tfMzDoWb7KanX6Z32fEpB5NpdCIDEDqh/p2Pq2UXCRyJBGX7CNE3oW1R0D5o2TlBSYY8gG8W9HUUksLwDyAlmOx/ZQh23rzhkrYh+PnVQ6i/zJgKNM4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(39830400003)(366004)(136003)(376002)(346002)(66556008)(8676002)(66476007)(66946007)(31686004)(4326008)(5660300002)(316002)(8936002)(110136005)(54906003)(2906002)(83380400001)(86362001)(508600001)(6486002)(966005)(31696002)(53546011)(52116002)(6512007)(6506007)(36756003)(2616005)(186003)(26005)(38100700002)(38350700002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmoxWlU5RVhidC95Vkt6TWNSakxpV2VtWXhtODlJc2JhRko2MjhmVysrOFNn?=
 =?utf-8?B?NlJMQ2tYRHJqR2VncnN6bWpKQmpUejA3ZHIzRTJVKzZGdEI3K3Jka2FoaGFM?=
 =?utf-8?B?VWgvVzdGc2lEcDg0U2lsVHZIbUpVblFCYW9rckt5d2NiQS85a3UwYXhzWHlx?=
 =?utf-8?B?YS80UlZ6QlRMODNscy91NHRuTDJybDJ1a3hYSjdnZWhlcDRraStYNkpGcGpW?=
 =?utf-8?B?WWJ3SVhzOXRERjBnbFlHVTcxaWVPekE0R1Q1UlV5bFNCa25RMm5FN0JIdEFs?=
 =?utf-8?B?b2Z0bGxZcUhYcDdpbnVrWldERCtSNmhUdFltY0d6SDNySTZkalg4Z0xzcS9P?=
 =?utf-8?B?OUlUMi8zSFN6MEpQa0pKSzd3UnM1bm05L2lMSE54T2JUbjE4UHltVk9IK2ox?=
 =?utf-8?B?Yzh3QkI0MmxwUlc5NUpPZ1JVbWp4cThRSm9SVHZLUkU3QVFZd0JHeHdlRzdS?=
 =?utf-8?B?MndTaFg0bUp2anRKdTQ1OXBIaWdMNVBKNzFwNUd5d0lyeXV4MGdKSjZybi9v?=
 =?utf-8?B?aEwycHZScW42QmlwN1RULzNRZ0RFcElpZnFpTU5May9GY3NuSU5JanZEK0dx?=
 =?utf-8?B?NTBkM0hNZGNlbVgyRFBLbmxBYTJjdDlqbDg5NFFZaU9WUXZxNjErSHg3T2t3?=
 =?utf-8?B?N25wTWJGR1VWM3pmRjZLNUd3TU4zTVQ4clltc0d5S05YQ2NEeXhyNGFxeXVM?=
 =?utf-8?B?bHFXSXBhcWpqMG4rbk1VWjlTd01IVTk3bkxUbUw4M0M5Kzg2dGhnZHZzUi81?=
 =?utf-8?B?aXBiN0pJTjJQWHZOczF2NDNZM2lxekUyeVNZQk9CUjdQZnU1YzhicGlubXhh?=
 =?utf-8?B?aEx3dEVBRm5CdGdickVEZUtBMVl5QVlJZkFHK3FXbXJXNlFqcDA0SFVsOG9v?=
 =?utf-8?B?MFYyR1NtUVU1YktlZ21FTWhnN09iRE80aE4wbHFVU0RKNVBodGc5VWdLamNY?=
 =?utf-8?B?SDhTakQzRFNBbmdxbVdqc2ltRDl3MEhWaTV1bWQ5NlNiSUJDdm15TllVRGlL?=
 =?utf-8?B?aURxWGt3ZHdsZ1RVNVg4bHBUaUxhcitQWFpYeVhLUXJCTlZubU1nU0FiT1d4?=
 =?utf-8?B?UytCRHRSWDJPWkdMYmZiYWI4YWFtRXBEeis2K1N5bjQ0eGVsb0FZbXpVbUhK?=
 =?utf-8?B?QkZjQVF5a0lEVFhaVE5qZkdXaFU4U0d5OWozQm13NE1DL0p2M3FCRk5pZzJ3?=
 =?utf-8?B?UXhka2R4bzJFY3JqRTdDd2JuelB0d1AwYW9lc0VBRmNvMHd1SU55WVlqeHJu?=
 =?utf-8?B?VE8wNjlvZmoxeVZVZ29YU2xsM0xIb1ErdEIraGdBYVhBckgxMHBDbFBGcUdV?=
 =?utf-8?B?aVFXRDhobXdtYTlnd1g0dHpTaGdYbVk5MFRoeE1oa3JQc3hrWUNOMDB6L2Yz?=
 =?utf-8?B?QU1SczRONUhROU54YzJrM01HWC80dmhURW9DN3JhQmN4TkhKNHJuSGpvN3Iy?=
 =?utf-8?B?THkrdW9YQlRwSW50QXlNY3V0MHlBOHJmZCtJN2V4UlNqcmtrWFhrNktuaUd5?=
 =?utf-8?B?SlBCMGl2bkJkbk5iY2RrRGdyeXBaam90WlRlcFdBaFFoWlh6M1dVc21GTSty?=
 =?utf-8?B?a2F3UnRmMFVXeDNLK0VrU0tOWEpZWlUwSmlFZWFkTkk2bndJZVBOaUMwcUZH?=
 =?utf-8?B?bWdVZWNzV1VJUXpTUytjRHpFL01mczVZT0Z2TGYwNUpQbTZUekN1YTlEbmJW?=
 =?utf-8?B?UnlhVE93eFhjQVkyTHFvYkNFQVJGR3pMd0xSM2JpV0hGc3p4V3JaQmZYTzBU?=
 =?utf-8?B?VHgyVFYzMEUwNWs3b2ROTnpvS1Q1Q0ZYUWxvb2M3UFkyNmZxZVZZRnpLbWdH?=
 =?utf-8?B?K2JkYlI5R3NSZkxXdkVnQUo2ZHpPcnB1M3lyb1pwY1dKKzNJYXo2YU5TOGEz?=
 =?utf-8?B?MkVZOWw5cW9talQ5TWlvQzJYbTE1TktHd3gxM3BSZFA3NlF0Z2cxOWJ2ZHRt?=
 =?utf-8?Q?QwiqCLUTjUokbJQndApXNmp2Oacw9Nxw?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 141ff1a9-3087-4dd4-c6b0-08da0a134e12
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2022 01:45:25.8574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ql5O4hB1zSG4yA2SMlzch57tYGrhkB7Xm9LqwEpwf8Xemc4uw1aYO9j99fe878Z2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR01MB2474
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 3/19/2022 9:22 PM, Namjae Jeon wrote:
> 2022-03-20 3:34 GMT+09:00, Steve French <smfrench@gmail.com>:
>> They probably should be always 'u64' everywhere (not le64) and change
>> the code back in fs/smbfs_common/smb2pdu.h (was this due to ksmbd
>> using the file and converting these fields in fs/smbfs_common) rather
>> than the ones you changed
> I don't understand why only FileId fields should be declared as u64 not le64.

Because they're opaque to the client.

> It means that FileID doesn't need byteswap in client?

Correct. They are tested only for equality, or are placed in a packet
verbatim and sent back to the server.

> samba seems to
> stores them in little-endian byte order.

Again, unnecessary and dangerous, IMO.

Tom.

> 
> #define SBVAL(p, ofs, v) PUSH_LE_U64(p, ofs, v)
> 
>          SBVAL(outbody.data, 0x40,
>                out_file_id_persistent);          /* file id (persistent) */
>          SBVAL(outbody.data, 0x48,
>                out_file_id_volatile);            /* file id (volatile) */
> 
> Am I missing something ?
>>
>>
>> On Sat, Mar 19, 2022 at 11:01 AM Paulo Alcantara <pc@cjr.nz> wrote:
>>>
>>> Yes, I agreed. Why not simply store them as le64 and avoid the
>>> byteswapping altogether?
>>>
>>> On 19 March 2022 09:06:55 GMT-03:00, Tom Talpey <tom@talpey.com> wrote:
>>>>
>>>>
>>>> On 3/19/2022 12:23 AM, Steve French wrote:
>>>>>
>>>>> Any comments on Paulo's patch? It fixes an endian conversion problem
>>>>> that can affect file ids used on big endian archs.  I will add cc:
>>>>> stable
>>>>>
>>>>> https://git.cjr.nz/linux.git/commit/?h=cifs-bad-fid-fixes&id=a857bb6b15646a7946fafb281878ddf498107dc3
>>>>
>>>>
>>>> It seems a bad idea to be storing opaque fields in le64 integers, then
>>>> byteswapping them when they go back on the wire. Wouldn't it be better
>>>> to make them u8[8] arrays and just use memcpy/memcmp?
>>>>
>>>> Tom.
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
>>
> 
