Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C982ECAAD4
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 14:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbiHaOut (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Aug 2022 10:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiHaOur (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 Aug 2022 10:50:47 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2079.outbound.protection.outlook.com [40.107.96.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22C12A249
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 07:50:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLYQ4XKxFenIKQ2zCkPanA7w+HcR0YEu16iV4aR/kped2PB82XHxXB4mMEQbEHdaJ4PJ6BbW7DBAlmJBTgU4zUv30fCzguuGsKNaVCFu8veT1BGpXS9trSZ6IAGEIri7ue9zyGZ9z2Tr4CD4nX7BtPvrNWob5dPOJn3FZKliIcFkatLkX2XHbTxjOlQ2Sh/ApK1tzDtzz1BJ2/Y78awmyJm2i+b8PPBrn2BHSk1AwqzS4k22FtVHsrhXCIhoT/lnr32mLIY0yh+ZYz7qqNSMmz4g0JR5Okv55tCEQqAchzVYAl0khkuviNZgurP0V2fBG1V7El6vHW6TdWYv7PbFPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rEgvAH8Or64Z5HN2FBa0TB+oL034ikKxZyt51jvnTCc=;
 b=H50nT5aONmPYVrz1qEEykm9dreS/7eQA+g+G0StpnbRpaveRCZfz8enzrhpKkgG/SBjVo0nPEKqnKSM8o1yvWyeVa4qbwfPdIYdmCko0PmvxBXDcAteSSnaQjCmvRtlIcjTKuyPpGlfiTeNQhGAXQGhXscpzWFjdY3Ali8M1lieW2cogUjhSBlP4s7SZe5r78Yw56KUXFmStNe36RaZEma2OZygklhvHcS2TRboVkwEyiDNHVcbQwSvasCn/2WmkfMHCBmXOV3CZBlcBPv8W3otZxUj0ekfFy3pi/Fg7xcEMFbGQsrb0BklQfuphkSwB4Je8pWgRoXpM+V7TrfejwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BYAPR01MB5542.prod.exchangelabs.com (2603:10b6:a03:124::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.16; Wed, 31 Aug 2022 14:50:38 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b%4]) with mapi id 15.20.5566.021; Wed, 31 Aug 2022
 14:50:38 +0000
Message-ID: <3b13302f-28b4-60b2-7f3e-0c62703ee7b7@talpey.com>
Date:   Wed, 31 Aug 2022 10:50:36 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v2 0/3] Fix some bug in FSCTL_VALIDATE_NEGOTIATE_INFO
 handler
Content-Language: en-US
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>, linux-cifs@vger.kernel.org,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com
References: <20220831075255.2667077-1-zhangxiaoxu5@huawei.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220831075255.2667077-1-zhangxiaoxu5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0053.namprd16.prod.outlook.com
 (2603:10b6:208:234::22) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80f0c9c0-58fb-4323-5cfd-08da8b602b29
X-MS-TrafficTypeDiagnostic: BYAPR01MB5542:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: arTqHpLO1OW1fDHXcTzR39/WlK8fSBcIUBD+HtRtWGuTNpAM438AnwlQZ1aVxwp6Rb2H2bWC8PBoo6caDL4tlF1OaqW4Ps0GL/b6lxeNGSpVDgHFu4oQZG+sS/2sB+LWn90/bkJyi3uAigz9UigYB7tS6KYS6HUZ5UIUaoSMnyClp+7STRGX7fUQRydf7ppgMjdJxI6WrN2uIW2RlrlIWtTV9eWMEa+7x8hC7g316F8jZCCihXV/NYJM0o+m/C6hBzYwURLqQyw76gGWI9xDzKF26dJMM0hweaEaC7nKbI26808UEkbDq/ijuiASUIAxvV3RNz620WqQddhv2Cl7ZWe5az9zis67+HX1izyuPpRxSR4gfQPvvVIQRri5SNEXQza9XJvUIJZoqEczQREjbzJLr01fSXTzpsER1LeYPFdaJ5mG7lIlCW8i55sbW68GWsiz5bP1GiwKZSzDIHf88c1k4oUdrmxxcH82kB3tT8hFq6uDIJ1OTSRCFI6rGQNgDqf9b5aGxr/EzjlooQdyvVEepN0FZKue6VUcVSSXW/rtLGq9bKSDnszKjCc3VPpcmGTavYawIjeUqVJambd7/xLS3NZU4wKdD702sBgU4PTHylmnwvt1siZkcTI8KP7hbeTRdlFTFn/zVDCyPb5rPSdr9KsFXD2AHYt7FEDjIh4NFCn65LayHBqNghHjLIYSSLSrF+ECAqSzw7Rsr5swdTYLBLcL+4Nrw/VbftfdJHdDVS2yjFs7MCW0SDvvQyYkaDWCg6PfZ15ZpFRjbmZjwRZl9M8oIdhFxrAq68T0IHk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(396003)(376002)(39830400003)(346002)(316002)(26005)(31686004)(38350700002)(66946007)(6506007)(66556008)(66476007)(53546011)(52116002)(6512007)(36756003)(38100700002)(86362001)(31696002)(8936002)(2616005)(83380400001)(186003)(41300700001)(2906002)(8676002)(5660300002)(6486002)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N05OU0ZwcFhJWmZEZmZGejRGK1lEeWtaVjMyeWQ5OWNCcWN0WTB0bkJMYnVI?=
 =?utf-8?B?bEtqSDkrQUhUdDYwSnE5Q2NVcU9iWUtTTmFzeGkxUHQwQUMyYUhFem5TM3Zi?=
 =?utf-8?B?MG10andpNWV4U1dpaS8wdGE3eVd6SDNHZHoxN2tlWm9ndlBKRHNLbERZdU1S?=
 =?utf-8?B?Z2Z1cW4yZlF2NGMvZmFROThCelFqWmpQdkdnNDk3d0VDbHlSVHd1R2NJaE5v?=
 =?utf-8?B?aDd6UWlGVit4VG45WGlGMkxiUWVRUjNXQjBaVjBXOHhIZlZZM2w5Q1hRRTd6?=
 =?utf-8?B?aWJEYUlKL1psbE1aTE9JSmRCWjJFZUdHckFjaHdRR1hyb0dLKy9seEt2cVJq?=
 =?utf-8?B?MGowWjl3dW1GbDQ5cGt5cTVlYzdUT2cvOW1yNFY1RzBqc3Z0S2dmUzZScmR4?=
 =?utf-8?B?K1E1MndxUk4wSDNVTzBpR0pvemxiTHdxUFVhamhJalRtbjNEVDNZTGlRL0pP?=
 =?utf-8?B?ZXIycWtKNGg5UHVFb0ZrYXc3bW5ueXU0WU5VQVFSVVZ1aDJYcjQydm1UTXVi?=
 =?utf-8?B?Q2lNSldsR1d5TDJwTFJ0NXFxWmpySHVsUUFKRkxWWVY5VklqOUVGeEI4NjUv?=
 =?utf-8?B?dko3S0RCRU11emd3K1Y2TkpxZDVSNlo5QnpXeVc1RnJ1ZjJsc2MwWk1GZDlM?=
 =?utf-8?B?S2VvcTMwNVBaa2Q5cFlZTXJkS0hFL1EraC93SCs2bUEzK0Q3Lzc2T0hLdm1a?=
 =?utf-8?B?c0JzenlkeDZKM1ljK3Blc0h6S1BiQnM3SDZTVG8zK3FqSFJXdXpCeU85V01V?=
 =?utf-8?B?dTRwb0xZNU5pVk5RMUVZb2ZGSnpVYkgwbEk3Wmc2NHBDMTd1RkU3cW9oOU4x?=
 =?utf-8?B?b1lxamc5dU9CdW5EQkVyblJVd04zVHZ6WHlSdGRSbVVxQXFBbk9mR2w0NHE0?=
 =?utf-8?B?TnFZOGFVYjBNSGxrd0ZCaWlJV25vUUZRb2kyc0RKS2lUeEQzenY4NHk0TFFP?=
 =?utf-8?B?RjJXcGtPVHRWNEV2VlpPOFVhcUJQd091QzYwQjArMU0xMXBLenpyMUp6cjlv?=
 =?utf-8?B?cUU0NkxBTVNxMEl1RVgyeHo1MkJXYVlxdXV4N2djMkRnQkJzTW5WeExkclhT?=
 =?utf-8?B?TVcvMy9LRzBFczd6K2d1c1VUeCtGbDJjZTJyQVNjUHM4cUloUG9MQjVXMkhq?=
 =?utf-8?B?QnlQUmo1Q2U3ejg3MlZhL095aTBJYmkxRDJnd3ZwVEJtbHlQRGZtUkdvZzRT?=
 =?utf-8?B?dUg0S21aSnFGc1VqNW1JcDdremxPMVhnQVdMbThjRzM3VWZad3RJT1dndkNa?=
 =?utf-8?B?U29kSjdURm1zM2pkS1BxTVVVZWdvc3k5aWV1QVZ6b1FrN0diM0xlaGRXeVIw?=
 =?utf-8?B?VHBVcUw2ckxqQjVxbGIybmhYR2ZTSzFwU1Q0cDhNSkJ3KzdmRzJoMzJPdHJQ?=
 =?utf-8?B?aEc2NmE3dmhabUVickc2TmZkVGE4b1V2ZmY0M2ZPa0dERytocEw0amtFak1m?=
 =?utf-8?B?SlZXMnRjcW9KaHFseGFmT0xjejNMMEtpSStVQWlEcXFiaXR4emN5UG5IWGJB?=
 =?utf-8?B?cUVFNzhuNGZZNTl3a0lhb0txRGhQQkcybWV1bU5JWnQ3b3hSRzhmWnBMQjBT?=
 =?utf-8?B?cHZUaDg2UUtscTlya3llREVvbC93U0xxd3doMi82aDBHZlFOVTg0SHVuVVN6?=
 =?utf-8?B?eTVxRS9aQ2NBcDRoL2RIUngzWHRQaVlCRG9pdWMvQjRMZm5XQVFUZHdQaktm?=
 =?utf-8?B?YVFLai93d2ZpdnorOExBdk1ZUUJZWHJzMmlESnoxb0h6Z2FwSVJ0bENxaTZW?=
 =?utf-8?B?MFpIc1JMdUM0ajhaV3Z2dW5PMWNNb3lTZzZiUVVycUFiTTZhbWZzZFNjbGd3?=
 =?utf-8?B?K21LRG9nd09TZ0FpNnExZ29PRjB0bTZmdW02UlN5Q3drVmdEZE5FRkNkdWd1?=
 =?utf-8?B?OGV4bG1zdktyVFp3dERDNGF5ZTJ2NHdadkQwVGtEc3FpTUFlMEhDT045ZTRC?=
 =?utf-8?B?TWJYczBGZWdQakdsYzYvbVg3R3kvcG5ra0p2LzNqTHJjcHFXc1RLNXhVa0Jq?=
 =?utf-8?B?dy9vMnNhYk5rOFNqcE91anh1R1U0RmJMZUliUDRlc3RlcHN1NE5FNlpQUGxV?=
 =?utf-8?B?ODZ6bUt5TElLaEZhM0h5VkpWUE1iQkUwdG5kWGMyV1pvK0Fsa0FNY1ZGTG9B?=
 =?utf-8?Q?ih/sl3B75odBbmE0Bl8pjgaF/?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f0c9c0-58fb-4323-5cfd-08da8b602b29
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 14:50:38.4848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5fI4OsnNw10gkqP2dUBNAM1gkWAsRVfSR6dIwI+tQNgHXGnMggIm/CwMmi0KTF/q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR01MB5542
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 8/31/2022 3:52 AM, Zhang Xiaoxu wrote:
> v1->v2: fix some bug in ksmbd when handle FSCTL_VALIDATE_NEGOTIATE_INFO
> 	message
> 
> Zhang Xiaoxu (3):
>    cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO message
>    ksmbd: Remove the wrong message length check of
>      FSCTL_VALIDATE_NEGOTIATE_INFO
>    ksmbd: Fix wrong return value in smb2_ioctl() when wrong out_buf_len
> 
>   fs/cifs/smb2pdu.c  | 4 ++--
>   fs/ksmbd/smb2pdu.c | 9 ++++-----
>   2 files changed, 6 insertions(+), 7 deletions(-)
> 

Sorry but these are a NAK from me - they don't actually change
the definition to a variable-length array, they just attempt
to undo the broken "4", in several places. The real fix begins
in smbpdu.h in this line:
         __le16 Dialects[4]; --> Dialects[]

Also, the change to ksmbd is incorrect, it is critical to check
that the inbound buffer holds at least enough data to be able
to dereference the DialectCount, followed by a second check
that all the counted array elements are present. Also that
the outbound buffer is large enough to return a single dialect.

Tom.
