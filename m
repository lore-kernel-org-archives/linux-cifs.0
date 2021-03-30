Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC9AC433DB
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Mar 2021 14:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54B00619BD
	for <linux-cifs@archiver.kernel.org>; Tue, 30 Mar 2021 14:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhC3OV1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Mar 2021 10:21:27 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:23382 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231918AbhC3OVN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 30 Mar 2021 10:21:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617114072;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qyo1iGnwRmWmAebFWxtJSpBClOncOLhe0UJCyw33bVs=;
        b=XzNU3cuO8XoOzPkFhT0hH746miQXma3p1cQshmSVeX1FvDfjqYcTpznhlDafquHXYKHdDq
        NBQFEifaV5OP5NzM9/ezNMZcLIkhkYqSyqCJ1z0HzNe4ydMtr9YF8rQi5p6F92IN/+Ts4a
        7FUx1OHkq4EY2ARJRqJmY52ZtvcHgfI=
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur03lp2056.outbound.protection.outlook.com [104.47.10.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-28-noQVxaX9M8iAETAlb9Opow-1; Tue, 30 Mar 2021 16:21:10 +0200
X-MC-Unique: noQVxaX9M8iAETAlb9Opow-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czgRcHNBD7Avgj/nVpBuBMsfchvKwwO5m6puMZC8+Qr0/w2FDLLCviFIa+RsUX7QnfXcB4Vhy5kMzwPiuemWgN2S3M/oqOcFTSue3LYjuvCg+ybTwz18yBSfCesfPPrVYXPvIyMJPLZenqH1XJYLQZir6IXXGiOGC1bM/vfCh0TckLqzJEuVEJIqrt/zuxVPR2T+QqSLFTmJTK+lmy4+B1Q9L8ZdIEUv/FVtAYceR/xsywoyp245S2R7a2vNFj0BMnRrjZ8hJoQxVI3Z/HeFmsb6+TrsqaKQb4/gFHm7K3IdM1eTpuAd7KK+f7wkl6oAP7KrhxB8G1Nc2M+0pLo/zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qyo1iGnwRmWmAebFWxtJSpBClOncOLhe0UJCyw33bVs=;
 b=Ist70AKUnl7o+gA7atThCiOebSEOw9gbqB8PcNQno5MpMunqypUbw2MTR8U0nlZWSXtbk5HauPNru36YB2FrUtYg2ZokO7jXbpuIEGsZgeoQ0Tvqct5NDLoYVweLsA9f1dOdly4z7YHUFi/RC1C4F+kgo4QLVh172+V51pLTJ0umZS44gfgHSD5HMK5FRasQIigGgD/ntzc+xDkh8K72gCeKTkhraSw6Adws7b1ICzOPTZcd6fULGLJkvVaJxW5jnCngXWqmixY4SWkhA1iG7B/YfYtZYdFp6t/G8W1adEUWo11xHIQUeG2IyOvc9dIzrsYwNipo8IxLKbraSvj+jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB4526.eurprd04.prod.outlook.com (2603:10a6:803:6e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.29; Tue, 30 Mar
 2021 14:21:09 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.3933.039; Tue, 30 Mar 2021
 14:21:09 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: add support for FALLOC_FL_COLLAPSE_RANGE
In-Reply-To: <20210326195229.114110-1-lsahlber@redhat.com>
References: <20210326195229.114110-1-lsahlber@redhat.com>
Date:   Tue, 30 Mar 2021 16:21:07 +0200
Message-ID: <87eefwpvsc.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:a716:eb16:c60f:edad:7b7f]
X-ClientProxiedBy: ZR0P278CA0063.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::14) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:a716:eb16:c60f:edad:7b7f) by ZR0P278CA0063.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 14:21:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d725162-3405-4bd8-79cf-08d8f387100d
X-MS-TrafficTypeDiagnostic: VI1PR04MB4526:
X-Microsoft-Antispam-PRVS: <VI1PR04MB452621AD0DEF1B57B26FA7D3A87D9@VI1PR04MB4526.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r7IFc0SQWi85KXGKDhFTSH5uYBHT+0nCRVDvXBf5hdej7LIiklT/4+96RmJaiLipa1wPwDuOHwGc4behT/WFCdtyTXh+RGEc8QoELrfJnVQ0UbhgDH12ryRyhQsB7zOUKQA24p/miKR5bF+dYoItdhm/IPnDF4a1bnq0tWNGhoGRx09cztOEOR56hWAol9QRQJ0FidSF+WPPhYkcm1wuoX3amwJP1dTPAFZFXpVMKtIysm0Wy9tR0MmwnoqbPKrd5xgJ1AHePmNZ1l05YL53aDCc58iUBMsOcTj77vCPnypjLR1p2ddLPD1UbJGOeVARbVWwQLHvcQWKR6e6H0PMjhiGds+fvJYUE7pUGhzMFCzoRnQ26PNNpMVjlWkCZvb+g1fgF+hBKLXY7SsHFmpe1+sRiBlLlTB/xcpueBIuk1PLS4PBhBEPLC0LWeAvNgtAYms/i2s4LCRrcCNRcm2Wm0YLmRNf/ZyCmQrX+utzr0FGnCX8c5wRXXx+ltIs6Vosc9Rva+wj22uvAN5njZ3rM6xiFLAQ1yHVNXBBvBL7zMUtuwQj8xFQzn9+37l7Ch51HAegfuQTMdf1GKx4R1ikMVybObtZZ6wN1JXpN78nwGm42nA0IivHX71DEyRm9uzkJAkjd3eeDezB3sqSVkvQZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39850400004)(366004)(396003)(376002)(346002)(4326008)(8936002)(8676002)(66946007)(52116002)(38100700001)(16526019)(478600001)(5660300002)(66556008)(66574015)(110136005)(86362001)(36756003)(186003)(6496006)(2906002)(66476007)(6486002)(316002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?d0pkb2RYMnVxTmZGLy8wY051YTBuaHhoN2g2MGI1bGhUWHhmUmhDc3hPSWE0?=
 =?utf-8?B?UjliUDlDNG40M0oveFpBaVozeXp1M3VkQkNGQmh4Zk1RUXVwWUg5N0QyeGU3?=
 =?utf-8?B?SWs5Z2ZTMFJGWTBDVXAzYjRXRlR2TzVxZFJ3ZDBjVXlETVFwYjRqa3k5QU81?=
 =?utf-8?B?M0VBN0cwd0IyN25jR2VNcnVOZ0gyaUQrY2lHdmpqRW9reHJYcE9ySG5nT2NY?=
 =?utf-8?B?NnY2dFdCTmN0bFgya1lVMGhXRWJ6c2UxNlRyL1UvdnFOaVpJVk9IWUtGTGhp?=
 =?utf-8?B?NmZ2a0V0cEVHNE1GVUJzZlZ3UE0zeC9aSHl0bG5ta1hVSytBZnNzQ1ZNVFcv?=
 =?utf-8?B?M3Q5MnV2TGkvYUFQOU44RXhVejNxZVEvV28zNlZEc0lKSlVoMGRGMkhENWdS?=
 =?utf-8?B?SzQ0OU9td3d0VFloWFpXVDJ2dkhPc2t3TVBuTDJJZ1hDZDFNaGVpeGFxREZM?=
 =?utf-8?B?MzcyQS9PclNaeDUrU0ZuRlhPNVlySjlKc0FFVGdaTU1PN1VLeTdBMnBhT3Bp?=
 =?utf-8?B?cU9SdTVwSDNTdkp2RmdZb05LaTMweFJJVkREbk4wSjFGc0RxcVR4emgzSHJZ?=
 =?utf-8?B?Zk9sRC8zTFNEUHZPYlh5dCtRcnFzTDZveXk1VGhhcElDUitvN0Z0VmxKZmpL?=
 =?utf-8?B?M0prR1UxeGNrejJEaC9VQktZTTh4Y0ZjMmE4dm1sS0dob3BDbFFndGl3aTVo?=
 =?utf-8?B?dE9jcURpWm56enh4QytBTWxxLzBsM29ZbFFjaUduZ0R3QmpUbUpLTGxWVThY?=
 =?utf-8?B?ZDBldjQrSklPUjJKSTAzbjROTjRPdWxVZFBEL1RUZTFxTUVwQmVUdTVFeHlE?=
 =?utf-8?B?cHErSHBNVS8wMGl4Nm9OcS9LVUd3QnFkcVpnZzlzWlRFZE9hRTRxcTk3Zk9F?=
 =?utf-8?B?Y1BrckhFcGlFdFV1anI5Y01LZ1gxdXgzZlN6Wks1UDNhZjFxT3FDUDA2Y0N1?=
 =?utf-8?B?aVBZdGtNaE5DbmRycmFFTEtYK1BLTzhlMXZaSFlPQUNLTnNTUzV4WW5FbHBk?=
 =?utf-8?B?alI0N0w3VTlremJtd2wwaVhBTGRDNWFNTXA4cnB6b2tidjZCdVJFMk1ZWUYz?=
 =?utf-8?B?eUh5MlBiMFpxZmd1c0llRFlBTjRQL3J3SHlTK3EvVG9yZFhzbzZCNmEzV1Zj?=
 =?utf-8?B?ZUJvNmVWNDRvM1MvZFQwZGljamplQzh5aUR2SUFaRFdRU1VNSnliV3JQYm1C?=
 =?utf-8?B?QmN1M1E2ZGZVek1SUU9zdFpzV0pPT2NiZ3ptc1padkpxaUQzQ2xJaHpkVWlB?=
 =?utf-8?B?WFdySk9sVFhMOHIzVTRkTURycVRwOWRWRDFpL2RZSjNCZnhaTSt5VFFHaFZJ?=
 =?utf-8?B?T3dKckplM3JmNXk4eVdGRjBQcW4vMnpyZHg4S1Ixdm5mUU1OVzR2eG1YYVBq?=
 =?utf-8?B?SkhCTnJ4eStJSDRvOWtYakFRNFA2RS9Gc0tWYUYvZnNDR2dFRk1ud3ZzcnM2?=
 =?utf-8?B?OXN0VW1zdEQycERtRTVsdVBwaEEyTnNqSWwrd1NITGZkanMzRTFVQnNzc1JN?=
 =?utf-8?B?NVhNajc1cHBLcUlaNkY3YXExOU9rNmRZcjRHMFVLRWQ0Rmt4VENVRGdoS2VK?=
 =?utf-8?B?QzJNQUhtUHE1VWZ4dWlsSXBWaldDRDJvWWtPM0ZVYWUwQlc2bW9wbndJeE14?=
 =?utf-8?B?VE5hQ05UYkQ5ZGFrMG9lbmR6Vm1IOEw4RmRzN0Y5U05jY3pzbTU4ckQ0Q1F0?=
 =?utf-8?B?N0RSMFcxNDhqK3R0WEd0eEp4Rzl5Sm5aSzlrczhTQmdXbkpBbDhNV1RIWWhC?=
 =?utf-8?B?aWMvbmNYdXdXV1hDRFIyV3FmNkZlaFZZSXB4YU92OFdaNFFqekJKUU54aStK?=
 =?utf-8?B?Z3Y0eG9ldjJvSE1Kcy9pbWpSTFEwOUwzdmtYVzZ1MWpwS3VyTERPSkhYRzYx?=
 =?utf-8?Q?+T5jY7s7tWUCa?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d725162-3405-4bd8-79cf-08d8f387100d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 14:21:08.9647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IvczyRDaLKVTKsu1JH09wH9ldhk65Ugq/eZ1Y+XNCP9ou5oYGxQaNWy7NGjr02z5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4526
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:
> +static long smb3_collapse_range(struct file *file, struct cifs_tcon *tco=
n,
> +			    loff_t off, loff_t len)
> +{
> +	int rc;
> +	unsigned int xid;
> +	struct cifsFileInfo *cfile =3D file->private_data;
> +	__le64 eof;
> +
> +	xid =3D get_xid();
> +
> +	if (off + len < off) {
> +		rc =3D -EFBIG;
> +		goto out;
> +	}

loff_t is defined as 'long long' for me which is signed, and signed
overflow is Undefined Behaviour, unless we compile with -fwrapv which
I'm not sure it is something we can assume.

Also, vfs_fallocate() in fs/open.c already does an overflow check before
calling f_op->falloc(), this is probably not needed. (It's also relying
on signed overflow so I guess it is ok...?)

Rest of the patch looks good otherwise.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

