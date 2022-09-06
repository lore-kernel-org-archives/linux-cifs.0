Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08D9CECAAA1
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Sep 2022 17:21:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbiIFRVO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Sep 2022 13:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234223AbiIFRUy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Sep 2022 13:20:54 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E1752DDF
        for <linux-cifs@vger.kernel.org>; Tue,  6 Sep 2022 10:09:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gpxRfKcJ9WCOTPTjvZyqArWMJmY0ZZaAx42Hv1HtVm9cPJCGSCa63UieXuG4Vy00wTOWD220hsPfmsknMZx82sKVhGkrPecta3L0+N86/m4JJfDbsoTHV5qnp522kRVHXTnvL53KNDIV2o0at9ynyeT+AqBeEgLKCPwlKNp29fN3X8b/OHWOy48iU6b6yCPZbB5G6DxWBKkPMZnaT42MltLUnabPFZfzVnkN/hsgVh1uXP9TQpH0PzqyewD1g46yNCPn3fjSs3Zzxvg7Qvtayc/JuEOhI8PqMn6wQ3+LTGhIhTtWp7qnH1tCV0llUdSPPVKKe3zyvShUWffinqAPJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yixk9JyH2mcGT+AXy97r3Kv/V0QxOjQQxrakhgDlXdQ=;
 b=GLVr0c4A1KRW0L8YgsiAz1OOBW/rlVvD17RbeyXDqItYJ39TP70wmywGEtIO13sKrW2nPg82MzPxh2ep5xIgJuaU3MZwjkqNzQpD6U9yTn4wvYJrTrthoaG/RKLStBqNtWS2jEHlGG4axUX6A2efm6aljCVw7i62rrcMk7DxN4CYU8k26xzqfMOCRqxHCodvTDhTai5MvA+QROUKPEc8VVQ1n2OaZeDQ6IcMAxvW1oChbA6f/bQujv+kZ9bnMVFPaGdS/vqbNlohCabEB0fdls8/oG+WdYUrR7sslaFgPUuqTzVJR/yDvdiHqh5At4r+3zdqrh9HF6vDM+5W07Pqcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 MN2PR01MB5853.prod.exchangelabs.com (2603:10b6:208:192::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.17; Tue, 6 Sep 2022 17:09:41 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b%4]) with mapi id 15.20.5588.018; Tue, 6 Sep 2022
 17:09:41 +0000
Message-ID: <356b6557-fa62-b611-8ef2-df9ca10a28c7@talpey.com>
Date:   Tue, 6 Sep 2022 13:09:39 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v2] ksmbd: update documentation
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        atteh.mailbox@gmail.com
References: <20220906015823.12390-1-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220906015823.12390-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR06CA0022.namprd06.prod.outlook.com
 (2603:10b6:208:23d::27) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88f27c63-5a54-42c8-612a-08da902a966c
X-MS-TrafficTypeDiagnostic: MN2PR01MB5853:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H4XasBn3Raa+kVQMbthUpdeeN97yY8dhTm6vPS0BcSOz72DhZY3ip/yRARZh1AGQbiu+LlBgUZCo4LizAmCo8PxdPVoxSBn6HL2A6gTL4xPh5+WtMy6zkHw9RX6Vjw4//y02zf7Zo5uGMGfFDuvhlv/DkQOLTIhweaNozQqMTHio8yXEjiP3gnTZ0JiQrft8n0WnihNwZE8K4GedX6cyMy8i4kZZ+MJRw5hMI5xpg1jWNbi/YJoEHkyGt6MjEb7DijoLYLgmeGW63Tgsa7WiikmAdUI/NZ3v6jn8rW9XSt9slCJJ77KP68IU6E2OP+YUjDA91FZCWUK2I69KMwhSmtCYCemeZjKkM3Xz7Mr96VTLL6OH4afnhy0nqQmU2/Z77k6BDYsR+rUFlDIVtfKAJV2/BuTOBqoF9DrPrRaahIRAU5gGW2CGqU97Xm4i0jmO6Z7Dd3a2O2fTqEgNNZyd5iSs2hcFw/dnyncfimg7kH5DMygdMbmgLbcRzjhqOdct2KDj5bqr4RytkFS3ugFZ8cPChn3WLrkCLV4fVHKTZYw7ixFK2MVCwTw/uxz0oeXIdVwha2v+Gj58BNxncOs/rMkOoEC4DPLD33cw2SdaZ0j2mnFpv3n7Oj9IV99tevSd55DqeA550HIzpIwTrGHZKOrAY6zvSi0JtnyfHwRMpFNOOnOHnlU9yWuzuX83i6PQJijWUjTCykxvJ76FPF2VZv3M/Jhmbt0lHBh+srOIzSyKu3gHY0zd6GM350ftuISxVyvmhrY+ngcbYDvpD5W1FZxuPu8snVLo5QgXZMVou4abNkOcbdY8+UQ41uuiWBsI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(376002)(39830400003)(396003)(136003)(346002)(6506007)(86362001)(6512007)(316002)(966005)(31686004)(6486002)(66556008)(8676002)(66476007)(26005)(31696002)(41300700001)(478600001)(66946007)(38350700002)(38100700002)(2616005)(2906002)(8936002)(83380400001)(186003)(36756003)(53546011)(52116002)(15650500001)(4326008)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MzMxVWEzQVdlZHI2RG1UUkxUbGc5SUhJN0RwSHQyUFRFVTJ4alNVandDVjdj?=
 =?utf-8?B?UUhwUTVKZHg5RXlmeWlUcWgzNytMajJ2VmNuWURPOTRISExpV0NWTHk0cGJQ?=
 =?utf-8?B?Y3FRdGg5NXJSUFZKZTBTU0lVdUxlbE9TM3ZXUzgzeDk5dDJDNHBXYVY5OURX?=
 =?utf-8?B?ZitlNGl0TWMxNVhYZTY2d0NjY0RwMGlFRkJ5REhFK0gxKzBoZCtQQ0k4RjB5?=
 =?utf-8?B?RHJkUDFUNzdzaU9LOWxyRUNiaXBxNVVCYUg3RmZZNTZPZWlTM29IMm51Znc4?=
 =?utf-8?B?RGkvdGR2ZHl3Qnl0R0NKcmgzd2lzTGM3ZW5XQmpwMjJYUWxCRlFVZjBMMnBo?=
 =?utf-8?B?cGpMdjhTelIrSkVHQ0NMRDhjS2lCemxya2xKbEtVU28vRXNCaXpEZEk2OUN1?=
 =?utf-8?B?Tk1NMEpWZkQ0M1dnd3Q0Z0tHWHI0L2JhYkhLMU16WlVXYThnMEZkcEJpYTB0?=
 =?utf-8?B?dnpsSHliT3BVaC90RlFtQ0NXN01CSW5NOC9VS2VPenZZdC91TCtvMDB5UE5P?=
 =?utf-8?B?bW4vVGhUQ091VUJ5RXdYdi8wRVNPeTY5ZEx3STd2ZWs0eUpnNGZsMUZmUEow?=
 =?utf-8?B?enZleC9RNnY4NGNrZUMzLzFWTlRraEptY1A5bHI1N01HNjZHNzRlNEM2Rkk4?=
 =?utf-8?B?OERKWU90YTVXN21yeHF1STExVk45WFI0eVRDSDhBU2M1SjFkK29TbnZ2aGZj?=
 =?utf-8?B?TXFvcy9IMjlCeWNxMUZRdjYva1FKdTQ4cHRzSW5kdXl0Z2hNc0JXOUMrM0hh?=
 =?utf-8?B?Ny96M2daRGY1Z2dHQmw4WDNHcmlFVjVqTnpJUExaczloZUQzeUVxYzZjT3Js?=
 =?utf-8?B?cHB5S0VOdzJabHZNY24vS0o5eno5NmI4bHdpTVRBRnVWdFFtWnVzaEJURlNT?=
 =?utf-8?B?YTV5ZEx5QnVhWE5kS1pFS1ZvT3lkUFdaY1Byd1lHS2E0b2NHZWJ6SUEwZWcv?=
 =?utf-8?B?aWNUWVFyenVNVFhmRHI5R0tPeGR1QlZ0cE1hQVdiU29ibjN0RTJERVZCYWhN?=
 =?utf-8?B?NkVKTUxrd0lUQkdIVkt5b0Y3RlZpNngxSmFBZnpNNVIxMzE4UmpTYUdTZ0M4?=
 =?utf-8?B?ZUJIVFZ4dE41Q0RXYndSeldKR1RWNVhZWTNnNGFJNWMreithK29XMncyVG44?=
 =?utf-8?B?cFFrOStNT2tzZ2pocDdML2NXazFnNGhGNlhzWVNuYmZNRUw2dmd6eTU0L1do?=
 =?utf-8?B?K3JNQ1hDYnZ1enAwakJlN1ppdEcwVlpoZmNLUUpTUGNSSEZaWFFaeXJ3Q3Bk?=
 =?utf-8?B?MHlJWmYwWjl5aHhZOGhXVjRwZ3hZRitvN1JWOE05MTRrUkpwRHdCSUJHRHVO?=
 =?utf-8?B?dTdKZExCb1l5THFvL0VkaUxOaEw0ZHBHc2o4N1VFcm1YbytlcmQ2S0I4T3lD?=
 =?utf-8?B?Vzhra0dpNk9DRDdGL0RPT0FFUlJuRXJwUUw5bHZpM1o5SC94OVRwc1k3SGIw?=
 =?utf-8?B?VXhIRlJKd1JXNTNzZWUwNVAveTdnL2ovVGUrUkUzMnRBY0ZQVXFZUU5IbFp0?=
 =?utf-8?B?ZWhRN0FHYXRRd1dqcU4yZzVyVWRkWUd2TlZRWksydEw4TldQdzh5RnVCbXh1?=
 =?utf-8?B?RlZORmZSU1BWdXVSbG5OOUNlS3FFbzVESkgwL1gzenZ5NkY3UFlQSVNCSzQ2?=
 =?utf-8?B?YytSSXRrUjI4TUI2K3VUZUhjTXVPaWxLbk5zVjN3cG8ycjFTMzkwQ1ZEUmVE?=
 =?utf-8?B?OVZENm41a3Y0bDFUeTJLako3ZTIzaU1WaHlMMWozV1ozYytOaHJ2SzV5MldH?=
 =?utf-8?B?ZnpDdE9pMC9peHRtOElnOHRvTHVvMFBnWXhsNGdTdlQweDA3cldLOXNVZkM1?=
 =?utf-8?B?c3BjZU5oMmluNTZoeG0wYm5LUXNFeFFpSVNQeDlKdHQ1R3U2Um92cytpS08r?=
 =?utf-8?B?d0M4amR5MXIzdkxGTDh2ZEtpbWV6RnliRk5vVlk0YU1RMXZzY0lEVkdhT09j?=
 =?utf-8?B?d1R1WDUyVjBNUDhlYWk3VlVvR1lFYkRVVzB0SmlIaUNpY3Z1SG9LSXlWTXhU?=
 =?utf-8?B?aElPN2R6Zk9GTGZRYnhjeEVTaUduWlZTdWtxY1IweTFYMDI4Y0xIVWlTTkc5?=
 =?utf-8?B?cUpiK3phcGhZazUzUjJrb2RlV3NNVjNpZy9iVGUvSWRrZExOQUdScjEzazVu?=
 =?utf-8?Q?ydSbrHLuyL5A1BpXKUNuzrEtf?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88f27c63-5a54-42c8-612a-08da902a966c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 17:09:41.4463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JAc5wdzqphbrl9FZIal44mW1ZWc5erbi2ayu5TlvtwLYG1qtRJWHAPeLMvVN+Z8b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR01MB5853
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/5/2022 9:58 PM, Namjae Jeon wrote:
> configuration.txt in ksmbd-tools moved to ksmb.conf manpage.
> update it and more detailed ksmbd-tools build method.
> 
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   v2:
>     - rename smb.conf to ksmbd.conf.
>     - add how to set ksmbd module in menuconfig
>     - remove --syscondir option for configure, instead change ksmbd
>       directory to /usr/local/etc/ksmbd.
>     - change the prompt to '$'.
> 
>   Documentation/filesystems/cifs/ksmbd.rst | 32 ++++++++++++++++--------
>   1 file changed, 22 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/filesystems/cifs/ksmbd.rst b/Documentation/filesystems/cifs/ksmbd.rst
> index 1af600db2e70..69d4a4c3313b 100644
> --- a/Documentation/filesystems/cifs/ksmbd.rst
> +++ b/Documentation/filesystems/cifs/ksmbd.rst
> @@ -118,24 +118,36 @@ ksmbd/nfsd interoperability    Planned for future. The features that ksmbd
>   How to run
>   ==========
>   
> -1. Download ksmbd-tools and compile them.
> -	- https://github.com/cifsd-team/ksmbd-tools
> +1. Download ksmbd-tools(https://github.com/cifsd-team/ksmbd-tools/releases) and compile them.
> +   - Refer README(https://github.com/cifsd-team/ksmbd-tools/blob/master/README.md)
> +     to know how to use ksmbd.<foo> utils

I suggest typing out "<foo>" to include mountd, adduser and addshare.

> +
> +     $ ./autogen.sh
> +     $ ./configure --with-rundir=/run
> +     $ make && sudo make install
>   
>   2. Create user/password for SMB share.
> +   - See ksmbd.adduser manpage.
> +
> +     $ man ksmbd.adduser
> +     $ sudo ksmbd.adduser -a <Enter USERNAME for SMB share access>
>   
> -	# mkdir /etc/ksmbd/
> -	# ksmbd.adduser -a <Enter USERNAME for SMB share access>
> +3. Create /usr/local/etc/ksmbd/ksmbd.conf file, add SMB share in smb.conf file.

Typo - "ksmbd.conf" -------------------------------------------------^

Wouldn't the ksmbd.addshare command be a safer way to do this?

> +   - Refer ksmbd.conf.example in ksmbd-utils, See ksmbd.conf manpage
> +     for details to configure shares.

This way is fine too, but as an alternative for power users.

>   
> -3. Create /etc/ksmbd/smb.conf file, add SMB share in smb.conf file
> -	- Refer smb.conf.example and
> -          https://github.com/cifsd-team/ksmbd-tools/blob/master/Documentation/configuration.txt
> +        $ man ksmbd.conf
>   
> -4. Insert ksmbd.ko module
> +4. Insert ksmbd.ko module after build your kernel.

Can't ksmbd be built-in as well?

> +   - Set ksmbd in menuconfig(e.g. $ make menuconfig)
> +       [*] Network File Systems  --->
> +           <M> SMB server support
>   
> -	# insmod ksmbd.ko
> +	$ sudo insmod ksmbd.ko
>   
>   5. Start ksmbd user space daemon
> -	# ksmbd.mountd
> +
> +	$ sudo ksmbd.mountd
>   
>   6. Access share from Windows or Linux using CIFS

"SMB2 or SMB3" ----------------------------------^

Tom.
