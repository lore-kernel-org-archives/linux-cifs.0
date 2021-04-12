Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27BDCC433B4
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Apr 2021 16:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0A876023C
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Apr 2021 16:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244839AbhDLRAH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Apr 2021 13:00:07 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:30350 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243689AbhDLQ6U (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 12 Apr 2021 12:58:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1618246679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Duc+g0ge5n+ZvVu3Gi7zPRmkGbOPW7zEnJbLmZh/sDY=;
        b=GuIyNHsO9icJLkEFUhPgQVOgvQkQWyt4Fj1oI8NFDXoC2c4D5hkL7szarPp2jA4bUF6p4M
        8Ku5JI2G1Ar86KcZ7T5Vrpv+WDBz7zD2b2f86ep+2lKhcv0/IAVM/PiS+CA6cvmsADsm9+
        kzQjhUF+osjXijEtCmmMsYNDLf99tcc=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2059.outbound.protection.outlook.com [104.47.13.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-25-TNdbd9bMOUGCy-0Nkq7uBA-1; Mon, 12 Apr 2021 18:57:58 +0200
X-MC-Unique: TNdbd9bMOUGCy-0Nkq7uBA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJT5biPMxqcqbD3qJEty7S7efP0U9SS3rJ/o1zMnSR7Ee7nPEN7rNIMYWH+CJya+0/8Di8IeYQMrfIIB131gW2HJU9yJqGFuajKD0beJL2flBv52eMu9Kj1JSkWHuo9Tn6RFFozPfqI74Vqv9UsMZ2z4Q1EdRarmRxIs3RH8qur9OB/fb/pE5WuQyTXJkAnVGUyeJdkt2MPvC77lDy2A0nUVrHjm4uPd/uJtwjzA8fi1GA6Nsd7RhSXhBWRwRa+58tmWusqZhNVwyqCPv2zYOXS9kB4P1688zsPiVuoR1T+rzr3+wKb2IVizqfU8Y9hUanjFKrJ3qQ87yBsVckyOdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Duc+g0ge5n+ZvVu3Gi7zPRmkGbOPW7zEnJbLmZh/sDY=;
 b=QlIug+p3hqOPVKzI49//ewTn+BQXDj6+4ygLxoM7JSD69s81AizgPxmuqdpJY/kPYXaSugovRviBHV+hz19gJFMqiEZ7SoABQPt2b32guKjZft9f4w0myKPOX9pkE4Des9PQoeAS+7J9G2vY2C+vnS2CiE5gsdXNAz1gGUJk3AA/0A9gdIsmQtw+Gfneg+ulmPulFwcaI40I4but2lOOKE+vbqKGsfFI1KNYRHGP5SEDQIjSvbSfmQBi+7D3ONfOMKreAQGehqUn7KyO+clNyrbbcPAzWxwnS1oQJpr0JPjiSfLdJceMLpsWQu0yLPud5XmaYeFR7YmpH9hSwoDgzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0402MB3517.eurprd04.prod.outlook.com (2603:10a6:803:b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Mon, 12 Apr
 2021 16:57:57 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 16:57:56 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Rohith Surabattula <rohiths.msft@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>, sribhat.msa@outlook.com,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Subject: Re: cifs: Deferred close for files
In-Reply-To: <CACdtm0avBPeuxEvfymnVk4eYCYO3fCiywJWH0VYmVGiM2OL9_A@mail.gmail.com>
References: <CACdtm0Y1NeC0jNTOtjhTtGRt0sfyhyxC=wNfMu1eqibe6qJbwA@mail.gmail.com>
 <CANT5p=pFU=1OKiBA0m0_Pqms4Vsxz7omEgvfDDAb8U3M4-3qbA@mail.gmail.com>
 <461d79c3-1b32-b0f8-157c-b5d4b25507d7@talpey.com>
 <CACdtm0agzeVRiQg1zZjm=jFrf-gSQ-+YGc1Zm1xN1Pd9tJia4Q@mail.gmail.com>
 <49874720-dc76-2660-17e7-f7157a9725d4@talpey.com>
 <CACdtm0Z5BfbHp8Y2nFLv0k854hDe6-j4xtYDP4oruKPOtxxz2Q@mail.gmail.com>
 <CACdtm0ZYHjHXt-n8xnRQgZ+ZdLw4XVdb_yCK3Q_QSG4SrK6_Lw@mail.gmail.com>
 <CACdtm0YhpOW+7-ELLOk97utOikU-06Zccwq-2HK+h3aFumnedg@mail.gmail.com>
 <CAH2r5muCvxAHPOac4Ai5fxK_TLYiSw4LKy0QZv9iVVJoRkdCew@mail.gmail.com>
 <CACdtm0avBPeuxEvfymnVk4eYCYO3fCiywJWH0VYmVGiM2OL9_A@mail.gmail.com>
Date:   Mon, 12 Apr 2021 18:57:54 +0200
Message-ID: <87blaj30fh.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:703:389:f439:5b5b:3992:60b2]
X-ClientProxiedBy: ZR0P278CA0017.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::27) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:703:389:f439:5b5b:3992:60b2) by ZR0P278CA0017.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.19 via Frontend Transport; Mon, 12 Apr 2021 16:57:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0911b0c5-2162-4a1c-0809-08d8fdd41ee7
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3517:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3517B28F9C7B074D07E29FDDA8709@VI1PR0402MB3517.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sAQdn63Ts0RQY+nLON+eWxhVH85umkAPpsGS2pS72GQS95E3RqQXJ1EB4FvBhQ7E5jZuKIwxRUISk81W6WCR1kE2s9R7NC3kjAm/aHNMpe89IFQKvemLEUDCo593ynOP6cMJMpxxNIwx2uiITYaeJgo4nTylQSA+f72cosjfx5IGa9eg0jpKHmQrx8ghj0/8pfLSSBRtgmdbt6K6xsYTbJQLF9gKFPIZmHA1JTAQa1PyAaM2EfXkxcRxIX8HovfAtRRPpLCxrKH0Mhqm9yWxgMtRS2wnPPZ/x9h6kcBBN4lD/pQH32sCJwGoymWlcqptvjkQs4JMm0Blhz1YISVjQ5LR2yVBYkzF6XKdIwMA+uxayfS8Z0dAAoVBNkiHtqA7kbpf59+E7NJTliZNPQpAdOfKUmTfEuyk1DJAin1IG6b5AfX0SbGodowTyCFMNjYWc68ox6yn8435GXiP5g+whCXurjGAF0nZyz7uPbibmH3FgB8RTq9zkLxhxM4P6q/VUyHaiwz9g2LMWZwqHjEPZCh21qI3ICJz7hrhmVG85KckpdPbGh9CmKmtHbfFCyOQJfOw7nxJZQyVQuT9ztyLMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(136003)(396003)(376002)(366004)(478600001)(86362001)(38100700002)(8936002)(66574015)(5660300002)(6496006)(2906002)(110136005)(54906003)(8676002)(4326008)(6486002)(52116002)(16526019)(83380400001)(2616005)(186003)(36756003)(66946007)(66556008)(316002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cUk5aitIWG0wR3YxdlBCL09vYWxyVE1UQ2xEd29UZDJKZ3oyTVo0dWpQejF0?=
 =?utf-8?B?UDNlU2lDUkF1bTBhdjRhZ3lnNVdrcVQ4MTUzTzdpaXFISWhFelZZL2tpQytE?=
 =?utf-8?B?U2l2dGw4QTg3QlAwZWNJSnRQNHRWWDRKUDU5akw0SDhBRkl5SWlNckx6Rk9j?=
 =?utf-8?B?U3pnVmpMRWpSMGxGMWNpelFId3RMdkRZK1NZQTRGTUQ0YWdOWVc3aDIvRWNh?=
 =?utf-8?B?Q1NMWDFwV3VnQ1lqbVBrK3czZUlQb1VWQXhWQmsvbE9xMm5hc3FMZkZhZndG?=
 =?utf-8?B?czd5bkpPb3FINEsvSVhkTGt4V0VXMlRRMWowK0k5QmxRRWxsVFU3NXcwWEFs?=
 =?utf-8?B?TlpkdnlWajJ1d2R4Q3VGR3FjRFZ6MjFlVlg2dU1mSGkrNE9xZXU4SlhaQ3kz?=
 =?utf-8?B?U0NSazgreVBLYjBIY3NNZ2tpNWVRa2dwVHpja1lBbEhVOEJ2QXRPUDduU2Ir?=
 =?utf-8?B?V1FLOVVMWUk1Vjg2YTlKUUJpNkFZbTluRXVsU1Jzbm0xYmdUZlVDYlMzRHJx?=
 =?utf-8?B?NGJOV1FyVUtoeGhnUElwRGsrRmN6bjROUk5TQVpQSzFlbXcrSWRpQ0FUWDRC?=
 =?utf-8?B?R3pKdzhNcUtFS1d2YVFLeWZWZnMzamtvK1k4QUREZ3Z0akFOcThHUWJiM1d4?=
 =?utf-8?B?UTZ6UytxOVAzcDQxbDJ0ejZWWGFxNnB0b3dNcWlIOHRUNUYvZ1hXKytRbVlh?=
 =?utf-8?B?eGRJeHd0SVczbjV4NWJ0QnVyLzY2MTE0Wmh4VmRVSFdYV1huRzhYV1dudUhu?=
 =?utf-8?B?WHplQTdMd0puK0FQRDhVQWJpQTg5RGc2MDhhM1JFTDdFdVRVQU5hN3p0SzVo?=
 =?utf-8?B?S3hxd0VBSmFuY1BiaFhuanNEZk9OZUowdDVFM0xSU2FOY2hMTjRLbWhJNFNE?=
 =?utf-8?B?bTZURzFLMGNVRy91UkRHUUN0dE90SFQvVkt5VVF3N0tYbG1xc2o0ZFZXRm1D?=
 =?utf-8?B?djM3cGkyd3BtVlRhOVNTcWs1WFlkSVV4YXBtN21QWHNlR25mdFZ1Qm8xOGxL?=
 =?utf-8?B?N2gwL1FUMVUxci8vVlNnMjF1UldTeEt2VmQ1eGhhQWYycXJtQXhPRE94NEtD?=
 =?utf-8?B?a09vQklOVUozZXY0QXpUUFIya05MTlgrTVlpQlJEam5JbGxKQ0NWSzUyMldM?=
 =?utf-8?B?aVFabVhNc0pGbG1meGR2WnVFSHpGbmsvdk8yYmE5d3VuNmwrcDZ1amo2d2VT?=
 =?utf-8?B?V09TNGd0bXBzekQ4aEVyNXE5M1JSQkFKRFhIM2p6bDlPd1dmSHp5Sk1rSlpD?=
 =?utf-8?B?SVpQMUdvSGlKUDdrWndRcENGeElhUXNOZThGY25DUzVxS3Z4Vlc5eXZvNVd0?=
 =?utf-8?B?bnFyQTgrd093UGJaT2szMXVmMFpvLzFTaXJYbkFpQy9FUVpldTBETEszVDA3?=
 =?utf-8?B?NDVKU25ramVNOXI2OUhwaFhKa0JDM1lFMCtGRTdaUFNvSnpieUppSzFXWThR?=
 =?utf-8?B?OUViV3BicDRHNUZKUW95N3BGK09hdTA4Ymxkbll1dWpRL2tpc2hXSUVEYTFz?=
 =?utf-8?B?MXZzUC9ONkkzYVduZjFUQlVBN3FRREFENkJ6clZHVUF6dzRaSXpHV2k5Vlpo?=
 =?utf-8?B?N0JuYjRiRWJzM1FuNjA0S0ZlRVpYM3J0TlhBaUk2NUFhVkMvOG1NOWdwZUNL?=
 =?utf-8?B?ckttMkczdHlubGFpZEpGdDJ3ajVMYXJFN1dSbjlZSGZQYWZQZzBBSmwxZXpW?=
 =?utf-8?B?L3ZkNiswcUtqRXpzYU5ZNHpXZFZrWTBocTFCd3RYQ3NULythTmZ4MzVmdXRq?=
 =?utf-8?B?THNOWHh3aUlWc1h4bUZXTCsvdUxDRWRQeHVIWlhMQVpRV1IyaUgwMWNJcSsw?=
 =?utf-8?B?enFHNUNMWVJodDVINm5KVmZjYms4cDBDTml6Ull6MW1SV2RYenl2a0U5a1hx?=
 =?utf-8?Q?0DuidRqLRclDl?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0911b0c5-2162-4a1c-0809-08d8fdd41ee7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 16:57:56.7915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HkSSMyr/yJtrFPCrrKrhcVUlwHtM4nezTsoX66pT1ZwIzIiB1SbnWT51TRjqEU3z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3517
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


I have added test cifs/105 that triggers oplock breaks. I think it could
be used as a base or be modified to test your code (unless you already
have some script). In anycase I would like to make sure we can trigger
the codepath you are adding on the buildbot. My script is in
/root/buildbot/scripts/fedora29/cifs/105 and it simply calls the
optest.py script in the same directory.

The code is essentially:

    for x in range(n_children):
        pid =3D os.fork()
        if pid =3D=3D 0:
            for i in range(n_it):
                a =3D open(fna, 'w+') # file accessed by first mount point =
A
                b =3D open(fnb, 'r')  # same file via 2nd mount point B
                b.close()
                a.close()
            exit(0)

That python script mounts the same share twice but with -o nosharesock,
to disable connection reuse (so you have 2 TCP connection).

Then it creates n_children, and each children is opening/closing for
read or write the same file (but accessed through different mount
point) in a loop (n_it times).

If a process has opened it for READ it will open it with a READ lease,
so that multiple client can cache reads.

As soon as one process opens it for writes, it will make the server
notify clients that have a READ lease on the file to downgrade it. This
notification is the oplock break.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

