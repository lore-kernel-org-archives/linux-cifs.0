Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB776C2B9F4
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 06:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 870BB6134F
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 06:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbhFVHBJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 03:01:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59678 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhFVHBI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Jun 2021 03:01:08 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210622065850epoutp0125e48a4307c7d6c417224c748931df2f~K1Uo8jjJF2698926989epoutp01Q
        for <linux-cifs@vger.kernel.org>; Tue, 22 Jun 2021 06:58:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210622065850epoutp0125e48a4307c7d6c417224c748931df2f~K1Uo8jjJF2698926989epoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624345130;
        bh=Bw5+O3/xXOto7iw7au7o8ZqYAh4miTafJeRe+zkanZs=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=OQ+SNkWp4RE83x9y6Ni+73kZzATLJIE0RRd/bQK50yF/WpZ4bAguZbGDw8ZnzGx1L
         xVnuWTtXadjOhQzPWaxzhcXbWepKyMo9tl4Wj7l9JPUxMRXqAO6tju0s1hDUAsClhY
         NvM5lkGNJnq8BTGy2K8O7782TLsAH0fNW8bQ9s08=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210622065850epcas1p1c38a27021c7c260047e0e1203ab09a25~K1Uoi7qFv2712827128epcas1p1z;
        Tue, 22 Jun 2021 06:58:50 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.166]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4G8HLJ6kP9z4x9QK; Tue, 22 Jun
        2021 06:58:48 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A8.2E.09551.82A81D06; Tue, 22 Jun 2021 15:58:48 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210622065848epcas1p15b875ef993bc987755a5ef8abc055024~K1UnHuYmn2712827128epcas1p1o;
        Tue, 22 Jun 2021 06:58:48 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210622065848epsmtrp156d6edea4a5f871e2244aaf67341a726~K1UnG6y_N0537105371epsmtrp1f;
        Tue, 22 Jun 2021 06:58:48 +0000 (GMT)
X-AuditID: b6c32a36-2c9ff7000000254f-55-60d18a287c3a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E8.03.08289.82A81D06; Tue, 22 Jun 2021 15:58:48 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210622065848epsmtip2b25b2d404437f3a74fd94cf7c1f1c0d3~K1Um4mkAh3189031890epsmtip2I;
        Tue, 22 Jun 2021 06:58:48 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Christoph Hellwig'" <hch@infradead.org>
Cc:     <linux-cifsd-devel@lists.sourceforge.net>,
        <linux-cifs@vger.kernel.org>,
        "'Steve French'" <smfrench@gmail.com>,
        "'ronnie sahlberg'" <ronniesahlberg@gmail.com>,
        <aurelien.aptel@gmail.com>
In-Reply-To: <YNF/OpvdMLbIDZiZ@infradead.org>
Subject: RE: ksmbd mailing list
Date:   Tue, 22 Jun 2021 15:58:48 +0900
Message-ID: <013001d76734$0cf3bee0$26db3ca0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKEoK/ucUJhU+AlUKRaTDLvHCKH0wHZDfPRqbZTPSA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsWy7bCmvq5G18UEg52TTCyOv/7LbnF6wiIm
        ixf/dzFb/Pz/ndGit+8Tq8WbF4fZHNg8ds66y+6xeYWWx+4Fn5k8Pm+SC2CJyrHJSE1MSS1S
        SM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqtpFCWmFMKFApILC5W
        0rezKcovLUlVyMgvLrFVSi1IySkwNCjQK07MLS7NS9dLzs+1MjQwMDIFqkzIydhxZyl7wRvm
        is79G5kaGCcydzFyckgImEgcnLSNvYuRi0NIYAejxP0lS1kgnE+MEhM3djBBOJ8ZJbZOPcQG
        07Jy5m5WiMQuRomz9yYxQzgvgFp2HgWrYhPQlfj3Zz+YLQJkn134ghGkiFngEKPEuqn/wRKc
        QImm061MILawgLzEqsMNYDaLgKrEzUerwWxeAUuJe+dXMkLYghInZz5hAbGZBfQkbkydwgZh
        a0ssW/ga6iMFiZ9Pl7FCLLaSeD1jKyNEjYjE7M42sEslBFo5JI4fhEhICLhI7Hv4khXCFpZ4
        dXwLO4QtJfGyvw3KLpc4cfIXE4RdI7Fh3j6gOAeQbSzR86IEIqwosfP3XKhdfBLvvvawQpTw
        SnS0CUGUqEr0XToMNUVaoqv9A/sERqVZSD6bheSzWUg+m4XkgwWMLKsYxVILinPTU4sNC4yQ
        43sTIzhpapntYJz09oPeIUYmDkZggHMwK4nwvsi+mCDEm5JYWZValB9fVJqTWnyI0RQY2BOZ
        pUST84FpO68k3tDUyNjY2MLEzNzM1FhJnHcn26EEIYH0xJLU7NTUgtQimD4mDk6pBiZ2O611
        cyMcFbxPrBHIMowQbxO9EZN65Fq8pfc7pu0hpy3L/xhF1G98v+yc0/Kcz61Mn73MpQ46Z/S0
        THPY/cM4X2aZ9/qA1793RjEvumTyPzuvUl63hvtEzrPCjaINL45UM0zJ0Dl6clvOobsqc+pP
        1Za/zzCwrmcwavy8ZM3TdPalAr5SOvXbNDg7pJfeW+bb76L5J1Rc+BlPz8sU71sKz5cKXF8Q
        njPh8e9VH7/tKxHcE+nldOXtLbW/3Z/ED/K3tqyZp/V2a8iD96nMHfFfz6oKWpi+e7WDhePz
        tgw27TkrHoYtNMuY01lh2qpR0MY4b+Wrg/wqtcIpu/gOCL013yZw9OIHr6JdZtsfLVZiKc5I
        NNRiLipOBACVvJAuIwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWy7bCSvK5G18UEg9a7YhbHX/9ltzg9YRGT
        xYv/u5gtfv7/zmjR2/eJ1eLNi8NsDmweO2fdZffYvELLY/eCz0wenzfJBbBEcdmkpOZklqUW
        6dslcGX8uetQcJ654mHTJPYGxrdMXYycHBICJhIrZ+5m7WLk4hAS2MEo0XVkFlRCWuLYiTPM
        XYwcQLawxOHDxRA1zxgl5mydzw5SwyagK/Hvz342EFsEyD678AUjSBGzwDFGiUvvloAVCQnU
        SfS+nMwKYnMCFTWdbgVbICwgL7HqcAOYzSKgKnHz0Wowm1fAUuLe+ZWMELagxMmZT1hAbGYB
        A4n7hzpYIWxtiWULXzNDHKog8fPpMlaII6wkXs/YyghRIyIxu7ONeQKj8Cwko2YhGTULyahZ
        SFoWMLKsYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQIjhstrR2Me1Z90DvEyMTBeIhR
        goNZSYT3RfbFBCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeWpGanphakFsFkmTg4
        pRqYIlzj+OsfTdun7dfOJbr1quJXc/PdlcVL37g+nR1vLnhatUwrxqm8rXj3njPTf+q0vD8w
        /clWJh27U0J7OxZbfst543Cp5WnlIiE78d8bDUIXP9/sc1L2oKE7o2zKjNcs9YV9Ju296wPt
        0nRmGS98ccy+ZueLVnGj10l/eWSy2dxSxH91H3BOtv/aMEVfe4cNu63f9JI93Ex6qdoi0fc3
        ++oua3L9IVbmbvh3Yurs7w/nXUrYn6+6/ei0iueOB2SrLqdfvyU+efrS0wWt4c4TDj64afTK
        +bIo90yZX5tWeld4fMhce8PfaM+qqE9qzP9j3xn2tTSZp8n6PNfPln3+fJ7lVYEl94VP8Xis
        mK2rxFKckWioxVxUnAgAuc0ZWQoDAAA=
X-CMS-MailID: 20210622065848epcas1p15b875ef993bc987755a5ef8abc055024
X-Msg-Generator: CA
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210622061228epcas1p247d557ef24a971eaf395edd6174bed5e
References: <CGME20210622061228epcas1p247d557ef24a971eaf395edd6174bed5e@epcas1p2.samsung.com>
        <YNF/OpvdMLbIDZiZ@infradead.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> Is there a good reason to have a ksmbd-specific list instead of pooling a=
ll the smb3 knowledge on a
> single list, similar to how nfs development works?
There are users who subscribe only to ksmbd-specific list since ksmbd is ou=
t of tree. So we specified
both lists in MAINTAINERS. I do not object to use single list and kill the =
specific list after
ksmbd is merged into mainline.

Add CC: Steve, Ronnie, Aur=E9lien.=0D=0AAny=20opinions?=0D=0A=0D=0AThanks=
=21=0D=0A=0D=0A
