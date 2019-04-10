Return-Path: <SRS0=49Qs=SM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB1A2C10F11
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Apr 2019 09:46:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76A2E20830
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Apr 2019 09:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729756AbfDJJq5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Apr 2019 05:46:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41704 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729737AbfDJJq4 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 10 Apr 2019 05:46:56 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ABBBA2D4B6E;
        Wed, 10 Apr 2019 09:46:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A1EE3608EB;
        Wed, 10 Apr 2019 09:46:56 +0000 (UTC)
Received: from zmail23.collab.prod.int.phx2.redhat.com (zmail23.collab.prod.int.phx2.redhat.com [10.5.83.28])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9585C41F3C;
        Wed, 10 Apr 2019 09:46:56 +0000 (UTC)
Date:   Wed, 10 Apr 2019 05:46:56 -0400 (EDT)
From:   Xiaoli Feng <xifeng@redhat.com>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        "fengxiaoli0714@gmai.com" <fengxiaoli0714@gmail.com>
Message-ID: <992655431.2748492.1554889616432.JavaMail.zimbra@redhat.com>
In-Reply-To: <1065228238.2702965.1554867616002.JavaMail.zimbra@redhat.com>
References: <20190410014158.27517-1-xifeng@redhat.com> <CAH2r5mvPYod-H0CVt7WEij1neO3fPu9h22Yi-EG=Wfqo-0F44w@mail.gmail.com> <1065228238.2702965.1554867616002.JavaMail.zimbra@redhat.com>
Subject: Re: [PATCH v2] CIFS: display noacl in the mount options
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.72.12.24, 10.4.195.14]
Thread-Topic: CIFS: display noacl in the mount options
Thread-Index: oqCU5ckFeAVeIgLfXU4pXf+eDSh3SJwmNtIU
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Wed, 10 Apr 2019 09:46:56 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Maybe we should change the option "acl|noacl" to "posixacl|noposixacl".

----- Original Message -----
> From: "Xiaoli Feng" <xifeng@redhat.com>
> To: "Steve French" <smfrench@gmail.com>
> Cc: "CIFS" <linux-cifs@vger.kernel.org>, "fengxiaoli0714@gmai.com" <fengxiaoli0714@gmail.com>
> Sent: Wednesday, April 10, 2019 11:40:16 AM
> Subject: Re: [PATCH v2] CIFS: display noacl in the mount options
> 
> Yes, could get users confused. But from the Man page:
> 
>        noacl  Do not allow POSIX ACL operations even if server would support
>        them.
>               The  CIFS  client  can get and set POSIX ACLs (getfacl,
>               setfacl) to Samba servers version 3.0.10 and later. Setting
>               POSIX ACLs requires enabling both CIFS_XATTR and then
>               CIFS_POSIX support in the CIFS configuration options when
>               building the cifs module. POSIX ACL support can be disabled on
>               a per mount basis by specifying noacl on mount.
> 
>        cifsacl
>               This option is used to map CIFS/NTFS ACLs to/from Linux
>               permission bits, map SIDs to/from UIDs and GIDs, and get and
>               set Security Descriptors.
>               See section on CIFS/NTFS ACL, SID/UID/GID MAPPING, SECURITY
>               DESCRIPTORS for more information.
> 
> These two options are for different ACL. There is still a option "acl". It
> also can be mounted with cifsacl together for SMB1.0.
> There are some errors in my commit log. Should say "smb2.0+ don't support
> POSIX ACL". What do you think about this patch? It also
> makes sense if doesn't display "noacl".
> 
> ----- Original Message -----
> > From: "Steve French" <smfrench@gmail.com>
> > To: "XiaoLi Feng" <xifeng@redhat.com>
> > Cc: "CIFS" <linux-cifs@vger.kernel.org>, "fengxiaoli0714@gmai.com"
> > <fengxiaoli0714@gmail.com>
> > Sent: Wednesday, April 10, 2019 10:56:19 AM
> > Subject: Re: [PATCH v2] CIFS: display noacl in the mount options
> > 
> > Could this get users confused who mount with "cifsacl" and see "noacl" as
> > well?
> > 
> > Also this is really saying no support for "POSIX (draft standard) ACL
> > support" not no support for SMB3 ACL (or similarly "RichACL" or NFS
> > ACL or ... NTFS ACL or ... which are somewhat similar and common).
> > 
> > Could get confusing
> > 
> > On Tue, Apr 9, 2019 at 8:43 PM XiaoLi Feng <xifeng@redhat.com> wrote:
> > >
> > > From: "fengxiaoli0714@gmai.com" <fengxiaoli0714@gmail.com>
> > >
> > > The mount option noacl aren't shown in /proc/mounts
> > > even if they are mounted successfully. And smb2.0+
> > > don't support ACL. Display noacl acquiescently if ACL
> > > is unsupported.
> > >
> > > Signed-off-by: fengxiaoli0714@gmai.com <fengxiaoli0714@gmail.com>
> > > ---
> > >  fs/cifs/cifsfs.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > > index f9b71c12cc9f..80ee4fbcd25b 100644
> > > --- a/fs/cifs/cifsfs.c
> > > +++ b/fs/cifs/cifsfs.c
> > > @@ -535,6 +535,8 @@ cifs_show_options(struct seq_file *s, struct dentry
> > > *root)
> > >                 seq_puts(s, ",dynperm");
> > >         if (root->d_sb->s_flags & SB_POSIXACL)
> > >                 seq_puts(s, ",acl");
> > > +       else
> > > +               seq_puts(s, ",noacl");
> > >         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
> > >                 seq_puts(s, ",mfsymlinks");
> > >         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)
> > > --
> > > 2.18.1
> > >
> > 
> > 
> > --
> > Thanks,
> > 
> > Steve
> > 
> 
