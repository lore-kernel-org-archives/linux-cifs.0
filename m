Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB65C433DB
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 10:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61A7C64F58
	for <linux-cifs@archiver.kernel.org>; Thu,  4 Feb 2021 10:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235181AbhBDKFl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 Feb 2021 05:05:41 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:56358 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232838AbhBDKFj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 Feb 2021 05:05:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1612433071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yZlRWbiMl2nrtvNjB5VItzBIZ23pbMbZBSy9PT67IDU=;
        b=LJ4pqARctsLAzClZqE8BGVlRtTq7to3uMqdDtLC0VPhxwLZI2suR5TN/fQVF/XWh5B+OSa
        NoAeTG7Yp3eaMIZz6bOXcMWUk3F2BID47D9Aqopdj0N5JCbsYH8TOT5+pPaPGEp2oMuR9s
        esyoCm39ib14S2LG4dCpEwq/UXSPlMI=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2054.outbound.protection.outlook.com [104.47.6.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-8-pDBmLySlN5ifGZxP8p8IcQ-1;
 Thu, 04 Feb 2021 11:04:29 +0100
X-MC-Unique: pDBmLySlN5ifGZxP8p8IcQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ID5bsc6CY4s4ydd+xvy11q7aMTm7fCb6h5vIDwueekhw9TzLOdj9JDNCYay6/BYaLzRlAk8bl5y34T3efSB/H4F2q4gI+224Ib7pW21cwVQjukLsGEBsLYRZYT3I5px7ozorN+DBGuiAScDiM5LyXwQBVYV/GefqoarkGsq0/lxT6opGDZEHlbyOz9Oq/S69QC43ReBaeoSzMaALGkCu0KBgdXd8PRO0PzJzBcqo6B2uUMJPmgScyPnmnvUYf7ZUhKPB4Pi1KmZ71Z3HtYEgz7aze8m1f8vrmg5BKCDkjhTjYxX9Bu5wUy5Cbf4hxRAXMD6t1UNoyZkPJpTP0XMjCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yZlRWbiMl2nrtvNjB5VItzBIZ23pbMbZBSy9PT67IDU=;
 b=gLmf3aLLgr5gE9IexBe/FzZoDFGOMlQu3jwilUcOwp1L3GX5gRALxNXeJhnIjokAMgN+nEo+7D8oIQPjWIIC9vzdSiZFqABKJ19L1hf8VXJzfVTiY2KTkScTSNWDycnQxZip4Nu1iUeyzRn/L03oqixcDBR9nHeMCX9V3DeGETblKt6TeJqb6EalR/1bpQlawH6cJV/i5rToo/gG8WnggGM0rW+qIwuVzvfzAe/bvZqYccvKOUJv6CQ4T6T9DA0ylmZDkYOp+wzLqsRlGNNBsim/DRT7UzCRR4zS5ShAP0yhCfnhRiTOMLqVJYIg8ZRWzKhSN7a0ZIppd/GsDZA3Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB5391.eurprd04.prod.outlook.com (2603:10a6:803:d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Thu, 4 Feb
 2021 10:04:27 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3805.022; Thu, 4 Feb 2021
 10:04:27 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH 1/4] cifs: New optype for session operations.
In-Reply-To: <CANT5p=qrx1bKAcJGG=hGBkvwHjQWLgTH3kJ+g-YdZL0yfBtA9A@mail.gmail.com>
References: <CANT5p=qrx1bKAcJGG=hGBkvwHjQWLgTH3kJ+g-YdZL0yfBtA9A@mail.gmail.com>
Date:   Thu, 04 Feb 2021 11:04:25 +0100
Message-ID: <87mtwkno7q.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:9b05:ee03:72d7:dd87:90d5]
X-ClientProxiedBy: ZR0P278CA0092.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::7) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9b05:ee03:72d7:dd87:90d5) by ZR0P278CA0092.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Thu, 4 Feb 2021 10:04:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa810142-0999-441f-9f1e-08d8c8f441d4
X-MS-TrafficTypeDiagnostic: VI1PR04MB5391:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5391129067C0D5557899D288A8B39@VI1PR04MB5391.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gDfKTQhgXRyH4c8PwX3vWRSvylJhUYuUugGWhLW1GZLV0xzukR3d4ARLa8WfXzSZXl9+SiG6g5ct9f9ocoufzhNCsfgNQB83PqIyyrBzo6mbT0Pp8mp2s4eAGBEx0jfp0Rez7t7U1MG1hjqJi7a04/hxueIZB18IAI1P7px+/mLmqf1/WPsCKvBccYezSvCLEaSQhEt8zsx3D3gTLtfNDcLHqrHpDTjv661rBchEzHfjRkTyq+iYJppVu1IFHHhudF3HB7G1YZkXs05RS5jmD7iHvUhRGUirFC2mtpLJswniwjekuZxdIaDNWe4h+LIOtyRJubFdma+SECsIgKKqzLPGcZcWmDTG4HCYLsoMU6m8vxbGpdCZ/+8HJXVjuAy+pNThgfLp16abLMV7QAcBZNYoOIpb6hCRtvaq82ABwv35aKViQHWhb/wBjJ3aACoMJwUDEuOHf4pyoc5sUxUk37E0/iaC4nPoCjTb4Tyhhme3acw3GMd6m7BgdozYotdV9zNq1WG96jUIbduGxO4BcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(376002)(346002)(396003)(478600001)(66946007)(6486002)(316002)(86362001)(16526019)(2906002)(186003)(8936002)(6496006)(36756003)(66476007)(558084003)(66556008)(110136005)(2616005)(52116002)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S2ZBdnhLN0k4WGtrWCtIMlJPOVJDZ0FLQit5SlhYOCtWUVh4QmNDeXNiUS9h?=
 =?utf-8?B?REhaZGxpOTQwTzNGS1ZXTlJxck8ydzFyREtGUTQ1ek5WWGtFbW5SbnhYVWUv?=
 =?utf-8?B?VXZHcXhGQXdRaDBXaEYweDNJY0h6Wmw0aTFFTlhKeGxLaU1ML1M1MWFTdEp2?=
 =?utf-8?B?cE11U0dtRE40eEc1R0JMalpqaDJhY0IvRExtS0hZWXhRSlc5WXIwNExWOFhX?=
 =?utf-8?B?OFVnNGVLZXFKV0loZ1VwUTVHWmFNaE9QUE9DOW5kL0RpbVdFdkNack9DTXJm?=
 =?utf-8?B?bTJkMW1ZQTBzK3A3NTFJTWk3Yy85MXAyc3dDa0NjQXZmazJySCtLRy8zeHN4?=
 =?utf-8?B?L0F6d2dWdEpXVjhvWk9tWkFWVGZISVZ3RVd0OWQzL3RKa2VTV3lpMEg0STMx?=
 =?utf-8?B?Y2tMZ1hvZHlKNDFNRkhBRWRHN1lPZ1hkRmFKQ3I1YldWazFEdEhVTVUwdXZa?=
 =?utf-8?B?VnN4Y2lDQ0dXNktxOWZtQk5UQ0g2NEpvWXdxbjNYeURjSmlUZGp2b1Z0NGkx?=
 =?utf-8?B?VTlWSVJIaVYyTXYzOGNIUXlFQk1uaDZKeE91Mmx4RDYvbll1Zyt0bEFNK2pV?=
 =?utf-8?B?cFlhTHJmSDZpMVFBc3VzQXBITWQvQVY3K04yVEQ5N0toTGVKK1o1SndXMWtY?=
 =?utf-8?B?cFNEUWFsMVVDZEpMMnAybWZ0NUdsSTg3NmQxWHJyWmptalhKL0pqY2JTandC?=
 =?utf-8?B?VFcrZ3E2UUJTQjRKQmpIVHNoU3AvUnNjNnNYNi93NGZmWWFGSEk4dlhsSzhw?=
 =?utf-8?B?NVFleEpOZWxDVnRwaUFlZHBOMlIwZjZBbXZXS043a0R1dHRLYkdsRXRMbXBq?=
 =?utf-8?B?endEQTB3M0E1amVNVHg1anRickMrcmFqOUhLTjc4ZlVLc01jSXRYd0NYTllY?=
 =?utf-8?B?a3J2V0VYSlB3T0lha3VvaUVnelMvMVIwSXJ5TVJkT0U0aW4xVjNsS3ZlZm9n?=
 =?utf-8?B?WGtBTlFjN1hwdCt1VDRxa040OUc0dUczS3BUVGdRWDcyWmxRcVVZbWVMQkVq?=
 =?utf-8?B?OGtjSGFvTFBqVHpvbTExRXlQUHFWdWFkbStqN3VUUHdxdXYvSnAxeGc5ekFu?=
 =?utf-8?B?Z0prYlorbDZmSDVsNjdhVldHbFZUcG9Bajd1b0lqNzBRSlVFWWpMSG5EMGI0?=
 =?utf-8?B?cTVXNEFvbDRsYTVzbHNkRGxNU3Z0ZWtDYi9HVXg3TnhQeHVuOWNtUVJhVDQw?=
 =?utf-8?B?emY0cTBWV1JrVXpDOEx6RnlNak43QnB1RS9xdVdNV09YcjRoWENtaTRiejRk?=
 =?utf-8?B?S3lrYW4xWG9xZmFsdU1OVEYxTWMzSU42dmtHc0NZM2gxUEMrY2ZjVG5XcmVY?=
 =?utf-8?B?T3hyVnBnNXZ0bndPN0dGS3NzZHpqVHJxYmlubHFneTc1WEJ3RTF3UGNRNXp1?=
 =?utf-8?B?VUJMMjFOSGVaNG1OenBjOE5RTzhRdzNMamlmQlZlQjB3NzZWcUtnZWI5TmM4?=
 =?utf-8?B?dmhGVFNrWHI2bE8wUk9SdFFkRmVZcmlXTlluaGhydWtycWNYR1M5a2N3QURZ?=
 =?utf-8?Q?y+pJbSLB/ZNFme3/gQkrxB0aDVr?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa810142-0999-441f-9f1e-08d8c8f441d4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2021 10:04:27.6942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RB+upjP9zKHXYIIctlqlvMRuQFJcPxPgOhvzjuOEtZ+/OKHgeJU5AR0PQP/n8aIV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5391
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


LGTM

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

