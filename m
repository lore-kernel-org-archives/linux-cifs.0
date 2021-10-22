Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E30DC433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Oct 2021 19:27:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BA2460E9C
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Oct 2021 19:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233615AbhJVT3t (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Oct 2021 15:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbhJVT3r (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Oct 2021 15:29:47 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B49C061764
        for <linux-cifs@vger.kernel.org>; Fri, 22 Oct 2021 12:27:29 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id u21so5493866lff.8
        for <linux-cifs@vger.kernel.org>; Fri, 22 Oct 2021 12:27:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6MIYbiqTAgOZcVD7o78/iMiC5v0PdYgNzQoieL1dnhA=;
        b=NpDhMd+K20exoXtDQK8VxJJZx2jeiKfduhNixPkqDW3AhUt9xwYIfDXlKXTXwxZNO2
         rNDgVo6Zt+p6dmQo5I+h/tgPznlF+wHZKxE1z8e+Cg4jyabcAJUUy8ldhvdjRTw7E0CK
         ZCzjOxlNRUs2SJlFmk4Z3ttWsxuy0Et3Uj530=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6MIYbiqTAgOZcVD7o78/iMiC5v0PdYgNzQoieL1dnhA=;
        b=paA0ynVdh07D6sHl1lEzkHq/vhr5fZrVZs6jAUV79mbylzUQcwYYXU3gA0W9QhgRvL
         njsZ6zjM0ZF2m70X7wPi2bqYDVd7Uv+C52wiReX6/vJhiPi+Jtm+rg75qhDA1DMhYsh8
         R3AS7vVGiD70LUP4BisEQbTt33DTQr10cK3dgMjBaTkdplyZsnJ4U54aRU9WV6zADpiS
         RRKH0k0jSKmY25KERiGpvVSUqRT4WJdyPnJGTAgeCl9IEYPJrNHNj0vXlyBpBS1y2DYr
         Ysqq5w0eelzr+5IxQ5gL4N5KNcplhyTH3ObdnX7IKFBH6QrsL3lnKs7lQ0GAOGnv1g/6
         IAdQ==
X-Gm-Message-State: AOAM530g9ylhMR2od/Idd8+AKSSoLpD6Cs1BcTrkpGElEuqV9q4DOn4U
        3sHHfj0fENmGljhdwkgEpl99jSgAX/6VSdXyzz4=
X-Google-Smtp-Source: ABdhPJx/Q+Ga3GMYVHNxiiVrX5REK8Eec/MXvnYU3c0kwZaW90FaPqzmrIjoVtJMKcvG3D5q76SikA==
X-Received: by 2002:a19:c192:: with SMTP id r140mr1428789lff.448.1634930847164;
        Fri, 22 Oct 2021 12:27:27 -0700 (PDT)
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com. [209.85.208.180])
        by smtp.gmail.com with ESMTPSA id a11sm811103lfl.157.2021.10.22.12.27.26
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Oct 2021 12:27:27 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id w23so3246161lje.7
        for <linux-cifs@vger.kernel.org>; Fri, 22 Oct 2021 12:27:26 -0700 (PDT)
X-Received: by 2002:a19:ad0c:: with SMTP id t12mr1362164lfc.173.1634930491229;
 Fri, 22 Oct 2021 12:21:31 -0700 (PDT)
MIME-Version: 1.0
References: <163492911924.1038219.13107463173777870713.stgit@warthog.procyon.org.uk>
In-Reply-To: <163492911924.1038219.13107463173777870713.stgit@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 22 Oct 2021 09:21:15 -1000
X-Gmail-Original-Message-ID: <CAHk-=wjmx7+PD0hzWj5Bg2b807xYD2KCZApTvFje=ufo+MxBMQ@mail.gmail.com>
Message-ID: <CAHk-=wjmx7+PD0hzWj5Bg2b807xYD2KCZApTvFje=ufo+MxBMQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/53] fscache: Rewrite index API and management system
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
        Marc Dionne <marc.dionne@auristor.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Steve French <sfrench@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Jeff Layton <jlayton@kernel.org>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Jeff Layton <jlayton@kernel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Omar Sandoval <osandov@osandov.com>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Oct 22, 2021 at 8:58 AM David Howells <dhowells@redhat.com> wrote:
>
> David Howells (52):
>       fscache_old: Move the old fscache driver to one side
>       fscache_old: Rename CONFIG_FSCACHE* to CONFIG_FSCACHE_OLD*
>       cachefiles_old:  Move the old cachefiles driver to one side

Honestly, I don't see the point of this when it ends up just being
dead code basically immediately.

You don't actually support picking one or the other at build time,
just a hard switch-over.

That makes the old fscache driver useless. You can't say "use the old
one because I don't trust the new". You just have a legacy
implementation with no users.

              Linus
