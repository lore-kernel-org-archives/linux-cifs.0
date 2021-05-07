Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E459C433ED
	for <linux-cifs@archiver.kernel.org>; Fri,  7 May 2021 13:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC4A461401
	for <linux-cifs@archiver.kernel.org>; Fri,  7 May 2021 13:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbhEGNeU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 May 2021 09:34:20 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:53156 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234545AbhEGNeU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 May 2021 09:34:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620394399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GZuhxbV1BvN0SJcnHn6jAbUGtHN8N6f3S0dRs2yKMaY=;
        b=JAj9bnmOZNhaCZU+hFHOtX9LuQ0S78e3P+fi8Gy6+dIS3lPd45C+ThL9Ad0JARhl66p7r5
        dwMzW1VtYQlnPvMioTc4pI047pb8meYW8q4cwCTCYtuRoOoS1y8NAkkCSTkdlxsONR+v0F
        KBE1SR2p/H9dnT7VOubpTk0iwzoC8p0=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2051.outbound.protection.outlook.com [104.47.8.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-23-ln2_xXrAPMGaG2_efqQw7g-1; Fri, 07 May 2021 15:33:18 +0200
X-MC-Unique: ln2_xXrAPMGaG2_efqQw7g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GusUmc2b4MsnUyrDJrOH1fHmLdTBnOaRQ8qUYBXVrVq3QqWpFDOLOJ6duXoghXehBWwbpx7VHYRULhVVNc1WCRlqpgmMf4QF7VFP2qngx8BQ5QW4ajPc6QLp7zTHp2DXAF3QQ20BQr7lvrEbK66bV1UJdgaSLx2wPR+SsHec9p35wQBfG3KiHd20hP/BmYC0pS8T/WAc2ievql52E0/ARbF59+ihxrnU1Ci0k/N5XMScxEDtVhH1K7xS2TdaD9qjJq2JAwa+6ScHLQigExl1aI5KyC5gKacvzSSfdEdDW4MFgMGxFRkQmVmH9L0rgwW6iZanW4S3aJ8kMHUJPmH+BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GZuhxbV1BvN0SJcnHn6jAbUGtHN8N6f3S0dRs2yKMaY=;
 b=fgcZkK54UBUYB3vOu3w7wwj1ov582wF+rouz3Bqktp2MQ45+Ub1CJBzasgOL8PKCLeFZ0O8j+sXtI1J+o7bx5OA3HjNwLoazUOlZQrThd5hKpid0ljrO5iXpp1y1a1qBev2lAQk8RB9O5JKnPVCTxMS8h5p68/p2Bw5krqNeCdSmil7VJWqZd/aec3RW8k6j2oTROKI5G14bQlhQOjuhBd9cofVyU5XqKGkDjPqE9XuEXHTotqz9TOvOfgaW4DFnELHPp6JV6qnseXAc0YuhWFaDxSOW5X/KH51VL3g10btr9wAId0Nfn/mctt9rnGpjgD8acKBl/A6YKIH7puiz7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: samba.org; dkim=none (message not signed)
 header.d=none;samba.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0401MB2383.eurprd04.prod.outlook.com (2603:10a6:800:2b::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Fri, 7 May
 2021 13:33:17 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4108.028; Fri, 7 May 2021
 13:33:17 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Stefan Metzmacher <metze@samba.org>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        linux-cifsd-devel@lists.sourceforge.net
Subject: Re: [PATCH] smb3.1.1: allow dumping GCM256 keys to improve
 debugging of encrypted shares
In-Reply-To: <87sg2yu18q.fsf@suse.com>
References: <CAH2r5muN3rpUur8jSav=fJfnt_vuJhgOXxMeGmXvT3KvxbBU5w@mail.gmail.com>
 <c2b84e56-87c6-469d-c272-02731cb0937c@samba.org> <87y2cqu9as.fsf@suse.com>
 <2e20d5e9-148b-dbb2-9fda-50521be46fa5@samba.org> <87sg2yu18q.fsf@suse.com>
Date:   Fri, 07 May 2021 15:33:15 +0200
Message-ID: <87o8dmu0ro.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:a615:1bdd:6a41:a7f2:21f0]
X-ClientProxiedBy: ZR0P278CA0056.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::7) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:a615:1bdd:6a41:a7f2:21f0) by ZR0P278CA0056.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Fri, 7 May 2021 13:33:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 569808a6-a1d2-4826-273b-08d9115cac01
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2383:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB23832F5B82C703833BC5376CA8579@VI1PR0401MB2383.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1bnp2AfaqEHxy/0+AaDoTmwbMvH4sxU3654mRVBVL1lZhbsKcqoMmhW1rzL+m18DY5pfd4ddfvu1WG3HUCsXcUzTvFO94PKNxEi48LJH3JgkWyP/nEt+d54EyshDq0roufaPONlDTDowZFOZ+1dD1MI4k1sS+0n2kkfBw6iP9S0V7izih08nSKn6QuN18LJY1uz0+eosUSAyqvVLTnxRv0w5Vm2xfYu4/IKv5tT1/l0Vmwa/M1p5k7wHbWZmOhvF6grk5+S8BAGthMQqBYdC8LixWZ0APe8gY9TvP/U36EGwgXWcvGartYcrP6EwVUXVPYjJy+ozxJ0fV3wShRIC2nnYh13QT+DcuXnlf9nBhhrKDAPO06Mc7QB+OsQHLllQhXijgfJurHCPqTiXB/OIeAfReRV0/GmEuvK7XplEGLY6vezj9mCEiTpLgnlm3/hptoaICw41mOWXgbqiinFm3RsTfB4kAbCUT8YCDN2ex8OTRhfhpJjLgojDsCwN5eLWDyR2/5Yq9xcN02Kzq2HQEkGG2yMFCiptFHxj78eMGdUn5VlPHqDjhQab1xmOqp2eLgt1LD1wOasAN2/yF7ev0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(136003)(346002)(376002)(396003)(366004)(5660300002)(86362001)(16526019)(6496006)(52116002)(38100700002)(186003)(4326008)(2906002)(6486002)(2616005)(66476007)(36756003)(66946007)(66556008)(478600001)(8676002)(8936002)(4744005)(110136005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OUE0aW1yQm8xTHdORTVIQW0rS0FQNGczWXVkaUpjdmVaTlA5OHYrSTZOZ0Nx?=
 =?utf-8?B?MTh3SS9qVlcvQ09hb3lvZGdUTUZ2bHFvY0Z2V0dQeTZLYWpZMEhnRWxMVndS?=
 =?utf-8?B?ZzEveE1mM0lJYWV5SVhqcDBUTEJUR0xxUEl2QTNkY1hLcG9Lcy9SMHdrZTlC?=
 =?utf-8?B?Y1Q5UXRWK3hiZms4dm1FZHYxUndpNS9veDlwMTNrTFAxS2dlOXNKSzV1RVli?=
 =?utf-8?B?NUFnT3RTNzE2OUxDR0JoNE1maW85SS81bUNob2ZKZkRjWTBFdkM2T0cwVzln?=
 =?utf-8?B?amFuUjQzT2ZWVmhscUt3cU03OWo3WkQ5Z1RzWk5zTXhNOXNYWlZWRk01R2ND?=
 =?utf-8?B?Uk1DNmRNclFXNnJCUWdndGNYdTgySTdETHpCcFRuby8xZTltZ0d5S0hVc2lS?=
 =?utf-8?B?K3djVmFtYjNDdGhqUEJFV2Vrd1lwWTc5T0dSazdGZ1hyRGl2UTdwZ0Q3WTdw?=
 =?utf-8?B?eTE0c3l0cXplQVQzSllvV2ljYnpab05pQTkzUG8zWHZhbDZJbDBhejdBMGQz?=
 =?utf-8?B?MGpsa3diVzN5elZqaU5NSGhkSFpSZTRhS1FSZjhwYzluSE9DSisyUEFFWmlS?=
 =?utf-8?B?eTRZcUthNHRMNVU4S0xDV1lJRko3Um5QQkpMcW0vcllUc1lNNG5ORDlWTi9n?=
 =?utf-8?B?dXQ0VlRwSUp5Qkt0d0w5Z0V4N1Z0UXlVQzlEekVVTnBMdW9DazZ3djcySkwv?=
 =?utf-8?B?UXhyOGpCTEFwcmo2Q2x0MWxVY2I0Q05zSUtrM2dMdnFWdDlwUGhiYVArRFhS?=
 =?utf-8?B?V3VNQUxySlFWaHlBeGZZYm1OeVpFMTREdEVEc2EzNTJNdEV3OXBnWGVLaHdQ?=
 =?utf-8?B?U3piV1dkVnU5cjI2ZEZVUkpROFhwNFdDaENGZDB5bE5kbjhHdisxR24xZG8x?=
 =?utf-8?B?ZFM5ZU5wN0g1RjRLSVFDRVlEdm9UYXh0WHN6UG1HK3JxbUVwMWFFNmI4Kzla?=
 =?utf-8?B?Tk1jN1JyN0xZSjIwVjRDd3lIZ1B3Si9yQlpETFNWR3dwZCtEalBZUjRSNnFw?=
 =?utf-8?B?R214YjVyaTlOL1dydE5RWHNLajdVbkhibFgrZ0QyVkttbGZWRGZhK1ozU014?=
 =?utf-8?B?Z2EzRnUwcUVqVitZRXBSdGgwSVFZQjN5RG9EaHBYY3ZMNUhRQ3RwRG5UbDZL?=
 =?utf-8?B?cUtEWGZWSnZBdFp4QW53akkwMWVHaFc2NWFRQjR5OEIyaktVK3Qyc0xIL0Fv?=
 =?utf-8?B?QUdlcVUrSG9hSDlSbDdDMVp0WURMWXNnc04rOEczVHNvYUZGODh3Vm9wMW1M?=
 =?utf-8?B?WTdnbDFlaHBKZko4M1pETXNXUVMwV2NvRmpoWEhDSzRySHhpU2tDT3QvUDV1?=
 =?utf-8?B?dVBISWpvdDJMdGtZZ3NaMUtuMWhYdGJqbHFFYWV1Y3lKM2hyL1VYN1VhRWFh?=
 =?utf-8?B?Y2t6Y1RlTnh5VUhtN0dZQm9nV0thQWRsanBtazl2T3BZK1pxck9YMXVycmpo?=
 =?utf-8?B?dVpBdjU4a1d5bmdCa2lQNjdaanVUeGtLVVZZOE5NbzBkblZSd0Y3bWk0Lytp?=
 =?utf-8?B?bkVLM3JZaURNdWZMSFBndkVQL3QzNEJ1cUJKSm1xL0RzMmQwSTFCV2I3NVJS?=
 =?utf-8?B?V0ZwS1FPSU04cXgvWnRNSEhFd0lxeHhYbjZkblNoR29TMXlMbEhiZitmcFpJ?=
 =?utf-8?B?QUxZODJjd3c3bmRPSlBvM0ZING9UT3RUZVp2UDZySjNLcUxWb1lTVW1FdUNm?=
 =?utf-8?B?OXdzNW85QmxTQ1JBa0N6aVdoRWFPRzlGL05vN1FqNUJZUm1TYnFsRzZmeFRW?=
 =?utf-8?B?MmprSDhwQjlHWEtIUEFLZ3BIMytvRW1DQVZvY1hCckMvQ29zb0tBQUZ5SmFS?=
 =?utf-8?B?aEljWDI3MXU4UlBhcDlwOU5xMHVvNmgwSkFMcnBrNzFlTFFTcnRPU2FibVBO?=
 =?utf-8?Q?dnbOILtRmMUF7?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 569808a6-a1d2-4826-273b-08d9115cac01
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2021 13:33:17.1455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8eoCr0fCthvzX+xZ922OoTuaCc0pPdTAjYVQj1g/Vi2/Kn42McOeQaZfm0LX1K/J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2383
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aur=C3=A9lien Aptel <aaptel@suse.com> writes:
>     } buf; // sizeof =3D> 16

err that 16 is wrong sorry, but the rest of the argument stands, the
kernel v.N+1 struct will be bigger and cause bad write.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

