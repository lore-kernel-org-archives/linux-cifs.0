Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8546FC7EE2D
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Feb 2023 16:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjBXQ2T (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Feb 2023 11:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjBXQ2S (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 24 Feb 2023 11:28:18 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE5A11EB9
        for <linux-cifs@vger.kernel.org>; Fri, 24 Feb 2023 08:27:54 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id f13so56368558edz.6
        for <linux-cifs@vger.kernel.org>; Fri, 24 Feb 2023 08:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s1ddkJIM272NGkB+LdN/hOmq0DPwywAhS02NibdV81Y=;
        b=bstXxSL+BDGWYBS5i0BfvHRTN5xNltCllunCBSGHMIovfA2Zl4RfJXVwEWe8wBnMcA
         j/8MypiD9cD6M+qyHUfL5CDqO9YEdIBWUdDzQBViMk5d2c96bWbBg7i6UXH/WXncbAj6
         aRxK/kG0bgqQB9xcxRQZsAkPeR0Ta+jmZuR/E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s1ddkJIM272NGkB+LdN/hOmq0DPwywAhS02NibdV81Y=;
        b=q08ObVSKB2hxiPmaa3NruvfnQtZEimCN1+XECkTdHLkFPYDDJufrnEK4SYR4JbJUDp
         fGhJOyc/B6qy+tExT6Lmq90ZHzUcBjrBlmamiXuZAr7h/WyaEmENc62gSQKd2h3dmkg8
         2QB9si61yQBuV1sKno4Gt4u0YfYWmCl6BDXHlULwBpU+mGa4ocvdJ1FMwcstlOfEPO47
         2/izn857c77xDfQvIEaNqCayBqtmj1bRvQVSIx7wSwX9EaBD8kLyaOKHkiyD/HkWffV8
         xqcj16bVTkkGkUg1FVdlT2PAGIcp7kAIRwLIG85IybmHcUlKIjqFKpZJe7+zc+dTZS3u
         wFzQ==
X-Gm-Message-State: AO0yUKUg7d40mjP3bipezFmx8TVrxu8VxNRu/at+nGfoB45san51vv1Z
        PVrr3fd4JtHu+Zehq3vKOM70emfd36piaBkgCdEXUA==
X-Google-Smtp-Source: AK7set/24hG1SvYyrCjxx7vZS0SgkZCjFCX8nW4VoEw90Z/MLps+pdxmi6ms0gdTTMwZ4Qw2+Z2FLQ==
X-Received: by 2002:a17:907:2bd2:b0:889:d998:1576 with SMTP id gv18-20020a1709072bd200b00889d9981576mr22860491ejc.66.1677256072996;
        Fri, 24 Feb 2023 08:27:52 -0800 (PST)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id e19-20020a1709067e1300b008e7916f0bdesm3273548ejr.138.2023.02.24.08.27.52
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 08:27:52 -0800 (PST)
Received: by mail-ed1-f41.google.com with SMTP id h16so57074332edz.10
        for <linux-cifs@vger.kernel.org>; Fri, 24 Feb 2023 08:27:52 -0800 (PST)
X-Received: by 2002:a50:d619:0:b0:4ab:3a49:68b9 with SMTP id
 x25-20020a50d619000000b004ab3a4968b9mr7634213edi.5.1677255740399; Fri, 24 Feb
 2023 08:22:20 -0800 (PST)
MIME-Version: 1.0
References: <2134430.1677240738@warthog.procyon.org.uk> <2009825.1677229488@warthog.procyon.org.uk>
 <CAHk-=whAAOVBrzwb2uMjCmdRrtudGesYj0tuqdUgi8X_gbw1jw@mail.gmail.com>
 <20230220135225.91b0f28344c01d5306c31230@linux-foundation.org>
 <2213409.1677249075@warthog.procyon.org.uk> <2244151.1677251586@warthog.procyon.org.uk>
In-Reply-To: <2244151.1677251586@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 24 Feb 2023 08:22:03 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgPPFN0MvHYwtaPAtQkDFHwZrDXxZ+bOWk-qSyGMiLV6g@mail.gmail.com>
Message-ID: <CAHk-=wgPPFN0MvHYwtaPAtQkDFHwZrDXxZ+bOWk-qSyGMiLV6g@mail.gmail.com>
Subject: Re: [RFC][PATCH] cifs: Improve use of filemap_get_folios_tag()
To:     David Howells <dhowells@redhat.com>
Cc:     Steve French <stfrench@microsoft.com>,
        Vishal Moola <vishal.moola@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Paulo Alcantara <pc@cjr.nz>,
        Matthew Wilcox <willy@infradead.org>,
        Huang Ying <ying.huang@intel.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Xin Hao <xhao@linux.alibaba.com>, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Feb 24, 2023 at 7:13 AM David Howells <dhowells@redhat.com> wrote:
>
> The inefficiency derived from filemap_get_folios_tag() get a batch of
> contiguous folios in Vishal's change to afs that got copied into cifs can
> be reduced by skipping over those folios that have been passed by the start
> position rather than going through the process of locking, checking and
> trying to write them.

This patch just makes me go "Ugh".

There's something wrong with this code for it to need these games.

That  just makes me convinced that your other patch that just gets rid
of the batching entirely is the right one.

Of course, I'd be even happier if Willy is right and the code could
use the generic write_cache_pages() and avoid all of these things
entirely. I'm not clear on why cifs and afs are being so different in
the first place, and some of the differences are just odd (like that
skip count).

               Linus
