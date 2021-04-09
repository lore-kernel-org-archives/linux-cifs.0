Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8607C433B4
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 14:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9EEE61181
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 14:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbhDIOGS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 10:06:18 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:25691 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233745AbhDIOGQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 10:06:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617977162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cEmqoJyXGBCLmwz23DXaJshEzbSz6IO/BJQGgho3Gk8=;
        b=E5DcTTedkUgFID9vPWXJqqnzr3U5oTnRE1cgfSxyFbHCdVQO1vi+hus0D2GTmnteTcNu7x
        k4g7WEW+QtSP7k+H6jMMAqwlGR57xIqptofASDw36VPyf+AQepVQNMyjVusKGLxwSkiJ09
        LUjmujcBRMQYrn8Zl+rJupuJm4XhAbY=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2053.outbound.protection.outlook.com [104.47.5.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-36-Jvb0FK9HPte_4fRLJFufcw-1; Fri, 09 Apr 2021 16:05:56 +0200
X-MC-Unique: Jvb0FK9HPte_4fRLJFufcw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HgNehyOb4kR5K/0NAX8wFWs3+LElHaMKGDTXRn2KhrXtC49gSkv8lDlokj6mGKuwiM89rIkFqcFL/mWlwDInxVkYGd2qasV+du4UwkI8FzdQxoL5v4wWMusG/7GSFyMc3u52gqmWOg2zWxALlK6q0OIvUHaIP+siFp/qRNdyGgXDBRe+sTNbbE3fAUIZH+wCZirs18ZXGWG9miyczi5fophZQECu6n+ZZcBuBFESzuFpdvWdRwijjwDoLqprUQFdQhM6RmIJrcc6/CoQaCKXRzKm90bCS0cHExML+pv8opHOBM05rgnQaQcBA2YGO1eERO0yfz2roeYLvsBsY6KtdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEmqoJyXGBCLmwz23DXaJshEzbSz6IO/BJQGgho3Gk8=;
 b=O+rAVS8sBFbmj3JSVrRzKHvRRql04FAW0pL/QL2Pw25NG8nUkSoqUYlN3dzlNGL70fDIqBHRlxj9043CM5glmD8/VR6zBPr+05wv4p6eLoYexPVyb/ovJnFKqiePc5Ltar/eAtv8PmxECJTna+szZxhuF5NnOdZ8Kk/Fp263r5aCC+C2IBp+8wWo4HTOzz6oKaXns9frDD2NQ8xmNrQcO9NXMDBOAkpxMuksTZZbNdy30VXwJbzxbg/a1QqqiV55EEXvrDOA2uYdOPauczx2KzphCPPBntvFPuoxTTAFxNdqondcAmE8uLLbLcEVr3yJsXyERm04ixxeOqQVLhv5tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VE1PR04MB6720.eurprd04.prod.outlook.com (2603:10a6:803:123::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 9 Apr
 2021 14:05:54 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.3999.035; Fri, 9 Apr 2021
 14:05:54 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     =?utf-8?Q?J=2E_Pablo_Gonz=C3=A1lez?= <disablez@gmail.com>,
        linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smbinfo: Add command for displaying alternate data streams
In-Reply-To: <CAMM8u5miX1JbzWMG3WLZLZeD1_ZL=6nufWJaT7ensA+yPo5zeQ@mail.gmail.com>
References: <CAMM8u5miX1JbzWMG3WLZLZeD1_ZL=6nufWJaT7ensA+yPo5zeQ@mail.gmail.com>
Date:   Fri, 09 Apr 2021 16:05:52 +0200
Message-ID: <87r1jj364f.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:3046:69ee:cad4:97e6:ea8f]
X-ClientProxiedBy: ZR0P278CA0099.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::14) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:3046:69ee:cad4:97e6:ea8f) by ZR0P278CA0099.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 14:05:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dddfc906-9ad7-4b7a-6a43-08d8fb609722
X-MS-TrafficTypeDiagnostic: VE1PR04MB6720:
X-Microsoft-Antispam-PRVS: <VE1PR04MB67209651CCF5F583A199609CA8739@VE1PR04MB6720.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7nBmVpgz56ZbXg5pLt1P3GjsuDxgSxJfCaX4e1pPBcw0zDmsnEtqT5QuJaTu736UJwVsGnS3zckbf631onI9mEqFWERS3OuB2Eq/teUGEmpdOT4l3HZDySKpUN07LwvqR84Gy3PO7rohydwEC4iKh4C/QPVb3I/oBLnTsTF9x0gt3glpspOys3NzXzn+2aixwJuVQ8SaNRrg5e8Kr7b+nkT9WCkx4xH1h1i6081eaBvA4apeMBC25odX7nDEFJnNnMV6NX9hKI7NmtMXpf5TeZ1YYMSHtZToFaM1EeoLCbEEFCFXD6WvI975Z+2vluXyTvW8pDYPRLQZGwhZejb5VuHvPqrE8tkAOnm/Iham7dkn7h0Uyyp6Lcpd8YfxAIV0v7oL6TkvlceJvJp8mVB24Y6W2QRj00194f3yFjB5swt3RkOxbzb/4/LG1TNT3gOe14O8SRIv9ckoKWeSIerooOijOEsT3PHbwl2j7MNKBYpt/WTekQNGtXIgE7uk9P6JhDpg9vMMKvZFCtKyOKxMCz6Vo+XkHMJW+02Ie1H5E6XeAJIBZ4m/vdGlgI9e+bYs1eZU1gtg2bRez1kZ4ZmTLIASG8tlKdlWOxxkCjXuKXKJW56kRcU9mBT7H0Y+x3Ih/0LheQs4k2cp9dC3BALVcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(39860400002)(366004)(136003)(2616005)(6496006)(478600001)(2906002)(36756003)(38100700001)(4744005)(66946007)(5660300002)(86362001)(66476007)(66556008)(186003)(52116002)(8676002)(316002)(8936002)(16526019)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SGxkcWxpYkVPdzJUOUZxN0sxemR0bXo3dStEa2YyODY3bzJweVFoYmVCS040?=
 =?utf-8?B?WkVXZkVvU1NVYTBpYjEyT1gyK1NNMHptTUFTdnhCNkc2WXo4UkkrUytNTk9w?=
 =?utf-8?B?T0Znenp4SWNhWHdDcVFDd1BBMFd3VTZIVUpoNW9nL0k4TTliNllGUkJibmxV?=
 =?utf-8?B?WXpnNHRKOW0xRWxwUHdSQnA1aGNwWHlzYmNUbUp0dTYxalp2QkQxUjVlSE44?=
 =?utf-8?B?b2sxOUdwZS91S3RvelRzU0NnQTN1elM3dU15emNFOGh6bTlvWS9ycVVkb09p?=
 =?utf-8?B?emJhUHZXblVjQ2pUZDFLczZnMWluRGpzV2plYWhmZm1RNmswZ3BMQlBTQ0Yw?=
 =?utf-8?B?d2JiQkRwaTB0NktmRzZHazQzY2VUeStJd3ZqMnMyK3RkWUJpR1FLYkpXZHR6?=
 =?utf-8?B?WW9ISXdlYm1JbGRvRlhJRCtwSGttTXpPMDk4Nm5VRUxlZWFQNkFzVHd4V0Na?=
 =?utf-8?B?TU9uaWxZOTRsN0V5eFhBbDh5b0FGejVmZ2pEUGkzUWY1ZEFWRkp3RXZoeHpt?=
 =?utf-8?B?RjJxN1dENmtFellBM2VmWkU3UFhRN21NRlJKWi9SeGtNb1ZPQUZhSllxdGZs?=
 =?utf-8?B?bVIxckU3OS9neUR4NnlZWTBCTWxZeGNQcVRyZTFscnp2V0pwSzZFMmx3Yjhn?=
 =?utf-8?B?dHdjemZLNW9UdnRSMzNOc3pKT1ZIdTQxaHI4b2pTRUlLVUUyeXNWcWIrckcw?=
 =?utf-8?B?OVZxVmMvM01TbGwwQ3RkNm9tQmdPTEQ2M2tpdk1lVGFqbXE0ZXpCdlRGVXEw?=
 =?utf-8?B?NnBHUTQ3b1c0SjRiY3kvMldxTGQ0L2NCaWNabU1YazhVTkE4YkczaUxOZzFv?=
 =?utf-8?B?UWV0TStrWUFUQ0dCRnoydVhTbGNROXh2dVNmMHdKQUk4bE1Vb1IxUGVEZklo?=
 =?utf-8?B?NFNDbklVMXZheHU5SGFHaFBxVGxsS1NmVTlVaWkzM0llZTNsNmp4SVpRUDYz?=
 =?utf-8?B?aTZYWFFJOWwrU1BzUDNCbnIxUGlNK3VEOHZTbXdSSml2TjhQd05FWG56S25Y?=
 =?utf-8?B?a0c3d1lFSE1xZmZvWndPZ1kwWDNJd0tva2FXZGJQeURYNElPREFycERBODFQ?=
 =?utf-8?B?bUlmVzcwVFFyM1F6eThLVnVqZjBNSWFCQWRENFpKODBUK2FPTUJ1bnVZQVR6?=
 =?utf-8?B?ZlJKSXBLUi8vU1NzRmwxdUUrRUZKUHRBZEU5a0huMGkxOHdnbVpJNHJ2SllV?=
 =?utf-8?B?bm1RUHMrYXBaQmh1dmVBc3B3YlFQVHByc2xxVFllNnJOVm52SE9MZ1dwSE1m?=
 =?utf-8?B?a1RJNHJJTGdlZTAzNkhWSWZvdzg4YWdVTHlvY0ZPVGVtR3N0K2lBczdvNS96?=
 =?utf-8?B?SDlhenBxTk1zWDRvUCs3MmlEZFY0ZTNGejdzSzFQNk1lYXlJRk54RGhLTHM2?=
 =?utf-8?B?eTh2bENRK2grNFdxQzNEOCt5Sk1RR0o3eDhneGZlR2YyVERNMVp3Ukc5ODN4?=
 =?utf-8?B?MnpzVlZQTmhZSm1EV3lrYTcvcm9Jak5XQlBQZVNvZmxYNzhyc3pLT3JIcVlk?=
 =?utf-8?B?MGtOczArd2tCbXBsSlhpbjgwMG1EWnRqNW8xVnBSUUZBOHlMRXBFK0VYdUpY?=
 =?utf-8?B?aVYyS29JTnJXNkpFZzV0RnpTaU5qVm5vbDluZjVBUXFNLytMTEQzMTRicDhU?=
 =?utf-8?B?MXBHR3pwWTJUNEU5QU9LY0c1M09QSk8rK3A1dEtBcmlGUWNsa2ZEMXBHSUty?=
 =?utf-8?B?cnZqNms3eFhYSXozZGV4bVFiZ3RQR0F2REUxK3Z6WS9Dd2wrWll1Y3JOem9R?=
 =?utf-8?B?WGViL21DcVQzd1ZGcStPTXl1cHNqeWJrMTdRd1k5MHhIR2Rhamd2QWQwdTBq?=
 =?utf-8?B?S3MxRnlEN2w3SmVDWTZlSFNXcFlJMEIyM1dzL3RzZ05QODJ3ZDN0UVh0cDdm?=
 =?utf-8?Q?NJ8JhhJBClqlB?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dddfc906-9ad7-4b7a-6a43-08d8fb609722
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 14:05:54.5021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EmDtTH1czIK3YHOo/N5J4lHNu3mC2DfIMjO3ybUe/D7WCSQshqR7q9/iCjgX5o5n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6720
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

J. Pablo Gonz=C3=A1lez <disablez@gmail.com> writes:
> This patch adds a new command to smbinfo which retrieves and displays
> the list of alternate data streams for a file.

I gave it a quick try and it works. LGTM.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

