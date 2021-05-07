Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F5CC433ED
	for <linux-cifs@archiver.kernel.org>; Fri,  7 May 2021 10:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72F746144F
	for <linux-cifs@archiver.kernel.org>; Fri,  7 May 2021 10:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232831AbhEGKnu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 May 2021 06:43:50 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:52128 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232268AbhEGKnt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 May 2021 06:43:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620384168;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bvE8D7BvldSmhCt2mJ9ZKdmlr6c4im0nRXr+FEyqRSg=;
        b=llW3WlIgfS0mdctbv6ti/ye0eLMJIKAVBbqaKbQDqPsCiZMSdJ0iogJERIYH7NQ8TN8XTp
        bwDVwTDucDferommXZ7q9PWRK8/obNI7bZykqPolRxT4lSeM1kNVPqUPVaAhEdvkLenmga
        DSoNuJpeC2LhLCTsqBxKNCkXsHiqvv0=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2053.outbound.protection.outlook.com [104.47.14.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-23-TXTDUQ5aPgW6NuAHOmVZqw-1; Fri, 07 May 2021 12:42:47 +0200
X-MC-Unique: TXTDUQ5aPgW6NuAHOmVZqw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DCLcaD6HB4LLPOprXAJPJ+HSzp/RU2OUZVK9zvZhONE59aKb6NdZkuIc8f0+pWZ2ki15AJUuoK2HBMmKMaWMMpCIKzvwac7ZqTZl7K0b3fu5xH6efdLkr2Z9EAwkvYrx4BCtUdeUlgLoFqZt7anXpbky9s/oaCbzcGz7pUio0boBokd2L2tZ4lixBWugKC3bQHtUC/JaijIE6Cy+2Ki1euHyLVfLX1KF/fTm1M7JKNlHs8kJZwrLfvq+VilLsZkqfRMd3yhyRVzzZpnY0M8vfGn1EZghYHjGPXLKBjr+ep3nW+Eclu5mC2oBtRkuFzohCp7duVH8XPYL6AfMKYnsGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bvE8D7BvldSmhCt2mJ9ZKdmlr6c4im0nRXr+FEyqRSg=;
 b=GoocozWcZOaBpNdM7CbNI53UjWOTWUDQwSXpaExyC9jZga3GH/xOckkuCOBAVO0e5r9Bo52nFHTJBSFzbIbFDqcsl2VpIu4uFQqwWM5liSXL7MTrP2eNhn8m0QiNoMfIh64uIiAgmxfFU7yTyTt9x6o9/v7BKHQmZx7ntjpWToC8wSg2QQB45GgiIg+wHsdV7MEeoRzeB5LllGBWljjs5SSvtT/y8zKHGOk9fvm3y9BFHtnYIAjqJUv03i208zs/1L7Zx+PacP2KH4DPqnhDTauapTyt8bcm7t0IvldfCdQHROcrUMOAjzQKNtJYGN4J61BkIYChQrOSDPPmA7Meug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: cjr.nz; dkim=none (message not signed)
 header.d=none;cjr.nz; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB5214.eurprd04.prod.outlook.com (2603:10a6:803:62::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25; Fri, 7 May
 2021 10:42:46 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4108.028; Fri, 7 May 2021
 10:42:46 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org,
        piastryyy@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: Re: [PATCH] mount.cifs: fix crash when mount point does not exist
In-Reply-To: <20210506192513.2935-1-pc@cjr.nz>
References: <20210506192513.2935-1-pc@cjr.nz>
Date:   Fri, 07 May 2021 12:42:44 +0200
Message-ID: <87v97uu8nv.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:a615:1bdd:6a41:a7f2:21f0]
X-ClientProxiedBy: ZRAP278CA0017.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::27) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:a615:1bdd:6a41:a7f2:21f0) by ZRAP278CA0017.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Fri, 7 May 2021 10:42:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91fb65e8-3a6e-427c-0dfd-08d91144d9da
X-MS-TrafficTypeDiagnostic: VI1PR04MB5214:
X-Microsoft-Antispam-PRVS: <VI1PR04MB52143EF70CBFBE95957B214DA8579@VI1PR04MB5214.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oLrGuGAojmGUpGINv90eVC4+sXbh7qwqht49AMy3x55BNsn0plwgPYGCBqFOVGcQrq/cZ51K5joMdk6Pkt5uoRQu5rYoTP3o8p5G2n/Hvqx1b1/bzzzEuFrX9+3aRfOpriFZfIVyYGECE7ms2zQrEekS0A76EkRaUb/p4kZwZh0ezotUqX3uKOP2l4qjlFlaHYL9edQy5d+Y78IY5CroJ/QDzEGxupGA/9QAHMf+ixttIQbn0rACSdB3pLF4435OEBpnYibyw6xfqHi/w1MdiZVtEtZmYwFVJ1MeSnEMtjxpYQgKfnGLHFejJWtEYNm8XXfNMuZnBz/0y+6zgnsbVFe1e6GdfptBr7SWxShucF6SGkYhyquQQ9Lu7O2tiniJtMB/kHyWmShtF0uGOMVT6611tyrIUIPAgH72ZAdr6rTCM+zS5pgHIjWLxFZrOnQ6PkK7eBKDLYQ50WJdkcoKgOF55spZvH7ujTMNbZOJ2ChWPVCP9AeYN3y7uQubvL6YgCKXweis4UV8tGaXJycVJ6GAGf8+7oERM3YwQ5aDXIL8LRiceRliQJGEJg42l5dg6A4OSNtpdIMoeEQUqCrTSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(136003)(39860400002)(376002)(366004)(66476007)(16526019)(478600001)(38100700002)(36756003)(2616005)(66946007)(4326008)(6496006)(6486002)(8676002)(83380400001)(4744005)(66574015)(8936002)(5660300002)(186003)(66556008)(86362001)(316002)(52116002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Z1NpWWsyYnNycDZHeXpQcHpCUjN1UkJmdG83cWhKMzFxcjdETGM3K0U2WlNt?=
 =?utf-8?B?UTh2RnZjQVBSOGNoZURWYU9KSTh0My8wZDJLSFFPMTVXN1FpK1VIQXFVc2lW?=
 =?utf-8?B?UFVWenZwbnNMR1FWeGdTUGpnQjdCdWwrOEUwYmg5OVVTSnRMZ1BQZFVQNkxV?=
 =?utf-8?B?NUZ0MjdQNEdXQXQ3aTJua21HbzExZGJXclFtOHcrczVYZkpZYTRZYk9xd1U5?=
 =?utf-8?B?VkJuSitob3B1bFVodGRiaWdvcVdDb2ZwY0pqbXhORVJhTm9KdC83c0VSbkxM?=
 =?utf-8?B?WVRlbmZqMktrVGtpOEYybjFkWkloVHk5S0h4M0NMUkJQdVowUERqOXNiZndy?=
 =?utf-8?B?Y0pnYVd0YjJVYnFMcVhkMW5DdmxnekEyMTFSOVlqQlhUZ1htdzJNUVZDWFU4?=
 =?utf-8?B?RlRISWxPSEVUK0hKOEdPQkdkZFNmeGhEQ1ltK0RXOE1JdFNJTXV5cE9YK0pV?=
 =?utf-8?B?S3lxV2hRUG1TK0huM3JxVW1tdDliMGNWTVdPcnh3M1NWMHNMTmZZQWhzSVUy?=
 =?utf-8?B?Ky9xTkpsOWJid0dZdHhxbUpXTFcyM1duM3QvcUkyUXNYZWMvT21OU21JZUFo?=
 =?utf-8?B?RmV4bittNlNDOHBZWEZOMW1ITm5qODNKdUR1WnhnQ0VBS0ZZbTl5RDZtazNN?=
 =?utf-8?B?cVJqSGIwV09CVUlzcUJtaGpiWENEWHh3M1N2MU9UQU1NQzFpaEZDeVo2UEVK?=
 =?utf-8?B?M1MvUnBqYVBDMnhFUHpJUUwrVGIzVzJuVnk4SXYvcnFSeFUzZmx6K0tEcWlj?=
 =?utf-8?B?R0VCaE1NVjZiNzNuYTdPRVlFZnZNak9wRm03aWtYbzdNMHhPN3ZGeUNkZEVP?=
 =?utf-8?B?SzdCUkl6cFBFNVVOOGZBM0NVeUhjRFBLY0d6MmRWZ3BUb1ZtZ3gzVzBOdEN0?=
 =?utf-8?B?eEthbkdpQzhHUlc1ODBKRWcvVGVzUTJvNzZQZENDQ0h1b0xHWldpeGE0UE50?=
 =?utf-8?B?KzUrckRoWHk5cFZ1Y3pWTk9Ua0YwUXN2U2l1QWpkeEtVSFZ6TEpXQ0ZrT1pq?=
 =?utf-8?B?OGkweHZ3SkZGcmdxQ0MwM2txanVBMVBBNFA1V3N0WHBjNk85ZEN1T2NUajJT?=
 =?utf-8?B?T1M4RzhFUytYdDFITnRZYndPRUFqaWFyd3JnaTNIWHV5ZGZuMjZFWjZDSU1l?=
 =?utf-8?B?SExIRm5nRW4zTFV1YWdiS1haVkxQUGQ5WVk0a3pTWVlvaEk1TmxhT3NTcE9q?=
 =?utf-8?B?S3ZrOGdYUSt0ZDkrb3VadlNudmowdk5SQmdXNG5hZFZidm1LaUtlUEtIYytn?=
 =?utf-8?B?TWo2RTAxbFo5YitBbGV1eTBNM3R2UGc5M25xcncvbEFES29lTytCYUJVZkV5?=
 =?utf-8?B?eGpGOXA2M1NJWEpUY09lTFdmdTBsNzJ4NnB3KzVoaVpxUGI0b2d3R3NCRUN1?=
 =?utf-8?B?ZzFMMllyYUNXNC9ySlJtL0s3YmVlQllianMxMkNiUXZPK1hvZHJodDIvTEpM?=
 =?utf-8?B?QXpUQVB0bnd1NmlseDUwNUZuRVAxVzkzVXZ2ajRla204bW41Q0dySitjZy9m?=
 =?utf-8?B?WXFYM1pMa3BZT1pIUDZaeG9yTmZ1enF0WkRXY25wazVONlFqei83N0JiM0RZ?=
 =?utf-8?B?T0VQalcwa1UrOGRnWXQrZldrQVFSTUtHcmthV0dVNDlJOW5wSlFhL1VjSnRG?=
 =?utf-8?B?YWdHVHd0Q1JXb09pbEtRVnlJSW9JaE10ejhVQ1JWdlhJMWkxNjJxNFhpZ0U3?=
 =?utf-8?B?UVNKUmpKMzEwdE91T2RET21oUy9rRUYvendjdG5VRFpuUDJ2eWNiMmFLc2JF?=
 =?utf-8?B?OG1qcmpRVmNFS013Yk5wcWpkNzRYanRQZXV1aEk5V2RheUMxY2ZFNVY2UHJW?=
 =?utf-8?B?bVBOOWZzTGw2ZmU5MnJoaW1DYVhUeEdKSTROTVNRSDhhakRkeUxnWk5wRGNC?=
 =?utf-8?Q?EA3kqQwDHE2n0?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91fb65e8-3a6e-427c-0dfd-08d91144d9da
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2021 10:42:46.1189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uhC/qr4ctDXaRNarmyMqK1Vb9sRbjl0CyWCiMV+4PN914RA6unyoGMRMxJ/YgHm+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5214
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Paulo Alcantara <pc@cjr.nz> writes:
> @mountpointp is initially set to a statically allocated string in
> main(), and if we fail to update it in acquire_mountpoint(), make sure
> to set it to NULL and avoid freeing it at mount_exit.
>
> This fixes the following crash
>
> 	$ mount.cifs //srv/share /mnt/foo/bar -o ...
> 	Couldn't chdir to /mnt/foo/bar: No such file or directory
> 	munmap_chunk(): invalid pointer
> 	Aborted

LGTM

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

