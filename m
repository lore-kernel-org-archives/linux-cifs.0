Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D812C433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Nov 2021 07:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3FCBB6109F
	for <linux-cifs@archiver.kernel.org>; Sat,  6 Nov 2021 07:02:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbhKFHFc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 6 Nov 2021 03:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhKFHFc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 6 Nov 2021 03:05:32 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E8EC061570
        for <linux-cifs@vger.kernel.org>; Sat,  6 Nov 2021 00:02:51 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id r4so39881151edi.5
        for <linux-cifs@vger.kernel.org>; Sat, 06 Nov 2021 00:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9E7RBz+vZs5Trf+tInfkn1TkuX4NLTVgceQdDw7N38U=;
        b=k6oJQU+v1GyRJIeweMSUJLev1yXfZNbmsFO1FHvpvs5YoO0shP8BfzHJlXLE2woqYY
         yAPz8oJ3c5wiiaCehzHvhZiE7Dmx8vAbEO6Xoz7KNtHsnArK9tQfXhcEmXDJWRFSLDTC
         jbCJ74H5I23+MYibNT3gElC3RQWdLMJXcEpNQI5l5Y/9z6casM5lTseGB0i/S3uHkSA6
         1CCBKqozdQk3lclw5qoI14bSaY5vXEPPs74QSp9OWM/GgA7pq7K0XXcGQqXJPxIhwsPO
         Ri6WSrJD4mK0B7K700ADjSBfu9nFiqs77ydMSlaiBtqXLt1wZIb+UeEA0ZByaCL5hT9s
         v1bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9E7RBz+vZs5Trf+tInfkn1TkuX4NLTVgceQdDw7N38U=;
        b=ogMsL8OSGJwW6F+0kcePwz5q+zmi5B7qt97TmZrTtbrs7g3BZRHfE+fiYBG+9oYQko
         KlRaKN42A9A7alLaFLCchwhbZcP7U+uT8ruVSyyJY/q8lpCW99zpse3BWW8EtDcq6sTC
         HLsIg6ZN/BXNPIc5cwOjix9omUKGqYaWtxBA9sD6GgGusBeUdyP4fNVmXIOoJ4/tLJGn
         YhHGhwGYqDnQohGinW7yy4ZQxrsHQc4HjhP87zDKaY+3EpSc5rbmOlYr7wkzQYWllapW
         9Pr5IlI/R7IgdOhteQoW1uZyKIIcM6YGQH3P6IanPAFwI5zw4hRoz0EaNNTnHKWfxUbr
         AOCQ==
X-Gm-Message-State: AOAM531tRJ0ByVRXp7vXTAK+wOjJqdUrerRkCrpnyHxUmEiQyUcBRCSt
        rOzU87AplZOPjxNaRMvGTHy3/1EJE3yGMRoVCNA=
X-Google-Smtp-Source: ABdhPJwcT0xGI3jZFNUjynmq5AzFyei5SThdAEbJUNvaxFxP0oafiIPQJ/LjgrjjTMBTHZCpuRA01obhIZuNip0iPfA=
X-Received: by 2002:a17:906:4787:: with SMTP id cw7mr12175755ejc.311.1636182169740;
 Sat, 06 Nov 2021 00:02:49 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=rgHn59NVvH32FSKtNv_cyKi4ATSAExBmWT_qjb7km7Fw@mail.gmail.com>
 <20211106013854.6qx3tz53pvayqcgm@cyberdelia> <CAH2r5mvQG0DFmMdzojH2u_w2=_9oGRV++AnEt_d7WJzj=-uTKA@mail.gmail.com>
 <CANT5p=qOQDg4xDbx6oZafJc+gnM0pN+aYOgjokU54ZeLXq_uDQ@mail.gmail.com>
In-Reply-To: <CANT5p=qOQDg4xDbx6oZafJc+gnM0pN+aYOgjokU54ZeLXq_uDQ@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sat, 6 Nov 2021 12:32:38 +0530
Message-ID: <CANT5p=p+vUkOmeozfDncRKzu5awry1a3KgDqVcff5ANaNCVEOA@mail.gmail.com>
Subject: Re: [PATCH] cifs: send workstation name during ntlmssp session setup
To:     Steve French <smfrench@gmail.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Nov 6, 2021 at 9:08 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Thanks for the reviews, Paulo and Enzo. Please read my replies below:
>
> On Sat, Nov 6, 2021 at 7:10 AM Steve French <smfrench@gmail.com> wrote:
> >
> > Interesting suggestions, probably worth experimenting with but even the original patch could help a lot eg help server to understand type of client connecting to it when debugging
> >
> > On Fri, Nov 5, 2021, 21:38 Enzo Matsumiya <ematsumiya@suse.de> wrote:
> >>
> >> Hi Shyam,
> >>
> >> I have some observations/suggestions regarding your patch:
> >>
> >> On 11/06, Shyam Prasad N wrote:
> >> >Hi Steve,
> >> >
> >> >Please review this patch, and let me know what you think.
> >> >Having this info in the workstation field of session setup helps
> >> >server debugging in two ways.
> >> >1. It helps identify the client by node name.
> >> >2. It helps get the kernel release running on the client side.
> >> >
> >> >https://github.com/sprasad-microsoft/smb3-kernel-client/commit/d988e704dd9170c19ff94d9421c017e65dbbaac1.patch
> >>
> >> - AFAICS it doesn't consider runtime hostname changes. Is it important
> >>    to keep track of it? Would changing it mid-auth steps break it
> >>    somehow?
> I think that's okay. AFAIK, that's only used for
> debugging/troubleshooting purposes. So it doesn't need to be a 100%
> accurate.
>
> >>
> >> - I didn't understand the purpose of CIFS_DEFAULT_WORKSTATION_NAME. Why
> >>    not simply use utsname()->nodename? Or even init_utsname()->nodename, which
> >>    is supposed to be always valid.
> I initially did not have the utsname changes. That idea was an afterthought.
> Sure. I'll update the patch to fix this.
>
> >>
> >> - Ditto for CIFS_MAX_WORKSTATION_LEN. utsname()->nodename has at most 65
> >>    bytes (__NEW_UTS_LEN + 1) anyway. Perhaps using MAXHOSTNAMELEN from
> >>    <asm/param.h> would be a more generic approach.
> >>    (btw this is because nodename is the unqualified hostname, sans-domain)
> Noted.
>
> >>
> >> - Instead of setting workstation_name to "nodename:release", why not
> >>    implement the VERSION structure (MS-NLMP 2.2.2.10)? Then use
> >>    LINUX_VERSION_* from <linux/version.h> or parse utsname()->release.
> That's a good idea. Let me explore that too.

Hi Enzo,
One "problem" with using just the version field is that it has a
predefined format.
This may not help us in decoding what distro and if it is a custom
kernel. utsname()->release gives all that.
So I'm planning to use workstation_name in the "hostname:release"
format. Let me know if you see some issues with it.

>
> >>
> >> >I ran some basic testing with the patch. Seems to serve the purpose.
> >> >Please let me know if I'm missing something.
> >>
> >> I hope I didn't miss anything.
> >>
> >>
> >> Cheers,
> >>
> >> Enzo
>
>
>
> --
> Regards,
> Shyam



-- 
Regards,
Shyam
