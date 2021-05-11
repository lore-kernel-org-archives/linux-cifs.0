Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7771AC433ED
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 16:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 417FA6117A
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 16:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhEKQdX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 May 2021 12:33:23 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:49097 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230315AbhEKQdW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 11 May 2021 12:33:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620750735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BkcsnhlbiEwihx1Y/MkTscxX9yrG72E49r/oLeR6HjQ=;
        b=hAdVAsi/N6N8mvsPs8JGUA6sE9KHApB4WLy2rJEj0oUiFMHi5OK1aGbIqmg005MJ0kmrd6
        MdwYg+IKlLK8nH70z4da9cps33gjVPgR790Ax8514O68u6HB89VwlGefLwOx15HMU+lKu4
        uQwxNh9AZqFws+yHlTGwaa5n8IXW/qo=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2175.outbound.protection.outlook.com [104.47.17.175])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-38-FvgdQ3jlMd-ge2zQkW3Wyg-1; Tue, 11 May 2021 18:32:14 +0200
X-MC-Unique: FvgdQ3jlMd-ge2zQkW3Wyg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WDLlBxVCQzKrvP01Bjb7m6Pw0SZU4ShbBrq+e+CUvYjP6IQbNBtVThGu8JZYxh1qw/7uxWrzWpRQib21PUZM9IqT5HhDli/kGAQV6DnHfogdDW+UXVN3tvcZSphHebUqdgOkysuqfDJuvn3lar5qnDyY2t/VKqoZCRgvKNlLIB4CUS09GVcahVTWejLtO38V9KF9ajaNyW1LTtIQrL/4xHemUeyzUh/Su/YpNQ+kunD25ppmGv9WxH7V8ZyzpUEyZpt8Evd4QH8myyfmcn/72p1qUTtRXFKbtfF13AIFtnGLZS8dnWSs8f47TCAmlYB+07hk0iNbQqWcuFSAKgpNAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BkcsnhlbiEwihx1Y/MkTscxX9yrG72E49r/oLeR6HjQ=;
 b=POAQeRTrz7hk88m7ExODw0xxiEYMnmZVYsW3dXNS3Q/3h2EdoBcP+MKYI0ngNf+0uHnhgO8bFk+2vrLbXK5Ad8wnHqm0wti9wZgLhv46JGXfPf65BjJvWs7PGIVPw84NLMdxr349A74Vwawr2qsgP3JHbZ+U4MpR/p9TEhaKePanoyya7uwR3xF+H3q+w7zu0IOcH8Ne9gLjT9bhF1t4ivTS5F+2d6S5ZAPCtIholm/5uFvPDVJn73Vxd6EDPw3WJEeLlxIpi30oYzryuf2dA9NUdoQzdEu1qTXj7cqpRHrlIFwJVxPgTj7UrtKaEnBeCTg016oD0xndK9yfKd2Xlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gwmail.gwu.edu; dkim=none (message not signed)
 header.d=none;gwmail.gwu.edu; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0401MB2400.eurprd04.prod.outlook.com (2603:10a6:800:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Tue, 11 May
 2021 16:32:12 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 16:32:12 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     wenhuizhang <wenhui@gwmail.gwu.edu>
Cc:     wenhui@gwmail.gwu.edu, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Signed-off-by: wenhuizhang <wenhui@gwmail.gwu.edu>
In-Reply-To: <20210509233327.22241-1-wenhui@gwmail.gwu.edu>
References: <20210509233327.22241-1-wenhui@gwmail.gwu.edu>
Date:   Tue, 11 May 2021 18:32:10 +0200
Message-ID: <875yzptenp.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:d359:b215:6aa5:3693:e486]
X-ClientProxiedBy: ZR0P278CA0075.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::8) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:d359:b215:6aa5:3693:e486) by ZR0P278CA0075.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 11 May 2021 16:32:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25ac8358-8e52-41c3-081c-08d9149a5487
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2400:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB240022E76075FDACE4B20BF1A8539@VI1PR0401MB2400.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: raiYDMbFWPhdrEKpsnXl9ArXEim92h8OLQbH0qvsPpANxTWlM0YmHDIHDfFqgyQnTYjtbI7GIIzO/ITpTrs0N/4kVAsii7xqco4L69zoIdOVixwqw2Gk7ekjmYURkylDmkC1obYMtAMKIX50RL8M8rtA0Udy2j2p72hzmNJc3eKC9/KmaZPcZBRLn6DWTm43tzUVaai/meiHABs/NGZb1OsvHMmxHxT4h3M1OpjKw2+MK3eSoRkKPZmNoa29rG16I/lGSUSJweaqFRpj5ZivIyR/UqQEoGo+cTdrrRvCTuJeiFdWbHrdbPrrecuSiO1k1bx6rfPPZ4lbXg1RxCnlCLh5UtnyWpwPU+lgAlReIpTTEqjdUfr3xmAMs7LzzbSV2ixx+YJBFGQU2mA0Pj9iabkcwHSKwLiWTR+qEnLVcWWloslPgXeAmOyyf0m5/f9czO2KdVhHLkL4pT4ihJK+SoKyrcZ8B4c8AUC85ievjOQGjUElcXyIydAD1p/WLUfpkOgVQ107P2DUCwJRZClgkw1sg6+DFUBju/pKt/1kN6mI1VeER9rrLY2dgq5shARQ5ipzffbt+a5eOlBSlLeKAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(396003)(346002)(39850400004)(36756003)(4744005)(86362001)(16526019)(38100700002)(186003)(316002)(6496006)(52116002)(66556008)(2616005)(2906002)(66476007)(4326008)(66946007)(6916009)(478600001)(83380400001)(8936002)(5660300002)(8676002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cDRubS9MaWx1azhBRGVycEQrMHo0Y1VaaTFDL3pPdkFIdTJXeWh5aUJ0bHZK?=
 =?utf-8?B?Wk54LzEyK0pHRmtoQ2lITlFhRS9pQ0JzQm9VaDJRYXdwTmROaXdKRSs2R3Vq?=
 =?utf-8?B?NnFza2UvTWsrRDUxR1pFaTY1ZmlTTmVQZkErZTdpQVNuN2c4RFlkVnlSYUx3?=
 =?utf-8?B?emJjVFhRSmZFa3VKd0JEaVUydDhyeURLSGMzcHVKanlwajY5bXVVc1hIdzh1?=
 =?utf-8?B?d3hianJuZUs0dlJtcFI0K2FJbVJxckh6RVVVZ3BuM1BrWlBmQXpjWE91RGpa?=
 =?utf-8?B?SndMSXdnVGFPcmhZK09SQkdvTWovb2dPU1A2bG9pVHRockZacGtxWEpsbmQw?=
 =?utf-8?B?YzN1cHRJNURSZHpOd21xYk5tbFB0TzJabkVNU0JBVm5RR0ZBUmRVcGFlMGxZ?=
 =?utf-8?B?SUtCMVpZU0lycm9BaWdjYzNUYmVraGVpNW5CTHFhWmk2LzhIbTRzcG1yQnVs?=
 =?utf-8?B?aDNvQWw4RnRzaEtHVlFpZDdRZEp5anI0YmZiN0RRZVVZMGFtUHBBQTVKN0E2?=
 =?utf-8?B?d1U1dVdFU2Y2dEFvV3RHWmx4d2hSZnNxcjhDSmM1OW1sNDc2d00rTm1TYTV1?=
 =?utf-8?B?VWZNMlNPNm56d0FseDA2OHdXaVc0VDh5VEhmL2VjbkIrSlg1YWN6V2F1eDZC?=
 =?utf-8?B?cnZPY2xXMC9FQzhqbUpqT2VMcHIzRXR6Ri9lVk40YXlQak1vRUhVQ3BSemU3?=
 =?utf-8?B?ck4wT0FYeWE3WWlSenlrbHBURG92UExqaUVnM00xaW5qemppc1dBZ3FiSVE2?=
 =?utf-8?B?SnZFdG8za216MWRsMmNnczVrMitwT0VUU0VybnRPRC9kMGJkQy9nY0NnUnBl?=
 =?utf-8?B?L096bkJzY1Yxd0k0NnZYbUU3eVd5Tkd5Zmk4Nm9QM3VYVDVzQThrKys0THpl?=
 =?utf-8?B?elphUGVTT2cya25aNXZNQ2RGTS9YZkJJeCsyWjd0L2JxOVJFamp4M2tNWVNH?=
 =?utf-8?B?QTQ3REdDTUZ1VllaZC9hQVFiOUtxSXV4c0NjbmpjNStzWm5FQTdnSmg0THVp?=
 =?utf-8?B?L0o5YXRCdnlHTy9RZUJZNmNwSmd0WnBlME1ZSmtqUFpQWDdaSmJNV0JkYVdK?=
 =?utf-8?B?Z09BZEpHaG5PVjlzNHFwVEJhWm9UMUNIS2xQRlNnT2x4aFZhN29KNDJCU0l1?=
 =?utf-8?B?REpTRVV5YWZWN1FqOTg4K1ZYdXVVMVR4aE5zU2NQckhRRXhYZERJYVgzYVZ4?=
 =?utf-8?B?bmRleW5kNmNqZ3RwSXZYdk1oVzFzRm84ZXRSOW1mSGV3VWQvaGhzMWRWSFVw?=
 =?utf-8?B?THZxQUtGZTgxT3BLdm5XL3dJTWJCdGE1ZE1nSVVSOGZNbFpjUFZ5blByM1lt?=
 =?utf-8?B?eTZIOVh4cm9rVHJCTW9wQWk0V3lxTzllMGRVMVF3Wk1DMW1QdzNzYnRxTEVH?=
 =?utf-8?B?VlFvVGI2T3VVWDc4UCt4YTZ1MEsybFF0Z0ZjeWhCOUJuUEJ6WkQ5MDdpMXVU?=
 =?utf-8?B?WXRKOXh4bVNwMk9OQWtsMEFXQXhVVmgrdlBPcDNPaGhTb1FIOElieGwrRmxV?=
 =?utf-8?B?eFNkOWRXMFh6dlZCM1M1ckVSZlp6dmFnWVN3SFpxV0dzVjdtckFjZXdvREEy?=
 =?utf-8?B?Z0xBWE5FcUlDeGI5aWduNW9HMFRuYXc3V01XTXlyNUY4SDJ0VnpIUHFBVmZo?=
 =?utf-8?B?WU94YmZ6aXBhN1AvRTJoN2ZNVmw4UllwdnNwYUovWDh0SmYxWEprK0kwMHNr?=
 =?utf-8?B?TjlVRXFDSFJRM0lUMElYTW95S0d6aGl2MHlpZUdEMjJEVHRSeFZHZ1JwbEFS?=
 =?utf-8?B?OWhZN1lMYjBNYjROL2o4NjRhL0NTOEZOWXFZL2VnSjRkVmhVcmJWdnVmOFBx?=
 =?utf-8?B?WEZGWjlPV1lYSlR0Wmo0d3VWYTZYYjVEYkQ5aDFPTVVJaGQvYld0dUUyN3Rs?=
 =?utf-8?Q?KpVL55Xq+iWdn?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25ac8358-8e52-41c3-081c-08d9149a5487
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 16:32:12.6579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i2oRHEmB/EfrY/hPpqryzo1cRZ5rtXxHX6ngn3alGcwwohDz+ckyoh6gVkUAXZzK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2400
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

wenhuizhang <wenhui@gwmail.gwu.edu> writes:
> Deadstore detected by Lukas Bulwahn's CodeChecker Tool (ELISA group).
>
> line 741 struct cifsInodeInfo *cinode;
> line 747 cinode =3D CIFS_I(d_inode(cfile->dentry));
> could be deleted.
>
> Signed-off-by: wenhuizhang <wenhui@gwmail.gwu.edu>
>
> cinode on filesystem should not be deleted when files are closed, they ar=
e representations of some data fields on a physical disk, thus no further a=
ction is required.
> The virtual inode on vfs will be handled by vfs automatically, and the de=
notation is inode, which is different from the cinode.

This looks ok but the patch subject is wrong.
Also the signed-off tag should be the last thing in the commit msg.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

