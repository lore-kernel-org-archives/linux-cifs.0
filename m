Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D770C433B4
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Apr 2021 09:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D970D613BE
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Apr 2021 09:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237467AbhDFJwa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Apr 2021 05:52:30 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:47534 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237380AbhDFJw3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Apr 2021 05:52:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617702741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EFquN6iWQl84tfbAUA7yg9lr8kUzupRT62s5fh6MT18=;
        b=HPzMC7N54q/qp8Ead8W+LAHD66NV8wRw6Nv3tx505CHKP/HsBE8BA82TFPMdL85nlZE6hO
        pPTAYPNCxoxfPCIgZjG+STIggAkLhs9mulwsBqLjXBhKkjWEJiLQ9W8EnTcOXh/JhvIVcM
        pqlWVsFaAEaJIkGlkgkj40cX+jyUqKQ=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2105.outbound.protection.outlook.com [104.47.17.105])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-3-MM9XFtQDMJaxJI0Ep5spfA-1; Tue, 06 Apr 2021 11:51:35 +0200
X-MC-Unique: MM9XFtQDMJaxJI0Ep5spfA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U3lE7RnMPwNwP+10HoBeQO37/ErhK1PZwqvkRx/JlCSGvSb0np43tozo33GZBzD2FWY8oAkLO0GZjP0CFJJ0pTEX2EqF/3UPjO5L5qbAH9TuHzWlvbcOVucRCCoHmRyxWn6OyN6WZ89zM5SFoBcoruZGZNyYlKU5dPfvhChMpsUZI52m3ZHGmi26uKvKvkxz6BabeeqZ53ggUBJ0gUoqQUsyC6vZfteu9ZePsMO8auRsGBshyO5y4CpzGQoQYrkuFOVsnJC3SSXc1sMG8MeCgrDJHBsrWQAyQgy7LrAF64dt1z7xbBteohMg1/WbNL8xbbDzqBHb6hQ9cfESJEOqBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EFquN6iWQl84tfbAUA7yg9lr8kUzupRT62s5fh6MT18=;
 b=HbebOyHhfNC6Tm5FeSo6r7T59BQzMO3AhQsI/kXuHE6Fd+wj6AUZWa6fVYLGLHZYDEow08y5uRVsleFpD1Xqfs8ue9eckz1FS4gMznoxIFNPRZ86VFy4KOOy1+dxHaEJ2OWJBPw5QZCpO+phw/UwREUBV8oTax3JV5aucjB9MO4DP3pUDQ8WhCsGYQX1QL6emcWvLE9KARZAow3yKEgihlhDWYI6vZzKATMzZXla1cJ6N6859rXRu6IqZcaMKaVbscvtbr6jrBwwS4UxWLQLYOcHrpFbtGFXG+HXMoCNjy7CQovKyUVZqiFMNzq6qY2SjADTAxngCdWOWRQLIpq2dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: xes-inc.com; dkim=none (message not signed)
 header.d=none;xes-inc.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB5215.eurprd04.prod.outlook.com (2603:10a6:803:59::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26; Tue, 6 Apr
 2021 09:51:34 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 09:51:34 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Nate Collins <ncollins@xes-inc.com>, linux-cifs@vger.kernel.org
Subject: Re: multiuser/cifscreds not functioning on newer Ubuntu releases
In-Reply-To: <3798863.814011.1617658480343.JavaMail.zimbra@xes-inc.com>
References: <3798863.814011.1617658480343.JavaMail.zimbra@xes-inc.com>
Date:   Tue, 06 Apr 2021 11:51:15 +0200
Message-ID: <87k0pf4u7g.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:3023:3e6b:6105:9a2b:bde1]
X-ClientProxiedBy: ZR0P278CA0050.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::19) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:3023:3e6b:6105:9a2b:bde1) by ZR0P278CA0050.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Tue, 6 Apr 2021 09:51:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90d814f7-df5c-4a5d-b803-08d8f8e18fec
X-MS-TrafficTypeDiagnostic: VI1PR04MB5215:
X-Microsoft-Antispam-PRVS: <VI1PR04MB52150D23D2AABF03C3B54878A8769@VI1PR04MB5215.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rs+O0sYQzGQZQX9L+JpNCP2o3u9wvahMOYFpe9bBAp2JpbWd7WbAqkdRoAO1r3m7VHueiH4uOk5YCriZvilFowjcMn5Ig4wzakIRJdAQmusjEVJIwGbXoWZpl0SjvPBAldK9tPtF0UYrWNqtIxCNYmrWOPzA7OvxoADoBMi2PnVxyKm0g7L7rmlmIIB0zc/YmqXUswOyI3WFIXXyK8g6iogrbMGK50+kWaeuwApwEP0LoStN9oFQ9eoiJP5BR3dKE9TYSygcdpFqQHbjEjn2mwZWbX1MgC6mxe8FDLPnIJ1tPLmt6sLv/yH1P+gdH3g6fdbu6kwdXYw3na16kheAB3R70MAxmxx3TjcmolyuJAonsDRnKwdm1xcXZ64ym4TWn3EKW0W08qYI9WCOtO0yHT1KBiZrYdL9T6c9xlijsgJ0HeJkw3aXqeGVL4LEECHzG1Q4k84zuD63dJcIkvhgdeDsPoDO1w9NOlvFZvCUd2w1psMGnQ1/9+chmVG3w/4fSFK/aSsTyQ7fJmZYm+cO5hP7b0EQu1Ssr6fERLbett2GY+rq+ZKFBR0xpcDl1DpGupWkYZFfi7Ra4sp2B3tFRYZw2j0nW7PCCR6J1iyhOWCgXo1kNAWXG/hu0tFDu0UIJ16FyXYvkjfWXHs7sgPc/Sx1yKQBlvoQ7Q8jq1RRb7/vW2ie7nwtdvoo47eIRvxK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(366004)(396003)(136003)(376002)(346002)(8936002)(36756003)(2906002)(6486002)(186003)(83380400001)(66476007)(2616005)(66556008)(966005)(478600001)(8676002)(6666004)(52116002)(16526019)(66946007)(66574015)(316002)(38100700001)(86362001)(5660300002)(6496006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?S0EwUEpMQlBPKzZYQmpoTHpXNHROR3NYRE1CVjY2ek1ERDYxY2VNSllHVUJZ?=
 =?utf-8?B?M2doOWY5b0F5ZWZINFc4em0zdWkyY2E3WEZ4KzhQaTg2WjVyM1QxYnArQ2VP?=
 =?utf-8?B?b1N6S3RqUC9nTlhFS1h3V3F6RFVDWmIzTzNqYWVHMFJDZUFKZ1hvRW1aNnEr?=
 =?utf-8?B?ekphL1hITndnUURPbEVmbkJhNTZhUEd1c2pNanNlZ2JOdDdQWWx3MjdocjUr?=
 =?utf-8?B?eS92RmE1TG5zNXNHZ1ZnZFY1c2VzeHoxdytwd2xsV0R0SkQvWGZWa1lxOTV5?=
 =?utf-8?B?YWMybmZOb2dUZzluRS8zcGRsQUJMT2xYWWpNbEZMY3VSUHQrQkFGVHNFTW9X?=
 =?utf-8?B?ZE9RYW5HUnpJQ05ldnNsbWF2S0czNzZJempzZmhYb2NQN2VvL0VRZzNjamNU?=
 =?utf-8?B?MTliWWNmdk4rekRSSHlQSitQOGsrOHNyWTdzQ2dLZEZiSGxVOHN1c3JOaktr?=
 =?utf-8?B?a2ZscEtOc0VhVmFldG56cm1EQmVFWkdZK3o1a2hRdG9tRFJUTytrU21CSGtC?=
 =?utf-8?B?R3NJM3Urbm81bWptbi9MamFtUDl1VkxhUVhOTDBldmVBZW9uU1BDNGI0YWVW?=
 =?utf-8?B?Y1NxQ3F5YUlpZkRtQWR5aXNjZEUxYnJRT1dobEx0RDZwKzlxTDhVdWZhLzRz?=
 =?utf-8?B?cS8reE80L1o2WWlqYUtmYWFCTTh1bGxUQU0yTW1wLzAyRW9RaGhmdnBjVzIy?=
 =?utf-8?B?SGJLaDRaWUhhMkNyOEhnZWJOVjdSNHJ0MVdEbG9DcWZmcVZENHRxT0pvR1dR?=
 =?utf-8?B?Vjh1ZENpbE9Fd2twcTdUYytNek9ZL3gyZktCM0JWbW5uZ2tON3lnU2JpQ3ph?=
 =?utf-8?B?US8vVkhpS1g3ci9MNDZvQ0lwMzVSOFdyR3VxOFJDeGNhYlIxSkZueDIwSlVS?=
 =?utf-8?B?bFd6ZnROdGF5NDgvVjRpNnJiOEd3UXVCaXZXL2k5T1NiVUtRSTZ1OVN5RzRE?=
 =?utf-8?B?dm1XUGJ2ZHpvWFc1TlVLV1BUVi9uWXY5QzBHOGZVQk5mK09USjBzZlE1MWxx?=
 =?utf-8?B?S2R1WFp5a2lqMUNJY2JMQVFkb2xjZFdnemx3Y0Y0NU9PdWltdFBuZVRVdGQr?=
 =?utf-8?B?SHhGNzc1amNkeVNoTDZBa3Q1V0U0V1g5R1ZTV1lxdERLM3RHMkxLZXVQZmdn?=
 =?utf-8?B?cFpwYmFheElSNHY0YU15STAzUFJ3MzlGdTRCbVFPTEZ1WVhma0cwd3VUOHZ6?=
 =?utf-8?B?UTZsT21BeVl1Vlg3ek5MZkMzdmtxQlFpSWdIWlJ5RnR0b1Q0dW0yNjdqZ0I2?=
 =?utf-8?B?N09OR0Z6QkdZN0ltQkJEeWp6TnlFVzNXTzdvL0VDTXc0dmxGYzBZRENselZX?=
 =?utf-8?B?QW43am1QK3V0VjM4RlhNVzVSR2JMYlIyVmlYMzdoQXNqNkpWZXRTUFBIYU5M?=
 =?utf-8?B?V25XenJaK1pHNkYyb1gxUWVrR1FuNUhGNDI0b2M1SnEvWTc4QVBxOVhIR0VM?=
 =?utf-8?B?SkJDU3dLNGppc2dhaWNjaUVzbEU5TEtkcnV1Rk92d1hrSWxGa1F6dFQ1QXMz?=
 =?utf-8?B?ZHFtbUE1VGllOUR4T2g2c3l6RTZqTWdHVnZ6VTBTNGhDR2FsVWRRZVZZbmdu?=
 =?utf-8?B?TjJUSHJzeHhmRUFob2lJTXc3OEkzaWJqZXQrWndHQzZXeWtWUk9RTkJwanZs?=
 =?utf-8?B?Rkx2TzMxUVRMN1dKRTliczB1ekdmZzN3UkxIU1dyQ1lRWU1LbDBLVlY1VmNL?=
 =?utf-8?B?OWMvYlR6dEZaRG1JVnN1YkVDTWxZeHNseXNJaDliUUFIKy9TMXZMSEJ3cC9B?=
 =?utf-8?B?cWpaU0lOQnRLazBhQWRPNWRoS3duOHNoMFFyaSttK3g5Um02elpPdUY1dDRr?=
 =?utf-8?B?c1JISTB0QkZRQThzQnpwRFN5OE5rUDRtaEtsb3crZCtiUmJhZlZIdzR1QmJD?=
 =?utf-8?Q?bKdeZHoAeMG7Y?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90d814f7-df5c-4a5d-b803-08d8f8e18fec
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 09:51:34.0010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WsJg9GhJQzDt/MjIpB2ni36jEu8fcy1UNIFcfjGDseDSJu+MMLwstGUp2msMO9Sp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5215
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Nate Collins <ncollins@xes-inc.com> writes:
> I initially posted this to the Samba mailing list, where it didn't=20
> receive much attention, but it might be more appropriate for a
> CIFS-specific mailing list. Per the subject, this may be an
> Ubuntu-specific bug, but I don't have the familiarity with CIFS to
> claim this is so and that nothing is wrong with my setup.

You can try to look at what happens in Wireshark. If you are getting
STATUS_ACCESS_DENIED during session setup it could be a signing problem
or kerberos issue. I would be interesting to see to which request are
you getting that error back from anyway.

Ubuntu 18 is from 2018 right? There have been multiple regressions and
fixes related to signing since then. After a quick scan I see these
fixes (from most recent to oldest):

05946d4b7a73 cifs: Fix preauth hash corruption
edad734c74a4 smb3: use SMB2_SIGNATURE_SIZE define
cc95b6772790 cifs: fix channel signing
ff6b6f3f9160 cifs: Always update signing key of first channel
46f17d17687e smb3: fix signing verification of large reads
8c11a607d1d9 SMB3: Fix SMB3.1.1 guest mounts to Samba
e71ab2aa06f7 cifs: allow guest mounts to work for smb3.11
a5c62f4833c2 CIFS: fix uninitialized ptr deref in smb2 signing
a12d0c590cc7 cifs: Make sure all data pages are signed correctly
8de8c4608fe9 cifs: Fix validation of signed data in smb2
27c32b49c3db cifs: Fix validation of signed data in smb3+
83ffdeadb46b cifs: Fix invalid check in __cifs_calc_signature()
...

For debugging keyrings you can write a shell script wrapper for all the
cifs keys defined in /etc/request-keys.conf. This allows you to log
calls, strace the bins, etc. See Sashin's blog:

http://sprabhu.blogspot.com/2014/12/debugging-calls-to-cifsupcall.html

If you can recompile the cifs-utils upcall bins you can add calls to log
PID and sleep so you can attach gdb and step into it, can be really
useful as well.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

