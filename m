Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F75AC47083
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Jun 2021 15:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 397FC61466
	for <linux-cifs@archiver.kernel.org>; Wed,  2 Jun 2021 15:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhFBP7G (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 2 Jun 2021 11:59:06 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:45441 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231614AbhFBP7G (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 2 Jun 2021 11:59:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1622649442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NHtQTFaPEVABKdxJYxD+D3HizUJ95Ah4mMaEZUzpm5o=;
        b=IcbYvhdGye/kkyKs4/7i6XED4PkmoTWIfnrBJF25MtFfRQm5OX9RaoNuZTYQsXGulkMDJJ
        kD3Q7BsLXjuhtJBv+i12rQhICO4wfeUS0dCjwxzGUg1625ucHLWdPJIvCT5JuVLFDls4sq
        yIEX6eluj8QvwJbctE8PA0B33GPe17I=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2113.outbound.protection.outlook.com [104.47.18.113])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-40-SvdovHEpMOCqXXkR9nu4OQ-1; Wed, 02 Jun 2021 17:57:21 +0200
X-MC-Unique: SvdovHEpMOCqXXkR9nu4OQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqnz7ypfm3pdbndlY2IplW6iU8UUl06et9p6fFClqeUel9zSUm4S7vfbgO9AWCPVHcefW61LH8+UizbrMuvI+IQron9XbCeaVWkYhb6atPJ6ZLJi/tvtwFsJNskj15Ruj3+T42dAlvMYEDjGbMj56HICksrxRzSiW7UbnBr0EYAKPBvl92OjxPTAE6Dw96stHnlQOR8/0GeatJvGYsvyHW+dtba48yDpZnQYQQ8b6GO4HmyMPveSCBiqZNTJ8t++amVsb42PbuSgWwURkPOBBOskMqrDnzCrKtEQGe47iVzLbYu8uEe59CV0Jkp8Ke7QZDpvuOslaWdLNL5TMm9Akw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NHtQTFaPEVABKdxJYxD+D3HizUJ95Ah4mMaEZUzpm5o=;
 b=nuO6JqR4oZ7rTjRHUmNPYkV9p3xyMqoGO7lrte7PPp69zdYJ/duEYSKGEOay92Pk8ztF3/LKA19ioySrLO/Fv6hgNGrOcORxaR08/etK2kYMhNtJcHyq7A8PjJYOJwoGIwdzqDRpKKnM0PgfZPkrsZHOQPKq505c7KQVeQDmZbbZi6GybxppQ+4zIDNlV846zrM41LW5Zjf8bTH83TyUPjEr3TUW03yB0ReV8A20Ywo4wfNfvdbEXpxmg/7T8e4A4II6lKj97I1wzkYaZZgzvSvl+8MI06wPLhEmOre1DH20MsiOc6LgO5deJXLsj61gHyYfSxSjroEhJTVf3hRbOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB5758.eurprd04.prod.outlook.com (2603:10a6:803:e7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.27; Wed, 2 Jun
 2021 15:57:20 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 15:57:20 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com,
        rohiths msft <rohiths.msft@gmail.com>
Subject: Re: Multichannel patches
In-Reply-To: <CANT5p=oMLZei+OhXZ-8Hr2NCx=pRYWF1zQ0vRQ5D_NkvLGwJDg@mail.gmail.com>
References: <CANT5p=oMLZei+OhXZ-8Hr2NCx=pRYWF1zQ0vRQ5D_NkvLGwJDg@mail.gmail.com>
Date:   Wed, 02 Jun 2021 17:57:19 +0200
Message-ID: <874kegtg2o.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:d344:ce45:96b3:a2d6:686d]
X-ClientProxiedBy: FR0P281CA0008.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::13) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:d344:ce45:96b3:a2d6:686d) by FR0P281CA0008.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:15::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.9 via Frontend Transport; Wed, 2 Jun 2021 15:57:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b060c5ee-b073-42ae-43cb-08d925df1a90
X-MS-TrafficTypeDiagnostic: VI1PR04MB5758:
X-Microsoft-Antispam-PRVS: <VI1PR04MB57585E0FFBCE2CE765CF4698A83D9@VI1PR04MB5758.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m8RwdeJszOAR42/Ss4HE41Q9eqHQ3qWslrNY3rA+EcTwm63S6eymbo1M1MJz/pqB9q10DRw21Ll02VbCbDnMAgIpoIy5VRE1omi7QwV5IiKkZIWVCLg911UJCF+4ODrtzdaRhmml+/DFK1gxYfsvYRuSWY0rk2EYoNUL9yuss1gViEnzfaKpH2XCEmHV/5ywNnoE2El7V6qjNuauBRMDXpIoioe6yg+v2MWSaqXEtLjYc78m61TpaviZUc4cmENPPZ8SNiapWYSOXovxysN+HYY2gLJfPC3QpRg9bXIezqjO84LIvFhkLuk8d7GWG1wxDwG2Kym3jX/xPVELFy3cdzygWlHPNXGffS9voW0wgGIgN66QROrJGdtMiEugqrZIhVjTvkRkkQJXkBcM/jAVFiXuQRnfJHhUUU8/YM/EW7yHU3BGJW70PPinrPXJsAnYYc+O0EIyrXm29C/qmASkApDGUysT4pIDNF1Dt1WIy48HKfJYcWwmapSROlMcB+rqoo6swQKJHvLbbtfNsEJd5hyzUj3AKtK6l1KqhM6Dxk/uAjhxu3EAdUT7NSSwS7BqMMVZFMPHCVP3rZcFR4d0og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(346002)(396003)(366004)(2616005)(8936002)(6486002)(66574015)(83380400001)(3480700007)(8676002)(5660300002)(110136005)(478600001)(86362001)(66946007)(186003)(66476007)(66556008)(16526019)(7116003)(2906002)(38100700002)(6496006)(316002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?anRuanJrbE1iejRVYUhacUxWRlRPdTRsWmVjeXA3ZE4rdzhPc0JVcTd3QWlV?=
 =?utf-8?B?VmN4S0tPR0trenpXOVRPSHAwRnNjdnJMUStoWGJzUXp3VThnZlJidWppY2tj?=
 =?utf-8?B?a0xqZ2dmWnRJK0R3NW1Wa3F5UTNGUTluWHNDbjR4TnZDY1JNVXE2NXRJMXJ3?=
 =?utf-8?B?YWhyRG42QW5QN3FyNWdtck5uWTJ2UFFzM0k5SEZMYUV3QTdBQmdLQ2phdFlD?=
 =?utf-8?B?dFl3cDdudmlITnE5OC9zNFZXRUpIYWNPSDNRMXI1L0U2MXpmcEkzTDczRHAr?=
 =?utf-8?B?UThudGt0cW16MVVWS2tKSmFGeVRwRzZWQi9FSkYrcGRXN1J2Vzh0ajdocHF3?=
 =?utf-8?B?Q2xtL25qa2QwaUZka0d4MmZ1dGI0RGRVb1NSRE5NUi9PVjQ0UjNSSWtpZm4x?=
 =?utf-8?B?bnh6Ukd5VkFIL2luL2tjODltMlFkMVhFMmF2a2ZCMUY3STlETkVZUjlFcERW?=
 =?utf-8?B?ZGlYVVlFUVR1cUxCcUoyWUtuQy9zTXNEYUExRXVqdUI4YURqOGJZdTlXQm90?=
 =?utf-8?B?MWpFay9aZGFkcnZWdVVXemZ2bHhzRFJlMXhaVWRQV2VkMkp4MzhWV251MmVs?=
 =?utf-8?B?WmV4WkhWZzQzOEl4WXFxV2Vna0JNc0o2RUdNWWRwQ0NUZGlweHg2cER0aisv?=
 =?utf-8?B?VmZTb2R0K2ltKzBKWjJaeVczWENyRVIrQTd6RkFRaTRWcWpPNm9pditjelFa?=
 =?utf-8?B?eXVQMit3SncwRDB1YjZ6WjhPeG1ET1dMMTBCVGJtRmJUYlM4TVZBbGs2OWZi?=
 =?utf-8?B?Z0JqTEFIa3JqeE93MjlreStPY2d0ZTl6Y2lTRDBSenBmSnZsNHh3WVJwZUl1?=
 =?utf-8?B?dnRWM1Q0VTdndzZTUnA5OFZOaVJEVE5lTWhPZHBxaDhHSm1SVXFHbHpod25Y?=
 =?utf-8?B?SzYycW9NUUlJeFlNVU5acmIwMG1ocUJldlJpMmIwWkNXK0dRek9tUVJwVVpy?=
 =?utf-8?B?Tnd5OXRVeVpLS0JucElSeVJ6cFpucXRvZG9nUHlhZDNpc095cmZtRGRYb3Jz?=
 =?utf-8?B?WkV6QWhSaGg0MiszNmVnWVZ2aHo1bDdyNk9qSG00aWkxcXR5cit6bzdtQ1JO?=
 =?utf-8?B?VUdlMXQ4aUZWVHA5ZUFIdGg1VEluOW9LTjBzMEd5UDIyRVhLWDlJNVh3NmZE?=
 =?utf-8?B?U2tWd21CTytaWnZHVHQ2a3l3WXlHTmRVQ2MxcHMyNlR4TUVpWHpkY2pQMlFr?=
 =?utf-8?B?dmxNRW5xdjJuTWhRcXRxbms2RTlDdkMzbEhadnlpVHBqekFnRHJ5cDlTNHBW?=
 =?utf-8?B?NXFVYzdIZWh1WFV5Mkx5SzNUb2ZUUjNzSHhrUGxVdExSL2tVRmpTNjVFTnNv?=
 =?utf-8?B?ZVhnZFIwSUQ4NWhjVkxNaXVRZENvWkx5MUhVZmNMT3k3Yy9oalM2bnlxbVhB?=
 =?utf-8?B?SGo2RTZyeXhRbnJjRXJWTTZkSVc2d01iY01zbEk3LzJlakpZb3VqY24wMWxh?=
 =?utf-8?B?Y25FQVhVempwSjQzL3JHd2xlU1VMd1FtVnRVSi9ESVFUMVNzSTJpWTZwVVI5?=
 =?utf-8?B?V3p4eFRyTzQvcEZ5S25SMUt5QlBpaVlWR0JpOUFZZ21FTVNxNmJCNCszM3pa?=
 =?utf-8?B?cm1vZ0VHOXlXZTRpM2FBWWtFcEpwK3lMcWkxQkNya3h0Q3hPMzF6QUw1WXlC?=
 =?utf-8?B?L1Z4WWpJUHByUFM4NFluMEh1UE45ME5vOWJRZjBqOWNrakw1STJvaEZlZFlh?=
 =?utf-8?B?VzZFbEJZMnhhc1I0U3pxTXhjZ1hyR2Z2T3NwYjZlT1h2M0FrNFNhUnQ1dkp5?=
 =?utf-8?B?NDd4SFkvYm9KQllaZG9XdENCNEtEdnhxa0lqWERicUc0NTZEQktQNHI0bThh?=
 =?utf-8?B?T1g5WVBzWHBXTmJ6K3JKTEo5a3BDZC9HVGVaYSt1NS9YWnU4eVdDYnZhQ1A0?=
 =?utf-8?Q?8toLSOdZw4jsW?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b060c5ee-b073-42ae-43cb-08d925df1a90
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 15:57:20.4521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gT7HD+ssURCV8kr9tQfs7tEcquY4Y5A0ifJHYzBD4Ifls+X42ll+vbEXKDjaABzF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5758
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Shyam,

We've already discussed how to go about it so your changes LGTM.
I've added some minor comments on your github pull request.

Shyam Prasad N <nspmangalore@gmail.com> writes:
> P.S. There is a logic in cifs_reconnect to switch between the targets
> for the server. I don't think these changes will break the DFS
> scenario. The code will likely take effect only for when the primary
> channel reconnects (as DFS server entries are cached with super block
> as the key). Perhaps more changes will be needed there to also switch
> between the targets for individual channels (maybe use superblock +
> channel num as the key for caching entries?). Folks with better
> knowledge than me with this code may want to check on this?

You need to talk with Paulo for this. He has just sent a rewrite of the
cache yday.

> @Steve French It'll be good to let a few cycles of buildbot to run
> with this code, before submitting to upstream. I have run a bunch of
> tests with this. However, more soak time will be safer.

We need more tests on the buildbot so if you have things for mchan we
can run on it please add it there.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

