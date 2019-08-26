Return-Path: <SRS0=RY9s=WW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A035BC3A5A1
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Aug 2019 00:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7331D2080C
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Aug 2019 00:48:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jiglPNpg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfHZAsK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 25 Aug 2019 20:48:10 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44753 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfHZAsJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 25 Aug 2019 20:48:09 -0400
Received: by mail-io1-f67.google.com with SMTP id j4so24831977iog.11;
        Sun, 25 Aug 2019 17:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W/51w5j8xEcYmqOnM2KI7Id/pY4RG7FnEXZK5a9W5RA=;
        b=jiglPNpgKm4E5mpddxqvqDxY+bWhiTdGIiXT9uvxVz1duakfoA0qsNe5RK29mA6Dcp
         kg+Wk9tznXQsM40KYC2TtpmG4f9oxaGSqH/PMDRfN6WLlY4IXrKLYga69MPDT1rcbU6s
         JHwnkbxQiMHJTwzPvpaBKebn9G5xjknuQunqMDbIW5TIFb6CpTWl1NKGwpA1dY92vlqE
         mGRkyznLTonRN/FzEbyM50uXHAW5ifkHfp2LHlf52/ypSZXw0P25Q62Q56Rgglfv7tgT
         Tpdp15TuTcucREXfQLHhvQtiYaW0/sNb2oZYwk4jXp6GVtG0atQ99PLhoZPfve7XCAqk
         UwYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W/51w5j8xEcYmqOnM2KI7Id/pY4RG7FnEXZK5a9W5RA=;
        b=sNTmYi1sFzWWB9TBhvr3/NXfYQ+nCsoFCUepSGRCwvCHvEXG+Lx6lFHWggc0Fwn2Yb
         nzvzs3T7ffLxBqGn0DR89OKOyJ78URtAEHDbsf5YKHGZOg648KRnnpoi2co9oSedDFgR
         LYwJLlb882fh1MAYTs8WXHikr6qRyhsGcqgu/B9zgA71al/PELfheMgy2P21roOIezxg
         KOGFellgLhIaCMZG0gQeCPTxqwYvsWoLN0wLBUBN4RqvG0KeHHdMLiagUEQ0C2XHtEqU
         dM/p4D1qa3L5vYsqODHN6pVdbu5wUNnUBUiJQp2E+vkSKTdReBUvxGp+O6hg6w5Ge3Iy
         Jc2g==
X-Gm-Message-State: APjAAAVy6B8Qvt9dPF0Rly7CO4xfixWiXq7EBCcGyjI/le1zB0X7Ek4q
        KcWk+RZ5heyb9W35stsIe9OCws4pLgBNbcH9r90=
X-Google-Smtp-Source: APXvYqzXg9gVX/qKg0t2MCc7SoktEu+oMdiepBTfW0tBZwwwg2umaYojE9DZsKHbmvFwfWsBZdWs0TnBY8SLScsRhs4=
X-Received: by 2002:a02:29ca:: with SMTP id p193mr15275350jap.88.1566780488682;
 Sun, 25 Aug 2019 17:48:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190823121535.76296-1-yuehaibing@huawei.com>
In-Reply-To: <20190823121535.76296-1-yuehaibing@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 25 Aug 2019 19:47:57 -0500
Message-ID: <CAH2r5mt0T=4qw9tuvX-QO7Lh2A_gzWPhLMyou4ZJNDJgmFXEsA@mail.gmail.com>
Subject: Re: [PATCH -next] cifs: remove set but not used variables
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Fri, Aug 23, 2019 at 6:11 PM YueHaibing <yuehaibing@huawei.com> wrote:
>
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> fs/cifs/file.c: In function cifs_lock:
> fs/cifs/file.c:1696:24: warning: variable cinode set but not used [-Wunused-but-set-variable]
> fs/cifs/file.c: In function cifs_write:
> fs/cifs/file.c:1765:23: warning: variable cifs_sb set but not used [-Wunused-but-set-variable]
> fs/cifs/file.c: In function collect_uncached_read_data:
> fs/cifs/file.c:3578:20: warning: variable tcon set but not used [-Wunused-but-set-variable]
>
> 'cinode' is never used since introduced by
> commit 03776f4516bc ("CIFS: Simplify byte range locking code")
> 'cifs_sb' is not used since commit cb7e9eabb2b5 ("CIFS: Use
> multicredits for SMB 2.1/3 writes").
> 'tcon' is not used since commit d26e2903fc10 ("smb3: fix bytes_read statistics")
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  fs/cifs/file.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index ab07ae8..f16f6d2 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1693,7 +1693,6 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
>         bool posix_lck = false;
>         struct cifs_sb_info *cifs_sb;
>         struct cifs_tcon *tcon;
> -       struct cifsInodeInfo *cinode;
>         struct cifsFileInfo *cfile;
>         __u32 type;
>
> @@ -1710,7 +1709,6 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
>         cifs_read_flock(flock, &type, &lock, &unlock, &wait_flag,
>                         tcon->ses->server);
>         cifs_sb = CIFS_FILE_SB(file);
> -       cinode = CIFS_I(file_inode(file));
>
>         if (cap_unix(tcon->ses) &&
>             (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
> @@ -1762,7 +1760,6 @@ cifs_write(struct cifsFileInfo *open_file, __u32 pid, const char *write_data,
>         int rc = 0;
>         unsigned int bytes_written = 0;
>         unsigned int total_written;
> -       struct cifs_sb_info *cifs_sb;
>         struct cifs_tcon *tcon;
>         struct TCP_Server_Info *server;
>         unsigned int xid;
> @@ -1770,8 +1767,6 @@ cifs_write(struct cifsFileInfo *open_file, __u32 pid, const char *write_data,
>         struct cifsInodeInfo *cifsi = CIFS_I(d_inode(dentry));
>         struct cifs_io_parms io_parms;
>
> -       cifs_sb = CIFS_SB(dentry->d_sb);
> -
>         cifs_dbg(FYI, "write %zd bytes to offset %lld of %pd\n",
>                  write_size, *offset, dentry);
>
> @@ -3575,10 +3570,8 @@ collect_uncached_read_data(struct cifs_aio_ctx *ctx)
>         struct cifs_readdata *rdata, *tmp;
>         struct iov_iter *to = &ctx->iter;
>         struct cifs_sb_info *cifs_sb;
> -       struct cifs_tcon *tcon;
>         int rc;
>
> -       tcon = tlink_tcon(ctx->cfile->tlink);
>         cifs_sb = CIFS_SB(ctx->cfile->dentry->d_sb);
>
>         mutex_lock(&ctx->aio_mutex);
> --
> 2.7.4
>
>


-- 
Thanks,

Steve
