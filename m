Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C996C77B73
	for <linux-cifs@archiver.kernel.org>; Thu, 20 Apr 2023 16:24:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjDTQY6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 20 Apr 2023 12:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbjDTQY6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 20 Apr 2023 12:24:58 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38DB93
        for <linux-cifs@vger.kernel.org>; Thu, 20 Apr 2023 09:24:56 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id ud9so7642675ejc.7
        for <linux-cifs@vger.kernel.org>; Thu, 20 Apr 2023 09:24:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682007895; x=1684599895;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+7R/+DhzK6pCWyipuTTsGpqOoTB+pldmrMxN4qqdyXI=;
        b=rctcz0tAPLrK2gdoMDtTWo62J21DUbBJcKjT0Q3QPLBitBxIxr2MrVXO/cxMpd5rV7
         1Q2mC/ERTbgO3C8UbXZZF5U7gzii9XoK4MbH5QwLvXGHWZlDgDKhbKD0oOn1YTWMqwk6
         rFqY4Z1t1GFktuVzr7IMUFR68JihmpSDlGuznWHA7yHZV9jIQhL3ywYxVYwcwwsBP70F
         tMfTjAuKpgSsfYKoUkQvnTIQ747k1fcnc6VaO+SeNVdQVyV8KP8FkrIod+zUHjf+0Pl4
         u9YDgO6BderOEKKlZ4DShjq18Q/vKrpC6qt/xoDXfKn+TiXKLhp9SvVOxcleBm3q4/Na
         N8WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682007895; x=1684599895;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+7R/+DhzK6pCWyipuTTsGpqOoTB+pldmrMxN4qqdyXI=;
        b=LNXJVVhMzFh9jFz+3wSmp+J+fMQWW3o5MfO2mAVcY3VXSwNxFpYjw6rTGcaArOzMsC
         bSabNcsoOYn0CzLGiNcgiOnmrRpYOVmhFw6OKcd2/gGO/ilRzWgyFyPvsXs8VExLF247
         nQrKhn2KgKoCDJZox51aYF7ebECih6osoaIMxYCELsDN4XAjrIivcMcapNeDvSW3PZth
         1ChV7XlWTEYZ7xP7HUHVU9yTo+8IQBDEfrPYwWk2sxbZF2PX4E+VTlXugqs7dLwHacmO
         qqjJdZZc0ZdI2kFSmJVF772YhrrjNNPQUWKxu37CpNw8JcdjxxlI0MZEgV86HOTS78Hi
         tF0w==
X-Gm-Message-State: AAQBX9e0SwSVs3CmpPjieEDTKSuJw4+UpspI0uclVbZz60m0tJzlCs02
        uZFBdzRwyK51H8hv/9fVUdMBF42yCzyNl4weYQSYh5rx
X-Google-Smtp-Source: AKy350azkDNBoPYbtxqf62SJga6ytktk7bKekNxxE7Ivj5Jv8iW0Guz2+07Bd8diYk1lrE9NEDWCFxCHIfr6ikpNusU=
X-Received: by 2002:a17:907:3e87:b0:949:797e:ea91 with SMTP id
 hs7-20020a1709073e8700b00949797eea91mr2574615ejc.56.1682007894927; Thu, 20
 Apr 2023 09:24:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230420160646.291053-1-bharathsm.hsk@gmail.com>
In-Reply-To: <20230420160646.291053-1-bharathsm.hsk@gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 21 Apr 2023 02:24:41 +1000
Message-ID: <CAN05THRhV3hRcYVfx0_1A3dZPtVCBxtbpXvboAu34VdoKM3Mzg@mail.gmail.com>
Subject: Re: [PATCH] SMB3: Add missing locks to protect deferred close file list
To:     Bharath SM <bharathsm.hsk@gmail.com>
Cc:     pc@cjr.nz, sfrench@samba.org, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good. Acked-by me.

Can you add a "Fixes ..." line to the commit message.


On Fri, 21 Apr 2023 at 02:16, Bharath SM <bharathsm.hsk@gmail.com> wrote:
>
> From: Bharath SM <bharathsm@microsoft.com>
>
> cifs_del_deferred_close function has a critical section which modifies
> the deferred close file list. We must acquire deferred_lock before
> calling cifs_del_deferred_close function.
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/cifs/misc.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index a0d286ee723d..89bbc12e2ca7 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -742,7 +742,10 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
>         list_for_each_entry(cfile, &cifs_inode->openFileList, flist) {
>                 if (delayed_work_pending(&cfile->deferred)) {
>                         if (cancel_delayed_work(&cfile->deferred)) {
> +
> +                               spin_lock(&cifs_inode->deferred_lock);
>                                 cifs_del_deferred_close(cfile);
> +                               spin_unlock(&cifs_inode->deferred_lock);
>
>                                 tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
>                                 if (tmp_list == NULL)
> @@ -773,7 +776,10 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
>         list_for_each_entry(cfile, &tcon->openFileList, tlist) {
>                 if (delayed_work_pending(&cfile->deferred)) {
>                         if (cancel_delayed_work(&cfile->deferred)) {
> +
> +                               spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
>                                 cifs_del_deferred_close(cfile);
> +                               spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
>
>                                 tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
>                                 if (tmp_list == NULL)
> @@ -808,7 +814,10 @@ cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
>                 if (strstr(full_path, path)) {
>                         if (delayed_work_pending(&cfile->deferred)) {
>                                 if (cancel_delayed_work(&cfile->deferred)) {
> +
> +                                       spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
>                                         cifs_del_deferred_close(cfile);
> +                                       spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
>
>                                         tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
>                                         if (tmp_list == NULL)
> --
> 2.34.1
>
