Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746C6C433ED
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Apr 2021 08:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48E95610E8
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Apr 2021 08:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbhDHImJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 8 Apr 2021 04:42:09 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:22060 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229539AbhDHImI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 8 Apr 2021 04:42:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617871316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T2/5Fu65EVf59D26J2e8IErt1pyg+zYW7lt9XIn+mJA=;
        b=Wyvrt98O5fyPyyO+ZOhrEKuo5Nkad6zJvuCsjKm9LuuVaoYSLid9e5A/IQQ6k4Twf+3kTq
        HF1tHF1cG1SxOZQTe6Wr+qrYM6sPbCT8Y+Q2wuq3XIbBYb3LgZyQzT+64jZA4/taG0EmMP
        C+LbmKgdUOVpdIbmeZ5h84rRCSQhpqs=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2051.outbound.protection.outlook.com [104.47.12.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-34-DWuDeIy4NEWLY3QrR5dQog-1; Thu, 08 Apr 2021 10:41:50 +0200
X-MC-Unique: DWuDeIy4NEWLY3QrR5dQog-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fAnTXhT7TcFENop1YzemA7HlZGKxaMngwD7eojcql7ion7sJS3oV1sR2SoVk1WBDy7QMRUeUHQPHC7ta9mjv8JLyLYHbuqsJKJXUBWt2QH+yQBuEVrpJpY34Axdny/tLlQcQTisWPuHINK9N6iEgZLzG6AQ8Z4h+HCSGL7eqtFcZVW+wZfTIsL79VzlfctR0mgG3X3b/QrGxyeFwCmTX9BiNQ09zzzABVvhK0166bxPltabb4clCURAyTl3zystw6haYSmdE22wTgaXX67cQD3t2+z/rdobNOzOvFXBvATyRILC40PSeqPK0AlIylV1WGxlmnF07VgYavhCIkV+FFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2/5Fu65EVf59D26J2e8IErt1pyg+zYW7lt9XIn+mJA=;
 b=I+RocVOeWCQ/UJAYsVyBADeo8FiQ4B6V5e21RqHde+HCkg75bP5f4LNZpi+OeuMB9KC7wUznftqtTsCDGGiV60rBEhNmx5cR9S2dGSZnjLtSWZMBO0J77TRh0f/iC8zAwL/Efq76y9cK6wYOHR8Y2r8hQxQ/1FUKfZ9QosFMwDNseueVVyIpmK79htSvNNqMMB7eduKqg//XMUX/Ut3iEa+g2jOvkXLs/C9Z4TG3MX7z59ufNclHuLSLBrvvXfljGme1u4VkzRbHVZqQD7A0423zaPp5+Uk1h5uPiFaA+ryqY/yUQlClw92TfCfB/NNlBTxFhd3hJciRyzMbX8rCKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB4526.eurprd04.prod.outlook.com (2603:10a6:803:6e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Thu, 8 Apr
 2021 08:41:49 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.3999.032; Thu, 8 Apr 2021
 08:41:49 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: On cifs_reconnect, resolve the hostname again.
In-Reply-To: <CANT5p=rq+jXGyZG-23dpOVOomObXmXEdr9FsO-=-vX9tH+kkCA@mail.gmail.com>
References: <CANT5p=qWyYCD_gSw-AzvxOgzTzWkBK1uUz-16YougX5No8jjgQ@mail.gmail.com>
 <87im50vi9v.fsf@cjr.nz>
 <CANT5p=pHPPwf8H1ZbBT+yr4CP17+BB2evDBxPVjYrvr+kdF1FQ@mail.gmail.com>
 <CAKywueSCF-ZgmJZif=kkspk_b8Xp3ARUGHD64nnc5ZbVk3EcxA@mail.gmail.com>
 <CAH2r5mv1=tpjPOZhq97t+X99dfSDtzWepp5bpqPqjf9Z1t6+sg@mail.gmail.com>
 <CANT5p=rq+jXGyZG-23dpOVOomObXmXEdr9FsO-=-vX9tH+kkCA@mail.gmail.com>
Date:   Thu, 08 Apr 2021 10:41:46 +0200
Message-ID: <878s5t4185.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:3083:db61:a56:41ea:f10a]
X-ClientProxiedBy: ZR0P278CA0129.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::8) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:3083:db61:a56:41ea:f10a) by ZR0P278CA0129.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Thu, 8 Apr 2021 08:41:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62ba6e4c-88e2-4e86-48b6-08d8fa6a266e
X-MS-TrafficTypeDiagnostic: VI1PR04MB4526:
X-Microsoft-Antispam-PRVS: <VI1PR04MB45267BD5549BA1F881000FF1A8749@VI1PR04MB4526.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WOV+YqwWHac3oSb+fiev4hpatgM2yJuDWVGbQo/29ATtJg+4e7/S1ig8VaSbVaIU8oPhX3+TJ0/JGclmnf3GXVegQCNt5G4IEow3qSq87BjWMOrvAWPctOAv2iBJ0nP8snfOQ0U0aSh/MHZw3eV0vFL60MQNBdLfQsAOpMRbh+Ofa5aOfZom8MgiHlPF1hxEYyAZ1xbI6Igy8x5m+qHtsEOLpgxtZekGRAUfcXpGgN4opgcSCossY+z2jzaZn2D39WMd7T+lLlZBlkbbjZGK0ZhP/gaks3RRbvI28ngBFviQS52dQgmAa7bVcTIfir+58XbcTgEfYAH6lO3jU0pLsKRwFLokh1AWYmPhO1y7WvoMHBONeTBX4N046pdfxchS3bJUxRXJuv47UteEQ2YO3XUjfpdyFVtzZ2rO6oGvH1mzON5P04iVNgIW+mhbl/OYMJZJks/tfNmsU6C/ypNq6v4OHDSQPXQ2WLWEjFNbyO6N4QWFn4c0QiQkefdYBXXZ+znN5qYhD2gkfUgikd1zdjR8osSdXBa+6edTZ59Tjompq8kz3k/q1EMxBLh6PJixFavfdgWRd1gilwjAwCiXq6lrD9w6nLaYTQEKKMPviFQxxEAXo0NwxsjxK4wJLKwwhu7T9mcMXwJqd+lcE+x1rQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(376002)(366004)(136003)(316002)(2906002)(36756003)(16526019)(54906003)(186003)(8936002)(83380400001)(4326008)(52116002)(6496006)(8676002)(110136005)(86362001)(66574015)(2616005)(38100700001)(478600001)(6666004)(5660300002)(4744005)(66946007)(6486002)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?LzlWcXUvNlJNWWl3N0VWbndteXVWQkxaOWUvcmhmODlObjFoMUcveHdubzVX?=
 =?utf-8?B?V0V5bCtCTEcxeHovR0pvcTkvWWQ5R2hIVmpZOVh3S1B2MXRhVUFmSldYOWVW?=
 =?utf-8?B?Z2V5SDV3TjZDQmlCd1pDdEVwVUtNS2UxTG5lZVZTZnMvN28wMktLY3JGU3RS?=
 =?utf-8?B?bml3Q1E4d1cveTBBR05HenJidHNMMXhva0cvNVVqSzc1YloySEZ6bTYrRTh4?=
 =?utf-8?B?eWFoOGl0ekVNayt6QkZTMXZwNFdqajlJditBWW96a3NraFRsSFMrRW9wTnZI?=
 =?utf-8?B?cUVmMjMwNEpaOG1mbTlZZW9pQkVueDBhM3F1V3ZNUHp5MlRLdzVGT1ZnMjE3?=
 =?utf-8?B?UnRxZWVreTVtekwzNC9nOEh6SnY1VzB4OG5KNERsdHpNV1VkYUN2ZlRmaHBm?=
 =?utf-8?B?MjF0ZGtIaVZWVkRIbm83ajV2eS9wejl3ek1WbnBnczBiSEFwMnpWbmljSDZu?=
 =?utf-8?B?ZnpsYUxvSHlYL3dDV3ExZUh2am9ON2xsU0o4WllaaGt6dVVaTEMxV3BseGJZ?=
 =?utf-8?B?Rnh5dkFIS0lpVzlTVmNtVVlmUGdNSEpGQ09adGQxVlEwRlZhc2VNaHlLOUtW?=
 =?utf-8?B?cG5DS1M4cXRPUm0yOGRYNTlLajdCdkp1VTR2MmRObkhWNGZCdUk2N3NpdlBH?=
 =?utf-8?B?S2JOZHZwWHhpQUVaS2d1OHZGS1dBYkx3QS84Vi83b1B2MlNmMURWYWdZT2py?=
 =?utf-8?B?cHBSWlN5bUpuclF1R3loVmsyMy9sN2J6Ykk5QUcrMWtmaFhSZm1adE9hV1g0?=
 =?utf-8?B?K21pQ05ENVkyRFp6NFdNSEk5U3lMYVNvUEdkUThVTlBENldETTFLVHEzdjZs?=
 =?utf-8?B?UFBEME00Nk44aVFYZTYyWFNHQzhsU3BCd0szdFdyR3hadGppU3dNWi9XV3ph?=
 =?utf-8?B?dFQyRVpHQkZKUTY3SXcwQUNWdjZ2OThTQnhNNitIZ1JjKzNLZUt0c2ttUUM4?=
 =?utf-8?B?UkNsdVAzdG5JK0U1V0U3V003MHA0d05ZaGtkUjFKVStRcjluN2FkT0IvVkxY?=
 =?utf-8?B?aUwrREtieUxiQVFJaHpZZkowRlV4ajh1bzNrcFJGUkRJbHZqZ01kUGF1aU9u?=
 =?utf-8?B?ZjhBRThEa29IYzVvNC9DTmpoRVpsQ3FNWTluUkx3NjhEOEFjL2pTWjVwdnpo?=
 =?utf-8?B?ZXBrYlhsYUxrZTBmZFFvZnB6dGVrSEVYYnVlSU0wRDZ6UTB4Vm8rZkFHL1Bt?=
 =?utf-8?B?Umd1Zi9nakxhZjFpOHFMNHVsblJkUStYbWdLWm1waC9oQ0hCSFNlbWZyMitB?=
 =?utf-8?B?clNQNFFBVzUxTVEwSE9xc3VwRWcyNGxPSXBrNHNET0tQcDUxMDU3MkFJSHl5?=
 =?utf-8?B?M1lUdTh1L3FiZ3RIMmxFSWpTdDNjVGZJSHNWN3BhTVdpRS8wK3RWU3hQNCtR?=
 =?utf-8?B?L1B5Z1pJaVlJbGhicmtEdFFtUi9MNGJRVzYxS1JkVUNaSlVlK0hpNFBsZzJD?=
 =?utf-8?B?R2s4Y2xuN3F1bGVKelRPN215ZWtUT3BVMGNHeXAwbkNtOWRVTnNWSTIvSGRn?=
 =?utf-8?B?dURmUEZVWEJCWVJiVmMvRWNmc1V1aGhHYkxxZWVBZGJPTjNFOExDcnhyeThh?=
 =?utf-8?B?cTdnMjdFYVI2TlVFNHo3Rnlvdnp2WnhSemxSeG5qalEwRFRxSFFXWkpIV3ZL?=
 =?utf-8?B?eEFvQ3NMSGtkVWNpc3JxRzBxY2xLbjFud0hNeGcxa2ZvL004NXFXQ3Y1b2J1?=
 =?utf-8?B?WnBoZGcyWkpHbS83eE1sS29oNUNGZzBzSUQrMmw4UHlPSzA0SjJaL3VLenFP?=
 =?utf-8?B?d0RCNmk5YnZTR0s1aTJKQkQ1K1N3OTFQNVlWako1Y1Q4bmtKSUZiNzF3NjFC?=
 =?utf-8?B?UG54OTVNUldXZzVGd284UndhYTJJS283OCtmQjNkQ2Q1d3RQR1pPdXdYUFpG?=
 =?utf-8?Q?6mP5d49t5csEx?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ba6e4c-88e2-4e86-48b6-08d8fa6a266e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 08:41:49.2323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9OTLaHkqWsY6g5Q/CPpId8Mt3qut9XE9YC3d2Z56d7wuYFtNJlq+Ektx8oYiWhpc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4526
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:
> The intel bot identified an issue with the earlier version of the fix,
> when not compiled with DFS.
> Here's an updated version with that fix too.

Ah I guess that's why resolving wasn't done on reconnect outside of DFS:
it requires the DNS resolver which requires upcalling i.e. having
keys-utils, request-conf.conf and dns_resolver key installed and
properly configured on the system to be able to reconnect.

Maybe we should fallback to retrying the same ip if resolving isn't
available.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

