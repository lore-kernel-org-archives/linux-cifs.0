Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 315ACC433DB
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 21:46:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 065D364EE1
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Feb 2021 21:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbhBIVov (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Feb 2021 16:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbhBIUj1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Feb 2021 15:39:27 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E23BC0698C0
        for <linux-cifs@vger.kernel.org>; Tue,  9 Feb 2021 12:06:10 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id w36so16703030lfu.4
        for <linux-cifs@vger.kernel.org>; Tue, 09 Feb 2021 12:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MGC00U/HTrtqydk9z5KHQicSX2U/6RNp0JEbXDL4cbY=;
        b=Tb6m+K3HZW76bdsjYApINK9m2LDk221e2SfreuFuP+1hOiMeKJrlfzqKA70H7uiGuV
         AhX3cFx07TszJpQw4Jb6BMWlxtLHIgzmqxLPraDEDS41cJXoQmom5btN0crBYusdL3Op
         FFvP08skk7v9J5/3R62otrbDPa7K5MpHgu5Sdl+Cf6v9iqaOsAlrj5/v9y+kpCl/MO/s
         dOr5YcFfvxGdsGfrGe8tXR4z21pb6HqPj5KJMPwGost0b4fi4HFevCfovpBp13oa7Ag3
         J1atlJCJuXR0G5+FgDdEDirDvHMP/HNLufixUaVl4gjOzacYgx3un2deQpm/KBXHXwTk
         ZPwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MGC00U/HTrtqydk9z5KHQicSX2U/6RNp0JEbXDL4cbY=;
        b=Xw9z8fO3ZwnAntDuGRkZI+ERZRQdQROB1O1TqfWW4+SnY7bF/INzcY/KMR4SZdTkOq
         TAVD9itcabqYV56c7CkSuC+fc02Wd7z6v1+5/O6jnHN7x4nUIAxOoya+2EUYr6sNwX8c
         SK6TUkqFG2042H29E6PslXVKh2fNM21snE3ooQDyk1ihkZXti8AOaVkta04yOpAqlshC
         Qu4YBc6d0K64rr0GRKpdUU4hQUn8yqNz33xecll+d50ZJ8ay4ukOPf6rIPmM68vCuGZp
         RhPFGvVqzKcOZJUBAMlpcnRK3/E+6lqQBQqXVeAWlREnd8gsZ9aE6Qh6VFCu4os1HPCC
         Y9sQ==
X-Gm-Message-State: AOAM532NlxiMoDGizcfCzwQxODO3QEHE2tYNbvKSoyv9JgclfrskHu6q
        iFcoJ6v+IANqxeFR7nDGBLdbKMyWyhciRr/HkDcKhgyYsY4u3g==
X-Google-Smtp-Source: ABdhPJx3kDAorhvXPu7Dk6B7MCn4Dbhe6eVdPFkxi7OemTCvVXiDHccngjvZXzl3bZNySUJy2tpEm5Y5p4lEitkSQqE=
X-Received: by 2002:a19:910e:: with SMTP id t14mr9522499lfd.282.1612901168779;
 Tue, 09 Feb 2021 12:06:08 -0800 (PST)
MIME-Version: 1.0
References: <CANT5p=qrx1bKAcJGG=hGBkvwHjQWLgTH3kJ+g-YdZL0yfBtA9A@mail.gmail.com>
 <87mtwkno7q.fsf@suse.com> <CANT5p=qeEBwivE_Fc-Y4gj17d9nkU+ROPnZL=0BD3v_yRNBFtA@mail.gmail.com>
 <87blctmqo0.fsf@suse.com> <CAKywueRd1u_7F6qRkSRCtg5exPeNBSXANUiFTrUfcigJGMeP3Q@mail.gmail.com>
In-Reply-To: <CAKywueRd1u_7F6qRkSRCtg5exPeNBSXANUiFTrUfcigJGMeP3Q@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 9 Feb 2021 14:05:57 -0600
Message-ID: <CAH2r5msowQaXTi+3K0UeyFdVVzHz_LLk-Cdr5XBANYz6SmqymQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] cifs: New optype for session operations.
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Feb 9, 2021 at 1:58 PM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 50fcb65920e8..1a1f9f4ae80a 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1704,7 +1704,8 @@ static inline bool is_retryable_error(int error)
>  #define   CIFS_ECHO_OP      0x080    /* echo request */
>  #define   CIFS_OBREAK_OP   0x0100    /* oplock break request */
>  #define   CIFS_NEG_OP      0x0200    /* negotiate request */
> -#define   CIFS_OP_MASK     0x0380    /* mask request type */
> +#define   CIFS_SESS_OP     0x2000    /* session setup request */
> +#define   CIFS_OP_MASK     0x2380    /* mask request type */
>
> Why skipping 0x400, 0x800 and 0x1000 flags?

They were already reserved.  See cifsglob.h

#define   CIFS_HAS_CREDITS 0x0400    /* already has credits */
#define   CIFS_TRANSFORM_REQ 0x0800    /* transform request before sending */
#define   CIFS_NO_SRV_RSP    0x1000    /* there is no server response */



-- 
Thanks,

Steve
