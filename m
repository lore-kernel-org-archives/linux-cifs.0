Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A6EC63793
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jul 2021 07:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89A4C61249
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jul 2021 07:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhGVGlb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Jul 2021 02:41:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37368 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhGVGla (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Jul 2021 02:41:30 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210722072204epoutp0199cb0eff2c7ba9499fcca169100c4aa5~UC-ffF7xH2479424794epoutp01C
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jul 2021 07:22:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210722072204epoutp0199cb0eff2c7ba9499fcca169100c4aa5~UC-ffF7xH2479424794epoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1626938524;
        bh=QmiwsOp96TmtymuHB/WVhpHtyoPNu2aa4OAwPWaKKaI=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=ru1Pv6bSYSzfYSVxEML4dD2rS4/M5nBc2YvPbWW/Sxlc/rZLuaVMWQSJS3ac/ZBmp
         CDgidIutO4zJrhfNUQzjVrGfZR2ovKernrstHDrF4IedWf1WmjBA+9Pp6t4g4ux9gE
         BfseOi8byWja0psOZSFo9p/jiSpAm9h5+NILkobg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210722072204epcas1p115df0354b01f8344ccb211e0002a15b3~UC-fUFn5b0903809038epcas1p1o;
        Thu, 22 Jul 2021 07:22:04 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.161]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4GVkRH2n7cz4x9QD; Thu, 22 Jul
        2021 07:22:03 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        F4.44.09468.99C19F06; Thu, 22 Jul 2021 16:22:01 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210722072200epcas1p290f4fae8d380c60b00a5daa5f4016e5b~UC-cCfDK20258902589epcas1p2V;
        Thu, 22 Jul 2021 07:22:00 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210722072200epsmtrp2dd4d9f90f13aef5464a5b671c8ce1c58~UC-cB03yk2216722167epsmtrp2N;
        Thu, 22 Jul 2021 07:22:00 +0000 (GMT)
X-AuditID: b6c32a37-66505a80000024fc-a4-60f91c990247
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        64.FF.08394.89C19F06; Thu, 22 Jul 2021 16:22:00 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210722072200epsmtip1195947ec3a39f81dfe51e46b2cd65820~UC-b2qhWq2340223402epsmtip1Y;
        Thu, 22 Jul 2021 07:22:00 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'ronnie sahlberg'" <ronniesahlberg@gmail.com>
Cc:     "'Leif Sahlberg'" <lsahlber@redhat.com>,
        "'linux-cifs'" <linux-cifs@vger.kernel.org>
In-Reply-To: <CAN05THTv3o8yDuGLJE5M+YXhdW6ChnnUyznVF_a_3uLQcE=5Tw@mail.gmail.com>
Subject: RE: [PATCH] cifs: only write 64kb at a time when fallocating a
 small region of a file
Date:   Thu, 22 Jul 2021 16:22:00 +0900
Message-ID: <006b01d77eca$4343a840$c9caf8c0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHxVlcgtFcS9XEREPWB6nfEmeiRZwGYsS+AAo3wyigCil6ALQJDwXMVAQZ5K++qyw2NwA==
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKKsWRmVeSWpSXmKPExsWy7bCmnu5MmZ8JBsfOSFu8+L+L2WLBVX2L
        3r5PrA7MHjtn3WX3eL/vKpvH501yAcxROTYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqG
        lhbmSgp5ibmptkouPgG6bpk5QHuUFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQWG
        BgV6xYm5xaV56XrJ+blWhgYGRqZAlQk5GfPftLEVtAhWTPrxm7GBcTp3FyMnh4SAiUTjtJfM
        XYxcHEICOxglXtw9zQjhfGKUeHz0NBtIlZDAN0aJ5RtdYDqWXvrGAlG0l1Fi7fFLUM4LRomv
        +z8wgVSxCehK/PuzH6xbRMBIYsfB5cwgNrNAlETn9sNgNZwCgRKnui6wgNjCAgkSC67vAIuz
        CKhKXJnaxwpi8wpYSnTcvsMCYQtKnJz5hAVijrzE9rdzmCEuUpD4+XQZUD0H0K4wia+zKiBK
        RCRmd7ZBlbxll5gyrwikRELARWLaJjGIsLDEq+Nb2CFsKYnP7/ayQdjlEidO/mKCsGskNszb
        xw7RaizR86IExGQW0JRYv0sfokJRYufvuYwQS/kk3n3tYYWo5pXoaBOCKFGV6Lt0GGqgtERX
        +wf2CYxKs5B8NQvJV7OQnD8LYdkCRpZVjGKpBcW56anFhgXGyBG9iRGc/rTMdzBOe/tB7xAj
        EwfjIUYJDmYlEV6Voq8JQrwpiZVVqUX58UWlOanFhxhNgeE8kVlKNDkfmIDzSuINTY2MjY0t
        TMzMzUyNlcR5v8UCNQmkJ5akZqemFqQWwfQxcXBKNTCdFz/TuvhwiYuEUa1PsHCLnrYZ58L+
        M3rR5usuznHaM5t3d4C67WeV3fu2/dlhnPpswTtf+Y9HtijelrwT1W182c3zKf/da0eP/uvt
        8CyflfjWzSdrws+6K/+kOu+EM5kxJAmWxqpuPDxFcW7eW/Pnu6SErfMmdbuKf6tre+L/e07n
        xsNfOe6KH/x4WLpco+2r5BSTbctmZVd+rqzv7hcQ0q/8tfHSNvG6mrWvZFcqpXIen/MkovKH
        1xxug6iNHxYWn3vs+vuW+gzHeW9fP+v+uHkdz3Xp4uVbdjaffLX7/dXK3w1yIplpD58E3D/B
        vOnyPuaZO1Kyu3yZTdttAyIez1E/K9vyQnaDwf7JG2ZsUWIpzkg01GIuKk4EACE/N4MIBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWy7bCSnO4MmZ8JBn0PDSxe/N/FbLHgqr5F
        b98nVgdmj52z7rJ7vN93lc3j8ya5AOYoLpuU1JzMstQifbsEroz5b9rYCloEKyb9+M3YwDid
        u4uRk0NCwERi6aVvLF2MXBxCArsZJaafXcIKkZCWOHbiDHMXIweQLSxx+HAxSFhI4BmjxOUz
        eSA2m4CuxL8/+9lAbBEBI4kdB5czg9jMAlESC5pXsUDUf2SS6P+hBmJzCgRKnOq6ABYXFoiT
        +P9xBxOIzSKgKnFlah/YWl4BS4mO23dYIGxBiZMzn7BAzNSW6H3Yyghhy0tsfzuHGeJMBYmf
        T5exgpwpIhAm8XVWBUSJiMTszjbmCYzCs5BMmoVk0iwkk2YhaVnAyLKKUTK1oDg3PbfYsMAw
        L7Vcrzgxt7g0L10vOT93EyM4FrQ0dzBuX/VB7xAjEwfjIUYJDmYlEV6Voq8JQrwpiZVVqUX5
        8UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTCZdZQUTF1nr+KmFH7ZZccM
        7dr1h9wzD7K8v/19WlnwpI0Whxo/ah5ZqB3n4DlPvuCR7/4KxSkdyyqn+t/nS+D+vdc20rZ/
        08LJnOI3HYxNWzmyK6wNn60Kff/5R1X9o5dTW/eWufx+eOTZV57ncTLyrpt3/b6s4XQxfPb0
        l0WPZkxZYvTqduljpayWuoPKk9cKTDWcl3yoXGTVxsVrZB7ciujyvVeiOfPw9g9nzeZP2OwU
        sXnSZ1vx2DPWawT9RA/8PWeh/r6DdbfcSoM/51N59n4oe8YvHJo+y8Q5YfUsu4ehX1hiGtod
        c0NWha131XxxWv6StsKqwLk7nR3er2pfa7G93LNwhlAlp1TKx7hTSizFGYmGWsxFxYkAaXWG
        FfQCAAA=
X-CMS-MailID: 20210722072200epcas1p290f4fae8d380c60b00a5daa5f4016e5b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210721015429epcas1p4654c2b9348101aa7967bfe60d1d8da71
References: <CGME20210721015429epcas1p4654c2b9348101aa7967bfe60d1d8da71@epcas1p4.samsung.com>
        <014c01d77dd3$57add320$07097960$@samsung.com>
        <016b01d77e00$fe61efd0$fb25cf70$@samsung.com>
        <CAGvGhF55Tq-sLUtKBn+QX6kWrL9dDzKkXFKdQ==gz3s=RkySKQ@mail.gmail.com>
        <006601d77ec6$6b1b13c0$41513b40$@samsung.com>
        <CAN05THTv3o8yDuGLJE5M+YXhdW6ChnnUyznVF_a_3uLQcE=5Tw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> Yes, ofcourse.
Thank you!

> 
> Steve, can you revert that deletion in the patch?
> 
> On Thu, Jul 22, 2021 at 4:55 PM Namjae Jeon <namjae.jeon@samsung.com> wrote:
> >
> > > This code is actually bogus and does the opposite of what the comment says.
> > > If out_data_len is 0 then that means that the entire region is
> > > unallocated and then we should not bail out but proceed and allocate the hole.
> >
> > > generic/071 works against a windows server for me.
> >
> >
> > > If it fails with this code removed it might mean that generic/071 never worked with cifs.ko
> correctly.
> >
> > generic/071 create preallocated extent by calling fallocate with keep size flags.
> > It means the file size should not be increased.
> > But if (out_buf_len == 0) check is removed, 1MB write is performed using SMB2_write loop().
> > It means the file size becomes 1MB.
> >
> > And then, generic/071 call again fallocate(0, 512K) which mean file size should be 512K.
> > but SMB2_set_eof() in cifs is not called due to the code
> > below(->i_size is bigger than off + len), So 071 test failed as file size remains 1MB.
> >
> >         /*
> >          * Extending the file
> >          */
> >         if ((keep_size == false) && i_size_read(inode) < off + len) {
> >                 rc = inode_newsize_ok(inode, off + len);
> >                 if (rc)
> >                         goto out;
> >
> >                 if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
> >                         smb2_set_sparse(xid, tcon, cfile, inode,
> > false);
> >
> >                 eof = cpu_to_le64(off + len);
> >                 rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
> >                                   cfile->fid.volatile_fid, cfile->pid, &eof);
> >                 if (rc == 0) {
> >                         cifsi->server_eof = off + len;
> >                         cifs_setsize(inode, off + len);
> >                         cifs_truncate_page(inode->i_mapping, inode->i_size);
> >                         truncate_setsize(inode, off + len);
> >                 }
> >                 goto out;
> >         }
> >

