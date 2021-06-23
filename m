Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 074ACC48BE5
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 11:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E657160249
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 11:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhFWLno (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Jun 2021 07:43:44 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:32682 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230308AbhFWLnn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 23 Jun 2021 07:43:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1624448484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EFCbHOWus0ZZp0tJfk8Avib1o5HXPQPfPCBA24h9B+k=;
        b=IZGGNFv278ur7zqnrGQu0T8d2ors1ty62yih0R4Ewj6oeGQ6+Lusv3b73MQ8Kz86FGvEqJ
        WcDS4dtFLA8ukvdyw69fUHmRsv/khvNzB06cGn+bFB+vUMoeOzzjuFqsUN8+AOv/dRn0WI
        9ycq/ijDv+0/VufG1a/pRHSWYk9i28g=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2051.outbound.protection.outlook.com [104.47.12.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-14-F4thxzMpNw2_rbqQv9Anqw-1; Wed, 23 Jun 2021 13:41:23 +0200
X-MC-Unique: F4thxzMpNw2_rbqQv9Anqw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUvQXKmOop7HDYD+tWrJY+awzjPFl77J94IlUTioxi15AX/kwPfLQznJovr1urWmPP52EJ0utPe6KuH9bHovlLCfkJwun3F5cI8Q1BRGAb5lIZEEwjEMOtCjhfD/KWUY7w92is0RIN233EaTyqJOb2PMLaJOum5PdOtt7AaGDQ536/M0m5fDL+PP0W1kLalTD9/TPsuZzB0OkhaIGo+vfG3dlzeWZhrsP1JCMH4ufyPZWZBvqhktj3qfwsWO4FDg211SGlJw/8o14i+/pDFJIRtaSBidrp5/Tl7d1OT4nFYpX7cIkTrYA9s/hOaJxfAUDV3aMGhh198fQJuktUu/9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EFCbHOWus0ZZp0tJfk8Avib1o5HXPQPfPCBA24h9B+k=;
 b=amXiGNGL4NuK2jVDOPeO6I89gT3ulB321EsUtwwtu1D/bziHW+dYPH7dyXVkAklxR34K3PwXYcpSMKs3fPaCGIqkd7+NXskLUGbuNf7sL7B9li2GNrTlHTaaK/pkhIK9k5WIDCsIUI39m6M3j/YYTuEShTTucWIENfN2jkumdnDGSzTJmzxU8pOkK9p4riqeOMxBV13i2NAfOksmtpIlo1AVdU+2OYRWo9qJ5v8Jm1XJOizIoMbywMMC/ypbDZfWblZSTxy5YwbMrDpGQuXBmQIY1wZlO4QwGHVnXyD4MtYYEpEO8kF93nl7przGOAIApkdllLa/YbQSce/RXZdq2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB6222.eurprd04.prod.outlook.com (2603:10a6:803:f3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.19; Wed, 23 Jun
 2021 11:41:22 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d%6]) with mapi id 15.20.4242.023; Wed, 23 Jun 2021
 11:41:22 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>
Subject: Re: [PATCH][CIFS] Fix uninitialized pointer access to dacl_ptr in
 build_sec_desc
In-Reply-To: <CAH2r5ms_paV2a7KZwWkmz25pn4iS2kEDErGpNapOWZ5Kd_bUNw@mail.gmail.com>
References: <CAH2r5ms_paV2a7KZwWkmz25pn4iS2kEDErGpNapOWZ5Kd_bUNw@mail.gmail.com>
Date:   Wed, 23 Jun 2021 13:41:21 +0200
Message-ID: <87bl7wreou.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:70a:9978:e3b4:c6e6:8f68:a927]
X-ClientProxiedBy: ZR0P278CA0039.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::8) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70a:9978:e3b4:c6e6:8f68:a927) by ZR0P278CA0039.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Wed, 23 Jun 2021 11:41:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a21033f-fd41-4f58-1cb3-08d9363bd30d
X-MS-TrafficTypeDiagnostic: VI1PR04MB6222:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6222131F660FBC8121A529B4A8089@VI1PR04MB6222.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zRFlIzh1beWt74gbhCC2DPe6S2JXXMesHbeK2tXWCi2RBRKEM2/KpSFv6H61v6MvoMG0kF/NU3qJ/crdlTCP1noUJarPCNYYUaOXzJ29+aK5b14ktwmv3hSeYJfH1BCJ+hR0RggHNt+nCnBmGmQFtzqXmdX2xPAzO5NSKMknKfavycUtOP4pN3M/T63wJ2VeZF/1sZO7P3ds9cEmaI8ynaMcsoWZbJsUbArT+cbhIba6yJYMy5/0Pkbqy878NGWs3DSalm85xRDJnL0gaOp5xxl0UNpao/G6/D0qglTZ58188pLkLnp1CCzrqdLQgVYx4rUuhmfJi1u62s9Pg1vecjK9rPoI6cKvfN/4j8EiVgYQjz+LTjL36Pps5FRuHeQPgqRiNfliXomh1+7UAT7UsJv4JrrPJu94PGFdFfjQIIQFQNOay9MD7rvsGQTgt05RE2e0CaBiCkbnCWUFIWrflnchDzAsAdwsIwGB7WVfFE4wnE5EmgWMPjL9Em/owaSoHTaHOYzWUJ0L6JsoBfJkdMZcW8QZXDm0tqqwfoWFyh4t5iJsD+JYEPRT6CCKxaAq/Av3ukPj48KGJV7JgJXVfGiayhD05rLCDDVh2ewd+o0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(376002)(366004)(346002)(396003)(6496006)(478600001)(38100700002)(316002)(53546011)(110136005)(16526019)(83380400001)(4326008)(6486002)(86362001)(186003)(45080400002)(5660300002)(66946007)(66476007)(66556008)(2906002)(66574015)(36756003)(8936002)(2616005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alZGL3JZSUJ1em4vdGJsUFgvM2toQzdaS0FKanRzbU43ZklnaU5MSElzUllj?=
 =?utf-8?B?UlgrclZKVnR3UFZHdExzVFV2QVEzZ2c5c3hsWGxDaVJhb1F1ZUhFRnJuRG9F?=
 =?utf-8?B?ZVZTMW9jSk5qeWN6MytwbThXaVBYQXdmcnliQTRscFNzRHF1ZDlnQU8xRWhN?=
 =?utf-8?B?Y2h0ZXU4TWg3dEYzbDZKS0E0YUxZaGhxRzl5L1dIdU4vN2IwUVZHMmZEaDJt?=
 =?utf-8?B?V053R0JuQUFTRlU2NVZ3aGJGS05vYWdIdWNLdDhYcW1uWmtzZGJ6R2xOY3BI?=
 =?utf-8?B?OWJuUXdVOXhtb0I4WGZLWWhaaHpRUVR5Z2lqeU81WU5wUWtTYjY2THA1T2dE?=
 =?utf-8?B?SlMzeUtlTDZWQzdLbnE0Q09RY2VmcnhRREFWV2szczJJR2lhRGhKd2ZVRnVm?=
 =?utf-8?B?RUZodWdpMHVXcE5MUXQ1VmZvOENuNUs4RG1oQVN2NGxCbjcyQmZCVWplOUtn?=
 =?utf-8?B?SGlkTC9oTFEvS3UyNWtWblNELzk0eXJmYjhNUEZlQjB4ZzYzbjY4a2hCbDBN?=
 =?utf-8?B?cWdMVnRST1YxbU9nZi94a3RNR3pLU3c2L05oNE1zTUFOSjJBNHpPcy9sV0Qy?=
 =?utf-8?B?U0w1ckZXRzlzY1FOVnNRT1ZSTmFwWUpmTWFmYTI1NVVMWjc2UGxiVUhSUHAv?=
 =?utf-8?B?WWMwOTcrUWZzZTNrM1FnS20xNkhBelVodkVyZU1peFZObWI1aUxkUFQ0eVlv?=
 =?utf-8?B?dUJ4QkFaeithM3c0L0FCcUlSSzZqaTY1QWRTaXM2bDQydE1sVGNISlJqQTRX?=
 =?utf-8?B?ZlFVYjlWTjd4M1V3aEUzZ2FHYU5QcURyYytNdjBkWmtXRXNaUmpWMVlBR0dx?=
 =?utf-8?B?eGdxc3RJVk1JeU53dGVzRUVScDZ4N01oTVNoSUovVFQ1MTIyTjlxZXJOZ1FR?=
 =?utf-8?B?b3B0U2R4NTJ3czc5M0xHb1JQZWZvU2dvTG4xTDVUNDVUK1NOVDd2RW80N2JV?=
 =?utf-8?B?bWo2TzdObnRKMWVWNnpYelVHSHBrTkM3RnFlWmxrZ25UMGRBMHpGZHNQMVQr?=
 =?utf-8?B?MVBObEFLbW15WXdQOElwOElVdmh4N2tNZXY2MVZqQmxnRHQxQklNQWo2eXRS?=
 =?utf-8?B?UkFKYmR6MVA1Ukp4Q3QrNEdZbllGTVJWcDVrY0kyVVNwZDZFcXNCREJrL2lM?=
 =?utf-8?B?SVhVck16anpUYXcwY0dINE5Xc2tkb001aEdtU0dRekJUdW9QZlAyWEQveXpC?=
 =?utf-8?B?T0VsbEs2UGlvcVV3QTBIdnVoUUY0c2oxNmZWdnZiNUw0M0hzUEVYaTVMdUc5?=
 =?utf-8?B?YkJVbU5UTlFteGlhR2dsekMxbUZkK1lHR25JN3dhcGkrdU5zVm5kcU8rcy93?=
 =?utf-8?B?VmdMMEZNRTdlOVYrYXZjaWhuemFBeVpBeFpnbldDMzl6a2drVEd1VC9pcHJi?=
 =?utf-8?B?aWxlV3FTUVUxdlhuWDkwOWR2RzN6eFRucU1oRmc4U2wyKzdHRFgyTmRPcWFY?=
 =?utf-8?B?ZHRoZWVjdW4rZStjTklxdk9XaS9sVXBrRTBvK0NYZXp1R1h5UDBNa1J6NllY?=
 =?utf-8?B?aU5oSnoySXlSRGovVytQeFJJTXNQZVYzNS83Nk1FSW5JMGlCYlRhYmkwQXpM?=
 =?utf-8?B?bHdjMDZSTzRseVBEbzBXQkl4WHlCL3NCaHhHK0l4eUc1SjVoaXZPbXZVNWt2?=
 =?utf-8?B?U1hCdFZmaHBpbmFGWEI4dHljcWYyR1JCMWlRTHkxTjhwWU5kWDZmOWFSeVBF?=
 =?utf-8?B?NDduYVFlSzNoZytiZEoxWmdFVTd2U2NrKy85ZmtwRUlaYVVaQ0k1Y3hWR251?=
 =?utf-8?B?WXlSbXdNMWFLUEx3QURNZ01mUWZYcmFlbnNpSE1XSEJMbEZFN0RMMFg2b05v?=
 =?utf-8?B?VlZWRVdWWFU1MW1Xd2FpeFdkcVp1NEhLSDJ2S3dXVldxUU1mNUJubUwxenhP?=
 =?utf-8?Q?xWTlWE3Eqeg5Z?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a21033f-fd41-4f58-1cb3-08d9363bd30d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 11:41:22.2266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0F2JlW3smmErDeQsmM9FFPrbVeWRmDgn+ctHwsTD1CIhUMyhgF96vGmhn97KBka7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6222
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

>     smb3: fix possible access to uninitialized pointer to DACL
>
>     dacl_ptr can be null so we must check for it (ie if dacloffset is
> set) everywhere dacl_ptr is
>     used in build_sec_desc - and we were missing one check
>
>     Addresses-Coverity: 1475598 ("Explicit null dereference")

Looks OK since dacl_ptr is only set if dacloffset is set but it would
be clearer if you check for dacl_ptr directly no? Any reason you are
checking this way?

I think this is clearer, unless I'm missing something:

ndacl_ptr->num_aces =3D dacl_ptr ? dacl_ptr->num_aces : 0;


>
>
> --=20
> Thanks,
>
> Steve
> From ec06cb04376e5abc927a9b85dd768ce8728965bb Mon Sep 17 00:00:00 2001
> From: Steve French <stfrench@microsoft.com>
> Date: Tue, 22 Jun 2021 17:54:50 -0500
> Subject: [PATCH] smb3: fix possible access to uninitialized pointer to DA=
CL
>
> dacl_ptr can be null so we must check for it everywhere it is
> used in build_sec_desc.
>
> Addresses-Coverity: 1475598 ("Explicit null dereference")
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/cifsacl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 784407f9280f..25a8139336fa 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -1308,7 +1308,7 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, =
struct cifs_ntsd *pnntsd,
>  		ndacl_ptr =3D (struct cifs_acl *)((char *)pnntsd + ndacloffset);
>  		ndacl_ptr->revision =3D
>  			dacloffset ? dacl_ptr->revision : cpu_to_le16(ACL_REVISION);
> -		ndacl_ptr->num_aces =3D dacl_ptr->num_aces;
> +		ndacl_ptr->num_aces =3D dacloffset ? dacl_ptr->num_aces : 0;
> =20
>  		if (uid_valid(uid)) { /* chown */
>  			uid_t id;
> --=20
> 2.30.2
>

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

