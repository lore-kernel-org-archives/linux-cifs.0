Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF5ACC433B4
	for <linux-cifs@archiver.kernel.org>; Fri, 14 May 2021 11:01:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C170E6144C
	for <linux-cifs@archiver.kernel.org>; Fri, 14 May 2021 11:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbhENLCb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 May 2021 07:02:31 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:41663 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231777AbhENLCa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 14 May 2021 07:02:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620990078;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XvlELfG9tW7Mn11VyPpJHUO6iYopzUxBXZpHpj9kt5M=;
        b=LrL1z3vtwovvDgH0jGuVU5LTcLsPAurJyt1ZKW1aIn4l1v8Z8PAh7VS5ymx5+b4bRvS+uO
        HFDF9BLks69DGWY9eisidauWH7OWGiKynG5tEqfKlEjlE47aRlJR0cZw8OtUtP/6gQEUBx
        +k40zDZhC8HSWaOpxlwMIkFdplcfj8I=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2053.outbound.protection.outlook.com [104.47.12.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-4-3BdpliGcM_uj8aJQirlsPg-1;
 Fri, 14 May 2021 13:01:16 +0200
X-MC-Unique: 3BdpliGcM_uj8aJQirlsPg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UgSyhR9q7ji104C5BtRazolLHbTVxMXoz4YLcs7H16L9bcFcT7yGd8JFXnhks1HvB3cZJT7IiEeCd8ct+WZed8iuqeGEkPC2fAnaSmBpForl7ANHc8u59+dtZAz9+A6U8rwQgYh/q/uXp0qCeaiCUZAxaFUgvmukw00mdK4TrJeiP3BIuAx60509rdm+RM32F1EFxDPcWz2b8if2J49pQ9IjWJCqd67Z9dcATwOW7KT+2dhxSjyY8MaBxDokvBh+QkNMrPZK77Nz1uz+ISklehnt/Lo8SmFDumshfpIQBAa3uyH/bFCCKopT8fzVivVYIxqxic6u+XbRbhgUQdHt6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XvlELfG9tW7Mn11VyPpJHUO6iYopzUxBXZpHpj9kt5M=;
 b=FFhDCgC5aBl8/xpRCkvRRYBDlhrVnWFWb4X2pfF+5OZrVOx8Hz/PisiGAU1n85K8hKPFEZW4AKFODcH80B1kASnrpWexicNB66x6KS8xdnKXCZTeoUbe2ZdlIuqJRNqLGZwbE5BXaxYqfLalNEqPPnnYhyGEVqCp6qRtQ1YLC/cT0c0Zcxu2I2GPa3/7kaU5CureQ5WONd3+/sSZhjDW+nNsw4+z0iBQfQMwgvaTWQtERyPVbdKqYFMO4uM43KXGcuPw66sqePo4sjUsnPaUsuID2SS95XcByghDcsljyd/428rAuMU2g2p8B8E969Ctk1tyJNNpqsQ1WckOGLMBvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VE1PR04MB6654.eurprd04.prod.outlook.com (2603:10a6:803:129::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 14 May
 2021 11:01:14 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4129.028; Fri, 14 May 2021
 11:01:14 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Additional xfstests
In-Reply-To: <CAH2r5mtfVHbbucj6gtWQcE4zHXX+zdYf2XzqQOW2T7-duDr04A@mail.gmail.com>
References: <CAH2r5mtxZx3RG4Z_b6-9bsaLBMAHObGas-yPe3rttj1tXcFtnA@mail.gmail.com>
 <CAH2r5mtkjSwU4mqbkUJomdB3o0Uo84agSVS_Vn+Yz7t1uLYoCg@mail.gmail.com>
 <CAH2r5mtfVHbbucj6gtWQcE4zHXX+zdYf2XzqQOW2T7-duDr04A@mail.gmail.com>
Date:   Fri, 14 May 2021 13:01:13 +0200
Message-ID: <87pmxtshom.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:d396:524:65d3:25:9e8c]
X-ClientProxiedBy: ZR0P278CA0111.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::8) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:d396:524:65d3:25:9e8c) by ZR0P278CA0111.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Fri, 14 May 2021 11:01:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5d514899-582b-4e66-b675-08d916c7978e
X-MS-TrafficTypeDiagnostic: VE1PR04MB6654:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6654F23F20E385C5C47E0303A8509@VE1PR04MB6654.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LpNu0zvAihL6OT7x+2dlaHZLasC10mwtm5c1815jxS/LvVVBzJ1aAm1ov+XBkKIkMhywrZmN9AThGFXpL+W/3wp9ps93g4sjZw/kr6CNkZL1PNrLyH1EqlmOU52GV8gX71VbYsU9lCXS5yg0DEk71TlJWe20WqYlnqFQdWl3RFXIGYDS8CePF7GscORhirQ0inr8b3G1RXM05W4IOXmEtxHw51DmCpzHsBiEFaKygMqC0eweL99/Qkd5PpciegRMtL+HApw8iLL2xFPsBqDD1Ex2BSE1nr/XqYGCYZaRDsyw310b2CVv/IcVNF8SlyjK5BDUgKjQRUZcGia3COQ+QATlIy2ki5zkHy8sL53TV5GEjHm9O6Lr/ir4HHp2ZLbnazLgvXa533FvJJZpPZrQP7AjPVJsvP2zM5OdNAAm19yXbSXLWwFw0dD4NsyYqO4vHSklgHHcNEOf4SXOKcI/49BIsOgTqW7NY0z4S47tzfHX7lH43u7hZV6OtbMhzrpApk04kHVnAkGge+ST//qFt/ZB0et9xsX6DPyoyD93TFNjTNxyH61FbLk68Vpl5t1mAQpQ3O1Ee7IHtMBX38EsGJZVq1PdszMX9lr1LCLk0mo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(39850400004)(396003)(376002)(66946007)(66556008)(110136005)(8936002)(6486002)(4744005)(478600001)(186003)(16526019)(5660300002)(6496006)(66476007)(316002)(2616005)(86362001)(52116002)(3480700007)(38100700002)(8676002)(36756003)(2906002)(7116003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZjBHRzBabkJ6dW5wekI5K213Q3JSUEI0aFc2WHVma3JQa0luV3dRWVRwNjdS?=
 =?utf-8?B?Y1hvQTgvZm5qb0hnN2VSYnpvKzdnbjJmTmNEN1lGL01SdWlHc2FyaFJ1N2tk?=
 =?utf-8?B?ZjlGOWlTQnRDbzZyRnAzZ2dRcXZKN01GVlZ3U1d5azc0OU9kS05YR3RzNmpM?=
 =?utf-8?B?aDk0QW9GOGcxd3kwc0orY3l6UDVGejJ3WkpNTlp4V21LZ0FKSTdKcnE4Q3cw?=
 =?utf-8?B?WXFOR0NPSnVkeHVqbk1PcEE5bG1EYW10S2ZhT1RBVXU0MEVDNDlQTWJKWnQr?=
 =?utf-8?B?NXQzbkpRR0FEMWpaOXc3Tm1DZ0lKMkdoWjlaZ05jU2tINTJiZzRTRWdaMis4?=
 =?utf-8?B?cHEvRDExUlQxNW5lSFd2cXB2Uk1ibzk4aXloRmFBUENORnJjdkxYb3pWM2tY?=
 =?utf-8?B?RnByRFpTSGRBUll6QjREQTRRQU43RWNlbVdhNWNHZDlEM1NQWlpKOTlEbjhS?=
 =?utf-8?B?aWlVZzA1L1NYMTJJNmV3Zi95MUsrNXF4Y0NsbUlHd3JnTjhTVkNReDNFeFBz?=
 =?utf-8?B?NzJpTzM4dkVIaHpKd3gwVVRYcU94K0FwZGNDMXpjUzJxSnhPWUp4ZVAxQU5B?=
 =?utf-8?B?L0d5aTJ5S2MrYlpnWjZXQkdXb0NYMzZHVU5ZMGZ5TGIvaG9uZ3Z1WnM4OUY2?=
 =?utf-8?B?VmkyMmFTdC91cHB2QkhMSFFJVW9OdnIrQ1kyc2NRNXZiN2RDbUNmYTRUN1pO?=
 =?utf-8?B?UzNvMmhYdVRkdHBNOFlPOUFTRjlkb2k0d1ZxbS9sVExzMXprTUc2Mm5UTWly?=
 =?utf-8?B?cjhQNUJyTHB5bkJWVHdCZlBuTXdkLzdDUUFZVlJjREFMYWxySEN0eWFmSzJF?=
 =?utf-8?B?NnREMDN4WXlWNFp4dGwzU1RXTzVEWkQvNkhjSlVRQUJQeGtzV08yNVhDZXlM?=
 =?utf-8?B?SVlsUmZUcUxMcHNzbkt4WHZFVlBIbm5qaHMvL1AyTFNySGQ1WE9SY1hDUTEy?=
 =?utf-8?B?MEZOTFI0ZC94M0hWaUNxWnpZL2VYVG42eHpUaysvZzk2REZKSWhtYXVzNjFP?=
 =?utf-8?B?bzZWcG5YcmxyaWNWdWFkYlZsaUxpT0RldjFBdkNIVkQySmlVVThnR0xoRmdM?=
 =?utf-8?B?TlJsY3FVcDRxSE1MRXgzUTMwUVZ1MU8rY25UZ05lQ0FKK1NhYTR4YUxNb1I2?=
 =?utf-8?B?My94MURkU2JjTGJsbUdlNGo1SSthVTBQSVFFbTNFRnpobWhCTEpqeE1oWFpx?=
 =?utf-8?B?MDVpWFlueXBmRXd6dDJ3Y0g3cVVQSjZSRG9KN2IzUENLZlAyQmpCWTdXdytQ?=
 =?utf-8?B?c3VWY3hXZTZvT2hLOHMxd3RoWVJlQTd0VXlJWTViQXdBRUUza3NLZEJJS0JL?=
 =?utf-8?B?MTVyVnl0NlR6MlhrTGhxZFE3ZVVtTHpycTBWcDQ0QVVTejRLdTlyR1hiSHU2?=
 =?utf-8?B?OWRGeHluY3hVK2hwMDZkWEloVXpsM1haR1VpMlU1T0ZPak41MlN1S3B3dkZt?=
 =?utf-8?B?ZUlTQ0RaZHBhM0kxU0hwb0RVZWFEMElKa28rZmRuVitqZ0g2cVZpOXMyeGV1?=
 =?utf-8?B?dDhKdmxaVVlZenBQS1FjYjNjYWxqYXZLTjRHVDd0MmtVMmh6Nm8rS3dkcElj?=
 =?utf-8?B?Z05EN2JIT2ZyMm96TEdCY2lSL0pkZDl1cDVwVTVRZU5xdmFqN05ZVG9vSXV4?=
 =?utf-8?B?djR6QVBqRjdQaUNxZytKdmpyYkt5akpOQWlDdE9KZ00zVis2bHhGWGlvUith?=
 =?utf-8?B?d0I4UmdTYUFyY295N0puVWluR0ozOWNoaVorVW5YRE5kSHNCL0xNZ2hxUkNw?=
 =?utf-8?B?aVpmM1U0cnlqbmxyb0MwKzdOT0NJM3dNZlMwMDJVRVh3bTZNUjJ2MFlITXVu?=
 =?utf-8?Q?4x5awndlmIBijlF7KifRNrcqN/maflOPZgZzA=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d514899-582b-4e66-b675-08d916c7978e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2021 11:01:14.7590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GNpfQvh/O7uBHpJMw34S0G+f3qarxAV76Qd8KYkuV1+wBYOUO9RlJBz5I8FHMBcS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6654
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
> And just added six more:
>
> xfstests 461, 590 and 615 (and 630 and 632 could also be run) more
> generally across multiple test groups
>
> and tests 458, 518, 525 for target server of Samba running on btrfs

Great news :)

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

