Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3ECC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Feb 2022 00:13:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiBNANt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 13 Feb 2022 19:13:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbiBNANt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 13 Feb 2022 19:13:49 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C1151E6A
        for <linux-cifs@vger.kernel.org>; Sun, 13 Feb 2022 16:13:42 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id bx31so20150750ljb.0
        for <linux-cifs@vger.kernel.org>; Sun, 13 Feb 2022 16:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UwvUse9y9j4tJu8PHCN610HJR4p+TqkgHOPOwX7TDLg=;
        b=H8MWCAeauBMqtErW1FSaOjYnOWGZqgL8qJlZ3tzYhtpw6P+Iz7zjbKMN+3KKGEAeLO
         vPIy35wtRqJx1SumF3zBGbRcPWgklUX6rLG1rxfaDEaew0b3WcSAcDHTXS3xkB5WZycg
         2faKoGIOYMWK/wEgIPw4ajqdgZPk7h6hGjxkyAe4NNdcUdxsGYNO/FVvZMybOfhN6AAa
         yoKEKbklqR2afhFH8gnovxsRAeMXD8iy3Lq7uTOVnSBonzSKJKq9UpY461W4qN3smQlD
         FFOLRaZrBy23RoAN2n3bWD2tOmp4BDkM942pusGt2rAdpfff4LbImBVFJGe8U+u9A5Jw
         ZYSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UwvUse9y9j4tJu8PHCN610HJR4p+TqkgHOPOwX7TDLg=;
        b=aw0i97I4LUHxxxj3fCYMQrFYySx8eOipWNykYQrhvwBLxRJMATPihpu3s4JqKg/E3+
         qS4lSCv9gQz5A+Z1np9qgznWsJFypSpsguCMb1qSPB0Q8YN65uLGjqy+j4komf+IZhm8
         eQ/RZ70S/h7bHBq/nk5ZkDJzk6Y+j2MZvQJMN7UWkbxtRyYeHvzRCCZL0M9ZzfOkDCmt
         BYjkUopgVlyDSMQZf+ZA8/TbawTXPiBRqPXz26e335MureCaXIaylt9RHzzPw1L++4FD
         nGilRqteOp+DRzUqOu0Czjk6ukBuGNcc+xYs9ZI8U6nFGtgZPIarYz7TL1LaRcNd3jDt
         ROaA==
X-Gm-Message-State: AOAM532vP+XMBi2ZpuVuax6SgQtkshBuBt7ulPwDk5SRlMfrxkHhjoaN
        TkNgVZbuYaRUmLb08MNC0VZI5qVrgWY7PXMsjjJHkKcn
X-Google-Smtp-Source: ABdhPJw4uQmCz7UlT1Ta3oTYhgPlUlFfcqLaCd3NrnEnmIF5lmMUjRVw2ByD2ZICGUa3ufXiPuNBEAMcYIm7IfnM2R0=
X-Received: by 2002:a2e:9c04:: with SMTP id s4mr7598755lji.229.1644797620694;
 Sun, 13 Feb 2022 16:13:40 -0800 (PST)
MIME-Version: 1.0
References: <20220213224052.3387192-1-lsahlber@redhat.com> <20220213224052.3387192-2-lsahlber@redhat.com>
In-Reply-To: <20220213224052.3387192-2-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 13 Feb 2022 18:13:29 -0600
Message-ID: <CAH2r5mtK6pgX31NN4yA0EbRm5nF+9mfu-1urjsEOU4OZejXjqQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: modefromsids must add an ACE for authenticated users
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next pending review and more testing

Ronnie,
Maybe we should add a small test for create file with modefromsid,
chmod the file, and then getcifsacl?

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
