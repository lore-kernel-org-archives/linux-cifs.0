Return-Path: <SRS0=Y4Lp=XS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 968A9C49ED7
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Sep 2019 06:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A6AD20882
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Sep 2019 06:34:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s7KAS9I8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404435AbfIWGeC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Sep 2019 02:34:02 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:40722 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404432AbfIWGeC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 Sep 2019 02:34:02 -0400
Received: by mail-io1-f65.google.com with SMTP id h144so30682333iof.7
        for <linux-cifs@vger.kernel.org>; Sun, 22 Sep 2019 23:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0kwVFUe61nVokPUICnuht+1nWz+No6O7nlYuDMtUCMQ=;
        b=s7KAS9I8K4FTgVQKT1YheEH6Wvw+7bnMV/hjnTfBdMk40N9QkSPjmQ8VW7PIljxYtL
         f2Y1ensEAAUUX3MTapF72WFsCOymQzBfTbdwRg72QXIceaS5XlEpz+5jP1xNzKMlsAGr
         ZxY6hyRIURi+SXASALfoxeae8Hq/Nh2SFdm10RJ4H41qqCqZlVF3rgrHXhG9GUn48Tjd
         tYHbTRqTAez7BJECvToMbK//RMzxpo+uiG90L1Ebs2mLUoaHo0De7/WInk5bNrANDaYL
         PLTu/nW7dVVYl8V2nZbIhScMdmt9PJ1gxnm4oH7+4LyFQSq17iGm1zk4in3dLTGlaGnv
         XuJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0kwVFUe61nVokPUICnuht+1nWz+No6O7nlYuDMtUCMQ=;
        b=o3qpU2St/H9VANMjfthSS6QLMmo/gJbZCNQz5c3iAAjd5FY7WtAudJjhh6kmJ/SIQG
         s3r9RyHfqDX0O3e2/7LW/KLPbJ1+D6doR9LzPSFN0C72M5quZEUte8Sd5TyVJ7E+tfkX
         A3lkv0yPL9wpR9CmUcwLoOVfQ1lVXVPMA7IAL73JtbDXY5Q5BmNQLEzjd68LY0QN2Kds
         QDo1IyLnIhgW3TqXKtkZsjvtd+kkoABQieTEHB/TmK0hFgRuAvZj0qckqnz+TG5/dgNv
         QXUTq9Pd3PKnVl/AzDICkiyVni9lpv9G3RX3GEnJZ93qZXvVnjodSjid19Co6Co69iSz
         s9jA==
X-Gm-Message-State: APjAAAW7VKGe1XrUqqXEBenuHeHwzhBuTjvjkKpg00fwsPQODdQ90YDU
        xMwq2hsyutuG92/a5ve4QgcVJKd72nw2MnJ/yl8=
X-Google-Smtp-Source: APXvYqwKfDURx3tQe7I+WSpx+4A3fpX0Y/cInIJO/rI1bXkzqIQLWFKASChbU5y0fDgxONRqxfFZoK5EULm/vfFCBDQ=
X-Received: by 2002:a6b:2b07:: with SMTP id r7mr12786888ior.173.1569220440158;
 Sun, 22 Sep 2019 23:34:00 -0700 (PDT)
MIME-Version: 1.0
References: <1569046966-118677-1-git-send-email-zhengbin13@huawei.com>
 <CAH2r5mu+ytpDOcq4Au2AZe7M00p3XJnBVD2wO949G7Ud5bp=dQ@mail.gmail.com> <65f0ed75-045d-6b07-609c-a23d747d99f3@huawei.com>
In-Reply-To: <65f0ed75-045d-6b07-609c-a23d747d99f3@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 23 Sep 2019 01:33:49 -0500
Message-ID: <CAH2r5mtfEnA-E0xLi+C1PvaFOFbByT_UHjRO_CS4MbKpZipnkA@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs/smb2transport.c: Make some functions static
To:     "zhengbin (A)" <zhengbin13@huawei.com>
Cc:     "zhangyi (F)" <yi.zhang@huawei.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The code to call SMB2_change_notify (from an ioctl) should make it in
pretty soon (let's hope we can finish testing it this  week).   The
fix to inotify to allow inotify to call into a network file system
will be helpful in the long run, but in the short term at least a GUI
should be able to call into a cifs.ko specific ioctl soon for it.

On Mon, Sep 23, 2019 at 1:08 AM zhengbin (A) <zhengbin13@huawei.com> wrote:
>
>
> On 2019/9/23 13:07, Steve French wrote:
> > Thanks - merged into cifs-2.6.git for-next
> >
> > Aur=C3=A9lien -
> > FYI - it makes minor update to code you changed to remove the warning.
>
> We have a similar warning in fs/cifs/smb2pdu.c
>
> fs/cifs/smb2pdu.c:3184:1: warning: symbol 'SMB2_notify_init' was not decl=
ared. Should it be static?
> fs/cifs/smb2pdu.c:3213:1: warning: symbol 'SMB2_change_notify' was not de=
clared. Should it be static?
>
>
> while these two functions are introduced by commit af8d46ab49b8
>
> ("smb3: add missing worker function for SMB3 change notify"). SMB2_notify=
_init is called by SMB2_change_notify
>
> No one calls  SMB2_change_notify? Or we will call SMB2_change_notify in t=
he future?
>
> >
> >
> > On Sun, Sep 22, 2019 at 2:13 PM zhengbin <zhengbin13@huawei.com> wrote:
> >> Fix sparse warnings:
> >>
> >> fs/cifs/smb2transport.c:52:1: warning: symbol 'smb3_crypto_shash_alloc=
ate' was not declared. Should it be static?
> >> fs/cifs/smb2transport.c:101:4: warning: symbol 'smb2_find_chan_signkey=
' was not declared. Should it be static?
> >> fs/cifs/smb2transport.c:121:17: warning: symbol 'smb2_find_global_smb_=
ses' was not declared. Should it be static?
> >>
> >> Reported-by: Hulk Robot <hulkci@huawei.com>
> >> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> >> ---
> >>  fs/cifs/smb2transport.c | 7 ++++---
> >>  1 file changed, 4 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> >> index 12988df..7cc8641 100644
> >> --- a/fs/cifs/smb2transport.c
> >> +++ b/fs/cifs/smb2transport.c
> >> @@ -48,7 +48,7 @@ smb2_crypto_shash_allocate(struct TCP_Server_Info *s=
erver)
> >>                                &server->secmech.sdeschmacsha256);
> >>  }
> >>
> >> -int
> >> +static int
> >>  smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
> >>  {
> >>         struct cifs_secmech *p =3D &server->secmech;
> >> @@ -98,7 +98,8 @@ smb311_crypto_shash_allocate(struct TCP_Server_Info =
*server)
> >>         return rc;
> >>  }
> >>
> >> -u8 *smb2_find_chan_signkey(struct cifs_ses *ses, struct TCP_Server_In=
fo *server)
> >> +static u8 *
> >> +smb2_find_chan_signkey(struct cifs_ses *ses, struct TCP_Server_Info *=
server)
> >>  {
> >>         int i;
> >>         struct cifs_chan *chan;
> >> @@ -118,7 +119,7 @@ u8 *smb2_find_chan_signkey(struct cifs_ses *ses, s=
truct TCP_Server_Info *server)
> >>         return NULL;
> >>  }
> >>
> >> -struct cifs_ses *
> >> +static struct cifs_ses *
> >>  smb2_find_global_smb_ses(__u64 ses_id)
> >>  {
> >>         struct TCP_Server_Info *server;
> >> --
> >> 2.7.4
> >>
> >
>


--=20
Thanks,

Steve
