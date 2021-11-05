Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 106BAC433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Nov 2021 14:19:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E432D6120A
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Nov 2021 14:19:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbhKEOWH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Nov 2021 10:22:07 -0400
Received: from mail-eopbgr1410129.outbound.protection.outlook.com ([40.107.141.129]:48129
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232106AbhKEOWH (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 5 Nov 2021 10:22:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TTAd5aHHvc5GAti2876bQH/QuLsSSMV2QKkyUscWrDGxCsR6lGGyJSaCeWeFzfZ9IfiEYdFsyghljzS7TXce/HDvzr4iISQjqyJhqcuVqu1OhqqjJLOHrpYPD5E7V+agG9fXlTQ/4lSzXhyQ14o5bPQ2rAvQxG8yZYnwNu3YpBs+sfJH3mvhrmOCMhGLltwOz5/7vBS91H60Y4gR2kFW9gt6OUNFsn6Wyt/ANDevs94ZSnuC9RkNJN7T87BKgVF0N3YmRGx41jSPbFC1XUsfLD5/5Zz8ft4/yy1cx5sTPff7c2kLj9i1znekHdaKfoCvK3Pw0WIheQIk0+tZPwdJRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+xWq827sC3JgR8pvkIM0C3iOIiW+MiX2gd03nq0JrnM=;
 b=L28+LtNXZnrxB7C62POUYaLR437x54e58eTzFgyDVSH4HcraF/4X017IiHWVcvzE1tmLf26BTuFm89T9en0q3irNw6sG4nRUJmYOpzOH+4QO9zwtwXNWI/RGDBh0432xL1yfXiw1ynZr4WJSdyXwM45qVb8YUpKXtcQ9PYXOJVMcqXt8fSup7bI2Hbz3FnHfCpRrDLV5kK5VBlg4FDx9YXSEbpFUhRPKSs2fxgOjqGwbQvQ20FM237nU6XSk6IceOrZheQMbjcSxGPdnIftAEWDqXEgHQgg5iZuF3fvWud4kNrWSQezxPjUVmonVxumNAsovaDBbMEDPritorWW4Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=connect.ust.hk; dmarc=pass action=none
 header.from=connect.ust.hk; dkim=pass header.d=connect.ust.hk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=connect.ust.hk;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+xWq827sC3JgR8pvkIM0C3iOIiW+MiX2gd03nq0JrnM=;
 b=vxvRVjMlg49zC5AKdGehnsdSAf8obo1BMb6BXlMxjavPPqdHPy8qMSPjDXOWubLhb/XcxBb3roziPuZAfULQJGnnVicDAXuLfIge0QvoePyPzeyhFQK7Rozzq2yoHHPDks8oxirKuSVT0eixAn6ousULytL9gBqemOnssXGPzfI=
Received: from TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:b7::8) by
 TYAP286MB0633.JPNP286.PROD.OUTLOOK.COM (2603:1096:402:37::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.10; Fri, 5 Nov 2021 14:19:25 +0000
Received: from TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
 ([fe80::c0af:a534:cead:3a04]) by TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
 ([fe80::c0af:a534:cead:3a04%6]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 14:19:25 +0000
From:   YE Chengfeng <cyeaa@connect.ust.hk>
To:     "sfrench@samba.org" <sfrench@samba.org>
CC:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: cifs: suscpected double free in cifs_oplock_break on error
Thread-Topic: cifs: suscpected double free in cifs_oplock_break on error
Thread-Index: AdfSTvIUI+djSELHRAGbEEdvxjgNYg==
Date:   Fri, 5 Nov 2021 14:19:25 +0000
Message-ID: <TYCP286MB118867BCD206596ED6C8971C8A8E9@TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: samba.org; dkim=none (message not signed)
 header.d=none;samba.org; dmarc=none action=none header.from=connect.ust.hk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 03af2a98-21e9-41b0-0404-08d9a0674533
x-ms-traffictypediagnostic: TYAP286MB0633:
x-microsoft-antispam-prvs: <TYAP286MB06333D94B110CD5BD726D8E18A8E9@TYAP286MB0633.JPNP286.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XukmKmIgA3CyfvW0x0Pe9Vz7mOAvd9jVSNJqvM9NOlU9eXa7931Ape6a+brg0cn0226/TDmygV6vrrtmBGlGYWdqmi9w3Fi2oY+ZQX+ztXo3do4St9oQrwP5JebPhQV8MoIVPbqLt816QYGnGk9WgKgtpLB6Amm3XASRd4e0W9WnGaQIeUNHhWgkGSJG7t/XOH0exciwp9QB+j3bG+k2IwNP3x9D85YbKAuSU6vZPsyOJtghok3lWoc7VT0KI3VZAXAAaOOhlxAN2Tx51XN0SfEAy3hyXtvF1kduSuRZI+il8VfYb8CMwnGmiI6NlsMotOZIO8gwz9klL7nGnEj+lcdZcmnvK8GdfC/4xkp/rwP2HR13ot6m7RvE7+YwPi0oyUywG6BQHvt0xCkdajUE6rUo1daMDLQ1TYyGatjPqP10nQyYYnkoMH5sAQZby+eRXsjspuijiTZ7/GQnmrAGFGrAHCDoSzjElkKQa+JTO2NLNtx1dosWmOJVu0sbmQNPOc7Pn5+YWxB+b104Rp/I+r+qnN7XodHC7ZJHna1OhExTenvK/bgChpCb8pxncHKOcfJ/MNBw0ysHC1YJSlBeDn+4ECRbPZD4geFxJeaeH6n63meJLiLrNlPIf47WCs7+zf8Vm3jVjLtMoLtq+r35KIwiQCiqlcTM3qvxZb1YuLpC4x/VbDetWKltnslwoxwZbvkxqLLYR0G0Cig44p9iIuFOZ0XLhZA7/+gfkSnsuA1OIgKXsCcEc2x5BPYkO9NA2r19Vhwv3S+Mt+Qb+2T+AK9ssiH71Wh76GUCl2P4JU0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(2906002)(966005)(4326008)(86362001)(66476007)(6506007)(71200400001)(508600001)(83380400001)(33656002)(316002)(786003)(6916009)(52536014)(54906003)(66446008)(66556008)(38100700002)(64756008)(5660300002)(186003)(122000001)(4744005)(8936002)(8676002)(7696005)(26005)(66946007)(9686003)(55016002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gx6eOEpwpV5ys/rHibkYi7e8hxnrt4jU6VbmGqeY94AW2cER3Z1z8jl0chUZ?=
 =?us-ascii?Q?SK3xW7uyY2+9L+yvoKic0i7U03lIbescKZL71XQ1B5VBgJGxDvS5ViroU0jk?=
 =?us-ascii?Q?C+koWVQ4fNThLlzIu9hxdp2AqiCAHeLORLhoHpwL+Yzoet+T4/GUT4/9pmWU?=
 =?us-ascii?Q?nVsU7YjTTmUXLAdWJqtcfFetkXXbrr51jdAoqiZxCE5JX3FcpCuR9p4j2wbt?=
 =?us-ascii?Q?YPOEW1QNOyuUSY3EYPh4WCDaI97arBosYK1Oklfku6FQdOVZgHh6oLzH1sTY?=
 =?us-ascii?Q?fjfetGTLf1C3w8ecYQD21lZq0A2M13ekSRQlQ2SAumZYboHmaALcTJImKY71?=
 =?us-ascii?Q?FAw5Wgb8isMhigHBm8aXhLPa2pGhVeDl85HXw5nzlnLIKHibr8KZ4+MDLx6J?=
 =?us-ascii?Q?0+8xtjnB+LgKT2+d63WUA0nUEBmv0bgQ0rCQuAawsXI+oCAraUQdrmDFZL7K?=
 =?us-ascii?Q?MSvJ6MOCPulsfKk9g+N7/ixSOMp7g3XyBq/YD6fJ1YWxypp6yGYtvwCg78/2?=
 =?us-ascii?Q?jb2Ld/2h0CsnSSNroPBwDxo0LiAdAD4/29eh+YbIOVqMEIg2waXlURTGFGZO?=
 =?us-ascii?Q?PD4vTZE2iPXDOeeBf2SbUFPka9Gf/UYRxhJrxws/gkAJW+foxXw2PrHRsCAo?=
 =?us-ascii?Q?WRJlj/OhHKq9Ldg0tGHU+Ej1SrRRZOE+SuXLsp0pp8zEt1q4KwLs3FnbF2o3?=
 =?us-ascii?Q?z/9/XsCbvaZBYhdBy+FGtkZEDm0S3DZbOF4/BUQB3+go002iAiM1O7/vSzkN?=
 =?us-ascii?Q?iFnBXqu71Ggj934pkjg/cICZAWNtjRsLOQBlWzaAftgYspfzuQd90MQ/dtiJ?=
 =?us-ascii?Q?XfIs5X9ol/5zpiujSzatDT3JVL3HO1vWR/nUL2b0lmOfAaA6aXIXxnv4lxHd?=
 =?us-ascii?Q?1sfBIpBsSc6e8iWCab3RgzR5RI6er1Tf3yZCAO7Kap+kG6Ot0jfu/h4ADPWb?=
 =?us-ascii?Q?mO39mk1TS4azDBr7SBuotNSRo3E+kfVsivcUnHjUm00mwyHd9OzT0gGnuiqj?=
 =?us-ascii?Q?nD30UWlyQNzf/4OBa9z4354mWG5k8jqNQ6zpfPiBEYUtsmY3u1rmlqZNnmyL?=
 =?us-ascii?Q?8gkfbqN/zlKXn0xGRXeJ8yblc48VmMCMi6sUqINzrBWewTWwIFioFeu1cvEC?=
 =?us-ascii?Q?F8MxAgp4qjb32+P4CfumMMhTmjxRUp5t9Nl1Oa5zGz5iDga8Rnz1HjcexZwH?=
 =?us-ascii?Q?CEFAR75TxAQYXpWCuu0XKG/WrgcbmOfOsm26il8mGFXxE8SH4UXPIvkh6OCc?=
 =?us-ascii?Q?A7HT0C47bJZbrpi+IqJsDr5RGrquKVa8REm2zgF/IHp1nxW8AWdzBtZIVSuO?=
 =?us-ascii?Q?BsOyMs9BHUT+dqsq+1MEuUgiVYcPjrcrjqpt/Ghquy9Jz8/zBp8VOzQsm1oo?=
 =?us-ascii?Q?tMsI1KyjkEhBl/AZjrEbffkauNLLuz7tWrhy1lLUwhEJ5o+LtRTq3iPpLlK+?=
 =?us-ascii?Q?226u6A0buNKU1JOtJrdj6wujnNH0xkjXTcGS9uMle+cv1DjdnruM2ae2DK4T?=
 =?us-ascii?Q?n68NSSA9tX6kMTcFjfC2qY5rOQbFiKf8Wp16g/qscALonqaf2laGR55iN8sd?=
 =?us-ascii?Q?xRaF/JzRCGtgudvjQci5mqZ1i/tfkWTjt5O4d48b+6fEnAPXOfVulwPvaXor?=
 =?us-ascii?Q?efaiUz24dcU95GYoWErteio=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: connect.ust.hk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCP286MB1188.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 03af2a98-21e9-41b0-0404-08d9a0674533
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2021 14:19:25.1348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6c1d4152-39d0-44ca-88d9-b8d6ddca0708
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JZtD7vPYJhbY484hjYE/kri2QR3wQ85oW4ktTh1UB5y4Lu1O0vv/pAUvDD7C+FudNFqdl9tk5oAZpkCn6YZqlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAP286MB0633
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

We notice that _cifsFileInfo_put() is called twice for cfile follow branch =
at #line 4874. Follow _cifsFileInfo_put->_cifsFileInfo_put->cifsFileInfo_pu=
t_final, cfile will be freed finally, so it calling this function on the sa=
me variable at twice looks like a double free issue. Would you like to have=
 a look at it? We would like to provide a patch after confirmation.

https://github.com/torvalds/linux/blob/master/fs/cifs/file.c#L4874

Best regards,
Chengfeng
