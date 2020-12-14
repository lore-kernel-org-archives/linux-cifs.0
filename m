Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED46C4361B
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 12:17:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD6BE2471E
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 12:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438990AbgLNMRk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Dec 2020 07:17:40 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:36354 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438996AbgLNMRk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 14 Dec 2020 07:17:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1607948192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N9KoRFIKaZjkeuHajQ45Krly+at3FQpppiR+GLYueUY=;
        b=nv4vWzdGEZJlt9qfmL9/4ofs5Z1aDrlP+bdbYcchFGPtxGWlcdDJS1RKdFJ9gyIrvDi39d
        UbA8O8tQDnEmMSzsiXwxp/hrekh7SWofMSSODGoRAj0iXuuktBTBRF7u+DsILWpgLAlkH2
        B6l+4bhNswAFhU5gGR7em+JY8oPx6Vo=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2051.outbound.protection.outlook.com [104.47.12.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-4-UR7cRh5OMuq8RJam71b1Fg-1;
 Mon, 14 Dec 2020 13:16:31 +0100
X-MC-Unique: UR7cRh5OMuq8RJam71b1Fg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6JFf1+d1E0XL90UgzaWKlGW/Os3Evu1G5DTQUkle7/FSgwYKIPEH5btm03Sl53W/WH1xGtP2rYQ8QxA7n0H3cT11MQHeSlwIxMpPBvWbCiwQ5APX54FONojqB9viltGYSwLtk54AJsIewpP04mxaPbZG0Nw3IVlI4/EjOUgnywvrnanx0FlXgg3VnOE65uJ0QQDrjII+OIPI54rPfyUdy0qX9folhRIGFeKufC9VfQxGOIaNQkwlzKxwTS/NP65j/SydzJ/2gqKJQzJ/ONoSljvXQq/FLQSokdtT5FPklDyj9GJEAXa2hH4OeVjD7qYzwba9JCrQMPxVGanOcGG8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9KoRFIKaZjkeuHajQ45Krly+at3FQpppiR+GLYueUY=;
 b=RULZ9yaapjLdWcc7S6BZqvt4jbIBwr5c0UqvMLM/pktWX4dUJ5RTsHCbJis55pTq257OgcZpb+rPanJOgIkDqLiKsOkmZE7U+IDGXbqTaYHxMuwXALEsx48exnzi+ICeGFLbz9/riflo0YzA+7vNo+kmy0NLZPjaaMTgJ8QPVjT4BRtj9+V24wojrG9/keEZrDWiKBfPgiB2qyb9ZkaazPesj5eAUEEkiRywb/fRKiv/fze6Iw0h07PwC/ex0NkvxRHDCPpO7cmJl+wRkou5K0NfvPy+VmH5oLG8ATmeEQ7MTR//+WrpNnafPBoH3QCAMHUztfBouED/M5QsUVKREQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB6909.eurprd04.prod.outlook.com (2603:10a6:803:13d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Mon, 14 Dec
 2020 12:16:29 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::4dad:a2d3:5076:54f0]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::4dad:a2d3:5076:54f0%5]) with mapi id 15.20.3654.024; Mon, 14 Dec 2020
 12:16:29 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <sprasad@microsoft.com>
Cc:     linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: Re: [PATCH] cifs: Fix uninitialized variable in set_chmod_dacl()
In-Reply-To: <X9dS1EllbQhuX7/C@mwanda>
References: <X9dS1EllbQhuX7/C@mwanda>
Date:   Mon, 14 Dec 2020 13:16:26 +0100
Message-ID: <871rfsd1lx.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:9f63:f5bd:7a8d:a064:3118]
X-ClientProxiedBy: ZR0P278CA0004.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::14) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9f63:f5bd:7a8d:a064:3118) by ZR0P278CA0004.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 12:16:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 225b0d8e-d064-4aa4-4931-08d8a02a1600
X-MS-TrafficTypeDiagnostic: VI1PR04MB6909:
X-Microsoft-Antispam-PRVS: <VI1PR04MB69097EA1C46A99B1F5E347EEA8C70@VI1PR04MB6909.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4w1wQBfv2iWLgW2zWSUP6a5WK9+w8BWyTiya5AV3w4J8d0wSq+mo0n/+1gYIc2hxtulN3NkaqB4FL2xifoPGRzZTsPbewwRvCbTvrmOrvVnidkRFvm3+lAVQB7B8p9MSjB/OeP1AoM/CkEEhexz8d1R1dogo/LGS9VJC3ujZwW3FmcAfsV3Te+ieK++xvZaPvTkjebsrVAM9fAWcgd0U3ijoxCQfRC/VBH1LDfqXQk4HP9aqZxy8lv2xi7D3K13AzVOrQ6tMWm1SCgZ2WG8XgRPLZE2q+YvoOhAUX0Yg4xdmPXd9dcsI5HP6iEkzyegHxpM5HQ3LGp0Mge7sdxVLhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(39860400002)(136003)(366004)(86362001)(316002)(8936002)(36756003)(4744005)(2906002)(6496006)(110136005)(478600001)(52116002)(4326008)(66556008)(66476007)(66946007)(2616005)(6486002)(186003)(5660300002)(8676002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T3lYQzFSZW1iTWtVNEVvMEYvUmpUK0JDYnducklRTEJNNjhXMTRRVHlPOGdJ?=
 =?utf-8?B?cE9VM1JNN2dheDNLU2srV0htNlB4YlpsNGdhMkJPYXJDVGUvUDdRakhscVc4?=
 =?utf-8?B?WjBXRktZWm9pS2kyZFFxMGFBMVd1b0RkRWdmemk2Rzk4MmFma0NlelZldU9L?=
 =?utf-8?B?aFdWOURZRW9UbHd0TjhtYzNJMDdlV1dDc2psbWFFUHp6b09XNzVSWjEvN0hj?=
 =?utf-8?B?WTV3S3hHZ1JUUEdKY1dibHlzTTh3UWEvVWNVeGhTZVNLUzZEMytXV0pBSTdB?=
 =?utf-8?B?Yk02M0FLZExOam1SbThaS3hsZldueDFaZzgyQXRCZCs2Z1ZVN2EvdmtoOXZz?=
 =?utf-8?B?N3dWRGZsSDV6NFR2MzFuQXdvR1d0aDJyNCtWbzhCSEM2b3h1cTdQTVZTRnAz?=
 =?utf-8?B?SXRoU3Y5WVlxVnRsdkJJaUhHdldzM24xemNZbkpYeUczakY2YVV0UTVMMVNu?=
 =?utf-8?B?Ry9XcHhGcmpnTDVybzdTS1BBZXRXK0xFNDFVd1JaUWNNUXJET3YybHBGcSth?=
 =?utf-8?B?bTE2VTRCZCtVczJrWExzT3dCM0QydmpqcHg3Y0pHL0IzbW00R2xnVU9NNHJo?=
 =?utf-8?B?cUMrY3VNZmdjMWUyeXMzWmRBUXlzd2gycHo5S09SdU5Rbnl0SnBSS2c2SWtU?=
 =?utf-8?B?LzdRenJNcGtNQjFtY3IwMkJwVklMTEl2SXNIQ0xJanQxOWdaSjkycGNvQ1cx?=
 =?utf-8?B?OG43aWl6SFJxSDhiV01UdVBNK2htM3pib2pGNGhMTmtZdTFaclVuVllVZkNB?=
 =?utf-8?B?bm52ZElzaGgwYS9iOXVocC9jTkV1ZTlsUUNaV2toV0tDVzcyUytPSDVFSHB3?=
 =?utf-8?B?ekY5SUJ1Mmo0cW5WN2p0WTBpaUpwSUVQdjdFblE2Wm5WanVUaFpFcTJGUzIx?=
 =?utf-8?B?WGdlWnlpOTlqSlVNclBhaVJkSldyZnJkWFJsaUo3YXA4Qk5WNVo0b3ZyNHkr?=
 =?utf-8?B?bXV2RjMwZkdiRVZOV1pFRThtQ0s5MDRZZmFBVDVYR2dFelBjWGxGN2lQNWlZ?=
 =?utf-8?B?d0Nzd0VjZ3ZvQXFSckFwTWVwRDFjVWVRc3BJQ1lyV1g1aXhtM1c1OWttanhV?=
 =?utf-8?B?RUc2b01qcXMzdlhEY1BxcTF0dmVNT0d6SWwyRm5zWHo2Vk8vUDlOMlh1Rjln?=
 =?utf-8?B?VmpMYnpleGw5bkxrdm05UHlWYkVRM2x2bjZTZUJsZHZoZGdmNTFLUVFBa3lo?=
 =?utf-8?B?NU1sZk96M3NnV0JGZ0VaWlNQSVZHUTUyeUZQaEVoQkt2K09od0hvL1dzbWIw?=
 =?utf-8?B?NTJtOEx2b1N2eS8weThkYWpDYXo1Q3BNYlZWUVoybEZ0QS9xRDZoaGpIcTky?=
 =?utf-8?B?YlVkOUh2MjM3Q0lCQXRFbFJIM2lTRmE0WldidmZsMU80MERVK1lScmhxTnVm?=
 =?utf-8?Q?5yqq9tL4cIrcyZABKP6rUPSzRtIvybBw=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 12:16:29.0143
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: 225b0d8e-d064-4aa4-4931-08d8a02a1600
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sGFDnRt2Z2D9NHoK6aBt5mBJOOpsL8Crs6hdPBytfUP3FpG5T+DuWRySUcKlqf07
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6909
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Dan,

Dan Carpenter via samba-technical <samba-technical@lists.samba.org>
writes:
> Initialize the "nmode" variable earlier to prevent an uninitialized
> variable bug when we do "size +=3D setup_special_mode_ACE(pntace, nmode);=
"
>
> Fixes: 253374f7557e ("cifs: Fix unix perm bits to cifsacl conversion for =
"other" bits.")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

The current version of Steve's for-next already sets nmode earlier in
commit 0f22053e811ca ("cifs: Fix unix perm bits to cifsacl conversion
for "other" bits."). I believe this patch can be ignored.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

