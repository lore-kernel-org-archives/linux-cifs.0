Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A1ABC433B4
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Apr 2021 14:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4878261107
	for <linux-cifs@archiver.kernel.org>; Wed,  7 Apr 2021 14:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348141AbhDGOQo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Apr 2021 10:16:44 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:40578 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348177AbhDGOQm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Apr 2021 10:16:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617804987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3dksJuCwQc+PgO3UI8+smu452bAAye3WH9Uit62bGug=;
        b=W91fpyptAIJkd0ohxcRjLzbn6Dx4GYzWm2ECqTaY5tyvw1o4cfxq8waspzk0qERST/XsKp
        QDj8dwqLzFZMd+DWr+sd9Kg6uZ6Lt01my420tLOue97AsHX7lvorLstsNzzevxZ+vELHzm
        HH+DBA+3Inl7iFpw0Edr+/siWFhIKr0=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2058.outbound.protection.outlook.com [104.47.5.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-31-txoCfyg0OhaIU7fSY0flKg-1; Wed, 07 Apr 2021 16:16:16 +0200
X-MC-Unique: txoCfyg0OhaIU7fSY0flKg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gaSgkabwvEVsaF94HIWypsuv1R2CTQAkG2KPJhMg0xngqcud+et53PWpOfbQADWM5wtR42M+X2xr7Z9PntDG0hmJzhIeokuRdEA1/x5VeJPOuDsr2D6hGXlNgqQrpxuYxgQAq9rDwSmuVzceZLgx2c1xW7+ElrijoHp+ftNhN6ZubXdsVzq6uM+hOL4c6nDJP6lgjzw2IU+fBevoNtw1Qd1P/+bDPWR6WRfl7kW7L43z0ZbsdToF+AB/AKZ2noFOySEMoG7jB3BQmynP06uwnJoprTa3dQ/MvkVhYuSrOY+/Zx4zxqS/vSmunKEKi2AOvH9qWxDWTOfTpfN2loAn5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3dksJuCwQc+PgO3UI8+smu452bAAye3WH9Uit62bGug=;
 b=b5RpHI/uvog7CNho5BlCWbwt+jHU+xUmfrbP8iNRc7lU5x5/5RR/fWUH1m4lebs+KapZFV2JK4dV0nQgaQqtwbjdc/L0sr4IDVjs1/B8+28s9IceqQaAfLgBHmZLsBuZAP/8iT2d6cFiei+P72pXDHng47/AtmamaAvfB2vPDsCWcA+JOd4BJhe1PcoluOHOGM9IHDNv4wbUPAhOzgS+katDYrpvgBpwRBGP/6BxNQ0vmO73AKHzs82/meZ8MhH9RU+KPbaAUTiR1Jnjz+3b+GP0LL2wE6pLW2359UBbZVxmU5x6omy49xSZsJVSQEDNMot3IvapWg3QjNgBlJ8Lag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: barracuda.com; dkim=none (message not signed)
 header.d=none;barracuda.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB6928.eurprd04.prod.outlook.com (2603:10a6:803:12e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Wed, 7 Apr
 2021 14:16:14 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.3999.032; Wed, 7 Apr 2021
 14:16:14 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Seth Thielemann <sthielemann@barracuda.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH cifs segfault ]
In-Reply-To: <DM6PR10MB3833579F43D640A69C4A39F8A2769@DM6PR10MB3833.namprd10.prod.outlook.com>
References: <DM6PR10MB3833F0DD867BF1B48F60B99FA2769@DM6PR10MB3833.namprd10.prod.outlook.com>
 <87eefn4hdt.fsf@suse.com>
 <DM6PR10MB3833579F43D640A69C4A39F8A2769@DM6PR10MB3833.namprd10.prod.outlook.com>
Date:   Wed, 07 Apr 2021 16:16:11 +0200
Message-ID: <87blaq41uc.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:3099:4c70:65c7:fc68:d2e3]
X-ClientProxiedBy: GV0P278CA0063.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:2a::14) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:3099:4c70:65c7:fc68:d2e3) by GV0P278CA0063.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:2a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Wed, 7 Apr 2021 14:16:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 471c1872-322e-42bb-ccb1-08d8f9cfb391
X-MS-TrafficTypeDiagnostic: VI1PR04MB6928:
X-Microsoft-Antispam-PRVS: <VI1PR04MB692867CA045F879EB668BFFCA8759@VI1PR04MB6928.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gEGfRPD+v5IA2Y1omiWhxf4ON4tkYZlj07QLotEFUC1ZS/KjatxwI+r3jBdKiELHQL2+h/h31tu+tgII8RLShSdGnuuBuWvvbr8eARvOPEfNuYB330YRl00v6eWCYdQr/OxLKXn8CJnkcV+dOcEOcld6m3XpyRl2h1RSmnbXM8QuUvp4imfkj9KdImkj7KD/VNvXxaBOcP16mlf8VHwGR5Fn2jO1o3Xi4FNVXswPPdyPLHx8Kx/67bsagcG+uZYWl8hCN4hZnunKSCFU3z4BcX84pDBGNBfC03LAXiIQ2DR07cxqdbFv9WCLfSmb3tkQ3Ci3e/RRetKXP4t0lQQ6BtR5epl0VpLKk+x+4LBZlqLBe7XLEYmO0NGxEvFYcLvqRyTF+BFWYMZICU/71JFjOyCn3jYwm7rJm8/4YtRLWk5YIgoiSm0AU8mktd9eIvxbMRrnpacKkzXbmga5ZYjDCM1HZ4ehCVhbE2bU2JI6QnHv20+cdOQ1sXSNUv5xNm5sMe5bVklMnp1teG2dULP1bMVwzyPSti6ZTnmBRi1W0p6iASKQlOBJpclm6RGb+h6h1gJwM6Mt1pAli2zTyhv9aVzXVjsNS5S5afuWHzSgnrR/sXw39qU39jev6n34i1DU1HeukJEnYGYlrncVJnFovw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39850400004)(376002)(346002)(366004)(52116002)(2906002)(5660300002)(86362001)(38100700001)(6496006)(2616005)(8676002)(6486002)(8936002)(316002)(110136005)(186003)(66946007)(66476007)(16526019)(36756003)(66556008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WG5adVE1bk5CbTc2TXk0cDVYenkvRDk3Z0NpVGtlWVd4RHV0d0VPQjUvc0lT?=
 =?utf-8?B?am8xT25GMVhPRzZwRThzbklJUWhJaEZnd1VNVTBXdU5pK0Y2Vzh2aVY2ZWF3?=
 =?utf-8?B?NVJaS3h5bDlNYWhQQkZmWmN5cWZiaDF5Y1BuTGdRYk9vTGFJVUN4c0Z3THQ3?=
 =?utf-8?B?REF4aVM5YjhNanR4UDdzQWlYZkZ3UjZYUlpOQ0lEendSWmxKc05FRmpneHY4?=
 =?utf-8?B?emtPaVU0akdaQ05wa2I2WGZwMWgyeGhaNGpqN3I3bzJFbUl1a2Q0WnlTWUhw?=
 =?utf-8?B?c2F6MkgwUllDcGdsTFNvQ2dUdUhabTRydUh3NnV4dHFscWlvNUdmMm1MRjNK?=
 =?utf-8?B?ZW1OOWM3cWlvMVpZa0F6ckNEb091QnVJWGY5UFR6OW90eGQ4cWJUMWNDUy83?=
 =?utf-8?B?N2xWUDlpV1BLK0Y5UEVJTG1pdjhVZm9IOWw2dklxRGduSnJVb1NVSDhFK0Vl?=
 =?utf-8?B?VG9OM3FDN2JGeldVR3FWOFY4YTVvcXBFbXVzSDIzcEJRNHlUZzlDdjFOY1dD?=
 =?utf-8?B?WklCVmJNK2VDakRWL0gyaXNndXFYSkJveW56UFRYZ3JYTkdFcjZ5UUt1cyt6?=
 =?utf-8?B?SndmbWVhcnNtaHVNeXU0TndEaStQa0h1SjkyS2RqYW5hRStnUEovUWtlMUE4?=
 =?utf-8?B?UncxRlE1OTdXeEpQVkt0Nnc4OStxVXN3ZnBMOTRFL3lscW4wSzgzWWhoWVZt?=
 =?utf-8?B?ampxYVhFa2hXQ2dqMFMwQWkzeHlGRFpMM2hSSFovNFNhZVRsTlNvMFVVZ2xq?=
 =?utf-8?B?Lzc4VWY1d3NYZVlHcFZMd3ZhM2FxZjFLVXlXNklxbU9lbGNJa05Rb0RhTWZQ?=
 =?utf-8?B?QWJVU09KWFRrakhlOFNMVGlrazh5U2EvR0RTUTRkcURGcmJSZG1WK1d3M21C?=
 =?utf-8?B?M2pHcHdMWThndjR0d0NSZ0xmd2IwRDNMTjlVSzJhTlg2am9LWWpaK0J6Unl2?=
 =?utf-8?B?MzVGRE9TS2wxMXcvVUplM3dXR0tiUFVpWUtwcy9TUUNMbDBnbDB4WU4vM3oz?=
 =?utf-8?B?NHJLa3NKaW0vK0dWR1Y1WE1SdUhYQzN0T1BSekpPaUQzNjJENzBEcjZzdkFR?=
 =?utf-8?B?aGI4T0x0UVBRNzA3OElWWDdiZ3lYUmVnUE5OQStHam43MklQcU5OeUpsaTE4?=
 =?utf-8?B?Y2kxb0F6K01wOGlTRHVSclFDT1VQenFCVktmK3h1eEJWdDhUYmErU2MxaGZ3?=
 =?utf-8?B?RHhYKzJYRGw2Y1BTZ1J6bTRGKzNzdWNaeTFXcVpvREZvVllLQ1F1U3YwK1Vo?=
 =?utf-8?B?QjJRZTBweFZXQWp2aVpURVVRTnZrQ3ZPaTRUZ0ZxTFk5d3E5eHprUndkdThQ?=
 =?utf-8?B?d0lEcTF1ZzhLQy9BQzlQSnFaNDZjcWxHN3hrL3Y5eUZnYXlUV2dlekNVd2JE?=
 =?utf-8?B?WnNBQXN4SExrUGNXc1V3UkpYMmh0VlkvaCtRZXZkbHVaQjMxK3hBb2d1WnRR?=
 =?utf-8?B?LzJVNVhBUVZkVzl4VHJPaEVnRDBZak5KMjkyRGlkNEFCelpZMUsyMmxudzhh?=
 =?utf-8?B?R21zUHBhZ2dScFlLNTArWlQySkhNZUp3NzZidndpMHpHQkNGZWR5di9TdHB1?=
 =?utf-8?B?ZTE2cDJvZjFiLzl2YS9iWnU4VkZiL0Zyb2VBb2dmNHJidlI0dUJLTWR1c1FI?=
 =?utf-8?B?M0VYOVpWSUFYSC9nNDk5K1RuejBTQ1hCQ1JBRFE1SzN2UEZpM1JTbkd5WE80?=
 =?utf-8?B?dGkyTFZiS0V2a1ErNnNQRWp3NyszWExPU0ZZcko5cWpCZTVBSE95Y1U0Tm81?=
 =?utf-8?B?b25BSVcxTkdWU3FlTTQwU2kwdHVraG9MZy9KeXJQWG4rb2dYcXBUb3RPR09s?=
 =?utf-8?B?RElYMjdCMlFFWmhTbmQ1cklodEp4eGJRQlAvQXhScTNadWRQSllRVzdkQUo1?=
 =?utf-8?Q?+DRgwOf0eWpEs?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 471c1872-322e-42bb-ccb1-08d8f9cfb391
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2021 14:16:14.0787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +ljXw7GzJ6hDYxXknWSSYbO/Zqk/XLc2fCoDd+raEMe10U8GhxGH347RG6Mhg1Mu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6928
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Seth Thielemann <sthielemann@barracuda.com> writes:
>   This definitely could be a bug with the compiler, I ran into issues add=
ing some printk's and things just magically worked and then changed to addi=
ng asm volatile nop sentinel's to make sure I was looking at the correct se=
ctions. I still think it's a reasonable change to use the ssize_t since the=
 rc is a ssize_t and the outbound syscall path is also a ssize_t. Best case=
 scenario is a segfault in userspace (made things easier to track down), bu=
t will likely wind up with memory corruption otherwise.

Looking at this more I found that commit 97adda8b3ab7 fixed a very
similar issue:

-       ctx->rc =3D (rc =3D=3D 0) ? ctx->total_len : rc;
+       ctx->rc =3D (rc =3D=3D 0) ? (ssize_t)ctx->total_len : rc;

I think the logic is that compiler sees the "then" part as unsigned and
so casts the "else" part to unsigned as well.

In any case I think the change is good. We could change rc type in the
read path as well.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

