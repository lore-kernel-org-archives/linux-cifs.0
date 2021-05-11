Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA0FC433ED
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 17:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3AF261378
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 17:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhEKRro (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 May 2021 13:47:44 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:35136 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231329AbhEKRro (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 11 May 2021 13:47:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620755196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mv4kcwq0Qh/kssfC3wrIPvmemZDTzz0BXDC78O1ALiE=;
        b=dYrc5lvkHDAN43fInquafxGgpPvtZkUVremXxOuMermnxaCW6+5V1BRqZ+pBLQL7g405lJ
        go5ZR8cqJGdN1UE/doSxglqwVxxviU73+vkqZgMbPS7DodD+qooYVUGf65HsteuANdkTNo
        YpWUlxOXNyKsazdTEggbYYRfyOwwPKw=
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur03lp2055.outbound.protection.outlook.com [104.47.10.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-38-rrk-NC4vMuuBzba7colG-Q-1; Tue, 11 May 2021 19:46:35 +0200
X-MC-Unique: rrk-NC4vMuuBzba7colG-Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KPPOn8gRFgyrF5opdEBHMek/QaB0QmJRPgn6yLpBxp7Afjc8ZB4+qq6Q9WTNv9Od1XSh64OSXFgloza9ZtvYT5zXcUHXQ5mRzU3kIN4c55X2TdCL0xYHEZRtmGRNQhIUolZvkUoXFsfaayagbUHiUpeTNjflZnLMC+2VfBB9BULkOHGtpVISVZMNQdVNhbIO8dGVmVju0bVesftkLGl4izmRyRNDVSDhzw7WWOaCuu3Ye4wImgC3xYHuce0yYFciL97R737iPN+g/FdTlNUrUpR+6HNoG0M7qAUqnMC4YsgrFLeGB5OsPDbtVKhV1pgQ9tNv8KfmEbIOFq4lQGJ2PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mv4kcwq0Qh/kssfC3wrIPvmemZDTzz0BXDC78O1ALiE=;
 b=enC0vM6yEAPnBEIV98qtvCUz9P/uyYFZpCY2/1fMvV8+3VH2qz5vL0OqqArdTmQh1/eqzo8nL50Cdx0/gMZIcuRrpXjxhg1cwks9cPlLYcQ+itI8ghYnIiNa1Q2oA/n6KQWON6/u7Z7hEXSRSnefCXzisT1CTBRkAeXgxcQC5gtwvwTA9JTbpiXsVSk1qg0zFlMuKPWWGE4ouEfwToiwbqALvUzHyKqOou9OkEo+62BK1/oDBvMtWNUhp5A6iv+QPu72ZoLyWjADLWTgfuWA78AI03YFmcAxN07CO4lF84PZzgaRsE0sZCuR5x4ILdnZN5tz4qboXWBDt7hUQ9uEUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: cjr.nz; dkim=none (message not signed)
 header.d=none;cjr.nz; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0401MB2400.eurprd04.prod.outlook.com (2603:10a6:800:2c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Tue, 11 May
 2021 17:46:33 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 17:46:33 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org,
        piastryyy@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: Re: [PATCH cifs-utils] mount.cifs: handle multiple ip addresses per
 hostname
In-Reply-To: <20210511163952.11670-1-pc@cjr.nz>
References: <20210511163952.11670-1-pc@cjr.nz>
Date:   Tue, 11 May 2021 19:46:31 +0200
Message-ID: <8735uttb7s.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:d359:b215:6aa5:3693:e486]
X-ClientProxiedBy: ZR0P278CA0050.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::19) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:d359:b215:6aa5:3693:e486) by ZR0P278CA0050.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 11 May 2021 17:46:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eef8cd9c-d2e8-4e40-5614-08d914a4b741
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2400:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB2400EA4E7B203940479CEAA8A8539@VI1PR0401MB2400.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V7s+BvDkAyNqjH0zULJjchVauG3MNCQm/2VJwDogSDs/dMNHs6Q1++zeBouSEnnHilqISG20azKQV8yeeT2B7+dkd/L7FeYFP0GKRciGDJC4VN9HZs92NrOSYHH6z+X1I/+PRKmRN+LO9uPUVP8OQruUKFUXgFdB8jGtbGbAchuoPVMzf7nI5Xz0OkksOBV/hWOapSE3Gi+PmdaWzI5YfgH4U/xcvcST2o09jcHqn48PPDBmtWp68kbW/Aw3PFjE8H5lv+8sjAJ1ZBvVJ+/p4TSqny8GLOWdsWV7XNRSeDmSIBIXsP/Fve+TCsM1Xk9T5OOHRhAtwU5smAZNMuzmjp4131VoV4/yHsIFKGWR57sIQcdBktiVJzgegtT4TTzQBCJbZCddG84WVyhAl8gRk7I7p9OSHgxhEh5VqPQlSs4IxAAlAsiuiRTlVLgNxEEorqiH69/zagdpZg1w3AEsyyYr3+5tJxXfjM/bGY2yYfSe+qmrqcjKC1QjvKPqTZWVxC/eC7afBujqG4swsFnm1rkYvOqZBDDeM3jomb2Bb0S3yEhM34SIiUIMkDRZEK2woH9sLm2gbR/xezCoL8UO6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(396003)(366004)(376002)(2906002)(66476007)(4326008)(66556008)(2616005)(8936002)(5660300002)(8676002)(66946007)(83380400001)(478600001)(6486002)(16526019)(86362001)(36756003)(6496006)(52116002)(66574015)(186003)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?T2NQMlZqL2dtZy9RUGlLQ2l3Qmt0S0FRUytHa0hFTk5BQWRvWUtVb2pESjhM?=
 =?utf-8?B?NE91eFBmcm5ySUJsSzJPRXdxRC84V1FGNXk2c1JSNjFqK3RoN3NJMHBFQjN1?=
 =?utf-8?B?M2V2bFE0enFGbUdZdXowRVBnZ0xDSG03dDFGTkRMRGpwR01KQit1VjlYbkxa?=
 =?utf-8?B?T1lncmozTkJQc0IxQVQxN3pBTkFYeG5EVXl3RjFwYy9rVnAyTmVvWWpsdCth?=
 =?utf-8?B?NkdCcGhDVmxhUzc0QUdud1lDQk5MUEh3ZHd0M1VqaDBPdWNMK0N5YUppc3Zp?=
 =?utf-8?B?eXl0TTdVeXdsM0IvcjZhcHg0aG1oS2NVbWVySkNPUGUxTUhqeTZPcUVDVkxh?=
 =?utf-8?B?MUpoTVo0cDl1eDVyYWhuWTZVdHVXV3oyK3lHRnhLVWp3cHBmZFBDa29TdVA2?=
 =?utf-8?B?YVVQdXNTeEZVbC9QYTU1RlBMVXlvQkxvdVhoTVZQTUlDK3Z6d2ZGdnZDdC82?=
 =?utf-8?B?VEFCdGdEZDZmd1laSzNMSVo4MGRNVHFOWHhCdUhCeW9UYlhZUkY0SFJlRThh?=
 =?utf-8?B?bGdabkwvRGlDU3NYYkE4bnNWTXpzc1lhV0djdG9yamZjazBTTzkzOGxtc1k3?=
 =?utf-8?B?VFk2c09JanZGV01rbnFCUWk0bmt2SzB1eWxDaitZUzlzVlQ4VlBONGozZWg0?=
 =?utf-8?B?c0EwWm5vOGJMd0NwRi9lcUhrZW1jTEM2L1FMNWVRSU56T3g3c09PaTVyVy9C?=
 =?utf-8?B?VXhHK0lFL2NwOUpvMkg1eFozL0J5c1ZlODJCTGdrbG1mZHJGdzZjZU8yZkZC?=
 =?utf-8?B?TjA0dVZERHR6SXJuYkFQR3BreFNWdmxBSXMvdXpkVjBMVzNGUEZDZGJDMXhD?=
 =?utf-8?B?dWNYUklJK29ZMTlyTFlQb0w1ZDk3elRyMXdNZktwNHdtTWMrL2RuY0hjU29B?=
 =?utf-8?B?VkZTL3daMjc4MHpmM2xGQmtVbVQ5bG1iWWVuRnJQUnZnbGxJREV3YTZua1Yv?=
 =?utf-8?B?eWROR1A3S0VRVlJsUHlScW5VN3Vpa0lIOWlicy9rOHpSeDZ0aUl1ejYwKysv?=
 =?utf-8?B?M3hJT2dJOGVRV053KzhOaGVrQURWTUlKVkZaYmgxc0Zha0JhOUtKd0F4ZS9F?=
 =?utf-8?B?akdUMHNHaXFGZzhDY1hYNEI2RHJBalE2OWFuQjI0THZjcmFYYW1yL2Q0NzJT?=
 =?utf-8?B?UmxBODBuT0Zuc2U1VVQ4aEw3ZndvYkhJZjN0LzN3UFJOU3JDRXdaMG1rdUl0?=
 =?utf-8?B?SHMzMnMwelpmQWdsZFlTVFkzNXpCc3NCWkM4OWpsWXlqOWp5NExTL011bkQ2?=
 =?utf-8?B?QlRibGNKMXd3dlFISHhmYzl2S0RPaWIwMThWSU9kU3RJTUpnbmEzMzdWWGlW?=
 =?utf-8?B?K2EzNk53VitUYU03Zloyb0lPN3B0NEVYWmJBcG5CVkNyUnUrcndXRnlYMU9L?=
 =?utf-8?B?Si8rcThubEVabnFlNDdjTG93V3pweUdINjh3ZEprdjhxMkE5Z2ZYalNueWVR?=
 =?utf-8?B?YWtYZER0b2dYVVplN011dUZRK0EzMkJpNWRSVjNVTjBDaW5tbnVLVnJKQkds?=
 =?utf-8?B?N000NVNmY3RiVTRVcHp0V2dOMzV4WU40Y0hWZHJEUnBrS1pFTlJ1U3RBRVFJ?=
 =?utf-8?B?dmlVdnk4MnZ4dUw4ZG1NRlUwRVYxeGxmQUxYV2RRcGVWTEpUZmQwUnJtL2Zo?=
 =?utf-8?B?SVoxSkNJUDV5K2xvSFZOZWJ1N0diL3VjV1JrL3JnbkN3dyt2aVp3N29hZ0F6?=
 =?utf-8?B?bytqQWFPakhtMlpnSkYvN2ViSk91bGo4ZkZSMzd6aWdYYnFuZnRpOFlyUkJm?=
 =?utf-8?B?V0p5SUQvSlI4cDdZOEtTK0piYkhHZE1mMWxuU3orcUhvNWRrYVhWOVNMVjhz?=
 =?utf-8?B?VWJ2LzQySUxNdEg3ZTBvWlZhRWQ3Yk9aQk1qM3JuVm5hOUlEVi9KTENUcVpZ?=
 =?utf-8?Q?rz/UutrA53zDW?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eef8cd9c-d2e8-4e40-5614-08d914a4b741
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 17:46:33.3079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k11x62IlQLuCLWA2XsFjSa5IMKpxQXtFe6F30DFNwSm9lEluNyBVbgb7hibNu3yo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2400
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


I would put in the commit msg that this requires recent kernel.

We should probably merge kernel code first so we can reference it here
in the commit msg, and say in the man page when did the kernel change.

There can be cases where cifs-utils is more recent than kernel and
mount.cifs will pass all the ip instead of trying them before passing
the good one to the kernel but since it's an old kernel it won't try
them all. We could add an option to enable new behavior or check the
kernel version from within mount.cifs.. thoughts?

Paulo Alcantara <pc@cjr.nz> writes:
> =20
> +static void set_ip_params(char *options, size_t options_size, char *addr=
list)
> +{
> +	char *s =3D addrlist + strlen(addrlist), *q =3D s;
> +	char tmp;
> +
> +	do {
> +		for (; s >=3D addrlist && *s !=3D ','; s--);
> +		tmp =3D *q;
> +		*q =3D '\0';
> +		strlcat(options, *options ? ",ip=3D" : "ip=3D", options_size);
> +		strlcat(options, s + 1, options_size);
> +		*q =3D tmp;
> +	} while (q =3D s--, s >=3D addrlist);
> +}

I think you should write this in a clearer way and comment, this is hard
to read. What does addrlist value looks like for example? Why are we
copying things backward?
Why is the last 'q' in the while condition instead of the end of the while =
block?

I was going to say should we return errors if we truncate the ips, but
none of the mount.cifs.c code checks for truncation so I guess we can
ignore.

> +
>  int main(int argc, char **argv)
>  {
>  	int c;
> @@ -2043,7 +2058,6 @@ int main(int argc, char **argv)
>  	char *mountpoint =3D NULL;
>  	char *options =3D NULL;
>  	char *orig_dev =3D NULL;
> -	char *currentaddress, *nextaddress;
>  	char *value =3D NULL;
>  	char *ep =3D NULL;
>  	int rc =3D 0;
> @@ -2201,20 +2215,10 @@ assemble_retry:
>  			goto mount_exit;
>  	}
> =20
> -	currentaddress =3D parsed_info->addrlist;
> -	nextaddress =3D strchr(currentaddress, ',');
> -	if (nextaddress)
> -		*nextaddress++ =3D '\0';
> -
>  mount_retry:
>  	options[0] =3D '\0';
> -	if (!currentaddress) {
> -		fprintf(stderr, "Unable to find suitable address.\n");
> -		rc =3D parsed_info->nofail ? 0 : EX_FAIL;
> -		goto mount_exit;
> -	}
> -	strlcpy(options, "ip=3D", options_size);
> -	strlcat(options, currentaddress, options_size);
> +
> +	set_ip_params(options, options_size, parsed_info->addrlist);
> =20
>  	strlcat(options, ",unc=3D\\\\", options_size);
>  	strlcat(options, parsed_info->host, options_size);
> @@ -2266,17 +2270,9 @@ mount_retry:
>  		switch (errno) {
>  		case ECONNREFUSED:
>  		case EHOSTUNREACH:
> -			if (currentaddress) {
> -				fprintf(stderr, "mount error(%d): could not connect to %s",
> -					errno, currentaddress);
> -			}
> -			currentaddress =3D nextaddress;
> -			if (currentaddress) {
> -				nextaddress =3D strchr(currentaddress, ',');
> -				if (nextaddress)
> -					*nextaddress++ =3D '\0';
> -			}
> -			goto mount_retry;
> +			fprintf(stderr, "mount error(%d): could not connect to: %s", errno, p=
arsed_info->addrlist);
> +			rc =3D parsed_info->nofail ? 0 : EX_FAIL;
> +			break;
>  		case ENODEV:
>  			fprintf(stderr,
>  				"mount error: %s filesystem not supported by the system\n", cifs_fst=
ype);

Ok, so now we pass all IPs to mount() and we don't retry.
I would add a comment before the break to say that the kernel will try
all the IPs so if we get these errors none of them worked.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

