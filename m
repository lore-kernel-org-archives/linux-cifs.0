Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7665C433E0
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Jan 2021 15:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A24F1206A5
	for <linux-cifs@archiver.kernel.org>; Tue, 26 Jan 2021 15:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403840AbhAZPmV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 26 Jan 2021 10:42:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41150 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731086AbhAZPgF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 26 Jan 2021 10:36:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611675278;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+sg4yNwZrAUtqGjsjAIZF/lC9W6Hi56SguvTv3qRusA=;
        b=AvAimHzoNnyt6HHce6CcX+chG4tX7GRBMoCQqfIxXhqI8JNTZLdVRQ5eCsiWDp3LoQW+Ll
        BeRU+iGXcpfeyr40dWf/CDbUTRRooyC2d0rayKu4vV7JNCkHFFE87e7d5qPvPql+tPM8IL
        LMZSLZtAFSNufeHw3Gm8odSA9k8MABg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-k94peZQONReCm_yTmlczLw-1; Tue, 26 Jan 2021 10:34:36 -0500
X-MC-Unique: k94peZQONReCm_yTmlczLw-1
Received: by mail-ed1-f70.google.com with SMTP id q12so4734686edr.2
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jan 2021 07:34:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+sg4yNwZrAUtqGjsjAIZF/lC9W6Hi56SguvTv3qRusA=;
        b=rfnbCO91rnRQiQhG7K0cc+DCh3W3UrWJmPN4WtpM/jtXco+M4K0IrtwxiCiUnH8RoX
         IM8l/5ORYhkeamzW5IHmVO2lWrNrY6gg+EtsvsurWtTcuY6e0gq/O4yp6a4A7jBJMlee
         PeSBg+NPriKJrmhTjmCt7XOQNtuXmtzuQjUE+7+3bQsW5JiXd2mAEeMB30kM0K0CAKhH
         AzlT9bC425ibjRzkf+ERHu+mozp5xdlNaWjPEr2wjbLIXBZ6WDDbwOehP+rbEtsq7iw5
         /1mn1TZzziR7k0N5aK5SQ3RIU1WzRehxhkTCGF0rCrPoB9hMsk8YszMVdCh0SMawaKGT
         yG0g==
X-Gm-Message-State: AOAM530hDoixqwuV39V0LReAsTWghAW2K7Am9uV7xCXBAwnN1wtGLuPH
        dOXwfy9ddwXHXRFMtv5lWmKeiuERcRp8FSksGyWPMtKtsAmhgDfdA49X0Lz5VibPtCOzb1aWPaD
        rtmreVtQqKM1k5IvXcTNkBsC6eswr6d3cw28rZg==
X-Received: by 2002:a17:906:4451:: with SMTP id i17mr2289506ejp.436.1611675275260;
        Tue, 26 Jan 2021 07:34:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzSasZks4PL3NUJQfxg7We8UW4x28G54NbjOgDuCVAFpi7QKXrub9Pz5L3G6Ovg3Un+JLmrv6pQRbddbpD7RMI=
X-Received: by 2002:a17:906:4451:: with SMTP id i17mr2289493ejp.436.1611675275099;
 Tue, 26 Jan 2021 07:34:35 -0800 (PST)
MIME-Version: 1.0
References: <161161025063.2537118.2009249444682241405.stgit@warthog.procyon.org.uk>
 <161161054970.2537118.5401048451896267742.stgit@warthog.procyon.org.uk> <20210126035928.GJ308988@casper.infradead.org>
In-Reply-To: <20210126035928.GJ308988@casper.infradead.org>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Tue, 26 Jan 2021 10:33:59 -0500
Message-ID: <CALF+zOkNMHjtH+cZrGQFqbH5dD5gUpV+y3k-Bt31E35d4kn1oA@mail.gmail.com>
Subject: Re: [PATCH 25/32] NFS: Clean up nfs_readpage() and nfs_readpages()
To:     Matthew Wilcox <willy@infradead.org>
Cc:     David Howells <dhowells@redhat.com>,
        Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jeff Layton <jlayton@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
        linux-nfs <linux-nfs@vger.kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        ceph-devel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Jan 25, 2021 at 11:01 PM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Mon, Jan 25, 2021 at 09:35:49PM +0000, David Howells wrote:
> > -int nfs_readpage(struct file *file, struct page *page)
> > +int nfs_readpage(struct file *filp, struct page *page)
>
> I appreciate we're inconsistent between file and filp, but we're actually
> moving more towards file than filp.
>
Got it, easy enough to change.

