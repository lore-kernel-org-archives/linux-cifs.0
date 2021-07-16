Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08524C07E95
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Jul 2021 07:56:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E059460E0B
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Jul 2021 07:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237069AbhGPH7g (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Jul 2021 03:59:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14720 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbhGPH7b (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Jul 2021 03:59:31 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210716075634epoutp04f5c7f2c2f5e19b638b21a49212870240~SNl56-DEn1255312553epoutp04b
        for <linux-cifs@vger.kernel.org>; Fri, 16 Jul 2021 07:56:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210716075634epoutp04f5c7f2c2f5e19b638b21a49212870240~SNl56-DEn1255312553epoutp04b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626422194;
        bh=I5/zKF+mn12wN8G9nZA21Y4QR5K5HKpK04YGo0CsQMw=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=B2T/R0KxeVaQ1RyBN62prkqhMNY3MSOKckiEbBRXkgmVpXVJ6/xtNSht5Zbvxi2Ob
         YsYhDj+Uv2lk3hjsURttLWyUOM8H63H39Luz71mv43iF5s9Lv39syK/6jnnv+/C6b3
         OGpZbrHiNpYAvmVo+2YFM5wdbwmrYro5lQqsAQ4I=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20210716075634epcas1p3f09576b6474995190061d46f451fb55e~SNl5j1AFW1786317863epcas1p3j;
        Fri, 16 Jul 2021 07:56:34 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.160]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4GR3Ts2yHBz4x9Q1; Fri, 16 Jul
        2021 07:56:33 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        86.48.09551.1BB31F06; Fri, 16 Jul 2021 16:56:33 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210716075632epcas1p207e5c09533e733354ab1e16c9098a844~SNl4HaWWS2680126801epcas1p2E;
        Fri, 16 Jul 2021 07:56:32 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210716075632epsmtrp20c3a214cc7aa890bf08e8fb62a14efe2~SNl4GvWKu0627706277epsmtrp2D;
        Fri, 16 Jul 2021 07:56:32 +0000 (GMT)
X-AuditID: b6c32a36-2c9ff7000000254f-68-60f13bb14673
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        46.EC.08394.0BB31F06; Fri, 16 Jul 2021 16:56:32 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210716075632epsmtip16ed25dc68c017280cfb0192d8de553e1~SNl38qTdv0689906899epsmtip1H;
        Fri, 16 Jul 2021 07:56:32 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Stefan Metzmacher'" <metze@samba.org>
Cc:     <linux-cifsd-devel@lists.sourceforge.net>,
        <linux-cifs@vger.kernel.org>
In-Reply-To: <d6d4e15b-95aa-38d1-40f7-14f99fe24260@samba.org>
Subject: RE: [Linux-cifsd-devel] [PATCH] ksmbd-tools: add support for SMB3
 multichannel
Date:   Fri, 16 Jul 2021 16:56:33 +0900
Message-ID: <003001d77a18$17fadfc0$47f09f40$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKULK/y1rzC9SYQxxkpz/fmxPdeDwGkqamZAc17dDepsETyIA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsWy7bCmge5G648JBpfm81i8+L+L2eLn/++M
        FheX/WRxYPbYveAzk8fcXX2MHp83yQUwR+XYZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjq
        GlpamCsp5CXmptoqufgE6Lpl5gAtUlIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQU
        GBoU6BUn5haX5qXrJefnWhkaGBiZAlUm5GTM3H+YueAGd8XdKxPYGhjncHYxcnJICJhI9DWd
        Y+li5OIQEtjBKHFjexsbhPOJUeL6pLOsEM43RomTi3ezwbTMbt8NldjLKPFu509GCOcFo8Tt
        WZ8YQarYBHQl/v3ZD9YhIqAtcejVHXYQm1nAW+LriivMIDangK1E46nZTCC2sECkxJVlG8Fq
        WARUJfa1bQKr4RWwlJi3/z87hC0ocXLmExaIOfIS29/OYYa4SEHi59NlrBC7nCT6nm1ghqgR
        kZjd2cYMcpyEwFt2iel7V7BDNLhI/Fj9mhXCFpZ4dXwLVFxK4vO7vVBvlkucOPmLCcKukdgw
        bx9QDQeQbSzR86IExGQW0JRYv0sfokJRYufvuYwQa/kk3n3tYYWo5pXoaBOCKFGV6Lt0GGqg
        tERX+wf2CYxKs5A8NgvJY7OQPDALYdkCRpZVjGKpBcW56anFhgVGyJG9iRGcCLXMdjBOevtB
        7xAjEwfjIUYJDmYlEd7l6h8ThHhTEiurUovy44tKc1KLDzGaAoN6IrOUaHI+MBXnlcQbmhoZ
        GxtbmJiZm5kaK4nz7mQ7lCAkkJ5YkpqdmlqQWgTTx8TBKdXAFNFwISZ17anH745+WtPc/vjD
        TllZtRWlWdMKe2fJVnd/fnxp8wmHM8dDtD4IyPKeeXGr4lHq18cbpn02S8/ne7WSbWrc2mh+
        m/J7C/MsxRJlpnYHhIn+Vly0rKDZhCHWefovQ33+x7vzN08PuhOX9G72R8a94bL3Tl5oz/eL
        TteOb9W6z8odszrQt/DLhumlaSzLZyw012jpUP9oWhc4/yejl0H3PWUhy09v8m/cXHi4++DM
        aa9/LUpf+/q45aZQprcmuuW3u/PXFVq6XM/OXaqVp83X8DFjdtnb89nqmwJur1MU/+2dqMFX
        nG5xr+G0s8D5nM562e2JYtespq1h5bebs+lfeIOpTPfnN7+ZlViKMxINtZiLihMB2hIx3w0E
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsWy7bCSnO4G648JBjMOGlq8+L+L2eLn/++M
        FheX/WRxYPbYveAzk8fcXX2MHp83yQUwR3HZpKTmZJalFunbJXBlzNx/mLngBnfF3SsT2BoY
        53B2MXJySAiYSMxu383axcjFISSwm1Fi9cPF7BAJaYljJ84wdzFyANnCEocPF4OEhQSeMUo0
        fRACsdkEdCX+/dnPBmKLCGhLHHp1B6yVWcBX4u6s2VAz9zNKXJn5GKyIU8BWovHUbCaQmcIC
        4RLLp+aBhFkEVCX2tW1iBrF5BSwl5u3/zw5hC0qcnPmEBWKmtkTvw1ZGCFteYvvbOcwQZypI
        /Hy6jBXiBieJvmcbmCFqRCRmd7YxT2AUnoVk1Cwko2YhGTULScsCRpZVjJKpBcW56bnFhgWG
        eanlesWJucWleel6yfm5mxjB8aCluYNx+6oPeocYmTgYDzFKcDArifAuV/+YIMSbklhZlVqU
        H19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILUIpgsEwenVAPT5IDLSjKuNx7MiZk84el1
        72VFobI7QqaIJN7ItJ823e+2xO28E4yPph6tNJJPMlugy+Iyq2fdi/9CG6fkzJgrx7W/SW37
        XdYH2gcvbLtXtyrbsr1CMDhyk/8j3c2fjRfNMZrszyHTL/PGOJFh5gzzu4aKGlWTpil9P3Yj
        K3xCuFb1mop5+Q8O3OH+utDmtrbzibkTDM8cfn4kTy7jCztLtFhLnum7Y9zumfFTs3fInmKt
        PPh7n+iuux/4D2WtUZfWqZBSt2TXrP5wdJkrW4gG61f5+Q1TprE4zDmyeH/UqdlW1g1bdndG
        Mml+ZoqPmqC26v/3c65tP7d5WezsOFW1zbBJ+tOzy6/vR/P8Vr58X4mlOCPRUIu5qDgRAM+7
        Wlz2AgAA
X-CMS-MailID: 20210716075632epcas1p207e5c09533e733354ab1e16c9098a844
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210614085106epcas1p4143f68f380c480f5f8a504370b10a969
References: <CGME20210614085106epcas1p4143f68f380c480f5f8a504370b10a969@epcas1p4.samsung.com>
        <20210614084135.19753-1-namjae.jeon@samsung.com>
        <d6d4e15b-95aa-38d1-40f7-14f99fe24260@samba.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> Hi Namjae,
Hi Metze,

> 
> > Add support for SMB3 multichannel.
> >
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > ---
> >  Documentation/configuration.txt | 3 +++
> >  include/linux/ksmbd_server.h    | 1 +
> >  lib/config_parser.c             | 9 +++++++++
> >  3 files changed, 13 insertions(+)
> >
> > diff --git a/Documentation/configuration.txt
> > b/Documentation/configuration.txt index f38aceb..1289cbf 100644
> > --- a/Documentation/configuration.txt
> > +++ b/Documentation/configuration.txt
> > @@ -109,6 +109,9 @@ Define ksmbd configuration parameters list.
> >  		host where ksmbd runs. the format is "cifs/<FQDN>". if this
> >  		option is not given, ksmbd sets "cifs" to the service name and
> >  		try to get the host FQDN using getaddrinfo(3).
> > +	- server multi channel support
> > +		This boolean parameter controls whether ksmbd will support
> > +		SMB3 multi-channel.
> 
> Did you actually implemented all replay related features?
> - Create replay
> - Lock replay
> - Write/IOCtl/SetInfo replay
> - Lease/OplockBreak replay
Not yet.
> 
> Otherwise you should mark this as experimental, as it's likely to end with potential data coruption.
> That's why Samba had this flagged as experimental up to now, Samba 4.15 will be the first release with
> all required features in order to enable multi channel.
Okay. I will mark it as experimental till relay features are implemented.

Thanks for your review!
> 
> metze


