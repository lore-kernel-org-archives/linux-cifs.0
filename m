Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3937C7EE2C
	for <linux-cifs@archiver.kernel.org>; Fri, 26 May 2023 14:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243985AbjEZOjW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 May 2023 10:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243992AbjEZOjR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 May 2023 10:39:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6824DE55
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 07:38:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46CEB65046
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 14:38:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB2CC433D2
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 14:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685111928;
        bh=XJw8yWAfV0gIujeqAb59okwkDlRY5H7OKskFqI7PdNQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=uylkhIQxf7BEOwtX0qdAEh7qI69MhY6GgAbsltXh33RogBwu4YDxHRZFt8o02zrtS
         r62uAxmjbvecC+mRpuzEAHt9gIKtxVwPUTizf8xDvKiy9GkYQP2qHpLrX4hjUKnDls
         NpLfZ7hEoE5ZfOnaGJse4RbNO0QSQg+Bp+qWPfFiU2JbDyZxVNLse6gr4rsJapY7zz
         fj+xB7KXff+EtjKg8KsbiGgb/TKvYUbcc/nWwEt2Gbobv2MGNI773PeVyhr9/mB/yU
         GF3jfGL/0BC2IoUbL2LcWsLn0p9v+S+rd87eUTwFn4KVFWdCIY5nCGwl8N/h208aPC
         CRqffFTWVmGtw==
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-557e66063e8so141863eaf.3
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 07:38:48 -0700 (PDT)
X-Gm-Message-State: AC+VfDx6zjh+jVwccXJLOQRH/IxT3rD8TKpodtIxb7h5PmxJ4t/JsCdV
        11Kmh90MyqtzfmtoXiZsZtMKPjrR8b3WFsc3UpI=
X-Google-Smtp-Source: ACHHUZ681sWMoKY9dUW3eQSxLlJfbFEfZGuaWLT3HZGxLlXE5K/VU22uAEQhFsrKHp+6lXzeKBI4nYGNLxVhbGug16Q=
X-Received: by 2002:a05:6808:13d1:b0:394:4642:7148 with SMTP id
 d17-20020a05680813d100b0039446427148mr1178461oiw.48.1685111927802; Fri, 26
 May 2023 07:38:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:acb:0:b0:4de:afc5:4d13 with HTTP; Fri, 26 May 2023
 07:38:47 -0700 (PDT)
In-Reply-To: <61b13628-5502-42c5-b988-62a2c5809c45@kili.mountain>
References: <61b13628-5502-42c5-b988-62a2c5809c45@kili.mountain>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 26 May 2023 23:38:47 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_DqMsaKq0fQAzMfAM5N05oB2ajM533nnTSk=cGQVAnTw@mail.gmail.com>
Message-ID: <CAKYAXd_DqMsaKq0fQAzMfAM5N05oB2ajM533nnTSk=cGQVAnTw@mail.gmail.com>
Subject: Re: [bug report] ksmbd: fix racy issue from using ->d_parent and ->d_name
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-05-26 20:58 GMT+09:00, Dan Carpenter <dan.carpenter@linaro.org>:
> Hello Namjae Jeon,
>
> The patch 74d7970febf7: "ksmbd: fix racy issue from using ->d_parent
> and ->d_name" from Apr 21, 2023, leads to the following Smatch static
> checker warning:
>
> 	fs/smb/server/vfs.c:1159 ksmbd_vfs_kern_path_locked()
> 	info: return a literal instead of 'err'
I will fix it.
Thanks for your report!
>
> fs/smb/server/vfs.c
>     1149 int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char
> *name,
>     1150                                unsigned int flags, struct path
> *path,
>     1151                                bool caseless)
>     1152 {
>     1153         struct ksmbd_share_config *share_conf =
> work->tcon->share_conf;
>     1154         int err;
>     1155         struct path parent_path;
>     1156
>     1157         err = ksmbd_vfs_path_lookup_locked(share_conf, name, flags,
> path);
>     1158         if (!err)
> --> 1159                 return err;
>                          ^^^^^^^^^^^
> This used to be a "return 0;".  Now it looks like a reversed if
> statement bug now where people accidentally include a ! in the if
> statement.  I spotted a reversed if statement in someone's code yesterday
> so that's not a super uncommon bug, hence this unpublished static
> checker warning.
>
> Cifs code as a few of these.
>
> fs/smb/client/file.c:1723 cifs_getlk() info: return a literal instead of
> 'rc'
> fs/smb/client/file.c:1739 cifs_getlk() info: return a literal instead of
> 'rc'
> fs/smb/client/netmisc.c:171 cifs_convert_address() info: return a literal
> instead of 'rc'
>
>     1160
>     1161         if (caseless) {
>     1162                 char *filepath;
>     1163                 size_t path_len, remain_len;
>     1164
>     1165                 filepath = kstrdup(name, GFP_KERNEL);
>     1166                 if (!filepath)
>     1167                         return -ENOMEM;
>
> regards,
> dan carpenter
>
