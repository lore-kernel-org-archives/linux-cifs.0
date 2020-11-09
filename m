Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 677C5C2D0A3
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Nov 2020 17:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FC1420E65
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Nov 2020 17:20:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="AnxaTVfq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbgKIRUm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Nov 2020 12:20:42 -0500
Received: from de-smtp-delivery-52.mimecast.com ([62.140.7.52]:43151 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730806AbgKIRUm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Nov 2020 12:20:42 -0500
X-Greylist: delayed 10911 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Nov 2020 12:20:40 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1604942439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D0X2Wm7xzP51fHi8t/qF350d2dBeewkFt095mYMvFYg=;
        b=AnxaTVfqDw9Ccn+3kR5ZEZedncnCkMAQyq45lb/H1ju/RJZMnOkybCEFcAlXnPA93UTquQ
        Irqm7ZIubtBWM7gOvKbOp6Mfr96HCuShDVHOg724qXsAEKd2b4Pr7RSQPshnoYUWBDDNAb
        OzYVS+GpRCLan9vy91gTYWXfUQF1u7c=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2056.outbound.protection.outlook.com [104.47.0.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-18--wlMDly5Oz2sZeH5M9ZzWA-1; Mon, 09 Nov 2020 18:20:38 +0100
X-MC-Unique: -wlMDly5Oz2sZeH5M9ZzWA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GSWm40t92Dqoys3I773O+bJL5ORIDF2j+V0MydZVBtdfwje++dmUSm3USxt7iSVFt5g1Q4XLWP6zyqHF/3tr9zZ6GsyGp6TiqSGHo9jtscelmVN7YiJHpoFKvG4RgqRBro6lUoziKxoAidMvSZf95WF1VexQz0P+w5GQt2k7xVoBjHObdSnp2UMa2eS2eOCSX6niyx2OeYl5qcCafyZs12amYwRxmLj6cGFMjSGZI/H52oaeprXiq1E1Kc4W0Umt9cNMUwn8xmDZ2pVULxxIFQs5WtoRfoU/c+D76AtsCUOFZfgxcETp85FTh5kX5eNzjbDeMb614cqyZmH6oxSY4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D0X2Wm7xzP51fHi8t/qF350d2dBeewkFt095mYMvFYg=;
 b=gloGryTBjTR+qfUuXNK+3imgMp5SX5Z61xnW86wFffeDWUc5/P76D4xly8WPptRJmibt6eWYHHeIo6J7Dvwaw+tIzOofAw2aj68qP4ypzOIrNA32fukE1gSUcFzAsbTuQM+LhcDibsIyzXiqaUJj/0m1EwgdQsV9Jxj9QTwjj8QkxiSsOx3GtKoYd30vSYJWdgT7K7EHCTYOWAgiy9JAku3CASwozVRQAVteGHNE8kfvp/XctcNODooy8a0EikKCHKNHamQNxwfH9FrtXc5ajX13zwPSoQr0n+Mdp88feamgJfTiHjbXmfVG2Oc/Nfsc/ByufBpe43CQo3l3Gwm+/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: nnit.com; dkim=none (message not signed)
 header.d=none;nnit.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB6927.eurprd04.prod.outlook.com (2603:10a6:803:139::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 17:20:36 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::4dad:a2d3:5076:54f0]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::4dad:a2d3:5076:54f0%5]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 17:20:36 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     "SNSY (Sune Stjerneby)" <SNSY@nnit.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: Stability problem with 70+ simultaneous CIFS mounts
In-Reply-To: <DB8PR10MB3193DF33207A5D8EE5F340BEBFEA0@DB8PR10MB3193.EURPRD10.PROD.OUTLOOK.COM>
References: <DB8PR10MB3193DF33207A5D8EE5F340BEBFEA0@DB8PR10MB3193.EURPRD10.PROD.OUTLOOK.COM>
Date:   Mon, 09 Nov 2020 18:20:33 +0100
Message-ID: <87sg9itpjy.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:6850:d332:5221:af3c:2ef8]
X-ClientProxiedBy: ZR0P278CA0006.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::16) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:6850:d332:5221:af3c:2ef8) by ZR0P278CA0006.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 17:20:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fdfda54d-763e-4704-5e62-08d884d3c598
X-MS-TrafficTypeDiagnostic: VI1PR04MB6927:
X-Microsoft-Antispam-PRVS: <VI1PR04MB69273F737B3D1C49CE912FEEA8EA0@VI1PR04MB6927.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2WlvO9aODmVk5BIivUVUOZuwebPSH2W+0zbRLbCjC/qoWGvJWg1OtzSP3jp2xSCq5fz75grHlu7ZrYP2kzLpcFWpZfOuiEVVctZFlB+huLg9IOl+6X+6T3feUgqyZTTsOT4AHYsRxYa2izuuuubUoMoQguTMWe7BbXKahBpB6ltMa+LE01TUai2nweSZxl8tYlXRek0xQ4tbAwiFRyrHoYtHEcQhsuBKscwOpSgXqmj7g18SNPi1pnTmdPgp+jFqZmFK+U4wV6LpuE+9pirMZEw87Mu0nP3g0/uLe0mBAwMUfd3UVziCcHbNNXf2AErWpFJUTitVPaXHRudygjGC+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(396003)(366004)(39860400002)(4744005)(86362001)(5660300002)(6496006)(66476007)(66556008)(186003)(16526019)(66574015)(8676002)(110136005)(478600001)(6666004)(36756003)(52116002)(8936002)(6486002)(2906002)(316002)(2616005)(83380400001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OPeGUa18zKDxC8VcqOlI4wHxxxU4UCUKgNZzqP6IyLjc3955Y3ANCiz9LXw5y8TL3Ol1pKY8opwCyU7RkOJsi1UUmgOYSKfSc6QWLfmQ+gAWaXy7m8cV7D75B2EzgJSB2EP8k/Hkpy5uxD+0TS16imqd63CT5KIl9GzQMe5tMdnb/BokJnrZijIb/tmEeKvK4NLGRmgCRSlgzB5BfmLGVOwhUwzslgP2QDtmmL/RUkDzPjr/5UMrimKX37YR5A3Ip2t2X6wMMG1EiWr5tUH2bLQN3CsiMvN5AxVB/kxWHDXed5uH4115P+uRCZp340bs3kAa8sbJD0a/pPRhy6RmdYStEVzgCkMD4YeU2jfcsamAEtuNN1BVhEN151ishpEpcLZNxL0ax+doOPnOVMy0nyUXjnluo7Xd+N33Cbfncm9ggHznXuneAoSMP/HAQRqrZOzM/kqYuQ0pQU6oFlrLgzsD517u0Et4/a1BgM/AunLwW6cMO0GeZfC9qCdnAtb8BuO7Oqn9prWzzECLPw0yNJ6esG6K6ejbGsfnD9B5gr2Q3rMWyIER9Oriqo67G0mK1TDuAlNtMGBoaiBpcbrIn+TIpZSyP8P99nS36A/felfq2F2diYOYTEFkxXbmCvtC6Sa3PVhNDBsZGeE1e/0j692V6vrN5ItV0dErCAFYhRGzte/IkDgUxXlwR/zvlvaFW6NLKoC3cfKs/EZApIp57Q==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdfda54d-763e-4704-5e62-08d884d3c598
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 17:20:36.2417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IeTlGMw9kpR7euncz5ezq5MLFqvEMyePI7thpRVUpUF0WpM/JaTNTyXpnmqMXlE6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6927
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

"SNSY (Sune Stjerneby)" <SNSY@nnit.com> writes:
> Nov 2 15:27:31 myclient kernel: cifs_setup_session: 40 callbacks suppress=
ed
> Nov 2 15:27:31 myclient kernel: CIFS VFS: \\myserver Send error in SessSe=
tup =3D -13
> Nov 2 15:27:31 myclient kernel: Status code returned 0xc000006d STATUS_LO=
GON_FAILURE

It looks like login failures. Are all mount points connecting to a share
on the same server?

> Any suggestions on how to proceed? I suppose the next step for us is to e=
nable additional debug, and collect tcpdump captures.

Yes. You could try more recent kernels as well.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

