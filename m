Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C1DC433DB
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Feb 2021 11:40:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98E7764E6C
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Feb 2021 11:40:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhBHLk2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Feb 2021 06:40:28 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:39512 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233263AbhBHLiA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Feb 2021 06:38:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1612784207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xb4+2VcXEL3V5FF4BEANp3N0+WoNE6V+UzgRrhieWbc=;
        b=Gz8AdxaXf1qDiE1c/uu73kIts+CBbh5DKdh9Xjh4Ira87piSnBE3BUUQN9dsnMPnov+Hal
        PMLP5fkJJIpiN9f6ME3J50sQ3cxi0npdkLeMr4WaedBnac5J0o9YniNCFCT/ZPgixotGay
        Dc21Jxok47/hnB31agJPN1fZAKbrHDc=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2055.outbound.protection.outlook.com [104.47.14.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-8-g5UZMMigOoqJaakM23P97Q-1;
 Mon, 08 Feb 2021 12:36:45 +0100
X-MC-Unique: g5UZMMigOoqJaakM23P97Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSu1aIHFYH+zS7u010PpbVO8WyD0T1xPq2S4jsvg0XAGaOTsq5xc5bHTJ2XRI0cJ2LZ0vUT0ysuAc8yVKKxe+5ix/nBTW8H0BH29UotGlp3kcQqV52kqP6TpK4N0Co1jSuXRKzmK6CjVgX5fiZWF6sGcETZBpIHQ/Cj8kzUQgxBvpdOR2++/2QGtySPWM5vmQKPcWPEOsQRvMN8LfRCQJxm9wUbKJmn/PoAM/2yiMJw2o6/Id/lEF/03BNqWojHEmF+vzyTBEFk1elIeNAGemF7rEFRDNArtBKrDRiCO7YY3tno+yBdIteDuhuXbGyp9D3pwEXYcTzReZhY4/ix40Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xb4+2VcXEL3V5FF4BEANp3N0+WoNE6V+UzgRrhieWbc=;
 b=oJVP0r+1ZeCJZRgIWcCm6l1emwFpLqAK/E/9K8h090P9eNPjsuwzgcIEQAjBQBgTQ0dQHtNvTLMwm4Md8cTU1nBRyXCcyfTnrTWoIFSlO8a9v7ojD0VoQ1M50XNpjvGF2wMF+5RJG0/AFgFNxrQqr7NdbS+qE90s2O/3+5sYz/rtxjRg6lDwz5pD2yDGko4mu6dxpKTg/+k0+CDKXWXoYb8IuBZJAGMRNs02Vjke/JQ6HewLAdilu/wzzhNmIbsrkZguI90eVEFjZwghEFZIaZkxCo54OZlIcy1mnx+Cj+wpw7Vv/oFko7SbwyxgDUR+7pLqxQJ7Vm9D0ljLlbETtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (52.134.1.156) by
 VE1PR04MB6528.eurprd04.prod.outlook.com (20.179.235.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.28; Mon, 8 Feb 2021 11:36:44 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3805.022; Mon, 8 Feb 2021
 11:36:44 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH 4/4] cifs: Reformat DebugData and index connections by
 conn_id.
In-Reply-To: <CAH2r5mv0TzWpYi38HtuVG2gtYvW60-RDOri3a1FUUtprn19Dzw@mail.gmail.com>
References: <CANT5p=o9Tw9E+o3PWytsNh5eDKxswJ+YPLZLWac7QwR_u-UJaw@mail.gmail.com>
 <87h7msnnme.fsf@suse.com>
 <CANT5p=qGTC4E4Rf_-t9xXOo4yf3W=xtk97J1jg-WRLhwf0juBA@mail.gmail.com>
 <87a6sjopsc.fsf@suse.com>
 <CANT5p=qQJwvF11MJpiuV7S1GpH9=HZ-g=hmfOV-a07N9xkYqnA@mail.gmail.com>
 <CAH2r5mv0TzWpYi38HtuVG2gtYvW60-RDOri3a1FUUtprn19Dzw@mail.gmail.com>
Date:   Mon, 08 Feb 2021 12:36:40 +0100
Message-ID: <87lfbyn647.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:9b38:7d8e:a321:ae97:fc64]
X-ClientProxiedBy: ZRAP278CA0012.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::22) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9b38:7d8e:a321:ae97:fc64) by ZRAP278CA0012.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Mon, 8 Feb 2021 11:36:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f79dfe4b-94e8-4244-588f-08d8cc25ceeb
X-MS-TrafficTypeDiagnostic: VE1PR04MB6528:
X-Microsoft-Antispam-PRVS: <VE1PR04MB652811A101EB00780FAE84BAA88F9@VE1PR04MB6528.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: He3UeCUEAgEYKz9SN2tlM1hHHzbcZL2OMsqX5BLUbzNcR5ij7TwUkK8v8h21/7Ev4IGNKdqqK/hlL6EEiTl4olmNbJPeZcybNGvZy9lsa8A5HBFgzEXAF/7skf5/rsE+Ob5nGkFXlk+JydjbGote07WIRnRWqpclqRoPmwzyb+FU2Pff8m9fAC7dihgF9Sa7gMgpZnD2A9MuMkCf18QQRPNQhwUiONFenkB0GWRN115toFE/lWdmL8bhFgxnFAL9AXkK2588VJ115mZeFg8O/mLMeZtI3BcCIaqy+pRBQ4dQ5bvVtzBSehFjG78gG0eic3Vwm2s7PLOBdb6hQ/AjWDGDZ0UOBqrM68lBu2MtLvbzCqfmOvPYQuL0C3/gGzOXxWmgdAdG5rFY236JrGQaSTso3x9ES45z/d9ODGiGHt4JJVKfiJTu6mJZt9UEfSVHsP5E4EJt90XhIHiW/B7QqcGXSBqKJhS/WoNe0I/Zubcdd4YtPcuHAVW6kl5RH57lH/WFVay6Ou/lo+OypkCORw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(366004)(346002)(396003)(36756003)(6496006)(4744005)(8676002)(16526019)(2616005)(478600001)(4326008)(66476007)(52116002)(66946007)(5660300002)(66556008)(2906002)(66574015)(54906003)(316002)(6486002)(110136005)(86362001)(83380400001)(8936002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YzBXeDFoV0hERk9tYTRXL1Myc0hPVktZd1R3YVIzUllpNE5PenRLdUNNa1Na?=
 =?utf-8?B?dTArdVdFUmhmcjRVL0h3eW1EU1pLOGtXTHNjbUpRWVhnTk1Hd1daMFNWbTJE?=
 =?utf-8?B?cVFmQWVkL2hsSXZVd3ZacWYxZGc4NlQzRkRFUHlja0p6ZlBtTy9jWDhRL3p0?=
 =?utf-8?B?MDBLMkFSaTBMcmhraUNoL3RBWElQWk9Ua2MwS2JMR0RnSVNEdVpuUkJTL1RV?=
 =?utf-8?B?UCt1Q01sU2kycForMVRXNXdTY1MxWUhjWVUxUzkrQ0FpMVFXUnBvNXdrcmNm?=
 =?utf-8?B?T29rOHl6Y28zRkRhRDkvZ1ltMm9uam80eWxhclphdnZFWlZOeHJ4Y3Jtd1h0?=
 =?utf-8?B?TVhna0R2c1RMMmI3UFB3TDJJa3UxdzVva0Frc3ZSRlFNZ0VSWGd3dHo2TjJ1?=
 =?utf-8?B?YUtJd1JBU08weHB2emUwMlVqWDhzdjNvVDc0d3hCZzV4c3cvUDZEODBUekFk?=
 =?utf-8?B?emFsbTVtbUo1Q3NnNnAranNHaE1GUHR5cHBabzU2eEV4QVc5YXg5TTB0aEdo?=
 =?utf-8?B?c1dLQngxTXdId1NEZUNMdyszSmxFSVJyT3NDNThCeFR2TjM4VHh5Nkhkb1Zo?=
 =?utf-8?B?c3haQzZkSlNhdFpmV1o0ZkF4U3grS2laNXFuWG9YVWJtM3BVV0NPM1NmcFp3?=
 =?utf-8?B?N2NGWFdHZndRanJsSCtYMGlHelBGMEQwVjZZNERrcHBNSUFxeUZubE0rNXhP?=
 =?utf-8?B?WVltckN0OVZ1Y2ZLWjk4NlJsOTEyc25DWjFuYWpOWkxrSGdJSTFNVFFtbHQ3?=
 =?utf-8?B?eFdCT0JSMG92ZHJIeGlZcWpVTkt6TkZvdUNjMDVoeldYSVhjbDYxTDJhamhH?=
 =?utf-8?B?MjBzb25FL2Q0bmNUYStrYUVZSklBMC9xckhRWW9DWkRKbDZCVGZUd2ZXNHFL?=
 =?utf-8?B?Q05OaGN5aFNRYjd4dFYrS2E4aklDRzhpNnh2MnM4Z1A0RWdhUVhoMUhGUkxq?=
 =?utf-8?B?dUh4eGNORVNtTWUzUjk4NkR6Tmd0Q2UyUEs1UWJvQ09hQnA1S0lrQUhUYnJ3?=
 =?utf-8?B?Tm5KTzByTUE4c0owMGphZGVWTWZrY3NJajVjeUZNbEFSWFg3cW84YW9uV2Nj?=
 =?utf-8?B?TVdCN1J2Y3Q2TGFRWEdvbW1weVQwOXBVSjhETUIyTXIycnhDckFuM1FqQzcx?=
 =?utf-8?B?VVFzUTdvRVczTFI5MUZXaUR0dVhjQzhValN3RmdDcHNHQmtva0tpVGhYZEho?=
 =?utf-8?B?bllDZDZ0VWhGeUFWSGM0YUlLaFFLSkczYjZNU1BmWFQ1UDZLcEFhSHd5TTUx?=
 =?utf-8?B?KzZZclA2TkFOSE5nejVYV0pzUDVPM1N0TEs2RHRSMkhsVVYweUxma0wxK201?=
 =?utf-8?B?QlhaaCtXQWNLZ3B1ZmhUUFM2YThBcDA2bS92VkxtNXMwRUQwdDlPLzNyVkRU?=
 =?utf-8?B?SHJmWWpkbDFZaURRZ2FFZjBJcGE4MDFGN21nam5iSml0KzJFOUhZSTM0b2gy?=
 =?utf-8?B?MWRTUjJzblhXTG9zTlZhcklyd3VtUTk1V3MrYmZQOFQyazVnaUo2UFZFNFBD?=
 =?utf-8?B?UFNrMk9BbjQrRUVCSTdISGljWlV0YU9ua0s4WjJLYnRQZTBFM1RNQ3d3bkFZ?=
 =?utf-8?B?T05WSytqUDdKTkNQRFlrai80K3Bmdys0czNxU2xVSUhqV25RWnlUaWdKSm9z?=
 =?utf-8?B?UHRsMTJEbmhyVzVQelh3UkI3b1NpSlpFeHlNV3VOOUdzMmh4bW5vRDNwcWZn?=
 =?utf-8?B?TU1UZVViS0UwcXhiZmM2a2hhZFcvazFXOWNtanR4TjJ3cXVGRG4rS1lVR1Fm?=
 =?utf-8?B?dzEzNENhRnM4YlRTUVVRdWJET1BZdUtLRm5JT2ZSUTN3MzFFeURidjFuYlNZ?=
 =?utf-8?B?c3pnSlY3UDJxZWJaL2RTaXpnN3Z0b0tjb2pqcDlKVHV6M1FQcjVydU1ObkN0?=
 =?utf-8?Q?ewE4KpAFR08xJ?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f79dfe4b-94e8-4244-588f-08d8cc25ceeb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2021 11:36:43.9616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mnI1bY/0Q+k+jtPI13ZBk9nJY3ycfI0nAxUxNq7QG6vofGNgEOqT2wogX2LmSaN/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6528
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
> the multiline strings if they make it more readable are fine (probably
> fine here), so can ignore
>   "quoted string split across lines"
> warning

Agreed

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

