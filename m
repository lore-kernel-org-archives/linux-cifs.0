Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BBAC38BE2
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 19:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E74F72080D
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 19:36:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iWcXJhnF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgBXTg5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 14:36:57 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34683 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgBXTg5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 24 Feb 2020 14:36:57 -0500
Received: by mail-lf1-f67.google.com with SMTP id l18so7693325lfc.1
        for <linux-cifs@vger.kernel.org>; Mon, 24 Feb 2020 11:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ijjCxN/28FlXrGzuIcLcmSw3EaxMb4V10DErszQLBR4=;
        b=iWcXJhnFN9e+kmrej0AqWQpDtTqdUC6EfpyCJk160NKfBEEKNcLCVNgbrOwdZTN49t
         JahZJb6rDUcARKy4t6uwuwsGisqpMMiFOaRnGmT668m2NKc/siQSRYAN2+6pVUriqVL9
         3x6n1o2bEC5YMNTKgKB8zdMjMmYAoMBB/eU8gLo9Wigwnix1JMr6xHtbelRPAIAOLUSc
         1OLoiQJxI3E9blzSF35cOmZ/3AF5LwLfrHBDwrRytyFwGEMDAz+gG8Sl1TAQn7A/ysQY
         UFnwOx44kklvF7Z1afUZSRgPk0PBbAvt3S7/DS02YN5Ho0U0z35lWQaISNJzyStJOB7B
         m7Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ijjCxN/28FlXrGzuIcLcmSw3EaxMb4V10DErszQLBR4=;
        b=TmChjT4PWihM9y8NjzWUiI1s9QBnpOz6zfHGberLrnvgqmkqUVMcpnzFsVY7sEbiLT
         +Lk47jFdMTuVcl34/WnQZbtAEQaUladHuSYoeqWuXvUZgdqrJbbzOAQXX3uTy07q5LTa
         oa4oxdWtE6B7sVVzlvRafuR4dR0dOivaJKWAZTg2SSgS38v4ml9R2s5kBWWv8lHE5Op5
         8ozELdYQ9CHWeqTsYt4iTfi0rCtzEGTnw7np7YaPacQWbxJr6Cn/XuHQIORt2W+juxjQ
         YbPYXlblsEquVj38hiRVCyYOM7RyaG2gtZspOQxX1sWMxYY3q3da1cNpUQRxqbLur/+m
         V4UQ==
X-Gm-Message-State: APjAAAXvK5L0IIF8uYn8lmzZRn4VJmoiwAeIRqArd+JSLWDSYaX3JbO/
        3igVmfW+xCY5a8oSRcwDm4t/YYtYhAWVnr1J1w==
X-Google-Smtp-Source: APXvYqzRX1Si432K7nf2FN0S4B9bSAQZpcQtgtQnQKmYARSzTcK+9eCXJ5D/YBne49C2YveVR0hAD5Zdsk5nybeHjko=
X-Received: by 2002:ac2:4d41:: with SMTP id 1mr5481829lfp.171.1582573015330;
 Mon, 24 Feb 2020 11:36:55 -0800 (PST)
MIME-Version: 1.0
References: <20200218200103.12574-1-lsahlber@redhat.com> <CAH2r5mvXp_KvT5CmpmsbNbb2bVD+qKRu22QPw3_KTq38UURFTA@mail.gmail.com>
In-Reply-To: <CAH2r5mvXp_KvT5CmpmsbNbb2bVD+qKRu22QPw3_KTq38UURFTA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 24 Feb 2020 11:36:44 -0800
Message-ID: <CAKywueSsso_n_KM5qv9kuLVEPyjUaqh3u973EJ_+RLRaGwBFtg@mail.gmail.com>
Subject: Re: [PATCH] cifs: don't leak -EAGAIN for stat() during reconnect
To:     Steve French <smfrench@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 18 =D1=84=D0=B5=D0=B2=D1=80. 2020 =D0=B3. =D0=B2 15:27, Steve=
 French <smfrench@gmail.com>:
>
> merged into cifs-2.6.git for-next
>
> On Tue, Feb 18, 2020 at 2:07 PM Ronnie Sahlberg <lsahlber@redhat.com> wro=
te:
> >
> > If from cifs_revalidate_dentry_attr() the SMB2/QUERY_INFO call fails wi=
th an
> > error, such as STATUS_SESSION_EXPIRED, causing the session to be reconn=
ected
> > it is possible we will leak -EAGAIN back to the application even for
> > system calls such as stat() where this is not a valid error.
> >
> > Fix this by re-trying the operation from within cifs_revalidate_dentry_=
attr()
> > if cifs_get_inode_info*() returns -EAGAIN.
> >
> > This fixes stat() and possibly also other system calls that uses
> > cifs_revalidate_dentry*().
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > ---
> >  fs/cifs/inode.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> > index b5e6635c578e..1212ace05258 100644
> > --- a/fs/cifs/inode.c
> > +++ b/fs/cifs/inode.c
> > @@ -2073,6 +2073,7 @@ int cifs_revalidate_dentry_attr(struct dentry *de=
ntry)
> >         struct inode *inode =3D d_inode(dentry);
> >         struct super_block *sb =3D dentry->d_sb;
> >         char *full_path =3D NULL;
> > +       int count =3D 0;
> >
> >         if (inode =3D=3D NULL)
> >                 return -ENOENT;
> > @@ -2094,15 +2095,18 @@ int cifs_revalidate_dentry_attr(struct dentry *=
dentry)
> >                  full_path, inode, inode->i_count.counter,
> >                  dentry, cifs_get_time(dentry), jiffies);
> >
> > +again:
> >         if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
> >                 rc =3D cifs_get_inode_info_unix(&inode, full_path, sb, =
xid);
> >         else
> >                 rc =3D cifs_get_inode_info(&inode, full_path, NULL, sb,
> >                                          xid, NULL);
> > -
> > +       if (is_retryable_error(rc) && count++ < 10)
> > +               goto again;

If there is interrupt error, you will end up doing 10 attempts with
the same outcome - interrupt error. Such errors should be returned to
the upper layers to be handled correctly (restart of a system call or
return of EINTR error to the user space).

Please revert to your original version that handles EAGAIN only.

--
Best regards,
Pavel Shilovsky

> >  out:
> >         kfree(full_path);
> >         free_xid(xid);
> > +
> >         return rc;
> >  }
> >
> > --
> > 2.13.6
> >
>
>
> --
> Thanks,
>
> Steve
