Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6232C19F2D
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Aug 2022 04:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbiHIEWV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Aug 2022 00:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbiHIEWU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Aug 2022 00:22:20 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD1A192AF
        for <linux-cifs@vger.kernel.org>; Mon,  8 Aug 2022 21:22:18 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id m67so10757315vsc.12
        for <linux-cifs@vger.kernel.org>; Mon, 08 Aug 2022 21:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y+QjLpklbyTw/CQHOBH32LIoi1KNzBohuIjfYBsQtCk=;
        b=bSEB+Ams+4H1nSTQBbe9Gi1eqzZ6O/Q0IkHdqDcUDmYUCE0LbkG9yENeQNYezRvCF8
         uPau6b9omIS6K/dTIUf2QePIePOmPilLlWsm6ZBwGhqlk3pgj+VAtbaaZ+BfgWiL8tsr
         UqX9GTBcmNykM50lLzLQvBganOUwziRsXEZxl5qprPjMW9oxdTFoLKfG75TWvtneZ+3N
         YwyT8NFot3Rw/pUTpLTQFXN41FgXdkqXi/ULollaNgR60+6mbsC2yQqxUascvQ+z1Ruz
         Jj7N5bT5D2S4Q7mcQBq0B2rnNvIUHgQYdW1qaXjWucvfpVLT8Y3WZuazwKgdLWodIusV
         Nbhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y+QjLpklbyTw/CQHOBH32LIoi1KNzBohuIjfYBsQtCk=;
        b=MbW42+YJOdm5q1OlzeM48sWVVYrHIFkRz13uZDSnn3I+8T0wZHfRq+ghXixMc9fMfE
         eBYsRH+U0ZLStAuU4dHXMxxpzMGTtnc2jjukGy05maa/zdwasMJx2Ziu7l3+wSrElizJ
         /8wWd7X2cNCCujG3+Rnlx2ndcHZFI5rvJ8WzPB71hFAhpLM1hDTwmS2zeKZLUT6QHz/b
         9U3ZKvDXr3hwRsIX4sZScVGnKuJ7bIz9N2zbXX6S+VD/cLKgUJ4ofoJlm7ovcy6YSf6t
         LQcjQSMeH9jPbeSlJvhB3nUlBqsmj/BcQ9D0X6sxJp4FQCq+q7s8kYwS7nXgvb72SYwt
         qMEw==
X-Gm-Message-State: ACgBeo1C6d0ZS9A+5zubuFcRP2zMiZETLI3U7RG/s1jVCGotjsMX00ZA
        uBanfXYdNxgmH8oyBceazt94wLPzt4KDMCx7aRGk38CzbMg=
X-Google-Smtp-Source: AA6agR5iYPUdHt2Yyy0WG8uT6RxVlH4iqDgvSHCocxFTzp6RAnW9U3qv0qewBeUYEd9dIwcRciGlotNhFxqEirL1Hlc=
X-Received: by 2002:a67:b401:0:b0:387:8734:a09 with SMTP id
 x1-20020a67b401000000b0038787340a09mr8193348vsl.61.1660018937126; Mon, 08 Aug
 2022 21:22:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220809021156.3086869-1-lsahlber@redhat.com> <20220809021156.3086869-3-lsahlber@redhat.com>
In-Reply-To: <20220809021156.3086869-3-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 8 Aug 2022 23:22:04 -0500
Message-ID: <CAH2r5muyuaCmi18XU7PHzGZS5CmqNDuPhe_Yc5UhyS=DDxcx9Q@mail.gmail.com>
Subject: Re: [PATCH 2/9] cifs: Do not use tcon->cfid directly, use the cfid we
 get from open_cached_dir
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This looks harmless if it makes future patches easier

On Mon, Aug 8, 2022 at 9:12 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> They are the same right now but tcon-> will later point to a different
> type of struct containing a list of cfids.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2inode.c | 4 ++--
>  fs/cifs/smb2pdu.c   | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index f6f9fc3f2e2d..09f01f70e020 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -519,9 +519,9 @@ smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
>                 rc = open_cached_dir(xid, tcon, full_path, cifs_sb, &cfid);
>         /* If it is a root and its handle is cached then use it */
>         if (!rc) {
> -               if (tcon->cfid.file_all_info_is_valid) {
> +               if (cfid->file_all_info_is_valid) {
>                         move_smb2_info_to_cifs(data,
> -                                              &tcon->cfid.file_all_info);
> +                                              &cfid->file_all_info);
>                 } else {
>                         rc = SMB2_query_info(xid, tcon,
>                                              cfid->fid->persistent_fid,
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 9ee1b6225619..5dbd2cac470c 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1979,7 +1979,7 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
>         }
>         spin_unlock(&ses->chan_lock);
>
> -       close_cached_dir_lease(&tcon->cfid);
> +       invalidate_all_cached_dirs(tcon);
>
>         rc = smb2_plain_req_init(SMB2_TREE_DISCONNECT, tcon, ses->server,
>                                  (void **) &req,
> --
> 2.35.3
>


-- 
Thanks,

Steve
