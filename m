Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58ED5C6FD1D
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Mar 2023 18:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjCUSzG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Mar 2023 14:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjCUSzF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 21 Mar 2023 14:55:05 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4152D34313
        for <linux-cifs@vger.kernel.org>; Tue, 21 Mar 2023 11:55:03 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id i5so16739515eda.0
        for <linux-cifs@vger.kernel.org>; Tue, 21 Mar 2023 11:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1679424901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o0ckUw7dWkverm2igg++8Ynt0yEw3mz/3PbETIyN2lM=;
        b=Q0quwuuIg8g7Pc5qITuwgjE4CLdtaBEAux/4FE/oyGlvumxSV5yoOMRg3zn8UARZYI
         xqIS+WT+wGlSrUzp/vI6QAMTdZugPBIFWdo0Gyw5KvwrdUchfMnTXgqYjsulJTjji1ES
         5815awTKv+KrYE1wFFgcb14EQcUQ/lQe4LrI8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679424901;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o0ckUw7dWkverm2igg++8Ynt0yEw3mz/3PbETIyN2lM=;
        b=WHbC6FCsIqG8+TY+lBd7hIzyh6p2svfc3u+qiwq/AewuGnchI5upM8i04FXHAtXpkz
         0Q3EBTt4uOoGawV7ULf/L/eyUpjLkGN0pWk0x74RAIiQndGERkxNe4VoxCeHoNYYZ0Ng
         RDwH+fINwiQ8LE3JccVMN2neBnoMKcy/TY+8aqJWsyJVe1eVWDZBBuqVJauOtpGbrPzx
         pD86MCGI2XNRgHOUhS1JP0xqXINJsrLRfYzDuepYyZyqKp4ZbXr4y1zXNKP4tVAYzQRJ
         N4wyoGSMrxRXDzPF4VG+nvwwv7At/0UUvB+ttqPL9rJPW8gC69pVkgr0u0WHAfq0GRAU
         g2ig==
X-Gm-Message-State: AO0yUKWeGMaP6KBX2OvTjbMUA/YeNM1kBztdoKi+MNcZJzDeHMFct/HL
        fxIdXqt0iuSpL4OHxEuHdPObaQGpTf1QbU4FK6tgL7Es
X-Google-Smtp-Source: AK7set9kS54nnccn77yDIvnDWAOXok5sfqTr1rXPt/KmpLdLNagUAxJqrvywZKZLUjltVlZt+KUm2g==
X-Received: by 2002:a17:906:ae0f:b0:8b1:77bf:3bdd with SMTP id le15-20020a170906ae0f00b008b177bf3bddmr3691857ejb.36.1679424901569;
        Tue, 21 Mar 2023 11:55:01 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id i13-20020a170906114d00b008e0bb004976sm6127157eja.134.2023.03.21.11.55.01
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 11:55:01 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id cy23so63533028edb.12
        for <linux-cifs@vger.kernel.org>; Tue, 21 Mar 2023 11:55:01 -0700 (PDT)
X-Received: by 2002:a17:907:9b03:b0:932:da0d:9375 with SMTP id
 kn3-20020a1709079b0300b00932da0d9375mr2409395ejc.4.1679424514115; Tue, 21 Mar
 2023 11:48:34 -0700 (PDT)
MIME-Version: 1.0
References: <2851036.1679417029@warthog.procyon.org.uk>
In-Reply-To: <2851036.1679417029@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 21 Mar 2023 11:48:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh1b0r+5SnwWedx=J4aZhRif1HLN_moxEG9Jzy23S6QUA@mail.gmail.com>
Message-ID: <CAHk-=wh1b0r+5SnwWedx=J4aZhRif1HLN_moxEG9Jzy23S6QUA@mail.gmail.com>
Subject: Re: [GIT PULL] keys: Miscellaneous fixes/changes
To:     David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Bharath SM <bharathsm@microsoft.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Robbie Harwood <rharwood@redhat.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        keyrings@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-crypto@vger.kernel.org, kexec@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Mar 21, 2023 at 9:43=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
>  (1) Fix request_key() so that it doesn't cache a looked up key on the
>      current thread if that thread is a kernel thread.  The cache is
>      cleared during notify_resume - but that doesn't happen in kernel
>      threads.  This is causing cifs DNS keys to be un-invalidateable.

I've pulled this, but I'd like people to look a bit more at this.

The issue with TIF_NOTIFY_RESUME is that it is only done on return to
user space.

And these days, PF_KTHREAD isn't the only case that never returns to
user space. PF_IO_WORKER has the exact same behaviour.

Now, to counteract this, as of this merge window (and marked for
stable) IO threads do a fake "return to user mode" handling in
io_run_task_work(), and so I think we're all good, but I'd like people
to at least think about this.

              Linus
