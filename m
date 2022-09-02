Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD238C6FA82
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Sep 2022 13:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237671AbiIBNzf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Sep 2022 09:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237663AbiIBNzD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 2 Sep 2022 09:55:03 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2079.outbound.protection.outlook.com [40.107.101.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBCC29C81
        for <linux-cifs@vger.kernel.org>; Fri,  2 Sep 2022 06:29:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a0tuLCxB8z4qMJRfQbpv1D3lTsz/8/E59BUcHmXZNiwy5ieDQB1WGMYc02hr4TVN14bqp3FLKx/281KQnKEqF8DlvOiTgK0i8cDb28E+3SLO/XCvxGB7ZYBmiJpgWKqFo232fh1Qm+QNRLhUaQ7EoXQ8oIMENkXzSq0FUGMN48qmaIwVYD7AkqjgBXrpc+tewxd3tbxo8e54Nl7LRHYIyniRjnwcbxkSpTfOpszvenkJGIKN4CAATrm3TehccdrWn2zgok288axJE5oWq7DaSaZq5NRoHE7RitxY7O2atLzzQa6Cj+Ba6+eBY+iKhN86SJG45iqp1MKYRI2b3gehJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xmklNm/JZQkNZ0Yr2mO+qvlrCOHf8hACe4Wv+A4jSck=;
 b=cf3ukYhl9O7uIFdwPjRnha4izcsJ6A8OgDZtAgIxPnAWvlC/I6LP/3k6V1rLCVl3tCUASEWRrzeNQpCWav1fZjv8hwv1uHwE6uG/qRCrpLkhJth6K6mWn5pSOprZobR1m3UUod1j0qlS1l77YgL6HrSqoNwQ1RIRoHDAv+TkCbqM7oaTcn2vj4Z9Jd5rhzuyoX9vcgrflJwg/BspoAslIZaZMzL5kpjZl7khfG5NOe2tgPKR95nOPGRjE7hPZbIhv/bbFPgaybZC2Xbuuxm6bIfjORzTRe8Vo5sBMQjVVdg8hGjHIsQSmVGlHd3dQPVJv65sblZAtgGDmF13KMxbpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from BYAPR01MB4438.prod.exchangelabs.com (2603:10b6:a03:98::12) by
 SA0PR01MB6203.prod.exchangelabs.com (2603:10b6:806:e0::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.10; Fri, 2 Sep 2022 13:28:31 +0000
Received: from BYAPR01MB4438.prod.exchangelabs.com
 ([fe80::6d1c:4239:2299:c1f6]) by BYAPR01MB4438.prod.exchangelabs.com
 ([fe80::6d1c:4239:2299:c1f6%7]) with mapi id 15.20.5566.021; Fri, 2 Sep 2022
 13:28:31 +0000
Message-ID: <6cf00762-f446-490c-5e88-79382962e985@talpey.com>
Date:   Fri, 2 Sep 2022 09:28:28 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v4 2/5] ksmbd: Remove the wrong message length check of
 FSCTL_VALIDATE_NEGOTIATE_INFO
Content-Language: en-US
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com,
        linkinjeon@kernel.org, hyc.lee@gmail.com
References: <20220901142413.3351804-1-zhangxiaoxu5@huawei.com>
 <20220901142413.3351804-3-zhangxiaoxu5@huawei.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220901142413.3351804-3-zhangxiaoxu5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0268.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::33) To BYAPR01MB4438.prod.exchangelabs.com
 (2603:10b6:a03:98::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0eaa412f-d18d-4a7c-7594-08da8ce7070d
X-MS-TrafficTypeDiagnostic: SA0PR01MB6203:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jrp9dvPsqmII2GnkLZmPFOK+uZGDgShToKBiRHvPbWoLIJb2VGZ7SKWcGySzI3rOh8Qqvvh6BJMlj6bo+90qJCZipcu33sVuGB0+0p1zRsN4mVNX+UlBElPotlmhJqOKNUJq5ePAd/93x6/hH4Dm/Nt1KImhiQJQEb5VyzQIstkhN6bV0I+6ESZtmltTXpuARb0dBqjJ8Ult5WL63qGM2VcQQiYRj/jm6q7/AK0YER+r9JtkpE+/MJdmOWbH+5PzE058M9pasMSB/zVMFzffEwilVAl2cQ2dSA58HBbtZMvRz7UlLRVeEKs5UMCBKT2Ub+OAsjPrXz6Hvc2bpBentsBGTBnNMaCc3mccW34FTya83WqCI1o69j0Kl/jKV8VgtnMSv6pktz40wjcHqSRWbS3pddNfKw7onswY9tMtZpfgUPIDgmpKGET7necFt6StluiAd8v87p/h0JkEEyaz/F8EPTPbgc3xJLCEMPM/xPZlUsF1dlelmMps7PWrkxDKpUEZ/LQrB60a6knbbdPegzqsZ8Egj90IM+E/+FoL3+jUQfwIiHgURwUE5hqTp7uV3tgjK40W+QeHNevnVnc6OKqYbtTe0StmCCkaKY1KjsxKgwGMV2pcjjzeZBec63cLDqGlxVOtL4z5xYyrZjACw3Fd/CLbOlF2ouC/IX0FMCwzxP5YbjtgoULmzUVlT9clUO4JFoUYDXupFN+dUDzawqj76sk8yt9vR5Agg6+rpRf+1gCaG/0exTMr1Rteup2nzis+Oe3amPEgQUifBf8R9ju7iFpkRAS5+TehdkaxPRW8R0wnVL2H4lNkDM1Ajm8i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR01MB4438.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39830400003)(346002)(366004)(136003)(376002)(2616005)(15650500001)(31686004)(2906002)(36756003)(26005)(6512007)(186003)(66556008)(66476007)(7416002)(8936002)(5660300002)(921005)(8676002)(66946007)(316002)(52116002)(478600001)(41300700001)(6506007)(53546011)(6666004)(6486002)(38350700002)(38100700002)(86362001)(31696002)(83380400001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnpKNnhRaVRJTTlkcmx5L2tDb0IvcEw5aFgrZGNMc0RxMWpNSkR3YjlwOWZ4?=
 =?utf-8?B?TzJJR1o0RTM3cXd5TXg4RDh0eUxzdk1mMGh1WjVGOVRPQmZaV0NMaDJGelZm?=
 =?utf-8?B?a1A1NFNYSWoxYkw1ZnRDNktRYmEvcm9ReFJCWisraFdFM3FtRTNzazJ6bWk3?=
 =?utf-8?B?T1hTUllCeVFKWnovQlJnOGFhaTcvL25uVjJnRGMzenZzc3ZmZzV1VCtzUUU2?=
 =?utf-8?B?eUJBVTlHNVZUNDZjS2cvcXUxWllaUjQ5WmtJaFZML0tWZ0xobzIyYklaRUh0?=
 =?utf-8?B?YmtnbmVCS2RRQXJNTk1Jcm1vbnJpbERtSUJnbC9NdEltb2RubmQrOWEvTkQx?=
 =?utf-8?B?aFhoTm5WNHRFVW9vRmFLSTg0VHc2UDNDZFUwZDh6S2QzemJNbVBsRVNOTEVO?=
 =?utf-8?B?L2RaWGxWYVNmd2JydXNoMFdzK1ZveWltNVB0R2h5Q29rd0xJNThzVThVUERT?=
 =?utf-8?B?SlRJZHVlQlJnc1BsVVRjaEJFZllKeG1ZZXZ4NmI5enhIUjRzVHVtWE45eG5l?=
 =?utf-8?B?akl1MFJGUXZiMTNIeU4rbU5oa1ljZ0dzL1dIblpNZzVvNTNmOXdLa0g5b2wr?=
 =?utf-8?B?QmVGdkR4UjZobGo2WXZwUzhZMjluYm16cHZFelJBMVBha0RHU3hJdWFLRk9J?=
 =?utf-8?B?bTlJUUxMOGpldTdTYmpobWVQSHJDY3Uvd2Z4dFJIeFp6Tk9Lbmx4RHRXMkp2?=
 =?utf-8?B?dUhXa1hDbzFjRVcrbmJVamlsSHlqaEJJRmJkSGRZVjFtd085bURoRW1LMllt?=
 =?utf-8?B?aDZVRzArZjQvMXlTSFBFb1N6OW5haTV6UXdMOUNRQ25jU1VxRm0xUm5IQ1hI?=
 =?utf-8?B?alFHUDVWRFNVWFhSMUNuZlk2WXFXelRUVDJBc1FLaFZ0T1JOTmV2Qm5ZQzdl?=
 =?utf-8?B?a3dUNTZYZXkzbHNFanBySTBoNW1CZzZuZ3FUTzMyU0JJMzc0TGUyaUhVWU5V?=
 =?utf-8?B?YWk4Q2tydDJnOEV4aW5KY0ZsMlJORVJDd1p2Y1dEUjExV2RVMzdGMno1Znp3?=
 =?utf-8?B?c2xXRFJwME1MY1VZN0lMdnh1c2QwaWdDZE5YVG5hbGtmR1gxc1EyWFdpRk9F?=
 =?utf-8?B?d1pGQTBXVFFtNUlFUVhKZmxCL0l5dTVQZngyZWdqTFdkRmF2S2t4N0xXay91?=
 =?utf-8?B?WnZUSW80SWZzNEdzQWxXZDNWSTNZUFdzNGVsUm1DaTZ4dnhRNnk0Lyt2aXR3?=
 =?utf-8?B?Si81M2xKTFJZTlRESkUyN0U4dHhlM0pScm1RcEFWdXpPUEUzTk5nY3J0ZE5l?=
 =?utf-8?B?TmNPSUtDSGlRaE9GTUZnMHZLMDZGSXJTL1ByOGkwNk5PaTZTdlBNVXV5SmFy?=
 =?utf-8?B?d0x1NjIrQ2RCTDdJRFhabUNtLzdabDI2QlVkSWx5Y0hNNnlRUXFGYUdoZ3RT?=
 =?utf-8?B?cWw5ZkRVOVFEZ1d6aXhzditYa0JTVDF3SlpYUk5TZ05KTFh3Nmp1eVBGT3Y0?=
 =?utf-8?B?VFpjOGZvSFBLTkFibXVkRWJnS2J4NnJXN3p4elZGdk1hblhaSk1NUnI0TDk5?=
 =?utf-8?B?QXJZTzlqU0xkQTN2MitldEZUdDlnU1ZIVnFtdUNCOXBjQ1FKTnF3ZnpDSlNq?=
 =?utf-8?B?eE0reUlyczZJQ1BmNEM3ektaNTRpRnEra29iVVV4QklMRTBaSEtqeFFmbTQ3?=
 =?utf-8?B?UXVFMVdDUSs4dFdpcm9OVnBQNkFGcmthMVBmMFJjRlFWclZPZzJGazZGUkZp?=
 =?utf-8?B?TGtFZUxkYkhhdGo2MVZkQnRocWY5bFd3T3hhMERkNGFYdGw5STFUNHMyZWNu?=
 =?utf-8?B?YjlzY0NkSXJZOFpqbHVnTWg3M21ZL092aWJrUzVnaXh3ako4cjNVdllXZDk3?=
 =?utf-8?B?Wkk2T1hhakplb0xLM3huclB2ZUtrSHNmVE13Tmd6MzE1ZFlkbzdvUEZyQ284?=
 =?utf-8?B?K20reDFONW9BS2xSSCtrVTFmM3l2cUpZbzNSSHo0Qk8yUU5CZWpPblYremNS?=
 =?utf-8?B?YmtnWHNoZ2JKeFVtSXE0RkJvNE91azNiTmpsTmErVklZbnQ0ZTZLT0dybVh6?=
 =?utf-8?B?dzVxdDMyR0NTcjhiYmJJYnRxengydW9kaDVCY0R6K3pkc1ZHK2NOZzJxYy8r?=
 =?utf-8?B?Y1JvVUk3WVdySmEvQVRzbE5vYzhLQXIraWx4dVFpamprOTVOUzJhVjhTazhM?=
 =?utf-8?Q?70bqfJ4F1/nSS1yo4jnF8jnkP?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eaa412f-d18d-4a7c-7594-08da8ce7070d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR01MB4438.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 13:28:31.2034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yKqEcseCHktDwMX5k6BE6UZpFq2TR70DFdfydrwtNr4HLgnp/snA0+71+SLFChJO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR01MB6203
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/1/2022 10:24 AM, Zhang Xiaoxu wrote:
> The struct validate_negotiate_info_req change from variable-length array
> to reguler array, but the message length check is unchanged.
> 
> The fsctl_validate_negotiate_info() already check the message length, so
> remove it from smb2_ioctl().
> 
> Fixes: c7803b05f74b ("smb3: fix ksmbd bigendian bug in oplock break, and move its struct to smbfs_common")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> Cc: <stable@vger.kernel.org>
> ---
>   fs/ksmbd/smb2pdu.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index c49f65146ab3..c9f400bbb814 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -7640,9 +7640,6 @@ int smb2_ioctl(struct ksmbd_work *work)
>   			goto out;
>   		}
>   
> -		if (in_buf_len < sizeof(struct validate_negotiate_info_req))
> -			return -EINVAL;
> -

This actually fixes a different bug, which the comment needs to mention.
The structure size includes 4 dialect slots, but the protocol does not
require the client to send all 4. So this allows the negotiation to not
fail. Which is good.

But there are two other issues now.

1) The code no longer checks that a complete validate negotiate header
is present before dereferencing neg_req->DialectCount. This code will
fetch the DialectCount potentially beyond the end of an invalid short
packet:

   fsctl_validate_negotiate_info():

         if (in_buf_len < offsetof(struct validate_negotiate_info_req, 
Dialects) +
                         le16_to_cpu(neg_req->DialectCount) * 
sizeof(__le16))
                 return -EINVAL;

         dialect = ksmbd_lookup_dialect_by_id(neg_req->Dialects,
                                              neg_req->DialectCount);

2) The DialectCount is an le16, which can be negative. A small invalid
negative value may pass this test and proceed to process the array,
which would be bad. This is an existing issue, but should be fixed
since you now need to correct the test anyway.

Tom.


>   		if (out_buf_len < sizeof(struct validate_negotiate_info_rsp))
>   			return -EINVAL; >
