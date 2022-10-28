Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06DB7FA3743
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Oct 2022 16:42:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbiJ1Ql6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Oct 2022 12:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiJ1Ql5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Oct 2022 12:41:57 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E001C841E
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 09:41:56 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id r19so3793860qtx.6
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 09:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R2O57OBzpb8FA+DnVcdKrC0pUlI+m8T71gxg18g9ML0=;
        b=KiggagMYrTu7SdTQf7qYTjBuh7Vgh0DLPpwOBg8u9qpWv7WzBIc/UO/p3ds0BQ10Y2
         twYZGkSmA7kxGJkxMhsJuQftz9pMY+b7t5qOEkdTuyRtagTPZL/MxUkxUaekrc5Qnqz8
         TGwfbYloJxbCkPQdW88sUCBtcQCOvMnJfcMNI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R2O57OBzpb8FA+DnVcdKrC0pUlI+m8T71gxg18g9ML0=;
        b=La4q6Jx2NdsgVe0e3BMhBHsX5h8NmS5IqwsKM87jQBswVyugQ7Ge0UCm1K1pRFLKcm
         VYufq15Aqx9zG/i0cOSVNKMPA4ymOqZBKtFqHmWar/ABAf+MHgW/I2yoqkU+nFapHx8s
         y8djbdMVkOiTGjKHBRZ396U3AIf9Tu1Rr0CtwkazE9XW15iuadDoiUG9XYmZ+kD0Nh4k
         vCG/6nB5C47BPvml7zbfz/1PUagXydhbBdF4WPUbN4IV7RsVbfVzED0CDQfOTTyY28pw
         ZmcGb3Cn9ijvDNTdoXgbnBZ9rQlUwZqEQ+yI9w0UPAm6dSXq8bBgBtnyB5sQedYO+e54
         pcxQ==
X-Gm-Message-State: ACrzQf3MACsoa7hIhemEPl7XefupTVqM+EzfnDy86uSVyoyvCN3sLGSM
        l97aRFFkemC9nl7NbNyc3u9EVcQF0xGYhg==
X-Google-Smtp-Source: AMsMyM6NWxYX6IYR9ToNHL1TXoyppNlCS4/2a6H2vhDSQPLSmsO5naqNzg4w2whkftoYpJhFn13piw==
X-Received: by 2002:ac8:5cc2:0:b0:39c:e770:4e77 with SMTP id s2-20020ac85cc2000000b0039ce7704e77mr325149qta.328.1666975315490;
        Fri, 28 Oct 2022 09:41:55 -0700 (PDT)
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com. [209.85.219.178])
        by smtp.gmail.com with ESMTPSA id w22-20020a05620a445600b006eeae49537bsm3281290qkp.98.2022.10.28.09.41.53
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 09:41:53 -0700 (PDT)
Received: by mail-yb1-f178.google.com with SMTP id f205so6763419yba.2
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 09:41:53 -0700 (PDT)
X-Received: by 2002:a05:6902:124f:b0:66e:e3da:487e with SMTP id
 t15-20020a056902124f00b0066ee3da487emr144065ybu.310.1666975312766; Fri, 28
 Oct 2022 09:41:52 -0700 (PDT)
MIME-Version: 1.0
References: <Y1btOP0tyPtcYajo@ZenIV> <20221028023352.3532080-1-viro@zeniv.linux.org.uk>
 <20221028023352.3532080-12-viro@zeniv.linux.org.uk>
In-Reply-To: <20221028023352.3532080-12-viro@zeniv.linux.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 28 Oct 2022 09:41:35 -0700
X-Gmail-Original-Message-ID: <CAHk-=wibPKfv7mpReMj5PjKBQi4OsAQ8uwW_7=6VCVnaM-p_Dw@mail.gmail.com>
Message-ID: <CAHk-=wibPKfv7mpReMj5PjKBQi4OsAQ8uwW_7=6VCVnaM-p_Dw@mail.gmail.com>
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

On Thu, Oct 27, 2022 at 7:34 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> READ/WRITE proved to be actively confusing

I agree, we had the same issue with rw_verify_area()

However:

> Call them ITER_DEST and ITER_SOURCE - at least that is harder
> to misinterpret...

I'm not sure this really helps, or is less likely to cause issues.

The old naming at least had some advantages (yes, yes, this is the
_source_ of the old naming):

> @@ -243,7 +243,7 @@ static int lo_write_bvec(struct file *file, struct bio_vec *bvec, loff_t *ppos)
>         struct iov_iter i;
>         ssize_t bw;
>
> -       iov_iter_bvec(&i, WRITE, bvec, 1, bvec->bv_len);
>
>         file_start_write(file);
>         bw = vfs_iter_write(file, &i, ppos, 0);
> @@ -286,7 +286,7 @@ static int lo_read_simple(struct loop_device *lo, struct request *rq,
>         ssize_t len;
>
>         rq_for_each_segment(bvec, rq, iter) {
> -               iov_iter_bvec(&i, READ, &bvec, 1, bvec.bv_len);
>                 len = vfs_iter_read(lo->lo_backing_file, &i, &pos, 0);
>                 if (len < 0)
>                         return len;

where WRITE is used in the 'write()' function, and READ is used in the
read() function.

So that naming is not great, but it has a fairly obvious pattern in a
lot of code.

Not all code, no, as clearly shown by the other eleven patches in this
series, but still..

The new naming doesn't strike me as being obviously less confusing.
It's not horrible, but I'm also not seeing it as being any less likely
in the long run to then cause the same issues we had with READ/WRITE.
It's not like

                iov_iter_bvec(&i, ITER_DEST, &bvec, 1, bvec.bv_len);

is somehow obviously really clear.

I can see the logic: "the destination is the iter, so the source is
the bvec". I understand. But that was pretty much exactly the logic
behind READ too: "this is a read from the device, so the source is the
bvec". I can well imagine that the new one is clearer for some cases,
and in the context of seeing all these other changes it's all quite
straightforward, but I'm trying to think as a driver writer that is
dealing with one random case at a time, and ITER_DEST doesn't strike
me as hugely intuitive either.

I think the real fix for this is your 11/12, which at least makes the
iter movement helpers warn about mis-use. That said, I hate 11/12 too,
but for a minor technicality: please make the WARN_ON() be a
WARN_ON_ONCE(), and please don't make it abort.

Because otherwise somebody who has a random - but important enough -
driver that does this wrong will just have an unbootable machine.

So your 11/12 is conceptually the right thing, but practically
horribly wrong. While this 12/12 mainly makes me go "If we have a
patch this big, I think we should be able to do better than change
from one ambiguous name to another possibly slightly less ambiguous".

Honestly, I think the *real* fix would be a type-based one. Don't do

        iov_iter_kvec(&iter, ITER_DEST, ...

at all, but instead have two different kinds of 'struct iov_iter': one
as a destination (iov_iter_dst), and one as a source (iov_iter_src),
and then just force all the use-cases to use the right version. The
actual *underlying" struct could still be the same
(iov_iter_implementation), but you'd force people to always use the
right version - kind of the same way a 'const void *' is always a
source, and a 'void *' is always a destination for things like memcpy.

That would catch mis-uses much earlier.

That would also make the patch much bigger, but I do think 99.9% of
all users are very distinct. When you pass a iter source around, that
'iov_iter_src' is basically *always* a source of the data through the
whole call-chain. No?

Maybe I'm 100% wrong and that type-based one has some fundamental
problem in it, but it really feels to me like your dynamic WARN_ON()
calls in 11/12 could have been type-based. Because they are entirely
static based on 'data_source'.

In fact, in a perfect world, 'data_source' as a dynamic flag goes away
entirely, and becomes the compile-time static type. If anything really
needs to change the data_source, it would be done as an inline
function that does a type-cast instead.

And yes, yes, I'm sure we have lots of code that currently is of the
type "just pass it an iov_iter, and depending on data_source it does
something different. I'm looking at __blkdev_direct_IO_simple(), which
seems to be exactly that. So I guess the whole "->direct_IO interface
breaks this, because - as usual - DIRECT_IO is a steaming pile of sh*t
that couldn't do separate read/write functions, but had to be
"special".

Oh well.

I still think that a type-based interface would be better, maybe
together with the bad paths having a "iov_iter_confused" thing that
then needs the runtime checking of ->data_source (aka iov_iter_rw()).
But maybe DIRECT_IO isn't the only thing that thought that it's a good
idea to use the same function for both reads and writes.

                         Linus
