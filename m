Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47AC6C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Dec 2021 16:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbhLPQ2K (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Dec 2021 11:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233731AbhLPQ2J (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Dec 2021 11:28:09 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C46C061574
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 08:28:09 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id z29so8819716edl.7
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 08:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fkh9SA21WJAwLXrex3D5hDMvc6XDF8J0dz4irJ+Ae9Y=;
        b=TZ91WtmX33bYGxQ28DYuwMlA4L/Ykfses9BBTD3iJ52Q9qh/2tU+S4awSqTTbNIEfO
         NIVIGXtvrTssU7E/Ib+EszfgqaQI3Ug/c2E/ITq3PkTvuJKpkp8KHKAP+FyMLrxxfyHm
         7LDKJiXUmfROJo2atlx1zLIBfA58BXXUjM6Yc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fkh9SA21WJAwLXrex3D5hDMvc6XDF8J0dz4irJ+Ae9Y=;
        b=xOe6EwI6io4ujiAHqw0N57UnsEyQWV7E6Zte2n6NZq/BxNBmkq81FBdOVY8uHckIGj
         OhVl9hfWCy6luoaZmaUHqExDCQROhsoMpGexYoN/4ZYCdJF97iCxhUK8IJchmcak3jbV
         LV3ndZXjEtSAE+0lv1OQ/hSVcdZGuBofijZbU+Yz6GMxQDAE4nVC7QijVq3DEE7Ao9Kr
         UNFzExdT4jbOkqpi9zbKGs3eOKsmVYmwLYZqCk0mgjG3vl0ke+lmY7J66kn22tk2ldBb
         8N2XMliqrPfwXKWIWKTwhhw3Bxhddr4laxA0uGyqFc8UthSe1CspxGDD/TlWFvCpq0Si
         aJqg==
X-Gm-Message-State: AOAM530amXrW4/FYnuyY+gKiZy0tLQVNdlg4Hf2MG7YH82dByUxb5uh/
        ejf+40C8nZ+Ya4IBt122rhXNncZbEOdtDeGn
X-Google-Smtp-Source: ABdhPJxtc89k0GRONDMRxUupBDG+M84jIKFC8+2M8zSefR9zqb/JTJlq4L6CNZrPeBfz5snrysd4JQ==
X-Received: by 2002:a17:906:7304:: with SMTP id di4mr16715036ejc.327.1639672087753;
        Thu, 16 Dec 2021 08:28:07 -0800 (PST)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id kx3sm2003116ejc.112.2021.12.16.08.28.06
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Dec 2021 08:28:06 -0800 (PST)
Received: by mail-wr1-f48.google.com with SMTP id t26so8864962wrb.4
        for <linux-cifs@vger.kernel.org>; Thu, 16 Dec 2021 08:28:06 -0800 (PST)
X-Received: by 2002:a5d:6211:: with SMTP id y17mr9727999wru.97.1639672086343;
 Thu, 16 Dec 2021 08:28:06 -0800 (PST)
MIME-Version: 1.0
References: <163967073889.1823006.12237147297060239168.stgit@warthog.procyon.org.uk>
 <163967172373.1823006.6118195970180365070.stgit@warthog.procyon.org.uk>
In-Reply-To: <163967172373.1823006.6118195970180365070.stgit@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 16 Dec 2021 08:27:50 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjiba2VRKKjOYAiCZn1Tk9H1tiXcOvjekdo3wPHHmedyQ@mail.gmail.com>
Message-ID: <CAHk-=wjiba2VRKKjOYAiCZn1Tk9H1tiXcOvjekdo3wPHHmedyQ@mail.gmail.com>
Subject: Re: [PATCH v3 57/68] afs: Fix afs_write_end() to handle len > page size
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs@redhat.com, Jeff Layton <jlayton@kernel.org>,
        Marc Dionne <marc.dionne@auristor.com>,
        Matthew Wilcox <willy@infradead.org>,
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
> It is possible for the len argument to afs_write_end() to overrun the end
> of the page (len is used to key the size of the page in afs_write_start()
> when compound pages become a regular thing).

This smells like a bug in the caller.

It's just insane to call "write_end()" with a range that doesn't
actually fit in the page provided.

Exactly how does that happen, and why should AFS deal with it, not
whoever called write_end()?

              Linus
