Return-Path: <SRS0=9w6c=D5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09ECFC388F2
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Oct 2020 11:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88B76208B6
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Oct 2020 11:37:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="FHb2u79q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2444547AbgJVLhX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Oct 2020 07:37:23 -0400
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:55117 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2444409AbgJVLhX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 22 Oct 2020 07:37:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1603366640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tqHLJJIzST18v9/q7u+MkgDwY/Vo6eeYgnN/nwG0Fuk=;
        b=FHb2u79q9+NZCUTqk9ScxYgfOHjTIStH1IffA/DWAfblkGlbDmEVfuRr0pA/5JDLXkVnPz
        V5Q30PB4kMF1nGXrLRP9UmPTXCEUYsf9rXX1DhFr4FoTtHMde5r5ep3Zz6rEf+r37LBvI+
        VnM1adkvY7klogwV4Iqmbx4XAP96l38=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2104.outbound.protection.outlook.com [104.47.18.104])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-11-KUmTKig4O7mz5o6Zerr1jg-1; Thu, 22 Oct 2020 13:37:18 +0200
X-MC-Unique: KUmTKig4O7mz5o6Zerr1jg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tct74mRYgFboSU5GD+/KQ2KpABwKBoqaK5XEyqNZOo485zdhpYdXQJJE+o/tqUYKK4Rwo0+wt8ZXwzwae+1b+XVbHgqmoVdeWv9d6YoX7omhEwzp/tM6t5peiAlxB7RE9INTptf7HugG3XTNJipw4ePMAzmxvdZhsGp8xVzrYuWVDIljpmkUnB4hBkWris6mUo/rfQFAVD9BB6RylXgM2tD9PL1EOt+MEQZWYhmJhOklGyqnNNSW9SSv0S6BGNEqV2ig+TxBdb0Gf4HVxXSWd11zB6BiPEN7O9Af/gCsPGqmGks1NWeLYFwnKU6pxm+1RJygWpvseK5kHnTgLcqBJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tqHLJJIzST18v9/q7u+MkgDwY/Vo6eeYgnN/nwG0Fuk=;
 b=jrWKcLY8KS83AMCJmRGQIXa2282O771ZZU/3n8YQdN+wQ2UO6jpnVu52iTq9GUg0xeEpUyykovTRTH07YqX58SIbPbJ+xbj/SiT6o5oV4tK9wiqbsbNOjGrJqimtBfyrg9l4xAPMITxcbndsJJNJ0ISMZD7yRhUPkoifniuK3gssmH7c7HqR5KPSB2fF59IRCYSts+RKQYd2K+y3NBlyGRnGp7NLgYsgvon3ZecFWvSieGRtUQMXUw19OgXLSnDif0kJXVWmi9ncWcejWT9Rm3y0c0HrewE4msBXHDpwqnoT7t7JeYUFKjJ2bJSicHiZIN8rG3X9dL6fMQrqo4oYoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com (2603:10a6:803:3::28)
 by VI1PR04MB7071.eurprd04.prod.outlook.com (2603:10a6:800:128::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28; Thu, 22 Oct
 2020 11:37:17 +0000
Received: from VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::e01c:2732:554a:608e]) by VI1PR0402MB3359.eurprd04.prod.outlook.com
 ([fe80::e01c:2732:554a:608e%6]) with mapi id 15.20.3499.018; Thu, 22 Oct 2020
 11:37:17 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Subject: Re: [PATCH][WIP] query smb3 reparse tags for special files
In-Reply-To: <CAH2r5mtmPxUKYYK-PbouTFpt9T8AU-41pRZu1CEO=+XLZZ+vSA@mail.gmail.com>
References: <CAH2r5mtmPxUKYYK-PbouTFpt9T8AU-41pRZu1CEO=+XLZZ+vSA@mail.gmail.com>
Date:   Thu, 22 Oct 2020 13:37:15 +0200
Message-ID: <87wnziv6dw.fsf@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [2003:fa:705:6807:8347:7696:25d3:a22f]
X-ClientProxiedBy: FR2P281CA0025.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::12) To VI1PR0402MB3359.eurprd04.prod.outlook.com
 (2603:10a6:803:3::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2003:fa:705:6807:8347:7696:25d3:a22f) by FR2P281CA0025.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.8 via Frontend Transport; Thu, 22 Oct 2020 11:37:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81ee2366-a249-4041-4f82-08d8767ed440
X-MS-TrafficTypeDiagnostic: VI1PR04MB7071:
X-Microsoft-Antispam-PRVS: <VI1PR04MB70719A093D0A5D66FCBF7C3DA81D0@VI1PR04MB7071.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qt7yFs5usP+t7f9gCdwzNPS+RcGtja86ZjY0o9DLM46rPDqYQwuchBOeFjOKNjEvM1cPuUiXvRYkrJYPDUVCwWMD3j3KtTjjGRGaWX28J/3tnTxQ1sRcGytoHif8LwIxjyQPYSGLODZCBPWC8IsM9N63UwIB5wYggruSIe9pWJbYWV6f7J3ge3Y0FbebD+ZzMs1JjquvB3O+u8AgYt3IVIUhL5krM8bm3AbLycG1FDJj2cKs/bpXRNIidfpd6Y441LXf1csRdCCXOf/XXvmAkfgmGQiivDeRfS/fzqBOKJg1B9TPBLmkQnpygoQA4m4HpLuGpde7hAeprOsiCMeDzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3359.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(136003)(39860400002)(366004)(16526019)(66946007)(110136005)(478600001)(2616005)(186003)(66574015)(66556008)(316002)(83380400001)(66476007)(52116002)(36756003)(6496006)(2906002)(8676002)(8936002)(5660300002)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YWORHVlWbyyz7jNVbh8UiJDJ76i+nu9Rw4jEe8tmZyenokB05weBrPCoJ/BNIDwLqikT8TGeHlS2ra8m6Sb/WzrKAAkUdUSKogIgz9Fd1AE2Vyfz3tzXetT48Mip1QsV9c8Quy0szPsbcI8U/8w58QyS+RGukhAztOFygKKTqYTPuytOwgP+5rWtT+g0TjE6dFZS6nqic03DHg+h3y1CQPC0jgOJCzIIi8MIm/rm8GLA1eFdyqlpZb1b9cS7E5KCBKDB7ftzi7NI40PejdRh2F77vGJSK1Nnk4xqxmFhu58pmUgAEF2k+19VWFCoMJE3u+JTGTpbTOdBdNOVUlC8BnQmCfD6GanQrkJeIx3GOj3ZaEXnuqkaCJRnH+S+DVC6i9nLjrsOiMSgG27b+D/KwsNQpwdpzM4icZgmJyxXMIuU0UQFRD9hBwKxMRieQxgKHnrfqAp2nu2nETqbtqmOBzQCKgELSiTY2vKDJBU5MLEL4EUfd2iLxcQsdHTG4VJi2d4q/9CH0y9xTnPC9yMMxTBxz+hO7eIBb1UmH8B8QakBAW2YasqxE8AveDibk/XZzggHcVGLxM7VFSyT9ewdQ1YmHDtRuxX5f4IZaqGJIuo/ITtyTy1ABHqc3OlLD7TCiFX2CVbk2iHGCzbQ+gk0ePP8dGPlqcISKSzTSkTAWSvHpWkktVT1gtmczn2Ud3uRoibWlEk1l5uMCdpOMRukmQ==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ee2366-a249-4041-4f82-08d8767ed440
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3359.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2020 11:37:17.4165
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: crQ8bv8cX/N0p/y/i+gx0zBsdH6kGoRjqaYm8+PxQYMBVCp2Er7LISHvsptMbIAP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7071
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:
> smbfsctl.h:#define IO_REPARSE_TAG_LX_SYMLINK    0xA000001D
> smbfsctl.h:#define IO_REPARSE_TAG_LX_FIFO            0x80000024
> smbfsctl.h:#define IO_REPARSE_TAG_LX_CHR             0x80000025
> smbfsctl.h:#define IO_REPARSE_TAG_LX_BLK             0x80000026
>
> These also make sense for us to use more broadly because it simplifies re=
addir
>
> but ... my first attempt at querying this using infolevel 33
> FileReparsePointInformation (see MS-FSCC section 2.4.35) failed ...
> with Windows 10 returning STATUS_NOT_SUPPORTED when querying various
> reparse points (created by WSL indirectly) including fifos, symlinks
> and char devices.
>
> I can switch approaches and try to do the smb3 fsctl to query reparse
> info instead but was hoping that query info would work.  Any idea if
> there is another info level that would allow me to query the tag?

According to [MS-FSCC] if the file has the REPARSE_TAG attribute, the
EaSize field must be interpreted as a reparse tag for these info levels:

* FileFullDirectoryInfo
* FileBothDirectoryInfo
* FileIdFullDirectoryInfo
* FileIdBothDirectoryInfo

Otherwise we have code for querying the reparse tag in
smb2_query_symlink():

	rc =3D SMB2_ioctl_init(tcon, server,
			     &rqst[1], fid.persistent_fid,
			     fid.volatile_fid, FSCTL_GET_REPARSE_POINT,
			     true /* is_fctl */, NULL, 0,
			     CIFSMaxBufSize -
			     MAX_SMB2_CREATE_RESPONSE_SIZE -
			     MAX_SMB2_CLOSE_RESPONSE_SIZE);

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, D=
E
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)

