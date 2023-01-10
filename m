Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49D66C54EBE
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Jan 2023 21:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbjAJVgP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Jan 2023 16:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234834AbjAJVfl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Jan 2023 16:35:41 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6247F6339C
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 13:34:38 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id v25so20486957lfe.12
        for <linux-cifs@vger.kernel.org>; Tue, 10 Jan 2023 13:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hk054R084mkFRV/1Y4y8vQQXWbfgbsX2+RxJlDPfb+8=;
        b=SsTIC/oxz4JOc15SOni5Tk1l+Py+AeYXPbxF6EAi/IPHD5vY06uQZYU95MvmU1vVHD
         b/mPg/c68RcJWyJT5jokACKKvQva2Cav0BBkuBkpsduN4aKAV2edYbVa7GA+CqCJfNps
         /q2YeeeSCBlFlj/zfpkV6YTj/XnTqZgoKn5oMRqCmsp4cHm5hunwYJCSGu6ydB+dkXpl
         RFAdjGXiazbhyq0uJdAAKT0onkU6LiVchRDtpHublfjrbwBatkpyDrTzgYyEZOb7JUEf
         h/pwAzui2wnl73MPUt5oQiKXWvNePT277Xkx+qo4l2THJYgioHPvGUG5i6VVaQ/q02D6
         4T1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hk054R084mkFRV/1Y4y8vQQXWbfgbsX2+RxJlDPfb+8=;
        b=AL143cFm3umqKiyohQQYP94YWYRjZ9BOJWl45WxvPMjuHQfQewJ2XypAETN8F1K+PI
         WFD2q99MgYG0h7Pq6qEXG7VK3PPpaO+ah4HwygQRGua2KtrVBNOD0dzDYX9DlOOvfGSf
         e4r3VJM8QlwFabHh6KWVkK6KjE5QR/l5NE8ksg/KOU7TZMPMAM3oCc4V6Lv4Qfvkukrs
         Q5skKVV0DesMbsUXyjI4t9TOOlnvQ2LJHZb8uEDxhmJXkTN/0K+bD+B//Fh/6f9n/OYH
         XpUwRgf9g0DPr2UpcApDjZ84fg5kogiznloX+ZOKW8rOdcPKUI8oDj0C1/oYXf4BuHhJ
         9jjQ==
X-Gm-Message-State: AFqh2krLGMK4anyTSfbOxFX2zgj4E0UgPdVS5jjpyXOrhW63Krqq+MyU
        8kN02KsTBWAK0jdqaBp1DnXp9EhN597hHTj619lp+222
X-Google-Smtp-Source: AMrXdXseuAt07NkB664mk90gDjwUxRvDUQWA+zC6toGxpBGK28ptX47SoDPdVztPWCkRKhTItvM4YMs9iBjYsiWzQSQ=
X-Received: by 2002:a05:6512:3601:b0:494:842e:3f6 with SMTP id
 f1-20020a056512360100b00494842e03f6mr3252770lfs.225.1673386476418; Tue, 10
 Jan 2023 13:34:36 -0800 (PST)
MIME-Version: 1.0
References: <20230110205520.4425-1-pc@cjr.nz>
In-Reply-To: <20230110205520.4425-1-pc@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 10 Jan 2023 15:34:25 -0600
Message-ID: <CAH2r5mua8CNGC3R4_349YgZeYB_k5YvnbFG4Yjd=jh=5Zg9toQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix double free on failed kerberos auth
To:     Paulo Alcantara <pc@cjr.nz>, Xiaoli Feng <fengxiaoli0714@gmail.com>
Cc:     linux-cifs@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next pending testing

Xioli,
Let me know if you want me to add your reported-by and/or tested-by

On Tue, Jan 10, 2023 at 2:55 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> If session setup failed with kerberos auth, we ended up freeing
> cifs_ses::auth_key.response twice in SMB2_auth_kerberos() and
> sesInfoFree().
>
> Fix this by zeroing out cifs_ses::auth_key.response after freeing it
> in SMB2_auth_kerberos().
>
> Fixes: a4e430c8c8ba ("cifs: replace kfree() with kfree_sensitive() for sensitive data")
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2pdu.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 2c484d47c592..727f16b426be 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1482,8 +1482,11 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
>  out_put_spnego_key:
>         key_invalidate(spnego_key);
>         key_put(spnego_key);
> -       if (rc)
> +       if (rc) {
>                 kfree_sensitive(ses->auth_key.response);
> +               ses->auth_key.response = NULL;
> +               ses->auth_key.len = 0;
> +       }
>  out:
>         sess_data->result = rc;
>         sess_data->func = NULL;
> --
> 2.39.0
>


-- 
Thanks,

Steve
