Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51626C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 17 May 2022 08:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235013AbiEQIFl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 May 2022 04:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242292AbiEQIFj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 May 2022 04:05:39 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7053EBA0
        for <linux-cifs@vger.kernel.org>; Tue, 17 May 2022 01:05:38 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id bg25so9965733wmb.4
        for <linux-cifs@vger.kernel.org>; Tue, 17 May 2022 01:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cuCW9T6SSEeY6SkDGT5HHQbPkmPAs6Gr+DWJqav36hI=;
        b=HV7uR42B+wuVzDKBv6uUU8fdSUtvcb9rxmntNntepLg8My5OS0Lmos+fcjWTgve34j
         lRmy4qlF4EQHOsoXTtN5F0bJ+useuDZusaxhBSfco8Zo2ZOONvR1LN2tNlfQlXCKeKEF
         x4GhHgwBw9nmVSERcf6kkYiYBNtYObJjBp5cPsfMKEAZo8+bI/SGlTBHZj2YVBVOty4/
         61gxQTR3oQ02xx8Nr9xQmCcSDz3GZzslvgxnxalCypdOR9G2/fPNHqlsY6X340X65FeG
         A8D1GUkRpMSXnSwP18HefkZ19fwOp5sa2XuFHE9NLdnC1xHI6j9VNryiQZ8cXaZOzeIx
         tVHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cuCW9T6SSEeY6SkDGT5HHQbPkmPAs6Gr+DWJqav36hI=;
        b=076VcimkM+hK1CqyNuahRDkbxd610HQug/VQTm2LzMvBlSap2EwXMkQ5uEnL3wXHbs
         vYbtx4k9GPzGy0DQNt8SL/fTRQtRmYfikJW6G5oXyf/CeO+hnu1MfHwjnxCuZcxVXate
         k8AsqasxPNVk1ba8Ndj5qaKe2xUa//o9mNylo/1xA8ay4CtxTvSHl6Kf6eWbXItMh6XV
         OqzSpyw4WQFq0ngfxGp4KHraCiT6KvQcFc1uTThUibBRoGHPsMHyHerLY0c1qKrlbvzO
         V+Fr6ddBhPL7t/0jdvdQSXYuAd6ZYngeT3XFgb4kH+UFmSF4i/TwfT616mDSJEg0edco
         A0Kg==
X-Gm-Message-State: AOAM532TDN82emgGw2G/owHYKlJl+dr73lziYfBbuziNwmcHd8YSN1YF
        szxFacg58ge0/39JN+CpBBOkqbitoKe5kBUsHSg=
X-Google-Smtp-Source: ABdhPJzV7NQTu2IgUxupjzjzTUx3EkMQgXIQ6j71LTdQ20Xr1Sq3cJQaf9ssa/8MlqmYXXUaFGsSHj4hEKBJhxp/eVU=
X-Received: by 2002:a05:600c:19d1:b0:394:7661:6de9 with SMTP id
 u17-20020a05600c19d100b0039476616de9mr20515462wmq.76.1652774737336; Tue, 17
 May 2022 01:05:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220516074140.28522-1-linkinjeon@kernel.org>
In-Reply-To: <20220516074140.28522-1-linkinjeon@kernel.org>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Tue, 17 May 2022 17:05:26 +0900
Message-ID: <CANFS6bYkmDY1esbs6Wd4n_PW_M1zfN3Ft7_7hra9Ad=9Mcf+Rg@mail.gmail.com>
Subject: Re: [PATCH 1/3] ksmbd: handle smb2 query dir request for
 OutputBufferLength that is too small
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022=EB=85=84 5=EC=9B=94 16=EC=9D=BC (=EC=9B=94) =EC=98=A4=ED=9B=84 4:42, N=
amjae Jeon <linkinjeon@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> We found the issue that ksmbd return STATUS_NO_MORE_FILES response
> even though there are still dentries that needs to be read while
> file read/write test using framtest utils.
> windows client send smb2 query dir request included
> OutputBufferLength(128) that is too small to contain even one entry.
> This patch make ksmbd immediately returns OutputBufferLength of response
> as zero to client.
>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---

Looks good to me.
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

>  fs/ksmbd/smb2pdu.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 10b7052e382f..eb7ca5f24a3b 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -3938,6 +3938,12 @@ int smb2_query_dir(struct ksmbd_work *work)
>         set_ctx_actor(&dir_fp->readdir_data.ctx, __query_dir);
>
>         rc =3D iterate_dir(dir_fp->filp, &dir_fp->readdir_data.ctx);
> +       /*
> +        * req->OutputBufferLength is too small to contain even one entry=
.
> +        * In this case, it immediately returns OutputBufferLength 0 to c=
lient.
> +        */
> +       if (!d_info.out_buf_len && !d_info.num_entry)
> +               goto no_buf_len;
>         if (rc =3D=3D 0)
>                 restart_ctx(&dir_fp->readdir_data.ctx);
>         if (rc =3D=3D -ENOSPC)
> @@ -3964,10 +3970,12 @@ int smb2_query_dir(struct ksmbd_work *work)
>                 rsp->Buffer[0] =3D 0;
>                 inc_rfc1001_len(work->response_buf, 9);
>         } else {
> +no_buf_len:
>                 ((struct file_directory_info *)
>                 ((char *)rsp->Buffer + d_info.last_entry_offset))
>                 ->NextEntryOffset =3D 0;
> -               d_info.data_count -=3D d_info.last_entry_off_align;
> +               if (d_info.data_count >=3D d_info.last_entry_off_align)
> +                       d_info.data_count -=3D d_info.last_entry_off_alig=
n;
>
>                 rsp->StructureSize =3D cpu_to_le16(9);
>                 rsp->OutputBufferOffset =3D cpu_to_le16(72);
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
