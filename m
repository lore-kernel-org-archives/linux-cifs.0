Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5381C3F6B0
	for <linux-cifs@archiver.kernel.org>; Thu, 18 Aug 2022 16:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344600AbiHRQ21 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Aug 2022 12:28:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344227AbiHRQ20 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Aug 2022 12:28:26 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDFA1167D6
        for <linux-cifs@vger.kernel.org>; Thu, 18 Aug 2022 09:28:22 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id c3so1993291vsc.6
        for <linux-cifs@vger.kernel.org>; Thu, 18 Aug 2022 09:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=IvZh6EAKHKX6lMxF+fIvTSoE2SsnutgeNfmB7p2zOyo=;
        b=gEbzDfOb75SGVfednnK8H6b/LsWLVcuBxBcYAdVfOh32xzA4q4Fo9aIpHwDdGTaxj7
         mbI5FPECPLCez+Z3tbnCU2CnpTfOTtAsWUEPTJz54cjxsOTJemGuco5hGsEymnaZjJXD
         +nxRUIOaVvdE7OTz+E/Vxw6RiUnQ3EfVj8AGm/cBiUhEuU/pqIlJsrMVOGSA8foDGrca
         1rDzeo8lIGN5pPLtGHIG/AByEOlYvqqlWMEZ3bLMErE5Z6QCsGOFMiR50N9N1d/Z4Gx/
         hTcHv88Ou3T8e5JM5qnICaJ1sV/WThwiG4Ad6npdWtURBn3Kn8Ai1Tn1rLS4VIhi446K
         48Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=IvZh6EAKHKX6lMxF+fIvTSoE2SsnutgeNfmB7p2zOyo=;
        b=e5c5bobh/KSw1+VIQFpMlm5TBlify6lFHx1dVFQmeWFHyzNDfvQbpj2xoSmZL47W5M
         rIU/cK9NF4nlX/S2J/qYvuRlBMSlexQtveifqLWh+1MdihffNiEggK79cN48Ek1DPw6Z
         gCB8Ubj83UWyOTVWoTgRQlKj41Rg5J5nV+YF4x/KW4AV5TSYMKrJKJ5d5OXA9kEOszhB
         HUWC4/ordaxhGsDODQwWa7N8KomjpePJ4yde/1xrkcRylffYtDuTMXdq4xXGk2KA91Ln
         /OHmaua/oJnBcGPFDCSbobGRuNv5v0cLX9bgTaJCeQSQ96Sik8Rp7shseSqwm6smkT50
         BMRA==
X-Gm-Message-State: ACgBeo3ENYNVTCfA9XHXmzd92bs6t5Hbie79TnnYK5KalEF5iPinOzLf
        rqp8VNbDZiAkVq+Mgd6V4TygI+qerBywBu8kpxI=
X-Google-Smtp-Source: AA6agR4rKMWBMXwwp7ZAGrwyTN4p48q2b+9mHVJIes27Aatj04T+lFdW/PRTFfQcTKsLVWBCYh+EZNw+aAfi7ruzBEE=
X-Received: by 2002:a67:fc06:0:b0:388:955d:2535 with SMTP id
 o6-20020a67fc06000000b00388955d2535mr1371007vsq.6.1660840101886; Thu, 18 Aug
 2022 09:28:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220818135044.2251342-1-zhangxiaoxu5@huawei.com>
In-Reply-To: <20220818135044.2251342-1-zhangxiaoxu5@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 18 Aug 2022 11:28:11 -0500
Message-ID: <CAH2r5muzC3oSXKBO=p8b5e_MFTvLhitZrcMeqocyBZfidRd+fQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix memory leak on the deferred close
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>, rohiths@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

looks promising - am reviewing this now.  Which xfstest did you see
this when runnign?

On Thu, Aug 18, 2022 at 8:01 AM Zhang Xiaoxu <zhangxiaoxu5@huawei.com> wrote:
>
> xfstests on smb21 report kmemleak as below:
>
>   unreferenced object 0xffff8881767d6200 (size 64):
>     comm "xfs_io", pid 1284, jiffies 4294777434 (age 20.789s)
>     hex dump (first 32 bytes):
>       80 5a d0 11 81 88 ff ff 78 8a aa 63 81 88 ff ff  .Z......x..c....
>       00 71 99 76 81 88 ff ff 00 00 00 00 00 00 00 00  .q.v............
>     backtrace:
>       [<00000000ad04e6ea>] cifs_close+0x92/0x2c0
>       [<0000000028b93c82>] __fput+0xff/0x3f0
>       [<00000000d8116851>] task_work_run+0x85/0xc0
>       [<0000000027e14f9e>] do_exit+0x5e5/0x1240
>       [<00000000fb492b95>] do_group_exit+0x58/0xe0
>       [<00000000129a32d9>] __x64_sys_exit_group+0x28/0x30
>       [<00000000e3f7d8e9>] do_syscall_64+0x35/0x80
>       [<00000000102e8a0b>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
>
> When cancel the deferred close work, we should also cleanup the struct
> cifs_deferred_close.
>
> Fixes: 9e992755be8f2 ("cifs: Call close synchronously during unlink/rename/lease break.")
> Fixes: e3fc065682ebb ("cifs: Deferred close performance improvements")
> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> ---
>  fs/cifs/misc.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 1f2628ffe9d7..87f60f736731 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -737,6 +737,8 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
>         list_for_each_entry(cfile, &cifs_inode->openFileList, flist) {
>                 if (delayed_work_pending(&cfile->deferred)) {
>                         if (cancel_delayed_work(&cfile->deferred)) {
> +                               cifs_del_deferred_close(cfile);
> +
>                                 tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
>                                 if (tmp_list == NULL)
>                                         break;
> @@ -766,6 +768,8 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
>         list_for_each_entry(cfile, &tcon->openFileList, tlist) {
>                 if (delayed_work_pending(&cfile->deferred)) {
>                         if (cancel_delayed_work(&cfile->deferred)) {
> +                               cifs_del_deferred_close(cfile);
> +
>                                 tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
>                                 if (tmp_list == NULL)
>                                         break;
> @@ -799,6 +803,8 @@ cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
>                 if (strstr(full_path, path)) {
>                         if (delayed_work_pending(&cfile->deferred)) {
>                                 if (cancel_delayed_work(&cfile->deferred)) {
> +                                       cifs_del_deferred_close(cfile);
> +
>                                         tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
>                                         if (tmp_list == NULL)
>                                                 break;
> --
> 2.31.1
>


-- 
Thanks,

Steve
