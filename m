Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A03FC46467
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Jan 2023 16:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238480AbjAKQYy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Jan 2023 11:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238633AbjAKQYV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Jan 2023 11:24:21 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B58E81D0D3
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jan 2023 08:21:22 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id f20so16523573lja.4
        for <linux-cifs@vger.kernel.org>; Wed, 11 Jan 2023 08:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=se6o/wamCUk1XZu9amcrO9324e6O3pn9p1xL06lLNG0=;
        b=HRlYbEfq8GsoFpxgb2k96gLqbw84qQbDu/tL7zQtp3UYdfdKe5TE0Oe4cOyTUYMaZk
         G1osGVAM3QzMcZYeATLsceILF1RqfShH2V5Wp3gsLqHFbpewLsjiFv6F6TvXJmuTRYZi
         +9G4t9saP//aVIrA3Ml3CteNxHIzCRsHQGDb/+DohbR9v1UOTDU0Hyxs6cCdazQRPUGM
         CjBjFHQgh4kF8ue/mqOVG0CP4kgvEzJ1WNJupDGFciGwQ3Oj4pz9Qi2GIxtXoYLmkM/B
         O48aCUKN8ERg86xaDydF2RyDzjb9KWIZgeXpc2Jsu7Rsx/OCZGrAVaL9fNvENneVJwJG
         A7Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=se6o/wamCUk1XZu9amcrO9324e6O3pn9p1xL06lLNG0=;
        b=ZVgQq7Y0s9ZuwXs31ubYH+tpzTJ2oBIsBeioVY0T78K5eu1zHXAL+gfwOJTIxUOKQ1
         MbCXKBnVgHX9rYHVMJEAhyTO+NXyifoDd/4huF1Yb1qoylAxzK4CR+iZOfvc9Qhmqddw
         EXEdh3cyhP9LHkmvUUjXqdMBossHHDHyJ82gkGwG07gXPNM8pPwWGQ+yYFzHcgbdawga
         mgnhxsgiKRO+/Y/num6jiYOvrqmXHRTNgYASmfmsT0Uk5nf7N1Swunv++cQWza3yL7Ne
         N23tfDGa1KivigHxgWczcRqShRlZUMT2rc2AMGZ6tdye41m2t3vF0sCw/VNPq2A+qml7
         B7ZA==
X-Gm-Message-State: AFqh2kpK3mbApHBxKKeanmRVFsfKIolpI8XDMvCrZinclOt1R/+ZMEt6
        yWRxRMa1xXt3hBO4HXre/TuZbW6w0EkDaCKxqEMWoiTJCWU=
X-Google-Smtp-Source: AMrXdXtXZiLCaibh15SqIF2bDItS54993yrkatU9TfQHqFGRKnfdJ+DZp2i8pHwMMBWWhiD3fysnX3WGq1rnZs1k/xQ=
X-Received: by 2002:a05:651c:1953:b0:27f:963c:1324 with SMTP id
 bs19-20020a05651c195300b0027f963c1324mr5974391ljb.194.1673454078829; Wed, 11
 Jan 2023 08:21:18 -0800 (PST)
MIME-Version: 1.0
References: <Y76gvH9ADxSgAxSw@sernet.de>
In-Reply-To: <Y76gvH9ADxSgAxSw@sernet.de>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 11 Jan 2023 10:21:07 -0600
Message-ID: <CAH2r5muTjUB7LBevcKE6oxWHPrm6yxY7H5jRuECMLbebQyRXpg@mail.gmail.com>
Subject: Re: Fix posix 311 symlink creation mode
To:     Volker.Lendecke@sernet.de
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Should this be 0777 instead of 0644?

I noticed the man page for symlink says:

     "On Linux, the permissions of an ordinary symbolic link are not
       used in any operations; the permissions are always 0777 (read,
       write, and execute for all user categories), and can't be
       changed."

On Wed, Jan 11, 2023 at 6:14 AM Volker Lendecke
<Volker.Lendecke@sernet.de> wrote:
>
> Hi!
>
> Attached find a patch that fixes an uninitialized memory read when
> creating symlinks using the smb311 posix extensions.
>
> Volker



-- 
Thanks,

Steve
