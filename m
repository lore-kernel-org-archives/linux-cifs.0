Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB86ECAAD1
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Aug 2022 17:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiH3Rji (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Aug 2022 13:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbiH3Rik (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Aug 2022 13:38:40 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0C6B12EC60
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 10:35:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCqe1ySQPeMl3JY3o5SCZ1rE5sOfbxLG3FX1XJ+AwUJrdaxG8bgWhbNOWZn4mXk7z8//2sadIbZfJwnr+MYOrNXUt9lZ/OIFxfJIK/pP2r+a5tZERMOlwQF20LlHBqVNwhNfEb5ZTC+eQyFKiLCm/snahoyEfnmLnXmQkHbIqmCvf88gLmkchjwCA5oe3GyJ/f8rCwJFHQUpDTfwsKByhdnZQZHSD5qxxgBAJnUbo3eKBcwfFGsVBBwt35l1EK9HQSoBYLzmipNHmTHCBcPLT9zHUc6oRb5ZZNNwqhwuF3lC6XJiKwjS+5M2FwbMaF84p/PLJbz0LXIm44PxyqsZDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bk4pcaUyHi15N26oL0hdzeAIh1WZKfD+shI1kgT5w8Y=;
 b=LgrjsICNDPMYSEr2vQ8iV/4yFmW3+ylvMcjgivXXWTkmCwesF03o7XDI3/wCmFF/kS3KwOC6JoF5xmtMHKRNCsZz8275xnsnpoM7LkAqkK6jKfFq8b+9G1VEa5HUCxRKkxC7xqiROF1T5OppbywERmkTdkL/Dr98wNPQdQp97qEHE591kntwT8fzJpbQzgOmzloWMl/Bjxq61cejwngV2pf3UNAx0Q52jrzlr0zV3D4NuILKegsR703BPP/QbrD9eBmjTZmFRUfoVGTHVjC/SCKD/0jAbMN7URnbcFwSUBcK18A0QWHhbGNKiqbNCl2NVjaE9c5DQtFFGI4wOV9tIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 BN6PR01MB2834.prod.exchangelabs.com (2603:10b6:404:d0::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.21; Tue, 30 Aug 2022 17:32:15 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::701d:e406:dcfa:118b%4]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 17:32:15 +0000
Message-ID: <4de37022-ec62-319c-6ee0-89c8491cd102@talpey.com>
Date:   Tue, 30 Aug 2022 13:32:13 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 1/2] ksmbd: update documentation
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org
References: <20220830141732.9982-1-linkinjeon@kernel.org>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <20220830141732.9982-1-linkinjeon@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0060.prod.exchangelabs.com
 (2603:10b6:208:25::37) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f275c319-f0b3-4315-59db-08da8aad9452
X-MS-TrafficTypeDiagnostic: BN6PR01MB2834:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5Rhik19iZwZw99Ng/oAyM2AgA4qK0Aq+iO8H4nyW1Bd2VnpJ5OaCw96SVFGxY7A2eiY0HQ/2xQyOBWLXbxWdHKpY23u22GcmQ+f6xJklvUT9zFFTFxq+hlgEvkgJfnvZh9F5tiT+9jVWMMdlDeuUw8zCM8NGJobvi8ciD5QTUuPPMZNln4GwsM8KdmywEtlWuGa080fB9uemqVsvYev31+VeIOUi4XH5IuZXM/DC0RI6+dkkznZlqkF+9BMIV3yoycMQqfozVKeWPAFRXVZjw5w+Ee8lRWVOE6qz3JJctxYCwWTLuOc02D0xa0UeVDI371T21C6jDuOectHQVfvIkClCTFdJKrNTdUdzta2euHo/SfV3CTSGgl/h9DFS/7krKO0C8LKTU4Z5gwMKg+aZIfc2ZHVNZr47/DuK3AjyH0/pxPvsmIvM4LeVS7HjbwLb52IDhPTUTo2+eKJV+p6AVqNcydRxoM4cBPjraPDl3Vc9o22ikiRNsMIn7uDt5cYWCBxCHCz5RQtPOd9wAKWNB69tGEZ74tSBuVTobkxXIJssYCrSz+zCfoiLyNEMGBJHJ9PbTmPB184cJb/3LXT68EWPLnXaWxYO3RAC/r6VjXcNNTWN82RB/7YM+z/ENP41jr2oHJzD1ainQ8XCIbhnJ0gPLGqiroed6YCa4pvRaw39PL2Wxa95GmycBlAD9l+8oz/BAfeuy1ueMRxGQi3pn+j9PuaeC6ENpyE1aJIj4r/tY9eqkG1QMFvs5VzWxjIu6ya7xTs7FgzBb0PlW3CBJI+HyXCn3ebE6SqvPEinKfuKITekaNiTULQ4FPb2/U1O
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(39830400003)(396003)(346002)(366004)(376002)(136003)(66476007)(478600001)(86362001)(31696002)(38350700002)(966005)(66556008)(8676002)(8936002)(5660300002)(41300700001)(6486002)(38100700002)(66946007)(4326008)(316002)(2616005)(6506007)(2906002)(15650500001)(36756003)(52116002)(83380400001)(6512007)(26005)(186003)(53546011)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SW9pUDVhL25NU0ZSUDAzblNvZWZkaEpNcTJCOU9XMGJzemJHT0NLb1FuM0Iz?=
 =?utf-8?B?Yk9Pc0l3QWNKQXlUdWl4bW14am5iQnlacUV1ZDFUaEhDbWQ5cHdXdEFGZGtV?=
 =?utf-8?B?bXhWbmRWTVFEVC9mcGg0TXpLdXhRRTVZbjc0Z2V0ZTQzcko5dzM4S3pzMTNL?=
 =?utf-8?B?d0l6eVNQampLOVZ6YmVJaWpwcElRN04vT0RQdWhKUStpR0hGaWxnemVvZVVJ?=
 =?utf-8?B?anZ3Z2p0VmdNMFZsdllQWml4aXBkTm0vZHFSK1E4VnhzbkFvb3RyYnV4S3Z3?=
 =?utf-8?B?clVCZGM4UmYrcmd2RGxkQkkwQnBWblJZYkM5aFcrenc3SGtQTHZUbXQ3Z0x2?=
 =?utf-8?B?a3hTTzU3L1VVSVIyTy9XYWxkUUMxM014UnJGUFdlY2NVVjNCRDBPQWg1RElk?=
 =?utf-8?B?U1dPRVJBR3d1R3ZidVZ2ZmJqUFp5N2wvRlBZNjg5OS9GamtLeExmYlJyb1Rh?=
 =?utf-8?B?QWwxamlVK1lKTExoKzdDU253VEt2aXZZSWhMbHFxUUg4S1BFbnRKUk1NSmli?=
 =?utf-8?B?bzdvTlVNdlk5dEJOZG1wRTEvUUFTeVBhWU5mOEVFSDIwbDltcTkwYXZiYlpZ?=
 =?utf-8?B?ZHhWVnBub0dKNFpybzl4d3dON29VS3oxeEFMWlRneUpyQ20zazgvY250QW5w?=
 =?utf-8?B?REg4blVBalZOSkR4QTFnd3NDWUhyN0NnSVZTMXNYRW9nN1l5bUhCbFR4em1M?=
 =?utf-8?B?aWdMTDYxMzFQbStsWVE0aEp4bHZGQTVOTDdpMzFZcnlTYituQlVIUHMwR01p?=
 =?utf-8?B?dTdPbFYwQ3piODZzUGNERTBCWDBCaXJiak4rY2x6QjhYeEpadzA4MWlUeWJJ?=
 =?utf-8?B?MHhZdTYyM1VSaWcvU3RZeDY0K2pHU1hwUGpaVVQwbU5oeW5NckhCOFVHUUtw?=
 =?utf-8?B?Rkp5a3dDNTE4WHJnZ25vcDVISHozZDVRbi8zaGp5TWVQVnZheUEzMjJtMDl4?=
 =?utf-8?B?NWplT1A4RTd2dmdoMDYzWXhENWo0dnVPZlRlMUcrU3dvMzh1Q2tTbzJtMFZ4?=
 =?utf-8?B?MDE0Sm5hMmxaVjdwa0NDa1RxT0ZTR1pJdkdMSDVoTWZxMVJRVHVveEZQYjU5?=
 =?utf-8?B?Q2dUKzIwK0k2U2E1cE4wblpQQW9UQmd2L3hGSDVBbGROVE4wL0htT2pCZThE?=
 =?utf-8?B?eDlMelk2VVAyS21ZNVRpVlFZVWJ5VzFwN1JzSGZWb3dSVWc2dFVBUitkWmNq?=
 =?utf-8?B?eWR0dkxMc2ppSVcyVkhXZ0Y5d1NPNHhHcWdPOGo5YXZjUzJNdGJ4UjNGdWh5?=
 =?utf-8?B?MC9WQVhpeU9vY2sxYVBUdWttYkVQZTBnN1Irem9kU1dObzE0ODg1Qjk2Z0Jz?=
 =?utf-8?B?THN5bW5zYitkRkwzM3U3eXVSaDR6TkZveVlTRWovKzg3dGpnU1pxU2xNSjRZ?=
 =?utf-8?B?cU9ZSkdCOTNzSE5HNk12K2VISG1GbDBCbW43Y3J1S2F4V05CeWpISFBOSjFj?=
 =?utf-8?B?eGJ3WENZYUlsSTZTcWtRRnRHVngrdUR6bmU0TU80dGtWSEs1TEVNVklLNVFP?=
 =?utf-8?B?Z2ZyNWZldzNaRUtFSXZvZGVuTkdoZVJmTTZCNTRDM3lKT2tEcTBhVEpPaTdW?=
 =?utf-8?B?cmJiMU5sUVBkbkNZTGV0T1d6Y2hJWEp4OUJlTWNxUTRuWGFCWnZGLzBkVkJD?=
 =?utf-8?B?dFRGYWFEOEI3dGh1QU9BMmxaNWlkMkZsTTBVbW1ZaVlrbS9ZVVk0NWJ2Z3BZ?=
 =?utf-8?B?bVNsYmMwbWk5aThPRlFMM2FmTTNaR2tiYlVreEkvc1FiRlVGZnZkYUdVcFZM?=
 =?utf-8?B?SmFhV3BDSEZzd1hUdnNnWStwSXlzcTZyaFlET1BxbDZyb2FRS2NucnJUUUhp?=
 =?utf-8?B?QjdWcVYvMjQ0alVIVFZlcGFVM0VMbDhrcUFpZ2p1NlhkUWgwb3E0Y2d5aDNQ?=
 =?utf-8?B?OHpKa3F6UXJOMXFYU2U0VDJ1QW1XcitPbjVmRHMxNjdUUXVISTlhbDVhQThZ?=
 =?utf-8?B?Q2JEMmE4UzdJMlVVUDhjVjJkTXc3MGl4SU9zMlpnbGUzSmg5aDYvN2RjVXVJ?=
 =?utf-8?B?YWpITzYxbVdJWmRVQnphZERYRS9lV0x3WTVxSVppSGhuWXFTaGpycWVWcloz?=
 =?utf-8?B?Skl0Q0hXZlRzczlaS0J1eGc2UXMxWVNWcWU5MEY2NGJ1TVNvK0JDcHRkaThO?=
 =?utf-8?Q?yiyw=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f275c319-f0b3-4315-59db-08da8aad9452
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 17:32:15.1715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3fogFCuLxjVT9sF9zdfOXM7OknSm20MYEX4jgOypatkXfcjmdZemK1hZzyoIskO0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR01MB2834
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

BTW, I expected a "2/2" message, but never saw it. Was the
subject a typo?

Anyway, I have a couple of comments on the new file, which are from
going to 
https://github.com/cifsd-team/ksmbd-tools/blob/master/smb.conf.5ksmbd.in

It refers to "SMB1", but ksmbd removed that, right? And because the
SMB2 (and SMB3!) dialects don't make it optional, does the setting
still make sense? Either way, delete "SMB1" and don't restrict the
discussion to "SMB2":

\fBserver signing\fR (G)
This controls whether the client is allowed or required to use SMB1 and 
SMB2 signing.
With \fBserver signing = disabled\fR, SMB1 signing is not offered and 
\fBserver signing = auto\fR applies when negotiating SMB2.
With \fBserver signing = auto\fR, SMB1 signing is offered and SMB2 
signing is required.
With \fBserver signing = mandatory\fR, both SMB1 and SMB2 signing is 
required.


Also, most of the settings start with the words "This controls whether".
I find these words unnecessary, and by the third or fourth one, they
are super-redundant. Would you consider rewording them in a more
active way, for example:

\fBbind interfaces only\fR (G)
This controls whether to only bind to interfaces specified with 
\fBinterfaces\fR.

... could be:

\fBbind interfaces only\fR (G)
Only bind to the interfaces specified in the \fBinterfaces\fR setting.

Tom.


On 8/30/2022 10:17 AM, Namjae Jeon wrote:
> configuration.txt in ksmbd-tools moved to smb.conf(5ksmbd) manpage.
> update it and more detailed ksmbd-tools build method.
> 
> Cc: Tom Talpey <tom@talpey.com>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>   Documentation/filesystems/cifs/ksmbd.rst | 10 ++++++++--
>   1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/cifs/ksmbd.rst b/Documentation/filesystems/cifs/ksmbd.rst
> index 1af600db2e70..767e12d2045a 100644
> --- a/Documentation/filesystems/cifs/ksmbd.rst
> +++ b/Documentation/filesystems/cifs/ksmbd.rst
> @@ -121,20 +121,26 @@ How to run
>   1. Download ksmbd-tools and compile them.
>   	- https://github.com/cifsd-team/ksmbd-tools
>   
> +        # ./autogen.sh
> +        # ./configure --sysconfdir=/etc --with-rundir=/run
> +        # make & sudo make install
> +
>   2. Create user/password for SMB share.
>   
>   	# mkdir /etc/ksmbd/
>   	# ksmbd.adduser -a <Enter USERNAME for SMB share access>
>   
>   3. Create /etc/ksmbd/smb.conf file, add SMB share in smb.conf file
> -	- Refer smb.conf.example and
> -          https://github.com/cifsd-team/ksmbd-tools/blob/master/Documentation/configuration.txt
> +	- Refer smb.conf.example, See smb.conf(5ksmbd) for details.
> +
> +        # man smb.conf.5ksmbd
>   
>   4. Insert ksmbd.ko module
>   
>   	# insmod ksmbd.ko
>   
>   5. Start ksmbd user space daemon
> +
>   	# ksmbd.mountd
>   
>   6. Access share from Windows or Linux using CIFS
