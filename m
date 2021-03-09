Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78E37C433E6
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 10:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 473D06518F
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 10:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbhCIKFH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Mar 2021 05:05:07 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:53139 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229691AbhCIKEq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Mar 2021 05:04:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1615284284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N5XXNG5rM2KtjCjdksJEHF7DN6xMn8sSmAip3tA3O8Q=;
        b=j/jUdITFSkzBJskqkJtdJ86ISSV2+EfuXKFdkohR08i2+s97VyuqeIXQjj+5kHg5qDkDIB
        v7ACx+ksbzLcWkg/jq/PiAOcp692aWZMtkkGRFVfKzPach8VEjwxqoJv4fnO7KmXbB1Yu7
        8kzZgbbFE+aLId1MSQBkHLqhYJF4v8Y=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2176.outbound.protection.outlook.com [104.47.17.176])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-14-063D8ph1NPekS8qC6U_RZQ-1; Tue, 09 Mar 2021 11:04:43 +0100
X-MC-Unique: 063D8ph1NPekS8qC6U_RZQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UV+vpY2j/pBKeKJt0F/qm1H0XY6c/AZFh4q5gp9T6csYJASjYzdP3SX5Imi/OWwubvyGjWu9bmygm+ItorjtJ/w/C+zhH7jAEP/UX1XqFvnKiqvfmLrg2Nw5VEjCC2J39sv9Ph8YWaL2XcnrHcHB+K87GN8kND/HtsqBx4lKfP2zO3MuMI325l68dp97wZg8Mgw0QapCwm+Tfh9kl6a5M2BMYt3e99HMAX03uX3qPe54XupSFtawLYivVP9Z99Ld19+Gh6d2YNHuT1mxDUkCvUPX2KPYDuFLNtY8nlgNpRPzM04cBa0OjRtulU2G+mLSAPfOZSQaTi7yMWjnQ/KB/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N5XXNG5rM2KtjCjdksJEHF7DN6xMn8sSmAip3tA3O8Q=;
 b=MoqVQ20/QjY5MFJMv7PMFZj35mPHotmOgNK8C/HleKEBl3LuxBYkytnDsJIwbV13ZWY+J3ozZqhnHauylEnPsgH9wrvreBPmq/cHgN0I2i8iR2B/0I/FvgWNQk+N7LI9KIU8eavuU2AQKSYHwEjLPiuAeKIGAcWc9ig/kQid0Z79XPxGYfnqXdY/VlQemXn1cBQH6PUqfARb/fyb2vx6x0Mutlxuec76uCjChqv8+D2Cdx3RPlWMKn9vI0vG/1nRtZ7Mw+nRKzsBQPOfv59ReFFp+vSM1hRkRjZxksIVc0svFGBBqJttAIpS16xrnc3VJ7WF4P5taaENIb/dxLpLoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VE1PR04MB7278.eurprd04.prod.outlook.com (2603:10a6:800:1b1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Tue, 9 Mar
 2021 10:04:42 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3890.037; Tue, 9 Mar 2021
 10:04:42 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steve French <sfrench@samba.org>, kernel@axis.com,
        Pavel Shilovsky <pshilov@microsoft.com>
Subject: Re: [PATCH] CIFS: Prevent error log on spurious oplock break
In-Reply-To: <CAN05THQtb5RY2ye7nkyWBjrXS+=usZCxUM7jBQG+JEpg_TQQTA@mail.gmail.com>
References: <20210305094107.13743-1-vincent.whitchurch@axis.com>
 <CANT5p=rB2=DvjtpmVy803emWpuzsy-C2+d4wqQ5g_9fJ8+a5Cw@mail.gmail.com>
 <CAN05THQtb5RY2ye7nkyWBjrXS+=usZCxUM7jBQG+JEpg_TQQTA@mail.gmail.com>
Date:   Tue, 09 Mar 2021 11:04:41 +0100
Message-ID: <87h7lkve12.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:70b:4a04:48fe:21ee:1b19:31ad]
X-ClientProxiedBy: ZR0P278CA0123.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::20) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70b:4a04:48fe:21ee:1b19:31ad) by ZR0P278CA0123.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 10:04:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53a5860f-da46-4590-bb79-08d8e2e2c21e
X-MS-TrafficTypeDiagnostic: VE1PR04MB7278:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7278750F6E0CACF00D13828EA8929@VE1PR04MB7278.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sNiLJFdYWslk+Zzq2Agr2BmYw4iZTCcK5sgUFr5n3gk55tdFaKRbB1I/0SL8yyyNUwpaMpPLncVa+3Dr1QGLn9/SSlx8Koj7Ltoermk7id8LsOjuqRz347arJkY9f+1qfcpqWJcOhdrEb2SunkDbCuJspQRoy2hZP/ewADyvsaPxGntPegqMw4lzA7Zgw0A+ap9R0eU506GU+NQXx5oTvO7VL6UMqYwLnZ5nw63QbYdOz6JD/7ckkt9cO4fnG91nk6U8NuDati1GiSgLOU5J6AUC09myJIcYBAPh6pDsvZIdKXoTaPOC1J6/Ceqhw6uBV2bIVfnxM/qqDPPhMSm0naWew72i+WrzLw/5bEffPRCdnf8lGtakHmPvyXBGAUunro3axP3sTwPw0JpS/e7dlm6Jw3lfCeAwqggIJVYM1aUvFGr0WviSdqSSg4tNQsMU52/By+e/xUaqpolIl6ZUdoFFgApUTy2jLv1/LfkJBGXybkMN1b0sXuxWfMDU7PJ7Sd5yoiyCMWLbGeJC/eZqpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(136003)(366004)(376002)(52116002)(186003)(83380400001)(2616005)(478600001)(66946007)(6496006)(2906002)(86362001)(4744005)(66574015)(316002)(5660300002)(6486002)(8676002)(4326008)(110136005)(54906003)(16526019)(8936002)(36756003)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WXVpV0VpcXY5aktBRlBpbjg0eE5FVlVSbnlBUnVYL1l0R09MYWFjWkFRbjkz?=
 =?utf-8?B?TEcvSnJpOGF6bElTd3J3eUY2elJnbzU3aVdSNldRRkxLSEdNN0RsQ0x0QytP?=
 =?utf-8?B?VVZIK3pWMUZDc2wzcXhtcVQ0U01nMk1DeTNGdnN2cDY3V3VzRVRlWHF6ck01?=
 =?utf-8?B?RDdtTndkbFpZcEtyZHp2TUU2Rmx0dUY2eDRJRW1PZHhsS01ZQVhaeG1teGVh?=
 =?utf-8?B?RzlVUDBscGNxUzhuQ1NnVUNTYWNHWVpsL0UwUXRJcms1NWUzbGxydksrOU5n?=
 =?utf-8?B?WnRXZDkrSDNTc0ZTeEltSkFwMWJha1FkN1BRTFJ6eTUvSHFiUlgwUVc1Z1BV?=
 =?utf-8?B?amwyMXQvOFJYWThRcVMzK2R3eG9obktkVzNGaE8wQXZtSW80UVFCNkN4OERD?=
 =?utf-8?B?WnhXc25QV2ZMd3ljc2xNa0VFM1prUys2SVFVSGgrdUhRVFdWdjVra2Q5MmRa?=
 =?utf-8?B?MjFlcWozbG1xd3Q4MWxiMmdhQXdqSk92alRvVzFtZ2RMWWx2UHl4L3E1TWkr?=
 =?utf-8?B?VThYRnE5NksxTzU3dnBMcjFlTUhQRGdjSFFrNFc3cTZ5dTd6eTRDUjUydW52?=
 =?utf-8?B?bTdjdjEyYWRyaXUxWkZCRjlLUlBmaVdRck9CTkovcFh6dkIzbklLZWxpSzRZ?=
 =?utf-8?B?amJKOWRuQVRSL3RxbFZMTGEwQ3Nsc3NZT2xKQm5nTXdZdUxkTytUV09sa3BT?=
 =?utf-8?B?aXYvQjdFREt4dHhmS0cyTGxkMm1GTjNoNU5qSkJ4NGFRVGdGR1NOZ29rVnpD?=
 =?utf-8?B?YjFoYUJnMllvS3ZoWTJLRGxOZUNCNE0vMCtDM0NOa3FtUnFkQ0VnRHZoSHVX?=
 =?utf-8?B?SUUveE9nMTYreFkwQzM2U1c1REdjcVdzZ1Y4YUxjcThBdG5BYllsdkdia1No?=
 =?utf-8?B?dWJpRmhRUHVhc3lid1IxRXBrUldzaXZXTTdrOXBiemZvTWR0aC84MGl5Z3BK?=
 =?utf-8?B?b3FHR25ZWXFMRVErbm9vckc2QkpEYzlZWnllZWtWeEpqSEF4Q1c3VHRTY29C?=
 =?utf-8?B?NWY0YjFMbk1aRGFRbkFLc1dHNDB4WXZtek42UzdKbEhMUnZiZXdiQTRxSTVX?=
 =?utf-8?B?a1NucTB3Qjc2ZGtTUVZ5T3pONExPT1hyV2pmNlVZd3ZjUTAzVnBEaXBuenI2?=
 =?utf-8?B?dlp4MFFQb0RFQXh5cTFkRVZncEpQcy9LZmFYVHJsK0JnRHZoUnFyQWdhU0pF?=
 =?utf-8?B?UzdSSmZyQ0JOdFE4ZmRHSTN1SnkwYktPUWhtMEovd05mNWVlSDBGVFpZMFFj?=
 =?utf-8?B?V2crQi9KeVZTdlM3aWhoMUJqOFdKUXF0TGJuR1ZzSEVQWXh4UW9YaFV1dDhj?=
 =?utf-8?B?dmRUV3pjWEtuTnp6UnlaK0xncVVKL3FCSjdOR3dPZFV4SG5ISmo0NjVPenQ1?=
 =?utf-8?B?LzBxMFBJSTBqTThqYVhWUlA4UDcrRUU3N3M2VHcyNUk1Vk00bjZBOTNKanEx?=
 =?utf-8?B?dU1xczR2MXBSVzJOK2FnRmFIcW1zZDkwT29ORGdLNGdSK3FtMXpJZXY0V1Jy?=
 =?utf-8?B?ZnI0M1RGbTA3L29HeUJndW1iZEhmOFpIM3lZTzYxYUh1aDhnUnZFYXBDSml0?=
 =?utf-8?B?MUJuUURqYW9SeUE4UXQ3RjQwRE9KdmE3OW1SN0orS2VOQUttaWtBeTNJMTJx?=
 =?utf-8?B?NVdTQWNKUU9ZRy9YTVpqVTU5VXVnell4Vk4yNUppaFVENTBWbDB4TVUvaWQ5?=
 =?utf-8?B?aDMxdXRGU244WUtjKzVaZDdRUG5nVnVkSTlzbFFmZlBlMCtJRW85a1FnU2Nl?=
 =?utf-8?B?NWgya1ppWFFWNlUxZDN2anBUSjRZQXNTV09rQkE3ZTBMcXFiZ0p0SWpmUGM5?=
 =?utf-8?B?WVl5TVhvUUVNcDZpZlREcHJiNUxpbDkvdWV3RnE1cXQvNUtIMVUvaUd5bDZY?=
 =?utf-8?Q?enI/WAXR9G/fo?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a5860f-da46-4590-bb79-08d8e2e2c21e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 10:04:42.2244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QipnxOGvKm9wWnUbCY+DYB4sRdj5ocQey8yOoNmMSJg/6P4qFULfMV88/VHMcASp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7278
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

ronnie sahlberg <ronniesahlberg@gmail.com> writes:
> Some thoughts I and Stever brainstormed about could be to change the code=
 in the
> demiltiplex thread where we currently dump the packets that were "invalid=
"
> to maybe:
> *  log once as VFS and then log any future ones as FYI
> * log once as VFS and then only make the others available via dynamic
> trace points
> * rate limit it so we only log it once every n minutes?  (this is overkil=
l?)

My thoughts: these dumps have been very useful for us in the past, and
at least for SMB2, they indicate real bugs I think. I have a little
script to parse and decode them. So I'm in favor of keeping them in
SMB2+. For SMB1 I'm OK making them dynamicaly switch to FYI.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

