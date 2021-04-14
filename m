Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 122C0C433ED
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Apr 2021 09:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DECD060720
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Apr 2021 09:21:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347523AbhDNJVY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Apr 2021 05:21:24 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:25856 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347352AbhDNJVW (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 14 Apr 2021 05:21:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1618392060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NPrJP5T0uGbl6isM91dm3ig7tGuKA1BSeM9Ufc+oQhM=;
        b=Wp3co3EkvY88nLBmgN3yId04eCkb+qgab3vURmLiSZY3fWgWpnc2l495e6d5GYuPg7s7po
        f+GBrJHC17Bdj1ql9zV2ohQP1N6nTTks9bYN4ijzblLNQPVGNOtU7ErTetViAgqJG5GCJn
        B3yUIFObvnctlJUBpyiA+QKR3MP06jE=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2058.outbound.protection.outlook.com [104.47.1.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-4-7QBFvz5sNoilJ_jXzLi4ww-1;
 Wed, 14 Apr 2021 11:19:33 +0200
X-MC-Unique: 7QBFvz5sNoilJ_jXzLi4ww-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VoGI8TGurJIlm6UvlDWnpFrprRg+OEziYIJ7Isvlnds4sWQnnXm7ED5P633UsQhL8jIntFEh4Lcxbzr/sJ9HmdJhEJgbcCvekB2oBVaeiLMq73PMosz8oRDuzmD61pBvBJDcvPT3cUP06dOld/GvdBTIN6LOIpwtoKZfBN1VVlpoXUD2zBHk5d8Vy6264UY5u/uR4b6rw1XFFcm/CKHIEZ4FPhpqHrhz2jUzzpqKgLmRTiKr6QIY3CXhbpvFGg1jR2/4TD4AS+Uf9v6XSr7kMYp0YtODDFdwWQaxh4GpoUPfNj4Y+xDizXLVOLmwHwMeeIi2PVppyDT2I6ZMh4FTOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPrJP5T0uGbl6isM91dm3ig7tGuKA1BSeM9Ufc+oQhM=;
 b=jBD5seJMhsjbhCckkUHHCfL9g87H9VKPpioU4rKpkXe0za7YfzYwvtAi5D70xlbuqoae7NOYmGdgLoPJAFtaWwTmKHfJ3r1EACp4gZKt2mDFWsLUvJSc+Yvzt379qri0XaZRUVDepyUFBG7Qz0yU9lCQdqBxlRvr7VtdJybtGA8kYWqrw9jFQAI+DEpBp+YcZs7NrJ7CsBAS6NDQzhSADEXTU44kpiqYZcaakt7v8Ty3MzbeL5lyXG9aIkF58Kueblq17mb5ptrm9TMlS1PLtiuq0OcbGYcq3nukj/aW02xrSRKYGyu5AlHw5iSYLsepqd0yF7q/xJHpBx0NLyTDkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: tlinx.org; dkim=none (message not signed)
 header.d=none;tlinx.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0402MB3887.eurprd04.prod.outlook.com (2603:10a6:803:19::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Wed, 14 Apr
 2021 09:19:32 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4020.022; Wed, 14 Apr 2021
 09:19:32 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     L Walsh <cifs@tlinx.org>, linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: multiuser access and group membership(s)
In-Reply-To: <6075ED6A.6010603@tlinx.org>
References: <6075ED6A.6010603@tlinx.org>
Date:   Wed, 14 Apr 2021 11:19:30 +0200
Message-ID: <87wnt51avx.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:703:334:3d56:188d:3047:1bd5]
X-ClientProxiedBy: ZR0P278CA0131.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::10) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:703:334:3d56:188d:3047:1bd5) by ZR0P278CA0131.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.20 via Frontend Transport; Wed, 14 Apr 2021 09:19:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2275a19-4b4f-4067-0df5-08d8ff2669e7
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3887:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB38871A440F77ACE5210E0F1EA84E9@VI1PR0402MB3887.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 700bXIcCbNsHh80ZFjuWVKp5P+QrwwZveq6sbCHurDuj9qW1avcz/G/oChJXVvmniy/RQ3/yqo2YavTEIlV5bEXsCNkcVZGUJOxK7667PYGdsFbH1XgMeIOKWN2abxZEIxB6w5UR49f6gHjXX/q2EZGvReDO3uauP3eLNMeJgvTB1mY1xPYQ/xzUFecYd+l0AtqmGKMbQ3+eW7CWJYHEC3bWmRIPxS50FYt4IM/+JE1oEpbilto4RgOyNvMU0vQ+3peZkXbeksLtO8yJwdBr/4NsAMCPLmDOCp2PXFLH0dR+2+uBOQOYuIu4J1cR4oUav3OBO/ZP3Dxc6NmSt0zNDWYovNtLC4VjJp8liHxdFUJhASBF7fC6PhclMsDfQq2pit2gr+cZXs32qYm/pc7EyxoKnBhEZQ7PxwNNkZWnHcemgUuqNyeB2WkWUy9SzrzDcQ5a/LSVAnucXas5BGVpelgLKx2i0OZD2+Y82c8sgD2J1EX+StR+i0d5n/sAVptcPCywmOGlzj7aTYQQn5SeWSEOszBryCJP3NPiwavUB1LLI/LRMppXWz46N6+ub8HGjLFQrULMaYp+ce5gVDSi4/HOIMxNMFQzFcn6P+r4nRzDJ0fHtI3wWJw1b7e8zSoNpGnrZlA1ZaVjL92KJzd9kg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(396003)(136003)(376002)(366004)(346002)(16526019)(5660300002)(52116002)(36756003)(6496006)(186003)(83380400001)(38100700002)(478600001)(6486002)(8936002)(2616005)(8676002)(66574015)(110136005)(86362001)(316002)(2906002)(66556008)(66946007)(66476007)(403724002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WEJ6bm4yMnpmMlJLbjVRbU5sdHdUVGJnLzJKL1pJdVpwYTJGMWh4dEFubjBl?=
 =?utf-8?B?b0dLME0zLzdmYjdPajlPOXJpcURUL1Q0ZnpkWWdGTXROUVVuaGd2WW9pWFlL?=
 =?utf-8?B?M2xJOC9EOURCa2RjUFp6Y2x2UHQ1N2FRdkZZaUUyeTdIaGVsTVRPSzZHUHFp?=
 =?utf-8?B?cElCUDFVa1VBUittOU5tWHY5dzFHMHAweEhBU1Jiak1oZFRIOWJMejk5OStp?=
 =?utf-8?B?cTNXd05mY1Bxd2pHUDQrZGR4VkhneHh0a2gzeDAxYzRYOXJ5dUNVWlpxMmdZ?=
 =?utf-8?B?UlpianNPSWpBUFJKdGREeDRyL1Rmd0lxNC9PMkprcEFXblg1ZThBVng4cDBM?=
 =?utf-8?B?Y21TQjVES1ZLL2lGU051R0tmY0tIN1pFQ0R0TjVGNFRzTzNFUjgrVjdGeHlS?=
 =?utf-8?B?Sm85ZHRIRUxvb0dSZHhONCtveTdKb0Q5YzlXVHhadEZhWllsMjd2QThnb2Zv?=
 =?utf-8?B?TnFrcjhCTkZDSFdYYkRlNFJkcnUrL1RVaXVtTjFkSzcydHhxMS9ZakNOM2lY?=
 =?utf-8?B?ZHpQTnNYWjJIYUp1bWlTaCticXBHQXVjNEVicjRDTVZ4R0NHbjN0WC9BNXB5?=
 =?utf-8?B?NDNaTTVuVzVGZUdVZjhzSHFsK3BXb0pkYWZQNkRqcS9ldFBXbERBaHhvdHJN?=
 =?utf-8?B?OWNqeHhxa3BTb09HL2NGN3JBZS9wZkVjZThGbDYyUCsrTGR1KzNYT2grT0o2?=
 =?utf-8?B?NmU0eWhTN2RReHRIcXBkL1lnQXJSSEV5NnpJeUNDRWplb2gvVXFsQlRMVEg3?=
 =?utf-8?B?ZGVjOTVrYTBDeis3c1Y3YlR3VFR5UC9SbEdwT1NCVjV4UXBVSmJ0dytmK3NR?=
 =?utf-8?B?Q3NMVnI2NXQxaHBhNlN5N1phSjdpVnVDbUFXZW5DakRqQXQ4VjFONE1IV0JX?=
 =?utf-8?B?bWZqVEVaWU1pYXBaRW4rL3UveDZiVWlEUGRReVlKZS9kMXIzMTlaWHE2UWti?=
 =?utf-8?B?eFpQdEdJbFJ1a2tlZmdpSHh0eTdyd0JuSDZsM0tId3UxNnJ6ZnpiSmMvNENz?=
 =?utf-8?B?aU9oTGVlUjBRRXFSUHMwcUtCaUFaZDFVL2ZPMEZlS0VZZ1Rnd0VUYStIYTBM?=
 =?utf-8?B?dUgyNXhETC8xLyt4aXFiWUY4c1RiNlRNQUpOZDNKeEx4czJWWE1SU0N6bjNQ?=
 =?utf-8?B?dHJ3N3JMYkxvbUFUZlB6TStjeFBoMVZwbDFNYnZwUm1FRG5TSkg3RGZ6RlAw?=
 =?utf-8?B?NGpkUHZmcENHTFM0cUZJcG8xUnZib1FBY0pZNHZ2N3hLUncyb1FuZ2FxRzZ5?=
 =?utf-8?B?Y2hjeFVTdUd1aDA1ekdSRWxGU09xaG5rTEdHL1RLVVNBTGFwc05nSitpU1pq?=
 =?utf-8?B?eGhPdzVQYXVTUVdHVlRCbWh4aXBpT2xCWlIwT2U3VGVmdHRyVk00QXhJZTFQ?=
 =?utf-8?B?ckJnTUxFMUxPdkw3bGJ4b0gwblVtWWhZY1JzTkNCV2pNeHM3d0IwMTVvd1NH?=
 =?utf-8?B?VGthMXoyUGxXM0wydDVZekY4RDFGNEZ6b2NOSVVaU0ZnQnNJYWxKam54M0pT?=
 =?utf-8?B?aVkxMnNJTitTUkUvZ2ZYb0p1eVZOTXZvd0N3ZUZ2UEQvSThMRkxkYk5mbXZH?=
 =?utf-8?B?S0N3TzY2UVBXMExndHhtZFNBczl3a2ptdWtQSkZVTXpXNEhGVWErNUZIWmV2?=
 =?utf-8?B?UjhieFhwSkVOUDhwdy9XUWtoOTZabWVJaEdycnp0R2xKeTRQSm5DVnVGbXMz?=
 =?utf-8?B?VWpnbWJ0amM1eXNDek94RTJsNERrZFNIYVNvNEJRSVRMMDBZUk5PMXdtRHlj?=
 =?utf-8?B?L00zRVJxRjZsVE02ekJpOFNNalNYRlNwRGZHekZBc2VSd3daSnc2TnlrRGhC?=
 =?utf-8?B?UDVYMWNyWjN4M2hqRzNBOURHMXNuUEt5bkNGQUdDUk14Q2VUYVFJcDhXQUE5?=
 =?utf-8?Q?ch/QZfFtQNFVg?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2275a19-4b4f-4067-0df5-08d8ff2669e7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2021 09:19:32.4644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sRXKppZKkYIFw1FypZoKt8uQFsD+PkhBhpOn2X7ZmnHFc1nwCUjqHJ6mYRV4wzA7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3887
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

> Surprises:
>
> * Files owned by local accounts appeared to be owned
> by 'root:root'.=20

When cifs.ko fails to resolve sid<=3D>uid/gid mapping it defaults to
root:root.

> * Files in well-known-groups, seemed to
> resolve ok, but didn't recognize my domain login as
> being in one of those groups.

Make sure you have cifsacl along with multiuser. In my testing
(multiuser with kerberos) I can see domain accounts resolve fine. Not
sure about local accounts.=20

Keep in mind cifs.ko is delegating the work of resolving to winbind. So
I would suggest trying resolving the things that don't seem to work
directly with the wbinfo utility (see --sid-to-uid, --sid-to-fullname
etc). My guess is it won't work either but it could be easier to debug
from that end.

> * Files with group ownership of Administrators allowed access
>   regardless of permission bits (though I am in Administrators group).
>  -However, files owned (showing in UID) field AdministratorsGroup
>   showed up as being owned by 'root' from the linux machine  and
>   didn't enable access (though some other rule might).

cifsacl mount option will also enable mapping mode bits to ACL but in a
best-effort manner as a 1:1 mapping is unfortunately impossible. It is
not very reliable and we also have no tests to check those mappings :(

I think Shyam worked on this recently, maybe he can comment.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

