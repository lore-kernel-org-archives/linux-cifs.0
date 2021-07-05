Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D23F5C07E99
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Jul 2021 10:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AABCC6100B
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Jul 2021 10:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhGEKy3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 5 Jul 2021 06:54:29 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:56179 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230482AbhGEKy3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 5 Jul 2021 06:54:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1625482311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ADD3efIo11jB5uIHY4lgMmJPsiVUZ7KxIWuykBgSWqQ=;
        b=Nvva/dRQGFkETbMFr9EtJUu5W2mYEKa0NICG/xs0Y19M6QFlx44iPjRzuAKmPoccReMVxy
        BOXZZeNqzzsjLJRcfscUrsjf/sN/0tGbp3OTt3x9UVHYb8/4uvHbBjn6E2xjvj5g6U8s60
        ZMkolmV4CqH5E7RqBiZFaH3El5Dy6N8=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2168.outbound.protection.outlook.com [104.47.17.168])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-13-VSEF6vvvO06DjVVJVj_6xw-1; Mon, 05 Jul 2021 12:51:50 +0200
X-MC-Unique: VSEF6vvvO06DjVVJVj_6xw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=brQ35CuTzOv35wc6Pjmm1BrtuQZAaqw2NCMKtm7n+2r++ptAZxoJYTbMzssUsHdrCBwmgPgWFMGUZNg4o6EFqoWYYw1AMYXZstAfvy7uVr5bhu31tpMQElXfUDmxSAFoD1gDxiS3u+AvUZtsbantS/tsFACfGiMdxssqwVEXzOXJLwkC4UCjq7AlXdlHarIuu7l8ub/+1W/itQGxvYW1pJVrRuXkEmZpWrY0Mhl0eBnd2Cf+8n2woRhhQsy4UKLVsud6kHHLgC1HbQgBKYQ0Yh6jq/djKVyY5eey9e1AZDPcODzkj9VYx4fuC5aOMAvLVb9e6LLkWVB8OgsKMFiDRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ADD3efIo11jB5uIHY4lgMmJPsiVUZ7KxIWuykBgSWqQ=;
 b=iJTK5ZQI/mpCxk7yEhx736qImQJXOPypzPigsj3Jvrq1xq2C/Edjtxx8tqSLv0nF9tUUt9/G6P/EzmKk21PsYD97AQ5VlfT6RWRWHuuUJ4qwfwnGf4FpGT92FXKVDorPdVY2GugNuH3+D5RgQSNT9bu/U6j3FBwS0axzdOtib0KuHaqKZ6WQRqqMuwkzWYCMukfo03ewkH2ubhCzYpuvEVVhFxINFf8FPmZwkIEjLEmySRGTKUup8GOEBZat+ojtQ0Xow2NH5rBJao5lUecnEBGTtmphlC/MWQEOHJz6LEeitJiS6g8ml5uLmuYeOHopu0txgflxzf42GRS91pzgXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: cjr.nz; dkim=none (message not signed)
 header.d=none;cjr.nz; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB6910.eurprd04.prod.outlook.com (2603:10a6:803:135::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Mon, 5 Jul
 2021 10:51:49 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d%6]) with mapi id 15.20.4264.026; Mon, 5 Jul 2021
 10:51:49 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: Re: [PATCH] cifs: include regular shares to the list of unshared
 tcp servers
In-Reply-To: <20210702171710.406-1-pc@cjr.nz>
References: <20210702171710.406-1-pc@cjr.nz>
Date:   Mon, 05 Jul 2021 12:51:48 +0200
Message-ID: <87im1powxn.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:709:ff78:616f:16b9:1438:527b]
X-ClientProxiedBy: ZR0P278CA0003.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::13) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:709:ff78:616f:16b9:1438:527b) by ZR0P278CA0003.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Mon, 5 Jul 2021 10:51:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d13278c-fefa-4d6d-97f7-08d93fa2e40e
X-MS-TrafficTypeDiagnostic: VI1PR04MB6910:
X-Microsoft-Antispam-PRVS: <VI1PR04MB691069287EB2F6E278720B3DA81C9@VI1PR04MB6910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s87Edmw0Cju2cRnbMKzL8eCectjZyRcmtptGA9qDRccINwmeTTP2GUORlbFVByoix/+kg0ihzUewSYdCevZEkWGqkWQX12e8VYcPEhz5GuHBd4lH6Gq5BQTUMzHcQF31SlB2uxOAJaC0RkHhTatbRqdYXERlqHQbKWzBGOSTkWRaBX2w+PcJmRiaRAZuD1+5iB3LbEwKLjAyKrvOfhXi9aVaLi4x4qoGtDaxVYCVYbnpeX1h0eO6AIHXSGgMbgAUjHt7jxmhOP5STIt8Pv4hUFDOz7Rvt78HGABkeD4u7LE5C6zVXg9JMWY9X1tBlp2SNtBgswNNSUgYK/+1gmJXu1dMLoLY2rfvyFuonPIiOpfg78vBCYUWwyscVwV2S6uqtxaxdunNRbmCqSuWTQ5zYEMZNLGL7D8KV8fur0vgeAEoC35W1aaBDbyl3yrWAvX9nU0vNOjpz+/r7Ort28DA45AGJHOLZBa7CB06Va7yqqlwGFZQV/W7i6Q7OuMXdwqTQMT0TPcorCgedWH5NRnNoj/V1UjrYYISzNKozB3qugbjjWqQ87S3Jb/U82ghawzKirOUKUjZOLfZFeYful1jtpssghN/C4b6agyjE4FtgXp7NXvsaUXi7yqJ/lhoOqkl/pPUJXOkZJw9i6tNJFdzgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(136003)(39860400002)(4744005)(8936002)(8676002)(6496006)(16526019)(38100700002)(186003)(478600001)(5660300002)(36756003)(2906002)(6486002)(86362001)(66476007)(2616005)(66556008)(66946007)(316002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dW1XNjJyUzk5enN6MkN4NU9kVlhEWFhPS1pSbk5GZ0piVWNyR2NzcHJHUklL?=
 =?utf-8?B?dEp1UEFVM0k4MC91eTJzem9pWnFhckFBb2Z0bWNibGRuQXJEazBOTTl3dHZG?=
 =?utf-8?B?cEtxbW5FMFJTeXNLM1p6NUJsWDJoc2xoZVB5YzU0a2xCeUl5RWtJcFNSeFNu?=
 =?utf-8?B?SkZleUk3NFBXTkJTMy9JaS85bmZVZy85QVM5clVHSTBlOUJVNkpzNlBhcG4v?=
 =?utf-8?B?d2ZNaTZaN21CMytwM3o5Q2RtTFRMbkFLem5aYXdQVURHVG03dWtDRW1BaHF2?=
 =?utf-8?B?dFVMWGp0SStXbTBhU0dZeEUzOHJDYTMxTklQMkVKckhjUmJQMERCNlByQVZS?=
 =?utf-8?B?ZFZVWjFCN25YZHdjdytNZ0tPRTdqRGVPejBGVmtJMUtJeDdxd0pVdzVvOCtP?=
 =?utf-8?B?bnZGVlFuVkFaVlhscmpsVXZFbE5IWnBrYzkzUHI0NFlSV0d1OG41OVJ5a1ZI?=
 =?utf-8?B?aUp3bUNsZGZTcE9tYXQ1dVJDcGRDVGdtQWdEdWthZzYxVG5OTDZIRWpURERn?=
 =?utf-8?B?c3Fic0xOcjQ1Y0RTZGY1UFVTdExNSEF1ZU9JemgyVW1ubk9yOWI0K0F2UlYr?=
 =?utf-8?B?Ty9zR3hoNVZnQXUxSnVOd0psUzNaK1VySnQ1ZEozdlFROE1MQ3Y5U0FmMU1T?=
 =?utf-8?B?TGJ0bWxUQ1R6NUVOZ1lDYTBYRHJyTHYvTmJhQnF5Z3d0NmRnSkFxSzZlRFll?=
 =?utf-8?B?bEI0MXcwVjdmL0NyUXY5Qyt2YWR2cEtLQzZNRmhCTFdaZFhHQUNxVTRGQzFO?=
 =?utf-8?B?L1NwaGtSazJkSkg1Rnc0QTgxMWlGTE9HVUhGSGVEMXBsZ1NWalFFZUlyV3d0?=
 =?utf-8?B?bENPZjRzRS8rbVhKWlEwQmJwUG1yY0pzd2pDQWFGVU4zZlFreUlvcWgvaEN0?=
 =?utf-8?B?bUdhRjRYUEdEK0YralZ1TDBGR3BzMUwxVkNlY1RKcUxaQnJhTlc5bWc3WTU0?=
 =?utf-8?B?N0hTYlJBSFBkRDQ2blpYdFgzS1VVRjVicEg3d3ZlZWJkTll0MHM5aCtyVTBP?=
 =?utf-8?B?RnI4SjFsQVViZ3N6VGhndjdUbXZuamc0eTNxK1hjUzEwanVDY1hmdmJqMG8x?=
 =?utf-8?B?aG03RTQxRG5xckM4SG8zbEFCclZZYUl2dWNiMXAwYk85ZDF5Tm5scGpzOVF6?=
 =?utf-8?B?QmFKelFHZStiUTVBd1VWdFNsQjg2Z1ArdkJmZmNJbzNYVE9PdGQ4Njc3azJn?=
 =?utf-8?B?d3NDQ2xJTG9CZm1RNGRpeE9qdm9KeUlYUTRBL1AzOXp6Y0wyL21oK2UzaEVa?=
 =?utf-8?B?cWQrT0lMRWpsM1g2QjFNQzJTTDREbmlrUjlEdDZQdHVMUXhYN0xQRnBkMWgy?=
 =?utf-8?B?TG54T1Z2dUlhVk9xMDlTc3h0NWFmVDE2djh5dzdpSldWbEJEbGNISWNmalRC?=
 =?utf-8?B?d0ZMS00rM1orSERuTkpFOXhaLzQ1R0o4ZHZxakRqUkJIRjY3bW5RQnBTNDJX?=
 =?utf-8?B?WXA1VUx6Mis3RUxySjJ0SEhUR0p3Z0pHYy9RbzR2Wk9jSVV4UkxTRmdyS0c5?=
 =?utf-8?B?SjhQUG0xQXVZYWtmeW95c29CaG1yM296N05pTWVVb0QrVXQvTTVoc1dhWGph?=
 =?utf-8?B?NEwra3RnZWNZTEVuMHpwVFJ4NmxhTU1Za0xHZ0RUalJYR2xBVzlwc3BoUWsx?=
 =?utf-8?B?QjZpRnVPb3JaRWlQTFNlTHF1OVQ4Qm9hQmhkSFZUaXdwejAvVTJKZExyaHdQ?=
 =?utf-8?B?blR3dncxQUJINUt6SmdGcGxmeDgxNkdIUWNXTm1Eekl6eVVtSUpaTXRhWFFz?=
 =?utf-8?B?OTFuWThhdWpWSGliWm0wdUFGZm9NMFNtSnV2U2Q0dXNOZFB6T3k1TFE5ZXJo?=
 =?utf-8?B?eUVIVGJmUjhXUHNEWTYwUWRuSFdVbGthVUhqaEFBeUlQUGZYRW1WdEJWRXhB?=
 =?utf-8?Q?PywLh0R5JwQAE?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d13278c-fefa-4d6d-97f7-08d93fa2e40e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2021 10:51:49.4318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DPL9wdvL9QmcUECsGSiIarbg4pBbdO44toYFiTmxr5hlAAkHYtLOTi3+D5eJfRPy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6910
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Paulo Alcantara <pc@cjr.nz> writes:
> We need to make regular shares to also not share tcp servers because
> we might have both regular and dfs mounts connecting to same server.

So with this change we never reuse tcp connections, and nosharesock
because the default mount option for all cases. We might as well remove
all the code for searching/matching/reusing tcp connection, smb session,
tree connects.

That doesn't seem good. If dfs connections are made with the nosharesock
flag they should not be reused already no?

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

