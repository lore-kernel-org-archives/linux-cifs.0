Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B005CC48BE6
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Jun 2021 10:07:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CDF16101B
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Jun 2021 10:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbhFPKKC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Jun 2021 06:10:02 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:53639 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232064AbhFPKKB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 16 Jun 2021 06:10:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1623838074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B6bImO+IU9Ue2PAd9Wc1j9lUve6ypzper723/1wSdSE=;
        b=C0gR0fvnmgu+yV9nGUGgvuxJudEWx7CpE7+/bSiZTihXTwvpkJXuVBCcrR/WNHSJl4SFbs
        BwYR+xaGvO7HoBkKFkjLP7Ll0eWk2w4aUC9MQzo0ogCRd8aMviHyROJSlGkEoKDRhDuBVp
        5KSi1uSZ7NbSiiOOeP1v4Au1Y8DDrYE=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2104.outbound.protection.outlook.com [104.47.17.104])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-30-fFUa7xU2N9aofVgN9wXMZQ-1; Wed, 16 Jun 2021 12:07:53 +0200
X-MC-Unique: fFUa7xU2N9aofVgN9wXMZQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CJ8N5OAcVqhXSTmCL6T7kWF4ljbdEw0CDZ+bSGu1z5teLAhX+mofK0nZG0rV3N7khdJoEyzEUXGLKWRM15WnlAaHClQ2NJT3+RslUVYqjEAtqOQ1um0NjkFs60mLPA9B/p8SCMhOJcgz8qmH7mRbZozVhH2oMcucAkma0uXaTpUIC0rjXYYpJNkn+IuNMuifuZ71u8GARB0XEHhPr1+psnKkJ9VUxDRG+9OMQQ/iPgSOyzEuKlGvLPaGxLAxfWpIkw1XKJ/H3epZkHjnxEs2K9kG5YvZy7mtnXj5DIuLOq1WPO6EJusbGADImkBPrjcLBmt5rwMkTOMvuwEM/mTHwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6bImO+IU9Ue2PAd9Wc1j9lUve6ypzper723/1wSdSE=;
 b=NRwmVElr3ZdLjBASW4NAK4C+OiClXMaYPARZ7RxQO0TsXw1gW9AGWMF5YlzIMbyPNTEaDZhRJQ7PihJAxJ+vkNAWnP2t34BPkNHZtIOR5H+p6oJ8kD+60m+2dBbmex+BlbPRcbHXUNXTamwHJb2FFWBU6wZv9T3GV46lNtMHpvO2hZD6MMhmH800jof3Nu0q+qx8zQtt/R18E4y1svUiKUK8XclDdqr+t+FneYfvmd7CCRc23gqqeZeYgpMMxVn9w+FulgyoNrm21/C14YBHpLYMaO68cfz3ykyrkciLwJthG8QkmZEEl6P2GMDKfF6zuNqthQRCQ2T+kRGJPreJJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0401MB2576.eurprd04.prod.outlook.com (2603:10a6:800:56::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Wed, 16 Jun
 2021 10:07:51 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d%6]) with mapi id 15.20.4219.025; Wed, 16 Jun 2021
 10:07:51 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Thiago Rafael Becker <trbecker@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cifs: retry lookup and readdir when EAGAIN is returned.
In-Reply-To: <CAN05THQqBdT-uvVS+jq1Hv8MwDVCTJFHhzan8M0+4ztNbpCZ0g@mail.gmail.com>
References: <20210615164256.173715-1-trbecker@gmail.com>
 <CAN05THQqBdT-uvVS+jq1Hv8MwDVCTJFHhzan8M0+4ztNbpCZ0g@mail.gmail.com>
Date:   Wed, 16 Jun 2021 12:07:50 +0200
Message-ID: <87zgvqqg09.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:70a:9933:384a:5d3b:dc74:fc10]
X-ClientProxiedBy: ZR0P278CA0062.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::13) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70a:9933:384a:5d3b:dc74:fc10) by ZR0P278CA0062.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Wed, 16 Jun 2021 10:07:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c0d7c39-3b06-4da2-5700-08d930ae99d0
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2576:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB25764FCEE645CE6925903198A80F9@VI1PR0401MB2576.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AMdtXlRHsaaKksYzb8z/ZoAIc0nkZ8/xN1IgGZMrgOtIzP6Jt/xhF9AVYkKmufad314evZS2UzXeaxGgeafjmu2R4B4qGJYx0YmAzwNhnPHhtTmzObzm8A8jfFwuWQpFNSGaRnyoJyg+2J7yZOWmFaeH4VlBmR9TvaQu0wUHZ3Dny4teG00f1uIV93bbJA+Fj8IWlX4BIZfb1WuOYnTunBV6QJqn3caG/elvZ5Kwo2/vLl5cdXx5dDXpmS6EQpn84Tezy6rVVlFSJYUFkmvdtkLebd3Mhx0uFfpgHSr8nNjoKOipGzdBv45a58HGXHs0aRL5XL1qLSfgdEnc7TV58RY1fAwtsn9Eoh1WY7WkXa7UK5QvaGlR0fEJxQ2NhoOyy9/RbFYLW182pk3nZCLTvcVdS8gPOnrfQ+E26gFHDOzOh5aytgrxfD5R7dvruO2yKTnSsdOHdN9Zz3aopAWN4bFkcHA4TY0qDBJCug1cldKDIr21f+c0F3f+iSZC/EMQp9TqjK5zN7i/H4INITUZUOfWISulso+D/x8m7q9ueQv9N1iImWNmvjtDw49nLZvH9Vfki4zEnhvAHM1kmbYMWA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(396003)(39850400004)(136003)(4326008)(478600001)(54906003)(36756003)(6496006)(5660300002)(110136005)(66476007)(6486002)(8676002)(66946007)(66556008)(38100700002)(8936002)(83380400001)(2906002)(186003)(86362001)(316002)(4744005)(2616005)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dW5lUUJHSWpFL01vT25Ld2dnd2QvTWUzTnltN0JRc3YvL1VNOENsVUJYb3Fp?=
 =?utf-8?B?WW5oZ3c0YmV4cHV0aVVEVUZvTG8zRm5QQUZkcVl4dDJpMURmZGkxSzRwSG1k?=
 =?utf-8?B?WDB5RHE2UmlPdnVFSWs2ZkxaSHBLUkFZMStFcHlqNUJxMmp6RHcrUUZQOHUr?=
 =?utf-8?B?UHg5eUVVTWVEclFlRWhoTE1sZjFlNENvaWdZRW1ybWt4a04va1FmWi9sOHM4?=
 =?utf-8?B?UzV1RXMyNW94dmszTmV3UkpzaDMxc05NVy9TaGNCVHh1d0ovYmRZZm5qQVVk?=
 =?utf-8?B?M3REN1FXVFBOYnZTRlFiWVJuSjNNNGRqS3VScStTMWdPNXJCOXBSRFZicnNY?=
 =?utf-8?B?aGwwWEY1M1NEYjcvV0J4WTRLRWlBWjczd2pGaDRuSEZvZkZMdHBzb2FiZisy?=
 =?utf-8?B?T1k0emY4aG1CZTJKcEhhdnRQNThBa2xhUGJsMk1vYmVOTEFWanQvT2VqY2Q1?=
 =?utf-8?B?SzZ3bkQwcjRwSGRuT0NTbjhWaVppL1VKQ282cktORTJraDV0ZGNMNU1RQWxt?=
 =?utf-8?B?ZTE4S0hhcXNwaWhFRU05Z1EwdkRoc2JJSkF0WEV4eXZVWTJpaHoxdGJBZzVL?=
 =?utf-8?B?S3hGNEVnM3hHcUdGek1Ld1FEK3grMThqak95ZU1uV2M1bDdyNm1TdlEwSDEy?=
 =?utf-8?B?SnNmQm92Z0lMeld1MmFzOXFEbjAycWFPVitXdHJ3MU1SQWRQZ0ZvbE9VaU1T?=
 =?utf-8?B?OENWSHVvWldpUzM4QitRMFdEK0dkeXdxaTE3TE5iVnpjY2pmMElNZ0x2a280?=
 =?utf-8?B?cVRwOEcwcFpKMzRpTTJLRzZyTnhSbExOek93MGxxWVNDdm4rZnZRNmhJOXNx?=
 =?utf-8?B?ODdzNXNnUWdMOFRIUWlueEtmZG5uR2RYS25OeFVWKzlsR1k2WnUvTlI5V0t6?=
 =?utf-8?B?dW03OXdyamlOUjA1VEttQnVOMnd2cUNoOEpxWnRxdHdrYUh5QVhJVnQxTGUz?=
 =?utf-8?B?dXNOZlRrd21ZbUhORjVyNHBOd1VZaTVsT3UxajNuaXQvY0hObXFqMWpNc0E5?=
 =?utf-8?B?eE8zenoxOFBseUkzamk2LzV6RHExTnQ5N2txLzE1OE41M092SERrd05tQ3Y4?=
 =?utf-8?B?ODdMQ2ZySDlaYm1GS21BaGNLWnBSNjhQL1Z6RDczNDQwUVdZQzhWaGhFWUVR?=
 =?utf-8?B?Rmx1R3FFM3FkZEdIOHdCQmZORkdqNGFnQzZQbDAvd0VXRFY1elNoL3BlelBp?=
 =?utf-8?B?N2tFQTVCZmpTR0RGY3ZwTGgrTlF1eWNlUk1SWlFhZFUrc3RjMXljd3BDaTFD?=
 =?utf-8?B?VnRrSzcvcjFtdFE5RDQ4QUhlYzhXRnNKdXM1ZzNyemJ5b3VLMGlSNUpzRlpM?=
 =?utf-8?B?bXVDUndaZUFCU001cEtCekg3elgrZk95SVphMUJMeUZoZ1BJRVNSTzBWd3Ji?=
 =?utf-8?B?MmxEL01pODRGcDRzOEZLcTZMWWZFc0ltSXQxWSszRTN2NWdiSTNIdUlyOXYy?=
 =?utf-8?B?LzlYUHpIRmlKZlhJRzdDUG9sK0doOWVYRkx4SGIwQ0xRRE9BdjV2NHpjN2Uz?=
 =?utf-8?B?eWpSSVVRMnQwbkwvQlE2RzBNa1MyWFFpUDNMdlhTeWo0dTFHTkpmb1hIZ0ZX?=
 =?utf-8?B?TVFmdVhvSityb01zK28zbms4VStGa254dytGb3VFUkJGNGlFTXQ5RVZuVGYv?=
 =?utf-8?B?WXBNb3grTjFGWEl6LzVVdDFjWkNTUmlEODdwSGlpODg2cHNIWFlDNmt5L2tL?=
 =?utf-8?B?M3VrLzgwUGZrV0xPNlAxdnl3ZytwK0lIN0FPM3BQTkhqQmxrbHV3b2lMc21z?=
 =?utf-8?B?ZFJMVjljR1QvV3Z5cXFDbm5pY0o2Nml0bFpkc2tlc2FPWnljbTUwZ3pPSmhx?=
 =?utf-8?B?cXZteGplMFVvZjlVbzExQ1hyMllCM2VQN2xFSVdtM2tCMEhNVmVJWWwyMmpN?=
 =?utf-8?Q?lGa9kH4DER0BA?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c0d7c39-3b06-4da2-5700-08d930ae99d0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 10:07:51.3889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +I8fiF/P0xyfoIx/JULkv+xKVHxL7OwRKgHA3Y/pUSL0kAG/79YlBWhzLoD0cVWw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2576
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Thanks for the patch and reproducer Thiago.

ronnie sahlberg <ronniesahlberg@gmail.com> writes:
> Looks good to me.

I guess it looks ok as a quick fix for the issue at hand but:
- should we check for more error codes (use is_retryable_error()?)
- all syscalls will need something similar, the session can be closed at
  any point
  * either we add a loop everywhere
  * or we change cifs_send_receive to retry (most?) calls
  * might be worth looking at what nfs does here
- Should this be done for both soft (default) and hard mounts? I guess
  for hard we would retry indefinitely

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

