Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E185C432BE
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Aug 2021 19:18:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EEAB60EFE
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Aug 2021 19:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243488AbhHZTTX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Aug 2021 15:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243494AbhHZTTV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 Aug 2021 15:19:21 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B617C061757
        for <linux-cifs@vger.kernel.org>; Thu, 26 Aug 2021 12:18:33 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id h1so7024841ljl.9
        for <linux-cifs@vger.kernel.org>; Thu, 26 Aug 2021 12:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MnXDnvEa5pEjcGJwfJwz1IjuV9YT7XSsO+QYPYQmxDc=;
        b=FOEjJTucJIEKxg3dOfHww9vmbh9JsU697XKlCHDJ14oPPkaQzS2nxkSxSkvWg1ewxf
         zfPyyJoc8J/of0wuzRqVbpbeiHP6G1l2WFzNHoMWdVp0jJMEKInp+hZComiMyF9HJ1Q5
         mVipWSunEm5Sjl5YAHD98UtJHGnmyU7Ddqql/u/0XoS+r4SmWxv0lnnXo2bQdOqMfb96
         J0LMvINqtI80NiYOYFKGRgn8kQFdg0DTptHCDM2cjjZbWjERyxF9q+pDlVn7VekiBdjm
         DnYaRTqnEtjdkT2VyjQxp4Q6soOdFT/I5VzAN2gQ8LcfDnADPRhsMjB9RcRkWxnpyVUm
         Pogg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MnXDnvEa5pEjcGJwfJwz1IjuV9YT7XSsO+QYPYQmxDc=;
        b=mCE8gC9wQv4XhiPsuqT+pCFYrzAu7YMWVbyiQlkVFgWg9BFnLB3unnAiOnaYpkUrLf
         gBMivt+NmuFMXj/SFuzTuSC1JeTTpYh08mKN0I3HL8/WyJvSK3mx73S7q9YgBID4nLhk
         HRphIe9tsM9srLOU78U2fO8qUr8D+7Ze0hjdnTEsXvIA6dyWwRk4ceGBWBUvMkSflKuI
         DZ+TOT9grW5wtIFNQfQNbybaer78agiuNCZ85/OZk19JBDdsb5CKfOBSFglbgnlQ2I5I
         OHFYpsB+qHA7jj+ZRu8Oh38nchQHWxyQkSq4fMjgd1AUwGOUC8RXgUZkB7hLKGFJFEHd
         hzCw==
X-Gm-Message-State: AOAM533RIf67sezPsR6ILIRS5+6t8fADxmIT8YFi49G+khqG5koWLxJ+
        L+w5ZZtQB/dppOlyzF0Dl9/ozq9qQolb0V/FhRYJ4T0x
X-Google-Smtp-Source: ABdhPJxizp3kaB5ykUW3hD278EHuu5rdnHi2d61KXLQ82SsFNvUyXuFq7KPxYnJv824+E5HmyQlyLa/pyL4vQ0498IE=
X-Received: by 2002:a2e:8e62:: with SMTP id t2mr4462929ljk.477.1630005511739;
 Thu, 26 Aug 2021 12:18:31 -0700 (PDT)
MIME-Version: 1.0
References: <bec6e1554ba990330cf812050f4b43feda92aeb9.camel@tjernlund.se> <CAN05THRp0AcQvgn2ro-0M12i90FMnQfBCo7AFbf1qQCF2dtUjQ@mail.gmail.com>
In-Reply-To: <CAN05THRp0AcQvgn2ro-0M12i90FMnQfBCo7AFbf1qQCF2dtUjQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 26 Aug 2021 14:18:20 -0500
Message-ID: <CAH2r5mtCefKR2sqspkjGS6kg0D5YKvwi0Xz=j+4xbf8542OFVQ@mail.gmail.com>
Subject: Re: CIFS version 1/2 negotiate ?
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Tjernlund <tjernlund@tjernlund.se>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, Aug 26, 2021 at 1:35 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Wed, Aug 25, 2021 at 9:49 PM Tjernlund <tjernlund@tjernlund.se> wrote:
> >
> > We got an old netapp server which exposes CIFS vers=1 and when trying to mount shares
> > from this netapp we get:
> > CIFS: VFS: \\netapp2 Dialect not supported by server. Consider  specifying vers=1.0 or vers=2.0 on mount for accessing older servers
> > CIFS: VFS: cifs_mount failed w/return code = -95
> >
> > If I specify vers=1 manually on the mount cmd it works.
> > However, GUI file managers cannot handle this and less Linux savy users don't know how to
> > use the mount cmd manually.
> >
> > I wonder if kernel could grow a SMB1 version negotiate so a standard CIFS mount can work?
> > We are at kernel 5.13 and I can test/use a kernel patch.
>
> I don't think we can do that in the client.  We are all trying to move
> away from SMB1, and a lot of servers already today
> have it either disabled by default or even removed from the compile.
> So enabling automatic multi-protocol support for SMB1 is the wrong
> direction for us.
>
> For that reason I think there will also be pushback from GUI
> filemanagers to add a "smb1 tickbox", but you can try.
>
> Other solutions could be to locally hack and replace mount.cifs with a
> patch to "detect if servername matches the old netapp and
> automatically add a vers=1 to the mount argument string passed to the
> kernel".
> It would require you to build a patched version of cifs-utils and
> distribute to all the client machines though, so ...
You could do a small mount.cifs pass through script that adds
"vers=1.0" and then calls the real mount.cifs ... might also be able
to put the mount options in /etc/fstab with vers=1.0

-- 
Thanks,

Steve
