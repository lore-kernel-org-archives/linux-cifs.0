Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A8CEC433ED
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Apr 2021 10:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3931B613C2
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Apr 2021 10:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237523AbhDFKO5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Apr 2021 06:14:57 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:43534 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232696AbhDFKO4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Apr 2021 06:14:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617704087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nldumVSVePquCXazler6bXpCzZJhC7kEL/fAigfoayY=;
        b=en+e42PYVLqK6xLlMuvGyFFy/KT8aVTo1+R2KIwXHly6AO813Y6qDp5o+oSJvO5liEYDvZ
        TIABjZC/2Tfa3VhkaBYym6ZoB/+xcmG+qpEy1OyKfJGJKyiYs33kzdnKHxP8VhuXaC0VNJ
        uoc/tVVQO5yE33qgRsd9EvvtzqtzVjI=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2052.outbound.protection.outlook.com [104.47.5.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-31-ZiMfhc9GOIOI0nSezKh2uA-1; Tue, 06 Apr 2021 12:14:46 +0200
X-MC-Unique: ZiMfhc9GOIOI0nSezKh2uA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNFXpMAiYonKYW9GQ/m6L0gVp+8APEYv6wHUMM5LktKtH4KB6A5ZYGQstSEqfmqkXYl8MyI3HERKJBUQSEWrmcZqNYU8S7RuDV8TGJz5H04cJ2AcC/Z4ZMSIxpQp63FRNl6IF456vlJH3IfczhttqR2A5wO9s+VgjYFZL5K2g+J9rkRtRwQpivQjKBBhwG4OmFDMJMFfH74JpXzv+Gljesv/hWfJZ18syye63UESpMHClYPr2pyaY+U1DBl+qGueej+yeVFFAGvJxcYFIDjy+a0TDTUUQQhMWf6sLp6j/LdxgJBA6IlTAaGNJ9sxcP4+acITpZy4wu1ukoj2m8/lww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nldumVSVePquCXazler6bXpCzZJhC7kEL/fAigfoayY=;
 b=fBe+2qZ1UInp90OKyHPNRQnQ67a40Pk6mf0EzPZ0zijuYFjDino/EVFDWM1cqiw+b8BoR/S3/iavfLAYEZvF/DPH8qP40rTkduksq8H7f1qxh/nWweFZTqNqVd75NJheO2Ty6SIQweEh42VCNKfEi+1FUGV39AHmA8IBj6SFwXUAT6Ica9k3VqtOnJK3NVC53q1yXh5vBDtDSftHfS9MT+LFp4zqRMOT9MqWV/Mu2+SU3Bxdf4cCDYWqWVij0QaV5aWg404JxxjxsF71H2BOzmn1/l+/B1nATwgy7O2I79HK2FfyHLmjkUFRyj1AR8gjvR+02PsKrLumwz50G9SilA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: tlinx.org; dkim=none (message not signed)
 header.d=none;tlinx.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB5760.eurprd04.prod.outlook.com (2603:10a6:803:e6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Tue, 6 Apr
 2021 10:14:45 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 10:14:45 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     "L. A. Walsh" <linux-cifs@tlinx.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     namjae.jeon@samsung.com, linux-cifs@vger.kernel.org
Subject: Re: cifsd: introduce SMB3 kernel server
In-Reply-To: <606C1DD6.80606@tlinx.org>
References: <YFNRsYSWw77UMxw1@mwanda> <606C1DD6.80606@tlinx.org>
Date:   Tue, 06 Apr 2021 12:14:43 +0200
Message-ID: <87h7kj4t4c.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:3023:3e6b:6105:9a2b:bde1]
X-ClientProxiedBy: GV0P278CA0028.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:28::15) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:3023:3e6b:6105:9a2b:bde1) by GV0P278CA0028.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:28::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 6 Apr 2021 10:14:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 616c369b-9eaa-47a9-b44a-08d8f8e4cd1b
X-MS-TrafficTypeDiagnostic: VI1PR04MB5760:
X-Microsoft-Antispam-PRVS: <VI1PR04MB57603710019E965061E1429EA8769@VI1PR04MB5760.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9E4CEyNztCGqcT3aNpo9+Vr3pYC/sDySVvTltiv2gdQGiVPJISjzG0MP990NqbxO5KQwuiJF1aM9N1EDIVI3oQ8g1OQcI7XcrTiu9cqEALubRbAAW50qksdJsZ/rGg6sH1te8hlg+KFhFv9/R1ydY919ORUH+opT/9ggZLsjMsgeG4kvG0UFfqUeoa6Ik8JQZx0y7Meo3EXmpxEAm+TfYQ88UGvuiIjQ+hZqa052MX4V5JeZDIZpGZNvfoNmY78oYoG5EUrPl04lR7E1z4MzraKp/mJjiuj8OreSb/Y872BiG63XbVpnlgwPOTJGpRqiStEhn7aO+jAjxX0zWvXNNrmbqyUuetRNa68ZQjN6c9rY51ZioauHXLXJ/jTcL9gGyXMqYsElSjesDSaEXmiyF6uJGQDtFpi780bEO+JrHpdSG197t+8l6AZYCgdXFH4Uh1JFsbHvf4F6FO+CCp/IRSldxD2/wbNLkVPe38NX9FYFv6NwZvIHU8AchZH9OoUHuOAka7OQpDgBETTXCDziXeZbsDlJjONrgcMOl7PC68+lWNumwE25pTYK0Aar1TC/vVtoeELyA9lyvkjvXB1q7b6rpoUwAIr5zioQnbyige8+YoiYWEtaOgA1/7NDJEawWkIFVcFgOSHRC1+jycASabb6VnWqoFLusGs6rn3FSmYqX237M1JxxLWGu1hfoOe1Ae4fcAyGAcKoGxrq5lU5m5FJwmoqZ5n73Gwy/gkts6A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39850400004)(136003)(8936002)(83380400001)(86362001)(478600001)(2616005)(6486002)(4326008)(66556008)(186003)(66476007)(966005)(66946007)(45080400002)(5660300002)(53546011)(6496006)(110136005)(38100700001)(16526019)(8676002)(2906002)(316002)(36756003)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eStGRUd2YkIwS3lKMnhpYXhMWjQwV1RLNk1rYjZqM3E1OXc4RjhZTm5ibUdU?=
 =?utf-8?B?V0gwL0liWHJZRjdYUFM2WVBZQ0hTeEdvRG1IbXFjeVBYUEpNeE1hYlo5RW9X?=
 =?utf-8?B?RG9Lc1JWODdCZGxBM0xVeFI0QWdEcGowZmJxSFplYWlOeWh1N2FKK1hLd25z?=
 =?utf-8?B?ZXUrQzRlNWJuZzZuMkZVV2ZzUXJJVHY2M05PUno2MWo3SG95V3FnZjY4QTlO?=
 =?utf-8?B?L2FYbUdVL083RzFjcWVsQy9zdnJGRExMaVRZaGVCUXhIY0hmYzVoWXB2SmVK?=
 =?utf-8?B?YXlmcFk0K25KaVNjQytzdERFWjU2eGFIUlF2QXIxdWxRMng4T2ZtQldiSm8z?=
 =?utf-8?B?NzhkRHFka0U5NTdsVHVWUjZubWRiem14bVAvUnZVMzljb1AzOGFObFhpWjhh?=
 =?utf-8?B?cGVmT3htcXVZQm0zZDREeVdvdnpBR1RqcUxqTTlzc3N1T0pIZ3pvT1dnZXFr?=
 =?utf-8?B?Y0VITDdBemtKZ1VwVUkzeFRWL29EV1dBRGk2MHBnam5qa1dDOGtvK1JoS0ZU?=
 =?utf-8?B?S1BVdWVtZHNvaGd1N1NKaTBESmM4YlliNTNFbllNZGRvWjRHMUkyOTNMN2FD?=
 =?utf-8?B?UE85SGd0RnEvVG1BaVpKMTdxY3hua0EvTERLRG9RMFg3b2xxcEpYeXl1V1A5?=
 =?utf-8?B?bWRrMWVNZ2pORkl6Q1FiYVpCN04rYlJPcnJiZGYvTUtIQU9oS1JtOTRyeURH?=
 =?utf-8?B?MjRNb0xqN0NsSWNNOUxhckdVdFlDNTRnVWRtY0sxcEZXaGE5R3NiSlk5S29J?=
 =?utf-8?B?OEdnYm14T1BFYWhTKzMxTDRUb0xoVGZabkZpdHBGRDRHYWxMaFZOVXdpMkt3?=
 =?utf-8?B?alFJd3ZTd25ndDFRMlNoR0N4enBPSHIxUi9iK1krYWZBalM3d1o3VFVtWXBD?=
 =?utf-8?B?elovaGV1YVp3bmNmU3BKVXZIak1tSzZ0d3BKSTlvc0pkbHpHd1ZkRW11ZWlt?=
 =?utf-8?B?Nk1aOTBPVUorcGdWeEFvWmJFSG10QzBSYU1HZVh4NFFTcXl6Y3JsL2Y4UkhM?=
 =?utf-8?B?b3lxMEFuRm43MVh1b3RzcDZXZmdoQ2hIalFteW43T29OM0dRTm9NclEvTVdV?=
 =?utf-8?B?MzhKSEhmNG5qL3BpaGdwdG5jRHlOZUlmSTZRaG91UExUUHFPNk9pQzVXWXQv?=
 =?utf-8?B?VXp6VFcxYmwzdXpWclVKYUR5MGxETWhDdlVCQXFESXpiTWZmWFdLb2ZmNEtH?=
 =?utf-8?B?NjJ4KzUrWXovNldjSkdvYURTSkJJZHJOR3d3a2Z3ci9wSStGTElUNEQvY1JF?=
 =?utf-8?B?dFcrL3l2dEdLY1MwWWhDSUYyRmFYajZpNWNDY092NWFQQk9VckV1eU84czRq?=
 =?utf-8?B?Z2tzL2crQThiQUdBdjBTNmdicEpZTDVLdGMzbTl0QXJSeW5ndEx2ZE9CWTV4?=
 =?utf-8?B?L2x5WEM2SVM3VEVPQzZKbEM0ZlJpUnZZZmh4cW92d1hGWGp5RVBmNk1IemE5?=
 =?utf-8?B?eXFOb1RUcDBHbXBrNjlvaEp0NU5KVzA3Wk9VT1pjWGtpSWNoYzF5R2F6Vkw4?=
 =?utf-8?B?SXNJczQvL2pqNXIweVE2emg2U0MwVERWVE85ZHgrc0ZXeWQ4Q1NJK1FHbDZV?=
 =?utf-8?B?YlMyT09xR1dXTERZaWpDNFNSZi9GMDFYSWVyTTNVZjVEM3ZDSEVvMmZteXlH?=
 =?utf-8?B?cUZEOEc2YytWNEx0YUxIWGRxSE12Y2c0ekxVK2NWdnQzcWcxa09VYXBhQTZY?=
 =?utf-8?B?ck54bVZJVklUT3JOUVZWZE9ROFU4c1V0Q3gwcVpIMVJvV1lRc3k3Y1hxaUVj?=
 =?utf-8?B?RkxjMGwxQVBzZml4ejB3Y0xlR3dRcEI2MWwvdThHeHNEWlhYSmdvWkxVUVhx?=
 =?utf-8?B?ckFiV1V1OGg0M3JnUkhhQXFPMGhnVEVuOEJldU5JTXU0ei9DM2M0MUZrVzFz?=
 =?utf-8?Q?YgQ7pK4oHgwFi?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 616c369b-9eaa-47a9-b44a-08d8f8e4cd1b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 10:14:45.1411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9JYt0977Ra5jL/wjrIO1DiMvvu8l6Q/4uytgRN/rwgYzcwEpGlc97O3H8qvc1nWV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5760
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

"L. A. Walsh" <linux-cifs@tlinx.org> writes:
> On 2021/03/18 06:12, Dan Carpenter wrote:
>> [ cifsd: introduce SMB3 kernel server"
> Is it to be Linux policy that it will give in-kernel
> support for only for smb3, or is it planned to move the rest of the proto
> into the kernel as well?  It sorta seems like earlier parts of the protoc=
ol,
> still dominant on home networks, though it seems linux not supporting
> all of linux's smb devices, from smb2.1 and before.

smb1 (aka cifs) is unsecure, out of support and being actively
deprecated for over 10 years. Microsoft is uninstalling the smb1 server
on Windows updates. That's how hard they want to kill it. Samba is
planning to drop smb1 too eventually.

https://aka.ms/stopusingsmb1
https://aka.ms/smb1rs3

> I'm sure those clients would benefit as well, being kernel services
> could allow for a lower latency with potentially faster response
> time from being a kernel service instead of user-mode client?
> Is that also planned?  Isn't the base of an smb3 server the same function=
s
> of an smb2.x server with the new smb3 extensions?

AFAICT Namjae's ksmbd support smb2 and above.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

