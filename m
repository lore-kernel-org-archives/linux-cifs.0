Return-Path: <SRS0=Ot+p=4V=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3788CC3F2D1
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Mar 2020 02:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E48320866
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Mar 2020 02:33:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f6FKEWhY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387452AbgCDCdq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Mar 2020 21:33:46 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44437 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387473AbgCDCdq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 Mar 2020 21:33:46 -0500
Received: by mail-pf1-f193.google.com with SMTP id y26so150073pfn.11
        for <linux-cifs@vger.kernel.org>; Tue, 03 Mar 2020 18:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uMDrPDLSvrt+LZ/B1Dx4NYmfSQkR45XjEYJFwYsLOAs=;
        b=f6FKEWhYV6Yn32hpn4zu5wnouAFE8ypADTkBaAeQKgpEhyswMGf6iNqLbmYYd6GYfp
         M6ZdaaBwMI1xAGskUlOUzClzV8QBkMjk40MEJK5fwoi3NdR7TTXKqkh8E4OIFbOGlRdw
         otFsZpDGMXJZziXHf08zFAgc+q1Rjk2thsCMbP6zHAZcmNQ34J2QgvvtBf2YnK8jVBOI
         sMtRbeB1tENazm5XImjo9nHnY5SD88BbaR/Q2I74jvw1GrmqP1DS/ji5qZiR4nEX8vHl
         ukDwY3J+2JjWpnzsUi3FyqeGTW6Mvqk8LAQTeZKEdMOFFvS77pvIorIKfHJvoeZvyL+Z
         0w1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uMDrPDLSvrt+LZ/B1Dx4NYmfSQkR45XjEYJFwYsLOAs=;
        b=b1gbPe24AG5DS5778GPGCZ7oss6OvhYHNZdbXxaPoJTcov0pFk5yvXuwdcWhyu81dL
         i5I7+W1+GlU6AQqs4zM2BGKewSnCdnUmn+xIii7RBArfw7NtYEjz38i0q6/fncC5C/TC
         ykmz/TbAl1Pixu2svDgc8Ydj1jzv2fWmBkPCgCWoD48bB0ZjgZHpnN76y8/x2loQ6z/8
         eJTfqWniETa3H5wngkThIAp3YRA5y7rFRtbhmYIANCxuGLqE/FjQ4YGevSKpXIixRieD
         ENIpSHPatGjzVA6N0SfprrMeAcJI3vO8QoAtcPjUPTNpRDE+dwAL+eaF9Mjv8DRPEMDv
         YMVQ==
X-Gm-Message-State: ANhLgQ3pWjrW0Z3YpBxKiyEOl87p8j4dZMoSNDEBknp2f007S2iynWZl
        F51FX2jHt0jsDCOOee7q3lPOSEXm
X-Google-Smtp-Source: ADFU+vuAcu7m6NqT3jAF3+68t3/z50VMvvZ9ATI42Pr0pMLKCNB2S5RDAbddLDCFdlml92uQx+mI9Q==
X-Received: by 2002:a63:36ce:: with SMTP id d197mr507780pga.8.1583289225107;
        Tue, 03 Mar 2020 18:33:45 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g2sm26128201pgj.45.2020.03.03.18.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 18:33:44 -0800 (PST)
Date:   Wed, 4 Mar 2020 10:33:36 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Jeff Layton <jlayton@kernel.org>,
        Steve French <smfrench@gmail.com>,
        Murphy Zhou <jencce.kernel@gmail.com>,
        Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH v2] cifs: allow unlock flock and OFD lock across fork
Message-ID: <20200304023336.prhzqgheltlns2nd@xzhoux.usersys.redhat.com>
References: <20200221023001.vcoc5f43rdqqeifn@xzhoux.usersys.redhat.com>
 <20200226153941.xv7xsrh623zp3s7w@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226153941.xv7xsrh623zp3s7w@xzhoux.usersys.redhat.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Feb 26, 2020 at 11:39:41PM +0800, Murphy Zhou wrote:
> On Fri, Feb 21, 2020 at 10:30:01AM +0800, Murphy Zhou wrote:
> > Since commit d0677992d2af ("cifs: add support for flock") added
> > support for flock, LTP/flock03[1] testcase started to fail.

Ping on this one?

> > 
> > This testcase is testing flock lock and unlock across fork.
> > The parent locks file and starts the child process, in which
> > it unlock the same fd and lock the same file with another fd
> > again. All the lock and unlock operation should succeed.
> > 
> > Now the child process does not actually unlock the file, so
> > the following lock fails. Fix this by allowing flock and OFD
> > lock go through the unlock routine, not skipping if the unlock
> > request comes from another process.
> > 
> > Patch has been tested by LTP/xfstests on samba and Windows
> > server, v3.11, with or without cache=none mount option.
> 
> Also tested with or without "nolease" mount option. No new
> issue shows.
> 
> Thanks!
> > 
> > [1] https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/flock/flock03.c
> > Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> > ---
> >  fs/cifs/smb2file.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
> > index afe1f03aabe3..eebfbf3a8c80 100644
> > --- a/fs/cifs/smb2file.c
> > +++ b/fs/cifs/smb2file.c
> > @@ -152,7 +152,12 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
> >  		    (li->offset + li->length))
> >  			continue;
> >  		if (current->tgid != li->pid)
> > -			continue;
> > +			/*
> > +			 * flock and OFD lock are associated with an open
> > +			 * file description, not the process.
> > +			 */
> > +			if (!(flock->fl_flags & (FL_FLOCK | FL_OFDLCK)))
> > +				continue;
> >  		if (cinode->can_cache_brlcks) {
> >  			/*
> >  			 * We can cache brlock requests - simply remove a lock
> > -- 
> > 2.20.1
> > 
> > 
> 
> -- 
> Murphy

-- 
Murphy
