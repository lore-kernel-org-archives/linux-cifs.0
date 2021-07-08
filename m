Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F3B3C07E96
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 11:25:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C08F6141E
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 11:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbhGHL21 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Jul 2021 07:28:27 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:57622 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231576AbhGHL21 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Jul 2021 07:28:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1625743543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=J3TEhO5BWPR0w4imoWWTUnzmXHZ2x488maampi1p6p4=;
        b=GfIgfSKasCHADBGVm17v5yoPtdBi/maETqwMJnxqInw4WaTVPXh5/pv9n+WJmSTPSGbpqH
        aVCmQArnPX56qiYJ/mJzc7Ns7kXM0MaCJdd2kKtKyFaF6cFKnJaXaeh9m2kJd6dOUXjEsq
        CaYHn1GQM701CDIEUX1k2QjnArWXElM=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2058.outbound.protection.outlook.com [104.47.14.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-16-tdL-cxrEOGi4iOrNH7-FoA-1; Thu, 08 Jul 2021 13:25:42 +0200
X-MC-Unique: tdL-cxrEOGi4iOrNH7-FoA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iY0xeNfDCAQtpgyqy/4+Ut9DjTKoARwSewKoF12HIkVhQOEZREnO0koqzsy550Y0I4DNajNa9E1+y/EGDo4r25+gr5Wdsk8vDReIz1qZ/9UChxRk1pd0wqMRBn9tDrQf70UTVh3p62voaWNbmlYg77Ho/VTtMrNhdVy1NW5SxUDKZiFMoCkHIKUuFVJtxf+4IqwL7lQ/yXQkyrWd2GajusEaRvShY4LrDKv+BP69XRwbCtpWKmJScPcq5w6qeFR7zOURoK/BdryKWXZEN103ra83Q5wZed5X7IViQylUDhkROfcISu5R1HSfd0kSuJyxWFCc11rCgvF+A9FdYtrX4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J3TEhO5BWPR0w4imoWWTUnzmXHZ2x488maampi1p6p4=;
 b=b44PTiFW+vPGpt2WHzvCkSf1qEMHz+yqLmkbEaoG9G7msACv9r68cRuvupNKmNzFdw1Mfj1VHFqM/dprfIfNdIcpPcz7JHkdX2IbRt8lx9Erus5S0ikJOqvTx6lEuAFdES1BiUAoRrCQFHxdfosNtFy2ZLTJALZXytq0hP/KRqnWDphwHAg7r4DTfdmGJ4izPp48I726/D/f4+0I8shGWlzdO9A9tWT6dMdjD0DnEOj1kT4BiQN42JTm+rwnYJVF+9JZldQiK/U2kx7RF28Y/mPQ4hQRmXB5TNYLfX9Rsgb9/CRmbPpg9eqbevnBMuZIz1zY6aP7CFh7BWm5IiE13w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VE1PR04MB7279.eurprd04.prod.outlook.com (2603:10a6:800:1a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.21; Thu, 8 Jul
 2021 11:25:41 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d%6]) with mapi id 15.20.4264.026; Thu, 8 Jul 2021
 11:25:41 +0000
From:   =?utf-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Subject: Job switch/email change
Date:   Thu, 08 Jul 2021 13:25:40 +0200
Message-ID: <87v95lf3nv.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: PR3P251CA0004.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:102:b5::16) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:709:ff00:9d2e:ab35:845e:9ff2) by PR3P251CA0004.EURP251.PROD.OUTLOOK.COM (2603:10a6:102:b5::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Thu, 8 Jul 2021 11:25:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 114774ad-95e0-43ba-cf03-08d942031e62
X-MS-TrafficTypeDiagnostic: VE1PR04MB7279:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7279EC447F8A4B5AFDB2C70EA8199@VE1PR04MB7279.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OWBTrAzvNHomh8hDhKxjPJB2GlfBV8O5TsOj4PBDAZNui2k5Uv6Sqck5iia2uQMOR8hRni/4T2dvRvfYVXJv1ijN61qci1xdbo7qKr5yknfFDPJhN3EZkSz0KvS1GxUXyUu5LFl7IhZuQInIf3jGNk6xOa0WlMOg5GcOdUxmQGFwlZLOFw91rFHJhVYkznqEjGpOqvJbEVTXK0ZBwxLM5E9oam8b1BYoheLAw9Tb8R2crHsQItw+e4QXmKcvGRhwH7ujisfGoDDY9N0xwxUE0YCGS10c+MM4xEbzKW9hGM3jOtOhpX6zqmU5DoLW9rng4oAIsiwLmyk/BOguMz0+uDFBuYeuu3+HKB21T88hTO6SwTNHYhgD1+7CyzHY6vIHqrXOOBbXnFOOYlvDulXVrzJEHA3l+OFhIFE4InO60CPb33cQNRbzesTWfAsjcg2Rv5ULh4+2vtvmkvQDE44u3WJJbVVPOXnHXnSj8kBCMUS1aT4LbmKuEBGg5WlfQ5x2JhI0uSghdtM/HYE7CYIaGiCuq59l7zep1BEzbSaqd+TsY2n/ptdZBhGpUyYyYhEBlH1I6aqweI2ZU6OjSlhyk8j1o/1UFyirq0dt9Qybggoc8zn+Dl/hJDjtMkv417pIkDhavFOg1pE4FcGL+J+voA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(39850400004)(136003)(6496006)(6916009)(316002)(8676002)(2616005)(186003)(6486002)(36756003)(38100700002)(66476007)(8936002)(86362001)(66556008)(5660300002)(3480700007)(4744005)(66946007)(66574015)(83380400001)(2906002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVFWMGpjSXZ0QWpFSmpoVEF4U0FRSEg4MEdyYmZLb2h6WmxoTjY2cU42Q3NR?=
 =?utf-8?B?M3JZRFVSZEdCMXNPUDV5Y3o2Vi9aVkZmaFg4TGFJN09YRzhQYWdLMHQ5QUhs?=
 =?utf-8?B?dXBLd0piUWRUYm51UzNRajhUeGh5ZmM1N0JOTmV6cDNaa1ZvaEVaSUFrVnBh?=
 =?utf-8?B?MkczZ1M5dHBVN081b2ZaVThPYndCdU96c1paQS80K2pmcTZwWGtqRjVxdWhn?=
 =?utf-8?B?UUFyTGZrbzcyajZBZ2kvNmtxNDlPdzEyY1BycFVUTHptbEdXMFlHRHlVQzJQ?=
 =?utf-8?B?eXllMmc3b01uRm4vUldiV1l3Y0pyVVJMTi9QbGlUc290djk1YXh3T1JRQjcy?=
 =?utf-8?B?WXBrempNekxCSi9zZFBiYkxMaDIyNW12RE5JaVMyZTNJYnNMaUpKTjREek1O?=
 =?utf-8?B?M1NGMnpob1QrYzAyUTVHdXl5OXB3bE51V3FlR0RhU05GbXJwRDJCUFJYc2Nk?=
 =?utf-8?B?T1lRMndVVENTTDQrb1VZMG9pUSs1NjJDUjdkMlVWRm4wb0doOGRSZHZqOWNS?=
 =?utf-8?B?WHkyMGVIWkhPelNaOTEybC94UzBDSjhoNXhGRDJxZHExR1lzY2JYdzlES1U3?=
 =?utf-8?B?Q1dPYlpRaTJwNW5pY3NKTndiZTBybzE5YnJRVldsaWxFc3JGYlpjcmxNUU5U?=
 =?utf-8?B?czk4a2ZBWWdrUTN6b1VodWc4VUpiVFB6ZDVGVU5FTlh4azhkRm43OEcxYXZT?=
 =?utf-8?B?YTNLSVFFUG1BSTcwU1Vrd3h1T3ZnTm1EckpiREhISENQM1hIT1BsNmxESnBU?=
 =?utf-8?B?cTdCT2c4TGFsZmM5TVQ5ZEgyRUVkTHhVVk1TREFWbnVGU3h0dHR6NEVudU8v?=
 =?utf-8?B?aXBKMXZ1T0hRcUpqSlVMQzdILytsMVJuaWIxbXJUODlPVTJKeW8xWDVlWXEz?=
 =?utf-8?B?Q2VLSHhqRXZNdEpIQVRKOGlGeHNBekdHUXdyMGdPSGQ4QW1GRnMrbnp1d2V2?=
 =?utf-8?B?S3MrcUJjWExheE5XUkN4MW9qSk1sOGFOeDM3SlhXOUpCQ2dpOWpIdHExSEJx?=
 =?utf-8?B?UmhVUk4xWlpVckFra2V0NmdCYmpPQkdEdWhMTTRlSEE5TEhLRDI0Ty9TZ3I2?=
 =?utf-8?B?T0EvVWRvc0hsZS9RU3NybDNKaGRhTG1mYk9neWRaT0dVU013UXNuNS9JTGZT?=
 =?utf-8?B?Umtxa3RKU0lrUGNsZitvT2lxRlhYQ1N1RWVVL0tObW9sa3BZY0JmK01JVzh4?=
 =?utf-8?B?ejYwOVBNZHFjbm41QUd2Ynh1MVYwRU1OSlhKb3FaVFJzcGRkTnZjNTFxQjJF?=
 =?utf-8?B?eW9SNEtlL2xiSnd6TlJwUHRxZWppQXI1TFFQcFUyb0hxeDFKcEMwVUgwMnll?=
 =?utf-8?B?WTBOdUpSOUFoN2Y3ek5vRVRkY3hhc2xtbVQ4WjFSZ3JTM0tDK2Z2SW9rOXBJ?=
 =?utf-8?B?OU11MnJFOHVhWWFxVjFuRzJzbGlYOWtLTE5HNENOZm1SS3JQa1NESTdCZEt0?=
 =?utf-8?B?a1A1Um5vWHpJT0FzK0o5SVRCczBub0IwbjRBTmFDQkV2bzVLSUhXQW9nSkEx?=
 =?utf-8?B?RVk5dFNyeWRBbFJjMllsazRNZ2dpS3YwazFZV0NWNS9iaUR3c1Q0K0d6THhF?=
 =?utf-8?B?bjZidVo1ekF4T2dSZUJwMUpDbmJyWHV5L1U5cnZBV2JsR2pHc25SMlJCMkM1?=
 =?utf-8?B?eHErSWVad21DUGg3SFUyWWVOTXdlTUw2ZU4wMmpjN1o0Nm5DYlNnNkFkUDJ5?=
 =?utf-8?B?cUd0VGNoUEgyWU9XU1FTZkhSQWoxVG43MUxsNWFBQ2RjYVUrQU1FMEYzTUtW?=
 =?utf-8?B?TklvMHlGb2Y0SWlpVHQ3RnZyMSsySVVqUnFEYlhJVmpsSkZVZ1hmSkROM2I3?=
 =?utf-8?B?M0xGWS9DRlkwVUc5aTJHVnFTcDBRRGJ5R3E0VVkybnRnaU5RQm15TFJwdTJi?=
 =?utf-8?Q?qD0D1Hb10zzGj?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 114774ad-95e0-43ba-cf03-08d942031e62
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2021 11:25:41.2742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ee0/os3grPqQtXEKxp8xXO4VL8PFohJAprdE2keC2CG0TX/Iql64ouFzbn9/ii/v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7279
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Tomorrow will be my last day at SUSE and I don't think I'll be able to
access this email account after that.

Please use aurelien (dot) aptel (at) gmail in the future to contact me.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

