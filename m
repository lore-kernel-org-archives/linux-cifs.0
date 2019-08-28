Return-Path: <SRS0=V1Ry=WY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 496ECC3A5A3
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 01:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15EC12186A
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 01:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566954004;
	bh=MzOAND7RsfQATN1Qm/iqbqlGTnT0tZ64ZunkXTLII/Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ohcC3JLRVTEpeV7yYTf/4TtFCJhu+NkQI88XK1LPhuGjvEbI8GzFoumZlkFCaZSMQ
	 6AsNNmbhgwWLT6KVE2kgHXidbmB0l3rAAYesWwkJn70JJcQzzmM+N4hKKE2xV6i0gj
	 ocnM98Y+DUeSJ2yfjfc4+x2dTo6QSrxo92g84B6A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfH1BAD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Aug 2019 21:00:03 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34596 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfH1BAD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Aug 2019 21:00:03 -0400
Received: by mail-lf1-f65.google.com with SMTP id z21so598662lfe.1
        for <linux-cifs@vger.kernel.org>; Tue, 27 Aug 2019 18:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ez19Bi9YwMuRt11LXnbvdNfMraqnRCr3P/qfxB7W2ZM=;
        b=La3KweEJVxXpIzsfhB1pd6d8rFD6lfK8dOaTGK0dmHUCh8ZMHpx+w1NT35dIXH9g96
         2IPCgq5w57QdqTVZ+XY7Lis00OlRjrjHBfmfhu6comj9292BzFIe5zQMwblQryGB1OzF
         abNaAdrqPj+cSSgSBDuhrbcKX64/ptneE4LZo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ez19Bi9YwMuRt11LXnbvdNfMraqnRCr3P/qfxB7W2ZM=;
        b=UOQFDZU6+JVQA7uc2c50j0vk7oX4SJhedmCyG1L+kZcRqaaJzy6u0DhExVI+wsM6zw
         AT2gwteaAt+Pp6NM4v7ll5hKTk5pXPVPsuxSxTFULlcgARBYzUZmYzXnygzUAVhGaBs6
         mIKZ5mSzrlVOMbWvKG2rBaxD7BOlJT2pMP+aLDLtUR66jgFMtw4mPoTlbYlr/vc2GI5k
         9wqnmnncBGLrzK11QkNXhxr4Vh4ECeT7yLNRE7ov/6HzeW8O7i5CP0UbQAYFh9o2nUcb
         k7AoQNBbhDEYzMC7zRwir4TU74kRdmj0CcL/yu1bA4o1CGSzEu+3/fnwaz/86ruWNLlK
         jWWw==
X-Gm-Message-State: APjAAAWmY2fT6nwlLQ3ply18Xv+UZuA+8Gtm0ldx2TX3CoBjSt1+EL6z
        FcsTQ55kAiX2awvWzFJD9K2DDZYkBx4=
X-Google-Smtp-Source: APXvYqyS2p42CPvjlhncYgYwDTpoXiMjTebXJPqYI7TqHzu3A+lORdMp9f7E9xWYexrxlHJpznN6+A==
X-Received: by 2002:ac2:4c2f:: with SMTP id u15mr738846lfq.174.1566954000711;
        Tue, 27 Aug 2019 18:00:00 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id s21sm230392ljg.95.2019.08.27.17.59.59
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Aug 2019 17:59:59 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id u13so565190lfm.9
        for <linux-cifs@vger.kernel.org>; Tue, 27 Aug 2019 17:59:59 -0700 (PDT)
X-Received: by 2002:ac2:4c9b:: with SMTP id d27mr740120lfl.29.1566953999331;
 Tue, 27 Aug 2019 17:59:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190826233014.11539-1-lsahlber@redhat.com> <CAH2r5mvQ7YzkUjNJxC8sNCsbr-NXM9KC0tXYr2PgZ_zCR0Qu_A@mail.gmail.com>
In-Reply-To: <CAH2r5mvQ7YzkUjNJxC8sNCsbr-NXM9KC0tXYr2PgZ_zCR0Qu_A@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 27 Aug 2019 17:59:43 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj=exJrhFY5vwvrhmYR-zEnoxTkS+SPV2-kc1Kp-iD-OQ@mail.gmail.com>
Message-ID: <CAHk-=wj=exJrhFY5vwvrhmYR-zEnoxTkS+SPV2-kc1Kp-iD-OQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: replace various strncpy with memcpy and similar
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Aug 27, 2019 at 3:34 PM Steve French <smfrench@gmail.com> wrote:
>
> -       } else {                /* BB improve check for buffer overruns BB */
> -               name_len = strnlen(name, PATH_MAX);
> -               name_len++;     /* trailing null */
> -               strncpy(pSMB->fileName, name, name_len);
> +       } else {
> +               name_len = copy_path_name(pSMB->fileName, name);

Hmm. If you kept the PATH_MAX value as an argument, you could then ...

> -               strncpy(bcc_ptr, ses->user_name, CIFS_MAX_USERNAME_LEN);
> -               bcc_ptr += strnlen(ses->user_name, CIFS_MAX_USERNAME_LEN);
> +               len = strscpy(bcc_ptr, ses->user_name, CIFS_MAX_USERNAME_LEN);
> +               if (WARN_ON_ONCE(len < 0))
> +                       len = CIFS_MAX_USERNAME_LEN - 1;
> +               bcc_ptr += len;

... have used that function here too, instead of open-coding it just
because the max length is now CIFS_MAX_USERNAME_LEN.

Although I guess that case is slightly different because it only adds
"len", not including the final NUL in the count.

So who knows. The patch looks like a clear improvement, although I
think the smb1 code could have used a helper that did the UTF16 cases
too, because now all _that_ code is still duplicated and I'm not
convinced that gets the final NUL any more right..

              Linus
