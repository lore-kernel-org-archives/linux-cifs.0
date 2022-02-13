Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FF97C433F5
	for <linux-cifs@archiver.kernel.org>; Sun, 13 Feb 2022 23:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238819AbiBMXrT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 13 Feb 2022 18:47:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbiBMXrS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 13 Feb 2022 18:47:18 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19C8751E4B
        for <linux-cifs@vger.kernel.org>; Sun, 13 Feb 2022 15:47:12 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id be32so1557830ljb.7
        for <linux-cifs@vger.kernel.org>; Sun, 13 Feb 2022 15:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FqKcYte9o6iPfTdeapjGwq/aivR7PK9Pwf+EwCHDC4E=;
        b=VfeMBhrbFylPo9qDv787OmX9yqaUdZAyymYIHrXr3tKHh7KLh9YG5ooMj2QBa3mxEz
         hspt+ifQLSc1w40hdjkxY9+Ws7rd1U+4ptdospDA7yXq0h6g/pHugCZQlu3VeKZae5B8
         m/U5Xpw7KwpTWnirBcrO+D0BmZpREjrwoYzLTp3Uo4pcr/q+8tYBTyo7te05XPODtnYt
         H7dszHMguJXxrukBkNXLEP4YfLRp4wWJWmWBPDOiz5S0dbrY0jnQ0lgM3x/hDvAMJyDI
         VCeomcasJCkGeW++F7kSq7/ZBbOeTY3qxMPJh2AoKcKxylImILDghTvSOKUEh6SYT462
         uiZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FqKcYte9o6iPfTdeapjGwq/aivR7PK9Pwf+EwCHDC4E=;
        b=fiGy7aRt4NMpZWkkShTd41W6nmZPdsLrYa3XukwjhRwR6pJpHmizTBLmIPkKJUTTBx
         9n4Kmq+uMYbOJAK+waQ1lKHfbjpMCaYEuSLTFRa6qBJ6aKtOv1e9Z+8GTo9R/04dU06j
         80ZQdcANL9mmVrMXZQ+wxfAzQPdTk4N5VhUZRULlH8ES8aenZDoLN5Wm6Xb9rJGwlxI+
         TOG+GDn1EjvbP7gkuSeaVv3T4vTx6KDG0+MnB0++4P7+qw2nsrwVhtb8wXTKLylMSV+g
         ofYxQNHQp4SqW7LsFDxjYNqVp7yfO51gKx9c/h8Dap5ljcQsCylh8AaE2XKLXy/bal5A
         ob/Q==
X-Gm-Message-State: AOAM530DuEDsznWXgpZqRFxF+V/nVL5SyuizC3JajjtZeESa5WnoUrYi
        lhhNOub0JLG+uGAJZ8AuMJg1KVjQ4PRi4tqwEAA=
X-Google-Smtp-Source: ABdhPJwismsRT3uVtE0W6iW4h4OKGySwS+wh6thxzDNAkQJ5ZrByA4MDGVN9Z+0XLTnDd3j2wU4a1QAzqMZ4ARN8Pnc=
X-Received: by 2002:a05:651c:104e:: with SMTP id x14mr7430860ljm.23.1644796030241;
 Sun, 13 Feb 2022 15:47:10 -0800 (PST)
MIME-Version: 1.0
References: <20220213224052.3387192-1-lsahlber@redhat.com> <20220213224052.3387192-2-lsahlber@redhat.com>
In-Reply-To: <20220213224052.3387192-2-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 13 Feb 2022 17:46:59 -0600
Message-ID: <CAH2r5ms+mW2ujPBObv4MbSe2VkXwthwVqJYQjd75MmyAU1YC-w@mail.gmail.com>
Subject: Re: [PATCH] cifs: modefromsids must add an ACE for authenticated users
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Should I add:
   cc:Stable # 5.12+

Thoughts?

On Sun, Feb 13, 2022 at 4:41 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> When we create a file with modefromsids we set an ACL that
> has one ACE for the magic modefromsid as well as a second ACE that
> grants full access to all authenticated users.
>
> When later we chante the mode on the file we strip away this, and other,
> ACE for authenticated users in set_chmod_dacl() and then just add back/update
> the modefromsid ACE.
> Thus leaving the file with a single ACE that is for the mode and no ACE
> to grant any user any rights to access the file.
> Fix this by always adding back also the modefromsid ACE so that we do not
> drop the rights to access the file.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsacl.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index ee3aab3dd4ac..40cda87ce384 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -949,6 +949,9 @@ static void populate_new_aces(char *nacl_base,
>                 pnntace = (struct cifs_ace *) (nacl_base + nsize);
>                 nsize += setup_special_mode_ACE(pnntace, nmode);
>                 num_aces++;
> +               pnntace = (struct cifs_ace *) (nacl_base + nsize);
> +               nsize += setup_authusers_ACE(pnntace);
> +               num_aces++;
>                 goto set_size;
>         }
>
> @@ -1613,7 +1616,7 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
>         nsecdesclen = secdesclen;
>         if (pnmode && *pnmode != NO_CHANGE_64) { /* chmod */
>                 if (mode_from_sid)
> -                       nsecdesclen += sizeof(struct cifs_ace);
> +                       nsecdesclen += 2 * sizeof(struct cifs_ace);
>                 else /* cifsacl */
>                         nsecdesclen += 5 * sizeof(struct cifs_ace);
>         } else { /* chown */
> --
> 2.30.2
>


-- 
Thanks,

Steve
