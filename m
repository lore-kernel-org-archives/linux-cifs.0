Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44303C433B4
	for <linux-cifs@archiver.kernel.org>; Sat, 17 Apr 2021 10:53:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 198CC60FEA
	for <linux-cifs@archiver.kernel.org>; Sat, 17 Apr 2021 10:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236104AbhDQKyM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 17 Apr 2021 06:54:12 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:51366 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236009AbhDQKyL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 17 Apr 2021 06:54:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1618656823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EQhZsK+vEUDc2t1aqTICQHERXV6sMiCkmgDu0EwT0tA=;
        b=lBUKEQw7VtlcI6CtkDiJWBupEJKwHhrXLNL2F80IR/WZcjWUy3PmG4/+XI5wycb0rVowJ8
        s3vufbmJ31/p6M7yQ1SJf0XlVjD5olkN5NDiKVS5jUNWnZEo7u5yi3juIJyX5tkHlSd4LW
        m0Fc1TwOifowZaZxZcbqOVnkvuoKXMM=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2058.outbound.protection.outlook.com [104.47.4.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-36-uB6UyVdVMwuDhXcmDHw84Q-1; Sat, 17 Apr 2021 12:53:42 +0200
X-MC-Unique: uB6UyVdVMwuDhXcmDHw84Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GqjRiLgnnvW+ZXMFoWdHend/Fe8XVnvOKcNh31wuBcitz/RD1hlaf65vfutn9OJun/NAfoDo+JKN4r7F0B/qwpmCUa1XIvGvh2Jo06MUlTynUpmO5doymI94gQHuETw3Motfk0OWsJxjAJYDR6kxU8XpKP2VtudNG2IO8leoqXZ51GOfZhkSmOC8KARcyw/tkTjPSl8RHsQcroELz5y2nW7+yqsjQNtFAiGB0W/YYdE1okpU2EY35iW7he2fNHLO+90XJiibp+zxINRtb4yXiFzSa8YrwJ8XCSbc2ulbvM64Z/qNKQ39DZU4zdwuKZEn2VxjOU4otyu3Dd1RX7APQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQhZsK+vEUDc2t1aqTICQHERXV6sMiCkmgDu0EwT0tA=;
 b=D3LwwBqsjrcuy4hzWnLH0GXWHMbeYSpeg3x/579LaM9I0bpOuXAS9WhBPGzfX9xk7fUtUaiDrPA8sgsyfUT0krKloZ2/0xdnKVNFSoX/90xQpGI9aTJsKzdQoutS6E7/ooVcTYSK4i7RVY86Djup1Njd0ol5gg4Y3OfI92fZIAsdP8KXX63nwdqjMAlUrhex9FgDLNVBahpd1ZKMYc5TWi/SUErVLiI8z+sec12aaCnvyWav2VPIzDpvnD5Ak130NJqE4G/hqrle4B1kgbeFgWLneY/xLtangTC5UsdQft3XPCLs9/eL1m1jxLa9dCBbgCgd9HKIZsxVcMbFWmhiQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0402MB3888.eurprd04.prod.outlook.com (2603:10a6:803:21::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Sat, 17 Apr
 2021 10:53:40 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4020.025; Sat, 17 Apr 2021
 10:53:40 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Muhammad Usama Anjum <musamaanjum@gmail.com>,
        Steve French <sfrench@samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        "open list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS)" 
        <linux-cifs@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     musamaanjum@gmail.com, kernel-janitors@vger.kernel.org,
        dan.carpenter@oracle.com, colin.king@canonical.com
Subject: Re: [PATCH v2] cifs: remove unnecessary copies of tcon->crfid.fid
In-Reply-To: <20210415152409.GA2286719@LEGION>
References: <20210415152409.GA2286719@LEGION>
Date:   Sat, 17 Apr 2021 12:53:37 +0200
Message-ID: <8735vp18su.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:709:9219:df10:b79:7ed4:bb5e]
X-ClientProxiedBy: ZR0P278CA0014.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::24) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:709:9219:df10:b79:7ed4:bb5e) by ZR0P278CA0014.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Sat, 17 Apr 2021 10:53:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d721bfdb-15ea-4fbd-f589-08d9018f0f91
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3888:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB388881CCC4469396941CE9B5A84B9@VI1PR0402MB3888.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VX9pbOZSv8cXtoi+6CeD/D6osnZMphScSd7artE3C+r52GWL33fFgQi/uMavApK58O7NV8QsXUmsxs4HEBMpILS17akBXgsfzuhzwFuK3oEUZCwJKL40kWJl/2JdNm+v9hIkZ2E0BFIIDbC2HJCoZwhNDP92/LWJsndRIAqeIfkJkd9Gk0Lw6aX/mm1OwGZz08zRNo/4WX2f9s2IckpxDM9fA/qB2IBtq4W9xtwCTWS8T63uV5DecnvgkJz4c8bvrMbDjfZRJnL0MaYq1d60bp/GAHKB0gkU052aNbmAz/2YCUXq5vYF5gBS5DqRsePvSOgmmHAI4tsBZlVrOsfW9yZLwghha1rGGoYRY+xMOpnvz9OlH52VCI2cL8OLuzzvF6JGOmFaeryL1obeqHUrKjlfy2noC/qmmCujm3gBjXoKYuTZqTUp1Ltq4tb3/ZGFEdATbkS1B4No4+S42dcJVfvXJzFdM5HjssFVh+9nDZxnsSHMtvqt32rXLLrS9MRQp2CFExrDsbFpgq1bgb+ha19GjszSwZTiVJziWLWe1AO7iKhw6Y4c/62WKZJejzVbCij+5XsShwQPZKv5UgmnIw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39850400004)(136003)(346002)(366004)(376002)(5660300002)(110136005)(52116002)(6666004)(86362001)(16526019)(83380400001)(186003)(8936002)(6486002)(316002)(66946007)(2616005)(478600001)(66556008)(66476007)(6496006)(2906002)(8676002)(36756003)(38100700002)(4326008)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y3ZEdDFyenVlR2RCMWU2THRSdjh5M05BTTJuSmlta1Q3WjJoL0RURHJ6eVVp?=
 =?utf-8?B?SkpJYkoySUIzS2RJejFSQ3R3Rm5NUm5UOWRIaEYwM0dyS0grVUZtdEZ5bXov?=
 =?utf-8?B?MWc1ZnUwUjBSZVZSK08rWTZrSE96N2p2bXMxd05tNjI1NXBYRHFnTzFzWFAx?=
 =?utf-8?B?YVl6ZXd4YmtacmpHNVpheGJrbXhZY2s3eVhiSkpWc3lHelRCb2JBSGNGUWhu?=
 =?utf-8?B?d2hCcGVKZ255ZVZzRVRJK1IrVnluanRLaXhGV1lRR2RlWjI2NWR3L2pFaDU0?=
 =?utf-8?B?WVAxaXN0d20zejBOeGZ0VVZBNzBKYWJWQ3o0V3VzVXlxaHplTkFaTXRuOVR6?=
 =?utf-8?B?eFBDWnc5QTREeFV0T2pES0lnTUgySXNvcFV3eTdpVzEvQnlIS1JGM3dRa2tJ?=
 =?utf-8?B?MlI4d3F1RmdPTmdnc0hjMVZteVVkZzM1REpCSktlZjBXdW1ocGRiTVYvbnRU?=
 =?utf-8?B?S1hHRWptUldUbmxpb2wzTGZ3UkRtM0VBTFBUUm9kMmVZeXd5OVJNcDk5cHBm?=
 =?utf-8?B?c1JmaGtHZVc3N1QyVlB3NUFVZHlzWnVwaTlQTVJWdk0xdy9iNFJUVEJUWXBM?=
 =?utf-8?B?dFAzYWx5REhyV1VGSmRZUnNDYzVnU25WaWlSL1o4d2JTelgyejRuSE9Kcm14?=
 =?utf-8?B?Q3lCY0VUNkhTOWIvTWNQblBkeHdqdWhwdkJubXBBeFE0VEhhSUhQZ2tIWFJr?=
 =?utf-8?B?TTdza014VUJKMzdMbmx3bFJOcW1uL1BvZ1hWRSt5WmxhYzU1MWJ6SUZlS24r?=
 =?utf-8?B?N2dQT1AvTzNraFQrUk1sMVZWZGJOS3NTdG9MSThkcnJodEF1RDFlSEpNdURL?=
 =?utf-8?B?QnZNZytRWkJTbWpxVXFwTFF6Ti9wUjd3aDFuUG01Mmk5UERmS0Vkc0h3MGtC?=
 =?utf-8?B?aC9aQnJuM0wzeFNGcnpwOGY4Z1VVNHg1SThTRDY0c2k0TVJoM2E2SEk2emU4?=
 =?utf-8?B?WE40em0zSUZMbjlPOWhUYTJhdytPRTNJVFFORVR2VVVrYjhiK1lVNlVGUWtS?=
 =?utf-8?B?RUE2ZFNWSml5ZGF3aG5HajFrZVRFSU1IbWhSaVFoUExmSkpnUG5BYjM5TjQ4?=
 =?utf-8?B?QzdWK0xUVjdtUnJYb2t2eThwYVNmajBVc1ZnanFNa2VqZTRaQi9oczJlT0hT?=
 =?utf-8?B?RW1za1BBMU1tdzNvRUxKZXVuRTEyRnFWaDFZcm5OL0J6aXlOa3pkanV1c201?=
 =?utf-8?B?eWlHdFpTcUJ4YWRSdFVaREVFV0lwWHBjM21jelU2TDNoV0VNZHQ0eWZrQTZ0?=
 =?utf-8?B?cHhycFI1eFZSb2hLZllGcm05Vjhua2c3N3NNMlQ3NTdUV0k1RUhBblMvY3li?=
 =?utf-8?B?WFpTVFk4SlBpNG44K0ZaWFZMT0sxK09MWDYrVVkyVTFxZ2J4RHhoRU54cWFW?=
 =?utf-8?B?MUJPd1dyTUJvWUdxdG9zbXBEUWZRd2tzdHM4NStHek9GOHBPRmlBaE9TUWRG?=
 =?utf-8?B?Mk9CZFZwSi9LSFZhd1dIODhDSDg0bTRmbzBMTUw5MXhmalZWdDhnblJUUk5t?=
 =?utf-8?B?blZaNEtzV2VFTjNQMUFqVi9acFFuamlXM0kyNCtJK210QUxVdTFGMjZkTjFW?=
 =?utf-8?B?YjBiT1RESWltOTBpZXBZWk5JaEJway9obkpDNEo2aDFrME5qZTNUblZ3WmE1?=
 =?utf-8?B?RXkwNTBsNUQ3WDF4QThEVGVETEx4UVp1Q0t3N1FWalg4SU90S3JaZlhkUm5n?=
 =?utf-8?B?VGR3bTNuK3JKZ1ZPaVM5VFdiQktTOWZkNDVNUEllYm8wZFFoME5lTjVnaFRl?=
 =?utf-8?B?bFIydE5qaEViM2xFL0Jvb0hoemJ6bk01MWtFTzdCZUNsL3RyT0Rjb2JwakNG?=
 =?utf-8?Q?rx4KrM5qqSDjgvQOlXXoYFUBM1AyeMDpdmLpI=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d721bfdb-15ea-4fbd-f589-08d9018f0f91
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2021 10:53:40.4379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mQfrHf8qShcUieaGdRdm9Cc4HSJasrRRaJDhyGZWDJk4eA8VnX+5mLfOKY7UMLwu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3888
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

This is better I think.

Muhammad Usama Anjum <musamaanjum@gmail.com> writes:
> @@ -894,6 +891,10 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on *tcon,
> =20
>  	/* BB TBD check to see if oplock level check can be removed below */
>  	if (o_rsp->OplockLevel =3D=3D SMB2_OPLOCK_LEVEL_LEASE) {
> +		/*
> +		 * caller expects this func to set the fid in crfid to valid
> +		 * cached root, so increment the refcount.
> +		 */

This comment is misleading. crfid variable doesn't exist anymore, and
the kref_get() here is because of this commit:

    commit 2f94a3125b87
    Author: Ronnie Sahlberg <lsahlber@redhat.com>
    Date:   Thu Mar 28 11:20:02 2019 +1000
   =20
        cifs: fix kref underflow in close_shroot()

        [...]
-->     This extra get() is only used to hold the structure until we get a =
lease
-->     break from the server at which point we will kref_put() it during l=
ease
-->     processing.
        [...]



When we queue a lease break, we usually get() the cifsFileInfo, but if
that cifsFileInfo is backed by a cached_fid, the cached_fid isn't
bumped. That commit was probably a work around for that.

@Ronnie :

struct cached_fid is starting to look very much like struct
cifsFileInfo. I wonder why we couldn't use it, along with
find_writable_file()/find_readable_file() to handle the caching.

Alternatively, make cifsFileInfo use cached_fid (perhaps renaming it in
the process, I don't know)

Because I suspect a lot more issues will come up regarding cached_fid
refcount and cifsFileInfo refcount going out of sync otherwise.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

