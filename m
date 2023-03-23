Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48902C74A5B
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Mar 2023 19:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjCWTtD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Mar 2023 15:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbjCWTs6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Mar 2023 15:48:58 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C186F940
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 12:48:56 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id g18so23746815ljl.3
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 12:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679600934;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=saLPnnrlvOeB2+f8NroFCYMK1tLgCxAkPxq114hEi1M=;
        b=Yk8MjTv3lyxmOgswHHKhlqBVJZZU/aMS6fDMXG+vkVd3HJfNOxsA6jCLkdLUKiLPaj
         HpRYhN+UcGKgfGshADyS0Ws7EKciylHf+JBvWxIVlP+/Y0PUAjsT01+RmzNInlEKYcfn
         9zDgrBYBSBDwt0qAjgxGrt+tLWUxWO8f5un2qeYR+7SKm+cnSBBURjwZbF2XJW521Tg+
         uPYguRT/ownzJmEZ1a4SEwRwgZ+FTq5g9//h/ediokc83vRpevGLYEdp/rqXr3GxpSUb
         EDCAxekLWHkqiLcqWchugVE7+NI00Mb/84xF+tWLEFFLZGSxC9TnoAujg91D68LCU0an
         XBmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679600934;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=saLPnnrlvOeB2+f8NroFCYMK1tLgCxAkPxq114hEi1M=;
        b=o8A6MtYEI/FejPELv97t+TG5X/2TaiYIRNYmKBo54dqdpdDdgsMPFEDPI/HhTgNUnt
         w+ngZ2Dfoe6Lo8HjLGnsRnDWQOe2BO9OVoxmxATIO+bfEVZoOkU1EEsiNurIva4rMMas
         g7iNw2q5CPcmLZV4N5Ws6N3cTGw4tlL+VY8Su5lfBwnzhjkZ/MDSxtmVIFw39XfICjAB
         Ym5p7hgqnlfTVbNuwmDdeI3qRJffS2Tj5VEsk2zHwBsm6QgVsEoNunxF36vZtSAoxoVF
         K9Oj4zyzSX2Vecl3PMcJ+atCTbGYWxOGgoBe7azglExxHv7LO8dgieUBu22x0g9Jz1z6
         N+ng==
X-Gm-Message-State: AAQBX9ffYE+fYu8yRPRZLCwOF2IfAKIc2d/ZLqo3IsoYcVJpcshFwhDm
        oAcPDo434J3gYZMMGmsL8T09Q1gFyG+UBhwcJrs=
X-Google-Smtp-Source: AKy350ZcoAMnDxVLtRVcD8ODhliHi7trppXoB8W3xVDCxXDHwp2ndl1s67qzf95yCMRQIXYMdu8JoursY8OinWOIe10=
X-Received: by 2002:a2e:3203:0:b0:298:b337:c11f with SMTP id
 y3-20020a2e3203000000b00298b337c11fmr121023ljy.7.1679600934396; Thu, 23 Mar
 2023 12:48:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230323190500.1684832-1-bharathsm.hsk@gmail.com>
In-Reply-To: <20230323190500.1684832-1-bharathsm.hsk@gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 23 Mar 2023 14:48:43 -0500
Message-ID: <CAH2r5mtbT2pEY=-r-RpKW-YSkhbeqxx9dBk0et8tJd6AsD66gA@mail.gmail.com>
Subject: Re: [PATCH] SMB3: Close deferred file handles if we get handle lease break
To:     bharathsm.hsk@gmail.com
Cc:     sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This looks like a very important patch (I could repro some of the problems
he mentioned in other threads) - tentatively merged into cifs-2.6.git for-n=
ext

Am testing now - but let me know if anyone sees any problems with this.

On Thu, Mar 23, 2023 at 2:07=E2=80=AFPM <bharathsm.hsk@gmail.com> wrote:
>
> From: Bharath SM <bharathsm@microsoft.com>
>
> We should not cache deferred file handles if we dont have
> handle lease on a file. And we should immediately close all
> deferred handles in case of handle lease break.
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> Fixes: 9e31678fb403 ("SMB3: fix lease break timeout when multiple deferre=
d close handles for the same file.")
> ---
>  fs/cifs/cifsproto.h |  3 ++-
>  fs/cifs/file.c      | 21 +++++++++++++++++++++
>  fs/cifs/misc.c      |  4 ++--
>  3 files changed, 25 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index e2eff66eefab..d2819d449f05 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -278,7 +278,8 @@ extern void cifs_add_deferred_close(struct cifsFileIn=
fo *cfile,
>
>  extern void cifs_del_deferred_close(struct cifsFileInfo *cfile);
>
> -extern void cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode);
> +extern void cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode,
> +                                    bool wait_oplock_handler);
>
>  extern void cifs_close_all_deferred_files(struct cifs_tcon *cifs_tcon);
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 4d4a2d82636d..ce75d8c1e3fe 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -4884,6 +4884,9 @@ void cifs_oplock_break(struct work_struct *work)
>         struct cifsInodeInfo *cinode =3D CIFS_I(inode);
>         struct cifs_tcon *tcon =3D tlink_tcon(cfile->tlink);
>         struct TCP_Server_Info *server =3D tcon->ses->server;
> +       bool is_deferred =3D false;
> +       struct cifs_deferred_close *dclose;
> +
>         int rc =3D 0;
>         bool purge_cache =3D false;
>
> @@ -4921,6 +4924,23 @@ void cifs_oplock_break(struct work_struct *work)
>                 cifs_dbg(VFS, "Push locks rc =3D %d\n", rc);
>
>  oplock_break_ack:
> +       /*
> +        * When oplock break is received and there are no active file han=
dles
> +        * but cached file handles, then schedule deferred close immediat=
ely.
> +        * So, new open will not use cached handle.
> +        */
> +       spin_lock(&CIFS_I(inode)->deferred_lock);
> +       is_deferred =3D cifs_is_deferred_close(cfile, &dclose);
> +       spin_unlock(&CIFS_I(inode)->deferred_lock);
> +       if (!CIFS_CACHE_HANDLE(cinode) && is_deferred &&
> +                       cfile->deferred_close_scheduled && delayed_work_p=
ending(&cfile->deferred)) {
> +               if (cancel_delayed_work(&cfile->deferred)) {
> +                       _cifsFileInfo_put(cfile, false, false);
> +                       cifs_close_deferred_file(cinode, false);
> +                       goto oplock_break_done;
> +               }
> +       }
> +
>         /*
>          * releasing stale oplock after recent reconnect of smb session u=
sing
>          * a now incorrect file handle is not a data integrity issue but =
do
> @@ -4933,6 +4953,7 @@ void cifs_oplock_break(struct work_struct *work)
>                 cifs_dbg(FYI, "Oplock release rc =3D %d\n", rc);
>         }
>
> +oplock_break_done:
>         _cifsFileInfo_put(cfile, false /* do not wait for ourself */, fal=
se);
>         cifs_done_oplock_break(cinode);
>  }
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index a0d286ee723d..fd9d6b1ee1e2 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -728,7 +728,7 @@ cifs_del_deferred_close(struct cifsFileInfo *cfile)
>  }
>
>  void
> -cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
> +cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode, bool wait_opl=
ock_handler)
>  {
>         struct cifsFileInfo *cfile =3D NULL;
>         struct file_list *tmp_list, *tmp_next_list;
> @@ -755,7 +755,7 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_i=
node)
>         spin_unlock(&cifs_inode->open_file_lock);
>
>         list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, lis=
t) {
> -               _cifsFileInfo_put(tmp_list->cfile, true, false);
> +               _cifsFileInfo_put(tmp_list->cfile, wait_oplock_handler, f=
alse);
>                 list_del(&tmp_list->list);
>                 kfree(tmp_list);
>         }
> --
> 2.25.1
>


--=20
Thanks,

Steve
