Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82EA8C11F68
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Jul 2021 11:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F4DB6135F
	for <linux-cifs@archiver.kernel.org>; Fri,  2 Jul 2021 11:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbhGBLG7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 2 Jul 2021 07:06:59 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:40366 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231320AbhGBLG6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 2 Jul 2021 07:06:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1625223861;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a9OxhcYDHaj6gqL1dN2Inpg25CkyMUq0fbosuT4LGx4=;
        b=gXJw3PGImCrjHnVoYu4xIx/3/q9PCUcvZGQo6+Zn11ZC0Mqd775T4BpxPhwyo0x9dKuSGj
        BsvlV0IJNtI7CEmFteC0U5aEnDzVFtMYJKGfcjkseISkuAGuW4r14vLiWmJRJ0WypMUSrr
        iMVZ6mMImKTSbYFtsbqZuEet4uWPHYY=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2053.outbound.protection.outlook.com [104.47.8.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-36-RsgJb09CNWKFe7Yvf5GHDw-2; Fri, 02 Jul 2021 13:04:20 +0200
X-MC-Unique: RsgJb09CNWKFe7Yvf5GHDw-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzOD5GbmVUMbW9/8RNO2/PQByBZumBl2zAmd9VonNtGkv2tyTqY/kBbm1l7PcKlB9Y/bIhx70VP7Z5MgEXtxTvMsOILChXa+bqXB0ABuGSLpJknK9TvLVvxSzPFfC/xc5UdcSc70GzP2dFil5hjiG58Mx7vJ2GKd+dz1T+dG3ZkjfhI8kUqSLKUSzy0BJrpPaltRzIyVtCvXT3ZwiQjT1vB2327rCXDCQmBnQFkpm8hCVm0KY/jWua/cmoIVekAPaMxlL4RT4jcUX6TSjZ3uqU67Z93HLKo6XwT/cyUqKAiwm3PYV4gvE0OVehFaUtm0SrvNhRckeY+gNnhMrpHKQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9OxhcYDHaj6gqL1dN2Inpg25CkyMUq0fbosuT4LGx4=;
 b=BLmH6YF17jTJLu2Oh0JoI350fiK25JYk/FnovuzLSXt7DS65H8VORayGGK0OuoAPf2htVPQXN2NlJuEhPaSzUrIkEJWcgZcnZDJ6sLyrOoPVTD4VcyahNgM6tLBYWslBtAqucBu8ox1Ex1hREgMHVs0n3nGfLkgzcAwb0Fs+PaG5lemrTCkGFsSc/SAd4N7yZBPmS9OoICno6LBlo3P40fI9YBZMfJHEq33/VVyHD6mhxJbrLMMhSuI/zXmRPcKw7SGlwkhCf50kqNnAXukA1iVIkJtQYrht+FfDSY/3hFMv7IC1916VqgjKqWujemeOYv/Z5v2224oxvT1a/egzdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB6925.eurprd04.prod.outlook.com (2603:10a6:803:135::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23; Fri, 2 Jul
 2021 11:04:20 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d%6]) with mapi id 15.20.4264.026; Fri, 2 Jul 2021
 11:04:19 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH][CIFS] make locking consistent around the server session
 status
In-Reply-To: <CAH2r5muOpGHkvPyxJy_Qbp7gLC4ssL4eBOcY59U9+7KAjFHzcQ@mail.gmail.com>
References: <CAH2r5muOpGHkvPyxJy_Qbp7gLC4ssL4eBOcY59U9+7KAjFHzcQ@mail.gmail.com>
Date:   Fri, 02 Jul 2021 13:04:19 +0200
Message-ID: <87o8blou30.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:709:ff16:1045:9d08:76b8:80d1]
X-ClientProxiedBy: ZR0P278CA0125.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::22) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:709:ff16:1045:9d08:76b8:80d1) by ZR0P278CA0125.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22 via Frontend Transport; Fri, 2 Jul 2021 11:04:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec588a26-82c7-4f40-ab6a-08d93d49241c
X-MS-TrafficTypeDiagnostic: VI1PR04MB6925:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6925CBD90083F23E6B56E6E8A81F9@VI1PR04MB6925.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MZXqYE4FvRDd55voOCAPX4+uyhwJoZjwqrUF8beOIk9E9ARGxQH2/FlUnpKH6DPwV1ebNMoZNa8fOGl4Nn6bQi01wgf8L1nu6Mv0gc0FgfN1zhyiwptJt/7al5e17W+z07jACYBiyb+6b1OnQdRTzVdzhTGk6RFihwb6T2xNHmobKBiWHBI99T4QLZtWwTQsPU4FNPi0QWu4Ullv53YPSCoE/bmrNqk33vtLyRrnCLfMZ2PCIZ93/PEq6DocG3K1JLZhfXGHZZHB4r802gvmHghL5ZskBStwP8OzpQQOqeMbd2wqjACEEu8eOTGU99w7szxzqjSxH9CYnSTuWh+6MIIegvRi/AywPsAVY6hgwVUuwC+MuL5LCRM+rllQbvWnwEbPjnp1GperTWRgyIQcZazaqhSgL04hWwtknfnRxvC3TgRB8ZnbCxshagHhuH9nNPJyf+v4RXpiXPoUmsKiB3vc/4Ip8ExgSZoNJ++w4k8rG94z1TgnaGQGFAYsPP6wKHRPaFUGX7q8pHyU1Fs5yzbzjsmvYm0HotBC3649g6WXUoAj8WxZP48Tb0daOEaaGVR/YQSalV8pLu21M9AUZX/Wflr2tky+bTlduWUQTpoApBl5QBUf5VQkoePbVpgaNNUuvJM2zY0vBiVmnjMIKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(396003)(366004)(376002)(346002)(66574015)(8676002)(186003)(16526019)(38100700002)(83380400001)(6486002)(36756003)(2616005)(86362001)(66476007)(5660300002)(6496006)(66556008)(66946007)(8936002)(478600001)(2906002)(110136005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SE1FcWZNVzc5aG9XL1ZIZWNYTmJXK1R3K3NKRVRETktVdzhmYkY4Y1Rua05y?=
 =?utf-8?B?cTVIZlZ1WTAvM25yaDNpcTZ4Z214ODNFZ0VxZnFQdFpiNk5lNTFvdnVSYVVK?=
 =?utf-8?B?Mk91dzUwYlhFK2xnSVBGT2JjeW81WlAvcDJGdnBXVkQ2aWw1Ri9mU2tQU3ky?=
 =?utf-8?B?a0VpeWh6c211SWdaSzJVYkQxcnZFbEVXZkl0UnY0WmptMUI0NEUzM29QRzRV?=
 =?utf-8?B?Y2plSHhITUNMODlQWXVna0pkbUZ2RnY2WWdNTVhlbDRFNlN0RVFJamk1Vk1L?=
 =?utf-8?B?alphZXNrMEJKYXVqT3h4U3FQNm9HaWxLZDRZUmQxTXd1WGpBaTRwVmI3TUE2?=
 =?utf-8?B?NFNtZ0JWQytEemgyY0dWWVFVY0c4RzZWRWlqSiszRnBIdjlHUE5MK3M2bjhp?=
 =?utf-8?B?K2NoR0ptTHpNZWZkUkhCSGptRkx3aTFiYzB5a0NZaTlvOEFsS2VrWE4wQmhr?=
 =?utf-8?B?enh2WFVvL0FBb05vZURVWEI3cE1yOGJvbUhLeGFlOURpb1Fud0pLNktqdVE3?=
 =?utf-8?B?eDRncWliTk1NbmlBOEFUY0YwRmRnUlRDSlhlNkdnaU1xSVFEelFVbHU1c2di?=
 =?utf-8?B?QnRxQjU0UGt5ZXF6SmFRZ25qLytmOVhhU0dsNzN5MG5mQkpxVEdoNUdsNDlW?=
 =?utf-8?B?UUVFSWZWeVhwRGdXRVAyOHJLakFGRER5bVlJd1g0V24vMUJoRWxJMGNHUHcx?=
 =?utf-8?B?bnhRVWtvbUFWTHJ5ekVzRERzaUJueXdwMUl6RldvdEUvVzE2cG9ZdUhxNEFO?=
 =?utf-8?B?cWVFaUxPYi92VkJLTlBFV3dYYTdEWFNsUGR2eFNnUUh5dm9qWGk0RHZIUmNI?=
 =?utf-8?B?bGJ4TWtDTHpJalVRckxlRGhsZkhLOFRqQTZ4MkRzbDVMOXFFNjZvVVhHZlNP?=
 =?utf-8?B?MFpjZENmM2VzazJ3cFZjSGh4ank1WFhEWHA2Mm9jVWVXWWl5aUhWbmYyeURa?=
 =?utf-8?B?TzRJOUsvdk5XS1hRUlJWTHM1dE1NaWpJOXNkcGIvc0VEU2F5Mmk2MXF2K2dR?=
 =?utf-8?B?UnNRY0piWjhSL3piNEUwd2JGcUdjZWNKTnhRbkJxejBHOGVxL21VUytNbFBt?=
 =?utf-8?B?UjVQaUNEK2lRa1dFK09mMm94NUphckhLaFc2a2x5d29UMjlaSHh4c2dMZEtk?=
 =?utf-8?B?K0dJNmZwaFFWNEFNUEwrMkJyRjJIU01DZGk3WlNhV2xhQnRacTUxL1pMUHNS?=
 =?utf-8?B?WWk4dUo3RGV1QVBsNG43RmtpS0ZPZ0NPTG45Sy9qMmJtU2NGdEZuYURDR1ZJ?=
 =?utf-8?B?OWxzbW1Vc2MvQkR5QnF4dlRra2FYN2RnWDJ6MkFUQnJDVlhZbmw2K3hKcmlK?=
 =?utf-8?B?K2l4dHlQcTdGLy94cHorcEM3L1dzbmpZZUpOY1YvUlU5M1FUdCtad1hZZE1K?=
 =?utf-8?B?U05RRGJnSjY4N3ZLa0hjVk5BRFVTOUZOY1F0NHR2c1czK3NrQS9jTzRJbHBt?=
 =?utf-8?B?VUJ3TlBjTTRmUjFNMG9kaENuazVHZVdndHZxR3U0L1JsaGRQWHd1cVN6ci9S?=
 =?utf-8?B?Wi8zczhBWFJJS01HSnYwRTBGTjJMK1orMjBPaEwxR3BCSHVTd3cxWjhnZEt4?=
 =?utf-8?B?dVVyMFQrbFREN3hGMG5MN2J1dXE3VEE1d1RMeHU4WTRkZU5PdldURWdDc3J0?=
 =?utf-8?B?Mm1HUUI3b2lhRVFxVzVVS2VQdVhVVXRDa0hMRW5GR1JQQW5ERmVxWVVoSVhV?=
 =?utf-8?B?TmVqT2dkS1djcmtMUGJ5c0Rzb2hwS0FqWDI3VkdqTDdvS2JWWGc0dHVzeFI3?=
 =?utf-8?B?TTlCcHJFS2VMa0hlOWUwNmxzL1BlMFBuSEEva21ENWZZNEh1Um53cVlXdktk?=
 =?utf-8?B?eDJWNllVYWZTcXMyZUpKWFQ5UnZrRVVBVG55dy9JRFJIR1E4Ui9zVFVWM1R3?=
 =?utf-8?Q?WGNJphxcylyis?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec588a26-82c7-4f40-ab6a-08d93d49241c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2021 11:04:19.8760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NEzBxh07XkooCNdFKdRL2ijXmG41IpXGweqbCdcoJS+8xvGPHgncCEsOVaOanAD4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6925
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
> There were three places where we were not taking the spinlock
> around updates to server->tcpStatus when it was being modified.
> To be consistent (also removes Coverity warning) and to remove
> possibility of race best to lock all places where it is updated.

If we lock for writing we also need to lock for reading otherwise the
locking isn't protecting anything.
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1358,7 +1358,9 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx)
>   * to the struct since the kernel thread not created yet
>   * no need to spinlock this init of tcpStatus or srv_count

    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There is comment just on top saying no need to spinlock.

>   */
> + spin_lock(&GlobalMid_Lock);
>   tcp_ses->tcpStatus =3D CifsNew;
> + spin_unlock(&GlobalMid_Lock);
>   ++tcp_ses->srv_count;

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

