Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15842C4320A
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 02:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9B6260FE6
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Aug 2021 02:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235263AbhHRCrZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Aug 2021 22:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbhHRCrZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 Aug 2021 22:47:25 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E252EC061764;
        Tue, 17 Aug 2021 19:46:50 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id d16so2284621ljq.4;
        Tue, 17 Aug 2021 19:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RWmXHWwVFrhlQDHC2rVDGYKlpIeA9JdQ6DniyzAK9as=;
        b=qh1RLH0Gd1nVywJwS084M5nIdCuU3fLrE9me78hJx6YJWUywAhES+Rv22p+/SPc1fL
         9o4aeQ5FiuDpY9zA9fe7S7dVA4fZUyI0E4Ck5FCqY8OVxp4fGUDqm72VfRFfCvL7da0s
         4gfx8Sp6sXTCSvkI+kKDtqnennbd/VEodL+hFPm8gJTXqV7kaQYtgFavrFzglcF1/0lP
         6wjk56Z64KV378ezVD85SjvFX3TL1C1oxgjDzi6C/yhxLPewDD/qTijgJGHcgkvlRVOg
         J8Aqjwzc0qVGN8vltM4wiET4xJtYKs6RgUEE+GaZ8Dgkuw0j2UafSoX7quwlrC18yH/I
         qF4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RWmXHWwVFrhlQDHC2rVDGYKlpIeA9JdQ6DniyzAK9as=;
        b=ofk6dNko7gOv6EH1BcsFR7e5KlqhA7zX/gQlmirei1sa+PNZAKlwb6ToBc7Aqrbjac
         8DeFEdPaaAQ8KMuThXF7Qgj5Ndt9+RGTuAjby3b32JCQ6UBgo9uIEvNPzHbJ32eomJO9
         ijZ/MwHhxSaJzKsWOJrF6Z5BaZ/TZq2qTtFXMVwIL8mAMKIs0fDoR4rO8x7SSOFjrKEL
         Qof9obgB0SXVaIJe6ngQQcyiDm1kUdyYFbV+9A1xHup5zk5dHsnnab1U5/s3k6INvQF6
         uyHvQwW5tKEbW7eTYj8bfTQyorKze6ABRVZojkOKkq6y6zdwc8U23SuIvSN+WgnkI3d4
         tV/A==
X-Gm-Message-State: AOAM531S6D1+zdBeNjTkXwmmkPX8uNmG2OtAuZoyAdgNVzQ/Kq4nr3cK
        isNM7/XQ7AtJHqWAPoQ9vSRUBfIxF4dCNRkkvGI=
X-Google-Smtp-Source: ABdhPJwslGU/+xPwEkW6sdIpppodrm2AblhgBsp9WtZcWZkLIovt/JPSv6Jr/pVskQeBDBGbAgTovI27ptCXrwwcQdc=
X-Received: by 2002:a2e:a884:: with SMTP id m4mr5841362ljq.406.1629254809157;
 Tue, 17 Aug 2021 19:46:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210817102709.15046-1-len.baker@gmx.com> <87im03h9zb.fsf@cjr.nz>
In-Reply-To: <87im03h9zb.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 17 Aug 2021 21:46:38 -0500
Message-ID: <CAH2r5mtKsjPesR6yBTO8RB=BFYc5Cb23OA_gEQyWMNrORXdavg@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Fix a potencially linear read overflow
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Len Baker <len.baker@gmx.com>, Steve French <sfrench@samba.org>,
        Jeff Layton <jlayton@kernel.org>,
        Suresh Jayaraman <sjayaraman@suse.de>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending testing

On Tue, Aug 17, 2021 at 7:29 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Len Baker <len.baker@gmx.com> writes:
>
> > strlcpy() reads the entire source buffer first. This read may exceed the
> > destination size limit. This is both inefficient and can lead to linear
> > read overflows if a source string is not NUL-terminated.
> >
> > Also, the strnlen() call does not avoid the read overflow in the strlcpy
> > function when a not NUL-terminated string is passed.
> >
> > So, replace this block by a call to kstrndup() that avoids this type of
> > overflow and does the same.
> >
> > Fixes: 066ce6899484d ("cifs: rename cifs_strlcpy_to_host and make it use new functions")
> > Signed-off-by: Len Baker <len.baker@gmx.com>
> > ---
> >  fs/cifs/cifs_unicode.c | 9 ++-------
> >  1 file changed, 2 insertions(+), 7 deletions(-)
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>



-- 
Thanks,

Steve
