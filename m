Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51B62C4743C
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 05:04:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 288B860FE9
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Jun 2021 05:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFWFGr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Jun 2021 01:06:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13404 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhFWFGq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Jun 2021 01:06:46 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210623050428epoutp0344be445eaf21ab4cedd679a79d7c6b70~LHaEXTVqS1132411324epoutp03g
        for <linux-cifs@vger.kernel.org>; Wed, 23 Jun 2021 05:04:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210623050428epoutp0344be445eaf21ab4cedd679a79d7c6b70~LHaEXTVqS1132411324epoutp03g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624424668;
        bh=1I1iMgriE3fJNx7Qom7YUNapuuGsTGMHMrC1L6Ki6ZE=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=kmgGQBZD8BSWX0u4B9mY0m2dqdxWEcy0gWGQZTKGwicnS8hX+V+VN5nLtTYaAJX4U
         XEtSrcM6pyKm651vTEHwGTFONj9yFo3m5z1zuo+LoUifpivZbXbIAKZQQ5bnzCWKKd
         12jmo1mC3y5Q68CmAEwrboeJyk79ztOCrcSwB2x0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20210623050427epcas1p326844fb3c2f21a93883152b25430e967~LHaEEKV_e0814008140epcas1p3-;
        Wed, 23 Jun 2021 05:04:27 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.166]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4G8rlv2gx2z4x9Q1; Wed, 23 Jun
        2021 05:04:27 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        3D.8A.09468.BD0C2D06; Wed, 23 Jun 2021 14:04:27 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210623050426epcas1p10de7f87ad2007e1fc60ffd85981d8b4a~LHaDIzh6u2761127611epcas1p1V;
        Wed, 23 Jun 2021 05:04:26 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210623050426epsmtrp297c8fc7259ad8fdd6d467aa796e2f5ce~LHaDIByMn0264002640epsmtrp2X;
        Wed, 23 Jun 2021 05:04:26 +0000 (GMT)
X-AuditID: b6c32a37-0b1ff700000024fc-8d-60d2c0db365b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B7.BE.08394.AD0C2D06; Wed, 23 Jun 2021 14:04:26 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210623050426epsmtip2cdf4b9d4bba085b8d62a814346c24ac8~LHaC8twee1228812288epsmtip2S;
        Wed, 23 Jun 2021 05:04:26 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Christoph Hellwig'" <hch@infradead.org>,
        "'Steve French'" <smfrench@gmail.com>
Cc:     "'Aur??lien Aptel'" <aurelien.aptel@gmail.com>,
        "'COMMON INTERNET FILE SYSTEM SERVER'" 
        <linux-cifsd-devel@lists.sourceforge.net>,
        "'CIFS'" <linux-cifs@vger.kernel.org>,
        "'ronnie sahlberg'" <ronniesahlberg@gmail.com>
In-Reply-To: <YNK+GKA0aXoxhgdF@infradead.org>
Subject: RE: ksmbd mailing list
Date:   Wed, 23 Jun 2021 14:04:26 +0900
Message-ID: <000501d767ed$3d91e2c0$b8b5a840$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQKEoK/ucUJhU+AlUKRaTDLvHCKH0wHZDfPRAiUqc4MCZCxSvwDYIZrJAdymPOcCLY6gTKlscspQ
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupik+LIzCtJLcpLzFFi42LZdlhTT/f2gUsJBiveClocf/2X3eL0hEVM
        Fi/+72K2+Pn/O6NFb98nVos3Lw6zObB57Jx1l91j8wotj90LPjN5fN4kF8ASlWOTkZqYklqk
        kJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RbSaEsMacUKBSQWFys
        pG9nU5RfWpKqkJFfXGKrlFqQklNgaFCgV5yYW1yal66XnJ9rZWhgYGQKVJmQk9Gy4ylTwVyW
        il879zM2MM5n7mLk4JAQMJFYv4y3i5GTQ0hgB6NEz9aSLkYuIPsTo8T6tbdZIRLfGCU6OyNA
        bJD6Y8cuM0EU7WWUOLxhFZTzglHi3Mt5zCBVbAK6Ev/+7GcD2SAiECbx5VkmSA2zwH1GiYYJ
        18FqOIFqzu1bCrZBWEBeYtXhBiYQm0VAVWLRgS52EJtXwFJi8oGbLBC2oMTJmU/AbGag+u1v
        5zBDXKQg8fPpMlaIuIjE7M42sLiIQJTEhY9L2EAWSwh0ckg0XlnFCNHgItGy+DcLhC0s8er4
        FnYIW0ri87u9bBB2ucSJk7+YIOwaiQ3z9rFDgstYoudFCYjJLKApsX6XPkSFosTO33MZIU7g
        k3j3tYcVoppXoqNNCKJEVaLv0mGogdISXe0f2CcwKs1C8tgsJI/NQvLMLIRlCxhZVjGKpRYU
        56anFhsWGCPH9CZGcKLUMt/BOO3tB71DjEwcjIcYJTiYlUR4H7VcShDiTUmsrEotyo8vKs1J
        LT7EaAoM6onMUqLJ+cBUnVcSb2hqZGxsbGFiZm5maqwkzruT7VCCkEB6YklqdmpqQWoRTB8T
        B6dUA1PKtoO5l+Ntsn9UuQU3rViSocxUuOKUcD/rRR7jv78+ndwS2PJugvWB1VNbpS3PG508
        15ZQ4t1ZZlJpsPfHx3Ijk1sOV05wlycxnTrB+ENwjsFG3qmS3L9ChR08K26G/8zWeyx08GjC
        YtVix9J50bGmXX/UpXtNZ5SJarlunDfnTfDuNBk7rqdu9jt575gwXOTaPb/nTK2vXVbtdIku
        yfpzPwru+jSHXLKOfCKavHlBzHvhJR2piavdt4YvKGQPvlKaXMDInc6757volTY92a3vC3+5
        53dzVG/gKr3Gobz0tpS/kjGnOWO52qcfbwLkUhe9StlgUxzvXGwSkODoMq1BN/7NtF8zL7mJ
        2UUrsRRnJBpqMRcVJwIAkRdJDR0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWy7bCSvO6tA5cSDO7dMrM4/vovu8XpCYuY
        LF7838Vs8fP/d0aL3r5PrBZvXhxmc2Dz2DnrLrvH5hVaHrsXfGby+LxJLoAlissmJTUnsyy1
        SN8ugSujZcdTpoK5LBW/du5nbGCcz9zFyMkhIWAicezYZSYQW0hgN6PE+bs8EHFpiWMnzgDV
        cADZwhKHDxd3MXIBlTxjlLh7eC9YL5uArsS/P/vZQGwRgTCJazNWsoIUMQs8ZJTo/3aKEaLj
        FpNE65tprCBVnEAd5/YtBbOFBeQlVh1uANvMIqAqsehAFzuIzStgKTH5wE0WCFtQ4uTMJywg
        VzAL6Em0bWQECTMDtW5/OwfqAQWJn0+XsULERSRmd7YxQxwUJXHh4xK2CYzCs5BMmoUwaRaS
        SbOQdC9gZFnFKJlaUJybnltsWGCYl1quV5yYW1yal66XnJ+7iREcNVqaOxi3r/qgd4iRiYPx
        EKMEB7OSCO+jlksJQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgsky
        cXBKNTBdab7obPCR4Y7Uyqitd9dsb83wezH1tNM9ifDS6JNnsx9vis14udKIe29iVPC2Gbnr
        jHMF5te/7Fz5d0rjATZtRTMema7iksvFL75zytZcMjkk6KzBHLL51I4Npr+7TLa4ztDh2/GI
        e2bRrnXKq7uvXVus+lHOYVViD4PsPVW2OsHIb77lS1fKVPdNNlX41K3Nf2KDteBH0Sq/yc5Z
        uxhCue4sqZz7cNvJm15SLg97Hqw4sNbn6KGDwSoCAurPP3yNSrvDH+v97+vt04JX7pqanGh+
        q/Z8UkN+80FRrldTF8soe842qMlymplqYb7qyIkWvT/BoSwTwj5US37eb7fpJ98r701G2ne3
        hHguWFinxFKckWioxVxUnAgAm46dKAkDAAA=
X-CMS-MailID: 20210623050426epcas1p10de7f87ad2007e1fc60ffd85981d8b4a
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
        <YNK+GKA0aXoxhgdF@infradead.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> 
> On Tue, Jun 22, 2021 at 09:52:33PM -0500, Steve French wrote:
> > We should probably put a few lines in the cifsd and cifs client wiki
> > pages on samba.org and also in the kernel documentation directory for
> > each that notes that emails with patches should have a prefix that
> > indicates whether server or client or utils (e.g. [cifsd] or [ksmbd]
> > if you prefer, [cifs] for the client and [cifs-utils] for the tools)
> 
> The normal kernel patch prefixes would be:
> 
> cifs:
> 
> and
> 
> ksmbd:
Yes, Sure:)

