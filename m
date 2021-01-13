Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D369BC433E0
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Jan 2021 12:31:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F1C023339
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Jan 2021 12:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725774AbhAMMbC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Jan 2021 07:31:02 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:43060 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725773AbhAMMbB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 13 Jan 2021 07:31:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1610540993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z0uKbspxnWHp0h4ytzkkuvMn+2J9L60I5WFui7w3HCk=;
        b=Gwwqi0FFBgpHN4yOFmpPekorSRNiwGeOuCAneUq89tqO4wII0EIaRZkZNROu2eKOIYRjd3
        JLkmmjH28FLQ5iRPCtsA60bxEBoqzsRtwOs0tQ17y6gHYtfu0xTbaUmsqbZwKzacOFXF/j
        DSOLI2v2eooByKFkvUeO6Psgqu/nTOU=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2052.outbound.protection.outlook.com [104.47.13.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-20-m4e4fYgfMYuZPGwyyqiE-w-1; Wed, 13 Jan 2021 13:29:51 +0100
X-MC-Unique: m4e4fYgfMYuZPGwyyqiE-w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVyBSX6zEnKr832av0BuJeo/tMNZj5+oKC69UvYXRXng7MmGvd8CrZvp6A+gu9XC6B9brnrCoy1SG6lKANPH8ZPnnbAh4I4SzQvV3v1ull28L1njDbpw5dPi8gJXAUaBBjE5FRBfKXZDFhuIxsuaE7/GtSerjET9qFDeNqW7T7BHgSU32MfB4LX8Xoaj6D57hsZIYAbB/9Yul2rqBl7JPWRlAs6iCdaGKN5ZfR/irkjhpipD1RaOyYZDys2QIVuFUo9D6FeZbLZ84oni1ekApXKV+ITEkU/CJEIdBKSkpsgTA/TH2+nr2g9gEq8QvVxamMWovo38ZSXXvcUFKwcm+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0uKbspxnWHp0h4ytzkkuvMn+2J9L60I5WFui7w3HCk=;
 b=DpamWG3Pf7YWveLV9FWd4SVtfQfrU+XeTiA5mrBDBTAGk4qx9n8YZw+pAfAqk1r9uzd+eTQ/G8+0mDNLBd87Gy85U8qfB8xRl9ijtYj7l4qBQD+LKTwrgKvXk6tcfQMcLt+r/bj2g7LJiGbOESGsjjfxmxOej2m75iHLhD9bYCB/BWywQ9yWvMpYVFAYLf4hyJTT0iWavH/b0eHIRl5nasHmgdGoc2kUMpOWxqgdqHvPFeiAzU1s7vxIehMezF/AOUOgmqPb3u9P9xkTcqrcthtRcjxpsiHKx2JFLy6BODHfkij+++Sjrr/HETEfZFYCVFvWucovYWD4cUSxZpeuig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: duncf.ca; dkim=none (message not signed)
 header.d=none;duncf.ca; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0402MB3358.eurprd04.prod.outlook.com (2603:10a6:803:11::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.11; Wed, 13 Jan
 2021 12:29:49 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%3]) with mapi id 15.20.3742.012; Wed, 13 Jan 2021
 12:29:49 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Duncan Findlay <duncf@duncf.ca>, linux-cifs@vger.kernel.org
Subject: Re: [bug report] Inconsistent state with CIFS mount after
 interrupted process in Linux 5.10
In-Reply-To: <CAE-Mgq2kwwZJicbU9oenD4M5SQhbErhXovGX+LKtcnRbLC4xSg@mail.gmail.com>
References: <CAE-Mgq2kwwZJicbU9oenD4M5SQhbErhXovGX+LKtcnRbLC4xSg@mail.gmail.com>
Date:   Wed, 13 Jan 2021 13:29:47 +0100
Message-ID: <87ft35kojo.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:9f69:1ef8:3a2c:dccb:e3f5]
X-ClientProxiedBy: ZRAP278CA0001.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::11) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9f69:1ef8:3a2c:dccb:e3f5) by ZRAP278CA0001.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Wed, 13 Jan 2021 12:29:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5148ec05-df32-4a58-f225-08d8b7beeb8b
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3358:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3358D303252B2B337E37926DA8A90@VI1PR0402MB3358.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DTjg/SzgI2SrSWUkoQeDfi4/cAR4DoWzN49ZxRND0b687NGU9A6lhHY+8KpBENogOuqoPvB8ys0pEl0ZTNBTomoFHfPZNHiPRWZZMjpOP0DcfZlezMe0pEppfMZ5oUpm+3CYxdYS0MCPASlvium+MdcAIwLy4xsOING585Guer21fJ+ljGi6my+9Aa+qoLETxb0XIZcpSzHsYcpIzYhNOiio9fwlmgLpeJs7yucvrlCnAs/GRB1QFcNvL5JWyHMg5Qdqv7YkSbhs3k4AQ9U7SXfdXlTSjHzpnTY9dmv0Ga7TOBcCJVGVD0rZg9ClFYqEqXHUuJA543GI5kms/kbqtXCb3fNx6Iumu8f0dPHt8c9JXishiykokWiC5/ayIDYHTzy5X8M/IDVURH7opeYMxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(346002)(376002)(366004)(36756003)(16526019)(2906002)(6486002)(66574015)(66946007)(316002)(478600001)(8936002)(186003)(8676002)(52116002)(5660300002)(6496006)(66556008)(2616005)(86362001)(83380400001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MFNHcDVvMkFtRlF4VWhoV2IrM29XLzM2cDZJK1N5L0lnUEJRWVV3dWpvUnZS?=
 =?utf-8?B?dHY2Y2dSTTdRVGpLdWZtMVoxL1kwZDFUc24yREU0aW9uL2MvVUNFUGQ2Q2ZW?=
 =?utf-8?B?bnFid1U2aXJZMWw0Wnp6dFZpYlArd0IyQk9pQUtFZ01JSDUza01icVhZeFNm?=
 =?utf-8?B?RGtIeW1DV2kyMCs4ZEh0Rml3ZDVKb21aRTMzS05mblk0MkdHTFBENGRDQlV4?=
 =?utf-8?B?MGFXYWZycG5iM2hrY3pjWDg2UUh2SmVEMnNOOWVhQUxKUVVyVC82akdDdWVS?=
 =?utf-8?B?bVRoQmdmRXlZeEtOeUZkaFhKYSs5aTFRN1pxQ2ZiUEUzLzQyYnhJdituT1c4?=
 =?utf-8?B?TGxNRWhaL2lMYzI3cFkzclhSMXYrekxWcFQvV3Rjbk1BbWdpa25TS1NUdi9T?=
 =?utf-8?B?UUdBaWRkRURCTGlTRkVBUHNSUW9wT1dWT29kaHh4aktxV3ZtL1NvZTY1R2Z5?=
 =?utf-8?B?cmJsQyt5K1p2cW9rU1p1RUdYS1dCRXV3eHd5c2RJaVhUd2dZeW5XdElaaE1J?=
 =?utf-8?B?ZlphQ1hxU0RVVVowd0dBRTZNOTJvN3liUElmTGdZQzVVOTVYV1laNENTTHkz?=
 =?utf-8?B?Ym1KT3B6V2dxSjY2MHl1djBaUVgzVmcvc3RyZ2NobllnNXc0dXZ2dWpMM3R3?=
 =?utf-8?B?dmppc1NLMVd1c2pydzZBNXNyUnpkUXAwdTlNaXNxVlVwem9NWkxuZTVlcnVj?=
 =?utf-8?B?MW9CbTlLemUzbS84KzUvdVUvdVV5MlhCalhzRzBPeWdtSUxreThvQUE5djI4?=
 =?utf-8?B?VWEwR3A1ZVB6eTZuWjZpdnQrajRBS2VFc3hOMnl6UnhIb3N3RXZkaHNNMC9m?=
 =?utf-8?B?UVBPSUt4UzJBSHU3MjRjdUkrQ0xpRnRmV0h5SU9YV1ZYOWk1b0xlbUdPU05y?=
 =?utf-8?B?aFpkdDErbklsT1RBajFwUC81Ulc5V2J0QnJyckoxRFF1L3JWbEhhZ2dyY2p6?=
 =?utf-8?B?K1AwTDJyKzk0NTBKOVIzeXRvYVF5bERPUmtPZ3EyL0FhdEdtSUhhYzBBNXNI?=
 =?utf-8?B?YTl5bXZFMTlCUXVPNkdPN01ZTXlsODlDMnVRaXd3Q0M5K1F3M2NTUkQzcFBj?=
 =?utf-8?B?Mm9CcGJ3SklzVnp3UElTelJTcVhLN1phc3BXV0pQakgvQm1ETVZtMlRwc2gx?=
 =?utf-8?B?T1pSOFE2cUdZdXpqWnlUaXhKMmY5ck9ZR29HU3dMOENlZXZIVWN2Q3NxQ1Na?=
 =?utf-8?B?NnMzMmExdFpySWFSbUVJODBGR3N0VWExRXVuTTNkbjUzWTd3aUM5Qkg3OUVv?=
 =?utf-8?B?d2Jad29nNDkzR0lIZzB0cUhTaVh6U1BpT0ViTEl3Mk4rWDFNQm5zSkJWY0dG?=
 =?utf-8?B?WnNsSGJpVG00dzFuYlQwcXAwdVRrdTRlQUsxc05sVDBLZjdYSjgxNlp2aVRY?=
 =?utf-8?Q?802AVEvNVX1f0qJCUhUb/WQ8CTA1IIlA=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 12:29:49.1264
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: 5148ec05-df32-4a58-f225-08d8b7beeb8b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3CbvqqSTCIYkYnBW0mWFcp7Q9lCOVZ3TstLkLNBYBbIW9ES/3s6DAFF6fbBVLv9p
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3358
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Duncan Findlay <duncf@duncf.ca> writes:
> There seems to be a problem with the CIFS module in Linux 5.10. Files
> that are opened and not cleanly closed end up in an inconsistent
> state. This can be triggered by writing to a file and interrupting the
> writer with Ctrl-C. Once this happens, attempting to delete the file
> causes access to the mount to hang. Afterwards, the files are visible
> to ls, but cannot be accessed or deleted.
>
> I'm running Debian unstable with a Debian unstable kernel
> (5.10.5-1). I attempted to but could not reproduce this with a 4.19 kerne=
l.
>
>
> Repro steps:
>
> $ sudo mount -t cifs //test/share /mnt/test --verbose -o
> rw,user,auto,nosuid,uid=3Duser,gid=3Duser,vers=3D3.1.1,credentials=3D/hom=
e/user/tmp/creds
> $ mkdir /mnt/test/subdir
> $ cat > /mnt/test/subdir/foo
> [ Hit Ctrl-C to interrupt ]
> $ ls /mnt/test/subdir/
> foo
> $ rm /mnt/test/subdir/foo
> [ Hangs for 35 seconds, errors in dmesg log -- see below ]
> $ ls /mnt/test/subdir/
> foo
> $ stat /mnt/test/subdir/foo
> stat: cannot statx '/mnt/test/subdir/foo': No such file or directory
>
> At this point, the file still exists on the server side, and
> restarting the server causes it to be deleted.
>
> I can provide pcaps if necessary. It looks like with 4.19, when the
> cat command is killed, the client sends a Close Request, and on 5.10
> no commands are sent.

I can reproduce this on Steve's current for-next branch but only against
a Samba server.

On Windows server, doing ^C kills cat properly but the output file is
never created, which is also a bug.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

