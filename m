Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D85BFC433C1
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Mar 2021 15:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A438561A27
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Mar 2021 15:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhCYPm4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Mar 2021 11:42:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbhCYPml (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Mar 2021 11:42:41 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9C9C06174A
        for <linux-cifs@vger.kernel.org>; Thu, 25 Mar 2021 08:42:41 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id s17so3719421ljc.5
        for <linux-cifs@vger.kernel.org>; Thu, 25 Mar 2021 08:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qgODEvGwNY/7hmpr7nElrTk8l5tB/W0wTmx5vwj5GU4=;
        b=hRi0SWDkaG2evYhmqccG7RwKjU7tIJjXETaRVPEC5sz8HXHJugwFHW0mJ7XESIGwMf
         rSv9jLGFnIlUdfeaJL0D89Qe3tgfTsiqfSkr1PEL/heecPyosEs51UgNSY4X52w+Xif2
         qYJ1U7qL/GlH9ut60uWzzdUIVNvV2QhfEGshMLAyqjUV7Iwf6gbzwuGgAJy+fJhG1ZEa
         fUbF5GEsQ4WFvHDWvKbczkwYt679bpQ+ECnE9MkaWUq9saRZAAvv5bfRRi4ITRf30cEm
         jEG8C/5CJWcYs2vsyuMBNf88AgzwCHfdnys4f6DUPMmvxnb5R4cnnLmlVIAGY1l/Aiou
         dYCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qgODEvGwNY/7hmpr7nElrTk8l5tB/W0wTmx5vwj5GU4=;
        b=UyYMoHiuqFwgL/mGoKVsTsytRGH/HjckGGfL8dIVQvA91fQqbLMxzYbEVQdKQSck6j
         IxuVUE4tgYfCy4XSSzMX0Ku91V23/OgdxuJOhZWCJN112vh0+Z4u8VYCBOuakAUOIGRq
         NBoDVtIllkyb9R+Vq6AAzDqEZTjLVon65YcI+qyGGcTVd0uKMlZO4nCEo2LfS/qcYmoM
         3vy1oHB2QuwUhNhNh29JDvDeR4K5PEkcwAayUxtTadGIuzNTY2lEZpLQl8+PhaQ0rwrF
         RUWDnZTUXOelIJd6zLSki311DHXryhqY4WYl05+JhbT/PeSipOe/DJQSUOTAXodTsoPE
         ZSkg==
X-Gm-Message-State: AOAM533jXNBsn6KMRWiMkpmfNB9dpTSoXSV0l1lBO1GpI6KacjCvNeLd
        1bK8cWL1tOpgmcA225s0lnbLKkAlvGr13Q2I/isxSiZjxI8=
X-Google-Smtp-Source: ABdhPJwZqjO37fyyK89VWN2VaqWP0NqqPYyNjWziBxq4TP7qstYX0Akok7C+r4DJAXhQgx/8DuWtZzN8A2SiQ9wKjzs=
X-Received: by 2002:a2e:98c5:: with SMTP id s5mr5935804ljj.218.1616686959556;
 Thu, 25 Mar 2021 08:42:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210325062635.43370-1-lsahlber@redhat.com> <87y2ebdz7z.fsf@cjr.nz>
In-Reply-To: <87y2ebdz7z.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 25 Mar 2021 10:42:28 -0500
Message-ID: <CAH2r5mshpO_T7OeO9fnCGRpJUTOYeu-OzGN2uVpHkAQEp86CVw@mail.gmail.com>
Subject: Re: [PATCH] cifs: revalidate mapping when we open files for SMB1 POSIX
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Thu, Mar 25, 2021 at 10:34 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Ronnie Sahlberg <lsahlber@redhat.com> writes:
>
> > RHBZ: 1933527
> >
> > Under SMB1 + POSIX, if an inode is reused on a server after we have read and
> > cached a part of a file, when we then open the new file with the
> > re-cycled inode there is a chance that we may serve the old data out of cache
> > to the application.
> > This only happens for SMB1 (deprecated) and when posix are used.
> > The simplest solution to avoid this race is to force a revalidate
> > on smb1-posix open.
> >
> >  Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/file.c | 1 +
> >  1 file changed, 1 insertion(+)
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>



-- 
Thanks,

Steve
