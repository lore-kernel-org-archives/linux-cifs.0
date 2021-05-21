Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E191C433ED
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 08:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1198161132
	for <linux-cifs@archiver.kernel.org>; Fri, 21 May 2021 08:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbhEUIod (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 21 May 2021 04:44:33 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:40526 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231779AbhEUIob (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 21 May 2021 04:44:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1621586587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4e/scaqEmpvXWy7rdtlUb/CsfzTol91llwKIskKu/ks=;
        b=V6jfOsU8XY01l1n5XY2GMG4Wf78cZiLaJAijMU86xsmePQu7M1DelAaXJKN2Gn+uFY10tv
        qM5TnzyRNRv41tLdwaU80+pzLGqfy0mD685K1KLZPmpG9tCkqjTj/mnBKJCJhnfIqK8PW0
        7xriKRCTrT+/kBmutNnZkcY8j+FVVxg=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2177.outbound.protection.outlook.com [104.47.17.177])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-3-MUAKlSxtPueEFtbsz8kX3A-1; Fri, 21 May 2021 10:43:06 +0200
X-MC-Unique: MUAKlSxtPueEFtbsz8kX3A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B0cNbOK7RZLWkJyqxXAVNUob+NVdcifuet7QJ0VHaZRdqjkEtFf+98gyHuZppG1eFo63rw2QpIdJ+blry+OsxKR+V+4Z5JUcC3FDMd5wC+CtBJ+uBoXrpyIeJcCvOPTmlOEJU9JGivdl8FeqJ8XRCF9Si1Gqe0EOCKT1vczDv3Q/KO7+cbBGj0dnnVUxcaaHYxesmFD5KFAAZl7X7QPYuD2gLdb6h83PY0FguqZriHC0yYCCxg8THY7ryJYYbGIVMSqBKwCqyr4k/xVroSgj/O7F0rvwBtoJkZEgFP3soxwGzpvVCgaRXb8SJXM1/S1BxNzaxCroS3C554m03YLhbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4e/scaqEmpvXWy7rdtlUb/CsfzTol91llwKIskKu/ks=;
 b=IS7z7kCHmv3tPRU0Jg7z3pvYT4Ui+OfVacpNkyq9vaxnN3KYSvt8Mb9XJMT/YV6sy87HBZlTMT5qdC9P9dbnMfcNiu8D0t2UiTb19Otrog95mtGErIJzASY+mFerZ2/HZrzXeHGtc+oU3b/pMVEh7PBLH2GaBp6KI3zjYiL1cL5RuSQBXX1mTUoT54KtROwYHuY6Ge3tUnkzjdRROSOP4DO+PU3yfFmXkYpryUAov2CxFsHt/nKbiQhr9I4YbJAfKf3N2tbv8w17lL7fMS14nSVxcw1OBa6wAVxzDzEHQVdiiNJienl0P6Oq/xnUR9TN3HP34CcIXemm1SstEByYDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB5392.eurprd04.prod.outlook.com (2603:10a6:803:cb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Fri, 21 May
 2021 08:43:04 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d%6]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 08:43:04 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Hyunchul Lee <hyc.lee@gmail.com>, Steve French <sfrench@samba.org>,
        David Howells <dhowells@redhat.com>
Cc:     kernel-team@lge.com, Namjae Jeon <linkinjeon@kernel.org>,
        linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, Hyunchul Lee <hyc.lee@gmail.com>
Subject: Re: [PATCH v2] cifs: decoding negTokenInit with generic ASN1 decoder
In-Reply-To: <20210521020051.196434-1-hyc.lee@gmail.com>
References: <20210521020051.196434-1-hyc.lee@gmail.com>
Date:   Fri, 21 May 2021 10:43:01 +0200
Message-ID: <87o8d4qxyi.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:d396:524:65d3:25:9e8c]
X-ClientProxiedBy: ZR0P278CA0085.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::18) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:d396:524:65d3:25:9e8c) by ZR0P278CA0085.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 08:43:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 317da4f8-39f9-4985-6087-08d91c3472dc
X-MS-TrafficTypeDiagnostic: VI1PR04MB5392:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5392CADBD4E8853E908EF0B1A8299@VI1PR04MB5392.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 44MnZZ9YTXBMtBqM3WE/Rq4bU8tE5neUKyDgUi41DPLm6rZDOYzW+q5w1cTQAp2LzL0U8uH5zWGnnfldHiItf3M/Ta0QGRnAL6e2UcE1TwyMEqBXO3JD6kQmLsqhc3Zw/F/eQN0E9VNRR+2s+pegALfcriYlCIt0wBIBhe3Yo3cz/8KM4XHJxMo8IgjXAfk0p8cDmshG0oumsOfLm4rqn8W50NQKdGIZcELOvzXXgWAXsn6wa7HDJOkBfDSeD3L6U77Ok6ctDH3zH4OFZrO9DABnB37tIStg4zl2u2mhHH20HHhJq775Ny3XKUwug6IE5QH/4pj2HZVQIhoTXdtdF58KpLTEd3uKf3fWTB4lepUS041mKHHInuKQ+dyuXKuyQ/e0zO3lixwD/yCDBKziilif5/DjpDXA9vcfxGnDQ1gK7zWR7AZhAczUlmPXVUrqnKwzu5zvs2D/iU1bykKcq3YbkJ7w6fp0nUajuOr6Z1NpBc7V4hZ/aQZUV4EVaRgSPST1F+iVeHhQX7VFw2Ga4OD2xijjZXsVgg3Is2ShELv7m6AaAURjcENwVWVhZ+2tuViV79kAPEZsNfFPfk47PCJsALP2xu5HWYT503ajwZOQKeCrniZyXMzwHLqhvyI8u5ybens3N1x2WP1GFr3zAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(396003)(366004)(346002)(36756003)(52116002)(6496006)(2616005)(2906002)(6486002)(83380400001)(86362001)(66476007)(66946007)(66556008)(54906003)(38100700002)(316002)(4326008)(110136005)(478600001)(16526019)(4744005)(186003)(66574015)(8676002)(5660300002)(8936002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V0M0c1RUWldha0U0cWNMdUdZZU5Ba1ZzQmxLVk1hRDVBNkxURENQakl3YWVM?=
 =?utf-8?B?c2F3ZHRBRlBJSlpMbDFBUng1Vll5NFhpanZGMHlyWnB6RXlheEJoLzEvRGtE?=
 =?utf-8?B?MW13U1c0cHdIamRkZUY1ZWZ3MVJFTCtsUFBXbzIwMjBoNTEzUVFhTjJjREFM?=
 =?utf-8?B?UVkvUjlDbkRsL3lMRWprU2NnU200RzVZQ25RaVZkTGxGTVMzZGRrWGlGcDRI?=
 =?utf-8?B?ME9aWEk1TnhtdUN2N2JCajZCZjJFOWQ4UnlYZlJzaGxnMXhyUmF1L1NsZ2Q1?=
 =?utf-8?B?ZW1vMnVSS3JLcTJqenhOc1dNV2tLTmFpRmkrYXBUM0Fyc3NxQ1VuMnFsellX?=
 =?utf-8?B?YytFYXpSekdZMGNBZU4vZk1qMW54dC9mbU9LK2VnSzZaOU5UbndHbkZnVXk0?=
 =?utf-8?B?Y3dXK2VQUk0vS29hb3JQdnVVaUF4VjZUbFJKWHk4K3pVWDRWbU55bVhHM1J0?=
 =?utf-8?B?MUJhWEp1RGxpT2RyeU95b2RCeVhYc2x3VytiUjdIb2ZmOXpvWEk4ckdxSU5M?=
 =?utf-8?B?Nzc0bWFEUWhvQWtydDg3d2JKOGpSOGc2Rk84NVl6ZUVOdDJGYmFBaG9UTWV3?=
 =?utf-8?B?K2F6SjdFb0lvT3hUYXI5eVdiRnJUMGwrUzJMaEMxRVRINk1OdGtDNmhhUEVx?=
 =?utf-8?B?T3F0ZnhGSkQwZFpYSkQ4MGtpelBwZDJGS2xEN3JwV2k2MVh4M3R3WlJ1TUhX?=
 =?utf-8?B?Vk45Tis0ZVh1RDg5akVETzU1R2pOSjV2bFlKYUV5Z1pQWEtQeE5tenkwaVVQ?=
 =?utf-8?B?VWtiYlNQWDZzZXhTc0ZtUERzRjA4blJST2pPN1RKdjJYSjlVZWo3c0hzMUNh?=
 =?utf-8?B?VlZseHJYb3FZTXA5cU42RXRiZXRsVXY1R0wyaVhVR0dLaW9SbUZ4c0g2R1hV?=
 =?utf-8?B?VHJ4UlFpK2ZGUFZJNEEwcGZ2SUFmZ3FTOGNaQzVKczNXWUhyZzNSWlNrV2F1?=
 =?utf-8?B?YkxyMFdLMmlIaGdXU2tEZ01OY3Z1QThCd2tzeW0xZm1pbW1jL0JST1pmbHE4?=
 =?utf-8?B?bGhEVHE2SktZaExmTW1IVXdkdFc5S0FvbVEzcFdaekZlSU1raTNPU3Z6YjRN?=
 =?utf-8?B?N0FxaWRKbTBGTGVaNDNxUXVMMkYvamwrNXFxeGRRbjdUNHh2QXpya1ZJSzFm?=
 =?utf-8?B?YXlSR3hOTXNvWlVSTWFvM2FoT0xGQUJ5Uk56OWoydS9tUDBtdzJGR3lTc2dU?=
 =?utf-8?B?cWlhWVpGLzNXVzV2ajNlY05RbjB3QjJ1MHF6dEczUDNwczAzd1FDOGpZNEVZ?=
 =?utf-8?B?Rmx5M1ZtZ1F5NiswanV2NThIdzNLSFp2a1VxUVZYa0h1ZXhVaHU5UFUwYXd2?=
 =?utf-8?B?YUVHWitJdlVQTHNROEUxZWJESkhaQ0NzMzRCZisxRWFBaExYa0JWQjhwNHlm?=
 =?utf-8?B?VXZMS3ppRUJCK29pMVBEZ1ptNVM1dStPazJQUU1keW13eXowKzR6N0oyWVhi?=
 =?utf-8?B?U29jTWREZDZGRXE4WGsxQ3pHSVg3MnAxeWs2d1F3M2ZFMnlLb3J5QjhDNkRL?=
 =?utf-8?B?ZjN2d1UzeUNlbE1jUWRkdG0wNjFZWHJQNUNHcytGanh0bnhybUM4UUNBUGd0?=
 =?utf-8?B?U25LRlJ3bjhzTXBsK1AzYTdCcEF2V2UzZytQa2NQRy9OcDVaOTNWWnBNQ3FW?=
 =?utf-8?B?eEY0NFpISUNxWnNJOEdQL0hVQy9EdCtHTEY5MDV0bjdWU0EzNmFjWHVMNXN4?=
 =?utf-8?B?dWVVMUVMaHluRUVRcTFxSitKbUZVWXVQM0lBVlB3Q1BjMDJnSUp1T0RZcUJW?=
 =?utf-8?B?NlM4Vm9uT3VrNjNXSUtqMnpsaHZsNFJ4SWR1N01jSi9JUnByTlgxOURZQ00x?=
 =?utf-8?Q?r1po3rdRhz4vvcOULEzH82pwbp4c06DuaQeyY=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 317da4f8-39f9-4985-6087-08d91c3472dc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 08:43:04.1957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: apVMKv+fPgp77BDTJU5UojP9yYXHRCjdk+EC/mMnCjkBsrk4qF87bZw2GxIvOEuQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5392
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Hyunchul,

The existence of multiple ASN1 decoder has been a regular complaint,
this looks nice. Have you tested it against any servers?

I think we need to make sure it works with Windows Server (including
increased ones with the increased security flag, Steve do you remember
the name of that flag?) and Samba at least.

There is the SDC EMEA plugfest coming up, might be a good time to try it
out against other vendors as well.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

