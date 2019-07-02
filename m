Return-Path: <SRS0=Wa1n=VA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D26E9C06510
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Jul 2019 00:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93BB3219BE
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Jul 2019 00:30:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nAAAHHf5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfGCAaq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Jul 2019 20:30:46 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40287 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfGCAap (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Jul 2019 20:30:45 -0400
Received: by mail-pf1-f195.google.com with SMTP id p184so273178pfp.7;
        Tue, 02 Jul 2019 17:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t3kvAYxZ9YfB3CErs/a0pOWO4ZDaH45y/5BXSbrPysE=;
        b=nAAAHHf5Jhq0CPzmiVQ+diqs3YNFkJMpwWivvfs3Z3TeIdRyFEWlDUKogew+cbhhB4
         MuNhbAT5rEZQKQXWE4Z8DXIVx3jqoIVYiJqftA/B2m1oe+Nmfww6QVm8ARClFuZwalX3
         xGhV9BEeNzq7e7+0Jt0LfSvDBFEIw/aO7RvXX16XMJFXncbMFpmRGTKiEfXWnXmmBOwz
         v9tCNDgE7AyS25BrN3cxAJcIZHrg0eMfK/Yra3lEWDjnCbAXuI3NOSdTbAj8AnVgqPaH
         +vMwJUSzkOzdWQl2DyWy77wiuWDbr87YobkqS9PYQnNL8ON2MyQY0aAxIMtG7bkc1zHY
         C2HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t3kvAYxZ9YfB3CErs/a0pOWO4ZDaH45y/5BXSbrPysE=;
        b=Evjtu0ktXuHi14sXZ7POp4VnPgqGhOAuHEinAFAyTj/nJtN2iqEKuWT+sMEiFqWW4e
         KLUMteKUAvaREBX5Unnc9bfPYc93Tfl4rkpfCFWh5KIxVy8a7ZR7aWIIGNtIp3LIf5VP
         28nqy8T7HVjDzbwf8BVfg5lRKxcWzRf2j9eO5MNSx/nOWkPN7y+2KndxdS6v61KeKz/R
         7o4t5ZDP5YN2OzPbJtdIbdJpDDw6LimlxYYoDx1fQmR6EB8w5W3YK5s4MzCnJ8PUv0YA
         gK6f6p/Hddy1gCNpgYR7Cm+qoQkos0Z/Fq+JV0vOAMKygW9rbv+W7wb5d/28ce1GqEzL
         GS6Q==
X-Gm-Message-State: APjAAAUlj7c0PHUZCGYx3YoPmJF+7WcZYhbN7zp7R0r29HSUXoWiIqFM
        7C8hUQdYW7npKXZyemGwQmZ+Z95mwcn1SIuKHFuKj5Hd
X-Google-Smtp-Source: APXvYqzbHumWotK093sUi124dPGbA3soHvzWAIdlOwFN2MycCmHQQWsEBzSp3Ct0ygT1bevzBTdPflT84VNatn18ojU=
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr7742124pjb.138.1562102962310;
 Tue, 02 Jul 2019 14:29:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190702182001.GA11497@hari-Inspiron-1545>
In-Reply-To: <20190702182001.GA11497@hari-Inspiron-1545>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 2 Jul 2019 16:29:10 -0500
Message-ID: <CAH2r5mtrVbTP-iO6XebrXXL83aS80RDiYS7G4-FZC43-ieUk8w@mail.gmail.com>
Subject: Re: [PATCH] fs: cifs: cifsssmb: Change return type of convert_ace_to_cifs_ace
To:     Hariprasad Kelam <hariprasad.kelam@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Tue, Jul 2, 2019 at 1:20 PM Hariprasad Kelam
<hariprasad.kelam@gmail.com> wrote:
>
> Change return from int to void of  convert_ace_to_cifs_ace as it never
> fails.
>
> fixes below issue reported by coccicheck
> fs/cifs/cifssmb.c:3606:7-9: Unneeded variable: "rc". Return "0" on line
> 3620
>
> Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
> ---
>  fs/cifs/cifssmb.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 2ea2855..6228719 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -3600,11 +3600,9 @@ static int cifs_copy_posix_acl(char *trgt, char *src, const int buflen,
>         return size;
>  }
>
> -static __u16 convert_ace_to_cifs_ace(struct cifs_posix_ace *cifs_ace,
> +static void convert_ace_to_cifs_ace(struct cifs_posix_ace *cifs_ace,
>                                      const struct posix_acl_xattr_entry *local_ace)
>  {
> -       __u16 rc = 0; /* 0 = ACL converted ok */
> -
>         cifs_ace->cifs_e_perm = le16_to_cpu(local_ace->e_perm);
>         cifs_ace->cifs_e_tag =  le16_to_cpu(local_ace->e_tag);
>         /* BB is there a better way to handle the large uid? */
> @@ -3617,7 +3615,6 @@ static __u16 convert_ace_to_cifs_ace(struct cifs_posix_ace *cifs_ace,
>         cifs_dbg(FYI, "perm %d tag %d id %d\n",
>                  ace->e_perm, ace->e_tag, ace->e_id);
>  */
> -       return rc;
>  }
>
>  /* Convert ACL from local Linux POSIX xattr to CIFS POSIX ACL wire format */
> @@ -3653,13 +3650,8 @@ static __u16 ACL_to_cifs_posix(char *parm_data, const char *pACL,
>                 cifs_dbg(FYI, "unknown ACL type %d\n", acl_type);
>                 return 0;
>         }
> -       for (i = 0; i < count; i++) {
> -               rc = convert_ace_to_cifs_ace(&cifs_acl->ace_array[i], &ace[i]);
> -               if (rc != 0) {
> -                       /* ACE not converted */
> -                       break;
> -               }
> -       }
> +       for (i = 0; i < count; i++)
> +               convert_ace_to_cifs_ace(&cifs_acl->ace_array[i], &ace[i]);
>         if (rc == 0) {
>                 rc = (__u16)(count * sizeof(struct cifs_posix_ace));
>                 rc += sizeof(struct cifs_posix_acl);
> --
> 2.7.4
>


-- 
Thanks,

Steve
