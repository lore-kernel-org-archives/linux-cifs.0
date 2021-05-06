Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308ABC433ED
	for <linux-cifs@archiver.kernel.org>; Thu,  6 May 2021 21:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE65660698
	for <linux-cifs@archiver.kernel.org>; Thu,  6 May 2021 21:19:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhEFVUl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 May 2021 17:20:41 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:22990 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229572AbhEFVUl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 May 2021 17:20:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620335981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wgZ6Z6N2tjHrguZhE2OKifxczkziiNtivPzRZX4lbzE=;
        b=IqYkTFpG/g5KYZPl6Tv2/284LZuIjhIGDWm4GXix2G3NLvhKadPcBclAhspCS4RwqrtgP5
        q8ckLbOLtCdG12cZHtFupGr36LmsG8PENiJl1GNDnPI3LJdx4jygKMc0RWhaMbxtUSDpBh
        vLFvvmXrr2QdWJ+uXLwRynQ5iXWgTWA=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2052.outbound.protection.outlook.com [104.47.14.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-17-8BdkdCRWO1qURQk0dD2H4g-1; Thu, 06 May 2021 23:19:40 +0200
X-MC-Unique: 8BdkdCRWO1qURQk0dD2H4g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DdHb93RxUe6xvu0nj+KvbyGQlk6lQO8C6HeYqWzhdvhvRPBAwFeBKb+B4SyNRGu7r3fqnrd/+uH+BLmEzneP6E2OqGGqfp3KU3FdxjQJsEWK8jU8k5CEeWVC2du39jBUJ5kelM68ARnus34K2Ek8JhN9d8Jj6W6njXTks7VkjRonY3TNK6P3Tsh7IrwjYjDkYGGZOfaY8OFPqzy/UOisDidxqVP/AahBLEGLjRHnIhNxuSaDiwJ9j4dvtVFzsPfTkI+urM05bEvTAMhRsKbCow31hLsNGyUxthVeVWrc3jkaanlBhwve0VGlLU95MotfEhpAvwYhv0eF7dXhIphPBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wgZ6Z6N2tjHrguZhE2OKifxczkziiNtivPzRZX4lbzE=;
 b=BhWePYsf2qiPp+T0t9kqxTMWelSrPVpMaZ5VaoYuPp+jv4eBUBVjI0vCvt9lr3vMp4BGBmWxS2Q7nwrDHfgU2U6PgetAlXnPBVPrftJHs8mhAzlQFC/ROq84T3byEMIaeBPXf5qrNz1pfEoZKCtZ/og3tknX+8GolWVAI5cJwBSHvmHBjg1HWs8fsl9Shf2ntwG11aug3Br49TAhBsnLzZ48GNDpqk/7+EYfkJi6xTNlunesm8Ql7jkJFngcj5Dwjbkg6kGVn+KUuuMS4R/X4+2JN3+6W1lZ6sinyY47l8n5Fd2OxYV9vYzKXqwhNBN9U/fGDDNcEccos8FaNDmUqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB5918.eurprd04.prod.outlook.com (2603:10a6:803:e1::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Thu, 6 May
 2021 21:19:38 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4108.028; Thu, 6 May 2021
 21:19:38 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Calvin Chiang <calvin.chiang@gmail.com>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: Unable to find pw entry for uid
In-Reply-To: <CAEVyU89=egaEAdvCD=FVkLwP4akzY3y8q=0hFW-hSryq0sxnxg@mail.gmail.com>
References: <CAEVyU88zhTKVrbk-+YCrd4fTN=za8906CwFFGzDk0OovSD4=QA@mail.gmail.com>
 <877dkcuj8k.fsf@suse.com>
 <CAEVyU89=egaEAdvCD=FVkLwP4akzY3y8q=0hFW-hSryq0sxnxg@mail.gmail.com>
Date:   Thu, 06 May 2021 23:19:35 +0200
Message-ID: <871rajv9ug.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:a615:1bdd:6a41:a7f2:21f0]
X-ClientProxiedBy: ZR0P278CA0120.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::17) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:a615:1bdd:6a41:a7f2:21f0) by ZR0P278CA0120.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 6 May 2021 21:19:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5df6a06-12b4-486c-1c99-08d910d4a74e
X-MS-TrafficTypeDiagnostic: VI1PR04MB5918:
X-Microsoft-Antispam-PRVS: <VI1PR04MB59186CAD38FD43A84326D3FEA8589@VI1PR04MB5918.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WJ0apFfXbma7W4Nm2h847tl6AKxnHs5UJXXS23Y0DQeIWymv1DS2fXtyxypy7uzUZX/AOZYhpdh8NIK5q1/SQoVFmqZqC9RjUbwULEgSE9RHA37zY6QtBo2krqGZ/fqdfoynGXY1rMvK2mEfyrL7nfq+/cqcw90iJJSkt0Fjiw1Ddc/qnkYOON17M49k2oXiBV+mJAGpoOr02IxEhGDkrirRn/WTzl/6GuUMXLvRNAfmegPtEdBpVFO7j0o2386AlM5jc8nCQ+6xOzs8BvTmgCQZKhH79upXrlhJWLtdhQ4PNknzjLv91Gkwn5GPt70fg7i29GXTby4ucVNLhiNig/VR6kzIIOj42Bxfqg9ZH8j4CqmlyFS/TP0kAbRbQaUNxay0V8SCv4KIop7dEy138+MCkL80mMJ7sxw0OCUohlBl8NlbBg3j6ZS+pMs7O8UFLFYdBxzhrntpSKkrc5hEziNn92mM0SzCDqqYkpnPFfoatlmLXLbmwe38k5/2UTmUEps/AZ5jE4EAixappGrQdDO8cTtXPeke8SAz1pE6gJZO6x58r6/RT/R8F0J0EeV9S/20a8SpTyCOvspRB1ndRMaZhzh339y9C83fxhGdKxgNbI0BmD3Fqpvp0rmpgtKdgDTdeUXWCTp29lCaflQDV2Rh/4FWS5mai8WChN6hdPo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39850400004)(376002)(366004)(396003)(136003)(316002)(86362001)(6496006)(38100700002)(5660300002)(6486002)(36756003)(2616005)(186003)(16526019)(66946007)(83380400001)(66556008)(8936002)(8676002)(4326008)(6916009)(2906002)(66476007)(478600001)(52116002)(37363001)(547064002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZVdUMDV0aGxlSVZRc28wT2pkS29pa241SGthSFU0dFVKMVRDb0pTK0hMTThX?=
 =?utf-8?B?OW5IZHVEQ2xtZmxGUENUQVhmcGRLV21xVjVlbmN3WHBLTWFaTVJldXlISHlL?=
 =?utf-8?B?cEhPaVlXVFZ3dExjMUdMUVBjdnI0VDMvNHAwY3lrUFIwbmVLR0VhbEc2SUgz?=
 =?utf-8?B?dDdkWUc0YjdIOWJMNXBOWWc2NVJRVjVvempwQ0FpcEMrdUZIWWxSTUNRNktW?=
 =?utf-8?B?b3VTYVh5R2RMbUl1eWVpbEU1eFY4TVZ3eGRFNit1ZlkxdHBSeFIrSUpzdlI0?=
 =?utf-8?B?QllnZTVOdjcrcjI4V0cvUU5CZHNFMDhOMUgzK09vZWlrZitEMG9mMmIzcmx6?=
 =?utf-8?B?TTlQS25WdTVLY1F2eEhncFlSdWw1T292SXM2TzNHcGs3WHlNeXBwNVAzVnJX?=
 =?utf-8?B?aytHdTB6QVYydHA0c0RCbDRPZzRkekFZTjAwY1hQR3JuOWhWQTZRckVJeEQy?=
 =?utf-8?B?MUtHOFhjbER0RWJhUTdIaStaZDY3aGxRQVp4Mk1LNlZoSE8xZzgvcjRTdFVC?=
 =?utf-8?B?NmFlMUQ0ODU2UTVkM01ZREdXUXlWeFFaSDNxWUttMzl2akNOTWc5SU5sWkdn?=
 =?utf-8?B?cFAydjFuZmR5c1hzb284QTcrRXpNTy9Uc284bWZOYThydUZaYklhUCt4aVUy?=
 =?utf-8?B?N0NFSGVISFQ0Y2NXL1pBSm9GZTZrUHlVOW0yS0ZxNThoVmx6TWZUY0FrdTNn?=
 =?utf-8?B?VlFXdDk1YmhjK0RLOThRK1FFUUxraHJHc1NoMWxMN0FROWR5b0I2cStsQlVh?=
 =?utf-8?B?bkhTalVKTlRxV29SNGx0eTNMU1c1L3hObHlaVzdKSGlBMjQrRngwVlMzV0Jk?=
 =?utf-8?B?MFF0SU9oUW5rVTJ5LzZnT0hIK3B4YktSNW1MRUVkRUZXdGp6TWJybm4xa0lx?=
 =?utf-8?B?V0F6emVGYWFOVWE4L2RJTEpRLzZ2MXNObDUyVnpQMisrUVVxTHQwQVRjTk50?=
 =?utf-8?B?Zmcya0U2dmJTUTNWNUlWMitkV0FJSlIycWFBbWI1WnltV09xcWdsVHQ4TzUr?=
 =?utf-8?B?Mk9CUXZoMzQ5RWZQUXRMT01Mbk9rdnVPd2tBWStVUmJFMHNyK1oveFpaMzds?=
 =?utf-8?B?bUN0YlB6NWhnYnZCT0VhSzRLeDR5ZlZrazA0bEJhbEFVeVhoRW82OEpqUmZD?=
 =?utf-8?B?SkZsamw0ZXdXT2dCU1lZdGhDQkcrZkYrVXFHbmd4WENjZ3FFVEdnaWNzaXRn?=
 =?utf-8?B?M09zTEd0bEJ1RWljT1U3bTAvZ0FsczhjSnRVaVdoTEtPN29haVJpS01ia2xr?=
 =?utf-8?B?K3g1M014NWpPWnppMGZscERtNFVOVTNRQVllME1VeFRJdWFramkrRG44T1pY?=
 =?utf-8?B?cFZMY2p3L0pURnhLM1prYWFRL21SSEVaQk5uK0p2UW90VmkzVWpKakZLM2VU?=
 =?utf-8?B?ck1wcTNCUXpTeTZXWTlMVHNmc0RDLzRLaVZpbmN2NzJ6d0tSSGd6NHVtUmdQ?=
 =?utf-8?B?UC92QVFEM3dDbmVlRExjR3hkb2xIVlFsMTF4aFBmQU12aEwvalRwaHVUTXpO?=
 =?utf-8?B?enRtSzFBZG1IbkJYanBLZExKZEplZWp5UGFDY1l6ZzczZ0dYVTdTZklja2pS?=
 =?utf-8?B?WnNGNm1YMGNNcWlndTNNeEowbmlGTW82NHdJNWtYclFHUVFiUmUxK2Z0WEpD?=
 =?utf-8?B?dks0cDcxL1J5Y2pSZTFMVzVXaGxKQ3ZNMGYraXJsczRJa0QyZjZ0eUpycGtm?=
 =?utf-8?B?T0l2S1c3U3g1d1BaS0U2bEUrY0xoZnNEMC92aFNHL2hieE9obUF2OHNEMjJR?=
 =?utf-8?B?eUM3WkF3WjhibDFKWDlyQ0NmeEoxWmRIeTcvcDVob3dyQWxKMnNVdUxMT2Y4?=
 =?utf-8?B?RGpNN0hTOHozMSt0dkVtSVJKMWRPL2h5NVFtZ3JkTW1FK1JXL0M4OUtucHU2?=
 =?utf-8?Q?BRsVXXNjn4/xl?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5df6a06-12b4-486c-1c99-08d910d4a74e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 21:19:38.0618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3xJKbU7K0S2NfHQXis7nyA3ndy8mcviT/bbNqzxBZ5tlDPrgxjFbtAtm/pskguUl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5918
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Calvin Chiang <calvin.chiang@gmail.com> writes:
> I guess after i make the change in the cifs.upcall.c file i need to
> autoreconf /config /make /make install ?
> is it correct that this will overwrite all the files from the
> cifs-utils package on my machine?

Yes you need to make sure you have all the dependencies required to
build cifs.upcall (your package manager of your distro might provide a
way to get 'build dependencies' of a package). If it's missing some the
configure script might disable the build of cifs.upcall so make sure it
is built. You can run

as regular user:

   autoreconf -i
   ./configure
   make

Check where is installed your current cifs.upcall ($ whereis
cifs.upcall) usually it's in /usr/sbin/. I would recommend keeping a
copy of the old one.

as root (or sudo):

make backup once:

    cp /usr/sbin/cifs.upcall{,.backup}

then to build and use new one (rm is to make sure it is rebuilt):

     rm -f cifs.upcall && make && sudo cp cifs.upcall /usr/sbin/

Good luck

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

