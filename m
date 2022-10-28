Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C639ECAAA1
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Oct 2022 20:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiJ1UeZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Oct 2022 16:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiJ1UeY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Oct 2022 16:34:24 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D5C22C443
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 13:34:23 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id 8so4231366qka.1
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 13:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5JcJ09bBdlBVf21xZKuOSzNCt5BJDxCAWw6Qi6m3gKQ=;
        b=hU743kZXYxAVHQ1EsSBvl3ayRYEjnGCLfaHZ8Jv5OOMADfUvRRqwIase4PKYUcaJ3E
         INbfDZi9n0Q5pnuXHtRhyGvyX40BjYI+eGMAw+5rMraVeCJayNAIOiRRhBR82dlGAo05
         /mVa5vBjROjk9lw+ojylUbMmMrQmNGOeXMwBU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5JcJ09bBdlBVf21xZKuOSzNCt5BJDxCAWw6Qi6m3gKQ=;
        b=DMoTElii7JUSXtX8k3bSYm5m3oCdBNHPDtnc7gxzMU1Gj4KIH46zfhZj92kuCbIKhz
         AVTkUWlLUEgrIRBWTjW0BiqIQ+hBgNx33gv/ah12qUuG7Fh4K3pKtjvUU3IjPG+nWhFB
         xHs7UwqTMHUZmTzACVGFAQhED5LA9BAUSrkeytbMvLudMDx1JZurDmbFW9a+UYWs+V7B
         luCBJKZXBqzWdXkvVHHrJU38OVH2xU8oFKto6YMNASKLf8BGquq+uxAVYCCTijV20BG8
         VonK56AksE3kX8ATI392VyAOPD0DtzRzbINWm+XoXH4PWXhfOULHRtsV+4FUh5bo6iev
         WS0g==
X-Gm-Message-State: ACrzQf0K3kPhlUNFqzZmna5S0QTCQwPivikd1DDvMhapuBcbQby8cCft
        OBOKuXBZ9CG5huHYER/12hpg6ld5AEi26Q==
X-Google-Smtp-Source: AMsMyM5XhHUOm8MLCo41cVe6SYdd0Lz3+uub6R3q7nXrRmzEkX9y/7AeaKtuXXbV8oLBoEc3DN4qoQ==
X-Received: by 2002:a37:a48:0:b0:6fa:46e:d075 with SMTP id 69-20020a370a48000000b006fa046ed075mr877207qkk.45.1666989262665;
        Fri, 28 Oct 2022 13:34:22 -0700 (PDT)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id bb11-20020a05622a1b0b00b0035d08c1da35sm2863472qtb.45.2022.10.28.13.34.21
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 13:34:21 -0700 (PDT)
Received: by mail-yb1-f170.google.com with SMTP id f205so7436307yba.2
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 13:34:21 -0700 (PDT)
X-Received: by 2002:a5b:984:0:b0:6ca:9345:b2ee with SMTP id
 c4-20020a5b0984000000b006ca9345b2eemr931629ybq.362.1666989261347; Fri, 28 Oct
 2022 13:34:21 -0700 (PDT)
MIME-Version: 1.0
References: <Y1btOP0tyPtcYajo@ZenIV> <20221028023352.3532080-1-viro@zeniv.linux.org.uk>
 <20221028023352.3532080-12-viro@zeniv.linux.org.uk> <CAHk-=wibPKfv7mpReMj5PjKBQi4OsAQ8uwW_7=6VCVnaM-p_Dw@mail.gmail.com>
 <Y1wOR7YmqK8iBYa8@ZenIV> <CAHk-=wi_iDAugqFZxTiscsRCNbtARMFiugWtBKO=NqgM-vCVAQ@mail.gmail.com>
 <Y1wt7uzL7vkBQ6Vm@ZenIV>
In-Reply-To: <Y1wt7uzL7vkBQ6Vm@ZenIV>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 28 Oct 2022 13:34:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj4ndvhOFFsnNXRmwetwL9ZxE2QzcrLFTeJ7Yfh+pJ7Mw@mail.gmail.com>
Message-ID: <CAHk-=wj4ndvhOFFsnNXRmwetwL9ZxE2QzcrLFTeJ7Yfh+pJ7Mw@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] use less confusing names for iov_iter direction initializers
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Christoph Hellwig <hch@infradead.org>,
        David Howells <dhowells@redhat.com>, willy@infradead.org,
        dchinner@redhat.com, Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ira Weiny <ira.weiny@intel.com>, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Oct 28, 2022 at 12:30 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Went through the callers, replaced each with the right ITER_... (there's
> not that many of them and they are fairly easy to review), then went
> through mismatches and split their fixups into the beginning of the
> series (READ -> ITER_SOURCE becoming READ -> WRITE -> ITER_SOURCE, that
> is).

Oh, ok. So if you've actually reviewed each and every one of them,
then I'm ok with the "abort".

I still want it to be a WARN_ON_ONCE(), because of any future addition
that gets things wrong.

Rationale: either the WARN_ON() can happen, or it cannot. If it
cannot, it shouldn't exist in the first place. If it can, warning
multiple times will just make things harder to read and possibly cause
endless streams of scrolling errors.

So either the WARN_ON() shouldn't exist, or it should be a WARN_ON_ONCE().

Generally the only valid use of WARN_ON() (and BUG_ON()) is for things
like errors in the boot/setup code, where the operation basically is
only done once anyway.

                 Linus
