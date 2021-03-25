Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88732C433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Mar 2021 03:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5880961A12
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Mar 2021 03:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhCYDfc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Mar 2021 23:35:32 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20420 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbhCYDfP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Mar 2021 23:35:15 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210325033513epoutp03674ce49143cfd0265167e6c1c64c6fbe~veIcsRyD61053610536epoutp03D
        for <linux-cifs@vger.kernel.org>; Thu, 25 Mar 2021 03:35:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210325033513epoutp03674ce49143cfd0265167e6c1c64c6fbe~veIcsRyD61053610536epoutp03D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1616643313;
        bh=y4Qm0WnVCT6lGKoOkoBEsUkBKqAXMToKmerg1AGx8yI=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=eBiM0DI6GTOaZqWCFk2+PXot1ANaxJFohW/lXuBxgi4ji8Ac7vHLNorBI3mxZ5MFm
         pErGSt+KrKIZpj4EQXIMdymegFqroJPZ2a9YnT6DqJ7GhyuB1J6MVaTdC9rlu9giLT
         f+XSkALYLpQiHEX+hY3dxfWmXbLF/XMGxbG5WgzI=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210325033512epcas1p12ac22ce1dfe3197453fe2a0ea4678146~veIcQkhkZ0452604526epcas1p1g;
        Thu, 25 Mar 2021 03:35:12 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.162]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4F5W2R5btmz4x9Q7; Thu, 25 Mar
        2021 03:35:11 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        94.6B.10347.FE40C506; Thu, 25 Mar 2021 12:35:11 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210325033511epcas1p14302b0d69b5205f0948b23a675b40524~veIaunLjW1114011140epcas1p1v;
        Thu, 25 Mar 2021 03:35:11 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210325033511epsmtrp1eb73ee184e3fd4974db06fa6e0ea8327~veIaty8sC1780717807epsmtrp19;
        Thu, 25 Mar 2021 03:35:11 +0000 (GMT)
X-AuditID: b6c32a39-15dff7000002286b-29-605c04ef0147
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        0D.3F.08745.EE40C506; Thu, 25 Mar 2021 12:35:10 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210325033510epsmtip2804f30d8daf81672bb53e5bd5644a7e7~veIaghvdT2021020210epsmtip2J;
        Thu, 25 Mar 2021 03:35:10 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Dan Carpenter'" <dan.carpenter@oracle.com>
Cc:     "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Steve French'" <sfrench@samba.org>,
        "'Hyunchul Lee'" <hyc.lee@gmail.com>,
        "'Ronnie Sahlberg'" <lsahlber@redhat.com>,
        <linux-cifs@vger.kernel.org>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        <kernel-janitors@vger.kernel.org>
In-Reply-To: <YFnsqPphqvItA3z2@mwanda>
Subject: RE: [PATCH v2] cifsd: fix error handling in ksmbd_server_init()
Date:   Thu, 25 Mar 2021 12:35:10 +0900
Message-ID: <01f601d72127$dc184c20$9448e460$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFtnsIBsSdZYhLtLLYYGwx6mjq1FQJ6+po6q1M6L4A=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmge57lpgEgyOftSxe/5vOYnHt/nt2
        i623pC1e/N/FbPHz/3dGiwVX9S3Wfn7MbtHx8iizA4fHzll32T12L/jM5PHx6S0Wj/f7rrJ5
        zN3Vx+jxeZNcAFtUjk1GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKL
        T4CuW2YO0DlKCmWJOaVAoYDE4mIlfTubovzSklSFjPziElul1IKUnAJDgwK94sTc4tK8dL3k
        /FwrQwMDI1OgyoScjOevN7MX3OKpaH44hbGBcRlXFyMnh4SAicSLm48Yuxi5OIQEdjBKvFm9
        Bsr5xCjx48cnNgjnM6PElP8LWGBajr45CVW1i1Fiy8NVUFUvgZxrV5hAqtgEdCX+/dnPBmKL
        CBhI3Dv5ggWkiFlgEZPE8q5LjCAJTgE1ic1PWsCKhAU8JHZN2sfcxcjBwSKgKnFqmSdImFfA
        UuLVtQdMELagxMmZT8CuYBaQl9j+dg4zxEUKEj+fLmOF2GUlMf3OZ1aIGhGJ2Z1tzCB7JQRW
        ckhMv9bCDtHgIvHybxMjhC0s8er4Fqi4lMTL/jZ2kBskBKolPu6Hmt/BKPHiuy2EbSxxc/0G
        VpASZgFNifW79CHCihI7f89lhFjLJ/Huaw8rxBReiY42IYgSVYm+S4eZIGxpia72D+wTGJVm
        IXlsFpLHZiF5YBbCsgWMLKsYxVILinPTU4sNC0yRI3sTIzipalnuYJz+9oPeIUYmDsZDjBIc
        zEoivC3hEQlCvCmJlVWpRfnxRaU5qcWHGE2BIT2RWUo0OR+Y1vNK4g1NjYyNjS1MzMzNTI2V
        xHmTDB7ECwmkJ5akZqemFqQWwfQxcXBKNTAdWPD13KSy1Wyn/8elildsibmovKK/lPUDw98t
        to9/ef8WdUhmrvPT/d3Xci/XiWurletlrWNNdYvu5JgU6dmnKi+//HbzhyP6jpvCGk40htka
        9ntNUXOR7g1c+Cv4WG+69KoIqcAnH99qhnExNwlePL9u4owj/ntyJDT/8K8XqbDNX3WRw3KL
        d+MryXNXnZPKH4h7sf/jzbzc4f9cunGd+1v9z9ILlrWdKzBnXWu1tGuf9Y6Pu5ztZnntiyud
        Osnp25G3hmtv/Vm/e52tnPSrp/4T9X+9MH3zRrbB45ez8vznRru587I14k/++GPAnhud5rfD
        NIDp2vvZkmZ7smyM5gWtk9pil1zF/uMWn4YSS3FGoqEWc1FxIgAJ/7/pMwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42LZdlhJXvcdS0yCwcXd1hav/01nsbh2/z27
        xdZb0hYv/u9itvj5/zujxYKr+hZrPz9mt+h4eZTZgcNj56y77B67F3xm8vj49BaLx/t9V9k8
        5u7qY/T4vEkugC2KyyYlNSezLLVI3y6BK+P5683sBbd4KpofTmFsYFzG1cXIySEhYCJx9M1J
        xi5GLg4hgR2MEtcfTGeHSEhLHDtxhrmLkQPIFpY4fLgYouY5o8SCh6vZQGrYBHQl/v3ZD2aL
        CBhI3Dv5ggWkiFlgBZPE7cOLWUESQgLlEneb7jOD2JwCahKbn7SANQgLeEjsmrQPbAGLgKrE
        qWWeIGFeAUuJV9ceMEHYghInZz5hASlhFtCTaNvICBJmFpCX2P52DjPEmQoSP58uY4U4wUpi
        +p3PrBA1IhKzO9uYJzAKz0IyaRbCpFlIJs1C0rGAkWUVo2RqQXFuem6xYYFRXmq5XnFibnFp
        Xrpecn7uJkZwZGlp7WDcs+qD3iFGJg7GQ4wSHMxKIrwt4REJQrwpiZVVqUX58UWlOanFhxil
        OViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTDte79xw8rfnyIj+9boBByZtPrFh5u+q5Y5
        MjT/3bJLkVlQIKuw84Pz9PoAuQ2pnUEmS2Y4vOcqYmxZK2Z/VdihXuiEvUGZ3/JH7v7lam4G
        ZQwFN/a63909//OkNfI3cqrkbKc7d3dN2fE7dXOINc8vk3OvbxpOLZpcx76M9/b0WFaxv+ce
        lE//vVq5ZyrnT71vfl5H6zkTdsyZKyTE4qRtkTJ7ltWtx4s/35v39vbixrW1wdlPP4kVB9ye
        dfBnU+uK051J72TfJDB7TW20VlaxYt+wpeml0ZeYfzJXG9KbG6wyvjd3JXzM5Xt9Ov/Hq7/3
        N1lW2m/f9M5R/caci3dP5xz9+un80ZQ1r85/fMQdqcRSnJFoqMVcVJwIALMzgOQbAwAA
X-CMS-MailID: 20210325033511epcas1p14302b0d69b5205f0948b23a675b40524
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210323132751epcas1p39002e41ec02ed29aee7f73aae5f2cbf9
References: <CGME20210323132751epcas1p39002e41ec02ed29aee7f73aae5f2cbf9@epcas1p3.samsung.com>
        <YFnsqPphqvItA3z2@mwanda>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> 
> The error handling in ksmbd_server_init() uses "one function to free everything style" which is
> impossible to audit and leads to several canonical bugs.  When we free something that wasn't allocated
> it may be uninitialized, an error pointer, freed in a different function or we try freeing "foo->bar"
> when "foo" is a NULL pointer.  And since the code is impossible to audit then it leads to memory leaks.
> 
> In the ksmbd_server_init() function, every goto will lead to a crash because we have not allocated the
> work queue but we call
> ksmbd_workqueue_destroy() which tries to flush a NULL work queue.
> Another bug is if ksmbd_init_buffer_pools() fails then it leads to a double free because we free
> "work_cache" twice.  A third type of bug is that we forgot to call ksmbd_release_inode_hash() so that
> is a resource leak.
> 
> A better way to write error handling is for every function to clean up after itself and never leave
> things partially allocated.  Then we can use "free the last successfully allocated resource" style.
> That way when someone is reading the code they can just track the last resource in their head and
> verify that the goto matches what they expect.
> 
> In this patch I modified ksmbd_ipc_init() to clean up after itself and then I converted
> ksmbd_server_init() to use gotos to clean up.
> 
> Fixes: cabcebc31de4 ("cifsd: introduce SMB3 kernel server")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: remove __exit annotation from ksmbd_release_inode_hash() as detected by the kbuild-bot
I will apply. Thanks for your patch!

