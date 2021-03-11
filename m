Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 887F2C433E0
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Mar 2021 10:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45A5864E58
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Mar 2021 10:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbhCKKA0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Mar 2021 05:00:26 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:29300 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231639AbhCKKAV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 11 Mar 2021 05:00:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1615456819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IYc6S2ZaG+ViO8iK5XizkZVcyi2xvFZ2eFzr4majxho=;
        b=G9iaJHCTY3aVdWx5bi1eCJRIKRYQLiTmOGhFLCPAFwlXBzEaN+m40ZnX0YrZT+LriyjvsS
        y5+2wnmxE01pncHzSVwXWEygkEyNQMtURVccM4+l55KTuUI4+5ME4oKq1QDg389w0kl0do
        8H8VaGDpLAnNeb1qTnYuXf108A7bd0A=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2057.outbound.protection.outlook.com [104.47.0.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-40-LnfHrtCxPa2iQXB6XOI9xA-1; Thu, 11 Mar 2021 11:00:18 +0100
X-MC-Unique: LnfHrtCxPa2iQXB6XOI9xA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KNz9aSZQoUiuNgFy4eM/cSV1X+MlEhl0//q4bLGVvFILQ5F4ssWb3e+j3GEea9F7GU2qvwHzHp0ODSPe1VM2nKb9Nf45fBSNqd3BOlBnzG+mW9WaWfH8TTYH6Ub1mHIbhr41NfjW8pHl82qoJb9NdnmgeHzFw9wCvK0CfPeY8IE6HlB+a9MthlqTjq01UVhdzObb9E1ZhZRCsnlfdPSC8h1KaZY22ftsBiZltdgZnKDmDu8HA/6PszpNZgKAAHDmGTyNEs1FiBKMeOB7sTITNVVzZVMpwMrU3X3F+CcxDlPtsFHp3uTe7CCGIGcy9WGwn70SI4KfNkapeKKwfscVqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYc6S2ZaG+ViO8iK5XizkZVcyi2xvFZ2eFzr4majxho=;
 b=Z2x05LhCjlg4A4r9ajndGM75l9j65+udAZ1N8ZcMCD4OLbMXvwcISBrMtmWAzVItnIRwEv2kwO6xAKFoxwf+bO4YBhFd7NJnBLMb7XsrYFmcejAuzDSSrCO+O9McJ7VDBvGV7sssw/nO+OjssLLpiofqBdSN4jBINF4eGAJQiKC9pfUvlJBRof2RKnaOtXzul+yRoLGFtdCmnngTebnqbtXktmOO0JYF775cV01fiSsGnYld32xNlWudkIlkSQRxTmbT98oid+UraBSZXR0lpatwpQAEYag6F9OgvdXukDTIgZI1eWAG7HxSkH7fm8Oz9WKqqMXyMjzgeG8xxRhNcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0402MB3760.eurprd04.prod.outlook.com (2603:10a6:803:23::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Thu, 11 Mar
 2021 10:00:17 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3912.030; Thu, 11 Mar 2021
 10:00:16 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>, kernel <kernel@axis.com>
Subject: Re: [PATCH] cifs: Fix preauth hash corruption
In-Reply-To: <CAH2r5mvkX7T=HLCJmL-T=5B3P7ipKMuzGJF6psoBLru-2fNfWw@mail.gmail.com>
References: <20210310122040.17515-1-vincent.whitchurch@axis.com>
 <CAH2r5mvkX7T=HLCJmL-T=5B3P7ipKMuzGJF6psoBLru-2fNfWw@mail.gmail.com>
Date:   Thu, 11 Mar 2021 11:00:04 +0100
Message-ID: <87v99yt3h7.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:70b:4a83:b8f5:d569:2662:f8fd]
X-ClientProxiedBy: ZR0P278CA0051.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::20) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70b:4a83:b8f5:d569:2662:f8fd) by ZR0P278CA0051.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.26 via Frontend Transport; Thu, 11 Mar 2021 10:00:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e961a38-83d6-4c6a-74ce-08d8e47478c2
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3760:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB37604B26B51B68C6B5510CF8A8909@VI1PR0402MB3760.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: csJoPkhZlCBzn0N9G3qQZN9iKeC/0/TbWoje+juaMegQvYZEAYYRdk4fKPlCVKZWX2Iu+Mmfao/JB8/NZRIzNKQX3+LsNQ1sqx7ZynlFax8c9QI0K04s2P8gEVaoeTyEU882/+6W7x2Uk87ylKj0gjmOYKPDyb728SGYwGljS/8Mg4wjHizJsnpbo1Jqr7EVRl+/GNqzgdcy2NTRfyy8sVxsN0Fb2XPyJCd9cVNVfByGBrAfOmRy7ufnya6dsG3ZJYxuhsJcdGOQ1zMvFAl+jIfuBvxETIWwNO1D4hvX1m/cl/PN4QIOXrLFJDJRbUmSDo8WmQ7jPjZRji3Auo0BnQK0y8XGFBx//QUgppjGvgt8QBLoCh8CITiTyXj1wDTvT0pDg1kY65YflBc2TbxzWsg2zD5wMXJqOWpsIl9KEJr1E2IMVLU/AGHmDpDO0vQpGj51yysEQXf0ub5Nvg+eBLM9dIUi32O0VcVT8fUCEenumkXTf/7gTo/cr/mFZTwWm//CDi7s1v2nm4Bc1NakOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(376002)(136003)(39860400002)(66556008)(36756003)(186003)(16526019)(6666004)(6496006)(66476007)(4326008)(66946007)(478600001)(2616005)(2906002)(6486002)(52116002)(86362001)(316002)(110136005)(8936002)(8676002)(54906003)(4744005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZW9PV0dRdnJROEgzQXo0NGFuR2VKdXZMSDlTWGs0dWZhZVl5MzhqWVNMc2I3?=
 =?utf-8?B?VGMxSHdQV2ZsaUwrZjVUcGVqem40eEc2VzZ2NVViMUd0SklKN2F5RGZ2R25q?=
 =?utf-8?B?YWFwUE55UXVPL3kyWDcxdHB5dzJkVEFVZFg3U0gyOTJLbTRDMVJ2cm1nSDFM?=
 =?utf-8?B?QllsVXg5L215alZ2cWFCQ24xMThpK2NnR21iSXluczlmKzkvRnFkeDROajYy?=
 =?utf-8?B?NjF4N0ltdWFzR3JoRFRNUHdvd0lXcDkxQ2ZOR0dBdGhTRUl3aDQvcVAyUEJ1?=
 =?utf-8?B?dCtNRitzdWFwT0wxRVh0M2NOZDBpeXMzcW11dEIyRXJWeWtVZzF6VnNYVFJn?=
 =?utf-8?B?RW5SNmRRZWgrMlF4Q3d2Z0RlQWErb0ZEdUFwMWdpcjdTUVF6ZlNZWVJxRmF1?=
 =?utf-8?B?Ym9DV2ZRSHJDOVlXcEJYdXVNd3BnQmFjV2ZUcm1YL1VGSXFOT1dudm5HZHNs?=
 =?utf-8?B?VStPdHpvQUJwSnNOVkNrWEFmQU1TOXhaa2hDeStEc2dvWXkrd2Zob1h0Q2tt?=
 =?utf-8?B?bmFjSmNVU0FhN0VScFBoMWh0VjRiUFlHaGFhUU1nTVNobVVvb2VpeDIxV0N0?=
 =?utf-8?B?NXl5eGZkL1pLem90Yk5OdS9OdDdSbFpENGJsYSt0QjhTQlEzY0Y1VlpMV0s1?=
 =?utf-8?B?ZkNxbW02cHBaN3RvZzRZZGZvcXBKeHdxd09KbzJkY21uYWZFT1lKVWI0aWI2?=
 =?utf-8?B?eHBSK3ZEY29LcUI5dThZV3RZNFFhZVVpaUJaQzY1UDIrajJ4ZFUybVhPUFZk?=
 =?utf-8?B?OCsyUHcxN0dGVklRZWYyUkJ5YTJ3S1RNVHB3OFdlNm8yejZPUWYyRlc2UmFa?=
 =?utf-8?B?OXZhUGZxTzA1TEpMa0M3c2VGNkg5MG9CbXR1YmlqMmJHRkt3TzNySG1Qd2Ey?=
 =?utf-8?B?b1lab1BhZjhsN0N5UE8zTEtBdE9UdytkcHVEWGFiYWJFUkIvQWJna0t6dFBX?=
 =?utf-8?B?L2x1RDZjU0o1a0pvaEcxbXNBVXMyOXk5c3R4MTNZS0tFMmdMaGw1WjZYREVx?=
 =?utf-8?B?NVJKQVArVk1yRnpseUJyOFdLazhlY2xZY3dyeC81UDFGWUYza2E3R2VoQXdI?=
 =?utf-8?B?VU13K2ErREpNRk9DcGUwQS9YREhZVnQzZkVrL0RhVWo1VFo0ZHh1YzJBbUZ6?=
 =?utf-8?B?aXFlaXFubDkyQUZMRjZIRkQvOXhpbEZPZGtuR1RRMmM5R0ZWb1kwUUZhaW9K?=
 =?utf-8?B?ZFJCelZaMTN5cTJUSkJKRmdUaEJESlRrNFpCcWVKV3Y1Rlc2bWkzYlZBRm1M?=
 =?utf-8?B?SHN2cUlNeVRtaG5UYW1vVDBreEJCUWtNcVpoU0tKazgzZEprWkY0MmpuQ0Fn?=
 =?utf-8?B?U205ZllrT0gzRWUxTTNTQU1EQTE3Z0htZXB1RWpxcUthUS9PaXhWVmtORXd2?=
 =?utf-8?B?OGhCSkgxcDRna1k5TGdSUzdUZHRtQW43OVg5MU9ibkhIQk5zMU5OTTNVMHhL?=
 =?utf-8?B?UUZHaVZOeCtNYWh0aDdaNDJsV1l1UVl2cDR5aForZnFabWc1WlcxQWxZR0g4?=
 =?utf-8?B?dC9XTFZoYkQxaFNaOCsyUFpCcFM0TFZPdXFNWE9lV3VRRUc2VFBQeForYVRW?=
 =?utf-8?B?UU9XOWZJWG9pL0NQNFhJbXAxeTl3SGNtNHYvL3BDaTN3dUxEWm5YRmppQTFk?=
 =?utf-8?B?WXBYQWszTGFkU2R2b09kMnk3WFBoSDBTbVlDaEZCd0FWbHBSTTgxRzJ0a2lW?=
 =?utf-8?B?MXpYVHF4N3VTZDYyWTExZ1NOY0lnV1BPRHdMOEo0ZWJIRXljazk4V1h2Z0RB?=
 =?utf-8?B?OStIZmRTRHZKdnNteWxPRTJ1alNnOHM2UnY3RTk3UXJZVHdyV3BLQjV0RE83?=
 =?utf-8?B?WGhSMmNJaHUveTgyYy9aQVd1b0hUSzdOVDhZZ3ZRdWh2eks0M29pY1l0c2JD?=
 =?utf-8?Q?Ia0UwBs9dvd7V?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e961a38-83d6-4c6a-74ce-08d8e47478c2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 10:00:16.8912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7nb6gNjcL6S09bmsRqpuEYpdIfqbvJekVJkgM+GboZ95IEwgtN+GiTS/ciFiSU8O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3760
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
> cc: stable?

Sounds good

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

