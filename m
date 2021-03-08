Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5075AC433E0
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 15:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CECB651D1
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 15:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbhCHPNC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:13:02 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:29095 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231219AbhCHPMo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 10:12:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1615216363;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oYMchobsyO1/l5ZFtFet20yHjD5yny2xSfdM7kiI4OU=;
        b=FGd0nnU1JD5k3kQZw8fIsuU5S6raziVKeVzjnOC3/4AfmzAapmlp4a6l1vaWW9FCAUqYqC
        8zIqyFfCyrp04AzwxXIjvjoKk5rQqDnIrQfpCNCQtYqmljxnWwcG9R9nh6Aae7O3khZhx3
        4ZHsxx4MPUCOmFL1awGi5qvX5U5GGq8=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2174.outbound.protection.outlook.com [104.47.17.174])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-12-zaXjh4lBOaGwy3kD8nhREQ-1; Mon, 08 Mar 2021 16:12:42 +0100
X-MC-Unique: zaXjh4lBOaGwy3kD8nhREQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFzVx8cYjzHVgYAfQrc5Uv2Rkvvp1l7pkWqYqGj87S7hFHMXn7XFu5fSRivPIhDat0a5G+YTqvUqkhLAkIx3XOgk9nild7xYPt18S97gKR7N4oV3jCOgFYoTc/7xJD7O3n9ZPrrzfnBgkPvyWpQ0POg+VKHJU9khiUSPIW9zOb4ZccQVPODm7OX13MHktoFaFvSi1C2rgM01I9USErtFjh9HHHnFhZrxXfCbx4BNAcBnOc2fnYPM46LXNUTMmLa8TKGGTl+OD54Ts3u2M5yMstdHLQyoPZ3L+E41Ud8me7PgZRwQ05qMiIIBsea3RFq/yH7NVWuOimgJqrhnInKdMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oYMchobsyO1/l5ZFtFet20yHjD5yny2xSfdM7kiI4OU=;
 b=XRHkhyvhY5wWaoh2qhjlzJpbvIWLrR31zv2EDMXahI9USDMECiRkTGP+PlTg1Mg8ks0wfLgKo2Xwa/o4i7cNtu68jGqPKhs2WkxytDmRAOuFKGEJ1Wph26TvGRQ0hFDGmAyIAXqQqT2sNQTgPQYHXEe86TZOBsqPjYM33OAvmoRMn+ERwW3g/eVn/k1cA107N9JJ/Ipe1A+RGcsmRo/YFERKzRVnN2GbU4XXIC/7Tvm0u6TWxh4XcocCchIz3b3Wn/mzSquP6SNUWtl+SG+KLoNAbt2FIxRtVVPF5XJQ1LzqLlSxA9lpVtg4MTL+HT7Qnw2cbH7iiu4C6O5vKe29hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: cjr.nz; dkim=none (message not signed)
 header.d=none;cjr.nz; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB5391.eurprd04.prod.outlook.com (2603:10a6:803:d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Mon, 8 Mar
 2021 15:12:40 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3890.037; Mon, 8 Mar 2021
 15:12:40 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: Re: [PATCH 2/4] cifs: change noisy error message to FYI
In-Reply-To: <20210308150050.19902-2-pc@cjr.nz>
References: <20210308150050.19902-1-pc@cjr.nz>
 <20210308150050.19902-2-pc@cjr.nz>
Date:   Mon, 08 Mar 2021 16:12:39 +0100
Message-ID: <87sg55vfvc.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:70b:4a04:48fe:21ee:1b19:31ad]
X-ClientProxiedBy: ZR0P278CA0080.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:22::13) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70b:4a04:48fe:21ee:1b19:31ad) by ZR0P278CA0080.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:22::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 15:12:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a1677ae-7860-49e1-07f2-08d8e2449dda
X-MS-TrafficTypeDiagnostic: VI1PR04MB5391:
X-Microsoft-Antispam-PRVS: <VI1PR04MB539181E1A53223B79201AEA1A8939@VI1PR04MB5391.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O0TNURrc8l3zLrFOfW5pPsHvKd22yzHpgPJqZUHQm3sDZZSBeqr2x7NbjkZEGfkhYHLYopZ1SpDdpJa4YYqtZ6ydebJbWxsqEc4QSDSVzSTw+rILP8VktrKzM3TwNkNtBYn/fXUL1COMUqOOPEoTCc7qtss3xJFw5zNHn982dWjrNd9N2GnefAVdeunLnkh5LvdzoQiNR/YLsUWtZlGqMM7J7OeomthP/a/AmgXHontRH1yLC+k9WV4oXkiJHDAXA4N4ZB4NHQcFzWp0quN919LPcLgt5wHzsDMlnxJ//GxYfvDumo5AxlUrlXqfUIJIKBrzXOL85Pc2IZ5zHCX/GE7+oLyFfk3fqn0p6nwU+xz/1PnZhD+Ju+n4hxCYgPqLomxVpqzSeslqrYIW3nnTYf5v9QQfkx0On8oFxcNEkKVOEECrtQfM5DPkw5TGj3jCpop97Mf4Je1TGC7jBRtPBg/6pllwXoQsc7XoPjjMaaFnwkmWtSzPVqCEh/I5+eF/9g82YpkWy8jjuxP4Be80yg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(346002)(376002)(396003)(136003)(16526019)(316002)(66946007)(86362001)(66556008)(66476007)(4326008)(186003)(2906002)(36756003)(558084003)(478600001)(8936002)(2616005)(6486002)(8676002)(6496006)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?N1liR0EwdTRNZmFpVk04QUd6NWtISHlZcDBWWCtrdEJ6bUp6L0RQY0RBSDg4?=
 =?utf-8?B?K3crYVBWSXdMOEtMSzcxUE41S1RubWM0TnlDd2xNVmxCNUUwRWpvNmI0czZP?=
 =?utf-8?B?NWgxcW9QditKSlMwSzNwUk9wck5ER2hIaUJsUU96eHN2VnVPY1h3UVFqY0Jx?=
 =?utf-8?B?by9MNzFPdFlxR2VrZjJjV1M4M3ZHVWpkUGFRaVhQVlNCNkpoSm12NXF2VS9q?=
 =?utf-8?B?cnFCR1ZuWk1GU1ExK3BwVlZ0NHJpbzlQblNCNWRZS204TFZjeWpaNlVPSWFK?=
 =?utf-8?B?Q1kzMUVydHN1UHpIakZ4K0l5Mk91TWQxWGJ3RVJVQjRQZlFSWnVHSStPZE5q?=
 =?utf-8?B?TFowSm5DUkg0UEpiUTlSOUkzNFpKZVdPUDk0RS84VEZ1bnVYdDdrS1pjSkN3?=
 =?utf-8?B?TmkxbldteDZ4VVdXenU5dGhOYTlLRjlnNmNhRUJ3b2k3R0ptY1lqZCs5SkxO?=
 =?utf-8?B?NGdjNFNHRldCMHRPMmROVGt2MnBxSjZya1pLYUxGUFQyYVhPdEhFZWJKOFFh?=
 =?utf-8?B?M0hKNHp3UkY3dC8xNmdxN25DQTRvTDEwN1dLVnJSRnpTV1EwdzhPRitBclpG?=
 =?utf-8?B?UlFGaFJaZERIVzBhTjE3cE1lQjhxUnFSWjBkN01QRHR2RjZyMmlkeWliRERq?=
 =?utf-8?B?MHl4UlViQjdnTk9OdmhCc0lpY1lFL3lYekhNNmZkS2YyeEpPNmdxZmREeDJu?=
 =?utf-8?B?Qzc0bVpnczhaVHV1bklEZERNNG0rc01UNzBub2h1MEMvQ1RiQjFlK1NGeXI3?=
 =?utf-8?B?Z2JGL2NRTGpqSUQ5VStWOVd0czVqSWozbVd5ZTM3NkV3dmsrK3R4K0gvM0o1?=
 =?utf-8?B?MjlpOS9FcGo4bm9zNDJ4MnE1L2dUYTdpdzZsOENWTU5nUFp1VlR1OGVVbGY0?=
 =?utf-8?B?Y2U5NkMwcWdTcytVWkVnaUtzTDY4REgyTHl6MW5QOFRHNG1XajlWUVpxS0Zs?=
 =?utf-8?B?cmRyYmV1VENnYkxqS2dPaGJMQUhVK1RiM2ZNUE9XZnUzUVZBQXNCUSswMTlW?=
 =?utf-8?B?M05uUngyL253aHd2MVIwM3BhUmNxa2xNL2d4VVFRMzkwUmtUa0ZqTjVKMW1i?=
 =?utf-8?B?Mk9xZSswSldBRlRlVGErMEhldVZERnAzdnhJOTB0SjFZZkRVMVVRdGgvRzVk?=
 =?utf-8?B?N1BMcUVMZU9NYVMxeG1xMnBFQXhmd2F3Qk9UTGt6T2RYWm45RTkvaHU1a0JP?=
 =?utf-8?B?ZGdtUzRQa0JkclFoMzF0cDNHd1FIbTU2RWlsd3M3ZFNnd0p6R0MrSWJrTGgr?=
 =?utf-8?B?T0o4ZU1TWGpaclpKU2RNZk51aHQ3RmtodHJoYmZBSytWTGxXTVlXNE5ydVM4?=
 =?utf-8?B?MlFuTWloM3J3dUw5UFBUVzBydXFCUnB0K0d6eFF0S1VUT1JMQTl2NitKZVI1?=
 =?utf-8?B?TEtGcU5hKzZnbElYSFVxZGQzZThlbUR4disrMmxXWU9LTWROckwwNmR3UHky?=
 =?utf-8?B?ZjFPQy80cVpPbWZkK0RPbENoZGRZdTdJYkl6ekJSaWVheEJ3VitZQXVoK0ln?=
 =?utf-8?B?M0laZEc5bmFYcmNwMktkMkxDMFdnSTh1VHZCNyt4S1JQd1pwcSs1Znk4bGJp?=
 =?utf-8?B?YWJmcmJrWlhZK2xlcDdNN1Yrd3dxSDl0M3NhY28rTFpiTDJXc2RwWGoyNHA1?=
 =?utf-8?B?VS9TUWUwTjByZGQ0STdUMVphdklNRVBQVVBFd1RPdWZsd2F0R2FhQUJjd21w?=
 =?utf-8?B?T1FSVzlnNER6eDVzc3dvd1pmKzZTNDNRTVEvZEZqRXFqYVNsei9tcGxUVVN6?=
 =?utf-8?B?MVlCQW1SWUtWN3dkdlVKSlloRUM5ZFFDK2NabmtLK2taOHdSM1VmYkcvVWRt?=
 =?utf-8?B?WlQ1anY2MkRlRFZUVTJka0szSFhiUDkvZEk2ZUNnZ2ppR3FvNTd2QjJSYTBL?=
 =?utf-8?Q?HRswxejakAu/z?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a1677ae-7860-49e1-07f2-08d8e2449dda
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 15:12:40.7839
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 10L7faREk0ZB8AjLk97bTwKem3MD87tHSKdFYxNZCM1xekflxnurJ0bGjLgrenlI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5391
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Reviewed-by: Aurelien Aptel <aaptel@suse.com>

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

