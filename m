Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0880C433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Apr 2022 03:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbiDND3e (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Apr 2022 23:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiDND3d (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Apr 2022 23:29:33 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FD84D9CC
        for <linux-cifs@vger.kernel.org>; Wed, 13 Apr 2022 20:27:10 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id b24so4699585edu.10
        for <linux-cifs@vger.kernel.org>; Wed, 13 Apr 2022 20:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PE9+NfU+sBlUIbU7hBOez9PF8TpoQJYautqyKfcMZCE=;
        b=ZN2FzZ4zfMfx0qcvl+SfuOVTphVSywBoS3ElDj+4gDhAl0s5y/3zkEd5urco+WNqHn
         ghvsrHFQBZn/5NivLQLQXGBON6JoLSb2ry/deWY8ydMou0tdgYyom1pq/S/qHIzZYoxL
         F7sMVyb43C+RId0UAD6SwrdiPmf1OOJhxHSzNV8WVx444p7E26Wxj/ZD9+W47hqfFjnA
         VnNCE9CvgXoOqfpu/5LLUD4nzBRby3ErXqR2WOjZBpiTFF8hzN/C/b0KoBbKDviw7Xlm
         76NCMKxf9nefyGAiMcA6vsLSWkry3FZLxhpyGLMV5UxtigQw7fM+wEOmLjNAkAQiwsZo
         I/Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PE9+NfU+sBlUIbU7hBOez9PF8TpoQJYautqyKfcMZCE=;
        b=wNTbaIhnmmZOTnSW3aRwLovUlVk2X7lxzgxzX8IL4AfbxFv/EJyrQpCA+YBzlaXITf
         y9qIpS+Y+od/qKEdbsC6DVVq8PCNZDA8R/wVtXKFVB+okx+fYM0a2p+mKRPEnZQQgin2
         oUmfrNy/9RyxmOLPWLVfdS/wsVHedmRPdm8Zmt9RsnpidxbdlcuiAroRKHoR9Yq+tSNY
         hEpatPlI6VDt4t6Zewlk71JUQ0PFz1yU/6JVZlxk6jGTAb5NdT2hQDKW2OMPTqBEvsBV
         QL34RLDyFwDAOowsixYu14y6UF0WP/g/brdMOmEfgh5zXhyECj2s/7XRsMDDRfhUWd9w
         tSPw==
X-Gm-Message-State: AOAM530fxL9aqCYBfR3K1//L6IDvfzv13S9HNxrWaN8rMva6gIQWZyda
        oNCFnzyNkyrI5FPj727MFAuANJ0MXkJzcukuZpfu3sDqtYMKGQ==
X-Google-Smtp-Source: ABdhPJyf19fbpxKYAzrWe8k/hVaR3kaCVoACsf3T0k0RmGyYt7ypg+rxYenydxArv5dJ7wsvuJvdOpJUieP09BN6wmg=
X-Received: by 2002:a05:6402:510c:b0:419:3fe5:15f with SMTP id
 m12-20020a056402510c00b004193fe5015fmr787921edd.274.1649906828607; Wed, 13
 Apr 2022 20:27:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220413000217.1609615-1-lsahlber@redhat.com>
In-Reply-To: <20220413000217.1609615-1-lsahlber@redhat.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 14 Apr 2022 08:56:57 +0530
Message-ID: <CANT5p=qNPjYNjBjOk-QHJxhLNRKgHJOXnVqqUTQZK3+Od8RBTw@mail.gmail.com>
Subject: Re: [PATCH] cifs: verify that tcon is valid before dereference in cifs_kill_sb
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Apr 13, 2022 at 7:06 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> On umount, cifs_sb->tlink_tree might contain entries that do not represent
> a valid tcon.
> Check the tcon for error before we dereference it.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsfs.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index aba0783a8f09..25719b70564a 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -266,10 +266,11 @@ static void cifs_kill_sb(struct super_block *sb)
>          * before we kill the sb.
>          */
>         if (cifs_sb->root) {
> -               node = rb_first(root);
> -               while (node != NULL) {
> +               for(node = rb_first(root); node; node = rb_next(node)) {
>                         tlink = rb_entry(node, struct tcon_link, tl_rbnode);
>                         tcon = tlink_tcon(tlink);
> +                       if (IS_ERR(tcon))
> +                               continue;
>                         cfid = &tcon->crfid;
>                         mutex_lock(&cfid->fid_mutex);
>                         if (cfid->dentry) {
> @@ -277,7 +278,6 @@ static void cifs_kill_sb(struct super_block *sb)
>                                 cfid->dentry = NULL;
>                         }
>                         mutex_unlock(&cfid->fid_mutex);
> -                       node = rb_next(node);
>                 }
>
>                 /* finally release root dentry */
> --
> 2.30.2
>

The changes look good to me.
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>

Does this cover all the mount failure scenarios, Ronnie?

-- 
Regards,
Shyam
