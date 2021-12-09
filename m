Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A6F9C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Dec 2021 17:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243109AbhLIRjg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Dec 2021 12:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237485AbhLIRjf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Dec 2021 12:39:35 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DAFC061746
        for <linux-cifs@vger.kernel.org>; Thu,  9 Dec 2021 09:36:01 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id y12so21384055eda.12
        for <linux-cifs@vger.kernel.org>; Thu, 09 Dec 2021 09:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Ief/4lrcrFC9yHQblzF1a8RET0HNi3QQm3divo4aI0=;
        b=AdnCyXT6TPlVVq0JLA/VEVV0O33H285eATNlyLPRaIFmtxnqr6S23nXl2J32guXc1O
         plkuA6YLaLfLkkkWTPqQOSOG7bZY0JEwSmKNFIrfpMXr3oq7FfmHctvECgg0O0gJcn+c
         hrPmI2kNvz5VH+5qzZSG7wTmayKDH0Ub3btDA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Ief/4lrcrFC9yHQblzF1a8RET0HNi3QQm3divo4aI0=;
        b=8PlojLvv5fZWiWii1rlusWfPr8K22rUx/MtXfsaqAXuBfobHK5oXgEBZ7LwrqH0IjU
         B9zo5eJhhkITcr7yL06gGViHmF1dM5jpbmJoRidTG5WfFCdr7ndvMSWMxMSHF4rMicnd
         LE0qMLd9PQNYBwYNTaPTWbB3GvVjg1m90QjVmOnsyoA+39a+SM3SKnRxrtBMuXGL/10i
         EEFs0288sHRam+biXo5Wbgk5s2E0Gjs1DFmFN+UCbz1lkvoboNJZruZt4x91CW50cv/k
         u5w0jD1iYcScwjEpra3RVY+4swwpTpcj/B9JTj/iTj+M0Es+7JSTanT2mKYw+e9q+MQs
         7nhA==
X-Gm-Message-State: AOAM530AP0j5tF9L7ppqKhVYRdgNjvND5XU+Gjd/2njtsXAVhQ+uwl5m
        UfHjQw7dE1potS2588cw88pVzt5gVPjTQpzt
X-Google-Smtp-Source: ABdhPJxltrxTqjUHyvCVLIWcJmxE6OYOzIH9Lj83U3KrG+mFKcXOA8U6DFKdtJaTecyb/+OP2z731Q==
X-Received: by 2002:a17:907:6d99:: with SMTP id sb25mr18242000ejc.261.1639071173672;
        Thu, 09 Dec 2021 09:32:53 -0800 (PST)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id sb19sm224456ejc.120.2021.12.09.09.32.51
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 09:32:52 -0800 (PST)
Received: by mail-wr1-f54.google.com with SMTP id u17so11002841wrt.3
        for <linux-cifs@vger.kernel.org>; Thu, 09 Dec 2021 09:32:51 -0800 (PST)
X-Received: by 2002:a05:6000:1c2:: with SMTP id t2mr7703596wrx.378.1639071170949;
 Thu, 09 Dec 2021 09:32:50 -0800 (PST)
MIME-Version: 1.0
References: <163906878733.143852.5604115678965006622.stgit@warthog.procyon.org.uk>
 <163906890630.143852.13972180614535611154.stgit@warthog.procyon.org.uk>
In-Reply-To: <163906890630.143852.13972180614535611154.stgit@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 9 Dec 2021 09:32:34 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg35xyf-HgOLcKdWVxm11vNomLVe44b1FsxvV6jDqw2CA@mail.gmail.com>
Message-ID: <CAHk-=wg35xyf-HgOLcKdWVxm11vNomLVe44b1FsxvV6jDqw2CA@mail.gmail.com>
Subject: Re: [PATCH v2 09/67] fscache: Implement volume registration
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

On Thu, Dec 9, 2021 at 8:55 AM David Howells <dhowells@redhat.com> wrote:
>
> +static long fscache_compare_volume(const struct fscache_volume *a,
> +                                  const struct fscache_volume *b)
> +{
> +       size_t klen;
> +
> +       if (a->key_hash != b->key_hash)
> +               return (long)a->key_hash - (long)b->key_hash;
> +       if (a->cache != b->cache)
> +               return (long)a->cache    - (long)b->cache;
> +       if (a->key[0] != b->key[0])
> +               return (long)a->key[0]   - (long)b->key[0];
> +
> +       klen = round_up(a->key[0] + 1, sizeof(unsigned int));
> +       return memcmp(a->key, b->key, klen);

None of this is endianness-independent except for the final memcmp()
(and that one assumes the data is just a "stream of bytes")

In fact, even if everybody is little-endian, the above gives different
results on 32-bit and 64-bit architectures, since you're doing math in
(possibly) 64 bits but using a 32-bit "key_hash". So sign bits will
differ, afaik.

And once again, that key_hash isn't actually endianness-independent anyway:

> +       volume->key_hash = fscache_hash(0, (unsigned int *)key,
> +                                       hlen / sizeof(unsigned int));

Yeah, for the same key data, this will give entirely different results
on LE vs BE, unless you've made sure to always convert whatever keys
from soem on-disk fixed-32-bit-endianness format to a in-memory host
endianness.

Which is a fundamental design mistake in itself. That kind of "one
endianness on disk, another in memory" is garbage.

I'm not sure any of these matter - maybe all these hashes are entirely
for in-memory stuff and never haev any longer lifetimes, so the fact
that they get calculated and compared differently depending on
endianness and depending on word size may not matter at all. You may
only care about "stable on the native architecture".

But then you shouldn't have your own hash function that you claim is
somehow endianness-safe.

If you really want to be endianness safe, *ALL* the data you work on
needs to be a proper fixed endianness format. All throught the code.
Make all key pointers always be "__le32 *", and never randomly cast
the pointer from some other data like I see in every use I actually
looked at.

                  Linus
