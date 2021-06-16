Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7441C48BE5
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Jun 2021 06:49:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABD8761246
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Jun 2021 06:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbhFPGve (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Jun 2021 02:51:34 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57241 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231799AbhFPGva (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Jun 2021 02:51:30 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210616064921epoutp04ed50dc946a89b6bc99333b413119f7b9~I-UpB2YUl0170701707epoutp04U
        for <linux-cifs@vger.kernel.org>; Wed, 16 Jun 2021 06:49:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210616064921epoutp04ed50dc946a89b6bc99333b413119f7b9~I-UpB2YUl0170701707epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623826161;
        bh=M6DUvZ8IY2qo/Do5U6AmcbRNLhZUcHmi8EbSTZ+iF78=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=hXDboEoOeT9Wi5EhmSKdO37XQFgyOmF2SgGigLnfP1eRWKolmdEhFOvu9vMuyWTgV
         wMWwWGAPaxPnsbhh36urIxb4iArdCeu5TXDQJGE/xHe/2TmWXqTEGwhoFtm+gUQUvx
         dD1H426W5KfkkQcn6XfxooFvlD++NyLYPiSuCIvc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210616064920epcas1p27791bdc7f0c35b3d370440bab44d1d4d~I-UopaVqt3236832368epcas1p2d;
        Wed, 16 Jun 2021 06:49:20 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.163]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4G4bQ634K8z4x9Q8; Wed, 16 Jun
        2021 06:49:18 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        27.BC.09824.EEE99C06; Wed, 16 Jun 2021 15:49:18 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210616064917epcas1p2fb3dde56754082dacaac21c3cbfc1f14~I-UmLBYJX3236832368epcas1p2L;
        Wed, 16 Jun 2021 06:49:17 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210616064917epsmtrp17cc946cdde10d3df454dd72d0fab8d00~I-UmJ6DVG2506125061epsmtrp1o;
        Wed, 16 Jun 2021 06:49:17 +0000 (GMT)
X-AuditID: b6c32a37-04bff70000002660-fb-60c99eee1cc8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        11.AF.08637.DEE99C06; Wed, 16 Jun 2021 15:49:17 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210616064917epsmtip2c8b8ce0289b1475b449973fe97ee7e67~I-Ul5zQmj1891618916epsmtip2s;
        Wed, 16 Jun 2021 06:49:17 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Christoph Hellwig'" <hch@infradead.org>
Cc:     <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-cifs@vger.kernel.org>, <smfrench@gmail.com>,
        <stfrench@microsoft.com>, <willy@infradead.org>,
        <aurelien.aptel@gmail.com>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        <senozhatsky@chromium.org>, <sandeen@sandeen.net>,
        <aaptel@suse.com>, <viro@zeniv.linux.org.uk>,
        <ronniesahlberg@gmail.com>, <hch@lst.de>,
        <dan.carpenter@oracle.com>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Hyunchul Lee'" <hyc.lee@gmail.com>
In-Reply-To: <YMhgrNGLhORjok1H@infradead.org>
Subject: RE: [PATCH v4 03/10] cifsd: add trasport layers
Date:   Wed, 16 Jun 2021 15:49:17 +0900
Message-ID: <009e01d7627b$ba613070$2f239150$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJhIpvEjjDPMdIB0j/UYsSOvpftcQGV6yKWAuKRMRACLRRmUqnNYT6g
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTVxzHc+693LYs3e4q6AniqDewhG5gaykcjJhlGGgGS5huZJkKdPRa
        wNI2vRenTpbiQh0VeWxmCy+nOEUl8hKVh0goTug6xwaODRXdA2aB8c42Ga+1XMz47/M7v+/v
        fPM9DyEuGSX9hOkGjjEbNHqa9CaudwbLQyZOO1Lkl/t9UM64k0BdY4sCNLb0BYGcRZUYulT9
        NYb6H08KkGu5BUdzy/8AdLPNQaC+lnISnSyY8UK592Sotb6SRFdmfxegP12dJLpf/CWJeha7
        vND803LyNYm6zPIDoW4uHRSor16UqVvPzGLq1gELqc5tWhSop4fvE+rGc79i6trGHwn1bMNL
        6oahcSzhuff029MYjZYxSxlDqlGbbtBF0XG7k6OTVeFyRYgiEkXQUoMmk4mid8YnhMSk693J
        aOlBjT7LvZSgYVl6y47tZmMWx0jTjCwXRTMmrd6kkJtCWU0mm2XQhaYaM7cp5PKtKrcyRZ/2
        JOchMP2MHbpV0otbwHHMBoRCSIXB6amjNuAtlFBNAF75+ImAL2YAbP5lmOCLvwF85HSSzyZq
        HCp+vQ3Aju5PMb5wAXh1qBnYgEhIUiFwaaGd9LCPm++edQGPCKdyCFg37sA8DZG70XpsmfDw
        OgrBE99/I/AwQQXBvpJLKyymIuHtjgqS5xeho2RoRY9TAfDGeDnuYUhJ4dzwBS/eLAYODixg
        vMYHluVZcY8xpD4Twbylm4Af2AkfzlatDq+Do12NAp794EihdZU/gN2OfzGej8K607cEfHwl
        zHdxHsSpYFjbsoVXbIbN8xWAt30eTvyV78WrxfATq4SXBMGC3s7VDTdC2/EpQRGgS9cEK10T
        rHRNgNL/zc4A4jJYz5jYTB3DKkzKtXfdAFYevSyiCXw+PhVqB5gQ2AEU4rSPOITtTpGItZrD
        RxizMdmcpWdYO1C5j7oY9/NNNbp/jYFLVqi2KpVKFBYeEa5S0hvEzaQ9RULpNBxzgGFMjPnZ
        HCYU+Vmw8wkv7w+fH6mWBld2Jenulp+q31TQMdGWncSN2UR3chP2PQiwb/v25KPCV9+yTvX5
        N8xl5p9viTt70NI+sHmuzKLdddtWEyiKnWgPDwvAEn3fDZQb8iTncqMmfhJXRO/e8TqHZcx3
        J6GYmsJ3TvVM1u6LloVmxx/7LeZE/8zeNp83780E7WnS1lV1yiSixg+5i3s7FtZP/nHtWnHk
        dzLn9IOM0cEbRfrskY8W9nBlVi5t6XFchTVW3unrbPf2p6u+mq3vCtxEvTFKpOA6+/vx7fsr
        u7mqWP+M0acF12tfcMVSu6zlr4xRRxIvxA69PXV441zvofQ7rQcsSNuTuMFUrTdM0gSbplHI
        cDOr+Q8efOWLfQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsWy7bCSvO7beScTDKasNbFofHuaxeL467/s
        Fq//TWexOD1hEZPFytVHmSyu3X/PbvHi/y5mi5//vzNa7Nl7ksXi8q45bBa9fZ9YLVqvaFns
        3riIzWLt58fsFm9eHGazuDVxPpvF+b/HWS1+/5jD5iDkMbvhIovHzll32T02r9Dy2L3gM5PH
        7psNbB6tO/6ye3x8eovFY8vih0we67dcZfH4vEnOY9OTt0wB3FFcNimpOZllqUX6dglcGc8b
        7zAW3GCq2DfzEnMDYztTFyMHh4SAicS6k6ZdjFwcQgK7GSVeLTrN3MXICRSXljh24gwzRI2w
        xOHDxRA1zxgl+n5cYQKpYRPQlfj3Zz8biC0CZJ9d+IIRpIhZYDKLxK7f29ghOu4xSqw/cBus
        ihOoanfTfxYQW1jAQqL7wil2EJtFQFXi8syVYDavgKXEkYNz2SBsQYmTM5+wgFzBLKAn0baR
        ESTMLCAvsf3tHKhDFSR+Pl3GCnGEm8Tdm3+YIGpEJGZ3tjFPYBSehWTSLIRJs5BMmoWkYwEj
        yypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOCI19Lcwbh91Qe9Q4xMHIyHGCU4mJVE
        eHWLTyQI8aYkVlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwBT9
        fiLbCcMdNgbcnUsFbZe33gwOcZS8/6feQd9xxYUrh/MSOgSuheW8nrCfQcJHarfvrPg9Otyf
        gyUEtpnfyaw64rnOYmrMYusbojf1z8450qL/hvO0QRPnq0MMJ2eUv6hXFXTbdE+SoTLcruLW
        PcW5U9kXaqSsFZPL73p6cZ9i24QHdqtten9ER09+vEi5ZkFIpaCW9JGa35x3s1Y+84tmr9fd
        f2+5suHMjFdHV9loKc2P5353W0vm4HudJ5WZD2QTQ7l2VxqJ8Svp/ss7O7N947WFfDWZXttk
        JX9Gv020Tlzza/UCf+db5bsviiRVF764yTCh+3XVT8+IavUfRWW3lvQ+iy1mdUrlVcqco8RS
        nJFoqMVcVJwIAKdvgkVnAwAA
X-CMS-MailID: 20210616064917epcas1p2fb3dde56754082dacaac21c3cbfc1f14
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210602035816epcas1p240598e76247034278ad45dc0827b2be7
References: <20210602034847.5371-1-namjae.jeon@samsung.com>
        <CGME20210602035816epcas1p240598e76247034278ad45dc0827b2be7@epcas1p2.samsung.com>
        <20210602034847.5371-4-namjae.jeon@samsung.com>
        <YMhgrNGLhORjok1H@infradead.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> On Wed, Jun 02, 2021 at 12:48:40PM +0900, Namjae Jeon wrote:
> > This adds transport layers(tcp, rdma, ipc).
> 
> Please split this into one patch for each, which is a much more sensible patch split that many of the
> others.
> 
> This also seems to include a lot of mgmt/ code.
Okay, I will do that on next version set.

Thanks!

