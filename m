Return-Path: <SRS0=c9dP=4G=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06CC8C34031
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Feb 2020 23:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD64222B48
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Feb 2020 23:26:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cFcnUf4f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgBRX0b (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Feb 2020 18:26:31 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:36653 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbgBRX0b (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Feb 2020 18:26:31 -0500
Received: by mail-il1-f195.google.com with SMTP id b15so18899230iln.3
        for <linux-cifs@vger.kernel.org>; Tue, 18 Feb 2020 15:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4RFYWOrcn8+ES/ygkiLPNvgn1Vv9uEoSv0huInrgs9g=;
        b=cFcnUf4frLSntwDmyz+SFv9vN5bjc+og3jJX2rtP9+jeP/7IP4NJkCZnpoRMd3Se+d
         ybIixi81GMOwd95lRK+1IwpfpMUlax4fOf9l+LWV/TlLvcPXrdFiyAMGbCpns6AI/icv
         lofsF8UezUNc35LiV9E+D1ug4oiuYVtIOsOg2ELCSdQDlKW9RGvwkYqYZqaiv8Zjg+Bu
         LPFzHEVztVk0eFyz8V6b8Y6tlySIQHD8+PlS9HJRl2ofGEis1YSo+w5NQasu2RCK7lcf
         TQP7pjg8NGfRIjO4erzYz/GqZaV7dHDad9cMwZ7p1hXsCS0OH3DYR7kFKKKXK250xh1i
         c17Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4RFYWOrcn8+ES/ygkiLPNvgn1Vv9uEoSv0huInrgs9g=;
        b=RiBy8ZFX+acSGgjvDYqTor8kDbtfQZ+43Bu514b7W0SRF2VF9P6mB+mj9R+F0KVWsU
         OpVFRARVWktvdoiWjxV7o0RZMSWkdY5+bXbcvoR5e/IT4jX3Y0OUcEf96GE/OtFrCZrR
         RXA+KFxA0j9Un4DzmHtmU++sR0pPPZ2vOU7WP2riygnHRizER6ekX6QxQdtxXdAKPuhq
         GtZxQ4Bo3YMFGgX6+rxwX58nekDkKA7meD87NOWFzzEPIdMY/YYwTyIw2esuogNuOd/K
         VQCHwqc5Zi/7a2E7j90kxhWLA/9swrOFKSzX8qBvyT/fi4Ox+WoOcgQCotqTqo11gA/o
         p73g==
X-Gm-Message-State: APjAAAVjyrO/dwS1LAf+OYg/B+8vSrqHG0JR+kOo9rQc3/V4os2w5EOo
        bz977VnPVPQXb2CimiRAu14eifVP61OmVk/ZBCo=
X-Google-Smtp-Source: APXvYqzqk2LWVip1tls3wVWqxHoNS+na11DmoJNIZWjCaNVU//A1Ok6oTuJKUWqCGsCEk8uu8RkwW9T5POr3OR7rxmY=
X-Received: by 2002:a92:9f1b:: with SMTP id u27mr22021414ili.173.1582068390303;
 Tue, 18 Feb 2020 15:26:30 -0800 (PST)
MIME-Version: 1.0
References: <20200218200103.12574-1-lsahlber@redhat.com>
In-Reply-To: <20200218200103.12574-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 18 Feb 2020 17:26:19 -0600
Message-ID: <CAH2r5mvXp_KvT5CmpmsbNbb2bVD+qKRu22QPw3_KTq38UURFTA@mail.gmail.com>
Subject: Re: [PATCH] cifs: don't leak -EAGAIN for stat() during reconnect
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, Feb 18, 2020 at 2:07 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> If from cifs_revalidate_dentry_attr() the SMB2/QUERY_INFO call fails with an
> error, such as STATUS_SESSION_EXPIRED, causing the session to be reconnected
> it is possible we will leak -EAGAIN back to the application even for
> system calls such as stat() where this is not a valid error.
>
> Fix this by re-trying the operation from within cifs_revalidate_dentry_attr()
> if cifs_get_inode_info*() returns -EAGAIN.
>
> This fixes stat() and possibly also other system calls that uses
> cifs_revalidate_dentry*().
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/inode.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index b5e6635c578e..1212ace05258 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -2073,6 +2073,7 @@ int cifs_revalidate_dentry_attr(struct dentry *dentry)
>         struct inode *inode = d_inode(dentry);
>         struct super_block *sb = dentry->d_sb;
>         char *full_path = NULL;
> +       int count = 0;
>
>         if (inode == NULL)
>                 return -ENOENT;
> @@ -2094,15 +2095,18 @@ int cifs_revalidate_dentry_attr(struct dentry *dentry)
>                  full_path, inode, inode->i_count.counter,
>                  dentry, cifs_get_time(dentry), jiffies);
>
> +again:
>         if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
>                 rc = cifs_get_inode_info_unix(&inode, full_path, sb, xid);
>         else
>                 rc = cifs_get_inode_info(&inode, full_path, NULL, sb,
>                                          xid, NULL);
> -
> +       if (is_retryable_error(rc) && count++ < 10)
> +               goto again;
>  out:
>         kfree(full_path);
>         free_xid(xid);
> +
>         return rc;
>  }
>
> --
> 2.13.6
>


-- 
Thanks,

Steve
