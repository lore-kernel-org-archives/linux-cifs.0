Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 782F1C433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Dec 2021 14:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhLHOsl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 Dec 2021 09:48:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbhLHOsl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 8 Dec 2021 09:48:41 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1387C061746
        for <linux-cifs@vger.kernel.org>; Wed,  8 Dec 2021 06:45:08 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id u80so2618884pfc.9
        for <linux-cifs@vger.kernel.org>; Wed, 08 Dec 2021 06:45:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zsky/SImT4uldRT10XDmxx67FpXPJPw2EiqrddSCfA4=;
        b=XXs86iAQcpnSiDP8uLJdJhVrdy1g7bvBlOt2QnENhKAz6+ocalZzg+c2ommwpJB0Fd
         sXdFk6QJJWRj64oz4VFPycIW4ofOTLOhGKd42ifL/uP9A6clkyxDRxmfAANvnINijdcP
         nkURWOYwE4ch8ReWfMuU/a4vtBsezEBYZ1Gn3UKAfGbvsYD3f7uyFTSccNh+PjDvVCvX
         r1dTYgDjQqniS/Y7BHzJG+uGKBnSfNboLV1CZqB/f+WbwAXAzV3IXpBUojBYUCZhl5HY
         WGJoKcsE6PZcFytLaCtfK/c5xte1ZRmmxSLcaqBq3SaxeD74Lgog4SyvKsdZxv8BUTju
         rlwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zsky/SImT4uldRT10XDmxx67FpXPJPw2EiqrddSCfA4=;
        b=PN6oOrEywsUd9CHXSnv9WkRlOPNODIYUM5yP406blPb4ASi/aNCY45KVIHnPMJueKQ
         ZrYqZQatfD5dqf02g5FOFyqfiHyGKTE/FMcZGsOu6i6aC6n4LsNI0iZnsLNlZbLJobLl
         dEN32XHV82oa36CXSscrJnKiBGEI7+d3z/qKHAFb2ZkkR+Bd67H+dVFqga/gggVY9EG5
         t6E0PcL5DmvYsiJAa+HW0J+L2jmzgIGYSLMWN6+Ik0b0Obo0C8YZPKCcQYtFtUxGa9ev
         +me0C3O1eOeXi3tDJ3ir+9kt8umOmfcRyerh9yJVBdXVLjUBPEuObtE4W9BJw4saQmzn
         Zc+A==
X-Gm-Message-State: AOAM530J3vzzmzUrJeopcf96fXC7MeZimCtUYxm6dlRtE+FnPUHkc2AS
        Uz/a207VYi7Gu0bgXBmXQDvpdOFBQAp702Q9m3g=
X-Google-Smtp-Source: ABdhPJxc9cTDpHs08QVitQUMjgdgvv2YzEHQg7VXhoJnZm5HfFqj3S9MqMfDZ9Mcj5uBqJK725+RUAiLGePH+urT03Q=
X-Received: by 2002:a63:b50a:: with SMTP id y10mr26513587pge.596.1638974708424;
 Wed, 08 Dec 2021 06:45:08 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=qXbQU4g4VX=W9mOQo1SjMxnFGfpkLOJWgCpicyDLvt-w@mail.gmail.com>
 <1355654.1638798741@warthog.procyon.org.uk>
In-Reply-To: <1355654.1638798741@warthog.procyon.org.uk>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 8 Dec 2021 20:14:56 +0530
Message-ID: <CANT5p=ogoa2ndAs5n5zzy4+NR-T6tyKmyB_1xQyqw6BTgBaXtw@mail.gmail.com>
Subject: Re: [PATCH] cifs: wait for tcon resource_id before getting fscache super
To:     David Howells <dhowells@redhat.com>
Cc:     Jeff Layton <jlayton@redhat.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        linux-cachefs@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Dec 6, 2021 at 7:22 PM David Howells <dhowells@redhat.com> wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> > @@ -1376,6 +1376,13 @@ struct inode *cifs_root_iget(struct super_block *sb)
> >   inode = ERR_PTR(rc);
> >   }
> >
> > + /*
> > + * The cookie is initialized from volume info returned above.
> > + * Inside cifs_fscache_get_super_cookie it checks
> > + * that we do not get super cookie twice.
> > + */
> > + cifs_fscache_get_super_cookie(tcon);
>
> Ummm...  Does this handle the errors correctly?  What happens if rc != 0 at
> this point and the inode has been marked failed?  It looks like it will
> abandon creation of the superblock without cleaning up the super cookie.
> Maybe - or maybe it can't happen because of the:
>
>         iget_no_retry:
>                 if (!inode) {
>                         inode = ERR_PTR(rc);
>                         goto out;
>                 }
>
> check - but then why is rc being checked?
>
> > +
> >  out:
> >   kfree(path);
> >   free_xid(xid);
>
> David
>

Thanks David. I think that there still needs to be more error handling here.
I'll check on this and send out another patch.

-- 
Regards,
Shyam
