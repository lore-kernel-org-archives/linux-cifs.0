Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 722DDC4361B
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 06:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 250D12313F
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 06:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733264AbgLLGBz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Dec 2020 01:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgLLGBs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 12 Dec 2020 01:01:48 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99879C0613CF
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 22:01:07 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id h19so16915352lfc.12
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 22:01:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ARbCF+lpCVaMl56G991jWAFTbkzyHdwBoH6nSF4ptS0=;
        b=ezIUULhB7sCOYqJQz/+VXB044Bozk9uGR3vdOlTIfaErAbIl/1yPg1TpjH/9hXGdUr
         En5BUfH7vYFORklnkHHlo3y2PPzu+aYCtP9sjCwJZ2Yf1RGd7AguoFSmqtXm/7Y4tq/f
         pofqgBXCEZCXA81MJTP/ueb7MOJnn7oqw4lHbI1oLmaXq5BVj910E2wjh184RJNBwO4W
         GKn62N114xle4xvAwacwXR7NhqpcXcPhRQy6u2MWV6CpLF9JByQMmcDd0G/n8nr7lBUv
         Axug/+VttpHVn0EN6+IXJYAhAfapXWMRkgBAeG6TXGoebNoR97+/JLEVEej3tEaqS9LZ
         s2WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ARbCF+lpCVaMl56G991jWAFTbkzyHdwBoH6nSF4ptS0=;
        b=HMdoQsrJa2Sj3cwRpAM2HuQs66UHtDbOhhhqrSSuA8tKiUVULI02I3nYu+dOQ3PF7r
         iG4m9Sl2qJ1+cvZSZXWwdGdsUefIAbqayiT5RR2KxGbGdozgiJwQDnwUfSVmFeVTErhk
         lP1b/2lps5WnuEHGFVpUwqizai1xDxdXAKxvVJn2+F+dxn/xTEF+Nc2quxfXBulkClM0
         6p5djCLQzNEECtXbnUbMYtaeM8w9v/7DNo8OMvmKvSW0rLZiFD27MzMTZjAlStrRQBpl
         U9+Vwh6hCka0Bxs4ZxMCYiNrr24nBTxx1HoayevNkt/MNm93BD4FOGt6agWcekBL3jZs
         zZ1w==
X-Gm-Message-State: AOAM530bCTO4bwx+oTSqV5R1kmWJusSoCuVygh1xqQ5eKeRp3QJ/YGaD
        uqZAZGEvR0AiV8Y4SR31qwkdWx1D30/EISUjxAlsHcxtuZ8=
X-Google-Smtp-Source: ABdhPJyJljee9L8v5end0PaRDrpvc6HeKqPHSPveMnivqIY6QC656j6shy3p4EOrBnudgg0A4fuZYcbPZ3iiRSTZPzo=
X-Received: by 2002:a2e:87cb:: with SMTP id v11mr6250980ljj.218.1607752866086;
 Fri, 11 Dec 2020 22:01:06 -0800 (PST)
MIME-Version: 1.0
References: <20201130180257.31787-1-scabrero@suse.de> <20201130180257.31787-9-scabrero@suse.de>
In-Reply-To: <20201130180257.31787-9-scabrero@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 12 Dec 2020 00:00:54 -0600
Message-ID: <CAH2r5mu5Tqy_NTBXNgjjKWUXHyCO-befGT6DCwDdJGGtuQ+FuQ@mail.gmail.com>
Subject: Re: [PATCH v4 08/11] cifs: Send witness register messages to
 userspace daemon in echo task
To:     Samuel Cabrero <scabrero@suse.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next. Let me know if any
changes need to be made to it

On Mon, Nov 30, 2020 at 12:06 PM Samuel Cabrero <scabrero@suse.de> wrote:
>
> If the daemon starts after mounting a share, or if it crashes, this
> provides a mechanism to register again.
>
> Signed-off-by: Samuel Cabrero <scabrero@suse.de>
> ---
>  fs/cifs/cifs_swn.c | 15 +++++++++++++++
>  fs/cifs/cifs_swn.h |  2 ++
>  fs/cifs/connect.c  |  5 +++++
>  3 files changed, 22 insertions(+)
>
> diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
> index 140a53a19aa0..642c9eedc8ab 100644
> --- a/fs/cifs/cifs_swn.c
> +++ b/fs/cifs/cifs_swn.c
> @@ -540,3 +540,18 @@ void cifs_swn_dump(struct seq_file *m)
>         mutex_unlock(&cifs_swnreg_idr_mutex);
>         seq_puts(m, "\n");
>  }
> +
> +void cifs_swn_check(void)
> +{
> +       struct cifs_swn_reg *swnreg;
> +       int id;
> +       int ret;
> +
> +       mutex_lock(&cifs_swnreg_idr_mutex);
> +       idr_for_each_entry(&cifs_swnreg_idr, swnreg, id) {
> +               ret = cifs_swn_send_register_message(swnreg);
> +               if (ret < 0)
> +                       cifs_dbg(FYI, "%s: Failed to send register message: %d\n", __func__, ret);
> +       }
> +       mutex_unlock(&cifs_swnreg_idr_mutex);
> +}
> diff --git a/fs/cifs/cifs_swn.h b/fs/cifs/cifs_swn.h
> index 13b25cdc9295..236ecd4959d5 100644
> --- a/fs/cifs/cifs_swn.h
> +++ b/fs/cifs/cifs_swn.h
> @@ -20,4 +20,6 @@ extern int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info);
>
>  extern void cifs_swn_dump(struct seq_file *m);
>
> +extern void cifs_swn_check(void);
> +
>  #endif /* _CIFS_SWN_H */
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 7fbb201b42c3..a298518bebb2 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -613,6 +613,11 @@ cifs_echo_request(struct work_struct *work)
>                 cifs_dbg(FYI, "Unable to send echo request to server: %s\n",
>                          server->hostname);
>
> +#ifdef CONFIG_CIFS_SWN_UPCALL
> +       /* Check witness registrations */
> +       cifs_swn_check();
> +#endif
> +
>  requeue_echo:
>         queue_delayed_work(cifsiod_wq, &server->echo, server->echo_interval);
>  }
> --
> 2.29.2
>


-- 
Thanks,

Steve
