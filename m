Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32829C54EE9
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 04:08:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbiITEI3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Sep 2022 00:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiITEI2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Sep 2022 00:08:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C35184D4DD
        for <linux-cifs@vger.kernel.org>; Mon, 19 Sep 2022 21:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663646905;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ID+2GbYEgbZtOFB9sx+1UICwKhNP3sdVuRwnTRhtJjI=;
        b=SKs1AW4NF4Op456d5M/y+AQD9FJSDZsvTsk0ZBspP6TEpuytif424DT2TZgCU178EH1p4B
        UhOaNAbSlshNEiXzGKspv8ebHT7oxGK21+1Rx1+PaO0oETSxF15Xs8yG1dj+HiTtt6qYdr
        xBSeQmSXnJXDl72nAZXMe89ylLSC9iQ=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-140-IsEYjSeUPgqReLqND22Biw-1; Tue, 20 Sep 2022 00:08:21 -0400
X-MC-Unique: IsEYjSeUPgqReLqND22Biw-1
Received: by mail-ot1-f70.google.com with SMTP id 14-20020a9d048e000000b0063936a5db40so711103otm.23
        for <linux-cifs@vger.kernel.org>; Mon, 19 Sep 2022 21:08:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ID+2GbYEgbZtOFB9sx+1UICwKhNP3sdVuRwnTRhtJjI=;
        b=EwvMY9KKT+x2L0ae1ya7yryvbO/1Ox53jQQ2pAbbm7hRpyefUQKnvkyESb/LQiDbqm
         swtIuCCTpqbuRn4udBhFVQ0vPgt0lf+CrJ+nwGex7lfKAW+53sOtYL+2AKcYCwYcWuoW
         050wC4yUkxO/P5Vahg7W0tagFsaG1OKZ58pkSG+xzf5Gee1a0/dqumHe9/hL/2sM+khC
         e/HWsumlVN5PsD0aLYjGLZlf+poihBAKLBl3Ta7vXVhKY62oexjVexGaSOkH02mIo8eM
         d+uJJNR+zBYywZdajq72VlU6PoQdjNzKofR1V/YD6nfLyczqxH4LFaz4JvWlUHLDTgkI
         2+jw==
X-Gm-Message-State: ACrzQf26kQKq4/RkiChQ61QSe+BZ3C/V5YyY9UxGFoQM3LQgsYff5xao
        ei2vwR/3IPU++mT0IjLzUlta/mW/nL5Sk2tNur6eWdVv9seRbbLN3c0UJUHJU4vzt6MumqJR8/l
        aItHN58FupRy8oZ3U/yg0WtedEhHpT0mWhS6YtQ==
X-Received: by 2002:a05:6870:2111:b0:122:5572:964d with SMTP id f17-20020a056870211100b001225572964dmr904487oae.1.1663646900970;
        Mon, 19 Sep 2022 21:08:20 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4sZFaffBDl7xbZjyfxHpkE4MA41XM/o11Xmaxhq/MSdZ2KOwXgvbGs+66hzE6AlVG93szserFUkUiXewxnLuc=
X-Received: by 2002:a05:6870:2111:b0:122:5572:964d with SMTP id
 f17-20020a056870211100b001225572964dmr904476oae.1.1663646900742; Mon, 19 Sep
 2022 21:08:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220919213759.487123-1-lsahlber@redhat.com> <20220919213759.487123-2-lsahlber@redhat.com>
 <5e836422-b132-b28b-af31-4cf7d02cc365@talpey.com>
In-Reply-To: <5e836422-b132-b28b-af31-4cf7d02cc365@talpey.com>
From:   Leif Sahlberg <lsahlber@redhat.com>
Date:   Tue, 20 Sep 2022 14:08:09 +1000
Message-ID: <CAGvGhF5+2PJbV4c5Aia8=jV5o-JNtEGmsvfYbHEo1+qOdMW1vg@mail.gmail.com>
Subject: Re: [PATCH] cifs: destage dirty pages before re-reading them for cache=none
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@cjr.nz>,
        Enzo Matsumiya <ematsumiya@suse.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Sep 20, 2022 at 11:43 AM Tom Talpey <tom@talpey.com> wrote:
>
> On 9/19/2022 5:37 PM, Ronnie Sahlberg wrote:
> > This is the opposite case of kernel bugzilla 216301.
> > If we mmap a file using cache=none and then proceed to update the mmapped
> > area these updates are not reflected in a later pread() of that part of the
> > file.
> > To fix this we must first destage any dirty pages in the range before
> > we allow the pread() to proceed.
> >
> > Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> > Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >   fs/cifs/file.c | 9 +++++++++
> >   1 file changed, 9 insertions(+)
> >
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index 6f38b134a346..1f3eb97ef4ab 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -4271,6 +4271,15 @@ static ssize_t __cifs_readv(
> >               len = ctx->len;
> >       }
> >
> > +     if (direct) {
> > +             rc = filemap_write_and_wait_range(file->f_inode->i_mapping,
> > +                                               offset, offset + len - 1);
> > +             if (rc) {
> > +                     kref_put(&ctx->refcount, cifs_aio_ctx_release);
> > +                     return rc;
>
> Are the possible return values from filemap_write_and_wait_range() also
> valid for returning from __cifs_readv()? It seems a bit odd to return
> write errors here.
>
> If not, then perhaps a more generic failure rc would be safer/more POSIX
> compliant?

Good point. Since an error here means we have dirty pages and
destaging them failed I guess -EAGAIN
would be the best to return. We want/need userspace to retry this,
possibly forever, in that scenario.

Steve, can you change the patch to -EAGAIN or do you want me to re-send it?

regards
ronnie s


>
> Tom.
>
> > +             }
> > +     }
> > +
> >       /* grab a lock here due to read response handlers can access ctx */
> >       mutex_lock(&ctx->aio_mutex);
> >
>

