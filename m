Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7833C64E8A
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Nov 2020 02:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6848920757
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Nov 2020 02:32:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O6/Goe8C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbgK3Cci (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 29 Nov 2020 21:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgK3Cch (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 29 Nov 2020 21:32:37 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF8AC0613D3
        for <linux-cifs@vger.kernel.org>; Sun, 29 Nov 2020 18:31:57 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id s27so18222653lfp.5
        for <linux-cifs@vger.kernel.org>; Sun, 29 Nov 2020 18:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mC2PYYSylUftRT+v8kydBvLTWOpxVkOFRf1Aq4659Tk=;
        b=O6/Goe8CyJDla3/i4El8LwbPKajDvaiOjF0p/SvCQQyaN0EvlF6zrmIQiDx7LnNNWl
         xndsKnav7Td3xGV3eM8lZwqtu7R7SV0HFEE5ZuP79HZuP5Db7bphJROrMUiw2uZvwE6m
         4c/l4PLfMUzx8r11XcSg+3GWJjLo8VUYq/E0W3/mlCaEGaHpM+KSUVkX16ZNZRXhTOjp
         vwdhcu6DrDfCbe8kZo/c0qLbuCS1W1SRbeRVqjrihCf1UtvqZKtCR36PNaMcg5KT/D8w
         CWrX5pF+GS2KwxzybwJaGSHx8ecFJWk9J+hkmwXUssg3prf1fkcHUFVg4A28p2iyY0YG
         +O8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mC2PYYSylUftRT+v8kydBvLTWOpxVkOFRf1Aq4659Tk=;
        b=jeykGQjSPVQ65MMJi63Dekj0zuFt7eP6jbBLf5DSgXtNwyg4L4OW2Df07xXFah5TAA
         jAs0uvBv9CmvqGXfadFHqJH0CMp9vWacctDWlBPIGRdXofOlCBg88mWw+s+82E27lfLI
         TLvqXv1CH+D3+MKUiioV9lw6S7+RUC4swBQK9AbCxAG4FCcjdX521I7dZDvGyk5Ct0mM
         ve0yYdCjaVgW9+KNPQ23OEsVTbSs9a8U27SgRQSPdSzhAmGBl16xPUWaQki+os+igepc
         SJtaU0YQQgEBqIch9rcCPkLGqoanmjFUM73wUeVBf9gEJSsI4GUoyR4uylvtSfxxFf7U
         5zvg==
X-Gm-Message-State: AOAM5315oRGZQkSrkZgonwCquTZFpOXc27m2/AqZXL8OlwnQNNvEt7V/
        MYSr7DtRu4/cfZ6eqUDLB7LzcMtjebfJrPpGXgw=
X-Google-Smtp-Source: ABdhPJz5pk2n6ljdvAThTFecsj4Gy5FUu7ucV1E/K9JNeVj/G93ruMCx6qvQ4i4wcTO6VDbw6M7UrsNhYWLq4x8vgUw=
X-Received: by 2002:ac2:4d0c:: with SMTP id r12mr8732119lfi.47.1606703515756;
 Sun, 29 Nov 2020 18:31:55 -0800 (PST)
MIME-Version: 1.0
References: <20201128195402.12233-1-pc@cjr.nz>
In-Reply-To: <20201128195402.12233-1-pc@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 29 Nov 2020 20:31:44 -0600
Message-ID: <CAH2r5mu=V-mzLxt9c2zxsYejNxhyfHYFjeJXxvwAaZjk9=-sBQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix potential use-after-free in cifs_echo_request()
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

added Ronnie's reviewed-by to the two patches and put in cifs-2.6.git for-next

On Sat, Nov 28, 2020 at 1:54 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> This patch fixes a potential use-after-free bug in
> cifs_echo_request().
>
> For instance,
>
>   thread 1
>   --------
>   cifs_demultiplex_thread()
>     clean_demultiplex_info()
>       kfree(server)
>
>   thread 2 (workqueue)
>   --------
>   apic_timer_interrupt()
>     smp_apic_timer_interrupt()
>       irq_exit()
>         __do_softirq()
>           run_timer_softirq()
>             call_timer_fn()
>               cifs_echo_request() <- use-after-free in server ptr
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/connect.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index c38156f324dd..28c1459fb0fc 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -876,6 +876,8 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
>         list_del_init(&server->tcp_ses_list);
>         spin_unlock(&cifs_tcp_ses_lock);
>
> +       cancel_delayed_work_sync(&server->echo);
> +
>         spin_lock(&GlobalMid_Lock);
>         server->tcpStatus = CifsExiting;
>         spin_unlock(&GlobalMid_Lock);
> --
> 2.29.2
>


-- 
Thanks,

Steve
