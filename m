Return-Path: <SRS0=HMAP=TG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92257C04A6B
	for <linux-cifs@archiver.kernel.org>; Mon,  6 May 2019 16:57:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 654E7205ED
	for <linux-cifs@archiver.kernel.org>; Mon,  6 May 2019 16:57:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samba.org header.i=@samba.org header.b="QotzqNtj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfEFQ5E (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 May 2019 12:57:04 -0400
Received: from hr2.samba.org ([144.76.82.148]:38120 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbfEFQ5E (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 6 May 2019 12:57:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42627210; h=Message-ID:Cc:To:From:Date;
        bh=sIeWRsQrjfl5uiGG2Afv8XyEcWfXKzvrjMXyJwlUSgs=; b=QotzqNtjAKaav33thlCTI2Hwte
        bjtFIAyRnHZa2j1wF9E4CcF3LQGfrLiNrlrCgiilCXSUgs72o7eyyI5nhqw5thxFGNSVXC925r6cL
        zvTKkzRBoNhCu4M5Q62OQ0EnAORwq4FV820kgcWxrVAlcq7gfht/07poI8M0Aal5ui/s=;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1hNgvF-0007UB-DL; Mon, 06 May 2019 16:57:01 +0000
Date:   Mon, 6 May 2019 09:56:58 -0700
From:   Jeremy Allison <jra@samba.org>
To:     Steve French <smfrench@gmail.com>
Cc:     Christoph Probst <kernel@probst.it>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cifs: fix strcat buffer overflow in
 smb21_set_oplock_level()
Message-ID: <20190506165658.GA168433@jra4>
Reply-To: Jeremy Allison <jra@samba.org>
References: <1557155792-2703-1-git-send-email-kernel@probst.it>
 <CAH2r5mtdpOvcE25P2UuNFpOwsNyFiBWRQELQFui+FJGVOOBV8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mtdpOvcE25P2UuNFpOwsNyFiBWRQELQFui+FJGVOOBV8w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, May 06, 2019 at 11:53:44AM -0500, Steve French via samba-technical wrote:
> I think strcpy is clearer - but I don't think it can overflow since if
> R, W or W were written to "message" then cinode->oplock would be
> non-zero so we would never strcap "None"

Ahem. In Samba we have :

lib/util/safe_string.h:#define strcpy(dest,src) __ERROR__XX__NEVER_USE_STRCPY___;

Maybe you should do likewise :-).

> On Mon, May 6, 2019 at 10:26 AM Christoph Probst <kernel@probst.it> wrote:
> >
> > Change strcat to strcpy in the "None" case as it is never valid to append
> > "None" to any other message. It may also overflow char message[5], in a
> > race condition on cinode if cinode->oplock is unset by another thread
> > after "RHW" or "RH" had been written to message.
> >
> > Signed-off-by: Christoph Probst <kernel@probst.it>
> > ---
> >  fs/cifs/smb2ops.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index c36ff0d..5fd5567 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -2936,7 +2936,7 @@ smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
> >                 strcat(message, "W");
> >         }
> >         if (!cinode->oplock)
> > -               strcat(message, "None");
> > +               strcpy(message, "None");
> >         cifs_dbg(FYI, "%s Lease granted on inode %p\n", message,
> >                  &cinode->vfs_inode);
> >  }
> > --
> > 2.1.4
> >
> 
> 
> -- 
> Thanks,
> 
> Steve
> 
