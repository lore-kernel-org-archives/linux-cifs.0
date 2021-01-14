Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9882BC433E6
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Jan 2021 09:27:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E10F23A21
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Jan 2021 09:27:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbhANJ0m (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Jan 2021 04:26:42 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:49113 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728228AbhANJ0j (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 14 Jan 2021 04:26:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1610616330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zCPfuXy5Bii+wf/SqTz1JCjyXiojJoo0V1h2IG7/dvA=;
        b=ZPXXridQqCZ/Ku68lx+yIMagY3Z4yW5nBS/couOSbDxnkXvmbF5HKKHDD2sdG8XbVOLzoq
        VATWb72f6Q2fiHRB87OfcGBjNi8ay8nTC3s9wDEz8A1Fn+De/9DKApKV1E/RZruRoGLLyc
        uOaTPfxEpPTVNh8pTnPt1muI6hGWz0g=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2050.outbound.protection.outlook.com [104.47.13.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-22-VyfuKy2YOJKnN-xHhcLqIw-1; Thu, 14 Jan 2021 10:25:28 +0100
X-MC-Unique: VyfuKy2YOJKnN-xHhcLqIw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EjFpuvw3odOeGI7WB2u9+QSqPIIcX0bxAymRbRT8qhb4O3znC65dZcKIeQ+Tp1vaXESz9fIR92NAtnFvWFVn2KPFyXw719dmq++kTLCKCYlZmkoEGPips3wquxRfBcJGnFtr229idujfFAMz0tENLqEIMjhSJ/XrPEROVr+H9HQM/Ft2Fk/pyICO8MZznX7zeoltLA8j3febzHxAdH0tFcGPk/rOALh2itheQmWc9lwBwC1UY2HcJDL9tktj9YbAlgQLl6ksy0/zOtV7OkQrGe/mb3oPa4Uctheq6tBHNxc8In7uTeHBfMNT9qvyZuUMt8NyaMFp07ZgtyEM+yPPdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCPfuXy5Bii+wf/SqTz1JCjyXiojJoo0V1h2IG7/dvA=;
 b=aERdl4fjPjjX1IojS9pbNYqjjbuYB3S4RrbJUa/jDoSPuEBhZl2FrN6xv+sb4fj5ucXpGxFctWGrvcHtnQB/QBt4p9Oa4RdyHkp6oGa5rSvMrInehqP/tCEnhKqxnhDqZBsVqsu9PHh6sKrb2Vi2449FSvMjxyYM6tgf5UhS2orWHOlBUHcE7KUpNLKKXNg8P1HezS4jHI3f14CHXcoqz2I7TpLGucg4c1jfXt5BP2la1jk46s0pcfz5U1S/k3CN3FgVNb/s+hFqMKdRwjRkZM0uiOkxbnBgAuet15LmSw2Sw38ZauLtYm8JnFGtqxcuVJrGM0MH76GyKXHir5PP8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB5055.eurprd04.prod.outlook.com (2603:10a6:803:53::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Thu, 14 Jan
 2021 09:25:26 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%3]) with mapi id 15.20.3742.012; Thu, 14 Jan 2021
 09:25:26 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>, sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: Re: [PATCH] fs/cifs: Replace one-element array with flexible-array
 member.
In-Reply-To: <1610615171-68296-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1610615171-68296-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Date:   Thu, 14 Jan 2021 10:25:21 +0100
Message-ID: <87czy7lvjy.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:9f69:1ef8:3a2c:dccb:e3f5]
X-ClientProxiedBy: ZRAP278CA0015.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::25) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9f69:1ef8:3a2c:dccb:e3f5) by ZRAP278CA0015.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Thu, 14 Jan 2021 09:25:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8acf310-2237-4ade-40d4-08d8b86e53d1
X-MS-TrafficTypeDiagnostic: VI1PR04MB5055:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5055EDE8D8D49DE4BF5BC1FFA8A80@VI1PR04MB5055.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fe0RpK9fp3t9nspM2vLOKN/e5SlRrcq5+IVf1o9WFJgR9SEtP/gWXqLgIoF1GpHKLKk4KCWotQ83fHSjVNfCCIIMzs2lrIIdpGGzV08nSpS0jaRnqRlw6To4q7tSVI9XUUG9fp1DM1oqj1bT6Ncc9wj1O7pLIthtBHG2SYT8tiJQLasWRCqwQ6i+JW3LJBTM/Yl6CsMY8mSus1ZXA9CmqfKELZV5EO4QfKk+vJ1/RQ4e6cQBtZncDNDt4w39NQpvUD55go/P9e0hvkFeUKmhfUYJkmBnxpbMWR/5sJ6rJBWUV8APIT+GAh6//1LQJ7agoOZCMTAts+qh+pOqqlBOal5F3oAheHJb7KFGTdZGbS6a8RVwR+hWUyChVnnxjzP5HUk4HQ6Tf9yv7TURJkf0bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(346002)(396003)(376002)(4326008)(66476007)(66556008)(66946007)(4744005)(6496006)(8936002)(36756003)(2906002)(6666004)(5660300002)(52116002)(6486002)(8676002)(86362001)(186003)(16526019)(316002)(2616005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?a0dVOEF5L2ZZVTdCRHdrZVAwZzBOMXF0bEpRMGZ0NlA1eUFYcmxUM25zN1Jr?=
 =?utf-8?B?OEE1eW1RSDZaZlZiQ1RyQWN0alplb3cyNkJvY0NYTWw4QndqK0hoSm1hdGNM?=
 =?utf-8?B?di9qQklvNW1DOXNSUERhV3RnMnlGRVBNU3Z6K0V5VFNFT0lhQ0V4bGVzazlE?=
 =?utf-8?B?anRmTmZIWnpaS3NSWkZGZ3VrQzJLbWRJZXZXWSt5M3l6Sng4S080RFpuanB1?=
 =?utf-8?B?Q1ZLVDFmeXorUFJBV2psM0pOZ3RLWkxYNjFSY2JxV1lqZ0JkY3pPRlNTT1J0?=
 =?utf-8?B?RUtSekYzTG51WTR6dTc0dWhyS3ZRVE1FaFBFVkYyUUpPVXd4U2ZmaDNDa3F0?=
 =?utf-8?B?ekIzS01QODVyRU1kSk9BNmVkcmZKWU5TQmZDSnlvUStDSHU0TmVYMy90eThw?=
 =?utf-8?B?bk4vZk5IRzJtVlFaY0FmdWpQdFcvT3ZUOUh6R1JiVWxFalM1TVIxTTg0WWt5?=
 =?utf-8?B?bmhmb3ZDK1JzcVExcEtJVEp0WWRyTWJVU2RvclorZzBkN3FmUERIR2N4YzZ2?=
 =?utf-8?B?MjhBS21zR0xCRWdJcEVQaWNYQW9nNW9xblMyLzFOMVZCb09NT0hBZkIwWjRs?=
 =?utf-8?B?Y0svU25zRy9nMlJOOWllaTBkUWg4SjlHNzYzOU1tc2o5WlV6cC9WVnBaOVQx?=
 =?utf-8?B?Nm0rdkxRd2xQYkd4QTRSRjl2L0M5cEZ0UUVEamZpTjJhL25ZUnR6eHF4ZXVj?=
 =?utf-8?B?VTYyQ3oxOVN2Tkk3U2ZheUpacFJ5Qzg0a3VtTU9UWkpJRFdqNDVQSitMcHdo?=
 =?utf-8?B?ZUE5NmNmbWZQOEcyVEVpN0JqT2Uyc3RpYlFGQ2J5Vi9kQ3hEaHlUdTh1Q04r?=
 =?utf-8?B?VlBRQ2ZFa05lYXRwRTJWRnV0NkxnQUJ4dy8zakNGdXJmaXc1ZEF4YWp2NGtj?=
 =?utf-8?B?WjVmVitxTklFcSsyRllVUkgzYzFmQXpUZ1VMblZ4S1BWUFI4SkQ0Q01yQnVs?=
 =?utf-8?B?WGRwSHNxOGROcTlEb0w3QlhXcExvb1YzZFZBazFDV3RVd2M2WjkyQ09HK0dJ?=
 =?utf-8?B?M3BMenhDVDlJYnEzUDVIUVh1ejEvczZ6UUwrOXZpcHNocmd5emFETHpva1ds?=
 =?utf-8?B?ckVkMFAyZm9SVGprMURBMVIxei9CRHZrVFVpeUVHeHNoQkFuVUhPWXpGbGtE?=
 =?utf-8?B?UG50L29yaVMxRklDSlRrc0xmVlZUeWF0cXlUTmdMOGZmV2dTaEFQa1hrdzl0?=
 =?utf-8?B?RXFTWXNISTB1ZFFYSHJFYUZKaXoyaDFMclFVUDcwM3RTdjJhWXpKMG1rY2Zi?=
 =?utf-8?B?S3ZXekFJUkJBaGlBS0xlRS9jUzBuUG1rdkJ1S0o2K21PYVFVRE1MUEFQVk9m?=
 =?utf-8?B?QnpmcmNoR2FOWlIwWFNIbk1NeHVDcWpvaU05Y2hDQnMxNk9ZaEVxZk5GN2to?=
 =?utf-8?Q?SXBOdVN95e1xvPJ1zh2YRq2ADULHYyFQ=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2021 09:25:26.4401
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: c8acf310-2237-4ade-40d4-08d8b86e53d1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8UFvgW5TQlzZxp8btpFgLsbnSGika6jjQGtpFNXhZrIF3ofdAed9Q2o4upYmuFMY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5055
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Jiapeng,

This will change the size returned by sizeof(). Have you checked that
this doesn't introduce off-by-one errors in all the sizeof() usage?

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

