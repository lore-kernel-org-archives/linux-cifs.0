Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3058CC4361B
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 10:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C276122AB0
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 10:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgLNK3J (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Dec 2020 05:29:09 -0500
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:59724 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725798AbgLNK3J (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 14 Dec 2020 05:29:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1607941680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UB6la+y9HouvY7y8Mq708WE2yYT3W+L8kJY7+2l6Ne0=;
        b=cp1bWxKuGS12drFYweTbG2CH8C10Q8loz8+Nj+LgjQFibyox71XlbU02ho4gh6mklyZzaa
        TOzZwY1FJKLj4GOX/hcK/AEZ2ntkZ0W3v/A+r4KrbmIhB2w0OAKSl+NLIv8WQsdkgu4pIA
        i05mZhrviAmel51gC1VW1QLFrVr2ezg=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2059.outbound.protection.outlook.com [104.47.1.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-33-n5eydkENPGqzGnCkk1TawQ-1; Mon, 14 Dec 2020 11:27:59 +0100
X-MC-Unique: n5eydkENPGqzGnCkk1TawQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F5luvfgS751g3PqUE2hTTFIpGoTmhnCUwCfRae0AiKiNAhZwh531lbRNCVC6cNXXsRDW701XwKDgf7mttuEAYkTOuEoCHbDSLKvNQRhxDk17rz3U2Hb/cJeOdv7fcwzqnymVfNps/1AYNIGakAy/Vm6wk57Hskh8trQKt/4ox7C6iP86GZi+vPD+07Ka/ebZV9gvkTl/0m7yjUXvonOx9yXIoJJRrlAfAdQK0tzS1Oecq3FZ23PfjacfKd3hMjESLcxGRWIolzvQaGCpfT3yaMgVsQkS8rmy2SYb3y4AGuEej5SIk5eDeGFG6ILfgWjdxcJi6ZqrnNLjnOYz46hJtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UB6la+y9HouvY7y8Mq708WE2yYT3W+L8kJY7+2l6Ne0=;
 b=jmdtqO/ZcHm/WlYxqTp6GoDW0Ba8NvAEbjyEeGuSIH0McvVIBprUwnNLWHWbdJdNrOB86N0tKU3DHcp1nyV8AshCzdpThHrl79oCRLsg2yDw+8r2zUh8g1W0TddyDp0oLxi32zGeVWtA6xyHhbZucErujr/ZywlQsEdApU6Q3Yi9ZknE2SRkj02JKQUHSNgf79tRS62RSpLUCzp4EHbgyVfT1gesQV3MRzFaSO9zpJD1bnOsee7iFtONYhXK/cEwrQU4qq+iAL3EL74HaZssk1NHAmtBsF5wGFS7XJjRSz3uIWXFh02XN1IYawtWgnBHk5uGIwXl/uTLlqoKzAJnKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB6224.eurprd04.prod.outlook.com (2603:10a6:803:100::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Mon, 14 Dec
 2020 10:27:58 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::4dad:a2d3:5076:54f0]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::4dad:a2d3:5076:54f0%5]) with mapi id 15.20.3654.024; Mon, 14 Dec 2020
 10:27:58 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH][CIFS] minor updates to Kconfig
In-Reply-To: <CAH2r5mvT6X-R-E+vFVUuGXYzh4BtWCefFsvhJK5EVEZhQt4YWQ@mail.gmail.com>
References: <CAH2r5mvT6X-R-E+vFVUuGXYzh4BtWCefFsvhJK5EVEZhQt4YWQ@mail.gmail.com>
Date:   Mon, 14 Dec 2020 11:27:55 +0100
Message-ID: <87a6ugd6ms.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:9f63:f5bd:7a8d:a064:3118]
X-ClientProxiedBy: ZR0P278CA0030.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::17) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9f63:f5bd:7a8d:a064:3118) by ZR0P278CA0030.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 10:27:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6243142a-1c1f-490e-8bfb-08d8a01aed7c
X-MS-TrafficTypeDiagnostic: VI1PR04MB6224:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6224FCB5014D261419CE9268A8C70@VI1PR04MB6224.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ST3rpjWLGM69yQSkQ3zxqnlNorwVzL2/oF9010eDVbEtVwNto7BqVFIpHtBK6ddpgXx5HouqJGMSlII0qPyGsLX1+vKyZy0YKrSoW0gz0GcZwWXE+oIRAr/WkgrOQ7fq11v0zi429HRgtzSV9IuwHLNKeT4Nu+J/yYUWTcAhN1VnDxAuaY6Eptt/eANRpG5+3xvHFtI0KWJmiyHHCVGYtDBjpdDCoPkvi4+m6IslEFsJGVyjUViej3mlJKzpCbKdqyMgUJaHi6tFtWj5EV2t/5Jzz2YqPc3yEk4AAJASNyHW5CjU7J+g4xDbF941ejl9Nmpnos2JD3VuPODO884zmA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(136003)(376002)(366004)(396003)(83380400001)(5660300002)(8676002)(4744005)(478600001)(86362001)(110136005)(66476007)(52116002)(6496006)(186003)(6486002)(6666004)(8936002)(66556008)(36756003)(316002)(2906002)(16526019)(66946007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VXRWaUk0UkZBYWF0M0xielRaZmZtZEhWWVlIRGtMa2J0MkZRblhhMHc4bmZr?=
 =?utf-8?B?ak5pbHZvalAyRWxCekxPQmNsSlVOd29oNjAzWHkyb2N0TkVkaC91eDdQbVRq?=
 =?utf-8?B?U0MzVkNxN0pZajFOTFlsYkpQOGhqTWlkaklnVlVkeERhVEJ1YnBpekFzSTRh?=
 =?utf-8?B?dFBIZnJHS1JTL1VjQmdhMjdTN2xGMjFFam1jSXlIWllFZUJtYUI4TXdpMUh2?=
 =?utf-8?B?M09ZWGxlVldCSDg4cUI2WkIwZnVpZ3U1VW94Ykh2azIvaXVHMzNwMEx4eWRH?=
 =?utf-8?B?YmNoakJHY2hqdzgrbVFETVNVUFZuN1phWkRUcmxDMlhvRytDVkpiOE52Z1dq?=
 =?utf-8?B?TDdaV0tEaFF6QnByaFF0ZHNRUmlNU0t4SkFncUJ4OVpsVmM0MVBzRFptRktK?=
 =?utf-8?B?R2JZVVBRU05KSjZ5bGErZTM4em5PMlgvdVd2S2JiZlA0amZlZWpiU0dnaEQx?=
 =?utf-8?B?Q0xuT1Fmd3JvVlZlZVBPcXU1cEFUanJFUDJtS25adklqYTd5SmpIVHRuMWVz?=
 =?utf-8?B?V0NGa2M0Tm1UWXhWN1dvaXgzd0w3NjhiZVlFczhIQlZrZklxNVhpMk40aGYv?=
 =?utf-8?B?N3dXbWpjVlpPYWFaSmkxdm8rNml6WE83Yk5iVFRQYXQxMkNIMm9JR0JjdkxZ?=
 =?utf-8?B?WVBybkFTbHo2YnB4UE5PQk15M0R6TGZFd0lnbWNaSHM4RU1Kd1ViSFNlNWNt?=
 =?utf-8?B?U0FWc2xMV3BZdXFRNkh3QWdva1BuRFlsWFdqbER2enlDMVlsQlV2TjdVV0V4?=
 =?utf-8?B?ZFlRbFNWM3FZa0xjZ1Q1TThJQm9wR2V2N2Fad3p4VkhmUjJCdm1QREI0UlJS?=
 =?utf-8?B?MnJ5UFBHblF0aVhXUStvM1BibXAxNVhGLzhxQjQ5UkxQZHhISDkzbytxQklL?=
 =?utf-8?B?SkdmMjd0UEprTjRRT291M012TUNReVdtVldJMW5BeFd5VXY2SkRIUU1rUzVM?=
 =?utf-8?B?M0xVeXNMR0dlbGYrOGlvUHFYTExDMVlncmZ4MWU4QUxZUS8wWWQ5VXgvQzU5?=
 =?utf-8?B?eGhRblN1MVl5SGlnU3liZVdGemFhSHVjZ0pkZ1RjanJ4WXNKSmRzK003cjdn?=
 =?utf-8?B?cjdScnJTajkyZzN3amVqUnROYkRWbUZXNmRFdnFGVEVQL280aE9DZWUrRnRQ?=
 =?utf-8?B?V2F2N3Joek1CQXIrcjk1WDhaQzYwU2pNdUNDWmVmbThOZU5NTG5EVFBXcTE5?=
 =?utf-8?B?bXRwYXBENWxrbW83QVFUejc5YnhxdXk3bU9tQVZFR1dSSjhvSlNPc0dYV1RS?=
 =?utf-8?B?dWg3SlBYMFdkMXRtYlc2cGN4Z3VlTnVJbFZtZHVTV3AwYm9Ra2JyNXdpTWJH?=
 =?utf-8?B?aVIweXpsQjJZUmEzdVlqem94V0dDUTJVKy9iVDZwR2JwMmJZUjFyaGJIZ2Y1?=
 =?utf-8?Q?ZsCmID+ycuxGO4EHIiafIVFpDkOfTFpw=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 10:27:58.6331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: 6243142a-1c1f-490e-8bfb-08d8a01aed7c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MKPDNdlyqhfPVgtQFmhhyR41E5MC0FqAdPcHk7iC72Rc3inkm7vunL6bV3kx94J5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6224
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
> Correct references to fs/cifs/README which has been replaced by
> Documentation/filesystems/admin-guide/cifs/usage.rst, and also
> correct a typo.

Looks good to me.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

