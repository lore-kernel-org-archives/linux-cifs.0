Return-Path: <SRS0=C9ZR=YM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C408DCA9EAD
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Oct 2019 15:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A2562082F
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Oct 2019 15:33:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L3Vj1kOj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbfJSPdE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Oct 2019 11:33:04 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34156 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbfJSPdE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 19 Oct 2019 11:33:04 -0400
Received: by mail-io1-f68.google.com with SMTP id q1so11022236ion.1;
        Sat, 19 Oct 2019 08:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NIb3d/6toqZlUMcL7Zc8QdhiLzW9kKqfuVQu7v/JRyg=;
        b=L3Vj1kOjh/KZ+NM2bYzvMPYecYR0A9+wlEwnyTyQjAO1K0vGrt5253pKMcYXllwx2T
         YLAmBckEL++tOo2MqutwWpos6jo9jc7JYXy2krBnaV5gcqdsk22et2V+vs/zISZUbxxW
         PPzetePYJBdaEKkDwcjswxRllw0jirERNrZoEf4w++galojWuKOb/yd7kHcduDZMJZgw
         Nd92jBZ83FQVGSIZIRUn4we1RIm2gEXt29bv2w5+DVfWbJPK4mCqx37KpI/lkjQ4pY5f
         W+1B3DcJpADEasmOaU8YKLNjC18+Ynu9qlH8GH3Qw4/2hVBjwa+nQ57WFvDSP6/zsOoR
         JNtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NIb3d/6toqZlUMcL7Zc8QdhiLzW9kKqfuVQu7v/JRyg=;
        b=Nl5+wt3hzKOSSI4rcMqYyYxdmBkrpowwf8MDi3bMXN1dqOnFAVfRrnvHiY4fwNGXfc
         4/WYxWsGo8FLvPnTOrUxa1xhq9NmIt+cu+JDQNfRGCFYiX1SR7GpBvXvU+dpWECJiqxY
         6WiEhMHFI5AUJUA6Q07VI/HeqRXRnYiutl+IVRLPzhJcmTN/0DGdFXGY+BQe/kU+uNUJ
         Phs2PI4uQgLE0JGHLggfjqyS+54Oy5XR/Bcphh+dA/46hZbm7KABTVcR4aSJZiGaWHNz
         Y1T+pQUK7z7ZB09lpEnoYL8ZMyHkebxAz2iw7NkUoGuxGuK8FaFbSDcH8CbzpHUCylEw
         1w4w==
X-Gm-Message-State: APjAAAV3ZaBcg7j0W8R+f23I0spWVMmQ01YSez7T8zPRRioEpX8jWCD1
        Xa8O+Qif4WJcJ4lilD0DcyJad7SeQ9T72ygm2l0=
X-Google-Smtp-Source: APXvYqzctIUFoGaIl0rpBUDrpqH8GDKfSMmdOFSYgwBO7PeaqyV1oVJFIstJbr0hTlAN7tiDDzPhiyHFiSxfpgjP0/g=
X-Received: by 2002:a5e:9405:: with SMTP id q5mr13110599ioj.5.1571499182901;
 Sat, 19 Oct 2019 08:33:02 -0700 (PDT)
MIME-Version: 1.0
References: <20191017035351.125013-1-yuehaibing@huawei.com>
In-Reply-To: <20191017035351.125013-1-yuehaibing@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 19 Oct 2019 10:32:52 -0500
Message-ID: <CAH2r5mucpgb=cOzbq52kLojoTega3fCVh9yRtpodPe1zw9GG6Q@mail.gmail.com>
Subject: Re: [PATCH -next] CIFS: remove set but not used variables 'cinode'
 and 'netfid'
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively pushed to cifs-2.6.git for-next pending more testing of
the flock patch it modified.

On Fri, Oct 18, 2019 at 1:07 AM YueHaibing <yuehaibing@huawei.com> wrote:
>
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> fs/cifs/file.c: In function 'cifs_flock':
> fs/cifs/file.c:1704:8: warning:
>  variable 'netfid' set but not used [-Wunused-but-set-variable]
>
> fs/cifs/file.c:1702:24: warning:
>  variable 'cinode' set but not used [-Wunused-but-set-variable]
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  fs/cifs/file.c | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 936e03892e2a..02a81dc6861a 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1699,9 +1699,7 @@ int cifs_flock(struct file *file, int cmd, struct file_lock *fl)
>         bool posix_lck = false;
>         struct cifs_sb_info *cifs_sb;
>         struct cifs_tcon *tcon;
> -       struct cifsInodeInfo *cinode;
>         struct cifsFileInfo *cfile;
> -       __u16 netfid;
>         __u32 type;
>
>         rc = -EACCES;
> @@ -1716,8 +1714,6 @@ int cifs_flock(struct file *file, int cmd, struct file_lock *fl)
>         cifs_read_flock(fl, &type, &lock, &unlock, &wait_flag,
>                         tcon->ses->server);
>         cifs_sb = CIFS_FILE_SB(file);
> -       netfid = cfile->fid.netfid;
> -       cinode = CIFS_I(file_inode(file));
>
>         if (cap_unix(tcon->ses) &&
>             (CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability)) &&
>
>
>


-- 
Thanks,

Steve
