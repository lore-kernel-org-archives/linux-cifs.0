Return-Path: <SRS0=0UGd=IG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A99C8C433DB
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 12:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A0B1651C9
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 12:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhCHMVY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 07:21:24 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:33297 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231272AbhCHMU4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 07:20:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1615206055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cBQoSFK3Iw49+JMmsX3eKbeije319M2h4dI7j5gBgnU=;
        b=YwrLzpTZfbyUleVMqPvNF6Tltg6bi3XIzB9EvpCm/hWd4HukHErCjOyWDLmYkqQgXCxcCb
        sVzcTwXFZo82bff4HboKhsFqc3/RQbDjAh+3mxXFIPtmzCeF/jUmtHqel2+JlRh06xzkl7
        PaHVyX56gpETf0FA8N14fO2+DhzAjdE=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2168.outbound.protection.outlook.com [104.47.17.168])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-29-Gpz_E2PEN2ezD-5D3GdaEA-1; Mon, 08 Mar 2021 13:20:54 +0100
X-MC-Unique: Gpz_E2PEN2ezD-5D3GdaEA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iluz0uaisXdHwvtpF5szt/8nS2y9ik/IbHM4yQTCQwwG0JsT7emcbn4Q2diRRutFUxbb+Ivc/M/eyFrp0y6L6hPiAZYdS7v0v1lEsaFbNEbGXAOGFwGG2nuOn2SK3skpil/60z5LCjf/r/0vR8t8p2DyJNLxbyTYc0H1pYF1Z6ami/oiE6vGw2q7OW6mC+aWfRj+Iq5bEqBcPTWfQ9AUuFa1sAoWzzKOG6svR0VXZ0+RPfE25Ee0TZbpCzuYJosKwNn9S9iz3qHJbrFLFXZeGSfMi6G+Hai7aqwTNM2iHgYIri7ykic75dmeHkQr49Ny/Bf80of1P5w+gAnImxrRaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cBQoSFK3Iw49+JMmsX3eKbeije319M2h4dI7j5gBgnU=;
 b=ZmnDgwFUaz7kS0cSg8L1rlCOVdFV0JW2S/t2GskzGxlZSRKKiKVdNdM5Z0vaCptbmUovkpTYi7Ad6A9NCRcROsoFC9UikdgJQDVZ7x7fquPR0r13d3Rkh6ZtjjkURdXv5ARNTsqEDekshSWjH6u1AcRDn7rruoFpdykI2JS08N34y1AGwkJeH09e/ROQaGmCGVlXXwPKwLkdeekZEmJhM7IRuag+MHtiX8oGSCAOGEIqz59wdm0A+HjSyWPm1+0CziDyLBtOvfCsuYLnm7WDclaXJk1Qges6EoeyOQIr3TWG9JfEZSOyCH54Nl1oxbiZ+w/ovSxYZ/+65R1KVnXg0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Mon, 8 Mar
 2021 12:20:52 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3890.037; Mon, 8 Mar 2021
 12:20:52 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     Pavel Shilovsky <pshilov@microsoft.com>,
        Steve French <sfrench@samba.org>, kernel@axis.com,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CIFS: Prevent error log on spurious oplock break
In-Reply-To: <CANT5p=rB2=DvjtpmVy803emWpuzsy-C2+d4wqQ5g_9fJ8+a5Cw@mail.gmail.com>
References: <20210305094107.13743-1-vincent.whitchurch@axis.com>
 <CANT5p=rB2=DvjtpmVy803emWpuzsy-C2+d4wqQ5g_9fJ8+a5Cw@mail.gmail.com>
Date:   Mon, 08 Mar 2021 13:20:51 +0100
Message-ID: <871rcpx2e4.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:70b:4a04:48fe:21ee:1b19:31ad]
X-ClientProxiedBy: GV0P278CA0013.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:26::23) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70b:4a04:48fe:21ee:1b19:31ad) by GV0P278CA0013.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:26::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 12:20:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 104a8006-467e-48eb-3dab-08d8e22c9db3
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3359:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB33591721A5D1CBF494E668E5A8939@VI1PR0402MB3359.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G/ZbvVVKZ3aU7/zH/ZZomReNfi5dvBn6gJ2O6fXrpxhSYKD2wa2+H5X6iVz3Ilraf6809tOET8JzBvUjdOrOLryoJoLlzI/BblIoFZU9RIBaghr9QIJwLwcqhRZ0G2hjvPGUtqey/mfJ7b1debmj7EGZSLJnPQxOcbMeCpRDgUbL3rv8AhCLJK13FNjXRd6jnaxSgqjOKguARUntFBPN5TYAd9DCp6CYSDnCzhSBWlYPMBJrCzuzfsuN8MXDM3gnOh9gwR2JQHV7zau7Ggg576F92l9tOTbfelvx2zuVx02rqlP4X19dx1d5Jt4qvP9Ia/KmlyR0Qj7rvEr0Cz+GbD8YdHQkED/LqmtbkTWcSYWZ+Zx+xUGrdWUYeOdVn1J9fZSaXb26jJkqkV8LZUMmkngRMq/c7VFZxJql8qFJYzLEHTzJmAXIk1L30NjseCbiKiB5U9y6j0iG5ca37W/vj0pxaL9j3AITPJw4MX5AWBYeeD4GDLDcGUSYgyXbqoGoRrGLW/V9NKx/pF/21E7ehg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(376002)(366004)(39860400002)(5660300002)(186003)(86362001)(4326008)(66556008)(66946007)(66476007)(478600001)(2906002)(36756003)(6496006)(16526019)(83380400001)(54906003)(66574015)(6486002)(8936002)(2616005)(8676002)(316002)(110136005)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RG9QcTJhTG4xcWJLQ09RNGlZaHYwR1JPUGF6NFpzRVIrYlpVU3hwZWNGSmlZ?=
 =?utf-8?B?RXJaSnJNMjh1cDJpQXNjdmVuRFZ6ZkNhNGJCU3pJQlBmdklQNWNVcGJVVDEx?=
 =?utf-8?B?Ujd4SjluVU1BSlVic05ueFdIZCtOTVduSGFzQ3FRUVhSQ3NWenI5L1RlTy8z?=
 =?utf-8?B?bUVnOXFOVTZhWU91VmVHZmdwRDdVdEcvWjJJYWlOTDJWenh1bWNXUTg3Y1lu?=
 =?utf-8?B?SmEvcGJYR3NWbjhiQXI0M2hUZGRMN0dLUWwyaDlFRTA4c2VqeU9FSUhvL3lN?=
 =?utf-8?B?SFNaUW9UMGJrTjBlZUhlTXV6MTdFV052dnlvNnJJT0tDdnlZbHFjODNSVHZh?=
 =?utf-8?B?eWtVMU9vQy9hOERybFZ0NTg0NW9PWFFGRnhoVkhjSTRNRVViQklEWFF2ZlFX?=
 =?utf-8?B?SkEwSk1GUW9teEg3WWswOWxlUXNrV2hRVHFDTGdDZVNiS2twRFovSURUejl5?=
 =?utf-8?B?N0Znck94WFlvYmkwMWtBVWNJR0V4Uy9uNkc2UnJVWXV2aThLYU02ZWE2MGVr?=
 =?utf-8?B?cjR3c29pN3lrL0dsTEJuZXMyaU1hb3JSSi9KeGFKV3BNY1ZmNkVoWTJWUTBE?=
 =?utf-8?B?ejRYMzNudFJEV3BwOXB1MlRpUjZqc04vK1JmTkFJdE1aeEx2dDVSaTkrOUxC?=
 =?utf-8?B?NDE0aDJEV0plZC8yaDZnOTZCUSs2TTZKU0pzMTFjb1MvTnM2UllGTkM0Tk1I?=
 =?utf-8?B?SnZBUXY4L2F2UjVmMXVxR1dIL0JYTzV2eGNKT1RSRC9OanI0Q08wdVlhM0I2?=
 =?utf-8?B?Vk0zSzJMQS9PYXFCenpSUUcvQjlUWkNjVUxrOTh0SzBuWFErTjFYcE9TWmxO?=
 =?utf-8?B?cHYwME1wUXkxQS9KN0RyK0hoRnJvZ1g2QTVXTFI4K2V5MXEwSnpja2M1SnFN?=
 =?utf-8?B?ZHVTSXRXZFRaUm1pTzZUUG5NYnhtZDJTOUszUFBkOHV2bTdxaXFCMzgzanhx?=
 =?utf-8?B?NzZwU0RPaUFzcS94cjhWSHQrRVVaQUZUa2g5WWpoRHVZUkZybkFoS1RQN2hE?=
 =?utf-8?B?ejg1cmFVRkRxdUp3SVhDUFlJU0ZzU3drNjNzeVpZYXdIV3pWZnc4ZCtBejlX?=
 =?utf-8?B?OEE4RlU3aXRsYkdZQmgyd05Eb1M4TmFSU0h0Nis3Yi8zK05uTEN1MzhsMllr?=
 =?utf-8?B?Y1NYMjROZ3p1dDl4YWZ2bE55VWp0eG5BMnFHaEFiUDA2Z0dPM2JEV0NQMmRi?=
 =?utf-8?B?ZDNuMXV0Qm9OT1RLUmJvNGUrS2VldnhNZVNlaHRDT05IWnpuVHlkSU9rQTZv?=
 =?utf-8?B?Wi85RFlsSzhuMmI4bEpKbm1oZUxHVHFjS0VJcGY2RHlCdnEyNko4MEtISDBS?=
 =?utf-8?B?V0ExYmUrNUVaclhsZnVyRi9LRmszSVc2MTJOVFE1K01rbDRqbVczK0REUnVQ?=
 =?utf-8?B?Mi9WUW5DMTNUNmJJb2NFc041TTVCRzQrdG9Wc2dQSlo2OUU1ZzN0SlVLMDRz?=
 =?utf-8?B?L09TRkFFRDlCcndtYnNWVzNoaWhQc05sWEl1RGJXTVNlcjdZTUUxdGpIeUx5?=
 =?utf-8?B?bk9BYk96VnNGNUtkQ1A5MjJIczd2dVorQThDSTFsbzI5bU80NHg4V1k1eUtM?=
 =?utf-8?B?cCs5ekZlaUNnaFZkazdaZjZ0NFFmTktmQkQvNlMvQmlCUnpFZzBtckl6YlZE?=
 =?utf-8?B?b2hBSGhXZmZEbEdlbjkxV1NPakUveXdYVjQ5SnNPMmJ3UXRXOXJRS0tsdC90?=
 =?utf-8?B?MUVuOFl4OTdxTnA4NTVMYzZmYUZXYVhmeVdQcWRjdUpvQ1pEdTI3anJkeHVy?=
 =?utf-8?B?SGRHbHoxQzVsWmhTQUptZlVBTGpZTFhyS3N2bW1aeUpEdEpRMlN3VHdhZ2Vs?=
 =?utf-8?B?dS9qN2loRWtwcWp5OEZkK0lXMDN5aVdyaTh2UUplNmppakJrNXhiVHhGblVB?=
 =?utf-8?Q?NxLwVE4+ym9y6?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 104a8006-467e-48eb-3dab-08d8e22c9db3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 12:20:52.6272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gnM1FWHoZOr8NSBExFNR+O/u4vtEJ1eLA60VHtrwonFlWn9cr+fDTn72ullOfhTi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3359
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:
> So I don't think we should be changing the logic here.

I would tend to agree.

> If SMB v1 had a different behaviour, we should check if that is as per
> the protocol documentation. If not, change it.

I think the main difference is that SMBv1 doesn't have the concept of
lease keys. I think lease keys were added to handle cases like this:

case a)

client: >> send create+lease (key=3DXYZ). I don't know the file fid yet

server: local open & concurent open (create response not sent yet!)

server: << send oplockbreak key=3DXYZ
client: dont know the fid, but i can match the lease key with a request
        I made, so it's valid

server: << send create response (fid=3D123)
client: I know the fid now

case b)

client: >> send create+lease (key=3DXYZ)
server: << open file, send create response (fid=3D123)

client: >> close file, release file ressources, send close fid=3D123
server: before receiving close, concurrent open happens
server: << send oplock break (key=3DXYZ)
server: << send close
client: depending on the order the response are processed, I might not
        process oplock because i don't know this file! I already closed
        it. But I know this lease key

Without client-generated lease keys you cannot match things you don't
have an FID for (because you haven't received it yet, or because it was
closed). And FIDs can be reused and point to different files.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

