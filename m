Return-Path: <SRS0=vQ6B=TH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB49BC004C9
	for <linux-cifs@archiver.kernel.org>; Tue,  7 May 2019 16:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EC4020825
	for <linux-cifs@archiver.kernel.org>; Tue,  7 May 2019 16:13:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QHZynWd2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbfEGQNr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 May 2019 12:13:47 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40358 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfEGQNr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 May 2019 12:13:47 -0400
Received: by mail-pl1-f196.google.com with SMTP id b3so8415476plr.7;
        Tue, 07 May 2019 09:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PvouaYjN3Arp+88+2ukjI7BrrRf9lUz+IEKElaRnfEQ=;
        b=QHZynWd2QYaXvolmJ2TVdMus1VL9YSL+KBfdl3oW1im3eGDEhHXcTHTPr5fHG5NHL1
         P1tPTJQBEplq5W+TrTmNGLR3sSvXrZ50RNK8G1LnVoDz5qp8NgfpfahuxzbByan1+1pl
         LoPJj8bmA6DTi50GOVFqXBA5053BgnXKVU7f3/+qfYOaQ5vlXWrqI4uIh1lhSR5qxe91
         0CISQFBxXzuC4yVEIuLmLpx0leHBOfPA6iiH35PNgFMbqvVMeDw36h7Hfbpw6Hp1ZM+T
         q12fZmmdaPk27jPyUqyyDXVRbIVNsT06SHTmIclL5L9eOR5+2l6jCXKmKSPs4VxFrB1H
         BkTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PvouaYjN3Arp+88+2ukjI7BrrRf9lUz+IEKElaRnfEQ=;
        b=YGhFQHxZE8Zg83BYKWnJWPjeAkk+jQgCmQ4iFxI4W+Q9KaqtfyK6Yo4VQbpseO+taN
         mOSDjryiHGO1eqxj4NysDDYWNHRdKT/nVO9jhM65/n9NqVr9N/80rNitn9RdZnevJjBH
         jzjhNAbsGwxtWBqtdxuCwhqgVIP8Nw0/xqIGjQvAakdcan4Ymi6s4Y9gHvLLp4Evn1oE
         e2ZSuQs2Sg15dss0MlXMHKugslnyfZWFAr2PsDIXetgcmueSDDhhFiaAifOUtQ8psPMI
         gztSyzDWTRwMVwD6/pi9Y20Y4uNpUdCpKqwlKGTUTD5fnHoVmBRw2Jo/SiZiKDAQHmS5
         cBmw==
X-Gm-Message-State: APjAAAX2MgFMKb9eGWn3q1wu+63tIr/2vNvp+6SYdNDr88/frJR+/zUJ
        6rGJNAUQcp8IrYF2sGt/Uhvxjh7ArX7XJdZgSf+nIQ==
X-Google-Smtp-Source: APXvYqzwej+/HPo7Bs6aRyGls46/1CQgiFLznL8JZhUc7dAFJOuirFsxCA42mxNCF1VwIn1EexS6Nu9rkXYKvnNMuEk=
X-Received: by 2002:a17:902:e00a:: with SMTP id ca10mr10539729plb.18.1557245626111;
 Tue, 07 May 2019 09:13:46 -0700 (PDT)
MIME-Version: 1.0
References: <1557242200-26194-1-git-send-email-kernel@probst.it>
In-Reply-To: <1557242200-26194-1-git-send-email-kernel@probst.it>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 7 May 2019 11:13:34 -0500
Message-ID: <CAH2r5mtqkHYbHJkf_LbAjhujnNRQP6Zmkmqhj1dUHomwsc3e=w@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: fix strcat buffer overflow and reduce raciness
 in smb21_set_oplock_level()
To:     Christoph Probst <kernel@probst.it>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, May 7, 2019 at 10:17 AM Christoph Probst via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Change strcat to strncpy in the "None" case to fix a buffer overflow
> when cinode->oplock is reset to 0 by another thread accessing the same
> cinode. It is never valid to append "None" to any other message.
>
> Consolidate multiple writes to cinode->oplock to reduce raciness.
>
> Signed-off-by: Christoph Probst <kernel@probst.it>
> ---
>  fs/cifs/smb2ops.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index c36ff0d..aa61dcf 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -2917,26 +2917,28 @@ smb21_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
>                        unsigned int epoch, bool *purge_cache)
>  {
>         char message[5] = {0};
> +       unsigned int new_oplock = 0;
>
>         oplock &= 0xFF;
>         if (oplock == SMB2_OPLOCK_LEVEL_NOCHANGE)
>                 return;
>
> -       cinode->oplock = 0;
>         if (oplock & SMB2_LEASE_READ_CACHING_HE) {
> -               cinode->oplock |= CIFS_CACHE_READ_FLG;
> +               new_oplock |= CIFS_CACHE_READ_FLG;
>                 strcat(message, "R");
>         }
>         if (oplock & SMB2_LEASE_HANDLE_CACHING_HE) {
> -               cinode->oplock |= CIFS_CACHE_HANDLE_FLG;
> +               new_oplock |= CIFS_CACHE_HANDLE_FLG;
>                 strcat(message, "H");
>         }
>         if (oplock & SMB2_LEASE_WRITE_CACHING_HE) {
> -               cinode->oplock |= CIFS_CACHE_WRITE_FLG;
> +               new_oplock |= CIFS_CACHE_WRITE_FLG;
>                 strcat(message, "W");
>         }
> -       if (!cinode->oplock)
> -               strcat(message, "None");
> +       if (!new_oplock)
> +               strncpy(message, "None", sizeof(message));
> +
> +       cinode->oplock = new_oplock;
>         cifs_dbg(FYI, "%s Lease granted on inode %p\n", message,
>                  &cinode->vfs_inode);
>  }
> --
> 2.1.4
>
>


-- 
Thanks,

Steve
