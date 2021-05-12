Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E5B7C433ED
	for <linux-cifs@archiver.kernel.org>; Wed, 12 May 2021 09:38:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 699FA6108D
	for <linux-cifs@archiver.kernel.org>; Wed, 12 May 2021 09:38:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhELJjv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 12 May 2021 05:39:51 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:52102 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230293AbhELJjt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 12 May 2021 05:39:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620812319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pEVb+z5L/MOLhBEVNm5bXUnjYt9WWILi1dzLw31dE/o=;
        b=HyQ1A3Cu+i8doxEfhpFQjtudWhhPaitIDYsLZ6a508NqD1WGDtrpvEevwkbv+50zk0/Dt/
        KgqipeGWs0RnwInRLHu/MKtI6ScC7KpnbU6Cxwl2TfumgRPte1PdVmi20LRLawhO8EAVgB
        N24vBGhSrmPLMY2BeKf7d6d1G4cF9Ek=
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur03lp2059.outbound.protection.outlook.com [104.47.10.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-26-w_gKg2ncNyKcVEKz1qav1w-1; Wed, 12 May 2021 11:38:38 +0200
X-MC-Unique: w_gKg2ncNyKcVEKz1qav1w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZUzRfjc9svErTubp0IUetDlD7CnXqXLIaZiqm3sXz0gQtGM1GxrrT4gmTw05zHpPU0Xwg66L49ETwp7S5vN7rk4krJVpi4AFDlGkv7SxTf0XS9PqxzdVEcvqDVmaVxx9lY0rXM1h2r0VsmFdEM/c2gp5GI4erniYG49dxtrfLcX+4qXui0Ljjg7wE+k9iJJWfFJgD+ETe1/eppn/fr1YXscoeuKE28ypVdusIlofoO/2rFz80SQHhbVMpEdak0yv5guyNPCi1nYiBrT7Nm8KH7lvZkBXlTYx3LzKLqm/JCC6ZrhASpq0XWOLIckLOglvFD6R1FHGjdQBba87YmwCwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pEVb+z5L/MOLhBEVNm5bXUnjYt9WWILi1dzLw31dE/o=;
 b=a8xOiL5BF/u7yPqYjsW9jepzZNeod0U3SlqJ97F7OfWrA606YspWiY+gs3hfa76DMWXkpXvD5IyZACtBtSIRQ1Vx5S0u6nkzXYXXzP/DO3sOgT3qFRV5dinsS61E0MSEAaKC5X8FxRNKXPdViP8FzQAmY+doIIT4VR6U+YJHx6jhjAnW28MGH1VO3Zr/glfHzqaxGoXPSUnbp7XZrv6qOcCCEaTNqswDLypC5o4K8IaGtFpE5Iv9Tc95N/64L5BjFZRZbSyCp2bMNxUsvOkANsLRYU6SMxzFqosFq5Qxxc9RJCoAG/enRBOAZAZs6jLzBNri+MKickUW0P4RPMigzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gwmail.gwu.edu; dkim=none (message not signed)
 header.d=none;gwmail.gwu.edu; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0402MB3519.eurprd04.prod.outlook.com (2603:10a6:803:8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 12 May
 2021 09:38:36 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4129.025; Wed, 12 May 2021
 09:38:36 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     wenhuizhang <wenhui@gwmail.gwu.edu>
Cc:     wenhuizhang <wenhui@gwmail.gwu.edu>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Deadstore detected by Lukas Bulwahn's CodeChecker Tool
 (ELISA group)
In-Reply-To: <20210511223425.12863-1-wenhui@gwmail.gwu.edu>
References: <20210509233327.22241-1-wenhui@gwmail.gwu.edu>
 <20210511223425.12863-1-wenhui@gwmail.gwu.edu>
Date:   Wed, 12 May 2021 11:38:33 +0200
Message-ID: <87v97os352.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:d359:b215:6aa5:3693:e486]
X-ClientProxiedBy: ZR0P278CA0088.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::21) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:d359:b215:6aa5:3693:e486) by ZR0P278CA0088.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Wed, 12 May 2021 09:38:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2d7a275-5c5b-4a94-f09f-08d91529b715
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3519:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3519AB17F4BB381DD6589748A8529@VI1PR0402MB3519.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /g6dtVoIWWGfJETEz5jKYsfWT3mwut2ElvLCoTMP3BQeRKlQeS5cBZDQV8iG804HMnPw9nY5BNzSMMQZp1g+IOTsWeu+hX+cjfRevU1kphZWuaWg1bfm3gwFuZa8rzWM3a1QH7l8RMEpjYslCBc9Z+pxViOjO4izU2S8vWCWJHl+iGZMp3dx3KjOCQeH3yf3mR78XhXacKRJb7q0G5d9CizdkmPDtAd1CvkfkXP0yNMf7DYzZOzZCVtRnEQGt5fDHgRfUhUkuj9PeHePFiKJe+4/8tq+HorjgLNQ62gNmOcROqXvMl2nYDnzhUXdW0XERiYgzHYn2OYYhDV/JAqP+cOjxzyd7Zx2cBjh+vsajQetEQZi8WC72nFaOjsYH3AGsE+e5pxMgcMR7AWkbOVKEVQ4XZd8MRtLB0I1Tabr+ULrI6sRrw9YH1uEbQ4BZpa3u1UT+nBOQHg6NOsqjdBHAE5bfvDL4dyyp3Bk7EV2PjJAtUdR9TtpKKeFvWQw7wC4Y1IdkuGqhuXg97jYonriExoolHeYBYTHBH7orNocpdkUFT5VjWzDttHN8TFmPXrC+apRcFGS59Y4GLO+YPBdJQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(376002)(366004)(396003)(38100700002)(66556008)(66476007)(5660300002)(36756003)(6916009)(2616005)(66946007)(478600001)(4326008)(54906003)(6486002)(316002)(83380400001)(8936002)(8676002)(6496006)(186003)(16526019)(66574015)(52116002)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WStkeVNpUlNEaDgycTZKRVJ0YUxxdnppb1JYYTBHRGg4SlhIVTVsblNJZmEr?=
 =?utf-8?B?dHFFQ3hWbzVvK2ZFTEdKemtGMXFrcGFDT2dTbklXWkpVV3V1WWdBSjB2cDBx?=
 =?utf-8?B?NEZ2MmhsRHJka3NvN2dLNGQ3am1pMWFYWTNzZkFYMEVZZ09IN3BGcENmM1ph?=
 =?utf-8?B?MlNKdGE1VFFqd1pMUDRsVXlGbk83K2Z6cnV5UkZkNVh1T0lNaTJRM0RRSkNC?=
 =?utf-8?B?eUZNSHdjK1RzWHNaU3BMdGFYeUJHaHFZN2MzT2tUbGhscVAwMXpKRmtyRG5J?=
 =?utf-8?B?NDdjVlZNYXorSVAwTWZodi8rNUh5NWpySVduME5NL1JOMjhybFcyblI3MlQz?=
 =?utf-8?B?WUVYN3F6eU1JVWNEMnh2U3crVW5NSFVIS002SGl5ZnNUNE1TT3kvN3EyS1lQ?=
 =?utf-8?B?c3VoM0tuQWdPSC9PdE96RitqR0NWd0QxT3lHY2p1aVNsRVdqRTA2cEtqNHo0?=
 =?utf-8?B?dXczMDNoL2VVY2t0SkVkTkFNdmpnRWVEZ2NRV1c2bzR4VzdGU2w2L0ZTNU1H?=
 =?utf-8?B?TFJLcGMzalBZRGR4b2NhWnNvREZRM0pIQllhT1BzN2I0ZEMzUDlvUFQraFVo?=
 =?utf-8?B?dkhXUG5ZQnBtZnF0WWYvdzB6RVo2aFFGREdqM0tmY0x5ZnB1RWc5Rm43bEFG?=
 =?utf-8?B?Yk9sMmhJa0VSVHJ5TktkOHF0cHM5ODlXd2lIQWxETkc2VHA4QWQ3bWQyWUUr?=
 =?utf-8?B?TE0xeUtjQ3dBOFlveFpuQU5oQUd5ckw3S2tFaWhFcm9iU2dKSkRVeERNbUNE?=
 =?utf-8?B?ZlQxRnhYK1cwZkdtUnljWmRGS2E0cGtsMUxRUTViZUxFMkE4UWluL0hNcmV6?=
 =?utf-8?B?Z04vM0pTY0N5RWJkNUdlRllzRGU3bWR4eDNPZVZUUXFKM29EVHlUTUVlRGph?=
 =?utf-8?B?dFB4by9MSDUzQnd3Rll5YU9ZazFreU91TVB0b2F2aCtkQnlWYWR0c0pzWE13?=
 =?utf-8?B?V1Fiei9nZTJiVENCT3JtT3J0L2NzNEZ3THJxZEhFVHd0a1ZSR09UWldPNmcx?=
 =?utf-8?B?OFE0eXA2dVZMV2JDbi9Rb2tSSVdGN3R6bDdrbm0vdjNsa0lVS0JVQ3JXQ3Bh?=
 =?utf-8?B?bFJMWFdkeGJBYkt5cm5od1VrajI1N3VCNit4M0R1RnJ1MUhzeVpxQVhVYlNJ?=
 =?utf-8?B?cDdzeXhYaVNOVm92YVd2Z0lsdzhKZk9vUmdkMXN2UnBXWWdoR0QxUnFka3g4?=
 =?utf-8?B?YiswSmJyRHNZaHFaemllWDY5ZjdZT1E4SUpIVkhIcWNPbTdQSnd2R3U5SXFs?=
 =?utf-8?B?YnVVMXhDVkpMN1luaVEvdWxCd2E0WlFrR3dIQTdsY3hWVnpscEh0d0o0M3A3?=
 =?utf-8?B?QVByVitjdVEvTjYxa25MOHZrcWF2OU84ZXVjZExGZFRGeVo2Q2JOdHBSRUpq?=
 =?utf-8?B?R0plUXFLY2JxbjQ4MTV0MVo1V1d6V3VkUUtsME5hSTJlSVRLelZVK2pmN2Vl?=
 =?utf-8?B?aDA4T3ZHV3dpTXVMSXJ3TDJ4bTJoOTJJVTVXb24vTVZ5T050UWJ4RlhFWTJU?=
 =?utf-8?B?TWVabmNUcEFrNlNEa0Z6MkVUUnRmVmhlRU1TV2F2bnovTHF0bis1cWVObkJS?=
 =?utf-8?B?dkIxOXFTa0l1YjRwUjluZCs4eFZmcHlSRnlkaDYrZEhyRFNsbmRHTlF4MEtt?=
 =?utf-8?B?dFc5QnRUaVlYeWFCYUo3aWNFRE81TE1sRTVYYzZWWUE4dXd5T0dKY0RHWWlX?=
 =?utf-8?B?SnRmYnFzcGZBR0p2MjAvVEd3c3NEbzM1cVUvSUhJL2xNRnF5K3VWdWwxeVNq?=
 =?utf-8?B?bTgrTWo5L0JCcGxSaUxOaXc2Skw0K29YQlc1UTUwUVBMZW9IcmlmSmsyck9y?=
 =?utf-8?B?ZEVhNnIybi8rM2tpQUlHRVJ5L1pyWXV6UHJKbzd1TEs0enhiVEVJUy80TDVm?=
 =?utf-8?Q?VGoWVwbCWdzZW?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2d7a275-5c5b-4a94-f09f-08d91529b715
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2021 09:38:36.0455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hb9iPlCPIvm5xyBHRBfC8xI/1KHSopOMzr4YtmflkAkDQCBKfOGPEJx9tBAs3i8E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3519
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

wenhuizhang <wenhui@gwmail.gwu.edu> writes:
> Deadstore detected by Lukas Bulwahn's CodeChecker Tool (ELISA group).
>
> line 741 struct cifsInodeInfo *cinode;
> line 747 cinode =3D CIFS_I(d_inode(cfile->dentry));
> could be deleted.
>
> cinode on filesystem should not be deleted when files are closed, they ar=
e representations of some data fields on a physical disk, thus no further a=
ction is required.
> The virtual inode on vfs will be handled by vfs automatically, and the de=
notation is inode, which is different from the cinode.
>
> Signed-off-by: wenhuizhang <wenhui@gwmail.gwu.edu>

That's better but:
* the subject (first line of commit msg) should be about what the patch
  actually does, usally with a prefix of the subsystem. So for example:
  cifs: remove deadstore in cifs_close_all_deferred_files()
* the body of the commit msg should be wrapped around 80 cols to avoid
  long lines unless you are quoting some output or urls

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

