Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 122F5C43462
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Apr 2021 14:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA18E613AE
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Apr 2021 14:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345151AbhDFOaI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Apr 2021 10:30:08 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:50865 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230032AbhDFOaF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Apr 2021 10:30:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617719396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vq/lMlqPc+qFf5Zb/K2Hd/YCjK2gi+M/b+bv27ce/a0=;
        b=I7PBNSYZp12Oh4dt4IausFZK3nJkW8gJTKIm6vB9wuVfNeQ4QsiGF7ucArT9vOamFBuwQA
        f8XPHmN3Fg/HBGOaTXIDB31514iZu6m2CdtXO/hLXKMXjZCjUkp3TU8X2jzeh+19VMUq9q
        IQEYOAfXIs/WzfmK3NS5wA1moVUkq3o=
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur03lp2051.outbound.protection.outlook.com [104.47.10.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-22-5pAxeC0nOmOoG5oggDXHsA-1; Tue, 06 Apr 2021 16:29:32 +0200
X-MC-Unique: 5pAxeC0nOmOoG5oggDXHsA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+83c094+KyfA/F0BkDvu2SnRxzfgrN+MKMj8ks2smLLrCF2kbVxkqMObUFfRmd62vTx3FU+GQox/3puyBXS5/aEqnvws8OyA4GP1rMHlzGz2j+lnL0mSvpuw9JmNObhZBH5Yl4KUcKdI7vjjl7a2fI4Tx0v46kBkNARGNyIQk9JOL5HyljLJwNT9kS9mFC0RRTSEtQ/InP2DZeQ/Rpto08WimNmoYKd2yd4PrxXSMjiDVMJwx5rZmuzdr100+lep3gurGoCHH27MSk8O6O4fOPTrzdRq0XPIuuGJHXouq4wEVozjBNDd/oIAgFLF4UgoTH1ju9x1yK+0pTYIFAC2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vq/lMlqPc+qFf5Zb/K2Hd/YCjK2gi+M/b+bv27ce/a0=;
 b=nRtnjEzbXB8hpkUgPHE2j420NznC72nhq0EdOqwxaFXbKbwvqEbS7pdJY9CmArqLdmWgK7N5Jp5/G2yCbyS8VebZ4WpnWskbjOmkWhmqKN5RSZTaRJDey1uZUl6HzAlKrOZdbqS8KxSYdNd0kCHr5AGmbpWrzF5sgwwTaSQxkZ2vSz/e01Aq5n33ju5nvIMxx2zX/xaRt52mBSVz32bCMdM2FTk83uiAKq0LS9ndwAkt8U4LyNrY19dzWpyW09FtpLVTMxeI/igl2KHYjLK3DdZtR+lwxGVQoXtWnL39HCYmuTQxkYP05IOUW0i4rM2zm7TYJ5jooDwhpUjJq1rsrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: barracuda.com; dkim=none (message not signed)
 header.d=none;barracuda.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0401MB2576.eurprd04.prod.outlook.com (2603:10a6:800:56::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Tue, 6 Apr
 2021 14:29:30 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 14:29:30 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Seth Thielemann <sthielemann@barracuda.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH cifs segfault ]
In-Reply-To: <DM6PR10MB3833F0DD867BF1B48F60B99FA2769@DM6PR10MB3833.namprd10.prod.outlook.com>
References: <DM6PR10MB3833F0DD867BF1B48F60B99FA2769@DM6PR10MB3833.namprd10.prod.outlook.com>
Date:   Tue, 06 Apr 2021 16:28:14 +0200
Message-ID: <87eefn4hdt.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:3023:3e6b:6105:9a2b:bde1]
X-ClientProxiedBy: ZR0P278CA0021.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::8) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:3023:3e6b:6105:9a2b:bde1) by ZR0P278CA0021.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29 via Frontend Transport; Tue, 6 Apr 2021 14:29:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 35a01375-9266-458b-3f57-08d8f90863c6
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2576:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2576E6ECDE177AD90C05DF4AA8769@VI1PR0401MB2576.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SKYLmuiskw9L/HsZModq1SSDBxkfxscVPMzL83QiwtuRlK78hyIrrNMcnjcuH7Zp8/xnCmtifPtuAFoVhUCHkbUHj58ouuyNxzFQ53soAWE1WYbj2Vn9TS7IHqSWCWIjRxH8zNICAJvz54HFjbDYckvkpdYowlFrzZ2rZkBSbusaZs66aNE1HC9+S/Rfv8ZXI42g9n3kUr7NVDG3jIG4yJjslTKOy1OFtclGMDErjMq5ARRDYbLDKDxX1MzBgHBtR2oMhlUngz2E6Eq8bZZqEuFI4vfu5gTkP+VljQwuNIzZQLuTqNknL2T4LihXS5DY13AbxQDddjl2SDtyBh9wMvcrUNNOktf4AYwAKTsSH+futZDTJXZzpu3tdifMa/LZk7NSUNU8FvVIJDvguCIF3NFRWAS9ZyjkifEQ+2wIg4EEQ4WAEI0Gs/8DXSvFCtsVpqsx3bB+bJekUk+Ksdd6JhN4XQVtT/jO9jr3Jgo/5SUbqIlLDffdPgCuqYlHaFgixm4fxAeyasrX8bAJNjBNRnsF7uaeBp3otwFaHM+EHX/Mz+UUMoYlbB6Kvooc6/5gILlYOMoWuoKECSZRHPq74BI6Ia/gYOld/OLPO/cIqRzPFvShmcD/pSJr69eacja36Ugl3e/peXw0kIr5WJ4X3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(346002)(136003)(366004)(316002)(8676002)(66946007)(2906002)(5660300002)(186003)(478600001)(38100700001)(8936002)(6496006)(86362001)(6486002)(2616005)(110136005)(52116002)(36756003)(16526019)(66476007)(66556008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?a0o3S2t5WjdWbGxtdTNqa09qWVpGWmsrNGswMzBkUmlmbU45NzZiWU1KblNi?=
 =?utf-8?B?RGl3cDFHaEZIb212QUJuZ1JwS1VZa00yNUZJNkhQRWl0bTNCcHFST2h3UDlW?=
 =?utf-8?B?TUlmTVZGdmZjU2hjSGZaUk0wU2VqbmpQQzZkU1N6Njh5RFM0dUNRYkZpVmRZ?=
 =?utf-8?B?YUJCTWRlSWdlcXdPcTVhOHRqR3dKd2l6Mm03RHAvVzNMcVZXMUQrL01ReGR3?=
 =?utf-8?B?eUt2WEMxQXJTSlYwTDk3cEI0eWdPdzgzNUNLWEh5d1RuYkt5Ym9yOGJvTFlP?=
 =?utf-8?B?c0tSZTc3TzlhRHJMMFlNQXV4d2NQTVlvbU1qb0tSNGxrekwybjR4aTlGZ1U0?=
 =?utf-8?B?aHhreEd4cTduS0tjZFB5WC94a2xqN3pJWlluS2Y0MlE2NTZUTjdBbXQzVzZo?=
 =?utf-8?B?cld4Um03bDJjWHpaY25CNW05eENIMXM4U29YeCszOGNRQ1ZJYmJFellSYWVD?=
 =?utf-8?B?MmQreGNxOXJWTVRMZGZUQUhIVVFiK2hIbW5xcnE2NHZlYnNpenpab05tTFp6?=
 =?utf-8?B?SlR4RHZFNzZTUDRMclc0SlFNZUkyRUgyOE4ybmswNlJBZHlPQ3ZMUCtuREdo?=
 =?utf-8?B?Q0dtVkdVQjI3TGl3bUxPa0U3cWg5b3FSSTEzUUdBL3I3RnNNWGVwdldDMzdi?=
 =?utf-8?B?K1Z1bC8vZUZkMjY4Q1NXbHM1Q1NIYVNrS3RxVGpSVzRId2JVbmZOMU9BZkRw?=
 =?utf-8?B?d2p0bTlLeHVwMDh1cFMySEMwMG5rVGk3V0U2eGNGaTJDYjBqWU8zN3NBM3NM?=
 =?utf-8?B?LzNiMmFNTUtyWnNIcDFtdXZSWTRFQUhvSXBtRUN3MHh2S0JuZWZuTkNydzN0?=
 =?utf-8?B?YUVCTEIvSGJsNmNlakRDVjVoTWpLVndGRHlraG1tVStWeXVvZHduY21xZEJv?=
 =?utf-8?B?OGlMTWJ4Q1l6TjdyZmtUWWxGQmtIcmVySmFvSHVDZy9ZUFlaTWlHdVdUOGtx?=
 =?utf-8?B?UkZTanl1QWxWR01JYmpzSlNxSHh0QVFSM1pySzFxTGFKbVNMcUZxQyszVGhy?=
 =?utf-8?B?MzZoYVdJZ0FsOVVzRFVzWEQ3Rmc2M0YxS2kvTG05WWVYZFphdjVqRTBNOFdj?=
 =?utf-8?B?OFprOVV0TmFyWHZHYmgzQyttdVFhUTJEMk0yT1ZwcVgzYzBLYml0YSthYWRS?=
 =?utf-8?B?SmRYcjFDZTRqSllSMVhxUURyaWIxbkJTQjZTK2tsZWIzYjRBS3BUeEJPYnVS?=
 =?utf-8?B?K0I3TXpTQWtQSDBmdEN5TkhoaXRlcVExcFJURys3ZDJ4MGhFQy9uanR1Zm1H?=
 =?utf-8?B?c3FkeW54eXFGbjR1MEx4MlhiNE0yTnE1eGRTQ1ZLc29IVHVhNEhsbnVlOW1R?=
 =?utf-8?B?WmM5NkNzVDloUkIyaHRUcEUvcW5tYzY1TW1EUW5FUDh2WExIcWVTRmdwdnpT?=
 =?utf-8?B?VVAzTmZDTDJERk44UThGanIyNUMwNTRiYVVMYUJPVTVuSXJ1amdNdlcrcmgr?=
 =?utf-8?B?Q2QyalhlNnRJUXBVdEcxcHBxblQxaE1WczBhYk1NWE9BTzBOTmRLaG0xOFZq?=
 =?utf-8?B?NlJBdVZ2RndYOE5OYWIyTUcvQ2ZOSnZ2Z01jdi9PbWRqTXBZVXJod0JVSWNa?=
 =?utf-8?B?ZU9mbGZ6VWNpY1BVWk1VMTdnQmRaSWd3VEhzdXREdUt3K3hwS3BLV0Zra3Av?=
 =?utf-8?B?RWRoeTdsU1drQXpMRFBzeERLWGpGV01MS2tQT0xNZnpXdFZiRXEwUGpXQlBq?=
 =?utf-8?B?bmtnYnpMVG95VXU0Uk5XZVhyUWdRRFBvOE1Bb3o2aW9YQ2wyLytLZVZGSlNy?=
 =?utf-8?B?eUhFOTlaSXgvenRBbzlYM1ZEYS96YzZzQmZnbFRrOEhtRXF1emhFL3dlVHUv?=
 =?utf-8?B?VVFKODZmTktmNVVTbEt0L1dXWmxxa1MvR1RUUjYxTzV6SVd3bEpPNGgxbWZU?=
 =?utf-8?Q?7Uc97dCexVkAm?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35a01375-9266-458b-3f57-08d8f90863c6
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 14:29:30.3425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /C/GKhNivAvP6EsBkesJHQGXpTZlAnh6tm+9N1TjrTNXS5e2toqX/ft6+AdXlTiT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2576
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Seth,

Seth Thielemann <sthielemann@barracuda.com> writes:
> - Observed segfaults during cifs share backups, core investigation and st=
race revealed that files were being opened
>   but upon read the syscall was returning a 32-bit error code:

On my system (x86_64)
- ssize_t is signed and long which is 8 bytes
- int is signed and 4 bytes

That is a weird bug. Casting (long)-13 to int is ok because -13 is
representable in both.

> - Above is an impossible situation, the sign extension was at fault. The =
two functions using the trinary assignment of rc
> in the cifs asio context:

You mean this line in collect_uncached_write_data() right? I think the
current code changed from your version, it's in a different function now.

	ctx->rc =3D (rc =3D=3D 0) ? ctx->total_len : rc;

>    188db:       45 85 e4                test   r12d,r12d

Ok I'm assuming r12d is the rc var.
we test if rc =3D=3D 0 (low 32bit of r12)

>    188de:       44 89 e0                mov    eax,r12d   <- msl cleared

Now we set eax (low 32bits) to rc (what is msl? most significat l...?).
But the high 32bits are unknown

>    188e1:       0f 84 6a 01 00 00       je     18a51 <cifs_uncached_write=
v_complete+0x371>

if rc was zero, we take the jump

>    188e7:       48 8b 7c 24 18          mov    rdi,QWORD PTR [rsp+0x18]
>    188ec:       49 89 85 a8 00 00 00    mov    QWORD PTR [r13+0xa8],rax <=
- saved

Otherwise we store rax (unknown high 32 bits + low 32bit of rc) in the ctx.

So -13 is

    0xfffffff3 (int)

but if you copy it in low part of a zero 64bits you end up with (wrong)

    0x00000000fffffff3 (long)
   =20
which is 4294967283... should have been 0xfffffffffffffff3

I'm no compiler expert but this looks like possible wrong generated
code for the cast :/

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

