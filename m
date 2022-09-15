Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37D1BC6FA86
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Sep 2022 18:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbiIOSZo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Sep 2022 14:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiIOSZm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Sep 2022 14:25:42 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2055.outbound.protection.outlook.com [40.107.102.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06F258500
        for <linux-cifs@vger.kernel.org>; Thu, 15 Sep 2022 11:25:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WWSkmvly+WQHbBOC2h6oDFMY7fJ61OpNwtjz1KrSrf115R1ExVggqnWocXFqpNWLaBXH+Ci93QUuKNzA4WPysspR3gzxQ/lPr65f1u5Y9x8xbDrqD+hL4w4E6U2ytgcXQ+NHjMNVa6Mnt56C9SB9u32nvGuhZPb9LaQdyhWE5Ix9dYbyFcntN64CJm6uA/p4FWwn9E9WOMGXOg1qbxNnGQYRRUoV8bai3GPvon+IxiIzMZnNwdbOTmLnA+8NC8zZ0xqYWCLLBKnpuW+K/VWBJmBdAcXriInVe5eyFrxgX/Fa2GQC0XYJhLO/SIi6ggnZdg8SBbLAU3/PewCeIIQpeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qzCs1ZOAc2EDFHCkxIgGVO2UV3bzLduVeo+RqiyzKcE=;
 b=TiAo8OQTNSrz66CC2gwgthI7RHb5hDoZdhCKeZd2q/nK0pB6cbpdsmx1yblG8o/tgOorI/pU6Kkjy7OJGzzd0Zixc+7YdZuGw+NycJ/+7LtxnI7JP3xd6ZrNPC6f/+zthmcMSBrq0q/OW/CTocF6j4CgX8junvE0ZC7e1CHg2hwfU05SFZteXex9dmwGuH9DfGSfZw29cx9ScNcdIv+3fqAvEir/G6VZiEzkmSPvbUJstV86kmubdqczkUaJ1xm/rgLJvlgZ9MnCOvBEVa8Xy+pHHIMQucig6sHQEirL62w/ZbMWId8OdBBWYfCR2jXOz8rg/f7EKtiFiJdfyvXUKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM6PR01MB5609.prod.exchangelabs.com (2603:10b6:5:157::25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.22; Thu, 15 Sep 2022 18:25:38 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::4dc8:c035:7271:4df8]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::4dc8:c035:7271:4df8%4]) with mapi id 15.20.5612.023; Thu, 15 Sep 2022
 18:25:38 +0000
Message-ID: <a4f7d60f-c5e6-8961-aabb-9148a5324364@talpey.com>
Date:   Thu, 15 Sep 2022 11:25:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v3] ksmbd: update documentation
Content-Language: en-US
To:     =?UTF-8?Q?Atte_Heikkil=c3=a4?= <atteh.mailbox@gmail.com>
Cc:     linkinjeon@kernel.org, linux-cifs@vger.kernel.org,
        senozhatsky@chromium.org, smfrench@gmail.com
References: <388d1257-419e-f0c8-348f-587f5c0a51ee@talpey.com>
 <20220914110918.5720-1-atteh.mailbox@gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220914110918.5720-1-atteh.mailbox@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:a03:217::15) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|DM6PR01MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a7ca44f-b81f-47c5-49cc-08da9747b05c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x+wr5ZaKbEHCpVLbeh5x1UZzr2Z3h8nWIBG7prSyh9CmLNEM/gwuUxJH5RRDue5zntB+wVxyEk5abGhVwhWWT2HiqJ2XsoyR+b4JUdpMsjRTJDQogf3vMZaVxHJAtYyHGty6f5vCH2J7ZwmuHMWR+GTuolMTaDzuQjzdpn4K9XM/v5dg5/eqIMZZGwDpKs8FQbO3lHwjB6PhTR3n92tbDrV5+qLsKUJcdZ5YF0YRnixyEKRoqattw75KEBqqq/IGyXWUoV2EWbUMQJYFPYbq4jL+05VzspDc04YnA517xXocCJ/h0ERxMF5se0yq9ihDNAd6TQELOgtcCXLV03lWsatrQaVIiaYpRrc7aN6Ia1MCKAnvLOElZ12UNZBVinxl/ZGa9kCbAq87ld/sIerN7/If4GLpTx5VR7LHg+hh2ZngrdIf0Sjjkg9hlmC521nP+2oAhU4WHY68abZZaiBnJlEO/9dnrl6bxvRx+4W6xXaypiYGcDKDp5kRIbDIdLHEPSKcLLDq9dwgfgqNyLEXGBqpfIergtp4p7mg2BfhDk980M9ba0rfSdb/CM38WZ8KVtBnWIIDc7Fhxwwwo38akN/OLt+FoSt68HVvPSMSS7KILBs5kpjn4XDb0e+EjZU0rx5GVuyQD8QRiB8c6+k++ZRvapolrobXqC1OYNexklrZfOuxGEHkc/Rr9zC2N81PQNIpCNq4Uhb2f2cBobVmAbzwltWaVO/0MheOZgIdU0LPXRKlUUlReNuAFGqCFsVSDE5Jf93b425Nt5s5MULxT0c8FgOqZNS6J1o+mnOqoyI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(396003)(346002)(39830400003)(451199015)(6512007)(8936002)(2616005)(26005)(38350700002)(6506007)(66476007)(38100700002)(5660300002)(66556008)(186003)(4326008)(8676002)(41300700001)(86362001)(36756003)(31696002)(66946007)(52116002)(53546011)(316002)(2906002)(31686004)(6916009)(6486002)(478600001)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzNwK2xqeEplNDVZRmhESDNUbmdHcFFqYm1mcDBPRlpza0F2MWpYTVBLRnhE?=
 =?utf-8?B?QnpHL0xzWk5Sb29CM0NRQ3NYM1JyWDhQTlUwQXp5b3Qyc1JjU1c4NWhHQlgr?=
 =?utf-8?B?dUo4ZThxL3ZGNlJUUkQxQkpKcnFBUTEyVTBoaSs4OElXQnhhdXI5aGJoTURV?=
 =?utf-8?B?OUt1dXhORnJxN2paeGc3L0k5cUREYXJmcnFWWmYvSnNrOXROOGp0MXNmZzJX?=
 =?utf-8?B?d2dhWXpQdVNhdEd6Tnl0MGpLSVBveFl4UlhLTndXek9EanpZNUQ0eEZRSDNj?=
 =?utf-8?B?MEtPalJhZ0N3dXZIMWdSbHlaL3ZlVUdzMmZxbkoxUzZNT2pGQ29sL2F2VlRr?=
 =?utf-8?B?bnF6cGhsT2RIZTFaZnpET0hPeGFMVExKVXNoa2ROUGdWNVNRU1pZa2xUQnl0?=
 =?utf-8?B?ckxvYTJMWm5RMjh4cFF6OXo2TXFiN3lhUWVXQVRwRUVYQ21ZbWp0OGw2Vkhp?=
 =?utf-8?B?dXpFaURPdnVxckJibXZPWlRsMGN1ZHFjM0JJNEVnNmUxMktlVUdSeENub0c1?=
 =?utf-8?B?d2NxU1dqOWJWRjBPKzdjWEpCc052QlhxZ1kzd3B4R3owL1lQZFBDR05QKy9i?=
 =?utf-8?B?bVR0QTR5alJ6b00xdnc3a0I5Mmpsbi9aN21XL29yOTQxWGE0dXFvMkVuZko3?=
 =?utf-8?B?R3RZWG90L2kwTG1aZE1SWHBVckxaZWV0SExtVWg1OG8xR1RtdThqZHdoQW10?=
 =?utf-8?B?NHFLdHBjeHNFSzlUUEcyOFpLMWlUdkttZzYxbWFaMGhrSFplMnN6cTM2NDVB?=
 =?utf-8?B?TDRZNXVRcWF3OFNrekVXN05KdGZVMUhJYnBod0d4eiszdWQvbnRkNHYvMGxl?=
 =?utf-8?B?TlU4YTFoQkF2TVl2cGRURmQ0bzhHUGNBanJPMEd2RURSZlhVMTBtMzhLajJa?=
 =?utf-8?B?dDVEdjFiK3ZWTHhUTTV1M2x2MkRWK3lpYlJIWWd4aHV6bEtEY29DUXE1LzFY?=
 =?utf-8?B?bVlwT1I2RFVUTThudFErWWtiMGVGMldrd3hwcDVRTXFEN0FkRTVGY2FINnVu?=
 =?utf-8?B?NTN0OG5ab2YwbTFjWVR6Q1dkcm1rNGE1YlFQQUdYek1VTE03RC9HWVVxeEVh?=
 =?utf-8?B?Q000M0h4U0J4YjBCaC9WaHRYVGFBWThwMTF6WWhsZ29mK2tOQTE1T2h2Zm1B?=
 =?utf-8?B?ZUpvSW5iZGpoeUdvME9sRnA5Z3pmazJEWGF0eTBleUpZejFkeG51TisyTzVy?=
 =?utf-8?B?RXBzQzN2V0p5YXlsTFNlUG5oZHQ5MFIxS3ZodzlZT3c1SnlQayt4akhqZm81?=
 =?utf-8?B?dUdhbkYyck01V2VmSmxTYkJBYkxmWHdmQXh0c21RZ3lzQW1kK3ZXRVVNVjVN?=
 =?utf-8?B?MlJOdzJwWGRQZmVicU85c0E1NDNSUnZwdHFuZnY2NFRIZlUzSEdHYlVtVUlL?=
 =?utf-8?B?c1VLYTIza3RvQ1NpOW5oUVNFSHJkSk1qZ2tNY3BKZnJBWGg3d1NodWxrZ2dh?=
 =?utf-8?B?Z1gzQUpaN0UvejV1UFZENUxmWkp4Q3J2YnA0MW0zejlDVG5tMnlYeGxMbHNX?=
 =?utf-8?B?NFNUVURDbWsvTlFWVk5BUWVyNVRRUnJNb01wNlNDZ1B2WElFbThDVXowcEFS?=
 =?utf-8?B?QW9RZ2N4RWJhelRWT0tyVFJwYUdVa1huU3hDR1hOOE85WVdFTmQyN09QTmtT?=
 =?utf-8?B?b1Byd1dEV0JybnVsbklTa3FsamNVaHh6Wm5QTDJnV3hxWW5nTGZuaytEdXZw?=
 =?utf-8?B?Q3BnS0p3WnNnZ1ZQeGg1Q3BDemNCeDdxWnc4Ry9oNVpIcFE2bFplejRmUzRS?=
 =?utf-8?B?K1gydWtTeXMyR0Y5MVJVeFQ2QWE5MExBdHlLTHRoZUNSK2EwMmR4b0FaOFdH?=
 =?utf-8?B?RVR1OEJuYVhHSG9YVkpwbXN3TkRTd1puMW5hRnN2dzdQZEdpU1NOR0dwSWM1?=
 =?utf-8?B?ZXE3ZnIvc0VkWXZKaHcyNWVkVlBxaVVXUzFrMjBiTVpWOFhhbG1vbXVZbWFW?=
 =?utf-8?B?c1UxOFlaZEpZYWVLSk85RWV2eGI5N2JrL3hFSWI4OGpXVEZBb1gxc0dkVGw0?=
 =?utf-8?B?Wm5CNnFzdXI4SThhcHVYKzVPWXhzWnNQTDdSS1huL3F4MGpOOEVEWTRkK2ha?=
 =?utf-8?B?MTJhMmZiaE9zcllsVS9ienpDa0k3Vmd6S1RJampVTlFXVGROb3dhaFMwSzlU?=
 =?utf-8?Q?s1tk=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a7ca44f-b81f-47c5-49cc-08da9747b05c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 18:25:38.6000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pwnAqyZaLNW9y+KUOeqmtk5YoZcHSe25YjLUqTeFpGC99hslkgkPv98bs6ISPQKS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB5609
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/14/2022 4:09 AM, Atte Heikkilä wrote:
> On Tue, 13 Sep 2022 12:02:47 -0700, Tom Talpey wrote:
>> On 9/12/2022 4:54 PM, Namjae Jeon wrote:
>>> 2022-09-13 8:38 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>>>
>>>> I missed this in the v2 match - are you intentionally moving the
>>>> ksmbd.conf file to /usr/local/etc? That seems a very mysterious
>>>> location. Nothing on my vanilla installed system places anything
>>>> in there.
>>> To avoid conflicts with the existing distribution package, the default
>>> location as far as I know is /usr/local/etc. And it can be changed
>>> with --sysconfdir. It is same with samba.
>>
>> I totally disagree with this. The kernel server is part of, well,
>> the kernel, and loading the kernel should not depend on a path like
>> /usr/local/etc.
> 
> I really don't understand what this means. The dependency to the
> sysconfdir path isn't ksmbd's, it's ksmbd-tools'.

But ksmbd depends on the ksmbd-tools to provide the configuration
to the kernel module, and to manage the service. So, the user/admin
will view them as one subsystem.

>> Also, nothing I know, including Samba, is deployed
>> with such a directory in my experience. I find smb.conf in /etc/samba.
> 
> Yes, that is because your distribution builds it for you. If you build it
> yourself, and don't want to collide with your distribution's packaged
> version of it, then you choose some prefix other than /usr.

I understand that. My point is that distributions have already
built ksmbd-tools with sysconfdir==/etc, which IMO is appropriate
and correct.

>> Where are the ksmbd.<foo> helpers installed by default? /usr/local/sbin?
>> On my standard Ubuntu install (and presumably Debian?) they are in
>> /sbin.
> 
> Yes, the GNU autoconf default sbindir is /usr/local/sbin since the default
> prefix is /usr/local. It is distinct from the sbindir your distribution's
> packages use. Your /sbin is (likely) a symlink to /usr/sbin and the
> distribution's packages install in the /usr prefix. The /etc sysconfdir
> is associated with the /usr prefix. You can also check what FHS has to
> say about /usr/local if you'd like.
> 
> Namjae's way of running configure is correct. It's either this or colliding
> with file paths used by the packaged ksmbd-tools, which isn't a good idea.

Ok, so if overriding the default sysconfdir builds the manpage
output to follow, we're good here. Out of step, perhaps, but good.

Tom.

> 
>>
>> Tom.
>>
>>>> Also, doesn't this file need to exist before step 2??
>>> Ah, Yes. Will switch them.
>>>
>>> Thanks for your review!
>>>>
>>>> Tom.
>>>>
>>>>
>>>>
>>>
>>
> 
