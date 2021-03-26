Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02588C433E1
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 15:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C194C61A2A
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 15:55:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhCZPzV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Mar 2021 11:55:21 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:36254 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230250AbhCZPyy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 26 Mar 2021 11:54:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1616774093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ivF5YgG7880hz0Eacci/ByEsR1AG7Q4byz8HPr67HYA=;
        b=kYVu34r09Asj7/BDG9ONgwYpEyTOy7dYKl3z1ptl7VC2HQ1C1TqsIHvdbWIU2csRvLuZv5
        pMdJSioCiTRfk7j7EyWf5X5OHWVxKtguRH292AOh4lPOlIbx2GCURgVEt19Ed7CL5QhoVc
        kzYK0w+wP1VrOBhCQwQgMCfSaAOD9YY=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2057.outbound.protection.outlook.com [104.47.14.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-25-PoFaig4GNfqRMYscCIfnYQ-1; Fri, 26 Mar 2021 16:54:52 +0100
X-MC-Unique: PoFaig4GNfqRMYscCIfnYQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNjNp0b9ibfi0/8zdZl1BtGbvxtUa85rKsbBxudN48WVnBHQHDXp3OwUbOPamlzWhY7nbKGHVIzx6Vqaddm/I0tZxDD1Dof5qiLUAyhVP3Oq41cuWOmesMQysfhg/7jYcC2xwLwBRdSEOaAolzLZNgy2nUijitMPruE4JHb8W7ANC1B5bHA9racI8+0qUpGIm1K5mmfYiptNA9mYTiSeBObQC+Sx4MbJebDfpO4yhSUZYYzsGU8Cx8TZcPGZsGjygGvnAoAFyS+d6wWszFsqhyED4YES7YP/obqtaY6ChtFZ3D0TB0v4OldYm/lf3Ko+QKeAWmJDLRqQa73nzGE0pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ivF5YgG7880hz0Eacci/ByEsR1AG7Q4byz8HPr67HYA=;
 b=NGXmQ1AB31Ufg91CtlSdSm4W/yLgtKYJC/vx7PDdgsjrxfzmxi3WoZUppRMNmI2yOc6ulQUC36lFjXYQJ/SbeZvgNXcrd7A3IT/S2zhNmmOyX7r0cu1JezenI2W9BlgiLswmN3gsNF3v6d9aSMh4vXxPPJPRCaeWcwejrLvv+WHixaOw+QEtkZrSNAv2rXX49fvCSNMkqCEJiWJcG73SzFYqv8lfoqiOwcDc4cswRn2p+6ttEQDQTbYfZKfQnuPz4Emnpf/1nFdcNn3W2sdIC3MP8XL5XZjwt8e3Byi6kztenz4bnM8XSddx1CQGJAIMCQ1jpaFatHGuAXnAgHPy0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB4589.eurprd04.prod.outlook.com (2603:10a6:803:6f::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 26 Mar
 2021 15:54:51 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.3933.038; Fri, 26 Mar 2021
 15:54:51 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Steve French <sfrench@samba.org>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] cifs: cifspdu.h: Replace one-element array with
 flexible-array member
In-Reply-To: <20210326011117.GA46303@embeddedor>
References: <20210326011117.GA46303@embeddedor>
Date:   Fri, 26 Mar 2021 16:54:49 +0100
Message-ID: <877dltrjue.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:700:2818:473b:a8cc:f6e0:2633]
X-ClientProxiedBy: ZR0P278CA0034.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::21) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:700:2818:473b:a8cc:f6e0:2633) by ZR0P278CA0034.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Fri, 26 Mar 2021 15:54:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1919e964-d2e9-434d-bfb0-08d8f06f7d8b
X-MS-TrafficTypeDiagnostic: VI1PR04MB4589:
X-Microsoft-Antispam-PRVS: <VI1PR04MB458936BD606C902B2604FFEDA8619@VI1PR04MB4589.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h/+194/9wLjtmS3dLOLN01PstpHintQocRtB3jHENbjTB07F9KnwklGYYzEvrLrQCScFU2Q6FvIuOxxE8rKNIIzWkO9iqyyiLEuvY87PvU3CCUKZF95krtzfp4wU8unMVKYYkeKEHgu12QiL2XHWfNY8N2f9xMTpngqmskHIL43l5JhHZMutGUZlQpu9U3mPHXQs28+vX5yaXlo4n5lk5wa/ndx32EFWtlyjio2vldkHF/I4DQ8sJyBEl/8JhVDuKZc7lptKo8AK5eJQexaIX5le+gQ/r7+8bE5lDYXvJbIg8eXaw0PF55xe3TZxKml6+BqqDrkIebB0Xxa07peoZDISFgcjc8erwatNui9QLVF/K4kGclADzpKovuG7Y/WuvbX+l6wS8mFLpczKZpWEajrXNoR9D3dINiUOgO48iuNOHmMmmdrlQdYPkLLYMJLKjfVPEBomekgCpyXr1glFay1DpL93OOdyx7XWaPYOw/4T3U/O7xeq6NohGqhju+GOOaBVcnRaKsHTBhMl80XCar13RHOs3XxGrkEdDBAX+GwaRoNkElNHPY01XIHoBNSRDHeEgA8rR+IghjgbTf/cHgQ7ldY7nbHNdPLCijBaEhuNjJkX7lZJPrwyfuQBa/03GgtJE4cyy1j8WPbg9Zm6hA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(376002)(346002)(39860400002)(6496006)(2906002)(52116002)(8936002)(38100700001)(86362001)(186003)(2616005)(4744005)(6486002)(478600001)(5660300002)(16526019)(36756003)(110136005)(8676002)(4326008)(66946007)(316002)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NHZ2MFlIanlIc2o3S3dZcFluRXk3OE9WcFNlR1M4YU9jWmo0YU9Ma3BWSG5l?=
 =?utf-8?B?Y05NQ2xEVUxxQ3NxRGY1R1JtQ0p6T21pdkkvWW13dGZUVTl6N2w4T1ZBb21x?=
 =?utf-8?B?Q01xaXNtRVk5ODYwYXdXNnFpZ3dRcHdSTHh0ZTRuNUtLNWRPN3lKS3NlSUJJ?=
 =?utf-8?B?RmkzaEZhZStXbFNyRm1NSm0rV0pTMjY5NG04WVJ2THZkK1JlVWZ6U3JuZVps?=
 =?utf-8?B?cDYxTlRYYXQ1eWZ2MEVBbCtucEdEeWRLOGREZ1ltYTZyRzhTS3hObmFnekhL?=
 =?utf-8?B?U0cyUVg1SEFLV1pRQVdlQ0RFNDNxYkRoeWMxMGNiV081bnhUaUdsK1oyOHhz?=
 =?utf-8?B?ZzFIQ3FEek1icFVQWDlsUGxJbm1PNWwwdjMrMXRSRERVWkFFSUd1alFFOGNH?=
 =?utf-8?B?M0d3bCttRWdGOHJSTVNNZkh2NG1HTlhKM0ZhUkxKWEcyckJnL210RkJoaDdz?=
 =?utf-8?B?U1QwK2FGTHQrckZCVmpRZ3ZwMHFPaUIwTWQ0ZEo4NFBzL2lSSk9GU3p5aVRJ?=
 =?utf-8?B?Snc5cFFvTzRDdE1XamhIaHA5blUwQmhpcE53QlZkTnFiclozamI5SHpHMkdV?=
 =?utf-8?B?ekdtb05TazhIekQ3MXZIa0NhbE8yOXN6UWw0bndweGY3RFoybUI2MkwzWG1V?=
 =?utf-8?B?OGRTb21rejVQM1U0UXlWc2tHdzFBK1RCdFdFY0pWbzBjWmUxOUs0aXJwd0dV?=
 =?utf-8?B?dnpOSGcvRjNRS2JNcFhJTENKaFBrdHZZM0RNa2dRWjMzYnVFQVlNUXR1MHEw?=
 =?utf-8?B?aFF4L3FTc3JodzhNN0lEWjRBV29ZQlpQR1RVdHV2OXNSZEZWcW5VMmdYTU10?=
 =?utf-8?B?dXM1eWFHb05tbFBmU1JpOG53UFB3MW9lTCt1VDdOTFRzY0c1ei9kbnd3S0tq?=
 =?utf-8?B?a3VRRVlHa3dvTmE2dTJ4NFlUUzlCa2xwRGpjNFhycTJrVjBQRmMvQ1R1aWtE?=
 =?utf-8?B?OGxBdjJtbzBZaTRNbnorbFIzeEhHK0l6TG5SR1MwU0VmWkxyTmNqdFZsRVA2?=
 =?utf-8?B?SUw2Z2pEa25YSnd1YmhOb1JFYmY2UlRGWnIwS3hHNHNSUGtVdWRqa2hSbTJF?=
 =?utf-8?B?QmtuNTlRTkE3NS8vS1VqTVVBOTZPVkpqcEZpR0x2WWR0OHZaMTJ2SUxNcG5r?=
 =?utf-8?B?amllV01hNDdZSjZvTzdtZ3hkTUVRTzFCODhrdXMyc1ZiNXBldm14ajNzekF0?=
 =?utf-8?B?a3UrZndmZ0t0SmxSWktpTDQ5WVhyR09PZy9yTFoxYThwb0Z4d3J4V21TUFZj?=
 =?utf-8?B?ZnorOGl6czNTVGlBYm1xYVQyUkZJYlpWNEx5cERjUHBNNGJXYk5IS2hwVFJT?=
 =?utf-8?B?UzBQNTRwd0RhTUJkK0R6c05ockRTOStFb2dxcjlnbXdVUUdwZXJWYXF4WEx6?=
 =?utf-8?B?Y2RlZWFjaTRHanErb3kwNFpVdEJZSjV2ODhqdU54dTF3bmxtUjAyZHN4QURH?=
 =?utf-8?B?Yi95bm5FcWxPYjA4OVpSdEorWEo4b3ljbndmYTJWMEFxNFBsMkJxLzBXZHU0?=
 =?utf-8?B?RGlIcnMzeDdablF5WnRpOGlRejhTWGg2M05BZ3p2ckZzV3N5VFB5RjltMUlB?=
 =?utf-8?B?endVcGJZbzZUdExPektaZitLMkR6L0xjcUcxcFdCUDBTMS93bUdzWmJNWGFL?=
 =?utf-8?B?a2QyOHZjeEl4NnFmb0UxcllJSDFOTVhVL1ZzSldVRXdRd2Zwa2IxeTg1U0U3?=
 =?utf-8?B?RTcrQUJEZElWWnZzQSsrUGZEdmN0NHZkWHBYbktFaUFqQW9ndzhkanFXZGhG?=
 =?utf-8?B?WEZyb2txazRKaHBlbFV5ZkZ6aHZ1d2lDRi9NV3BkZDFuR0FQV3lCVTU4NWli?=
 =?utf-8?B?eFdULy9aSG1tMGhPei9IM2t4N2w4K0prbzQxTXJwWmxuZDR2SHN1YXByNUxi?=
 =?utf-8?Q?OjV9lNPtCUYAZ?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1919e964-d2e9-434d-bfb0-08d8f06f7d8b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 15:54:51.2001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WwNVwM17SqBb9CeECdc/7TQRZDhKKXwGKHBbsJa8VucYwo+ppOWtRa+moLyIAJL/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4589
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> writes:
> There is a regular need in the kernel to provide a way to declare having
> a dynamically sized set of trailing elements in a structure. Kernel code
> should always use =E2=80=9Cflexible array members=E2=80=9D[1] for these c=
ases. The older
> style of one-element or zero-length arrays should no longer be used[2].

I've checked the usages of the struct, looks OK (we don't allocate it
directly, we use memory from the small/big buff pools).

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

