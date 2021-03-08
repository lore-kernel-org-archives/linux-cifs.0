Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA20EC433E0
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 15:11:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C08065020
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 15:11:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhCHPKy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:10:54 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:34418 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231313AbhCHPK3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 10:10:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1615216228;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/uLu0Je5dOrEL0KKlyDeG6HqJiqWlJr8Ujw1DjC2YRA=;
        b=kBl2YuzOtB2chXugE4GC4uNANjnImD2sa32Gd4hE2e5F5rOi+mUUtYJxWqcivFZEhJQTYp
        +RezLGOZ7g0Z7f0uFIRZF8qXMyPlAzZB5FRw6THTB3lZ5JsqX5uivJslzYAFfMEj/70l3G
        lP+MkYX71UTbinzK2Mbq/673pwXSMgg=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2052.outbound.protection.outlook.com [104.47.6.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-17-AiqrqazVM32NH-bVjsZSiw-1; Mon, 08 Mar 2021 16:10:27 +0100
X-MC-Unique: AiqrqazVM32NH-bVjsZSiw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEmXzkxtTB2tcODKgd2BWmkspli0JCbLkYTEpWfmJ/mS53/NWOGFHjudy7k1ef8ny81SMMJrtXilVD7XR+uMh5nweVdt3du31J2Nlf+Jhw9ylPMxCnHi7/D2yI+E8hlrKbdSujlEK+4WckjmiTqq1uBFbGyHXKSOJ7e6rnie4m/yLobAYnuF8yPEfvFonBxCyQBMGesjLymiFWhxzsJ3sWG/Y8+GjsFT5DQPSKrYj9rb5Er+Yh2KwZ9Hns7alSM9lG+THEFOdFZrH+0NQQiNkoN6L27h3jyUPXC93qTQKcTa/KWv/Xhu+wFKoYVu/EvAy1TK8P7Kd7V/vX4fGInd7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/uLu0Je5dOrEL0KKlyDeG6HqJiqWlJr8Ujw1DjC2YRA=;
 b=FXzh+m9uFJQY5QnqW2ud3zmKG1qrEYYZrGElY9BbBCmk5Vw6Pj5ST6RBj8m/ENxZ7isrq9/KDFKqn7jHYWlS/0sXPsmP79JOH9WXmEefZaC/pVAuer4XHUYgUgoz/cbBUs5MW+B4R2h/bpveK6uEVxsTN3ayFD0AFheYlhknlvCs0btrt1Ms7OUfmJXpC9pqGzA1GMe2q3ZjfuJFqoq3ajTzbOOow+cswXOPEFjH5sltgu36x3kUS9j7oq3PkaYjBRmfop4jQjczC0TbleZ1fbEX6pzOnRx3TX5SyBQjX/7eUP6iD+/3SBZWYaC2MnjzJKY4LorhQCmy7A2uLTLYtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: cjr.nz; dkim=none (message not signed)
 header.d=none;cjr.nz; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB4173.eurprd04.prod.outlook.com (2603:10a6:803:47::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Mon, 8 Mar
 2021 15:10:25 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3890.037; Mon, 8 Mar 2021
 15:10:25 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: Re: [PATCH 1/4] cifs: print MIDs in decimal notation
In-Reply-To: <20210308150050.19902-1-pc@cjr.nz>
References: <20210308150050.19902-1-pc@cjr.nz>
Date:   Mon, 08 Mar 2021 16:10:24 +0100
Message-ID: <87v9a1vfz3.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:70b:4a04:48fe:21ee:1b19:31ad]
X-ClientProxiedBy: ZRAP278CA0010.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::20) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70b:4a04:48fe:21ee:1b19:31ad) by ZRAP278CA0010.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:10::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Mon, 8 Mar 2021 15:10:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55ca0027-63ca-46f0-ecbb-08d8e2444d13
X-MS-TrafficTypeDiagnostic: VI1PR04MB4173:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4173C8D747982121D6710C97A8939@VI1PR04MB4173.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j575Mb/Qxyl+fppk3tSyQ/gAdNwByNDLC5guA+xvXiGrQcdCKslG4jfu9KSs5IM+MRVHIy0gTWgOkN2CZZq/IKn0Z6G0BOwEHKFSMjOPvW3ay1/GDBKSaNzGlJwIyS0ggg3HYqVMI+CO5eiPugblw3CwSSFpcftlvy+WttwIQrWTEqzvRADul+ke6Ev3d0PZXbU8fd+nmovu3Srvs9PhI7u34rgPh8YjfR0RgWkH+XyEas+MD0rpEQJG2+HHjQ1DqkDmHsVywos1U44evoENeeJHZnU1gyOU0wt8IQd5KnyyDcj/T6L/+tSAOlATpF0XqQmbIb314buHzeXtXY4TlVlH4JRn6O/QvDho5FrXlHfYZsiVH5+DKazdt/Up+K7xycCblrYavxrWSNkvIKqF0y41249ywLX+/pTkvQvjHn25E9W52ZV9RRlEcaUzFbaCcpPUG9MuGB7J533FoG0cXrxoN3os06qwRUv4iFQYjUjbf/GsFM+wLun8YEUFQbccWpF2rX4k4/iaK/G6VZjmig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(136003)(376002)(366004)(86362001)(478600001)(66476007)(4326008)(16526019)(6486002)(5660300002)(66556008)(52116002)(66946007)(36756003)(6496006)(186003)(8676002)(2616005)(8936002)(316002)(2906002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?c1RtbjBhYWVkdm5lOElTL2VNQ2hGYTZuZnJhb25yeXpvSnF0bWVzRWVpZjB2?=
 =?utf-8?B?UnRtdFI4ZHZQM013QXhNTXQ0TGF4bUs4ci95VUs5WnM0Zm1SbU43akJlY3lB?=
 =?utf-8?B?K2dBRURaNzdFUm5LRVBEc2xxTUdDWGJ0bVA1SWtKenc0c1dsVC9JY3pveDBW?=
 =?utf-8?B?MmdIRmdmd0E2WHFScDlDaW5MR2dVSGFROFNqNGdoTHM1elVlQVFVNERzbjVm?=
 =?utf-8?B?d3RtYXZkYTl4TmN5T3NERW01b053ajg4cU0wckp5dGUrMzQrcW1QSUNlRjdo?=
 =?utf-8?B?LzZiUEc2NGo0TmZ5VGpsc0kvbTVGNHY2M0RtdXRzWFRhRG5taUhLZk1WeHlk?=
 =?utf-8?B?QWEzeUg2OWpEOGdWMGRxVldWZWsyOUtjU2lqVytIbmpLZGhwbXllcFRQWGtw?=
 =?utf-8?B?UDlGQk1iMEhySTJBWTc4ejBYUzR6dk8rM1lyR3NjeEVGV2xIbWVOTHVzcFc5?=
 =?utf-8?B?Y2YzSjIyZk9jazlGazQyaWZGYmt5SCtwVkJEa1BqTFpGb2lsc1NqYzFrK1B3?=
 =?utf-8?B?WURCbFNjbXJtalJ6aTcwL3JxMThuNzhmcUY5UXpZby9ObUZFQ3FhRGxpaWlR?=
 =?utf-8?B?d1U3MzlKVTl4RndITW8xTzRsL1NLQUtFNjdQcEwvamhJTnNPVmFDRGtrRDRm?=
 =?utf-8?B?Q1IvN0k0SFo1blR0ekt2dnN0Y251RXdXYmY2blEvdDZ6SWtCWERjWVl0Mmx2?=
 =?utf-8?B?L1Yvam9NbVluZGIwK1gya0I1Skp0czZBMFg0cFhja211cTRpN0JjWU01RWJa?=
 =?utf-8?B?Qi9Jb3oyb0w0cVdEb1Y4eDlKMVZYdzJHcHhNa0hFaUF4ZC9LMWVLY0s0K1Rz?=
 =?utf-8?B?QXIxb2I0emNEN3pWRkdnWWtHc0lBYmJ5S3RSYkhTNENQV1BndXFYYjllN25u?=
 =?utf-8?B?eS9XRnppa3VuYUJWZ2FXWmlFT2NaamlQYkI1bHB0VU4rYktkUmxnQTBSaCtl?=
 =?utf-8?B?c0hSbUtqdjhWa0RpTFh3ZUZMM25ERFJmWXFTQjRSNWg3NWV0Y093Z1JOOURB?=
 =?utf-8?B?Ui94N0liYXJGb2VYb1BWUUdQUXBjWDVwTmdoZ0M2UERZSW4yMW8raDlBVVpS?=
 =?utf-8?B?Nml3S1IzbTQzbTVpd0NSdFpuVXlOY2t0N2lkWlJxdWdySHpNM1RaYWx4ZHEr?=
 =?utf-8?B?aEI0TVVndzc2TzdQVXR1Q1QyU0pmWk5wKzBnK1dvL1d3ekVyOE8zTXMxdGtT?=
 =?utf-8?B?MWhQVzZoUkt6Znp1ZTFSYlBVMFcxSGlVK0JVSmJ4aHlhMkdselJ1bFZTK0o5?=
 =?utf-8?B?SlIzcTJ3T3ZFY08zUHEydGFhTmIvcDNORWU5c2JPMDhjanB3OGd5VlU0eUJi?=
 =?utf-8?B?aUlRLzJCZ1RmN1hlcThVNGYraGkwMTBOUGRhcFBkUENYSHhGeWZPOGVtWEJY?=
 =?utf-8?B?Q2ZUU29WenVDcmhmblByMW9QSXVZSXFUUGJLdjVXV0ljVE54bURYSmYzdFlK?=
 =?utf-8?B?RnpjaytRQ3YrejY3WU00SXNXeW94VFZvZU8yVG5BUFMxL0dwRS9nSjBhNjJr?=
 =?utf-8?B?TlUrMy9JaFFSalB2cUdObC9SdHV0MHhNR0d0VStqOWFRU2FHUEdLdkUzZXc3?=
 =?utf-8?B?NkNaMUx6cER3bjV4SmVIdEIxMGVkdE1KVzluYVcya0VtcElPR1NDQVF5WFFQ?=
 =?utf-8?B?MnFlUDZNT21MZUZ0Nk4ycUpWY2RSUkdHbFYyNUZUR2Z2T0ZjUmo0UlNiOGtP?=
 =?utf-8?B?eVg0ME5zZUR3bXBrSEdPL0s2MDZmRkhqN3hEUE00NXVGTDczdm5SWU1QUXlw?=
 =?utf-8?B?SEZGTUMzWENoSWNENSttSFVxRUh5ZENXMzlPMW1mUTNUM245S29mODdJMGVx?=
 =?utf-8?B?VFhXV2ZyNXFGZVZEc1JoVk9nOG1rS3k1eVdwZXlRcjllOWlEVFZnNkJsU1By?=
 =?utf-8?Q?RF9IvfjR9kY1h?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55ca0027-63ca-46f0-ecbb-08d8e2444d13
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2021 15:10:25.3369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YB3P9rGTCN01++GbeWg4J+rBRhIqUjPa09e48GAKnAjIfwaf+yN7LH7obLrYhvt+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4173
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Paulo Alcantara <pc@cjr.nz> writes:
> The MIDs are mostly printed as decimal, so let's make it consistent.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

