Return-Path: <SRS0=yfix=WS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30DC5C3A59D
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Aug 2019 04:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 007C022CF7
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Aug 2019 04:15:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fhyBzl3E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfHVEP7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Aug 2019 00:15:59 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33362 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725294AbfHVEP7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Aug 2019 00:15:59 -0400
Received: by mail-pg1-f193.google.com with SMTP id n190so2711257pgn.0
        for <linux-cifs@vger.kernel.org>; Wed, 21 Aug 2019 21:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bPc2QwrtP+hZ98TSh18dPLDNi1G2/UEpcndb2fFHR5o=;
        b=fhyBzl3E5Hm3ccyFNuD83ANx8DBQEqc4swuVTdEC3RsgrXa5jkFCbbTI3axeqy4fIn
         jCtTm9ySPorFkP/osrygDWqhnqUlLvj7z4dkckNhnwBKh+4MnAoP3LyN1VIgRNsPZMoN
         sLwMrcEuGj9GHUbHN1/Do7IPk5JzcWUyI2QNrqg4UhpwnoYLNfgK5qiksEAHmppC62Uv
         MBf2FBs+4uNTxeU/3YBT6OHtc8VtvCrKAgOCzsHVw3moBxoJ9GGwRphnVG/Ihj2uLj66
         Ovuxeeke0nqcArKdH3CkQbzYs88P40+fsu7YFInPvZykA4L/oo7VSzC19lrrQBwroq4e
         Q9dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bPc2QwrtP+hZ98TSh18dPLDNi1G2/UEpcndb2fFHR5o=;
        b=mI4pnidVmyjAr9RRU+Er9PhD2z3ZasBLFDBHsxlFD9haRpNrwJgwTF1w70YbHX2UD1
         TRZNcR6VUyoehftrTTcVACyz66i80U4xEvrThZNj9ZqefcGtQI57r4sbka6ioxYz2XQN
         HD6lAqnV4rdKTlApB4/ZF7OcgDLgkeiQGUx5BncoE4nW1eGX/B2gvA4hYq0p8FeIf3jY
         +8TCqF14Ijz5mQpe3Ce1b7IIZJ5y7rD5MiNgZzJUDqcVxhwjx+P0B8HPGSaiDMbqO9zU
         i0tGtxwJ1GKGjjRIpe6XMq8JnsXKjGuFjFgValmR86B8sMaxKM7HHzO7k+2E/fXdY97P
         8xyQ==
X-Gm-Message-State: APjAAAX4fIO/lGV3syv6VLzsmZ1cLnYVWbibwuFEGY1+93QvPsuPXdFG
        9N2DUKkDFm7jEGnEzY6MQ+JzYViSXTNn95yi4pqz+HKp
X-Google-Smtp-Source: APXvYqzVka+SmM4SHgxcOtX6iS2ZWzuV46QaMQXTPUAyEMv/ULMsdPo3u9l8lhBW/yaUqmQ4tHotm6CHByo8pL4zWI0=
X-Received: by 2002:a63:724b:: with SMTP id c11mr32597245pgn.30.1566447358331;
 Wed, 21 Aug 2019 21:15:58 -0700 (PDT)
MIME-Version: 1.0
References: <1566447421-16203-1-git-send-email-zhengbin13@huawei.com>
In-Reply-To: <1566447421-16203-1-git-send-email-zhengbin13@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 21 Aug 2019 23:15:47 -0500
Message-ID: <CAH2r5msWGOYt7Q6PhnmLcnboiR+55+LZXsGGbqScW+mqWHNtpQ@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs/cifsacl.c: remove set but not used variables 'rc'
To:     zhengbin <zhengbin13@huawei.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Isn't this a different bug - we set rc to -EINVAL but then don't
return rc, we return 0 which looks wrong.

On Wed, Aug 21, 2019 at 11:11 PM zhengbin <zhengbin13@huawei.com> wrote:
>
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> fs/cifs/cifsacl.c: In function sid_to_id:
> fs/cifs/cifsacl.c:347:6: warning: variable rc set but not used [-Wunused-but-set-variable]
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> ---
>  fs/cifs/cifsacl.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 1d377b7..2b34337 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -344,7 +344,6 @@ static int
>  sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
>                 struct cifs_fattr *fattr, uint sidtype)
>  {
> -       int rc;
>         struct key *sidkey;
>         char *sidstr;
>         const struct cred *saved_cred;
> @@ -405,7 +404,6 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
>         saved_cred = override_creds(root_cred);
>         sidkey = request_key(&cifs_idmap_key_type, sidstr, "");
>         if (IS_ERR(sidkey)) {
> -               rc = -EINVAL;
>                 cifs_dbg(FYI, "%s: Can't map SID %s to a %cid\n",
>                          __func__, sidstr, sidtype == SIDOWNER ? 'u' : 'g');
>                 goto out_revert_creds;
> @@ -418,7 +416,6 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
>          */
>         BUILD_BUG_ON(sizeof(uid_t) != sizeof(gid_t));
>         if (sidkey->datalen != sizeof(uid_t)) {
> -               rc = -EIO;
>                 cifs_dbg(FYI, "%s: Downcall contained malformed key (datalen=%hu)\n",
>                          __func__, sidkey->datalen);
>                 key_invalidate(sidkey);
> --
> 2.7.4
>


-- 
Thanks,

Steve
