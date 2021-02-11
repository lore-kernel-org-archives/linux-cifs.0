Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D852C433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Feb 2021 12:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46C8C64E9A
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Feb 2021 12:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhBKMR3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Feb 2021 07:17:29 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:46875 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231634AbhBKMPR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 11 Feb 2021 07:15:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1613045644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nhtllMZZcRvEAYgy0H2+D/Zl1MiwWOpiinKU/JPhdbs=;
        b=nwyQEohF/Bgx0zC3r6gFsx3mTKPyhHSUHhG56wmQ2hRnQ4dhV5TAcjAuAdj4tDwEOM3iYW
        CoziE7BgRaPIOyssXlNgATnEkAKyIc8an35NP9nhod8kRUswuuJLbi0U9vq5w0jYwbYkPC
        /MIPMVbNsYY5Vn4zXwVuVVrZ9OMvF3U=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2051.outbound.protection.outlook.com [104.47.13.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-17-mempVy_rNmixKuSXIw_xDg-1; Thu, 11 Feb 2021 13:14:02 +0100
X-MC-Unique: mempVy_rNmixKuSXIw_xDg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AqjJKXSrS3hOX6x+wquas2F7Gi6jxB8Z+zHXrBHpvuhlEghKUMUKVK8kZ6LIo38W18DGxeowpxbUxPcNjRXSziPxNn0qXOVI6enJg6Ukn8M/dpyXrVyeiricOWVYNk/gTjcBqDbjshEuQDe6SXaX/AMKT5fwWqePbOdqzSVxR4ce7tZ/TemT45ZJb4nOrUMTXaTWXlvvDePJCLhT3ruh6DWgoyomBJdFDD0NP3BAb7f2iNm5OqG0wukf7RiF+OhxSDtSb/TVcDoL6RWVZkGRJ/V33RAiYZrsJRze/h39y6CyMPia5rwtdcyOwRx2e824T1EIRaI8j+LYE66Yn7WvKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nhtllMZZcRvEAYgy0H2+D/Zl1MiwWOpiinKU/JPhdbs=;
 b=iRUd8mfaOvG8D3d6Bnb0Dw4p5EUqQhR2Hr+oImeN4HZo06yyN56GKfRwvMkIJlzDP/SwvhpNOKzDE+uwJXIb15+qbLqFyqVn49SeHghkAeMU1fKPWHZMn8bwaagqx2g3/JHpDob8OI21WOHmcSJYhf5jSTibkzcRPrCmsZBNVBMXAUQn1iRR1itAu/voMg+KblUII+6m5zxxy2o4RFDx4j6wYBFvq3btGE1ZdSAwHyeTt9ik84czbYx2wZeJ6rLLFdJvrCuasGn+9dt1hETs+lm91CrW34ofj+uAubEbcCZTCW20JnsMXgTdC3Z6AznQvAjY9wE9jmTXEGEzKM3NEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0402MB3520.eurprd04.prod.outlook.com (2603:10a6:803:6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.30; Thu, 11 Feb
 2021 12:14:00 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3805.022; Thu, 11 Feb 2021
 12:14:00 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting
 cifs_sb->prepath.
In-Reply-To: <CANT5p=qNNFqeZnegrYZa0s_=KwmMVvQE3bbbGk60Y=WYvmiHOQ@mail.gmail.com>
References: <CANT5p=qNNFqeZnegrYZa0s_=KwmMVvQE3bbbGk60Y=WYvmiHOQ@mail.gmail.com>
Date:   Thu, 11 Feb 2021 13:13:57 +0100
Message-ID: <878s7un6nu.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:9b68:49e4:71c1:b7ca:b595]
X-ClientProxiedBy: ZR0P278CA0065.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::16) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9b68:49e4:71c1:b7ca:b595) by ZR0P278CA0065.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Thu, 11 Feb 2021 12:13:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba2a9e50-fad5-4a45-f8d0-08d8ce86836d
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3520:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB352028CAF39E1B228FC195C0A88C9@VI1PR0402MB3520.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xWlUH3tw2E0t9++nXzuuJlq26P3F6c4T+WMpf+tFaaDkC6vkhpe2y9bnmEMpAwC/yZDohSgEYLRtM6lWJog78JblfyzPzZBe+ke1+u1p7yYQgH7iJkzEm3F3DsihiKBZGao9A2kDfy8IAENFRbCS9aWW30M+/fW9k7eubWUHZ755p3htkKuw4POcTLm4FH42NuGCGUn65ID22rGMC/r3f5Uc91QpfRFnuSYnTvbXxY1YPxEm1val+wFcq8FLyiK0TfJHMW/xbVj1ynSik66TcfwZepqrf10jMa8BGm/qLSY8kx3WOb4LHyVpfk+KRO06NwABA1WLF3N9YdYgObxitkJXh/SfXzc6B/JBuxyIT7w29xlGN41GY87cWDl3gsYBvHEgGulLnVOj1QBlIiFpQ3dhOcc55V/G+RERJ+I7VyO0LmL/galYPWZuz1pk5xdF8U8tCWLR4ZEHwpA9YT+JqnfytywneG5YP+4OMC7ro2ZYUkTi0OG5fsvDxd7pBBHve2ADCmW8GQ3nFPjEXRDPcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(346002)(366004)(86362001)(6496006)(52116002)(5660300002)(478600001)(110136005)(2616005)(186003)(4744005)(36756003)(66946007)(8936002)(6486002)(316002)(8676002)(2906002)(16526019)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?N0pZYytWMmtzTllSbEtTT3BQaVZSK1djWExoT1ozYTkyMjZpcGc1TmdXQzIr?=
 =?utf-8?B?ZEJvaTIyUU81eVJ1MDdWY0tsSzZMbmdRaVRUUWJLWFVuV2NBS3J1MnA2RkJ2?=
 =?utf-8?B?cUp4cFVEM2o3V0d1NGl2QU9jVWFQb215dkhSaVVzQlFjMDFlRnVWbm5lM2F0?=
 =?utf-8?B?bTZZVWFyMTdseEpHNUNMZXNRMk0zM1M2RVREcmNGWlgxcTI2cUhIaUlKSGMr?=
 =?utf-8?B?N3IvNk1yY1RTVEE2YXJ3RTlaR2lFYXFuSWs2VFRTSFlmbllmRnpvQnVvNHl2?=
 =?utf-8?B?d0VGeElFbWlzRmVOQ0IxanlycStzZ1pJOHZMVmU4UzAvSFpnWGNNcDlKME41?=
 =?utf-8?B?eVB4ZXUrQmhaQXpHSDA0bVpJMEFDYjk5RDdJM2w4eDdkMklxbHkrRUgxSEdu?=
 =?utf-8?B?MjlQZk9wYUl3MXJ6bmpabzB1Z292WXMxRHhxQVdGR3JiV0lSdTY2RE9pbFdo?=
 =?utf-8?B?NW13STc3YXVZaUF0MDljcTdmL2ppT1VwRGduR3cxMCtxNUVBQlBNZTI2eWtN?=
 =?utf-8?B?RXNJR0ptVTdYREY3R3BnaG5JbEltZll6WlR0cWU3bFdCSTZ2ZXppdTg0MVpr?=
 =?utf-8?B?U0IyMTFlalVRMFIzQ0ZNZnIwVXpqdU5GYjBDeW1YbjNMN0RUNzRSZEJtUkd6?=
 =?utf-8?B?QkJHc0kvWnNSejNQK0lVVjZndUhKSnBLMFMvL3dzQVZXWWxnY3N0NjA2dk41?=
 =?utf-8?B?YnY5blh6ZUNidVRtRHVwLzhLNjBVamNOODJSS21tcXpLcG9yQVhucCt2MHZU?=
 =?utf-8?B?ZFFoWlhicElLYTRhWGE5NnpBR2xTbE1WWFFhY3F0a1UvMVRVUDJIUVg2VnpS?=
 =?utf-8?B?c3p0VzRwemlPR3JjdCtrVTZsMXU0eUEzWlpYdHNkK3hQenVqbVA0RHZLSzVB?=
 =?utf-8?B?Sk0zRGcvb0ZCcVkzSUg4enlGWjlzQXMzWi9XQ01HNFRmd2h6NDVJemIyVVVR?=
 =?utf-8?B?cXBXMkZ6WlZyY2lwSG1LaFBucHhSUllOcUF6MDlwdnQ2N3hlcE5yMXdoTE1L?=
 =?utf-8?B?cTFjenh2aVZMbFArMk12TFB0bHMyMTcyVlorTzFmMWk4MnhweTlud2dyNFFk?=
 =?utf-8?B?eWVTM0d2Q1BtT01teFFnZjg5aFk5VkRUNmRtV0dhTmYzWHRjRWZJMy9lMEpU?=
 =?utf-8?B?THJ1L1AxK1dnTWh1TUJabGhSaTFSNDAyYVJBb3FPT1pzMDJ5NnVoWGxWUTMv?=
 =?utf-8?B?RENtc3ZuRXdOUnZFRTFEd0RqM1B4KzhvQ3JLL2RRRE5PRTJDTGZZTi9WUkNl?=
 =?utf-8?B?SjFDRGZObTNHcStETVI1Y2trVnJMdUpwU1ZYZnNPN0F3a2sxYnoyeE5yWUlh?=
 =?utf-8?B?dmVwK01pa1hBelcwbk4ydVNyeUNJc0hmeVVtOVE5OW1WQS8vek80SlVTakQ5?=
 =?utf-8?B?Ym5UdlJMYmtWVVJUdmdNNlAvVTJmYmlXdXRRcTN6bEwvaHNoMDJYNG5hTzJl?=
 =?utf-8?B?SkUyMC9tclFQMXNOMDVtdVhEeTZDUkQxNXhqa29RVEVGZlUzMFYyNXFEd0pF?=
 =?utf-8?B?SGlUc2FuL25lWGhhaTJVYW5IL3BVYW9aa0EwWUMza01RU1QrMnE0MUwxQ3Ru?=
 =?utf-8?B?Q1V4VVNjRUs2cUFDdlE0R0YwWkVEcm5mT1VXVzM4ZG0zeWl0b0VhcHNRN1Zt?=
 =?utf-8?B?VGkyTHI1a3BzT1dEVG5JbGlvU2lmRzdkNGRlWVkxUGM5WUN2MXlnUFJyY1c3?=
 =?utf-8?B?UllvYkJZRnN3bDF5QlZ1VERpVGt0OXNyRFZZVzNFYmd6SCt3TXkwK3lncmxw?=
 =?utf-8?B?aDFRYWlBRkM3Z25HanYraGpUbnA5YWpoRi91M1d3ZjNwSGVCY0lYWjdFUjIv?=
 =?utf-8?B?YjZ4dUhLSGFOaloyT1ZJbExObllhdk00bHB6RTBuLytUQ3YwbXV6K3ZMekN1?=
 =?utf-8?Q?dGe9xoO+rr2E1?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba2a9e50-fad5-4a45-f8d0-08d8ce86836d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 12:14:00.0156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yW+gtRO2H1L5yJDxM79FWfJTwY3G0UqS2BBenF4oRVGAC/VOMg9i5tqscxGM4iyx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3520
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:
> Please let me know if any of the above assumptions are wrong, or if
> more needs to be done as a part of this fix.

I think that's correct.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

