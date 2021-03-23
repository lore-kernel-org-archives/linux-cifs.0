Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52822C433E0
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Mar 2021 05:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27AE1619B3
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Mar 2021 05:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhCWFfd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Mar 2021 01:35:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11452 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhCWFfH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Mar 2021 01:35:07 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210323053505epoutp035432d3a0a04e3c4863b3347893318c6b~u4eiYeFzb1400714007epoutp03N
        for <linux-cifs@vger.kernel.org>; Tue, 23 Mar 2021 05:35:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210323053505epoutp035432d3a0a04e3c4863b3347893318c6b~u4eiYeFzb1400714007epoutp03N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1616477705;
        bh=gQjyguLaBbjy93jFGQTyXsiTkaZxiPVVbFZD/zYWHqk=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=IdNOrAexaoj93bYsu/Si7DdS3ccG3q2ZdzsjjS4qJmqGaKUU7DOJWAV4Wa5gUR50x
         V/PqJDkm9BSCaSPsneBjZjTv1bcNbH5ubtFhII+v20T6hrXsfJpQi7Ub1huFZT+5Di
         937iWa02ySTg92DOkPeIEjmKwmAAD0I9IRtqa/NI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210323053504epcas1p1bea16d336c86331738ba2d36f7dd1d8c~u4ehs90Ng1197011970epcas1p1F;
        Tue, 23 Mar 2021 05:35:04 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.159]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4F4Kng1gJ3z4x9Pt; Tue, 23 Mar
        2021 05:35:03 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        9E.88.50768.70E79506; Tue, 23 Mar 2021 14:35:03 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210323053502epcas1p11d1920a160d484c700aed547030b372a~u4egAHsmV0422404224epcas1p1w;
        Tue, 23 Mar 2021 05:35:02 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210323053502epsmtrp2bc6f12e4870264b8f2d09d480d61f32b~u4ef-VovM3168731687epsmtrp24;
        Tue, 23 Mar 2021 05:35:02 +0000 (GMT)
X-AuditID: b6c32a37-fd9ff7000000c650-95-60597e078c67
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CD.07.13470.60E79506; Tue, 23 Mar 2021 14:35:02 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210323053502epsmtip2f156c3f47aad4fd1e32ba39a59dabd69~u4ef0OmDi2664826648epsmtip2n;
        Tue, 23 Mar 2021 05:35:02 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Dan Carpenter'" <dan.carpenter@oracle.com>
Cc:     "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Steve French'" <sfrench@samba.org>,
        "'Hyunchul Lee'" <hyc.lee@gmail.com>,
        "'Ronnie Sahlberg'" <lsahlber@redhat.com>,
        <linux-cifs@vger.kernel.org>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        <kernel-janitors@vger.kernel.org>
In-Reply-To: <YFiuo53u7GHg7cU5@mwanda>
Subject: RE: [PATCH] cifsd: Fix an error code in smb2_read()
Date:   Tue, 23 Mar 2021 14:35:02 +0900
Message-ID: <00f401d71fa6$45e5f6d0$d1b1e470$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQMmNmoMXA2EsxVJ+e0peq3551WO1gJIQ+DBp+CdNYA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPJsWRmVeSWpSXmKPExsWy7bCmni57XWSCwaYF3Bav/01nsbh2/z27
        xdZb0hYv/u9itvj5/zujxYKr+hZrPz9mt+h4eZTZgcNj56y77B67F3xm8vj49BaLx/t9V9k8
        5u7qY/T4vEkugC0qxyYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnF
        J0DXLTMH6BwlhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToGhQYFecWJucWleul5y
        fq6VoYGBkSlQZUJOxss5bAVT2SqOfjrA1MD4laWLkZNDQsBEYtm0aUxdjFwcQgI7GCXm75sD
        5XxilJh9bQ4LhPONUeLZ4hdMMC23H15nhUjsBWpZdYERJCEk8JJR4v6tCBCbTUBX4t+f/Wwg
        toiAgcS9ky/AJjELLGKSWN51CayBU0BN4tOarWCHCAvYSHxcsQhsA4uAqsSaK9eZQWxeAUuJ
        e1uPMEHYghInZz4Bq2cWkJfY/nYOM8RFChI/ny5jhVhmJfF31wImiBoRidmdbcwgiyUElnJI
        rNj5mhWiwUXi7YTTUM3CEq+Ob2GHsKUkPr/bC3Q1B5BdLfFxP1RJB6PEi++2ELaxxM31G1hB
        SpgFNCXW79KHCCtK7Pw9lxFiLZ/Eu689rBBTeCU62oQgSlQl+i4dhoahtERX+wf2CYxKs5A8
        NgvJY7OQPDALYdkCRpZVjGKpBcW56anFhgXGyHG9iRGcUrXMdzBOe/tB7xAjEwfjIUYJDmYl
        Ed6W8IgEId6UxMqq1KL8+KLSnNTiQ4ymwKCeyCwlmpwPTOp5JfGGpkbGxsYWJmbmZqbGSuK8
        SQYP4oUE0hNLUrNTUwtSi2D6mDg4pRqY3CO3MJRNml4at2pl38zETCWvoECT619+/0lffL00
        N8BWmuunxXHTs6+bzBN/zgh0TZHgNgv6ej9rgtSc9Ck23Jc0ZzzKFTsQfupWQl/CkUuM1yqu
        V2xf37FUqmypfa0G34M76y3ncX4qkg67xRy/2dr+pPS1+xtjvZ+ub/5RWD2fscT5QXLtsrRp
        Iaee/p+ysuTj++SjO3o2Hz2tpJ7+ojNfYInS6vtmbz+uONN/tY6DQbJIvNS6X7J2K3/dc5OP
        1pJPPxs5XNz/++KJi4fKfzq7pK1onHuDz1OtoszwtPr02eH7Vf/edfyxLmN+ryLLY/6OPcfc
        3K7MUmDqfu5QMvdOvJ/nd+9N85vvhiW+VmIpzkg01GIuKk4EABWz2bEyBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42LZdlhJXpetLjLB4Ei/jsXrf9NZLK7df89u
        sfWWtMWL/7uYLX7+/85oseCqvsXaz4/ZLTpeHmV24PDYOesuu8fuBZ+ZPD4+vcXi8X7fVTaP
        ubv6GD0+b5ILYIvisklJzcksSy3St0vgyng5h61gKlvF0U8HmBoYv7J0MXJySAiYSNx+eJ21
        i5GLQ0hgN6PEob27mCES0hLHTpwBsjmAbGGJw4eLIWqeM0oce3WYEaSGTUBX4t+f/WwgtoiA
        gcS9ky9YQIqYBVYwSdw+vJgVJCEkUC7x6NF8sKGcAmoSn9ZsBdssLGAj8XHFIiYQm0VAVWLN
        letgNbwClhL3th5hgrAFJU7OfMICcgSzgJ5E20awvcwC8hLb386BulNB4ufTZawQN1hJ/N21
        gAmiRkRidmcb8wRG4VlIJs1CmDQLyaRZSDoWMLKsYpRMLSjOTc8tNiwwzEst1ytOzC0uzUvX
        S87P3cQIjiwtzR2M21d90DvEyMTBeIhRgoNZSYS3JTwiQYg3JbGyKrUoP76oNCe1+BCjNAeL
        kjjvha6T8UIC6YklqdmpqQWpRTBZJg5OqQam6MDbjCknfWLqBfa6zCmdUb1gt8Yu27CN77UT
        azZf25PVrf3zhXX42f0SvYrxXyWL2jSUankrFauTv5tWhbdMyHtfv/P99U+FTOwez/e2RP9R
        q5SOat0doqu4J5KhZidDaEbsI4tpa2rKliakHZy/SJ3DRcrOo6k4Smuup+Lp4/eyN+lvXf90
        9WedFz6s55ZOb9Qq+a+2q17l5fr2B3+kVvIlzt6393ZgqVCT3vwYCY8t67u/1Cyc+WzGlzOC
        f3o/clXO2fX6f0ue7bozbw8cmx18k72l5vyMC93VqV/a1pjGPC2OeWb+2+PRnLXH9cyZHFQK
        j/xg+e9kvDburmLipKpFIvddHDoXaEmdWn9DiaU4I9FQi7moOBEAoX9rJRsDAAA=
X-CMS-MailID: 20210323053502epcas1p11d1920a160d484c700aed547030b372a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210322145056epcas1p2803a480b8b83f038407553c2b25fd384
References: <CGME20210322145056epcas1p2803a480b8b83f038407553c2b25fd384@epcas1p2.samsung.com>
        <YFiuo53u7GHg7cU5@mwanda>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Dan,
> This code is assigning the wrong variable to "err" so it returns zero/success instead of -ENOMEM.
> 
> Fixes: 788b6f45c1d2 ("cifsd: add server-side procedures for SMB3")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
I will apply this patch.
Thanks for your work!
> ---
>  fs/cifsd/smb2pdu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/cifsd/smb2pdu.c b/fs/cifsd/smb2pdu.c index 32816baa8a99..6770ebedc24a 100644
> --- a/fs/cifsd/smb2pdu.c
> +++ b/fs/cifsd/smb2pdu.c
> @@ -6200,7 +6200,7 @@ int smb2_read(struct ksmbd_work *work)
>  		work->aux_payload_buf = ksmbd_alloc_response(length);
>  	}
>  	if (!work->aux_payload_buf) {
> -		err = nbytes;
> +		err = -ENOMEM;
>  		goto out;
>  	}
> 
> --
> 2.30.2


