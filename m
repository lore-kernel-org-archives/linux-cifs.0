Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 696B8C4361B
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 12:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D7C524778
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Dec 2020 12:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439013AbgLNMVE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Dec 2020 07:21:04 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:51215 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731134AbgLNMVE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 14 Dec 2020 07:21:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1607948396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UNkalwrubY7ksmhvvK9KavHv+YrqOtEOflokNzzi9oE=;
        b=mxLlXfSzv1sfznn1drMlokFLmO9jjkTwSLzyHKcruxcBAfNI0GTkBqznchK7kPRoLz2Tm8
        lFOOpi1ZII0JCHTQLl+BoU0Au+WJDF8OK3Gokq6InJ3pd1PvSyLZZY/SIene9yDob4bk2m
        32xqGYlsC3QAkERmq1y21zxC7ch/bZk=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2056.outbound.protection.outlook.com [104.47.0.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-12-UNo1KQIbOFKJHpOSZWGxRg-1; Mon, 14 Dec 2020 13:19:54 +0100
X-MC-Unique: UNo1KQIbOFKJHpOSZWGxRg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ic/1gXo2Jbmwz2nCeWdCYwIbuLV/WG0HIzLqNsQLd4cMACTUHse2N/Eum8U3mN1CG+11gE7bKHV9bSFt34hZ1+O9/ykcN3ooi1kXSIM0ObgfjlXZP4njJU5fXO6doubWMoZkNHqi1MJSG3M1KPAsc/XebSbUyAFRrjYrFHDywkixzmQ0gqUsvKHdVLlyVG5IEkYUCJyzcDd9AbpdtOBVGmwNlXdPxsOSJNzWChZtIszA6wQum1cPbMY19nptuH4kZWvmsaOCH5roFiF3bMLtRJlElhHAGZjTlq7dhQxrSz8YA9VO6xn9OP5TPWTcQE4Im4d8dBy5T5MheNjQGEZYfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UNkalwrubY7ksmhvvK9KavHv+YrqOtEOflokNzzi9oE=;
 b=btSkKv5qGgbSEfVRNGrGCnqcuuXThPVXZinHSQjtV0XyARFR1TdP9R6QXZeq/FQLWBVbvRzYYwb5EjmSoaVMbP1wQNfmpVkyFjYnHvOQFbXYLfc1T6L0nnLUSkZS7kx/a7EohWGfOJbih9oQql6PWi2/BrUQmzAxq0KWC85xbKpTlfqWzTbI1pDkJM108p6GS3wyBpkQUCmb1IrSezs0zTVkoOHmPAmwUlB0Hs9u+dTqLZ5hpT4KzakC1mQPLYIYuol3/a3k8d9BacGvw46YRU6R9ponswvguiZ6B/ecz30ez629b11bpbwaeP96te/Q6OMKNm0y7oOUmQGYg4W4uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB6192.eurprd04.prod.outlook.com (2603:10a6:803:101::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Mon, 14 Dec
 2020 12:19:53 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::4dad:a2d3:5076:54f0]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::4dad:a2d3:5076:54f0%5]) with mapi id 15.20.3654.024; Mon, 14 Dec 2020
 12:19:53 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Dmitry Osipenko <digetx@gmail.com>,
        Steve French <sfrench@samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] cifs: Add missing sentinel to smb3_fs_parameters
In-Reply-To: <20201214113745.7909-1-digetx@gmail.com>
References: <20201214113745.7909-1-digetx@gmail.com>
Date:   Mon, 14 Dec 2020 13:19:50 +0100
Message-ID: <87y2i0bmvt.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:9f63:f5bd:7a8d:a064:3118]
X-ClientProxiedBy: ZR0P278CA0044.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::13) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9f63:f5bd:7a8d:a064:3118) by ZR0P278CA0044.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 12:19:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 523ead9e-ec8e-40f6-fd3a-08d8a02a8fab
X-MS-TrafficTypeDiagnostic: VI1PR04MB6192:
X-Microsoft-Antispam-PRVS: <VI1PR04MB61928C50F3FBE7A63FFC53F7A8C70@VI1PR04MB6192.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M7FxZSsnfFNkoRitV9hfiSN4o+e6pToz0kWt3Ynzzj8uo4uXgJq/mKGR+w6gNTkqyV7Tk6W1OikpYffp5kXE1DIrdamaxZVWd9cpkKHcEyVo5VBWKhHLxwsSbkZy9+W4PxtyDdqtJG+A5EKbLmsLHNE1xLwpRrBPB7XmniH9YgYGuLMoRaMZ2TalxOX6Teo39Gs6zIG1kK1Bj9xVivR2SU10GPVEZE+u3N0EoQf48s/hM8GAuAnHI6oqthgg3ccBqWC46D4XqIKMuZzAQ8AMPt3vJJS0rgY8/eAxP83TQu3mLACYfBsulJ+Vigt0ALsZgZ310PdkrvD0eHH21A4CXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(396003)(136003)(39860400002)(2906002)(66476007)(86362001)(66946007)(66556008)(186003)(36756003)(478600001)(6486002)(2616005)(316002)(110136005)(5660300002)(52116002)(6496006)(4326008)(16526019)(4744005)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZC9LekdGZCtLVld2RDB4UWtiai9WN2dvNE1DNytIdTBQcVFCSVhOVnZycmQw?=
 =?utf-8?B?SGNVZGFibnpLMEQvUVdiL3BtNTRsa1pDclhkSzFXUUlWZ0RCMUM0QnBuTzgw?=
 =?utf-8?B?ajg0YVJLN1Awd0kzd3g0bjl6bDJNeDZHZGluOFp4TkYyUGNTNHpsYkFLbnJV?=
 =?utf-8?B?cDZXN0NZbXhpT2pDMWtuTlU3V0FoN2NiankwRitYbmtoZXRERU9VS0l5Qks2?=
 =?utf-8?B?di84cG1QWm5CSjgrWjAxRE9pQnRtTzYvUDBSYU03OEk4SDJRVG1JQW5rM0tQ?=
 =?utf-8?B?QWZlbldWNmMvVlhGSWtRODFMWUVZdTRUWHh4clFXSDNZeXFHTDBvUS85eEwv?=
 =?utf-8?B?S040OUd1LzRNaDdVaXFjK01qR04yV0RjeGtaU0lNL2pJN0JVOWI1REdJWlBn?=
 =?utf-8?B?aXJ6WldoQVJpMCtqY1FvS1hqS2NDcUw2R3RrK1lkYlBZMnJhbkdDVmpJOFA1?=
 =?utf-8?B?dzY0UGhYWmI3eUhNV1lGSzZLVkMxTEJsUTN1Y1hMMnpyQWJFUS9kSVVucFlQ?=
 =?utf-8?B?K1FMNU1Hcjk0MGhhWlIzVDJOdVhxeUx3MTVwK3A2T3J6a0VCa2l6ZEFpaUw3?=
 =?utf-8?B?MUZsWVJFSm5EOHY4WU9hUnFTbEs1cjF3Wi9vU2Vmb3BjNVJVRFJiOFFkOTc5?=
 =?utf-8?B?VzAxRWd5S2tPMDZBMU9CTHM0R3ZQS0dKRit2cHNmVVdrejZSdjBsaTZOdzNP?=
 =?utf-8?B?VW5MTlMzTkE1YUNocHhtZUpnNWFxOEtDdjJBR1M0Nmd3WkVNclAyMWllVll3?=
 =?utf-8?B?c25vNUVIOUtNWWRVUWJMSDJKeE5kUElPeGZrSmN6VXJwcVVtdS9mMnp6OHJI?=
 =?utf-8?B?eUlzRkFyai8rNzRRTFZuZWc4K0tUUFVxWFAyYzVSMjM2RWJUMzVnemN3eENO?=
 =?utf-8?B?ZlN1QTRXQnNWR0J6azRqZjJFQjg0VkFKbzN0cWJhYkE1RUxvU2ozaFk4S21a?=
 =?utf-8?B?QW9VN3NwajdaSElDejc1eDVRc3VTbmhTVG0rSWdGQ2QyT0lyQ3JWL0I3d013?=
 =?utf-8?B?L2U0TS9XOFQ2TnowQ2VUTUlRMGhIMDU5R1UyZWhEMmtOSmRCelJzaUdQUFk3?=
 =?utf-8?B?WnlkbldWRFBwaWZKWXNocDYwK2p6dnd0YWZ0SlFXdnYvTytscnN3NXVoTzk4?=
 =?utf-8?B?bE40dWtBQ2tlaGpSWFNUWEpSdkFKRDRvY2x1a3JzdFJDaFpxblVLOUdybndP?=
 =?utf-8?B?cWU5akM3YXA3bGpwa2RXK3hFN3ZEc2xDQVR2YVIyRm9tMEdRMjV1SnJwZXB2?=
 =?utf-8?B?aDJneVJPeFpubEQ1MWpuY3FTdGkzRWtlMldnWmszTk54S08vU3hXVVEvOHli?=
 =?utf-8?B?bEE4VjYvRmNSeXNxV3cveHh3TkpzZDUzNDdGUzE1Z0JScXRoSTZ4ak93WU1U?=
 =?utf-8?Q?1hqj3qyenW0y+ttkjAu/mAmmZyjjeKpM=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 12:19:53.1559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: 523ead9e-ec8e-40f6-fd3a-08d8a02a8fab
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tqvaxtUNJ9rL0Om4N3Oz6PhiQAAfNE03MYuuJ/qsKySkV96fw82kclxfszkg5E3Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6192
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Dmitry Osipenko <digetx@gmail.com> writes:
> Add missing sentinel to smb3_fs_parameters. This fixes ARM32 kernel
> crashing once CIFS is registered.

Thanks for the fix Dmitry.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

