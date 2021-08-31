Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C411C432BE
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Aug 2021 18:06:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 524756109D
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Aug 2021 18:06:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbhHaSHt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Aug 2021 14:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230145AbhHaSHt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Aug 2021 14:07:49 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FC9C061575;
        Tue, 31 Aug 2021 11:06:53 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id w4so125828ljh.13;
        Tue, 31 Aug 2021 11:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4uoFy8lFPfOaRv20kXGYEUnEgHw1OP9Lm88Uu/BMnVE=;
        b=u1zPg1ZS36y+OJdwnG9hcpPsMVJIN/gOuB5RL3hnCHyd5TqigUN5AO9MKcJ8QrQ57f
         tihJTWu7OorM/pV7Ri9OHGMxCemm2s3jyILoDdCzS07iOmhoE/ct7C9O0wn7I83AEjEa
         ZgRgkBc6ND/hFiHUUT1KTE6GBf/oi/1bWz533CN421bo51io3jv79cxhSj62mYDfNTVi
         EtsJ1O5PIz03FeNvBbwEsBgGDVAgXGgVJWGP/eGF1hfScw4y4TF2Rxn1a+KwyEwQOb84
         LpqYpgqt7ZN3OD84pJHXjA6yx9/GcfT+7sJlnZ+RdmZOFFEXeXhGP2TrzPpinwoG7izs
         1RXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4uoFy8lFPfOaRv20kXGYEUnEgHw1OP9Lm88Uu/BMnVE=;
        b=VZt78c+RNmqkFxpSjcMIzFgb+00oRkJYqQgtJ7q/tBsyl1vV0LqwZuElkGWZgpOixm
         o1xR9pxMThecitlTay7ZlytENI1gtlv7eBSqE2wb2awNm4e/wuAM6pJU8zzThk6KCsLi
         qT3/hd7BHLdvXOrubGBF9Zn8NiRTO2CIROrkcIfrqwvuhOiDtNL1Sa93yTOnoV7LMQFs
         hfrHHIq+MAXq8Va+ILfTFFRjRUYYff1LmBA/pOxtjim1zazT2QJpW+DQrcCIf9Uuw6gd
         vsjTUfU7tk+dFUZXiC8o7oWBoWXj068rCjAJ2tnBvrUFe1nIrTJdbZmWW7xtEnufx+JI
         v9kg==
X-Gm-Message-State: AOAM53062wQkc0lxD8x6Ho1J9qmlCOYEWr7Zvy49KVpbk5O0tRYAn9P5
        ZJCcbVSsUH7nsox/Ir+j2bSp2V5iYVvpjpKWP+yLJTfg
X-Google-Smtp-Source: ABdhPJwHI/awRoxhF/yFyqZlpxqd+L2fpZ9GRmrzEMOYW6p5QGXjiKG/Ums/ZeYJAQVJprqmbAFf8ykZZvNpgGthLSo=
X-Received: by 2002:a2e:bb8f:: with SMTP id y15mr25733061lje.148.1630433212221;
 Tue, 31 Aug 2021 11:06:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvVdBoUW-0BfsxiRAE6X30cqhBtNDvG7pwKdQwsu+wXfg@mail.gmail.com>
 <CAHk-=wiNvB_j3VZYJ1yZqq+9JjgWCO1MUmRsjTKBwQ+x=kB5tg@mail.gmail.com>
 <CAH2r5mtTLUQa2U=MGHOVk_FsPZg6owMsw+RoTudWxGuoQej41g@mail.gmail.com> <CAHk-=wjxmDks6CS41PCy_BZG70pjAhcPBV_7ga8kSJySvvDezQ@mail.gmail.com>
In-Reply-To: <CAHk-=wjxmDks6CS41PCy_BZG70pjAhcPBV_7ga8kSJySvvDezQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 31 Aug 2021 13:06:41 -0500
Message-ID: <CAH2r5mt72NYan9q8MR5H8cNkYzT4jn1ZM1f3jp5V-fDs2cyB-A@mail.gmail.com>
Subject: Re: [GIT PULL] cifs/smb3 client fixes
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Aug 31, 2021 at 12:43 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, Aug 31, 2021 at 10:09 AM Steve French <smfrench@gmail.com> wrote:
> >
> >   So if you are ok with renaming the client dir and module
> > name - we can gradually stop using the word/name "cifs" except for the
> > parts of code which really are needed to access the (unfortunately
> > hundreds of millions of) very old devices which require SMB1 ("CIFS").
>
> I'm ok with directory renames, git handles it all well enough that the
> pain should be fairly minimal.
>
> I'd ask for that to be done during a fairly calm cycle, though, when
> there isn't a lot pending, so that any rename conflicts will be
> minimized.

Given likely movement of various common server/client functions into
cifs_common in the short term - we can delay renaming "fs/cifs"
(and fs/cifs_common) to e.g. "fs/smbfs" to 5.16 or 5.17


> > We could even build two versions of the module "smb3.ko" which does not
> > include support for the less secure legacy dialects and "cifs.ko" which does
> > include it.   Is there a precedent for something similar.
>
> I'm not sure there is precedent for that, but that's not a huge issue per se.

<snip>

> > Do you have any objections to me renaming the client's source
> > directory to "fs/smb3" (or fs/smb) and fs/smb3_common ...?
>
> So no objections to the rename per se, but can we please use a more
> specific name that is *not* tainted by history?
>
> I'll throw out two suggestions, but they are just that: (a) "smbfs" or
> (b) "smb-client".
>
> I think "smbfs" has the nice property of making it clear that this is
> just the filesystem part of the smb protocols - that otherwise cover a
> lot of other things too (at least historically printers, although I
> have no idea how true that is any more).

"smbfs" would likely be fine and I can bounce the idea around
others on Samba team etc.  And yes you are right, the broader
"SMB family of protocols" covers a lot of other functions
(from systems management, DCE/RPC, clustering, change notification,
named pipes, global name space ... not just files and printers) so "smbfs"
as a name for the client fs module going forward may be a bit less confusing.

> So if we rename, we should rename it to something new and slightly
> more specific than what we used to have.
>
> I'd rather have a module called "smbfs.ko" (or "smb-fs.ko" or
> "smb-client.ko" etc) than "smb.ko".

That should be easy enough (IIRC FreeBSD called their
module "smbfs), but presumably wait until 5.16 or 5.17
to lessen merge conflicts etc.


-- 
Thanks,

Steve
