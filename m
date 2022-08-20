Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D18C25B08
	for <linux-cifs@archiver.kernel.org>; Sat, 20 Aug 2022 16:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345671AbiHTQJA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 20 Aug 2022 12:09:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345651AbiHTQI7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 20 Aug 2022 12:08:59 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8E926566
        for <linux-cifs@vger.kernel.org>; Sat, 20 Aug 2022 09:08:58 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id q190so7187680vsb.7
        for <linux-cifs@vger.kernel.org>; Sat, 20 Aug 2022 09:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=/q6MLPjCGTaP4hzwbXh1fVszSQAdc6LEr4ZNoHsKr/E=;
        b=DCcGcnDPVfCclMOM/nZwBD6k0BExKrB01u9OTiCR4IGIDeSd4IAgIB7l48Lc+Qz/T8
         1XgsCuf2hyaVkYxyKGskRWp+/mLMt7wYGM4Z3hQHwLy+wiUu6ykrcJP0Psxs0KI2pemj
         FVsiHgqOmfmtuQ5I0wgs0tTfPmVmxVNurFH3X93MwHPftSdXBHxFxwRHQGMA+A0w+HAA
         5dNq9Rt7upvLbnIeUSUh1Ut/4OU7oO9yzY6XaF4A+E4yTJXu3my6bdNnynPld527mUSZ
         0VjGlFwhHZXsvEn/VSJ8Tvd3eJ2Mp8ejzq2xfh9iBHZJPXEvLZs3Hv42oMlBIvPfMwX2
         HoVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=/q6MLPjCGTaP4hzwbXh1fVszSQAdc6LEr4ZNoHsKr/E=;
        b=MtNN/dX0UrJtjyWDV2sEtPdJJwbMu+H5DjSPBrOolSz4UWGHtqPR6VXrks/GEeL2Rg
         BhFDGeWpNCGzM1i6S+fxSlZkEWg7K+YCwFfWTV0dMZmXHN2DizW1QbRwHQqyAg6dnP+u
         0LTnxLbfSDjM0H+LVYIiu2gT/IzdqptCaLuvd3C4ka7dYIq4Vbgq20ydEBk8lu0BNATu
         J8vp7qExkXbsoe4vwss3PldgGGhcP3bWQ/mt1RskkU3Qe41HysNUQ9JFCSf6eu9eJStu
         Q0YRzSNwNqD9DQLZYCKvnHCMiPtbrMhc2XtsFf+RxbBLA1+kO474WuIwTZoR16N0Inj5
         Ry2Q==
X-Gm-Message-State: ACgBeo0N38s8DAhvuxRNjy7tUoLbOj0ubnTgK8iuTztraypgXbRIU+9T
        prrU2Cmlkd9hB4QfOLNZZOo82XV5LlDjjoq9ITI=
X-Google-Smtp-Source: AA6agR4MIOaOr7h7wOTe3aYLVocq926+R0rOhHlr0KM0xBLT5DOdq4JD4PZpI5XhsAUkpC7c9AHSEqXFAEqzZEKCXz8=
X-Received: by 2002:a67:b401:0:b0:387:8734:a09 with SMTP id
 x1-20020a67b401000000b0038787340a09mr4359154vsl.61.1661011737417; Sat, 20 Aug
 2022 09:08:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mtVOKN-8ET1oYC0L+ihAWpmwFY3=Q=-KP+qwcaAb002_A@mail.gmail.com>
 <36140.1661008981@warthog.procyon.org.uk>
In-Reply-To: <36140.1661008981@warthog.procyon.org.uk>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 20 Aug 2022 11:08:45 -0500
Message-ID: <CAH2r5ms+UJntZ=F4AP1SPmrKDfHHer0JhZO4qroGPAJ5HR-kEg@mail.gmail.com>
Subject: Re: [PATCH][SMB3] fix temporary data corruption in collapse range
To:     David Howells <dhowells@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If it is moved earlier it will have the effect of throwing away these
pages even if the copychunk fails (and thus if the collapse range
fails we end up still discarding).

Any thoughts?

On Sat, Aug 20, 2022 at 10:23 AM David Howells <dhowells@redhat.com> wrote:
>
> Steve French <smfrench@gmail.com> wrote:
>
> > +     truncate_pagecache_range(inode, off, old_eof);
>
> Upon further consideration, I think this should perhaps be before:
>
> >       rc = smb2_copychunk_range(xid, cfile, cfile, off + len,
>
> so that any outstanding shared-writable mmap can be made to wait.
>
> Also the invalidation in smb3_zero_range() only covers the hole, so
> smb3_insert_range() also needs to invalidate from the bottom of the hole to
> the EOF - and, again, I think it needs to do this before making changes to the
> file contents.
>
> David
>


-- 
Thanks,

Steve
