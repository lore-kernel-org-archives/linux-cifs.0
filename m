Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D481C2D0E4
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Nov 2020 12:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 398002076B
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Nov 2020 12:12:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="n3YqAb5c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733119AbgKXMLq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Nov 2020 07:11:46 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:24095 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732987AbgKXMLq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 24 Nov 2020 07:11:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1606219902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2wQHV8j1JDws6EK979ndIK7iK3KWB4JkzgvpxXpge/E=;
        b=n3YqAb5cABiFGmJzSCaVefqUKJc4xDdD2HB6Ow5Gb5kJcbRRmR/FY2kkEvyWxoG+argknz
        jammji4m3/Ls0rr1S61N1UHvnXuaAJ3qEkvq7ubEv63z30TkezddZwKZ7gqayHxfhLtH9Y
        LStfyyBW+0cNTlsTsv+3yIxjgpkDXhk=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2051.outbound.protection.outlook.com [104.47.4.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-12-mYz40LFmO5OCub3a1iuqhQ-1; Tue, 24 Nov 2020 13:11:41 +0100
X-MC-Unique: mYz40LFmO5OCub3a1iuqhQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nxGdQZwpbTRJ4CfTrS3iHs1QMPXIH4VnqK6zRf6hXmj7WRpUIPTnkxx3PAAoUIfhzmYIcpFiD0w9CZk/jBdrlimbDosHuCf99p4M7cGZgAO3HkCBXFacgeHJrgNu6+QCIyzJl3TquL5Upqt5vRM0qEroQfeKXDtXtw/8JjzqhidtLOFEjmLBx8FbT/qkHUFRquMcNv7iYwPmeLm1zLGuht5OzLDklZY2lq6ZKChjY0gaxROsWu7YWX+/x85Y/F8fPMq3p2P0GyFxfiSBEFoS9fq0k9090WfUQ0fvPLJw+Kw8Q1Ep0Jt8liZz33jViqO6YRJTrHHwnuGDRV1Y2GiemQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2wQHV8j1JDws6EK979ndIK7iK3KWB4JkzgvpxXpge/E=;
 b=eonNDEsgmjwgRTLETtVkZcLr5ZVfPHPSxSIy4mbfYvXsIoHyBgYdmDeycS4M07S8gq01g5M9sjA3gpdsAK2ocNyMb9E0vYXSHIXR/0X+Kan50r61J0iE9Vpv5UX1GW8SX8Wyuan6Ttvl3ZYCy0TCyR/5mKqjkHm1/mgcDAfV384a3kaptw2XfH5P8aALYJb5I0sgfvJkhmGFbgT4JDys1zLodQO+xbzd22N6wv6+1l1lxx4kiux5p69vOlYAhKPVPWFYTwKsgR9Ek5I2xqHNeVIgVnOTdZbxzW/L4EKsqIcGTSlyR6m0ogMrS2PxSlcLlR7SS6Vl6duCcVQCpHoJtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: archlinux.org; dkim=none (message not signed)
 header.d=none;archlinux.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Tue, 24 Nov
 2020 12:11:38 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::4dad:a2d3:5076:54f0]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::4dad:a2d3:5076:54f0%5]) with mapi id 15.20.3564.028; Tue, 24 Nov 2020
 12:11:38 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Jonas Witschel <diabonas@archlinux.org>, linux-cifs@vger.kernel.org
Cc:     Jonas Witschel <diabonas@archlinux.org>
Subject: Re: [PATCH 0/2] cifs-utils: update the cap bounding set only when
 CAP_SETPCAP is given
In-Reply-To: <20201121111145.24975-1-diabonas@archlinux.org>
References: <20201121111145.24975-1-diabonas@archlinux.org>
Date:   Tue, 24 Nov 2020 13:11:13 +0100
Message-ID: <87tutflztq.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:e34:3de5:718d:1ad2:b224]
X-ClientProxiedBy: ZR0P278CA0125.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::22) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:e34:3de5:718d:1ad2:b224) by ZR0P278CA0125.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Tue, 24 Nov 2020 12:11:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 006b912c-ea05-4802-970c-08d89072188b
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3359:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB33595C519E352CC8B17484B3A8FB0@VI1PR0402MB3359.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hdWvQAN5IbhdrUld8U6/ToQ2toKIFReqybjaJlYWDP2Vq8Eea0h4iOB2NctRf+HNVklcodFrSqFHDxMDGr0N2Qg7XLhLy049is589pyIqIJuZpFSo+fnHtCnrULmiwDWk5ec0fJ4mlRF9TrzoHNgf+mXABr0uAeqdjBw2iZh7hyYioC+OT4jTZk2Ds0ypEp78/cks/O26BT1iCOnOGz4F1LGMNC4mOZ5H/pbCqOWgFKOlaO+pqgLQyb4q28DeJeLsLesIDJHg3Sslw5slISmCxmBpPosKX3QPiO296OQAQZ5exXkbd8+rz6iquiLJaHm91kGAOQe3sOe5JZsnXAEeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(136003)(376002)(346002)(8936002)(186003)(52116002)(2616005)(36756003)(316002)(5660300002)(16526019)(4744005)(2906002)(4326008)(86362001)(66556008)(8676002)(6496006)(478600001)(6666004)(66476007)(66946007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: gFd1dF6Tqda5yBzrzyF3mKvTEcfqwZGU2vvHcyuAyfk5RH1qnm2baDDBtu1Pw9z8lgJeSplQ9ibrtVeI/z7/U/oQZcWvM1Os64djXyTGv/TD9Wac9EQuWptk3GpUloDEk2ZHSbap0rabwQftLyJIZ+8DOr5C4TCIBgy+pFTzYc+6pNxcPcCzbq6mN6EIyUB5o7kk0GqyO/sq+T+2v1fNoXbQRy70uF//k//UJoCOog90kRcfXWlqocgQwbDXwzdXHkQe1a7Eq9E57RK6FjMYEmAP5JNKbphlyx067lbEk2CJ662qFKeNi4sAOhZVIcES9LriZ/bn8EImmbzlquVtikqEucFlcPyUDU6TFuPUVmKHHMTqIuZhv6XE1bPMhLzC/GrSfgAWx++g+s6b59nzDJo/Q8M41y3MnAKv2owfMCr7vgkcixWw4JBO9qe44MBqb4HsccP9CME8Ebxx0AQafY1YAjcudOKRfzIlA5BL0/xoaOXqsBt+6SeoS4/JiJFkmeKxl9w/rXu8lzeI6CMjdI+bhYUIF8y251CCCU62BWd9tWHJh06D2/2ePwUtFDYo7NRpbtlkdr/X33Gh1GADzOX7GdJvigJeu2Tzg+gzO5fttgWSVNswVgeDEEMldIJsejyFBzSYovVSh1jz0jL1Nh25T1n0kAmc0LvZ/ywj+2pWBeCv7N+NbRZsTg72LG+iXePgypX25aibKU6q8jIYH2xrjcAdZ3zgUqDkTQtR6PQkaUT+9YmNDuuIR/123YebpFae8SGsYyw7j7noVEc5A9MizNx5KEQ0l0lKQJW3rbBlTAPsG2GhQyUFCcJ+L+JdOss/hzuDWVhaafEfeqEKVbyh5mAb5PbBysWxPGCSy5X+vc+zhjLt2nSRB+K/eIPhF0lKGkDZDwfsepJyH8zapPOosdMYvUa0TUKTdXRNqwWdmpatWb9GwWinzq6g4mDV
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 006b912c-ea05-4802-970c-08d89072188b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2020 12:11:38.6497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cjsM344HryKBgohtyajJHwMNnVvPjzQInP3Yd2fLVH2rbQ4xCLgf3IMpUP/YdqWD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3359
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Jonas,

This sounds good but I'm not very familiar with libcap, any ideas how we
can test those code paths?

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

