Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7512AC4361B
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 15:52:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFFA7207AD
	for <linux-cifs@archiver.kernel.org>; Thu,  3 Dec 2020 15:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbgLCPwD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Dec 2020 10:52:03 -0500
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:45093 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725849AbgLCPwD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 3 Dec 2020 10:52:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1607010654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nonQJaPCTk7N42pXinwI0ZJxWuo/ER/EktuE73wS2nE=;
        b=DcagDU8PgakUIQqRKo1OT/81GwNO32sgu+jrTRuihBOMmF3xpL196kZPWTHQjXmgyDXj+W
        sOM4Pt5U8bj/YgRFjVenFG0QGocMVj7vlpZ1qVFgGV7vKO6+ntLiP1HF08jM6+DbamzNA7
        nKQeFhydS8Sy8BKN2Dv78nliRXDmncY=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2171.outbound.protection.outlook.com [104.47.17.171])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-37-fgf2C005PhSLiKEpHLSW4g-1; Thu, 03 Dec 2020 16:50:53 +0100
X-MC-Unique: fgf2C005PhSLiKEpHLSW4g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rh5u2sJSYpeICwMp/huElcjSygTcyzaa378eYKmaimuvAzfIcEKJQW430Oiitl19xb4TQ9yF3T2ogpCBQb53AGa6hY/QlzGGdHzkBFoTTh9xNe5gKgkabE8QxHHOxgN6w85B3yd1xV5dMYMycHihJv5KW0/Bfl96eeVLGLZ3wlVpZXqHUaKT0KOdK1oB1UipdW30ljYxWvhKfOX+BwqqoNl2TxblI+CmvSfcu4Vb/jbdb9RA9SmfQCaxyJBempPIDsdc8SJIsblPZFvOPE+LV7plY8o5lD7naUG14QHxU+BPZgQ/JZSogq7A/0kFBtniZboLO0wUM3uUiz2ORKpSwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nonQJaPCTk7N42pXinwI0ZJxWuo/ER/EktuE73wS2nE=;
 b=oJU5F1OTvE2UQaWOH0VAjWLsP27C27dyUXnVnqniKPahJdYLPA+XkUk1OwtwDVrro5sNFB2hFV+/gI/xjxgO4tMmULMJP17kX/4oWRj45S0nAPQwu5QnluhF4oQB3Y1r1OjLKg/g4H6SpDkQopRixCNFUk02pl2OuqwDW6yGt0xEV1c/LkeOdya7hWxn+BJJR7uIVBJQ+RS5Ppj6v8PISGk0pqlpDH4rK+8Tgw7UGd+44i2js2Fiyl003jeBalSL2got+ymelJ4RIFOgzVypUrF9wPgjn7HKaOF/9aL0TBhefp0SsGe8e9RFe1FZrNXYO0SAoJApm91PTmbsvdZcPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VE1PR04MB6719.eurprd04.prod.outlook.com (2603:10a6:803:128::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Thu, 3 Dec
 2020 15:50:52 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::4dad:a2d3:5076:54f0]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::4dad:a2d3:5076:54f0%5]) with mapi id 15.20.3611.032; Thu, 3 Dec 2020
 15:50:52 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Namjae Jeon <namjae.jeon@samsung.com>, linux-cifs@vger.kernel.org
Cc:     ronniesahlberg@gmail.com, smfrench@gmail.com,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH] smb3: set COMPOUND_FID to FileID field of subsequent
 compound request
In-Reply-To: <20201203033136.16375-1-namjae.jeon@samsung.com>
References: <CGME20201203033831epcas1p4c69684156cd4e393f048472a24238e6c@epcas1p4.samsung.com>
 <20201203033136.16375-1-namjae.jeon@samsung.com>
Date:   Thu, 03 Dec 2020 16:50:49 +0100
Message-ID: <87pn3qevmu.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:9f91:cecf:b9c0:26b9:4a2f]
X-ClientProxiedBy: ZR0P278CA0011.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::21) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9f91:cecf:b9c0:26b9:4a2f) by ZR0P278CA0011.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Thu, 3 Dec 2020 15:50:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8a73554-93cb-446f-a8e6-08d897a33676
X-MS-TrafficTypeDiagnostic: VE1PR04MB6719:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6719128DBBC589DE322B0794A8F20@VE1PR04MB6719.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1y8hNfWPDh/5RfRp6fQgmvA0fg2/mp4pz9127XGopyUtVjGF15qjJr+4X6Far9yw7+WFEDyZ1+jPaGJwXIbz9qdyLWmDmSR6yjjXUplgTLopaw3vWztlT88cLsdKS1b+YyO9EeLxAlg5+zZl923p0MHHrRufcZ7LiY0rSDi/R6UCDI8JVFd5vG+Jz9UuVzlmwyMJy7Yu0eYtT7VeTpZXkf5PJA8DDiLu7wlNxXSZcNwBEcQtMKXoeavG5TxJzyVtaXhFxCbWlMFjYVOI8ImNKr9f7qNKDgjlejpoxhKkGAsuljuRqXfbSylN9SGo8QGwiAu2/oUD7UaeqGTwe02f0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(39860400002)(396003)(136003)(8676002)(4326008)(2906002)(6666004)(2616005)(66556008)(66574015)(83380400001)(66476007)(5660300002)(8936002)(316002)(16526019)(52116002)(36756003)(6496006)(4744005)(86362001)(478600001)(186003)(66946007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aFRic2NsSHUvS2dwc1VrUDhoK1BwYW9zR3RWdGpTNGFjcjJ4NnRzeWNkWTZv?=
 =?utf-8?B?dHFvd0lmSFJWTzVnZlVpMVpYTldUSWtSZ0hPOUs4eko3cFNkaVMzZXNuSGg4?=
 =?utf-8?B?K3RXK3dCeTZ3b1ExcThYSFZIS1VCb3dOVTZBdnFXV1pBYmFoZ2dOTTA2NllN?=
 =?utf-8?B?emE5aG40bFo5cng2aVgwZFl3Y2MzV2FZK01pYUgvY3ZBb2Iya0FUbGFjbjcw?=
 =?utf-8?B?TnVBbFlUT1dkTXNZNnZ4SXJTcDljZE5BcXNEZm55QjgvdHdaMDJuTDA3R0Zo?=
 =?utf-8?B?b1BTZVFXNCtMQThyY0hWYUhTeFhCMDAwbXUzdUoxM0NpeEhldWhaMGIyQyty?=
 =?utf-8?B?T0FHN0U1WFFvQ1FxZU9iaHZtRENhTkx3VWwza2l2UDZ3dC82K0Q3bm1xNzJC?=
 =?utf-8?B?Z0VuWmxqTVVQc1BoVWhNYVZ6WXdVa3AycUdGYk9oUjlYejFtRy9rVDFFcHZX?=
 =?utf-8?B?OUJBYjFtVlNwR1IvblU1ZEdrOG1oOWhoYkp6MXVPUnRqMVJnMStTVmFuZzlJ?=
 =?utf-8?B?WEFxdXU0dTZKU2tBYXlnSDdrclVla2U1VVFBWjB3RlErSy9hTVI5dnlWSWNZ?=
 =?utf-8?B?NkhZdUV1UDhMTll0M0VMMGpaTTZXaWY0NzZtRWVXU3RMK0VNdkFFdTdCMkRm?=
 =?utf-8?B?eFBzS24rMjVOSDRUU2NFZVZxdjdmTVVMVU5CYU1qWFVFWU1qQW9MY1VIdXVJ?=
 =?utf-8?B?dTBjSkVNOFFYTkFzREg2WHZkNzFFaTJqSTVaRXFpYTFTd1UrbUh0YzBGRnRp?=
 =?utf-8?B?QzZWSTJUNkpOU01wSndMSkRzNkNpbnJWTmViTk10Q04yYTFZRnFkeWMzOGlF?=
 =?utf-8?B?Um1ValdzSkFOUk0yMDkrcTgyNDlJTjY1bzJQZmxTamVPejJ1ZU0xUWRCNzBZ?=
 =?utf-8?B?R0xOaEtFcGw0S3JxYlFLSm1xdFFMWkRDMCtXNUI5NmorZ3Y0MmtqNVNraUNT?=
 =?utf-8?B?WEZhTGE2NEcwVkYwUDluQnlXa0dLRGRwWE9ja29qMElHblc2WUFKejZpZWov?=
 =?utf-8?B?bTFsVkkvMld1NVNZU3dOUlR3NjAvckVTU1V6NTNDc1pKRUIyTmYwTjJxcGNx?=
 =?utf-8?B?WkdGM2pGTll6d0J0L3liNEp2M3RnVG9HWDc1MkFCTUdoZHhabjJyTGRXQURa?=
 =?utf-8?B?YzY5dFE3Ty9DNjl3UmpwZHhYTG84NGZNcFMweERISFJJTkFET2ZkaW41cFlm?=
 =?utf-8?B?dTNCOFNzSWFEWUtaMVRSNG5ySmdBUHA1TEFSM0RnNGdqQTFxOEh3ZzVlc2lD?=
 =?utf-8?B?RVZXOGxpa29KU1JLaFM0R05vZDA2KzZTNzNJdmJSUlBFdjllL05JdnRoTzVP?=
 =?utf-8?B?dnYvMXB4V2ZnMlRpWXNFMEI5b0pWUFg4eisyUEcxTFRJeEowRWRocHBwMlVz?=
 =?utf-8?Q?m7qIqjNXCDTUhBoct5U4ocpqnzE+VUTo=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8a73554-93cb-446f-a8e6-08d897a33676
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2020 15:50:52.3953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +bgAoqv4SBdPPO0tk2Gk3y3pNGA1+sZIo4JQTanG5Qvw9e0qZ3cbZmjYl+2QkenB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6719
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Namjae Jeon <namjae.jeon@samsung.com> writes:
> For an operation compounded with an SMB2 CREATE request, client must set
> COMPOUND_FID(0xFFFFFFFFFFFFFFFF) to FileID field of smb2 ioctl.

Looks good to me.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

