Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE3BC433B4
	for <linux-cifs@archiver.kernel.org>; Wed, 19 May 2021 08:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC4B960FDC
	for <linux-cifs@archiver.kernel.org>; Wed, 19 May 2021 08:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbhESIDH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 19 May 2021 04:03:07 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:27682 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237902AbhESIDG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 19 May 2021 04:03:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1621411305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rMlTGT4r+OWEDFHwdIuaU4ZcQtpW2MHIuf9Nwglhp2c=;
        b=eEgx7uU3kwNMdfQFJT4GVW0t9FuveZVZ4jDK32v0OTaS4G9TuPETJD25c5k/N1in7pZdyj
        vcX3tCcrubhRKY4XZQNJiDaw/M621TLUF0RCd9b9LHFmcFcVtf9DsdCV/QJQErqroyCpB5
        m2AtYWuIVnKCWCy0urbVTPdNTOKHAao=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2051.outbound.protection.outlook.com [104.47.4.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-8-GvfbQT9BMLC96ejrilv4cA-1;
 Wed, 19 May 2021 10:01:44 +0200
X-MC-Unique: GvfbQT9BMLC96ejrilv4cA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XwtWIGSPVYusfXUPR7dS04Lxll0Vvo2+m4BAP1LuPVgSPULOwGb1o5OT28v5ssOHaXfEMqOboZW7co3DbRXiRarsCxzYTJiM1v7ctBHRugD3KQ0EUGC+gYU2dHvZ2sZNdkgQ9kG/cx5R1yfAFQO3kAL2ABFZBEHFkdDxazVAqoh6BarwPZkLjIE+sf4NPxW/FHfPRS3ZBWepTtNBhhA3OhjNitqXK4SixNtFipaJL2r5mLkubi1l2bib5dmkb1SgoRkMrvi7OJPOps3ExRKcTiZ9JbkezO65W6Ol35JEotleZv3SZXa536Tm0O7ijBtQmfW/aPeSuxEcVGM2w9ksBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rMlTGT4r+OWEDFHwdIuaU4ZcQtpW2MHIuf9Nwglhp2c=;
 b=h+QC6fpefQqnv5fEk6qDAoxu3zyYspAQUvZhdloeytLIcvQ6AVJKnqPrpDJ405QbOY9JQXjXKYeEdAZWuRGdUAad/3ofzMibdXJ5ODE/YUQ5cffmglwXk+8RNSh4aCKN0YmymZgVPlD/mtH0uOOvEAta/0kLFHn0JzcH/MzUru5DX+o5gxpt9FjR18sooRXHfM7b7ZcbkgaEuCAIhwn6zNzCZqyp0LZv1rEyygVGOwwFturAELbzIez0i5lGXZWyt1SQC0p7WNYPZax5FR1aH7nksT/ztFUTIzl0hlp8JmNmJ/crUHiF2312LuQBkeZdpdLeke9Kgsoo40RPBetsow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0402MB3360.eurprd04.prod.outlook.com (2603:10a6:803:2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 19 May
 2021 08:01:43 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4129.031; Wed, 19 May 2021
 08:01:43 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: fix memory leak in smb2_copychunk_range
In-Reply-To: <20210518224011.663856-1-lsahlber@redhat.com>
References: <20210518224011.663856-1-lsahlber@redhat.com>
Date:   Wed, 19 May 2021 10:01:40 +0200
Message-ID: <87wnrvqhi3.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:d341:3455:1612:4218:6466]
X-ClientProxiedBy: AM0PR04CA0144.eurprd04.prod.outlook.com
 (2603:10a6:208:55::49) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:d341:3455:1612:4218:6466) by AM0PR04CA0144.eurprd04.prod.outlook.com (2603:10a6:208:55::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Wed, 19 May 2021 08:01:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09c10350-5689-4e36-c172-08d91a9c5721
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3360:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3360E66C994F3139E73FEAB2A82B9@VI1PR0402MB3360.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c9kVfBUNYeZJLu2uhtErcYkF7tfW9eTiAcAsHhQdXHv95C9tVta0eI60MZ88diLsMObuQCkybiNBlwod/JRov8Kae11sQFI5RM6evOjY1WIFR0yGTPjnDNlxQcT7CmJZv4y2oMAGtSYLLaYlu30bXdLYYuXNxwXTTSImELqd9tQwCOeTa85xyaMGaFqdzaxWY4tXCbGj9Uo0frDQDJuKTUEY6fa3liF8sP49WZJrwl6g7Ls6687li3iRghIjBdLAUu8Jv40y2sst99AemhQCV4wLPGZI4Kj1xKhDdyA8b46z6qbBKwz/EXAbxUXWJPVnjQatOA3or+2v90Zv4L8Qb6Z8hmdPXESPy4oy4jV0Gei2lIoiukMqd8UULbMvh/fsBUw0u0Ub19TAs7L4dbKwi2iQA70Wy1qNB8e/hCu9SizcGxU+UxzNY3UbfaAGJms3CoM2JSgrL4MqrB7juLrYOjIomrPKQ9nRMXHl0sk43jDf7onDE6j4hcqLR5fWN0eqyjSouoWR7D4gmd8zrv4urpjrBwVAPVgtGVF3rxz3KP6OVXQqHGTP6d1K54/Gc6qrr02wuVY9bHDMRrxxWaAThQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(366004)(136003)(396003)(346002)(83380400001)(86362001)(4326008)(186003)(4744005)(38100700002)(8936002)(8676002)(6496006)(2906002)(52116002)(2616005)(6486002)(66556008)(66476007)(66946007)(110136005)(16526019)(316002)(36756003)(5660300002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?a3BROS9YRDBJVlJacXlrNEczdSt5Rzd4SEgzNWRPeW9ESExWSGlwR2FxcVY5?=
 =?utf-8?B?SEpqbWFHWDVBbUk2OVAvT2VSdGY0dm9lVzFITzRrVk1ZM3JuWWFxQU5zaU1s?=
 =?utf-8?B?ZjBuL3B4cnl1NHFpM2tTTmp6a095bUhLZlVUR2t5Z3dPOVJxL3gyLzA5aGRN?=
 =?utf-8?B?clFiNFVXdWRldVA4MWNTUEhGUU9RdTVHZmowTTJUVjRUVldaL25Yelgxb05I?=
 =?utf-8?B?dGpkbUZzUTBjbldhaDVqQ1VRSHdvbmtDTlR4bm1LdCtEandHQncwSmZMcEwr?=
 =?utf-8?B?K3VxMUpuWGRGZzhzWmF3ekZ6OThYVHdMa29rbWF0bUlSUDc3N1E2dGI3ZUc0?=
 =?utf-8?B?T1oyWlp6YkJHNjJXN0pGYjlnVGdWTEFaeml0UTZPTjBCeUtqTENJQUFIU1Vs?=
 =?utf-8?B?RmpyT2pXOUtmd25lNWp3a05IK2RqWTl2WHR1ekhIMWZoTXkvd3ZydjI5enI3?=
 =?utf-8?B?QTZNWjRKNzNLVDNQcGVMV3p6aW1RTVV2YlU3NFBDN0dpZWhxSTJBQkF5Ujly?=
 =?utf-8?B?dXloK3JHWDJpcFNXVG5DbjFhYUM2dzNxTlk5Qmh3MHIyektjeVl1TmoxYkNF?=
 =?utf-8?B?bG96ZG50Z3RhdGR0RkgxZFZ6ZzFsSVVHdjUvU0ZWcERMN01TZEh4MTBSK0JV?=
 =?utf-8?B?RE5Ub2Y2YWRyL2lmOCtUK3NLSEFVbjVPQXBQdWxHSlFnSVVIOW5tQ01oS05p?=
 =?utf-8?B?eVd6eUVuUDkxQkhqSlp5UWpITjRRanY2cWpUdlRTeFZscWtrWldpc2FJY1Zt?=
 =?utf-8?B?VUpreXRRNjBYRUxWdlpkVmxVMTZlU0NpS0VNSE9SQTlXQnJqK3lsWU1nRW1s?=
 =?utf-8?B?RHpTUlBISXl0NXAwYk5JL0ZpaUY1Vk1iczlobFFqZnBNY05uQlkrOFI2N29v?=
 =?utf-8?B?M2FDRlBnTXVZaittR0pONm9qNjE2UUc4elFqTTdiMjZ6WGpyVHN1RnNaNFVh?=
 =?utf-8?B?ZXExSGZPVjgyNzREZkVOb3BqM1NKNDBEOS96aTRvd09RK2NiNjhxT2ZTTzFv?=
 =?utf-8?B?azlEb25FUCtTUStYZnNXUzZYTnN3UVdlUzR6Z0pWdE8xenExSVpKckhXSGF1?=
 =?utf-8?B?NnFCYTF1RjRsU3J5Z21MSnlTVE15U2NxNTlvbkFOTXgrSVhnV2orVXVoVFNv?=
 =?utf-8?B?TDNsWHo3dkkxU1pzMHprb25DajA2WGo5Mi9jTEpsZkZ1Z0xQS1EvWFJ3aVlM?=
 =?utf-8?B?SVZPZTVxc2QwUDJMSGFXeENTY0V1K2xNUUR5Q05haXNneENaQVY1L3dZN1p1?=
 =?utf-8?B?YktUN0MyLzFIUUhmVGZIM3BDY2QrM3ZoSHZzN3k4TTRYck93U2RUalBWUjhG?=
 =?utf-8?B?ZGd1QjJIZnJUWFpmZU0ya2dkUHhMTGFqVWVIZmtYKytIVVhXeGFZYWZiYWUv?=
 =?utf-8?B?Qjl2cGwrOGllNXJnVURlbEErM284UTVqMk80MlVUS0R3emZSaU1EblppWWRr?=
 =?utf-8?B?cDdPWkZKcDFHTmtjMEY5ZnR1K29mS04vWFZhd0h5aTg4OGJ3b2tmVEZHNFZ6?=
 =?utf-8?B?SjRlbzVLRmRaZG84dk5DQ1IxaWNqRHoxT0xwSVMwZ0lDSjhRSFl6b0ZnMEJL?=
 =?utf-8?B?OGZ3K1NhYkx0WlNPYVdGdlBKRWk5Q09XWjlEa1Q2T1BiaW12dm4zSy9nUWw4?=
 =?utf-8?B?eXI0aDBzZDNJbUhpVlBSTUE4U0RVNjRRbG5tSGZQY2VIRkRBUThtUUlKY1J5?=
 =?utf-8?B?cjVYdkM4Z0srdVFZdzcvMmF5M1NyZHBxNVZzYUZyUlUrYzFPN05sL3N3b1V3?=
 =?utf-8?B?Ymh2OEU3MTBCWkF1MHZzMTVLa3dQZ2tBd202VXdCVGRnazQxNUJKTjZuMStI?=
 =?utf-8?B?bk9lNno0SHRNSk93WEdGNFVka1BSZVMrWTBZQ2s2QjkvNkdvZmQ0aDA3c2ht?=
 =?utf-8?Q?EXYbOjJpPO/Ql?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09c10350-5689-4e36-c172-08d91a9c5721
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 08:01:43.0165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yEXGwJm8vHVTAJ1Wco9EF3VI5nqeWPJYBYTK++8sQTlQWkIfC/IgYqn+o/Y460cy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3360
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:
> When using smb2_copychunk_range() for large ranges we will
> run through several iterations of a loop calling SMB2_ioctl()
> but never actually free the returned buffer except for the final
> iteration.
> This leads to memory leaks everytime a large copychunk is requested.
>
> Fixes: 9bf0c9cd431440a831e60c0a0fd0bc4f0e083e7f
> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

