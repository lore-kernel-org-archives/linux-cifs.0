Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E5AC32771
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Sep 2022 18:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiIOS3B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Sep 2022 14:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiIOS3A (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Sep 2022 14:29:00 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2063.outbound.protection.outlook.com [40.107.102.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D065A642E0
        for <linux-cifs@vger.kernel.org>; Thu, 15 Sep 2022 11:28:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/3Pg4UAtN7SShkjSHtoEDQIkTXNf3rNwcR4I6sQmnQnopgJrRKLUzKC55YAsPRLlgTQt88wJWqK8o9F5f0zGzuuR829wJ+cST9j+Q5MW9dXbGv9Q+fLt20QHI4uGsfXNnJowStG7DUrg+K9D0MqeyRSlDNMtddxtA+38/LkFd9XZKt29n7gZiHCRteREsNY7gSLGTAmIkJrLa5WVrn7eQr+Wwd9rnuCz3YtC9Wy9+WMErxo1FvG2coNVZjZUS1eXhmaUQ3sydjSatdt96GTS2WSyqbNBHXpAzc4to+ZPWuK60st5Y8ZDrJcPWEttLGcO2Es6TLzbIPIJ7/xAzhU7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fHIQtQf/s5eDypK0FYJq9Qq7ekkf2IBRCRqu1aI/D4Q=;
 b=m4GKszYqZ9QkDpjIeEuMklzTn6C8g9/NGtBUL2sJJxMUiAYxY1Z/JHIjwfBxZEnZNSpA3PXrTVI4X23DgoLb1deGI8C/wk31hzmAn1xjDvXzL5aaCncTDbMxhJdWG8T6lQllpxG/OyBBuygiIwbkOleMiaLvKpqhyNwDxv1SS4vfd3WvfOR94Ca+ZoqrxED34WLxJ6SRBAEGvJRPHIZsYCTa0SYbJH+DbzSF0Bu4a4i3stNdIpZjfM7iCi7z5hlj65P7kN7APwoBkV5VqW8+aS4BrXTMvWR9kiC0p1xjt5rAgVxhyWCkGCopoPPV5fdTrmGBVbX1z4v/BuzJuTksQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM6PR01MB5609.prod.exchangelabs.com (2603:10b6:5:157::25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5612.22; Thu, 15 Sep 2022 18:28:56 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::4dc8:c035:7271:4df8]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::4dc8:c035:7271:4df8%4]) with mapi id 15.20.5612.023; Thu, 15 Sep 2022
 18:28:56 +0000
Message-ID: <deaed042-1d26-c3f8-3ae7-5cb1da9f2a64@talpey.com>
Date:   Thu, 15 Sep 2022 11:28:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v4] ksmbd: update documentation
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org,
        atteh.mailbox@gmail.com
References: <20220915140700.7953-1-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220915140700.7953-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0140.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::25) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|DM6PR01MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: d003299b-af3b-4c27-27f6-08da9748262f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xNl4wF2zhDklazkTpxEKHcnvt2Co1OdFuIZxH/in434gsKjlJVPyXAoPWDAi8IPvGTDbw4HtC8WRQE8krHnJx0MqLmad6WdgQSeaRa5Z0RWkmZ9NxrRChR8fWB6eTLg4FQVeO/F9d1VwKlU2YTk79LnWPXmKd36E/sganuYxHLILQ3LtHCsWMA/iO0DcbGLtVvLFAC+qqIUevcH3/TejeuRUkuwCCoSFfi2D+DNNdMmoneZ8RkzvWwjwFqWQiTwCKI6ubuCshYLcuMeFo6K+9//tPxHkQlI1Jq6eM9drlQLv/NL0WUhJzTrUs95Zvu0o1oQyZpp7zECrn7BhGxk4uTAkQp024thU0XFCoYkGZDrHcYOKd8HW1e5TFrf+ZnIIr5IWZlPCTzBsbzDf8yh2UVtEVFLDPJ/BETI9Zw4IqCRsw8smPkMIng/3koFSVlNdNDkfAouBMj4rCWjc7mc/RH91efObqIwzOsN9r2LUaVfPhusG9fQbg1lnmur9nF6Um8hWTGauKFPOiGOAupWMEQRnwVUv6wig5/N03uUCy8ba1wH/1q1P73NVgQpzS0lKy0B89vyXguDQ9LxSC40E4P5fYtTbOSBr7LBBXkc+hnxDMX1rFaYoFR1RzjYDDuDJd1cd+8K9OT6PPxv9hiXnnhfk0Ly8c0rG/8BRW9HLh1o2/ANNMVl9wcbCfr7T+N4z1CNdEmQcy7TCOUzKIcm1OZpEc4Rq9YxwdjCcatx4euxK+Y1DCwX/cNw34PfV+sU2aJDUFSHXzqOyUYNgbVWdBeVtWcBCx1gBRF1UTDhMQNaHRQ9isvIArAxOhJyFVD9u58TPdQfJSFZMhpTxK/fC5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(396003)(346002)(39830400003)(451199015)(6512007)(966005)(8936002)(2616005)(26005)(38350700002)(84970400001)(6506007)(66476007)(38100700002)(5660300002)(66556008)(186003)(4326008)(8676002)(41300700001)(86362001)(36756003)(31696002)(66946007)(52116002)(53546011)(316002)(2906002)(31686004)(6486002)(478600001)(83380400001)(15650500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXIvcEJBTDY4ditWcFhNdWxoZGtrK20rR2RhYXJKcDRZZVU1bnRRWDc1K3Zt?=
 =?utf-8?B?YnFGcDdsaHBhbEtZZjlKQ1A1OVNGYzhXQzlCT09qU0g5VWhsUVFMRFgyUHdo?=
 =?utf-8?B?dUNpN05oMko1ZnFqcHltUXl2Qk02dWFaYTdmZXFrbkk5dkxUSUhXM2hDdzhK?=
 =?utf-8?B?Mm5oZzArcHViY1czOVdjQ2lOb2VWSzM0d1F6QXN1bjR5RWMxckJaQkVnZlFF?=
 =?utf-8?B?empzcmNYVmdiVk1SYlI2TkZ6aW1VSjNaRm1WWDRsY0ZOYTU3YWZDZkVHODMy?=
 =?utf-8?B?MWpmN1UxUFNSUlZ6b0Q1ZXNkanVST0V3d0lqTjdpQUlGTWZDTkl6RHFnQTB0?=
 =?utf-8?B?M1R6bmFIcGtUUm5EQ1dEK3RCODlJUHRhMVN4aXozQjhUTDRCL3R6ZlNkQlVm?=
 =?utf-8?B?cEllZjFGb29nVllmbnRnRWNUWHFUSDdZT0JHVXVWdnM0SStGRnlkWTBQNnV4?=
 =?utf-8?B?ZVIvTmxxQ3NnUG5nam9qNUMwKzdPdzhmU05UQ0lZN1ZzQmpqVXdybHh3bkpP?=
 =?utf-8?B?cjl5d3FCSUM3MWswQkNGdW51UTZmWUl6bUhMa3NMSUxaRlFHd0JJWS9Yd1c2?=
 =?utf-8?B?TCtwWDVrZHlGVWVOaWtvOGJNVHcxWXVmYmNFTEdIVk0vcjBoZVdpbEpINmpj?=
 =?utf-8?B?bjJ3WllxZUlHSmRqVmt3VlBTQ1lybFAwc0syeHQ2VXFiK1pJdmZDOUJoOUZH?=
 =?utf-8?B?NGZLU2dlUXpwc2gxeTFhdGRuSDEvbWw5b1pKbjlEQzRIeW1idzFEU3dZNjFs?=
 =?utf-8?B?WjdhTW91UHpQRFNOWUU3bkNzc1laTEFtM3JCaHFPN28xMXpkc2ZGRThkU05l?=
 =?utf-8?B?SzlhaWdLZHBOS1N2OS9EdEdxRkxKQSs1T1JWQVM3Y1J3WVUxc1BOaEpoZXBT?=
 =?utf-8?B?TmNJcklLdmpRMmRJREZidVk1QXBLK2Q3eERKWGF1V0tpOEU4ZENwWEkrZHdY?=
 =?utf-8?B?SG1tOEJ1Z0FHVDBzQzcrdE5ESGlCS3pXZTVKM1RyajAxbzhPamc5bUpXMmox?=
 =?utf-8?B?YkdtQTUzUFlJK1M5OXh5QlJuNHZvem9uNnZWOVZETmJPYm1qTVFqUmt3dzBs?=
 =?utf-8?B?dm5IUUVBN1l3bFhOK0Z3WmIyS1FvZk5DY2w2YVVSM1E3c1hud0VYcEJjOGV2?=
 =?utf-8?B?L3BVRTh6TUJjd1JYK2tIU1pEcnltdVJQVElWRVNoamRmVncyNGI0TlZoTGlr?=
 =?utf-8?B?bmhjR1dlWVJEVlJvWTBOaUFTNU8rMVU0MVE1M0x6SytVN2VNd2FYUmo5Q202?=
 =?utf-8?B?UVhOaW5lNHFWNU1iUHJZQjRrVFR4U0JRWHFRMGdhOWt0SmRMekFPb1ZqelJU?=
 =?utf-8?B?Ynh3VzNPM0Z5bFgwNW5ObFdOQ1ZPQlFBR1Bvd1Rac1I5UkxhZzRSRERLL0Ev?=
 =?utf-8?B?RWhzODVUeFRaWHZFSUR4RzVMTG5UKysrRDhkOEU5S0JMdXdBVjYxSFdSdkt6?=
 =?utf-8?B?T1lMOVViVjZHcGNGR2xoRDl2Rlp2TG50SjZHTkF1M0dJd1JEVzhUdUlwN2pD?=
 =?utf-8?B?S1NWZllRQlpEQkVnYVpwNHd2Q1NFMUNXSTBiVXVhWWdlODlFV25RSVBlM0pJ?=
 =?utf-8?B?S1FDLys4TUxUQVRjRE02MU1ranh4MEN5L2pqcVkrNTNUemZjWlAzWHlRRDht?=
 =?utf-8?B?cC9UM2ZyYXJsMjRmTTRISkxWYXBCOU4yS3FXR1BNQWxGelJmck9udzFUWUJz?=
 =?utf-8?B?SWFpeHRpZ0dMaG1uVXhWaS9kcjZYZ09Id2JQcFlzWEhxekkyejJ4am5HYWVU?=
 =?utf-8?B?eVMxZDhlWlJMSnY1dC9oWjdscE1sM3NKQTFiZTQyOGU4OW12KzNwL2Y5Yjdw?=
 =?utf-8?B?Nkt3RlVnZ3E3Um9ITDByVzdNdEhXK3V2V2cwZjh5dFpxTXdHTDhpRDdFZ2s1?=
 =?utf-8?B?RmtpRmR4bHJFM2x6Tk1WdXcyNmc0cmFEWERobTA5NmNOMmtGUXg0TUlVSXBV?=
 =?utf-8?B?RnpkMXU4aUdRZVcwbVhjUC8zaTBJVVVaYkJvVnhjQzMxTm5jVEVSaFdOOFlV?=
 =?utf-8?B?amlldmMxWEpJVW1DQzJhUHNyV0hJUk9acXlqeEFUUTRBNjFjeG9FRGZyb0My?=
 =?utf-8?B?bGJSaFM1Z0M2RE9ZbzAxT2pqMW1MbmVhS1d3dWVzaTMzdUhCTFZrcmdqTnJa?=
 =?utf-8?Q?+COk=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d003299b-af3b-4c27-27f6-08da9748262f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2022 18:28:56.2129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uf55kv8FtlnLo/IQ7y3SlgDzo/6KgSkCvPqbbPHdmiXBicAEA1wMd4SO5kZzP4qn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB5609
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/15/2022 7:07 AM, Namjae Jeon wrote:
> configuration.txt in ksmbd-tools moved to ksmbd.conf manpage.
> update it and more detailed ksmbd-tools build method.
> 
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   v4:
>     - switch the order of 1 and 2.

I think you meant switch 2 and 3 :)

Looks good.

Reviewed-by: Tom Talpey <tom@talpey.com>

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
>   Documentation/filesystems/cifs/ksmbd.rst | 42 +++++++++++++++++-------
>   1 file changed, 30 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/filesystems/cifs/ksmbd.rst b/Documentation/filesystems/cifs/ksmbd.rst
> index 1af600db2e70..7bed96d794fc 100644
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
>   
> -2. Create user/password for SMB share.
> +   - Refer README(https://github.com/cifsd-team/ksmbd-tools/blob/master/README.md)
> +     to know how to use ksmbd.mountd/adduser/addshare/control utils
>   
> -	# mkdir /etc/ksmbd/
> -	# ksmbd.adduser -a <Enter USERNAME for SMB share access>
> +     $ ./autogen.sh
> +     $ ./configure --with-rundir=/run
> +     $ make && sudo make install
>   
> -3. Create /etc/ksmbd/smb.conf file, add SMB share in smb.conf file
> -	- Refer smb.conf.example and
> -          https://github.com/cifsd-team/ksmbd-tools/blob/master/Documentation/configuration.txt
> +2. Create /usr/local/etc/ksmbd/ksmbd.conf file, add SMB share in ksmbd.conf file.
>   
> -4. Insert ksmbd.ko module
> +   - Refer ksmbd.conf.example in ksmbd-utils, See ksmbd.conf manpage
> +     for details to configure shares.
>   
> -	# insmod ksmbd.ko
> +        $ man ksmbd.conf
> +
> +3. Create user/password for SMB share.
> +
> +   - See ksmbd.adduser manpage.
> +
> +     $ man ksmbd.adduser
> +     $ sudo ksmbd.adduser -a <Enter USERNAME for SMB share access>
> +
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
> +6. Access share from Windows or Linux using SMB3 client (cifs.ko or smbclient of samba)
>   
>   Shutdown KSMBD
>   ==============
