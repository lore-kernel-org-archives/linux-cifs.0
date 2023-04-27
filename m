Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C7A5C77B73
	for <linux-cifs@archiver.kernel.org>; Thu, 27 Apr 2023 16:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243284AbjD0QE0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 27 Apr 2023 12:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243215AbjD0QE0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 27 Apr 2023 12:04:26 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FBA30D3
        for <linux-cifs@vger.kernel.org>; Thu, 27 Apr 2023 09:04:25 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-4f0037de1d1so2857230e87.0
        for <linux-cifs@vger.kernel.org>; Thu, 27 Apr 2023 09:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682611463; x=1685203463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/VRUepJSl/YbHkY8psV+tEXRKigruPZKmUiC49TKFsE=;
        b=RItHYfSlGmX9qfL6Eol46+hVdmoJdrLc6FczWyYECqBGPLxpgCxKrjcefxtX/p7eQ2
         FT1XQXvI1jNAlWTxB9AZcRXJx/BgHCCQw42nSVLnhDqtfsj9LRgpaNfROUF6QQfj3niY
         ZddF7jQIaBzRhBGCmlwyRr0fwYPTJQQrfPfR4yBxt9aHkxcvGyC3fpTUZWijtXi9dm8t
         sapZdyKf16eIEItjR8KBCPXRc3yR08ZzvG19hx22dgmvvH0crrtPXwXAmn34OU4icy/m
         X3neLooLwW/FdXSNcOpaEjb3uMn21a1OZshwYut9okhjpC+JNewwR8QoeoqyDNaErKeJ
         30jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682611463; x=1685203463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/VRUepJSl/YbHkY8psV+tEXRKigruPZKmUiC49TKFsE=;
        b=EdH3nwl9tltxMlltYWFWaPZHQbI0LvBuMZZQooRWSjnu6O4ZozRlQyh0kPcqd2W8xI
         Fd4O8lz6Ql71loUS4hR+pWxUhQirKHtJvAUj9aLU36f1w46Fnsu5n1hNqD5u1ENVOOND
         /lKjGxyBecfXYRLp65KEUsE2bkN5To1qco4eqSgkEx+Jg33iwTwRAVpemduwMBzVoUnt
         jYN1jT8l60Y9wcgdaP9MbjrYelxdaY51yilAPO9W2+QaRIz/KIdWchSjAvUhBG5ftxnK
         CnxS0iZAnWVf0j4fAEm/xXm/OyuT9rbohKJjgSflWKU1NaOhK++y4zIOxgFeZJUqU048
         7TnQ==
X-Gm-Message-State: AC+VfDzKK2qEBWf3NQz445hwMcMOvqYH4Srax4GM7LiodgPn7AueBxzH
        7b6qxdvH9vqoRc61XRF2V2b7qWUVQsD31dphO0Z4Ga0p
X-Google-Smtp-Source: ACHHUZ5nLuUSh3nux1mPvcCZtqdFFLXXkSkX07a1juf3Ir+pyGq+ncdDaiD5LsAQ6Z+eFiByNoi4JOCocK94B+B25TE=
X-Received: by 2002:ac2:4478:0:b0:4dd:af74:acef with SMTP id
 y24-20020ac24478000000b004ddaf74acefmr759877lfl.35.1682611463151; Thu, 27 Apr
 2023 09:04:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230426140516.12532-1-bharathsm.hsk@gmail.com>
In-Reply-To: <20230426140516.12532-1-bharathsm.hsk@gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 27 Apr 2023 11:04:11 -0500
Message-ID: <CAH2r5mvzbg2U8dk_KbOQOuZoDmDJOx9X__jrBGg_RSNUJPe9_w@mail.gmail.com>
Subject: Re: [PATCH] SMB3: Close deferred file handles in case of handle lease break
To:     Bharath SM <bharathsm.hsk@gmail.com>
Cc:     pc@cjr.nz, sfrench@samba.org, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively added to for-next pending testing

On Wed, Apr 26, 2023 at 9:15=E2=80=AFAM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> We should not cache deferred file handles if we dont have
> handle lease on a file. And we should immediately close all
> deferred handles in case of handle lease break.
>
> Fixes: 9e31678fb403 ("SMB3: fix lease break timeout when multiple deferre=
d close handles for the same file.")
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/cifs/file.c | 16 ++++++++++++++++
>  fs/cifs/misc.c |  2 +-
>  2 files changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 4d4a2d82636d..791a12575109 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -4886,6 +4886,8 @@ void cifs_oplock_break(struct work_struct *work)
>         struct TCP_Server_Info *server =3D tcon->ses->server;
>         int rc =3D 0;
>         bool purge_cache =3D false;
> +       struct cifs_deferred_close *dclose;
> +       bool is_deferred =3D false;
>
>         wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
>                         TASK_UNINTERRUPTIBLE);
> @@ -4921,6 +4923,20 @@ void cifs_oplock_break(struct work_struct *work)
>                 cifs_dbg(VFS, "Push locks rc =3D %d\n", rc);
>
>  oplock_break_ack:
> +       /*
> +        * When oplock break is received and there are no active
> +        * file handles but cached, then schedule deferred close immediat=
ely.
> +        * So, new open will not use cached handle.
> +        */
> +       spin_lock(&CIFS_I(inode)->deferred_lock);
> +       is_deferred =3D cifs_is_deferred_close(cfile, &dclose);
> +       spin_unlock(&CIFS_I(inode)->deferred_lock);
> +
> +       if (!CIFS_CACHE_HANDLE(cinode) && is_deferred &&
> +                       cfile->deferred_close_scheduled && delayed_work_p=
ending(&cfile->deferred)) {
> +               cifs_close_deferred_file(cinode);
> +       }
> +
>         /*
>          * releasing stale oplock after recent reconnect of smb session u=
sing
>          * a now incorrect file handle is not a data integrity issue but =
do
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 5f874e9c1554..0cfb46d7773c 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -757,7 +757,7 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_i=
node)
>         spin_unlock(&cifs_inode->open_file_lock);
>
>         list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, lis=
t) {
> -               _cifsFileInfo_put(tmp_list->cfile, true, false);
> +               _cifsFileInfo_put(tmp_list->cfile, false, false);
>                 list_del(&tmp_list->list);
>                 kfree(tmp_list);
>         }
> --
> 2.34.1
>


--=20
Thanks,

Steve
