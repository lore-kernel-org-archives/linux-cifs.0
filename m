Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6556AC4743C
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 11:43:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4166260249
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 11:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhFWLpT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Jun 2021 07:45:19 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:47522 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230109AbhFWLpS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 23 Jun 2021 07:45:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1624448580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yADaV9zmN5mt2YXxJ1C1yC4JIkmtnroLLR5vosB4QJk=;
        b=HkOFyH503EAH5/pmt7AgMPFhhkKRYbbe81rRqVNOUj++c2VTlyk3ANaNtmsre+dXPTih8m
        yV8KUwYhEVg7xxGkumg4OoEkA+5p7mac3di7vqYHrHvdU6ElIJLkB9J45Ii05yNNg+7Ncw
        huRNytZ18qYGVT1nYRc2K904e9tU/08=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2051.outbound.protection.outlook.com [104.47.12.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-39-e--h6Dh5MFmVxpTvahrt_w-2; Wed, 23 Jun 2021 13:42:59 +0200
X-MC-Unique: e--h6Dh5MFmVxpTvahrt_w-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OO2SXELGGzlUZj+C2/YCUUR0vyhUhNyKc6xgO2vHRQAtXGT+A2NTiuZ3doq9hcDgp+EL8MI719IxeD9hZsf0te6YGG+S//kSxrE/TxRW4JA59CIMq+ABjaDaSbBX7hhBxiiwJhhFLRipJY8It1Wc21J9ClfRCN8Xk+1GXNQOZm32/+HFYNAw6c3RpaScj1NpeCuTWY4NHWq7lGZQBSXJGmO+3HhcY8KvWhOmMKm9DBH10Wbg13z06P4GoIL4Chu3AVJiRo8GOu9WCGBT8KzbLkaWNS1V7eF4Qlw4d5OvMQAmRVvByA5V0gjp0v0ZiPRxUujRKYhex0ybRCKLgnUxtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yADaV9zmN5mt2YXxJ1C1yC4JIkmtnroLLR5vosB4QJk=;
 b=Zoh+lDobtwN7fVAaFxIDSDL06OAyFXsPgtPkx4ilTNKqz1TIQOoe+iSiWbDbg9RcWXuC/nMZ4RT2FsI84wBQsc5T8fLGTuf2uixVcUnjS8MWgxYzQ0fym091RJ5GI2ZMP9DXfomSfJmUqCBEtlI6E9daFEJ8Lgbn4VW/m378I2fKbfMXoVPpCbUhEjw5onqA/Bp6xnuD9I+Lva8PwdoEszVGezi6J4oAk4LyuQpUp2KrzZqxGGB9vRtzo4QEMdZtb17UwIF+2NaDOqwbWZrXG1qLIso2lC2Ihxow+NV2svrH112c++nYTD0c6vOaFAccrz3MtgbmOhHNF0tGd6Y0OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB6222.eurprd04.prod.outlook.com (2603:10a6:803:f3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Wed, 23 Jun
 2021 11:42:58 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d%6]) with mapi id 15.20.4242.023; Wed, 23 Jun 2021
 11:42:58 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: coverity problems with certain macros
In-Reply-To: <CAH2r5muNZdzYOWZrRvo_OKVsmsPnNZckriKDqQTAQ06Wm5PObA@mail.gmail.com>
References: <CAH2r5mvCOafQpko19fmSTtEdgG7mp2R1+xto=_fkm7A=fqWq5Q@mail.gmail.com>
 <CAH2r5muNZdzYOWZrRvo_OKVsmsPnNZckriKDqQTAQ06Wm5PObA@mail.gmail.com>
Date:   Wed, 23 Jun 2021 13:42:57 +0200
Message-ID: <878s30rem6.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:70a:9978:e3b4:c6e6:8f68:a927]
X-ClientProxiedBy: ZR0P278CA0044.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::13) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70a:9978:e3b4:c6e6:8f68:a927) by ZR0P278CA0044.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Wed, 23 Jun 2021 11:42:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b437108-886b-4df8-91bf-08d9363c0c3a
X-MS-TrafficTypeDiagnostic: VI1PR04MB6222:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6222ED82BDA941E3D9B0AAD7A8089@VI1PR04MB6222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SulCj+5099GWuwKczwH94aZNk1w+BvnaLQpa6zz9k6pKwrwTrmJORNCVR8o2wxXGx5mUaoiz9B1QyaXR3xASulg2/KwdAouHRHl7V1B6RIwqyifa6Ax+KZFwdFwj13mydoH+ECmyiXvPm9OzecXfhlYKL4u9Sk+MyHOoTGWYwSUrwVm7THA2a63Z5N6Zk2O012ap4dMm6lmV9aSvXUsjtxQVOrDQUt1Xw9i0Vj+RbR8FLZuaQyyK3JF0h1HQcxEPY4OGq75yDSXzXcoxFqIjwagK+j7rpTrlgb7tyw1ZGfGRrkygeBRpGzZGahUp54bIsu3HloNpkRp8yzv2W1sOdjtJ+MEvZhmTV1304HMUUYOn4mCRCpp45YUG62WqJ8nM8a/U02dbJReeDl/0Qkg8dZE1TXlnd7yu1Fi5z2W5j0Pc7ftvyEcIZmcPzKrm3ZH1SHHcExp7Le8eAvD7mRaowSJMSXTPZaW4pubgSWg5aip8YhIXMrP/JZcQXLmIaDjzSd8OBXtp3yFCccH8a9YCGHnIWpjlRBAl+nLeRwl/2Du5j0DBG/JTo4MjcgFLvAiqdisyp/TtylvF2XsV+cVBgKlLrjISkxJXCCv+K92y+3g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(366004)(346002)(396003)(6496006)(478600001)(38100700002)(316002)(110136005)(16526019)(6486002)(86362001)(186003)(5660300002)(66946007)(66476007)(66556008)(2906002)(4744005)(36756003)(8936002)(2616005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnR1a0tGalpUVFNCS2V0Q29qMjQ4UDRDbVNYK2tIZmN1clo5bTBjYXhRSXRj?=
 =?utf-8?B?WkR4NWNHVmZheXZSdG9yOVJvSDFPNjNHaExiUFhaOW5aRU1KeXdNRWpnRko3?=
 =?utf-8?B?dVBJY1p2Q1RXVWNaa2o3YWdlekRGODRiVTRiOVJjSGg5cEg1Z0hET1hsQ3lw?=
 =?utf-8?B?VGR4aTQ2REljM21Ram50R1lkQ2E0OU5reG5zL0NmL2NFbzNnU3VZN2VwWDJ6?=
 =?utf-8?B?YU5JWWNseVNiZmZWK29aQ3lxd21RdFVKalBZWUU0eHdUbkduRVVpQjQrNmNm?=
 =?utf-8?B?akNDU29Zd0wxbmorMklVcXFsOHlBaG5pT0ZoeEpEaHl3VHJrdVdPdVd4SlBW?=
 =?utf-8?B?WkE3bklhTVB1a3c3SDdrT1BQYWx0MDFxVnZGLzZYdWEzcVhncDd5SHRZVlZl?=
 =?utf-8?B?Vks0aHBLT2txbUFpT3JEeThGYmtEd1NmdjhpWnExaE1ZUmdLQTRFdmNZeVdZ?=
 =?utf-8?B?MHpVRFZBYVp2MEZzV3V1citwMDlRS3d4ZWtwTiswc3d5ZldzckE4bmdjTzlL?=
 =?utf-8?B?UVVOdVpGTDZ0dVQvSGNzQk45aGx2TmNkMTZJUDN2N0NyZUY1TG5yMTIyaHJN?=
 =?utf-8?B?NzIra3hwQ1ZtVFN6RmI2TjRheDVTNWNIcElJN0NNdWdIT1o3bUZ2U25IMEc4?=
 =?utf-8?B?WDNoOEJ4YkdDanVUU3VWc3YzY3JKT253TGp0WjZKMUJHL1lSZUduQ0VJL2R3?=
 =?utf-8?B?YWI0b0Z3ZVp5aVNpb0NJZHMxaDRydExIbFJKNG12blQvSmR0TU95YkJObnAr?=
 =?utf-8?B?TGxvQ0ZZUjcyTkZCVlN5bUZXaVp3YmU1NmpaNTc5cFp5L0grSERmdE1Hc0pU?=
 =?utf-8?B?LzdFdTVRTkx1YzNRTjR5OVFSTDk5bFkzQ2hCWjhobnZCbmNGTEsxZGczWlpl?=
 =?utf-8?B?d3BySnZIZmQzRy9KZkcwNU9BVC9pN2dvN0RRbEF6bHl2Q29vRERzUURTRHZ5?=
 =?utf-8?B?b1pFcXB3RGppMWtURURSUkFHMUdzdzdnc1Mvbnpzc3VmUVo2MVlCSTVsTWJO?=
 =?utf-8?B?R0dWUTJnODB4dzRGaG1WSXc5NWNxbi9xeHBCbzY1OEhvUlF0a1lMdEc4ZFo0?=
 =?utf-8?B?S0V5VVRjVmZrODArK0JydEZMRzVoR3dOenVOTGthaWE2dWJLK0xJYlorTWFW?=
 =?utf-8?B?ei93NkpteGhKRDJuS3EwMURYSDRaZ1MvYlJtaEZhdzBtL3NwamovWVpGMTds?=
 =?utf-8?B?cDlyNjBpRzVZUmU2ZGV2cC8yN3hkSm4wdkJaN0JRSTJVSEZsOU93ei9xQVNC?=
 =?utf-8?B?K3ZHZVBIYWFtTEdWS2VuUjJaNU5XNTEwbzNXdjdrNEw5M2g1TGRwdzNheC9t?=
 =?utf-8?B?eGlzeGtwenhXLzZ4VStqUUNVK09rL3psWDE4dGlFZUtxUG41allEV0pQUEhX?=
 =?utf-8?B?Umw2TFZCbWE1YWYvdFBFQnZ6QjQxK3AzaEpUYmlNVXlKaTdtbzdEUXVHaHpK?=
 =?utf-8?B?VU1IekIwU1QzOWEzQUYyeXIzV2RlSnRxRXc4OEdPejBmMEp6bkxuRXp0NDVp?=
 =?utf-8?B?cUx1UzVVai9uZnJ3UUxPbnJ3U1VuQ2xOUDIzMHZaTE5HSmpjSFc2bWorU2pr?=
 =?utf-8?B?MDhlaHcyY0duQVVVQStNdHlETGlJb2I5SUE2SS9MNy9MYnUrQUpSOURhaWNv?=
 =?utf-8?B?UWtRRmhOU0JIOEhORWY1b01GZUtCeVhneTJNS0p5YlAwN0pnTkM3dVY0TzFq?=
 =?utf-8?B?NXYzZ0R1UTFqOUxFb0tHYWdUTEdTZEFSWUMyem9RSW96TGg2QitReGR4bll1?=
 =?utf-8?B?T1JsNzFLVStPblpPcXZ5bktacUhkcE8xQ3NIMU1iMUo3QVN1M2NpajZLbXcv?=
 =?utf-8?B?SC9DRHpOc0ljbGtVem50dVhHY3ZUQ2ZHTm9LWUtveTlzTGc1WDJjMWFDOXZR?=
 =?utf-8?Q?LzBU2ZsyT7ppu?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b437108-886b-4df8-91bf-08d9363c0c3a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 11:42:58.1497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T1MXyJlVH3w2UN620VShn7LydYXR5TFp0vE0sU7dv/X85z3kiwMuu4VfEQg4r1JO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6222
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

> Also interesting that it appears to show up only in the "linux"
> coverity report not the "linux-next" coverity report which have
> similar code there.

It could be from some implementation details of the pr_ functions that
got fixed...

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

