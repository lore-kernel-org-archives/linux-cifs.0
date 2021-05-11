Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48374C433B4
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 15:53:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1186761376
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 15:53:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231764AbhEKPyS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 May 2021 11:54:18 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:28861 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231839AbhEKPyS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 11 May 2021 11:54:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620748390;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=87QENvA5vpT9t7bzORxZoE84ur+51tpFN1ZBJ0dxO0M=;
        b=fR4Obv+KdbX2c9dwBnEh3Jp1YE1h1jxcJ2yqH6wlbGB5Gbc+UeG9kqQFB6W+UmRqjstxT1
        o0TWwVb26q0ldPr2iaG1t7BtG7UWgW1BtpMSx4G/Ye4LfENtP3nSo089UnRVLdRaP8hxQA
        gsQJkd6Vn/yDImP7eXqvc/cCxZ7bTwM=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2056.outbound.protection.outlook.com [104.47.8.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-19-1jaUWddlO5mown1ZTci_1Q-1; Tue, 11 May 2021 17:53:09 +0200
X-MC-Unique: 1jaUWddlO5mown1ZTci_1Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HGVsBBJ2/BXFOiHIA6YSFM/P/bzc/w/ve0Qw+F8MIljuEiM3jNGiABJrQ1HzeUOS9wsSh5RBWznX+Kvpp3iFElrb8Xk9GeDDl8dSAeXOsqz30tvScOT+GhsanvdbjO0D63mtpTPzWXqgvJchY6Ypc4+gfrwq2ix17p3diMkWDAE9eQIhasw1SA8hFnLJOf79rh3dM3VFE31M69b4iEpMDLUGHmIJ4q+7BDFm6k30Pj0dzsT/K5JiM0r/8NHxq7LxMUfG9YsfE6ppQhq0n/bvJMfa5ejUOsaGhNbKGlmsikzfVD4a211//oMtf5QIpv7p8hBDauO2Tw64R4fmQ+BluQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=87QENvA5vpT9t7bzORxZoE84ur+51tpFN1ZBJ0dxO0M=;
 b=TIODW5dQzBWr7BCiSm4lNh6Gg5gpGKilW9Qbp12GiTeVyIoIOZ8fx0qEPDV4CgGX3nY7OfWej6pbvAYTwZpXa8B2wvjPP0DDGsJXTwzl6FV9VplmnArWMCOlyRf/lTB4O71rO9rTCjedIYJC6HmLBesoeS2My0/mGhWajZH5iNErcoxewt1ujAczZJaCIhvOAlcYW5BX8c8u7AsHAJH7uActHNgYDkuniYUd5haN1RAWG0m2QxROx6yo1wlUB+WoK2XTIqOng2sZucufRRjvgFUgXgnHvRs/WauPrNVfccDmgMxCNY7Eg0fHirJ6lvx+tlo50ydMTPlFQgUIgq0Xkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB3279.eurprd04.prod.outlook.com (2603:10a6:802:3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.30; Tue, 11 May
 2021 15:53:07 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 15:53:06 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH][SMB3] 3 small multichannel client patches
In-Reply-To: <CAH2r5mu3m6FWWqrfOeQugXWGZOPiEE+Xgk8wc0rn8OgLRVPSWQ@mail.gmail.com>
References: <CAH2r5mu3m6FWWqrfOeQugXWGZOPiEE+Xgk8wc0rn8OgLRVPSWQ@mail.gmail.com>
Date:   Tue, 11 May 2021 17:53:04 +0200
Message-ID: <87bl9htggv.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:d359:b215:6aa5:3693:e486]
X-ClientProxiedBy: ZR0P278CA0153.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::20) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:d359:b215:6aa5:3693:e486) by ZR0P278CA0153.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:41::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 11 May 2021 15:53:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2e6e9b05-376f-4121-34ad-08d91494de3d
X-MS-TrafficTypeDiagnostic: VI1PR04MB3279:
X-Microsoft-Antispam-PRVS: <VI1PR04MB3279E74FBA44E1FFE67F962EA8539@VI1PR04MB3279.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BYXLUS0IhEta+ul1F1qegPiDMdmss1yQaj1tYx2gQtjlpRzolop4J2NAQayryN1LerRLEg6cVORwEc1+OqNBJYW9JDheP//cwnh2T+fr5gmm/eeOoFV2+G+xCDB3Nh8jcekTc1+cMUeOHXMQ0A2D5C6sy5Tr0l8nf6OKXwG8Tuwnmv8vbS/1/YS+UI5jGjYQgh+ynTM2JCaK4PoTCwce25Rlor6OXvZLkcATO2sVWxqyLQx5ObTdRdWi8KrFVKW5vXk62gzzQZlBPX3FwqtqlMFCYz9N3567+oc9kS5oWXE31IkEjevFY0beff76VH7XHCKX+9hY5enhYA+s7WK822DQEnFdCvh87vLqCqV8veoKcoyzm8P/GfwldUGXetLP7CUUWEQq8gnJqE11ditfMt8Oq1E8ampEh9Rlv6ojkZnlohSwtniAu9dAE9DatER5xpWUJG7uBIF32Y531Hm6PY+gDrPEu1fa21ljY4pEO6Y1kGiQeXJAdl0mRiowdVUjbbM7/PMUn+ZERXBTJy9FInVnTXXy51qQpk9vGFjEpLkK5HNU6PxtCKkv7gWbVa20DKfiEnIGAZJoSjKqC/8rlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(366004)(136003)(346002)(376002)(396003)(4744005)(110136005)(38100700002)(66946007)(86362001)(83380400001)(2906002)(8676002)(66476007)(66556008)(2616005)(52116002)(316002)(6496006)(4326008)(186003)(16526019)(5660300002)(36756003)(6486002)(66574015)(8936002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SDJoTDNmV2hIREk3M0taTHdKNW1OOXlORkc5Ty85bmNRMGxwOHM4VnJvNXpN?=
 =?utf-8?B?RzVFUFhWSGFoamtueTN4ZGRvRGxrSlZxaE0zSENTYXpUcEpxejhqcTYzT3hs?=
 =?utf-8?B?WDRyZ2xiU1o1NkJNYjlyU0llS1paSHBSNlorK3FVOE1tbzBkdjJtcVpjT2tt?=
 =?utf-8?B?RmwwSzFlMGg3eWJZZm5rak1YTkZYaVQyRHgxbnhzeVRXWlhPbFNQNDk2NWxv?=
 =?utf-8?B?cnc4RUFXeVNLOUYrTmtCaDBZUUpjTEZ1dndOMmxmVy93c1A0OUlyWldVRnJG?=
 =?utf-8?B?ZExMTmxPVU5sVlVYWWZudHZDS0VNNkMwQUYxMVBKUFNxZmlKYmtOUDdqUUVB?=
 =?utf-8?B?TkZQRlM2VXdZM0xwRHhKUDBnYW9PMWNtV3lnU09Id3l1b1lPK2IvS1NLcFlP?=
 =?utf-8?B?QW8rT3pSbDk4WFNzNXJURXRXeWx4NHNnNUoyTVpYWWxZL3g2REg4N0FqQlNy?=
 =?utf-8?B?cElIcFZ1MnJqNU9NNE5UbkJMMVNJeE81b0U3QThnVmdsY3VqMmExTkwzNU5r?=
 =?utf-8?B?THlmbXJZRExDc0p0NXF1Y3FhbS9ENXUzZzkybnk1eDlaL09NQzI3aUlwcWV6?=
 =?utf-8?B?ZzU1cEhibDZCc0RKdCtwdEN4bEJ6YTBNVmphMFRpZWtTdmhDdWJaTXkvVGlR?=
 =?utf-8?B?VTN0THdtckk2c3dXUmxJODVTbldMTGZLenRmeko2Z0EzeGluL0JsdjlwU1dl?=
 =?utf-8?B?algxQWtnSTB0MUtydWVCWHUwdWhFQ3ZnNFdhQ2o2SjdBZk5XVTVZYkd6TGRP?=
 =?utf-8?B?KzdtaXkwTDZicUs2b2FPN3J1SjVrZmxiZEVQTVNWb0kveUc5Y0RqcERHSVV5?=
 =?utf-8?B?ZWRJbGxQYlF0UVZTbmdmd1JZbHBVeTA2eElxUW9zbmdhd3o3NzNyMHI4REUx?=
 =?utf-8?B?Yzl6LzlrN0FkODZ2VWsrMVFGWkFRclNUSXpoZVNkSFJGQkkydmlES3JzeVBK?=
 =?utf-8?B?UVR0TGRrSGtiMTBRRlhLbXVESFA1eW5ldS9yQkVKaUdJQm1oYUh2bWlTd2k1?=
 =?utf-8?B?Q3hZelhjNjNuSHhnaUdjcTNyWlV3b2FwZjZRSWJMSFBWajliSjRzMm5tZTdW?=
 =?utf-8?B?TjF5bEFpSm93K3VlUjNGSHErUXVtQVlKODJhaHUvdndaTEovUDBjYjM5dW5X?=
 =?utf-8?B?bE9GNU5QMkcyQmVvVU82N1FQMFZGK0hyajY5ekZlNEg0b2t0QUppcHNIenNn?=
 =?utf-8?B?UEJCUmdyWjhlajc0S2JXTFVQbUFYY2c0RTVvcE9tYk54eGRrbVlGQUlRaE9r?=
 =?utf-8?B?bjdTenVld0JZYnlkK3VnRTI3R1VicUVpSzkvcG4rWjdJKzJGanV5enNhaXRN?=
 =?utf-8?B?SVM4aU5oN0RhL1JlemxPUzdtNUNjeE11eFFqVkl4RitrZ1VxMjVYdWxhSFYz?=
 =?utf-8?B?ajNmeTV1NlBraFU3Lzg3eGlKMG1hV2pQbkdyOWNjZ3BMVGRsbXJTRnJObmhh?=
 =?utf-8?B?bWxpdzdWUjhhcSswcjBSRm1rdWhHV2lOcFo4ODdlQllRNSsyekZTR043eFZ3?=
 =?utf-8?B?RGVTZzR1L240UUVZZGtRSzJ3Z2hUZHFmYnp1dU1tZTVjdHREVVBkL1JqSjlM?=
 =?utf-8?B?R2NpNFZ6L25tb25DU3AxR3ZjKzJoN1crT25vYWFnREx5cTZpTTIyaGRHYm1S?=
 =?utf-8?B?RVFZYWl0UFkyb01tdG5XTzA1VEltcDlOellPRjdETGlpNy9qbUt5ZkcvdGl0?=
 =?utf-8?B?Q1NWRnozb2RtVzZoRC9VTUcweUNBWHFCb043NmdFTGVyakJVOGYxcmpmdDlk?=
 =?utf-8?B?WHg4WW83Z3Q4WWJLKzV5OThRUk5hUTBvbkxPWDdvdGlPejhERzNHWDJqMG80?=
 =?utf-8?B?OUVZZk9Rcmh2aDdMcUN4WUdnY3RGMm5mejg5NThHZDIwMXZXUUwwVWJtalpP?=
 =?utf-8?Q?nIqjDK7/NBJLz?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e6e9b05-376f-4121-34ad-08d91494de3d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 15:53:06.7253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mqw2qcJ6c5bnpbjGvw8iMRjt+TtXoeNALRZqBD5mTJRtNAbcxxwd51HRzlyGE1aX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3279
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
> 1) we were not setting CAP_MULTICHANNEL on negotiate request
> 2) we were ignoring whether the server set CAP_NEGOTIATE in the response
> 3) we were silently ignoring multichannel when "max_channels" was > 1
> but the user forgot to include "multichannel" in mount line.

Thanks for those patches, lgtm too.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

