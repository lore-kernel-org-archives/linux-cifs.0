Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5527C47087
	for <linux-cifs@archiver.kernel.org>; Fri, 28 May 2021 08:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6D0B613DA
	for <linux-cifs@archiver.kernel.org>; Fri, 28 May 2021 08:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235038AbhE1IjW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 May 2021 04:39:22 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:48528 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232481AbhE1IjV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 28 May 2021 04:39:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1622191065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Aq6zc5aIK1aLMZDu1LswgL74F2yILU9kUuTleZuTKsI=;
        b=Fs2AszdW/Su29EGNDcoA7suvQfmn0VN5PjviXO4E5ZVA8WRrlQIIGrZ7jiCpFi1Z9bdE+Z
        MCB9yX5CsfUSackAc2GaQUFXNTTMLqvzAkiKlh9zJPB6HhPVxLbUjk8E1tKYM8NqtbiAmD
        jKKtRVizHfiV6wo14eCeTmhdhx1yMsA=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2053.outbound.protection.outlook.com [104.47.4.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-32-LZ6-PjY_P3GMQUpVmNn8yQ-1; Fri, 28 May 2021 10:37:43 +0200
X-MC-Unique: LZ6-PjY_P3GMQUpVmNn8yQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VZmcgPfCkKZK+Cap8SPJmOvn15sNnvFPulev1+zJP6E152p5o9MLObeuMiAf7MafpICT0VZRhKeuOKbMGkEuzOJkuQRZKDFgcNm2cBb90YdD4+flZHprqeiBzl7OiCtNNmCyYLfapOnZF8FHwBKAu/U0CcX8bUiSBDZ7gFWABRqoA/UE7Wf2jeNcPftdhArfWUsanMWSXpfcYvbW9d+taGm63SsmEs94VsH6sU3MqSNhZ9pfeW/zUrpPTs+usCEfZz0fdPBGheIX5Z8rcfLhnZhE5YMBfXXTzzTKvA5AqBkn8TVE/P/WkKGYSN8i9HpEGZLRT9Eyxy1cHf0awYLK5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aq6zc5aIK1aLMZDu1LswgL74F2yILU9kUuTleZuTKsI=;
 b=LJGs5jkBQaHYqwDOpM2DqlBdwdskX7jKr2h4tXkYL1R35d7NeAFiOgpAI3+GqSWWTQ7YCYD4mxxs/1ilKG0YrllSyUcU/E5uj+F8VEiEbMbsrUzJlf1hhU4g5JZSsq8gVd5X4J+BBDpHd3C9m2XfUyFkowKxHahN2YThbjz791Dfy/EZ1nlp+Uplkf5jfnfi/m5HSbjk2iEpKGAXErhj36JbnurLJVFjtoka0bRKkveekd67z7briP5Aqgv6mvk+Gz0dAfPWgyX6czpk6zkJNVaBazv9Zvl6pOSdxeuw7PvxrLQHKqUEHhFbLiP81Hs8tt6YMsEy3MlNb1BidcaPRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VE1PR04MB7277.eurprd04.prod.outlook.com (2603:10a6:800:1b3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 28 May
 2021 08:37:43 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d%6]) with mapi id 15.20.4150.030; Fri, 28 May 2021
 08:37:42 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        "Stefan (metze) Metzmacher" <metze@samba.org>
Subject: Re: [PATCH v1 1/2] cifs: set server->cipher_type to AES-128-CCM for
 SMB3.0
In-Reply-To: <CAH2r5mvQCKFZSvMf0FuF6uTzv-OBx7E=eF41V2G1JwgPWUxXuA@mail.gmail.com>
References: <20210521151928.17730-1-aaptel@suse.com>
 <20210521151928.17730-2-aaptel@suse.com>
 <CAH2r5mvQCKFZSvMf0FuF6uTzv-OBx7E=eF41V2G1JwgPWUxXuA@mail.gmail.com>
Date:   Fri, 28 May 2021 10:37:41 +0200
Message-ID: <87im33tfsa.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:d360:c494:e448:539d:457d]
X-ClientProxiedBy: ZR0P278CA0143.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::22) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:d360:c494:e448:539d:457d) by ZR0P278CA0143.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 08:37:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc338849-a2c5-4f0c-3555-08d921b3dc05
X-MS-TrafficTypeDiagnostic: VE1PR04MB7277:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7277FBE9710C245003475D63A8229@VE1PR04MB7277.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Es7fR3r1/ou+4dgkzNSQKlj29UWhTXtHGGeFS+tQl6AtWUcj5n/kQhlDxv6vaf3oInzzz+LuXURDrSB+pTTxENzZ5H4nHgYnTllYhuYfbgHBT44J6g4qc4hKL5JNYy4HLBm9QFlJsJS53wz2ZE8yw3ThwGWbZcwfW7BqWWmYx182jIZ5g+Zwaazs9duqRCdtzo4uCW3BCZBYHfNhvNtUj5kIMF9fOEYo95rOmtJ91sHCnwB+ILOzOW5IzjCQRIZCsvMat47KSTEb0FtXkzwTHTC2WXlBy4rapc7PoIA/Z2GiSv9ZQS/ibjztOG18x3s2xt51rGrTPunVEzpMrRThDLT379BgN23ZTL2yHQit6IFGi7d/um5WiBEBkCu1gg/XlHo7TkFfMP3VkQS3DkJ5xXTt2kT56A7ggNlUmrGxhRKSr69dVE9RNQy9XWetzHAiyGbN26o4GvkrOtyU80Bq2I0rFQzm5fjAMRYQt+ZCXZDEuyn9jXIKiBTUC7onS2BQ2CLaFTidgCdQzTWX932mDb3EX/uM5Yzj8zBv2M+XFgscrV1r8QCKYBEVYqMZXRmtEESyde2Oo45lI6mEd8C9FA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(376002)(39850400004)(136003)(36756003)(5660300002)(38100700002)(86362001)(478600001)(54906003)(6486002)(316002)(6496006)(8936002)(2906002)(186003)(16526019)(6916009)(8676002)(4744005)(2616005)(4326008)(66946007)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MkxJZkdZRzNSd3FxWUtzeTZST0xZL3dNT05CSC9NRFRkYXRPOUVpTGJBWTN4?=
 =?utf-8?B?K0RhSlA3N2dsbHY1WEVYVTVoQnk3TFZNdWxjcGNyZTUwampKOWVaQjd5RnNT?=
 =?utf-8?B?ZWVzb2pGSGEvOFI2T1VOS3BVWHpzM3hwVVJqTUxzSkNUVHlTOVhsSDV1Rlhk?=
 =?utf-8?B?UTZsdk5Rclg2b0xzRkMwcVBId1lhSlFFR0pEc3VNSXovK3B0NmR0NEFxM1BC?=
 =?utf-8?B?UHd0S3JvTERqTFIwRkluQXUrbnhvemthMlR4NkZ5TkRTU3BTWG9KY0Jicmw0?=
 =?utf-8?B?anJ5N24wWFpaQWFXLzZvM0dTWFdLV2ZDalNrUVJkWmtHaWJlcDlBNHBhRVRG?=
 =?utf-8?B?MFYzUmtUdlkzcm1iRHFONVRPNi9mb0RiRmpWdFF6Tk5JM2dOMWxqNVpuRWZs?=
 =?utf-8?B?cnlSdlUxKys0aDhQYVplNUY2QUVVaUNQZVFSeGQxTlhyTHZuenZwOXZncHBW?=
 =?utf-8?B?Z1ZQR091aTdsZUtFTDhpNWJyNW5sWVZhOXIzaUt0V3RINitSYk1LeTlXL0tZ?=
 =?utf-8?B?VFVJN3dYblhnVGxhZUJyYmtMcU9xRUFHNnpYRXliSmZHZ2haL25nY3A4SkE3?=
 =?utf-8?B?RFhFdzV0OStuVzhvWWlPdHhjZmlzVU9zV05QdjZvVlF1VjFDTlBoczVJTUNt?=
 =?utf-8?B?c2QxcHAyaUJwLzdjM0diNnRaU2dhMlR2YVdsQUNjRjRLRkhlOTNRaWFNcFZP?=
 =?utf-8?B?WmN4bFVsenNKT3ZrZCs4eHJMdFdxdThSd1BLbFd4NE91VmVBdXhRT0ZlODZD?=
 =?utf-8?B?dnN2amo1eXV3TjFNYVI4VzFldmpZY2I2QXNUMGlRY1hHN1R2YTV6OVNSUDNy?=
 =?utf-8?B?dzBLUGV5blh4TXJPSkcrempXSmZEbVN3S2JrMTFuck9MUEtKZkNXb1dQcFBL?=
 =?utf-8?B?MXMvZmhleGZHWkNHMTNnK3RIcGdlRlk2a09wSUhMT0lKYk5jMVp6LzlULzFm?=
 =?utf-8?B?RVlTZlVhM2RmTXVCaXIrektEYVJackpFdlRUbVRrVEduZVRHTjVjTFpEMURQ?=
 =?utf-8?B?WFJ0c0YvaVozUkxpQVZaTUYzWlNLQ0NJRlMyT2docHBvU0FtMFhBNGVDdlZZ?=
 =?utf-8?B?c1hPbnZTTE1UMEJTcDdRMVpKNVFwWDAzdk4rY1dMb2hPanJjV0xLZXVuYXJi?=
 =?utf-8?B?dS95Y1dBeW80OUVheHRXU2llZFBodzdkQ29ESkg4RVFuTnZ6eVl0anNybkhJ?=
 =?utf-8?B?Vmt0VFNzaWtCZDZ6YlBQVDRxZ2NSaXFmbWdOTVB2WFZXLzdFcEtEK3RiQk9T?=
 =?utf-8?B?eEl3cEgySGVzV3o1RXFkMmFhWlVMVVg5Uks0YWxoY2Q0SDByRlo1cjlqOExX?=
 =?utf-8?B?ZWM1alhGUnAreWZCZTM2akFjLzJaZlpWM21lK0kzck1MWHlmZ2pjY2thNDBR?=
 =?utf-8?B?eUUvK3NYc2tRNld1bEpXcXdNczNFRHk2cVJkOVRuTkhYa1RvdEl5Nmg2eHhP?=
 =?utf-8?B?bTZTNkNucDIreEZtMzNJM1pCaWdkdklzdUxzS1ZEN1luUUNNYVJENzRCUDJj?=
 =?utf-8?B?MTRnWEUyRW51ZG01RUVkdFpHdkhxaGlKdlJZcEt4ZTUydjlBa3FvZWljY3Ny?=
 =?utf-8?B?Vk1tOWhkYjF0TjZuQmg3eEVsZmlXcjNETGRCcWxqcU1JWUFoY21mUjE2N3Nq?=
 =?utf-8?B?ays2SUhqbDV3ZGpZRXFCRDFzUjVVWlJiTHM5TitqTGtqZm1mMkd6TUc4UkNu?=
 =?utf-8?B?blRJNFovOGdGYnFaUHlmNFlwVDd6bVd1OEQyZ1pQd2xoQVRHMUs5WFdobkk1?=
 =?utf-8?B?bHJVRnBMNXB6L0g3aVNhOTlNdm1wekhCaFlNUnZQNUxOZG5EQkIyQmZVeEUr?=
 =?utf-8?B?R0ErblRKQm5abHFZY2hmQzA3NDN2UUpyTUdWSkN2SXExOERVb0p4Wll6bWs3?=
 =?utf-8?Q?rfcln4Jg4Ftjz?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc338849-a2c5-4f0c-3555-08d921b3dc05
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 08:37:42.7715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2pCgyoN7Mhl+6e/GczP3mkH2A+Oecp/fhEVWOkxDc6Hw29VXG3ig7yrrx0OXxjzZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7277
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
> stable? How useful is it to know for debugging?

I would say it's more correct and avoids checking for 2 values when
checking for 128-CCM. Not much difference in debugging.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

