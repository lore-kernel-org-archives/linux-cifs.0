Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A7F7C54EE9
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Sep 2022 19:03:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbiIMTDw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 15:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbiIMTDC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 15:03:02 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252B3DE5
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 12:02:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UGbKdrM+hoNc1tFYU6VIXdLg1QaXM5WR2QZk1XVu26eKwo4UXNcM+EfKqxK6mngzSeRaxPQVb9PcegoEyV/B+eL9FGf2JQMSamgyxtDGob7te/wJT/VrH/e6vArnAuwhpnickiTTrUWoqK4zOVn/VBN8+DR9W3Pomvr5qf3F2aoGeZ530FIgGDrGyfZAAUMrAi+gcsaEjbKux/kpxRrypu+/rrOADmMWVM63ed2qOaQRi/lpIr53pD0ZMjAbS64wCFet5qvmCyq7rdnFQliQh0EtsoJPc6obFZBc1lQ8Kxe/D44pTOZ9DcXepKQEWinrf6Jz6I1o9dagZ8aW/m9jGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wUo4KyXxg5iYtZN50T2OCaYrFc0bSVr67vDPC1e8iPg=;
 b=DwphQwjPrnUyj2ZQv9yVIqTr40o6ZQH6Iw77jZkN3BJnTeoqYQsXXYYvp5mikiQ3i/iEEr+TepzjKcENNsAN/xm0BQZyztI5lm5heih0a2NyICOE9ooJfkfcHfSlka4WJIdI4fvcPWv3kFc648hsnzEZUvsknaMjeIXnKWewMF8y8ATLdsgk7bOSNpoqOacMSKQCntyg/IGAFgyl+nygZXRcv5JMUtZsIiwOiE+tAvjAOE3D38FaO/vuCx9cmVOMbJ3zYe5bwOG/Vi+Px6iVh/PWMQiOhh5hKij/pOgaMD6y8I2NJD/vgXhi9KhNPJfP2xs/1lmACtew96COahXxNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BN6PR01MB3250.prod.exchangelabs.com (2603:10b6:404:d7::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.22; Tue, 13 Sep 2022 19:02:49 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::6566:9fdc:aac:8b51]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::6566:9fdc:aac:8b51%2]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 19:02:49 +0000
Message-ID: <388d1257-419e-f0c8-348f-587f5c0a51ee@talpey.com>
Date:   Tue, 13 Sep 2022 12:02:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v3] ksmbd: update documentation
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        senozhatsky@chromium.org, atteh.mailbox@gmail.com
References: <20220909092558.9498-1-linkinjeon@kernel.org>
 <20220909092558.9498-2-linkinjeon@kernel.org>
 <a5f680f2-6dc3-1c0b-bfbb-51f740e09109@talpey.com>
 <CAKYAXd_4gpMU_0z9ed7ktP3zQ0doUqsWi1QqiJ_1v6Y25C9MDg@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd_4gpMU_0z9ed7ktP3zQ0doUqsWi1QqiJ_1v6Y25C9MDg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0199.namprd05.prod.outlook.com
 (2603:10b6:a03:330::24) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|BN6PR01MB3250:EE_
X-MS-Office365-Filtering-Correlation-Id: ca014e35-4923-4e47-1cb2-08da95ba8d04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vqc2KVqvSnG3SsJ+1+hhHhTxgowZof8CmB3vlUMG4aKWxLuKqyab5+DLshpnpFKjKazO8GwhhwdpcEwj/G6J42XJwg/DsglH64/KtKbWapUYtiJn05EANaYyGYLy9hFjjqt19VjQgNwAQKI11avruCtyvQSRfuoLqL5XW2CbTJFMOuryMaz8uKhsg6nfrjpq95XFoFEKjVAGBU52I0MK/xp28Nr6A25adeWUJTYs45O1DSY88iPqi05B6LTCGG/wODjSv/UbUU8pEcMxfX3SuNzl8P6gjQLxHHzcFfj31kDhCRCrePWJ8VfOSaRFwwsyyc3fCHovkbKspFxQrxQ3j/+q4k3Tll6VgENej1wLH12miKAbhY1xkey/i1DZs783aPnEHzdhFDjB54X2ORX7KHXSgQ6u7icCWHjNF/K3chadMKTUwzfZSXlE0AHpb138u27EWy0AfCARUl/orQcy04WO7a9O+gMjnsbun0u8/zpxT8uJnCYrioUw7aXVLwTErZbTmOGkZSGF9xZdiVaxeYeJclnOW+TEorZiGY2bDnIcr3jLCh47vrEIeu/HxH7YVY72TGYqv909krq0BIKxXk1LKlVKGxpEqgppd5qbapYkIlhlfpa7mZ1nws3PUfj5tONT3qArx8jz3r3w/a0z4Gy9J9PMjHJghEw7Kl0uAKGxi6OnNZNGVCqEu436Ja3B0xCJabA8twEt6RWNIt1jofZkCARmtLbFulTkwDPoLqYK8ohqKS5bMeoWPvk4WXYRqBYXrFuUI8RVCyG+BgpK/ZqMs+Oxq0zjsnsYpc+tVCk4zQ5rBD+SNswnlycqRGlEvlqJonWx7mBFP0OtsevJiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(346002)(39830400003)(376002)(136003)(451199015)(38350700002)(31696002)(6916009)(966005)(2906002)(66556008)(52116002)(31686004)(5660300002)(86362001)(8676002)(478600001)(66946007)(316002)(26005)(4326008)(6486002)(84970400001)(186003)(8936002)(41300700001)(83380400001)(53546011)(36756003)(38100700002)(15650500001)(66476007)(6512007)(2616005)(6506007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVU5aWR2U2NoYUtvbWRhdTR6THRCNmkzTzNwajhsdFRtK253U0NiaERybDkr?=
 =?utf-8?B?L3NNdHUrVFNFOGZUQkRkd3c4Z1FXM29leU0zbGtBZjJhaGQ0YTFtRHZYcFNE?=
 =?utf-8?B?UFVneDV2SFJUYWtacks0MjUzUE84a0J5MytOZEN5bmZITjlrenBzRUpvakR2?=
 =?utf-8?B?U2JlVEo4cnpDTTFabjZsall6dmJ2M3dTa2FlQzF3MEZ4QjhydFhPUEhxR3FG?=
 =?utf-8?B?dWdyb1JiNyt6ekVUYm9yTVR4RGNiZFlYYjBtMDJlMmVHV0VoMXBHaW91THhN?=
 =?utf-8?B?VDVZVWJQaldtN2NsUXFIdzFad3pzZTdtMkJSV2Z4VkJjZTBlTWpoRVhzOFBx?=
 =?utf-8?B?UVlRNHo4OGlDTDU1RHN2OEowaDdTVktQY0ZnSTlDdXgxaFkxL0sxc1YweVp5?=
 =?utf-8?B?amxBZEs1Z1p6cGVmNGNsUEJqVmdDNGVMUkE3MDg2QmV2M2swM0ZRbUU1Nnd2?=
 =?utf-8?B?NG5YZzhKWFZJVUpab0RLb085V2NKNnVMQ2F4ZzNUc0wvemN3WEVYclNOY09H?=
 =?utf-8?B?b3B0eTUrSWVDQjRCUE8zdnVkenVTQ3B1V0dxSlNzK1o0U3NtamxNTE5BNitU?=
 =?utf-8?B?ZVovdFBYMlRHcWdVZWVsVzg3NDQ2NDBmR0M3c1N5TkxTaWJ1OTVFQjRIZTN5?=
 =?utf-8?B?OWVMYzBNUGxIV0ROZENyQnpFa1FSUFEwMW1xK2JBb3BwMXpVRkhRdWVTcklT?=
 =?utf-8?B?ejdkU1lMa1FCRFU4dnJPQXorclc4T1Y2dWUzL09FK3I2eTZCWlhCVjhxVWEz?=
 =?utf-8?B?YXM3b2NyanMvWE5OMEFIYnpoME9sV1dSYkZkbXdRM2dCa3BacVVidzVjekpQ?=
 =?utf-8?B?ek8xYzA3aHNUQW5iZ0F5bkRRcHRSVTdXRjhqakVsT0J6b3k5bTd5NzN0bjJL?=
 =?utf-8?B?anZ0c2djdHBwNjRHdE8xSUlYTytFdmpwQ0pxSFBQT01PelhGK3dHcXEycTF0?=
 =?utf-8?B?SUVUSDFVWHZGVTJLNEFIOGpKUElkekd4T01WYTNEenJvbjlya3pvcUVFeUpq?=
 =?utf-8?B?Q1dkTzhyNnM1VzZQb3E1cENvOVh3WGl3cFcyN3RIUkhWZVU1RXRZeVQ4Q05t?=
 =?utf-8?B?ZkdjNStaU0t5THZkcTU1U0wrQWhBNjFzZUtsa0JaMFBPc1JGSVVzczlVZ2lP?=
 =?utf-8?B?NzArdmZwK2ZXN1R6VXVPUEU4cnZlQUI0dDRuaHQ0WithbStSZWVKL2k0Tnhz?=
 =?utf-8?B?aVFNbkxEZEt4T2RSVkw3RlM5akdSRHNyNWI2eWRxR2RhamhjQmFvVUlNZGtq?=
 =?utf-8?B?RGsxRENyWkJoeDRTVmNSTlEvRW5Jd2oxS21ibWl4Q25qb2NjNGhhbUkxNzhz?=
 =?utf-8?B?L0hTS2UrMTB5UHBvbGlYK3hBWkJZN21UV2J0MzBva1g3MTRqbkd1V1NhMVo0?=
 =?utf-8?B?WEg2ZnV1NDFQWk1HcU42RUFSaGJxZEpkZmxSWllvL1lOcDk2dEhLRCtydVVS?=
 =?utf-8?B?MU1JQlVPU0RXSHgxZ2k4VzVFNS9Hb29RUTlLYWtxeHAxdE8wbTlQYUpMdG5E?=
 =?utf-8?B?dFRnQmtYcmNFWWdud25RVnl2MjFkNnAvODl0VHBrdzNNQ0pDZ2FIYUhlRnpG?=
 =?utf-8?B?NDZxWXFiZ3hMZUlubktERURLeHpJU2pjSWJYd1p1KzBheDhqRVVaRTkweXYw?=
 =?utf-8?B?cjNPTVJJY3pDME5KblROZkoyL0w2SkRsZFhRckRZRnRQd2owcUx5Q3I5YlQz?=
 =?utf-8?B?Tll5WGFKU2pnQ2NZcFd6MEpUM0EranVRb0hFalVoSCt0TFRza1piQUJWSUcr?=
 =?utf-8?B?ZUs1eU91eGpBaFhoYXpmQ0VmcC8vZEQ4ZnZuelhIc3lvZE1mTG8zMjdvVk9O?=
 =?utf-8?B?eDZPQnh3S3FETUtZTVBaK0diR2xwMGdLdmFLeXZJVmkxMno1ei93SXdodFVR?=
 =?utf-8?B?VndnQ3Q1Q01xVkVWRExwM2JUTFE1UTdvdUJpMTU5NFl0dHNybitnZFZ6UWZk?=
 =?utf-8?B?U0MwYmlsQ05ZejNPcG1HVVhsaHE1dXdVTmYwcDR6bGI0STJiU0NGSkZ1b2xN?=
 =?utf-8?B?cm9XYWYyNEcyOFBnYU9FZnhhMmlwdmhJS2IwdTNSSnpUUnQvVC9pMXdURzhU?=
 =?utf-8?B?QzZtRnZYTU9kTU04aVhKUzFHZVZ3TXBYN0JZRUM4Q0dINXFCU1NPZThEa2xq?=
 =?utf-8?Q?nQRs=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca014e35-4923-4e47-1cb2-08da95ba8d04
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 19:02:49.0377
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D16BxqpO1QAS+w/aXdP0srfOSe5wYT7kD2pdwjwQdiHut6AkMSmdIp+90zokmcQA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR01MB3250
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/12/2022 4:54 PM, Namjae Jeon wrote:
> 2022-09-13 8:38 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> On 9/9/2022 5:25 AM, Namjae Jeon wrote:
>>> configuration.txt in ksmbd-tools moved to ksmbd.conf manpage.
>>> update it and more detailed ksmbd-tools build method.
>>>
>>> Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>> ---
>>>    v3:
>>>      - replace CIFS with SMB3 clients.
>>>      - update ksmbd built-in case.
>>>      - replace smb.conf leftover with ksmbd.conf.
>>>      - use full name of utils in ksmbd-tools instead of <foo>.
>>>      - fix the warnings from make htlmdocs build reported by kernel test
>>>        robot.
>>>    v2:
>>>      - rename smb.conf to ksmbd.conf.
>>>      - add how to set ksmbd module in menuconfig
>>>      - remove --syscondir option for configure, instead change ksmbd
>>>        directory to /usr/local/etc/ksmbd.
>>>      - change the prompt to '$'.
>>>
>>>    Documentation/filesystems/cifs/ksmbd.rst | 40 +++++++++++++++++-------
>>>    1 file changed, 29 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/Documentation/filesystems/cifs/ksmbd.rst
>>> b/Documentation/filesystems/cifs/ksmbd.rst
>>> index 1af600db2e70..4284341c89f3 100644
>>> --- a/Documentation/filesystems/cifs/ksmbd.rst
>>> +++ b/Documentation/filesystems/cifs/ksmbd.rst
>>> @@ -118,26 +118,44 @@ ksmbd/nfsd interoperability    Planned for future.
>>> The features that ksmbd
>>>    How to run
>>>    ==========
>>>
>>> -1. Download ksmbd-tools and compile them.
>>> -	- https://github.com/cifsd-team/ksmbd-tools
>>> +1. Download
>>> ksmbd-tools(https://github.com/cifsd-team/ksmbd-tools/releases) and
>>> +   compile them.
>>> +
>>> +   - Refer
>>> README(https://github.com/cifsd-team/ksmbd-tools/blob/master/README.md)
>>> +     to know how to use ksmbd.mountd/adduser/addshare/control utils
>>> +
>>> +     $ ./autogen.sh
>>> +     $ ./configure --with-rundir=/run
>>> +     $ make && sudo make install
>>>
>>>    2. Create user/password for SMB share.
>>>
>>> -	# mkdir /etc/ksmbd/
>>> -	# ksmbd.adduser -a <Enter USERNAME for SMB share access>
>>> +   - See ksmbd.adduser manpage.
>>> +
>>> +     $ man ksmbd.adduser
>>> +     $ sudo ksmbd.adduser -a <Enter USERNAME for SMB share access>
>>> +
>>> +3. Create /usr/local/etc/ksmbd/ksmbd.conf file, add SMB share in
>>> ksmbd.conf file.
>>
>> I missed this in the v2 match - are you intentionally moving the
>> ksmbd.conf file to /usr/local/etc? That seems a very mysterious
>> location. Nothing on my vanilla installed system places anything
>> in there.
> To avoid conflicts with the existing distribution package, the default
> location as far as I know is /usr/local/etc. And it can be changed
> with --sysconfdir. It is same with samba.

I totally disagree with this. The kernel server is part of, well,
the kernel, and loading the kernel should not depend on a path like
/usr/local/etc. Also, nothing I know, including Samba, is deployed
with such a directory in my experience. I find smb.conf in /etc/samba.

Where are the ksmbd.<foo> helpers installed by default? /usr/local/sbin?
On my standard Ubuntu install (and presumably Debian?) they are in
/sbin.

Tom.

>> Also, doesn't this file need to exist before step 2??
> Ah, Yes. Will switch them.
> 
> Thanks for your review!
>>
>> Tom.
>>
>>
>>> -3. Create /etc/ksmbd/smb.conf file, add SMB share in smb.conf file
>>> -	- Refer smb.conf.example and
>>> -
>>> https://github.com/cifsd-team/ksmbd-tools/blob/master/Documentation/configuration.txt
>>> +   - Refer ksmbd.conf.example in ksmbd-utils, See ksmbd.conf manpage
>>> +     for details to configure shares.
>>>
>>> -4. Insert ksmbd.ko module
>>> +        $ man ksmbd.conf
>>>
>>> -	# insmod ksmbd.ko
>>> +4. Insert ksmbd.ko module after build your kernel. No need to load
>>> module
>>> +   if ksmbd is built into the kernel.
>>> +
>>> +   - Set ksmbd in menuconfig(e.g. $ make menuconfig)
>>> +       [*] Network File Systems  --->
>>> +           <M> SMB3 server support (EXPERIMENTAL)
>>> +
>>> +	$ sudo modprobe ksmbd.ko
>>>
>>>    5. Start ksmbd user space daemon
>>> -	# ksmbd.mountd
>>>
>>> -6. Access share from Windows or Linux using CIFS
>>> +	$ sudo ksmbd.mountd
>>> +
>>> +6. Access share from Windows or Linux SMB3 clients (cifs.ko or smbclient
>>> of samba)
>>>
>>>    Shutdown KSMBD
>>>    ==============
>>
> 
