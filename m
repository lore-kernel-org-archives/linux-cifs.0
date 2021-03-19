Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08F84C433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 16:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF29761981
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 16:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbhCSQft (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Mar 2021 12:35:49 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:47392 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230092AbhCSQfn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 19 Mar 2021 12:35:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1616171741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/A4o2OItL+xG55qBoRhqEaUoLAKmrS+k68dJwMdiTgA=;
        b=HS4UjfOZbYA6oMzLhqI+zWN6IxAce9oT1Lj/jSZMLtUXfKZxvao1681z2v70tNNJisfIeJ
        FBAci2gQTOVHgkpcWP7ReEZCn+oL6bRweYYvB352RYELihzoeThXJs7O1R++Lu68jcwKdh
        SFudf76OEjkODjHD+5IIYiKMBMF6QoY=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2054.outbound.protection.outlook.com [104.47.9.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-8-MNBEd1MYNMSN1CU_UEguRw-1;
 Fri, 19 Mar 2021 17:35:40 +0100
X-MC-Unique: MNBEd1MYNMSN1CU_UEguRw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QlQuYJANqJYdMZXDaPxrPUs2gBAC8theM52xZ4Vd2/nX7s6S2043etoXnwhh2unH12xjq7mBbE3uVQ63bC+qDBFGpqurNEJBi/PM+HQeaWOaHy5bIYgBvwtOcDQaddcSWaks5km3+I41588BrqfsX5Mv/L8gIolrXouSqS6loRwQX0UdLgQsMxwEgxrBHjBfgkDzrGoIEw4ij3lrUnTybiBypP1FbQ6Fuat7qk9Cgx0+UGuXqCrkxqB+y2uPDcWo68ZE+W8kCcHPaTYrJzTf5W72rWwVtY4OqhcPRrcnIBByySMMZKiqepLKoX4W5Lre4m4Aawz17o1I9DeBlG2JpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/A4o2OItL+xG55qBoRhqEaUoLAKmrS+k68dJwMdiTgA=;
 b=h6Ix4R2CUCYldXpkZ1VGxULSakNwlggz6dBP/nkBYN5kZ66jAkWauoaVPVKmH0F3vd/i9/mDCmrHeJ9HlKQvGnnvCZm/vUru57tdGxRJdDrNbi/7j+/ixn5N4codcmKbUgmk2Coi/aWq56Tf3KujnTV3ikQ1lM7pXXarxnLRV+jFLNoEjpTzL3WZc9jMM/Em0ZWGebHHTxSWS919VmZszczSYGX1nTQJV7nyXdWpwIcA1Ul/6iIqWxaHdtpMIF5SZuS2bB9PqAsY5roaAgkUZ9yNfYgkepqUE9cVWVmJ102SityvPozZ53svi6VpBC8i9un2duj0Ma8Q/PXYT/A4tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB4958.eurprd04.prod.outlook.com (2603:10a6:803:60::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 16:35:38 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.3933.032; Fri, 19 Mar 2021
 16:35:38 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: fix allocation size on newly created files
In-Reply-To: <CAH2r5mv0kMa__3-KvRRE20OZ3R=cnOFVbrAzVyRA0zpXsbaBiw@mail.gmail.com>
References: <CAH2r5mv0kMa__3-KvRRE20OZ3R=cnOFVbrAzVyRA0zpXsbaBiw@mail.gmail.com>
Date:   Fri, 19 Mar 2021 17:35:36 +0100
Message-ID: <87blbfrtif.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:700:2841:4086:e281:ba2a:85f1]
X-ClientProxiedBy: ZR0P278CA0116.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::13) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:700:2841:4086:e281:ba2a:85f1) by ZR0P278CA0116.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 16:35:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82c7d652-d004-4520-0d68-08d8eaf5077c
X-MS-TrafficTypeDiagnostic: VI1PR04MB4958:
X-Microsoft-Antispam-PRVS: <VI1PR04MB49586DCB917AC24DC711C4FBA8689@VI1PR04MB4958.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rzuhw72LzMhfErBIrK/W6s5nGEapcV+tHGfg2+xJLEQoXeoeTQejxaJ2AiuDN0bRLyj0IfMOfrKNy0YJVBc8/X/S+Ifwr3iT3yo9zh/gomGMqxsJf3KI/iBIDQig8myxImSH8q4ktS+nA1jovShLJsmFNUk3lGo/E/Mc65oZ4jWnNRJfznt+x+8KT8icclX+yUeOPYoMulid2M1r9gaagqKCdljzxlGbJH1KgSaptJhWzaqKpmZMozHZQ3C+TOdt0C//ZLkJpo5gFDzfu9w5Nm9dm+je8rKxWFtuGlNkxrr4ZyaiqHcUfDUAa1SJvh5KuACSevnWxp7aysh9YWv1uvXhBWMgVav/ZTDuCo6XyrXQOT/jJqKIi+Lqr6VSpqvxMHdrcQwCqN74cqL+HarkZGjRs7dVYCFdYaq0bpLNYHFVrk4MW7H58fhjzexJHh0PkPx0LY0YB++pHDV+ZazYxZj7ERiSXAGPAhzYYKkCy5R6q93ED75B7lvTsJcCZ/jFLFqtmDcDafZgvUUnMCFVDhZuFE2A5R2llInXB3ew3ylQCVtgv1Gezfz+LKhDqG5FlqLrdlXjatdbp/ZNWm7hNm2TdvrtpF2K+i0w7ASEakrClaSYKMgVvIILwdLK47ZmD+fPr6KcbI9dHfyrZEURtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(346002)(396003)(366004)(83380400001)(16526019)(2616005)(6496006)(6486002)(66574015)(36756003)(186003)(5660300002)(110136005)(8676002)(52116002)(8936002)(86362001)(66946007)(38100700001)(316002)(478600001)(66556008)(66476007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bDRXRGZEWkk3c00rVCtmQ1ErREFIMnZxL2R3VUhnNlNtUzgvcVZUbG1jd3ll?=
 =?utf-8?B?KzFNajJCRkNqVGZoVlA1c3QyWUJteEpxUW9wVGZEbEgwclROelloMkFmZHdt?=
 =?utf-8?B?ZFc5blB4WGxCNStsQVNBa01lMzV3MENpNFVIblc3VkVRaWhqcDMrSlFJQnNp?=
 =?utf-8?B?bVpNaDFEM1d1RC83SWVsZFUramF0TXRDQjJMd1pUUkh5RDhKblZYSGZZUVBX?=
 =?utf-8?B?cnpVRlM3SWdsTklhUDZZTFRNakdVTW5yV1FwcElhY2JHbklMZWh5WmMvSG4z?=
 =?utf-8?B?UHFwL0loMzBxYUs0U1lnbm1lREdpQ01LT3QvU05kYmk4bFhpbk1ubGRIUkNS?=
 =?utf-8?B?aitaSWFIUXJ4VkVCak1kVHlsQ1hHVVpYN0tHM1ZHSjdjOURYMC9UNThiWUpz?=
 =?utf-8?B?UHJtTGtLM3VGK3hpbTRpWjliSEZkcU9QQUowenZVOUhwZHRkaUx6TThoZHJS?=
 =?utf-8?B?alA1SjhtcytMbjlZRFFsZ0VUUWVhc1VYaWRVc1E1Ny94QkQveFpXYlhjYzU2?=
 =?utf-8?B?UTF1UmpJcCsweG5rMHA2WXlZQUxjMGpQQ0NCRm5Ta243bVJnNmtmUFdQdGEy?=
 =?utf-8?B?Y3RKQ1IxWkJNTUtJS3FsMldnOThPY0czM3pQaUJ5L3dYc0M4U0FXcGJ6eXlM?=
 =?utf-8?B?NDA4NCtDdm5wVVhPbjZja3V2ZlBnWWN3aldSZWV0ODRpNTdDVVBHREVIRWhy?=
 =?utf-8?B?aEFIYlk4eXliYTJtOEFuMWphdEg1c0lTMnNlcmZuWFF1a2ljcmF4RGtDQlhV?=
 =?utf-8?B?YkhJQWp0OWh6SnY5RTNJUkl0eUY1L3pxTk9CVU5jN1RqS1lnRitNSWhMS0h6?=
 =?utf-8?B?Q0lyR0taNzdTaWdaT0hnSEdQTVl1WDg1Q2xWLzdUc2lyY2FPOTdzN0o2SFdU?=
 =?utf-8?B?ZERZUG1GRmQxZk1leFNVQXBRY0pQeHNtTDRtVm1HMEV3dTNNR2h5QVJxVHo2?=
 =?utf-8?B?a1ZKbXZncGhpOERYRk5GOXdSNkg2RkRoUkF1elNSamRzdHY5R1FHaUh1Yith?=
 =?utf-8?B?ZFZRT251NXRwRXhZUk1wWmczOGsxcG9iM01uSVJacC9MeWZjVk1XM1pPazcz?=
 =?utf-8?B?ZU9wUk8wazRnbEZuMWJQdjIwNGFhVW1rRXlQRXhIUzZYK3RpT3J2TVdNbC82?=
 =?utf-8?B?VVN6S3F0U2p5NWpNS28xQjY1ZW1SOGY4blh5bHdVZVFrcnZwMUl0SEpaWlZR?=
 =?utf-8?B?SjY3MllHS2xuVDhSS0l1OTJZajVaampUa3BpZEJvLytjcWMyREtjelRUeTY5?=
 =?utf-8?B?V1pDaWNldXo1eHZKOUU5KzRKYi9UeGFYZ2E2aEZXaURkTmtLbTUrb3dDVitt?=
 =?utf-8?B?bEdUbndjRFBKaENIeTNKTGszdTZhVW1vc3NUbnB6b2NncjhqNTJVcnN3OXEz?=
 =?utf-8?B?LzFlTXdVa3BvVFJnRkV5Z1JreU9ucFI0dnhseFNRWTdIL1hKTjA5MjNRN3VL?=
 =?utf-8?B?eDJEaDRYaEwxVUQvZ2ExYTBCSzhNb0xGdVcrNnhOcW9La0FPYlZ4R0l5Rllh?=
 =?utf-8?B?T2pzWGRwWk1ibW5ORk9qOU1IamJoR29rMlIxRHRvck11akZSM2VlSDV5d1ZY?=
 =?utf-8?B?blMwZy9CdGJIbVQwMlc2R0JZcUR2LytNY21kUlpmSCtQdkdtWVlKU1F1bTds?=
 =?utf-8?B?cHE5Tm5YQm9Lc3Z3TjY2YVN0TnN6Q3dKcVJ1WStOa2liblNSUEJ6SUhXWHFM?=
 =?utf-8?B?RkY5OTU1NlVjNTNnUGtXZXlBWUhtamNXR2xMVlZOSmdkYkdyL3V5VWlVbWN2?=
 =?utf-8?B?RytkUUlmSmJTczRCdnJqejdXRy9aZkt5dWpnQ0xuOEJXRm5jUWNaTm5KQUtt?=
 =?utf-8?B?RVRjaHc1ZDhleHFoQWQrdjRva0hWVU0xTFh1UVFrTmZSaTZWRTI4bUdmNWJC?=
 =?utf-8?Q?kNnfsmZl9yu0y?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82c7d652-d004-4520-0d68-08d8eaf5077c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 16:35:38.7172
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZfJiTl6DZ00vQUL6A2sFcFAy5szkyFBCc07H/Di1ZH7KRSfqT3TEx32J2RMlxJIo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4958
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


I gave it a try and it seems correct, alloc size is zero without the
patch, despite size being >0.

The estimate seems reasonable, it will get updated when cache timeout
runs out.

Server is supposed to return newly allocated blocks on Close Response
but I see it's zero on Windows Server despite file size being >0 (maybe
server bug).

In any case change looks ok, you can

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

But little nit picking on comments and useless final hunk:

Steve French <smfrench@gmail.com> writes:
> + /*
> + * i_blocks is not related to (i_size / i_blksize),
> + * but instead 512 byte (2**9) size is required for
> + * calculating num blocks. Until we can query the
> + * server for actual allocation size, this is best estimate
> + * we have for the blocks allocated for this file
> + */
> + inode->i_blocks =3D (512 - 1 + attrs->ia_size) >> 9;

I would put in the comment: number of 512bytes blocks rounded up, much
easier to read.

>
>   /*
>   * The man page of truncate says if the size changed,
> @@ -2912,7 +2920,7 @@ cifs_setattr_nounix(struct dentry *direntry,
> struct iattr *attrs)
>   sys_utimes in which case we ought to fail the call back to
>   the user when the server rejects the call */
>   if ((rc) && (attrs->ia_valid &
> - (ATTR_MODE | ATTR_GID | ATTR_UID | ATTR_SIZE)))
> +     (ATTR_MODE | ATTR_GID | ATTR_UID | ATTR_SIZE)))
>   rc =3D 0;
>   }

You should remove that hunk, it's not doing anything

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

