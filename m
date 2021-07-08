Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C738C07E9C
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 00:35:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E726D61C7F
	for <linux-cifs@archiver.kernel.org>; Thu,  8 Jul 2021 00:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhGHAij (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 7 Jul 2021 20:38:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61938 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbhGHAij (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 7 Jul 2021 20:38:39 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210708003556epoutp04f00b82946d277a505887de4309428ac3~Pqa4-xBUR0370403704epoutp04V
        for <linux-cifs@vger.kernel.org>; Thu,  8 Jul 2021 00:35:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210708003556epoutp04f00b82946d277a505887de4309428ac3~Pqa4-xBUR0370403704epoutp04V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1625704556;
        bh=EwrYyQcpWawI5Fld5oT8ahpOoWoON5EpWbrDsjKH02o=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=LS23Jmx5B9ZJ4uadnBGKWYZmrvvyu2jeOAecP+IICVvhtb9uq1tuHIW3f98BzJw4m
         0rzZ94a+qpikC1fC74O3nx2xRFZPt1n8p6GPr08T9RGLRlUovAs8OVIyXc5rgQw5EW
         mzmzMjhQQnoTFj0tT/TIPG5nHgJSGRJWIn5I9WLg=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20210708003555epcas1p39c983a949a8f362b82e00c044a78636d~Pqa4mG7wR0889208892epcas1p3P;
        Thu,  8 Jul 2021 00:35:55 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.160]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4GKy5701Qrz4x9Px; Thu,  8 Jul
        2021 00:35:55 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        52.45.09551.86846E06; Thu,  8 Jul 2021 09:35:52 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210708003552epcas1p171e154ff767c38ed9f4b64c5d6466278~Pqa1HAesx1011610116epcas1p1y;
        Thu,  8 Jul 2021 00:35:52 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210708003552epsmtrp2a467242d855159c4d3bf12ffa2b333ab~Pqa1GL3a20910209102epsmtrp2g;
        Thu,  8 Jul 2021 00:35:52 +0000 (GMT)
X-AuditID: b6c32a36-2c9ff7000000254f-a2-60e648683e24
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        21.18.08394.86846E06; Thu,  8 Jul 2021 09:35:52 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210708003551epsmtip26a9c16e2a6e25a864147242e374b6b22~Pqa04M1Rs2039720397epsmtip2d;
        Thu,  8 Jul 2021 00:35:51 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Dan Carpenter'" <dan.carpenter@oracle.com>
Cc:     "'Sergey Senozhatsky'" <senozhatsky@chromium.org>,
        "'Steve French'" <sfrench@samba.org>,
        "'Hyunchul Lee'" <hyc.lee@gmail.com>, <linux-cifs@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
In-Reply-To: <YOV+xDbnpDrR/Ipj@mwanda>
Subject: RE: [PATCH] ksmbd: use kasprintf() in ksmbd_vfs_xattr_stream_name()
Date:   Thu, 8 Jul 2021 09:35:51 +0900
Message-ID: <002101d77391$348b5e40$9da21ac0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKbYNqOz5tmC91+maLhZR2jJDEFjwF2ph+WqaSq03A=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsWy7bCmgW6Gx7MEgwfTNS1e/5vOYnHt/nt2
        i623pC1e/N/FbLF74yI2i46XR5kd2DxmN1xk8dg56y67x8ent1g85u7qY/T4vEkugDUqxyYj
        NTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6AAlhbLEnFKg
        UEBicbGSvp1NUX5pSapCRn5xia1SakFKToGhQYFecWJucWleul5yfq6VoYGBkSlQZUJOxrON
        cxgL5jBVLLj2hrWB8QljFyMHh4SAicSvafldjFwcQgI7GCUedO1hhnA+MUo07HnDCOF8Y5SY
        +7KHvYuRE6zj+McN7BCJvYwSh25cZ4JwXjBK7NrVwARSxSagK/Hvz342EFtEwEDi3skXLCBF
        zALHGCV2zp7MCJLgFFCTmPaxH6xBWMBH4u3RnywgNouAisT2s2tZQQ7kFbCUeHLRFyTMKyAo
        cXLmE7ASZgF5ie1v5zBDXKQg8fPpMrByEQErid3zQiFKRCRmd7aBvSMhMJVD4uXihSwQ9S4S
        bTdPQdnCEq+Ob4H6TEri87u9bBB2ucSJk7+YIOwaiQ3z9rFDwstYoudFCYjJLKApsX6XPkSF
        osTO33MZIdbySbz72sMKUc0r0dEmBFGiKtF36TDUQGmJrvYP7BMYlWYh+WsWkr9mIXlgFsKy
        BYwsqxjFUguKc9NTiw0LjJCjehMjOGlqme1gnPT2g94hRiYOxkOMEhzMSiK8jA5PE4R4UxIr
        q1KL8uOLSnNSiw8xmgIDeiKzlGhyPjBt55XEG5oaGRsbW5iYmZuZGiuJ8+5kO5QgJJCeWJKa
        nZpakFoE08fEwSnVwJTBflojRX3h9bBqO49UTz2eL2ZZdycGtNVke25blJYYZu9xMpRj2tTT
        X38IzZnnausj9Dtb4P2j3sJzP813S0reDxJ3U5S/tz1I0mpWQuVq/+SC93ePlWW9k/mj9WjD
        SlfWEom1zd+rSx7FtKRfuGfwWmgb58XKJYte6/+4rpZU+/9Bp1pwyOIF/+ceWi8671iOHuMW
        tUl2AqVWxSkfcgRFZawfHPJal1p2d/283jOfypQ9fBpqpnl4FIiuf5Z4oaP3opRXSabRnkhb
        1pvi7ToqHi8WtbhHCc1dffHsNb8IvdIFQadOMzGfSaqs9GB7tMhI8MsVee2dlkEBqVOq71yS
        LVgToBe845SX56YfSizFGYmGWsxFxYkATDI3RSMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWy7bCSvG6Gx7MEgw1HWSxe/5vOYnHt/nt2
        i623pC1e/N/FbLF74yI2i46XR5kd2DxmN1xk8dg56y67x8ent1g85u7qY/T4vEkugDWKyyYl
        NSezLLVI3y6BK+PZxjmMBXOYKhZce8PawPiEsYuRk0NCwETi+McN7F2MXBxCArsZJfbeWsoM
        kZCWOHbiDJDNAWQLSxw+XAxR84xRon9lLxtIDZuArsS/P/vBbBEBA4l7J1+wgBQxC5xilLhz
        7SjYBiGBcolrD5+D2ZwCahLTPvYzgdjCAj4Sb4/+ZAGxWQRUJLafXcsKsoxXwFLiyUVfkDCv
        gKDEyZlPWEDCzAJ6Em0bwaYwC8hLbH87B+pMBYmfT5eBdYoIWEnsnhcKUSIiMbuzjXkCo/As
        JINmIQyahWTQLCQdCxhZVjFKphYU56bnFhsWGOallusVJ+YWl+al6yXn525iBMeOluYOxu2r
        PugdYmTiYDzEKMHBrCTCy+jwNEGINyWxsiq1KD++qDQntfgQozQHi5I474Wuk/FCAumJJanZ
        qakFqUUwWSYOTqkGJt0fLz4/814W/fdAjujvHLGvZzYzm008eHVF+Jwzuscv/L98+QD3ldfK
        en8S+iMa7qX4RuyUWrBbc64JM/vkpMW8k4Lq1T/FNawXXO1o8yLurlSC2qTcbZZbf1055rTz
        4737Xa++T/FYYmitYbVp6plLFRuWRPl9qbpxTJt//Zl9/OndJ7fr2JpUlKzql0z6eWWnilNo
        JGe82psTzrV7uHL+KfjOWLbhM0Pq4cyvpQ/m3Hi4zldSaFlgw9pX1s6qfGrzJd/qapSeU77C
        ErgmNXl22KlO85SZn5jq1+w9IbPAti7zmM4Vl6VeKs++maie2THpPtOpoN2X6i4UHU5ce0NH
        6FSR2Db+Pptpqyv2pZYosRRnJBpqMRcVJwIAwAhMqgwDAAA=
X-CMS-MailID: 20210708003552epcas1p171e154ff767c38ed9f4b64c5d6466278
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210707101617epcas1p12eede31054d5985ad00297f45102bcd5
References: <CGME20210707101617epcas1p12eede31054d5985ad00297f45102bcd5@epcas1p1.samsung.com>
        <YOV+xDbnpDrR/Ipj@mwanda>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> Simplify the code by using kasprintf().  This also silences a Smatch
> warning:
> 
>     fs/ksmbd/vfs.c:1725 ksmbd_vfs_xattr_stream_name()
>     warn: inconsistent indenting
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Thanks for your patch. I will apply.

