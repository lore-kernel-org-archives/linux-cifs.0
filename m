Return-Path: <SRS0=49Qs=SM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25973C10F11
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Apr 2019 17:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E64C620830
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Apr 2019 17:27:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cjXpTd5w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729209AbfDJR1b (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 10 Apr 2019 13:27:31 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38103 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728749AbfDJR1b (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 10 Apr 2019 13:27:31 -0400
Received: by mail-pl1-f196.google.com with SMTP id f36so1843263plb.5
        for <linux-cifs@vger.kernel.org>; Wed, 10 Apr 2019 10:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mhGR40Wjk05aHvo5VY75GSrrfKh7dELYt9zDQYR1jQc=;
        b=cjXpTd5wZLp58UW7TpeUEnhADYMpoDMBkk7EL8W3ZWWZUkREAoOIKjC8Ja8h0XtjNt
         p2JHyAq10xDqEo5VM2lgZhBKq6JBIaWd3So/x+w/ZVevNHLRdR1Vn55wVsvuQ/IkbPEG
         gaobtSIS7/V2+98j16oGcat8XQFPhBC+UOUw07AWz9NJDBjA3K0TE59JjLQeaniHl8js
         S+UHa44YZ0iDCTkoeggXPH2UjyNLIFDZjiZGxZz0ZbVVUi+VkisbEqK/3n9hFAA84RZ8
         I5BGdFSIyTpZOZUEiQmw0Xn4IMf/GPK7IueDpcyIRsn+/0fRqUYF8u4lfqEKVrVJzI+8
         8yfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mhGR40Wjk05aHvo5VY75GSrrfKh7dELYt9zDQYR1jQc=;
        b=FscTZ/cWDP6mXSeZhQafk+C/pUQHJicHLhn8uBOPBATs/6yICn3cKnqNArjyrUJCgz
         VwJWcNSSTXVDvlHYI7PGMxVbqt7835qNGu0hl0Tx2eI3dCYsbWmOglUi7/usuUjWtrpH
         XQ2eT5Epbtm7OlYA7yoNGjnYVQExuw0rd/2X5kA/36g2weAmQVDmqB2BlVFGkyEVwvpP
         MsEcf7/tt7ufKslrCr54pWS/vC7KBsuYKSg0UoSHkQojnZJZyoH9fN3Ax1yruOXmxhkb
         SEjY4IFTgVj1vHZVgmRanuI7Z2bGyMimFFL7OvLfp6KctrUNIb1E7yAMojUNQLwac98l
         8g+A==
X-Gm-Message-State: APjAAAXhXfv/twadnwBV7mgyQDfe5ZPTx1rKht8J180ji6FWJisgqyQu
        +sVWmrbIsXewCtBoEzSGE2zdcUC15T/Tq5qvq6E=
X-Google-Smtp-Source: APXvYqzaKiKhcirAwK4LKpUIS/3i8eDE06EI5DaIK5p+8LdMlYIU6siE8Up3wNSFEcFcC8inEJyZqCwIm+2LAIMHMQo=
X-Received: by 2002:a17:902:28e9:: with SMTP id f96mr23993692plb.190.1554917250449;
 Wed, 10 Apr 2019 10:27:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190410014158.27517-1-xifeng@redhat.com> <CAH2r5mvPYod-H0CVt7WEij1neO3fPu9h22Yi-EG=Wfqo-0F44w@mail.gmail.com>
 <1065228238.2702965.1554867616002.JavaMail.zimbra@redhat.com> <992655431.2748492.1554889616432.JavaMail.zimbra@redhat.com>
In-Reply-To: <992655431.2748492.1554889616432.JavaMail.zimbra@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 10 Apr 2019 12:27:16 -0500
Message-ID: <CAH2r5mtLZ-xhFntJCF389_2wEM1rnUboMfFORgiJv2j1QSDFCQ@mail.gmail.com>
Subject: Re: [PATCH v2] CIFS: display noacl in the mount options
To:     Xiaoli Feng <xifeng@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        "fengxiaoli0714@gmai.com" <fengxiaoli0714@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Apr 10, 2019 at 4:46 AM Xiaoli Feng <xifeng@redhat.com> wrote:
>
>
> Maybe we should change the option "acl|noacl" to "posixacl|noposixacl".

That could be better although I lean toward waiting until we
experiment a little more with the SMB3.1.1 POSIX Extensions and any
additional mount options for them.


> ----- Original Message -----
> > From: "Xiaoli Feng" <xifeng@redhat.com>
> > To: "Steve French" <smfrench@gmail.com>
> > Cc: "CIFS" <linux-cifs@vger.kernel.org>, "fengxiaoli0714@gmai.com" <fengxiaoli0714@gmail.com>
> > Sent: Wednesday, April 10, 2019 11:40:16 AM
> > Subject: Re: [PATCH v2] CIFS: display noacl in the mount options
> >
> > Yes, could get users confused. But from the Man page:
> >
> >        noacl  Do not allow POSIX ACL operations even if server would support
> >        them.
> >               The  CIFS  client  can get and set POSIX ACLs (getfacl,
> >               setfacl) to Samba servers version 3.0.10 and later. Setting
> >               POSIX ACLs requires enabling both CIFS_XATTR and then
> >               CIFS_POSIX support in the CIFS configuration options when
> >               building the cifs module. POSIX ACL support can be disabled on
> >               a per mount basis by specifying noacl on mount.
> >
> >        cifsacl
> >               This option is used to map CIFS/NTFS ACLs to/from Linux
> >               permission bits, map SIDs to/from UIDs and GIDs, and get and
> >               set Security Descriptors.
> >               See section on CIFS/NTFS ACL, SID/UID/GID MAPPING, SECURITY
> >               DESCRIPTORS for more information.
> >
> > These two options are for different ACL. There is still a option "acl". It
> > also can be mounted with cifsacl together for SMB1.0.
> > There are some errors in my commit log. Should say "smb2.0+ don't support
> > POSIX ACL". What do you think about this patch? It also
> > makes sense if doesn't display "noacl".
> >
> > ----- Original Message -----
> > > From: "Steve French" <smfrench@gmail.com>
> > > To: "XiaoLi Feng" <xifeng@redhat.com>
> > > Cc: "CIFS" <linux-cifs@vger.kernel.org>, "fengxiaoli0714@gmai.com"
> > > <fengxiaoli0714@gmail.com>
> > > Sent: Wednesday, April 10, 2019 10:56:19 AM
> > > Subject: Re: [PATCH v2] CIFS: display noacl in the mount options
> > >
> > > Could this get users confused who mount with "cifsacl" and see "noacl" as
> > > well?
> > >
> > > Also this is really saying no support for "POSIX (draft standard) ACL
> > > support" not no support for SMB3 ACL (or similarly "RichACL" or NFS
> > > ACL or ... NTFS ACL or ... which are somewhat similar and common).
> > >
> > > Could get confusing
> > >
> > > On Tue, Apr 9, 2019 at 8:43 PM XiaoLi Feng <xifeng@redhat.com> wrote:
> > > >
> > > > From: "fengxiaoli0714@gmai.com" <fengxiaoli0714@gmail.com>
> > > >
> > > > The mount option noacl aren't shown in /proc/mounts
> > > > even if they are mounted successfully. And smb2.0+
> > > > don't support ACL. Display noacl acquiescently if ACL
> > > > is unsupported.
> > > >
> > > > Signed-off-by: fengxiaoli0714@gmai.com <fengxiaoli0714@gmail.com>
> > > > ---
> > > >  fs/cifs/cifsfs.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > > > index f9b71c12cc9f..80ee4fbcd25b 100644
> > > > --- a/fs/cifs/cifsfs.c
> > > > +++ b/fs/cifs/cifsfs.c
> > > > @@ -535,6 +535,8 @@ cifs_show_options(struct seq_file *s, struct dentry
> > > > *root)
> > > >                 seq_puts(s, ",dynperm");
> > > >         if (root->d_sb->s_flags & SB_POSIXACL)
> > > >                 seq_puts(s, ",acl");
> > > > +       else
> > > > +               seq_puts(s, ",noacl");
> > > >         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
> > > >                 seq_puts(s, ",mfsymlinks");
> > > >         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)
> > > > --
> > > > 2.18.1
> > > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> > >
> >



-- 
Thanks,

Steve
