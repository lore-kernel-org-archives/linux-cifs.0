Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F2AC433E0
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Jan 2021 04:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60C6F22D04
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Jan 2021 04:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725792AbhAFEMf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Jan 2021 23:12:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbhAFEMf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Jan 2021 23:12:35 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04699C06134C;
        Tue,  5 Jan 2021 20:11:55 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id y19so3555700lfa.13;
        Tue, 05 Jan 2021 20:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BhqmsY59ya3fHfoXcrewe93ktRT6SVmBebPAVLSKui4=;
        b=PoCO6p8GHpU7vS2aZkjww+AV3ipfyrlCb1BpTiBImi4DU+rWrJq/Vk8KAi9c5FDXQh
         mFAJ7DraVTYj3lKzK2vDh7WDgy5NZuSaYjAwBZGaRE3LBZyKysFRlpueBSYFjuA8vw9M
         2sLUgZwEPuLFas6XDvNrUtGkBCE6oNzTWRPrzUWB+X+b8l/OszYXJLyV3h5T7QCGt99b
         PMQ0H6/QsFWGmZ+yxnqEP5vs3b6PpF1pNQlWWA08wUNrdp89ovM4JOiy3c7ncr1yXWAq
         IZDACcAm6fxwT6wKJc8jH+WGRQiAzm6re1QqAGv4kJellgo+1bCVqud60acWO7BPKOha
         9sAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BhqmsY59ya3fHfoXcrewe93ktRT6SVmBebPAVLSKui4=;
        b=WhrBJjvnhT65x97+0D9CxM/CzAKISZPTPLAJphHo4wnlm5lztAfI/k87hdeY/PT6AB
         Oko7Wyr7Vr/OGeXGUbaOgSkYCZ3ouC2RvqYRMOLlJJi9g6C6KunDh+P923jxqL3zWw/n
         bBzS0W7wPJvy4HAqgwqKORiJtDv3BiBMLIyaC7JXNExYtIShAK74gcVtJVkaU7QTk1vi
         YCG0Kt9+Izzk1nUUmk0Ffm+8dS5teCF+tppqfRvxAJN6l3LHBbBt0RuW/rD6FDTI/g9t
         iUWsXluvfGPbnwI4vJzWcV3ov+7Oz3XIYzXOILcrmEnlNi9cEgRw+pFPC2VAzoyxLRoV
         wW3w==
X-Gm-Message-State: AOAM532Of7CrFLVl/gyZWMjsIv9/tveG6bqqB9WyWtwvFHFhmExHFra+
        GxGoFI+875CsluvFu9xazxMd4GwcgkodGzhiRe8=
X-Google-Smtp-Source: ABdhPJxV6bCJB+k4Ckmm5h2MhpYAhKhpy3K0U3zTSrqtm6MtY5+nLgHRmkeU2eDzFYwDZNMEdhSOATXCK0WBcWpRpq8=
X-Received: by 2002:ac2:5547:: with SMTP id l7mr1064627lfk.313.1609906313402;
 Tue, 05 Jan 2021 20:11:53 -0800 (PST)
MIME-Version: 1.0
References: <20210105202126.2879650-1-trix@redhat.com> <20210105222559.GA4118247@ubuntu-m3-large-x86>
In-Reply-To: <20210105222559.GA4118247@ubuntu-m3-large-x86>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 5 Jan 2021 22:11:41 -0600
Message-ID: <CAH2r5mu-C3v-Tuz5E8nAFepSiCyypvw0g4ctTt2fjx1vEb9a_A@mail.gmail.com>
Subject: Re: [PATCH] cifs: check pointer before freeing
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     trix@redhat.com, Steve French <sfrench@samba.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Paulo Alcantara <palcantara@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next and added cc:stable

On Tue, Jan 5, 2021 at 5:08 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Tue, Jan 05, 2021 at 12:21:26PM -0800, trix@redhat.com wrote:
> > From: Tom Rix <trix@redhat.com>
> >
> > clang static analysis reports this problem
> >
> > dfs_cache.c:591:2: warning: Argument to kfree() is a constant address
> >   (18446744073709551614), which is not memory allocated by malloc()
> >         kfree(vi);
> >         ^~~~~~~~~
> >
> > In dfs_cache_del_vol() the volume info pointer 'vi' being freed
> > is the return of a call to find_vol().  The large constant address
> > is find_vol() returning an error.
> >
> > Add an error check to dfs_cache_del_vol() similar to the one done
> > in dfs_cache_update_vol().
> >
> > Fixes: 54be1f6c1c37 ("cifs: Add DFS cache routines")
> > Signed-off-by: Tom Rix <trix@redhat.com>
>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
>
> > ---
> >  fs/cifs/dfs_cache.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
> > index 6ad6ba5f6ebe..0fdb0de7ff86 100644
> > --- a/fs/cifs/dfs_cache.c
> > +++ b/fs/cifs/dfs_cache.c
> > @@ -1260,7 +1260,8 @@ void dfs_cache_del_vol(const char *fullpath)
> >       vi = find_vol(fullpath);
> >       spin_unlock(&vol_list_lock);
> >
> > -     kref_put(&vi->refcnt, vol_release);
> > +     if (!IS_ERR(vi))
> > +             kref_put(&vi->refcnt, vol_release);
> >  }
> >
> >  /**
> > --
> > 2.27.0
> >



-- 
Thanks,

Steve
