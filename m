Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C8B9C433ED
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Apr 2021 16:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19A3C61450
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Apr 2021 16:42:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhD3Qmz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 30 Apr 2021 12:42:55 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:41314 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229720AbhD3Qmx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 30 Apr 2021 12:42:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1619800923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UcmO9qU+RK+m4wuhlRuK5jaux1iOekd9+Sjzv4dJPxM=;
        b=iXI3nrS8p0x2I4Qs1XJ1M3uRSM0BVZ+qE967s2pWvCLo8UM0cKzl2ZNGGrs+mVuXQJUSwH
        Z5ZLF3hZWVx48THiL8B3HFi8oWBLj2/78eoOvLK9htN8ykjrU8JMWHyUL9YQdefColBOEF
        PgL3nxVILsSshCBw3dH4Z46jR7w7zpc=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2051.outbound.protection.outlook.com [104.47.12.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-30-cCghDnB3O9G2rTkoGUHGPw-1; Fri, 30 Apr 2021 18:42:02 +0200
X-MC-Unique: cCghDnB3O9G2rTkoGUHGPw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DkZ4QSNB44//oWq5zian3J+19CBs0Wai54krZ1H2ge/Dy33gXQDxZ+Qa4x7STtoRpfsFCNnUAtsFLK5Ju9H2mVWWikvnlcpV4z5v1UPf8WdONdLDcChGnAMZnVB9vjRcWfDxi8DBPwpvb4G3OfMcd+djZSm49y9SjpYJnb8E4M/J0MzEGsSX1DIq1hTr2nnulQMvHI7khlfsgBT9Qgx8w8zhR5hzkeJQS4O7ekBMyOpBYUDAJrvtwSMZZhyqOy/HxBH3UDMuXLtU6SLElMprdezCtmlDFGmmslRzpWA8uwWm+E/goBeN6Ja/RsxBB/DylGatZnACgHEIfqDLd1rSew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UcmO9qU+RK+m4wuhlRuK5jaux1iOekd9+Sjzv4dJPxM=;
 b=k7L2KbBV36WDe/Vl+5Tv/0Q9CjyRJVpfTciGgOh3MuN/8HBR2Ye1sRKcH7ISlNa4bvqeSmLmTN39RFtTu6b2tfhDDZbtDPXKngTxp2JLxtLnWc2BIVpEfiWBJ3ouzmtK/kUBdOhDkfd5OFtoEwgfCpEsssP49PQEQnlI4a0GUPFkHh2japYtEN2XR4DpdfycYZMCbYZUQh+CSqI3fwnsZ75HQUXsDcNmG2FBa6lziyqlMC6tJQeEKJbTexAkNaJ0w69fa5VMMNQLKBB3bzdCDJgulIiOeIpL3wXz0L7fSFy/s/N7NPAHz79B4HG7Zbi2VYPGHcVL451ntnvbl7pYVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VE1PR04MB7278.eurprd04.prod.outlook.com (2603:10a6:800:1b1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Fri, 30 Apr
 2021 16:42:00 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4065.029; Fri, 30 Apr 2021
 16:42:00 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: add shutdown support
In-Reply-To: <CAH2r5msgAWp6wp9f21asTPqkuTcg5RtYm+pqK8etZ_zdej3=7Q@mail.gmail.com>
References: <CAH2r5mvKfohJ=NkkCM7AxqRYq2+D8kRMTxP3VdG=W0s72Cdh0A@mail.gmail.com>
 <8735v9wiad.fsf@suse.com>
 <CAH2r5msnQ4YjJee2FSKPRknNEWsD61V-hvw15m7L3_qBY+Nk1g@mail.gmail.com>
 <CAH2r5msgAWp6wp9f21asTPqkuTcg5RtYm+pqK8etZ_zdej3=7Q@mail.gmail.com>
Date:   Fri, 30 Apr 2021 18:41:58 +0200
Message-ID: <87lf8zvi5l.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:3866:13cb:c454:d9f6:ca28]
X-ClientProxiedBy: ZR0P278CA0143.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::22) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:3866:13cb:c454:d9f6:ca28) by ZR0P278CA0143.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 16:42:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c4763c73-0c16-413b-e3ee-08d90bf6e051
X-MS-TrafficTypeDiagnostic: VE1PR04MB7278:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7278F0813B2A4956DD3374ABA85E9@VE1PR04MB7278.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ao9iCZuoLCuwCQ9cURhnKTQrfATwiYOhqKoTYehR2Tzaeuza20V8NE74zDDx51SD2Lm4Yc29LEQQ/KanR0G9Io4IYMGJ+YhhaNb2QujDtjOlAy1pwr2AUWyVHiZFpfwY5M34zkkqWZM1ctdxBSlmf/S1jgR1AV9mxfNnx8l7+x/GEKAj4UL4J7bB7P6FHAncfn++1weAWC4Tdr0Tf4fvc+PiGpIALPXk4QkRWzcHUe1MQnzsxn8tewbJkxQ3/2qSx+vZeK3l9RXmegzElev6efkV5XxF8dvnpW0rn8Ok94le7hukLA02MKFnAjmGbe3RJlbyJ7pCTokBb81Ptuezgd+0DWS7M052Eb6UgRQ7Spvh+DdLr9zbiCzB6rvYjDZPrLh7dP0ABFuWMSSqi5hr1H4+Xtw8WNglVjp6hiSo/rEK6xNf6QtT/de8B5gY2rfHp+J31iyNMK0fm/aInQFu59VDtXOulQWgZTVsnI93Mv/Ph827bWsGU8n9pufHdKP42q0bVdq+oly/mh5thbPA+X95XG2RGMGMNI4amoZqaihw4EmpKHyH+FNdfd0r8mDkjhZqtPDA0maTBsTDszwwSw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39830400003)(136003)(346002)(376002)(366004)(4326008)(8676002)(4744005)(478600001)(316002)(36756003)(2616005)(186003)(8936002)(16526019)(2906002)(6486002)(6496006)(83380400001)(66946007)(66476007)(52116002)(5660300002)(6916009)(38100700002)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MVdzcWRySjIvU09MWXFxdDAzdGFLTmJSOWhRMXh5RDVqc1VsaGpEbzhTT2RL?=
 =?utf-8?B?a0NJb3l0cmtiVW5vL05TMHJNZUJLNE9Ub2RYWndkRlBTWmg2K0JNRE1KOXFj?=
 =?utf-8?B?dVRBRG5ISlFzSXFHTisxUDgvWnB4eXFGZGMzdm0vbzFWVmUySlNJRXp6VDVo?=
 =?utf-8?B?cnFoVThLZkgrZC9Td1h2NXZlRDhRSGhjTDlRdXpKckFZY1I5WFFreG02M2FL?=
 =?utf-8?B?SUJIUys1eEZyM0pva1ZhZXJlSnZRaWQ5ZHdlU3o4TG5EN2xKM2w0TTlaRkMv?=
 =?utf-8?B?USs3US9tTmI0dzQ3bGp0eWcydTR1dWRKbE9lT2FjVUd5SVFEcCtQTzNQWlhh?=
 =?utf-8?B?bUNHMDVGdXFOdS9DdC9WOHE1Q1BVQ0xBOGZWd1dZRTZ6Qmx3WUhsUWtibkxE?=
 =?utf-8?B?dXl1T3VzSVJlVjRPakFpZXJaNFJVYWRpeWE5TG02bkF2Y2E0alhqYVZPNTRi?=
 =?utf-8?B?eDZCZXVIUzNiVlYyVEVibmJtMnErancvWitZSnBSL29vVHdnMHhVOTBydGFN?=
 =?utf-8?B?dDNaeHJnSWNuZUV5d3A5azZETXluMXdoSk9PU21Vb2Y0b1c5NXkxQW9zVWp6?=
 =?utf-8?B?UFdBMGlUMnk5Uk9IM0ErTWw5QnViVm1IMzNXQkRGS0ZUbVBaTy9laWNib2F0?=
 =?utf-8?B?Q1hadWpCQ0orS3ZnaVBUZUhzd1ZNN0FBUDdKZFd6OHk3YjRNSmtWWWpIcUJo?=
 =?utf-8?B?QTUxYkw4cFNpenRmNmQ1SGpWQkpPYzhOMHVFSVVBSzZoajlibUxwSmtEY3Nl?=
 =?utf-8?B?bzFaN3NiVGZDYWd6SFd5VVBVWXdtR3AwTzZqZVRoNkU3bXVSTXZHRFRnT2RJ?=
 =?utf-8?B?MHhrL293VVE3WUVHSVo4WGlocEZNRWwyM0Vud3BBT2Mra0RsT0g0aUxmM0gv?=
 =?utf-8?B?MVdndm10NFM3cTJhRTNaTll0a1J2azJJcHUyR3k4VlFlTG04ZUdnOFkwWGg1?=
 =?utf-8?B?bmhRSExpTEdzOUdSQTdDVzlhZm5yYUpGbGRCRndLdzFzcllNS2MzOWNUdGpF?=
 =?utf-8?B?azJaOHJzMFFjU0ZhK1pacFRiRlhDVVllOEhkZlNIc3ZZTWpRZGdjRDMya3c4?=
 =?utf-8?B?Z3lNOXZtV3haM2gxWm9tL1E4WitmaDcrWUFiRVN2Vmh2bHMxTHdwVFZtTDBm?=
 =?utf-8?B?OVhJUWtlL0xSRjNxUHdlbkEzWEMxVHV1YW91WWxFVHhsN2dHWUhQZ1FhSmwv?=
 =?utf-8?B?U0lWWW11K2lVZjNST2toM2Vlc0VEcklPVFdob1JTUnJHNGtod2JPd2dxZ0Fj?=
 =?utf-8?B?VSs5NldvS1pXQXU0UWx4MXQ0WWFya1pIa1JscjhFN1VzV25VVmU5MTUxN2pv?=
 =?utf-8?B?RTJyMStFT3hPVzlTMmI3cklSYlFVZStPM3FRNVVqV25UNHIvVVV6MSttVThU?=
 =?utf-8?B?eC9vY2ZaQms0WEZSUDlVNjE1cW9va2NzMjBuOFZFWk1WY1lGd1JyaS9yUUxk?=
 =?utf-8?B?UkpCVlRCOFU4RVdleWljS0hlaklpdDZ4aXMycCtIVWNKaE41VVVuYk1ZVXJD?=
 =?utf-8?B?SVpZZGNIeElydDllNm41bzhNeGVMd29xNmFJbk5XSnJoUk5rTWFjM0dPbVJS?=
 =?utf-8?B?blhwSnhjRGtBWVhDZ3d4UUJSekJZdWxGSDFnMU5INFI3NTZ3Qkx2UDRZVnBl?=
 =?utf-8?B?dEladm5KeHdnOElMeHJyckZaUmZRVXJYQXdGeEhqMW5TYjlFazF5VnVXNTEy?=
 =?utf-8?B?WndKcXl2VzhsVG5tVGcranpGOTZIaUFLRnNXcURRdU1ITGY0Y1ZRZWk2MmRj?=
 =?utf-8?B?aHE2Z1hDa285RE9sYmpPT285L2tlanJBQjR1UmhuVytwU0NjL0tsRFJmT0ta?=
 =?utf-8?B?ZFQ1NFZidXBqaDU3Wlp4SVVDQVJKVXkxYW9DN01HZnhBSkk5TlRib2RleEc3?=
 =?utf-8?Q?SATaa6g9phuPE?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4763c73-0c16-413b-e3ee-08d90bf6e051
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 16:42:00.3938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vJlAXJeegJLxBiSVoWEJ/RK1hb08RHIfS1kt4h9v/hIWdA5wiX1TsYXCw0bDalT1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7278
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Steve French <smfrench@gmail.com> writes:
> Updated patch attached.   Fixed the remount issue (remount should
> clear the shutdown flag). See below simple demonstration:

I think it looks OK

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

