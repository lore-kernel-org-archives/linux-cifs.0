Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B087AC433B4
	for <linux-cifs@archiver.kernel.org>; Fri,  7 May 2021 13:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DC7A61401
	for <linux-cifs@archiver.kernel.org>; Fri,  7 May 2021 13:48:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237288AbhEGNtv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 May 2021 09:49:51 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:47074 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233394AbhEGNtv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 May 2021 09:49:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620395330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ddvbvD2W+1jMd8X7qcY0oH+b0oHq8R3O2e/EltdDUEA=;
        b=P+y+zNKYSi3L0Yc4sIz2Gd43CoKVZCQz9vJrJekO2g9k9svLbcYBf+hr7iINfemSgvEc6n
        6XZ/lWCw/dM6GdvXQQLCY3S09VFvLHyjyAqPAYV1t7dCVeKf33HU9cNrR8PK8ep++BFmz6
        ilSycJQKWitDInkTUvhDPj1DBv2kBGk=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2055.outbound.protection.outlook.com [104.47.13.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-6-Qh_Gby9wOiawS9Z_f5yoAw-1;
 Fri, 07 May 2021 15:48:49 +0200
X-MC-Unique: Qh_Gby9wOiawS9Z_f5yoAw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MtxiDEtnnQ/ZKpk09cUcZ6IbEx7WNdnoYD2jqJeIVN6/O7ScJZIAHRGsob8C5XJdcWN5dJb6VVdbhe2WNdLhXB0l+ixXrJXMantvjzLATEtIOyKK2psSV+Oj5xtW41RAXCuE3U0AmACt/HPjL9fQCWqbyAisn0XJtACZBpv9aPfSWJLc8R1eeYwLev22KnIrVy1ww2877Nywo0T5s2yIwIf1cgh1QrAUMVi2RQbW/IXgixDB2wXVR/c+1hV87ocWko8TBn2HAfHj7xMTO2g9WxCWLHe+lqBWT5S8X7HC/2unmhzGo0F7y+YSAlE3V73jqolg/RuULr8I3E47emjdUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ddvbvD2W+1jMd8X7qcY0oH+b0oHq8R3O2e/EltdDUEA=;
 b=ReBps58bhcZZT7wDoW7lnp3BiC+QtMTkrfhGEpnvjPwrOgCXftdicRukWD/6noagSkw7ctaaL1qNPK21y6eQ9ojTJ3I8beBBcARj8Hw0sntoB2vKItoFa7uUoG8jOohcFNzWqu+sRTD+ryrpNL+Uho/TAbfP6lSmpSxZBG4fSkFCLqr4Cy9U2vaz8cMhx+gPgmqp8JzNcb6S7ub5ysXvB0S+VMKpvlTEI0u5HFnIhBWFleaHX/4xaexwecxUy2JCNgGb2FFeZKxSTaeCnrrwLPDj6pfjrNtggSEXgtCmfikqtQDM+RS7CxG20BCe6L5AwBwfrppboxp/in9Fk3h68A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VE1PR04MB7453.eurprd04.prod.outlook.com (2603:10a6:800:1b0::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Fri, 7 May
 2021 13:48:48 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4108.028; Fri, 7 May 2021
 13:48:47 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>
Subject: Re: [PATCH] smb3.1.1: allow dumping GCM256 keys to improve
 debugging of encrypted shares
In-Reply-To: <CAH2r5mugntjkFbsz0YCRZwsL0YTZRtb5ZNBUcPBx5nTTWPG_1w@mail.gmail.com>
References: <CAH2r5muN3rpUur8jSav=fJfnt_vuJhgOXxMeGmXvT3KvxbBU5w@mail.gmail.com>
 <CAN05THQzSCZwypBWg9YZAarjrsQ74qowp4Bneo3crW9FfqVqPA@mail.gmail.com>
 <CAH2r5muu3YiBAk1Mf_xOFQJih8Ms7sQhNUKwUrFreggK-Mmr-A@mail.gmail.com>
 <CANT5p=rGGNdVjBSTZm1OsecEW=-5edZhZwBjSU1Q8d8dO+JsPA@mail.gmail.com>
 <CAN05THTmZCNXsH4_i=0CO6CaVOYuZ=z5XHW+U_=q3Djxz6XxBA@mail.gmail.com>
 <CAH2r5msrS0Ox86NgpfUrwv_MPEU7pYGdG=JfYwK9Btia6W8PLA@mail.gmail.com>
 <CAH2r5mugntjkFbsz0YCRZwsL0YTZRtb5ZNBUcPBx5nTTWPG_1w@mail.gmail.com>
Date:   Fri, 07 May 2021 15:48:45 +0200
Message-ID: <87lf8qu01u.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:a617:3026:1c10:d670:5fc7]
X-ClientProxiedBy: ZR0P278CA0139.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::18) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:a617:3026:1c10:d670:5fc7) by ZR0P278CA0139.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Fri, 7 May 2021 13:48:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 52eae253-e9a6-4bc0-7bf7-08d9115ed6bc
X-MS-TrafficTypeDiagnostic: VE1PR04MB7453:
X-Microsoft-Antispam-PRVS: <VE1PR04MB745346D3BA01C2F27E073C20A8579@VE1PR04MB7453.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +fYVcPiJ0tdeaO1zZgWezRohaoRWLZpS+1TQa4qTUrO+QrPglAj2zrpHO9Xmi2MUjR9x4KX9wFokpJfHo8T/CkYCAr/jmMZHNAEWmZ5wDqTvleFhMgZEyetLN6ERaSd2HvLvRTeWFLE5yWAW/hc4sVkB9zpjQnJPIFK27bXmq2xZ3Js9/sHkkKGkMoytWYgapoE96gXZsfQjC7E2Jcg+rbFuujmYGFW5rw9vq26qvgIyF1S0nxj8t1oUgxRKWF8/1W43iorRhGO+VDB4FWJalLqd4iqV1+93wi5T5582OX8270CTOP4YXRPsUAtQyGsfGiZ5T2E2/E3pAJCwIbuMqsWyRDqC2TXecIiUEEu7F4n+R3WgPA4WdCmhbAMZVBhjG2JoqeaszGU3daO4HSr4JgQHbCCc+eBKaHoV6LFr+DOQjs6bPol2cKL5oJSZLLl013M6Uk9eiVBvKc9nbMx6vy2cEasODmYBVthif5itSvi5q0GsN7gUeVNIhUQ+LXxkpfdBrOweaNgKqEtX/6PHUyVpz93HSXnsKh4tFPF7fU0QDAjQX35nGo6JIhII0B0CUJOPqHomOqZGN3RF45Y/dQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(136003)(366004)(39850400004)(8936002)(16526019)(478600001)(38100700002)(2616005)(8676002)(36756003)(6496006)(52116002)(66946007)(83380400001)(66556008)(66476007)(186003)(86362001)(54906003)(110136005)(316002)(4326008)(66574015)(2906002)(6486002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cVU3dWJxMThicFZ0WHh1UmJtYmEzUjM4VFIrQ01RbDNxcngrbjNRRVR1L0o0?=
 =?utf-8?B?aGtteDRHMFBycXVVMWR1RU93R3JiVjZicFAxQ0grQWtKejN0U2xPRk9XTWhO?=
 =?utf-8?B?UXE3dSsvbi9hU25HOUxhbk5jTGtwSkszMnZ0b2dhOVBjb3lZRzFOaXBZMXlw?=
 =?utf-8?B?cEZJdXJ0NUZnRUVySGl0eUlEUHRQb2Z2UmVFTUNFNk5ubHpOSlBYVHhJc2xG?=
 =?utf-8?B?MXVueUE4d0RYYjV0YzFzQUpMRStNaDkxajRhZmo1b3BnNHRWN1dzOFdWdmpP?=
 =?utf-8?B?TWZnUXFjeWpWa1Z2c3c3WXVad0EwOWo4UlpKOGNOdlV2ejNud1hSWndHTUdB?=
 =?utf-8?B?VmJJMmZQTzllNkp6UzJpR1paNGFiK1pTMDJ6S2xNV25NWGxvTWxndHFIelhL?=
 =?utf-8?B?OHdaUWZjVG82Uk1CRi9Pc1BkemFzb1FYMys4Yk5HdUxGTFVHUmtTbVEwTHgw?=
 =?utf-8?B?NWFJeEI3dWw5U2t5VG5ScVpxMG9xdEduei9vYytxd1NneGRMbEQ2cW0zSWRq?=
 =?utf-8?B?U3RYSk9ERWFFVUl2aW9RcFJwMVJCSS9YYVQxWFo2WVBWdjRzc1FhT1dzeTZz?=
 =?utf-8?B?RXJoSlExZGZnYjRYWWxCQkplWjZ3TzNTUURUcU5OM21wSEpXNndIYTloTW9p?=
 =?utf-8?B?c01jTktPY25jSTdKMjllSDBxenJsY0lqamxveTNma29QbVZWRThodDZXNkdV?=
 =?utf-8?B?V3FSVHhudDJ4ckFVTlRUUEMwcjdEbXF1U284ald4cDF6SGgrRkdwNmZpa1B1?=
 =?utf-8?B?SkRSZmd4a2xXOGFQZVVMZCtHRWNMYUlhYTJ3bDdOb3ZuYnNjOERZbThQa3la?=
 =?utf-8?B?MjhnbVZmeFFYcWhwZi9DTGhvR2RyWnF4NnFFQmNuNm1HSjFTNk1BZlVUVmNi?=
 =?utf-8?B?TnU0S0w4U09hR2UzMzlrMFZBU3UrRzdPRE1Ca3NiZEd5R2NrTG9GYjl2ams5?=
 =?utf-8?B?L3lZSVM1blYyVUpKaXR6cXExT1lQUlpDMFdyc2xJTnpKSjFzVFVpU2YrQkE5?=
 =?utf-8?B?WmJUUHJVSEpIWUZYZTR1S3BITEJScm5VNFpUQU5WKzBBaFQ1bFZHdVJCb0RB?=
 =?utf-8?B?L0NSM1lhRWdoRTlCaHM5N1hLSk5NaEpidC9sK3BwSkpiUTZGcnB1M29oR3Z5?=
 =?utf-8?B?QnhZM2YyWjczaCtjYU1vMHZqZ3FyMGRhdDZBNVVRZG1lWWQ2UDc5dnd4bkho?=
 =?utf-8?B?RUIzQStrbldjczgrR081SHByRHordW5KWU1XamZmMHFWbER2N25NSVhqTkJw?=
 =?utf-8?B?dXlyNHZNYkgyek9BaDFQQjJVL25Wbmw0b2k3NWYxNlNXK2ZPMW1XaVBSM0FJ?=
 =?utf-8?B?NHRHeGZvNVN4ck5EOE9GMUc3SThmUkYza0ZDenRsRUx1WXBzRnZZM3JjRk83?=
 =?utf-8?B?dXVQUk5TVTNkeGZLbEIxNmtPUzU4Y1daWnN4SmJDOC81UXAwY0JYdzFlVVhW?=
 =?utf-8?B?eUpPdGNFejRybEJlMGlnM0xMS2FoWHM5eEZpbnlWbUhtVVUvcXNVd2FpNTZr?=
 =?utf-8?B?eTF6L2RhYWppR3R5ckcvTGh0aThaSHpad0pLeTNXY3dDNjdtSWhKNzNnRERt?=
 =?utf-8?B?YWtSWG5qR0lvck5rRUd0d1Z6R1g5TXRHSEJqQzNmeXAvRDVOZ0tSTHMya0d2?=
 =?utf-8?B?MVJtSFFGeVlVQTNxRTluREoxZXZLa3RFU05XWnVMRFVBL3dEUGdrS2pjbjBO?=
 =?utf-8?B?T1BaNnRMMnFKcXgzc3BDY0Qrc0ExTzEzMWF4Y0o5S0YwQ2M1SDJxTVVTTFVZ?=
 =?utf-8?B?cVh5L05KNW1Cb0tEU1dmN1FzUDZCcllQTmxSS0J0UUYvaE9nT09MRnlxekJu?=
 =?utf-8?B?LytnS2FVT29JQ0hNcXFwNHpCRUFKT2p3ZUlEclhmcGluOUNrUTlaRjZlYXp6?=
 =?utf-8?Q?oAvvWNh+LdVLb?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52eae253-e9a6-4bc0-7bf7-08d9115ed6bc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2021 13:48:47.9239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6xGXUvDQX2V+Qcy9uYEw4UEwaremPYvTY/KIKk7OYLN5CHzp8vUtQQRFhpzpspb8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7453
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
>> > Or as an alternative, dump an array of ALL user sessions with
>> > information about which user and which part of a multi-channel
>> > connection that the keys belong to.
>> > And let userspace sort out "which keys do I need for my wireshark sess=
ion".

All channels for 1 session share the same keys (except signing).

I like Shyam's idea of having extra uid arg but it's more tricky
to get (have to walk the tlink RB tree and find matching uid) compared
to an extra session id arg.

> +static int cifs_dump_full_key(struct cifs_tcon *tcon, unsigned long arg)
> +{
> +	struct smb3_full_key_debug_info pfull_key_inf;
> +	__u64 suid;
> +	struct list_head *tmp;
> +	struct cifs_ses *ses;
> +	bool found =3D false;
> +
> +	if (!smb3_encryption_required(tcon))
> +		return -EOPNOTSUPP;
> +
> +	ses =3D tcon->ses; /* default to user id for current user */
> +	if (get_user(suid, (__u32 __user *)arg))
> +		suid =3D 0;
> +	if (suid) {
> +		/* search to see if there is a session with a matching SMB UID */
> +		spin_lock(&cifs_tcp_ses_lock);
> +		list_for_each(tmp, &tcon->ses->server->smb_ses_list) {
> +			ses =3D list_entry(tmp, struct cifs_ses, smb_ses_list);
> +			if (ses->Suid =3D=3D suid) {
> +				found =3D true;
> +				break;
> +			}
> +		}
> +		spin_unlock(&cifs_tcp_ses_lock);

Btw, if we go with this we need to bump the session refcount if access
it outside of the locked section (and decrement before returning).

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

