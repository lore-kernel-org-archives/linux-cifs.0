Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 267B2C48BE8
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 04:18:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FF4D61139
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 04:18:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhFREU7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Jun 2021 00:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbhFREU6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Jun 2021 00:20:58 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A61DC061760;
        Thu, 17 Jun 2021 21:18:48 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id q23so1660522ljh.0;
        Thu, 17 Jun 2021 21:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6H4QkZaU5ORUZ1KVCHUaXIqHAtY5xVo3G4y/EPhgIgk=;
        b=jFitRzYsSkj6l7xDBW63GcidXvYhzCLU1dyDQgEgHemJE0bWS/X5Bayf9p9izcBPA2
         2EZCseNEglVSoM+TjgQbf5Xluza8yKI2psozGBY5aOIdvRFNQYhuq00ej51gTx9bts9F
         oFzKL/GOO5yiSFBLReduzGkBhvtWnm0U03GO9DvKbyoCZOin5oUFPCjxpZ8+Vcqa+2qn
         KOohSIkyMw4ASLwbR20Fpd4r9Fka+k12vyB9dRG1bkBYcFsET+Qvrvc/6cxuWQ9Nfxck
         RrjlnloRMw0EslXM5zmmSKZYP/hqlrZEcHfEVFKetDmFHmtnTdVgOaV6AIbap4nHPeF9
         BM3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6H4QkZaU5ORUZ1KVCHUaXIqHAtY5xVo3G4y/EPhgIgk=;
        b=dca5HhrIPK9jYRRY2qTOV6DUAch8xfccq3AzODtwn1vGBOB39YdtEuMVVCBO4dQwvF
         +N3BUUr3X8jsxrDF+kXHf43V/TtyZyQYvvvf6wSrz4Su6A8gSWnuq1I/p1MB+5MLl6Ld
         uS6kL8cRl3kTXno3RXSnK8lyfYqN+QxAbQSKVzMZi/MHKm+CaQywhUmwF6UlIP25B7N0
         /8sZ6vmmY+b3HWrY0UJXEG2HGtsBE7gRMRKKRh9yMM6cfhnTjpGG3OT3HR5gLS3uOxYl
         GNic/Kfbm9W3XdO+RczK5pyzquhkGgX2iydXybDiUknujt3vp6wXQ3KYpAXM7KECK/Kz
         kpqQ==
X-Gm-Message-State: AOAM5324qppUNWvKyghie62P6lCmiOjf7r0EFLhepp8oSnf87F9gSUdi
        k19DOG9ZPIFOraURd1xrzaxgvuqtOgtfLwVNEpg=
X-Google-Smtp-Source: ABdhPJzwq/cJ4iLuZha164RaW9qKFIOBq2+xcuN/3k+wguDHpVwDoW6hkrv9I2/OCPFkSzi6JTU1Q4VrK6doRcel3rc=
X-Received: by 2002:a2e:a7cd:: with SMTP id x13mr7623913ljp.218.1623989926694;
 Thu, 17 Jun 2021 21:18:46 -0700 (PDT)
MIME-Version: 1.0
References: <20210617113640.4141487-1-libaokun1@huawei.com>
In-Reply-To: <20210617113640.4141487-1-libaokun1@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 17 Jun 2021 23:18:35 -0500
Message-ID: <CAH2r5ms4c37ykXetxy6CRL1WXWUZB59rFzm7ckG=0d-bYmnt1Q@mail.gmail.com>
Subject: Re: [PATCH -next] cifs: convert list_for_each to entry variant in cifs_debug.c
To:     Baokun Li <libaokun1@huawei.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next

On Thu, Jun 17, 2021 at 6:40 AM Baokun Li <libaokun1@huawei.com> wrote:
>
> convert list_for_each() to list_for_each_entry() where
> applicable.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
>  fs/cifs/cifs_debug.c | 24 +++++++-----------------
>  1 file changed, 7 insertions(+), 17 deletions(-)
>
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 68e8e5b27841..8857ac7e7a14 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -50,7 +50,6 @@ void cifs_dump_detail(void *buf, struct TCP_Server_Info *server)
>  void cifs_dump_mids(struct TCP_Server_Info *server)
>  {
>  #ifdef CONFIG_CIFS_DEBUG2
> -       struct list_head *tmp;
>         struct mid_q_entry *mid_entry;
>
>         if (server == NULL)
> @@ -58,8 +57,7 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
>
>         cifs_dbg(VFS, "Dump pending requests:\n");
>         spin_lock(&GlobalMid_Lock);
> -       list_for_each(tmp, &server->pending_mid_q) {
> -               mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
> +       list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
>                 cifs_dbg(VFS, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %llu\n",
>                          mid_entry->mid_state,
>                          le16_to_cpu(mid_entry->command),
> @@ -168,7 +166,7 @@ cifs_dump_iface(struct seq_file *m, struct cifs_server_iface *iface)
>
>  static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
>  {
> -       struct list_head *stmp, *tmp, *tmp1, *tmp2;
> +       struct list_head *tmp, *tmp1, *tmp2;
>         struct TCP_Server_Info *server;
>         struct cifs_ses *ses;
>         struct cifs_tcon *tcon;
> @@ -183,9 +181,7 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
>         seq_printf(m, " <filename>\n");
>  #endif /* CIFS_DEBUG2 */
>         spin_lock(&cifs_tcp_ses_lock);
> -       list_for_each(stmp, &cifs_tcp_ses_list) {
> -               server = list_entry(stmp, struct TCP_Server_Info,
> -                                   tcp_ses_list);
> +       list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
>                 list_for_each(tmp, &server->smb_ses_list) {
>                         ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
>                         list_for_each(tmp1, &ses->tcon_list) {
> @@ -220,7 +216,7 @@ static int cifs_debug_files_proc_show(struct seq_file *m, void *v)
>
>  static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>  {
> -       struct list_head *tmp1, *tmp2, *tmp3;
> +       struct list_head *tmp2, *tmp3;
>         struct mid_q_entry *mid_entry;
>         struct TCP_Server_Info *server;
>         struct cifs_ses *ses;
> @@ -278,11 +274,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>
>         c = 0;
>         spin_lock(&cifs_tcp_ses_lock);
> -       list_for_each(tmp1, &cifs_tcp_ses_list) {
> -               server = list_entry(tmp1, struct TCP_Server_Info,
> -                                   tcp_ses_list);
> -
> -               /* channel info will be printed as a part of sessions below */
> +       list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
>                 if (server->is_channel)
>                         continue;
>
> @@ -563,7 +555,7 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
>  #ifdef CONFIG_CIFS_STATS2
>         int j;
>  #endif /* STATS2 */
> -       struct list_head *tmp1, *tmp2, *tmp3;
> +       struct list_head *tmp2, *tmp3;
>         struct TCP_Server_Info *server;
>         struct cifs_ses *ses;
>         struct cifs_tcon *tcon;
> @@ -594,9 +586,7 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
>
>         i = 0;
>         spin_lock(&cifs_tcp_ses_lock);
> -       list_for_each(tmp1, &cifs_tcp_ses_list) {
> -               server = list_entry(tmp1, struct TCP_Server_Info,
> -                                   tcp_ses_list);
> +       list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
>                 seq_printf(m, "\nMax requests in flight: %d", server->max_in_flight);
>  #ifdef CONFIG_CIFS_STATS2
>                 seq_puts(m, "\nTotal time spent processing by command. Time ");
>


-- 
Thanks,

Steve
