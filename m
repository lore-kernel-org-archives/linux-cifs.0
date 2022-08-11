Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC3DFC25B0D
	for <linux-cifs@archiver.kernel.org>; Thu, 11 Aug 2022 16:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238856AbiHKQhe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 11 Aug 2022 12:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239276AbiHKQgq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 11 Aug 2022 12:36:46 -0400
Received: from mail-ua1-x931.google.com (mail-ua1-x931.google.com [IPv6:2607:f8b0:4864:20::931])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6794642DA
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 09:12:10 -0700 (PDT)
Received: by mail-ua1-x931.google.com with SMTP id cd25so4657835uab.8
        for <linux-cifs@vger.kernel.org>; Thu, 11 Aug 2022 09:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc;
        bh=O6b3n5uGy9zRrd2m55zAW6wYSw9+03kJDNpTw2XE+VE=;
        b=hN1YPZHEwXCkvjrQmP/eRxoKzniPpMbHY2QObPp6cigqykONBMufFkNB/XXGqCJjP4
         6HUt+SZ5517OPFP4pNri8fv3ZkN0FBHDcCFSB7EOpATstWFYHzgbfDd8s3/6VEoC6hwS
         uqYTPSKrYo9nYVf6KOQeYIHNBN7s9dKoGODNb1oxCD95bcRhwO4fi2wOGfJeCYCHT4o8
         QNXQEV0VeukbNgUk2C6pH7i0EK3RX0M3BdwJrnWEJHEim1tRs9O3OT0WLdHk3825TWZX
         2s+9bJJAytBROmv6WwbWN4//j7mKTDYFiwktHqxbUhKfwUvD9ZWGroNgnwigAQ7g9mgC
         n+0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc;
        bh=O6b3n5uGy9zRrd2m55zAW6wYSw9+03kJDNpTw2XE+VE=;
        b=SE7Zp/Kw+NDZfcV0Zflp1w22HOukKwxli3MmnCjngmh2xk1d/8WkrmyK+mz5a7cJ3N
         RKlM4jmYzCOajYcObdOl5aBSNDAL4lWZoCFsGS65Ypd1pFQxVKzBZL+qfIuIEii7Kad1
         pJ3EodipVgaMaBJSQTrL6WJhZUUBRFfl9d0GAUnwSs+T2El28BZ7eHbkWAwtp7UfebDz
         xUKBlAN30U7V8U+k8nkOKeDtQWDj4FMM1SlKhZmKnddslryaCaX6PhxImgw6SgFJY/F/
         NMceWZHmFAmZnR8rGo4IPN7n3K0jF9cqg6TRn5bLXMgZqo6Gir48L8cPMYZdDqeko/cI
         /MLw==
X-Gm-Message-State: ACgBeo2GmbwDaHmcfmvWTVc2/qCCgLw86hQrKeBbDZqkSjLAssPvilaU
        KgQ9WtmHM1uqWUAU+niXghV/ig2dWOSgPxoAlfc=
X-Google-Smtp-Source: AA6agR401Njc3AQQ+WIR5J+1iIy0cAkFHQJwUZDiL4z5iCfBhunapVXUXIA40Vw1dfi3+c7OpegD6/hVIepDDNZ071I=
X-Received: by 2002:ab0:3f0c:0:b0:383:f357:9c02 with SMTP id
 bt12-20020ab03f0c000000b00383f3579c02mr15123344uab.19.1660234329572; Thu, 11
 Aug 2022 09:12:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msJ6=LfoyGWyi94o+Z1FcJFdxpcLyPRz9K9gK5SpvPCUQ@mail.gmail.com>
 <87zggasr6o.fsf@cjr.nz>
In-Reply-To: <87zggasr6o.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 11 Aug 2022 11:11:58 -0500
Message-ID: <CAH2r5mviEtcCQa1Pbyf6OeQKQ8dzJrK+BQE61qaGk6rQUaGH4A@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] allow deferred close timeout to be configurable
To:     Paulo Alcantara <pc@cjr.nz>, Bharath S M <bharathsm@microsoft.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        rohiths msft <rohiths.msft@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Will fix the typos thanks.

There are a couple of minor differences from Bharath's earlier patch e.g.

"closetimeo" rather than "dclosetimeo" (I am ok if you prefer the longer name),
and also this mount option is printed in list of mount options if set.


On Thu, Aug 11, 2022 at 11:03 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Steve French <smfrench@gmail.com> writes:
>
> > Deferred close can be a very useful feature for very safely
> > allowing caching data for read, and for minimizing the number
> > of reopens needed for a file that is repeatedly opened and
> > close but there are workloads where its default (1 second,
> > similar to actimeo/acregmax) is too small.
> >
> > Allow the user to configure the amount of time we can
> > defer sending the final smb3 close when we have a
> > handle lease on the file (rather than forcing it to depend
> > on 1 second or actimeo which is often unrelated).
> >
> > Adds new mount parameter "closetime=" which is the maximum
>                             ^^^^^^^^^ should be closetimeo
>
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index 945fb083cea7..af6114e17fb5 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -693,6 +693,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
> >               seq_printf(s, ",acdirmax=%lu", cifs_sb->ctx->acdirmax / HZ);
> >               seq_printf(s, ",acregmax=%lu", cifs_sb->ctx->acregmax / HZ);
> >       }
> > +     if (cifs_sb->ctx->closetimeo != cifs_sb->ctx->acregmax)
> > +             seq_printf(s, ",closetimeo=%lu", cifs_sb->ctx->closetimeo / HZ);
>
> Hrm - I think you can rid of this check.  I'd rather print it out
> unconditionally.
>
> > diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
> > index 5f093cb7e9b9..927a5f2f9919 100644
> > --- a/fs/cifs/fs_context.h
> > +++ b/fs/cifs/fs_context.h
> > @@ -125,6 +125,7 @@ enum cifs_param {
> >       Opt_actimeo,
> >       Opt_acdirmax,
> >       Opt_acregmax,
> > +     Opt_closetimeo,
> >       Opt_echo_interval,
> >       Opt_max_credits,
> >       Opt_snapshot,
> > @@ -247,6 +248,8 @@ struct smb3_fs_context {
> >       /* attribute cache timemout for files and directories in jiffies */
> >       unsigned long acregmax;
> >       unsigned long acdirmax;
> > +     /* timeout for deferred close of files in jiffies */
>                                                   ^^^^^^^ seconds
>
> Otherwise, looks good to me.
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>



--
Thanks,

Steve
