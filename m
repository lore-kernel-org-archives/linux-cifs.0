Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A94C8C433E0
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 10:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AA4264F53
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 10:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235126AbhBDKRe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Feb 2021 05:17:34 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:46976 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235355AbhBDKRa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Feb 2021 05:17:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1612433780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3dd7CXWW/PKnUzA3uzPUG02a8i8FlF5xhFimo1sX3cU=;
        b=fDXCIzsbjJSChXHA+qvseagazXEfYGvt16kp7eGGkDmSZgjsnsJVaWNF45bRkgP/er2VWI
        BRD97l0TTwquKWUQ6/9cq7wexjmn4n2NZYLk16ogILayrGRk8gvU3neoMUCF7GwyiiyJM1
        ZtV7o77EqQKxJwrkShQ14bHpxdVyS/s=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2051.outbound.protection.outlook.com [104.47.4.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-19-Tz8ob6QjPcSedV2UAXYmTw-1; Thu, 04 Feb 2021 11:16:18 +0100
X-MC-Unique: Tz8ob6QjPcSedV2UAXYmTw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MylNGrn3XyXR+BN6p8ReHzVmuC0CsEsI+JHXnkwj7FO+RcSk7l8W5NNeqSszgXcdaOiIkzJkCHtjfAnTKnq/EWk1gQRzaIBY+ydf3OA0hbT/6afRTUFKfAVIUju2IEQJx+a6iAHpQTGuI7ogrWGref2VmgumK3YFDzhQmNCARTDgRKOYaipcqwu/RifEvtTg5XmeBouYosm7hgwbkzwztfIAQ87GlF+r05F+zf2om+qktkPfoaw9DoXqNpZ6a1p+3HaYoFI4IAiZMikRY7O4JJf0/X0s+PQHz+tmSXVWplfoXtnUFc4FOCh6dzI9DX1D0/HZ6xMM5ajfF8fESwgKpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3dd7CXWW/PKnUzA3uzPUG02a8i8FlF5xhFimo1sX3cU=;
 b=GEW0SiGsQN4btTdc4p/KOZqRvOLZD7IPCT2aznec8XgpOSVvMcqGXdhYsyhKlNnBMy3W43DmQj9sXpqDCNjtnpH2H6Zo96RT4L76ArvbzGdAnsBDG0WW4r1svqKhhWYItV2sukRtz6EzZ3S1jjyuxqQ1XUU64pSdI9NQlqM2oJUxwekedmFdWGiRE5FKBwAN4owXGqGSM3CjiixOAgSNVgJ9QXOiTmQNnJuHim0vTRFwf3TxvjTFN6w6Y4LegJVnI6pC6XBelxeBcGMZgjrQGjtYc5Bn331qKNFu+QMnxPzwrkQLXb0DpQMOjAblZJheYOr7LbmqBHAhlKLXmP0t8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VE1PR04MB6526.eurprd04.prod.outlook.com (2603:10a6:803:11d::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Thu, 4 Feb
 2021 10:16:16 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3805.022; Thu, 4 Feb 2021
 10:16:16 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>, tom@talpey.com,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH 2/4] cifs: Fix in error types returned for out-of-credit
 situations.
In-Reply-To: <CANT5p=oaVbe2rz-38J=_XD7DqZN48Bap-myJW9v76=JLTvAetg@mail.gmail.com>
References: <CANT5p=qFrK960mVaHD_zESh6prnHRLU1KeudOnbS+nqSXwiBjw@mail.gmail.com>
 <CANT5p=oaVbe2rz-38J=_XD7DqZN48Bap-myJW9v76=JLTvAetg@mail.gmail.com>
Date:   Thu, 04 Feb 2021 11:16:15 +0100
Message-ID: <87k0ronno0.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:9b05:ee03:72d7:dd87:90d5]
X-ClientProxiedBy: ZR0P278CA0039.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::8) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9b05:ee03:72d7:dd87:90d5) by ZR0P278CA0039.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.21 via Frontend Transport; Thu, 4 Feb 2021 10:16:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c26f160c-fb2f-4010-7cb1-08d8c8f5e87a
X-MS-TrafficTypeDiagnostic: VE1PR04MB6526:
X-Microsoft-Antispam-PRVS: <VE1PR04MB65263C7EF8134058CBF40C55A8B39@VE1PR04MB6526.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gpSQhbZtiqn4wzCZrf0W3PWjZtoEkxDPrYSBPSuAOYoPdmbEKjovH+Jl8Q2W9DlTWuEMAmKEX+Oys725JyDLhWnq4/0gAas/PFd/s+Eef2/RapLB4FEAxLYCrWbh8TB8J4f3iSt2XIVbH42Zy6hXqgHZDdPgYRgl+0+QTqmPGH5eAkCfD8M2mTdBNZxZR/gI2W/KvpM3yFT3Sh5XimszG46S1I6Gfh6Cqu5gXazZgrvYMdzNkdeklR+tu13M3lPF5BlzsxicqMMoYGSrOdhM58E7yZTY37DhSrxHh4XReG/P9Gmo/wAhQsT7Yz6W2yAUdE4N6Uixmal/4t+xbcYR4PBAejFgu6IMK/Dr2eaU2tSj/1bZ0J4MHKWTVcpqtEuX6uBCSojYWkwhRZJespGpaq5mdVdmPqZgkKpH5NTF/Xeyt30qDP5Y7vPJ4XY52VC/OX8zEzOUJEeFDpJ2fx5V+I+KaQzg/krnt3Sse6QZTywcXDzSUFzpgmlYfK+PeOlUdpmzndwmKNHhEr/AUlUUpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(376002)(39860400002)(396003)(6486002)(83380400001)(478600001)(86362001)(186003)(110136005)(16526019)(52116002)(2616005)(6496006)(316002)(8936002)(2906002)(4744005)(66946007)(5660300002)(8676002)(36756003)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aUhwOHhXK05mUWI5Sm42SGU2WnBNZlNKeW1TWXNaU3NVUmg2ZVl5S3RvbnU5?=
 =?utf-8?B?VStCMG1yMlFkZE9wd210VGhZYlNqeXI1Y3FlMklUbVIxTVZWUnVqQk01QlFC?=
 =?utf-8?B?SXQzWlNnbjlURjJnUGRKRHNGQnBvU0hadlF3eTJXUUhkSzZleUtPTGUvaDlK?=
 =?utf-8?B?Smw1YzFNekVybTBOdUFROEM5cGVqSzM2SXhFSTkrYlQ1VDN0bU1aWFN6d1M1?=
 =?utf-8?B?NTc2SENyT3owQW9DYXdYUGtrZ1BCSFlzandhdG1CUitvSmRQbk54K3Npekx1?=
 =?utf-8?B?dmswVUkzazhQZWkxOUt0Zk1iajVFa0lnVXhYS3lETkc0bXN6V1VVQUFNMStr?=
 =?utf-8?B?WFBoc0QwRTZvWG9uUEg3SndEd1dQVUNuRkFQeTRJekJNRWx6OHExKzZUSyti?=
 =?utf-8?B?ZkdOM2Y3T1FkMElsaEJCdUlkd3hwQlRzU2lFQ1BKeCtCWkVVM1ljMk5ab1BV?=
 =?utf-8?B?cFVMOEJBNEg4c3hhclhPREQvWjNPWElheVZhUVBCd0NleEx6dFE4aGVmQWo3?=
 =?utf-8?B?OW5sVkFXWlRvTjU4YXphY3dmWm9HelcrQ0J5S3YzY3dQcGhtWm8wbVF3MVY0?=
 =?utf-8?B?SDg4M2pycjFGQTN2NmtIcWJOblk2eFNKWk5hK3dMclQ0MDg1NFY3N256Yitk?=
 =?utf-8?B?WXRuNTZxSksxUk5mNXdBMll2Tnkrbk5vQkVxQUhTTDg2aDhmV3MybWd5ek1u?=
 =?utf-8?B?M0JtUk1Xa1NEM0xqaGVwOVU2RHNEV2xkclZJblluaUpIMEZwMWlLeFdwK3Ux?=
 =?utf-8?B?dTBCTVgxZ3p1WG9HVVQ3dW5NOXFpKzhOSnFmUmNQeENCd2llOGFIVmJlNTk4?=
 =?utf-8?B?ZWFuaW9FNEZlYW5Hcmo1Y0NGa0JhTlZMK28wQVV6empjUzl0Y0hvcHhpQVl6?=
 =?utf-8?B?c2cyRkdxZm81aDF0MndYY2x2K1p5eWdOY2FSRTN4aFFRR05FdjRQbTZKREp2?=
 =?utf-8?B?cEJ5ZE9CZC9LSllQNEVTT2ZLamZ3a1loOGJZZTF0N0JLK1ppYk50NlFsWFhU?=
 =?utf-8?B?NnhwRWdJT0x1aHlEWDZhbGxkSWZQWU5jUlhtd3FsNkUrN2xUT0pUak1JZEhF?=
 =?utf-8?B?THVKOFFPTGpPODkyUFRUYmpNbzlrcnZxak95aGNWTUZRak5VQkhjQjhQbFgz?=
 =?utf-8?B?bGRMSWIzOTJzZGVoaGJyblhrbVZFdG1zVkVIVXdxSnFvd0c3Z0E1TG1RMGR3?=
 =?utf-8?B?cEY0cS9mN0xHZ2JBQkVVT2hXQ04wT0NBNUpxMnhYZW1RWDhxRU9nR0FxWVRH?=
 =?utf-8?B?RGhya0VXSE44eC9kUHVBRzdScm0rNVZPRUVydG5rRXdHOUJyNmlsSFV0VnBz?=
 =?utf-8?B?MVVlZXFtSFNGZTc3VFdJVGkrUjVuS2YyZ1l1ZEZRT1htMWxlNEEyTXpjcXNl?=
 =?utf-8?B?UFhIQTBSM2VhUm1uK1IyYks5V3lEM1B2UkRKWWZ6NWlCOVpvblBGbUhzS0dB?=
 =?utf-8?B?SW9OVFpvaUI1alk1S05pemxxM2swMDJ4N3VCajZvQ05JOTBrRmZ4NWRtK3A3?=
 =?utf-8?Q?Hs0mUmfz0ZrXKTaT685Uk6hH/XS?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c26f160c-fb2f-4010-7cb1-08d8c8f5e87a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 10:16:16.8227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uu0k4Jgle/yP/oWXSgLOTqI5h8BpR6wIVPY55llohPziL5fTe6QRDTJflt7SyImD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6526
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:
> For cases of zero credits found even when there are no requests
> in flight, replaced ENOTSUPP with EDEADLK, since we're avoiding
> deadlock here by returning error.

Seems ok. libc can have different behaviours depending on error but it
should be ok I think and better than ENOTSUPP.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

