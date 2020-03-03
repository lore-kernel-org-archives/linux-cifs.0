Return-Path: <SRS0=S2CZ=4U=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEEBEC3F2D1
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Mar 2020 23:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C386208C3
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Mar 2020 23:13:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sFDL1Os+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbgCCXNj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Mar 2020 18:13:39 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:45402 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbgCCXNi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 Mar 2020 18:13:38 -0500
Received: by mail-il1-f193.google.com with SMTP id p8so154140iln.12;
        Tue, 03 Mar 2020 15:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vJr9ys90m3qSyzdRvYFeDv9aPSWThVfEBslU4+ThXWc=;
        b=sFDL1Os+uBZQJw2DKQ45Pscc95zk/o7Pif1zFFOBmxFHXvfyeAzrsTPB4xr5psDlQD
         bo0h/xAmnf1Vn1ScoDL+Rhjb/l0hYfysV1tc/vpKJ9EeAGV1CFaWPrG9D+a47ZwMy7FA
         EYCIUAovLySxlND1MNLDCVZdtQSGs0YAo9jkBWxduyeWBp63A19cioCnhkIMn3JsaKuT
         k4mjYsDiAYeHQXGFxRpiK5WevUk0QKLgYoAQrXayG1B0ySJ9iw4rQC/9TNjm7jeI92ZK
         6unXM7Xs6KGGCiiZwLY7LCta22CMqbdyMCHda7byprmPTFrecITvRyAlMkSgL6tnoJhY
         g+wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vJr9ys90m3qSyzdRvYFeDv9aPSWThVfEBslU4+ThXWc=;
        b=TR5F4R5KrxrqnuB+YsMYcBgUVqHaiYysJL02+vv6HBrXYNQ4FDlM+tlN+SuqWYbpRF
         xRoinnibt2n6xdMLdWYms5iKIxJgT8YSXDVxdkOJBME9eH4fx8MyNznn1Gie8kohXGg7
         VUXq2h6mIYt2KvBTkYqF2/qvUZUjjX+94oNPPcacdXx13SjZMd0Fa3JSRJGm89IRUOPs
         +p5Qd8DgfxzSgKW3DAXMAeFZq3TI3Lcn2jjvuqGNCwD8zXlIthLnaSRejdtHls92oxzb
         /6zF/7SblQ121wWEMaYeQXpioNu6uBNlKFZB7mHC3AuNYlKW38HBPZwe36FSWAHW84lD
         J6Zw==
X-Gm-Message-State: ANhLgQ2thvEpDu/bn0HYgnG+SfNhnQdsrXU/OamZW+wBP2aHNarqbq7P
        OckIjiyqo874ARkqI9VbCzwH6sQ+EyucQLV2YcM=
X-Google-Smtp-Source: ADFU+vsJ5YxHdGJDCIliHS6azGp7tdBPmIDmqC93Lr/zUfX6A3lFuYLTCzBQsXPBBOTWY7YkTKZtry+cCY/6luzo89Q=
X-Received: by 2002:a92:ce02:: with SMTP id b2mr98748ilo.70.1583277218119;
 Tue, 03 Mar 2020 15:13:38 -0800 (PST)
MIME-Version: 1.0
References: <1583250197-10786-1-git-send-email-hqjagain@gmail.com> <CAH2r5mv2VrSBT_MvUNjd=h354v=29htRQdLSEZi+pDtdggNfoQ@mail.gmail.com>
In-Reply-To: <CAH2r5mv2VrSBT_MvUNjd=h354v=29htRQdLSEZi+pDtdggNfoQ@mail.gmail.com>
From:   Qiujun Huang <hqjagain@gmail.com>
Date:   Wed, 4 Mar 2020 07:13:27 +0800
Message-ID: <CAJRQjocK1XtvtH_CiCpkR2uFMb8bBg0pEuTGM2hGqhs4qk4KbA@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs/cifsacl: fix sid_to_id
To:     Steve French <smfrench@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Mar 4, 2020 at 4:13 AM Steve French <smfrench@gmail.com> wrote:
>
> Doesn't rc = 0 have to be set earlier (preferably in the declaration
> on line 345)?
>
> since line 392 does
>             goto got_valid_id;
> which appears to leave rc unitialized with your change
>
ok, I noticed that fall back to using the mnt_uid/mnt_gid.

Should we remove the variable 'rc'. It is set but not used. And I was
confused last time. (:

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 716574a..1cf3916 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -342,7 +342,6 @@
 sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
                struct cifs_fattr *fattr, uint sidtype)
 {
-       int rc;
        struct key *sidkey;
        char *sidstr;
        const struct cred *saved_cred;
@@ -403,7 +402,6 @@
        saved_cred = override_creds(root_cred);
        sidkey = request_key(&cifs_idmap_key_type, sidstr, "");
        if (IS_ERR(sidkey)) {
-               rc = -EINVAL;
                cifs_dbg(FYI, "%s: Can't map SID %s to a %cid\n",
                         __func__, sidstr, sidtype == SIDOWNER ? 'u' : 'g');
                goto out_revert_creds;
@@ -416,7 +414,6 @@
         */
        BUILD_BUG_ON(sizeof(uid_t) != sizeof(gid_t));
        if (sidkey->datalen != sizeof(uid_t)) {
-               rc = -EIO;
                cifs_dbg(FYI, "%s: Downcall contained malformed key
(datalen=%hu)\n",
                         __func__, sidkey->datalen);
                key_invalidate(sidkey);
