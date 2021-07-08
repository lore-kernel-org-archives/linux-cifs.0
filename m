Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D77C07E95
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 00:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4815161CCB
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 00:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbhGHAgG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Jul 2021 20:36:06 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40248 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbhGHAgF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Jul 2021 20:36:05 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210708003323epoutp014ac8fee6d691dae67e13cb06c552f08d~PqYqfnA700851208512epoutp01D
        for <linux-cifs@vger.kernel.org>; Thu,  8 Jul 2021 00:33:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210708003323epoutp014ac8fee6d691dae67e13cb06c552f08d~PqYqfnA700851208512epoutp01D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1625704403;
        bh=FjAyIZm4iXyw7BTlZp1Mq4VStQs0O8MPMznlxXikJbM=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=HVOJOX+IzR77ANe8mGdQzEujQZwEZr5oIpUcIeLksdHU1abbbGBFSE3EiG9O2DG3A
         4Po/cyYHf1BV/PcNuspV6cuwjLx3ARaBK2m0gVFX8onXuUmHZS9lcXhW1UDLZ6A1H9
         DwV+yP0Of4XTYuB1R5gVgXZqNu+CGvOeI0ZX2ttk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20210708003322epcas1p4da813c12758e8897638ae944d662d6a0~PqYpefj3l2838428384epcas1p4R;
        Thu,  8 Jul 2021 00:33:22 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.165]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4GKy292WNpz4x9Q6; Thu,  8 Jul
        2021 00:33:21 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        CF.3F.09468.1D746E06; Thu,  8 Jul 2021 09:33:21 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210708003320epcas1p1da0984ef9b7b4ab344114c208816201a~PqYnuD4k32170021700epcas1p1-;
        Thu,  8 Jul 2021 00:33:20 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210708003320epsmtrp2accdb1e41715061e1a5f21029dd8b70f~PqYntYAid0811808118epsmtrp2A;
        Thu,  8 Jul 2021 00:33:20 +0000 (GMT)
X-AuditID: b6c32a37-0c7ff700000024fc-1d-60e647d17e72
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        15.99.08289.0D746E06; Thu,  8 Jul 2021 09:33:20 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210708003320epsmtip26205cc5fe821ddf8472fd916fdac06d5~PqYnhm5b11859318593epsmtip25;
        Thu,  8 Jul 2021 00:33:20 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Dan Carpenter'" <dan.carpenter@oracle.com>
Cc:     "'Sergey Senozhatsky'" <senozhatsky@chromium.org>,
        "'Steve French'" <sfrench@samba.org>,
        "'Hyunchul Lee'" <hyc.lee@gmail.com>, <linux-cifs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
In-Reply-To: <YOV+zDoSSwH2oMzG@mwanda>
Subject: RE: [PATCH] ksmbd: delete some stray tabs
Date:   Thu, 8 Jul 2021 09:33:20 +0900
Message-ID: <002001d77390$da160500$8e420f00$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHE0hI8gX1wPeHvcGZmd+myqkgEIALGdy9hq0dJIoA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEJsWRmVeSWpSXmKPExsWy7bCmnu5F92cJBrdmC1q8/jedxeLa/ffs
        FltvSVu8+L+L2eLyrjlsFrs3LmKz6Hh5lNmB3WN2w0UWj52z7rJ7fHx6i8Vj7q4+Ro/Pm+QC
        WKNybDJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOArlBS
        KEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFBgaFOgVJ+YWl+al6yXn51oZGhgYmQJV
        JuRkzJ79hqVgCmNFxz3DBsbyLkYODgkBE4mLT3K6GLk4hAR2MEqc/HeHEcL5xChx5fEPVgjn
        M6PE3qsHgDKcYB3H355gAbGFBHYxSvRtsoEoesEocWnLHHaQBJuArsS/P/vZQGwRAQOJeydf
        sIAUMYMU9c97ygKym1NATeLvBHeQGmEBI4nXF/aygtgsAioS61e/ByvhFbCUaH1lDBLmFRCU
        ODnzCdheZgF5ie1v5zBD3KMg8fPpMlaIVVYSp258ZYeoEZGY3dnGDLJWQmAuh0TDkwNMEA0u
        EvPO90A1C0u8Or6FHcKWkvj8bi8bhF0uceLkL6j6GokN8/axQ4LLWKLnRQmIySygKbF+lz5E
        haLEzt9zGSHW8km8+9rDClHNK9HRJgRRoirRd+kw1EBpia72D+wTGJVmIXlsFpLHZiF5YBbC
        sgWMLKsYxVILinPTU4sNC4yR43kTIzhxapnvYJz29oPeIUYmDsZDjBIczEoivIwOTxOEeFMS
        K6tSi/Lji0pzUosPMZoCQ3ois5Rocj4wdeeVxBuaGhkbG1uYmJmbmRorifPuZDuUICSQnliS
        mp2aWpBaBNPHxMEp1cA0b2GT1exCiVVaTVIXrFbqaleWz/Xsd13kcMDw/uO3ZxasVlA/LT2f
        JVHxasvHLRyGWas7dV+5mh1fvyxxzuLnd89rXDS8L6nK/3cDz7ubAobuyu9ltc+Unvh7/nD+
        fbk7ravZl9xZ2GOnzfDOfNeUV5lKr3W9ji1alzN7+YFVCzX2CHL1JawM50k23L7pZO7ZBxWz
        eL5d8oqq/P9lc22n9cU3DXwXrvwNue+iuXJSDcOxrq1z3JIX6k9OZ7Z7wzTN2Me0WNvukPEF
        qWNG4kVdV3bUJ13ifL5r+6SA2Bn7K0W26+oIbZp3ufw9zxIvx5rEfW+Czl6ZsMB/oYTNEfVj
        NUfXZcc+lPuYJTVL6L5FnRJLcUaioRZzUXEiAGyivQ0lBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWy7bCSvO4F92cJBo92Clm8/jedxeLa/ffs
        FltvSVu8+L+L2eLyrjlsFrs3LmKz6Hh5lNmB3WN2w0UWj52z7rJ7fHx6i8Vj7q4+Ro/Pm+QC
        WKO4bFJSczLLUov07RK4MmbPfsNSMIWxouOeYQNjeRcjJ4eEgInE8bcnWLoYuTiEBHYwShy5
        cZsFIiEtcezEGeYuRg4gW1ji8OFiiJpnjBINcx8ygdSwCehK/Puznw3EFhEwkLh38gXYIGaB
        N0CDNn1lBUkICZRLzFg5lRFkEKeAmsTfCe4gYWEBI4nXF/aClbAIqEisX/2eBaSEV8BSovWV
        MUiYV0BQ4uTMJ2BhZgE9ibaNjCBhZgF5ie1v5zBDXKkg8fPpMlaIC6wkTt34yg5RIyIxu7ON
        eQKj8Cwkk2YhTJqFZNIsJB0LGFlWMUqmFhTnpucWGxYY5aWW6xUn5haX5qXrJefnbmIER5CW
        1g7GPas+6B1iZOJgPMQowcGsJMLL6PA0QYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC
        6YklqdmpqQWpRTBZJg5OqQYmpaD8xJn1KrfK44R+7Zi+3miD1Y8rB80ebw0o6b5Q8aZKarHk
        4W2H6+NtchNdD13bFC9jJPrc6fmLDwHh1dPW7b30xtJDX/UbW8Z03y0378w85Pb/f8r3ypdK
        H3c885T+IP734smyi1IHZ7h1vL9Y9n7NhKuz9/y8e6RhDlMe85c6gRdsL423TbizM9tAfYl/
        eIViiUxvqf/NS5Y8//rP5BZEXH/6jMFwSsfOec/n3K/9suHlm0M/FvfnhBQrdsWI5fh9zt/z
        z+vKMaejRnHXlzOWacTbV25gXRWtXiOy6NL7a5zqj0VOKjO8ypsz4dXUdWLzNq9y3n6S//U/
        vYBkqxXzkiJe/9ufdvpI2PKuc85KLMUZiYZazEXFiQAaM3XEDwMAAA==
X-CMS-MailID: 20210708003320epcas1p1da0984ef9b7b4ab344114c208816201a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210707101627epcas1p46ab0f709390b2f626b429d58400eefb6
References: <CGME20210707101627epcas1p46ab0f709390b2f626b429d58400eefb6@epcas1p4.samsung.com>
        <YOV+zDoSSwH2oMzG@mwanda>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> These lines are intended one tab too far.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Thanks for your patch. I will apply.

