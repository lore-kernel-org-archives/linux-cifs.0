Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 695EFC433C1
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Mar 2021 00:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B7C961992
	for <linux-cifs@archiver.kernel.org>; Tue, 23 Mar 2021 00:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhCWAOx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 22 Mar 2021 20:14:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:13837 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbhCWAO3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 22 Mar 2021 20:14:29 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210323001427epoutp02205ccafee524d84bc9b091908d7fd64a~u0Gl2C1RD1753917539epoutp02x
        for <linux-cifs@vger.kernel.org>; Tue, 23 Mar 2021 00:14:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210323001427epoutp02205ccafee524d84bc9b091908d7fd64a~u0Gl2C1RD1753917539epoutp02x
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1616458467;
        bh=9ZTqikGfuSNBkZVtRe4z3tgEtRpuhIhnaohbU4HxrVI=;
        h=From:To:In-Reply-To:Subject:Date:References:From;
        b=RK8j+N93BchjKIwSM1cuplxSr8rcMDV5fLrqtw1Zt21uRz6FKhE0PtIopjVYO5wdD
         h7OdPhXMsi+fiff1ZCqNAxYRqh3NcZAQmmgkxbNJIF5pKKlKxYM/ryN9j1DcPJnwbr
         e72K1Ndn1qvyAdcx75TfcMdx+g5pZQum9zkJUcsg=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210323001426epcas1p2bdd263b74a7ccf9bb468e9684009021b~u0GlFhaw21507015070epcas1p2v;
        Tue, 23 Mar 2021 00:14:26 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.163]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4F4Bgj2wB7z4x9Ps; Tue, 23 Mar
        2021 00:14:25 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        ED.7E.10347.FD239506; Tue, 23 Mar 2021 09:14:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210323001423epcas1p2d95fe1898c2f0ec5318bf7379d20b1c3~u0GiG3zpQ1726617266epcas1p2c;
        Tue, 23 Mar 2021 00:14:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210323001423epsmtrp25c51a0775aa582b6e0bd7c1d45c0e0b8~u0GiGGWnX2317923179epsmtrp2H;
        Tue, 23 Mar 2021 00:14:23 +0000 (GMT)
X-AuditID: b6c32a39-15dff7000002286b-ae-605932dfa477
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4B.CF.13470.FD239506; Tue, 23 Mar 2021 09:14:23 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210323001423epsmtip10188c91e8fe89f8003858075d63205f4~u0Gh6ZMpF1180411804epsmtip1e;
        Tue, 23 Mar 2021 00:14:23 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Steve French'" <smfrench@gmail.com>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        "'CIFS'" <linux-cifs@vger.kernel.org>
In-Reply-To: <CAH2r5muFSCWQUVn+iuZ_8fiWrCXtNmO0+AaEEEqFmD9+qj8-1w@mail.gmail.com>
Subject: RE: ksmbd wiki page
Date:   Tue, 23 Mar 2021 09:14:23 +0900
Message-ID: <00ae01d71f79$7a76aa20$6f63fe60$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQFFRxmYUJogNSuAPx+l3/xFPu6QbwGQMwVvq6fi/MA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKKsWRmVeSWpSXmKPExsWy7bCmvu59o8gEg+cTbCxe/N/FbPHz/3dG
        izcvDrM5MHvsnHWX3WP3gs9MHp83yQUwR+XYZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjq
        GlpamCsp5CXmptoqufgE6Lpl5gAtUlIoS8wpBQoFJBYXK+nb2RTll5akKmTkF5fYKqUWpOQU
        GBoU6BUn5haX5qXrJefnWhkaGBiZAlUm5GTsWniZpeA+U8XZPYdYGhjXMHUxcnJICJhITHw7
        nbmLkYtDSGAHo8S8ndOZIJxPjBLTHrZAOd8YJX4vOMUI03Jp/2c2EFtIYC+jxKXbmhBFLxkl
        Pq96xg6SYBPQlfj3Zz9QEQeHiEC9xIkrAiBhToFAiaPbV4DNERaQkZh8+xMTSAmLgKrEtP01
        IGFeAUuJRde2skLYghInZz5hAbGZBeQltr+dwwxxgoLEz6fLWCGmW0lc+28FUSIiMbuzDewZ
        CYFH7BJbVpxhBKmREHCR2N4eDNEqLPHq+BZ2CFtK4vO7vWwQJdUSH/dDTe9glHjx3RbCNpa4
        uX4D2CZmAU2J9bv0IcKKEjt/z2WE2Mon8e5rDyvEFF6JjjYhiBJVib5Lh6GhLC3R1f4BaqmH
        xM6TD1knMCrOQvLiLCQvzkLyyyyExQsYWVYxiqUWFOempxYbFpgix/MmRnD607LcwTj97Qe9
        Q4xMHIyHGCU4mJVEeFvCIxKEeFMSK6tSi/Lji0pzUosPMZoCw3wis5Rocj4wAeeVxBuaGhkb
        G1uYmJmbmRorifMmGTyIFxJITyxJzU5NLUgtgulj4uCUamBS++y+YnfKM8lnchfqHK1ydlhE
        ngx7wbrsckR+y8Vgh+XMagem901+vWrpd1Gz6EUm1sy/hM2bOMXttscLa4VFs0zbtVnW4xTb
        lmctf6XlvC057fZ6ZCSy+m27xzD7XftHyTnK3YqzTSfOdZp0+czmeJaTJdmhOVvmfBBINzvV
        vO/MS6PY4/f87qa6Vl+/Nf0ss/+2toyyj7/enL+8dfmpSJXJVyptTxw5MlFr56kgZe/wY9nf
        qkRzmX90/7i6esGKVdebjMtdBe4v/C73Sbopfv5mIafr+YwRoYHza3mVHLPOdf49IHdkn8tB
        ydnzXgtMOG/kHaT9wkll7vXHYes+rNUoCy/8m9m9SLP1p72OEktxRqKhFnNRcSIAnh0k5ggE
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWy7bCSnO59o8gEg5fLFC1e/N/FbPHz/3dG
        izcvDrM5MHvsnHWX3WP3gs9MHp83yQUwR3HZpKTmZJalFunbJXBl7Fp4maXgPlPF2T2HWBoY
        1zB1MXJySAiYSFza/5mti5GLQ0hgN6PE7V2XWSES0hLHTpxh7mLkALKFJQ4fLoaoec4oMevG
        TrBmNgFdiX9/9rOB2CIC9RKXZk1nBLGFBBYxSpybXAFicwoEShzdvgIsLiwgIzH59icmkJks
        AqoS0/bXgIR5BSwlFl3bygphC0qcnPmEBcRmFtCW6H3Yyghhy0tsfzuHGeI0BYmfT5exgowR
        EbCSuPbfCqJERGJ2ZxvzBEahWUgmzUIyaRaSSbOQtCxgZFnFKJlaUJybnltsWGCYl1quV5yY
        W1yal66XnJ+7iREc9FqaOxi3r/qgd4iRiYPxEKMEB7OSCG9LeESCEG9KYmVValF+fFFpTmrx
        IUZpDhYlcd4LXSfjhQTSE0tSs1NTC1KLYLJMHJxSDUx+qZ7Ltz8ttefSWPnVJc4h9H9moUbO
        qYPneoXtby075lB+9K2Um1usb+Ir9px8Y2sDMw+pK+9a9ThMpzyy1d647ISLUosk80PHF0/d
        FWNndRxj9O9y2nXJI0oxIYXVR/Gchiz3Fvn008s9NUsfZ/W6Odcobgwpyzn9bd9059n3OK+w
        PiqI6dX2sDn11mo5E+f5oszjix5efGazwqTbsK+3smnWPN+oedtvf9qu/9PlYx13Ssic4+dP
        3two8rJgyXE+Fa0+9bW1k7lkOBhUfr3YY3cgKePNlMmqcw+eenedJa73/LM9cl9ZmJ5PnHvU
        vnX760z1WXsOzDpmq9+8ZuqJE5Kn1rnedt9/8OuVfdZKLMUZiYZazEXFiQCdQBdj6QIAAA==
X-CMS-MailID: 20210323001423epcas1p2d95fe1898c2f0ec5318bf7379d20b1c3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210322204103epcas1p36333367769cffbd735c9b61d58a74431
References: <CGME20210322204103epcas1p36333367769cffbd735c9b61d58a74431@epcas1p3.samsung.com>
        <CAH2r5muFSCWQUVn+iuZ_8fiWrCXtNmO0+AaEEEqFmD9+qj8-1w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> Did some updates for the wiki page for ksmbd (cifsd)
Great! Looks good to me!
Thanks a lot!
> 
> https://protect2.fireeye.com/v1/url?k=a0092f36-ff921629-a008a479-000babdfecba-
> e6a2a99f56c0e17b&q=1&e=dda77347-9f46-4283-8da1-
> 6932cb291dec&u=https%3A%2F%2Fwiki.samba.org%2Findex.php%2FLinux_Kernel_Server
> 
> --
> Thanks,
> 
> Steve

