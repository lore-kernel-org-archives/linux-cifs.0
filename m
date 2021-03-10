Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05944C433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Mar 2021 15:17:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3B3064F4E
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Mar 2021 15:17:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhCJPQ1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Mar 2021 10:16:27 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:57511 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229689AbhCJPP6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 10 Mar 2021 10:15:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1615389356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sEgQMDigNGDbw1kVZFujZEYDSjz7SEN4uTw9UNdMFUE=;
        b=Uh7Xbx09F9coQ6SywYE3Gv02N+BLQ69lhj33EQQ85EwNvcJaV1oN5G4zhsq8Ctc25iMpV+
        oHCWixVOdcF3hAKr+GKgz0n0OCBdM5eE1cym2gWbI5w0PzPUO04IqJft09ZugeWtj+/49z
        zGGVC0cezw6pz3kaUFCLaBvPMEKD30I=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2056.outbound.protection.outlook.com [104.47.1.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-34-bsfUq8emPym8JllX7Y2yoA-1; Wed, 10 Mar 2021 16:15:55 +0100
X-MC-Unique: bsfUq8emPym8JllX7Y2yoA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SC/EgPviAm5xSFd9y7H0eGK3URN5Oi+EqAQ9njMiPPX+rnfCY7w6WMuywvCM4MTaFQ9wzOjFQBEdKWfWwgWc+yLGv2YYkJHkvTTEEuvYApYXGGeorpFYr8HW0oVjHLB6kZ973oDnjPCGLVbIAPZVj8tLZwULx139GIXDAiApTfyU9l20TSur27cTb5MnGV2RLmbz6OASq3iqjHeNakk9Gjgtmnki3sWqtFtCrEqDuEYpGP0kJxTYBaaImQyeBOt0Odros9eiqjkvfIeXqVOdhYT67XJqbZ7P9FZMlPiEzjBRquGbk46ln8w97uBWAQFS6opGdJcAZBkKCxu7d8sRFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sEgQMDigNGDbw1kVZFujZEYDSjz7SEN4uTw9UNdMFUE=;
 b=ZJDMqauJO4FCSsCtIOtrGJUTaaUIpoaXAkAVqk37CdCtANaQWHGCYkGrYT85rhBGiP4KiducPyQyc7q7iE2/ifgcuyVsulW9PIJh5kzQDEsP3EKcse/I+DQgBOC3ElQ8evXmrnb5Jl5GNk4EVdO/XOr247ULd6p8cr4LLvKAAgjrwdHiKi3v3SyjML1/zxkQ9rjTeJNL6M8sNc4vJCnzhDsQ2t1P/R/um0sAFpKcq4CuJB1Hmj65Esv0jEwV/3kLlF2hTfe+Dcllt1I2a9EKQKwAnS+QO7VM9gUOBuqIyPO55sriiWMn+H9nsrzJ0gsdzH1suEIsWhRQvhsQqMTclg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: axis.com; dkim=none (message not signed)
 header.d=none;axis.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0401MB2397.eurprd04.prod.outlook.com (2603:10a6:800:2b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 15:15:54 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3912.030; Wed, 10 Mar 2021
 15:15:54 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Vincent Whitchurch <vincent.whitchurch@axis.com>, sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, kernel@axis.com,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: Re: [PATCH] cifs: Fix preauth hash corruption
In-Reply-To: <20210310122040.17515-1-vincent.whitchurch@axis.com>
References: <20210310122040.17515-1-vincent.whitchurch@axis.com>
Date:   Wed, 10 Mar 2021 16:15:51 +0100
Message-ID: <871rcnujiw.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:70b:4a83:b8f5:d569:2662:f8fd]
X-ClientProxiedBy: ZR0P278CA0109.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::6) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70b:4a83:b8f5:d569:2662:f8fd) by ZR0P278CA0109.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.18 via Frontend Transport; Wed, 10 Mar 2021 15:15:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb68242c-e13e-452d-7be6-08d8e3d765e6
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2397:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB23979125D8C53FB69FF5A814A8919@VI1PR0401MB2397.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VSOVr2x+8k5ExrcV4WOYlrE8HIm+x+wIDt7ZjDBhbugvBO17QltR+7dBEX6lg2aJSbM3/lBD3h1XTnU+qluj0iJP0iYeJF9PCVZH23gqmTvvagFQ0yQysYVMzFpPQJzNmVYs3pxrnlkDBt5HpRaNIs+QxkIAv7W18CQWnVqBQ4HEN+jCipmqvzzp4q6IWqMAYuKz8VJLjPTVyPDM8HZQ/nDLnZxD6SzZ729zZ9+g2W5pk62/p/9M438dPdbWqG+I+4OnE2XTv3HGhzRkLenpkfXaYLwUufybODKfGlr2JflrACqVfa2k5oer5U9PyLVyVYPHUrf1eIlLNB3JY2cE2Ik9ydnETUnp8lKMloKTqkUFHL/ipsuCAKwlqEwy6ihz8LfPWRuCVfDU6bF2XoBHEfd1DlovJLY75dgrhcnLtaR6M1t5tQuXUO7sh11a7043N/si+Iu8hwkwwk8LeV8ob5aBNocm2EBkeWVdiJD82XgsjZlMhyKZs5sQOBtw4L679p/4VrlGQo5JiSwrAjv5ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39850400004)(346002)(136003)(396003)(366004)(86362001)(2906002)(66946007)(66556008)(5660300002)(66476007)(4744005)(6496006)(52116002)(186003)(6486002)(4326008)(8676002)(36756003)(16526019)(478600001)(8936002)(2616005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V0NHVGkwZC94NFdpSFh0c3puOUk4LzhUOFc3VmZRSlhSOVBtTERJQVdSa2I3?=
 =?utf-8?B?QldzZUpnbmM5UTRiV2prZFZTMSt1cDQ4ZVJVTmlnYXJyd1pXcENyUkpLNjBB?=
 =?utf-8?B?Z3pMWEwzWjFjUG15S0lxM0NGby9PdG5YZ1VEd2JSSzkxbkNOc25waHhLNEl6?=
 =?utf-8?B?Ni9QeUtLUlRFQ1g1ZjJEZk9udDIxUDNHN00vWDNBYXdMZGNleTMrVEdpY3RE?=
 =?utf-8?B?blh6U1RjeGRGNGJib3k5K2FqSHlJQTl5bTVEd2FHZnZtcUZCMlM3eUZUME1Y?=
 =?utf-8?B?V3NveDViYWg3V0tkVGxXdHRaTVlrZEJPR3dtN2xoSTlneGxmbkhIVzU0eGZU?=
 =?utf-8?B?c0ZublJkU0N3RWVxMHdaajNpUE8vK0Nhb0Z4cWcyYnMzbG00QVRLUjVyUmlH?=
 =?utf-8?B?cFNqUmM3YVp1ejJaWm9GQWhDa3NzUkpEUEdHdGFBUFg0VXRsODlKOWl1VGJT?=
 =?utf-8?B?RkVKLzhVUEVUWmJVcDB0N05WUmgvaTY3cnE3Ymt5SU9XakczWS9ETWs2QXVN?=
 =?utf-8?B?SWZ0SitTakZhbVFaUzhrVURYNlJNNTdKTEdGc3NUOVBSeFI0QmNIMFJDZUtG?=
 =?utf-8?B?OVJqQy83cEpJV1JIdWwzKzEvLzVDUUpuU0JvWjVvdUJ4UzgzSS8zR2MzUDcx?=
 =?utf-8?B?V3pEY2ZJUVAyU2VGWnQ2MWhDY2hMT3ZWYUk0UjRxUTZuYmNMTU9UZGIyYm9E?=
 =?utf-8?B?Qm53ek41TEZUQmE2YUw4OFA0UUF1bUhmZmUySnl4SFZxQXFTZDRROTdvczRR?=
 =?utf-8?B?ZHFzREo0QmdzYWwvcTZGcmhwS2xLWjZJdHpFRlhRbTF6cFNSMCtFd25XYzdU?=
 =?utf-8?B?aHdWOWVFVlFnWWJoZUp4VTJ0THZ4MzhDKzB0Vm0zNlZKSTd0WVJnOGJzNU93?=
 =?utf-8?B?aHZYbTExOHcybzE0NU9wS3J2OXJlcWRPNHFFMnpLdUtramlzbDVjc1FGeTZj?=
 =?utf-8?B?QjBmcEZkbGFGVFE4UE5nZzU0S0NnU1dPdTM0ekYyZUVOTU9CVUo0dFpwdlg3?=
 =?utf-8?B?RHdleTh0aWE1bU9aQTlRem96WHE0aXV3Sk1lS1g3cGt3TndndXhNOGZyRDMr?=
 =?utf-8?B?UnZjVmtUbmdtS2JOd2w1UHlXeGNNYzdBUVFGeHVhcW1hWlR2akRjSXppVDBL?=
 =?utf-8?B?cGllZ2ZEWVBWQjhhTC9uNStad2tYR0RraStyZVJFVkY2eWhWTjJQSTcrSVFR?=
 =?utf-8?B?YkptTEU0Z0lYaXZKVXJueVAwWlZPaEJ1djluZDlOZ2VJaTdHS1laMG9BMHBr?=
 =?utf-8?B?WEZqMmRTRncvN1NSczl6K05WU1NYL3pwSE0xai9RUnc0elpiUktZS3VlQ0Qv?=
 =?utf-8?B?Z2ltSkNDVjBHeWcrbGRyc3cxWTBDdjh6Vkp0Q2NZcURRZkIrTG11ZFpkUXpL?=
 =?utf-8?B?R2N5ZHFaZGh6SytFUzQ4dDhjQUY2SGVOOC9Tc2pXMko3TVFNWkVNREtWYXJN?=
 =?utf-8?B?RG45aEJFS29pYUQxeWZxU3JVRDk2cWxUcEhwUGt4djhuTTJ5cUR6cGZYczRv?=
 =?utf-8?B?N3JNNklKRXVrSHZQSHVTamZNbUFZaGJhMmRFdUdFbHR5SWZPcGhycE0rNDlH?=
 =?utf-8?B?Q1FNTlBuU3NyQ3oyUmRwVnBpN0JnRUlSUXEvYThWSnc2ZUZoeThaUUtaTzBD?=
 =?utf-8?B?bGdBNisvZ0FOT3pxZ1IyWmwvaWJFVjVzQ2tpVTVJUlFKakxjb2VRR0E4U21o?=
 =?utf-8?B?ckl1RDZvanQ4ZWtGUWVCK0c2eUZ0ZURaRUFJbXFvc2ZaR3JSL1NLVzc4SVFY?=
 =?utf-8?B?MmdveTZNNmtRRlZkNEVaZVZsUlA5YlB1ei9PbDZtUHhGcTJnK2pZQlZvam5l?=
 =?utf-8?B?YStYUjhTTUlOSTZoMjlZTGdiamZXS044N3gvdjNNMWlRN2xNZ0lYQy9nbmlV?=
 =?utf-8?Q?UTIIQULNI4kpD?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb68242c-e13e-452d-7be6-08d8e3d765e6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 15:15:54.1411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x3msjU0bWLMyui4gzRlNFfvzEEKar5bK0p6LN5AH1QGKw3I/Efo9AfbogjMVtPTJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2397
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Good catch, thanks Vincent.
Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

