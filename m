Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF193ECAAD8
	for <linux-cifs@archiver.kernel.org>; Sat, 17 Sep 2022 01:04:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiIQBEn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Sep 2022 21:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiIQBEl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Sep 2022 21:04:41 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D2917063
        for <linux-cifs@vger.kernel.org>; Fri, 16 Sep 2022 18:04:39 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id lc7so53056814ejb.0
        for <linux-cifs@vger.kernel.org>; Fri, 16 Sep 2022 18:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Z+AjCDYgpkXZVHCrU99/jEqVC7Qx1qP/iKbGLi8Tknw=;
        b=gLJ6BDJ8jL8BpDpW81INthkxrO9HdW8F7xB0kjsqySr/pPAv/enBq4lVPjKcfQxZfz
         GhSViqjGsFAJY0RTL1wv5f3jxZTcGkLu7MNzdH5IGculFMUDgCZNV81D9UTBWdKBSUjq
         PdhdRbEAo3WI1ycPcamdyjg4fH5REzfAmRZX4yfZLuGUye9vQdeAgPG4FqIX/iRppbqZ
         0fSb3MZeg1w+Qg0eP4ZeS3RrOP76ElokH2P+d/tXCmtbl0o3qPgy+RAnZeabm2M91Wxb
         s1RXvMg+g4UdomvDeqlghBt/IWr+kl89SQwFSMNdRwkcJsadxF8dTvkPH8/tKD4Obv0c
         Ub7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Z+AjCDYgpkXZVHCrU99/jEqVC7Qx1qP/iKbGLi8Tknw=;
        b=ySX5Jx8xfKnojeacLi7kgSfzeEqFFph9FHc9CMNDau3au1MaPNRKrV6UB0r/GB90yU
         daTqu5v5XijmnNaTL89Jd22KccPkwX6CaaCCJg+j7DskRAWYXFfotNVSMqqZzQjeQ5yn
         Y3dNt82ydqO5G6xPah86gKe07NYrxnPve8n9Xis+ALDlzn2rxI8wn6z3h3Y0bWKF4ID8
         iyyxlqOybrxa/P/xWQYucQz+aJStiFTSszJFb8VQpoXpMukdtylfOQTV4HKeWQslz7+a
         2LkkxIYr6aOxAmWvysZ/bzScTWj2JKZnhI2sCTQR6SbOv4oW9guSLJEUHznN6Cp0U3tT
         PCgQ==
X-Gm-Message-State: ACrzQf2KuPxArX7rrgv6Jyi69VrqA/jTlTuliiYPcsYHxjhIhawzhkUV
        W/0TWz3NoD0n+Jk0AHmI2cfPM/0IpqmXFItryyI=
X-Google-Smtp-Source: AMsMyM6v4H6rduxoKOKeGMn1xIW8jbefKFhFaDCarmbumgsMPGaivHHXbbM3a6szep7F2DOZwQ3uzZGqYwCZeleVpy0=
X-Received: by 2002:a17:906:a0d3:b0:73d:be5b:2b52 with SMTP id
 bh19-20020a170906a0d300b0073dbe5b2b52mr5349845ejb.727.1663376677717; Fri, 16
 Sep 2022 18:04:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220916235705.14044-1-ematsumiya@suse.de>
In-Reply-To: <20220916235705.14044-1-ematsumiya@suse.de>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Sat, 17 Sep 2022 11:04:25 +1000
Message-ID: <CAN05THQbwrs0Y0OmfeoBDb9Gf109BoKx8vPrmUuzBC726CMX5A@mail.gmail.com>
Subject: Re: [PATCH] cifs: return correct error in ->calc_signature()
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        nspmangalore@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

reviewed by me

On Sat, 17 Sept 2022 at 09:57, Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> If an error happens while getting the key or session in the
> ->calc_signature implementations, 0 (success) is returned. Fix it by
> returning a proper error code.
>
> Since it seems to be highly unlikely to happen wrap the rc check in
> unlikely() too.
>
> Fixes: 32811d242ff6 ("cifs: Start using per session key for smb2/3 for signature generation")
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/cifs/smb2transport.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index 1a5fc3314dbf..4640fc4a8b13 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -225,9 +225,9 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
>         struct smb_rqst drqst;
>
>         ses = smb2_find_smb_ses(server, le64_to_cpu(shdr->SessionId));
> -       if (!ses) {
> +       if (unlikely(!ses)) {
>                 cifs_server_dbg(VFS, "%s: Could not find session\n", __func__);
> -               return 0;
> +               return -ENOENT;
>         }
>
>         memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
> @@ -557,8 +557,10 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
>         u8 key[SMB3_SIGN_KEY_SIZE];
>
>         rc = smb2_get_sign_key(le64_to_cpu(shdr->SessionId), server, key);
> -       if (rc)
> -               return 0;
> +       if (unlikely(rc)) {
> +               cifs_server_dbg(VFS, "%s: Could not get signing key\n", __func__);
> +               return rc;
> +       }
>
>         if (allocate_crypto) {
>                 rc = cifs_alloc_hash("cmac(aes)", &hash, &sdesc);
> --
> 2.35.3
>
