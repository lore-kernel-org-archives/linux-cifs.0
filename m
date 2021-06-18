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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 104B6C48BDF
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 04:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E085861139
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Jun 2021 04:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhFRESs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Jun 2021 00:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbhFRESr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 18 Jun 2021 00:18:47 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5F9C061574;
        Thu, 17 Jun 2021 21:16:37 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id d13so12074480ljg.12;
        Thu, 17 Jun 2021 21:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mCvwX5+vk8V7BQG3zhJB8owe7BcQtEPZvcZWN8YaLew=;
        b=oEYG8+1CdEWGShhblOI/IyYWbzHssVqmiSiHw5NzI8Mp8BwFBsE+tvAN9SKTZosZ8C
         cVmuWm4BKMXDz2GNjzBvWoYQhMyG8PiBunVcmZXWAF0zJBxgCEe+UKRHfzaW0LmTNjkD
         RQFNhEZvTFGKfx0ApcUyomqirzARoHl75LAv7FoPZFR3xsvfFCpbgIalrAR+TNIOHCub
         iNW1U6t6llTqFiN55Z7gcwmLPJEgUiaM3xQ1xVsxrTW4muT38lWurIkdTVjHQB6KGi1+
         JRhE5uHMM8CawEo2dPpGQAtPDmpJex6bs3ztJLhKJt6D7j9OwPQfxkJ/FlVKay4Z6ACj
         O68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mCvwX5+vk8V7BQG3zhJB8owe7BcQtEPZvcZWN8YaLew=;
        b=N0v5w5XeixzJLLqB+AK32FhNHLU5km241GnEQGzewUEezYag9JS/b++fxbznKA+Bqq
         q1jxVAxTPNitl5Mfbmgr+sxzEeojJM2jQyEjdpfFgytgz0RMV0HwpdiK99GHacmlBq1n
         SPmOQAVkMkOUwqdmkw6ym55WaZHrKD4dAAGOrjoi1OQf1R9SoN5dskPREukSrDmFy2F/
         /C17Jdl7codSkHVHYe/KKFEsc02PjCPmNXAQKEBX4S8GRk3BAb9bsHjwp21WK6DA9nHo
         Z3bPfLEPS2HQL2mAjHBRgXrB12TJScYfORb20qCLXmEcvWpP8gX6OvRPwkeKN5RG9O15
         cXAg==
X-Gm-Message-State: AOAM531Zu6N6FZYdexNuW+c/EJP+xOsagS7/V+Vh6BRgJspDYPX79ych
        q56qzLd4xpWqT3FojV3T1sfuWlpTs3Pez2t49zU=
X-Google-Smtp-Source: ABdhPJyUpDXqDD148jq7aVQbdrvt2B+K8YJqgK8iUPmc8bAHZhIJU3ufjCvD+JeK061NBce1HekS9JsPcwAIEHa94oA=
X-Received: by 2002:a2e:a234:: with SMTP id i20mr7894780ljm.272.1623989795895;
 Thu, 17 Jun 2021 21:16:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210618040232.2550645-1-libaokun1@huawei.com>
In-Reply-To: <20210618040232.2550645-1-libaokun1@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 17 Jun 2021 23:16:24 -0500
Message-ID: <CAH2r5msqnE+1=yfd_E32MNY0qpgRokMJzQ4j88_RC2rBYGMxqQ@mail.gmail.com>
Subject: Re: [PATCH -next v2] cifs: convert list_for_each to entry variant in smb2misc.c
To:     Baokun Li <libaokun1@huawei.com>
Cc:     Steve French <sfrench@samba.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next

On Thu, Jun 17, 2021 at 11:02 PM Baokun Li <libaokun1@huawei.com> wrote:
>
> convert list_for_each() to list_for_each_entry() where
> applicable.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> ---
> V1->V2:
>         Convert the missing list_for_each to entry
>
>  fs/cifs/smb2misc.c | 33 ++++++++-------------------------
>  1 file changed, 8 insertions(+), 25 deletions(-)
>
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 06d555d4da9a..aba048153f79 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -164,12 +164,10 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *srvr)
>                 struct smb2_transform_hdr *thdr =
>                         (struct smb2_transform_hdr *)buf;
>                 struct cifs_ses *ses = NULL;
> -               struct list_head *tmp;
>
>                 /* decrypt frame now that it is completely read in */
>                 spin_lock(&cifs_tcp_ses_lock);
> -               list_for_each(tmp, &srvr->smb_ses_list) {
> -                       ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
> +               list_for_each_entry(ses, &srvr->smb_ses_list, smb_ses_list) {
>                         if (ses->Suid == thdr->SessionId)
>                                 break;
>
> @@ -548,7 +546,6 @@ static bool
>  smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp)
>  {
>         __u8 lease_state;
> -       struct list_head *tmp;
>         struct cifsFileInfo *cfile;
>         struct cifsInodeInfo *cinode;
>         int ack_req = le32_to_cpu(rsp->Flags &
> @@ -556,8 +553,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp)
>
>         lease_state = le32_to_cpu(rsp->NewLeaseState);
>
> -       list_for_each(tmp, &tcon->openFileList) {
> -               cfile = list_entry(tmp, struct cifsFileInfo, tlist);
> +       list_for_each_entry(cfile, &tcon->openFileList, tlist) {
>                 cinode = CIFS_I(d_inode(cfile->dentry));
>
>                 if (memcmp(cinode->lease_key, rsp->LeaseKey,
> @@ -618,7 +614,6 @@ static bool
>  smb2_is_valid_lease_break(char *buffer)
>  {
>         struct smb2_lease_break *rsp = (struct smb2_lease_break *)buffer;
> -       struct list_head *tmp, *tmp1, *tmp2;
>         struct TCP_Server_Info *server;
>         struct cifs_ses *ses;
>         struct cifs_tcon *tcon;
> @@ -628,15 +623,9 @@ smb2_is_valid_lease_break(char *buffer)
>
>         /* look up tcon based on tid & uid */
>         spin_lock(&cifs_tcp_ses_lock);
> -       list_for_each(tmp, &cifs_tcp_ses_list) {
> -               server = list_entry(tmp, struct TCP_Server_Info, tcp_ses_list);
> -
> -               list_for_each(tmp1, &server->smb_ses_list) {
> -                       ses = list_entry(tmp1, struct cifs_ses, smb_ses_list);
> -
> -                       list_for_each(tmp2, &ses->tcon_list) {
> -                               tcon = list_entry(tmp2, struct cifs_tcon,
> -                                                 tcon_list);
> +       list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
> +               list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
> +                       list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
>                                 spin_lock(&tcon->open_file_lock);
>                                 cifs_stats_inc(
>                                     &tcon->stats.cifs_stats.num_oplock_brks);
> @@ -687,7 +676,6 @@ bool
>  smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
>  {
>         struct smb2_oplock_break *rsp = (struct smb2_oplock_break *)buffer;
> -       struct list_head *tmp, *tmp1, *tmp2;
>         struct cifs_ses *ses;
>         struct cifs_tcon *tcon;
>         struct cifsInodeInfo *cinode;
> @@ -710,16 +698,11 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
>
>         /* look up tcon based on tid & uid */
>         spin_lock(&cifs_tcp_ses_lock);
> -       list_for_each(tmp, &server->smb_ses_list) {
> -               ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
> -
> -               list_for_each(tmp1, &ses->tcon_list) {
> -                       tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
> +       list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
> +               list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
>
>                         spin_lock(&tcon->open_file_lock);
> -                       list_for_each(tmp2, &tcon->openFileList) {
> -                               cfile = list_entry(tmp2, struct cifsFileInfo,
> -                                                    tlist);
> +                       list_for_each_entry(cfile, &tcon->openFileList, tlist) {
>                                 if (rsp->PersistentFid !=
>                                     cfile->fid.persistent_fid ||
>                                     rsp->VolatileFid !=
> --
> 2.31.1
>


-- 
Thanks,

Steve
