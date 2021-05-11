Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB041C433B4
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 09:10:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75064611F1
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 09:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhEKJMA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 May 2021 05:12:00 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:45315 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbhEKJMA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 May 2021 05:12:00 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210511091052epoutp0423abb474feb2b97f6e56a73ee8f1bc41~9_B7Z0I3V1304213042epoutp04U
        for <linux-cifs@vger.kernel.org>; Tue, 11 May 2021 09:10:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210511091052epoutp0423abb474feb2b97f6e56a73ee8f1bc41~9_B7Z0I3V1304213042epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1620724252;
        bh=FRnDFmeOh258ch8R8GC6pJSffKqcPWp+P1IioF1+cvY=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=XFgxL1Y67NIWvQn3PKm4mIiHJtn6gAFIthuzU5Qpi5pXuL/cBofXklAPcZkRU60f1
         XgmvpaMOaK5MXodQ4LEdgdAlaiduo8IfTG/kYFWPUFtVcOngwsb2NsyvfT9EZQ8yVK
         CHdOjY2+x642h4r7knZdNs6vgroBfLDx8hLdxfPY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20210511091051epcas1p4d8ca59e66152edb54ea5d4e0df8da5e7~9_B6_EqtK2988529885epcas1p4M;
        Tue, 11 May 2021 09:10:51 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.162]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4FfXG26H1nz4x9Q0; Tue, 11 May
        2021 09:10:50 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        D2.10.09701.A1A4A906; Tue, 11 May 2021 18:10:50 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20210511091049epcas1p3a85da5050a55fede51bd66e6cbec4bab~9_B406f_K0791907919epcas1p3Z;
        Tue, 11 May 2021 09:10:49 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210511091049epsmtrp2b01d12bf8fa24352f678e6d298845554~9_B40Iogb3062530625epsmtrp2h;
        Tue, 11 May 2021 09:10:49 +0000 (GMT)
X-AuditID: b6c32a36-c0126a80000025e5-a2-609a4a1aeea3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        92.A8.08637.91A4A906; Tue, 11 May 2021 18:10:49 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210511091049epsmtip270996fae10d26c01750c1e335fd7e7e7~9_B4pEMD90778407784epsmtip2j;
        Tue, 11 May 2021 09:10:49 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        "'Marios Makassikis'" <mmakassikis@freebox.fr>
Cc:     "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Steve French'" <sfrench@samba.org>,
        "'Hyunchul Lee'" <hyc.lee@gmail.com>, <linux-cifs@vger.kernel.org>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        <kernel-janitors@vger.kernel.org>
In-Reply-To: <YJotWR/qMDIoJAcV@mwanda>
Subject: RE: [PATCH] cifsd: fix an uninitialized variable in smb2_write()
Date:   Tue, 11 May 2021 18:10:49 +0900
Message-ID: <00e501d74645$88e95600$9abc0200$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQEFAhLqD9ynDCeTCRE2lDxTFbDXmAIsVU3vrHEjOdA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPJsWRmVeSWpSXmKPExsWy7bCmnq6U16wEgwPHtS1e/5vOYnHt/nt2
        i623pC1e/N/FbPHz/3dGi7PbpzJbrP38mN2i4+VRZgcOj/X991k8ds66y+6xe8FnJo+PT2+x
        eMzd1cfo8XmTXABbVI5NRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2S
        i0+ArltmDtA9SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpdSClJwCQ4MCveLE3OLSvHS9
        5PxcK0MDAyNToMqEnIxN318xFXRyVmxYt4KlgfEAexcjB4eEgInEz1dSXYxcHEICOxglDr/e
        xgLhfGKUWHb7KSOE841R4tKPF0AZTrCO4/fmMEEk9jJKvDu+D8p5wShxfcJidpAqNgFdiX9/
        9rOB2CICSRIXTrewgRQxC3xnlDjy5TfYKE4BNYkZZ28zghwiLOAp8eWmDEiYRUBVYvLCT8wg
        Nq+ApcSHc99YIWxBiZMzn4C1MgvIS2x/O4cZ4iIFiZ9Pl7FC7LKSeP9nDRtEjYjE7M42qJq1
        HBIf24IhbBeJKWv2QH0jLPHq+BZ2CFtK4vO7vWwQdrnEiZO/mCDsGokN8/ZBw8tYoudFCYjJ
        LKApsX6XPkSFosTO33MZIbbySbz72sMKUc0r0dEmBFGiKtF36TDUQGmJrvYP7BMYlWYh+WsW
        kr9mIbl/FsKyBYwsqxjFUguKc9NTiw0LjJCjehMjOKVqme1gnPT2g94hRiYOxkOMEhzMSiK8
        oh3TEoR4UxIrq1KL8uOLSnNSiw8xmgJDeiKzlGhyPjCp55XEG5oaGRsbW5iYmZuZGiuJ86Y7
        VycICaQnlqRmp6YWpBbB9DFxcEo1MEXcWOf843yEuNDP+Bq7xpo7SicLb53c/1rh1sKtn/pS
        7bZ36q7xaVgwZW3DgZPtJ3KzhB97qnwweejoVt/Kc2BxQe6ELwYc4TIKNQYHNb7O27f/f37/
        pMPLtA5ITD0z6biYz/mS2+8Fg5QZD1zfb7znlMeiXt3rbLwdXo6i0UrT8tv3hF6o/MXut//N
        6uhTPp/ljBvlDa192G5efsHm1rVc69X/O9228zLvrmKKb91j7nm2LH/2jVv8SzaxOXfkOXe+
        TUpXU08QCggxWKupaK5Ta2C1gSku9PHW9u0/ju/Xrv8z36pGnq/EXtZl2YakP6HCX3uaQzP/
        TZxg+izno26h2p2TvBpXWraUPWHsU2Ipzkg01GIuKk4EAAH0W6oyBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42LZdlhJXlfSa1aCwe4uGYvX/6azWFy7/57d
        YustaYsX/3cxW/z8/53R4uz2qcwWaz8/ZrfoeHmU2YHDY33/fRaPnbPusnvsXvCZyePj01ss
        HnN39TF6fN4kF8AWxWWTkpqTWZZapG+XwJWx6fsrpoJOzooN61awNDAeYO9i5OSQEDCROH5v
        DlMXIxeHkMBuRomGgz8YIRLSEsdOnGHuYuQAsoUlDh8uhqh5xihx99lWJpAaNgFdiX9/9rOB
        2CICSRJPr21iASliFvjNKNHZ+J8ZJCEkUC6x9FkXC4jNKaAmMePsbUaQocICnhJfbsqAhFkE
        VCUmL/wEVs4rYCnx4dw3VghbUOLkzCcsIOXMAnoSbRvBTmMWkJfY/nYOM8SZChI/ny5jhTjB
        SuL9nzVsEDUiErM725gnMArPQjJpFsKkWUgmzULSsYCRZRWjZGpBcW56brFhgWFearlecWJu
        cWleul5yfu4mRnBsaWnuYNy+6oPeIUYmDsZDjBIczEoivKId0xKEeFMSK6tSi/Lji0pzUosP
        MUpzsCiJ817oOhkvJJCeWJKanZpakFoEk2Xi4JRqYNrn8NqJQ9P31APfxVP1VrPrHX8s9z6F
        bVGA8hHLj1oquRZTUu8F5P8PkuCZVBnyrS1yssl3icdtUooxioarLjp+33BJWvHRnAfdd33M
        E7X7jv0yTGZzDDw7Z/N7ub9nX8W+iIj5OcldMtjgZIr8wm3fJXSeTdd0727bvJHhcvu3sx++
        LJm3ZH6LiFcU2zG+U0fjbwqxx4pxt7hfntQZtVlC1fLl3Dvrr21cLXVEN651o+fSmzwb7U/J
        Hl/Lwdx2jjkg2uGfnJ984E6bItnoHwHBJ1nCtM67SEhI1jzhbFm6ef/az2z/Oa0iD9Qvbzxv
        scNiz7mQPIctf5Zvibo+UftvVZFDJPO39b6vdE56NSixFGckGmoxFxUnAgAcjY89HAMAAA==
X-CMS-MailID: 20210511091049epcas1p3a85da5050a55fede51bd66e6cbec4bab
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210511070900epcas1p1619e7c7f3c6248d4bb871d8e244590ab
References: <CGME20210511070900epcas1p1619e7c7f3c6248d4bb871d8e244590ab@epcas1p1.samsung.com>
        <YJotWR/qMDIoJAcV@mwanda>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> If there is a permissions problem then the "fp" variable is used in the "goto out;" without being
> initialized.  The correct fix is to initialize "fp" to NULL which turns the ksmbd_fd_put(work, fp);
> call into a no-op.
> 
> Fixes: bb03a3d512bf ("cifsd: Call smb2_set_err_rsp() in smb2_read/smb2_write error path")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Hi Dan,

I have already applied the patch to fix this issue reported by coverity scan.
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/fs/cifsd?h=next-20210511&id=9a5549727ad95a574b1d7dc60f663
250fa4b213f

Thanks!
> ---
>  fs/cifsd/smb2pdu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifsd/smb2pdu.c b/fs/cifsd/smb2pdu.c index d07d7c45f899..18de8a763209 100644
> --- a/fs/cifsd/smb2pdu.c
> +++ b/fs/cifsd/smb2pdu.c
> @@ -6078,7 +6078,7 @@ int smb2_write(struct ksmbd_work *work)  {
>  	struct smb2_write_req *req;
>  	struct smb2_write_rsp *rsp, *rsp_org;
> -	struct ksmbd_file *fp;
> +	struct ksmbd_file *fp = NULL;
>  	loff_t offset;
>  	size_t length;
>  	ssize_t nbytes;
> --
> 2.30.2


