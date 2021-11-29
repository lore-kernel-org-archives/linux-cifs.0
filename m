Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F290C433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Nov 2021 22:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236022AbhK2Wwb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 29 Nov 2021 17:52:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234268AbhK2Wue (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 29 Nov 2021 17:50:34 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF81C03AA30
        for <linux-cifs@vger.kernel.org>; Mon, 29 Nov 2021 10:19:11 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id j18so22959223ljc.12
        for <linux-cifs@vger.kernel.org>; Mon, 29 Nov 2021 10:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A1KpMLhPpZ3DtBAJ2H7WA1+eK6RBPvYL8JCpapFonpw=;
        b=hYrTDwhmtIHMqqbXGO1Kse+Z0mztn57tvq1yPxTQ6q8If5SiUN3r2mIlQQuhqQ5Ciu
         K5ZjiwPNhDNHwoG8b/skXzWnqGGnw5Xo6Kz7rDlvP/WRSBwiwJnbIMXZ+5EJLE2YnPsh
         8oCcdh7mNJuIoeX8m73ktIFQqXot2Q8wW5BQM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A1KpMLhPpZ3DtBAJ2H7WA1+eK6RBPvYL8JCpapFonpw=;
        b=fmffFeltB6BaJdkzMYTZp+3E1geRr82hcW3OD61yA/I7zUVFPDsbP3ex4vDgFwbaJk
         4i+o6KlZNdpHMeq+c+HudRzVObLCSBwLFSjmx+smcB7pctw6YeF5JXyy00RUNJzL7Jcm
         bX0srb3vke+EqsrBDzCP4i8fRYNyhguMuEMBUW5+DUPjCIjnNT8BiCkrvaSNlSTvHVm6
         s50ZTKLGDiQ428P1nfUcQjPrc4J24YvDezOoaI7aDiekl0hj2IDKKCU+zdHjVzDZiFg6
         Lkh/U9MRj46v7llWc4PkKvJQfB2asc7IcZRniYi56rYfw7JpPdBi1ooL+IBjqdfTWAWa
         H3Rw==
X-Gm-Message-State: AOAM530Fq95pf8831otX3BmLrdmKe1/gwggFl1l+gtZbz/PiLsQQ05Vk
        FXxRGl1LxgMtvouvTHt8TD9RvWKg7JQvWLa6fUI=
X-Google-Smtp-Source: ABdhPJwOw8Elv8OYRcRc334uQlSvrK8Zwjhqft7suoY79BgWEgEGdW5wLy0y5+e7EMniom8Ychpnnw==
X-Received: by 2002:a2e:904b:: with SMTP id n11mr49653966ljg.120.1638209949372;
        Mon, 29 Nov 2021 10:19:09 -0800 (PST)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id n30sm1422149lfi.194.2021.11.29.10.19.09
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 10:19:09 -0800 (PST)
Received: by mail-lf1-f50.google.com with SMTP id k37so47040197lfv.3
        for <linux-cifs@vger.kernel.org>; Mon, 29 Nov 2021 10:19:09 -0800 (PST)
X-Received: by 2002:adf:9d88:: with SMTP id p8mr36748101wre.140.1638209581186;
 Mon, 29 Nov 2021 10:13:01 -0800 (PST)
MIME-Version: 1.0
References: <163819575444.215744.318477214576928110.stgit@warthog.procyon.org.uk>
In-Reply-To: <163819575444.215744.318477214576928110.stgit@warthog.procyon.org.uk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 29 Nov 2021 10:12:45 -0800
X-Gmail-Original-Message-ID: <CAHk-=whGOEEb4n2_y3mnrmeNx4HYjRA-m=xMPDQD=bHWfB5chw@mail.gmail.com>
Message-ID: <CAHk-=whGOEEb4n2_y3mnrmeNx4HYjRA-m=xMPDQD=bHWfB5chw@mail.gmail.com>
Subject: Re: [PATCH 00/64] fscache, cachefiles: Rewrite
To:     David Howells <dhowells@redhat.com>
Cc:     linux-cachefs@redhat.com, Jeff Layton <jlayton@kernel.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        linux-afs@lists.infradead.org, Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Marc Dionne <marc.dionne@auristor.com>,
        "open list:NFS, SUNRPC, AND..." <linux-nfs@vger.kernel.org>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        v9fs-developer@lists.sourceforge.net,
        Trond Myklebust <trondmy@hammerspace.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Omar Sandoval <osandov@osandov.com>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Nov 29, 2021 at 6:22 AM David Howells <dhowells@redhat.com> wrote:
>
> The patchset is structured such that the first few patches disable fscache
> use by the network filesystems using it, remove the cachefiles driver
> entirely and as much of the fscache driver as can be got away with without
> causing build failures in the network filesystems.  The patches after that
> recreate fscache and then cachefiles, attempting to add the pieces in a
> logical order.  Finally, the filesystems are reenabled and then the very
> last patch changes the documentation.

Thanks, this all looks conceptually sane to me.

But I only really scanned the commit messages, not the actual new
code. That obviously needs all the usual testing and feedback from the
users of this all..

                    Linus
