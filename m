Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D49C43334
	for <linux-cifs@archiver.kernel.org>; Sun,  5 Jun 2022 11:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241156AbiFELB0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 5 Jun 2022 07:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232695AbiFELBZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 5 Jun 2022 07:01:25 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56322FE4E
        for <linux-cifs@vger.kernel.org>; Sun,  5 Jun 2022 04:01:23 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id k4so11387339vsp.3
        for <linux-cifs@vger.kernel.org>; Sun, 05 Jun 2022 04:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T57DzE1a+rfHF5vwDlZCSjEzhalOom7Y2d/yaDhAOXg=;
        b=nhmjt3/5UkoVNe0yRgNoH4HALatrcvrtokQSksaQy824x8qi6oMjW2lSZ3i3pT1YIM
         Wu5+KXgoygidyhF22vroer152RlGd6oIBpr74VCe1jX2vyc3a8KpTiOqGqamXPvtKcos
         Lk32zGXioR9CBe55GR5jGgijHa+pVfhWmc6mP9ML6ijCNkeYJd7hLOJMdd95y5lyRsR1
         UUQ2fPGTEInpj/i+4hh+sRztEJECqR9vJA/JgTU+6GsYZ3zH2Fyz1TQyAnc41idvEkR2
         Hak90lFb/cizHbsgleFXuwRm/8u6LiDJ7lJ4NuVKDBmtB4KJ9yWlPELSt0wluqhyCX5g
         T0hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T57DzE1a+rfHF5vwDlZCSjEzhalOom7Y2d/yaDhAOXg=;
        b=55QX+J2u6hPjXhnGiriNgWZLOeWu9l3xjwzDCui+ze2zHiMqvMVPd2aIL8laUlKVpr
         mw3lxzXSbgjDIBTuTNwBIB7YMJwykF2asGzeTkzqHn2rIHGo5frLUaagqd8bwxH3HbhY
         TpjHb7xcz/AZxNxNF7VSZp4pn8WRm2cPFmbgE9M3A4ALamlA9TfqRwTtHwF0kNOG9mJa
         MNX9nO9/YQJxFriy2o4XYfJL7cB9i4a0r2UKJ+8nEtBnPM8PJxn78tEXSNd1p0RmPOH3
         TUFG/lwTd06Vsl90WIIS8JLC9EnJkLaQvP15aCBcXuQZALc9ohd3K6aj60K8jkkLhxoV
         IgdQ==
X-Gm-Message-State: AOAM531EnGfYjrPa/OC6jmleztz3QDpRblw3wg0Ob5qn5l0XN9RdkSEU
        Zfq7cfVPxu9nKdLX7T2kQowhOiLgaFCsmqSfRUw=
X-Google-Smtp-Source: ABdhPJyVyIS3nOKCqX5thnZgmcpLDJkLRQ7w20lDFFUYm+9mr8W1CFAWvPgAK859/Is9UCCxD08O1V/jkU6BQCirZg4=
X-Received: by 2002:a67:df98:0:b0:320:8446:7c6d with SMTP id
 x24-20020a67df98000000b0032084467c6dmr35264162vsk.16.1654426882308; Sun, 05
 Jun 2022 04:01:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAFrh3J9soC36+BVuwHB=g9z_KB5Og2+p2_W+BBoBOZveErz14w@mail.gmail.com>
 <87k09wz0ec.fsf@cjr.nz> <CAFrh3J9Mrnw0bhJ-S3wYoZfNkKB-QjcLa5=r+vXMNudZ+zATFA@mail.gmail.com>
In-Reply-To: <CAFrh3J9Mrnw0bhJ-S3wYoZfNkKB-QjcLa5=r+vXMNudZ+zATFA@mail.gmail.com>
From:   Satadru Pramanik <satadru@gmail.com>
Date:   Sun, 5 Jun 2022 07:01:10 -0400
Message-ID: <CAFrh3J8c5cLhDpbDxOCL0XOx_UAN23_hnhMRy+NLqmRSC46rGQ@mail.gmail.com>
Subject: Re: Failure to access cifs mount of samba share after resume from
 sleep with 5.17-rc5
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I can confirm that the patch fixes the issue on 5.18.1 as well.

Thanks again!

Satadru

On Sat, Jun 4, 2022 at 10:31 PM Satadru Pramanik <satadru@gmail.com> wrote:
>
> The patch appears to fix the issue on the problematic bisected
> pre-5.16 kernel. (I let the machine sleep for 3 hours and the mount
> still worked after resume.)
>
> I'm now booted into a 5.18.1 kernel with this patch, and I'll be able
> to tell tomorrow morning if this also resolves the issue with this
> newer kernel.
>
> Thanks for the help in getting this issue resolved!
>
> Regards,
>
> Satadru
>
> On Sat, Jun 4, 2022 at 3:36 PM Paulo Alcantara <pc@cjr.nz> wrote:
> >
> > Hi Satadru,
> >
> > Thanks for providing all requested files off-list.  With that, I ended
> > up with below changes that should fix your issue.  Please let us if it
> > works.
> >
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index 12c872800326..325423180fd2 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -1086,7 +1086,7 @@ struct file_system_type cifs_fs_type = {
> >  };
> >  MODULE_ALIAS_FS("cifs");
> >
> > -static struct file_system_type smb3_fs_type = {
> > +struct file_system_type smb3_fs_type = {
> >         .owner = THIS_MODULE,
> >         .name = "smb3",
> >         .init_fs_context = smb3_init_fs_context,
> > diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> > index dd7e070ca243..b17be47a8e59 100644
> > --- a/fs/cifs/cifsfs.h
> > +++ b/fs/cifs/cifsfs.h
> > @@ -38,7 +38,7 @@ static inline unsigned long cifs_get_time(struct dentry *dentry)
> >         return (unsigned long) dentry->d_fsdata;
> >  }
> >
> > -extern struct file_system_type cifs_fs_type;
> > +extern struct file_system_type cifs_fs_type, smb3_fs_type;
> >  extern const struct address_space_operations cifs_addr_ops;
> >  extern const struct address_space_operations cifs_addr_ops_smallbuf;
> >
> > diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> > index 35962a1a23b9..eeb2a2957a68 100644
> > --- a/fs/cifs/misc.c
> > +++ b/fs/cifs/misc.c
> > @@ -1211,8 +1211,12 @@ static struct super_block *__cifs_get_super(void (*f)(struct super_block *, void
> >                 .data = data,
> >                 .sb = NULL,
> >         };
> > +       struct file_system_type **fs_type = (struct file_system_type *[]) {
> > +               &cifs_fs_type, &smb3_fs_type, NULL,
> > +       };
> >
> > -       iterate_supers_type(&cifs_fs_type, f, &sd);
> > +       for (; *fs_type; fs_type++)
> > +               iterate_supers_type(*fs_type, f, &sd);
> >
> >         if (!sd.sb)
> >                 return ERR_PTR(-EINVAL);
