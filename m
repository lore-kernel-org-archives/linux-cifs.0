Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F2CEC433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Dec 2021 17:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242922AbhLIR2g (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Dec 2021 12:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242918AbhLIR2f (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Dec 2021 12:28:35 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEC7C0617A1
        for <linux-cifs@vger.kernel.org>; Thu,  9 Dec 2021 09:25:01 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id e3so22136096edu.4
        for <linux-cifs@vger.kernel.org>; Thu, 09 Dec 2021 09:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iqExJZ9/DphBTKULUzi0rda5Ww/lFJEMJ0HrtECPjTI=;
        b=CEZX4drLnp80p9b9oVxK0f0qT2WA3YF+B1Tl8CQVWg2uGKK6+gQz0h/GPS2FyiNNJ9
         gAKRuC48E81Hb/mGX0sY3phjIF/WMv16b9bipyIo+rIOFDAbKwrmyJ7HqNkTia2gkVbu
         /I1NAgDWldKvVVC+e1z0jNAfGMMlQioj2HEiU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iqExJZ9/DphBTKULUzi0rda5Ww/lFJEMJ0HrtECPjTI=;
        b=YDnCYPhGh4xmn7fO0C2lJSDP9WhSFnwQf9Lb/tWx7SX6yfuYQ03YwxMKhpa/nKCSQ0
         BJf2BhYw+LgegNt94fiXpc9le8ja4YQO0JPotXSDEuseOeCE+l9Ftz/aO+F1LrYRgtm3
         X17mdX9y3aTOfyxDQyddUlYK1knbHhM+eeSU9kaQE8xmvS0qtczbVYDuW/3a5t/FLDLJ
         +cggVx22VZSWy8V3jGt41fa47cAjuAmmj0+J4OImmv4PaJ7uvZSEw4nZacN6iyrZS7pn
         YqAiR73IS7pNUy50+62yr5NfhOmlIlOj1FuJjMDeiFJC5GJffux1FXab06HWSBntKzHS
         NFjw==
X-Gm-Message-State: AOAM532f5Wdyg1j5Tmu3ySojprVtdxc7v5q6R4BjuN8x1wAdjcCCcxBS
        1t7As/WoOW3PAS4uKi6GbzpZ/fXmQ5vM5R+/
X-Google-Smtp-Source: ABdhPJwt7Lwzc+Gtz6rKkl9VXcwWw+B/n8aDRGu1DMlujdiUNjm2YqcJf6Da93u486p6QCL01i9ncg==
X-Received: by 2002:a05:6402:3481:: with SMTP id v1mr31605789edc.337.1639070536694;
        Thu, 09 Dec 2021 09:22:16 -0800 (PST)
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com. [209.85.128.43])
        by smtp.gmail.com with ESMTPSA id bm22sm191270edb.48.2021.12.09.09.22.14
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 09:22:15 -0800 (PST)
Received: by mail-wm1-f43.google.com with SMTP id o29so4816141wms.2
        for <linux-cifs@vger.kernel.org>; Thu, 09 Dec 2021 09:22:14 -0800 (PST)
X-Received: by 2002:a05:600c:22ce:: with SMTP id 14mr8659906wmg.152.1639070533785;
 Thu, 09 Dec 2021 09:22:13 -0800 (PST)
MIME-Version: 1.0
References: <163906878733.143852.5604115678965006622.stgit@warthog.procyon.org.uk>
 <163906891983.143852.6219772337558577395.stgit@warthog.procyon.org.uk>
In-Reply-To: <163906891983.143852.6219772337558577395.stgit@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 9 Dec 2021 09:21:57 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgejk2DA53dkzs6NquDbQk5_r6Hw8_-RJQ0_njNijKYew@mail.gmail.com>
Message-ID: <CAHk-=wgejk2DA53dkzs6NquDbQk5_r6Hw8_-RJQ0_njNijKYew@mail.gmail.com>
Subject: Re: [PATCH v2 10/67] fscache: Implement cookie registration
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
> +               buf = (u32 *)cookie->inline_key;
> +       }
> +
> +       memcpy(buf, index_key, index_key_len);
> +       cookie->key_hash = fscache_hash(cookie->volume->key_hash, buf, bufs);

This is actively wrong given the noise about "endianness independence"
of the fscache_hash() function.

There is absolutely nothing endianness-independent in the above.
You're taking some random data, casting the pointer to a native
word-order 32-bit entity, and then doing things in that native word
order.

The same data will give different results on different endiannesses.

Maybe some other code has always munged stuff so that it's in some
"native word format", but if so, the type system should have been made
to match. And it's not. It explicitly casts what is clearly some other
pointer type to "u32 *".

There is no way in hell this is properly endianness-independent with
each word in an array having some actual endianness-independent value
when you write code like this.

I'd suggest making endianness either explicit (make things explicitly
"__le32" or whatever) and making sure that you don't just randomly
cast pointers, you actually have the proper types.

Or, alternatively, just say "nobody cares about BE any more,
endianness isn't relevant, get over it".

But don't have functions that claim to be endianness-independent and
then randomly access data like this.

              Linus
