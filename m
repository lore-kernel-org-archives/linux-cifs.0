Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9845C433DB
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 16:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 966AF6522F
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 16:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbhCHQ7D (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 11:59:03 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:33300 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230050AbhCHQ6m (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 11:58:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1615222720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/VlZ88Tzm22GZQNon6Ytgf68PobNZNQHb0D1QsSfxoQ=;
        b=ixpNb+lkr1UbClTuS9JJHoik8YQd4oYQJyhezPTsOVJa002wbOKF9LJKkig0l1E0TYv7zN
        RB7tFZnB/mRSpcnN3EfQkjZ9pCYSThCZsA3++Vkue+y+Q2911AZIybA5urtXuwxdxqdJg1
        TqNBUg5qvs+ajMyliAU2XkOQKpbNtjM=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2177.outbound.protection.outlook.com [104.47.17.177])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-38-h9EqxENUPYmqoIi1qqj_fw-1; Mon, 08 Mar 2021 17:58:39 +0100
X-MC-Unique: h9EqxENUPYmqoIi1qqj_fw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TAhznhF3QkXW6/GpmvgPHjNLO3tRokF0e1kVBlQMlacyb4lb9BHXbzppWudvhlapaWrJswAD/eGex19/bHwcpcgn1962hU8/8N90CEJfYvO6yCXt68Y0JWyJoTlJTxHkBGCHSV/NG51+A5tO8bTw55Z4L+MnVGIElGh4NFDKowu22NCpoZ5bKgbYWLDeQ9NRQ4J/KeHD9PoOlq5qAGbWxIc8LJQlYCnHCDSw0Idsnao8mQkPihW78HGFAFfXTNaOn69f3YxtIv8p+zsPN4Heucy4euo0Iupuo+2h9RfncFXWlhEX0uwwtxMtt93S/gsRCFdxqnq/9SuCFrkrXeNmMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/VlZ88Tzm22GZQNon6Ytgf68PobNZNQHb0D1QsSfxoQ=;
 b=gcXDDb98LT7Dnkxic5BDhSKC5mQEqevblGHBOzFe+YupBliVBLzeihIvDhWua0FNPF8oDwqtzrTIfL/UwHiSgZtxYuq6y35T9RC/sgDi6ZlW9PWrstslY90AKjIwFrqzQyp7BWT/z59uNJ4jrOhWbiJQFb73qjPji8R68fnkvZ1ch1dVdYvuOypBXR8YArIMasVvu+cN7iJPLp6tEsWFmDDbC/ZDHfGC9+qsZqoCMIbtTPWtMtjmKMo5A/dY/ZRWdCbQC8coF4ihPIxYFpRQhIK2BPcz1+TU4KBz58ejvHVBVZ1Vd35wAU1c8hUBzYdHfC1Ubb3B/ZuWSMQ5tkqm7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0402MB3518.eurprd04.prod.outlook.com (2603:10a6:803:4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Mon, 8 Mar
 2021 16:58:38 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3890.037; Mon, 8 Mar 2021
 16:58:38 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: try to pick channel with a minimum of credits
In-Reply-To: <874khlx3pv.fsf@suse.com>
References: <20210305142407.23652-1-aaptel@suse.com>
 <CAH2r5mufnuA4cavG8JYq2q+-9kY3oHeoQrLyzeXgN2xFQ8P6_w@mail.gmail.com>
 <CANT5p=pzh7a9v1q15m056i=cN-MC4W2W2Lx3P68itHzd5EQnnQ@mail.gmail.com>
 <874khlx3pv.fsf@suse.com>
Date:   Mon, 08 Mar 2021 17:58:37 +0100
Message-ID: <87k0qhvayq.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:70b:4a04:48fe:21ee:1b19:31ad]
X-ClientProxiedBy: ZR0P278CA0012.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::22) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70b:4a04:48fe:21ee:1b19:31ad) by ZR0P278CA0012.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 16:58:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a33b349f-b9a5-4240-7d03-08d8e2536b58
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3518:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB35188A94C955F6CD41338222A8939@VI1PR0402MB3518.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:565;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w1c1nE+kIALaYeDf+zttDo1A71VmXEsHqvluc54u3zty1+0/0CPBB3CW0beyScfIXvzmnhyZyNb9UWoTmkSgkfG1d6Q7aeGgZPR0oNfA++SS6lAizr9wXcJw15IiB+xKbAp6esY/lIvhdyBoHwffc1qjLz/pYdRLQNdvlLqVJqpoxOt3FYzLuAQWK16P5m0/BaAd1+JUpoV8RNGwxKUJX77O7vb00Dt9gZWD3RMqQAns50T1lTrKBPWDUKD23QmObGvs78EtCshsB5ua0ss6/v7+kfJDZUbmldGEOb9ikqGzOsWcDZGKjCR1ouZOuwPRrzUuS+rDE5I5i2RwNi3QJe1OSAFmwaJiygJMA7xibPtZvG++J8Zc2qJMGPqigdYO1h9w9T8n6gkiFkg8HJN2bjOI0guJpNA/2yt6mnysEIVfRTzcW/W3+ieyIohb9mdBKftBweBQbwCWJp1q4FNg38mBwAtSMkykRyMVJB1wjeXfBKy/mqEx26ZL173OGXCWIAVGTrw236Jku3WFX3hj3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(136003)(39860400002)(36756003)(66946007)(66556008)(66476007)(6486002)(478600001)(5660300002)(52116002)(6496006)(2906002)(316002)(110136005)(16526019)(86362001)(186003)(8936002)(8676002)(2616005)(4326008)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?blZNYWpEVm1DbWU2OE5HdEVFRm1kS0F6eEI4bWRqSG92YVBYNmlBVDJUMGNR?=
 =?utf-8?B?Z1h3NGQ1V3BEdzRXcU1XdVR4NGhSTHk0L3NPcS9JNDZUNVdFTW1pT1VMdnlr?=
 =?utf-8?B?alJnbC9abG4xbVpYTGhONTVPMCtnMWJiL0R6NUtiQlVNZjZXUGNWVHlTNG1p?=
 =?utf-8?B?MTVHWGJ2U2VLZTZvRTFkNFVjNHp1TEtMVWt1Ykx5dmdrekpNeGNsRWFGUVJ5?=
 =?utf-8?B?d2g2ZE94VytPRTVpcS95b3FKY1dJNzN1aGdSV1VZZkt0UTRBczhiS1ZPanMr?=
 =?utf-8?B?WEdSOW1DL3d6dnZNaldxUWNlWWY1VmpPeGpaSkt4THViMGZrRWVzb2sxS1Bn?=
 =?utf-8?B?clhwNWdtdmVsQUJZUjJ3bUVtU0R0MjZGVFdtOUFMQSs0VWRCTmREWVlYMERl?=
 =?utf-8?B?T0JFTlBWYWE3YnRmM3hlNkp2VGQrOG1qZzZ2dFF0TWNiQnpTTG5xRnlQUXJL?=
 =?utf-8?B?c04zZjVIdDdFNXA0bk1CY2pjMUtYWTEvRzFTRWRnU01zRDFkNVNGYlc2QWpB?=
 =?utf-8?B?NXZUV2xiQjRrWW1RVG8rWjBNRXlabENSZVhrN0pwaHVyRU56UXhpNFEvNzNL?=
 =?utf-8?B?WW93cTFtTWNHVzFEVlF4Z3d3R1ZSd2kxZU1RSmJVVDNJTUxuTHVoOGVydWZ3?=
 =?utf-8?B?eDNWRVN3U3VWSTRrSmZrZlhTRk5mdi9tdklJR21oZFMzV0h0bFZMNjdRSzRN?=
 =?utf-8?B?U0NYZGk2ME1IT3pJQlEzNnRYRUxjMWFNaXF5SWR2SXFWNk5SVm9BN1VnV3V0?=
 =?utf-8?B?enlCNmFiYVVlMFJ0ZGFLVW5iWG96dGFnWXBhdzhqbFJic2ZhNXB2SU13a1Jh?=
 =?utf-8?B?ZC96ZmhMWlJHS2dtSDVnVElKNGFqYWxGZ0Y5T3drT3VxK3pPTlNhRFpFaXJy?=
 =?utf-8?B?aUtFV1BTYVNOY1ErNnFxdGZmWjl2eVpZeHVNTysyUnhJcURwNFRPd3hlam91?=
 =?utf-8?B?emFha0E5RGFjRHZLeURGNERjUmI4WWlNeGR4T3BIMGNqZUg2cFlsbFRPKzdK?=
 =?utf-8?B?RkVibUlXZ2tBYmR6SG44TzA4MjVxaS9LaTJEWjdYZEloVytRUkUxUlZNOERi?=
 =?utf-8?B?VmpRd2VEREVQS21TQ2hTN2JQVHNZNlhFNTFLUjQ0R1pkM05MTnlHQ1VFNjN0?=
 =?utf-8?B?ek5JT1JYK09jZ3R3QnB1VytQUWdzZGpyV3RIbGU4NEpVT2VxUzFubFJaVWdC?=
 =?utf-8?B?clRJMmRvYmh2d1hhYStqTlhxREZLR2VkcFNMT1J4d1Q0WVRjc0lkeTJqcXdQ?=
 =?utf-8?B?OTRpRmhidmltQXdhSERFVzV2RzZxdkM2bS9ONHBWN0RuTkl2VmcrL0p6WXI0?=
 =?utf-8?B?ck1FSjJ3WUZqSjRlNmh4YTdHaU1NYTZobythcVdjcTdybjUrWkhuT0xPV3pT?=
 =?utf-8?B?T3dMSjF5MWFmMjhuYnkxWW5HNXNYQ2Y2SGM1YzFhQXd6OG1JZW1aZ2ZqeUcx?=
 =?utf-8?B?T0ZpeWxydm96MUxHNk5UU2k5eXdZSWtEV1pGcFpZa2RhVmt4MnUrd21JRWxu?=
 =?utf-8?B?SENKdkFMMVBUUXprWjNFTDl3OHF3eEQ5UkJCbmdSbWM4cWpzV0xEcFZBbmM5?=
 =?utf-8?B?NzMvWGpJWlVTNW1IR1ZxYjFhTDI5N293RkQ0Zzh6L0tObS9RU0dWNTVUakxk?=
 =?utf-8?B?dWF6ai92N3VTbkwxZERlcVdESHNwMUg2bHByYlJkejVMZnNKZ0E2bmVHeWFB?=
 =?utf-8?B?Zm8yYmtsNmI1OWhiVzBZTGh5aTUrRlN5NmxnQVBoOEdyRDB0Smh2QmQwOFpC?=
 =?utf-8?B?NEdHSkVNWFpIb3lvOHVUa3FCcE80dDVMSXNNeFVlMXFlUDhUZGFNN09UL2lH?=
 =?utf-8?B?Tzc4eGZlVGNZbEdzVmlMRDd3NkxTZFl0dXRPMGY5UVVwTXRqTkhrTTJ4dzhQ?=
 =?utf-8?Q?bfay7UuBerqQn?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a33b349f-b9a5-4240-7d03-08d8e2536b58
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 16:58:38.5328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ICkh336LKHRrKTuT/zmyrOB4UfBI7vNCTrGTJhj7DTMItMeKxAMOraOmxQI9GmnV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3518
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Hm there's a typo in my commit msg:

Special care must be taken in selecting the minimum value: when
channels are created they start off with a small amount that slowly
ramps up as the channel gets used. Thus a new channel might never be
picked if the min value is too small.
                              ^^^^^^^
                              should be "too big"

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

