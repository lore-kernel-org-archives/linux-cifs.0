Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3308CC433E0
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Feb 2021 06:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4C0664DF0
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Feb 2021 06:09:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhBPGJK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Feb 2021 01:09:10 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:39260 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbhBPGJJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 16 Feb 2021 01:09:09 -0500
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210216060827epoutp01e1a68f581a82b432aa3b53e424ae1416~kJWrHWUao1078010780epoutp01J
        for <linux-cifs@vger.kernel.org>; Tue, 16 Feb 2021 06:08:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210216060827epoutp01e1a68f581a82b432aa3b53e424ae1416~kJWrHWUao1078010780epoutp01J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1613455707;
        bh=fk12Dsp4cNwrI2OKUnqEu/Jps7pXu90uthOtKr/vJuo=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Drub6bAk/cu3ycj1kXUm6eQR21pj4T/ScYYdccG5Ecaca757nmURLzkAZwD59eanN
         Eb1VHjoXTQCVGRYCVYYpwc5KzUPQq7fpMa2pJRlDMMV4uQWm6bV+OxQtSZ49MJXMPn
         +SOtGnqy9oIMVxwPthkb2jjDRVKGSG4zELkHMsIw=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210216060826epcas1p20f9527ecbe501f654b2ce4cc48e2758f~kJWq7Q76N2694226942epcas1p2g;
        Tue, 16 Feb 2021 06:08:26 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.164]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DfrBK42yZz4x9Pw; Tue, 16 Feb
        2021 06:08:25 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        ED.30.09577.8516B206; Tue, 16 Feb 2021 15:08:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20210216060824epcas1p3da0dbe476cf2799b797929d5371baefe~kJWo24xiR1077110771epcas1p3c;
        Tue, 16 Feb 2021 06:08:24 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210216060824epsmtrp257c0ca1a833700442dab67f5c357be7d~kJWo2T7o71331413314epsmtrp2W;
        Tue, 16 Feb 2021 06:08:24 +0000 (GMT)
X-AuditID: b6c32a39-c13ff70000002569-4d-602b61586e45
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A3.BA.08745.8516B206; Tue, 16 Feb 2021 15:08:24 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210216060824epsmtip277d8ca8c8e2eb63ff8e051893a6308d5~kJWor7nmS1238912389epsmtip2R;
        Tue, 16 Feb 2021 06:08:24 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Steve French'" <smfrench@gmail.com>
Cc:     "'CIFS'" <linux-cifs@vger.kernel.org>,
        <linux-cifsd-devel@lists.sourceforge.net>
In-Reply-To: <CAH2r5muxMuKw4Vk6k8P7A5SNVnO5E0zgFCfXd_DYXxvt1MfLgw@mail.gmail.com>
Subject: RE: cifsd rebase
Date:   Tue, 16 Feb 2021 15:08:24 +0900
Message-ID: <011a01d7042a$22a00950$67e01bf0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQK1bjyZLNsccgenqTIDRYfffdPZ/wHqbUDHqI4kI5A=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsWy7bCmrm5EonaCwZWjxhYv/u9itvj5/zuj
        xZsXh9kcmD12zrrL7rF7wWcmj8+b5AKYo3JsMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1
        DS0tzJUU8hJzU22VXHwCdN0yc4AWKSmUJeaUAoUCEouLlfTtbIryS0tSFTLyi0tslVILUnIK
        DA0K9IoTc4tL89L1kvNzrQwNDIxMgSoTcjKWHvnHVrCOsWLmt31sDYxNjF2MnBwSAiYS315N
        BbK5OIQEdjBK9D0+wgrhfGKUeP5nOjOE85lRoufCemaYls+9TVBVuxglln4/ywbhvGSUmLdv
        KthgNgFdiX9/9rOB2CICmhJvdk8C62YWCJNoaH7LDmJzCgRKXHrzkQnEFhaQlOia2AjWyyKg
        KvHw6XqWLkYODl4BS4lnf81AwrwCghInZz5hgRgjL7H97RyogxQkfj5dxgqxykri4Z75UDUi
        ErM728A+kBD4yC6xZvECNogGF4n172czQdjCEq+Ob2GHsKUkPr/bywayV0KgWuLjfqj5HYwS
        L77bQtjGEjfXb2AFKWEGemv9Ln2IsKLEzt9zGSHW8km8+9rDCjGFV6KjTQiiRFWi79JhqKXS
        El3tH9gnMCrNQvLYLCSPzULywCyEZQsYWVYxiqUWFOempxYbFpgix/UmRnAa1LLcwTj97Qe9
        Q4xMHIyHGCU4mJVEeNk/ayUI8aYkVlalFuXHF5XmpBYfYjQFhvREZinR5HxgIs4riTc0NTI2
        NrYwMTM3MzVWEudNMngQLySQnliSmp2aWpBaBNPHxMEp1cBkvN+3V+3RZKm/kg7LS96aeR3x
        nKrAder7o5vXThZkPLrIuEQv0e1vmq7KXY7bnafmJc3R6K+9tT1u9ma9yB7XtMDi7QGyd64W
        CTZ1azTUZHfsaRW8mGl4xyywfqaq9esHNy8+iMzZOVeKgSkr4MyEqIqpjXciN/yc8uSvyG+b
        6x83qG5w6BG6sPJyp/lVjwdXclL62RySXZ43xW/bW/Xh+uXmaw5Lb8r8bAv9435pabzWj4IN
        h9QkRA4Etyad2/yDk6N5+inObfee1D2pZVjNFv36ls5e1pbNd0VPXd7k94uzOzncb8umYKO8
        /v1qOR/PKPz+8e2tbtTKCv9Xy8853H0wfUNk2VGdqlkyVsk3lViKMxINtZiLihMBr1Z4AAwE
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWy7bCSvG5EonaCwYa/ihYv/u9itvj5/zuj
        xZsXh9kcmD12zrrL7rF7wWcmj8+b5AKYo7hsUlJzMstSi/TtErgylh75x1awjrFi5rd9bA2M
        TYxdjJwcEgImEp97m1i7GLk4hAR2MEqsu7WVBSIhLXHsxBnmLkYOIFtY4vDhYoia54wShz7N
        ZgepYRPQlfj3Zz8biC0ioCnxZvckZhCbWSBMoqH5LTtEwyJGiTfrWplAEpwCgRKX3nwEs4UF
        JCW6JjaCXcEioCrx8Ol6FpBlvAKWEs/+moGEeQUEJU7OfMICMVNbovdhKyOELS+x/e0cZog7
        FSR+Pl3GCnGDlcTDPfOh6kUkZne2MU9gFJ6FZNQsJKNmIRk1C0nLAkaWVYySqQXFuem5xYYF
        Rnmp5XrFibnFpXnpesn5uZsYwRGhpbWDcc+qD3qHGJk4GA8xSnAwK4nwsn/WShDiTUmsrEot
        yo8vKs1JLT7EKM3BoiTOe6HrZLyQQHpiSWp2ampBahFMlomDU6qBye2RvvvjpwHFW+dO/x7n
        s+OEymzOZIMVPRZvvSpZ1ht77NL9Ov9v2NUDepdtGw99EXouIPX/+2v+/OId9Vs9hE97/J2x
        hG3WGhFFAS/fjd2TZfN/TPt7LjqHj4/xDlMiy2TjlZ+utyQ8i7ugWrji0QvZK+Hvlt5b8dLf
        dvbszXfznSKM7ttZXGfnfHXDUzTH4u1Rz4y//h9bYvi93rVfWFFha3Dke6Puxojzbw98UbF6
        qL++uvBzZtW7UywspQ8a5v670NB0eN+yA+8e8+4t5On5HbuSpaJpsdzNAJ++zV8eb1M897u0
        TSmeLcP6teCmb9YmttLPrlw7HDtJVEf+rVn1wzeyLlIZjp5pfmscdiqxFGckGmoxFxUnAgCn
        94q+9wIAAA==
X-CMS-MailID: 20210216060824epcas1p3da0dbe476cf2799b797929d5371baefe
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210216060443epcas1p30d70f8b823a1c5513bd20d9f94e058b3
References: <CGME20210216060443epcas1p30d70f8b823a1c5513bd20d9f94e058b3@epcas1p3.samsung.com>
        <CAH2r5muxMuKw4Vk6k8P7A5SNVnO5E0zgFCfXd_DYXxvt1MfLgw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> FYI - Rebased the smb3-kernel github tree cifsd-for-next branch onto the recently released 5.11
Okay, I will check it:)

Thank you!
> 
> --
> Thanks,
> 
> Steve

