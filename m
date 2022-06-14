Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03B56C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Jun 2022 11:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbiFNL4T (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Jun 2022 07:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356182AbiFNL4R (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Jun 2022 07:56:17 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A1346B3D
        for <linux-cifs@vger.kernel.org>; Tue, 14 Jun 2022 04:56:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4HJt8tJO1ixwJdUGGlJeF4+aREpfeohr+yzWQ2ts8kZOiH/GnfUq3Q+jBKiM/VDghP9BVxyGt3Yi0lvGLW+3p7z/PdpYJqbsats7VbYSZSugE0AK+9mqXy7cfxO4vN0QJqUQNNTPo/RXo4GI4UIPAEASjjGJAMPh1oAF2vv1CJyQJXmebJwA1Cbjw69Ai3kKQfBq4n9Jb2h4CfjyaocQYp1YQAvtB98SyGftoanCd45gAvX/moLSbBmXcgOlfwJgkwZ00CAzukwWm1KudGAfvN0onbpbTjLziyyXiXdKotewUjfpjJzuqbfyedt6iosLQq9A5Fb9WZ3h9jEfMYB1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DCa4paZFr/v+uIvIHpezR9/OHAcBva6TydMkmFbo7FI=;
 b=fTYa9pNuCKeZPbvmmejddqWmnKr8+su9d31EgQMxPQKs74vqsnRw+fywpLLO59XwtU/wj/fP4SF9egIP6+4NfxzGPti86xlrg7CtJCL1WHim6npn3jGM+fWNMx3mCsVrpcah9fUlfDAMw/XVF5d8Dw9UOt9ClVt5kwcAEQL1UKvanDDkHt+Pz2vyBl4p6dae9DoNHpRGxQapE4g0VMrNVSWZQGStlPyFB89eivoBFXiG3Ly8gk22taiBcaFcfr6q2bkifYizxd16DEgJrElB39klBXXXHM36y+yybN3KXp1Ziorm37asukT149M2VC90qOS/Rym80+HQ4b+Xnl1x9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 CY4PR01MB2790.prod.exchangelabs.com (2603:10b6:903:eb::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.20; Tue, 14 Jun 2022 11:56:14 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::1883:4cf0:e35d:b6f]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::1883:4cf0:e35d:b6f%6]) with mapi id 15.20.5332.022; Tue, 14 Jun 2022
 11:56:13 +0000
Message-ID: <6b74f448-947b-0b42-f22d-8f3e5db10e50@talpey.com>
Date:   Tue, 14 Jun 2022 07:56:11 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 2/2] ksmbd: smbd: handle RDMA CM time wait event
Content-Language: en-US
To:     Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>
References: <20220613230119.73475-1-hyc.lee@gmail.com>
 <20220613230119.73475-2-hyc.lee@gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220613230119.73475-2-hyc.lee@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR19CA0031.namprd19.prod.outlook.com
 (2603:10b6:208:178::44) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8351b8ff-74ee-455d-547a-08da4dfce189
X-MS-TrafficTypeDiagnostic: CY4PR01MB2790:EE_
X-Microsoft-Antispam-PRVS: <CY4PR01MB27907B6F32A9BCAECE2BFA14D6AA9@CY4PR01MB2790.prod.exchangelabs.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e0eyIcVmVfWPpXfy56936HwnzOOmVa5/WauJeT8wUQ4LRQfJICqZkslxLADTOFjpvNyXvwVGCwJpDY3UH4HwixeJK53hSDMuDV8Jgmjb9/56AW0cl1g8sqqdOn3dkJaWqUGgDA90pM390oPZO8ZmMOgaIiU5NOYz+wOR0FBZssMPw/MhzZ/u6zwTGjQibfE5ukmeKXURpyLoE5T7CCeWuH1tipRFQLdbEvexrE1Op9gLJkcOd1+05YM2RTbQkTIyIRSghvr2nFBbvMvRNLRTY52wwosTkmFqMfpzn4xjXvEDAjlhy+bnuWyeq0pTtCIjxJE09C7baLaxDfJKCR+xiqzM4ySCv85HIlcAEIssY++K1goVdonNsQQ8+JkoLjoqtBQCitVfXCV5unhbAh2qp20iqGyuzROfSg91FBU1Q7oZHZ9WswST2Lo6gA+PTzzIqMJxc2kwZPqDNYVIw8ATj0MUl2OAFjAqX5kpYgCK7YCY/lZENjSeIN8EA31MVizgWRwgqv+T93B/QURCZlPXxSrewRwJyjy6vmUVPGB41XHM+aUTVOuJwgwlN/Tau9miKB4FL4FqJ/6D0j2GMnVmGml08jGMyhNhvZ8O1Iq+WjP7jFGPjy/LDUhI1u4+kICq5qm4r64TT/UPlx18qq7iPeEk6CK/3WiNREcLsQNKq2u7R73SWIkPzQ/fj0GY1T52nGdjZ4IEeRvCCEuHOB+kgYCmsPoIEa00T8R5J/q82wc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(39830400003)(366004)(396003)(136003)(8676002)(4326008)(36756003)(86362001)(31686004)(5660300002)(38350700002)(2906002)(66556008)(66946007)(6486002)(316002)(8936002)(31696002)(66476007)(2616005)(41300700001)(54906003)(508600001)(186003)(53546011)(52116002)(6506007)(38100700002)(26005)(6512007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZzRjRkgvbS9FdTlPNkcvM0tlZkRJU2V1c1ljUlFrVmROUHVqQWdoWHJrUHZh?=
 =?utf-8?B?WldjSm1zbEtQNUgrWWZoS0xJU1ltQmZwQ3BidURIZTQrRENmNW9paURSQXBK?=
 =?utf-8?B?enBQUXZ3Zm5xOXhvNzlKMXJyclN5Qk9PMVpxbFFpTTJqUDM1UjhYZ0dNUVp0?=
 =?utf-8?B?Y0Uxc0hyZnlqTTJOS29WT1U5OGM5UUQyNHlzZ0cxM091WDdNNVByeENhaUdz?=
 =?utf-8?B?ZVpIQlUvRDZPZHJuYzdtY1B1RmV6M3hpbHUyWlQwZUZ3M2hLaGF6bTVlWFc5?=
 =?utf-8?B?aVNPN3NLcjdLZ1ZYaHlPWkdrdC9TSGVoQ0ptbEZNWCtXSXhsRlBQY0pOZVdV?=
 =?utf-8?B?Yi9qRTFrTENEWVhtckFVTXI4VVFKOVhud2RqSTU1SkpNZFRjTVJXd0w0aDRX?=
 =?utf-8?B?R2NUM3ZtczJLS25sam02b01CcGJucU84bHIvWlgzOXM3WXRGQmdvc2dKWWNB?=
 =?utf-8?B?VHNNOTFzbXRDK1d4OEhva2Z2Z1hFM291TEtObUVjWUs5bWtlVGtqRXh6Ym9X?=
 =?utf-8?B?VnpNTnQ5WlRhTmVVVGx6QXRrUlFTM3QwK0h4OXNuaE5PU0hPNEJFaUllZHd5?=
 =?utf-8?B?cnBZdFRtMVVDelFEMXk1dys5NXgxKzVmVEoxT2w3OVhBYmdlQUVzSlJLcFJ4?=
 =?utf-8?B?Zk1INlB1UmR6QWw1THN3TmtzcE03bk5CMkt0MUI5ZFJzdkNSeGJqU2c3R1Fx?=
 =?utf-8?B?dEFqb09TLys4enhmR2Q5Z3RLOTVBa2lJSU92eUVxUjMwVG9CcitRdUtadXFa?=
 =?utf-8?B?NFFuMVZadXBrcmd5RDVKUXFPbEsxakEzSHM1UllnUzUrdjdjL3FPckVob0l5?=
 =?utf-8?B?NURBTXJ6WkJBdU5MalFKa1RaeUlqenp3RzdSaUtoNE1ZWGJNRjRJUTcyUTBC?=
 =?utf-8?B?Z2d4KzI2TTNXWk5kV2d2TVRQLzBHM3ArS0QrOEZGZi9Fd1duNmRwTW4rVENk?=
 =?utf-8?B?cHdvdFVlbUc5ZWM4eGs1VytiNUpnd0pLSDluVU5BaU1HUkFqL3RwZmY4MDZz?=
 =?utf-8?B?VEpCblJ4TmpHV1RSeXdVbkVTYVQ5YzlCSG04UXpjY1VHa3R1S1RaQzhaL2JS?=
 =?utf-8?B?VldLWFlldWV5WVp1KzNEMjNjaGtFR1FZc1hMNlRSeXpYMTA3YTVqVkpzcUxC?=
 =?utf-8?B?QnlnSVpLYWJEN29tNEtJVXFKbC9YbjVoUXRxdnFZbHhJMzhjRjVUTnhzR3o5?=
 =?utf-8?B?dHZMVzRjdkxVaGlZTFhTSmxucm5wY0dTYnlBUUdrSVNCM1BaV3lwQzFpS0dm?=
 =?utf-8?B?NERHaTdIc2ZuWU4veGNudTVnNGU1aVpxUUxiV3ZnaktVR3lCVVd2cytCZkYz?=
 =?utf-8?B?QWRKenUxUVRqSHc5dTFjUVZ0WTdLUWxrUXJLZytXcS9kL2gzMnJHemp4bHZi?=
 =?utf-8?B?QnkyZlE2L1RLOHdSR2ttaUVnSmpvcGxpaEszSGJRRi84TnlhRVF1bGxzcWpL?=
 =?utf-8?B?V045MUZSRVVlNUVFWnRyRmYvaGtwQ0xaeTFNZVNPS0YxZGFodWxBQ3VPajhH?=
 =?utf-8?B?dEcrWGxsUWlnZU5lR0Q4VFhocXN3RkpjTW1RWThqOXcvS1JnWHhMNy83TlJH?=
 =?utf-8?B?dUxnN2kvNUsyOTJHZlZrN1lyV2pzL3daNW5FV01tQzFPWHYrVVZXbU4wOUVt?=
 =?utf-8?B?bFFKQXRYcTdhYlBFZnJidzdNUmQ1T0F5SDVwS09YNjI3NVkxbVZqZmVvYTZW?=
 =?utf-8?B?bldaQUZHZG1CdnZLaW5LVk54cWNDeEx1VWw2SkNudkluSnloRUo5WmpqY2lG?=
 =?utf-8?B?eEJ5SlEzWllkMDRXQVlSLy9vaDR6WUMrWnZaNS9WZWxwYVc3bzZRVTVwL0N0?=
 =?utf-8?B?ZTlJN1BmeGYzU01aejd2YnVOSm5xazVXRkVobUg3SWR5MDJlTE51bU9CM1B2?=
 =?utf-8?B?VFF4VEJweUNMTk9YbnMwb2ZGSXNnbElMUi9HYkxjUTFZVC9RckNqRkIybkVI?=
 =?utf-8?B?WkJkSjNpcWsyVndacXJzb1pPWWtSMFBCa3AzUGFMZXRMcHNORU9uZU5yU0tr?=
 =?utf-8?B?blJ2T0hWajJYOFBLaUVxTkpBdkhidEtlejBhenYvNm15L2tuVGhmS293YmFl?=
 =?utf-8?B?N0tZa2gya2dJb3NrL2lUVytsdVdjMVprS0xFNXhVMHlVV0FGZnZBeXFxdnBG?=
 =?utf-8?B?WTNmUXZTU1RhczRpellWV3ozL3BhN0NwVnFvODlITk4zSXU1aElNbFVadjhr?=
 =?utf-8?B?ZnlIMnYxTE1GNnZlTFl2SlZXRHNPT0RPSkU4ck5sa0Nva2YveTdob1V4WENt?=
 =?utf-8?B?aUdmTnFCcXA2enc0bVAxQ3lSYlJRWGFKTTBvdU1kZkhmTW9BMm5iU2oyTi9x?=
 =?utf-8?Q?70+HjIIw/8z0DO0yYX?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8351b8ff-74ee-455d-547a-08da4dfce189
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 11:56:13.9036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ohJ9NjJTSdmUWVnCw0aDuaoKPvMiYIKbkUOavwXkBVw5Tz17xmobk+YepAtC0oXF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR01MB2790
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


On 6/13/2022 7:01 PM, Hyunchul Lee wrote:
> After a QP has been disconnected, it stays
> in a timewait state for in flight packets.
> After the state has completed,
> RDMA_CM_EVENT_TIMEWAIT_EXIT is reported.
> Disconnect on RDMA_CM_EVENT_TIMEWAIT_EXIT
> so that ksmbd can restart.
> 
> Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
> ---
>   fs/ksmbd/transport_rdma.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
> index d035e060c2f0..4b1a471afcd0 100644
> --- a/fs/ksmbd/transport_rdma.c
> +++ b/fs/ksmbd/transport_rdma.c
> @@ -1535,6 +1535,7 @@ static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
>   		wake_up_interruptible(&t->wait_status);
>   		break;
>   	}
> +	case RDMA_CM_EVENT_TIMEWAIT_EXIT:
>   	case RDMA_CM_EVENT_DEVICE_REMOVAL:
>   	case RDMA_CM_EVENT_DISCONNECTED: {
>   		t->status = SMB_DIRECT_CS_DISCONNECTED;

Is this issue seen on all RDMA providers? Because I would normally
expect that an RDMA_CM_EVENT_DISCONNECTED will precede the TIMEWAIT
event. What scenarios have you seen this not occur?

Unless ksmbd wishes to reuse its QP's, which is not currently the
case (right?), there's pretty much no reason to manage QP state and
hang around for TIMEWAIT.

Tom.
