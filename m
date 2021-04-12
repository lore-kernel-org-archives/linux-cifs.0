Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D2FC433B4
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Apr 2021 16:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 561356121F
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Apr 2021 16:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238197AbhDLQQi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Apr 2021 12:16:38 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:56082 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237798AbhDLQQh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 12 Apr 2021 12:16:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1618244178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QpMs7PEIynVqJprICVSsS77n4nge+WVu1wgJW/KXYdU=;
        b=FSAEOHjQujvG6ubleFDR4kzI0pvbg9GvaAHmfy/qJ8aYSnmFX+F5JTLQ7ZOf1Xs6C9SLyv
        i02WjNZti68rRAXImPeIZCnxp1HL2cLwWvaKywte52PpJwC2FCueSUnt9SJyPVsGuKT4Ac
        ZfPSGV01o2cMpucOe7awe0Bvvu/CzKU=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2052.outbound.protection.outlook.com [104.47.12.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-30-X1-ZjLWiOSaHlwkbQ5nxyA-1; Mon, 12 Apr 2021 18:16:17 +0200
X-MC-Unique: X1-ZjLWiOSaHlwkbQ5nxyA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNOWO918bod7BqNzjxXt7la9dkYVoJG2JnMWW5Em9mci779Jc54F6SeLqXymjRJu6GjU2xXEnAMZ4nozbBa4IJ1/FF+H0VUnxFbRFY9aPfnE5fJlmUoKStvcq9fdHPLlcyeHDfXwH1gfXwXXd+a9nmJ53IIhmH59qF+HefxOv47ujwVFUubm7ph7tttKnAHxUA9t3HTVW8MdCTY2o5m/eCmqt1tNTZfK5x+h3lofoXyANXaI0+/Oxdm/rzX7Yo0Dl8uBNd7hZPyaNm6EeAj/tuHAVC++k3SbesuNl9VnRfaOliQ79mTCk7c9Omcomo6BR6nz0moP8soQxs/VGkAmbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QpMs7PEIynVqJprICVSsS77n4nge+WVu1wgJW/KXYdU=;
 b=lgnMnfwC6iGOAw1x/p9Y5oYos0LW6CW5wcFNhiR1btB+UxnM0uhTFGotogNlIhQ20KM7wry3rwonYrBhQbi0ZnjsOQRaWy4hdsTTK9nkelkKgiJqgLfO/Dm39NQbsd2M73dXjXfUPrd/QVN3yDj5zbmQhI721PkC+emT8iRohxoZ42Kz4Id+NEBLObTyzxNz7nGN9JOkxubhz6uTCs5nNKjeg/G3vhxbxjt56BC0z+nV9IGZT2jv9RXoP23LEMzQuzxHT5S0czIdJcPJ2ihkSFAlJwmtItgpY60QyJI+26hQ7l5reFiaX4pUIi85Q5SpMuNPkkAXB4l+y5wUpqSIFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0402MB3517.eurprd04.prod.outlook.com (2603:10a6:803:b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Mon, 12 Apr
 2021 16:16:16 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 16:16:16 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: correct comments explaining internal semaphore
 usage in the module
In-Reply-To: <CAH2r5mvmsdai3iCwpohqUeeiW5tPSeiQgCH8DcpicWntc25rNg@mail.gmail.com>
References: <CAH2r5mvmsdai3iCwpohqUeeiW5tPSeiQgCH8DcpicWntc25rNg@mail.gmail.com>
Date:   Mon, 12 Apr 2021 18:16:13 +0200
Message-ID: <87h7kb32cy.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:703:389:f439:5b5b:3992:60b2]
X-ClientProxiedBy: ZR0P278CA0007.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:16::17) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:703:389:f439:5b5b:3992:60b2) by ZR0P278CA0007.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:16::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Mon, 12 Apr 2021 16:16:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d61c878-4cc3-4385-9a0b-08d8fdce4c60
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3517:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB351716365FDC167F6D20B252A8709@VI1PR0402MB3517.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HY5zq8Q7NC1PFGnXfp3Z02V3b3s985A747gcNCM7iEwiGMI+DIjq1XJ2e8CAbaSIt4bDj5UfxQpuEEL0KM9UGC3vgDNjCSUvNvE8A4Aj1NPA3f738vnqXWx9gjYTAbRlohlVQTGL80qzjTbqGYbd5ewcdhrYiql/2pqSrypOSb3nP7yThPk2QZHW3u/fmDHi86U+3h+8hMyUnQyuIb5hT/4ve/QLJOGe9m5Xv3Ups3jV9whkWzWNjnS9G5V9OeMcDp4tkp9J2w5Gm1hEDNqcX4ruohsHOAKNLLrsmw4OqEiItcho9nihQTJaFbKYd5/GmF3ZItHFumNClcthD1KDRisXNTKAnJA45chfSp7KOX/fba/yQY2u3wHqrh3Xw+Go3tx54rK+NwMU1Y2ap8klwOwaT+xY7vQ8DU74ILwIgCjVDWOd8KGo7zmz/yE3Fjj1Jc9qWEi0v95EnG5tWfwlWiOHQVd78G+84rdHfNwYk/kShR85tBtuW53vGYMmCjmydyp5qkR2oRBYvHYlO7c+3LLWcYLNSWxRITAkNbvXrtUnCewoDc6zmrw/6cGo8aFgEcRMMB/BOzjRSJuCx7Fr+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(39860400002)(346002)(366004)(136003)(36756003)(186003)(66946007)(66476007)(83380400001)(2616005)(16526019)(6486002)(52116002)(316002)(66556008)(8936002)(66574015)(38100700002)(86362001)(478600001)(8676002)(2906002)(5660300002)(6496006)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L1ZIcGNDRVdneG5zUGpTV3NYZWNjYS8wY3h0UVFzOC92WDY1RjZGc2NESEcr?=
 =?utf-8?B?MkRxdXZac3c3c2FVVmVBdThMTU9XV0svVVlSL1F4a1FyK0lqS0JaZi9zNXNR?=
 =?utf-8?B?WDBCQkZqQXcvL1Bmd21IS0EwV0Z6VWVNa1FyWlMwQnpveGduRWd5eWJpS0lX?=
 =?utf-8?B?QnR0TEhJVVVaUHRRWWNQRGZpVGtQTVdQMjF5blMwbEJxZnAzbW1sK0RSekdG?=
 =?utf-8?B?a2FDNU9uQm50VGJHUkJCQ2NDTXplZGo4WTlqRmJZTS96WGg2VXczSEtqN0sv?=
 =?utf-8?B?SlY0ajZhUDN1MTlpazNyWTNqV3FTTEptNUdVYkJSK2FNQzJLSXYvY3VPTzZB?=
 =?utf-8?B?KzRpay9zaGgxcDdXWXJUdWhjYUUyNkE4RlppUmtHMTRvVGFDZzhBUFp6K2c0?=
 =?utf-8?B?dG1NQUlBam9VcDJzR0tib2liRzdQcW1wWERmKy9oR2hCek1zUkVWUURoaldi?=
 =?utf-8?B?ZzhOWmxndmpkbml1STBzWE1sTjV3NU5iclNRdTBOTUlTNmlxbVFkSEpCRmg3?=
 =?utf-8?B?dlVBZ05VTTVwSjJpcjdNbkQxYjRnMzRIMUhqMlRHdWNaZXFvbFBsTm5TQmdQ?=
 =?utf-8?B?VE54ek10dUloR0dnN0YrdW41Z1RNYWhkNHNMZmdkcUNyemdwdjYxK21OMGNo?=
 =?utf-8?B?WXFRdTQvbmxRWmVkRFQ4V3JFS0pOSGtUOW56OCtpNG5LSDh5QVkyWUd0dEIv?=
 =?utf-8?B?UzBiSUJFUkVOakZEcUorckxaR09xT0FpbEdIZTBBbFlCZVJPYk9CZmlzM3h6?=
 =?utf-8?B?UEo3Nk50VGJlNWc3aEN3c1dVTkZDanVjWlhWUmdlaHFFV1RNdmJBUmV1TWN0?=
 =?utf-8?B?YUs1QVlCTFRhaVB1UHBqZC9vY1E1VVZ0cXhTUmZlVVR2ZVdEUmd1TklOVGwz?=
 =?utf-8?B?ZVovV0puZUpyRGZmUWEzMi84VVhmckRza3JPU1pmRndCbTM3MDlYRXJ0VjJP?=
 =?utf-8?B?ZFRiSG45UWhaUmNVVmNjYWs2bmIzaUhkUHE4Q1lFQXNyOStyZVFVR1pDUVl6?=
 =?utf-8?B?MWttRmtlUEdNYVBzQ0MxT1JncGdjcEdaZDQxMHJwVTJtNUFBRi8xUmVjOE5j?=
 =?utf-8?B?SkFHSHA1c1Y4UVYra2IvdzFMM1RsMXlCb29WcHY5OVNtVFpHT3pkZXVuZ2ti?=
 =?utf-8?B?UGhCTWZBSlg3QWZNNlRDMDFuVnkzK0ptZ0FWTEhzTTNac2VHbWJqNUJlajNn?=
 =?utf-8?B?UHkzSWZSNDdQWjVSV2FNOTdRY1ZqaGgzMkVrcWViQUdWZVVWN0cyK2t6OTFF?=
 =?utf-8?B?dmhUVXNZeU9yRGZOZU5KRlV2VjlIVVlkYjE0N0JWTSthbVBJS2FsR3QxL1V6?=
 =?utf-8?B?Tyt1eXZ3V3hUZWJpNGE5THp2OUdHNTVNcHJVR3BZWWJvYUI4YXhJQllFNnh4?=
 =?utf-8?B?R01TTEtybWVNaUpaSEQrOWRLTzllZkNOMWl5bDRZdEptSytjK1pPbTlLMnBO?=
 =?utf-8?B?cFZpZFNHSUZhTjY0ZHh4YmY4dFM2NUJ1d2U0TFMya1ArakRYWW56ekxKbldu?=
 =?utf-8?B?ajRQRFd6d3l0R1FDK2NYdXpaT2JPQzg1Z2wvWkxOZTBNYW1QNGRWVXpWeXFp?=
 =?utf-8?B?RVJRS0R2ZUZTSnVzZERJZldBTHFMUXZiRTVsMnpWczhmNGxhY1FGejdqNndy?=
 =?utf-8?B?STlKOUNRQXRBVDVlRWtmb2ovbkF2MUYrSHNTeGk2ajBoUGFGcnRYL3ZQMzJu?=
 =?utf-8?B?bVd0eExqZ0FOM0xUUWE4ejg0SllldXQwUzlTWkxrSkM4S3dGMjJDdE9UUmpu?=
 =?utf-8?B?YVhMak10Y01SQnlZMEwwNDBwSWlXNGhDMitjRW5idTMrNkxhTzF4M2FPbHFt?=
 =?utf-8?B?aVRSNDlCTVVlOTg1T0tpSkU3TERkdnVLTG1tK01XWDlZdWgzNHg0UXNKWUM4?=
 =?utf-8?Q?bCZSrXBc6cfBI?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d61c878-4cc3-4385-9a0b-08d8fdce4c60
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 16:16:16.1053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dKrHBY/yPX5nlH7PT0MDi5wQ0gu3TXzRKyu5rQb0/qLzf5mC4McIg9Loetc6SmhD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3517
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
> A few of the semaphores had been removed, and one additional one
> needed to be noted in the comments.   (Additional updates to the
> semaphore/mutex/lock descriptions in the comments in cifsglob.h
> could be helpful to make sure they accurately reflect what protects
> what).

That's a very good idea. A good starting point would be:

  $ grep 'struct[\t ]*mutex\|spinlock_t\|rw_semaphore\|seqlock_t\|rcu_.*loc=
k' fs/cifs/*[ch]

  fs/cifs/cifs_fs_sb.h:   spinlock_t tlink_tree_lock;
  fs/cifs/cifsglob.h:     spinlock_t req_lock;  /* protect the two values a=
bove */
  fs/cifs/cifsglob.h:     struct mutex srv_mutex;
  fs/cifs/cifsglob.h:     struct mutex reconnect_mutex; /* prevent simultan=
eous reconnects */
  fs/cifs/cifsglob.h:     struct mutex session_mutex;
  fs/cifs/cifsglob.h:     spinlock_t iface_lock;
  fs/cifs/cifsglob.h:     struct mutex fid_mutex;
  fs/cifs/cifsglob.h:     spinlock_t open_file_lock; /* protects list above=
 */
  fs/cifs/cifsglob.h:     spinlock_t stat_lock;  /* protects the two fields=
 above */
  fs/cifs/cifsglob.h:     spinlock_t file_info_lock; /* protects four flag/=
count fields above */
  fs/cifs/cifsglob.h:     struct mutex fh_mutex; /* prevents reopen race af=
ter dead ses*/
  fs/cifs/cifsglob.h:     struct mutex            aio_mutex;
  fs/cifs/cifsglob.h:     struct rw_semaphore lock_sem;   /* protect the fi=
elds above */
  fs/cifs/cifsglob.h:     spinlock_t      open_file_lock; /* protects openF=
ileList */
  fs/cifs/cifsglob.h:     spinlock_t writers_lock;
  fs/cifs/cifsglob.h:GLOBAL_EXTERN spinlock_t             cifs_tcp_ses_lock=
;
  fs/cifs/cifsglob.h:GLOBAL_EXTERN spinlock_t GlobalMid_Lock;  /* protects =
above & list operations */
  fs/cifs/cifsproto.h:extern void cifs_down_write(struct rw_semaphore *sem)=
;
  fs/cifs/dfs_cache.c:    spinlock_t ctx_lock;
  fs/cifs/dir.c:  rcu_read_lock();
  fs/cifs/dir.c:                  rcu_read_unlock();
  fs/cifs/dir.c:  rcu_read_unlock();
  fs/cifs/dir.c:  rcu_read_lock();
  fs/cifs/dir.c:                  rcu_read_unlock();
  fs/cifs/dir.c:  rcu_read_unlock();
  fs/cifs/file.c:cifs_down_write(struct rw_semaphore *sem)
  fs/cifs/smbdirect.h:    spinlock_t lock_new_credits_offered;
  fs/cifs/smbdirect.h:    spinlock_t mr_list_lock;
  fs/cifs/smbdirect.h:    spinlock_t receive_queue_lock;
  fs/cifs/smbdirect.h:    spinlock_t empty_packet_queue_lock;
  fs/cifs/smbdirect.h:    spinlock_t reassembly_queue_lock;

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

