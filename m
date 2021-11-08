Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF11C433FE
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Nov 2021 07:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C26F6112F
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Nov 2021 07:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236457AbhKHHOW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Nov 2021 02:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236151AbhKHHOV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Nov 2021 02:14:21 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD362C061570
        for <linux-cifs@vger.kernel.org>; Sun,  7 Nov 2021 23:11:37 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id f4so58205071edx.12
        for <linux-cifs@vger.kernel.org>; Sun, 07 Nov 2021 23:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wzdiKLmaDKEmfHlMRNj//CPWsTyxjOmEIsoboHjAidc=;
        b=g+2lhJTjzPLbsViRBldaqyZ+pF+t/bCYSKQBlbGCz8AhpszsQThZqJzHFf2gDneZNh
         gtLsxiT+PkWeZcxwadn49iq1YkQSf//tL9ruQ9SLulfY1xxyN49m02JObogXBXh9WGLM
         Y1f3j2ICCJRYOuc78781p4shkPO+/ag/S0rWxYgD06sa6yD4ZFtXvejgdh6ABRYGQpd0
         qiK5yRazYqA/2qgYZRDM9x+m0yRJbzn6SXJ24TO11/+aZGURA+sYoupahRxU8FqgRsTx
         Xrmt41TGjMcgKhmeOYAs+T24g3Dyl+cwc6ibRfmRRMlHoskPTCu/9eK2hjWf1ZQIX2CC
         ghgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wzdiKLmaDKEmfHlMRNj//CPWsTyxjOmEIsoboHjAidc=;
        b=0hHOo4B5fpCKXzXQDfZZykTWmJ/vB7tcGIOrRSa/r/8iI1Wece999Yy4QCZvB/790k
         bPzZb5zyGzASVt9v+drC3xfi+YumtFW3Q3jIbiYo/g2J81LHEFmzOY7PH8/ylDvFnNGk
         zRFHnU8UUcy93zIQsvqUm/52dSvJGhS2iPPK+eQlZO6++ZPnrEAFD9j6OQUzfiEUIrwV
         AEOIgTSoN7XVjNChvc7dmjelqJxyTvibDNeZs1pMyVG9D1BqvhSQ7Pt197OAjBGkBsi/
         gXPGssZ0de0D0hmoMw5gb9LajhAXYn/RgZ92qrgTL1FmQamLUCMTt6N3odc8Bo0KK0Pp
         aO0A==
X-Gm-Message-State: AOAM532GdM6gZ4bVHqQsdrFj0vrEapSMm3mvDurTjEbwikBxr7+5oHsU
        hH6IeMecztVzg4HEBCC3kRYTzzZvuUyRkFO7v9k=
X-Google-Smtp-Source: ABdhPJzBWWkgdsBZCv57hfP343jUqqbMx5JJDg920G4OGsl4r/8+ZAATyRgWPh9QRhwYHeQhmH/w8w9ceINEfWV9sng=
X-Received: by 2002:a05:6402:17c6:: with SMTP id s6mr89047983edy.11.1636355496414;
 Sun, 07 Nov 2021 23:11:36 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=rgHn59NVvH32FSKtNv_cyKi4ATSAExBmWT_qjb7km7Fw@mail.gmail.com>
 <20211106013854.6qx3tz53pvayqcgm@cyberdelia> <CAH2r5mvQG0DFmMdzojH2u_w2=_9oGRV++AnEt_d7WJzj=-uTKA@mail.gmail.com>
 <CANT5p=qOQDg4xDbx6oZafJc+gnM0pN+aYOgjokU54ZeLXq_uDQ@mail.gmail.com> <bf98a745-5feb-c38a-4641-6dd91c364c8e@samba.org>
In-Reply-To: <bf98a745-5feb-c38a-4641-6dd91c364c8e@samba.org>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Mon, 8 Nov 2021 12:41:25 +0530
Message-ID: <CANT5p=r6c+1Zmc9DysK1c6TPMVJ1QhW5+z1G3gDf1fvXpHyj_w@mail.gmail.com>
Subject: Re: [PATCH] cifs: send workstation name during ntlmssp session setup
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Steve French <smfrench@gmail.com>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Stefan,

Good points. Please read my replies inline below.

On Sun, Nov 7, 2021 at 4:19 PM Stefan Metzmacher <metze@samba.org> wrote:
>
>
> Hi Shyam,
>
> >>>> Please review this patch, and let me know what you think.
> >>>> Having this info in the workstation field of session setup helps
> >>>> server debugging in two ways.
> >>>> 1. It helps identify the client by node name.
> >>>> 2. It helps get the kernel release running on the client side.
> >>>>
> >>>> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/d988e704dd9170c19ff94d9421c017e65dbbaac1.patch
> >>>
> >>> - AFAICS it doesn't consider runtime hostname changes. Is it important
> >>>    to keep track of it? Would changing it mid-auth steps break it
> >>>    somehow?
> > I think that's okay. AFAIK, that's only used for
> > debugging/troubleshooting purposes. So it doesn't need to be a 100%
> > accurate.
>
> That's not true, the workstation name is used for access checks.
>
> [MS-ADA3] 2.353 Attribute userWorkstations
> https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-ada3/ec941bac-bc77-48f3-a1cf-79d773a91b6b
>
I see.
So ideally we should be setting the FQDN of the client here. I don't
know if there's a way to get the FQDN from within the kernel.
I'll just set the utsname()->nodename for now. If someone has better
ideas, feel free to chime in.

> >>>
> >>> - I didn't understand the purpose of CIFS_DEFAULT_WORKSTATION_NAME. Why
> >>>    not simply use utsname()->nodename? Or even init_utsname()->nodename, which
> >>>    is supposed to be always valid.
> > I initially did not have the utsname changes. That idea was an afterthought.
> > Sure. I'll update the patch to fix this.
> >
> >>>
> >>> - Ditto for CIFS_MAX_WORKSTATION_LEN. utsname()->nodename has at most 65
> >>>    bytes (__NEW_UTS_LEN + 1) anyway. Perhaps using MAXHOSTNAMELEN from
> >>>    <asm/param.h> would be a more generic approach.
> >>>    (btw this is because nodename is the unqualified hostname, sans-domain)
> > Noted.
> >
> >>>
> >>> - Instead of setting workstation_name to "nodename:release", why not
> >>>    implement the VERSION structure (MS-NLMP 2.2.2.10)? Then use
> >>>    LINUX_VERSION_* from <linux/version.h> or parse utsname()->release.
> > That's a good idea. Let me explore that too.
>
> No, it's not this is for windows version numbers.
> https://docs.microsoft.com/en-us/openspecs/windows_protocols/ms-nlmp/a211d894-21bc-4b8b-86ba-b83d0c167b00#Appendix_A_32
>
> If you want to encode something you can use
> 2.2.2.2 Single_Host_Data
>
> metze

Thanks for the tip. I'll explore this option for a future fix.

-- 
Regards,
Shyam
