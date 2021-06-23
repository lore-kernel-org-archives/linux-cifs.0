Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A3BAC4743C
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 04:01:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEF846135A
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 04:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhFWEDp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Jun 2021 00:03:45 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:49723 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhFWEDo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Jun 2021 00:03:44 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210623040126epoutp02e02c98ce983eb56ef348510fff705028~LGjB_Oevp1939319393epoutp02h
        for <linux-cifs@vger.kernel.org>; Wed, 23 Jun 2021 04:01:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210623040126epoutp02e02c98ce983eb56ef348510fff705028~LGjB_Oevp1939319393epoutp02h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624420886;
        bh=5PVFU6ULDmRmj4Yre3X/Pn6O0VQfnzl9i1rorA3ArU4=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=mZLO7r0uWjlvdXg0RPA7hr8hszwsXqzf2of8ib8SGZ/oBH48VkyTgPP3iqRq98sPA
         7MueOqey1Vou5w4T8YXgfHXH1OKA7oy1cX8Z3Widvue8q9QI9mlZ72zivW8w7FH5VO
         Jx+01JwzLdg14EJh/JS+UhqLWfztKNJprDaeS6Bk=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20210623040125epcas1p4f281addb37ea5634dc1cce0363294657~LGjBjaP-S0698606986epcas1p4M;
        Wed, 23 Jun 2021 04:01:25 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.164]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4G8qM85YWsz4x9Px; Wed, 23 Jun
        2021 04:01:24 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C1.3C.09551.412B2D06; Wed, 23 Jun 2021 13:01:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210623040124epcas1p1fbbc1a57a729991c45e496142d489222~LGjAN_Yca3217232172epcas1p1-;
        Wed, 23 Jun 2021 04:01:24 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210623040124epsmtrp2552920e4c6b370b9842bbf5393f2b028~LGjANKzRp0602206022epsmtrp2b;
        Wed, 23 Jun 2021 04:01:24 +0000 (GMT)
X-AuditID: b6c32a36-2b3ff7000000254f-ee-60d2b214e907
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E4.A4.08289.412B2D06; Wed, 23 Jun 2021 13:01:24 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210623040124epsmtip152f2e830417267ab6f85cd68d1124380~LGi-_jYsa0437804378epsmtip15;
        Wed, 23 Jun 2021 04:01:24 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Steve French'" <smfrench@gmail.com>
Cc:     =?utf-8?Q?'Aur=C3=A9lien_Aptel'?= <aurelien.aptel@gmail.com>,
        "'Christoph Hellwig'" <hch@infradead.org>,
        "'COMMON INTERNET FILE SYSTEM SERVER'" 
        <linux-cifsd-devel@lists.sourceforge.net>,
        "'CIFS'" <linux-cifs@vger.kernel.org>,
        "'ronnie sahlberg'" <ronniesahlberg@gmail.com>
In-Reply-To: <CAH2r5msB8Y8qn+DFV=3g=K791p1ssFJh=+yNOC4bG8iW3K07tw@mail.gmail.com>
Subject: RE: ksmbd mailing list
Date:   Wed, 23 Jun 2021 13:01:23 +0900
Message-ID: <007101d767e4$6edb4ff0$4c91efd0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQKEoK/ucUJhU+AlUKRaTDLvHCKH0wHZDfPRAiUqc4MCZCxSvwDYIZrJAdymPOepfc1SgA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphk+LIzCtJLcpLzFFi42LZdlhTT1dk06UEgxU3NSyOv/7LbnF6wiIm
        ixf/dzFb/Pz/ndGit+8Tq8WbF4fZHNg8ds66y+6xeYWWx+4Fn5k8Pm+SC2CJyrHJSE1MSS1S
        SM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqtpFCWmFMKFApILC5W
        0rezKcovLUlVyMgvLrFVSi1IySkwNCjQK07MLS7NS9dLzs+1MjQwMDIFqkzIydh1dyNrQZtA
        Rc+0t+wNjI/4uhg5OCQETCRefErsYuTiEBLYwSjx8f8mZgjnE6PE5J/nGSGcz4wSsw9MZO1i
        5ATrWLtlGztEYhejxKPJ76GqXjBK9Dz4zghSxSagK/Hvz342EFtEQFPize5JYHOZBWYxSdx/
        0MwOkuAUCJTYtuQd2FhhAXmJVYcbmEBsFgFVibV3e8BqeAUsJQ6tXcsKYQtKnJz5hAXEZhbQ
        lli28DUzxEkKEj+fLmOFiItIzO5sYwZ5TkQgTGJuqxrIXgmBVg6J5tlLoV5wkVh3u5cRwhaW
        eHV8CzuELSXx+d1eNgi7XOLEyV9MEHaNxIZ5+9ghAWYs0fOiBMRkBvpr/S59iApFiZ2/5zJC
        XMAn8e5rDytENa9ER5sQRImqRN+lw1ADpSW62j+wT2BUmoXkr1lI/pqF5JdZCMsWMLKsYhRL
        LSjOTU8tNiwwQo7rTYzgZKlltoNx0tsPeocYmTgYDzFKcDArifA+armUIMSbklhZlVqUH19U
        mpNafIjRFBjSE5mlRJPzgek6ryTe0NTI2NjYwsTM3MzUWEmcdyfboQQhgfTEktTs1NSC1CKY
        PiYOTqkGpmm568O+ZdVuunlJZvrCXVp+0WuNs6c26IWuOnsrWfPm/z/td6T+/jod72m+PqJy
        6+qg6MBv2ZWT9G9sLnwy+9S+XLYHLza8nz6PWSz76NIz4m8ur9U89FD3xvHPuQVLl4j+u6Br
        8oxnRqKlv9xTz8Iugf6cZMHYE5VieRcWBn0Okvrw2+TviQ1vuFs0mzeuZTyg2xnqPN9eYvKG
        6SyPnz7PEtzfODvtnN/RXOVEic3WkbHyOhkBN/aXeYcdFtmd8DD+1I97CnoLOp8+fs8vXszg
        ULQlwyVOTS3kVcwLrqbXafPez0hK73tq/fzxrSyNzR1OLdpymzI/bvGVvLTsUbqH5KzCtdw7
        e/V6tnw/9VmJpTgj0VCLuag4EQCIuv2CHwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWy7bCSnK7IpksJBnMesVscf/2X3eL0hEVM
        Fi/+72K2+Pn/O6NFb98nVos3Lw6zObB57Jx1l91j8wotj90LPjN5fN4kF8ASxWWTkpqTWZZa
        pG+XwJWxeqJsQRdPxc++TywNjGs5uxg5OSQETCTWbtnG3sXIxSEksINR4tCsm6wQCWmJYyfO
        MHcxcgDZwhKHDxdD1DxjlDj8+j4LSA2bgK7Evz/72UBsEQFNiTe7JzGDFDELzGGS+Ln4FVhC
        SGAnk8SxhgIQm1MgUGLbkndgC4QF5CVWHW5gArFZBFQl1t7tYQexeQUsJQ6tXcsKYQtKnJz5
        BGwZs4C2xNObT+HsZQtfM0McqiDx8+kyVoi4iMTszjawo0UEwiTmtqpNYBSehWTSLCSTZiGZ
        NAtJ9wJGllWMkqkFxbnpucWGBUZ5qeV6xYm5xaV56XrJ+bmbGMFRo6W1g3HPqg96hxiZOBgP
        MUpwMCuJ8D5quZQgxJuSWFmVWpQfX1Sak1p8iFGag0VJnPdC18l4IYH0xJLU7NTUgtQimCwT
        B6dUAxPv0ZXFhi93d79eeqx9dhazrYv1ifoKRZb8evN9N8rsmT4FKXCpVbbufb+7e8kVQe7f
        TKFzMtZeCl+gaX/K4VnfpaUHjBdsjTC+bd2c2aMVwS7Yrr707cP/D7aU1Jtc8JmSylReZOy2
        udG4McotIiEqt+6X6Ur/jQdyV8sL2Z0qF+Tb7Wt7purSGfe7D6QyxKSt126Y1C+86M2Lx0Kb
        T2lftL74lPvkIzU5z8JTzJpfPFa6Z6cJztR/dGBZcV/jp6S2iluRV5i3zD2w8DFnilXIa0/1
        cIfXmnfNo7Zt1d66KSG2UnrjvEtWHr3L0pyabuSl5m0MKzDa6fXi2eoZBqpf5xk+/f6GifHb
        bpcDl5VYijMSDbWYi4oTAVH+9koJAwAA
X-CMS-MailID: 20210623040124epcas1p1fbbc1a57a729991c45e496142d489222
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210622061228epcas1p247d557ef24a971eaf395edd6174bed5e
References: <CGME20210622061228epcas1p247d557ef24a971eaf395edd6174bed5e@epcas1p2.samsung.com>
        <YNF/OpvdMLbIDZiZ@infradead.org>
        <013001d76734$0cf3bee0$26db3ca0$@samsung.com> <87mtriqj6v.fsf@suse.com>
        <006501d767d9$361eeec0$a25ccc40$@samsung.com>
        <CAH2r5msB8Y8qn+DFV=3g=K791p1ssFJh=+yNOC4bG8iW3K07tw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> We should probably put a few lines in the cifsd and cifs client wiki page=
s on samba.org and also in
> the kernel documentation directory for each that notes that emails with p=
atches should have a prefix
> that indicates whether server or client or utils (e.g. =5Bcifsd=5D or =5B=
ksmbd=5D if you prefer, =5Bcifs=5D for
> the client and =5Bcifs-utils=5D for the tools)
Okay, I will update it in wiki and kernel documentation.

Thanks=21
>=20
> On Tue, Jun 22, 2021 at 9:41 PM Namjae Jeon <namjae.jeon=40samsung.com> w=
rote:
> >
> > > =22Namjae Jeon=22 <namjae.jeon=40samsung.com> writes:
> > > > Add CC: Steve, Ronnie, Aur=C3=A9lien.=0D=0A>=20>=20>=20>=20Any=20op=
inions?=0D=0A>=20>=20>=0D=0A>=20>=20>=20I=20think=20having=20only=20one=20l=
ist=20would=20be=20nice=20too,=20but=20we=20should=0D=0A>=20>=20>=20ask/doc=
ument=20to=20put=20a=20=5Bcifsd=5D=20tag=20somewhere=20in=20the=20subject,=
=20which=20is=20hard=20to=20enforce.=0D=0A>=20>=20>=0D=0A>=20>=20>=20Case=
=20in=20point,=20it=20already=20gets=20confusing=20when=20people=20send=20p=
atches=0D=0A>=20>=20>=20for=0D=0A>=20>=20>=20cifs-utils:=20we=20can't=20alw=
ays=20tell=20it's=20not=20for=20the=20kernel=20from=20the=0D=0A>=20>=20>=20=
subject=20which=20can=20confuse=20people=20and=20scripts.=0D=0A>=20>=20Than=
ks=20for=20your=20opinion=21=0D=0A>=20>=20I=20will=20change=20to=20specify=
=20single=20list(linux-cifs=40vger.kernel.org)=20in=20MAINTAINERS.=0D=0A>=
=20>=0D=0A>=20>=20>=20Cheers,=0D=0A>=20>=20>=20--=0D=0A>=20>=20>=20Aur=C3=
=A9lien=20Aptel=20/=20SUSE=20Labs=20Samba=20Team=0D=0A>=20>=20>=20GPG:=2018=
39=20CB5F=209F5B=20FB9B=20AA97=20=208C99=2003C8=20A49B=20521B=20D5D3=20SUSE=
=0D=0A>=20>=20>=20Software=20Solutions=20Germany=20GmbH,=20Maxfeldstr.=205,=
=2090409=20N=C3=BCrnberg,=20DE=0D=0A>=20>=20>=20GF:=20Felix=20Imend=C3=B6rf=
fer,=20Mary=20Higgins,=20Sri=20Rasiah=20HRB=20247165=20(AG=0D=0A>=20>=20>=
=20M=C3=BCnchen)=0D=0A>=20>=0D=0A>=20>=0D=0A>=20=0D=0A>=20=0D=0A>=20--=0D=
=0A>=20Thanks,=0D=0A>=20=0D=0A>=20Steve=0D=0A=0D=0A
