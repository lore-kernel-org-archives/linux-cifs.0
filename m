Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4AE6C433DB
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Feb 2021 10:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6704064E25
	for <linux-cifs@archiver.kernel.org>; Mon, 22 Feb 2021 10:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhBVKSj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Feb 2021 05:18:39 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:26950 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230037AbhBVKSi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 22 Feb 2021 05:18:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1613989049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gT56Ubf8ShWy5u9ZOkIPcIiN85mPMTM6eRJEIR4AX8g=;
        b=lW+U/548HWKehVE0r/3ZB3UYDpwlXJn3ag2+6KSy+wvVt3i3Td9sw3ptGos3S5Q6tXegBq
        eDi4yJLaZQ/+zINgdkssaI8QSZrBuFJCm/iSM3YKbKW+eaJT/iUStnwFtCCupmD52tvc0P
        cEd8BAdR8mv41En5mME56Aq0Mg1EI9w=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2051.outbound.protection.outlook.com [104.47.12.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-9-IFXlNl1oPtinSIpVvrrsww-1;
 Mon, 22 Feb 2021 11:17:28 +0100
X-MC-Unique: IFXlNl1oPtinSIpVvrrsww-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EBGf1ocuMJXZtVzKgGNgQsbNVVhYjBwGhxS5R9MIh84+vTIwyp80G5181LHC9oLh6zEGnvGkosuje0MXUrsJPJ+Y8FpFnCO4bEWRVn9zU0vt8BV+ouf4vFlX+U8+G2t5tVLpDIjJ+PTbsyfE0CnrXzGkdlveV1k29krZkz48zAHN4O9egbZEm8U5oJylrduE4/FNXd1zPLgU8IvcpPh1bOAfcHTLxaWW+m6DqnXUSG1i8C36nEZT1BPvOQRJywUdPyJFHg6u+pt848cllM7wGq/YbwYh1NgsVUMxx4aLUflu0OjD2OHXRYlfLwWybRx1A2kcz+Egs+4p8BeuOxJplA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gT56Ubf8ShWy5u9ZOkIPcIiN85mPMTM6eRJEIR4AX8g=;
 b=SLzhFvZ1bOPxqczuHF8EjMsIQQb0GOEvKBiq4Y7lGpPq0RHQ6RroEKDbEP0Bn5UPgkOprvFkNd1RVjjn37d79I/KnJ87OPQiO8y6VDZggkgiVsP7sBdghDv9sG78Scsz9HDY3/wG7qU6dGbv9uIEmMKLXmmLot6cJACpzVwYyimEQhq2GmyHUvazyMUaQcvqEak0RCtRev0O3dn6JKsvXM6yfMeV7oaA1PUpZ/csqvTYSymZ8E67PbMA4p/Jhk8/mIHt+B0TLtsfAqqr644gco5v617zmjSWSIoASMr8rCGPTOWRqC/s6g0FJANvegPmfvotDhVgjzvm/DL+SlQNig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: pre-sense.de; dkim=none (message not signed)
 header.d=none;pre-sense.de; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VE1PR04MB6719.eurprd04.prod.outlook.com (2603:10a6:803:128::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.31; Mon, 22 Feb
 2021 10:17:27 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3868.032; Mon, 22 Feb 2021
 10:17:26 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Till =?utf-8?Q?D=C3=B6rges?= <doerges@pre-sense.de>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: Mounting share on NetApp using SMB 3.1.1 and encryption
In-Reply-To: <c04ed8bc-9a36-0ff5-6b5f-1fce3d2d1402@pre-sense.de>
References: <c04ed8bc-9a36-0ff5-6b5f-1fce3d2d1402@pre-sense.de>
Date:   Mon, 22 Feb 2021 11:17:24 +0100
Message-ID: <874ki41k5n.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:9b04:4a88:71ad:821f:8ce0]
X-ClientProxiedBy: ZR0P278CA0124.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::21) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9b04:4a88:71ad:821f:8ce0) by ZR0P278CA0124.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Mon, 22 Feb 2021 10:17:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: acfb615c-2cc2-4f38-5ece-08d8d71b0d6a
X-MS-TrafficTypeDiagnostic: VE1PR04MB6719:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6719EFEBEF8F8A15F9172324A8819@VE1PR04MB6719.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KWVy0w7gO+bHkaxOuseoXZ4Sw/HnGrw5OzdRJCvXcMb4z7y2AxOXMvJcuYRX2fsRpARwS07mCgQ4eLvnwJafd99saN38UxtzIAY72mPk5rqlQ/1b74Of+y2SXDsEwMTAlki/RkzLBJbyw3LQeNm9E3EuFLM1hxBmCZ/eJdH5VPkAnEFm6sgpu/TLdLSOvSpe9ACelpM/GPa67rwKwLwb3w9CfeErHeHitD0D6PMoXrSGWlk0vUMxINiV2j8T1+qSfT9iXwwyXbVQ7jI1h+zAhIfiXQ9mH/H/2wqXrMmzp63ZKL8VaG3yWV2EPCfapbSHj5pShdjqPQcso5Mc7TtWPtBijtCegPZTr9pzs9f782S7dyhzeHnq73fKBcglT2MDyUtOqpqnU9Rhhgs/eIxl+zjrYFEMspl06n/JAbvEYkONPhsQQchPojrAgLAYSt4g5MYFIzZXAGKzFb1yUA19ogWGgZjCc8SDk2ejixDE1JSXSUCwOYOD3JMuqn+NeFoyLp3TJ31OmwLfv3OD6siCpWAZPZoBzf81dHc4KVCaQ68Ngx09vxxLJfRsQMkScLGu6/ai3WeMoIaPrL0gIKrffqFaQYgQXiRPDV+nfzk47CQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(376002)(346002)(366004)(136003)(66946007)(186003)(66476007)(2616005)(316002)(66574015)(16799955002)(110136005)(8676002)(6496006)(83380400001)(66556008)(8936002)(478600001)(86362001)(6486002)(36756003)(966005)(52116002)(2906002)(16526019)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ekRGY2REZWZBbnh5L2hXZmlWa3doK0ZGY0pKaHI4c1c4aE4zVFEzcGRsUStF?=
 =?utf-8?B?ZmozTkwvQTlFNGZKUDhTVDM3cTRwejh0em1vcU1RVTliRmw3aFh1bUV2MzFQ?=
 =?utf-8?B?NmNPTUlYeisyYUVnNUlEUmtmV0dOVUMxUHJRWUFOc3djekxmaUc5SzFJZHAx?=
 =?utf-8?B?L2dtRjRjVVJQT213VzFmYjd6TXNTN0FmcS9WUTg2aVJMSzk2RW54TDNxNEhu?=
 =?utf-8?B?a2g1b1JSbjU4Y0xFdDJha0VGSVR4ZTZjZEE0eW4rZHh5QVFQNkFqVjJZUHI5?=
 =?utf-8?B?eGF3dzgvTkphNWNVODY4K2xXZUZKQ25VMEJlNlVyaGpCTHNwYlJvOVZiTUZj?=
 =?utf-8?B?Y0pnTnIzSWx5VHg5T3F3b3RBQWFKYjg3aWh3Z2FSZGxROHF3RHVtSno3NFRn?=
 =?utf-8?B?R2tNZXFSRWJQdit3cjJFNnFlU1NYNS9Sc0dxU29YOWRPMUJqMGMxT2hrS1hC?=
 =?utf-8?B?NU51NnFYaGtyQWVjK0xQaGVwRSt1SE1qOHVNWDBnREFsKzlIcTI1SXBsTmxG?=
 =?utf-8?B?a2FOVkZhUGxmWUVwV0w4YmlqbmowMEx4Wjl6V2V3TDlvVWRHTzFKYzNkdG01?=
 =?utf-8?B?RWlmcVFzUnBuY29TYnkrckUrTEsvckRWVUk4RzdHbHRWVm5rTm8rZmVGelFU?=
 =?utf-8?B?Z25SUjEyM0J1OUtFWExhbXJucWNnaEdyeGpGb2ZiTngvVWtvMEtHRUFzdTBs?=
 =?utf-8?B?OTB0TE5WWXVYK1dLNkg1ckNaSVF2V0diOVBQYUZpWFcrNTY3VTIyQk84aGpy?=
 =?utf-8?B?VjdpaEFyWm9SVGlOb0FFMkJaQmdIMnNYN1ZKSVdiNFkwVFd5S3VMdWhTWkxn?=
 =?utf-8?B?dXhySlBCanJSemtYS05ENVNnRUNjbERLYVVNdlN1YVNFSnFlU2R5VVdWcFMw?=
 =?utf-8?B?YXBUNk82UFdtc0VWdlBYK0UzRHFKZ2FTS2g5OUk1bENaWkdVUnZrSXlRSC9H?=
 =?utf-8?B?VzNVMnNzNXRJdThCa0hUUTZ0U0szdlhoc1RTWjhiS1NRSWJpYlZOY0N1YkZo?=
 =?utf-8?B?T2VldzN1dk9hOVdPK0crQ3pkc0NMaTFBcHBQS0RQV01IZjVoenp0U1FaalZJ?=
 =?utf-8?B?MHRWblBPeFpVNjFLZUdHN2ovZ1o4WGZpbGZxS0svOEN4VkM5NVhrbSt2cXJD?=
 =?utf-8?B?VkxlS2ZQVi9OTVFmblQ2djJyeUQwVmlZM1VYNFBZQU9GTG03cnZxWGpZNzM3?=
 =?utf-8?B?K0o2RlBIanhFMjV1QVZDZ1JmTEg0MkNvOS8vVVlESENrR1kySGxmOWhPT0Nn?=
 =?utf-8?B?R1duOXlmSVlpQUlDSGdZWTlmQTlZMWtTZitkWWVnZyt5TEtNcXFXdW1sN2gw?=
 =?utf-8?B?TlNvdW1wMUx4YTBMNXRMcGplYVpyOExlYldRdmNyVVdrL3dwQ1hnWEdVTWsr?=
 =?utf-8?B?TmR4T1NXaWI2Qm1uSzMvNzBydjVEeTdnOUkyWFJpaUYxTHorLzkzV1pVNnR1?=
 =?utf-8?B?eVhJVUR6VitBOW5MS2FjSEM3NE96d0ZJenB5YUVBNWh2RU1JZ3VqV3hVQVNa?=
 =?utf-8?B?bWM1cWgrTkZnTHc5NFJ4cjIvdk93aVMyNG8xaWJmeFFabWtvazRZK1JQZzBm?=
 =?utf-8?B?QWMzTndEczVsZzgyQ0NmUHg4dkIycjc0YVFpaHlxdEFidHViTUdKem04dWQv?=
 =?utf-8?B?WXIwazNvM0lxeUZZQzJ5R1d3ZXJQYzljdmJKYnkvb2dsYXBUMXJoeHZxd1dV?=
 =?utf-8?B?MjVLakl1Z3JXTnUyTzJSRUFwTWJpZTg5dzJLTkpWUEVZUEZjN3JndllTOThM?=
 =?utf-8?B?L0NRZGF0VVUrZHlZaUxWNzAzUHpqYjBrZ0o4bTRmT0p3OWlqazh3WVFHQnJs?=
 =?utf-8?B?ZmdXOEVuajFWWjcxaXdPM2NGVmFnMG9xdVYzQk1jck1kTGZIU1d0Y0dQNlRp?=
 =?utf-8?Q?8JsqeSbZTrIer?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acfb615c-2cc2-4f38-5ece-08d8d71b0d6a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2021 10:17:26.3018
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t3N7Uf7gyyuRTuxdW2VpXOelOkzBNa8LuHs1KVGDN0KRe1RMGSyfV3vjWUHaKRTg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6719
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Till D=C3=B6rges <doerges@pre-sense.de> writes:
> Apart from the security requirements the server uses DFS and nested name =
spaces.

The nested namespace might be problematic. DFS is tricky.

> So before digging any further, I'm wondering whether this should generall=
y work with=20
> options "seal,vers=3D3.1.1", what to make of the ciphers requirement.

I think by default the client will only show support for up to 3.0
unless you ask it to.
So apart from the version, encryption and ciphers should be
auto-negotiated during the connection establishement: the client sends
its feature support, the server replies with its requirement. If the
requirements cannot be met the client will fail.

I believe you should only have to put vers=3D3.1.1. By putting seal you
are asking the client to make encryption a requirement instead of
letting the server decide.

If you are having issues connecting please refer to the wiki on
reporting cifs.ko bugs for instructions on how to debug things further:

https://wiki.samba.org/index.php/Bug_Reporting#cifs.ko

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

