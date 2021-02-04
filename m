Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05BF5C433E0
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 10:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B24C564E0F
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 10:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234965AbhBDKS1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Feb 2021 05:18:27 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:47302 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235311AbhBDKSZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Feb 2021 05:18:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1612433837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T3AcSCz6BVbau8ZArYS5fTQk8aAMC6phAbtDQz/Dslg=;
        b=HBIlZEp7XKceeW9jMikmL2dYC2ds5KHVo33cxfRA5fS3RMCTi7od8IkdkPJ3z+Gd3PLpPU
        2PIzo03Q6qR3cv659js85PnVi7FvVxqtCF2PPJMmASelUNo7Qhm94JhpwSoOvlBM+sdpn4
        hFvA/PJmSUFP5ko4LvEVinS+F9SvYXg=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2054.outbound.protection.outlook.com [104.47.8.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-17-xeVj4rBwOo-6y109ZUMH2w-1; Thu, 04 Feb 2021 11:17:14 +0100
X-MC-Unique: xeVj4rBwOo-6y109ZUMH2w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A97kmsMJ905lkFDztlF7m3R3eVXjyX9xMsoHR5oWiJQBBwKsRD2oiqRF3MCXy7/vUNV45oACk4U5hN+6vbvlEdV8lYypOtbxw9pdIbyEDgT9iUSLnFrUPFqdQd8TCL5d9OPr5YXno8CTCFZ+fq6WG+arpITgZw70t6A9DQQ2tzSmPcDxln1LUv3vohr5C0WL5PnwgxrspDQDwb/Ipu+v1ptYDKoteHMY9tjibO6tBziBQL5uAROf3Ey4WHvgsW/Uee6m6wwXJBpiMxj+uoXdgD6UNi5/0aw39hzMq1+oIiUUFDwUFmFUhOFIpVIWQdPJ9ccD+jJhnz9EqTFbzHrMgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3AcSCz6BVbau8ZArYS5fTQk8aAMC6phAbtDQz/Dslg=;
 b=Kk/dODIDknejKv39TeerfmB869AQp2OBluY6dBNPK9mD1PYv9FfP/ZuDnnGicJWiVcn7eL5a8D2B4Q4ab7FvUbgV9qqbQfC2qejixcx1WVpBg5s9r6hh2DnaTOZ53C+irAYNuYkihQUIxqVRWsKWjC5b/N3KipYLBRxvi1w5WNo92nHC+YG1bimoBpH9Isy4ucYSFF9ne6plPzDmxR7CdaJ2qeT9ttbxpfaPgo5zk3MpLZGW8W+LR1C7RUYl/CZ5AVQU0/H9X4BIv3SzHukiOTGCKZIDEdgUqv4kC3OqFMBnuucM/nH1UaPRL2W/EwqdULXO2QGntVvr51VEROeXtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VE1PR04MB6526.eurprd04.prod.outlook.com (2603:10a6:803:11d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Thu, 4 Feb
 2021 10:17:14 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3805.022; Thu, 4 Feb 2021
 10:17:14 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH 4/4] cifs: Reformat DebugData and index connections by
 conn_id.
In-Reply-To: <CANT5p=o9Tw9E+o3PWytsNh5eDKxswJ+YPLZLWac7QwR_u-UJaw@mail.gmail.com>
References: <CANT5p=o9Tw9E+o3PWytsNh5eDKxswJ+YPLZLWac7QwR_u-UJaw@mail.gmail.com>
Date:   Thu, 04 Feb 2021 11:17:13 +0100
Message-ID: <87h7msnnme.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:9b05:ee03:72d7:dd87:90d5]
X-ClientProxiedBy: ZR0P278CA0044.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::13) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9b05:ee03:72d7:dd87:90d5) by ZR0P278CA0044.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Thu, 4 Feb 2021 10:17:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38118e76-89f2-453e-b790-08d8c8f60aa0
X-MS-TrafficTypeDiagnostic: VE1PR04MB6526:
X-Microsoft-Antispam-PRVS: <VE1PR04MB65264D26B91CDB630B1CE5EAA8B39@VE1PR04MB6526.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 02Sw4rC3g0bzD62Jf1/9ckHeE1jmHcV7SO54F5Qp5TN2qU7vicZyJGHj65Le+20sPDxJ05UMHCVwFun/6nadLRejHEF9jzbF8FjOsZgab9Hs0YxOfDquOTIOMMidZ0R2OEWIUOwDbhz22UEGu7n+isZBa3FI+/8pe8D8Ls+gnxCpK2cZXSoi0dBM4RSdSFbe9Ya7hxQ9k9oYvhG1s0KbPibh12Vuzhhtxu1X1pVTh8oyFme5E8/J7r6fX7DKpzbS/gmix0MfQXJw64vqy321lW7vjOKGPHU5ywcyWpXUB8wpUmern0gHWY+VCZpchKyuAsn3CNNf+jZT7iyumMybnjfLhTDo5RX5hUQLK8kAiC4/3rjSQXpPlAslb+R0AVgbT9/8/zaw3jmNcOYuAokgpDEMT1Elj8t0OZZR7dyRD2kZJj9ErvtzOR9juvqIO2ppbgageRWLDZWbiVqjSOGcVlzubgiGSuxwuSfHUkbZCV4XTRrFL+KGh5vXRbzKg1nHmb70Vd0fJxQslvIJyRO0HA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(39860400002)(396003)(6486002)(558084003)(478600001)(86362001)(186003)(110136005)(16526019)(52116002)(2616005)(6496006)(316002)(8936002)(2906002)(66946007)(5660300002)(8676002)(36756003)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VWttMWhhK3BhK2F0ZW81MFlDMmFxOTFOTHp0RUFHUlpOb0tXYnAweElhS0hD?=
 =?utf-8?B?d09xZU1TNGV4V2RsUXkzZFZFTnduYU1XYUp3aCtsM3N2TjJGaWJGYnlXZ3Bw?=
 =?utf-8?B?ZnN0NXhrSGU0UU4xekhJVGs3WG9CN24xSTZhZmNDUU55UEtzc1d4MUxTaHVy?=
 =?utf-8?B?ME5LbXhhOHo0NStHdWhFUE53OXRRSnFmK25aRTkrZUVqbW9wTDRkZzZuU1BZ?=
 =?utf-8?B?NTRUOG5EdlAzc1puRHpTMHh6QnVxVHV4TGdxclFZZUI2MHFaU05oaG9XVkU0?=
 =?utf-8?B?Mi9wVDRLSGJkTzJ0QjhURlIyL1JNcVh0VFJuUCtwVGp5eFlDNG8zb1Y1S2ox?=
 =?utf-8?B?SWNnSVdIZCtZK2VNbVNxTXVOdWFjYmsvU0JIenpTZzdqdE9iZlFLSFQ1QkRV?=
 =?utf-8?B?akhwMUxPMis4VGUxRE1LZ3BtSStRSVJHQWp1RnhGczh3WGpWSG5KeDA0ZGxG?=
 =?utf-8?B?TVJyT3RqR3JUK1hTdTh2cmJKWllXcFBzUFovSlVzK3dTL1J3SXExSzg0em9F?=
 =?utf-8?B?YmNnUVVTL01JdUVrT0xYMWRFZVZXcXdCWWY3QWZQSzJSSnoyaG1LTDg0Si9X?=
 =?utf-8?B?azhjdnU3RUhtRi9mbTNSZXZFRTAvYWEyMEdIRGNoNjRZc1ZvTFBYNFc3bXF1?=
 =?utf-8?B?cUgyWTBQSHhKNjFqM044WUpJRWczNkxCb1lEb3FOZ3JkcHVycjByNmQ0a3pu?=
 =?utf-8?B?U2IyWjhjUlUxa296WE1yRlRnSXBQUnZSN2VLVDdTVGE3VkJSSkM2WkZVSklo?=
 =?utf-8?B?Qnc5UjY2UnBYNHlwTkZGVzZMN0ZrNldVQ3JTQVpTQnZ1YjJxcytKb2hRS3pj?=
 =?utf-8?B?L1ZGc3oydlE2RnBmdU5zSDZxSGE0T3phUzJhRndoMjFGZS94U09sQ09ETWFS?=
 =?utf-8?B?dy8xM2J4NG1tanRacU50WktFU1VPS2hSRHNROVZETWlPYWlDTTZUMUlqUGx5?=
 =?utf-8?B?d2hkMlJEKzU0dWlsRnp5Ty9EQm1ZSGVtSW9qWnd2Q1ByYytJQkMwV0g5RGMr?=
 =?utf-8?B?bTE5SVZrdG5UcU9tY2xTcGYramdvNjZISFBIanJXbkk2UGE2YUZLTi9lSDR6?=
 =?utf-8?B?TFRkMjhIUk0zVnJ3ZEdaaXF1eHBZVVRtbE5VWWphcUJDdmhTeUwwOE5JVnpo?=
 =?utf-8?B?YkhSVlgvQm43dHVYTWxvQmpPbEZ6VzQ4dG5sTVZPOVFVQ1BFK2JHcXN0cWM5?=
 =?utf-8?B?U2hibHZQbjIwc2dNdEZwMXRoQ2VFVnJYT3JiVCtiY0MzbXFRSmNuYmlxdlgr?=
 =?utf-8?B?TXFGdVlmS2ZSbXQ2allQR3FwMzFpNkhyMHpYL1NVN3BLQ0RmTCtnbVMwT3Vy?=
 =?utf-8?B?aXdaa3VTWTd1OXZiSTdpdzdwS3ZFTExHNGRETnVQSG1ybVRvKy9vTXF2cjI3?=
 =?utf-8?B?bkFUQlJiRGdxNUlYM2RmbTNNSVplZW9iMHI1eVhXZThyY0Z2YTNucjBZRGFP?=
 =?utf-8?B?QlhCSUtaK3hxdHBsVmdmdURkcU1MMkwzdzZ5REt4TG82TmN5MlM3eWh3QmNq?=
 =?utf-8?Q?yvVJpNnUSfDdwjDoSyBAcv+uohy?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38118e76-89f2-453e-b790-08d8c8f60aa0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 10:17:14.0539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F3Lnw0NKY7oIP8wX9L0f02sZ2HyAfCxyjfBvg4eGgL1L7eji2TcrkV6GG4KGaHe4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6526
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


-ENOPATCH :)

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

