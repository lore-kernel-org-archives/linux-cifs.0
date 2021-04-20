Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C2CBC433ED
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Apr 2021 16:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC7C16135F
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Apr 2021 16:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbhDTQlq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Apr 2021 12:41:46 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:42408 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232473AbhDTQlk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 20 Apr 2021 12:41:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1618936865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=idv6FNbrCMjECznCgezzYG3h2DrFKj4mYCaC0rMJmBg=;
        b=j+mLjSx0rnWD1+1PDSMjfW4Gce5iOsoKfkC5h0+6ZkS/ch9IG2MNJPM79frVefCs2c9ndm
        WCnXX7BzrrepSStt5IFgVFhForuLw7bf9le/gLkjWTKZC6My41k16j74CSi0W7xfrbc41m
        UEQbvhlTjAKnlzHbV0jXrL0gJwtQN7s=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2053.outbound.protection.outlook.com [104.47.2.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-18-S7sWXz5_NWKxm8T9hVMLog-1; Tue, 20 Apr 2021 18:41:04 +0200
X-MC-Unique: S7sWXz5_NWKxm8T9hVMLog-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nnJ/9lT+g34q3kt17nJA/cc4oIO+lygb9pOIhEyXsTUesiGS3aO59iYeaDmiQraFPsYxwPduN/9l1cHHym039hhpldyCb6XZRJUl8B0C9ZCmyeFqxPzZQf6r/QgShzRutfMHxJt0sQm+IFAieWM04kmDNHBcX8s1OyNZk1SqPE4UHwh3MiHAg/5SAYIqMCoIJDXpVk/ZaS5yHPlCnRcM60UNGGwtH5OI2gvs2H6QolwW1M828BDCes1yXJP0ubHSKwjx1Bw4CJF7N8Uk9hqkmTVBOY8aVjjd6qoXW82z/M3eiDbkw1YNvCigrCMqiT/lRQE55l7E7zsy8pWR7Qu5jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=idv6FNbrCMjECznCgezzYG3h2DrFKj4mYCaC0rMJmBg=;
 b=hp7qGi6jxcV8IUPmZzLnD+UiSPVCSMh2UKX/6PDK098J/hAwO8ra19N0okKAXP8Pl+hMXcOgYoAM1Rp41WqT4lfxkXOTTffcI4GqoJgGc921YEEIGfpnzGqGIOFeCl8WIUU5w6ylnepVmpnNC8UZQkAKdHIZDqGyuF0HoXv/o3BZJ9zrRsrA9t98+C9If0FgrQO/vL5Bi9TOJOiPvvy61fVy41LMDLnbGRaDU10nOvWwfaQyOqAPcZFk91d4N4o7puT2hX+wkY1yk9ri885GoUMPISBgiaZZZYnUDYINZBwee/nwP0ycqv2Y/rvG13+xoEle/mhSdIxX/vn0iF9H+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: alexanderkoch.net; dkim=none (message not signed)
 header.d=none;alexanderkoch.net; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB5550.eurprd04.prod.outlook.com (2603:10a6:803:cf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Tue, 20 Apr
 2021 16:41:02 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 16:41:02 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Alexander Koch <mail@alexanderkoch.net>, linux-cifs@vger.kernel.org
Subject: Re: cifs.upcall broken with cifs-utils 6.13
In-Reply-To: <a01d5d22-5990-c00d-bc2a-582d2585ea69@alexanderkoch.net>
References: <a01d5d22-5990-c00d-bc2a-582d2585ea69@alexanderkoch.net>
Date:   Tue, 20 Apr 2021 18:41:00 +0200
Message-ID: <87h7k0zz6r.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:707:6a97:e48b:68cf:c6e5:34de]
X-ClientProxiedBy: ZR0P278CA0155.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::16) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:707:6a97:e48b:68cf:c6e5:34de) by ZR0P278CA0155.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:41::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 16:41:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4c690aa-1e1e-4c7b-37f0-08d9041b15cb
X-MS-TrafficTypeDiagnostic: VI1PR04MB5550:
X-Microsoft-Antispam-PRVS: <VI1PR04MB55503B6401C7F4A6F9F55CF7A8489@VI1PR04MB5550.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NgYtdWq9ESWKLWkIfdXu58yMh48egAi5po+ESshRRgBrmS7gq4S2U4GylAeXqJAjFvAOFyIVrV21zxAJ80zcBieTZpMsrk8gW8Cplb9Vyj4v6ZNqcn/hrjV4pI9cbWJsGMcaUYWUSuRBRmoymt+QCoAqYZkwbtr+x1CvHXzbRJ3YX2Y8NoZh6D44jit9YMs5uKy/e4VnOr6vHlLP4qcG4BHx0V5WnFBMOBx4EIoKf8zxH/xZy5kg01jUpbgJ/rwmGvpOiQyKPhA1CWkBEkQc6g7mCRhE3uC/vclPMdQ6BAU7iqAhwQj+dI5CAOc3aXlr4nMtMTIu4CUBJJVgclDM7ATXdxeS4fJdsHG4Q5FfNWDhWGW/N44nL7WKvkuvUtFTwQqZQVWMV2J/U9W03na14LiixdgkS4Tw77nE5Llcyy/Aos6GF+PJO0EJ9cBgkQRc/BFBe+f1TjipQ4EmVpMjA+2DoVMPYFYiW6DTK0/zfRDf0rbWDszYP8UE6HpD/O5kZbnrueYAksUiuKWFqatOr5eHHrRhuyiumRVKzrmPEg544vpmc97F1HcqtwqFrdDkMYDlp4HKwO5KRBT5bQD0Vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(376002)(366004)(39860400002)(316002)(66574015)(2906002)(2616005)(52116002)(8936002)(8676002)(478600001)(16526019)(186003)(6496006)(6486002)(38100700002)(66476007)(86362001)(66946007)(66556008)(36756003)(4744005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L0lJTTk0U0VCeUJLbnYvOVY2M3RvQllzMzZNM3VKejBDZ0taUGhaYUljVXVL?=
 =?utf-8?B?Yk5BNEJEclQwUDFESzVaNGpCYnRTZ0NaMHo0MXg5d3Q5WHNtNFRtTXJQMU52?=
 =?utf-8?B?bjZ6T1BBQ0hPUkdpUTFFV01FR1YwbmR6S0p4dkVGc0JQUEZOODFOUWN3akZO?=
 =?utf-8?B?TkRQVGtGM2hIcjlkeGlZMUFSUEtNdXlCS0tLSkRSYmJwY28wZ0JsSnp3dmpD?=
 =?utf-8?B?YUVDYzJFSVhKM1NGdDNZWWhIODdTTjZneVU4bFZONW9saFI1UUF0dmQ4UlV4?=
 =?utf-8?B?VW44K0M4eGVsaE9JZmNtK1ZzOE5kdjdkNDNTOW05MHV5MDQ2R2NBQXJ5MGth?=
 =?utf-8?B?cHNDc0tJeFdVQ3NLbHBZUzIwMml6bEk1LzBON1VtWXIydXJ4cnJzWUVMTWlp?=
 =?utf-8?B?dFBtWVQ5RGNxaURRSkZxTS9pNGNwWlNyM04rV2pxVmFucDB3ZnlFTTJpaXRv?=
 =?utf-8?B?TzJzblN4RFJ6cmMvdk1BaWEwNXFHRkxOSDl5U08yTTdoU2NQV2J5VjB1RGdi?=
 =?utf-8?B?TS9YTEZodDVZS001SXVFUUFjRmxZQUhjY2NTT2ZkMGF1ZjdQT01acnlUbE5N?=
 =?utf-8?B?UWJhdy9UVG1pb2NmRXoyamV6dHM3S2Q3aVN6bGFsQlBEVXYxT2xQV2cranAr?=
 =?utf-8?B?M1B1cCtYdEVEdmF5S1I1MWZLaTF4T2RsUkNRblgrOXI1ZERlcS9hK3JFVDFC?=
 =?utf-8?B?MVlzTjVpRzhMeWJpQXNPSE4xTk4rYWt2bHg2bFNuZ3M1b3N3am9MYzRhWVJG?=
 =?utf-8?B?blViSkFrUHhwbnB3eWU1MGo4a1ViYlBGdjJsNzBtWVdwOUNVRnhWcXBEdDRP?=
 =?utf-8?B?VU54V3MveE9KeTJsSHgraDRPUTZvTFc0T1ZRaVMzbzA2dm1ML1RqOEszZzA1?=
 =?utf-8?B?b2huUnRKTDc4ZXBBOERubVBDTGliNDZIeCtmK2pza0dnVyttRDhCSGlDSndE?=
 =?utf-8?B?bEFsU3lrTEdNam9ub0t0bEI3Yk1JOGo3RndNY0xXR3lyM2pjR0RhYVNidmho?=
 =?utf-8?B?UFNaYTRob2ZIbGpDTThqZ2ZvMit4ODhzaVpkT3Y3azViRFVsZkFGN0g3RGNP?=
 =?utf-8?B?aGRlb0MzeWNCUXRiV3paYjhlZ0VPSW9kcXhWMjBCVjVLTEYzRzRtWnlwMjRp?=
 =?utf-8?B?b05pT2lld1FNSndjMXp2djNGTld4dy9tNVhBdU8vQU9mMFpqTm1kaWxJM2Ev?=
 =?utf-8?B?dnZjNkFnUFNBLzdZams1QUlPSmJ1OTI3RlRIMWxYVE1Bd1UxK2U1TnZpb3dT?=
 =?utf-8?B?alB2eVpNU0xUME1UVVdoTnhxd05QcVF0Y2Z6RmNhVVplSGptUEhCZEFWZWpq?=
 =?utf-8?B?SHNRY2VhSVdPQW5iSkltV01WZGFEajFYR3VTU3d3UkV6bk81VGdmTzJQTTN0?=
 =?utf-8?B?Tk1RNk1DdHR5U3FBOTBlZzg3UWhzejROdCtKMytuREs4MGdXZm9RVHo5c1oz?=
 =?utf-8?B?RXM5cWZwZEdUL3h0dnVOR24wRU9ISy8ydldpNndEUGNmOHF5YTgzUU4xYXdh?=
 =?utf-8?B?SnBjQzIwVG0xSlZOL2VrZXZHNnBSSkFSWEtCdDZ4MkNKVkJocitvYVRmTDdh?=
 =?utf-8?B?dVU3TnhQN0JzV2N0RUJaTnIvNUFDeWpjUU14b1pLZ0Jwcm5HMzN6cDkrajJ2?=
 =?utf-8?B?Q202ZFlid2VVWVpPcTVtdHRyMGhQV3krRURwcHdjWWVKOEJCV3lTOU1xa2dJ?=
 =?utf-8?B?SjJDb1BUUm9FR0Vtdm9WdUlxMVAvYnBBV3hxZ2x3TGlabU56NmtlQU9aU2dx?=
 =?utf-8?B?TVZCTXNEZUZic1F4NkpyTW14OUxnemNNWG91T1pac290dG1LOWRHTVJiQ21V?=
 =?utf-8?B?OWpnNDZxN2xGdnFMNmVGa3RnbXA1TER2eVVpWlpTb2t0K1N2bys3aDRZU05Z?=
 =?utf-8?Q?6Y4VeKCG2V+Ab?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4c690aa-1e1e-4c7b-37f0-08d9041b15cb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 16:41:02.7390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7AiL48ctp/ax0W2JdjJRmaDugRB/IBuTxfCm7oLL8UL4HUqoL/vcujznfbRBt+3Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5550
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Alexander,

Alexander Koch <mail@alexanderkoch.net> writes:
> The recent release of cifs-utils 6.13, more precisely e461afd8cf (which,=
=20
> to my understanding, is a fix for CVE-2021-20208) makes attempts of=20
> mounting CIFS shares with krb5 fail for me:
>
> Can anyone tell me if this is a packaging/configuration issue (Arch in=20
> my case) or a bug?

It's unfortunately a regression in the CVE fix. We are trying to come up
with a proper fix.

In the meantime, as a workaround:

* you can build cifs-utils --with-libcap=3Dyes (libcap instead of libcapng)=
. This will skip
  capability dropping in cifs.upcall.c.
* Alternatively you can comment out the call to trim_capabilities() in
  cifs.upcall.c.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

