Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF35C4332F
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Oct 2022 09:55:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiJLJz4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 12 Oct 2022 05:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiJLJzz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 12 Oct 2022 05:55:55 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604C17199D
        for <linux-cifs@vger.kernel.org>; Wed, 12 Oct 2022 02:55:54 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 81so19450764ybf.7
        for <linux-cifs@vger.kernel.org>; Wed, 12 Oct 2022 02:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Jp5TeaPNJUO6iZcRmXYh0cjQnSpVbyVQhWHEMpuLAA=;
        b=otgu+Er6L5YPe5aHlZgi+V3WLRmo02eCCuu38qhxTVX0HnLXcwWBFycACIZelzNLz/
         3mJ7NIzVXFeryTuPytKOpxzGoPmmnfCvFtjmanLjphHIVg/4g0pVHb2HJgDFBKepvPjY
         QmsGSvfLI4t18zrh2OVbs02cTBKalMFqTKWoShfESHAQpxB0BNvL2ksMHm9UGljI0y7R
         baT2gXZupmc6RmMinXGek+Tcjj2mMJX8clZ25jgferDvBAg1XG+DUvfQocCCpkRfGYCF
         tcvsfnFyhNc/0rF736FXXMlA/y/tzfWx0DSbmp7GHUl5fXyul+Hcgi2fwN5eYzqhBPWy
         ZVNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Jp5TeaPNJUO6iZcRmXYh0cjQnSpVbyVQhWHEMpuLAA=;
        b=a7acbrLA2tFHrrVz2OhhtkgFxji/ckCCEewLawGBRmAGS/PT4qrxWGGkaFOON1X1+A
         V3BPRM+buH0ZbNStr+ojoSbIBlhdVrZ+f5sfm9I3q75pI0/GYXylPwSrj/9BLIKQNTC+
         QPVqU04S7wm9gBAldQCQC9BUOduE/sqUkFy5I3jA+ZmqoxPYoWd+rmr55V3H0G0jGRtq
         Hv/rPDAdxnP/a35HoPJ0NTpF8hjP4Ri4gX28UQunWjdwmNzQnToM+cH/v7tTsNIb7AFV
         ZKLhOf2ueuoPi5f8gcq2vj8vIC36Pl1Kqmm2ykBGo5Sw8vi8lUoVaLpHDARLV2fd3RA5
         OEdA==
X-Gm-Message-State: ACrzQf3N93w4NAD/LN1DZbfZqJlyuHdVKaNkxY/SaqEb6aCbze8Lin6p
        ruZqOTRHQR6Yi1vASJLXY6ubMWLWI4RMH0zeXoA=
X-Google-Smtp-Source: AMsMyM7O/SESUm9a4vtdLoZnjUuFdA5naUCwPHQVViCq2qFthhU/wSCRNmDqFra+EHGNY/hubQ1UnV8lnupuH6s9Zh8=
X-Received: by 2002:a25:e781:0:b0:6bf:bd96:46a2 with SMTP id
 e123-20020a25e781000000b006bfbd9646a2mr22187910ybh.129.1665568553585; Wed, 12
 Oct 2022 02:55:53 -0700 (PDT)
MIME-Version: 1.0
References: <CACVrvT5CMERoJN4fz-MdNOOUV9VpOT_vv764UEgzDdaUEC9nUg@mail.gmail.com>
 <CAH2r5muHfRp0yA6G4Z0iJppy7CO_n=EYoZ0__U_iTGUJFOnKpg@mail.gmail.com>
 <20221011185714.5elxjbut7cvfed6x@suse.de> <CAH2r5ms=F_p5Ns_sGWsy4Ggrs9PnaNQszu3XKkSBH9+cGMp0Aw@mail.gmail.com>
 <20221011192138.dy44o34fpfhg5ck3@suse.de>
In-Reply-To: <20221011192138.dy44o34fpfhg5ck3@suse.de>
From:   Dmitry Telegin <dmitry.s.telegin@gmail.com>
Date:   Wed, 12 Oct 2022 13:55:42 +0400
Message-ID: <CACVrvT5YJHM8ofpf0vK+XPo89O284imZ6ckf=a2G+8gpFme_fg@mail.gmail.com>
Subject: Re: A patch to implement the already documented "sep" option for the
 CIFS file system.
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
        Leif Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> Yes, I'm just saying that the original approach (having a 'sep=3D' option=
)
> would require implementation in the kernel as well (it currently doesn't
> exist).

I tested the solution I proposed on the kernels 4.19 and 5.10.
"sep=3D" is successfully recognized on these Linux kernels.
Did the new kernel remove support for this option?

About escape sequences.
Please pay attention to the thoughts of the authors of "pam-mount" and
"util-linux" in order to get a complete solution:
https://sourceforge.net/p/pam-mount/pam-mount/merge-requests/7/
https://github.com/util-linux/util-linux/pull/1836

=D0=B2=D1=82, 11 =D0=BE=D0=BA=D1=82. 2022 =D0=B3. =D0=B2 23:21, Enzo Matsum=
iya <ematsumiya@suse.de>:
>
> On 10/11, Steve French wrote:
> >All three approaches seem to parse it in user space, which makes
> >sense.  Easier to do it in mount.cifs than in kernel fs_context
> >parsing
>
> Yes, I'm just saying that the original approach (having a 'sep=3D' option=
)
> would require implementation in the kernel as well (it currently doesn't
> exist).  If we just replace the comma by 0x1E in both mount.cifs and the
> kernel, we don't need all this fiddling with custom separators.
>
>
> Enzo
>
> >On Tue, Oct 11, 2022 at 1:57 PM Enzo Matsumiya <ematsumiya@suse.de> wrot=
e:
> >>
> >> On 10/11, Steve French wrote:
> >> >makes sense.
> >> >
> >> >Did anyone else review this yet?  (the mount.cifs version of the patc=
h)
> >>
> >> At a glance, the patch seems ok and solves a real problem.
> >>
> >> However, I think a better approach would be to parse the string in use=
r
> >> space, i.e. it's much easier for mount.cifs to fetch what's the
> >> UNC/password string if they're passed quoted (shell handles it), and
> >> then use 0x1E (ASCII Record Separator) instead of a comma.  Then, in
> >> the kernel, we'd only need to strsep() by 0x1E.  Since 0x1E is a
> >> non-printable ASCII character, I have a hard assumption it's not allow=
ed
> >> as UNC/password in most systems.  Also since it would be only used
> >> internally between mount.cifs and cifs.ko, users would not need to kno=
w
> >> nor care about it.
> >>
> >> Thoughts?
> >>
> >>
> >> Enzo
> >>
> >> >On Sat, Oct 8, 2022 at 2:41 PM Dmitry Telegin
> >> ><dmitry.s.telegin@gmail.com> wrote:
> >> >>
> >> >> DESCRIPTION OF THE PROBLEM
> >> >>
> >> >> Some users are accustomed to using shared folders in Windows with a
> >> >> comma in the name, for example: "//server3/Block 3,4".
> >> >> When they try to migrate to Linux, they cannot mount such paths.
> >> >>
> >> >> An example of the line generated by "mount.cifs" for the kernel whe=
n
> >> >> mounting "//server3/Block 3,4":
> >> >> "ip=3D10.0.2.212,unc=3D\\server3\Block 3,4,iocharset=3Dutf8,user=3D=
user1,domain=3DAD"
> >> >> Accordingly, due to the extra comma, we have an error:
> >> >> "Sep 7 21:57:18 S1 kernel: [ 795.604821] CIFS: Unknown mount option=
 "4""
> >> >>
> >> >>
> >> >> DOCUMENTATION
> >> >>
> >> >> https://www.kernel.org/doc/html/latest/admin-guide/cifs/usage.html
> >> >> The "sep" parameter is described here to specify a new delimiter
> >> >> instead of a comma.
> >> >> I quote:
> >> >>    "sep
> >> >>    if first mount option (after the -o), overrides the comma as the
> >> >> separator between the mount parms. e.g.:
> >> >>    -o user=3Dmyname,password=3Dmypassword,domain=3Dmydom
> >> >>    could be passed instead with period as the separator by:
> >> >>    -o sep=3D.user=3Dmyname.password=3Dmypassword.domain=3Dmydom
> >> >>    this might be useful when comma is contained within username or
> >> >> password or domain."
> >> >>
> >> >>
> >> >> RESEARCH WORK
> >> >>
> >> >> I looked at the "mount.cifs" code. There is no provision for the us=
e
> >> >> of a comma by the user, since the comma is used to form the paramet=
er
> >> >> string to the kernel (man 2 mount). This line can be seen by adding
> >> >> the "--verbose" flag to the mount.
> >> >> "mount.cifs --help" lists "sep" as a possible option, but does not
> >> >> implement it in the code and does not describe it in "man 8
> >> >> mount.cifs".
> >> >>
> >> >> I looked at the "pam-mount" code - the mount options are assembled
> >> >> with a wildcard comma. The result is a text line: "mount -t cifs ..=
.".
> >> >>
> >> >> The handling of options in the "mount" utility is based on the
> >> >> "libmount" library, which is hardcoded to use only a comma as a
> >> >> delimiter.
> >> >>
> >> >> I tried to mount "//server3/Block 3,4" with my own program (man 2
> >> >> mount) by specifying "sep=3D!" - successfully.
> >> >>
> >> >>
> >> >> SOLUTION
> >> >>
> >> >> It would be nice if we add in "mount.cifs", in "mount" utility and =
in
> >> >> "pam-mount" the ability to set a custom mount option separator. In
> >> >> other words, we need to implement the already documented "sep" opti=
on.
> >> >>
> >> >> 1. For "mount.cifs" I did it in:
> >> >> https://github.com/dmitry-telegin/cifs-utils in branch
> >> >> "custom_option_separator". Commit:
> >> >> https://github.com/dmitry-telegin/cifs-utils/commit/04325b842a82edf=
655a14174e763bc0b2a6870e1
> >> >>
> >> >> 2. For "mount" utility I did it in:
> >> >> https://github.com/dmitry-telegin/util-linux in branch
> >> >> "custom_option_separator". Commit:
> >> >> https://github.com/dmitry-telegin/util-linux/commit/5e0ecd2498edae0=
bf0bcab4ba6a68a9803b34ccf
> >> >>
> >> >> 3. For "pam-mount" I did it in:
> >> >> https://sourceforge.net/u/dmitry-t/pam-mount/ci/master/tree/ in bra=
nch
> >> >> "custom_option_separator". Commit:
> >> >> https://sourceforge.net/u/dmitry-t/pam-mount/ci/9860f9234977f111023=
0482b5d87bdcb8bc6ce03/
> >> >>
> >> >> I checked the work on the Linux 5.10 kernel.
> >> >>
> >> >> --
> >> >> Dmitry Telegin
> >> >
> >> >
> >> >
> >> >--
> >> >Thanks,
> >> >
> >> >Steve
> >
> >
> >
> >--
> >Thanks,
> >
> >Steve

--
Dmitry Telegin
