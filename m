Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5339C77B7E
	for <linux-cifs@archiver.kernel.org>; Fri, 26 May 2023 02:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbjEZCj7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 May 2023 22:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241041AbjEZCjw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 May 2023 22:39:52 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9977194
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 19:39:49 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-96f7bf3cf9eso40128066b.0
        for <linux-cifs@vger.kernel.org>; Thu, 25 May 2023 19:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685068788; x=1687660788;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jtyJ2YgemJB5j2IZr3EjuKVZh/s6jcvGUdflnfZ+1f8=;
        b=mbcAlGGi9k7xhOYbr+BXSFhuBD+0IsKpy/Bg5mE1NgD9HIRnXG1oHf/T+R9t3iXDpc
         zUiRURDM1xdKzqYkFK+ageoEHs/QwLIRtbbY8gS5YE+JQ0HV174Lw5i01kU2JqZWZY3s
         vEVdjyAn1Kx1QhLqAnqpOHB/WJLOGOhpaPXW/86OJryVpUXn+5hvURdBQDY6cb6gwO4g
         EIjkAR/yh6dSf+bwQqhDBoUgYSo5UStV92Id/ykQ3O2p/vlBGblgLpCkiftHsXH5ZFhK
         F1YEvkaTB6/HeiZdDeqqW9IOUOEKl/DJctQ+YxDr1pwMHyukNV7OlK6R6mBU5iZMwgGy
         fpGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685068788; x=1687660788;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jtyJ2YgemJB5j2IZr3EjuKVZh/s6jcvGUdflnfZ+1f8=;
        b=TL3tQRVDjuD/b8cVmB/R7KVXM7NB9AfhggOnV0te2PRojrzT/UhPKM0u62ZSNZGVN1
         PmVZf85rVY+I/vB5RBh/Ms8JKZeys1QwEc2dLh+sJv7tIJhbDT02LQlOwCtpYNV7Y5Zn
         lZ4Nk68NIEZuZQb3glLTni6FDvXpwBQRtzMAkqJUy7AgEboUY9EyRdLR31ICQ5ZqD7jE
         vknirMbJ9tSvsVilhvvbLPnLbqj1HX6DoDqgR5E0pYivkII/lDoxe/y5RLtNdWPOysBm
         q5Oe5FlP4nKxCZdNv58076zqIjMYkcgyauMod8qgFpzvxR5sUkYRmh1tYotnKZJ3nz3b
         O7KQ==
X-Gm-Message-State: AC+VfDyQR7nCM/eqAV0jFftF9bKr9pRP8xhf1lxPg3DuXJyqTSUh6Nik
        mtaxdI+T7N/Xf4RqN6nYQobgjedmKa61SosmYAc=
X-Google-Smtp-Source: ACHHUZ4+iTpbTcNqomzeawaHoHLFhSykLas5JERcQKALdEQU1sHEdLuFvasBJFoOeUus1KQzDVS6HPZkUTYn4lbJNWs=
X-Received: by 2002:a17:907:26c3:b0:961:be96:b0e0 with SMTP id
 bp3-20020a17090726c300b00961be96b0e0mr597700ejc.73.1685068787993; Thu, 25 May
 2023 19:39:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mv8nAncg-f=Z5u8LkH4o7kfJLJdtoksYQgiguF7efKZkQ@mail.gmail.com>
 <CAN05THRKq9XPD11rBWXyTL_OGSh4pP6mQyufeW+xc+J3wvkMmw@mail.gmail.com>
 <CAH2r5mtJfSiQXBRUwv6zcR5rhG2Q-pCvjH+n+_SZmVQo1pMeVg@mail.gmail.com>
 <ZGuWhzP98U9Niog+@jeremy-rocky-laptop> <CAN05THRnHcZtTMLxUSCYQXULVHiOXVYDU9TRy9K+_wBQQ1CFAw@mail.gmail.com>
 <ZGzo+KVlSTNk/B0r@jeremy-rocky-laptop> <CAN05THQyraiyQ9tV=iAbDiirWzPxqPq9rY4WsrnqavguJCEjgg@mail.gmail.com>
 <ZG0/YyAqqf0NqUuO@jeremy-rocky-laptop> <CAN05THSWHq-3bJ5+tzZ==j9uGFGfbALw0FoLVa9UyucaZ92bGQ@mail.gmail.com>
 <ZG+JqEwIdPHmHhVa@jeremy-rocky-laptop>
In-Reply-To: <ZG+JqEwIdPHmHhVa@jeremy-rocky-laptop>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 26 May 2023 12:39:34 +1000
Message-ID: <CAN05THQVK7O75NY8mts7J=n7V4PErWCNWkM8NfCNJTH7p=W2_w@mail.gmail.com>
Subject: Re: Displaying streams as xattrs
To:     Jeremy Allison <jra@samba.org>
Cc:     Steve French <smfrench@gmail.com>,
        samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, 26 May 2023 at 02:15, Jeremy Allison <jra@samba.org> wrote:
>
> On Thu, May 25, 2023 at 08:57:18PM +1000, ronnie sahlberg via samba-technical wrote:
> >On Wed, 24 May 2023 at 08:34, Jeremy Allison <jra@samba.org> wrote:
> >>
> >> ADS - "Just Say No !"
> >
> >I think that is a flawed argument.
> >It only really means that the virus scanners are broken. So we tell
> >the virus scanner folks to fix their software.
> >Viruses hide inside all sort of files and metadata.
> >There are viruses that hide inside JPEG files too and some of them
> >even gain privilege escalations through carefully corrupted JPEG
> >files.
> >We fix the bugs in the parser, we don't "drop support for JPEG files".
>
> What is the use-case for ADS on Linux ? And don't say "Windows
> compatibility" - stories about your mother's advice about
> jumping off a cliff have meaning here :-).
>
> Give me an actual *need* for ADS on Linux that can't
> be satified any other way before you start plumbing
> this horror into the internal VFS code.

I think it is too late to stop alternate data streams from entering
the kernel. They, or their equivalents, are already part of the
kernel.
This discussion is more about how to unify these things and provide an
abstracted api that is common across all filesystems than each
filesystem having a unique way to access them.
Filesystems that have protocol support for this is NTFS (ADS), CIFS
(ADS), NFS4 (named attributes) and HFS (forks). there could be more, I
have not checked.
These four are probably the four most common filesystems in use today
(ignoring FAT) across all platforms so support for this type of
feature is pretty much uniquous.

I think what we want to do is to have a discussion across maintainers
of all these filesystems and see if there is desire to work out a
common API and featureset and how that API would look.
How that API would work and what it would look like is a question
worthy to discuss.
Solaris surfaced this feature via openat() but that is just one of
many possible implementations. A separate userspace library that
provides universal access to these streams using something else would
work just as well. The discussion should be on how probe interest and
work together to create a unified abstraction common across all
filesystems. Then later work on what exactly the kernel API to access
this would look like.

For use cases? Something as trivial as storing an icon for use by
graphical file managers would be a huge quality of life improvement.
Even better if it would be compatible with how windows explorer stores
those same icons.
