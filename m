Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 325AEC433FE
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Dec 2021 22:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbhLIWT2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Dec 2021 17:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233422AbhLIWT2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Dec 2021 17:19:28 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC3FC061746
        for <linux-cifs@vger.kernel.org>; Thu,  9 Dec 2021 14:15:53 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id v1so24490885edx.2
        for <linux-cifs@vger.kernel.org>; Thu, 09 Dec 2021 14:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RHArNxFMHgs9P3JmMQUjRcZVsX1YeVD3wW/DAeZt5nA=;
        b=JhUfOUJjxhGRzHwksR/Q8zG3IINBIKaphSkRwJzWYADLahSsN6d7219QvbpoEd8Y7k
         Ufk/H24zbV7UnfRzWnZtmEkNZrNUh/75SD5YVhHcTNkE8nvjcjbuV/8uU1FIxASJeztH
         4gA4ykWichWHKmWefAIY/la0fzYo0je1n6xY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RHArNxFMHgs9P3JmMQUjRcZVsX1YeVD3wW/DAeZt5nA=;
        b=1x9Rko03hHFLxJSRWyAT9wu4+gOXe4408goNOGXXih/3+mjpovFHE2Jr6kVu1QZKiX
         fKXZ6WxHIoorxILvPqcGMyBi0TAftSqCa5CZWZci3i/wI4P2vTfIWpguORaDaLK1pweT
         bI5acvlsuU+WGs89O67C4O61i/Gwu6vJUkbhu1E+9kAKNEYCWqPLww3Xo+5SNwXtXOY6
         cNjIr8HEYX47qCwugQIqvz7iTQDtvduSUdhrh6UAgZi2cBj9OfMGUtUxuyUwSaxEiMS7
         +BkFb85oI34vr8S/sHUTRtZH9AbUVrTbCaAqXxS2P0DdqG3FRCMETAG5ArHjLkLM6BeZ
         p/WQ==
X-Gm-Message-State: AOAM530BnlmsWYHXvGUNazUveQb0FOYVHekyaFqTfw/6HYI61Vvjmwin
        AWp3sFhPhtCFsv0sBdaPM5rl7iDiuM03ldnjTzc=
X-Google-Smtp-Source: ABdhPJyNItY4B93/qzqSH9HjB6T16bn6eJosMfG8Pc6Rd6b8JHYl9TquDxwVWi6FbpI+6KVys387fA==
X-Received: by 2002:a50:ef02:: with SMTP id m2mr32400084eds.172.1639088152360;
        Thu, 09 Dec 2021 14:15:52 -0800 (PST)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id hq9sm506520ejc.119.2021.12.09.14.15.52
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 14:15:52 -0800 (PST)
Received: by mail-wr1-f52.google.com with SMTP id u1so12038780wru.13
        for <linux-cifs@vger.kernel.org>; Thu, 09 Dec 2021 14:15:52 -0800 (PST)
X-Received: by 2002:adf:f8c3:: with SMTP id f3mr9535285wrq.495.1639087669394;
 Thu, 09 Dec 2021 14:07:49 -0800 (PST)
MIME-Version: 1.0
References: <163906878733.143852.5604115678965006622.stgit@warthog.procyon.org.uk>
 <163906888735.143852.10944614318596881429.stgit@warthog.procyon.org.uk>
 <CAHk-=wiTquFUu-b5ME=rbGEF8r2Vh1TXGfaZZuXyOutVrgRzfw@mail.gmail.com> <159180.1639087053@warthog.procyon.org.uk>
In-Reply-To: <159180.1639087053@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 9 Dec 2021 14:07:33 -0800
X-Gmail-Original-Message-ID: <CAHk-=whtkzB446+hX0zdLsdcUJsJ=8_-0S1mE_R+YurThfUbLA@mail.gmail.com>
Message-ID: <CAHk-=whtkzB446+hX0zdLsdcUJsJ=8_-0S1mE_R+YurThfUbLA@mail.gmail.com>
Subject: Re: [PATCH v2 07/67] fscache: Implement a hash function
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs@redhat.com,
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jeff Layton <jlayton@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Omar Sandoval <osandov@osandov.com>,
        JeffleXu <jefflexu@linux.alibaba.com>,
        linux-afs@lists.infradead.org,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Dec 9, 2021 at 1:57 PM David Howells <dhowells@redhat.com> wrote:
>
> What I'm trying to get at is that the hash needs to be consistent, no matter
> the endianness of the cpu, for any particular input blob.

Yeah, if that's the case, then you should probably make that "unsigned
int *data" argument probably just be "void *" and then:

>                 a = *data++;   <<<<<<<
>                 HASH_MIX(x, y, a);
>         }
>         return fold_hash(x, y);
> }
>
> The marked line should probably use something like le/be32_to_cpu().

Yes, it should be using a '__le32 *' inside that function and you
should use l32_to_cpu(). Obviously, BE would work too, but cause
unnecessary work on common hardware.

But as mentioned for the other patches, you should then also be a lot
more careful about always using the end result as an 'unsigned int'
(or maybe 'u32') too, and when comparing hashes for binary search or
other, you should always do th4e compare in some stable format.

Because doing

        return (long)hash_a - (long)hash_b;

and looking at the sign doesn't actually result in a stable ordering
on 32-bit architectures. You don't get a transitive ordering (ie a < b
and b < c doesn't imply a < c).

And presumably if the hashes are meaningful across machines, then hash
comparisons should also be meaningful across machines.

So when comparing hashes, you need to compare them either in a truly
bigger signed type (and make sure that doesn't get truncated) - kind
of like how a lot of 'memcmp()' functions do 'unsigned char'
subtractions in an 'int' - or you need to compare them _as_ 'unsigned
int'.

Otherwise the comparisons will be all kinds of messed up.

          Linus
