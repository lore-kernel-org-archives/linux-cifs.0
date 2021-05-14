Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CCE7C43460
	for <linux-cifs@archiver.kernel.org>; Fri, 14 May 2021 10:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F37FD6143D
	for <linux-cifs@archiver.kernel.org>; Fri, 14 May 2021 10:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbhENLBC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 May 2021 07:01:02 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:26424 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230506AbhENLBC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 14 May 2021 07:01:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620989989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zugs79pSAgXzkEQM9lNhDUOLg7k//I+6nOz0Mb+zfdY=;
        b=j4qC8CKAOF8tViJGiSo1Vo2ocVOhy1IPJAwLPE6/nhBDMGffG3+pwDoBSl1Bj7pZPFALhg
        /RgxKGeGe+NSI2+Aj76WyvQWGUZ0Q9JsIPMkAGA505VYfeHrvudjJ21x+OHDAyL9nr39eK
        /syGHapOltislIospCsxoPlOGPVoP8Y=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2058.outbound.protection.outlook.com [104.47.13.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-15-LNzM6ylnM8eJOXsoCfas2A-1; Fri, 14 May 2021 12:59:48 +0200
X-MC-Unique: LNzM6ylnM8eJOXsoCfas2A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c9NkOzqeArNMmD1qVFoW5561rGF/5l/ZXdAtF0gEGPCuUCUxC2hg9lMiXb18eeNR2B8+Zdu5hHUPuYsSmwfTZpY3qdN4bGRUQOqZL9R1VKUNh/ozfOsl2ToSTiAERLdrOPGH0uGIjFckqQnSDeL383WuNVw2U0+Dp85nJR3sEompC+cFzhaMrOBV5IpfRPNNlt2sfN9a/RdVrNWqYIxDps0Vdo24MJQtz9SGIIi0zorzV4hk13PtXXubMBJlb9R8hJBw2MbKOYsG0H3WZFaiAUMVtdG36EGybuqvWpolI0W6PpIySKP31d6qyIk/3l0qlOJPO3TdOsp0JdKCPzXbbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zugs79pSAgXzkEQM9lNhDUOLg7k//I+6nOz0Mb+zfdY=;
 b=e5x/BhzcYaBZYzb39jriYTorfb17BuuJOStLIVNbnOVCEPEBgIiYZ3M/qWRUamRPZIn8kZYmA49AgmKrBdW6f0qlkMHo4KPv+Xvb23YHKbt4f/Bp8D+h9/9Tm+c71PeLNWDWPW/a0Eq933/M6owgwb/PC7tw7YisfD/pvr5LREmyMf8exCguEK8tgG7BtVVxQvq0pZZmYBfABddTKQJsiA3Jx/70cQl6k4onHW4LR7KgVE3CbL9OLqmeihYCFCSbEzSSgMRQkp2rNBawECsEC3Chr4yW0WZyAUyAo8rRLKVFp4hlBBmVJnbsVB9VY4SjY0/yrq1pTolk173h/BF+tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gwmail.gwu.edu; dkim=none (message not signed)
 header.d=none;gwmail.gwu.edu; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VE1PR04MB7485.eurprd04.prod.outlook.com (2603:10a6:800:1a6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 14 May
 2021 10:59:46 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4129.028; Fri, 14 May 2021
 10:59:46 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     wenhuizhang <wenhui@gwmail.gwu.edu>
Cc:     wenhuizhang <wenhui@gwmail.gwu.edu>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: remove deadstore in cifs_close_all_deferred_files()
In-Reply-To: <20210513165516.17723-1-wenhui@gwmail.gwu.edu>
References: <20210509233327.22241-1-wenhui@gwmail.gwu.edu>
 <20210513165516.17723-1-wenhui@gwmail.gwu.edu>
Date:   Fri, 14 May 2021 12:59:43 +0200
Message-ID: <87sg2pshr4.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:d396:524:65d3:25:9e8c]
X-ClientProxiedBy: ZRAP278CA0003.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::13) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:d396:524:65d3:25:9e8c) by ZRAP278CA0003.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.32 via Frontend Transport; Fri, 14 May 2021 10:59:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8934cbe4-67a6-4b4c-0aa2-08d916c762a8
X-MS-TrafficTypeDiagnostic: VE1PR04MB7485:
X-Microsoft-Antispam-PRVS: <VE1PR04MB74859327419EB797CEEB332CA8509@VE1PR04MB7485.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b/T6oQenlnQQv/yKmzL8tPjskgzY+FdA/hQpncmDHgo5QAsjSLqk9Fb0GebsVC56PsNzq59BW8D3UVOhXBaR3L2wSKqYqf4yqpXyRoQZM5THbUM6MFlvUiAmQkl0oKjCtd23oimPSYATfqcz1LK+r/nQHz9PUJKVRkAX5XcbxBeCwEMsBdL7CDH3GZVHA95gaJe8alc2j7je47/nskl1GsZrH+9tpjMh3Z40Nd25sZlzCylWx3bSjxN0QSx2U9D3XGtt+FHH+4WQJtWDo8oWoqD2IhVdGARQtxiyVOTVJ9LffCAAhCRUBdeuZDPRsdeDD1EnjdtDH6TSKuAaae+U6fXRPj1+FryfjRhGkpg3pVfVI/VwNqg7RXU0ldj4/tBDXmjbEvpqmIDEHHIRUT7e09VZW8e2hipQPdp5zJ9XP7cwr8myH+VEDsg6LRsVxtV/F4Gf2efTj1605MoPdMCfus18GlRbUCRb434APEi2RRyA/u5Lha1yvuBBV3QDarccazXZaJ+mJzjuzwVFQSl4Y1j2ewQwTGjMx6gA+5n6PP/kjCckBm5VTaKLm47X0gYofskcVvhKTedJgJNmVk0iLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(136003)(346002)(39850400004)(6496006)(316002)(66946007)(36756003)(4326008)(478600001)(66476007)(8936002)(52116002)(66556008)(8676002)(54906003)(6486002)(5660300002)(2906002)(2616005)(86362001)(558084003)(186003)(16526019)(38100700002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dDVJYkNEMkg1NDRoZzF3OFFYQXVyN3hML3Z0dW44eGdLRFVRY3pxdnlEUzhz?=
 =?utf-8?B?N3YrRHU5Ly9URVFSbU0vcXBGZ0VSajlrUkhWMHI3amhiOStiZyt2WXdtVi9p?=
 =?utf-8?B?SWhDc1hLZE9HWG5uREwvWXNEQlV0QkkvQlZHc1BieVpJbStUM0JLV2YxMktM?=
 =?utf-8?B?WVZ6NzhrWE9kRXdoUkU2R2pvUm5VSUtxcnFGYkFabmRaWENhckNVTldlTWhw?=
 =?utf-8?B?N2cwd3kxbFJOajVMOGswakRTSjh1QzNMQ3NZRmd3QzdmbFdTSVhzMWZTWW8w?=
 =?utf-8?B?TkVabDV4Vm9SeENqZWg1VXR4QWpTU1UwVmZlM3JmeEwySnBBSDk5UVhmS2po?=
 =?utf-8?B?NmsrK1hBM1psM3oycUF3L0pIZTVxU2xNSkk0dzF0aFMvaThTbVZacno5cEp2?=
 =?utf-8?B?TVBicFhydGNweUlkaUFqMHdoQ1k5T1VhSURFQ1JLME1pd3lHc0JOeDhUSDBx?=
 =?utf-8?B?bHlpd3hBUExzV2FvUUZ5WTg1U2FrbnRKcG5qYVNXZEMycC8zQlBmdmkxR2hk?=
 =?utf-8?B?eERZbWljQ3FlZHNIRDBtbW5pYlZFN1JiL216RW1VanJiRm53WWJQT3BoemtH?=
 =?utf-8?B?SlJlUU9VMTYwVEhQdkh1WmRGZmk3ZG1TY1NiVmFJb1BqUy9iS3FVV3o5L2pE?=
 =?utf-8?B?U04vemMxU0pCc0NDSUV0R1g4NUNsbWpvbFFPK2VSejVVUmUxUXR4b1AxWG1C?=
 =?utf-8?B?K2JVb3djeEpEM3k0NEtzR2k1V2lpelFSNnNzM0hRdzl4MjM3TnkrbUVjenVx?=
 =?utf-8?B?dXJ6ZmY4NDd5b29OV3J1SGp0eHBnR3hxMkN5NnZ2L0I5dWNvNlRuOXprK3lO?=
 =?utf-8?B?cjFqcGhNOThlNTZlcXN3VFhyMFJiZ1pTVnJWYXRrcTRmM21EZ3B3SHp6NzJs?=
 =?utf-8?B?N1J6dnR0cXFJTllEdVZ4RUFWRld1WDNSa0J5Y1hrdlkzbFZreldVQXoxSXZT?=
 =?utf-8?B?ZlNlbVVTRVNoWjBaaURFUnppNWsxbUJFRUlXTzQzWmNOS2p0eVhtbE1xQm54?=
 =?utf-8?B?eVY5SUFjakhRQ1hyNkJpVjNTVG5iRE5OakZ1WlIvTFNPQUx3TUIxWjEvU2FR?=
 =?utf-8?B?Z1ZSOUY3WDkySlc2d0IzbmJFdWpYUytneHZmam45ZmpnV2Q5Qmx1MnRvcjk4?=
 =?utf-8?B?dzJyR2xyaXh0MzlhTEpad2lHV3dIQSs5eVI4c203dzJaR29TcEZHWTV1Znhu?=
 =?utf-8?B?Y2QwRmpvdUNwWXRwMDdaQkhzVkpqU05OYzJtMzM2OFlCMklIOThNUU9KTVY4?=
 =?utf-8?B?dEt6RkZWRm1TU21sMUtnOGZVZVZiaVZkMDdiRHRyVG5STmVscHQvbDFmMSs3?=
 =?utf-8?B?TkVxUFRldXFiaEVZQkZSR0ZnNVZvT2c5MGhueW1WbFdXZGRoSjA5UjNaMjN3?=
 =?utf-8?B?Z2FCcVExTXA3NWNPMFVUVmVsWkhCOGFPMmtTSFBRSWhHRW85a3pGaFJlVWdR?=
 =?utf-8?B?eUVydmlUeW9Tak1TR2ZXdHVsaVAybHcrbVdsV0JRY0lTdWR3bHpjODFlREsx?=
 =?utf-8?B?UFVCcW5tbVIxQkVTUTFEZE50Y0hrZUlZdlVtd0NlWUxkU2NXWlVWVnpaUTlU?=
 =?utf-8?B?Mnk5Z3JpSEhUSDhNOTF2bHdrb1d6SGpyYzhDT2JSUjRjKzAxd0hrR0hjTnVC?=
 =?utf-8?B?OStLc05WMjRCeWc5bjRqY0tsbEhGWmVUakJ5Tm0yMDJoVDV5OUNUcXB2aVBk?=
 =?utf-8?B?c0hzUVIwdmsydVVZaGhNbk90c0JSS2pDLzlFc3VFZEpsdHAxQldweVQ2djBp?=
 =?utf-8?B?cngzRVlQdmdvZllZMFgycmFIV0tnalQ2MjkyS0l6d1lDRVdrc0NGaG9YYXUy?=
 =?utf-8?Q?S8QHRhwnzlixMlNvjtO5laAPgfl7j0ie5DNTI=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8934cbe4-67a6-4b4c-0aa2-08d916c762a8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2021 10:59:46.0268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Ko8PRYpvth0eGQt0lR1VTqX9htw09qtVaqJq04wPzZ5TSpsixP87jEz/7lt5zVG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7485
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

