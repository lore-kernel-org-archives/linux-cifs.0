Return-Path: <SRS0=0UGd=IG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43340C433DB
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 11:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDE7565132
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 11:52:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbhCHLwW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 06:52:22 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:37354 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230486AbhCHLwT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 06:52:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1615204338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cdJR0Ir7ZC3O0I/HBHy4gDqy/pzakzQHS8qRLTv4Blw=;
        b=N9tqiTbV2wlp+G/QzpEtGIGvHL3jkghXkGbgK5p2/4c0Ww/1ovAx1t5/0+TraNtr9Q0VAJ
        FdP5j4v+BeJqjWPVM+vJeNDlzdyatklzwgDxE2NQgsro3ybis9ZU73Ltb9hd9TJliob/Q0
        r5YakuxpTBU7L6Azt9dEZ9zjtPUWtfs=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2051.outbound.protection.outlook.com [104.47.13.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-18-MFZVvlJwPhWHJ6s2nWT8dg-1; Mon, 08 Mar 2021 12:52:17 +0100
X-MC-Unique: MFZVvlJwPhWHJ6s2nWT8dg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9bidSTZhehTYD10HqHk1CbSjBuOundQHrXZqetBx1iKf09Vi4xOxflciCyJD1npTQy7dqfmAo3pziFSnr/7eMHs7KR9SptvMxGp2+gIzpQvuqTp7W+VxIvRVxc8xdAqsBJ4pAHEhItChwF6nbUqc+KKyamyc7IKUpMREjbi0sk7KWNkDodWEZOQt5C1T7kuCy5p6CwzGNtgaXCDNt6eyzv4DfGKaIi+X9pJKgODLeYYBTOhPPrB+fFgTySaXCT8Oj3sK0NFGlLFSkhwDiutzimJ8dOpsCUNTjpd9ML+dIgOduXwnVjEQF6pZhHO72/w9w4ctNAzYkI19uFF3gfL+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cdJR0Ir7ZC3O0I/HBHy4gDqy/pzakzQHS8qRLTv4Blw=;
 b=Wwdb4nZP4Z2B+xke8xePzgLGAZ9y0zUbGbYwGFhyIjD6H39hrp3PVejYViFmYfq9omoA9QDt2j7Z6w5q9YhK9MOy5gu10sW8338bAwKFikK0FIRg3kJ1xlnsHUhutcV/xtx/wATqMb2VEjevbJgJ0F9CeMjDSpK+xHNh4tptJRiFtcbPD15fnBZqy17I1ZY6K4N4E0RQljLPFje8KzikldrUioo35BDD97LnOCs3+22tFlVyga0vPvLcC8qTp1aIjOHELsPrDbpXTWyNTzNdcBqn7Gzp+hyqEb0LKIN9uX0XbJNzz70uf3h9xWJh3TGU/jaSxm2yZMwuajbPzeIvVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB4255.eurprd04.prod.outlook.com (2603:10a6:803:3f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Mon, 8 Mar
 2021 11:52:15 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3890.037; Mon, 8 Mar 2021
 11:52:15 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: try to pick channel with a minimum of credits
In-Reply-To: <CANT5p=pzh7a9v1q15m056i=cN-MC4W2W2Lx3P68itHzd5EQnnQ@mail.gmail.com>
References: <20210305142407.23652-1-aaptel@suse.com>
 <CAH2r5mufnuA4cavG8JYq2q+-9kY3oHeoQrLyzeXgN2xFQ8P6_w@mail.gmail.com>
 <CANT5p=pzh7a9v1q15m056i=cN-MC4W2W2Lx3P68itHzd5EQnnQ@mail.gmail.com>
Date:   Mon, 08 Mar 2021 12:52:12 +0100
Message-ID: <874khlx3pv.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:70b:4a04:48fe:21ee:1b19:31ad]
X-ClientProxiedBy: GV0P278CA0055.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:2a::6) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70b:4a04:48fe:21ee:1b19:31ad) by GV0P278CA0055.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:2a::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 11:52:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3a647ee-0e4e-46ce-85d3-08d8e2289de9
X-MS-TrafficTypeDiagnostic: VI1PR04MB4255:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4255C83DAC8DBED12019C521A8939@VI1PR04MB4255.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3YF/jmtcfeCAASJB3fhkGcwmH1CUwA0DiTRNpyXVK11jiyxMHx+AIaJ4Fsj6b6BJ2MS+zxMGWv89LIU4uObG32/maHUw4vvbledLHnsFEb42iLCvFqXfMRZ4KsdHIQSOh9ol+K+09LdKluoea+OPaRBEOGHu52v1bIsqRFnMW98HWo7D/bTp48AnrscJsXLKALRUC6IhLPcScxhkzNhdZWCnmRKza8M4WcreEoGUhuNJMSYaxvE7TfBvf+Q9G8PoDQW7msssCnauElv1gC9Elnl3ENX8MKZavik8S5aIRQEwqH6gWQATfP1K2xFSqLSUwTTtzmdsZYTxnPn8mRUjjReTXZmUjIKWrgzUEmUUEfD9NtqSENnRJ4XobqgEDJOAQqCys1aZOIGOAiUKtOt/+BBhAllHZ3EA0HyOqJZmwgKRrBAZej8I6hoCEpDvmBUp/Kij+0GoZ9eclaQv8xQ8WjXmSLoiey7fEPqsEdMsVDDU9T/iG6c1yljJhTADzv3UiVeqWeLol7f30rCvT1QBUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(366004)(136003)(346002)(396003)(66556008)(66476007)(2616005)(8676002)(4326008)(6486002)(478600001)(36756003)(8936002)(186003)(110136005)(316002)(16526019)(66946007)(83380400001)(5660300002)(52116002)(6496006)(86362001)(2906002)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y1FZYjIwcUMzMDNDU05WUi9nNUE1VmVDSFdJamYyRFRIRUJvZkplMDAxM2Fi?=
 =?utf-8?B?OGFJV01GOWZLdFc2WUdWSzNOTWhLdmx5OUl1L2MxUkE1SVo0WEVGdzVzVy9q?=
 =?utf-8?B?S05rNU8yMmxPdWMyY0tEWVA1SUJCUFhuQlVoOXFzeEpmOEhBc1BUWk5KamVw?=
 =?utf-8?B?S1p2SEp2ZU1TRTZpTHZ3M0YzQmI2UTBnNDN1U2NlWlVBeWlXUGE0cW9DZlZR?=
 =?utf-8?B?WEdmb0NDbVA0UmJkNmo1QWpwVlJWYSsxazFDNnhZemtyRUlnZzhSbTN5UU1l?=
 =?utf-8?B?N0RvOWloZTVjQytqd0lwV3crTU5sUTgrd3RMUXR0QmdNL1psR1VPUUZERlNs?=
 =?utf-8?B?SnZFNUxLd3d3QVIwdm5aRzhGbHBCeExiV0J6RHREMzRHZmJvYjN1U1AzUFp0?=
 =?utf-8?B?ZndHVkRzNWMwU2I4VTl5SlUrb2xBakhnSHZHY1J0MVk0UDMxM3IyT2J0TUdM?=
 =?utf-8?B?dWJPWTdzNmQ1cVpCM1Q5VFFnV05xY09lK0pSUExmVjdvVEsrdzZJdERUQzRN?=
 =?utf-8?B?Q2o1LzllRjAwcVJwTTRFN0lxNmxGL21DNGw2dW14NlY5SEJkaWtzSjRoMkNX?=
 =?utf-8?B?NWhISkgyT1F6TEpXRXFOY01PZnFBeWhzcWd4R3lWK29LNnFPbXBPNXhvRUZw?=
 =?utf-8?B?UXlodkpXdDdzYTlsQTZuSEdDUmZMOXMxeVBDdXkvVVZkWFUwa0R2U2dvMjlZ?=
 =?utf-8?B?ZU9DRGM3U0VNQ3pUcmhuV09WbHZ1ZE1CYWFRSGVpcmZPZ0lJckZ6NzAxYmxQ?=
 =?utf-8?B?K3N1WGdVYUIzU1ZwWUZldUhGVzFkVHNrMjd5Yi9kdjZ3SHBRdE41dTFvN3F0?=
 =?utf-8?B?U3c2V3RPaU9Ub2d6b1NiRHYzUkhJTW4wbXNlUy9nOHFKV09Na1djUFdDTW53?=
 =?utf-8?B?NmlodExIQkRpVjIwRzdLM0x2YnJPMjR1SE1lcEk2WjdzVnZBMW43eFRYSUlL?=
 =?utf-8?B?bmszWTh2V0lLM1FJUmZVeVdtOWRHV2dRZGEzYlU1KzB2R29vV1MyNGZaR0pn?=
 =?utf-8?B?VUpCVUloYkV1NWRTTzBHMmpqZEtBSFhoOWNqcE9iUkFaRldXaFFZdVc5T0Vq?=
 =?utf-8?B?bVRYOXhHMVF2VEhBS2FKdEpNOGh6NlNLS0UxK1Q3ZXJYdis4QmQ2aGRRTTRV?=
 =?utf-8?B?SlVEblZzTHAwbEpuVE5vcmRrL000bm9MSXhrM254MGRHdDdGZHZ0Z25hbXR5?=
 =?utf-8?B?MEg0MCtnNjg5ajNtVUMrdDZtazh2NklNY1ZZM3dpSUNwN2piSDFDQjNLTUxC?=
 =?utf-8?B?TGR0MUtPeThwVFQvWjZlM1BxWS9ydG1nMTFHYnJpeW1QK2pnblNCc0tBS0Z5?=
 =?utf-8?B?N0pYekM3K2N6bDV0MlhSZ3l1cy80MUV2WS8wVmZEbjROb1FkK2dZRG5HaE9z?=
 =?utf-8?B?R2RUNGdEbllva05jVXJjWnRMckVtL0paWmxYUkhuQlhIWVNJNG92Yk5QS0Mr?=
 =?utf-8?B?TTJ6NkMrR3U5Y1FyQTBraFg0NkdBRjJNSHBOS3BtQ2d2eU93TTNUZzM4a1BU?=
 =?utf-8?B?bk8zTWF3UnIyUk9jRVI2NWVIRXAxcnd0VzZsem1ocGpGWHVjQThsc3lWcG1z?=
 =?utf-8?B?cDBSRTBRODFwbjNoVDZzakJzUGpFcmJ3am93OUNucDRwTHVDbFhpRkwzMkNr?=
 =?utf-8?B?a1FVSHI0dUo2OUFUQWpFdTNIeFp1ZU9sVnZNWUt1bTFoT2JKb0hNTXFiWFVq?=
 =?utf-8?B?S25IQ1MwN1p5SkFaaWdxQ0cxeUdwbm1aL0hYeVpza1ptZFBaMVVOaHQwanNy?=
 =?utf-8?B?dkJ3eXZ3SFBLVzdML00zN01YdGZSQThTYUw3a0FWRU1Qa0xrWFAzcmRSQndX?=
 =?utf-8?B?bUVHUUFtamtUendtcFhIKzlKYUFmNUpTa256T2loZ0lLdDFtM2tUeW1WRTQv?=
 =?utf-8?Q?WHsGzt5yZlM4t?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a647ee-0e4e-46ce-85d3-08d8e2289de9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 11:52:15.1449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9J4Ei5sNgTx1RhQ71vVQQ1jGdfUsuDQEIlpxe2irH5c4H90lB75qKxiVR/X1cCy2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4255
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Shyam,

Thanks for the review. I also realized we cannot make this failproof so
I went in with the idea to just avoid picking easy, non-confusing cases
of unusable channels. If that's not good we can drop the patch all
together.

Shyam Prasad N <nspmangalore@gmail.com> writes:
> Spent some time in this code path. Seems like this is more complicated
> than I initially thought.
> @Aur=C3=A9lien Aptel A few things to consider:
> 1. What if the credits that will be needed by the request is more than
> 3 (or any constant). We may still end up returning -EDEADLK to the
> user when we don't find enough credits, and there are not enough
> in_flight to satisfy the request. Ideally, we should still try other
> channels.

Yes you're right, it won't prevent failing if more credits are
needed. The patch wasn't meant to be failproof, just to avoid most
occurences of the problem. It's a simple sanity check with some
false-positives and false-negatives.

> 2. Echo and oplock use 1 reserved credit each, which the regular
> operations can steal, in case of shortage.

There's a dedicated server->echo_credit I think.

> 3. Reading server->credits without a lock can result in wildly
> different values, since some CPU architectures may not update it
> atomically. At worse, we may select a channel which may not have
> enough credits when we get to it

If we are just doing a read on an aligned int, at least on x86 you will
get either a stale value or the new value, you cannot get a garbage mix
of both. Which CPU architecture doesn't provide cache coherency at that
level? This is a complex question I couldn't find an easy answer to.

In any case cifs.ko is already assuming it's valid in various places. We
are doing it for some usage of the server->tcpStatus, ses->status,
tcon->tidStatus at least.

The problems of atomic read in pick_channel() aside, the credits might
change from another process between the moment the channel is picked and
the moment the credits needed are spent (server->credit -=3D XYZ). In
which case it will also EDEADLK later on.

> What if we do this...
> wait_for_compound_request() can return -EDEADLK when it doesn't get
> enough credits, and there are no requests in_flight.
> In compound_send_recv(), after we call wait_for_compound_request(), we
> can check it's return value. If it's -EDEADLK, we keep calling
> cifs_pick_another_channel(ses, bitmask) (bitmask has bits set for
> channels already selected and rejected) and
> wait_for_compound_request() in a loop till we find a channel which has
> enough credits, or we run out of channels; in which case we can return
> -EDEADLK.
> Makes sense? Do you see a problem with that approach?

Some code relies on server->* values so if you swap the server pointer
it at the last moment I'm not sure those values will match the new
server ptr.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

