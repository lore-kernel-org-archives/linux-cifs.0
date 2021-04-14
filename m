Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3683AC433B4
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Apr 2021 22:24:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07FAF61177
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Apr 2021 22:24:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhDNWYm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Apr 2021 18:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbhDNWYl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Apr 2021 18:24:41 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4507C061574
        for <linux-cifs@vger.kernel.org>; Wed, 14 Apr 2021 15:24:19 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id e7so25535079edu.10
        for <linux-cifs@vger.kernel.org>; Wed, 14 Apr 2021 15:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FtD3aJt2zt3+t5UuU1lseVCO90lcfa1i9K5SCPchkf0=;
        b=FV1ecycR6QS0CBNcmBRbXM3X9AntIieEjo8Sxc2tV/ipU2ZAqIJ0FqFxqjVJ2q6ibr
         nHaiZnYI56BFEdDsTI/ZMZLl9rQlfUbCnUSDsQHB64cZ6RB1l4+qL1foFz5uLc6ekoEg
         256K9PdH8dp3ccBanInig7eJCkYQfwbhfYeYiLBtKCGmBFVOaWGklcPlvr8/PZyEtNsz
         b0T+qxC2bZ1/LMgTmo2J/71959IDZ8jvr+7/ciAqoi7BP0rB3yr8wuaS8QOJTDoby29J
         Ug3n09iXEVGRrnJB/wIoLtekXlq7hiAWZqeGjjI70KlUodkIoIYExE1L7BBBvDBmdMQt
         n2ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FtD3aJt2zt3+t5UuU1lseVCO90lcfa1i9K5SCPchkf0=;
        b=VnLiSKEBddu84NZu/FnWDZlPDHgQvyKcFsqJugi+PmWsT2E0v3+rT0Wxl6AlsN1FvF
         ILVn9fYL7vYSus7Uwu4miw8lvalVV70t3wClq1U5V8bXeMN+WGS+YltSSWfrjcQd1WaF
         pr/V0kjJ7oZrX6T8JxqZmGhhilcXfZSJt2vChUXnZshaNNhDheDK5loYd/5qXAzMrP+X
         uFQO3CqhKrcMYT8sAmYEh9KkwBjkikRZWSbUT+z2+f2uGlvxdFjNuqdw5J6pubi4UIJG
         QWm8ygP1HA45i44yZ6B0TjtdFPa5gTgmTjc/qh9Ke67+JYZKacWlUJW8EJZnThSI8ut6
         TxnQ==
X-Gm-Message-State: AOAM532FzCljAddw2a3dbrj+V6Czj8NGfAa/9AZLQxY7asQ3OFH+TNz0
        nW3MhuC/JpAYsiUl4a/tnATqAyFO0wSrJ9oSkl70PgA=
X-Google-Smtp-Source: ABdhPJwXoxzO++xNgDsEcfuYO3W1U+K1B8JoNCNeyvv7xBZBOSNcNUSVTvELP2mgdu07GGYbjGFt25ryBxRSYKWDtb8=
X-Received: by 2002:aa7:cd12:: with SMTP id b18mr491125edw.340.1618439058494;
 Wed, 14 Apr 2021 15:24:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210413212527.473765-1-paul@darkrain42.org> <CAH2r5mtg3Yw7=3E_JExhaG=x3qZLsXJvG8L+ynkwprfLrYiPLA@mail.gmail.com>
In-Reply-To: <CAH2r5mtg3Yw7=3E_JExhaG=x3qZLsXJvG8L+ynkwprfLrYiPLA@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 14 Apr 2021 15:24:07 -0700
Message-ID: <CAKywueT+SGRaE7Ttq0BAum2QaXtO1D13FtYej_rLZ9JSuz5t9g@mail.gmail.com>
Subject: Re: [PATCH] cifs: Return correct error code from smb2_get_enc_key
To:     Steve French <smfrench@gmail.com>
Cc:     Paul Aurich <paul@darkrain42.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If we can't find an encryption key that means that there was a
reconnect and an SMB session associated with the packet is gone. If
this happens during the writeback (as in the trace above) I would
rather retry instead of returning an error.

I think we should use -EAGAIN instead, so the upper layer will attempt
to retry the write request if such an error occurs.

--
Best regards,
Pavel Shilovsky

=D1=81=D1=80, 14 =D0=B0=D0=BF=D1=80. 2021 =D0=B3. =D0=B2 12:49, Steve Frenc=
h <smfrench@gmail.com>:
>
> tentatively merged into cifs-2.6.git for-next pending more reviews
> from Pavel etc and testing
>
> On Wed, Apr 14, 2021 at 1:56 AM Paul Aurich <paul@darkrain42.org> wrote:
> >
> > Avoid a warning if the error percolates back up:
> >
> > [440700.376476] CIFS VFS: \\otters.example.com crypt_message: Could not=
 get encryption key
> > [440700.386947] ------------[ cut here ]------------
> > [440700.386948] err =3D 1
> > [440700.386977] WARNING: CPU: 11 PID: 2733 at /build/linux-hwe-5.4-p6lk=
6L/linux-hwe-5.4-5.4.0/lib/errseq.c:74 errseq_set+0x5c/0x70
> > ...
> > [440700.397304] CPU: 11 PID: 2733 Comm: tar Tainted: G           OE    =
 5.4.0-70-generic #78~18.04.1-Ubuntu
> > ...
> > [440700.397334] Call Trace:
> > [440700.397346]  __filemap_set_wb_err+0x1a/0x70
> > [440700.397419]  cifs_writepages+0x9c7/0xb30 [cifs]
> > [440700.397426]  do_writepages+0x4b/0xe0
> > [440700.397444]  __filemap_fdatawrite_range+0xcb/0x100
> > [440700.397455]  filemap_write_and_wait+0x42/0xa0
> > [440700.397486]  cifs_setattr+0x68b/0xf30 [cifs]
> > [440700.397493]  notify_change+0x358/0x4a0
> > [440700.397500]  utimes_common+0xe9/0x1c0
> > [440700.397510]  do_utimes+0xc5/0x150
> > [440700.397520]  __x64_sys_utimensat+0x88/0xd0
> >
> > Fixes: 61cfac6f267d ("CIFS: Fix possible use after free in demultiplex =
thread")
> > Signed-off-by: Paul Aurich <paul@darkrain42.org>
> > CC: stable@vger.kernel.org
> > ---
> >  fs/cifs/smb2ops.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index 61214b23c57f..caa5432a5ed1 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -4418,7 +4418,7 @@ smb2_get_enc_key(struct TCP_Server_Info *server, =
__u64 ses_id, int enc, u8 *key)
> >         }
> >         spin_unlock(&cifs_tcp_ses_lock);
> >
> > -       return 1;
> > +       return -ENOENT;
> >  }
> >  /*
> >   * Encrypt or decrypt @rqst message. @rqst[0] has the following format=
:
> > --
> > 2.31.0
> >
>
>
> --
> Thanks,
>
> Steve
