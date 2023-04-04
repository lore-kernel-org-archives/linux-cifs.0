Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D727C76188
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Apr 2023 00:49:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbjDDAtT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Apr 2023 20:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjDDAtS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Apr 2023 20:49:18 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5b::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73597212D
        for <linux-cifs@vger.kernel.org>; Mon,  3 Apr 2023 17:49:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mNJfY3Jsf5KgGIENRaAlq3PNxmSW05GvfgOpjcp/wToqXs0hXZsZbRcXBg1WKbOCgFFBvB4UXSojO5ZjKMH5ofD6s1v7Rauvhjpo9gt0tAu0yBlRqqA5IjI3AdeJ1a1bttguKo6u36ugl8NzEAp5WyoTNxrGksyRA1lT55ZpaD2wae4KSyVIDNBVe4LwCJW824FJ2r/HELp6sVdaRKcNR9TcwZAsxkZ2s1sjmEuzXiI3W68VuRJalKYJNNq+7o5nAv/2xl6KsVqGB3knttytzs3nhjc7nBLZyFWw1kG/iMKMQ+mK+lHuFq64unZNbvmglyiAcJh7K05R2HRcE254JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JjsCQxSAt4O2osd+NkcIZtZAt61Ws0NwL1Mp+g62AGU=;
 b=IEDItO9S6z/Z1IetPM0DOeMSV3db/LbdmHepI+SqG8nJ7DPIj4hePAzd0cdJ6PDFqXYQ2zRJLnohTPvscjVjalcKfdxDUjDR0lE3X0Eo1hJTBg1V18EDKpk3WoBRZ3tvXshXnBJSOXzAbVvvve/BStvj7jrUrAOAZXkcBlSXj7x00Nkk9yMUC9ZnPwIODfOqUdFPQRKhAFD3XNPC9cw1ITX0Qo0H6gszXx4F+hZyE3jqMpV25dsx1I7TLnwOTpfmf0IrQGPryF8mHbc1iPWf9tl7xpgUlskqMLcbPK1d+uKDe4dEOnRoeCh0AiDHpB0sp5HLV/NXMZAeFO36MGEaFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JjsCQxSAt4O2osd+NkcIZtZAt61Ws0NwL1Mp+g62AGU=;
 b=lVYvvHh6zqs1weuZ4e+CHAqaScGrT/c5BVabOd+JEoKQNzh8MVKT4k3+mi+jOc58UguPHYFiKqlQJvhaJW1kyRZT74LjwBuVKFgKw8X8TtlPaB3cR+oaqFypiWKxK91+RfwXgLto7gTLfDYRC87zBdHQG80uc2xp9AYK6dMVjm4fPzYfSIhCEuWI9Qzm58rVSCrSwxXJxwIGUayw0EF6AYjXBI0vUv37X9dOmB6a7i0A+C+rjtzV6FFk6igANH8ttO/q3ENVVPjUuQzTpgYne+HEwQJ4j9HAm4eImup3TAGlLG44h4rTrzqYujiW6i6fguv7ibnApkwqshEX41GEeA==
Received: from PH7PR12MB5805.namprd12.prod.outlook.com (2603:10b6:510:1d1::13)
 by PH8PR12MB8432.namprd12.prod.outlook.com (2603:10b6:510:25b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Tue, 4 Apr
 2023 00:49:14 +0000
Received: from PH7PR12MB5805.namprd12.prod.outlook.com
 ([fe80::e618:b141:38b7:2218]) by PH7PR12MB5805.namprd12.prod.outlook.com
 ([fe80::e618:b141:38b7:2218%3]) with mapi id 15.20.6254.033; Tue, 4 Apr 2023
 00:49:14 +0000
From:   Skyler Dawson <sdawson@nvidia.com>
To:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Inconsistent mfsymlinks behavior
Thread-Topic: Inconsistent mfsymlinks behavior
Thread-Index: AdlmjwtFTyjFLgRRSqCg2ixXcEHWXw==
Date:   Tue, 4 Apr 2023 00:49:14 +0000
Message-ID: <PH7PR12MB58053A72CA4EB58CD2B14E53DB939@PH7PR12MB5805.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR12MB5805:EE_|PH8PR12MB8432:EE_
x-ms-office365-filtering-correlation-id: b7966f22-1032-43bf-8876-08db34a669a6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cm6X/gO82/c6jYQTYUYTlxa13dFiSt0fFUhN3HfVVy1mSTOFUstNAlrrRh2QhXsBja47IqR/gcJKlr3/3RNSXPaoWL7o+SSTTbP/3Y3kz3/6pQZXXHnYhGA+oKWj3ic6GCoiI5Y0oUzorAbK+XTiNSUvCcX43/g+bWoKS5/wzb0tw3ygko4r4NqyAxl17Luxi4V8Xzw2OwJd77daAXikbVrv3A2kxqMg766wPhw0CvkvYXBIaKQiXy7zFpcqDW9t3qqeXrj/oOBKQmmbNJMuas4dKc5VeiOPKanoRIogHJmmfYuRFOxr0BgfV3GvyPFweEF6DbpTYprKCMNKwCJoBp9rtrMw8VgGEcL1bXvKMtrASUHnbBC9Nh5+iNQRxBalLx2WhGDM7mseXNohyaXl8R9V2kkZIvJAwHH82WKdcl7PsltNk1p/vXGqof2B0KQKIrVjT3ExF50YJYKRNMo2627gVr98TGosHHnXokykqgzn2qrCtrxuAL8jIqQpV8WQIEvFhFyZaz/WNzktC/RIAPpZphl8XWHftMRa+HJKkZDd+sbwmTROWTYU5mZ112PwFeLPysDcy+2YWpISXT6A098lcLrE98k8h70eOzr3WoSttebDbPh4j/o8lt6+/FpE2uiz5lStNPGEYlCgTJ+XxMxndWupJq34FYa9jl8w9uo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5805.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(451199021)(55016003)(478600001)(8676002)(76116006)(66946007)(66476007)(66556008)(66446008)(64756008)(316002)(52536014)(7116003)(8936002)(4744005)(41300700001)(122000001)(6916009)(5660300002)(38100700002)(186003)(83380400001)(71200400001)(3480700007)(966005)(7696005)(9686003)(26005)(6506007)(86362001)(2906002)(33656002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+SIPUIZtwVuvKwSktEvGtL/K0Bqv6YBWL35m+nAsgKMPYt4C8c2qGJoJ7EIs?=
 =?us-ascii?Q?IF12pH7obmlvfk4sKtjx9o4wNT/kbB93jLhXt/3PZsxWWv40NkCK1e6lIvyj?=
 =?us-ascii?Q?ZyEh4VjAgYaSz69EhCU01qu5rVYmT15zs1S/MvkBcJc67+N7ogxIHaxv6eZk?=
 =?us-ascii?Q?JdfM/zV5qVM0v+GPa3XD6vPA9mfvNnEu7Jgu2Q9IJguVteu9+CBKGU6WFzWf?=
 =?us-ascii?Q?S5mJeILUVFnCqUEtsaXUuh4bocA3LBGX7arNmD7niowuI92KfPuvbd/28VOL?=
 =?us-ascii?Q?zrOXeKGTMrmlJcN6K/OFKlWBSy0+QoImlX8J1pvk3SajCZ+mdvwTTrZs3dhI?=
 =?us-ascii?Q?qBkgM7DQQPiJzID9r6nqGpjhtDrGMl8kJOXeIJzJR6oGGoG9eDhBdkUQhu4A?=
 =?us-ascii?Q?UN1A2Tmng/0/+uFysYBpob8WnjMsQ7U3V3EhwHh5LqAi4BKNNTQWSz7H//jL?=
 =?us-ascii?Q?aWkQE8/p6KGmQ0iagBvcTmhjfkDBd1vJJUegktcde1ve18iyAFrBVc8VjcXG?=
 =?us-ascii?Q?1gxn/6qu71ERpoUpecuGzxZth8WyEeW3ah4YHAiMailUGHrqCvWjtEZZsS86?=
 =?us-ascii?Q?eus8LhlJJH2WFZ1WpBqGjV4czwhXaPG392MSrkA7yE6qyscrDkrhs4pRbXwc?=
 =?us-ascii?Q?V8sCQX4WFZeCTZyH31mQ6u7UAmS35jPL2afArzy8sI8upmePtuKgdL2OTPpu?=
 =?us-ascii?Q?MMAu8rTlEfZKX00b/i2aNij+wmgeMVEeGf4eNEODgyk89fnJxv8xegFoWrmU?=
 =?us-ascii?Q?AfTpJ1IQ9C1+CRij3j1ja0QWlS6dbksIqufooJKF0Xk1YjCM2EyLhPQb/I2u?=
 =?us-ascii?Q?tckS3AylTbnsU88sTYAX3iBGNc9BPcCaDwPlR8RgD0/7q4CFSzy8dVNyJ4fN?=
 =?us-ascii?Q?/Pbqtt+rvRdqQgBYEVWdJfYxMh1DXvYPdAaQM0URu+1eWsrd1KJEhHr/G7cp?=
 =?us-ascii?Q?GfItq9juPrPQjTgIXgaks/WiOdWXJfi+W7vnekhbc6z0/oIVZwfmcWH6dYtM?=
 =?us-ascii?Q?WC7FoUvOQRnsC2YQxiEgzrcXCjwLG1lFJQua36shbXJI75dGkBvyqa+gL42Q?=
 =?us-ascii?Q?SDM1M4pvUk9pfpLLtVecVquF1282SxQgX029lrOx71JQ+NfjCgD9OSdXfQsx?=
 =?us-ascii?Q?xvG76eP6IpthIfyuGTrriQ9iamyNnfMROzc6qBOj+FYAz1xQYVs4hklhzvGA?=
 =?us-ascii?Q?0fEERNHtfvRR6qzFkRoMjCAbyPLP8UbTlTHADIB4KOY08TluBNcx34+1Yf6p?=
 =?us-ascii?Q?HVRTO5D5uaGq2S569v+i+rpD01JyCjg2x4Vls2Fh1o4XJqH+2ujX/yA4sCwF?=
 =?us-ascii?Q?VayQAp05Wspx6v9dNHfQMg94K38Cj78gaorjfL7Cb1icl93axW4xlHmDYRR7?=
 =?us-ascii?Q?cZ2WyxNXWzUCaKMsifCbR95TyOpKkOiZ7UaogOdWTq15WyrqWA2OZBskNH0A?=
 =?us-ascii?Q?HluY09Xh/+PGolVBwhVVyWjWAl3/UokM5X0v7ULR0KLeVvxz4Te0smtloOQy?=
 =?us-ascii?Q?FThUV0VVx5x4j6/NEL9MIdsuMWT0plfkUGma0mpM2If7RKSB6XJAYiX7eDy6?=
 =?us-ascii?Q?2s/JPdIivpjQHbpTQWk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5805.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7966f22-1032-43bf-8876-08db34a669a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 00:49:14.4236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gc5cCPTdbDoqfcfTewjQPAObTh8eJocwy5z0GB1dYS63fn+iGgcAgY3SUB5ihlNTOYmcb9sBmJtjI0wMrZJfrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8432
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi there,

I recently came across some inconsistent behavior when using python to trav=
erse directories that had mfsymlinks, where os.scandir and os.path would re=
turn different values for whether a filesystem entry is a directory and is =
 a link. I filed a bug report to the cpython repository here: https://githu=
b.com/python/cpython/issues/102503, and @eryksun traced the issue to readdi=
r() returning DT_REG instead of DT_LINK. More details are in the github iss=
ue. Can you please confirm that this is an issue in cifs that needs to be a=
ddressed, or if there is another reason readdir can't return DT_LINK for an=
 emulated symlink with mfsymlinks?

Thanks,
Skyler Dawson.
