Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C05AFC00140
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Aug 2022 02:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235159AbiHSCyN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Aug 2022 22:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344112AbiHSCyM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Aug 2022 22:54:12 -0400
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C605ABD09F
        for <linux-cifs@vger.kernel.org>; Thu, 18 Aug 2022 19:54:09 -0700 (PDT)
Received: by mail-vk1-xa35.google.com with SMTP id q14so1670042vke.9
        for <linux-cifs@vger.kernel.org>; Thu, 18 Aug 2022 19:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=RaRHQ7NK25yTyLLB3ir1d2AGDg2WTmUCLFYlVNawnn4=;
        b=cDsm83xHvZwn37akejiLBYef1OjCg/WPot4Mxqhln0RY5l7eadIrpMqRKPCGBFTj5w
         eZyqW1nXXw2HVAOCa1PGjJ1tCEkS6Fy9HJaYKuBZq6TTUhqwdZjsPXjoZiUjb4hqOqDU
         PB3zMCqqLBUR3wkVyC05+UmTfqOPVXoO1iuLaFC74KhVG9qTsF2xZ2AElelpadNhbWKA
         G350dR04AIEMWH/bJLQBy6Ns+w4LZ+r4xd3lF5mQ+YdZ/TbU8M0v/fZeo+WsC4w1qNP4
         ZuDyrVfK6SXes4V+zDV3R1qW8QT/4xOzMVehXQJlNmSa63Wpau7YPlM+1cqC6j2nV7CI
         cp+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=RaRHQ7NK25yTyLLB3ir1d2AGDg2WTmUCLFYlVNawnn4=;
        b=hNAWficdbp92HIMS1lOkTlmg5pWT6Ose6xDtUQS2gs+mV67R15MKifb9D9lJadNOIu
         DD8PRjuvHrb8Tn6Pv8xLcgrVMM3Cbh+2l4pL4oIXYgOib4qbFHo2mLZmAD23SiKh+ppD
         hgAqMxyg0U4BGKKvYuT43R1ebVs6Fp89XdG3w0D8Af751mkId/kUn0y1nNBYJkiJ6z+s
         AYnXNOY2Gwba72R2pOZQk2Lo+8cm/4RmaHvwohGXBEOeZqr3LJxdBa1aXFoGyay9UxtZ
         GHZRzAq+ISN2EsAQVpdddvlj0CNXtYl5sKYEpBOB85BPuxGnZjfC9aYB9XzYeMIqKrvI
         SLSw==
X-Gm-Message-State: ACgBeo3ExjH1Hz5FtqK8Z84aVO6yw/YBMuhmeuhzWFYwXyMh1RTsHC4M
        g54yhPcnNontI8AHRzjjGPGA3CNzMXxdWRiLdwghlThwPg0=
X-Google-Smtp-Source: AA6agR5Bh058+Y41cJKPc6ayw+bxcNpyiI7vuTxTiMpjhp4lm9hMfl8kV9o8dEbCzm64S2upFn4vc1PeGNX5vmRt9Qo=
X-Received: by 2002:a1f:51c2:0:b0:37c:f131:e749 with SMTP id
 f185-20020a1f51c2000000b0037cf131e749mr2293193vkb.38.1660877648544; Thu, 18
 Aug 2022 19:54:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220818135044.2251342-1-zhangxiaoxu5@huawei.com>
 <CAH2r5muzC3oSXKBO=p8b5e_MFTvLhitZrcMeqocyBZfidRd+fQ@mail.gmail.com> <489b6c7f-0290-9eb7-621e-45e785b3f5b9@huawei.com>
In-Reply-To: <489b6c7f-0290-9eb7-621e-45e785b3f5b9@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 18 Aug 2022 21:53:57 -0500
Message-ID: <CAH2r5mtNS7ThH7QwYOewghx3HQ4nPaiZr_5PZZ+jCjbPdgxOYw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix memory leak on the deferred close
To:     "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>, rohiths@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Don't see any problems with this - but would like to run some more tests on=
 it

On Thu, Aug 18, 2022 at 8:24 PM zhangxiaoxu (A) <zhangxiaoxu5@huawei.com> w=
rote:
>
> running generic/029 and scan kmemleak on backend report this issue.
>
> =E5=9C=A8 2022/8/19 0:28, Steve French =E5=86=99=E9=81=93:
> > looks promising - am reviewing this now.  Which xfstest did you see
> > this when runnign?
> >
> > On Thu, Aug 18, 2022 at 8:01 AM Zhang Xiaoxu <zhangxiaoxu5@huawei.com> =
wrote:
> >>
> >> xfstests on smb21 report kmemleak as below:
> >>
> >>    unreferenced object 0xffff8881767d6200 (size 64):
> >>      comm "xfs_io", pid 1284, jiffies 4294777434 (age 20.789s)
> >>      hex dump (first 32 bytes):
> >>        80 5a d0 11 81 88 ff ff 78 8a aa 63 81 88 ff ff  .Z......x..c..=
..
> >>        00 71 99 76 81 88 ff ff 00 00 00 00 00 00 00 00  .q.v..........=
..
> >>      backtrace:
> >>        [<00000000ad04e6ea>] cifs_close+0x92/0x2c0
> >>        [<0000000028b93c82>] __fput+0xff/0x3f0
> >>        [<00000000d8116851>] task_work_run+0x85/0xc0
> >>        [<0000000027e14f9e>] do_exit+0x5e5/0x1240
> >>        [<00000000fb492b95>] do_group_exit+0x58/0xe0
> >>        [<00000000129a32d9>] __x64_sys_exit_group+0x28/0x30
> >>        [<00000000e3f7d8e9>] do_syscall_64+0x35/0x80
> >>        [<00000000102e8a0b>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
> >>
> >> When cancel the deferred close work, we should also cleanup the struct
> >> cifs_deferred_close.
> >>
> >> Fixes: 9e992755be8f2 ("cifs: Call close synchronously during unlink/re=
name/lease break.")
> >> Fixes: e3fc065682ebb ("cifs: Deferred close performance improvements")
> >> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> >> ---
> >>   fs/cifs/misc.c | 6 ++++++
> >>   1 file changed, 6 insertions(+)
> >>
> >> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> >> index 1f2628ffe9d7..87f60f736731 100644
> >> --- a/fs/cifs/misc.c
> >> +++ b/fs/cifs/misc.c
> >> @@ -737,6 +737,8 @@ cifs_close_deferred_file(struct cifsInodeInfo *cif=
s_inode)
> >>          list_for_each_entry(cfile, &cifs_inode->openFileList, flist) =
{
> >>                  if (delayed_work_pending(&cfile->deferred)) {
> >>                          if (cancel_delayed_work(&cfile->deferred)) {
> >> +                               cifs_del_deferred_close(cfile);
> >> +
> >>                                  tmp_list =3D kmalloc(sizeof(struct fi=
le_list), GFP_ATOMIC);
> >>                                  if (tmp_list =3D=3D NULL)
> >>                                          break;
> >> @@ -766,6 +768,8 @@ cifs_close_all_deferred_files(struct cifs_tcon *tc=
on)
> >>          list_for_each_entry(cfile, &tcon->openFileList, tlist) {
> >>                  if (delayed_work_pending(&cfile->deferred)) {
> >>                          if (cancel_delayed_work(&cfile->deferred)) {
> >> +                               cifs_del_deferred_close(cfile);
> >> +
> >>                                  tmp_list =3D kmalloc(sizeof(struct fi=
le_list), GFP_ATOMIC);
> >>                                  if (tmp_list =3D=3D NULL)
> >>                                          break;
> >> @@ -799,6 +803,8 @@ cifs_close_deferred_file_under_dentry(struct cifs_=
tcon *tcon, const char *path)
> >>                  if (strstr(full_path, path)) {
> >>                          if (delayed_work_pending(&cfile->deferred)) {
> >>                                  if (cancel_delayed_work(&cfile->defer=
red)) {
> >> +                                       cifs_del_deferred_close(cfile)=
;
> >> +
> >>                                          tmp_list =3D kmalloc(sizeof(s=
truct file_list), GFP_ATOMIC);
> >>                                          if (tmp_list =3D=3D NULL)
> >>                                                  break;
> >> --
> >> 2.31.1
> >>
> >
> >



--=20
Thanks,

Steve
