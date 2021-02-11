Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE277C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Feb 2021 14:29:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9638E64E23
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Feb 2021 14:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhBKO26 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Feb 2021 09:28:58 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:46536 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232216AbhBKOZ6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 11 Feb 2021 09:25:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1613053487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cD19E0Ce9brqhM0A9X0LPas98A+d9PM7FkZ4lkKcP5k=;
        b=CYnr3p6mdkjyUcDW/R9Vj1MwvUlRl1CuU8b1jH+efgtZM3Fex+WKTtMb0owba0ly/Q4Mwo
        k72yMQcdDXtP+9DNqRy4/bFuBMIPdMRDIdZGnahImhDDVL2JwvEtX64B/SyoiKPFD2ra5p
        hh1j5boqFMfH9XkHhM6KfRPmV0YhgeM=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2052.outbound.protection.outlook.com [104.47.6.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-33-fKFzTZnOPkK5kOZpw-8bNg-1; Thu, 11 Feb 2021 15:24:45 +0100
X-MC-Unique: fKFzTZnOPkK5kOZpw-8bNg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxU1M8bWx3lsIwT2/YFYprXplznG10i7d14j/4cuDwsZwhg12v0OIzaIlTfuzN0bqxM5whfUXbrKPXfhJUNCkFAV0VD2V55x85CTH3yOs7SvF5pfc8lgXcCTLSAdM86tjD2ruv6/TrJQypItDGTiIKHG74qSC4RB9tQOk0QuW9hmx4whEz0ly2OI5Vt3qgXSKA/k4ZmxLj+GWkEk8h/8ozG/yCyiL0qAHVqOjwkHG1nxdtOkXFUrbPBZB6np7yXTkClKacSJ0d4pxdR8znpa0EJts69+iIaXBdHA1Of+t8Rcerr4nFxzpaG50MJS4ivOVo4xuKqtdCuH1xfYejXlMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cD19E0Ce9brqhM0A9X0LPas98A+d9PM7FkZ4lkKcP5k=;
 b=D8nEuaBErB19WX2h6GhoAcL3rbRC/BbUx11xXBtGKLs8ft7GVS/b6aK+IGQuHMCMjPP7K0Q2KEF2qKxOg3kMStYUZMVPGg0iKhhs0cWtGPQduN/UQ6MY+bHP2YSO0c64zGAA7tSWqkzqPs8J/U3QTng96DeUwX3DJFRFgmEXbbWwe8L4vGiHexzoDfzSwGVLdw5FqQXlqmY3IjIHFv5PBSmrdx5bvoHXf4bbiJCmBxQrexGUGR+Cn+U8lnW1Zp1MI07BZIga7YgxndHkXsoRRLB3YGrZhUDPJaTyu1aO8VKVDe9gNX0GdULnnCDCqI6MhzdoHw+KtYiOGc9IgOZqMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB4254.eurprd04.prod.outlook.com (2603:10a6:803:4c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17; Thu, 11 Feb
 2021 14:24:43 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3805.022; Thu, 11 Feb 2021
 14:24:43 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH 4/4] cifs: Reformat DebugData and index connections by
 conn_id.
In-Reply-To: <CANT5p=qJjeVk1HDhvaiAQSYH3mj-rNBNA-j2TAUnoqQVTOQ_Ww@mail.gmail.com>
References: <CANT5p=o9Tw9E+o3PWytsNh5eDKxswJ+YPLZLWac7QwR_u-UJaw@mail.gmail.com>
 <87h7msnnme.fsf@suse.com>
 <CANT5p=qGTC4E4Rf_-t9xXOo4yf3W=xtk97J1jg-WRLhwf0juBA@mail.gmail.com>
 <87a6sjopsc.fsf@suse.com>
 <CANT5p=qQJwvF11MJpiuV7S1GpH9=HZ-g=hmfOV-a07N9xkYqnA@mail.gmail.com>
 <CAH2r5mv0TzWpYi38HtuVG2gtYvW60-RDOri3a1FUUtprn19Dzw@mail.gmail.com>
 <87lfbyn647.fsf@suse.com>
 <CANT5p=qJjeVk1HDhvaiAQSYH3mj-rNBNA-j2TAUnoqQVTOQ_Ww@mail.gmail.com>
Date:   Thu, 11 Feb 2021 15:24:42 +0100
Message-ID: <875z2yn0lx.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:9b68:49e4:71c1:b7ca:b595]
X-ClientProxiedBy: ZR0P278CA0035.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::22) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9b68:49e4:71c1:b7ca:b595) by ZR0P278CA0035.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Thu, 11 Feb 2021 14:24:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5de6782-b85c-4537-6618-08d8ce98c656
X-MS-TrafficTypeDiagnostic: VI1PR04MB4254:
X-Microsoft-Antispam-PRVS: <VI1PR04MB425497A13E3B2884E3D9E0ACA88C9@VI1PR04MB4254.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PnP+3Tuu4kTZzx+V3a2Ureiu8YDaV9F2YIvVOnEkyP+AplvsVdHAxrj6wgncQKjppcwb6ed6mQP3tac+pPaRAeU4OZRNMvQE3+cXnvTFFaQCRWUagYyq/DIjo0wV7wEw+A/iWM/SBmaLkXI4MVlNOWiQmriJ9X9DeS1yL7BEHZAM5jMiDXMiziXMQGqS8mRO77Rrqhi1/56gHIGar5oo1AQU3SebDsMsZkrvBPcz8wmw71764u1vpsvns8ygcJMDyahjpsH0zJ1gtlP21dVlCDaRBYx0l6QbWuFxupORdjrP1cZWaIPQkktnu8zFN+/fHKva3gMFDfPmn1P5AUgU9xgPaaQ7MLmT95m2HbXHrgJ95qlpgG877rckBLjaDYCkGQArn5UO/2GvaUuaTfqXhwpgWL3EqqyYU2II8a6khj0WyhKDjpeL73wpuOx5/L1TApVi4CQOfMIlWi+df3MyNjvqRaVxQUMPK9CzeyZqo5pWkGRV+PA17iUTHPSV8X48j2tgV6l4dKLymC4PMKsPhA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(136003)(376002)(366004)(4326008)(6916009)(36756003)(86362001)(8936002)(54906003)(66556008)(83380400001)(66476007)(66946007)(478600001)(8676002)(52116002)(6496006)(2616005)(5660300002)(16526019)(316002)(2906002)(186003)(4744005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bkhMUk51S1hrWnFVVmRrMnZxN3oyZzU5UEJRMS8rU3FwVGc5aEFqYm9Ka3E0?=
 =?utf-8?B?WXNpZFFOR0xpU1dCWWQyQ2VxSU1aMTlzMHJtMWZkZ2VXSW9tVkxzaUJJcUta?=
 =?utf-8?B?aldRelQ3SWp2dnBVNnRPQ0IvNk5KSVF1N0NyVDY5cjJaTWJ0RWRrNDB0VHFv?=
 =?utf-8?B?UEVyd0VNT2U4Z0J6allOaG5UZ3oxbVljVFJraDU3NjNSUFVwWVZjQlM2TFBi?=
 =?utf-8?B?WkcwK25BWEJicXMvRTdFaTIvRFg1UTBrRjFqcTZaK1dGTE9iOVR2NkhjOHZC?=
 =?utf-8?B?LzB0WjlrZkx3cVpyVnZYemNvTjBEQnFTU3FVdkZEQmxCQytBV05OUDloM3I0?=
 =?utf-8?B?QzhRMTFSSlhncS9oYkdrVDNDWWsrcmpYV0Q3cG1zaWQxSkN2dENqUUdvdm5W?=
 =?utf-8?B?Q3pPemRIS2FoKy9mbUkyM1FtRDU5TGNXUzF6T1JnRFZPUUJ1dTVuaDd0TkNM?=
 =?utf-8?B?VnlPNjhCQ2VtV0N5em8vT29QYml5ZHRYdEM1YXNublFheUNuVkd1R1ZFRXdj?=
 =?utf-8?B?SG45V3E0UDlkNDl5K0J1VVlTcm1QUzAzYzVTczJBblE1alhISklJcTQ3N3lP?=
 =?utf-8?B?T2cxaVk5RmhSZ3NmVDJHSm1kZWpyRlFLU04ycDBMUTJ5RFhYL3A4NXFNbWt0?=
 =?utf-8?B?bjFDemV1eVUwQlVoRlVWNGF0NUYvUE1pUy96MGlEY2h1aTg3NE9kKzJla05L?=
 =?utf-8?B?WjQ5QzZhbVF0bW5wWkkyd3c1R3k4L0ZXckFObk50aC9KLzF5YnhNT0JXRFNz?=
 =?utf-8?B?MU9VRk9pNytRc0NhbWJMaXRYRnpWOXFJbTRCenJDMW42cGk4VWZpeVhoOURk?=
 =?utf-8?B?bmMxajg4TnJOVVFzMGNYNnR3YlJWcUt2MWhMdVh3bFdpNjNMblBMbFNrdGgw?=
 =?utf-8?B?STNuemtnYmdOM1NySzZ0RU5ncVpNRzdnMHAvaUtycU9jRmFFeDFhQUxZc0hy?=
 =?utf-8?B?d3lxVjJpbm93dXhsOFNqWDloaDJweGpqSWFyWm1lUis3RHl0YUdEbEhrVysx?=
 =?utf-8?B?NjlaR3hzZEN5bEd5MW00Q1BhcTA4RjM4cVpiNEptQ1lwTElwQTE0QXppTWhl?=
 =?utf-8?B?cExrUWZNUjQ2RkJzbitGQmJONEtKYUgzTXNqek5ueEtPNk1ibk40byt5YXRx?=
 =?utf-8?B?ZVA2ekEyZnRwMHJiQ3BjRFg5ekw4dUN6TUpPYU54VkZDZDE4VHMzQy9pNXpT?=
 =?utf-8?B?b2p0ZFl4M2NpT2gyMWVTSmdwNU8zTXhxQ0E2ZDlpR2kxVEQxakc4clBVRXNn?=
 =?utf-8?B?OXVBZ0l6N2FGOXVKRGdESG9hL0N6UVFmMnNLWTF4SzEwU3FjVXUvdG5kTXhR?=
 =?utf-8?B?YVJ2dEoxaFRDU0hqc3FPazlJSWZlOWwxL2FPcjZPNDdWbTFRYTVNMkdmSmtl?=
 =?utf-8?B?aVNET2Y5STQrTHd1WDdEL3VyWmt6V1M0WXRBbnFIbkVDeEF3YXBlaXNHaGdD?=
 =?utf-8?B?ZHFIK0pMYmtmL003NWxUWVpxQ2RjSGpNQlRabnU2SENadGQ3UmhqWFgrL3lS?=
 =?utf-8?B?M2pNZzlaZ2dFV1pHZ1N3dERDaUJEWWZhNXZ4MWU2UE9CRTFkMVZLRHpFbENW?=
 =?utf-8?B?TE1PeVdsU1k2NTl3bS9id0NFenY4OG9rVEZ5cjFRVlF1NUFqNGZ0aVV4MitR?=
 =?utf-8?B?QTNkUVBkY3l3UWpaeVFPTHlQM3c2dEJNdGdWQWlsNjVENWw3bDlKQndUVy9T?=
 =?utf-8?B?YjZzVGpOQVV2UUtFV0hVNTlFUlo0Ni9QSUtFWnZidm1UWWRuKzRjRktHMVF4?=
 =?utf-8?B?QjBMQjg4OWFtaUFoV3BhM2ZJWEYycFFGMG5hVE4vZlFQbXpLa21iYzluUklz?=
 =?utf-8?B?L2NQNDVJaEkrTU9pbktkdk90MXhlTXg3clVNWkxiQ0ZvNDI2a2dxUTdpNVQw?=
 =?utf-8?Q?DZAKrwBeq4g7H?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5de6782-b85c-4537-6618-08d8ce98c656
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2021 14:24:43.2516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ZkEUZYme6Po3b+Qv/EBNL0TsATkipjWbco3SQbZ0gC0tdLXdjK9nbhB31dPpq7Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4254
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:
> I noticed that the output looks rather odd when used with multichannel.
> Attaching a revised patch with the changes.
>
> Also attached a sample of new output.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

