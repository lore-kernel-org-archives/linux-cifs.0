Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94EF8C433EF
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Feb 2022 06:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbiBLGgf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Feb 2022 01:36:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbiBLGge (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 12 Feb 2022 01:36:34 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBB4275CB
        for <linux-cifs@vger.kernel.org>; Fri, 11 Feb 2022 22:36:31 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id o9so10360920ljq.4
        for <linux-cifs@vger.kernel.org>; Fri, 11 Feb 2022 22:36:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7RegIpf17EZAC9wVCAuYizoCzd2b4rYZ7jtydQyBH98=;
        b=OkqglygspyXfNpKOGpKwlELftRlRWwX/URbQuTGkCHA2FUeL9KAV94/4rHLcIQoNwb
         S/RExxers821PuqsiVWppQwr8VQGyqOzsZTrDGa2cD68J/7wQcqDfx4d/Q2TnaueoKpj
         ctKFzI3MbLcP24ljR8QLb9hF5wYD5QrJLrwe9OV4jSMydOCNrvbXBH95HNiJ3WlLY/53
         c/FwMMoN+5QWbr13j0TuuU7e5o/Rg04hQ8vnLaoLKYfP2EpUkHU7ALFrNwQwkqRFqJpQ
         qROLBJSd9W+cJHQ//aO1+6s0I74DhIE+xx/W+wxNjzAW79G6XNDBfYtk9iZLLOn2SUG7
         /hXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7RegIpf17EZAC9wVCAuYizoCzd2b4rYZ7jtydQyBH98=;
        b=iMJcfb8D01cLjVD6oPPisKdBU5/4qcwPD6nQUuHkG1XOxIQqmHpbAfAiqBwPCliNng
         l1R7v2zNl4Zk3//4Q9JMi3DYN1Gl5bsdBNHtynCf8B74qIHyqm1UYFGwr8eKX9zgBBW4
         T8Lxh8fQoXVOvYOXDCmCzKx4umBseIufy32+r/HV01p+/74ZUe0xxBiBU6T+y5EJj4w7
         Vw93EuSxtZkxCkXbHZ/7TrsEX+k33aYi8XCNBebGrfvcSCG33tDNmBY64UDg4sfu2RAY
         VMk64sa687H7jc64mSylRqYrQZt56Hl9n29zhrn5F/Fd9HH9hiyEdVCuu+UumRmd8ucD
         yFTw==
X-Gm-Message-State: AOAM531W3fBlwLw9Ygw+ig2L994eal1t4czibpZvisXJXr4B0qwpJX9J
        R4UFfFtLYtX1coZXpcOCIaaPtExsanpg3nr1HQ4=
X-Google-Smtp-Source: ABdhPJz5aELe/rK0kRdoZE1+KPULZ94coNzt4hy7ZZIw4KtfMxNsuJFFyskLp7/Ore3I1BWdBE+bFONDTU5Kcck1Hjg=
X-Received: by 2002:a05:651c:198f:: with SMTP id bx15mr3043675ljb.314.1644647789976;
 Fri, 11 Feb 2022 22:36:29 -0800 (PST)
MIME-Version: 1.0
References: <20220211221620.3311195-1-lsahlber@redhat.com>
In-Reply-To: <20220211221620.3311195-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 12 Feb 2022 00:36:19 -0600
Message-ID: <CAH2r5ms_Egz4mmdGoQqLeoABJBjZsOLhje7U-Zv+4+SeLQEFqg@mail.gmail.com>
Subject: Re: [PATCH] cifs: do not use uninitialized data in the owner/group sid
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending testing

On Fri, Feb 11, 2022 at 4:16 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> When idsfromsid is used we create a special SID for owner/group.
> This structure must be initialized or else the first 5 bytes
> of the Authority field of the SID will contain uninitialized data
> and thus not be a valid SID.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsacl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index ee3aab3dd4ac..5df21d63dd04 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -1297,7 +1297,7 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
>
>                 if (uid_valid(uid)) { /* chown */
>                         uid_t id;
> -                       nowner_sid_ptr = kmalloc(sizeof(struct cifs_sid),
> +                       nowner_sid_ptr = kzalloc(sizeof(struct cifs_sid),
>                                                                 GFP_KERNEL);
>                         if (!nowner_sid_ptr) {
>                                 rc = -ENOMEM;
> @@ -1326,7 +1326,7 @@ static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
>                 }
>                 if (gid_valid(gid)) { /* chgrp */
>                         gid_t id;
> -                       ngroup_sid_ptr = kmalloc(sizeof(struct cifs_sid),
> +                       ngroup_sid_ptr = kzalloc(sizeof(struct cifs_sid),
>                                                                 GFP_KERNEL);
>                         if (!ngroup_sid_ptr) {
>                                 rc = -ENOMEM;
> --
> 2.30.2
>


-- 
Thanks,

Steve
