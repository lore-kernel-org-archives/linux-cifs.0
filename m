Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4089C4361B
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Dec 2020 08:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B95422D74
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Dec 2020 08:51:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgLPIvU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Dec 2020 03:51:20 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:19110 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgLPIvU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Dec 2020 03:51:20 -0500
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201216085036epoutp01eb7d4cb9622ecfddaf92221b7fb01462~RJkjigiIc2267022670epoutp01m
        for <linux-cifs@vger.kernel.org>; Wed, 16 Dec 2020 08:50:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201216085036epoutp01eb7d4cb9622ecfddaf92221b7fb01462~RJkjigiIc2267022670epoutp01m
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608108636;
        bh=ix+u816TBtZ4pK8xW8eb/4IvuGnGKJx94XI2ZmU0Wlk=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=CAbq91lB2fIgs/40Xyd1MR68TB39+YoLlJEyxZIQwcVVqof9BAIcAjGRE7VUHe0wm
         jVvS7Bjz0S5J3TBmfPiIDRh++bB2LUgkwXSY+U9EZm5wxv9XVUXB14zJgpB4Xsn9DY
         1c8NkZAk/W/ICQjhSykiH3iqHjMCJu7Lnhltc77M=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20201216085036epcas1p32486d512da04f82bcf577ec1f3314b39~RJkjMn3Eg2879528795epcas1p3y;
        Wed, 16 Dec 2020 08:50:36 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.162]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Cwpk25bN9zMqYkq; Wed, 16 Dec
        2020 08:50:34 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        B0.A8.09582.95AC9DF5; Wed, 16 Dec 2020 17:50:33 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20201216085032epcas1p395a2802e249c7a17b534af3753a3f37f~RJkgKNGrf0058900589epcas1p3S;
        Wed, 16 Dec 2020 08:50:32 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201216085032epsmtrp160748a75cac5ea7d651d7f05e1cc46dd~RJkgJknKz0069400694epsmtrp1S;
        Wed, 16 Dec 2020 08:50:32 +0000 (GMT)
X-AuditID: b6c32a37-899ff7000000256e-73-5fd9ca59be50
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F5.52.08745.85AC9DF5; Wed, 16 Dec 2020 17:50:32 +0900 (KST)
Received: from namjaejeon01 (unknown [10.88.104.63]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20201216085032epsmtip29adf7410a4ae8440ed7ad94c6cd5a57f~RJkf_iZ5H2967629676epsmtip2P;
        Wed, 16 Dec 2020 08:50:32 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Stefan Metzmacher'" <metze@samba.org>
Cc:     "'CIFS'" <linux-cifs@vger.kernel.org>,
        "'Steve French'" <smfrench@gmail.com>,
        "'samba-technical'" <samba-technical@lists.samba.org>,
        "'Hyunchul Lee'" <hyc.lee@gmail.com>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>
In-Reply-To: <069556fc-cb6c-1e52-02ab-fa9b71f58cf6@samba.org>
Subject: RE: updated ksmbd (cifsd)
Date:   Wed, 16 Dec 2020 17:50:32 +0900
Message-ID: <003c01d6d388$83669740$8a33c5c0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQDtjnMiCa1AcmvYMj1ELhOClJiQLwG3FqLJAxs+MEYCGETvfAJQSgxQq4Gl7zA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnk+LIzCtJLcpLzFFi42LZdlhTTzfy1M14g/ffeCyu3X/PbvHi/y5m
        i4vLfrJY/Fmyn91i7efH7BZvXhxmc2Dz2DnrLrvH/NmzmDzm7upj9Pi8SS6AJSrHJiM1MSW1
        SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdouZJCWWJOKVAoILG4
        WEnfzqYov7QkVSEjv7jEVim1ICWnwNCgQK84Mbe4NC9dLzk/18rQwMDIFKgyISfjQf9vxoIF
        0hVnlj9ia2B8L9bFyMkhIWAi0TzhPXMXIxeHkMAORolH+9axQjifGCXOft8JlfnMKNH69wIj
        TEtT6xU2iMQuRokdi5ZAOS8ZJV7cu8oCUsUmoCvx789+NhBbREBb4tCrO+wgRcwCrxglpiz4
        yA6S4BSwlehf+gLMFhZQknh4eQYziM0ioCoxu38NWDOvgKXE2ilXoGxBiZMzn4AtYBaQl9j+
        dg4zxEkKEj+fLmOFWOYn8evaVGaIGhGJ2Z1tYD9ICHRySLRc3gTV4CLx/OgeVghbWOLV8S3s
        ELaUxMv+NiCbA8iulvi4H6q8A+iz77YQtrHEzfUbWEFKmAU0Jdbv0ocIK0rs/D2XEWItn8S7
        rz2sEFN4JTrahCBKVCX6Lh1mgrClJbraP7BPYFSaheSxWUgem4XkgVkIyxYwsqxiFEstKM5N
        Ty02LDBGju1NjOCUqWW+g3Ha2w96hxiZOBgPMUpwMCuJ8CYcuBkvxJuSWFmVWpQfX1Sak1p8
        iNEUGNQTmaVEk/OBSTuvJN7Q1MjY2NjCxMzczNRYSZz3j3ZHvJBAemJJanZqakFqEUwfEwen
        VAOT/x2/WrkYttcMn56/eite2nlDe8e767V1yXJ9++2YmxkW8NfMkc2U/yEulPTzTY5wXj/D
        /X72GX9VmjYEB6ZL7+E+fepyxpsrGwp/X+GZMeV09tzEV9We/1clthT95TiR7vKxar20j6rp
        pPKCRfH+b36m9SQExfuu+tr6S/DJD5283w5Gu6eteycd27//XKt3ycH5d/flSV05OnMDs38q
        6955a+NOG559vzOzXTzTseKjlM6mLV8uV1688ywl9lHZG54HjL97fy/LePdew+6/zMbP/hnS
        AitM5CVKptaUH+bJdYuTrrm7kpnNPnH+o5lp17cdmx7Va71/xWsX+dL32zc8eKNRMdNv0bUH
        MdJWSizFGYmGWsxFxYkA0GsvySIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWy7bCSvG7EqZvxBk2ftSyu3X/PbvHi/y5m
        i4vLfrJY/Fmyn91i7efH7BZvXhxmc2Dz2DnrLrvH/NmzmDzm7upj9Pi8SS6AJYrLJiU1J7Ms
        tUjfLoEr40H/b8aCBdIVZ5Y/YmtgfC/WxcjJISFgItHUeoUNxBYS2MEosXQ2F0RcWuLYiTPM
        XYwcQLawxOHDxV2MXEAlzxklfk/dzARSwyagK/Hvz36wXhEBbYlDr+6wgxQxC7xhlLh+9gEb
        RMcmJon+o7vBOjgFbCX6l75gB7GFBZQkHl6ewQxiswioSszuXwM2iVfAUmLtlCtQtqDEyZlP
        WEBsZqANvQ9bGSFseYntb+cwQ1yqIPHz6TJWiCv8JH5dm8oMUSMiMbuzjXkCo/AsJKNmIRk1
        C8moWUhaFjCyrGKUTC0ozk3PLTYsMMpLLdcrTswtLs1L10vOz93ECI4dLa0djHtWfdA7xMjE
        wXiIUYKDWUmEN+HAzXgh3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbB
        ZJk4OKUamOSflaXlF6zSNP7d/lngkZF/VsD612xm7Vs/rkzpzjybsrUkdErPge61/E0/fzv2
        6oVtafw/v/fQHY3jpw1PzhZPsrrjs9DuQILE7ps5Cq5Jl0SWi3ydHqUS9vnKPM6ZQqsdQ7c1
        lGw80zWBcZP3+0npTx9GvbBVsep+IjLf9vtJCa01G7nCJ6ZPMJKR0fpw2eGu7Yd9H7YUdvA2
        BBiuW93GrflfeTX3wqS9p2q3rjaV2/M8l69/VUah0qfvBno7ZSb9a9qWZNXkltgssO9R8iOn
        xKSGf31Wix4mex+PdjvXIOycI7BveZF0z4fFXj1vNK5Pu8u/UvMd940jRzMPxdlVrW6d3MHq
        9PDvO+lF/5RYijMSDbWYi4oTAQo3KpIMAwAA
X-CMS-MailID: 20201216085032epcas1p395a2802e249c7a17b534af3753a3f37f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201214182517epcas1p1d710746f4dd56097f16ed08cfda0f6b2
References: <CAH2r5muRCUzvKOv1xWRZL4t-7Pifz-nsL_Sn4qmbX0o127tnGA@mail.gmail.com>
        <CGME20201214182517epcas1p1d710746f4dd56097f16ed08cfda0f6b2@epcas1p1.samsung.com>
        <3bf45223-484a-e86a-279a-619a779ceabd@samba.org>
        <003a01d6d28a$00989dd0$01c9d970$@samsung.com>
        <069556fc-cb6c-1e52-02ab-fa9b71f58cf6@samba.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> >> 2. Why does smb2_set_info_sec() have fp->saccess |= FILE_SHARE_DELETE_LE; ?
> > Because of smb2.acls.GENERIC failure.
> >
> > TESTING FILE GENERIC BITS
> > get the original sd
> > Testing generic bits 0x00000000
> > time: 2020-12-15 00:00:37.940992
> > failure: GENERIC [
> > (../../source4/torture/smb2/acls.c:439) Incorrect status
> > NT_STATUS_SHARING_VIOLATION - should be NT_STATUS_OK
> >
> > I really don't understand this test. This testcase expect that
> > FILE_DELETE is set in response if desired access of smb2 open is FILE_MAXIMAL_ACCESS.
> > I don't know why smb2 open should be allowed although FILE_SHARE_DELETE is not set in previous open
> in this test.
> > Can you give me a hint ?
> 
> As far as I can see the test assumes the user has SeRestorePrivilege, with that
> SEC_FLAG_MAXIMUM_ALLOWED will add FILE_DELETE, see https://protect2.fireeye.com/v1/url?k=3a9ae45d-
> 6501dd47-3a9b6f12-000babff24ad-8398dba5a818cd4a&q=1&e=bdf5897b-3ecc-49dc-9105-
> 2d6782854fcc&u=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-
> fsa%2F8ada5fbe-db4e-49fd-aef6-20d54b748e40
The question I'm asking is how it can be opened with FILE DELETE that adding
by SEC_FLAG_MAXIMUM_ALLOWED without FILE_SHARE_DELETE in 1st open.
NT_STATUS_SHARING_VIOLATION error should be returned? but this test should be allowed to open.

It test in the following sequences.
- 1st smb2 open with NTCREATEX_SHARE_ACCESS_READ | NTCREATEX_SHARE_ACCESS_WRITE
- SMB2 set info security().
- 2nd open with SEC_FLAG_MAXIMUM_ALLOWED(adding FILE DELETE) => NT_STATUS_SHARING_VIOLATION or NT_STATUS_OK ?

> 
> >> 3. Why does ksmbd_override_fsids() only reset cred->fs[g|u]id, but group_info
> >>    is kept unchanged, I guess at least the groups array should be set to be empty.
> > Yes, We need to handle the groups list. Will fix it.
> >
> >> 4. What is work->saved_cred_level used for in ksmbd_override_fsids()?
> >>    It seems to be unused and adds a lot of complexity.
> > ksmbd_override_fsids could be called recursively.
> > work->saved_cred_level prevents ksmbd from overriding fs[g|u]id again.
> 
> But that will always be on the same session/share combination?
Ah, ksmbd_override_fsids() has been recursively called to handle SMB1 requests.
At present, SMB1 codes was removed in smb3_kernel tree, So we can remove work->saved_cred_level.

Thanks for your review!
> 
> >> 5. Documentation/filesystems/cifsd.rst and fs/cifsd/Kconfig still references
> https://protect2.fireeye.com/v1/url?k=6f3cad54-30a7944e-6f3d261b-000babff24ad-
> 32002aad36f8cca9&q=1&e=bdf5897b-3ecc-49dc-9105-2d6782854fcc&u=https%3A%2F%2Fgithub.com%2Fcifsd-
> team%2Fcifsd-tools
> >>   instead of
> >> https://protect2.fireeye.com/v1/url?k=cf0932a6-90920bbc-cf08b9e9-000b
> >> abff24ad-ea69fcf05590fae2&q=1&e=bdf5897b-3ecc-49dc-9105-2d6782854fcc&
> >> u=https%3A%2F%2Fgithub.com%2Fcifsd-team%2Fksmbd-tools
> > Okay. Will update it.
> 
> Thanks!
> 
> >> 6. Why is SMB_SERVER_CHECK_CAP_NET_ADMIN an compile time option and why is it off by default?
> >>    I think the behavior should be enforced without a switch.
> > I can make it default yes. Can you explain more why it should be enforced ?
> 
> Why should an unprivileged user ever be able to start the server?
> Wouldn't that be a massive security problem as that user would provide the share definitions and users
> and controls what ksmbd_override_fsids() will use?
> 
> metze


