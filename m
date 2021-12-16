Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD77C433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Dec 2021 16:31:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbhLPQbi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Dec 2021 11:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233708AbhLPQbh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Dec 2021 11:31:37 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B14C061574
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 08:31:37 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id e3so90073467edu.4
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 08:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/0tfi6GWjQ8PFg1rClE3QlQWN0cjd+HtwnOPSpFHrtM=;
        b=ZUmg4A/7HjP6eAASANt+4keQHSopn9fF9fVMthVZu/c/YjSSrDTZVizCt53w3pjZTz
         ALdrT2CetN7y0UB7HWM9QXKDG/IjiRvTGiiwA+eAdMgcIrCfVT3wEDCrbPcgGrLjCxw0
         amQe/8kTyLnJyS+EwJHlBCCyQJgU9esnPnqpg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/0tfi6GWjQ8PFg1rClE3QlQWN0cjd+HtwnOPSpFHrtM=;
        b=btLOfR8TbY9ZLz5NG1anIBQrY8y8ZlQXiX1paup8E81Grkb/x2TNUAzOM8tp5qESZQ
         I7ax4x4Gg6ZaEZmI4DR5RcYEj0rFe9Z4BA8bMifB7jR/Pc0W9HRnF+QW+XOnncjx2qTS
         6gXICCE4EgtgWr+ljGsec6J46aso5+GIaBw+ckmMYGCv8CqvpU9v7P1VXwjTaKadTavI
         RYkMl8fvGGXoZSXKTfX4Fe1uGRu+xrzbxQVZYsQyIdoyv3WOXeesANi74vH5iWVjQ14C
         SJ4tYG022y1GDxm8T+k1cXiCFUu20m+B+4KPfC8SKCbdAc6lQkzthwBuX4c6Pcl8vMDp
         sIzw==
X-Gm-Message-State: AOAM533bxwgQqUk/8ykyNZKpPrmthZwrlUo7sz+xLO8EC3D5vyTxNEcc
        As/cIO/0/slJnhVk+qCwtdMNsc1s8zB0QEpf
X-Google-Smtp-Source: ABdhPJz9dnVqwNvs75qvJExWFfXR9PPMoTEbCdApsxFbuFfsiLYXVjXg57gWp1lv9ohJVeHiJXknwQ==
X-Received: by 2002:a05:6402:5244:: with SMTP id t4mr21135509edd.27.1639672295778;
        Thu, 16 Dec 2021 08:31:35 -0800 (PST)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id h7sm2725540ede.40.2021.12.16.08.31.35
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 08:31:35 -0800 (PST)
Received: by mail-wr1-f45.google.com with SMTP id t18so45151526wrg.11
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 08:31:35 -0800 (PST)
X-Received: by 2002:adf:d1a6:: with SMTP id w6mr6315246wrc.274.1639672295092;
 Thu, 16 Dec 2021 08:31:35 -0800 (PST)
MIME-Version: 1.0
References: <163967073889.1823006.12237147297060239168.stgit@warthog.procyon.org.uk>
 <163967169723.1823006.2868573008412053995.stgit@warthog.procyon.org.uk>
In-Reply-To: <163967169723.1823006.2868573008412053995.stgit@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 16 Dec 2021 08:31:19 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi0H5vmka1_iWe0+Yc6bwtgWn_bEEHCMYsPHYtNJKZHCQ@mail.gmail.com>
Message-ID: <CAHk-=wi0H5vmka1_iWe0+Yc6bwtgWn_bEEHCMYsPHYtNJKZHCQ@mail.gmail.com>
Subject: Re: [PATCH v3 56/68] afs: Handle len being extending over page end in write_begin/write_end
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs@redhat.com,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jeff Layton <jlayton@kernel.org>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org,
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Omar Sandoval <osandov@osandov.com>,
        JeffleXu <jefflexu@linux.alibaba.com>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Dec 16, 2021 at 8:22 AM David Howells <dhowells@redhat.com> wrote:
>
> With transparent huge pages, in the future, write_begin() and write_end()
> may be passed a length parameter that, in combination with the offset into
> the page, exceeds the length of that page.  This allows
> grab_cache_page_write_begin() to better choose the size of THP to allocate.

I still think this is a fundamental bug in the caller. That
"explanation" is weak, and the whole concept smells like week-old fish
to me.

         Linus
