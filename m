Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11876C2B9F4
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 10:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EABDF613C2
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 10:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhFVKUv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 06:20:51 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:51450 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229840AbhFVKUn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 22 Jun 2021 06:20:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1624357102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nHjQfKIEsqh1Hz0HELNZwKIyp/ghdj0PJZZrS7bp/d4=;
        b=C/vBcNA2ZzB+ThbMOP/4QiK2Ya3dUlMAMsd/fiRcuI0hQGTNVdc65I4qhdkkmeHfEfkUNp
        OS5a1yDbN347RzC8ki17o8Ve5CiHwahVWWntHjG+XUg8+A7KkQIHw/AySsX1QFje/uAtmb
        8ydBoV9Gpi5tGkHyI8pWU9PFmGQCCR0=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2057.outbound.protection.outlook.com [104.47.14.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-17-qpa5325MP1ybgm9vvIX-Cw-1; Tue, 22 Jun 2021 12:18:21 +0200
X-MC-Unique: qpa5325MP1ybgm9vvIX-Cw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hnpBIsIi0RHui9nDN/cqlVqKj84CgdroH4scjOe9221k4CU3402gAHEL3jgyBuBW1YMdF9ILxjrMlZk6ugPHPEVtz04ZVdt5dksxBLixxN5Br/WxpJNoqKXo7lNmON3Hl90eVsr3GuDzPIseOi56hh/idyTyMNuE9Fg+Dk3CBZK+MkmF6zZ9dnmEMSV5r3aUPjeeI3Kom8lBCy1Bpr5ULL+lgAte1G61ayoblkmcDG1PnTwyB8Bd43J32YX1hR3+WLJz/07lYn/SnonmRQjDvbTvUZEvyaO5JKu0jzMeTCpRYYwQiptZ+KZnL1+IGoENALIygUD5w89ASZ9YMWtLHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nHjQfKIEsqh1Hz0HELNZwKIyp/ghdj0PJZZrS7bp/d4=;
 b=Quo2GjSKOIpSHCos7VK3Wc/Sd5lAzSGKgIKfdUFNDoRtF+RbhygOPhtZbO1d5KsZrSbNnTzjLvr8y7Ltf9/Vf1NZsUVm904KC5g00H9ZxlD8opU0e7gMAQ3gHVcun/bCf+k3Nyvd2WcM/E9RtZt+5pYu1oo/AeCoPMDrOo2Ph4iH6FdmvPCoGUqZbzKn4BoITumliS5ZXq/GZz9ti7slDennpIfkzUSGXPl1mg+kR3r0Oa+zwa9wRSbsrU/EFGMG4KosZKRyd1+ykXgg7M8JNflL6bH5c4EWkdnPer6wr2LTRWUssNO07S5ZhPUfh2ww9vhTee+oAxclKIRTlpEAFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0401MB2381.eurprd04.prod.outlook.com (2603:10a6:800:2a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Tue, 22 Jun
 2021 10:18:19 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::18e7:6a19:208d:179d%6]) with mapi id 15.20.4242.023; Tue, 22 Jun 2021
 10:18:19 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: 2 error cases in sid_to_id are ignored
In-Reply-To: <CAH2r5mu4uEOP4r-KnF+bZGqPjdRwkaZanD1sE_JHuoK=jB_nnA@mail.gmail.com>
References: <CAH2r5mu4uEOP4r-KnF+bZGqPjdRwkaZanD1sE_JHuoK=jB_nnA@mail.gmail.com>
Date:   Tue, 22 Jun 2021 12:18:18 +0200
Message-ID: <87r1guqk2d.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:70a:9938:181f:a8b6:e56d:3837]
X-ClientProxiedBy: ZR0P278CA0112.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::9) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:70a:9938:181f:a8b6:e56d:3837) by ZR0P278CA0112.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:20::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Tue, 22 Jun 2021 10:18:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11d94404-adba-415d-5018-08d935670e8b
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2381:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB23811A787E6B6DC00E5A89BDA8099@VI1PR0401MB2381.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dZwR2QyZboI2MXnDK5Xlx9gkt+95uvLJdvgcidSVZLihHirCcf7cvIe698Tn0xDbSn9LGL24+OLlEtEzylNc2uWbN7xRAkUHEjtjzgGU6HDvIBTrRLJqHkGQCCm3s+dOezE3XrH4qtSlTyO7Cg/uNwWA8G2QQAX57Hd3JJFxoRCyNlzLh0iLOjFN5E2igP4tRXDpzg48Hk9d+SSvwJywobytOxW9jIpiw0fF64Yk77Mc+OxaGzocEgcMIwe2PAqE37FICXZkmO2TYO0DoqMjLurl7JAOxkDxAloKzM1hlT4RIFvUewOceaV65u+PARpkb1FK7QQlSogiPNaMaI1+QpY3vZm30Gqw3+2xPIc1NRNfYstK1mUk2920KI5DCFXZcidSRbG7kZisYoFwFesr+NZxga4bnoZemwOBb9RAWCiT77sUk3FQ6FWUJzj+2nmvvJqobP1rhPVB7X59SnxVcvCuELkdNJGqBBlL5ksz+MgMg979OHKF+GNN8jyyk8ZOXD234jvQAkFEidk7a9a1hclY/czmSFzsvdFXLXvOMOTw2TE/1ca2Q+yGOnVMRbsBpPH+eXj94gXvx0iOi0XBTViR1KDmibm7uMlN2fWBTYo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39850400004)(376002)(136003)(366004)(396003)(36756003)(4326008)(110136005)(316002)(66556008)(66476007)(86362001)(38100700002)(478600001)(6496006)(5660300002)(2616005)(186003)(16526019)(8936002)(8676002)(4744005)(2906002)(66946007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTRrUHVNOVZSZVpYcHZ6ZVVPaUxQTnpqaGZiTFlpV1MyYzBUN0dHS25wMjYv?=
 =?utf-8?B?dHJaMlQ2RXdKYmhDTmRSY2VIaGtZczJSRnRyMUU4UVB3K21HQUJ1YmpQa0xM?=
 =?utf-8?B?aktsY3NUREdsbzZzM0dBWENycCtFYTdycnRjbkt2T3FGY2E4KytjeUJtTlBF?=
 =?utf-8?B?azRGQzViazdVUDJ4eUxGSjZKS1pXdlZvQ2JBcU52cDhlVENmcGl3OHlDWXRi?=
 =?utf-8?B?QUxSelBnc3M0NzZza0xBc0lCaHppdHp1UDB5cmNxZzZDNGIrQkNQc2tyOUdN?=
 =?utf-8?B?SmIwWDRxeXVCaDVYZEkrVVRzekJGaXZXL2ZJaVNPTWFjTm9GTS9WSEFIRXBL?=
 =?utf-8?B?Q0hqc1drWkQrZ3YxaDlWdGJVenkzbldoVGp4TDVDRVBvWHRENkRuS1o4dnVt?=
 =?utf-8?B?SHkyeHlCUFZDMlhxWkhZaEFKWkczV2p0dzdFNnpCODdJalkwUDg0Nis5TTYx?=
 =?utf-8?B?V1dFS3N3YzJpbnR4MnJoY0prUVF5MERSYkEyMmdObEhNRGR1T3cvbndmOXRm?=
 =?utf-8?B?U1BEdmE1dnhoOURzLy82MTc1RmFTQUFGdjV5UW16bDdab2sxZWlHUVJ0dUov?=
 =?utf-8?B?WXdMTWc4ZzdIYjBhak5ZampkYmVDdGlSdG9paFZ0Vk52bWovSGdFM0p0S09U?=
 =?utf-8?B?RGNuL2pxYzFxM295cWpTcnk4ek9NOVhXMTU1dTRHMDcyK3NvT2NXNTloNVhW?=
 =?utf-8?B?OEhJN2JBM20ySXdrWGZZMklxbmphSjk0d2I5ZlBsZWpyTGlYVWZ4aG0wUkxo?=
 =?utf-8?B?SExvbTdSRFBISW1XRWpBSXQ2VzI1NkE3SFpTT3pacUJ1eVkzUHQ2ZytRQVZT?=
 =?utf-8?B?SlB6MXc2b2FRNFdCK3NHdW5rQVdFQXlIMm5NeWZsSWU4Z3Z5UlBIRkR5T1lN?=
 =?utf-8?B?RTBtaFdYYkdRNkNObXNBWmptek1EbW9BRkZwY2xaQ3ZXVE14OWVra0dGRkVR?=
 =?utf-8?B?QUZmQkJyWEFyYzVwa1E1UWlmeHNnZmZ4UldMdVFlZjV6SmxNbFN5eTY0ZGdj?=
 =?utf-8?B?TTBNRVp4OTVxeUw4K3JCU2UwVzBLdWoyTmNTN2ZnTENLQUxXYTc1Z2NDR0p4?=
 =?utf-8?B?eVNKUnJ6VVVkNnQ4Y0dhdGNPN3ZrZHJiL2dqNVdBMldEcU4yOFQ4M002MElI?=
 =?utf-8?B?NFZiSHpuUHJmUEIxdDZXdUJGQkk0U0RYTnh6YmVZN05JQ0NIL0s0aW5pcEdv?=
 =?utf-8?B?MzZ2c2tTRDBUcG8xdUdoQ1ZxQ0tjMk16R0RYd3Ewbld3RExuSmdXaU5CZXFE?=
 =?utf-8?B?R3VxZElsR1o5eFI3TjVSWVR4cXhzQ3BBOG12WlRTbmZyZzgvUlEySGZodmpK?=
 =?utf-8?B?elVZSDFNR2liQVJHREVnU3FLM214NjVEcjA3bnZRbzZQQnNmVjdxN25PZ2tV?=
 =?utf-8?B?cXZSbWdRdUwvWGNiemF1ZVhaekQxRFM3K3pKRTFGMWw3S1lkUm9tTzNseUtM?=
 =?utf-8?B?cHpTTllMSjQySDNXb3JIQjdZOUlxYi9pdEkwTmZpS2tZdXhpbGpwejNOdG5X?=
 =?utf-8?B?OHFxSklLcndJYS8xRUIyNGlZU0NpVVhZbGVVdzBuQmhyRDRHUDYrMUx5amMz?=
 =?utf-8?B?MHRzWkRDTDlHU24zU0pwQTdBSmZrenhGekJ2ZEhGellzRHYyUG9nQjBzeDZO?=
 =?utf-8?B?NVB5em5FODlMd0tTSmhhOFNxbUNJdnhiM0dJbFY1RlErVFNJNzhKR2FVQksv?=
 =?utf-8?B?NjZVMDIyUWovMHFNNVFmU0IvRWYybXJpYnpoc2F1U2lBNVRWaDQ1ZUlSRmNT?=
 =?utf-8?B?R2hMclJqRGRjVVIwbU9IdGpxQ1RabG0xMEV5aG1sdGJqc3Z1cGNRYkJFUTdZ?=
 =?utf-8?B?YkxDVktIUW42bHh6b3U0dkRsM1FKNjR0YWJtSURha013RFVPVzBDRlpsSGo5?=
 =?utf-8?Q?RC2ij7TYsrz59?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11d94404-adba-415d-5018-08d935670e8b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2021 10:18:19.2932
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +1dokF9P8kQU+Z9VbGHJAZnhZXOMzWzx95fyYZK7YNMZ8me40S15sFV8+kyqQmRt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2381
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
> Any thoughts on whether it would be better to return the errors, or
> continue the current strategy of simply using the default uid/gid for
> the mount and returning 0 (and removing the two places above where we
> set rc to non zero values, since rc will be overwritten with 0)?

My opinion: I think best-effort would be better, so returning things as
default uid/gid (or possibly root).

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

