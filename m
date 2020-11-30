Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9370DC71155
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Nov 2020 10:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37BD820708
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Nov 2020 10:30:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="T7zffsIX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgK3Kac (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Nov 2020 05:30:32 -0500
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:60315 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726498AbgK3Kab (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 30 Nov 2020 05:30:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1606732163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KOi7ljYATgqCcd5JSK41L6b4dDuXRqOjudZJ7dKAffI=;
        b=T7zffsIXTWrtVlJgTx9TkTnsEDdehgTUuarCuN0jkBTZD8c5372Bv0pYNVVjtAQXXPHvBn
        COIXQ23NEh0TQNVdAWfuAdIOwD0bQZpe+YATT6MJE0LbTBVDsUPdton1NofG9Qvm6NIZg1
        2BMzuUUpt+RS9y6Oscwfceyv5VhSuyA=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2171.outbound.protection.outlook.com [104.47.17.171])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-37-75yiF2U1NFukmCsWvocyJg-1; Mon, 30 Nov 2020 11:29:21 +0100
X-MC-Unique: 75yiF2U1NFukmCsWvocyJg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ztec1xkxQ4mEFvU0hPacjXjhv0qRQwsGtjDQRhrFc3Lpe4pscEWG0ONdt7dK0GbSfGlH3vOQufnFWOq8MCbD2oRe7JPM5Q/7bHzWv2bqfAqZ6akpZzTsPaFoBUXBP2vQ2JLMNJsjifz8wdz6wozKaInBEynt8z4Zzd4Jg/VkpPFV7n6P8she8vD3BEz5hTiR/K9cYocTLqUUbBXQdxKtc4MnWBNwzD23+T5CtO1cFaoc1I9sldHlH7/NRK4OTh++Z1Zj9lA2br+YwuK+Po9yumVx+NqnTvMwF2om/tYCSBFPV9lmIOP2WUsMcOReT4YLX0N8Keni4H7QQtlFIYP3yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOi7ljYATgqCcd5JSK41L6b4dDuXRqOjudZJ7dKAffI=;
 b=bPSLXkO49kizhCHczqp3sBJPZMGnlWvSXkzb/ildu5SCzCy+f6VsV1mKaBwV9GZSXt7B5jejtL7yMN7jvAwAkjKwJW9GAtw0IXAo+j7aeGig+Ui0K95ooZosmtIxKavRTIfP7DaFa6uCicZ1wPLOgDin69GjohSYukAW11KzInVsQakBg2I51xDbFVl6yG0zKGwsPcl3ERRNGOLJBkKHdiOEEwKqvrPQhoOnAGPzkVpQcbhjqrkXUM15cSTM48s1onCrIB9iKVOUvn/9jc0Y6/dCFvVJYpmynr44neuTBO1XaibXWGytA0hqj6qao+vysEMHiPDyr83ikephwrGxMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: cjr.nz; dkim=none (message not signed)
 header.d=none;cjr.nz; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0401MB2381.eurprd04.prod.outlook.com (2603:10a6:800:2a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.23; Mon, 30 Nov
 2020 10:29:19 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::4dad:a2d3:5076:54f0]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::4dad:a2d3:5076:54f0%5]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 10:29:19 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: Re: [PATCH] cifs: allow syscalls to be restarted in __smb_send_rqst()
In-Reply-To: <20201128185706.8968-1-pc@cjr.nz>
References: <20201128185706.8968-1-pc@cjr.nz>
Date:   Mon, 30 Nov 2020 11:29:16 +0100
Message-ID: <87sg8rdtoj.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:712:b936:c722:2c07:6cc3:291c]
X-ClientProxiedBy: ZR0P278CA0096.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::11) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:712:b936:c722:2c07:6cc3:291c) by ZR0P278CA0096.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.23 via Frontend Transport; Mon, 30 Nov 2020 10:29:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6470993-67a4-4b8f-3cc8-08d8951acb7f
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2381:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2381E4F696FC4CCB438D0D0EA8F50@VI1PR0401MB2381.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RzZPbnyUQ78aAB1Q/63oW/uJaxcEUhR4KI4aHOGPg/sRUO7peGOJU8/Bl9cLLyO7N4K3iGCsX/2AAYfO++sTFDbwmaApYSaJZ8ucLaeFqoHmwxnLumY1xUXvNj+8fLR6smdKXz53fY21feP90q2ap8fWscZlr2n5TJfapg8ybgZgSlHYNihVmfFBz06EbP4TYPyEX+JXMSSt3C/DaI3yjXB0HYzqg6/vYBUTeAsrgHNPSj1Swgfq8EfyOeJ7EXe1/TJtUJsP6Qek9QDECZgBkzwkT/bKavtnV/TiaH9we/DyzxcuFcG2MIZ9Q/YPsfeI93+O1TxQsmSAiRxorLuNWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39860400002)(396003)(376002)(366004)(478600001)(66476007)(36756003)(66556008)(8676002)(8936002)(86362001)(66946007)(6486002)(52116002)(2906002)(5660300002)(16526019)(186003)(2616005)(4326008)(316002)(4744005)(6496006)(83380400001)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aXplblBqN2tYL3ZsUlZOVkV3eWc2UXR1QUR4enVSaDBGYzNJWGpEaTRVK3NS?=
 =?utf-8?B?TUVBYmF3Y2RkSDlvWkgyeVBVcWhsWnh2TDErTm9vREErTUJIQzR5N2c2VE1v?=
 =?utf-8?B?bDZJQXNtcFZvYUVZankySVR5eTBxVnNCTnhDU3cxVzJHQ29Qc1JjMjZYWmZC?=
 =?utf-8?B?RVlaOEhZdVdiVVh2VW95emdrdkd5TllFMWVxVVFkSHFZYkhEYkdtcW5lMzdo?=
 =?utf-8?B?VTFZVGRLZmFsZ09vcG12N1RlSWJ0RzVDSXNORDg4OVhXRmIzRGVVRk5WQ1I1?=
 =?utf-8?B?RHcxenkzNDBZVGdDQzhta3ZiaUpKNGRnaStWdnpITTU5OUxaN2xjblpOeWdE?=
 =?utf-8?B?bk01S0hHMUlWVVRBL1dCTis4ai80VDZGTHpRbCtMbnVzMFhOYU1sUjFodk9s?=
 =?utf-8?B?V2pYQ3l0aW90R1BDaVkrMDg1cHIwbi9hRGZmWHVCcFlGSjB0anJDR1dRQU1j?=
 =?utf-8?B?MjlNMTJVVU53Mmp0MDZKTDE4QlIxbUdsNlZ6a3o1OHozZUc5cjgwR0trck95?=
 =?utf-8?B?SVMxWjRDQWJxM1Y5dnlXNExKSlg1TDhlTHp0OHF6a2RsdWR0RVNCc3JNazdt?=
 =?utf-8?B?TVE4Z0RFeHc1ZkNSanFHUmlKckorWHRiVDZuOE1OQ0x6NXBrQjFjVU8vOXlk?=
 =?utf-8?B?MjhtSVRYMU9hVDl2OWJZdGhSRHNhbU9NY3dWd1BqRldMbVFFcXFQWWk1cnR1?=
 =?utf-8?B?UEV0Q2Juc1ZRcUhJazcyWG5yK3NidVRqOEZwTjdvUzVyb3lDcDRUTXdsaE1x?=
 =?utf-8?B?Sy9kZWN0cFJNVnpBalpzcjNWRFhTM1VTbjdueVg1RmtjUCs5ajFBVXJEaXA4?=
 =?utf-8?B?MkRUMkE1aDhBTGhDN0lOVzJQSDRYRTdHMUtQYWN2WHNtekIxMURoVWJlNFhB?=
 =?utf-8?B?SEIyYzc5cDRhTVpFUURNbGNTeEFkSkduMkZDTFkwU3h4cmE4dnJPZU1WVFl3?=
 =?utf-8?B?S1hVVnNwblVucEhoUERTVkRPZUV4RmdCMU1ySEZIdkVMM2Fsano3R004N2Fa?=
 =?utf-8?B?MlBhTkFuWWVKMWJRcy9weDFIOWVja3ppMklzUTZHMHI0ZGRqTFhueVpFK2RT?=
 =?utf-8?B?MnQ2QzYxMnJkOUNKd1JQZVFMdkNHcURveGg5d1BEZUUrbm9LWUxOdkxYVjJR?=
 =?utf-8?B?UDQ2SVhrZnhLWEZ5c3dRRit2dXJrLzNOczJIc0d2QTZWM3Yvdk5UOFJQYjNs?=
 =?utf-8?B?RlVNdDBWYmZ4OGRvRmR0L29NS1dxY1BNVXBsQjV1VTV1VlVqYVp4OURrU2Jx?=
 =?utf-8?B?QXp3UUtrOUF4ZEIxT0d0YVJLNlNMTnFPY2VoRDVkN0JiaDljSlZMcjR0bG9D?=
 =?utf-8?B?eG1HMlJaSnY5VTJzd250S1haQ0RsZmQ0ZjV5R0hKT3FNV0tmeUNxK1VOb3hD?=
 =?utf-8?Q?brJzhc55MjKLzuMrscW6lqVeoSHn7LeM=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6470993-67a4-4b8f-3cc8-08d8951acb7f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 10:29:19.0785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tEmPZmQnpobC1AGPPn2zuN8HNDdCEl9zKYp6CYL5+OB+i6BC0zpgg/fY4a3B9M7e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2381
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Paulo Alcantara <pc@cjr.nz> writes:
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index e27e255d40dd..55853b9ed13d 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -338,10 +338,8 @@ __smb_send_rqst(struct TCP_Server_Info *server, int =
num_rqst,
>  	if (ssocket =3D=3D NULL)
>  		return -EAGAIN;
> =20
> -	if (signal_pending(current)) {
> -		cifs_dbg(FYI, "signal is pending before sending any data\n");
> -		return -EINTR;
> -	}
> +	if (signal_pending(current))
> +		return -ERESTARTSYS;

Can we keep the debug message call?

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

