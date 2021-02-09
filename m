Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFDCC433DB
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 11:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E695164E7C
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 11:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhBILZ2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Feb 2021 06:25:28 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:53989 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229564AbhBILX7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Feb 2021 06:23:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1612869765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nxvuk9F2Qt086e0wG/WHA4zizODni/CFnyt8qQCvT+U=;
        b=dUNApD63xroWcbYvFW+pU1xNHfaD9gk9cvI9spvl/0WJ6mo3MbnJgZgxQmhaEJolpaM6D5
        r8gOIZFfp3Rm3MfTu+HPKUZV7jOwQC4QwwtCW+M4hOKa2H0ROk/SAV36TlgTpqXfLli8/a
        ZTXW6x0c1jWDvQdv6xS/scfJj1AHtjk=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2056.outbound.protection.outlook.com [104.47.2.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-32-6ySdvZB_OraXWa7H8-qysw-1; Tue, 09 Feb 2021 12:22:43 +0100
X-MC-Unique: 6ySdvZB_OraXWa7H8-qysw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aOXA1T+U/XzfB7IY1MWrZKJwqxWSJpAGRHMfl0wbN05gfTD4hCj60RFz/5W1OAvCpByMCAgxUW8b6VwYhK0af5+IufT/Gyvuvt42Y479Kvqv2kh+hkr3KzLziwGQE9H9LFCdIqYPYvNkfg+oThWatZ7bclnu+Xlr+MF42K6BZ5YfwER7/r23BWc+zcC52Iws4UV9xzy2rMLNrW5eDCFvcK3xTTf3sP59UITtoh0ulRF8uYI4t1JKu6Owt5klf7AkIObiDa/3e/ssT253MlKhDX1TySLcIt/MoMvyTPZRnVlvIed3Uku/sGz/HskAJOobQ0RUWybJRqnXqhq5eGH82A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nxvuk9F2Qt086e0wG/WHA4zizODni/CFnyt8qQCvT+U=;
 b=hFQ+xUw4eFeA/jXB+pYiFuQVKxh6xEXNM8ozw+rmRzXvDuG5mXYZqhTWWeHtxAlk1ArQJFfUdTHhNupUSqvo40R4MDQV0px/4qsUZMl8Sn/K4cbCUfc9T0WLjgb/KV7ROFMLNpXJs5caxVb7sYmFDMLa7jR7vXvwJGwY7c1N+3cMyilUmr80S42zqA2Cl7EuxGdlmw8d7PFhE+E3yEM4eBTv1z/Bj+9aUWqBO6q2qWE3CCYsYZuJLmwGjFlbLYAQdhzxn7eNSSKIqs0wdfOJkk+/GGUBrZDfY4JlqKhwdjHOznN3QBWL+DM1Ps4sKrEfYrplG66MQfdpRH6iUgD7VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB6925.eurprd04.prod.outlook.com (2603:10a6:803:135::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19; Tue, 9 Feb
 2021 11:22:42 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3805.022; Tue, 9 Feb 2021
 11:22:41 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH 1/4] cifs: New optype for session operations.
In-Reply-To: <CANT5p=qeEBwivE_Fc-Y4gj17d9nkU+ROPnZL=0BD3v_yRNBFtA@mail.gmail.com>
References: <CANT5p=qrx1bKAcJGG=hGBkvwHjQWLgTH3kJ+g-YdZL0yfBtA9A@mail.gmail.com>
 <87mtwkno7q.fsf@suse.com>
 <CANT5p=qeEBwivE_Fc-Y4gj17d9nkU+ROPnZL=0BD3v_yRNBFtA@mail.gmail.com>
Date:   Tue, 09 Feb 2021 12:22:39 +0100
Message-ID: <87blctmqo0.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:9b01:1224:ea0b:107b:c49c]
X-ClientProxiedBy: GVAP278CA0005.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:20::15) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:9b01:1224:ea0b:107b:c49c) by GVAP278CA0005.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:20::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Tue, 9 Feb 2021 11:22:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b0d15b7-403e-41c6-8595-08d8cced03d3
X-MS-TrafficTypeDiagnostic: VI1PR04MB6925:
X-Microsoft-Antispam-PRVS: <VI1PR04MB6925BD253554CBA7A3235E7EA88E9@VI1PR04MB6925.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GHbwZqqM24O8ttrL2gWjZrZlFjn33MMaNdMZKJwp7rJz1Wv8DbliJ03F7AIABoSudqTSHJwDuOowSGau1kpC3HO0r275ND44/cSRWbuSnD1lSqJki6P3HTcuwT2CF/qdFZBzlWtZvljUD9pFhJWhEeoJLgybNhYHkBuI79t1z7FISeuv3CB6qbIzEmWCAvi6JhSjRdyMcY1d/my9EjJathcqGtPepygCNnc9/pU8IoUz3nqwjsDllR+J+yJHN++bqteQZS5lZqnVIVFUR5SQ146nQ1079MzAQ8rDBHixE4Sg9FBtIMSAgo/VKh6v1SB4/SdSF6ctdPF7qhlegHNkzHkK5bX+gGKJu2HlHygkHwtCJSnqYksJzYzgauVjeMLz0Tr8eAIaQFExWj3wUjhaYDLEoc8sANsSTA6NUCedNczXoDvRlWuTLxw0/cWX94xYdeIxbLEJ3/i6YZ87YMgHcCHI0MPV9LF89ie/FlJ0Hy72AJNTB4EnlWrRkFvjEfpLGUvWJW7id3qbuoRpxFawfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(346002)(376002)(136003)(396003)(2906002)(36756003)(478600001)(86362001)(8936002)(16526019)(316002)(54906003)(186003)(5660300002)(66476007)(83380400001)(66556008)(6496006)(66946007)(4326008)(6486002)(6916009)(8676002)(52116002)(4744005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MitwWUdLb1V6aHMwZEVaaC9CcFJ6YmpFSWYyVytmZDFJN05uNnJWVnkyL25k?=
 =?utf-8?B?VmQ4cTdpL1JSdnBaU3FuU2o0MEZrbHBORFFzWDdidEpFVmlZY1JtNktGRFRi?=
 =?utf-8?B?UkU5WU5aSmlYaVZpUUgrYXQ4b1NVVDY3MVUvdnk2RjY3Tm5pUUh4ZnlvMEZV?=
 =?utf-8?B?eFg2bVprOTA1dGpac0RVNzZDZUlkWWhhMnV0dTBLZkhZbGdJNi8xVnliWHFz?=
 =?utf-8?B?NncrKytURW50VHpUY3V1ZC9lcFhFKzhFY0l4Vk5CeGJIcmhhQXIrUW1sRk9k?=
 =?utf-8?B?Y2JUb05mdjZDb3d3OHdxa1R6RCs0S1ZqcmJoTmY2MjYyTThvRDNlb0lOR1J0?=
 =?utf-8?B?L1RCKzdEZ2xPd3ZhTTVmT21WNjVOdklPS3V2VFpyNmZ3WlZhM3ZhVDM2R0U3?=
 =?utf-8?B?L0k2dWVOT1NDRXhYc1VvSHpBQWlBa2hHcSs0MEYrVWhpUG1xSkMvR2kxVkhH?=
 =?utf-8?B?WFJhaTZMV0pMZWpKa0I0dzBhc0VvT25KMEFhYm5kWVlhcTBhVHBncVFQSHA5?=
 =?utf-8?B?RVovTk9vK0xWbnNNRlBnd080dzNrbzRybkVjU2dBQWpJNTBOa05oNUl5Vlh5?=
 =?utf-8?B?NFVuaVlRRDFISWlMRzRZWVhqcm5FMjhGNFQ4THJDYzFObkRzdXhxeE1JczIw?=
 =?utf-8?B?cysyY2M1NE5MSWMrZVVqT2VyT2hMbmJ2djhHRDQwelVRUGUvdVNXODB6RFJZ?=
 =?utf-8?B?OFlFMHErSHdpQzdtci9IWTdTcjMyWG45aEdnSEg4QXl4LzNialhhTEtWbC9L?=
 =?utf-8?B?a081QUVDclpYUUhYMUFSUWRGM3hSYzdjNUNDSk1hRXBjd09LS0NZME5sdWla?=
 =?utf-8?B?b2xjaE5KdndaME0xNkJOWmtYdDhqU091UWhia05PRXcrdm1pRDdtWlZ2Z0N0?=
 =?utf-8?B?aWxJajkrdEU5MXFCUjNreEZYYnBDUWZQTXdYL0paOXR5K3cva2ZEeHk5NzlD?=
 =?utf-8?B?QnhCWFprQ2lJd2lvNC9rdkxFc3EydWNnV0w4WWducXNiWUEzYWlvT3BTMFk2?=
 =?utf-8?B?OXpCS1VDb2c0dzZEWlRmZGMyYmZVSjV2ak9odjVSNnUyS0t6NHM3VDBuZzdC?=
 =?utf-8?B?UWUyZ3NyWWNiVjVOREpBLzdoUjl5cndPQTZqZ3pZSlNDV3gweEE2SXdFSDFt?=
 =?utf-8?B?ZlpOOTdveEk3RTcyNVhsMjRXWlFITGF4V1pFSkQyUHFlUXZsME9nanA4aDl6?=
 =?utf-8?B?SVZrUzRFa0tiamZZZGVKN0JMeCs1dUY1aE9ocXVpSVl3ZlFPZnVrbHZxWFVL?=
 =?utf-8?B?TFBmbityL2NPYVMxb0Q0Ynk3MGJ2VnN0L3l1ajdCeEJEWW04UmpCR1NqbXZm?=
 =?utf-8?B?R0xHSm9vQVpuck41ZDFEN0Q0SjlWQkdKWkk3K21JcTY2dCsvMUNqV3UxT0lv?=
 =?utf-8?B?MEtReWUzaXRjZlNHOWQwTDZabkQyc1Vva0RKdDA5OGkxTDhvYjJ4SW1kcCtR?=
 =?utf-8?B?aWRZdktQMFM3RU1RSDdOckJoNi9zRnF6R215U21SOWg1QWpDdDBuNnBMbTJn?=
 =?utf-8?B?ZUNHUkJYNm5DVGNQdGoyUE1TMU5jY0owQndwc2pJaHZCMnIvSXhhL29yc2tY?=
 =?utf-8?B?T2UzMDNXWmJ2YnppWWhybEc0SW9KbFJ6cTRoK29lMFZlNjhaUnRwb2NHc3Ir?=
 =?utf-8?B?Y05CRUl4eXBkcUVqYmVpbStUV3laR05nczdJd3RCT21FSTFFN3NIR2R0K2c0?=
 =?utf-8?B?eHl3cE5MeHNxa0ptR0RiRUlaY1Nab2JYd0w0Mm1xSUd1bG44UWF3cXRPb3po?=
 =?utf-8?B?YlJVcnBrUndjNEhiOUtDNDhSOGRHRmpyWWE5ejVEN1VkdEx1dDBJVGFvTHp0?=
 =?utf-8?B?aHRmN1gveHc2K0F1WlRoYTA1OUxzSk85eS9waldPMFkwWXN5UXdxL1NRVlJz?=
 =?utf-8?Q?oKgtSLHXx/lQ9?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b0d15b7-403e-41c6-8595-08d8cced03d3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 11:22:41.7793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bmD/1aDJjXJO7qpEJcF9ZRyRg+0XqW29ZO50JcjFI4aqBjZ1MeZfiw/Lw74XdkDF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6925
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:

> I had missed one check where CIFS_SESS_OP also had to be checked. Not
> doing so would disable echoes and oplocks.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

