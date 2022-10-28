Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 942C3ECAAA1
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Oct 2022 18:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbiJ1Sfg (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Oct 2022 14:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiJ1Sfc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Oct 2022 14:35:32 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890AF6E2E1
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 11:35:27 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id l9so3995812qkk.11
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 11:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=554KCjWn8qBcAcBVpoouhKeUYG/Iw1xaVWw3M5KddOs=;
        b=DCzroOtVcESn8/j0p2284O1c8+f71f2wa1HhtWbyeBVb5KrtXtesUm1DKY6tLO/CqX
         oBob/TSHMKmFbqkcAbw8pVZOUno4hI+NzeRw7haRuA1X/fp9UYA0EEKK34zd9GG+8Fmn
         h0agPHPClfZ8rFS2LoP6wiZ0asEbvErvPOO6Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=554KCjWn8qBcAcBVpoouhKeUYG/Iw1xaVWw3M5KddOs=;
        b=NFdv0TaHLlbLP6X29/PvIZECYPws6rsnggz+cw0mjzJbmNaOAHT97ZvOPrTa5ZmdlP
         amzhMEUXvOJUrcaLeV7tTTLTnjiRXa5CIGDT6qJfpW8WW7SlEmB9Ctrer8o4PgVEtgIN
         k3k03q9CWXiVTwcUMo7YG8iOKEf3ktWbrp+iV4KnAwsY0bWLObO8nS8DoW9PymM+5ru4
         +8qQaWdyiPz2QzCouBmvXU5NYp19x7YTh45Rrj6x0HoOxsi9jBv5OzaNyaLD1arKvYoR
         KfUKyDPTS9Ri4nr+MAiG7syIKo1Pkj0jUJ6VQK/XyORFOutL1/5lyf3xxlYvJawv37x/
         SyIA==
X-Gm-Message-State: ACrzQf1U9/YEkVyZlBKyfAOU9UCxQe149KKqrbwDgmgt3s/MzYSovqdD
        wHdVYPc3w5TX2YAByxH22IOSZpfy/rJYmQ==
X-Google-Smtp-Source: AMsMyM7CLK1tm5Va/JsP2RMTt2+mYCk5y4lmWpE9hP8R6fz7cn8ejAfEEEg26he9hyHbpo3Wh2HG1g==
X-Received: by 2002:a05:620a:a1e:b0:6f7:ed97:3d49 with SMTP id i30-20020a05620a0a1e00b006f7ed973d49mr498450qka.364.1666982125603;
        Fri, 28 Oct 2022 11:35:25 -0700 (PDT)
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com. [209.85.219.175])
        by smtp.gmail.com with ESMTPSA id r25-20020ac867d9000000b0039cd4d87aacsm2705170qtp.15.2022.10.28.11.35.22
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 11:35:23 -0700 (PDT)
Received: by mail-yb1-f175.google.com with SMTP id r3so7080478yba.5
        for <linux-cifs@vger.kernel.org>; Fri, 28 Oct 2022 11:35:22 -0700 (PDT)
X-Received: by 2002:a25:5389:0:b0:6bc:f12c:5d36 with SMTP id
 h131-20020a255389000000b006bcf12c5d36mr619498ybb.184.1666982122579; Fri, 28
 Oct 2022 11:35:22 -0700 (PDT)
MIME-Version: 1.0
References: <Y1btOP0tyPtcYajo@ZenIV> <20221028023352.3532080-1-viro@zeniv.linux.org.uk>
 <20221028023352.3532080-12-viro@zeniv.linux.org.uk> <CAHk-=wibPKfv7mpReMj5PjKBQi4OsAQ8uwW_7=6VCVnaM-p_Dw@mail.gmail.com>
 <Y1wOR7YmqK8iBYa8@ZenIV>
In-Reply-To: <Y1wOR7YmqK8iBYa8@ZenIV>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 28 Oct 2022 11:35:06 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi_iDAugqFZxTiscsRCNbtARMFiugWtBKO=NqgM-vCVAQ@mail.gmail.com>
Message-ID: <CAHk-=wi_iDAugqFZxTiscsRCNbtARMFiugWtBKO=NqgM-vCVAQ@mail.gmail.com>
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

On Fri, Oct 28, 2022 at 10:15 AM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > I can see the logic: "the destination is the iter, so the source is
> > the bvec".
>
> ???
>
> Wait a sec; bvec is destination - we are going to store data into the page
> hanging off that bvec.

Yeah, no, I'm confused and used confusing language. The bvec is the
only "source" in the sense that it's the original destination.  They
are both the destination for the data itself.

> Umm...  How are you going to e.g. copy from ITER_DISCARD?  I've no problem
> with WARN_ON_ONCE(), but when the operation really can't be done, what
> can we do except returning an error?

Fair enough. But it's the "people got the direction wrong, but the
code worked" case that I would want tyo make sure still works - just
with a warning.

Clearly the ITER_DISCARD didn't work before either, but all the cases
in patches 1-10 were things that _worked_, just with entirely the
wrong ->data_source (aka iov_iter_rw()) value.

So things like copy_to_iter() should warn if it's not a READ (or
ITER_DEST), but it should still copy into the destination described by
the iter, in order to keep broken code working.

That's simply because I worry that your patches 1-10 didn't actually
catch every single case. I'm not actually sure how you found them all
- did you have some automation, or was it with "boot and find warnings
from the first version of patch 11/12"?


> No.  If nothing else, you'll get to split struct msghdr (msg->msg_iter
> different for sendmsg and recvmsg that way) *and* you get to split
> every helper in net/* that doesn't give a damn about the distinction
> (as in "doesn't even look at ->msg_iter", for example).

Gah. Ok. So it's more than just direct_io. Annoying.

              Linus
