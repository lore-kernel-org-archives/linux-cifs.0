Return-Path: <SRS0=N0Uh=4C=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93512C2BA83
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Feb 2020 14:28:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67BA02168B
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Feb 2020 14:28:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aZtbjZb4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbgBNO2p (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Feb 2020 09:28:45 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:39467 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbgBNO2o (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 14 Feb 2020 09:28:44 -0500
Received: by mail-pj1-f66.google.com with SMTP id e9so4003328pjr.4
        for <linux-cifs@vger.kernel.org>; Fri, 14 Feb 2020 06:28:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/0eY8YEJ0CYiYNhGHStK7nhZtrxxUv+KLpI+Qku4XnQ=;
        b=aZtbjZb4d2aV9/b2mWOrjni43fkfrWCknXOaUl+lQrgN+Tnh3i5tNqihdKUgnpIitg
         sb6gMsFovfvVISSBAEEvfUGo31X4ktEZLtY2tAgIWl3tDk2tHscFY3XlOQhGCr5avpF2
         hQ53M6UaxQKuusXx8K2PC405oCF+fD6QpN01Libhnb6bjRgEeCUrtjAynlvGMKD9l5f9
         9rx6wi5/OuKAfBirRT9u8h9ZBCIV8HUVsQ7ZW5dyla0WL6StK+aBfRQ68LqPPqdnzhPt
         qRUmlp+MLFzY1BclK6IPYWc6ctPfMviogJz+A3ZwIHfRiHZsI/AnVGXIAra+iDXgbFkP
         E7Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/0eY8YEJ0CYiYNhGHStK7nhZtrxxUv+KLpI+Qku4XnQ=;
        b=ckXYw2G7CO16LVqIMexwCbVs1YFJuqQiXd2e9Vi6yOZrZL7mgNaV9z0woZyRXR+MdN
         /m3eYbJJs4FQv/dwO/8qfOmQgAF/NDXTgl8r1ofVfKkQEcofpC2aSc/QvwzInuB4rNrq
         bfqtUT40zJA2T9s6ZEiW4uGnQyBdg5CP6/BQNxgXwmHUqexYGaX2tiSLhH4vixLPjacG
         oXvpV0TPwf9LYmbjnivHQSFXDR6QnEbem01wNIv569tBJMk50b9V7OJjDmt7I6riVHhH
         atsw/sSicFmRoi+vZao93xm10vwqUcck2EHgFL7746PO4L/mENR5T/cHgBcMUZPSRuQK
         hJbA==
X-Gm-Message-State: APjAAAVuMaKKWKNvlFk0Qji9IjnaG5WK/r/Xk92YvdpGa0Ek+Q9Zz3F9
        6sqB0wh01i4glYdydWW9Bg/8w/Er
X-Google-Smtp-Source: APXvYqxHiLOGS96LHjJnE2o4eZ2PmeGsXU0brnajRocJk2jTFT9d/SsA4zNvFzWJocNm8oUjlfXSTg==
X-Received: by 2002:a17:902:b944:: with SMTP id h4mr3563743pls.92.1581690524116;
        Fri, 14 Feb 2020 06:28:44 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h26sm7676717pfr.9.2020.02.14.06.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 06:28:43 -0800 (PST)
Date:   Fri, 14 Feb 2020 22:28:36 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>, linux-cifs@vger.kernel.org,
        Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] CIFS: unlock file across process
Message-ID: <20200214142836.2rhitx3jfa5nxada@xzhoux.usersys.redhat.com>
References: <20200214043513.uh2jtb62qf54nmud@xzhoux.usersys.redhat.com>
 <370134c148a5f4d12df31a3a9020b66ef316a004.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <370134c148a5f4d12df31a3a9020b66ef316a004.camel@kernel.org>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Feb 14, 2020 at 07:26:46AM -0500, Jeff Layton wrote:
> On Fri, 2020-02-14 at 12:35 +0800, Murphy Zhou wrote:
> > Now child can't unlock the same file that has been locked by
> > parent. Fix this by not skipping unlock if requesting from
> > different process.
> > 
> > Patch tested by LTP and xfstests using samba server.
> > 
> > Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> > ---
> >  fs/cifs/smb2file.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
> > index afe1f03aabe3..b5bca0e13d51 100644
> > --- a/fs/cifs/smb2file.c
> > +++ b/fs/cifs/smb2file.c
> > @@ -151,8 +151,6 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
> >  		    (flock->fl_start + length) <
> >  		    (li->offset + li->length))
> >  			continue;
> > -		if (current->tgid != li->pid)
> > -			continue;
> >  		if (cinode->can_cache_brlcks) {
> >  			/*
> >  			 * We can cache brlock requests - simply remove a lock
> 
> I'm not as familiar with this code as I once was, but...
> 
> From fork(2) manpage:
> 
>        *  The  child does not inherit process-associated record locks from its
>           parent (fcntl(2)).  (On the other hand,  it  does  inherit  fcntl(2)
>           open file description locks and flock(2) locks from its parent.)
> 
> It looks like cifs_setlk calls mand_unlock_range, and that gets called
> from both fcntl and flock codepaths.
> 
> So, I'm not sure about just removing this. It seems like the pid check
> is probably correct for traditional posix locks, but probably not for
> OFD and flock locks? What ensures that completely unrelated tasks can't
> unlock your locks?

You are right Jeff. Just removing this is not right. We need to handle
at least 3 types of locks: posix, OFD and flock.

Thanks very much for reviewing! I'll try to sort this out.
> -- 
> Jeff Layton <jlayton@kernel.org>
> 
