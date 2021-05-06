Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9554AC43460
	for <linux-cifs@archiver.kernel.org>; Thu,  6 May 2021 12:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67222613C1
	for <linux-cifs@archiver.kernel.org>; Thu,  6 May 2021 12:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhEFMtP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 May 2021 08:49:15 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:30981 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229946AbhEFMtO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 May 2021 08:49:14 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 May 2021 08:49:14 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620305295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kHixbJwT9SWxPok1eZm7tAC6NfIHGCYNVoSH2vRhJZA=;
        b=Yphs+8ZYvssudfQowpH2GsrOPSJ+qVScxly7zs5Ml4tuyqWrueYYiyisip7veJlmbuMwkS
        TZuWW3T7CJ8NF0PYwSmvstGS6xk/ymjenLFJObeYGVkbI54UokiQlj6P0BKk5O7OPiIVfD
        5rJFpRx91EaRtvDpOaaS8YAdPL7sDy0=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2057.outbound.protection.outlook.com [104.47.8.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-20-EOKYzVRtNeqJUGpPsRAu-Q-1; Thu, 06 May 2021 14:42:07 +0200
X-MC-Unique: EOKYzVRtNeqJUGpPsRAu-Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yj81IrhQRn/USsdICU8tTOntuOuRD/ZaOo2dnEGLWHgM85MN2C6nmsVt+aQKOUXmvGxvYRVKw2R2UkHI9TBkkEubRXsM/SBktf6jLVFKwUY9IzcTHFOXQAHv66urYDlHHr8rHS1HCLum1yPYNiBAx7aHy75+6XPa7M0XNprFEX20kEfUdmd1X7K6hJN1mH97jh7D056UCadybkaS2txazVEeYNQWksZJeciQ8tSUjmzawP41OFIk0BdSLogav80r4U2BJhKoJPuwfEoR/wXcQ5xJ/Rq1nidzFz1vQ3UAoqXKG3041CvqYf+608MoiQIPr8sswVOWfjX9o/n8AFRkKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kHixbJwT9SWxPok1eZm7tAC6NfIHGCYNVoSH2vRhJZA=;
 b=C0B1aZvC8S2Zcibw14a7CIpRm3/k8JUXPEdvb2fQzGkgXmNqnvdEdorl6XcJ3daex+yxxgtLxUImawjTfcVHXC6byJQyOG9MBFF7RVKHQCDsYzMVPFbVoDuIsrSAa+WCtjcWauOCg4l9+hE8gcVwp4A/4vOjzLBGMrGajun6Ne3s8IJEyPL2Xwhk1oM4wgwRN9JNJ1blP5yIaUh79kfK4O9Z3zg+K0mkXw4RHe2ncfsJqF9sONAM21PHlLYGigvWSDFtxaJR4WRAdzYmJfVHxfLCNlUkHAd50umuj8pFAUJACJ0vwhYtm/8JsgoYErL5yC5JWMDWB8BfIwZqwAnoFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB4751.eurprd04.prod.outlook.com (2603:10a6:803:53::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.25; Thu, 6 May
 2021 12:42:06 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.4087.044; Thu, 6 May 2021
 12:42:06 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Calvin Chiang <calvin.chiang@gmail.com>, linux-cifs@vger.kernel.org
Subject: Re: Unable to find pw entry for uid
In-Reply-To: <CAEVyU88zhTKVrbk-+YCrd4fTN=za8906CwFFGzDk0OovSD4=QA@mail.gmail.com>
References: <CAEVyU88zhTKVrbk-+YCrd4fTN=za8906CwFFGzDk0OovSD4=QA@mail.gmail.com>
Date:   Thu, 06 May 2021 14:42:03 +0200
Message-ID: <877dkcuj8k.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:a601:a9cc:4527:eb3e:8251]
X-ClientProxiedBy: ZR0P278CA0108.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::23) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:a601:a9cc:4527:eb3e:8251) by ZR0P278CA0108.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:23::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 6 May 2021 12:42:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25ce08b0-d680-4b57-55ad-08d9108c5aff
X-MS-TrafficTypeDiagnostic: VI1PR04MB4751:
X-Microsoft-Antispam-PRVS: <VI1PR04MB47510EE5C7785E3327E7C770A8589@VI1PR04MB4751.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DLlR9eF2FBtgF/Nx3vPU+HvLcj/pOAMe3FKhjuGNzMxqXqGAGdv7Mz3CXOFNhGLmIE1Si52FUaBjONMzqdNnlU9OLlOBz0PcfmoH8ToO+8w5dtHhHJ0rmtm6G2s9/uqty93TSL7H99lNQw/Wi+MwTf4z71lg2i3eu0mQnEMBTueXs05ldwo1TWrzg+WDItLihymNd9xgeMrqVAC7U6tDR94jGfFShmHt+jZ/4MmHjtuSv0dJBbwWYYe7h8VMce3pBPn1t3y5uELucCopf+R+gqFPyR9YzfciBSavMtzP4aVrCpSdvG4x7ADWzxMRtagWF647vpoxScOQI7npOhPcL6yYn/XrcKC7KtMQ0nPPmZXv9r4b20NqLZ3pPhzcyzcRBnjDTlcUjDHXkrevYbLINDMh4HfCecot2q3sVBU9LVUx0lXWMAOYWyjAHuyZy5AN6twohdkZOGoNzOzDtIi/ozayFUuuz0ihoxSFUCcdwbbClVrmHJHxk46yML55P1ZbW0Q0DirknNb4OcAr0aBVRelZDEjifea7bhGJhFJw71d4Nk8EIfrHGmAJxaIONsHVgeUO+R13II1kWNUzSfcMQSk3uiNjxNvjZSd0e95ck6s15s2jOt98UwA/kLV5vVFa66FpBhLL9bp2/j94xD2T9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39850400004)(346002)(396003)(376002)(38100700002)(36756003)(5660300002)(186003)(86362001)(2906002)(8676002)(8936002)(6486002)(316002)(66476007)(66556008)(52116002)(6496006)(16526019)(83380400001)(478600001)(66946007)(2616005)(37363001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VnJ2VTVHL2FUdmJvZnZaRThGdURYdXlnMTR1bE1xdjJiZk1nNXZKcE9xaWN3?=
 =?utf-8?B?bzdiT2cxUUVVTDFKVmNUT0UvUGlTSGJ1bjRjazVnQVpyNStGenNjc21lY3RZ?=
 =?utf-8?B?YS84NmZ1dmRucjR4aDdyOWg5SnNMUmRyOCtxMlBXTW4rZlBJbFlmUUIwTHhO?=
 =?utf-8?B?ZTVRVjRoTlJzM0FmbjBuZDFuT1UyTzBxQm5obWQ5UExBYVFGWWRmV25CLytV?=
 =?utf-8?B?azdMTlJpNG04aVBjZDYybkVBSUVRRTdzSkdPdElBU1d2cURHUHR2R0hvVGdj?=
 =?utf-8?B?bnFZdEVxMHlydEFKVVluUGZpWTBjM1U5VWh0TUpsNVhtYTVDRzJTWk1RU3px?=
 =?utf-8?B?R0tzMTZ6VWt3bnI2bG1jV1ZsR1hyZmU4aytnTFl6ckxrbE9xbUluVFlBaVlh?=
 =?utf-8?B?b0lFSjY4MitiRlRCeFBoakpjMkJkaU8rL05mbFBZUmxhRndTbVJMbWt0RXNj?=
 =?utf-8?B?MGpTdHhUNVN4THNNS2MxdHZVdVdjSGU3VjMxemV5QmpFOFByemlDV0dURjBl?=
 =?utf-8?B?T1IxV2lweURaVDA2RStxV3FUd2tkcVlaWkdPUU5sb2Q4R09UUzBGYUZDZDNt?=
 =?utf-8?B?TjFlWW1RQW5FeXNBLzRhNlErZFFrb3VCNGFadjlXNmxySjR5ZzhJd3FtZ21Z?=
 =?utf-8?B?VU5QYzREQ2dNYVN1V1pYYlhlaWlKUElkcWN4S3dmM21mZHhGSUw0Q3BZWEY4?=
 =?utf-8?B?aHVaWkNZMkx1d3UzTWN3Z2cxZVFCeEZDajVFZjBvY21JOGVqSUR0SnFJbERU?=
 =?utf-8?B?ZGluM0tGSStURWkzV2pFV3hIcThubjFDa3NBNU5Vdzc1TTN3MFVRWTQwc2I1?=
 =?utf-8?B?MVMxMUZZZmRxZ29FWU52UktoalpTYmhmQmVLRTdtWXN6N1JGQUlCbUdWN1lK?=
 =?utf-8?B?RkRGWGpneU9DOW5maWFTWXpUYkU4ekdybVB5cVVvOXJ2MzhTSDFjd01FSjQz?=
 =?utf-8?B?b3doZ2ptN1llWTZwbFpKclcrdy94d2hiaTcweTdWWWU2cTl5RmVXaU41L21j?=
 =?utf-8?B?MVlVN1o2dkZ0K25RUXpyeDFmZ3pWSzMvRHdxM25ldXpZRmVCNzlKYjM3SFdU?=
 =?utf-8?B?VnR5QklUM0F5VWsvUFNBeTVsdU56VFBadHRtSytUZ1psZllTMEE0dlVLRzAx?=
 =?utf-8?B?TnRuZzhFUmtFbTJoRUl0YTRzOE8xWUh5MGZDZ1VBbGhudWJFaGpHdWxESlBE?=
 =?utf-8?B?UDl0T09wYTNDUHhkNnRSUHptVHBxdlhLQ0NNUGNnc1FiODZsNk5VTHIzNEtV?=
 =?utf-8?B?QURuQXV4VDBoSFZseEMyQnFrT09Qd3Q5NDR6SXNkUlpldlFwcFBHRW4vd01Y?=
 =?utf-8?B?dldSVVhnOCtaM20zakRRbGY4UGVjeVhEN3VJV2xBMndlbGpzYXErR3JOSHY3?=
 =?utf-8?B?dG9oSDBPbldvL2ZFTUlSYk1mSWw0V3U0WGhmTGFkMTN0dExTZkxlaVBPeDBh?=
 =?utf-8?B?NHA0Y0M2aTh5NzlFbE9OdjZ1Q2V4RGxmTGNhMDV6L0prbHZaTVFiTWNCNm43?=
 =?utf-8?B?TXBQYnpYS3BST0p1MjEvcmk2RllpaitVcjZHaU5qSjdROFY2Nm5TZWE0UW1R?=
 =?utf-8?B?NUpneW1DdTJ3R1MzL0FLaVVwRE41ZDZzVzFFRXBYTENnR2tEUmZhdWR0Mkl2?=
 =?utf-8?B?d3FVVWNkb25VaXlCdE44bmwxSzFFbmdhRjFBM25DMFZRNTdFZnNJVFI0QnJG?=
 =?utf-8?B?blJSckFVL0dIaGh6N0ZnNklDTEZDejVtUktJWHdqUU1ycWxEUnRablRwVGlu?=
 =?utf-8?B?UWNneVVJektmbS9uaEJwVCsvM2g2bk9iUElJYnVHM2pPWUg5QzVzaE1iTmtY?=
 =?utf-8?B?bHphMEcyVXJTdG0zTDl4NW1ybTlVSmlWOHpic2VjOTdVMzFzSVZHYWNWRmdX?=
 =?utf-8?Q?nICc3jUdrKk03?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25ce08b0-d680-4b57-55ad-08d9108c5aff
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 12:42:05.9103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jMzMJenTUBmYTAbh/CLQOgWx6Dnk+zbx0XQf3Oca6318iig9BsVLugENnuQbiZlt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4751
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Calvin,

Calvin Chiang <calvin.chiang@gmail.com> writes:
> Now oddly the strerror(errno) is actually returning SUCCESS
> But the pw =3D getpwuid(uid); is failing.
> Getpwuid(uid) is calling nss.

...

> and the output from the sssd_nss.log is:

...

>     (Mon May  3 13:05:12 2021) [sssd[nss]]
> [cache_req_search_ncache_filter] (0x0400): CR #114: Filtering out
> results by negative cache
>
>     (Mon May  3 13:05:12 2021) [sssd[nss]] [sss_ncache_check_str]
> (0x2000): Checking negative cache for
> [NCE/USER/cyberloop.local/alice@cyberloop.local]
>
>     (Mon May  3 13:05:12 2021) [sssd[nss]]
> [cache_req_create_and_add_result] (0x0400): CR #114: Found 1 entries
> in domain cyberloop.local

I don't know much about sssd but if it's finding 1 entry in the
*negative* cache that means it knows it doesn't exist. (I'm assuming
negative cache means cache of queries that have no results)

That being said I've had issue with getpwuid() before that were solved
by updating glibc. Could be totally unrelated to your problem though.

You should try to attach gdb to the cifs.upcall process. You can do this
by adding

    syslog(LOG_ERR, "my pid is %d", getpid());
    sleep(5);

in cifs.upcall.c before the getpwuid() call. Then try triggering the
mount. It should block because of the sleep(). In a different terminal,
look at your system journal for the PID, and run gdb -p $pid. From there
you will be able to step into the getpwuid (glibc), nss, sss, calls.

If your linux distribution has a debug symbol server setup for gdb to
use, gdb will dynamically fetch symbols and source code on the
fly. Otherwise you will probably need to install debug and source
packages for glibc, nss and sssd packages to be able to see function
names and source code in gdb.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

