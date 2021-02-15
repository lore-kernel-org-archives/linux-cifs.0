Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F076C433DB
	for <linux-cifs@archiver.kernel.org>; Mon, 15 Feb 2021 01:00:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04A4964E52
	for <linux-cifs@archiver.kernel.org>; Mon, 15 Feb 2021 01:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhBOBAQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 14 Feb 2021 20:00:16 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:39529 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbhBOBAO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 14 Feb 2021 20:00:14 -0500
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210215005931epoutp031a1de999ebc30ae4c5704f9fc97ddf8a~jxfqGsf312782127821epoutp03S
        for <linux-cifs@vger.kernel.org>; Mon, 15 Feb 2021 00:59:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210215005931epoutp031a1de999ebc30ae4c5704f9fc97ddf8a~jxfqGsf312782127821epoutp03S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1613350771;
        bh=SfYFblpSib/Vr1j+2XMm6Ietkk5NSHooqY/HQ7G8Seg=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=qjRJ6JvYwv4kyFTLcgTY54xwRqTZVKtiy0S0FmkTXhwmmKyUpaSHMaCuPtIA/V8PI
         3e/m3IiCuXE501L+XsVLruYPmhTxE/T85QiywB3ZeFZagorxjUm/KT9DcWlpxdUoe/
         QZc7MzKUYXoieXnYuw3GxstWBX03owzfqABywJc0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20210215005930epcas1p435d4e6cbf44db980cfdde7571e36cb95~jxfpmMTOW0985009850epcas1p4L;
        Mon, 15 Feb 2021 00:59:30 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.160]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Df5NK6Pt3z4x9QF; Mon, 15 Feb
        2021 00:59:29 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        03.EF.02418.177C9206; Mon, 15 Feb 2021 09:59:29 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20210215005929epcas1p49aacc3d06efa8e70eb99c745d15fa839~jxfoD3GLQ2852528525epcas1p4h;
        Mon, 15 Feb 2021 00:59:29 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210215005929epsmtrp1403ed34dc7aa307dc04c0ed1b2b6dbb2~jxfoDMw4y0077500775epsmtrp1G;
        Mon, 15 Feb 2021 00:59:29 +0000 (GMT)
X-AuditID: b6c32a35-c0dff70000010972-b0-6029c771b154
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        87.11.13470.077C9206; Mon, 15 Feb 2021 09:59:29 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210215005928epsmtip1c6861c2e6ea205f3c2dccb3ed76e5ce6~jxfn324LX1862218622epsmtip18;
        Mon, 15 Feb 2021 00:59:28 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Stefan Metzmacher'" <metze@samba.org>
Cc:     "'Namjae Jeon'" <linkinjeon@kernel.org>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        "'Samba Technical'" <samba-technical@lists.samba.org>,
        <linux-cifs@vger.kernel.org>
In-Reply-To: <adf41e69-5915-06aa-6f8b-8ffc073fc8a7@samba.org>
Subject: RE: ksmbd ABI for ksmbd-tools...
Date:   Mon, 15 Feb 2021 09:59:29 +0900
Message-ID: <009101d70335$d02bcb40$708361c0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQLNkXaegPBuGsSfX03ExGj/IX/q7QD54CbSqGNkVFA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplk+LIzCtJLcpLzFFi42LZdljTQLfwuGaCwcG5ehYTpy1ltnjxfxez
        xc//3xktLi77yWLxZ8l+dgdWj02rOtk85s+exeSxe8FnJo+5u/oYPT5vkgtgjcqxyUhNTEkt
        UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
        VtK3synKLy1JVcjILy6xVUotSMkpMDQo0CtOzC0uzUvXS87PtTI0MDAyBapMyMl4/L2XueCo
        XEX3vlaWBsZL4l2MnBwSAiYSf6ZcY+1i5OIQEtjBKLHl/n82kISQwCdGiTOnXCES3xglVh8/
        xATT8fXqYmaIxF5GiffP57JAOC8ZJeYsfgjWziagK/Hvz34wW0RAW+LQqzvsIEXMAusZJeZv
        uMsCkuAUsJU4M3EFM4gtLKAp8fftOVYQm0VAVeLqoQ1gNbwClhJfXn1ghbAFJU7OfAIWZxaQ
        l9j+dg4zxEkKEj+fLmOFWGYl8eE+xExmARGJ2Z1tUDWdHBJ/9vpB2C4Sd9YuZ4WwhSVeHd/C
        DmFLSbzsbwOyOYDsaomP+6FaOxglXny3hbCNJW6u38AKUsIMdPL6XfoQYUWJnb/nMkJs5ZN4
        97WHFWIKr0RHmxBEiapE36XD0DCUluhq/8A+gVFpFpK/ZiH5axaS+2chLFvAyLKKUSy1oDg3
        PbXYsMAQOa43MYLTpZbpDsaJbz/oHWJk4mA8xCjBwawkwntVQiNBiDclsbIqtSg/vqg0J7X4
        EKMpMKQnMkuJJucDE3ZeSbyhqZGxsbGFiZm5mamxkjhvksGDeCGB9MSS1OzU1ILUIpg+Jg5O
        qQYmsWaL5PvqDcGW8xZ06jRWRMSKhM+RkmLy+8sVxtJde2DXquol33qqlv+LKpew5hGM43Z/
        8O6A1LQgh0sv/9awT0m+2sQdxXTHf3frf7ML/ofZj2w1uCoS27lr41P/pQIbVMyM6274rd76
        fF2qSPgZgwPLjv/9kfnGpmbmRdkDd/UfPFq/WOuCRqXCoVJbp7p5a1g35MlU5CqYHy3+vHHi
        N0XeLM7stl+OB9cn2SUyP+RdLHjvkMn3eSG3Z+rF37e482P1t64zvj4WBh+8oq/NXSpW/ilR
        /G/nWe99apVzfOfHmXtcWebi1iS9aOK3zXyr9YQndOnX+WWdkPh59sKVm7emn0vKiL2Qp2cU
        eX6KEktxRqKhFnNRcSIAukSr8iAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsWy7bCSnG7hcc0Egx1TGC0mTlvKbPHi/y5m
        i5//vzNaXFz2k8Xiz5L97A6sHptWdbJ5zJ89i8lj94LPTB5zd/UxenzeJBfAGsVlk5Kak1mW
        WqRvl8CV8fh7L3PBUbmK7n2tLA2Ml8S7GDk5JARMJL5eXczcxcjFISSwm1Gi5dFnFoiEtMSx
        E2eAEhxAtrDE4cPFEDXPGSWmPugCq2ET0JX492c/G4gtIqAtcejVHXaQImaBjYwShxbOZYLo
        6GOU2LPyPVgHp4CtxJmJK5hBbGEBTYm/b8+xgtgsAqoSVw9tAKvhFbCU+PLqAyuELShxcuYT
        sDgz0Ibeh62MELa8xPa3c5ghLlWQ+Pl0GSvEFVYSH+5DzGcWEJGY3dnGPIFReBaSUbOQjJqF
        ZNQsJC0LGFlWMUqmFhTnpucWGxYY5qWW6xUn5haX5qXrJefnbmIER4+W5g7G7as+6B1iZOJg
        PMQowcGsJMJ7VUIjQYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvha6T8UIC6YklqdmpqQWpRTBZ
        Jg5OqQammO1ecr7nWOQOfzA//Ff8dbRBnrd9nGVCMePan6d83izcnZ0kcmSJdmy3ne+1v7mX
        4zcXnKn1cra203O46qJwb/pU7tD2xfXqntN/FD+J2OPyXDbKVrlb4vcqgQlNOrOCm2Z999EI
        +PTsxLTVDR/KT52vkpvacdv4t7xPo0/gnqvuavaVc5/UXdnvXDh16Xr9j3wveLZzflrXcv7u
        7/s9p17M0HefM908TTn+g5Pyu1sZ/3dEJh8p37bS5OKBL3bxP/xkbyYyrap3UTg60Wpi7s+s
        O++eb1BK0G5Jcv9drH3ihIXZ6v1/dRsaA6oscxs6dz9RTbjMc5s/7YTvOqcV0gYH7m6X4QyN
        mSU2/0a8EktxRqKhFnNRcSIAyFYPuA0DAAA=
X-CMS-MailID: 20210215005929epcas1p49aacc3d06efa8e70eb99c745d15fa839
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210212143813epcas1p1dcbff2491a1c7cf052c03e57f54e1474
References: <CGME20210212143813epcas1p1dcbff2491a1c7cf052c03e57f54e1474@epcas1p1.samsung.com>
        <adf41e69-5915-06aa-6f8b-8ffc073fc8a7@samba.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> Hi Namjae,
Hi Metze,
> 
> I looked through the interfaces used between userspace (ksmbd.mountd and ksmbd.control) and the kernel
> module.
> 
> After loading the ksmbd.ko module and calling 'ksmbd.mountd', I see the following related
> proceses/kernel-threads:
> 
>   12200 ?        I      0:00 [kworker/0:0-ksmbd-io]
>   12247 ?        Ss     0:00 ksmbd.mountd
>   12248 ?        S      0:00 ksmbd.mountd
>   12249 ?        S      0:00 [ksmbd-lo]
>   12250 ?        S      0:00 [ksmbd-enp0s3]
>   12251 ?        S      0:00 [ksmbd-enp0s8]
>   12252 ?        S      0:00 [ksmbd-enp0s9]
>   12253 ?        S      0:00 [ksmbd-enp0s10]
>   12254 ?        I<     0:00 [ksmbd-smb_direc]
>   12255 ?        S      0:00 [ksmbd:38794]
>   12257 ?        S      0:00 [ksmbd:51579]
> 
> I haven't found the exact place, but ksmbd.mountd starts the kernel-part.
> 
> ksmbd.mountd also acts as some kind of upcall, for the server part, that takes care of authentication
> and some basic DCERPC calls.
> 
> I'm wondering why there are two separate ways to kill the running server, 'killall ksmbd.mountd' for
> the userspace part and 'ksmbd.control -s' (which is just a wrapper for 'echo -n "hard" >
> /sys/class/ksmbd-control/kill_server') to shutdown the server part.
Hm.. We can add the code that kill ksmbd.mountd in ksmbd.control -s.
> 
> As it's not useful to run any of these two components on its own, so I'm wondering why there's no
> stronger relationship.
Sergey answered.
> 
> As naive admin I'd assume that the kernel part would detect the exit of ksmbd.mountd and shutdown
> itself.
Sergey answered.
> 
> It would also be great to bind to specific ip addresses instead of devices and allow to run more than
> one instance of ksmbd.mountd (with different config files and or within containers). That's why I
> think single global hardcoded path like '/sys/class/ksmbd-control/kill_server' should be avoided,
> something like:
> '/sys/class/ksmbd-control/<pid-of-ksmbd.mountd>/kill_server' would be better (if it's needed at all).
Could you please elaborate more why we should do this ?

> 
> I also have ideas how ksmbd{.ok,.mountd} could make use of Samba's winbindd (or authentication) and
> Samba's rpc services, but this would require a few changes in the netlink protocol between ksmbd.ko
> and ksmbd.mountd. It would be great if a Samba smb.conf option could cause smbd to start ksmbd.mountd
> in the background and delegate all raw SMB handling to the kernel.
It's what I plan to do in the long run. It would be great for ksmbd to fully support the function
using samba's library. But I don't think ksmbd should have dependency on such samba's libraries.
i.e. If we change the existing netlink protocol in ksmbd to use samba's winbindd and librpc,
The current users using ksmbd on closed systems may not be able to use ksmbd due to GPLv3. So, This
should be a new netlink protocol addition or extension, not change the existing ones.

> 
> So my main big question is how stable would the userspace interface to ksmbd.ko be treated?
Sergey answered. If his answer is not enough, Let me know it.
> 
> Would it be possible to change the netlink protocol or /sys/class/* behavior in future in order to
> improve things?
Yes.
> 
> Can we require that the userspace tool matches the kernel version for a while?
Sergey answered. If there is a better way than now, please give me your opinion.
> 
> I think iproute2 creates a version for each stable kernel tree and tools like bpftool, perf even come
> with each single kernel release.
Ah. Even if there is no change in source, Does it release according to the kernel version?
It would be better that ksmbd-tools also is merged into kernel/tools like bfptool or perf,
but I am not sure if it is possible. nfs-utils seems to be managed well apart from the kernel version.
> 
Thanks!

