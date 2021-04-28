Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15735C433ED
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Apr 2021 15:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4B826143D
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Apr 2021 15:25:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbhD1PZr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Apr 2021 11:25:47 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:50705 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230527AbhD1PZq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 28 Apr 2021 11:25:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1619623500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T4j/C4s4P3zn4INk3+BBVWR8dqkWwhtDAWrf5Xto6Ho=;
        b=ifEPTUwIgrrP0Xec1ADSiJqzt+F3gMAaXDAzwy88ldqoBpOf1KCudBu+jWUHpXXTP78u55
        W1l1DEcNKxAtDnTcQJsKnmv6WXhbS+CTTQnrkJEFdDxNYvYjrxHaaiVlJoDis/p+FqtT7g
        2jlqJ1Wfuib/GSEFBjzEy3eMFV8y518=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2059.outbound.protection.outlook.com [104.47.12.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-18-OAGwV1lIOV6ofckTqNYiCw-1; Wed, 28 Apr 2021 17:23:36 +0200
X-MC-Unique: OAGwV1lIOV6ofckTqNYiCw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dI2+gLzJMyjJEpm2mB3A+owjPvaaT2YFJ+vcbLugc/tn4SWUy7JvhkgEMn+lCatLG2UhntEksEaAxYVe39NEv69W6z5upMbXYUO5GqA2T1VOCg0MI2ZihfHv4ub+pT9PKcT9qVO22YHbBGoOTVCzx3yQs88k5JQN+22dLL6pFMSKTwkDJVGA6OEHY7LphGPJJ7BPh5y9wJj7WNu7aVh6m27iRHS5u70o2rqcgnOslWKp+jUjmod+WZ6pChpoFgQ9tmPqzEBk6WqgssX7waBVc81+9zyMZzsB4brCj/8Z313FsW5iARHDCNILySRkEkW+sxqfGOXoULmnN5tTwdMZrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T4j/C4s4P3zn4INk3+BBVWR8dqkWwhtDAWrf5Xto6Ho=;
 b=M/rr9eX1wPKJ42FfCsneO0qzRkGQhCiPVC/l3eiVXuzfLqnN97X9wtfd6RQZxEecFyNnBQnd8TvntVDh6+LxVOomsqmNxR3f9RBkSmemBP0IK0eatsYDY0XJG8jrTNFK3s/CKWIMnCE2c6UrCJoGvk2e77p4dTU0DBI7D7c5gODTt8/1rVFPy16BBIMjuS4vG11Rmr2taOO4h6BUs0w5zz8I3awCFmILhjUhpNcQ52lwfnqx51rxeo0HOiasW5H1TqN31HIMILQBWxCeWfsdAsj/kXbRFXk9xVvoJQxNxrWaalNyzg2MUhH8w5tEXvc4wyy9bJQ3AlyD1uF/s8E6Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB4672.eurprd04.prod.outlook.com (2603:10a6:803:66::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Wed, 28 Apr
 2021 15:23:35 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4065.029; Wed, 28 Apr 2021
 15:23:34 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: when out of credits on one channel, retry on
 another.
In-Reply-To: <CANT5p=peB0L90CN1pVDe6uyrbz2=9jTm865N6938i5-ZJN42Bw@mail.gmail.com>
References: <CANT5p=peB0L90CN1pVDe6uyrbz2=9jTm865N6938i5-ZJN42Bw@mail.gmail.com>
Date:   Wed, 28 Apr 2021 17:23:32 +0200
Message-ID: <87bl9ywhzf.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:3857:3489:4c2a:5839:314b]
X-ClientProxiedBy: ZR0P278CA0043.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::12) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:3857:3489:4c2a:5839:314b) by ZR0P278CA0043.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Wed, 28 Apr 2021 15:23:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: afb10faf-ed26-4705-609c-08d90a59969b
X-MS-TrafficTypeDiagnostic: VI1PR04MB4672:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4672E4B411621C2F32E979C4A8409@VI1PR04MB4672.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Duso0NgSqsZOTP08Usg1wHstJReRX5Tj/JAyv/Mskoq0Bg3LloxxJig+nVGcp/Ia2tgkxCxVGexWmKBxClaoMPqUxVWJ5r7jYJ0FoSkdzDudNEuSHJKkxm0+bA0SCjAlvQCySV4jAH8NdddnfEIWhq7MjGzNw5s+sw427iWeCFAHw5RBDuFniKvP4SnMr/ybkGg9b6oFRPZM1f7FApz0dS6pJISY8IQCBli6hBwmVZVNKkpjQzZa7lvP6TR7YEKy72rBRZfHnUYmfHJSMVZ63DE1fBegEflDUiO0di4Ojn6qHg6cGgc4q04P4ePuUffa8B1gwmqaxn8q9S/O9ZnfuJv3sEdt+NOmxsLVutWo6uqJnDdkAcWO8zJPIcwOFhI7KNPZ0YyrodHaAQv8kVYSXs1PXGdnWE3DWX5WFwT8EppwGMUfnqz9BA+W53odvcO2zoStt3gYn7HKyrzaCLL/V/4OzZakvjGhajNXn37QRP/5F5u+FjpmqjYb5wtJY+6sWB995WJVwYItAyZn41dF8a+gH73sEcSX0vVjlztq+yLm2Erh2BT/T1ut07OPpmhKfc+9zWcShKZNnt0CLZwouA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(366004)(136003)(39840400004)(52116002)(66476007)(66556008)(66946007)(110136005)(86362001)(2906002)(36756003)(478600001)(38100700002)(45080400002)(8936002)(83380400001)(2616005)(8676002)(5660300002)(6486002)(66574015)(186003)(6496006)(316002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VGJHS1lYRWtvcEtLOXIxSTV3U3NLVVoxRmVmZlQ2TzVlTkxvbG9pK1hWeG5R?=
 =?utf-8?B?cThjczRVelBQdEJQMmVnSFF3VzBNbnllMkhWTnF0UERURzdJMDNPUVRjYmVo?=
 =?utf-8?B?d1JOUldrdGhLcy94KzVWWjIrS1lSZitpZWswQWs1aXpGS24veGkybDJIK3lF?=
 =?utf-8?B?Uzk0ZnJ6cGMydUhnSkdXK21qUy9jc1dUa0FJc01iYWUvRVBQUzBOdWQxSU1G?=
 =?utf-8?B?WTJFWjU2cWlRU2tzN3ZSelZVL0VhalNDNzdDUWdsUGVXRFRmaVZUQlAvajk0?=
 =?utf-8?B?S2Vud1hhVE5QaE9DOW1uUWtYSmIyenBkVkd5WmtzU0VVRFhsN0FIRkJUSXpu?=
 =?utf-8?B?eWZhUnR0REdKbGMvSWJUemY0QkwxNE9IV0dzL1o4U2RIWEo1WlY1OTFoYXU3?=
 =?utf-8?B?NjlFZG44MFdsQW1CSWwrelE4R05tWG5EWUdQcVRRRXJjZjE0VXdkdStscUp2?=
 =?utf-8?B?RCtWZkVsOWE4THByZkFrT0UrRkRIVE0vM0FsbllTOVB1QlJuQ1VLTVFKMmtZ?=
 =?utf-8?B?U3E0b2JWUTRzbUladHRjYnVjdXhVVmhTWGFMTnZ0cmpsK2hzV3IreFFQSVdH?=
 =?utf-8?B?UXBDQWZPdDBJcC9lTzRuUWhyeWxVV1NucXlQR3U1djZTdHVFZmFrU1lKeXI3?=
 =?utf-8?B?V3Z3b2tvMFVxYXYvcHVxekFKdmtJZ1B1YlpHZnBlcFRGZFhVbm5uYWQyTjUw?=
 =?utf-8?B?Z1MzS2hIdEhrZnFXU2k2YjRvempsYS9DVzZla3JRZzdmazdFcktLQ0tWeDJC?=
 =?utf-8?B?K1QxSUlxblV4VkM4UWRRUVhEWXhmY3ZnbGFsYmZBMHV5SkI0cEVPaTE4OEYw?=
 =?utf-8?B?dWhhaEMvOFpXYU1iRldub2RZbThXdTUwbkxwNTBhUjJxK01aR0FJN0ZUdkZB?=
 =?utf-8?B?UWhxa0NFVkVFL2dXbHhhRjdNSHc5SHBvMjV6TDg3b1d4eWVpaGRua2s5YlJa?=
 =?utf-8?B?b1ErQ0laYnBhQUFKbFdCaXJ2MmdOUkRGQVJxR3A1UkVaSmhiREh1YjFIYzlZ?=
 =?utf-8?B?NFFVRVg2ZEVqaG5aMUFvZHpUSjRxaEx1VHRCSERCdEZsUjhIaVg5WklLaXpw?=
 =?utf-8?B?L3NWbXBlMzJ6QVZIT01KYTRhM1FER0lzaUdEcWo3Y01YRGJZd3V3RHl6blpo?=
 =?utf-8?B?VGk1QVkyaDBXcHRFWG85eEVVRUNMbkUwdERoQzVVL21OQzBWL242UG9uUU0v?=
 =?utf-8?B?L1hrLzUxby9DMVVCMVpmL1JhTTJXUE9pTWR6eTZvYzNhS3Y1ZC85Rk1jc0wv?=
 =?utf-8?B?cTVwL1BDSHludENubndDK0pYcWlaeDgwTllKZWViVlV3ckFuM3FXQUI0VGlj?=
 =?utf-8?B?WGhqWWRuMS9UdkVZMVpaMnBsdmN3M3dYbGdheGt2NHBoTC8raGMzMSs4cm1W?=
 =?utf-8?B?RHZ2UVlLUTZjMHRvRG1TWXEvUzZVakYvdlptV1pveURYZWJFdzg0NzZuZjNK?=
 =?utf-8?B?alZTVndvci9odjJNbEg0LzBCVlN2azVtUUVtK1JiODlNaU5vblU1MmZpc2Iw?=
 =?utf-8?B?bzZueVFKSmQrUHVVNFRYVWhMWm9CQmFGa0lxNHdXWW9kV0hMY3pjMzMzdFZo?=
 =?utf-8?B?V1VTWW9TWFpuTnlEMS81UE8xNUlzY1FNS0lBeUtCanVHVXNDRk1vc0prYTZ0?=
 =?utf-8?B?Q0R5b3pPelFSTEpRdlJrdWtZb3I0NVNOYzB3TER3UklJUE14S01uSHF1N1Vs?=
 =?utf-8?B?MDdncUN0T3gyK05oNXhGYlJFWmhmZnViQVhFZnFNWEdLQjJZNFhyTnA1RjI1?=
 =?utf-8?B?emZYVEJzaUZZRk41U1lTdktYbmowWlZhUFM3ZjJnNGpEak1iZklDOUd2OGJl?=
 =?utf-8?B?a1FLOE5pNW5pRy9yYXNSVjFKNFQ5WjF3ajZOYXRaUWl6czIvd0FlSmRGRnRS?=
 =?utf-8?Q?iP80NnmkHwgV1?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afb10faf-ed26-4705-609c-08d90a59969b
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 15:23:34.6187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kcb50URaEmVHxXG4ETpryfKs74Behd6S8hYAxeiV0emvRl7SFwwAQ4Sp/Pcn7st+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4672
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:
> The idea is to retry on -EDEADLK (which we return when we run out of
> credits and we have no requests in flight), so that another channel is
> chosen for the next request.

I agree with the idea.

Have you been able to test those DEADLK codepaths? If so how, because we
should add buildbot tests I think.

For the function renaming, there is a precedent in the kernel to use a _
prefix for "sub-functions" instead of the _final suffix.

> This fix mostly introduces a wrapper for all functions which call
> cifs_pick_channel. In the wrapper function, the function is retried
> when the error is -EDEADLK, and uses multichannel.

I think we should put a limit on the number of retries. If it goes above
some reasonable number print a warning and return EDEADLK.

We could also hide the retry logic loop in a macro to avoid code
duplication when possible. This could get rid of multiple simpler funcs
I think if we use the macro in the caller.

Something like (feel free to improve/modify):

#define MULTICHAN_RETRY(chan_count, call) \
({ \
	int __rc; \
	int __tries =3D 0;
	do { \
		__rc =3D call; \
	        __tries++; \
	} while (__tries < MULTICHAN_MAX_RETRY && __rc =3D=3D -EDEADLK && chan_cou=
nt > 1) \
	WARN_ON(__tries =3D=3D MULTICHAN_MAX_RETRY); \
	__rc; \
})       =20


> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/cifs/file.c      |  96 +++++++++++-
>  fs/cifs/smb2inode.c |  93 ++++++++----
>  fs/cifs/smb2ops.c   | 113 +++++++++++++-
>  fs/cifs/smb2pdu.c   | 359 ++++++++++++++++++++++++++++++++++++++++----
>  4 files changed, 593 insertions(+), 68 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 7e97aeabd616..7609b9739ce4 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2378,7 +2378,7 @@ wdata_send_pages(struct cifs_writedata *wdata, unsi=
gned int nr_pages,
>  	return rc;
>  }
> =20
> -static int cifs_writepages(struct address_space *mapping,
> +static int cifs_writepages_final(struct address_space *mapping,
>  			   struct writeback_control *wbc)
>  {
>  	struct inode *inode =3D mapping->host;
> @@ -2543,6 +2543,21 @@ static int cifs_writepages(struct address_space *m=
apping,
>  	return rc;
>  }
> =20
> +static int cifs_writepages(struct address_space *mapping,
> +			   struct writeback_control *wbc)
> +{
> +	int rc;
> +	struct inode *inode =3D mapping->host;
> +	struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
> +	struct cifs_tcon *tcon =3D cifs_sb_master_tcon(cifs_sb);
> +
> +	do {
> +		rc =3D cifs_writepages_final(mapping, wbc);=20
> +	} while (tcon->ses->chan_count > 1 && rc =3D=3D -EDEADLK);
> +
> +	return rc;
> +}

cifs_writepages can issue multiple writes. I suspect it can do some
successful writes before it runs out of credit, and I'm not sure if
individual pages are marked as flushed or not. Basically this func might
not be idempotent so that's one codepath that we should definitely try I
think (unless someone knows more and can explain me).

Same goes for /some/ of the the other funcs... I think this should be
documented/tried.
> =20
> +static int
> +smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
> +		 struct cifs_sb_info *cifs_sb, const char *full_path,
> +		 __u32 desired_access, __u32 create_disposition,
> +		 __u32 create_options, umode_t mode, void *ptr, int command,
> +		 bool check_open, bool writable_path)
> +{

I would use an int for flags intead of passing those 2 booleans. This
way adding more flags in the future will be easier, and you can use
named enum or defines in the code instead of true/false which will be
more understandable.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

