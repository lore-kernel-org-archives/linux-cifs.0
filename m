Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308B3C433B4
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Apr 2021 16:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC5FF613D0
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Apr 2021 16:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240049AbhDFQfu convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Apr 2021 12:35:50 -0400
Received: from esg-scz1.cuda-inc.com ([198.35.20.38]:3293 "EHLO
        esg-scz1.cuda-inc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbhDFQfu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Apr 2021 12:35:50 -0400
X-ASG-Debug-ID: 1617726941-0e7bdd3dd5803c60001-broWZD
Received: from IP-SCZ1-EXCH01.ad.cuda-inc.com ([10.42.96.74]) by esg-scz1.cuda-inc.com with ESMTP id Eg41ORvWYPaHWkVO (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NO); Tue, 06 Apr 2021 09:35:41 -0700 (PDT)
X-Barracuda-Envelope-From: sthielemann@barracuda.com
X-ASG-Whitelist: Client
Received: from IP-SCZ1-EXCH01.ad.cuda-inc.com (10.42.96.74) by
 IP-SCZ1-EXCH01.ad.cuda-inc.com (10.42.96.74) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 6 Apr 2021 09:35:41 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 IP-SCZ1-EXCH01.ad.cuda-inc.com (10.42.96.74) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2 via Frontend Transport; Tue, 6 Apr 2021 09:35:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NOipG/4lan4MVXl6o5BTqh2RK9zOh3V3CtwfGiYl7Y9YtJozDm5ELuic/pSVjIP+tP2d7ho/Yhnf2M3QmSsdx//qvK5cSIFxObz6rMsFaAs8bsc8lBITDlzrfIa4zcR6NyTQdSJI+ZDsM8G1hHmxJVkYJ+4uiLP8yM25bK8ZKTmBbJV3sPXlMHN4Mc5ljbOExPmKOs4hb1+SvNwf6sayCRlLxld5ac6ljw++kIOxcgkuKkS+fNvJ8sujV7AlTSm8hgpbmxSqen5rGO/RpIF34/utR8huiN2/59jxRc7wbBqiBTW31PAX/o2c1MfyB943OtLgax5D+g3Wrs6iQoIP4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lvn/ZAzGKJAv7kQ5cjX2GnG1xHxy9okNoKRFHMX+z6g=;
 b=GJlkhCpbKsCWHpxvWytwJ1zMjWVglKYz7J5DWAbkvWK21mPbHlHvGMeNf82PVKVimltdxRdm3fiY0uaRaEdcsbxJfX8fQlPNTSX7ZsEwQednlCeuJr+6JmkbkFIj/jEiqGZi9f2EBypWXhIWIAj6D80UOn6Pqhh0aopDOn9u7iEevfNIYdFmLC+VMAl6KBmTxSPdu2fgcaeG00C49EcJtXDBzKtirPTdZUSl9QMEtq72uwU1Vyinr9OXJ1doIqjdNauDtW2MKLQCV538JdyKDTavx2ImUK5rB9Yg6hCyRwOil5odzyoQT1pjrbhyEEEjUi6s4dDOhYydUFYsK6WaYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=barracuda.com; dmarc=pass action=none
 header.from=barracuda.com; dkim=pass header.d=barracuda.com; arc=none
Received: from DM6PR10MB3833.namprd10.prod.outlook.com (2603:10b6:5:1d2::33)
 by DM6PR10MB2795.namprd10.prod.outlook.com (2603:10b6:5:70::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.32; Tue, 6 Apr
 2021 16:35:39 +0000
Received: from DM6PR10MB3833.namprd10.prod.outlook.com
 ([fe80::c60:b1cb:d94:f9b6]) by DM6PR10MB3833.namprd10.prod.outlook.com
 ([fe80::c60:b1cb:d94:f9b6%6]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 16:35:39 +0000
X-Barracuda-Effective-Source-IP: UNKNOWN[2603:10b6:5:70::21]
X-Barracuda-Apparent-Source-IP: 2603:10b6:5:70::21
From:   Seth Thielemann <sthielemann@barracuda.com>
To:     =?iso-8859-1?Q?Aur=E9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH cifs segfault ]
Thread-Topic: [PATCH cifs segfault ]
X-ASG-Orig-Subj: Re: [PATCH cifs segfault ]
Thread-Index: AQHXKt4/gcN4ypBJS06lRQOFN2ocFaqnjGsAgAAez1A=
Date:   Tue, 6 Apr 2021 16:35:39 +0000
Message-ID: <DM6PR10MB3833579F43D640A69C4A39F8A2769@DM6PR10MB3833.namprd10.prod.outlook.com>
References: <DM6PR10MB3833F0DD867BF1B48F60B99FA2769@DM6PR10MB3833.namprd10.prod.outlook.com>,<87eefn4hdt.fsf@suse.com>
In-Reply-To: <87eefn4hdt.fsf@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=barracuda.com;
x-originating-ip: [198.35.20.112]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6436fa1a-1524-4940-441a-08d8f91a035b
x-ms-traffictypediagnostic: DM6PR10MB2795:
x-microsoft-antispam-prvs: <DM6PR10MB27951C8BDF252B33EF08A6ECA2769@DM6PR10MB2795.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hg8r27JUbg7VAcj5aXvF81WDl8Gv7tUrfK9IA+LgmDKuCb2pCYpS3vF5XSDdDKc6ee5zqChpFItqN2000LKIf14ulOZqKYevrBMib9NRBv4yIy9ggCn+ijtdOxXkBVDfRY4aOOju97Bh9yBGHVeDnKL/rjLt0xo5v5QwhJJT0ritHy4GbCv8VRFpkkWoe+OkPtIcknnLudIJ6jvBMTWdD0cKXrO0H3Ts3hqyOg/nINlNt4MUSiliP1W8h6EsYJ/9Yhvt5PPmQHKZLiy6m/At6e5iwtJzlUqkeC9kChHZlpV3wtxGJNPTS/l2KkQCvKvkCvjwLDd4EPGQuvnX9BWI1hap4yRJWKHXTGuXT8ItPbMaNK1gMVlDjIUws1RgVjqAxsYPI1MaI25nDxX29u1sOzaUpXK39PsBICdCmahjGovoVUo+YeTDvf34ovw7Tpa77mk3Aii7qPp28hK3razuGElKH6n3z873KT0+hwhHqnQhPxcIaWLtgjqOzLervI+oe1ddpqbWznR9rry05V/IRGfNxz5Wfw0Plue7j4kCXh9/Wr96oVmfo6LU8yuVsVb/4Ebl6yOUG73km0sqWB1WPCoVI+cnHHNbQ1iU2y7R1cjb5RxyHX2+G3+WWYxMYnt/FhGbeu6LGtKLpQnwLVNpqikeLtdmB8hh9uysN/z8vUE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3833.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(136003)(366004)(396003)(346002)(376002)(33656002)(26005)(6506007)(53546011)(66446008)(52536014)(7696005)(2906002)(66556008)(478600001)(110136005)(64756008)(8676002)(316002)(55016002)(86362001)(9686003)(71200400001)(5660300002)(8936002)(186003)(66946007)(76116006)(66476007)(83380400001)(38100700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?j6cdCjdIo2j9aA21gVUtVDL4CzXGxZv1BjwGc6t6nxoEkfxqOu9GFFDHaN?=
 =?iso-8859-1?Q?e3AAjDuYpzCzEGX0Q7BOlezxdbzGrGMiHysF2V/IRbXIKhYjWjByDrKKkK?=
 =?iso-8859-1?Q?F6TTEXSToR10dGhMRHZ27/3GEK7Ijc3Dfes3GMnozf7HPGsT8wablSZ2Eq?=
 =?iso-8859-1?Q?K/6e2lYWwKJh9L08PNVTPc0pfZfGPLz+b+jrsvUWSyEjhJoLI+727ZfaTs?=
 =?iso-8859-1?Q?LPFMU4vQ0ap2Erelj6RODA6/k/XGegqDIE2OZHx/qHGsHg1GYGpb+T4voi?=
 =?iso-8859-1?Q?dt+luHvrZTzEL33EELpDFhfjbOYbHKVfAltDuJiQ5CH/CneFOaziOH3Qut?=
 =?iso-8859-1?Q?Pgd6/aWJd8CKMgQLustGyiWZquEtE/+n0GyNyNR0097L0cx8D+v03UwlLZ?=
 =?iso-8859-1?Q?HBThcXFisVbJMt5DMHFMkSH9iEZ9YkhdAu1mbr1BwUxvwYKcwha2Vf3qHJ?=
 =?iso-8859-1?Q?oj+vytzNy5htzXaVjsGeRIV28YTXx5Rw3apKcdyVysr++2cPra5W4Rylh2?=
 =?iso-8859-1?Q?RCuhFtDDhnSFMv7CICASXpj5Dlbm/IwRm9tv2Rr2FwpN9pPV7tM9Llh25h?=
 =?iso-8859-1?Q?UbpoP9DVbsCdqwNaNgIk4aucaFYwdUtjOaO8Hu3s7w9UnAfwws/TA/VVFq?=
 =?iso-8859-1?Q?dIIHqdZtdrHjx3z0UVlRwthGdGkcWfAU1K+GqvP6khux5/9wgCuIlvPVAF?=
 =?iso-8859-1?Q?4dbVlgSn5jRrDcKOKPp2NY75GN/4JoJOk6dBpvlw18hD/tJuDFCgC7+15k?=
 =?iso-8859-1?Q?9RPKJ38JkHXL+Exb+nnTjrndKFtZaP2GiS4T46o+3LKr3B37yyE0VkdmvL?=
 =?iso-8859-1?Q?0imAIksA7KL2n03Op5C0lQ482DXruWp/WKxKFL67zw3hkteSPvPMsX9179?=
 =?iso-8859-1?Q?p/nfOD+YxKoIvMUpg1ZVuGb1sLDsqgHjTfrPKv67vpXnLuuCFHudXaaEbr?=
 =?iso-8859-1?Q?t4ExLB4FzaTQWR/3766KCjJLX3OQex2pjY4oFxaeTNc/D/fQinGmU/qyBL?=
 =?iso-8859-1?Q?93hxksaNf9zq2PR4IUqAc+A+zP1LJMTr7W/hT8uAWKc7Jd7bn+cIEzb+XG?=
 =?iso-8859-1?Q?YAAeuKOrCDvUUoq7E//9H9rIE0lYwwqvSwXQK+if1jXWBqqbVh6z4UG4Gg?=
 =?iso-8859-1?Q?1EGgxRc87ZSzJGKvr9ae7qkVUSEmcuKXgIYq/SjFi3TWPHt6DmglN86QXo?=
 =?iso-8859-1?Q?3iNzW9r0VGranXnmc0+quDNAyUhfK4tZjCiT90VWcP2dwx2X7U++f1cxSt?=
 =?iso-8859-1?Q?gC4BwiFGhdpyZiET+SjYx0XWhSGSn8ns5kJeURy8QyuKK/44+eVaGDgj8R?=
 =?iso-8859-1?Q?Uv7MBNfUyuoRkF4Am2YiPdZxj5/t0T95uDBNIDJWsAfZ084=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3833.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6436fa1a-1524-4940-441a-08d8f91a035b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2021 16:35:39.2504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b893e0b8-2743-4fa7-81eb-0155a9060350
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6iAnyrz7JMgUOVMYHP8pm0N3rE9FNT0IoD7fw/jKJ1oY+15NS+Cm36WOzxAGLPzhPu1kBGRmMGlZr/3M7NF52BnOVOUBiNQhNgpq71Up3Xk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2795
X-OriginatorOrg: barracuda.com
X-Barracuda-Connect: UNKNOWN[10.42.96.74]
X-Barracuda-Start-Time: 1617726941
X-Barracuda-Encrypted: ECDHE-RSA-AES256-SHA384
X-Barracuda-URL: https://10.42.53.101:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at cuda-inc.com
X-Barracuda-Scan-Msg-Size: 3230
X-Barracuda-BRTS-Status: 1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Aurélien,


> From: Aurélien Aptel <aaptel@suse.com>
> Sent: Tuesday, April 6, 2021 10:28 AM
> To: Seth Thielemann <sthielemann@barracuda.com>; CIFS <linux-cifs@vger.kernel.org>
> Subject: Re: [PATCH cifs segfault ] 
>  
> Hi Seth,
> 
> Seth Thielemann <sthielemann@barracuda.com> writes:
> > - Observed segfaults during cifs share backups, core investigation and strace revealed that files were being opened
> >   but upon read the syscall was returning a 32-bit error code:
> 
> On my system (x86_64)
> - ssize_t is signed and long which is 8 bytes
> - int is signed and 4 bytes
> 
> That is a weird bug. Casting (long)-13 to int is ok because -13 is
> representable in both.
> 
> > - Above is an impossible situation, the sign extension was at fault. The two functions using the trinary assignment of rc
> > in the cifs asio context:
> 
> You mean this line in collect_uncached_write_data() right? I think the
> current code changed from your version, it's in a different function now.
> 
>         ctx->rc = (rc == 0) ? ctx->total_len : rc;
> 
  Right, the rc is a ssize_t in cifs_aio_ctx, this was found on a slightly older kernel, would like to see it fixed in mainline, just changed the original patch for updated kernel version.

> >    188db:       45 85 e4                test   r12d,r12d
> 
> Ok I'm assuming r12d is the rc var.
> we test if rc == 0 (low 32bit of r12)
> 
> >    188de:       44 89 e0                mov    eax,r12d   <- msl cleared
> 
> Now we set eax (low 32bits) to rc (what is msl? most significat l...?).
> But the high 32bits are unknown
  Right, the most significant long / double word gets cleared in the move, such that a few instructions down it gets stored as if it was a 32-bit / int but it's going into a 64-bit variable.

> 
> >    188e1:       0f 84 6a 01 00 00       je     18a51 <cifs_uncached_writev_complete+0x371>
> 
> if rc was zero, we take the jump
> 
>    188e7:       48 8b 7c 24 18          mov    rdi,QWORD PTR [rsp+0x18]
>    188ec:       49 89 85 a8 00 00 00    mov    QWORD PTR [r13+0xa8],rax <- saved
> 
> Otherwise we store rax (unknown high 32 bits + low 32bit of rc) in the ctx.
> 
> So -13 is
> 
>     0xfffffff3 (int)
> 
> but if you copy it in low part of a zero 64bits you end up with (wrong)
> 
>     0x00000000fffffff3 (long)
>     
> which is 4294967283... should have been 0xfffffffffffffff3
> 
> I'm no compiler expert but this looks like possible wrong generated
> code for the cast :/

  This definitely could be a bug with the compiler, I ran into issues adding some printk's and things just magically worked and then changed to adding asm volatile nop sentinel's to make sure I was looking at the correct sections. I still think it's a reasonable change to use the ssize_t since the rc is a ssize_t and the outbound syscall path is also a ssize_t. Best case scenario is a segfault in userspace (made things easier to track down), but will likely wind up with memory corruption otherwise.

Thanks,
Seth

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)

===========================================================
Get the 13 Email Threat Types eBook

https://www.barracuda.com/13-threats-report?utm_source=email_signature&utm_campaign=13tt&utm_medium=email&utm_content=13tt-ebook

DISCLAIMER:
This e-mail and any attachments to it contain confidential and proprietary material of Barracuda, its affiliates or agents, and is solely for the use of the intended recipient. Any review, use, disclosure, distribution or copying of this transmittal is prohibited except by or on behalf of the intended recipient. If you have received this transmittal in error, please notify the sender and destroy this e-mail and any attachments and all copies, whether electronic or printed.
===========================================================
