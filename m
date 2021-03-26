Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6B5FC433C1
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 15:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0F7D61A27
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Mar 2021 15:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhCZPvi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Mar 2021 11:51:38 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:28856 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230391AbhCZPv1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 26 Mar 2021 11:51:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1616773886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yWfHb2TKRYnuegZ6qi6gTbzPATYeELtGfqKHotcKldM=;
        b=LG+a/d0VIDck8+c5ZVBGD9F6bPs8CyDCNEelgusuA7CemSgSG7h3T4LC6I80Bgs159XKJW
        sKdvU6SfXMQldJMzFxMgz+Hmly7SgWt5tAwiut2W/5PF3/5xmN61Z+aDQwaU2nLjHhqF//
        Ov0cmoQhWaeTvlj5PnXzZrLfk87XW6o=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2176.outbound.protection.outlook.com [104.47.17.176])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-21--eDSnibcPM2Xav9Kl6aM0Q-1; Fri, 26 Mar 2021 16:51:24 +0100
X-MC-Unique: -eDSnibcPM2Xav9Kl6aM0Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGlPxuActAAOb/ANGSm88T2tOb+Xf0WutbzNG9b7LV9Tw9BwnO9BBvdbFRFk1hUUpzYMZXufwJ5B9LYcw9C4R36w39iovnIc9LolAcmrNiN0VZWSoPR+TxQZkUfaT+sDOwNoAXs8f7xKUH0EJSNMZu82cozEZisD+SdJZSTA9SMqttdHH4duHH4WO6mxSlhrGInzRl42o2eD3fvpAq3AXyp6hjrLnHVDmntyUW799KRzU2hC06481nlqiw1ZpmLBEwdXbtkYV2mxuRm1W5HxGPwFLF4oJacr0c+M79GoD0ZmTUW59yGfHDrAPm+343kWlS5mN7qdIjLgHB/ca4u3sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWfHb2TKRYnuegZ6qi6gTbzPATYeELtGfqKHotcKldM=;
 b=OpH+fMITs4iBni6K5O90uq7J+8xJteYddmlIv22D8aPLTklftFZMD2qBnH4oUQtIng5m8ipkyYQAoQmbDmVR1Vsb+arF4OfBfSEV5rgQ9gJrc47IPcX2+PdRkhXJzx5BD3A9r2S6UsI82XMQJvKwUZrzFUbL6VApoOE4CMnThdjPEiPtkscIbB/w4eVhRLc5EG75h5mjzGBhzcJRj8qgL86DSessqBxR1VdB8gL0WX0+zA3mrl4IPJxXcw1XQ7/eJj+MOR1q/aN40H6uIif/7E9hchfnaGxfnYtyyVJ/uismSpQeQ76imO/j8B9ranPqovLL9b1mVgCBT7PHlPDZ5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0402MB2910.eurprd04.prod.outlook.com (2603:10a6:800:b6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.30; Fri, 26 Mar
 2021 15:51:24 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.3933.038; Fri, 26 Mar 2021
 15:51:24 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: cifs: Fix chmod with modefromsid when an older ACE already exists.
In-Reply-To: <CANT5p=rr-rDZ1Jo_rzM0_63-pHOKPcRSnML0ucOVkSBVWrSc4A@mail.gmail.com>
References: <CANT5p=rr-rDZ1Jo_rzM0_63-pHOKPcRSnML0ucOVkSBVWrSc4A@mail.gmail.com>
Date:   Fri, 26 Mar 2021 16:51:21 +0100
Message-ID: <87a6qprk06.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:700:2818:473b:a8cc:f6e0:2633]
X-ClientProxiedBy: ZR0P278CA0078.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::11) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:700:2818:473b:a8cc:f6e0:2633) by ZR0P278CA0078.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Fri, 26 Mar 2021 15:51:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 49873c8c-290a-4991-ceb4-08d8f06f020f
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2910:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2910269D88BE0491014E8FB0A8619@VI1PR0402MB2910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rh2PVoXOIvsjV96Y/65Xc04rqfpO1SURCH9YP6iVvmRmE6v+TwLIzHeevkeMRJ8H96pPEpCT5LcrVUBxQXT7KJLWeKlrWllGfrL61WKmCztvF4Z32kS/UdFeLVz4CUmPxhPX8IvsWnfBOCUSMTjH4ajU1fK8nhbSjZHwmkMEdYk13Enr40MHhrnsEyJ22iXF2dVWXM8BBhSFvtWcTauz+T5SAkEk26WdoALckUdSEypkX7qmnZpb4lE1OGwi3hfQ+qzFgnkjsAuyxR5tCy1KCZZztuDlJtJlMEphGPhN0gZ1JkTdfo+HC6dwqKLHN77gUnRkHensbWsLs0LjVSW+/HYUY4LcvWbIc8oEOHchRbDsXnPGWMI1pdqFobFD5EbkSl/aPIRNVVw9Z8sWXN0nLp+r5Z/2p8hUj3DOuYs/kMgb89WpqMduIirqI3LKR2A0p/qAkJOqqq8Xf8X95pAcz1jAM72cAR3r213QetIQi9hkSDdSUNfxzBH+xkEsVVBkE0F2ckTvvAMW3aCPYifuQHS+GnY+aOgrUxzJHFui5JOypqWaE4QJk+AJ4SqfFDedhBw3StqXCEJlrCURO1etx0IL3Lo4vDEcgFTBMMKv6x/s5LNOlNnzH9QIu9alxVnjt7q45+zrDMFHbJPZf7SCrg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(366004)(39860400002)(396003)(8936002)(8676002)(38100700001)(186003)(36756003)(16526019)(66946007)(316002)(66476007)(66556008)(110136005)(478600001)(2616005)(4744005)(6496006)(52116002)(5660300002)(6486002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TEFzcDBCcEplVmdad1hmZUlRWTMyOXkwL2RheGlrTW93M25wenZwaldvNVli?=
 =?utf-8?B?VU5vUlZ2Q3Y5VU5hZlVkcE9pc0FZN0RRd3hSTG5SZ2Z5VzRXZXF5MlBMUHJE?=
 =?utf-8?B?TVltZ1ZxNWgzNzl5Q0s5eUJTUy9WRkRsM2xlcEFXV0xVcVNldjV6b2VwWnBh?=
 =?utf-8?B?dXV4V1lyaS9BY3F6OGFsYjNzUmcrLzdJOVJaUXhEK0JEa3NUKzNRV0ZNTjNo?=
 =?utf-8?B?bWxwZWErUFBPSVlsOVlRelRELzRwVngyUjB5bGhvZC84UG9OSU9EN1MyYzl0?=
 =?utf-8?B?VkV0TkNHTEZPYXJWMUNHWG5FYUNtelF6TXpzUkFnZnBIdVRuaWF5a2xZeWtE?=
 =?utf-8?B?YkNEQnhNdGxMdGtNV3FVWGUrYS9IbXYrOG5rQk1WTE9LMkxKYjJsbytzUHEy?=
 =?utf-8?B?ZGpxVnl3SmlMZzVJZE9YVG5Nb2lMU2FEL01YY3gvem0wNnJtN1FYZkNaamRD?=
 =?utf-8?B?NEhWTzk4QXdZWjBZbEdQRmZQV3JyM2Nqc01pb096bE9IUjkveVdHQmVBam1F?=
 =?utf-8?B?RDFmcU5Rb2UyYWdjYzQ3aWJaY0lvdmQyRWZzK3FqRkdXVHFTUXdpRWJmc1B3?=
 =?utf-8?B?MWJLWVdwbG9ucXdtOEttRjBzY1gzZzN3TXVyVHhPdHd5TFJ1eGVNZW5lc25p?=
 =?utf-8?B?LzF5SHJOTFRvbmxHWmR0REMyb21xTDZiSWcxRlowM1RrVURQNEZ4bU4zaHVW?=
 =?utf-8?B?Z2dVbjNZck84ZXNJaS9TRU5GNmt2am1uY3VmUlRZOXZvam1ReGdnUUJxMG5s?=
 =?utf-8?B?SmZWSUpLaWZNTW9ua1V3ZzA4dzN2V3ZrMFRvTURFWTdRSC9OaC9vc3lCMG0w?=
 =?utf-8?B?aTAzK0Ivd2Y5MU1jNFpCUXYzQVI5a1pldmpPa2lBeGxRNE5sQWJHaWFGZ2hJ?=
 =?utf-8?B?SU56Q2s5YW1IMTFXVTRYMWM5RXNTbWxUNXl2N0t1ZWlTeVRQMEVCWDNEN0s0?=
 =?utf-8?B?UGZ2UnFueXJaVFRnRHVNb3BQajF2REgrLy9zZUhuVzNaNHBqeUx3QWF5dkh0?=
 =?utf-8?B?cmlyVWR6a1JrR0h2Q1hFMHdzVWZOdUgyOHVRMWNtYld1QVNxZlBQWkQ3MFhU?=
 =?utf-8?B?RjlLQThSQWRPMVBPV1JaSnBwbzRuNzI0cmd2N3lVYU84QzZmUDZ5SEFORWtQ?=
 =?utf-8?B?c2tYV09UZDZ6N1orQ2JJQWl6cjBETDkrcWt5RWdWMUZueGhvM2xpUCtaSEJC?=
 =?utf-8?B?TU9rOFZzenpjb0pVNWNpRDFRaWFEaUtpZ0paOW9nOUZncGQ1TktTYzFZNW5R?=
 =?utf-8?B?dlRtM3JaY2JwL3B2UlowZTBmWEw5WnhxR2JkNXJ1RlA3UGFPTllxbjZPa0hM?=
 =?utf-8?B?MnNTTERTSG1oejBpWC9IYmR5aVRDcG45Wm5QZUw0Rng0VzUxNXZoaVI2ZkNV?=
 =?utf-8?B?cTRNR2ZXN1luWTEzYlpaT3JnRmo3WUVGa2Q3a20ybCtuZnhTUGNXMEFNVWNO?=
 =?utf-8?B?ZnMzdnFjdy8rTlZJTXlpQlpwSHhDTkRzbFlBM2FQT3N4NVRhNW9aZUtzWWps?=
 =?utf-8?B?UGdIdEdycTJESTlaOVo2b0R2V1d4RnJIVDFzRjY1dVh5OVRRV3N2L2wxRVo4?=
 =?utf-8?B?NlVpT2VPTVNpU21USm9rVTJ2N3ZFMmFuT21IbTREeXFVRUh2OVJaNHBTWDM1?=
 =?utf-8?B?WTFlSm1JOGI0cnBSVkJaL2p0SjAvYnpyalNxbldtOUhDbDBYNG9wSHhtUWtZ?=
 =?utf-8?B?R1lCYmh6eTNZRXY4a08xcUs3Q1k0ME5URnVwWERVNVJnZzZBSnQvUDBFTGN0?=
 =?utf-8?B?MDFDMmRQNjFCT0F4QWx4cnBHaS91WW5SbVVnRHkrTnJDdHA1NHRMOTRuYnJ6?=
 =?utf-8?B?dWtsdnd0V2grTWJFZ2tmRHBWNjdkMFNBNFVhTVhoNXUxUDFJbHVGbkNjcmtF?=
 =?utf-8?Q?Yiyr2HnKqP+Mw?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49873c8c-290a-4991-ceb4-08d8f06f020f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 15:51:24.0451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yj03g6tabcylZDmUN9nnUeq+o5NNT3tr+n9O0lZCnf7U7l4esWK50YOrqHS3YHTw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2910
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:
> Found a regression in modefromsid with my last fix in cifsacl.
> Tested against mode check tests for both cifsacl and modefromsid this tim=
e.

Can you put a Fixes tag?

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

