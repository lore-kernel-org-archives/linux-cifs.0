Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9478DC433DB
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Feb 2021 10:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58E4564E98
	for <linux-cifs@archiver.kernel.org>; Mon,  1 Feb 2021 10:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233204AbhBAKoX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Feb 2021 05:44:23 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:26631 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233240AbhBAKoO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Feb 2021 05:44:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1612176185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hJUOe6c0ycRAwODfzuoeGt3q8aeZ4vFGoKtV8gWXnKI=;
        b=LGtH3Z65Okxs4IX5bIqrh9IZ5z8YKdHA8UckwJO+pUIdhlBxHXoIafjevQ9xqeryY34W6u
        mYyIx2IAN2Dlbqq+5kzV+SElkR/u/D8L1ZDtDTQPzibkukN1OBlLcNUQfbIZsOwsHpqS+d
        bukXbZt0Ff5NAE4HNTjjRuwqmkDmbTM=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2105.outbound.protection.outlook.com [104.47.17.105])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-23-irgrg7yiMfi7YbmPECSgsA-1; Mon, 01 Feb 2021 11:43:04 +0100
X-MC-Unique: irgrg7yiMfi7YbmPECSgsA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aT3DZB98a/LHMQSbBt5o+62FO6gwnkA7QqenV1G9QCKeYNCUtIchHsY/xjj24gSvfQlWL2VtUeHeep3GzfRAiE1kaBY4MV6TBJWo4UCA9cE3ZdOIi0SmAodu+8XAUljcuXeA8ECqaIgy67gMdVXU/889i2vx5dCBherYAGjDTnTfFrYfNOMIPpEgli7nUlbDrXwQScTBCgCUnvVLazK0vPtys5ZZZEwat0hFtBRT/VWS+spoDna1wWH2agWzrjPbpMuPF0GVJI/ivE+D8UhFnSXGl2oQ4n6705lRS9PTShCEGkTJoHnuBeLd0vajDl8lLa84ljxqdZdTS6zqYjY7/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJUOe6c0ycRAwODfzuoeGt3q8aeZ4vFGoKtV8gWXnKI=;
 b=AnNVdGxBMJA9CVpZ+3PWY3Mj42pwLCC4Rq6DonJBZQNIot6OtZZzOKJN5TRSwvrKwu7l3tzxJcJAfIrAPbmz62pkp3u7c8rl9qlDxhrBwdDUuvd+A+67ySr4Vv5hRH9C8L3GqDBTxuI74zT0oAVlk+pUXjGqelO7hoounCzBZ1gMKtLehDGJJrjwGtgTj7Qll3cspqqgke33r1N3jscdv4kV5dOnHGpsj9oY9djWU2Yme/d+UIdaZ2F1mJF7ppUUGq21HFrEqyjfhLHtm2EbcuP+CvIR9Cekdrc2gEIesyCyE4DwaBwu7DSA8x/PsE7NqOlfw8QhRMJPVQbzxaMBjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0402MB3360.eurprd04.prod.outlook.com (2603:10a6:803:2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.26; Mon, 1 Feb
 2021 10:43:02 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3805.022; Mon, 1 Feb 2021
 10:43:02 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        sribhat.msa@outlook.com,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: [PATCH] cifs: Changes made to crediting code to make debugging
 easier.
In-Reply-To: <CANT5p=p60ahfnrxU=sazMszPaxWWp4YLKiDWkZs0mf8iie-TbQ@mail.gmail.com>
References: <CANT5p=p60ahfnrxU=sazMszPaxWWp4YLKiDWkZs0mf8iie-TbQ@mail.gmail.com>
Date:   Mon, 01 Feb 2021 11:43:00 +0100
Message-ID: <874kiw9ih7.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:9f12:fb7a:e8aa:e796:34d1]
X-ClientProxiedBy: GV0P278CA0068.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:2a::19) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9f12:fb7a:e8aa:e796:34d1) by GV0P278CA0068.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:2a::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Mon, 1 Feb 2021 10:43:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5d5df85-d4b7-4fb3-99b2-08d8c69e2632
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3360:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB33601FABF485D3BC0371BB89A8B69@VI1PR0402MB3360.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YMXF+WnWpH+7XiTBxxatf9V48qL+x9QxFst6SCts6NOAsP0K7zAZtk9X/CvwiBZ+KvybXgmXPqnA7/Ua7HRSQr4vTsY0MCtum9AHH7VoKcCfbAP6Rw02qLfLZ52cgfV2AHFtALYBR7VwCETcHDENs6WIYzoUcGWoFdpx6UBfPcA86DVQPWR3X18Rrsm9CHy+FKWidExpx3LdbVJsRTK03jM6sHJlmNYxIWpP+DevRoSZ8xg2gTk3pJ1Bf1OUvsZHgudQCvrgasZFEm8lPQ/mAI+bGpdxfb2iZPftD2t8xpknQIG70oLm2jiI4XEZZqkEXZeb4/a3fGgMEFFtl+I3oqq19pjnpcPPJ3H8mg1oJHQyd0tSVyN4EMLYVDD4aoopWUC4zDaa8LxHAXDMX8ZZIc1SSkmyaUVdUVf6Qp/c7WhmuAKcG4/3oxd3e9FyZ+9P7/twrNh9oWgD5BIgipbNFhlovadQBWt380JnTpkUhD3ZOputBYZ0q0SlBfo2sIjwCwYfHRcZyNTpTMbtyAnAcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(396003)(136003)(366004)(346002)(110136005)(478600001)(16526019)(8676002)(5660300002)(66574015)(186003)(316002)(2616005)(86362001)(66556008)(36756003)(6486002)(66946007)(83380400001)(52116002)(8936002)(2906002)(6496006)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K2ptSk83UDBteDBTQUw5ZVBYZnREckJlVElyRzdaUUw3RXdJT0thS0lBeWZE?=
 =?utf-8?B?RzNwUGsyWi9KcXV4REdybS9JWTdwWGV5Z0pSengrY3owVWpOSXhKdHRzUXZJ?=
 =?utf-8?B?OXpybkRiSCtxRHFzeExxaUlxWm5nRml4U1pVY1NvZGFDeFBqMXVxOGw3bFdJ?=
 =?utf-8?B?YU84U0hsOWltblFhd3pob2V0NDF2QWxoeDVtWlUyU0JFcjY4ZUhmY0sySmtS?=
 =?utf-8?B?d21SeFRRVkZRZFZFZ25NMi9Dazg1UjhsZTQ0RjVPYXZFb3lDYkFFT1psemZB?=
 =?utf-8?B?ZFRFaW0rV0NCUHU3YnlPcHVjOFRzY2JhcEIxT3Nna0toWjRGc0F2NlQwdXZC?=
 =?utf-8?B?dDJiaDlidHlvMlB6TG1LbjRmTEFpbi8yMDFwc1dscWdZUGRzdlNHdHhxZm84?=
 =?utf-8?B?MW83eWhOdWIzQ1hFRTB1VWo1bEUrQUFiYTNLUklFYTlWRjl4dWFPRitVcm9S?=
 =?utf-8?B?T3kwbkdJUkZraEdMV1pJS2E4OXpiNHlxUFU3VkkrU3NSWjkxbk5JbFVKaXNl?=
 =?utf-8?B?SVQxNyszWXVOMXNkdmxCN0hqckd3U010aVFWamVOMmNhdFNCN2FncDN3Z0NP?=
 =?utf-8?B?YTZXUW1aV1BwcmtVT1hVdkNTU1daOTY2YkJiREE4eXBIRHR2ekdNNWFTZVI2?=
 =?utf-8?B?OUNJUTdaZm5KZHVCUzAvU1pCVUdtSlBQTTV3SDd4UjBSYlU5NGZOdmpKcWNS?=
 =?utf-8?B?bG1SUlRoMit1c2UwU3ZUNGJoZFZON2l0UXV5UGtUMFBiQk9qaXp4YzloaHFC?=
 =?utf-8?B?MzhNRGlQOTFhbjlsQkxDWVM4bE9HbWYxNHlHa0dOQnowSnJrbGE4VzhmL0hU?=
 =?utf-8?B?MHFNVEJtb3dzNmNLV2VYUFEvRXNENU16aXkzU295MmFFbmFubHB2ekNWUjh1?=
 =?utf-8?B?MXluTXdqQWRCMDhqNlNJWEt0OWVlaEtTU0lUWFBMeWZIM21uREdkVTdJK2Rw?=
 =?utf-8?B?dERveU1yWU1ybG16cEkwMC8wNGxNblJpWGhWODdSVThXblRRUDBDSGRHRnpI?=
 =?utf-8?B?YTZXa0orSTFFUmN3V2J2WUJnd3lxWmlVUmRyQStYRlpZNStuRzFqeWNXdWdQ?=
 =?utf-8?B?NnNUMkRabmkxc1djbDAzR2ZXNW9ib3NjV0pZRkd3OElXY0VZOGlScGhaQnk5?=
 =?utf-8?B?c1JlTVJzT3lVWXJJKzQ0SGxEWXN1NjhhT25XVFVqZ1BxZ3F0YjNJOTNnekJ1?=
 =?utf-8?B?azZtNnAwR2JiK0dHWmJEa0VXNGZZRzN3Vk52UXB3Q2NUKy94LzJTL29mUnFy?=
 =?utf-8?B?V0dEME1wbEJaOWt3SWlEaUJiTHlWR3VPQVRaMmZuVG4reWZtNHFjN05jWXZW?=
 =?utf-8?B?TEJ5dHZ3cGpoQThEZS82SnpNaXp2KzVhNWhlbEdHSWh2SENERFRRaUJwKzZT?=
 =?utf-8?B?dXJ2ZTlCNERGdXRIQytmM1cxQXFWWEF2aC9sOGk1dnYrVStRMUg2cXA0Y1Rq?=
 =?utf-8?B?NU9qb2VXN25WcWhNSWsrZ29BOUFsdmoza1A5QzBremVhbnE1MnpvQzJZdHpt?=
 =?utf-8?Q?t74yyH45Pl4ciA0s+wGlMH4i4w4?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5d5df85-d4b7-4fb3-99b2-08d8c69e2632
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2021 10:43:02.2297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: agbppwxLh7Lxwiojbgdw2DbNkdwr/n30wa/74xp/LGkGUdqnh2JLLD8vS79vkY14
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3360
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:
> Specifically, I keen on your views on the following:
> @@ -1159,7 +1181,9 @@ compound_send_recv(const unsigned int xid,
> struct cifs_ses *ses,
>         /*
>          * Compounding is never used during session establish.
>          */
> -       if ((ses->status =3D=3D CifsNew) || (optype & CIFS_NEG_OP))
> +       if ((ses->status =3D=3D CifsNew) ||
> +                       (optype & CIFS_NEG_OP) ||
> +                       (optype & CIFS_SESS_OP))
>                 smb311_update_preauth_hash(ses, rqst[0].rq_iov,
>                                            rqst[0].rq_nvec);
>
> @@ -1224,7 +1248,9 @@ compound_send_recv(const unsigned int xid,
> struct cifs_ses *ses,
>         /*
>          * Compounding is never used during session establish.
>          */
> -       if ((ses->status =3D=3D CifsNew) || (optype & CIFS_NEG_OP)) {
> +       if ((ses->status =3D=3D CifsNew) ||
> +                       (optype & CIFS_NEG_OP) ||
> +                       (optype & CIFS_SESS_OP)) {
>                 struct kvec iov =3D {
>                         .iov_base =3D resp_iov[0].iov_base,
>                         .iov_len =3D resp_iov[0].iov_len

preauth should be updated for both negprot and sess_setup (except last
response from server) so that looks correct. But ses->status will be
CifsNew until its fully established (covering the SESS scenario) so this
shouldn't change anything. You can test this code path by mounting with
vers=3D3.1.1 with and without multichannel.

Also there are no 80 columns limit anymore, I think it's more readable
as 1 line.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

