Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 804B9C433B4
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 04:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DF2D61106
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 04:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhDIEms (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 00:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbhDIEmq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 00:42:46 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E342C061760
        for <linux-cifs@vger.kernel.org>; Thu,  8 Apr 2021 21:42:31 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id 12so7537282lfq.13
        for <linux-cifs@vger.kernel.org>; Thu, 08 Apr 2021 21:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w0LRIqo5DL2xDKojQwbW8/gs8Wwm9YoLUQYYjVTXSdI=;
        b=aQ92765YG0iiaKkRD3Ocwar/HfatgKSw1qPu2R20HbSFGF87WE4jMWG2wi63xDo0eu
         hg8U1E18GRXGnrnz2KmxnDyDkpc1N46eWT4GE5pwx7xlNP1h31HqaNfxw75gMfZfb/IC
         tm2Gw3Ol5/Z98GbR3vx65LhdZqjNI1neHmZ9xPKt9e3EoHzYAsgjCG9TOnuKsx6n7+I1
         zO314MUtfWDGbPmIR1WMvLPnfhcJ7gx/rYDR8TvvZBnIJWJ2vYvzpvPDKiuRK8XIeaK0
         Xy+RGcLyUma2qeRKN4N1OSDpEArja4q36KC+EvxRiEVKo+oGGdgPPDe9Eys2A9v9gZFg
         wsyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w0LRIqo5DL2xDKojQwbW8/gs8Wwm9YoLUQYYjVTXSdI=;
        b=IdQ/dRxJzXH1vl8+LcX+aqcVWchRGTBfPFikxROavX/DjtwvZ8iqMBUaffV6qQJsDY
         skh64pq/0Znw+u8lv5vF4eCCpAsXyy1zcSTZzR6aM6b0lW/sOSnih4RMIBblUUfSrkyy
         NhoOTRqym2ZTNZYaCormekUG0nTEnKDcBO4Tp+i0CpZwvLm3QTum5mo7d2Qa7GX7Ft1S
         nSNJnvwXTZwKBagu5GZ0XN4blc3S1FNxoKYBQkXWgM/44DeqPamY4Enj5T1bCdMfVt15
         mrZt7BNYkhwesS+ZbNdmzg5roBnEKN5HyFNGtDHswnonW4GZPfKHB9OrcU5RP3HiK6Ak
         gp/A==
X-Gm-Message-State: AOAM533YZ8rsK5jJHaRdXXfRhEZHKps6OaYQx5RO2WxakkWghKu08zGD
        Hb2KEgQV9WSAVjAdOp6O7khbtcbnzuTdnsB+dkU=
X-Google-Smtp-Source: ABdhPJyDJMlFj+hiwMsEPbO7arii9dSzIio31O5mTdaEPzIKqkzfqEwnsO4UoqDST2lDsmXnW1GTzpV3YHuCT2sv9aU=
X-Received: by 2002:a05:6512:1322:: with SMTP id x34mr8866100lfu.133.1617943349547;
 Thu, 08 Apr 2021 21:42:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210308230735.337-1-lsahlber@redhat.com> <20210308230735.337-2-lsahlber@redhat.com>
In-Reply-To: <20210308230735.337-2-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 8 Apr 2021 23:42:18 -0500
Message-ID: <CAH2r5msHDo=Dpp0j5_TkbG90zekMUw3r1O+z0N2CrtfhzqDrxA@mail.gmail.com>
Subject: Re: [PATCH 1/9] cifs: move the check for nohandlecache into open_shroot
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Is there an updated version of this 9 patch series or is this current?

Any additional review feedback on it?

On Mon, Mar 8, 2021 at 5:08 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> instead of doing it in the callsites for open_shroot.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2inode.c | 24 +++++++++++-------------
>  fs/cifs/smb2ops.c   | 16 ++++++++--------
>  2 files changed, 19 insertions(+), 21 deletions(-)
>
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index 1f900b81c34a..3d59614cbe8f 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -511,7 +511,6 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>         int rc;
>         struct smb2_file_all_info *smb2_data;
>         __u32 create_options = 0;
> -       bool no_cached_open = tcon->nohandlecache;
>         struct cifsFileInfo *cfile;
>         struct cached_fid *cfid = NULL;
>
> @@ -524,23 +523,22 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>                 return -ENOMEM;
>
>         /* If it is a root and its handle is cached then use it */
> -       if (!strlen(full_path) && !no_cached_open) {
> +       if (!strlen(full_path)) {
>                 rc = open_shroot(xid, tcon, cifs_sb, &cfid);
> -               if (rc)
> -                       goto out;
> -
> -               if (tcon->crfid.file_all_info_is_valid) {
> -                       move_smb2_info_to_cifs(data,
> +               if (!rc) {
> +                       if (tcon->crfid.file_all_info_is_valid) {
> +                               move_smb2_info_to_cifs(data,
>                                                &tcon->crfid.file_all_info);
> -               } else {
> -                       rc = SMB2_query_info(xid, tcon,
> +                       } else {
> +                               rc = SMB2_query_info(xid, tcon,
>                                              cfid->fid->persistent_fid,
>                                              cfid->fid->volatile_fid, smb2_data);
> -                       if (!rc)
> -                               move_smb2_info_to_cifs(data, smb2_data);
> +                               if (!rc)
> +                                       move_smb2_info_to_cifs(data, smb2_data);
> +                       }
> +                       close_shroot(cfid);
> +                       goto out;
>                 }
> -               close_shroot(cfid);
> -               goto out;
>         }
>
>         cifs_get_readable_path(tcon, full_path, &cfile);
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index f5087295424c..7ee6926153b8 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -746,6 +746,9 @@ int open_shroot(unsigned int xid, struct cifs_tcon *tcon,
>         u8 oplock = SMB2_OPLOCK_LEVEL_II;
>         struct cifs_fid *pfid;
>
> +       if (tcon->nohandlecache)
> +               return -ENOTSUPP;
> +
>         mutex_lock(&tcon->crfid.fid_mutex);
>         if (tcon->crfid.is_valid) {
>                 cifs_dbg(FYI, "found a cached root file handle\n");
> @@ -914,7 +917,6 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
>         u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
>         struct cifs_open_parms oparms;
>         struct cifs_fid fid;
> -       bool no_cached_open = tcon->nohandlecache;
>         struct cached_fid *cfid = NULL;
>
>         oparms.tcon = tcon;
> @@ -924,14 +926,12 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
>         oparms.fid = &fid;
>         oparms.reconnect = false;
>
> -       if (no_cached_open) {
> +       rc = open_shroot(xid, tcon, cifs_sb, &cfid);
> +       if (rc == 0)
> +               memcpy(&fid, cfid->fid, sizeof(struct cifs_fid));
> +       else
>                 rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL,
>                                NULL, NULL);
> -       } else {
> -               rc = open_shroot(xid, tcon, cifs_sb, &cfid);
> -               if (rc == 0)
> -                       memcpy(&fid, cfid->fid, sizeof(struct cifs_fid));
> -       }
>         if (rc)
>                 return;
>
> @@ -945,7 +945,7 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
>                         FS_VOLUME_INFORMATION);
>         SMB2_QFS_attr(xid, tcon, fid.persistent_fid, fid.volatile_fid,
>                         FS_SECTOR_SIZE_INFORMATION); /* SMB3 specific */
> -       if (no_cached_open)
> +       if (cfid == NULL)
>                 SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
>         else
>                 close_shroot(cfid);
> --
> 2.13.6
>


-- 
Thanks,

Steve
