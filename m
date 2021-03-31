Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C007FC433ED
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Mar 2021 17:44:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B19C61041
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Mar 2021 17:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234381AbhCaRnd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Mar 2021 13:43:33 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:53774 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234139AbhCaRnC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 31 Mar 2021 13:43:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617212581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V6sQUKfPn3dLSmlg8XyRKxi1hpQzhVcIz0GHbDMda78=;
        b=itOVC2Gh9U4g5XmUaN/QEPVciOd9zTvpo1Lv7Njn5BFHHKQ7GX8H158fmiF4s6z2FihB/0
        EE8pVdFJN2fLz2hyh489FB7jQIy1sK8ILLK8ndN6zEKoBquKegoeraX3MsYJymHM/YdKXm
        lLVITyBMV3PuyPuQFSzo6f4S8Jwme/Y=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2169.outbound.protection.outlook.com [104.47.17.169])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-21--tgIDKdoM56JDZOnDApw9w-1; Wed, 31 Mar 2021 19:42:59 +0200
X-MC-Unique: -tgIDKdoM56JDZOnDApw9w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DAQDihuONpGqjQHGTNr5hI1WS7Pd50DcssphnLxw3GckRxAPICl5WAW+ba2RscRPlrPb1e/8Xdb2v4BWvOcC9yWLOSMJH+fm9PNNpWM65ZB5rUnHvbb92+4rJDsI4yGfQlIeTrZ705hGmWHmdP4GBDDyTSz1SxT5LbRBb7UnZII5RRfAR7LaZfH5Dh+qdNHsUoawT8ekOapqbwchWFsVrvI6WTGy7Of8GOOrh8Ef1qCOQrlvkl4OmizUxbC0F68fi2YHmVrHTFSipEdbvUBNAykU7sZCvGkVo0Tst6SdkCm41cTeyRk2NuhT15zxvIVczMDISXgW4pnWdRZTV7AdHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6sQUKfPn3dLSmlg8XyRKxi1hpQzhVcIz0GHbDMda78=;
 b=Bmv/HA8RkNpZL34ep0gM9NrkvIhGSsTbHl6nEkTS3A0pWyyTis8QD0PyXFOvwf1X2TUePnUa6WDogLO+Z/6Jnqe0fqERiTvLWzUDSmwHBPMEDsv0pBNopNqCXe2lq/JB4napEuZuPoNJWEV2U93R/RqmMZlZAqjX7ZJZJkbQ8WmZUmk0JS66CknH/ckPsNCj+5ybAs0/uiZdEEio1ochJgYRpiTWN9EdSl/PkqdCWuueM3FyJHFLfgQDpGwH7kdLwYI4b9grOlJBr3QC2RWT+1/Z5hbk/Kyx+LY6hUB3G8Bmx/o53O98kbDEY4979JZVeNDkl0oC9PufksZ8WtTngg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: uni-jena.de; dkim=none (message not signed)
 header.d=none;uni-jena.de; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR0401MB2399.eurprd04.prod.outlook.com (2603:10a6:800:25::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26; Wed, 31 Mar
 2021 17:42:58 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::3c87:7c9e:2597:4d94%5]) with mapi id 15.20.3999.027; Wed, 31 Mar 2021
 17:42:58 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Frank Loeffler <frank.loeffler@uni-jena.de>
Cc:     linux-cifs@vger.kernel.org
Subject: Re: specifying password when using krb5
In-Reply-To: <20210329170849.GD21718@topf.wg>
References: <20210327113252.GC8814@topf.wg> <87o8f2orjm.fsf@suse.com>
 <20210329170849.GD21718@topf.wg>
Date:   Wed, 31 Mar 2021 19:42:55 +0200
Message-ID: <874kgr5ie8.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:713:a710:b2c9:dd6d:f33e:57c5]
X-ClientProxiedBy: ZR0P278CA0135.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:40::14) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:713:a710:b2c9:dd6d:f33e:57c5) by ZR0P278CA0135.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:40::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Wed, 31 Mar 2021 17:42:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b89b0b28-55ad-42e5-d7ef-08d8f46c6be0
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2399:
X-Microsoft-Antispam-PRVS: <VI1PR0401MB23990E3F61C79A4564B50E4BA87C9@VI1PR0401MB2399.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b8IFPKvbRU7nMvz4GNwClPd4OGI4PjDok8RtYMPnzUuNfQQW3IrShiGTGpnv2KEH31kQMVhzjNVCjD7A6i+OgtFaaT42XLOxMW7iVo/K1UOOgsmQzR1Wh1r8DuWpiYkUNv07jiwE3WV4kJrCjCVIPGFytYBCYV/oktq5WiRk9OBCLjsPHbGsw5uhAqq5nE3ZzGGS91jexwk2NF8YC4YyfBOYgLhq39b6KHYoTNQIUnXtugjF64f2Oa9uQErWh8MVwxcqBFg1mvi7nrwbrVGZjKQZJcexHqqQsKPksBB4SBGCiAI6WEC5We+vMrhrSmvLl76QjEjQ3oAj4ig2rCwRn6h+T+2O03jJADTgf6uJ5Wn5txLSZOEG8AcKgT63iQmjMWje/JDVD8pRv92NKPvBNclBJ+tMBBQ5TTUWD6PDMzbcCizi8+YF5QVbP8neIFV1R2za7iWsWRvHStDxB/TxudHqfShwmrle7Sa/xJZszOokCv1bUR6iN/f3NteSk/Kry/gz9G5XzBKJQoVoaQTiGt0nKsGL1V8cRYWuOCWCIdnkRPaIQOF4SeMN8m+89ZcdMmKdrOMcu+9nYlfvHm9WoPsKdirFgIzkr9IsRmyQJXpGdk/svYEJXwKIxywLwlerVVfsDvK1dQJCtxd3AOeReKe02PAgYyqx95PcbyrSyGCrne9pvwY7R9GS417cJ8Zgwnwh3+RfDszuTuYrYZelZCWdy6IadDpjrEkUULPiF48=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39850400004)(136003)(366004)(346002)(396003)(4326008)(6486002)(66946007)(186003)(36756003)(38100700001)(52116002)(478600001)(6496006)(66476007)(66556008)(86362001)(16526019)(6916009)(66574015)(2616005)(8676002)(16799955002)(8936002)(5660300002)(2906002)(316002)(966005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZUlZMG1jOGdSeEhCaDY4SjVlZjZSaG1vY2FnUEdrTSs4SE1JMWNock5zYzN3?=
 =?utf-8?B?OFRXVVgwTUk4bmNmZ3EzNHdaTmhGdHIzV00vNHUrYkdXVFVlWllEK0tpVkVR?=
 =?utf-8?B?RXNZZ242SVVpVzZjcDJENDhCR1YvWk42NVdNTEVpbVRDZzhhN0NSM0FNdVBI?=
 =?utf-8?B?b1RRVzdaZnZXMzBGT0U3MEZIeUlpUFpHYjk0citWZ1ZRVHNCWDNmd2FJS2dV?=
 =?utf-8?B?a3lFbXZBa2lyblZBamtFSFpMRkFSK2tJbjdJb3Fsc2x5bE00SWxYRUtjcGxH?=
 =?utf-8?B?Rks4bGpGWDNjdi9DbTdRa25RSlpVVWg4M1dBMDZCU1FETEdPcndPN1JJbWVv?=
 =?utf-8?B?cDRHUHcrWmVLSk9YUFdTY2dSSTlSMTA2ODVnOXdvMUpYbEFKaW15QlhRZWM0?=
 =?utf-8?B?emFwSDdjaUVyRHpTOWFURHl5NngxUS9ZTkI1Mk9YNmUyaUJQTUZuSXNRY2pI?=
 =?utf-8?B?TDlSRkh3ZnFDNlVRNGZtY2M0aytma0ZyREczR29NY0FFYUkxcThOS2MzOW5z?=
 =?utf-8?B?SjZudXJKY1RHdFBZNjNkM3BKdHhrNk9ZRXZzR3U2WjVmQW9jRmEramJlSkhH?=
 =?utf-8?B?dldJaWIwU0tIWjlsc3kzbWpOTDhydmpTYlBPNDR0czJCSG5zMTdVWjRUVU9T?=
 =?utf-8?B?b2N0QnhoL1RsM2FBZWFEQTZJNk95d3RTZVM2c0tUT0FKc25UcEFkbGpETnJ6?=
 =?utf-8?B?bVROTjJ3YVNkbFdrNVF0WDRaU2kveERIbXo3MGF1OTVCNXFOQlhscjN0UXc4?=
 =?utf-8?B?VytoSTZIU3d2dU1iSVJaNFYvM2x4L3cyODRPa0Nlekg5TGdNRXIvUk01OEJK?=
 =?utf-8?B?bnh6aWZ3YnRsTlg5VlVocFBjUnRkeThQakpBZzRKWTVYbkpvaGFjaUZUc2pT?=
 =?utf-8?B?bzhGQzBJcS9SY3FmMDY0NHZKWEtsYmZQb2hrYlZzeU1oZjJlMEk2cWg3VFRC?=
 =?utf-8?B?TlhHQjBrMnVuZzBoWTJzMFRmVzcwbnQ3djNGODJta2FISzhmN0VveG92Q1pE?=
 =?utf-8?B?Z3V5U2d5Qk5MRkJBUDdPMWdZSmNVc2ZyOXIxa1R5MzZWWTlDWXNISzcvc0dr?=
 =?utf-8?B?QlpRejJxdkJFS08vWXBhWEd0YUdnc1dnMlFLcnJ3QmxRZ1J2cmR5WnhBeFZp?=
 =?utf-8?B?UVRvZ2pWK0wvVGJIR2JGczZNdGhRdkJMdVp5NVBnOWs5ZkZENVVGNG9zZXJS?=
 =?utf-8?B?MGFiajdmanpQM2JjL0hKNlpDQlplQlF2azhiMkRmem5YaG9McUhRZ0JYOHRj?=
 =?utf-8?B?OWgvVEprYU5yYThYWkhMbElkM3ZQWWIweDUwYmQxTndNaExmeEpBNGcvZG00?=
 =?utf-8?B?eWo2QzkrVWtyMWJKRGlITW1uOUNOOUkvZEdEQVljYnNaeHpjMVBHOTQzRzIw?=
 =?utf-8?B?a3BXanppZmZHU08wM0J3bmMxWnpKY2FURnZoSkJXekVzWHFwVmgvUWJHTGNC?=
 =?utf-8?B?MndCMExzTFE5V1JCY2kxMEdZQXZvcGo0d2FqcFFmZ2tMWUtkcDVrQ0t0Yk9k?=
 =?utf-8?B?S2E1UjYwRU96ZUJhZGZvR0JheVRXUlhYSGVCUEhwZ0NoN0hlQkpHSmpsVGJj?=
 =?utf-8?B?Z05LK09Vb2preTlrQnFHSkcvZGNycXpHSFZKN3B1ZDB2NjYvTTRpamNiU3dU?=
 =?utf-8?B?Vzlpc2NiaWF3d2YwcisvY0huWGxLM0d1UDVkRW8xV1JpTVpuQU9za0pQNkxM?=
 =?utf-8?B?dDhvUzhYU20vdnA3dzlzVE5jSHIxYmhmN0JwYmwxTktDa3NVWFF4L2h0T2hl?=
 =?utf-8?B?MEJRRGNobXczZU1zUHNVRi9tVUd5OW5VN09aQWpuR2l1eGsrbzl1Q0VLUXVE?=
 =?utf-8?B?Mnl5Yi9kZklOUXd4MnZhMFdOenB6Z3FnTmdDQllkc2hTVENPVVBlRHpROFRt?=
 =?utf-8?Q?N4bZQRvEi1yzM?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b89b0b28-55ad-42e5-d7ef-08d8f46c6be0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 17:42:58.0785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vWyMAeqhLjEVYBgnVE30qbIcFuIX+QrVPRtGyX2lTfJ5qjt8qOiqhN6dEiy4pPcK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2399
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Frank Loeffler <frank.loeffler@uni-jena.de> writes:
> As far as I understand, you (can) use a password to obtain a krb5-token,=
=20
> which is then used for sec=3Dkrb5. From a users point of view, you enter=
=20
> username and password and get access. Whether this is using krb5 and a=20
> token or some other mechanism is usually something a user doesn't even=20
> want to know about. What they know is a username/password combination=20
> and a share name on some remote machine.
> If the mechanism happens to be krb5 (isn't that even the default on=20
> Windows shares?), you might need a temporary token, but I wonder if =20
> that "technicality" couldn't be made transparent to the user by default.=
=20
> This would make mounting Windows shares a lot less 'messy' to users.

Yes, from the user point of view, both NTLM and KRB use
username/password pair. But in Linux, KRB is a complex system-wide
service separate from the kernel, cifs-utils or samba. It is its own
project and it requires a /etc/krb5.conf file, proper DNS settings,
kinit/klist/... tools etc.

All we can do from cifs-utils is expect those to already be in
place. Configuring KRB on-the-fly is out of the scope of cifs-utils.

> That is unfortunate. However, not even verbose mounting gave me any=20
> indication of what it was that is actually failing. Maybe, before=20
> returning ENOENT, cifs you print something else, possibly at least with
> high verbosity/debugging enabled.

Do you mean verbose by mounting with -v? If yes, as I said when the
mount.cifs program calls the mount() syscall, the kernel can only return
a single generic integer code. The mount program cannot tell you much
because it doesn't know much. When it mounts with KRB, it just passes
sec=3Dkrb5 to the kernel. The kernel tries to connect and later on call
back userspace (yes, kernel calls userspace, its called "upcalling")
program cifs.upcall, which is responsible for finding the krb
tickets. That program cannot print to your console, all its logging goes
to the syslog. That's why you cannot see much from the mount program.

You can read cifs.upcall logs in your system logs, probably with the
journalctl command.

If you actually want verbosity _from the kernel_ you need to do those
steps:

https://wiki.samba.org/index.php/Bug_Reporting#cifs.ko

You will then find more information after calling mount by looking at
the kernel log via the dmesg command.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

