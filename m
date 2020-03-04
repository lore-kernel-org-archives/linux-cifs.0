Return-Path: <SRS0=Ot+p=4V=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 836A8C3F2D1
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Mar 2020 06:18:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 590BD2166E
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Mar 2020 06:18:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FTCe6sWf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbgCDGSV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Mar 2020 01:18:21 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:34903 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgCDGSV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 Mar 2020 01:18:21 -0500
Received: by mail-yw1-f68.google.com with SMTP id a132so997544ywb.2
        for <linux-cifs@vger.kernel.org>; Tue, 03 Mar 2020 22:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jcz2rfW34qu6+b+jI00dFaLIo0kKDE91j2N3+6pK3rI=;
        b=FTCe6sWfAwgSExWrWZQR4JO3VyTW5RTXR4oST49CB0ZtcKY/FadArUV+HNYyqkkgAn
         4qLuo403wsiIiBSQG6O51v/f83t/URPQJztlrmmbt00aJ4ZEUqdKyjbaHWt5YAGCK1Yn
         Ue+X9taEplgv4tkRc0m1ZECVgytT8PpBbCESjvV8UenncljWCHt0qlZKW0Idp2CWKTrR
         OgLUcSCUwlljgWUjvA1mSFSJUxl2quDKc10IWJS4v7XJrOyc3bU3H5IUYB2VYiQgaX4H
         V/LyZdcnN8iU69AZpgHYORiWA8NvIdUjdg5QVAydv2+ZiA5XKEW1ck/duaRvp6UVZogr
         ljqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jcz2rfW34qu6+b+jI00dFaLIo0kKDE91j2N3+6pK3rI=;
        b=JbfO/c9g5vxrPQWUXiVJgKTdtlGRW7pUolS7HpomMcLKvIxbBfoyzeEPLouuJ3hw5o
         l9NrsjBqrLMJoOd4UY3JiH6Aw8jWN+KC4HCQHkGMSb82+0f8cAWqUJqif4J0I0yTxHXO
         UaPvrfbuuLhx/aoo8lFaTtZ07Fht8kWlLs8GXujL2Qx8GrIBaUfPV9AYpcWNqVdvy/zC
         XVfpuT7gwsfyyTyXlm2evrBKv0kaya7oz8WCu7bYsMmNz1E+mzAVpaeePNoPk+/1jOvI
         YnwbLorY7sUwblALQ+88Dqs9SJ4fqwr+zlzH9ONFGp6eIl9BJj1JuS9XzF/zxcmOfNhb
         wv6g==
X-Gm-Message-State: ANhLgQ32RiweTZu5zwNmsCMPZl4ARLSKCyYIzqRDCJxg4FvtA9l58b4o
        HazffvaAMeZ3DNlSu99JYWU/LLGcbNi7VboQ53KvwQ==
X-Google-Smtp-Source: ADFU+vtE9vnGKUcQy7SCZ1y8Z3ed/W99AuCZ4t7dWDWlAU/IxIKP3rMk+hr0nJNtB9YkLC3j/SUaCz+CgCBlOU6Xhvs=
X-Received: by 2002:a25:f20f:: with SMTP id i15mr1108093ybe.364.1583302699139;
 Tue, 03 Mar 2020 22:18:19 -0800 (PST)
MIME-Version: 1.0
References: <20200221023001.vcoc5f43rdqqeifn@xzhoux.usersys.redhat.com>
In-Reply-To: <20200221023001.vcoc5f43rdqqeifn@xzhoux.usersys.redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 4 Mar 2020 00:18:08 -0600
Message-ID: <CAH2r5mttkA0MAofhVHe6phT65nLzoeBR8phbPuyn1zC+u+Ltpw@mail.gmail.com>
Subject: Re: [PATCH v2] cifs: allow unlock flock and OFD lock across fork
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending more testing

On Thu, Feb 20, 2020 at 8:30 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
>
> Since commit d0677992d2af ("cifs: add support for flock") added
> support for flock, LTP/flock03[1] testcase started to fail.
>
> This testcase is testing flock lock and unlock across fork.
> The parent locks file and starts the child process, in which
> it unlock the same fd and lock the same file with another fd
> again. All the lock and unlock operation should succeed.
>
> Now the child process does not actually unlock the file, so
> the following lock fails. Fix this by allowing flock and OFD
> lock go through the unlock routine, not skipping if the unlock
> request comes from another process.
>
> Patch has been tested by LTP/xfstests on samba and Windows
> server, v3.11, with or without cache=none mount option.
>
> [1] https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/flock/flock03.c
> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> ---
>  fs/cifs/smb2file.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
> index afe1f03aabe3..eebfbf3a8c80 100644
> --- a/fs/cifs/smb2file.c
> +++ b/fs/cifs/smb2file.c
> @@ -152,7 +152,12 @@ smb2_unlock_range(struct cifsFileInfo *cfile, struct file_lock *flock,
>                     (li->offset + li->length))
>                         continue;
>                 if (current->tgid != li->pid)
> -                       continue;
> +                       /*
> +                        * flock and OFD lock are associated with an open
> +                        * file description, not the process.
> +                        */
> +                       if (!(flock->fl_flags & (FL_FLOCK | FL_OFDLCK)))
> +                               continue;
>                 if (cinode->can_cache_brlcks) {
>                         /*
>                          * We can cache brlock requests - simply remove a lock
> --
> 2.20.1
>
>


-- 
Thanks,

Steve
