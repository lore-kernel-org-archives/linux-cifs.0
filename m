Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7C80C47083
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Jun 2021 16:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A277961623
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Jun 2021 16:07:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhFBQJY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Jun 2021 12:09:24 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:53978 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230136AbhFBQJX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Jun 2021 12:09:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1622650059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=iKGxPv32KPhvS6JjNJvn47zYi2igV2WR+SmdJkz0AeE=;
        b=V7KBegAilLsvvWtKzT55A4WCDUPaVu6hi51YEFoRfjrBfg5n7fJiW7hshdCNyjvwowSRdT
        ix7OFQosGE0EXEPQXpj9YOW9BqNNkFrt1+n3LXMQkwtXYbWTIthz4sgRuuXc9UGvQbp4iJ
        vioBLPOxCbw+iKPdPG5PC62J8S/I5Ao=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2055.outbound.protection.outlook.com [104.47.4.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-4-KkDeW7mDPhWhr0kySXnfYg-1;
 Wed, 02 Jun 2021 18:07:39 +0200
X-MC-Unique: KkDeW7mDPhWhr0kySXnfYg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AAX23pQbMdGKvpgeqlxQgjy4KkoVil+p6aecYuiUMFi42/uIYcHqlw6A2mXCC/GNLcjhleg5XNCyfekNdXNjetut1hatjt78g6MJDLmMwTtA+HQmDbtpqKGW57/UAz4O93uriwCh4iOvvrC2gQsI1w+BToxW7RvGbY7LSUaIRuatZ6z6n0s3D5novr9y4Qm0f7HgfYT7oNEV/97zxLiU/kpXVInQ2xRMWmMSNAdsgxeQt9xLdoZBFeJYNugHykesgquvyooh7YtrW6sES4aMNmBRrKyteFDTdL46ZlrJhgTAG+K6B8A3BClaZ36cm389zRW4r4K8qRD8eyxFKhjVRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKGxPv32KPhvS6JjNJvn47zYi2igV2WR+SmdJkz0AeE=;
 b=Rna5vNIirfHD58rk5rR/RtbLY6u3uG1Uhjprg9M99RFyztFS58UOAR69OsieVmwdpSDvBLWxblDAuyXbCbnDKZX0uK0lSpzAtm/seYkAHdLFONT22ts+L8CwZjPPpuw2Hgxq60fcXaNu/ELVg5Jy/RyIWgnstk/sIfXvr78x388MOMZbz7uvcZxqcn8FDRReoRjkRY+TGRmLvmpiy3dbq7V3rqGuB9x81O82pqCFV/SjtuPDhgj8jXQUHrSgsnwe6qfXd2EZC0pwSx2q7UxPJlG3CDCS3cdSAnQxY5vhIJyezii/MhE4YVbehJuKKGeizrSVI50jyYhdScgLN8peeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VE1PR04MB7421.eurprd04.prod.outlook.com (2603:10a6:800:1b3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 16:07:38 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 16:07:38 +0000
From:   =?utf-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org, Pavel Shilovsky <piastryyy@gmail.com>
Subject: [PATCH cifs-utils] fix regression for kerberos mount after CVE fix
Date:   Wed, 02 Jun 2021 18:07:37 +0200
Message-ID: <871r9ktfli.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:d344:ce45:96b3:a2d6:686d]
X-ClientProxiedBy: PR3P191CA0011.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:54::16) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:d344:ce45:96b3:a2d6:686d) by PR3P191CA0011.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:54::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22 via Frontend Transport; Wed, 2 Jun 2021 16:07:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0d90a66-96ac-4a5b-ebf1-08d925e08acc
X-MS-TrafficTypeDiagnostic: VE1PR04MB7421:
X-Microsoft-Antispam-PRVS: <VE1PR04MB74213989E948498C9F3E5AF6A83D9@VE1PR04MB7421.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WCJTj4zNQhKKsyn7At1gbOaL7OXxCRGQkbXkOgYvZzwSi8TUD7LdDIhzo+BUPhS9uVt6Iuqyteco01/Zlf+Dp58c4Apfj3CpiUI6OaGR6/UQou+68gaRe0YLUxcs1QKXkSnsmYvqx2pV10hfnqYjaPDi+CIwhakSJ7FoubCWI+OmZUivLmgbXdkUDhifsoG6AhyJM4W8mYGB0MJPAlGRGHlkL6NvqqpB20DVCT4OMHeuTYj/gjYMTGGL0LefYjeMjNDywlB8ZAambtI57td5A8fxFElfRIz2oqpKst2QrH02wIjGQjo5oNqCiZmfk64UdCCncEQMOXPxgecK7gC0Oq5dtq36s3yV7asPwsTqflhcmH7zZePcRr/ZdNjN1a0OZ6z1d7w9F9m1qsW5c1pT4R0d8lTyKCEqSZ+Bq/HaYT9/yVZ0S4mJXxJntZAEwUfvQ8OIz1nzMmxMAqrr+xF5zXmhy4Z7/GsFHDBsGQepoYfmnZPvHkKkx9DX/IdPElRgXz2W5Y9Cylz1OD73rnCFMt+ibeArY/DQ8cO7Tje7ZUwwYgt3ZEKFmLCKSp+IiTVqNESQO10G4eMGeS8yeG7Dd8ZnbuVqWtkzO0X3OkZ6mCpzqmpO0AZVuK92QtytBk8DowIxZY8ar7xzEo7dcxIHTMhs8ECWeF5UTGlOK0t1sU3EDwgqkLGaOq84D460XBVU7X4GUzQgfY3jKm1vlxRjaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(136003)(396003)(376002)(39860400002)(478600001)(316002)(5660300002)(966005)(6486002)(2616005)(66946007)(66476007)(66556008)(186003)(16526019)(6496006)(38100700002)(86362001)(36756003)(8676002)(2906002)(4744005)(66574015)(8936002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RDdMTjR3Z2JmMnc5OThteFVhZUJRWlRnTWxjTUUyRU9WTTROKytaOERzT2pv?=
 =?utf-8?B?UTM5RE1PTC9TcUdOeGpjbTZ0R1ExNVYxcGdQVGhTR1FtelVhKzY5RFJSWXpN?=
 =?utf-8?B?UnJmam9pemc1WEdNeWRaVExTclVxU0ZSaEZVbFo2RFhhKzJOLzZqOXZNWWhO?=
 =?utf-8?B?MEVWRHlkVGp2bmltbWVHMkNjZlpZZEV5cU1ObnFpbGE3ZzdsUEhQY3JVc2lk?=
 =?utf-8?B?N2RGSkZTajlheWlLTUlhTXg0OUhnOFhOZS9wcktod1dCUFluVG5ndWxreHh1?=
 =?utf-8?B?U040Zjk0aW9la0hHQXdLZVRybm16V095amdLZTE0WEdCZDJGb2xoK3Ixb0xh?=
 =?utf-8?B?Q2ZKRWk4d1N6SGJ5cDZ5bWJ2cVZwRkYxY3BRcDFYcDF1ZEdXWDdWNVMrUm5C?=
 =?utf-8?B?a3V1Y3BiV0VidEZOYnZCYW9EbzIwRmgvR0YrdTlyL0xWUzZEWUxOa2xaa1dG?=
 =?utf-8?B?dGR0QkNaUjNjeFVIdG5waGFYemhpaUtpcmxKUm8zU1ZCUGI3My9ucFFJN01l?=
 =?utf-8?B?NHk4KzI1Q1lKNjVkcmZmcFQ5R1ZPaFZENHlpK2xKNHRpVUxqV0svMW15aUlF?=
 =?utf-8?B?dXR5QUlMdjZLQmgvMVhiTStFQ2NDMzBTWXFSaXlhamFRSHpITWw3QTVLNjBN?=
 =?utf-8?B?VnVwWkt5TUNjaXNqcU9aeWlEUjZucVlCNTl4L0hxT1RzeStXTkZtMjd4cE9m?=
 =?utf-8?B?c1NTYlo3SGZmTWlrWTlhaFpDQVAvUE9NT3Vnbnh5c0cvR2dhRE5TUDk4TWJI?=
 =?utf-8?B?ektlV0hWdG1oeEN2aUR1Mjl3aXJPWlF5V0h1V0NoaHNPMStqM0t5RVJiYWI3?=
 =?utf-8?B?TnJ0OWlSaEtCQ0xCcUxrazMwNWtTZWNHSVhqZTlSTVZnMHFyV2FNT1ZRT2t6?=
 =?utf-8?B?bDVQbE5DOUo5cE9EQUtvcnFHRFBPbUlBZVFLQVdwTXNGbmthN2hMVXlTZ05j?=
 =?utf-8?B?TjJnZEF1L0dXTkNJU0o4bmkvWGkwbmd6U0M4VmIwSlVhNDNtTVo3b3p1QmZK?=
 =?utf-8?B?ODRIeWZuZGxVZm95blFBSm9nMk5EUzFZRUdwTWNaczBMMWZJYzRQdlE3d041?=
 =?utf-8?B?Yk1pakZRaFROM1dBM216dXJQUFBadjlPQjJlNnZEWjBGT04yc1cxVmtYam1j?=
 =?utf-8?B?YzVXUzBwMGlnMkFhb2xZMkxoN2c5NTYrMjZXMkNMSisxZFdnMUQvU0FiVE96?=
 =?utf-8?B?dVY4NDhqdjhtenBnV3Y1MExuNWdiODdaS2VjRXUvQUFnV2lZNVJrM2piTGRs?=
 =?utf-8?B?QlhPZElrMTBDWGN5RW9NVDFkb1hiZHRtU2VnOW8wc1NpYjJIbTloTFNqR1Zp?=
 =?utf-8?B?Nk50YWl1RkF5eUs2b3ZOaE03dDI5M1ZmbEQwQ0lBVitsTlNLYVBGNEdxZ2Fp?=
 =?utf-8?B?QVFzSWlPMU1ENXEyNXJEeEJGWHQ1RzF1RkUvb1hkaTZMek5FSnJha0pvV2U5?=
 =?utf-8?B?RzBlcjh2NUc3T2JMMGM1cUo1Ri9kNFRGeWRkZzdlcXVwK1ZJcHg3WXd2VXYv?=
 =?utf-8?B?a0tGaDl3V0kyT2htU3RYVzN3WmtnYi8zZ2xUWXdwSGwxRlptNHBBaURhM1dz?=
 =?utf-8?B?SHpHUnN0TUNBQmloaEtKalVwWllxU2d1OHg3VTdzdks5dTVTNnRYa2hPczdn?=
 =?utf-8?B?bW95Z1NDYUNlYXhHelVHWDNPLzBZQTJuYjEzSEhCK1dlRkFtOUM1MGxvbmhQ?=
 =?utf-8?B?SktXdXZWLzRYNmcwcis2MkVrc2dCZXI4T0xRem9zcG16Vk1FWU5zNTdzNG9j?=
 =?utf-8?B?WFh4T1BWUzF3aEZLWkpmaThPQ2p5TE9kM0l2L1lwRkpqb05FM1ZoUVNCZUpI?=
 =?utf-8?B?R2U0eE1DUW5nTGlNZGpUeXR6eExCMjVnak1GMVhjZTd2bVZyUzI0ZCsvMVY1?=
 =?utf-8?Q?LEVKV5BCl89ZN?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0d90a66-96ac-4a5b-ebf1-08d925e08acc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 16:07:38.2192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +GX/4i+Wglx1FshVRa5mJDmaSOh2deD5nMlMX2eGKvPZktR3u+O/InItVHq0CC/P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7421
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

I see that the fix for the CVE regression is not in Pavel's repo. Could
you merge it please? We've been running it for suse customers for over a
month with no problems.

See patch file here

https://build.opensuse.org/package/view_file/openSUSE:Factory/cifs-utils/00=
01-cifs.upcall-fix-regression-in-kerberos-mount.patch?expand=3D1

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

