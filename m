Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F6CFC38A02
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Oct 2022 10:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiJ1KIQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Oct 2022 06:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJ1KIP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Oct 2022 06:08:15 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51161104D0A
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 03:08:14 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id g7so7501903lfv.5
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 03:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YHhrmtY3iWgY76K73S3+jeqkBJXT8kHKXOqWxY3+/9o=;
        b=OYCdcnNHeOwY6GH57Ecgy7N05CTLfrLWWKBORuBPv/KLj0TguHdAXbka+attl2vW6x
         5j4hNBqg5pCejoTNU2kTt9cfiL7LkWCG6v7KZOUKGAsr4ww650l/+UaO8KPoZ1SJbc19
         ak0nOmqdqNeZQhPXvD1/sdMvCxYPY9VzU6yW/h7LiKD1ico9pMmFOr17EGl3EQ8XcXIi
         sUnF03IRmRbSuVfGaZRZNQdd52AlwxExl2TJ5gepXVdln/Vl5RCX1OukvYMA57GI7Xh9
         DQiMaCSo0Ugqqi8CGNO35tQGYq7MdftfAUrULFLbTgtOw4itwEZzFYay6rCog5Tz19jO
         vykQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YHhrmtY3iWgY76K73S3+jeqkBJXT8kHKXOqWxY3+/9o=;
        b=MEoNFqqiAKEYvfXiERovXOPpX8JXJj/2DXyes2HRwxQx0245N1qEQZOF93jD1m6O0t
         otqGLWJmZxmeUH9jlYkUhuqkdUTq0AH76Zs3cskh/p50L/yMYcj/3wi7N56O8CnKTGY9
         1/1heqaYZ5VGDrKxCJfK3pdeSPahvXqSOS+FCrkvpa1Jo50A3io6ZrVeeNtHTp4pRWb6
         ZmsD2evQXyN8GgPXEvV4/KLFfaJF9tyUpA2x5p07nqLWyy0p5ZglmZ4QPtKR5F6CTgWZ
         HMiink7cd1Yfg02bvwV6x51xu/rmqtMpXX6FEj6nIp9fNqyMa5SC98hfiJj9O9UzBZ6/
         /CWg==
X-Gm-Message-State: ACrzQf0Iq1SZ7xqVxhc2AuePJjZqt58BoUNplcpdJcQ5ousF9VmVPdtl
        hirVODhp505S/CZFZIwkpiS1nJXDfYMRf03LQbY=
X-Google-Smtp-Source: AMsMyM5/pOFLiJMRUFmhYgl0655Y5Mv+pl/9uS01MIgbe+yOi/iUXkZyDzhvVmXefKFLYQ4tc6Q0CA8c+xTAhQNz5qo=
X-Received: by 2002:ac2:5f97:0:b0:4b0:144:a243 with SMTP id
 r23-20020ac25f97000000b004b00144a243mr2480175lfe.394.1666951692377; Fri, 28
 Oct 2022 03:08:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muCMfv4HuPw6sEgKj3Ude3cz+-NRdxDXpJr3CNtUAnm7A@mail.gmail.com>
 <CAN05THQ_C_mqq-S69f53EZQUxB2Q3rNrnVU-vRH_6kt=M0-Uwg@mail.gmail.com>
 <CAH2r5mu5cTX2gWhoyUBbkLeTtJeVvOH0vn_j_5DNwQ2__Rh38w@mail.gmail.com>
 <CAN05THRpHkXnx8NqjdEb=4BcxwsK7u+jYDSTEHdHXX_c5OZmYg@mail.gmail.com> <CAN05THSBzu7fgXSybe4isLGPRYxWLkZDZb_Lmox3TneAQfVP=g@mail.gmail.com>
In-Reply-To: <CAN05THSBzu7fgXSybe4isLGPRYxWLkZDZb_Lmox3TneAQfVP=g@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 28 Oct 2022 15:38:01 +0530
Message-ID: <CANT5p=oaTX4R-mzZpWXxT52--AKnJ0DzN+zL6XGuaQguH5_GLA@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] fix oplock breaks when using multichannel
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Oct 28, 2022 at 2:49 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Fri, 28 Oct 2022 at 16:55, ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
> >
> > On Fri, 28 Oct 2022 at 16:53, Steve French <smfrench@gmail.com> wrote:
> > >
> > > I haven't tried a scenario to windows where we turn off leases and force server to use oplocks but with ksmbd that is the default.
> > > Worth also investigating how primary vs secondary works for finding leases for windows case
> >
> > Yes. Until we know what/how windows does things and what ms-smb2.pdf
> > says  we can not know if this is a cifs client bug or a ksmbd bug.
>
> So lets wait with this patch until we know where the bug is.
> I will review it later for locking correctness, but lets make sure it
> is not a ksmbd bug first.
>
>
> >
> >
> > >
> > > On Fri, Oct 28, 2022, 01:48 ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
> > >>
> > >> On Fri, 28 Oct 2022 at 16:25, Steve French <smfrench@gmail.com> wrote:
> > >> >
> > >> > If a mount to a server is using multichannel, an oplock break arriving
> > >> > on a secondary channel won't find the open file (since it won't find the
> > >> > tcon for it), and this will cause each oplock break on secondary channels
> > >> > to time out, slowing performance drastically.
> > >> >
> > >> > Fix smb2_is_valid_oplock_break so that if it is a secondary channel and
> > >> > an oplock break was not found, check for tcons (and the files hanging
> > >> > off the tcons) on the primary channel.
> > >>
> > >> Does this also happen against windows or is is only against ksmbd this triggers?
> > >> What does MS-SMB2.pdf say about channels and oplocks?
> > >>
> > >> >
> > >> > Fixes xfstest generic/013 to ksmbd
> > >> >
> > >> > Cc: <stable@vger.kernel.org>
> > >> >
> > >> >
> > >> > --
> > >> > Thanks,
> > >> >
> > >> > Steve

This is a valid bug, and needs to be fixed.
Here's my version of the fix. Few more places needed corrections.
Please review:
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/2b57cec4d03464f4875671d4146e75fb41476941.patch

I think I know why this is an issue only for oplocks and not leases.
Both is_valid_oplock_break and smb2_is_valid_oplock_break pass server
(on which the notification was received) as an arg.

However, for some strange reason, smb2_is_valid_lease_break does not.
That is what saved lease break from this bug.
I think passing the server as an arg even for lease break check will
save some unnecessary iterations.

I'm seeing similar behaviour in couple of other places. Fixed them here:
https://github.com/sprasad-microsoft/smb3-kernel-client/commit/6bfba4f4939afb36364e6c4f4f8ca979cd526729.patch

Thoughts?

-- 
Regards,
Shyam
