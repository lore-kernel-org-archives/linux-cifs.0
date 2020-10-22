Return-Path: <SRS0=9w6c=D5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E1FC4363A
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Oct 2020 10:15:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0EDA22248
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Oct 2020 10:15:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="EEIC/Cr1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896438AbgJVKPa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Oct 2020 06:15:30 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:46630 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896412AbgJVKP3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 22 Oct 2020 06:15:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1603361726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P+0y1WNEma5hgL9mDETZOkST2hs/DZhKu47TPUVDB+E=;
        b=EEIC/Cr1iJi/33TvDWI6BaAhVWSlmcR/mO1WS8IzY6GX+xKQiJk6IWmk3rgF7Mnzg8XA8z
        GbTpvr0zSnjKznjPxKqipoHB9pHIZUaHM+xbjMU2jDEr7uS+Ff8V39ZaE8OzMol4yagemp
        qABNjZf4+Nt33in0gHFZExiJrUEDVcw=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2059.outbound.protection.outlook.com [104.47.13.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-16-HWZytwdmNcS2f1tdVe__eQ-1; Thu, 22 Oct 2020 12:15:24 +0200
X-MC-Unique: HWZytwdmNcS2f1tdVe__eQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bCSvgAFJvJpgpTkaoCF+UBZYn5LGVhasy01LgxlfqYtGaJ/AD8cCeGb1VUqaibOM5Ei+SbSCz1pvfMmyp569V6afcnlO48nutNB5lQTuakyrGq/0Ro6O36Qj5XCj1CgKPuUC6VMcEfHKemrIeVvrCGwb4AEY8GlMgOYxJBufTvC+0YLpkCUxT702PeaZTW8zvbQFeeGayOcHRKKoDyFdh50oNaaraPyBdzynZl1iFk13y4rsR5d12plXoMrsiT1QJNoDwc0Ua/FNVXLSYLJZUMwdWBoAxBdDQQjocXmV4HRpL4NPxWBOf/JwGyHFDWYHPtk9190KBauAkhOvlgcEKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P+0y1WNEma5hgL9mDETZOkST2hs/DZhKu47TPUVDB+E=;
 b=InJId7MZMSt1ylEMPx54YhbAiOgik1h2mNv04I0BjQ9B4SU3157VqRvfV6RlFQH2ZYzbN1W0lmRIu2zmoK1VbeoDQ90aD2wVy7lEGsWMZQVnlKcVsNQjNWEzmUD3ObPEvmJTCIJVqERV4uyaxnSYWmkflnu0xIgMfwdKoXO+r89id2feJksWzoPudjgmwXbmuvbYLhG54T8Se3uYgeZCVX5oX1aoONP8QV2VrUr13DIr0yFkps9VIjLRUQX/4qP0Wk8LSpiKfxk6Po15IGzXcivdqEKegFd2uawRNQlogqPVic+WkIM0GBHHovXBPyKS8K3abP9mIkN7E0uUubp/qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB5760.eurprd04.prod.outlook.com (2603:10a6:803:e6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 22 Oct
 2020 10:15:23 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::e01c:2732:554a:608e]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::e01c:2732:554a:608e%6]) with mapi id 15.20.3499.018; Thu, 22 Oct 2020
 10:15:22 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: Updated cifs new mount API prep patches
In-Reply-To: <CAH2r5muuy22vvUvJuz8njz3ymkign0BpNv=Xgj6jG7zqXhAZmA@mail.gmail.com>
References: <CAH2r5muuy22vvUvJuz8njz3ymkign0BpNv=Xgj6jG7zqXhAZmA@mail.gmail.com>
Date:   Thu, 22 Oct 2020 12:15:20 +0200
Message-ID: <875z72woqv.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:6807:8347:7696:25d3:a22f]
X-ClientProxiedBy: AM0PR07CA0005.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::18) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:6807:8347:7696:25d3:a22f) by AM0PR07CA0005.eurprd07.prod.outlook.com (2603:10a6:208:ac::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.9 via Frontend Transport; Thu, 22 Oct 2020 10:15:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3dbedb1-e431-4231-3fc4-08d8767362e0
X-MS-TrafficTypeDiagnostic: VI1PR04MB5760:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5760E1E7D830A58039FC7685A81D0@VI1PR04MB5760.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xEXEWjjr4P6URt2NhmLKFDp/iA+Kj9VQBLRyOAnjgGoQca3tSS4Da23mQH+JEkQJKta/7YrYAkD0IR29UW4OlrQ3H/Wm8bVOuSbLQ3275C4lePC0V8M5s+QPyo2Hr/0sdqqNTQ4oU1lJWGvQ9y2fwfXMuKV4RQ3uvo1XvggW4la4LeS4wyJmot6nFQuBVGsTFiDA5UJAi1Gl2hzKIcyR1jM8DhMO8GBZbYUzxGyhmtmFvElGBXi/NukBrDlLybAnRGaysu/ruAjHx2Gee5LvpFenAqWBUIDcOfeJBWLV9SYhWHXl5Szab52dMP8DALl4Pi10eXFo0r6YIs74SsYVsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(366004)(39860400002)(136003)(8676002)(2616005)(36756003)(6486002)(186003)(316002)(2906002)(16526019)(8936002)(478600001)(52116002)(6496006)(66574015)(66556008)(66946007)(66476007)(4744005)(86362001)(5660300002)(110136005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RPuNeMBBSTYuO4hEj3EF922nFDtn1c2ZHxREYurGIMHHD3FB6Y1Jua03lrF3HsUCU/rMraAmVqf0uBJ8RXdidoj2eYFA4Nwj32G9byi0aWcpWruHOBLwqQiQ/7lwru61MsfL47TE6cBIQXuk95z2od/OzTEGZMn5GpcyApbCsLNFypBfWyDfiIUB2SDAiQGqMOz7S75EF+bBlFxBGJ+gc2dItBp21MdfccYGVRkMmcYJLFTfCH63eaDc5nX397W3pVIXAHnoK2Y/04/FfYp6jXXizhI9z55OVMtvJqYe5kVZhOjLi5JNRJu2hfRUTEYuJlyBO775Aa0Tx+WYXTqh2UwBEhX/kxuLNlVMsGzzTD2doBXHOvVrocZRW4r5ZmL64w/jjaXoyJfuS4sdE5pDL+T6WjtWWmIkzkYy2I38oVmgNXYG1naZSrSIqrJGIIa2g056cnuirohmIRot0amPZOZfndCrG/xLPkX/Ij9oy5JC6WSDT3H3ItTHGAzlu9EIVklAJ6YYwJ3CNXZMM4jLWgruk/1fS44J0YaHg5FtVYvzY8gFZvXfbjrMYwhRJDTDNB3o+xqK3sY6CghlKNQHfW2WEoX8D37b8PfyygEdsiId6920l2cq/r39Amy2YqLp0wtiRlfc9w0eHGl1De7HkOj/sKKJcFVumUvMCIemMmTyvlyWZVLS6npFAiXoN1W4TPil6C/wB7b2ee3mVRM/rQ==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3dbedb1-e431-4231-3fc4-08d8767362e0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2020 10:15:22.6754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vrxf5ZXNMMsp2eRP6aEkjD36h7D0o/7gGAfHlXeP2zOGMOfmX6Gm/BOk4AQlCwHV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5760
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
> As Aurelien and others had mentioned, shrinking fs/cifs/connect.c by
> moving mount related functions (to fs_context.c and fs_context.h)
> helps make fs/cifs/connect.c more readable (see attached patch series)
> but also will make it easier to review the future patches to move
> cifs.ko to the new API.   These are low risk and will make the mount
> code easier to maintain. These four don't change any existing
> function.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

