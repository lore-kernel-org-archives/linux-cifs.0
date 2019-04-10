Return-Path: <SRS0=49Qs=SM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CFA6C282DA
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Apr 2019 02:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C2EB20874
	for <linux-cifs@archiver.kernel.org>; Wed, 10 Apr 2019 02:56:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LwLcnMzx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfDJC4e (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 9 Apr 2019 22:56:34 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:36232 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726577AbfDJC4d (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 9 Apr 2019 22:56:33 -0400
Received: by mail-pl1-f194.google.com with SMTP id ck15so451842plb.3
        for <linux-cifs@vger.kernel.org>; Tue, 09 Apr 2019 19:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SWasIx9c2TSXqDo2OQhbL9rdpS8X6UpDy/cu4eHGeoM=;
        b=LwLcnMzxXazUMAQHXyyAS+BFCQtHSu2PjEA/JjibohJ2DfuT2wzJ3+NLFlgeCfpjuD
         MnHGO3cG27KSP5amXYZSj5XjBJ9S/y+h9Vpt78ZVBZ9o79n0Td9XeuVL4/uW6rM33dU/
         X42sUYoms4sQzMGklPHt1N8/pC6NL5k6gdGeeT9lFPK+w+U7L74Mj+CVZ/su9Rgvrw34
         57RpzlGypoaDJqeWwVIS/UzEeS9Z4VNphFUOFWllFpyQkli7DwFcPawRtFyZTJx+4fXY
         IUPES63cSmIP/jgiMGD7x6JmDuHcimCtGsJsNku+FCaQZueLj08IoPXtjWgShTG4nYcZ
         ZjQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SWasIx9c2TSXqDo2OQhbL9rdpS8X6UpDy/cu4eHGeoM=;
        b=rqlsOgS2cK37VHTFHi5F1WVKRkrzQ6plhKMtr5uN9dKHMKuALwC3bFbRbRnnsY+fLT
         C0aRNigaLKENrkkwU9oqeYg1/Fh1M+x3lG/w+vTMlZwIoeXelluiGEOTG/Mq8vHRS/a1
         YfenuiF8OsWRJSVyKOtpd9VWZwZYycKsB7zpnlWM/F35kEHxDbDqa8r8fwAGh5L15lMc
         FZ9VU0BU78votTCrwCLsZEAn7VPvmpkkcHch1kzvKEWSxLhg+nV/Jx3G7PGwTeNz00H5
         +G6rmxvM/FkR33h15gRIVNg7q89JZF6Qc6RjmRGM8qLSxX9Q1AlkpR+AJ53cWna3hePR
         Q5Tg==
X-Gm-Message-State: APjAAAWOGFN8I5oHhRYFQKCxW9CN5QKNWoxJLKYHRLsvcFDc5NLApCV5
        9UAQEVghTQB2bFKqclhn8nle6ReG0xPeefPMryk=
X-Google-Smtp-Source: APXvYqzB3JtuW29F7AJNIDCYUANrMZd5ERRFU6wEFsL5c0DKulaHSOcU4ahrAVloloE02+i0mijKGqMwyXFJ6ly5GgE=
X-Received: by 2002:a17:902:1486:: with SMTP id k6mr6892434pla.208.1554864993023;
 Tue, 09 Apr 2019 19:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190410014158.27517-1-xifeng@redhat.com>
In-Reply-To: <20190410014158.27517-1-xifeng@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 9 Apr 2019 21:56:19 -0500
Message-ID: <CAH2r5mvPYod-H0CVt7WEij1neO3fPu9h22Yi-EG=Wfqo-0F44w@mail.gmail.com>
Subject: Re: [PATCH v2] CIFS: display noacl in the mount options
To:     XiaoLi Feng <xifeng@redhat.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        "fengxiaoli0714@gmai.com" <fengxiaoli0714@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Could this get users confused who mount with "cifsacl" and see "noacl" as well?

Also this is really saying no support for "POSIX (draft standard) ACL
support" not no support for SMB3 ACL (or similarly "RichACL" or NFS
ACL or ... NTFS ACL or ... which are somewhat similar and common).

Could get confusing

On Tue, Apr 9, 2019 at 8:43 PM XiaoLi Feng <xifeng@redhat.com> wrote:
>
> From: "fengxiaoli0714@gmai.com" <fengxiaoli0714@gmail.com>
>
> The mount option noacl aren't shown in /proc/mounts
> even if they are mounted successfully. And smb2.0+
> don't support ACL. Display noacl acquiescently if ACL
> is unsupported.
>
> Signed-off-by: fengxiaoli0714@gmai.com <fengxiaoli0714@gmail.com>
> ---
>  fs/cifs/cifsfs.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index f9b71c12cc9f..80ee4fbcd25b 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -535,6 +535,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
>                 seq_puts(s, ",dynperm");
>         if (root->d_sb->s_flags & SB_POSIXACL)
>                 seq_puts(s, ",acl");
> +       else
> +               seq_puts(s, ",noacl");
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
>                 seq_puts(s, ",mfsymlinks");
>         if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)
> --
> 2.18.1
>


-- 
Thanks,

Steve
