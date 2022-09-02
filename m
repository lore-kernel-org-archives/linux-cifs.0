Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC40C38145
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Sep 2022 13:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236508AbiIBN4G (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Sep 2022 09:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236408AbiIBNzV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 2 Sep 2022 09:55:21 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2079.outbound.protection.outlook.com [40.107.101.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32D05EC4C9
        for <linux-cifs@vger.kernel.org>; Fri,  2 Sep 2022 06:29:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HuzO50X1Nt/w0z1z2TFaeN1WVY0/GO617sR1HBrOX9pI1B2Gsd7RrQDacLcD9RaqyR+qXToIHVCchiHprJAlpjlSLMKEdd3RGnlJTMzVz6Dz+t2KXeQJ95/5TRjdeWI8y8insM1u/BKWvsqh5iVsKXowa/baLvqwwngdw67O1BEOUi8BPS8pFoGhNTAMqcc5VM+m67Qsp6i4+nzZgYZFiNVs+mfmHPPYCXCrvWDguxMeSiYo3Yqfys/gXhzCwmscq5jH7EkW9TKg4N2+iM125CaGDKoy1doeawuKXnEPOR2bv6txmo88I2krjRWKYT7Mgdzwx3Efo8EM2mROEZ79+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NrchJ42qThNo/4R1bl3w6h7iU+OYPWSQ4iVNjNp8jcs=;
 b=SocLMcy+SVgJb9whE6syRvTa6rwUosISBydXBaCHzc76UDpTJYE5NGAptny372CUDmNYb3NBXfgxb2Ap8u//6aUkLk+OsITmz2/ieLE4+kIxPefrYeSBrunGs6aLCLOabsF5eyIpLsmaFpk/MqK5PFehHsRRTVlsHieWkRVWjNqJMc09L0jGAc5zC5h3p4+9O1fqIesAC2zvXdlgQn2gwIqbU40qsJ1uHnDRps6MiBMgNHKkZY2Skj9/ySaYJbqv79U5+uMleyTWIaTav1V1g3PhuaJvupnfqha4g35ymKg9nDnQfohNJtcSK8Qjh2DVvfb9xZsSQxltG7xHdHL+EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BYAPR01MB4438.prod.exchangelabs.com (2603:10b6:a03:98::12) by
 SA0PR01MB6203.prod.exchangelabs.com (2603:10b6:806:e0::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.10; Fri, 2 Sep 2022 13:29:18 +0000
Received: from BYAPR01MB4438.prod.exchangelabs.com
 ([fe80::6d1c:4239:2299:c1f6]) by BYAPR01MB4438.prod.exchangelabs.com
 ([fe80::6d1c:4239:2299:c1f6%7]) with mapi id 15.20.5566.021; Fri, 2 Sep 2022
 13:29:18 +0000
Message-ID: <0d601836-3748-7f4f-827b-af1b53eac0fd@talpey.com>
Date:   Fri, 2 Sep 2022 09:29:15 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v4 3/5] ksmbd: Fix wrong return value in smb2_ioctl() when
 wrong out_buf_len
Content-Language: en-US
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com,
        linkinjeon@kernel.org, hyc.lee@gmail.com
References: <20220901142413.3351804-1-zhangxiaoxu5@huawei.com>
 <20220901142413.3351804-4-zhangxiaoxu5@huawei.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220901142413.3351804-4-zhangxiaoxu5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0247.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::12) To BYAPR01MB4438.prod.exchangelabs.com
 (2603:10b6:a03:98::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4885b5d-2dd7-4959-154d-08da8ce72326
X-MS-TrafficTypeDiagnostic: SA0PR01MB6203:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j1OvkcVSQLeNPO7DBSpNBYnIeUlw2KlXWnjtigUyIZwyKArHjDmPryURV1beRi55lIzz8JOkv/5AiPDTRe7HAJyIREE7r5fkx0fQETM9CL0TXawzskCcBLQEH1GyWfuBfda4hWwjFwWLfro1P6ASleVWHzeQsSlU9cV1Yqgur5t3CGygGVzS9OCFmxniz8574pUvDCJEpa4w0KD8+7JafIkc35fVIiMqVy7FAaEUEnQnfvWkWtoLNoYpv02hwBqPs3rUXn57BVwxlR0/rGFAxX3kXYMW2qsrlSrp44uSdDRNU0sSjg/z5p8mS9kwEVmfA8hzab4dP+9CGHGOxOx6i8ai+S1jOQ39mDKRLxqF3Kev7/Z2a+jw6Hyqcvl5/RTik0WXUmNwaIR3GHCnzZ2HG0kw5xsRM0KK9aEnb06HvYubA+AXjz6dzTRTA/BljJ6g++KL6g+sRG6BFeueqefcSrCDQUYxaiel7AqhSohgMfeBt0YcaQA0psJK+F3Y7rhNEZaSBMVRfYTE7MFS6MkeYCg78G3biKJNCMXw/dBTDAMKrd/H8Ww7jkItcpMldPkig7zc2PRpzhXkclGuQBfiv3xIY4SJ0LwOsrtgAd4/LhZBSWj0vq1YpDFYysmpSJtX6naYFoskHTrbTIcpdLoKagHL5YQYokb6grAuIVM6lbMPF5TPHadJ8FTpf2qU1kLCYAAgCOGb9+paTCsb2jzwLLMzfxXVwXK4IPpNJhpqv8J7L31wvEIbyuSohNFR400V5/MIqwTJadhKmF3/SGRtuMBNCbHVW201qfAcBbMJ5tpurUF7boioU0+61JoJu6G3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB4438.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39830400003)(346002)(366004)(136003)(376002)(2616005)(31686004)(2906002)(36756003)(26005)(6512007)(186003)(66556008)(66476007)(7416002)(8936002)(5660300002)(921005)(8676002)(66946007)(316002)(52116002)(478600001)(41300700001)(6506007)(53546011)(6666004)(6486002)(38350700002)(38100700002)(86362001)(31696002)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bkhac2tVVEdnb1JQUXMyait4aURPTEw2emxPVEpJYksrVk1LT25PaGtHNmRK?=
 =?utf-8?B?RFBBTnVVb1FVUnNEaTdmc1JWcHk4UWRhbnVsckFlTzJabVNMKzRFU1hnVGhK?=
 =?utf-8?B?RGxGT1Mvb09lWTFINVd3Q0wvZlZFT3MyNVBRQWN6enQ3NGJVYUxuVlQrQ1ZF?=
 =?utf-8?B?Q1ZXN0V5NWo2bTNXQmxZblhSaGRlREh6RmgySTc1blhkdUtNZnBISFFYNTli?=
 =?utf-8?B?eUFyQXhYazFyaElLUU5wTTV6Sjh1aW5WV29ISkNRdm5YMkVqeEdsVSt5Um9p?=
 =?utf-8?B?RlpGOUJMNlJHNHZnaXp1QjFyZHV2YTdIQmYrSGZzcjVMb0ZDYmVWL0oveTlT?=
 =?utf-8?B?amFuRzFmVzdaL3VGYzlCbnMwNGpCNWJ1K1dTaWFweUM1UFFpWEF2cVVvOTFP?=
 =?utf-8?B?Qkh3VWRZWHpWQTNhRmduWWZ2S1FySmFNM1EycnFjc251RkJvTExVSlVBRTZH?=
 =?utf-8?B?YjFlb2ExZDd3czJiWkk3Q085U29hQllrbERIOVJyOGNNNkU2alRyZUdLWnVP?=
 =?utf-8?B?OFhiZThYaDI1RVpLanFIUENpOExrQ0lic1lZZWhXakxwcUVIdnpnZGlnckxl?=
 =?utf-8?B?WDVxdEdHekZrdmQwYkVDdlloRW1yOUdic0UvUU5vRGNKRVdNWDl2WnNZcTA2?=
 =?utf-8?B?SXRjM0hKZ1lSWldnWVpMYnh6dEd2Wnl2R0s4QTlMYW1lT0Jjb3FpV3BzYnU3?=
 =?utf-8?B?aTBwRHNZeTZYMTkxZS9mZER0U0M0eXlnbkVQdEx6MXB6dld4S1dJL3Fia3dD?=
 =?utf-8?B?WHo0RUc2cnd0OG1WMHcxekNRMHdIaXNCc0ZiSnVycU9qekJ5M0FqVTNMNFov?=
 =?utf-8?B?L0hXeUY1S1FjZ3NqNHB6ZXZjQU9RWHNYVmcrS2Fnd2k4dzd4OWJpU2s2R1hT?=
 =?utf-8?B?RG5xekkwRVg2bkhYS0RkaEg0WFRLZVdmSm1RSG5Tc2dyY1MySTVGSmJHQVNV?=
 =?utf-8?B?VlVpU2dpVEIwK3NHUXlwT0Q1TVlvaW9JUEpWNHVZZ2Rrb25DcUJPRlA4a1lR?=
 =?utf-8?B?MFV4ZTBtZ3RHcDVmOW9SeXpuR3RIMEFFRVRQTTVoNEhuUndSYUk2TERaY3N6?=
 =?utf-8?B?ekp1VTgvZ1EwWVVzc1BsNGo1c0FUVkREQ2QzQU5xNVF1UUdIRXd6d2p6WGxP?=
 =?utf-8?B?eVpVRWJhTVVWOXJWeHFnNUxqMW40R3FhZjNZbnhNQlRvYitKUWpNS0Nuc0Y0?=
 =?utf-8?B?RXpSSHprSDJCek15cFlrZWNTODNTZXEvME5GK2VlN01ub0x2YkE3WlE4TndN?=
 =?utf-8?B?T1crV2ticWZEYk9WY1hXVHpxclNYOUhkb0tZMk5SY3pYM0ZQdWE4dmVSMk1P?=
 =?utf-8?B?ckU4bE5hV1RmYUEvZEQ2RmJjQTJXYk5ncnVZL2hYamlJRGkzYjg5VEx2U0dG?=
 =?utf-8?B?OHlpTkNuVnJ5ZkJRMmF4Z0dkeTJYcVA0c0tmbEg0c3FVcWc0NUJHZFFzejVH?=
 =?utf-8?B?a2tVNGV5UExCMkNqY0tVQ2dQT1ZxZmdYOXdkaC83UnFma2FHSTM1bEE5RDBq?=
 =?utf-8?B?ODZ2ZVAzOXpiTmhEY0Z1Y1VjYm5iV0hVR3ZQTDAvTjY4UjMxamJKM3E2d3dK?=
 =?utf-8?B?YlM4QnVOc0M5ZkVIaGZGdnZqT3V2a3VNWnVoVnEvNWkycnM5eENBNkFkcHNL?=
 =?utf-8?B?SVJGTjhyMVFwOEQ5Tm01MHFUVjlBQzVPV2swSCtkTUNqQm1iVUJNVG9hZUFE?=
 =?utf-8?B?czRHL1FjdlhkaTZtaEdXYkk3VHVWWVNtNXg4Q3hLS1NOK0V6cXF2VVdLZFBN?=
 =?utf-8?B?VW5naFZHeDFEeitMVEZQcWZPSm5JaHlVeFhZVjRUcmRQOWNpa25pNnI1U0xp?=
 =?utf-8?B?SE9zYzR6cytWWmtqMXc4NHhMc1NraEFvNy9BQmJ6cGo3REpudEdzbEZTU25F?=
 =?utf-8?B?ODk3T2Q0ZDg1Y3J1WTNWdmFBVHF6WENLRC9IV0tURzVrbXdPU1NFak9GeGdr?=
 =?utf-8?B?Z0NINWZlR3RVSjhpR0JFSXN0bXBhdVo2djhJVU42ZzZ3eGI0dkppNG1BYkl2?=
 =?utf-8?B?T0wyNWVpL3NiczhudHVrcWtqcDhsc3M0bWw0V2d2bDhXTWNrS256NHZKN0o1?=
 =?utf-8?B?WFJyc0cxcUFIbllRWDJscFRSeU4yb1JqY0V6QmtxVkhrNlBxaytHN3F2cFI3?=
 =?utf-8?Q?cXUxQfVEWTWMo0QLnTQtlMm0J?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4885b5d-2dd7-4959-154d-08da8ce72326
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB4438.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 13:29:18.3253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JnTP8tgjGDpLAmChiYE1GRMN5+zWbxD1dcwPPZ3M5N/DdXjGrHyvRikKgl9sE3PK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR01MB6203
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Tom Talpey <tom@talpey.com>

On 9/1/2022 10:24 AM, Zhang Xiaoxu wrote:
> When the out_buf_len is less than the size of struct
> validate_negotiate_info_rsp, should goto out to initialize the
> status in the response header.
> 
> Fixes: f7db8fd03a4bc ("ksmbd: add validation in smb2_ioctl")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> Cc: <stable@vger.kernel.org>
> ---
>   fs/ksmbd/smb2pdu.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index c9f400bbb814..7da0ec466887 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -7640,8 +7640,10 @@ int smb2_ioctl(struct ksmbd_work *work)
>   			goto out;
>   		}
>   
> -		if (out_buf_len < sizeof(struct validate_negotiate_info_rsp))
> -			return -EINVAL;
> +		if (out_buf_len < sizeof(struct validate_negotiate_info_rsp)) {
> +			ret = -EINVAL;
> +			goto out;
> +		}
>   
>   		ret = fsctl_validate_negotiate_info(conn,
>   			(struct validate_negotiate_info_req *)&req->Buffer[0],
