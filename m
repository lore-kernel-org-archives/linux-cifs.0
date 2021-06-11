Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AAB2C48BDF
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Jun 2021 00:40:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CB2D6128A
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Jun 2021 00:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbhFKAmZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Jun 2021 20:42:25 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63983 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhFKAmZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 10 Jun 2021 20:42:25 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210611004026epoutp01e951b3600288cfa6328195ffda14fa3c~HYEHfbijx2038420384epoutp01h
        for <linux-cifs@vger.kernel.org>; Fri, 11 Jun 2021 00:40:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210611004026epoutp01e951b3600288cfa6328195ffda14fa3c~HYEHfbijx2038420384epoutp01h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623372026;
        bh=E6/+jD0GWeLZqmC2W5BnJVBWqpRDEJQcu9OTjCqzJB8=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=Sjc7Yw42nHXyGplY6dDXYeInFXDuJxfskEH6e9TIi0K0QC6hkwDJmb5O102nVMujF
         dOok76QNeJMxc7gHHocTitjasv1OxyObc0j/plee6MCanN4VhsuNONNH4MwLk1+/AA
         /DYnO/ia2IMTPR2Ea+g2gJfm2ZV+H5XWi9uT2J8I=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210611004026epcas1p2250c35e6e071e9c2fa4d309cfa02f8e8~HYEG-_S-v0587505875epcas1p2H;
        Fri, 11 Jun 2021 00:40:26 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.165]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4G1MSm61JRz4x9Q7; Fri, 11 Jun
        2021 00:40:24 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        89.F8.09578.8F0B2C06; Fri, 11 Jun 2021 09:40:24 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210611004024epcas1p16e25142d1430c3cccad03af11ba5b602~HYEFSVkVB0587705877epcas1p1X;
        Fri, 11 Jun 2021 00:40:24 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210611004024epsmtrp2788f815e1370374d764b60a64aba66c9~HYEFRfJiv1820418204epsmtrp2o;
        Fri, 11 Jun 2021 00:40:24 +0000 (GMT)
X-AuditID: b6c32a35-fcfff7000000256a-82-60c2b0f80130
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A4.92.08637.8F0B2C06; Fri, 11 Jun 2021 09:40:24 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210611004024epsmtip191844ad8d552bed1984b04de38dd333b~HYEFGnwBq2968429684epsmtip1S;
        Fri, 11 Jun 2021 00:40:24 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Colin King'" <colin.king@canonical.com>
Cc:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Steve French'" <sfrench@samba.org>,
        "'Hyunchul Lee'" <hyc.lee@gmail.com>, <linux-cifs@vger.kernel.org>,
        <linux-cifsd-devel@lists.sourceforge.net>
In-Reply-To: <20210610164603.554691-1-colin.king@canonical.com>
Subject: RE: [PATCH][next] cifsd: fix kfree of uninitialized pointer oid
Date:   Fri, 11 Jun 2021 09:40:24 +0900
Message-ID: <000201d75e5a$5da793d0$18f6bb70$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGmysDK925IjpbwB8/bhQpBcVuCZgJadOaRq1xLYcA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsWy7bCmvu6PDYcSDCad1bX4vbqXzeLa/ffs
        FltvSVu8+L+L2eLn/++MFpd3zWGzWPv5MbtFx8ujzA4cHrMaetk8ds66y+6xe8FnJo+5u/oY
        PT5vkgtgjcqxyUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXL
        zAE6RUmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCRX1xiq5RakJJTYGhQoFecmFtcmpeul5yfa2Vo
        YGBkClSZkJNx5W0zW8FXlorb0xtYGhi7WboYOTkkBEwkfj1cyt7FyMUhJLCDUWLjpG3MEM4n
        RonvM3YwQTjfGCUm3TgL19LQtgiqZS+jxOrPj6GqXjBKrPhzkBGkik1AV+Lfn/1sXYwcHCJA
        9pQvkiA1zALTmST2z/nJBBLnFLCXuLAwGqRcWMBDonfKe1aQMIuAqsSCZb4gYV4BS4mX/yez
        QdiCEidnPgG7gVlAXmL72znMEPcoSPx8uowVYpOVxJ3zBhAlIhKzO9ugSmZySExrNYWwXSTe
        zFjIBGELS7w6voUdwpaS+PxuLxuEXS5x4uQvqJoaiQ3z9rGDjJcQMJboeVECYjILaEqs36UP
        UaEosfP3XEaIrXwS7772sEJU80p0tAlBlKhK9F06DDVQWqKr/QP7BEalWUjemoXkrVlI7p+F
        sGwBI8sqRrHUguLc9NRiwwJD5IjexAhOolqmOxgnvv2gd4iRiYPxEKMEB7OSCO/OlYcShHhT
        EiurUovy44tKc1KLDzGaAsN5IrOUaHI+MI3nlcQbmhoZGxtbmJiZm5kaK4nz7mQDahJITyxJ
        zU5NLUgtgulj4uCUamCyEX20595RuchTJd8emXjNSZ42Yz1X89fuRZ1Ltv/bLBMSu2v5gW9m
        X98fi43UczOW3Bv+/0aP2xGZ71WWHCdEPR7FZZb1tnZXiodfj7F/dC5z1Sp9OwuvkMaLL0wu
        nHdp6Fku2mvkFWa+Yv+TM6azSi4ELvlT+nna+jT1BVHsV2bbqG9bq7LM7vK5NvPXjiubs/Q/
        MMWnl/os87gbvYXvqu/isMMmF39PDNrkzfKzo+xpQP4lf/6Xf12jdi+6k6xi8b696aCn38bm
        aakTu9heus+42n8pfccnrYwFDb0xbDOeiKXF++2o2nc6cdleLeNyrxerz8w5s2nL7/KTG3f1
        bVws9ig5ibkw+b3nz83rlViKMxINtZiLihMBjye+QysEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LZdlhJTvfHhkMJBlsXCVj8Xt3LZnHt/nt2
        i623pC1e/N/FbPHz/3dGi8u75rBZrP38mN2i4+VRZgcOj1kNvWweO2fdZffYveAzk8fcXX2M
        Hp83yQWwRnHZpKTmZJalFunbJXBlXHnbzFbwlaXi9vQGlgbGbpYuRk4OCQETiYa2RexdjFwc
        QgK7GSVOt32CSkhLHDtxhrmLkQPIFpY4fLgYouYZo0Tj/t9sIDVsAroS//7sZwOpEQGyp3yR
        BKlhFpjLJLF5+xMmiIYJjBI/1v1mASniFLCXuLAwGqRXWMBDonfKe1aQMIuAqsSCZb4gYV4B
        S4mX/yezQdiCEidnPgE7h1lAW+LpzadQtrzE9rdzmCHOVJD4+XQZK8QJVhJ3zhtAlIhIzO5s
        Y57AKDwLyaRZSCbNQjJpFpKWBYwsqxglUwuKc9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxgiNK
        S3MH4/ZVH/QOMTJxMB5ilOBgVhLh3bnyUIIQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OF
        BNITS1KzU1MLUotgskwcnFINTCp/Xix+8S+v5sf99M9bfzoxrPX1+jt/64uUe0VRV5R/HJVZ
        XWAq/NQ3WPTfj+YX52x5DDdyxUXO/BOpsGGv8uN32obrf661SWI1usHpUpJ9Uevz5j+aHunc
        PC9WOy17/+LgpPwVqzdGVWs6PBXjfPamnuekRKDcvulX7VSYDprbxn2aZvC9wEH9iq1rG9s3
        xZZ33CfVij4dq31s5cufxXhcXuOqyurfGvYejRmSAiv6G7nql8l3mC9LkeGJ71j7/u/KpE0/
        7GrOvgp9qVH43POG9uM71cmpLzdvcv7ilDglXKJJga/ILdz5zY/fDJx6S8+JLytkinnW4TMj
        84XCnVjTC2lXAmyyV8qemftlihJLcUaioRZzUXEiALWaM1kXAwAA
X-CMS-MailID: 20210611004024epcas1p16e25142d1430c3cccad03af11ba5b602
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210610164609epcas1p1c221f8a2c1762fc8a2e0cd5aa44c2b37
References: <CGME20210610164609epcas1p1c221f8a2c1762fc8a2e0cd5aa44c2b37@epcas1p1.samsung.com>
        <20210610164603.554691-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently function ksmbd_neg_token_init_mech_type can kfree an uninitialized pointer oid when the call
> to asn1_oid_decode fails when vlen is out of range. All the other failure cases in function
> asn1_oid_decode set *oid to NULL on an error, so fix the issue by ensuring the vlen out of range error
> also nullifies the pointer.
> 
> Fixes: 8bae4419ce63 ("cifsd: add goto fail in neg_token_init_mech_type()")
> Addresses-Coverity: ("Uninitialized pointer read")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
I will apply, Thanks for your patch!

