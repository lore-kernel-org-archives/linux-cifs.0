Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C79FC43219
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Nov 2022 18:35:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238965AbiKWSfN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 23 Nov 2022 13:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239257AbiKWSfB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 23 Nov 2022 13:35:01 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035FCC771
        for <linux-cifs@vger.kernel.org>; Wed, 23 Nov 2022 10:35:01 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id g10so13053103qkl.6
        for <linux-cifs@vger.kernel.org>; Wed, 23 Nov 2022 10:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=T/jG5QaYqTRKNFcJtqKGHj4SfbKFSJH0wslCbBk+0rc=;
        b=WtEZfFy9CjWS25vRvH8BUGmfQ5TppWVPJY29aYmVjK2t/Gqd80v173byCSBDvOcqZ5
         GS3iagkeA7ssVh/ddKEkJKHeWkCPYto/COdNwh44sfuBXjAau3yrVZ6HAJiXAaELgCMQ
         DakZoiuRSNhC/sDbjfyndFBio5BbqUEFc1b48=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T/jG5QaYqTRKNFcJtqKGHj4SfbKFSJH0wslCbBk+0rc=;
        b=wQJHTVIzGCrtyAFqwD/zTQn/9EIaSTONLHptjT0oyvsIRzCy3FT67STTNrDIikpdZY
         AAqOcVVWNXK3bf9uQDkyDXuYQEKh7pfsqT/436UxdPxCyGb6zsOcVSmo/ZnBMzIp6oSf
         qYf8ScCvWL6DN1ox4Kr62XeRmIv8QvBnT5xZqU0nDBIfd+stodTnxUboV6CFqyOGQnQp
         ukZBkxOkGG/MOd6Ai0JwkK6l6P9zTvcUY6TCEEV1R8rdig4XztFpketRzo72r0h3DMEm
         08tNcM4ioFSa4OQO8ksfFbm2z3bLjooGJfFG4kGurN2Zr1RpzisHwpvCUFz4Rq2AukZ2
         zevA==
X-Gm-Message-State: ANoB5pkotws2Y0ZOl+9mcjrIL3QCXE7gpaLXnYoeg0qyEseCbXW+C5y8
        0ZLsoL0mHuLUBAMKNQRnaCz3NHg7j/K5nw==
X-Google-Smtp-Source: AA0mqf53omU7Kkl8uvv1pKcnB79vO2pd3jZrn73r1WCY+/CGOkHhVhbhqy+9FUw/iZHemWb+bAQLoA==
X-Received: by 2002:ae9:ed4d:0:b0:6f8:4c19:8072 with SMTP id c74-20020ae9ed4d000000b006f84c198072mr26509635qkg.601.1669228499874;
        Wed, 23 Nov 2022 10:34:59 -0800 (PST)
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com. [209.85.222.180])
        by smtp.gmail.com with ESMTPSA id i5-20020a05620a404500b006fb11eee465sm12638386qko.64.2022.11.23.10.34.59
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Nov 2022 10:34:59 -0800 (PST)
Received: by mail-qk1-f180.google.com with SMTP id i9so3541106qkl.5
        for <linux-cifs@vger.kernel.org>; Wed, 23 Nov 2022 10:34:59 -0800 (PST)
X-Received: by 2002:ac8:41cd:0:b0:3a5:1ba7:717d with SMTP id
 o13-20020ac841cd000000b003a51ba7717dmr9188380qtm.678.1669228012067; Wed, 23
 Nov 2022 10:26:52 -0800 (PST)
MIME-Version: 1.0
References: <1459152.1669208550@warthog.procyon.org.uk>
In-Reply-To: <1459152.1669208550@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 23 Nov 2022 10:26:36 -0800
X-Gmail-Original-Message-ID: <CAHk-=wghJtq-952e_8jd=vtV68y_HsDJ8=e0=C3-AsU2WL-8YA@mail.gmail.com>
Message-ID: <CAHk-=wghJtq-952e_8jd=vtV68y_HsDJ8=e0=C3-AsU2WL-8YA@mail.gmail.com>
Subject: Re: [PATCH v3] mm, netfs, fscache: Stop read optimisation when folio
 removed from pagecache
To:     David Howells <dhowells@redhat.com>
Cc:     willy@infradead.org, dwysocha@redhat.com,
        Rohith Surabattula <rohiths.msft@gmail.com>,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Ilya Dryomov <idryomov@gmail.com>, linux-cachefs@redhat.com,
        linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
        v9fs-developer@lists.sourceforge.net, ceph-devel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Nov 23, 2022 at 5:02 AM David Howells <dhowells@redhat.com> wrote:
>
> Is the attached patch too heavy to be applied this late in the merge cycle?
> Or would you prefer it to wait for the merge window?

This patch is much too much for this point in the release.

But I also think it's strange in another way, with that odd placement of

        mapping_clear_release_always(inode->i_mapping);

at inode eviction time. That just feels very random.

Similarly, that change to shrink_folio_list() looks strange, with the
nasty folio_needs_release() helper. It seems entirely pointless, with
the use then being

                if (folio_needs_release(folio)) {
                        if (!filemap_release_folio(folio, sc->gfp_mask))
                                goto activate_locked;

when everybody else is just using filemap_release_folio() and checking
its return value. I like how you changed other cases of

        if (folio_has_private(folio) && !filemap_release_folio(folio, 0))
                return 0;

to just use "!filemap_release_folio()" directly, and that felt like a
cleanup, but the shrink_folio_list() changes look like a step
backwards.

And the change to mm/filemap.c is completely unacceptable in all
forms, and this added test

+       if ((!mapping || !mapping_release_always(mapping)) &&
+           !folio_test_private(folio) &&
+           !folio_test_private_2(folio))
+               return true;

will not be accepted even during the merge window. That code makes no
sense what-so-ever, and is in no way acceptable.

That code makes no sense what-so-ever. Why isn't it using
"folio_has_private()"? Why is it using it's own illegible version of
that that doesn't match any other case? Why is this done as an
open-coded - and *badly* so - version of !folio_needs_release() that
you for some reason made private to mm/vmscan.c?

So no, this patch is too ugly to apply as-is *ever*, much less during
the late rc series.

                 Linus
