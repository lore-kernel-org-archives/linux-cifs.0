Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472C9C64E75
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Nov 2020 10:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAE1B221F7
	for <linux-cifs@archiver.kernel.org>; Fri, 27 Nov 2020 10:01:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="jrXxLNo2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgK0KBp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 27 Nov 2020 05:01:45 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:25172 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728077AbgK0KBp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 27 Nov 2020 05:01:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1606471302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tcGH8az6RReSDeyuBq+6fSfdNsep6uG1GtpSkYMJdkk=;
        b=jrXxLNo2cRQJ4pB57K1RFEH4HpyThoFcYINOA7Vjm6Ib9JNFpTD/dr9Sl83VXRHzilZcko
        DpWtqUYh9b6frl80EQHHnmGbc5lRE83GT2ESnb8iMkKtz/HaAS2er9cQUA8O55FubwGjuv
        rQUumCe/oq1bfl0gSUNDJUyBKjF1LnA=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2175.outbound.protection.outlook.com [104.47.17.175])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-30-iYR_EyI3OYqDnNG97epfSw-1; Fri, 27 Nov 2020 11:01:41 +0100
X-MC-Unique: iYR_EyI3OYqDnNG97epfSw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fj6x/jUuzG4g7NpKePW2xXGFSuf+g8RAA4JIB6eJWOhg/O9EJJpwCWZkiaKi4p0dssTT0XSlv80vR4yMkOaLZIGHapNjDppTuXGY6dQTH4RqXOdURp7kPAFU/73/i8Dm+1q1rkuxe+1TLTCTn6IcKm2Eso0/Fee9tSroYAoOWvcdITlsjBXR0+l5IFaJ95W57CtspS3b0BmvDrnUpV5Jsccx9aN+KAn8f0tjiMo9eHGDzIjpzDf5665T9kS4yjOBM0tSkUtgKrrGP3KGudSlfQK/ZHty7Ft7F8ZbQBM2Bcu8ooTCWNOkQN6RZzUM1Jk5uTwtCzeFYttUvWLD/5gPWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tcGH8az6RReSDeyuBq+6fSfdNsep6uG1GtpSkYMJdkk=;
 b=UU1mhMZgLDhxUZj9CnNBXJCZgPJjohbQAVp2PvXMOAgoM+stFkuxL6evlW+SzXgFT5q4ShhBu0FhlFH+x8zM/tyXj0CfDNcSN6aB7o3d93BlJRzoLLNL0XQFI8JZhokkF1h1jES9+YWzAFIXxCj9VfHpxcjNedmMbwIwOYHEWD/VqFHCHm/gy6CqijeG6wsrg2kaHz9KYpRh/E235tCsFu5KQUI4NZLSA87WxvReagNoxWbES4wQYsMghy11NUTe5Dr2Oynea1BayiTJZKEa7v7tcDtmWeMY9AhTiW2bXuQrWGIeI2xZDc+ODiQ8zeUTFMC9px5TgVWDtRhYvUni/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: archlinux.org; dkim=none (message not signed)
 header.d=none;archlinux.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB3104.eurprd04.prod.outlook.com (2603:10a6:802:6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.29; Fri, 27 Nov
 2020 10:01:40 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::4dad:a2d3:5076:54f0]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::4dad:a2d3:5076:54f0%5]) with mapi id 15.20.3611.025; Fri, 27 Nov 2020
 10:01:40 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Jonas Witschel <diabonas@archlinux.org>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [PATCH 0/2] cifs-utils: update the cap bounding set only when
 CAP_SETPCAP is given
In-Reply-To: <20201124133740.cixyh57b3rlto54n@archlinux.org>
References: <20201121111145.24975-1-diabonas@archlinux.org>
 <87tutflztq.fsf@suse.com> <20201124133740.cixyh57b3rlto54n@archlinux.org>
Date:   Fri, 27 Nov 2020 11:01:37 +0100
Message-ID: <87zh33dsou.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:e82:e682:674c:6004:e415]
X-ClientProxiedBy: ZR0P278CA0014.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::24) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:e82:e682:674c:6004:e415) by ZR0P278CA0014.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Fri, 27 Nov 2020 10:01:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5a82a22-48a2-48b2-220f-08d892bb6f78
X-MS-TrafficTypeDiagnostic: VI1PR04MB3104:
X-Microsoft-Antispam-PRVS: <VI1PR04MB31047FF404B6E245DE43CFFCA8F80@VI1PR04MB3104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9KOf510zXHujkgA6gTXaywdhIos6RYLUIfuXLOHYc/CSwp3UaMrtn0rWmV+1EEhDJNpKnb7jYNVU6+X5Zcu7uVUt2QiEOPUzy2/o5PCVFTUQR2QbV+/BlyemS5cNkFGoWCru4SaEyAljHoE9uzqiXVTsyMO8RhrCI5+D2DykVqWFdHbjYw47TX5+W5jNhYKZQO2ea48JTOXMDtixfju5FVvkz4ubjCb99mYR1Px3ObsAgvm5TBeWT6GEDAdIGNTOHFTE6er2/sCJpyOYhL+DSa0KZdhhts08TTh/06pbcGLpT8W7SdTkPGG9yKbvrCL8VjCUKkQ5WOhqSAXO6519gw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(366004)(376002)(136003)(39860400002)(5660300002)(558084003)(4326008)(66476007)(66556008)(52116002)(186003)(316002)(6496006)(66946007)(16526019)(6486002)(8936002)(2906002)(478600001)(86362001)(6916009)(2616005)(66574015)(36756003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cE5mbEhzWHBVOW5HM0krT0trcjRXQWNpY3F2V0l1N3JrMDZYeDVhaGdhOStF?=
 =?utf-8?B?dktRdCtjeE1KT0FTNWFBL2pMTEorMm9ldW1jaUhRMzE1bnZwRGRIemhMcVlZ?=
 =?utf-8?B?WnN1SDV0TzFuTGp4RVN4OWFra0tyaDBRTUZDT2hJdTdKTzhrZHJVcUVLazZm?=
 =?utf-8?B?TWo2dnAzZzNGemtNWk1yc2pjRmVpU2xOUFh5NHZjZVd6cktiOHNwcFZabkNM?=
 =?utf-8?B?ck9ONUJSbDMxUEFMK0ZkZmsxMWtNYXAzdVpSUDhVRFM0MzZBK0sweElWRG8v?=
 =?utf-8?B?bDI3MDY2Nld1U1J1eWFkczVzdHVVYWRlYy8yKzBQdjNEd1AxemFwZXBoV1FS?=
 =?utf-8?B?ZGhsLzhXeUlmcWdyVjVsc2M4andKNjlXL1dnQU5PMlpkZTloLzVvaEVtcWYx?=
 =?utf-8?B?TnRxbm9kajhRRjUyRWRMcWFhVGFNclhFTGlwRTRUZS9GR1FxRGNGclZVM29m?=
 =?utf-8?B?d012djlEWHc3eGZLemY3cWFscVhHd0M2eCtydG52dUdicEgzS3RpWkR1VE5X?=
 =?utf-8?B?VmdBaitTcldMMXZjb0lhNTRiT0ViNTV0VGpNVThIVkdYY0pXdW5CVEtWR1RD?=
 =?utf-8?B?anVJUDZDbU1tSUpFNVU4Q3k5bEZBaSsvck95cTFZeWNXVEZBdW1qeGxQTVN0?=
 =?utf-8?B?NEQ4dlFMeDI2Q2Z4Mit2N01rVGo4ajNZQkVlQ1NvL0d5endVUXIwN1RLeU1m?=
 =?utf-8?B?eXJHRHpsWHArY3pjQ0R6bXRCeW5aWkxxaVlCMG5ZZllWT29HZUVXYzVRYVpa?=
 =?utf-8?B?QmpLWEtYTnlaQmYvSXlxYm9TT2FnMDR6TmlhQm1jM0puYzZZdEwxUEliS2Fn?=
 =?utf-8?B?bFJUQ1l5QkF3c1FIMjJnMkxzbFhPeVFoNEZvanZkZ0Q3SHRhZUlwK1kzWjhP?=
 =?utf-8?B?RTM1QkM4bG16ODBvY2JaVEVvaFlSMUxPTzQ1ZitBVEFwVU9CSEgwTGhpYVJr?=
 =?utf-8?B?S1Q4WkRLSFd4eTdyaTI4YUl5anhObHNrdlBKZVdGSm1BcnNSRGNYQmQzcXRt?=
 =?utf-8?B?cUR5aVhrNzY0VGFYd3I4ZzRBZk1tU2dqR05XNkhUaUZ2U1JRZFh3cUVEZ05j?=
 =?utf-8?B?clpsZnIxeFpGbExYekdURGR6U0YxbFk5L0FUN0FtNmtrV28rSk1mMjk3ODdy?=
 =?utf-8?B?cnpKcGpXMkRCc0ZCRkQ2K0JjVG03NWxQeitOVlVKTVR5U2x3WlQvcXQrdnlG?=
 =?utf-8?B?Z1F0ZmF1Ui94TDdNZXRoTmF5Q1l0YjZheE9CZWY4elVkL21Vb2ZLa1hIbC9n?=
 =?utf-8?B?U0F2SUpSMmkrYlZjU05vUkgwOWRHWVljVGphNkVMOUdhZmpUT0R0bjRvbGl6?=
 =?utf-8?B?YVFvLzluQXQ5QllKczViak54Nk5PbndkY240R1NXUkhITU13YjlBbGxkN2ZJ?=
 =?utf-8?B?R2xQdXJxb0dhdkNTUTZGdStPdXl6aEJuQUgwdlJrQ1NucnRKMHRTN2hWUmhF?=
 =?utf-8?Q?bR6Mp4gb?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5a82a22-48a2-48b2-220f-08d892bb6f78
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2020 10:01:40.1597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MWDVgdTiO73eOYItxZhBvWCrDqwRB+o/Oyj4B1IYEscSsmHx9UwwcT2FS1fItIrI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3104
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Thanks Jonas this is very helpful.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

