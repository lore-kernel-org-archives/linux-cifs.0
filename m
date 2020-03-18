Return-Path: <SRS0=eY7I=5D=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D14C1975A
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Mar 2020 02:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D215C20738
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Mar 2020 02:01:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GGzdmGwK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgCRCBZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 Mar 2020 22:01:25 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:36805 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgCRCBZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 Mar 2020 22:01:25 -0400
Received: by mail-io1-f67.google.com with SMTP id d15so23325947iog.3
        for <linux-cifs@vger.kernel.org>; Tue, 17 Mar 2020 19:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GcjnegM2S9W/wrTabVBPi2axgy50klV3Is7PgYxHwNU=;
        b=GGzdmGwKvyRPeOjCEqIF6d1jfZjoCOLFIjoqbojgj9gYAnyGs6dpnzzzYqYeA+TtdN
         q2tIEtLaDYQsXvfbpZHsb5srvkTZV3RP5zqj1Vqc1xhj6ETZCHpr6pFqixOOk4aHBZvv
         IWPCc8OLyoPoxKpejbmdmEcJhkjP9u0BbwBH/ZTselzEKqfMiaPUHd1SwXkUNIFnWnIJ
         N6PN/yJYyyzYsu7mIaS2Er10MiOYh0Y+mOSQeZL5KFJNF1JT4DzRTNnqHlC08hIlnxWl
         trdMrPw9wtdW5FyIiTGShxkL0p2/hD5NiHuS0PeOBf9I9FKPVlmjVnCrart7fFi5pMPA
         mwpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GcjnegM2S9W/wrTabVBPi2axgy50klV3Is7PgYxHwNU=;
        b=JPsMI07mlIvMWkBJkputUXUZp3cFC3XRO2cDNHSi+YOee/IEoonScQ9UPEE62VsMMf
         4oD8yeA54YsjLhH9fOtwYTdIuXc718bku+j35x4xYzmQWlPq4r8CwDX5CQxNQZwGupLw
         MKh5VMgwqlFtkf1UV3iB88oz8ZrvOQpwlvkdBMRriPn7EqI07HZ9YllLfvWxGK6oq6YM
         Jq+UNPZAEo9qRzw6Klg5UPuWmByWsKbtypxBK9lQc1cLFj5xCrWZF4p2hvLqML77hFJL
         UHzS0zC2MBucven5M9WUOSQfJw+vYffHPebHyrbQyhOCLskBUWBZXGWUKLH2q0rnvaxv
         QR0A==
X-Gm-Message-State: ANhLgQ1u3gjPDZrZR7sunz6ap8gYcydKoM1riJQ/x1E++XXDiA7vSzoa
        c0exXsON6zeXGAo/J+hxc2b9pyI8LlM8rkYeqFQ=
X-Google-Smtp-Source: ADFU+vub78Xk9XTXxkplXJ6b6pPAcg0UlwrHTl44loVyAexWXsKTtxtegLSto0IvSKhMJlDLYwe32Kp1IOpLjzbU7MM=
X-Received: by 2002:a05:6602:2098:: with SMTP id a24mr1607343ioa.101.1584496884191;
 Tue, 17 Mar 2020 19:01:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200318015624.spmlc7izbszkpdqf@xzhoux.usersys.redhat.com>
In-Reply-To: <20200318015624.spmlc7izbszkpdqf@xzhoux.usersys.redhat.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 18 Mar 2020 12:01:12 +1000
Message-ID: <CAN05THRkPZEzsWuXQi_LOMtkD5vC80Zv6r2EohwfKoXxat2MqA@mail.gmail.com>
Subject: Re: [PATCH] CIFS: check new file size when extending file by fallocate
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <sfrench@samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good.
Ackd-by: me

On Wed, Mar 18, 2020 at 11:57 AM Murphy Zhou <jencce.kernel@gmail.com> wrote:
>
> xfstests generic/228 checks if fallocate respects RLIMIT_FSIZE.
> After fallocate mode 0 extending enabled, cifs can hit this failure.
> Fix this by checking the new file size with the vfs helper, which
> checks with RLIMIT_FSIZE(ulimit -f) and s_maxbytes.
>
> This patch has been tested by LTP/xfstests aginst samba and
> Windows server. No new issue was found.
>
> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> ---
>  fs/cifs/smb2ops.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index c31e84ee3c39..48bbbb68540d 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -3246,10 +3246,14 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
>          * Extending the file
>          */
>         if ((keep_size == false) && i_size_read(inode) < off + len) {
> +               eof = cpu_to_le64(off + len);
> +               rc = inode_newsize_ok(inode, eof);
> +               if (rc)
> +                       goto out;
> +
>                 if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
>                         smb2_set_sparse(xid, tcon, cfile, inode, false);
>
> -               eof = cpu_to_le64(off + len);
>                 rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
>                                   cfile->fid.volatile_fid, cfile->pid, &eof);
>                 if (rc == 0) {
> --
> 2.20.1
