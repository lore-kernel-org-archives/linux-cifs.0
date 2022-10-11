Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E41C433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Oct 2022 19:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiJKTM4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Oct 2022 15:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiJKTMs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Oct 2022 15:12:48 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9CF4660E
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 12:12:47 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id d187so15331237vsd.6
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 12:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=F9+ulosHDIs2Jgm180779DI+tOC1wWup7HPaHcmL7NE=;
        b=pqm7gO8vhROWTcT/kbLPxi1C67EC7Ve86cWEfn3IeOMsAYRVoXPnjpA9ePoGWCbrYd
         9Qzh4DrbLzRL+U7Yl5sp8CScjK81Js+y04sy0Afw0nfe/p0M0n2U7ltmyHgPoTa+E6YO
         ShjLCjfdIB4tf8sUgZJNG4P0uFRDA3uWPJUYGVuwo7UzVcqcMoHpPuaoh0ANCa5URSJP
         yccz/mg9ZgcPoS4LV+NlC2+F3meQJVpg/cRNjNHrZMaPf3B2fdMVyeRknuMcYQ5pXT9z
         gEaCESZd/LmvcAqH4Ups2BchoGJ4SzQM8FzKmHWPjyl5STvCnuaJ0lflUvCSjQdjz8f9
         4+Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F9+ulosHDIs2Jgm180779DI+tOC1wWup7HPaHcmL7NE=;
        b=DdSB4FcrwYvMsxyJxW3Agt96bncJNdydxkeYKYgR3oxWgmoQ4cWjjrmGG+L0DfTNVR
         wbsdW62B67c06VkbTHZ1JwLyM0frTLaPeycmMDfaWhjdJwB+cCubRhwgfMctj3zuPUFN
         zH0qoQW/yXBPcZEnV0PmP0xRtKW4thYSwOYz7zVxBsnpB/IKjrcG8XK9OoQ5VSSN+Pa4
         uXbMU0UyvK2EkgDcTZuX1Bvl6Bk8sQdjAqGa42WXT7E8194kWEoNadXbYN+3UY5Vvt3T
         xiqOyksEkNnS2ZueA7n00W7GEN5JU5wneBHy9JUh/Sf2+C8esuZATtkvQ7nLVj1Kr4t5
         so7w==
X-Gm-Message-State: ACrzQf0QwYL4B5Z3sWQz1qHgGAddoRJeTDBIiOTMWqexBF+B7MWSaNh9
        oeG4vMQraYlnoRgqHU9vjtnDWhe2r+HqK0Q65dssFYcW
X-Google-Smtp-Source: AMsMyM5Yw1wf6u7xzSettAXuIDdioSKHiQ5u7H+WNTRiyar6QstXJgm4YCTrxXOZAeiTnfSeVI3W6XXmu20Xu0JALQU=
X-Received: by 2002:a05:6102:23dc:b0:3a7:9b0c:aa8e with SMTP id
 x28-20020a05610223dc00b003a79b0caa8emr4157524vsr.60.1665515566330; Tue, 11
 Oct 2022 12:12:46 -0700 (PDT)
MIME-Version: 1.0
References: <CACVrvT5CMERoJN4fz-MdNOOUV9VpOT_vv764UEgzDdaUEC9nUg@mail.gmail.com>
 <CAH2r5muHfRp0yA6G4Z0iJppy7CO_n=EYoZ0__U_iTGUJFOnKpg@mail.gmail.com> <20221011185714.5elxjbut7cvfed6x@suse.de>
In-Reply-To: <20221011185714.5elxjbut7cvfed6x@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 11 Oct 2022 14:12:35 -0500
Message-ID: <CAH2r5ms=F_p5Ns_sGWsy4Ggrs9PnaNQszu3XKkSBH9+cGMp0Aw@mail.gmail.com>
Subject: Re: A patch to implement the already documented "sep" option for the
 CIFS file system.
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Dmitry Telegin <dmitry.s.telegin@gmail.com>,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

All three approaches seem to parse it in user space, which makes
sense.  Easier to do it in mount.cifs than in kernel fs_context
parsing

On Tue, Oct 11, 2022 at 1:57 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> On 10/11, Steve French wrote:
> >makes sense.
> >
> >Did anyone else review this yet?  (the mount.cifs version of the patch)
>
> At a glance, the patch seems ok and solves a real problem.
>
> However, I think a better approach would be to parse the string in user
> space, i.e. it's much easier for mount.cifs to fetch what's the
> UNC/password string if they're passed quoted (shell handles it), and
> then use 0x1E (ASCII Record Separator) instead of a comma.  Then, in
> the kernel, we'd only need to strsep() by 0x1E.  Since 0x1E is a
> non-printable ASCII character, I have a hard assumption it's not allowed
> as UNC/password in most systems.  Also since it would be only used
> internally between mount.cifs and cifs.ko, users would not need to know
> nor care about it.
>
> Thoughts?
>
>
> Enzo
>
> >On Sat, Oct 8, 2022 at 2:41 PM Dmitry Telegin
> ><dmitry.s.telegin@gmail.com> wrote:
> >>
> >> DESCRIPTION OF THE PROBLEM
> >>
> >> Some users are accustomed to using shared folders in Windows with a
> >> comma in the name, for example: "//server3/Block 3,4".
> >> When they try to migrate to Linux, they cannot mount such paths.
> >>
> >> An example of the line generated by "mount.cifs" for the kernel when
> >> mounting "//server3/Block 3,4":
> >> "ip=10.0.2.212,unc=\\server3\Block 3,4,iocharset=utf8,user=user1,domain=AD"
> >> Accordingly, due to the extra comma, we have an error:
> >> "Sep 7 21:57:18 S1 kernel: [ 795.604821] CIFS: Unknown mount option "4""
> >>
> >>
> >> DOCUMENTATION
> >>
> >> https://www.kernel.org/doc/html/latest/admin-guide/cifs/usage.html
> >> The "sep" parameter is described here to specify a new delimiter
> >> instead of a comma.
> >> I quote:
> >>    "sep
> >>    if first mount option (after the -o), overrides the comma as the
> >> separator between the mount parms. e.g.:
> >>    -o user=myname,password=mypassword,domain=mydom
> >>    could be passed instead with period as the separator by:
> >>    -o sep=.user=myname.password=mypassword.domain=mydom
> >>    this might be useful when comma is contained within username or
> >> password or domain."
> >>
> >>
> >> RESEARCH WORK
> >>
> >> I looked at the "mount.cifs" code. There is no provision for the use
> >> of a comma by the user, since the comma is used to form the parameter
> >> string to the kernel (man 2 mount). This line can be seen by adding
> >> the "--verbose" flag to the mount.
> >> "mount.cifs --help" lists "sep" as a possible option, but does not
> >> implement it in the code and does not describe it in "man 8
> >> mount.cifs".
> >>
> >> I looked at the "pam-mount" code - the mount options are assembled
> >> with a wildcard comma. The result is a text line: "mount -t cifs ...".
> >>
> >> The handling of options in the "mount" utility is based on the
> >> "libmount" library, which is hardcoded to use only a comma as a
> >> delimiter.
> >>
> >> I tried to mount "//server3/Block 3,4" with my own program (man 2
> >> mount) by specifying "sep=!" - successfully.
> >>
> >>
> >> SOLUTION
> >>
> >> It would be nice if we add in "mount.cifs", in "mount" utility and in
> >> "pam-mount" the ability to set a custom mount option separator. In
> >> other words, we need to implement the already documented "sep" option.
> >>
> >> 1. For "mount.cifs" I did it in:
> >> https://github.com/dmitry-telegin/cifs-utils in branch
> >> "custom_option_separator". Commit:
> >> https://github.com/dmitry-telegin/cifs-utils/commit/04325b842a82edf655a14174e763bc0b2a6870e1
> >>
> >> 2. For "mount" utility I did it in:
> >> https://github.com/dmitry-telegin/util-linux in branch
> >> "custom_option_separator". Commit:
> >> https://github.com/dmitry-telegin/util-linux/commit/5e0ecd2498edae0bf0bcab4ba6a68a9803b34ccf
> >>
> >> 3. For "pam-mount" I did it in:
> >> https://sourceforge.net/u/dmitry-t/pam-mount/ci/master/tree/ in branch
> >> "custom_option_separator". Commit:
> >> https://sourceforge.net/u/dmitry-t/pam-mount/ci/9860f9234977f1110230482b5d87bdcb8bc6ce03/
> >>
> >> I checked the work on the Linux 5.10 kernel.
> >>
> >> --
> >> Dmitry Telegin
> >
> >
> >
> >--
> >Thanks,
> >
> >Steve



-- 
Thanks,

Steve
