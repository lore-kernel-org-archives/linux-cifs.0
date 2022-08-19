Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA6BDC32771
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Aug 2022 10:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348313AbiHSKFq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Aug 2022 06:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348061AbiHSKFo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 19 Aug 2022 06:05:44 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D99EEF1E
        for <linux-cifs@vger.kernel.org>; Fri, 19 Aug 2022 03:05:43 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id v4so4121838ljg.0
        for <linux-cifs@vger.kernel.org>; Fri, 19 Aug 2022 03:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=I/9Odi99bpORRjsp2NGeqk65+nhWV0L7uOWhJbCnn3o=;
        b=kW32C+pCvOX7K5j6NIMf+mI57KZtcn41vYsCkelNqk4wJn/jPgyWHNpRkAgPeeMkJG
         lB8c3pbkpZO2YCt/zq7dm8mmcMO1+cX7L51jfRmdyCkLWPs4qpuGkSuQaQJstutT0bz8
         EPuVqs12O81XJ1ffO6kUDehMpCfSgKqWZEhMJBQiwTYc0zRp6w3NHMMYev0uew8vqWPR
         1zPMWLhQzjKpQmyFgD4sjAZjsn1mvOOmc1dbzNEdWKNZaYw8g4HLi2JpviREfBEbaT54
         0p6qbpRiopYhomFLKBw/yphAsUcxJDD+jGjP0P4RMibA2o2tiCwodkFpTHk4XjUSTrFY
         8axA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=I/9Odi99bpORRjsp2NGeqk65+nhWV0L7uOWhJbCnn3o=;
        b=W1ihlFBsqsZyX0C+hdgv6HJA32pZXSQlCZxveRNjd5I/6w3mP+nGIz5ltfpgAimiFw
         w5RpMEzcrKSV3xhq4MQ4l+Z3qOCb05MQPOMgK5cQwzu1sGXvUcRxxVaAo4N0huICMDcX
         QX+X/xPL+oMDxpFpJNOLwAPMHyS0iUi5KXnExLe/QyQ7r3pPnNKdqUjMwvoWSXTIYxMh
         OIRAa1D/QCo3bR64UUjV9zKsU+7R97muvoeKsJeruAPHc5hGeJrHF+u/ZdBflawiMmY5
         cS7flhI+lh2siwghsQVEJ+oz9r3GF/E5JtYiKl+M0mQSwZw369QpsEm23Y/pcC8hwj9P
         g7mA==
X-Gm-Message-State: ACgBeo0jXZczTVDALJljafC5caE4YmkYdRr6QywZzbDWDcIXVptjV0KM
        f2KUN3naSl8i8X8RMpMUPaUZ/r7vQ3tQfRK8b3c=
X-Google-Smtp-Source: AA6agR5M8r5Gzz0fahCuzNGEv2DoM9BiD97AbFCzvjdfdi+7XJVXlaNVJhhoFB04OBehyfflNUWCq2cpkM4/jyxnBjI=
X-Received: by 2002:a2e:834b:0:b0:261:a7a4:d2d2 with SMTP id
 l11-20020a2e834b000000b00261a7a4d2d2mr1841009ljh.175.1660903541413; Fri, 19
 Aug 2022 03:05:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220818135044.2251342-1-zhangxiaoxu5@huawei.com>
 <CAH2r5muzC3oSXKBO=p8b5e_MFTvLhitZrcMeqocyBZfidRd+fQ@mail.gmail.com>
 <489b6c7f-0290-9eb7-621e-45e785b3f5b9@huawei.com> <CAH2r5mtNS7ThH7QwYOewghx3HQ4nPaiZr_5PZZ+jCjbPdgxOYw@mail.gmail.com>
In-Reply-To: <CAH2r5mtNS7ThH7QwYOewghx3HQ4nPaiZr_5PZZ+jCjbPdgxOYw@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 19 Aug 2022 15:35:30 +0530
Message-ID: <CANT5p=q2rp528NfOiaT8xEHNw2_Vkix2r42bsRL9D8CowWDmbA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix memory leak on the deferred close
To:     Steve French <smfrench@gmail.com>
Cc:     "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>, Paulo Alcantara <pc@cjr.nz>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Rohith Surabattula <rohiths@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Aug 19, 2022 at 8:29 AM Steve French <smfrench@gmail.com> wrote:
>
> Don't see any problems with this - but would like to run some more tests =
on it
>
> On Thu, Aug 18, 2022 at 8:24 PM zhangxiaoxu (A) <zhangxiaoxu5@huawei.com>=
 wrote:
> >
> > running generic/029 and scan kmemleak on backend report this issue.
> >
> > =E5=9C=A8 2022/8/19 0:28, Steve French =E5=86=99=E9=81=93:
> > > looks promising - am reviewing this now.  Which xfstest did you see
> > > this when runnign?
> > >
> > > On Thu, Aug 18, 2022 at 8:01 AM Zhang Xiaoxu <zhangxiaoxu5@huawei.com=
> wrote:
> > >>
> > >> xfstests on smb21 report kmemleak as below:
> > >>
> > >>    unreferenced object 0xffff8881767d6200 (size 64):
> > >>      comm "xfs_io", pid 1284, jiffies 4294777434 (age 20.789s)
> > >>      hex dump (first 32 bytes):
> > >>        80 5a d0 11 81 88 ff ff 78 8a aa 63 81 88 ff ff  .Z......x..c=
....
> > >>        00 71 99 76 81 88 ff ff 00 00 00 00 00 00 00 00  .q.v........=
....
> > >>      backtrace:
> > >>        [<00000000ad04e6ea>] cifs_close+0x92/0x2c0
> > >>        [<0000000028b93c82>] __fput+0xff/0x3f0
> > >>        [<00000000d8116851>] task_work_run+0x85/0xc0
> > >>        [<0000000027e14f9e>] do_exit+0x5e5/0x1240
> > >>        [<00000000fb492b95>] do_group_exit+0x58/0xe0
> > >>        [<00000000129a32d9>] __x64_sys_exit_group+0x28/0x30
> > >>        [<00000000e3f7d8e9>] do_syscall_64+0x35/0x80
> > >>        [<00000000102e8a0b>] entry_SYSCALL_64_after_hwframe+0x46/0xb0
> > >>
> > >> When cancel the deferred close work, we should also cleanup the stru=
ct
> > >> cifs_deferred_close.
> > >>
> > >> Fixes: 9e992755be8f2 ("cifs: Call close synchronously during unlink/=
rename/lease break.")
> > >> Fixes: e3fc065682ebb ("cifs: Deferred close performance improvements=
")
> > >> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
> > >> ---
> > >>   fs/cifs/misc.c | 6 ++++++
> > >>   1 file changed, 6 insertions(+)
> > >>
> > >> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> > >> index 1f2628ffe9d7..87f60f736731 100644
> > >> --- a/fs/cifs/misc.c
> > >> +++ b/fs/cifs/misc.c
> > >> @@ -737,6 +737,8 @@ cifs_close_deferred_file(struct cifsInodeInfo *c=
ifs_inode)
> > >>          list_for_each_entry(cfile, &cifs_inode->openFileList, flist=
) {
> > >>                  if (delayed_work_pending(&cfile->deferred)) {
> > >>                          if (cancel_delayed_work(&cfile->deferred)) =
{
> > >> +                               cifs_del_deferred_close(cfile);
> > >> +
> > >>                                  tmp_list =3D kmalloc(sizeof(struct =
file_list), GFP_ATOMIC);
> > >>                                  if (tmp_list =3D=3D NULL)
> > >>                                          break;
> > >> @@ -766,6 +768,8 @@ cifs_close_all_deferred_files(struct cifs_tcon *=
tcon)
> > >>          list_for_each_entry(cfile, &tcon->openFileList, tlist) {
> > >>                  if (delayed_work_pending(&cfile->deferred)) {
> > >>                          if (cancel_delayed_work(&cfile->deferred)) =
{
> > >> +                               cifs_del_deferred_close(cfile);
> > >> +
> > >>                                  tmp_list =3D kmalloc(sizeof(struct =
file_list), GFP_ATOMIC);
> > >>                                  if (tmp_list =3D=3D NULL)
> > >>                                          break;
> > >> @@ -799,6 +803,8 @@ cifs_close_deferred_file_under_dentry(struct cif=
s_tcon *tcon, const char *path)
> > >>                  if (strstr(full_path, path)) {
> > >>                          if (delayed_work_pending(&cfile->deferred))=
 {
> > >>                                  if (cancel_delayed_work(&cfile->def=
erred)) {
> > >> +                                       cifs_del_deferred_close(cfil=
e);
> > >> +
> > >>                                          tmp_list =3D kmalloc(sizeof=
(struct file_list), GFP_ATOMIC);
> > >>                                          if (tmp_list =3D=3D NULL)
> > >>                                                  break;
> > >> --
> > >> 2.31.1
> > >>
> > >
> > >
>
>
>
> --
> Thanks,
>
> Steve

Thanks Zhang for the fix.
Looks good to me.

--=20
Regards,
Shyam
