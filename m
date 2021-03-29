Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1CE6C433E0
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Mar 2021 16:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2F0F61919
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Mar 2021 16:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231719AbhC2Q0J (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 29 Mar 2021 12:26:09 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:43355 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231687AbhC2QZz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 29 Mar 2021 12:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617035154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OkVVTiNgNAGVKKxXmSbJ45707scXwHxDXOiGfj8o+RE=;
        b=mR6BgtiEZvLWQEvkjAvyd58QDw69MC0OEvRToCdGTC9JVd92sXWSyMcqKXmisdLE2xAbhU
        HqXplT0uVplg4WS/YQtYPU2r/rGYLFkSeG0H6VTo1RAIq9uuk2vzpCZG776Rf5EhLkNPc+
        P4SgfLQmSNpEEDVW5Ul+P61q8H6ESK4=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2058.outbound.protection.outlook.com [104.47.4.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-15-GXBomO6VMtm2BCZpKAIjsw-1; Mon, 29 Mar 2021 18:25:52 +0200
X-MC-Unique: GXBomO6VMtm2BCZpKAIjsw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPWnqXkKq6JGvB9vDoUFZeJiNvkZjmmlZi0SFN+BuXJBIj4DvbTEbFAjA4BhxAo2Qa+9BAAF+PlDIi3AnBxJnQ9RAeOrts+qSvA3hqDqpUOnADOEMCJ5mc8SP4jNituQsSg8Q1x65qESXgFvEgKg2kgKCwZiwAUp6zk2GhxeGiERoxD5qkw8SdQlxLsgbqsm6vLsgotK5qDAoNCd63yUWxNmNKZBstD/nyNgZOHISgPr3+bTWTydBKKEU3MDXmL2TRF2wPbn+k9b6A51HxCfobIS8lPeS4mm4lkvIWRSNZoQK1LWx84hejmFzplPti/nsVzIY9GLabIv3jBXRr/YOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OkVVTiNgNAGVKKxXmSbJ45707scXwHxDXOiGfj8o+RE=;
 b=PIHFqZLCj83KSBrC8mnWnXL8O8XFvUH0yDEuRSEKMDeySi9J+xTaxalrUj9P8IPkkCVk4oNDHSH2SHZ4JpuO+y2Y2wuRwTt0ScgjqcR4h11WpZ629foSj1odXhTYeRTQ/Y8iYBstIpwXw82TCOkzA7nRp6KjIis4zdOg6Dm9PBq10t/OZL0yEL8jqsrMjTpyGi+xlxprn/VgRkojZn0xDCr2UBgrRivG6QPFoG/2CZSRJ3trPVEZJir7w0CgtoMJusfQ8Q7LQg0XLHlg1frveDw9zD8mMACL4gO+oaBYEt57x33/ufMFFkeQOKIJeXIJm0fdoElQxmClCjoXTwrHHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: uni-jena.de; dkim=none (message not signed)
 header.d=none;uni-jena.de; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VE1PR04MB7485.eurprd04.prod.outlook.com (2603:10a6:800:1a6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.30; Mon, 29 Mar
 2021 16:25:51 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.3933.038; Mon, 29 Mar 2021
 16:25:51 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Frank Loeffler <frank.loeffler@uni-jena.de>,
        linux-cifs@vger.kernel.org
Subject: Re: specifying password when using krb5
In-Reply-To: <20210327113252.GC8814@topf.wg>
References: <20210327113252.GC8814@topf.wg>
Date:   Mon, 29 Mar 2021 18:25:49 +0200
Message-ID: <87o8f2orjm.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:a768:3507:171d:8867:5078]
X-ClientProxiedBy: ZR0P278CA0008.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::18) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:a768:3507:171d:8867:5078) by ZR0P278CA0008.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Mon, 29 Mar 2021 16:25:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 818ca9eb-9cd8-4fd1-dd2c-08d8f2cf5176
X-MS-TrafficTypeDiagnostic: VE1PR04MB7485:
X-Microsoft-Antispam-PRVS: <VE1PR04MB7485B857775D49558C226920A87E9@VE1PR04MB7485.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kttPmSks4+tsFuecMpI50cBr1R+SyXLlLdTCICgnVCRgmn1PaZY2lYokaJOcJvNyPZ1aYEVRUZa75g3HmVFCAfPG9wkRSCkUR4RXWMWPCaCDuSYUjMzEWBoy0XMHXjEmxkY9mr2yGl50HAXP1hGFyq9OefJySN+d/4ZjLlfiEr2PFZejgAM1SlOxBXGAmhHrc7jNFNy5WSM/6dvv7DNsAYn1ck/Y/Frs1Y4rXu7pHqkwK0VjBgwIv8Zbovwi5Xxi0Dtep63nEqMB2yNA0RXQdUyuhTcXUtnR1YUj45xHRRuRBBeTIkifyki7hOgiXh+39OsUhPlug/xbWeCJrKbyk79+k1DN7OaCMMpOKurPouI0ZQPEJWYhsOygAIqKUSNlH4G/VAOLvxttdX8LiZoZ/wc+ShX7xdN9OSAD2bT7CQSqEfx2UK9g8zGyYFYOyxdyxHId6kRhtnGnsPhf83Eo/2U9nZoMgb5MdZl97SnI+p9PLsb4s3QYLYSJbXYk/k2s3PJeQFMONVwYJAc60dTqIdffWlkByT0qvzn/+WMFPUR53jbZcwJrsKFYFtOGyeEnAF7Th9zC+JHg6lQ33TXWpwG2zlr8uFwo9i7hrPvPy/9zP610ODfzEsfjCR4wLxCGTGAHyQxFH71i/bjiwOrwVT2ZC5HK6DQXS30fN+6c8xA6SHkSwCNXE6xegTFk3aaSRzPFyJGyYzBOH/h2tl76T82UchrKl7gbGWojpP75RTU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(39830400003)(366004)(346002)(136003)(5660300002)(478600001)(2906002)(52116002)(86362001)(38100700001)(8676002)(36756003)(316002)(966005)(16526019)(186003)(83380400001)(66574015)(66476007)(66556008)(6486002)(66946007)(8936002)(6496006)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?U1J1amh0ZXZBZm9uWms3Um5TV09taFhIaWE0RUZLazNLTVRRcEpLc0FSRlYw?=
 =?utf-8?B?NEJEWVhOd0svQWk3c1NiWnZieU9EbW0wRnpsTHp5SjhJaVBSYWFWNDkzZEZa?=
 =?utf-8?B?cEp1REVkbEJZdWxpT2ViVFg4bzhreTEvMW40VFo4bDhJa0NZSlR6RWNtZnhy?=
 =?utf-8?B?MnZMZEFrdmU1THdPZGVWWUtPK0d2V1FqcXlzekV0Y1RhREJwemxaR2hacGE1?=
 =?utf-8?B?NE1xZG1XZStmMnYxVCtGd0JWZHFmUWpFRlNBY0tFT0VxNFVuR2NkdHZidmhQ?=
 =?utf-8?B?SzJkN2E1U3lmNUxLT1RoRytHUDFTRjN4R0pIa2VDL3dOYTFGcVE2dXdGN0ti?=
 =?utf-8?B?ZUhENjE2R2hBaUgzaFEzNnljQ3czaUxEMkUrQTg1aEdsamR6NkxTM1RSYVFV?=
 =?utf-8?B?ZjhxMUZCSzA4ZmhsR2hNbVoycEx4UWlweEh0L3RLOWF1eVAyWE9CaitBRUEy?=
 =?utf-8?B?ajdBbFFwMzZXS1lwUUtLQTlYeFJmM0hSUXNqVnhtZXYzSnQ5L3VTUEJNS0tq?=
 =?utf-8?B?VmJnb0x2aHNWMDREWXprNWJKYk9BVlFzOThQTVNnbEV1RzVwbGZWLzlId1g4?=
 =?utf-8?B?TUNPM0IvQ2g3NmZzbWR4eUdVSktqdmhXeFlHdGVGT2JibXc2ZC9XMExGOEJT?=
 =?utf-8?B?YVh0T1FzcjNhcFZZVFQ2NHBsdFdiK0FUa3VXbE1hYlRtZlpPTVFpQ05Rb1VW?=
 =?utf-8?B?ODlOWitwd2FGUDIxSllGNGR4Sk5xNEttMFl4TGlOcmtrUjBsUHprcU85RzVJ?=
 =?utf-8?B?ZlU0MlNKQkVJMUpMUmhrYnF3UDNkRERsZlNidk1ueW5ENTVSTVA0QTYwTDg0?=
 =?utf-8?B?Y0JaM2pUTkJzaUhWYTNTSkZOdU5TSjhjOTNnVE1UY3hRQW45K2dRZWd6S3B4?=
 =?utf-8?B?NjlERkFVL2dTempxcFNXVEVNQVByeWx0TC90dno2SUcxaVZjajdoSkt5QXVY?=
 =?utf-8?B?U0dlNk5QYVlLUFpXOHhoOFk0MEZiTzVBS0JTQ3d0eUpzb2dHYllSMkZ3UmJt?=
 =?utf-8?B?MEV3WnpvSVh3NGZ2a1UvNDkzU3RHc1lmZVpQRGIxN3JjMzlzWFhCTmYzQVJW?=
 =?utf-8?B?SXRhS1pMZ3ZzNlJnQ1YyWnV2YVRrak9aSzlaQnpueXlUd0ZZT01GU0JLOWxm?=
 =?utf-8?B?OXFKT3NWK1FwRnphK0tVNUUxSnAyS0dpUXJJNlI4Y1J0V2JQeVFmaU5ZUDhK?=
 =?utf-8?B?cE5CRXI1KzhBM1gzOHpqcEdmdXdCZ1JxWWZVdnF3Zm5JbUllNk5OU01DZ2VF?=
 =?utf-8?B?S0Erc05aeE9kaG82WjRYWkM5R0tKbjY1WXIxK3k3QjNQQUkxTTcyaVhxTktx?=
 =?utf-8?B?dGpUb203NVJJNnlTTkZqV3pTQkN5cUFpVDJqc0F6VFpDL2RJdnZicENteXp2?=
 =?utf-8?B?UE91TGNvRjJDQ2lEd05rU1FleEhHcDRhcFZpMGRvS2h1KzZ4RVl0VklLcWNG?=
 =?utf-8?B?cUxub2tCZ21RTFh3bHdHbEpFcWNHVHhRK1I0NkpOaGZpLythVzNEL2pyeFVr?=
 =?utf-8?B?Q1k3eHBQcUZsN3dUNVowTEVMbEFQenZ1cURTQzFjTDF3RGR5bjdoNHRlZGw0?=
 =?utf-8?B?bGlDSnJqSFNqNXM5QzRvTDYzOFBhWUJ1em9YblpRWVpDZjB0ZmpzNjVxYWFj?=
 =?utf-8?B?S3FkS2lod0ZpUmhIRUdTRVhRWjZ5UGtpY0lyYU13ZnR3N291dmk4UjdNSHQw?=
 =?utf-8?B?YVhmSHBuKzUrQ0l2Y1M3Vk5ZNW1ob1ZxYmNJR2NwMWIyZ0lhYll3V2ZnOXlW?=
 =?utf-8?B?dHhmSFEvMU5kTmlyemVnbEhRbFhKQTVkdHdvL2I4RkNTTkR6M0ZXRlg1Uldy?=
 =?utf-8?B?cE9lRWlXZUh0YWdJNlllVWFNUzA1QlNvemx0Uk95M0plTDNsM3lZbXFpeVdD?=
 =?utf-8?Q?7t7XTGamfkfHo?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 818ca9eb-9cd8-4fd1-dd2c-08d8f2cf5176
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2021 16:25:51.2920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bBi9Utet7oEJpbr/pVZrLBhOE3cgiJzjp6X/mAcI8rhaQsBTH9x2jlp/Dbqgi9/3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7485
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Frank Loeffler <frank.loeffler@uni-jena.de> writes:
> 1. Is it intended that mount.cifs will not ask for a password when using=
=20
> sec=3Dkrb5 and will ignore any set password?

As Shyam said, this seems to be the case.

> 2. I don't want to setup krb5-tokens for users. All I want is=20
> authenticate using krb5 to get the smb-session and then forget about=20
> krb5. smbclient seems to be able to do this. I don't know how they do=20
> it, I suspect they create a temporary token, open the session, and then=20
> drop it again. Whatever smbclient does: couldn't mount.cifs do the same=20
> or something similar? This would make the 'password' setting meaningful=20
> for sec=3Dkrb5. This does not mean that existing tokens couldn't and=20
> shouldn't be used. It would just mean that users would not *have* to use=
=20
> an external mechanism for this.

When you use a password you're actually not using krb5 (even in
smbclient), you're using NTLMSSP authentication.

> 3. For the moment (and only if my observations are correct): could the=20
> documentation be updated to reflect that "password" is ignored for=20
> "sec=3Dkrb5"? Users shouldn't need to dig inside the source code to find=
=20
> out things like that.

That's a good point, I'll try to update the cifs-utils man page.

> 4. Currently, trying sec=3Dkrb5 without token cache files results in the=
=20
> rather obscure error "mount error(2): No such file or directory". Could=20
> this me changed into something that points users to the actual cause of=20
> the error?

Sadly we don't have much to work with. Mounting is done with a single
system call mount() which can only return 1 error code from the list of err=
no
codes https://man7.org/linux/man-pages/man3/errno.3.html

The error printed is the generic description of those code stored in
your libc.

There is a new mount syscall API that allows returning errors _strings_
to userspace. I've sent experimental patches to make use of it but I
haven't received any feedback on it. Your post is a great example of why
we should merge it.

> 5. Am I even remotely correct with any of this? :)

I think you are :) thanks for reporting.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

