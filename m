Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B1C2C6FA83
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Sep 2022 23:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiILXia (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Sep 2022 19:38:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiILXi2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 12 Sep 2022 19:38:28 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2041.outbound.protection.outlook.com [40.107.237.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC691D0D6
        for <linux-cifs@vger.kernel.org>; Mon, 12 Sep 2022 16:38:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TxWczGLyp+dYPxZSpGlc7v4UfvMIU/DaeYXCpjYeyX4Qx5JcNC7olhdBLvNcJKsIlF2dLsykDLiEiHd3Z6NP2XvOPdfpn2YryRfRCShkHcwLCV5oOMt9fagCdTSaOVUhqkdCG1mfdtJ/Qvv4AEJrqmsk94VA+dqeBQ5JIQfnq2Ev07IZGnCg7YuopnyS86DZLd4Gju1Z4G/+di0+5VCqwsvuocNPLZrBGH4JutyW91HyNb7BqF+5E8E52DNg/pJWK3MqRGtOrKKC0lPT8aexvL4x39sMHaSwil0UrujqPE8b/kIud+rmDxRJUhmjT4madcw1wZauBMmA1F2vy5FHgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ywoD8tClzZRvWBM7mjxcT3NQGMldLCf/zqIQPf0Tf0=;
 b=dxqXcjqdgCRS7ir0LyoXGc4QqxgSCfzxKhaxuynJWKjDw9oCOAzc2SRbq5q8snmQXuKswTUwyWvGCQrZ+0oSN7h2DU+6/5IJUVkc0fSAsR0n22WGUarSWEc1ZkyjDdqCP1LrGm4y61tQxFTd1slJPZ9DNU6xTyTRASvgPC8JUhc2pl1P1bUASEP41TcMW5cQGzlEcm9gH5/FJgfZ+IDcpkouFxY9rWYahSVX0owxlnfPuPfLjJ90+Ab8FWNiogTCw3JsKMHYuBswce8d4XDgUwtyuy7YMG+KHL7rWSQSY2lGWcIaD+e2PUQmhhieX8oBRUGqFTtAshsJBxEQpdm0AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 CY4PR01MB2440.prod.exchangelabs.com (2603:10b6:903:69::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.22; Mon, 12 Sep 2022 23:38:25 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::6566:9fdc:aac:8b51]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::6566:9fdc:aac:8b51%2]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 23:38:25 +0000
Message-ID: <a5f680f2-6dc3-1c0b-bfbb-51f740e09109@talpey.com>
Date:   Mon, 12 Sep 2022 16:38:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH v3] ksmbd: update documentation
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org,
        atteh.mailbox@gmail.com
References: <20220909092558.9498-1-linkinjeon@kernel.org>
 <20220909092558.9498-2-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220909092558.9498-2-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0380.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::25) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|CY4PR01MB2440:EE_
X-MS-Office365-Filtering-Correlation-Id: b4a558d1-890c-48d2-29c2-08da9517e2ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LVSMQVAubE/tRGNB3OIopkPFynM5iPENHngDB2iso9aIGu2RHYVp9BrhrF9BC1hjIN/rNKaQnL5hG1a0c586mOQgb2zTeUT2OvNk858cEOZszg9mUc+TwKoFMxX7g4coTuxg9v0z5/iIbXwOzxUbFZ5MYzCYyVUw1wsWKO+xxrKcAGhMc0LYmFNkZpzxVUGvj/djgyZxab16cFfwVUv9h+stbVrfCinib+9U6MNd3ekOERE2Ws8kRr/qgB7FG0eL6pzOfEucXyoMqM9kYSn3q4i4ylEdn/90BfH8iTPzUMUex9l4mZbmqtBeOAxsGHiVIE518hRtrG7HJadWkwJInCTRYgWnjBOepGXwdri62BjRQJyV2yn6glbj2qRpTv6sRviHoTQTQSJxGnKlVDOkMzG8GPfzvWexIt34JIeD6jZA29ufy2dwq2OHbOC97VhGcf5Z/in+2DNJi9kqdS6VTsusX3kv/75ar9cfFE6j9ew4siurK1wJYRs1KHH5YHRBbt5FTxlH9+YBHDEOeVyN/YZ/j7JSUrAVHY4NCKDRk+UjrZalNdfSIcNA6/pYdIjn5/Xtv3jSj6E3WBHTNbpEJ5AKYu4/b4/MaE1eR9U45ItxzYBkjrohS7lhwqRqZyDR6fLAmYbHI2eAQ6LPQSrtFQbGSJ7KN0l76Zqtb5lfTyhlnvL3Y46fStNN0SFBl4YMnPTj/8VBpJ3a3SJeMM61Nbik+kaeVzl2VlGftoAi0eYe2l/vmYSGMd0YKPC1fCOcvlGMpiLCmvgIR24a02QXzWpwFpZbGVlRovCGxxWLz166tSxxwJIGk8bKYzN2PICV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39830400003)(346002)(396003)(136003)(376002)(451199015)(6512007)(8676002)(26005)(15650500001)(8936002)(478600001)(52116002)(5660300002)(66476007)(86362001)(66946007)(38100700002)(2616005)(6666004)(6486002)(966005)(186003)(41300700001)(31686004)(6506007)(83380400001)(36756003)(2906002)(53546011)(31696002)(38350700002)(84970400001)(4326008)(66556008)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnZJRWtrRUVXNTF6TmE4K1hkcEUrSno1Z2o4QnlIUVNjczZnVkFLWWl5SnRK?=
 =?utf-8?B?dzFFcXNjTFc3RW9NdnR3MW0yQWFIYW5GSERnMm5ZWWZXM1NKblJYaFBBNW1B?=
 =?utf-8?B?dUh3UjVPdnVMVWUzRmdNMERkbUtJSmpxNm1kYUJQcDgwMDdSQkJ2andHZ2F5?=
 =?utf-8?B?OGRYTUcwRDRFRFgzdlRjWTZxL3RqeEFRRFlKWGNjdHNmVDV3MzhCZUs1Z1VG?=
 =?utf-8?B?NXd6aXppNG4wK1FOQ1h1VWNUYm92SDQ2NGp3QmlJdHl6UXhSeUZzNmhRYVoz?=
 =?utf-8?B?OXdjemwvS09jMXlVcmJFVkNQaWtlN1lRdXdvUFQvam1QZDM0UlFBUUxZSW1F?=
 =?utf-8?B?ejk5UWFVQnQyNmpmRWxjTklqWkVqdUpZejRIeWJ2cCs4TTcyUTYza2RzUUVW?=
 =?utf-8?B?bWtXV3VNbDQ0bDBpR000U0x0ZDlRNVJEbUQ1QlRySzAvamZ4bmZsOW1iMW1C?=
 =?utf-8?B?SklFNklYb0lWcUZQZUcwY2xUOEkyU2NtUkhPM05ZTk00eGdLV0VVZS9IQkJt?=
 =?utf-8?B?QjY4VUJvMGFrekpuZmc0ZTF3MlJ3ck1vYWVZY1JhMS9LUitrOUpKSklWYVM0?=
 =?utf-8?B?TVVJYUVoeGlpK2lnRmV2YjA4bjhLSHV4WVlYMW5FN1pXQ1BzVzIzK3JhOG02?=
 =?utf-8?B?VUR2OVlBWUlvRFJIakcvbTNCOEFTL2VJaVU3NEFEME45bG50VzNteTlUcUc4?=
 =?utf-8?B?WktRWkFJeW5UM2NWNFRham1RaHF5K01NNmZrSmQ5dGVOYVdMMXhvdjd4S3g5?=
 =?utf-8?B?QW9CUE1ZZDR0TWdZWWR1K0pFK2ZQNDNqL1BFTzhQUFVOY3NIclFKeDJPdkY5?=
 =?utf-8?B?QnEvWVV2RFRyNTBUZjBDNG96U1Bwcm12UEdPWnJFVWtLaWp3S2g4RmxLV3BO?=
 =?utf-8?B?RTJydERtSWZMSlZFanFaT1U4dzJXWndEYTlUenNZbDVoK2lwY0dSaTB6KzBt?=
 =?utf-8?B?VjgySUhKTktZUGowTmxHM2F2Vk9OUnZmMTdBdi9vdE83VkswM2IxVHFhMjVy?=
 =?utf-8?B?eHhjSXlNY1UvRmlMVlh0MVdLT3NPVEhsLzloK0VsMC9IVmJ3VnZsOE1odlVh?=
 =?utf-8?B?aXRQbjR5YlMvRGRaUWh4bEt3QzlNdUdhajc5QURxemxaWkxacGxLN2RWN2Nr?=
 =?utf-8?B?MzNnd2FLVlJPeW1GLzJJbnpQVzczdFl2bXBTbHZZMWR1RTJNMzVDcHN0cnVx?=
 =?utf-8?B?R2Z2aDhZT3lGZ2ZGM2lucmZHQmQ4Q1JCc2lwTi90Y28xelpaS0lTczNKN1gv?=
 =?utf-8?B?eWc2UHRiV0k1cC8xTTc4bEJpc1JVa2FBR3B3blR2QzhNdTFzdGZmQi9YU0Nt?=
 =?utf-8?B?N1MwYUdIemMyM2tjZXpoay9LQkkwOTRublMxeXVScHpJSTA3Rm02MUtwamFU?=
 =?utf-8?B?M04xUmZ4Ly91NWtlTXVMQlVCZ0pEMUNPWVFJZGprdzRmK2lFdnhvMU42c2hw?=
 =?utf-8?B?eU55NUNSS2Z0N3BjK285Sk9TTCtTT1p3ZUw4dllJcEQ3RGFBSVY2ZklFUlZR?=
 =?utf-8?B?Ykp3akRlU0lJMWpldzlYSjE2QzlBZElTeVN6OGFpMjloR21zQ29LQnhxRTly?=
 =?utf-8?B?RzNUZlNIdWUrYi91RXlVaFFPSUJpMkQ4NDlIU2R3M1ArT0paTDYyVzJpVm9G?=
 =?utf-8?B?NXM3NzZJNHdrbzlxRGVVSVNveHN1bnM5NjEwQkQyQTVqQm9EeGNoNjdpZ0xs?=
 =?utf-8?B?YjQ2SkxZdW1BSDRYb3pnWnV4MlA5ek00MUlqa3VsUmE4R3JzMXdrbzQvSzY4?=
 =?utf-8?B?ZEloTmpUZ255aU5ZUkZCTHpiS2tEUElyMWd1UStDOHFwRHFXejRuRTg2S2w3?=
 =?utf-8?B?dk5zZERhcVRZeEM4ZDRnQmJZNjJCZWVDcng0Tm1jSkVzR1BWSlpZblV1N3gx?=
 =?utf-8?B?UnZWbnk3NzNqMkZTZGlYWGVRMkFZVW1NOG5kOE5hM1hnQVIveldQWnBYenZh?=
 =?utf-8?B?UzRyem9HQVEwaHdNQTYwbmhWZnVjR1lwZFhCUENrTWhuZzdUVjQzODQ3REt0?=
 =?utf-8?B?NjRpbmd0SXcrTVlaaEpMTUpmK01xM1hWYk1XQVhQTTBTaURGWFdXbjFZbE5w?=
 =?utf-8?B?c21VcG03enJVOU1yd0Y3OWs0SWc5SnRFSFFLdWpkM3IrWHBER2RmUEpMZHhJ?=
 =?utf-8?Q?Pbrg=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4a558d1-890c-48d2-29c2-08da9517e2ce
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 23:38:24.9857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +7QdeDIhy/RUkKdmo8VPTsrZboO9lF1VzotpInoxNxQkdx2pBM4j44C2FCx5DUZY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR01MB2440
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/9/2022 5:25 AM, Namjae Jeon wrote:
> configuration.txt in ksmbd-tools moved to ksmbd.conf manpage.
> update it and more detailed ksmbd-tools build method.
> 
> Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   v3:
>     - replace CIFS with SMB3 clients.
>     - update ksmbd built-in case.
>     - replace smb.conf leftover with ksmbd.conf.
>     - use full name of utils in ksmbd-tools instead of <foo>.
>     - fix the warnings from make htlmdocs build reported by kernel test
>       robot.
>   v2:
>     - rename smb.conf to ksmbd.conf.
>     - add how to set ksmbd module in menuconfig
>     - remove --syscondir option for configure, instead change ksmbd
>       directory to /usr/local/etc/ksmbd.
>     - change the prompt to '$'.
> 
>   Documentation/filesystems/cifs/ksmbd.rst | 40 +++++++++++++++++-------
>   1 file changed, 29 insertions(+), 11 deletions(-)
> 
> diff --git a/Documentation/filesystems/cifs/ksmbd.rst b/Documentation/filesystems/cifs/ksmbd.rst
> index 1af600db2e70..4284341c89f3 100644
> --- a/Documentation/filesystems/cifs/ksmbd.rst
> +++ b/Documentation/filesystems/cifs/ksmbd.rst
> @@ -118,26 +118,44 @@ ksmbd/nfsd interoperability    Planned for future. The features that ksmbd
>   How to run
>   ==========
>   
> -1. Download ksmbd-tools and compile them.
> -	- https://github.com/cifsd-team/ksmbd-tools
> +1. Download ksmbd-tools(https://github.com/cifsd-team/ksmbd-tools/releases) and
> +   compile them.
> +
> +   - Refer README(https://github.com/cifsd-team/ksmbd-tools/blob/master/README.md)
> +     to know how to use ksmbd.mountd/adduser/addshare/control utils
> +
> +     $ ./autogen.sh
> +     $ ./configure --with-rundir=/run
> +     $ make && sudo make install
>   
>   2. Create user/password for SMB share.
>   
> -	# mkdir /etc/ksmbd/
> -	# ksmbd.adduser -a <Enter USERNAME for SMB share access>
> +   - See ksmbd.adduser manpage.
> +
> +     $ man ksmbd.adduser
> +     $ sudo ksmbd.adduser -a <Enter USERNAME for SMB share access>
> +
> +3. Create /usr/local/etc/ksmbd/ksmbd.conf file, add SMB share in ksmbd.conf file.

I missed this in the v2 match - are you intentionally moving the
ksmbd.conf file to /usr/local/etc? That seems a very mysterious
location. Nothing on my vanilla installed system places anything
in there.

Also, doesn't this file need to exist before step 2??

Tom.


> -3. Create /etc/ksmbd/smb.conf file, add SMB share in smb.conf file
> -	- Refer smb.conf.example and
> -          https://github.com/cifsd-team/ksmbd-tools/blob/master/Documentation/configuration.txt
> +   - Refer ksmbd.conf.example in ksmbd-utils, See ksmbd.conf manpage
> +     for details to configure shares.
>   
> -4. Insert ksmbd.ko module
> +        $ man ksmbd.conf
>   
> -	# insmod ksmbd.ko
> +4. Insert ksmbd.ko module after build your kernel. No need to load module
> +   if ksmbd is built into the kernel.
> +
> +   - Set ksmbd in menuconfig(e.g. $ make menuconfig)
> +       [*] Network File Systems  --->
> +           <M> SMB3 server support (EXPERIMENTAL)
> +
> +	$ sudo modprobe ksmbd.ko
>   
>   5. Start ksmbd user space daemon
> -	# ksmbd.mountd
>   
> -6. Access share from Windows or Linux using CIFS
> +	$ sudo ksmbd.mountd
> +
> +6. Access share from Windows or Linux SMB3 clients (cifs.ko or smbclient of samba)
>   
>   Shutdown KSMBD
>   ==============
