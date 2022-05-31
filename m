Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BCF7C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 31 May 2022 22:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347557AbiEaW6T (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 May 2022 18:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346457AbiEaW6S (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 May 2022 18:58:18 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA128D698
        for <linux-cifs@vger.kernel.org>; Tue, 31 May 2022 15:58:16 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id j7so15075797vsj.7
        for <linux-cifs@vger.kernel.org>; Tue, 31 May 2022 15:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F6jLlotet9fld88869eL4pV3RiJxYyLTLvKbQkNleEQ=;
        b=G93pYWX80Lnj4R4Ro0uCQKNSjc+xDNuSagXZKj3kekd8IItz07TZTwAWEICVpRLV/u
         FntPWeqhWdecU+3053218tGhEI8Oy+6PcgFV/SExUyIfJw8pahCn4JHSUw8P6y/1xal8
         yaZqPzlH60kjIBPBqLIQTbHEALTEqq+vYbzx4iJymQ2oicRNw3KP5Tl/t4bVMyfbfuJP
         DFDsrG8m0gRKwZd/NX0YhY7BA6mTwGPZvFpfHlemjt+zfCmf7ZkURI2xpvZJKV0DVfpD
         Igi4CfUn8VbmUtP5oO0PHqmTTKE38rxWQOaZuqVKzrfBguy1BE2Mgbj1vetlBTdStSlD
         awzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F6jLlotet9fld88869eL4pV3RiJxYyLTLvKbQkNleEQ=;
        b=256ik/1k9FePGl98WYjtsP8ET1V62Hwp8q5agAHt9LFV92MdbpPdJxMcITrbvztTLw
         kbrI79m8bNanwyscS2S8K+0wZtLy3V0h3na5hD3B9QB4Sv3eDN3T3fSUGka8P18VJOjq
         vRpjxN4LnUA6oBLGGBdd7OV59y2eotxFwXEgksZ2fQCAN+uzj/uGHVe1tky+BPy8pXc7
         vs0i4PWgps9brLJB3mQzlOG2LgZ0IvldMatmBrwXob9iFYR5Q3hZxBexFbNwKRYsaf7w
         A6CMFJuF9fI+TRGi1LahnkQi+77SpOUYkQMMZA91ZZjWdIJ0SMSdaUdv+2KaLjoWVRfV
         8TdQ==
X-Gm-Message-State: AOAM532+gbW59aFbxnsSZ/naUGLyPQXvZbX/ccCwBiXCFEvMncOZvC8E
        yYLN1maRZ389yQrFMOq4lLc3u+SYRr8wpcx6leJWIbQ6
X-Google-Smtp-Source: ABdhPJwKZq/VSdnZOyQDDTX71T9gHi1ubFj9WBvtxVE5zpnEVmh/YB21e6J+PlZutoVg1FOm3CfdFj2VvDPILMnwCT4=
X-Received: by 2002:a05:6102:2137:b0:338:f898:8bbd with SMTP id
 f23-20020a056102213700b00338f8988bbdmr14201758vsg.60.1654037895894; Tue, 31
 May 2022 15:58:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220531224838.425356-1-lsahlber@redhat.com>
In-Reply-To: <20220531224838.425356-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 31 May 2022 15:58:05 -0700
Message-ID: <CAH2r5mtxgpxj6uThwG7SaTT1EQ5_GUkv8UOKDcG5ZbY74Ytgww@mail.gmail.com>
Subject: Re: [PATCH] cifs: when extending a file with falloc we should make
 files not-sparse
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

will merge to cifs-2.6.git for-next and cc:stable

On Tue, May 31, 2022 at 3:48 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> as this is the only way to make sure the region is allocated.
> Fix the conditional that was wrong and only tried to make already
> non-sparse files non-sparse.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index d7ade739cde1..03ab28c341c4 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -3859,7 +3859,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
>                 if (rc)
>                         goto out;
>
> -               if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
> +               if (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)
>                         smb2_set_sparse(xid, tcon, cfile, inode, false);
>
>                 eof = cpu_to_le64(off + len);
> --
> 2.35.3
>


-- 
Thanks,

Steve
