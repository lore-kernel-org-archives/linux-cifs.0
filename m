Return-Path: <SRS0=49Qs=SM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE1D2C10F0E
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Apr 2019 02:35:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7DC52084F
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Apr 2019 02:35:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfDJCfX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Apr 2019 22:35:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58804 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbfDJCfW (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 9 Apr 2019 22:35:22 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9C00D307D960;
        Wed, 10 Apr 2019 02:35:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 909CE5C666;
        Wed, 10 Apr 2019 02:35:22 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 836EE41F3C;
        Wed, 10 Apr 2019 02:35:22 +0000 (UTC)
Date:   Tue, 9 Apr 2019 22:35:22 -0400 (EDT)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     Kenneth Dsouza <kdsouza@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        "fengxiaoli0714@gmai.com" <fengxiaoli0714@gmail.com>
Message-ID: <1802884205.2699298.1554863722130.JavaMail.zimbra@redhat.com>
In-Reply-To: <CAA_-hQJjJUGKTRenzqgSCjsc9BnL1B=aGgfBZjF+O6yywiovSg@mail.gmail.com>
References: <20190409131716.15212-1-xifeng@redhat.com> <CAA_-hQJjJUGKTRenzqgSCjsc9BnL1B=aGgfBZjF+O6yywiovSg@mail.gmail.com>
Subject: Re: [PATCH v1] CIFS: display noacl and locallease in the mount
 options
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.12.126, 10.4.195.5]
Thread-Topic: CIFS: display noacl and locallease in the mount options
Thread-Index: ct29LDoAzldcD5Ao3081El8s+JVH4A==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 10 Apr 2019 02:35:22 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Kenneth,

Now re-sended it. By the way, suddenly I have an idea. Such as for your this
patch, I suppose you see the bug 

  https://bugzilla.redhat.com/show_bug.cgi?id=1662406
  Bug 1662406 - [RHEL8 cifs]: the option locallease isn't shown in /proc/mounts

and then send this patch. I think it's better that add the bugzilla info in the
commit log. Just my opinion. But if you didn't see this bugzilla, ignore what
I said.

Thanks.

----- Original Message -----
> From: "Kenneth Dsouza" <kdsouza@redhat.com>
> To: "XiaoLi Feng" <xifeng@redhat.com>
> Cc: "CIFS" <linux-cifs@vger.kernel.org>, "fengxiaoli0714@gmai.com" <fengxiaoli0714@gmail.com>
> Sent: Tuesday, April 9, 2019 9:59:39 PM
> Subject: Re: [PATCH v1] CIFS: display noacl and locallease in the mount options
> 
> We already have locallease patch in for next.
> https://git.samba.org/?p=sfrench/cifs-2.6.git;a=commit;h=1d4fcc75b71f8a9f9807a000da53d9885546e2f3
> Can you resend this patch only for noacl?
> 
> On Tue, Apr 9, 2019 at 6:47 PM XiaoLi Feng <xifeng@redhat.com> wrote:
> >
> > From: "fengxiaoli0714@gmai.com" <fengxiaoli0714@gmail.com>
> >
> > The mount option noacl and locallease aren't shown in /proc/mounts
> > even if they are mounted successfully. Now display them.
> >
> > Signed-off-by: fengxiaoli0714@gmai.com <fengxiaoli0714@gmail.com>
> > ---
> >  fs/cifs/cifsfs.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index f9b71c12cc9f..44dbace210d2 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -503,6 +503,8 @@ cifs_show_options(struct seq_file *s, struct dentry
> > *root)
> >                 seq_puts(s, ",unix");
> >         else
> >                 seq_puts(s, ",nounix");
> > +       if (tcon->local_lease)
> > +               seq_puts(s, ",locallease");
> >         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_DFS)
> >                 seq_puts(s, ",nodfs");
> >         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
> > @@ -535,6 +537,8 @@ cifs_show_options(struct seq_file *s, struct dentry
> > *root)
> >                 seq_puts(s, ",dynperm");
> >         if (root->d_sb->s_flags & SB_POSIXACL)
> >                 seq_puts(s, ",acl");
> > +       else
> > +               seq_puts(s, ",noacl");
> >         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
> >                 seq_puts(s, ",mfsymlinks");
> >         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)
> > --
> > 2.18.1
> >
> 
