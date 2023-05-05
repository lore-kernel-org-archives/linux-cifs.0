Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA231C77B75
	for <linux-cifs@archiver.kernel.org>; Fri,  5 May 2023 16:48:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbjEEQsD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 May 2023 12:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjEEQsD (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 5 May 2023 12:48:03 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EC413843
        for <linux-cifs@vger.kernel.org>; Fri,  5 May 2023 09:48:02 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2ac836f4447so15790021fa.2
        for <linux-cifs@vger.kernel.org>; Fri, 05 May 2023 09:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683305280; x=1685897280;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vkq/ZgEsVSWkgOmjDl/SX5379XWcMRCyBV2NGyBXO/k=;
        b=TMaf/61q31++nUCUT/3ABb9azIqzKHcTBoeH+YbmxDlbCAzmNl5hYkccTIbdR/efKp
         ESSSlyyP28sf5QjszFQSYuKjfXn36FXvph3QrSR9XtELaZFb0yOgViXnWNcQekwLwBFf
         +/+dIpAtN2jksHFUPIaq+L5UhRFOMz4t7IF1V/gK9Ljlp0hgeXFxcavaqitSPjPwALpt
         RBDRvfziEtteUhV2xE/JOkyUVDWLgU9SAeQ5kzwYVzgQOhbuEH3shMV5xLzO8ahqDyEd
         EE/b+yx59DKjodb063ba2LjQ0xWNXj/jMhxRdQumXqLZkZDMkpgzT7fl0wjlcXXgR+Li
         0V4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683305280; x=1685897280;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vkq/ZgEsVSWkgOmjDl/SX5379XWcMRCyBV2NGyBXO/k=;
        b=bFE5gQ2vMcejXH1EpIFFsIY6L5NF9L74AjVPf7RwYLgEoQ5BjIVqCmcSEnf3Qeb6zp
         Wq+o7m0EUQmvgeoJk43++v6HdivRomYYbe+uB/QkzQjEGqD6vJ5orbElUhvYqZ2jy7oa
         oSWO7f0voJRafIIBFYtQ2NuTQvIgQQwYA0DvV/h0tYDUfzFDJNO1TJ9mDZ1L0EaOwRoX
         L7/3ybBQSikeofZ2xgCd7ISak5zDglM0Z8CZm4urQI5p/5R79/+fcOG4dUguyVnh9f5U
         YciQNJhZG+JnxFY1dqHk0FGxaYtYxyTXJllm/lPBmxMIzgwtfa7mJDCHdRvuoiXDZcCP
         al7w==
X-Gm-Message-State: AC+VfDxT0C7c6othfJv1cNqrFop5cFd7LkzSZLgtyULbiLdc3pubh9tk
        DWtLTip29q46FyJFRJ7cLUUVW3bPN9EGj1MrGTbbSg2g
X-Google-Smtp-Source: ACHHUZ7SADE0p4lKW2ExipS0/SKw11SD5BjdCcNaEXy3VF9cekOHCpanWX+maJKNLirfGB4xJoKOE1nN+QZptkzF2pE=
X-Received: by 2002:a2e:b0ed:0:b0:2ac:8486:e318 with SMTP id
 h13-20020a2eb0ed000000b002ac8486e318mr751853ljl.35.1683305279790; Fri, 05 May
 2023 09:47:59 -0700 (PDT)
MIME-Version: 1.0
References: <4b402539-1b98-bfe6-fa60-d73d13794077@gmail.com> <CAH2r5mszw6sayQfJqiYwTjPCqKDB7Dk-Hmtr0-Z3fXf=e3t0aQ@mail.gmail.com>
In-Reply-To: <CAH2r5mszw6sayQfJqiYwTjPCqKDB7Dk-Hmtr0-Z3fXf=e3t0aQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 5 May 2023 11:47:48 -0500
Message-ID: <CAH2r5mtP3Yw72tBNNS9+KRfU6QVK7Q-kK-+yKtMW+W102kss2Q@mail.gmail.com>
Subject: Fwd: [PATCH] cifs: fix pcchunk length type in smb2_copychunk_range
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

---------- Forwarded message ---------
From: Steve French <smfrench@gmail.com>
Date: Fri, May 5, 2023 at 11:47=E2=80=AFAM
Subject: Re: [PATCH] cifs: fix pcchunk length type in smb2_copychunk_range
To: Pawel Witek <pawel.ireneusz.witek@gmail.com>
Cc: <linux-cifs@vger.kernel.org>


since pcchunk->Length is a 32 bit field doing cpu_to_le64 seems wrong.

Perhaps one option is to split this into two lines do the minimum(u64,
len, tcon->max_bytes_chunk) on one line and the cpu_to_le32 of the
result on the next

What is "len" in the example you see failing?

On Fri, May 5, 2023 at 10:15=E2=80=AFAM Pawel Witek
<pawel.ireneusz.witek@gmail.com> wrote:
>
> Change type of pcchunk->Length from u32 to u64 to match
> smb2_copychunk_range arguments type. Fixes the problem where performing
> server-side copy with CIFS_IOC_COPYCHUNK_FILE ioctl resulted in incomplet=
e
> copy of large files while returning -EINVAL.
>
> Signed-off-by: Pawel Witek <pawel.ireneusz.witek@gmail.com>
> ---
>  fs/cifs/smb2ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index a81758225fcd..35c7c35882c9 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1682,7 +1682,7 @@ smb2_copychunk_range(const unsigned int xid,
>                 pcchunk->SourceOffset =3D cpu_to_le64(src_off);
>                 pcchunk->TargetOffset =3D cpu_to_le64(dest_off);
>                 pcchunk->Length =3D
> -                       cpu_to_le32(min_t(u32, len, tcon->max_bytes_chunk=
));
> +                       cpu_to_le64(min_t(u64, len, tcon->max_bytes_chunk=
));
>
>                 /* Request server copy to target from src identified by k=
ey */
>                 kfree(retbuf);
> --
> 2.40.1
>
>


--=20
Thanks,

Steve


--=20
Thanks,

Steve
