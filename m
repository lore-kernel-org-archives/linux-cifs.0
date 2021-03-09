Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E834CC433E6
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 18:29:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD35064F57
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 18:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhCIS3X (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Mar 2021 13:29:23 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:35900 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230288AbhCIS3S (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Mar 2021 13:29:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1615314557;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9uOMiE7k5WuZHBxKPjley2JfnGn6HOzPZJ2YPDiwcD4=;
        b=Q3fdr2dzV3JOrFZ1uSVMcFYJYN75Zno0fwMzpKx67m8m+L2PgGQypwIOgQQp4ObBT3+Rlp
        Lmt4fHvDzI5hPpOStx3MgOZUqVuJvA/tZ3S933PpHWW9PE3tfpYPT07M7vU8rBa6uPOtD4
        DvUANTAjVBPL+UphJRROsDLhOyxcuTo=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2056.outbound.protection.outlook.com [104.47.14.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-40-_-ffND84O6SN0VzAcbYqjA-1; Tue, 09 Mar 2021 19:29:16 +0100
X-MC-Unique: _-ffND84O6SN0VzAcbYqjA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PFKn5rUzZNihDUq+CaQviz/2139qBO7NZU4TXSI+eTy+VvHNBGUcU9AfvC297RFeM+W+vhDgN0MP7UK9GF/Etco4ywkacheP3kxQQ8T9jrj+xZWxP3P4BMKe+pUSTjFNKb9Q27uOdqA+YCU3+3C/8/+NaeHOrQdiTFuQNgicydltYp9hkknID9567sAhV9ZFuep37xIZLHCT2icuH48QPmSytnESRdIU0+fj8imZJCYbBSTVFa/neIUQ+u0let7QUyaerM3RcOwdGSFIdaZwL8sLuboOdrAlDPQ9FzAUZl6Ds2PGXlP7vEIdAqBwB+1v0mQ0JIE7xbLBsvPJZsyhaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9uOMiE7k5WuZHBxKPjley2JfnGn6HOzPZJ2YPDiwcD4=;
 b=nWHzCcW+RAf5Ji4VcPRX2xhcn1XorSvpp05EtGQBwF83NrS/5ajq8MCW8bUoxQD8MbJjWMyatERvlqAja/kaeb1vOhwNyse+A4w8IuITBMhG/C8U6tF3h/OZIjIrujKYjHCFpCHQhFi79BmMcdjcMpCG9U/I65U6yZ469+ZOfF62pb7XravuuPEEuKW12vxepT3Lmxi8t1WG3rQDRD9LI1WPGZ53NOTI2bO/5ydMCZodWCTc0g9RcaxEYW8WQ0Tl2tZ6ozS1zEzRE426ZJW+/FDD1TaiokBVK47RcGAzT3RdFlY4ST/NPo8aM2DKM4GKAgpVDpbDTzKxALGtLfPDVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB6925.eurprd04.prod.outlook.com (2603:10a6:803:135::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.28; Tue, 9 Mar
 2021 18:29:15 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::9c1d:89de:a08e:ccc9%4]) with mapi id 15.20.3890.037; Tue, 9 Mar 2021
 18:29:14 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     David Howells <dhowells@redhat.com>
Cc:     dhowells@redhat.com, ronnie sahlberg <ronniesahlberg@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: [EXPERIMENT] new mount API verbose errors from userspace
In-Reply-To: <181014.1615311429@warthog.procyon.org.uk>
References: <87k0qoxz7r.fsf@suse.com> <87tupuya6t.fsf@suse.com>
 <CAN05THRV_Tns4MTO-GFNg0reR+HJKa1BCSQ0m23PTSryGNPCeg@mail.gmail.com>
 <181014.1615311429@warthog.procyon.org.uk>
Date:   Tue, 09 Mar 2021 19:29:11 +0100
Message-ID: <87eegouqo8.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:70b:4a86:7aae:f2a3:a8a6:9cb6]
X-ClientProxiedBy: GV0P278CA0014.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:26::24) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70b:4a86:7aae:f2a3:a8a6:9cb6) by GV0P278CA0014.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:26::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 18:29:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d81cc96-a67f-443e-ddb2-08d8e3293dde
X-MS-TrafficTypeDiagnostic: VI1PR04MB6925:
X-Microsoft-Antispam-PRVS: <VI1PR04MB69253913118685B541F5044CA8929@VI1PR04MB6925.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EsSos33ns9MASwqgOv6ZPWXu1n2JrPaRCOYjRFoNf62Y+dC6i2L+ywLPJ7blxOauk4mJEhib91UErYGPO+NkhYyw75e0z6U9B1mL36E3cqj8pgFkHYrMGvdEJ3w9M7ORUejReXj0yCe3eels0pwnFwkRGZZAiv3zb3+NQyt1wgAivXeCauA7MDpbC9+jAhCaiKmkrEroYVF1G5Zbjrd3PdLNdGNhW7cm4AxvYYdLrsM+GyTb2UX0sqXeyT9sihV4unle9FZKArV6YwWocsCZv/FR+XUFPaKa2qcK/xjBGfuQuxYKh8+FAyHNdaSM4dhlBrHZWuEFvzy9xG2F9e0fBlZK6j9IcZ/5LhfJqF98betFEesTvv1skOHDwgaStaItdqoq0dwqV4j2yW4fwOg3qXHGCMg3a1KIPin2NW2y63Ct1Ce2AqFwtja/kPnpCcKv1wl59UyecDpVTVcyat7YnRvxqoAJS4CKM350L+rneqLY8OmdVcKXJGuwDx0Xwen7EqU8PMjFbm5vB9MPZr2SQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(396003)(346002)(136003)(36756003)(6486002)(52116002)(6496006)(4326008)(4744005)(6666004)(478600001)(6916009)(66476007)(66556008)(66946007)(2906002)(54906003)(316002)(5660300002)(86362001)(8936002)(8676002)(186003)(16526019)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T1ZUbzdTbUduRDdIdzJoUFhhbFFEcDRqZDVtYXZoazU2WXJOUEM4RkRsV0V4?=
 =?utf-8?B?UUlpMTRUNVVDaXFuV0Q1NFk4M2lOQXUxZ0syaGNKQncyekZENFVGQXpqWGtv?=
 =?utf-8?B?a2NvZnZOdm94M3p5WUQxVmR1M1dEL3V0MFA0S1oyWE5IS1d3R2xiV0xlYXlm?=
 =?utf-8?B?UXBpQ25JekZiT0xiRVZ2Z2UrNFRWQk5CVmxSWlZubU5VQnNRYkVza094RkR5?=
 =?utf-8?B?RitJTkFUWGtZY2JPenNrRU5wbDBhaVBKZXlHZEdZcVZGVGZteE1qYjRPWFpv?=
 =?utf-8?B?alc1M245Wjc1dGF0NDVJNmtMcEVHTnpHejZ6d3VpZmVVeW9NeHkraVRMQnJM?=
 =?utf-8?B?cDZ3dWMvVjQzRnMwSXVibzc3LzdWZnBLN0JMOWxSSml5dmFlYzA4SzZaWnRu?=
 =?utf-8?B?Q21ZSlpXTGJGMTlkNjA0Z2xNQ1duanRMUkZ4c3FYQjFCR0FLNkZOcGtiSU1w?=
 =?utf-8?B?aWFvK2RBNmNCYUNRSDdYL3R4TlR2WDNISlhlUWFtS1l1SUVURGI2dXhCa1hM?=
 =?utf-8?B?MzFvTEx3TzNCU3hXKzFlYk5BYXJVM2J1Qk1PbExOUzZwODU3eE5BSG1IMmVJ?=
 =?utf-8?B?U3NJOFFJcndQVUdIOS9sN2JuM1FtWk5sWkh4NU4xTVhoeDRIMDZvOWwrclZE?=
 =?utf-8?B?d3Z4R0NEY3R1ZWtvc0hYRWZiZ0NKYkxTTjcyZEVjVU5xVko2UjJaWG14bnJp?=
 =?utf-8?B?OHNXU2pmT2pxMERuRHRDbTFMTWMzbWkyTXRyT0g5VE5UOURJeTlTTkd6cmRZ?=
 =?utf-8?B?S0VUeVBpY0F0S081dEd0UDdIZDRTdWl0WkpVYm40ZUpmYmRZMmdaeDJncmJD?=
 =?utf-8?B?R1hIVlQvS2FCQ1UvZ01aNGZ5U3FBeWhqS3d0TklCUER1bWJTMEp1eGpWNExR?=
 =?utf-8?B?T29ScTFrcyswNHZqcFI5RmM3K1cvZGpwN0RnR3p4dmYrNDNhTEhhbVoxVVA5?=
 =?utf-8?B?d3pGR2xXWHJ5Ui85ZDlTNWJZdWwvdWt5am45eHNic2VIMkdIbWFmc1ZUTHhZ?=
 =?utf-8?B?SXg1ZWw2Q1ZrWFU0UUFKbTRmWmJlRmVaaHJMRUZUS0QxQUYvUFFUV0xjUE8z?=
 =?utf-8?B?RWZQM3NacktVZHh1R2J0YzF6VS8ybEp5YmsydFR5VzZFOG9zMHVSMFU3TXdn?=
 =?utf-8?B?V1ZrRWxxa2ZpR3VRS1U4WStBR0ZuQkNJaTM3VTMzNkFRcDRuMWIwYkxUS3Va?=
 =?utf-8?B?eStFL0FLMC9nWEVWdWZESVFiWFZpeUpJSHd0RU9VYkF1alpCWldzclQwUmtT?=
 =?utf-8?B?ckxkYnNGZVRpeEVwNWxvZmhFazBrTHRQdUhzaW5qd3IwTFBLRzdmbFVOL3lv?=
 =?utf-8?B?dzEyazRLaW9VOWRmSzZweFVzaS96NWh3dExPK3NzOVlUZjFpbEw1ek5IQlBS?=
 =?utf-8?B?dFBiQm5yOXJoYmVKU0Z5WjFJcVlhVVFsU0JJYTJOenNteHVMdk5jcFNsRVhi?=
 =?utf-8?B?UVpSa0Z2Rnl5d0sxem9vSk5EeGRHODMxZ3dXd3c4UXBIWUtySDRNQnhOSTBk?=
 =?utf-8?B?YW5KT0owOU1LUWNFNHdWNjZrcktDc1BtRlE0WURWL0J6eFJnMXlhblhYa09v?=
 =?utf-8?B?VlVQeFlKZkJsNi8rRVJ1UklVWVk0NGNmcGNHZGFKSDZQVEk4KzQ2TVZSQTgv?=
 =?utf-8?B?Y2VibHRRaWZMRVZUV0Jjd1IxQXd3SGhidXpheTJmS3JlaHh3YU1WUTR3eE96?=
 =?utf-8?B?SGJYeVJvNm1JczRxeTd4SERFd20rMDVGdW5WdXFweG5TWkkrU1dyREwrNHVM?=
 =?utf-8?B?S21oOFAxZis5T2lPOHUxKzE0SWErRExLTi8xTGpRd0ltUmlISVpLcHUwM0sy?=
 =?utf-8?B?VHUzNWF1SG42UXRSOE5ydUFtd29OaW9YQ3lEOVFYRndZVUNrdDgzUXNzdzlE?=
 =?utf-8?Q?DR8MjickxUyX4?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d81cc96-a67f-443e-ddb2-08d8e3293dde
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 18:29:14.8732
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wmbHWx7wCjzoJg/jcIrL8j/h7enxADHbf+VrST7HKyRxLA9bv+2dNnsWW3RpGCI1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6925
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

David Howells <dhowells@redhat.com> writes:
> I had this.  Al disliked it and removed it before the patches got upstrea=
m.
> Also Linus hated the fsinfo() syscall that was the way to get this (among=
st
> other things).

I see, that's too bad :/ thanks for trying anyway.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

