Return-Path: <SRS0=eY7I=5D=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 016F3C10DCE
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Mar 2020 11:27:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3CA22076C
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Mar 2020 11:27:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AvDGjd82"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgCRL1d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Mar 2020 07:27:33 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:51135 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbgCRL1d (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Mar 2020 07:27:33 -0400
Received: by mail-pj1-f66.google.com with SMTP id v13so1219904pjb.0
        for <linux-cifs@vger.kernel.org>; Wed, 18 Mar 2020 04:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HGhLXKvct+PN3oiwE7+OYLkf8ojL8gg8cs73uo1tf8Q=;
        b=AvDGjd82lJAbdbgNglShFWtLg8tM1mljGR2v2E30yLlTCqXSjHjVR8IBSGJs6XT+yQ
         rtZQvyUuByd3C0XDptrAuBe97ap42t7i7lLuqaPzL+ZOlwFEyH2OFhccyYNSCRBLvsoH
         2szcXdJkvm4T1tL97OZt1nGskcedvya9zNefzDvU6vYDMy/mvXbKXu9LwJe3VdJToNb4
         ssJNOLlNYhzvgOM+qKTuk7/mAcFhvNkqYPnXfzpLlK/zL4zJuCuzrM91gmFQqRhhFUMl
         A8iJUdshqve5sMcvcsKLdVBMGM4dRSZ9SaVBaKy9+37WmaglFa9GZquwLFX/ng5hOF4n
         UZ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HGhLXKvct+PN3oiwE7+OYLkf8ojL8gg8cs73uo1tf8Q=;
        b=at3Cqp5FvPdBt1MLIC6G+OLKKG2YWClLjKYUZhSKzPbYAmuAA+4GtYx9ZOPG6lk4a0
         Wy7P6EyhWlZwUWC8p9AT5VbO1BtLZtsCsE1qbO0W3wwKqs0hUo72sA5lhK2KWoZx2ICq
         iTxNFw7CYEwt6C+dSo/QXJZNkb2PW+Mv+9JnM9X+eRQGMHKf+T2oF1SVu8e1cLLIcbZD
         zIHmORwvZiqeFYnd4UAK1wVPuVT64oxA8aVUmfMiosXvANIyD1PCKhRsB17ioFL9aV/1
         SztiXuYyW4ebblAAc4l+yTPQMTMa3/UZHKuhPieIcWLzYblcu3mmSuJrWfK/DX6hQR4a
         1B8A==
X-Gm-Message-State: ANhLgQ2IRhzbiBXqSPbD4ufArd8w8WvIuTh98cRrbBO1Q8iBeCjbD6iO
        qnSzhKWVxushmQQAediqdfs=
X-Google-Smtp-Source: ADFU+vu8+dJFqYHv7Ws/cGtbzJZW54+reiA1fw/Vb1rn5IwYtJAFI1soqw+foRL5e8EeuBO3LRX5oA==
X-Received: by 2002:a17:902:9a85:: with SMTP id w5mr3564564plp.168.1584530852213;
        Wed, 18 Mar 2020 04:27:32 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e184sm6298042pfh.219.2020.03.18.04.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 04:27:31 -0700 (PDT)
Date:   Wed, 18 Mar 2020 19:27:24 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Steve French <smfrench@gmail.com>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <sfrench@samba.org>
Subject: Re: [PATCH] CIFS: check new file size when extending file by
 fallocate
Message-ID: <20200318112724.wpyryqlet3mt7ont@xzhoux.usersys.redhat.com>
References: <20200318015624.spmlc7izbszkpdqf@xzhoux.usersys.redhat.com>
 <CAH2r5muj1nGSQFJzD7v4By6kgbt+k0ZmW0z_iKwRUB24XXB-bA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5muj1nGSQFJzD7v4By6kgbt+k0ZmW0z_iKwRUB24XXB-bA@mail.gmail.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Mar 18, 2020 at 12:57:23AM -0500, Steve French wrote:
> generates a warning (sparse) when compiled - can you fix and resubmit
> (can also add Ronnie's acked if you want)

Sure. Will send v2.

Thanks!

> 
>   CHECK   /home/smfrench/cifs-2.6/fs/cifs/smb2ops.c
> /home/smfrench/cifs-2.6/fs/cifs/smb2ops.c:3259:46: warning: incorrect
> type in argument 2 (different base types)
> /home/smfrench/cifs-2.6/fs/cifs/smb2ops.c:3259:46:    expected long
> long [usertype] offset
> /home/smfrench/cifs-2.6/fs/cifs/smb2ops.c:3259:46:    got restricted
> __le64 [assigned] [usertype] eof
>   CC [M]  /home/smfrench/cifs-2.6/fs/cifs/smb2ops.o
> 
> On Tue, Mar 17, 2020 at 8:57 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
> >
> > xfstests generic/228 checks if fallocate respects RLIMIT_FSIZE.
> > After fallocate mode 0 extending enabled, cifs can hit this failure.
> > Fix this by checking the new file size with the vfs helper, which
> > checks with RLIMIT_FSIZE(ulimit -f) and s_maxbytes.
> >
> > This patch has been tested by LTP/xfstests aginst samba and
> > Windows server. No new issue was found.
> >
> > Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> > ---
> >  fs/cifs/smb2ops.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index c31e84ee3c39..48bbbb68540d 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -3246,10 +3246,14 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
> >          * Extending the file
> >          */
> >         if ((keep_size == false) && i_size_read(inode) < off + len) {
> > +               eof = cpu_to_le64(off + len);
> > +               rc = inode_newsize_ok(inode, eof);
> > +               if (rc)
> > +                       goto out;
> > +
> >                 if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
> >                         smb2_set_sparse(xid, tcon, cfile, inode, false);
> >
> > -               eof = cpu_to_le64(off + len);
> >                 rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
> >                                   cfile->fid.volatile_fid, cfile->pid, &eof);
> >                 if (rc == 0) {
> > --
> > 2.20.1
> 
> 
> 
> -- 
> Thanks,
> 
> Steve

-- 
Murphy
