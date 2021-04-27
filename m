Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F59C433B4
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Apr 2021 11:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5847613DD
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Apr 2021 11:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235446AbhD0LrT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Apr 2021 07:47:19 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:21033 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230365AbhD0LrT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 27 Apr 2021 07:47:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1619523995;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j0yW5E/+Eh2c0rn1HNinLWz3ZTTHbbP3XqD7PeRzTFY=;
        b=M2tTVXna1aGqIWjsMiKWeoCa7L3hczjQp4jdNbUKGvVW86et2kiH4PTWejJYE8QYWe8YA5
        sRxqm4fv+fAN0SHZvKws7X3LIGF5dX+jyFixw6dckXCt67/ytfbdxClPxImxqigT/Icnar
        C8iPwxwuelVyA88aaab5wWmydsuW0/c=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2052.outbound.protection.outlook.com [104.47.12.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-36-xet0aENWN0KFI-4cOEub8Q-1; Tue, 27 Apr 2021 13:46:34 +0200
X-MC-Unique: xet0aENWN0KFI-4cOEub8Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jeYkP6Ki07UdZu7sKnRmbjreVY4ik6P16AT9Ro55Zzpq9LLWGq9cUtoN3min73UQaEQ60hqv6qLPI+qqx9yIkTSQaVkVj7iL8MWGnGpgBDLqsrYgM0EBxuZbTPzXnVc78BItYLnQZo57OFCMCPe4IwcYo6IxRMZ0pG83TvhWdCnko7lX345Mq2IOj8/bsitRf8zUcYQYI9BS0XjCYUhRVeHAPsmeIi7n77TzdPC+uDUAZbFkuo8G07nlfVVkCEor1D/EioEw2nrPdrl5VIdZizfRMjyhhWt6RCDK71YPHMBMo6c6SR6MVllA7Z1qJkmM9lbdLncoHOlQMXmkp4ov4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j0yW5E/+Eh2c0rn1HNinLWz3ZTTHbbP3XqD7PeRzTFY=;
 b=STpE8mLQJH5I0AhWucVPI5Y/n304ScCrvhD3+rhK8gB1IuBnf6TCU+9QMYIPzxpmcG/3SNlVY8wSWMY6ZdDGgkF4HkO432YtXvxgu02PzIBb7CM7W2SBjE7J76xvD9gMy5Sr/JVcc6L3g1AUfhTUCvboY8PfyBlmkKhXolejR104h0pxigH9I3KJ15PNWUnYzmbbJ9j7EIq10liDHHNFLOHJOYzCEQcePP6ES7whiP7F0Vp349jbuESwrWCI8GzGv+L5sRX5Xyz646W8p+nXLbD8m0hG8RnLCiQopw3lDZHdZd8gQkznValSJYcXHpefTau9DDR9a3fLMsjZ5cYzKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB4063.eurprd04.prod.outlook.com (2603:10a6:803:43::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Tue, 27 Apr
 2021 11:46:33 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4065.025; Tue, 27 Apr 2021
 11:46:33 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: oops running test 130
In-Reply-To: <CAH2r5mvHQ63Sk=GUT5EdEHMT41SznR7dYQqFk_i+W4x2jxtwYw@mail.gmail.com>
References: <CAH2r5mtfw9siVqpj4Zu3ayvo-4s+ka90y3fn5EFYLnBK6psReA@mail.gmail.com>
 <CAH2r5mvHQ63Sk=GUT5EdEHMT41SznR7dYQqFk_i+W4x2jxtwYw@mail.gmail.com>
Date:   Tue, 27 Apr 2021 13:46:30 +0200
Message-ID: <87im48vtk9.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:3855:41c0:bae2:e87d:86bf]
X-ClientProxiedBy: ZR0P278CA0055.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::6) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:3855:41c0:bae2:e87d:86bf) by ZR0P278CA0055.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25 via Frontend Transport; Tue, 27 Apr 2021 11:46:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9cd9c478-c390-425a-a108-08d909721aa9
X-MS-TrafficTypeDiagnostic: VI1PR04MB4063:
X-Microsoft-Antispam-PRVS: <VI1PR04MB40635DC9B3DA9AD2582E16F2A8419@VI1PR04MB4063.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:576;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vf6ixglIJUGWCj/FI5+U4emTzplVqPcyYRZXE/IdsxgSCEYUUr3ru4n1AGsxZFlV8NcTpj4bkWNzBZ4oo8B1snVSWP7riHk3Hb9Vp1WsODF5QiVm/jkl/rDe4IaoV7cuUIFTlrHo7oT13FrhnoMklHmoYyRECMkkIRIOszdBzdPf31/qaNz+wz4unho/kYeLZVPyOI1AESRp+7vo/LhU6csYBYFFKD3krbFR3c/LHSAmKWTIvyn2fIiIhUTC0DZxNpk1v7BqGlbh5befXMDBHKLwifq71qpl7QupjL1l3L2PidDHkmYePyHjsAmbm8ahJ7vjzUNbo3a5DWyhgh1UIIrjs748onVWSK+nFaljo0uVsXT/4+lDDUJL7q88a3WzUMRkMp7DuYHcy3v8rFr7ypr172Zq/L81cGxQ4w9s4DGKgX2cbfrNOGuaoTA6j1NLY4+BgrAzMjP6V3hJQqh0lfMhx+BfRzm0K+gfXGyhhuaqWBiG00up3q+0TsdwMdU4scIOPD6U02OpL3CA/kP20gyVf16LPPj+3eMlhnEJ19OG+4MLhyS6W5fhABtyqCmJFPss6nrmNC0C7CShRPQWZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(366004)(39850400004)(396003)(66574015)(38100700002)(36756003)(8676002)(5660300002)(83380400001)(110136005)(6496006)(478600001)(66556008)(86362001)(7116003)(52116002)(16526019)(316002)(2906002)(186003)(2616005)(66946007)(66476007)(8936002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WDJWOTNHdlc5R000NWJnR0dNWXpJK2FQSFpkRXlkU01oRTlVTnpFaUUveE1U?=
 =?utf-8?B?UjNlWkdFUW50Q2trbnhHdlhEZDd1Z09PU2VhTDRXMFhsS0gxTlFHVEtaTCsx?=
 =?utf-8?B?VFQ4WFIyS2w3TnBRaEdqWEJzbnpqQnBJSXZCUExDZEp0Wk9HWml3ZjZpaVAy?=
 =?utf-8?B?TkZaL2hVamJKbHVTR1l2NTE1UDJKalJrNXA2N1JLZnpqRVVCWWgzaSs1dFZm?=
 =?utf-8?B?VmZJbVdLSTdhZHlKZTM4U1B0MitweTg1UEw4V0JxUFFCcGZwRG9vOUtsd3ZI?=
 =?utf-8?B?ODVtaTBjdnJrYmJHd1MwbnNxUUdOcXMzZzhvcjY2TXVHbUpwNDY3RVQ0V1Ev?=
 =?utf-8?B?WlVMUkdSTWk0dTc4UzMwNldNam1nNStVRXltZUdlSWZSN3liYlBoVGNsNkQv?=
 =?utf-8?B?SnBXN2wxUkIzWDRzYUd5cUNIeUFBTE5yc3IrRGtlVk5RU1BPMnFnUUx5M3dq?=
 =?utf-8?B?M1l0N3pUR3RvQVdLb3JEUjNad1Y4RnRoQXJHZW5uSHNxdjFUWkQ0VHJqSkxO?=
 =?utf-8?B?TmRUYWZTc1I3MUVxaGlQVnVndmg2ejVsKzlvaUV1TGlVZkpMNU1QMVpXeVd4?=
 =?utf-8?B?N21RN0ZVa1FTMldGeEJCMk41OVVlMkNJbnp1eXJmditUREtHbXNrNXJ5MzV2?=
 =?utf-8?B?Z0ltWUZxbnQrbkQvODdoYWk4bGpZYnFWQWQwZWRGZFdEbGhrM09hWE1xVmVE?=
 =?utf-8?B?b2YyaGtCdUtRZW5NeHJjcUZobUozbGcvM280cW8wRHBsMDBXdE9WR2JxYnRV?=
 =?utf-8?B?ZGJpNjdCVzVRdmY1T2dtSWxKbU1HYzRuME1wZGJwemRDeldySUdPMnBXZUNw?=
 =?utf-8?B?UFJjTmZQMkt0ZnRlK0phQ3pHUm9keHF4WVVSRWJlZkJQR1ltcmQwVXpnZGxs?=
 =?utf-8?B?bWZpNWgwcGFWSzhpamh4YkdGWnM2emhsM2orRFJrUStsaUtFQ2VDVlhkVUd4?=
 =?utf-8?B?RHdBelpHVmV3L3RkaFg0QzJRYmx0REJjZXJjZ2d1dXVoVUgwUlE1MUJWUGMy?=
 =?utf-8?B?dG5QOTBmTnUwYmxtd0Fyekt4Q0FNbXVIbmxWWEg2c0ZCWk85S1h5WTBZNkRY?=
 =?utf-8?B?TzQ1c09IY3c0K3A4d056OGR1cUFVYnE1L1RHN0ZJYjJuZ3l1aDdGekZHYUYv?=
 =?utf-8?B?aDY2SXZxdGl1cUtnUFRQOGlzWkpXRm5WaGhrU01reEFXNXA1d2l3VTMybHAx?=
 =?utf-8?B?WVUyNDZFTzFzRndXT2E5Y3JKOUFMQlhWSDdvQTA1Y2RWTHdZcm41Wmd0QzFU?=
 =?utf-8?B?MHVSazJqU2oraGNkOWZjdVNQYkxmRTVJcEtzbHFrdmlZM2RKZXhFOThBenpI?=
 =?utf-8?B?OVcrRUVuK1FWMmhsMmtNSnRIN1lZZzdReCtrMTNEQ2pXZ2dMMlI2QmJpOWJr?=
 =?utf-8?B?YndqdTZPNjY2d0lXSFJUUm5hRkxqbW15U2RvOHhQZ1hBYUxyWWY0OGlrcDBi?=
 =?utf-8?B?R2wxMXUrbExIZk0wU0NzYjNwZE9uaGZiUHFpd1c1dm5GUlJpUXZkZ3hUL0Qv?=
 =?utf-8?B?RllLU1lKaDJrWXJHcVhJbFRvc2t4SDQray93cGJXdnpqZlBBZUFnbEJheUQz?=
 =?utf-8?B?SU9LZ1VXbTNqSEFFS2UxVEwvK0p6RTFCNW4vemppa1dHQktYVWJqZVFhb3Zx?=
 =?utf-8?B?RHBEMXEzYlRpMU9vT01ZMWdDdUJSUVdVVEFFME5jMU5WWFFTR0F2TWpKZmU4?=
 =?utf-8?B?TnVBL3FzSTVmajNJTWd3eU5XNmxRR1oxeklDcDR6V2JJNk1aSzRtaGdOalpU?=
 =?utf-8?B?V1lDN3d5YmlNTjg1bkptYlZVYWM4OWw4OU5QOStTSHhlbVE5eWtPMHNOdmpy?=
 =?utf-8?B?di9KcjlIL0xTaTMrcjNlWEJVdW1iSGFJVWMzNkswUWVGVk5oU2JZZEZWTHpI?=
 =?utf-8?Q?bwzO5Nw9p40jT?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cd9c478-c390-425a-a108-08d909721aa9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2021 11:46:32.9471
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fw1B3wP216xF8Ke6PS6Nip87eVwgPMhqGL7Y8R6nANqnin7Y5LLiA2LEddjSll2j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4063
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
> And note that rerunning the test with same config and same target
> server 10 minutes later ... I did not see the oops

>> [ 1967.512902] refcount_t: addition on 0; use-after-free.

from


>> [ 1967.513069]  open_cached_dir_by_dentry+0xc2/0xe0 [cifs]
>> [ 1967.513142]  cifs_dentry_needs_reval+0x6e/0x160 [cifs]
>> [ 1967.513173]  cifs_revalidate_dentry_attr+0x30/0x340 [cifs]
>> [ 1967.513201]  cifs_revalidate_dentry+0xf/0x20 [cifs]
>> [ 1967.513376]  cifs_d_revalidate+0x50/0x130 [cifs]
>> [ 1967.513408]  path_openat+0x794/0xff0
>> [ 1967.513412]  ? __bitmap_andnot+0x26/0x70
>> [ 1967.513415]  do_filp_open+0xa2/0x100
>> [ 1967.513419]  ? __check_heap_object+0x5c/0x140
>> [ 1967.513421]  ? __check_object_size+0xd4/0x1a0
>> [ 1967.513425]  ? alloc_fd+0xba/0x180
>> [ 1967.513429]  ? do_sys_openat2+0x248/0x310
>> [ 1967.513432]  do_sys_openat2+0x248/0x310

That sounds like a very likely regression from that commit:

commit ad7567bc65af
Author: Muhammad Usama Anjum <musamaanjum@gmail.com>
Date:   Thu Apr 15 20:24:09 2021 +0500

    cifs: remove unnecessary copies of tcon->crfid.fid


Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

