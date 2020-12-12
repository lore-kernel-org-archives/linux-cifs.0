Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 630B1C433FE
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 05:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28C75207B0
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 05:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388835AbgLLF6m (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Dec 2020 00:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgLLF6P (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 12 Dec 2020 00:58:15 -0500
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2B8C0613CF
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 21:57:34 -0800 (PST)
Received: by mail-lf1-x142.google.com with SMTP id l11so16984452lfg.0
        for <linux-cifs@vger.kernel.org>; Fri, 11 Dec 2020 21:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6ke4M6qYQUrPB3Ltom9n7Z+DAm2gNRVxabjNNtKO8O0=;
        b=aHzG8U3sWKHidjQxTAtr9YqXXVBdxgrxlmrR+Q/SJ9v39i+UBFUW71kb8zA8JgJAZv
         TrXbnp2fSQecGUsVhpw3X1mq2J/dYHcLPdbVK07WFG4EQbeo7gYBPBiYRl58j6RQfFya
         YWrcv8amRQUWEyJKnl2VD8GpM3esnF+FUS9oatXIPzlMbOiKqgK5TpV6mf+SheyJALXX
         yJVOqxLWcJLQAXjU4p6yLtfpOm8cNIAC836Hcy9/D85ImrNbeK58uD/rd74SRHTlBmRc
         Cmmhl+bCqYpKhEFsRNoKV05D0nobe6Q4TnXPC5EdbTmEV/LVbLRtODrS+3zmaOCWvfMv
         b2Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6ke4M6qYQUrPB3Ltom9n7Z+DAm2gNRVxabjNNtKO8O0=;
        b=qJtVRlHIj+WhRJub5k0d3sO5N1jIpYcXM2PaOBrCd4wKMyqH78+xUCbCSUNU4Pnqzg
         Fm91B3wmZ6tCgIWTHesU5Eok0blcBhHpsOvjvbH2152kFwS7RUEP48TQ3lYMcngjfeXP
         CBfXgCwFPFB8ckQ+XIvuY1i41By0f5c338lAsmT2+M3msnRsNJuuiVMV5AEB+TK8WcQM
         Q1w6IPtn0vyJpReuk8FPrr+HlDViwhKdzTt1tcvLQLidkikaQ8KZMIZjkhJIXic03PKj
         sCJ7SfL+39MdTX7iC3zLegbCJEfKXzZSICxxRirQSJCCVmbZOvg5hjhXs22TEr1OIaLX
         7uCw==
X-Gm-Message-State: AOAM530ddcpQdYGNK+ukkjSENYQ9PzguZ+DysxwclrVELFMxpIzPOG8X
        bS2x542YjFFlHOrDjmpG5MJBJLnnb3YA+29y5is=
X-Google-Smtp-Source: ABdhPJztQvobahPyH1Zcq/9pD6KR6DejAPN5gKW+fPpHM6e5KEcqvh+0dBoekVea5YC3kccqNCZtT0pcOXAv+khlp6I=
X-Received: by 2002:a19:950:: with SMTP id 77mr5481186lfj.133.1607752652867;
 Fri, 11 Dec 2020 21:57:32 -0800 (PST)
MIME-Version: 1.0
References: <20201130180257.31787-1-scabrero@suse.de> <20201130180257.31787-8-scabrero@suse.de>
In-Reply-To: <20201130180257.31787-8-scabrero@suse.de>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 11 Dec 2020 23:57:21 -0600
Message-ID: <CAH2r5mvrokWepaVVFwK+P-nWBjifjHDA5chZjGDMFpn4gw0=TA@mail.gmail.com>
Subject: Re: [PATCH v4 07/11] cifs: Add witness information to debug data dump
To:     Samuel Cabrero <scabrero@suse.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next, let me know if any
changes needed to be made to it.

On Mon, Nov 30, 2020 at 12:05 PM Samuel Cabrero <scabrero@suse.de> wrote:
>
> + Indicate if witness feature is supported
> + Indicate if witness is used when dumping tcons
> + Dumps witness registrations. Example:
>   Witness registrations:
>   Id: 1 Refs: 1 Network name: 'fs.fover.ad'(y) Share name: 'share1'(y) \
>     Ip address: 192.168.103.200(n)
>
> Signed-off-by: Samuel Cabrero <scabrero@suse.de>
> ---
>  fs/cifs/cifs_debug.c | 13 +++++++++++++
>  fs/cifs/cifs_swn.c   | 35 +++++++++++++++++++++++++++++++++++
>  fs/cifs/cifs_swn.h   |  2 ++
>  3 files changed, 50 insertions(+)
>
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 53588d7517b4..b231dcf1d1f9 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -23,6 +23,9 @@
>  #ifdef CONFIG_CIFS_SMB_DIRECT
>  #include "smbdirect.h"
>  #endif
> +#ifdef CONFIG_CIFS_SWN_UPCALL
> +#include "cifs_swn.h"
> +#endif
>
>  void
>  cifs_dump_mem(char *label, void *data, int length)
> @@ -115,6 +118,10 @@ static void cifs_debug_tcon(struct seq_file *m, struct cifs_tcon *tcon)
>                 seq_printf(m, " POSIX Extensions");
>         if (tcon->ses->server->ops->dump_share_caps)
>                 tcon->ses->server->ops->dump_share_caps(m, tcon);
> +#ifdef CONFIG_CIFS_SWN_UPCALL
> +       if (tcon->use_witness)
> +               seq_puts(m, " Witness");
> +#endif
>
>         if (tcon->need_reconnect)
>                 seq_puts(m, "\tDISCONNECTED ");
> @@ -262,6 +269,9 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>         seq_printf(m, ",XATTR");
>  #endif
>         seq_printf(m, ",ACL");
> +#ifdef CONFIG_CIFS_SWN_UPCALL
> +       seq_puts(m, ",WITNESS");
> +#endif
>         seq_putc(m, '\n');
>         seq_printf(m, "CIFSMaxBufSize: %d\n", CIFSMaxBufSize);
>         seq_printf(m, "Active VFS Requests: %d\n", GlobalTotalActiveXid);
> @@ -462,6 +472,9 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>         spin_unlock(&cifs_tcp_ses_lock);
>         seq_putc(m, '\n');
>
> +#ifdef CONFIG_CIFS_SWN_UPCALL
> +       cifs_swn_dump(m);
> +#endif
>         /* BB add code to dump additional info such as TCP session info now */
>         return 0;
>  }
> diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
> index 63b0764af5d5..140a53a19aa0 100644
> --- a/fs/cifs/cifs_swn.c
> +++ b/fs/cifs/cifs_swn.c
> @@ -505,3 +505,38 @@ int cifs_swn_unregister(struct cifs_tcon *tcon)
>
>         return 0;
>  }
> +
> +void cifs_swn_dump(struct seq_file *m)
> +{
> +       struct cifs_swn_reg *swnreg;
> +       struct sockaddr_in *sa;
> +       struct sockaddr_in6 *sa6;
> +       int id;
> +
> +       seq_puts(m, "Witness registrations:");
> +
> +       mutex_lock(&cifs_swnreg_idr_mutex);
> +       idr_for_each_entry(&cifs_swnreg_idr, swnreg, id) {
> +               seq_printf(m, "\nId: %u Refs: %u Network name: '%s'%s Share name: '%s'%s Ip address: ",
> +                               id, kref_read(&swnreg->ref_count),
> +                               swnreg->net_name, swnreg->net_name_notify ? "(y)" : "(n)",
> +                               swnreg->share_name, swnreg->share_name_notify ? "(y)" : "(n)");
> +               switch (swnreg->tcon->ses->server->dstaddr.ss_family) {
> +               case AF_INET:
> +                       sa = (struct sockaddr_in *) &swnreg->tcon->ses->server->dstaddr;
> +                       seq_printf(m, "%pI4", &sa->sin_addr.s_addr);
> +                       break;
> +               case AF_INET6:
> +                       sa6 = (struct sockaddr_in6 *) &swnreg->tcon->ses->server->dstaddr;
> +                       seq_printf(m, "%pI6", &sa6->sin6_addr.s6_addr);
> +                       if (sa6->sin6_scope_id)
> +                               seq_printf(m, "%%%u", sa6->sin6_scope_id);
> +                       break;
> +               default:
> +                       seq_puts(m, "(unknown)");
> +               }
> +               seq_printf(m, "%s", swnreg->ip_notify ? "(y)" : "(n)");
> +       }
> +       mutex_unlock(&cifs_swnreg_idr_mutex);
> +       seq_puts(m, "\n");
> +}
> diff --git a/fs/cifs/cifs_swn.h b/fs/cifs/cifs_swn.h
> index 7ef9ecedbd05..13b25cdc9295 100644
> --- a/fs/cifs/cifs_swn.h
> +++ b/fs/cifs/cifs_swn.h
> @@ -18,4 +18,6 @@ extern int cifs_swn_unregister(struct cifs_tcon *tcon);
>
>  extern int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info);
>
> +extern void cifs_swn_dump(struct seq_file *m);
> +
>  #endif /* _CIFS_SWN_H */
> --
> 2.29.2
>


-- 
Thanks,

Steve
