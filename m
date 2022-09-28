Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE70C04A95
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Sep 2022 15:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbiI1P0u (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 11:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234152AbiI1P0V (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 11:26:21 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BA14BD2B
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 08:25:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YcYmuTD4Cd23EYbE/l6jS0BNJDvFpPmBHUrCAO+w3oCmaZTxmcdlOjvI/hvaKgruuKlQDyvo3GBFJ258//gQp3H4cevWJSgoXe6M2VBDdmGyEh2iaiNrafV1X12slUROLqqsgJJNfWy11FkQE+KyoHGbixy/xkrEJxM4x/b1HV5VbQICNhswywOIpvTusfUs9f7jOv2BlJXdAgt3EeUGUj7erZzMOdYFyttvNi0rkaMxVE6/6X/Iwu3rsSLDS/IDfZB2xnqN8qfTXOsAEtgHBkkBQ18I6avEsxC8nECb14u/2FLoOYpL5lFjJCslTn3tTOQzJdW42vM5e8gc8GLHDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O9DjRku1OcV5rd/b9EWm8xCRJXBLpR8mhXeCcRD11d4=;
 b=mG7ahUOSrF3Uk+svGUvC7oozRvt5TJ0L6ZdcX7SrOKNe6tjAcQpKIJWkFY40+kCFWQGmxzUXszvuVk0UxEYx1ARSTTSGqxZOIzL9oU1XQLKguSAT3Z+SSmZfKMnBE/MQfaWxdKGCO1snRlIP4TWE+VdYt9lu/hZhbzPL2wi+rXPyCYWjPvSRN1k5gERO+yicIK/loBHgR750xzHGJL/RMuDoj3tvhSyMYbQT3v2RQdP5Obr8Vx1zjT5On9UIdF6UdF2e5K6Q4vVTl5SSL1MLfz8oBO6IYCOOXRbmjHUURE+q6WjP3f2kHl6ouCFIo6juQptr59Wb84zQbemmlFOrlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 DM6PR01MB4555.prod.exchangelabs.com (2603:10b6:5:7c::17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.26; Wed, 28 Sep 2022 15:25:50 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::d99d:5143:a233:36a0%3]) with mapi id 15.20.5654.014; Wed, 28 Sep 2022
 15:25:49 +0000
Message-ID: <60322098-648f-2610-bcf2-1cec581d4f86@talpey.com>
Date:   Wed, 28 Sep 2022 11:25:48 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH] ksmbd: hide socket error message when ipv6 config is
 disable
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org,
        atteh.mailbox@gmail.com
References: <20220927215151.6931-1-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220927215151.6931-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR13CA0023.namprd13.prod.outlook.com
 (2603:10b6:208:160::36) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|DM6PR01MB4555:EE_
X-MS-Office365-Filtering-Correlation-Id: 0230f2ee-92d0-4083-5149-08daa165b90a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4iboEsnzxBL5COs23ZoHPOu4FWWu/YNbUIwUjnW5EkuL6DhSzAr5WDvwq1XDxAjSG5u4tlkZrMPsa/9y7hJwW4DMpZuuEcaZEkUTDqarKDK9DPMjxQWAa3oiGuQW8X7DzKr38BtnkUFCQwU9X4qYaWEgi6BCvDyQPYvwbuS9do6C9UwfORvfJJC64XOt98IFhkCR5mXprBuNUdfle/GltzQA5E621uRbVK62WmGVSlUJJ9xxLArfyqqAK9RRGlIkwUyEULpH8eo7tP7RP8kV3vPOW8w3wpSZiocjThcJDdhgbGbu4fukUDAVHTU0Hm03fJydi8Xo/KZDue7fnL4MP6q9UjOIOZGn3TA9d4kFX2HGV/PK5encGLFI4A6dbp/lPLgtW/JoaTZpCwf9L8SoMmSftytjG4INNHlJE0dLPr9JIs45NxM7ScuWtMEUKf7Cwc5Rcs2yqXB39muTKwtoIblGYO6xZJiNax/yNEBYguXCqm7/F6hHz4EewRXMI6sus9G3772XMarWouvp3epqW99WTDU+72KAmJcY5CMguwONLfpDhAqC3F3BTQAHsmi9DNJZgk96otp6RsqmBAfkDizSTj5jGFefcggn38jRJQRqVzjr+QJCsn7+4+fW5t583jbHdkjwV/mhVh5OXbukQ/BoNebUDG7ZRaDh70UF/fL2OCv9XoT3OEPSs4rDbzx0a8vliK7RnTiy8pvZTn6/KcslYrLPMFtt08vRvmsiEjFa8kihrtS6qdfg0mHBd1ankPJ+CpeJy0TGGTESV9CMMtxaE6QMlhVKZEx0eKlNgZA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(396003)(346002)(39830400003)(451199015)(8936002)(316002)(66946007)(31696002)(66556008)(6506007)(52116002)(53546011)(5660300002)(36756003)(6512007)(2616005)(26005)(186003)(4326008)(38100700002)(8676002)(86362001)(66476007)(38350700002)(41300700001)(15650500001)(2906002)(31686004)(6486002)(478600001)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aDZNRkRLWjNZL2tFSDduZFZ0N3hOT0crUSswbTZWa1JJdE5VU1RKQ2xHL3BS?=
 =?utf-8?B?NGpDeDZYMUQ0MERZTW1majVaN3hPTy9DazZ3RTdhOVVlNjQzeEZTa1NvaXJO?=
 =?utf-8?B?bFl0bEY1dkVGOXcrZ1RqSjlqODFrWUlHd2dsL0hRK0JyZExDeXdCWTR2aUE4?=
 =?utf-8?B?S0FZNVV4Q3g1WlBmNithVzZDemV0QkpZMXpFbWZjSWdWbmk1a1RKb1k0SWlt?=
 =?utf-8?B?NkhLTDFIamhQZ0pTa1pwYnc4OHJsM0JWNXNFNko4NnJ1b0FJa2VNK3g3cCto?=
 =?utf-8?B?WTlOODluVFp0aHdmb3RWWndSV0lRbFJ1RHJSQkFvWjNBU1ZJT3Y0Sk1mcGVY?=
 =?utf-8?B?RXJ2K21uTjdOcFFpcTJtSk5WU05mQVdwV09SWlBacG04UDJ3VlNxRy8zT0VY?=
 =?utf-8?B?eFB5ZkFsZGlWLzJVbXJoODJGMlcxcEk4eDRvZ1JLV2lhQlFoc1lHUkx1RXMw?=
 =?utf-8?B?U0ovNFdxV1Q2M0JmSDFZWTRXS1NtaW4xUXh0eXVCVjgwWExHUEJGZHBDNmlv?=
 =?utf-8?B?akh5eVRBUVdvTVNtdUdyOVNDVUprWWtESE1JVDZnS0RGMDdkcDZwYmZtTXlK?=
 =?utf-8?B?YVBOcUV4VVB6VE9EcVEzRFZkSFExN1N0WXBPakpWM083T1NOUjZaRkswQStV?=
 =?utf-8?B?aWV1eXpra3pmNTFuUTlCc3V3TnkzTGdRVTBTVDU2L0tZSStYZ1hsWnA4SHRq?=
 =?utf-8?B?VzR2cDM0ckt3bUoySWxOMmQ5c1R4Q0U3UCsxMkZFYzZXWTZIRk0xeDd3UFo3?=
 =?utf-8?B?QlNYTUJUenp2ZmtWOWljZjd0eEhINmVCMm9kNnU2Ukx5ak1scS9TYTFRVnUv?=
 =?utf-8?B?VjJKVHJ2RTJHcVgyTUFoMFZIOWRnNmFVQXZyY0k4RFF2Mk9kdG5pUHlGSXRY?=
 =?utf-8?B?MWRjTVQ3c0hZS0NrSTIrQUJGR1E3NVZmUjRiZ0xqa1JxMzFqdUZaRk9aUVBT?=
 =?utf-8?B?cW1oU1RzaDE2SzlaaG5SYjlXM29uRFgxQVlxc0xGd2xVakJKUW9OS2MxVzR1?=
 =?utf-8?B?NHdqRUNrdkVRaThxd29DSXRFczR3OXFZbzJOYnBPcVN4ekV1d2MxUzVwa2oy?=
 =?utf-8?B?TFVrM1hHdlpOTzMzd3ZxWDN0Q2VGRTR0UExiTzRNZnFvS0wwdkZRMGVuZWlk?=
 =?utf-8?B?dGtYT3dFS2FORVp0bDMwWWkweWh6dkh4WnljOStMbXZjZGJib1dTcGNSMzVN?=
 =?utf-8?B?YTY1MjZIclJkZkZVak01WU8yci9RaHVlUEFxVmtSc250L0ZyVGRRWUlzOWEw?=
 =?utf-8?B?eVZDbEhKbzRRVUhaVkRyeGk3L0phWjhTVm5LZ3FUQzhBUWFzRUtGaTlIS0lH?=
 =?utf-8?B?OVZPRStpL0RjWGJSVjF2SjI0d25GZkNYTm1EZU9ZN0lSWEFweFZkTEI5N3dl?=
 =?utf-8?B?RWlDbmZnTjdYMHk1WnNKVTVTMGZ3bSs4TmhQNUNsdUtBb3NxTVRUOGxGeHZE?=
 =?utf-8?B?dEphYm1uNFpHUmt0N2t6YWRWZVVDQlpienMzQkdXZkkxZGlJbFZJUk1wRTAy?=
 =?utf-8?B?Yys0bVdrTThwWTYvTDVJdG1yajhYRThjYnRydnFLOU1HQXJ0K0t3WWdzR0l0?=
 =?utf-8?B?RTYvRC9iSVdTdlF2d1pMTzl5SnFKeFlPNDhBczA0YmMyLy85dHhJbkpNeW05?=
 =?utf-8?B?SXRMY0U2VU82ajZoTnhtREVSMThHWjNyYnVRSEpKMHFuVkFoVHlXUnRDTmk2?=
 =?utf-8?B?WEpEeTRPanEzR1lpdGdpT0c3K1RxWFZOZmkzR3ZHczBNYitrTVk0SE1LOVB1?=
 =?utf-8?B?bzdXR25DU1Zna3d3UFA3THVGaHFUOXErMFloL0ZwdUNXdnRCaXFKRnNySHhE?=
 =?utf-8?B?UDZ4eUIxaDBsaTBuZ2E3NEZYQzNFOEk3SDBaaEplYlpPL0RGRlZrcnd2Zmgr?=
 =?utf-8?B?dkRqaVM4b0doMzVXd2pNUFg1cnJGNVFYWlVTaWMvU1RqWXJQSmNZMGJtb0NN?=
 =?utf-8?B?UDF6WTJuRlo3bG9zYjNyZ2dDMmYyVzJ4Qi92QTlkZVUwRGtkNTkzUGFWOEZu?=
 =?utf-8?B?Uld5NEdsNHBRZE56UFUrK21aYWFmelJZSTZldVpCUy85UDU2eUlOeENhOGk4?=
 =?utf-8?B?dWFKclpaWFI3dGtGZTIwK3lKK3AzUFVRRnRNNkJjdFc1MHYzc1ZYU1ZjdjVC?=
 =?utf-8?Q?gmz2fAhM92s2PAz/yPtrlunUr?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0230f2ee-92d0-4083-5149-08daa165b90a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 15:25:49.9107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cmkA4PHhw7FX6ks8PijYGcVLCvxXSSJ1wKOIV9Zjk0jUlWkRDt1N5FxQHEGX0bpV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4555
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/27/2022 5:51 PM, Namjae Jeon wrote:
> When ipv6 config is disable(CONFIG_IPV6 is not set), ksmbd fallback to
> create ipv4 socket. User reported that this error message lead to
> misunderstood some issue. Users have requested not to print this error
> message that occurs even though there is no problem.
> 
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   fs/ksmbd/transport_tcp.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
> index 143bba4e4db8..9b35afcdcf0d 100644
> --- a/fs/ksmbd/transport_tcp.c
> +++ b/fs/ksmbd/transport_tcp.c
> @@ -399,7 +399,8 @@ static int create_socket(struct interface *iface)
>   
>   	ret = sock_create(PF_INET6, SOCK_STREAM, IPPROTO_TCP, &ksmbd_socket);
>   	if (ret) {
> -		pr_err("Can't create socket for ipv6, try ipv4: %d\n", ret);
> +		if (ret != -EAFNOSUPPORT)
> +			pr_err("Can't create socket for ipv6, try ipv4: %d\n", ret);

Why not just eliminate the splat? The only real error seems to be
that IPv6 is not configured, which is undoubtedly intentional, and
in any case there's nothing to do about it. Suggesting to "try ipv4"
is kind of pointless, isn't it?

>   		ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP,
>   				  &ksmbd_socket);
>   		if (ret) {

The same question applies to IPv4 - socket creation is not something
that fails in general, and spraying the kernel log isn't particularly
useful toward fixing it. In any case, the error propagates back up
to the caller, right? Why wouldn't ksmbd.mountd do the reporting?

Tom.
