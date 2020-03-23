Return-Path: <SRS0=rFey=5I=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C48C4332E
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Mar 2020 00:24:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAB4E206F9
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Mar 2020 00:24:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PqcW1CnO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgCWAYi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 22 Mar 2020 20:24:38 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41256 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbgCWAYi (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 22 Mar 2020 20:24:38 -0400
Received: by mail-pg1-f193.google.com with SMTP id b1so6266850pgm.8
        for <linux-cifs@vger.kernel.org>; Sun, 22 Mar 2020 17:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lO9YmYI+70RdHjderze8WogfaWFoPY0L5C7JPO7z+20=;
        b=PqcW1CnO28dEfC2632aNIkYrSqiinvbihx/h8xl8xhSIGC2NLUez4bGU3A/s+LPCy/
         bP0qe/KSeWmyNVlyXXQIJSjn/0qqeFsaY2NOLG3mGjNQQb8iuPQSjuK2sdh1E/JAHNmV
         7apKR8rNqu3mojfyL3HBZ8GeCL0I5b1eouyo0C+CA8p+lBaC63kDCvP7PbTf9HteK2OH
         gkbvB0UA88X3r7uEuRKVd1WVe0f69pY7d7fUZQIBiSx+pMoLMBtnYlUParS053PqBOY8
         r8IxAOSaohtwMvBc/6bvGur/5gBEwU6m2RxrSvlq6RZZXhy2xFrfvei5SM1h27sUG/4k
         tNlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lO9YmYI+70RdHjderze8WogfaWFoPY0L5C7JPO7z+20=;
        b=WCQZfhz32NfvRXDO1Wz99ISufT1WZezC0FV7cHzQDKIR++WOLFdKNUwuaWGoKaqsmY
         3P/2n/zbiSR8TTajDa8ZlK6C18eh9OXp4F5jF02HMIolQFu/FrQLYB6VO4DzNRTsYIyU
         FA7lSlC3CmFdZF9SQ7hSmHEkVrmVEd74CrO34PJ7IdQxU03uMs1hUoVF5OdmS0VQu897
         Fzy5VzkyWJqFlhoi5I2w+/W7YcZngq/wQGP/YS3vDyuZole2uga7n9X41TlGqN8V2NQM
         VXUJi1agKZ88gcbCz5sbAmQZAJQQDogAH2WXQha++uVsUowfFBwIaDFF6IAaJDiUVwfW
         5eug==
X-Gm-Message-State: ANhLgQ0X+DZDn1oP5G7MucyA8U/K1q9SFmQxJVBnO/7zJspj9JYtB7k2
        tdyufVhzWBKBNDmzlP4XzIFPFeor
X-Google-Smtp-Source: ADFU+vt3vREIub+bY+4Nrqx+BVyYtEkSvR4oOHEc5VDZCU+VwbHHBorAgiP0BmBXO3HPLhQlrG2q7g==
X-Received: by 2002:a63:be0f:: with SMTP id l15mr19112417pgf.451.1584923076745;
        Sun, 22 Mar 2020 17:24:36 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y17sm5190426pfl.104.2020.03.22.17.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Mar 2020 17:24:36 -0700 (PDT)
Date:   Mon, 23 Mar 2020 08:24:28 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Steve French <smfrench@gmail.com>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <sfrench@samba.org>
Subject: Re: [PATCH v3] CIFS: check new file size when extending file by
 fallocate
Message-ID: <20200323002428.ih7nchj5tnbuppeb@xzhoux.usersys.redhat.com>
References: <20200318124659.cbxngqb4kbt2vhza@xzhoux.usersys.redhat.com>
 <CAH2r5muTx3DmGZ+ZedrNmPK8ZHq10XZ3RXxVD0H6RmEcBvnVPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5muTx3DmGZ+ZedrNmPK8ZHq10XZ3RXxVD0H6RmEcBvnVPQ@mail.gmail.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

On Wed, Mar 18, 2020 at 10:36:54PM -0500, Steve French wrote:
> Merged into cifs-2.6.git for-next

I don't see this in for-next. Is it for 5.7?

So does this one:
cifs: allow unlock flock and OFD lock across fork

Thanks!
> 
> On Wed, Mar 18, 2020, 07:48 Murphy Zhou <jencce.kernel@gmail.com> wrote:
> 
> > xfstests generic/228 checks if fallocate respect RLIMIT_FSIZE.
> > After fallocate mode 0 extending enabled, we can hit this failure.
> > Fix this by check the new file size with vfs helper, return
> > error if file size is larger then RLIMIT_FSIZE(ulimit -f).
> >
> > This patch has been tested by LTP/xfstests aginst samba and
> > Windows server.
> >
> > Acked-by: ronnie sahlberg <ronniesahlberg@gmail.com>
> > Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> > ---
> >
> > v2:
> >   Use (off+len) instead of eof for correct argument type.
> > v3:
> >   Fix Ronnie's email address.
> >
> >  fs/cifs/smb2ops.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index c31e84ee3c39..f221a01f62bd 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -3246,6 +3246,10 @@ static long smb3_simple_falloc(struct file *file,
> > struct cifs_tcon *tcon,
> >          * Extending the file
> >          */
> >         if ((keep_size == false) && i_size_read(inode) < off + len) {
> > +               rc = inode_newsize_ok(inode, off + len);
> > +               if (rc)
> > +                       goto out;
> > +
> >                 if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
> >                         smb2_set_sparse(xid, tcon, cfile, inode, false);
> >
> > --
> > 2.20.1
> >
> >

-- 
Murphy
