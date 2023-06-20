Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DEA5EB64D8
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Jun 2023 07:52:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbjFTHwN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Jun 2023 03:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbjFTHv6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Jun 2023 03:51:58 -0400
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BA91991
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jun 2023 00:51:24 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2b479d53d48so25482071fa.1
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jun 2023 00:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687247405; x=1689839405;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cwL3unHAQPDl4hIu4mbqjua7QkjE7rzQol4DZum6iXw=;
        b=S6RlnC+Rd2YboWmh0x25ztmuF/RpHjl01ks5YsxXlwWJM8NydNZE3esfD+Iz06t+te
         NVRJW330l0G187GdwaSEusyQgxOvfm/fBBlXgm4W2NIfWWUVkGmdq+XjMke0Bi6aZFKs
         dUI3vI5UYZrTFwY4ZhzjMqQGeICHqNfO3pLsdJHU9eUlRUqGginasR9D8lOjnZc+c/5D
         VH2qBL7DbSvZtxf6HtSJqe3Ixi4qLN7j94F5AnRut5gxzgUWXCdg/3E640nCiUAKOtxC
         2nLQ7XxJZKt46txFOtV7+JuI/SY8PEP8IynM49U6yI7W0cxrmZYOwDKSfRF938mcDDR6
         Uqyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687247405; x=1689839405;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cwL3unHAQPDl4hIu4mbqjua7QkjE7rzQol4DZum6iXw=;
        b=BRvjom48PWUwvQ5aEkzodQBSTD2qE/f3YYxOjEUsA87zCNm7eUq191pXWNxGUup9gh
         VSSv1An6u2i8xDLwIj11yegWsgtwbOetcqJLf6aSij8pMifKwVU53i+deCZqXvzFbZdG
         8PhnD88kS+DsOl4KPOcSXA96JG5IutB/nnYaOuXrASpYkf9UzfyXdFSLoiSySNIGQEb7
         uxxntm9kuZQOCKyLHGdKEX3/k/Otc+HJY7ND/imHBO3EYE6jdV5gX1ftsUU5vqhJdh1q
         Kg5zd+GYZLzaEtUwiBUGe8iCDEopHfKre6nlJX8JwmCa6FNq70LQkktSJScBsb1avrOc
         JxLQ==
X-Gm-Message-State: AC+VfDxoiX5OZhSetIi9EI89TyggTiilI6OVpIwlWdyJd6tn2g65UGqh
        0yFr0L0cKVbaHUcLnVO7caxyIDQ6ZMSsTGFZrhhCZvKjBNE=
X-Google-Smtp-Source: ACHHUZ4QTD1lVSGOnyGBlHPj3yaoCoY4WnmMf04TfnAxyzomhj7hMWQz1EKMuArrVYIcTkVGWoEqiuMJO6vl9Wt1e7A=
X-Received: by 2002:a2e:94c1:0:b0:2b1:ac82:296 with SMTP id
 r1-20020a2e94c1000000b002b1ac820296mr6864586ljh.34.1687247405118; Tue, 20 Jun
 2023 00:50:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvpS+XPMe_taXe7W8fc2GaG9eKVMXtUZQPg3AzY-QKdMg@mail.gmail.com>
In-Reply-To: <CAH2r5mvpS+XPMe_taXe7W8fc2GaG9eKVMXtUZQPg3AzY-QKdMg@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 20 Jun 2023 13:19:54 +0530
Message-ID: <CANT5p=pMzN_bNWNKCYfq6FUWcq_PKKM3QK3roiva4ksim6Pt9A@mail.gmail.com>
Subject: Re: [SMB CLIENT][PATCH] print more detail when invalide_inode_pages fails
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Jun 20, 2023 at 7:22=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
>     We had seen cases where cifs_invalidate_mapping was logging:
>        "Could not invalidate inode ..."
>     if invalidate_inode_pages2 fails but this message does not show what
>     the rc is.  Update the logged message to also log the return code.
>
>     Suggested-by: Shyam Prasad N <sprasad@microsoft.com>
>
> (see attached)
>
> --
> Thanks,
>
> Steve

Looks good to me.

--=20
Regards,
Shyam
