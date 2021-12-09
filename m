Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3401EC433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Dec 2021 17:15:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242356AbhLIRTJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Dec 2021 12:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242355AbhLIRTI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Dec 2021 12:19:08 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F12C061746
        for <linux-cifs@vger.kernel.org>; Thu,  9 Dec 2021 09:15:35 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id o20so21972235eds.10
        for <linux-cifs@vger.kernel.org>; Thu, 09 Dec 2021 09:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3tHtN7G3YGgTFoTuLt2UtzoWso0slwegtyye0NyKD6E=;
        b=EkUZICBj3sLfwkSa6PVgwK3UJYMBWKD3Zl6QL503dGClSkUivH631EePhpBTiQgDNd
         VoCL1zBnYteGbjvNrexkMxulvtqSc6W1x7ANtURNimEiRxxY81sHWsZDJM+iJu2oAiti
         SYA5FO15uZ/NSRZ6dw7jltE7xXAi1A4hAYadw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3tHtN7G3YGgTFoTuLt2UtzoWso0slwegtyye0NyKD6E=;
        b=tUPkf6no67VETT9HbjT70RHK7CFtqRlo1kzFVoIsa0Fn0bbVi0aqJMvAJyqJzkW+Ra
         THSo6B7nWL+6UUVztaOgP4p3/wQP7/pqYPsYsXHy05YpF1ey+QahJt9bVhZODRGHJNcW
         VkmJQiNt6MSPatMfkNG1NHvCWGSMdF0nlBkfSwlqXteUuivA+4EFvaqSOt1iEQvK9kWK
         pFo7yg68vXfiBeDxEbMcYz/Pwg24p6o+BQvIPxonswhaopqcQY6cSCjZkHX0chzwKl3I
         AMAlxue/8tYjZlpcG9LYJ5If6drsPNFFiVa6iKaWxL8BybA1ILHLaa62qp9jAcMzqCAn
         zCNg==
X-Gm-Message-State: AOAM53304D3ILIgt4S+7YWvvj0cv1DL8l0LIlxmM7vU3kqQ3IZLLyTsG
        EEgBH9/KJ946Ub3gugnIaNO4lfPY6xkE2kSP
X-Google-Smtp-Source: ABdhPJy9K1GVPjU8vL1a72kydiAKfq7MRFhz+UX8gcplBnbfnAPjxYA8WHzrcs3YNLzyD2DQpwzZSA==
X-Received: by 2002:a17:907:1b11:: with SMTP id mp17mr16748675ejc.374.1639069995942;
        Thu, 09 Dec 2021 09:13:15 -0800 (PST)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com. [209.85.128.47])
        by smtp.gmail.com with ESMTPSA id y15sm193561edr.35.2021.12.09.09.13.14
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 09:13:15 -0800 (PST)
Received: by mail-wm1-f47.google.com with SMTP id p18so4751083wmq.5
        for <linux-cifs@vger.kernel.org>; Thu, 09 Dec 2021 09:13:14 -0800 (PST)
X-Received: by 2002:a05:600c:1914:: with SMTP id j20mr8992229wmq.26.1639069994552;
 Thu, 09 Dec 2021 09:13:14 -0800 (PST)
MIME-Version: 1.0
References: <163906878733.143852.5604115678965006622.stgit@warthog.procyon.org.uk>
 <163906888735.143852.10944614318596881429.stgit@warthog.procyon.org.uk>
In-Reply-To: <163906888735.143852.10944614318596881429.stgit@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 9 Dec 2021 09:12:58 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiTquFUu-b5ME=rbGEF8r2Vh1TXGfaZZuXyOutVrgRzfw@mail.gmail.com>
Message-ID: <CAHk-=wiTquFUu-b5ME=rbGEF8r2Vh1TXGfaZZuXyOutVrgRzfw@mail.gmail.com>
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

On Thu, Dec 9, 2021 at 8:54 AM David Howells <dhowells@redhat.com> wrote:
>
> Implement a function to generate hashes.  It needs to be stable over time
> and endianness-independent as the hashes will appear on disk in future
> patches.

I'm not actually seeing this being endianness-independent.

Is the input just regular 32-bit data in native word order? Because
then it's not endianness-independent, it's purely that there *is* no
endianness to the data at all and it is purely native data.

So the code may be correct, but the explanation is confusing. There is
absolutely nothing here that is about endianness.

           Linus
