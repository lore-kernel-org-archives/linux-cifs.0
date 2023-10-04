Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC871E7C4E2
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Oct 2023 17:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243651AbjJDROf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Oct 2023 13:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243634AbjJDROe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 4 Oct 2023 13:14:34 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD850BF
        for <linux-cifs@vger.kernel.org>; Wed,  4 Oct 2023 10:14:30 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id 2adb3069b0e04-505a62d24b9so72469e87.2
        for <linux-cifs@vger.kernel.org>; Wed, 04 Oct 2023 10:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696439669; x=1697044469; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3gslD5XAzLKbBLj30E2T1HNZh9XKmRmxl79bGcWQMhY=;
        b=lys7mcMESKngl+QZmn1S+cwdU3s0EPXFvr+gn2f4NiD73AdgTcO//M64cY/0gHZLnv
         w88NSDWfl4So/rewPzHU7rkglknkn6BHiExlGG3VYTdeMwbvjbwikujvnBqXyoKft1nh
         uf1OFuV4vlAE1+ngma2EV4fpsfw43bqvByGjuqH1nH1HSOgTZTMScJwq/j6tH6lWYymU
         R0DYP8+6d2XoR1DjvJo5ydNb8xrTawLBpoen7qFTjz5xASq33XvQwPQfaCcDXjkMsAQm
         rf3dYylsjCvAkBLdlz/t4KCJMVjNjM+jfKgk9DXajDn2XUMLsnTASv+dpHHPyz7LU10g
         Vt/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696439669; x=1697044469;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3gslD5XAzLKbBLj30E2T1HNZh9XKmRmxl79bGcWQMhY=;
        b=QmSdHcbJa4MF69q+gG9fSmqgQ6DLa7wayW4ylg3q5R7TvLQMxvAnxS94rNzJKJegpD
         yw13Y+ONP5LC6DI4DRiuCv67wu1GeGONrOL6eDFCOUiVWDyrJWj8ESDtyds7U6M1MB5p
         QFnzpmNmJ8+OP4yQ2QkUbMZDYEls/zYKOURFjEgqyX/KSZCrFqXMOd624VI+cC9X8iM+
         SB6kS5LUOPTt22DeZNHsuCg/7CNuooSf3utQN8Kys0T2b8lY/YnJCpUq7NjvVzpNkAUX
         6d5/08PBZsFhtQm+Ap0weYcP8gfWFX/IwAEVKTNSHzxRznTi5zBu2ya3tH2nlKbubVC/
         5aVQ==
X-Gm-Message-State: AOJu0Yw4vZQ6sxzRDyjeYJGB6kWa3teVGOuDhkXn8HftPZa/LbLuv/h7
        pB/unMBAtWJJUNXYp4MqeH92aKDse8CIQsfUoOhARkTs
X-Google-Smtp-Source: AGHT+IHEq9rIzqaLYF1Dc6YaXWCONSe77hb+NJI+dFcrSVBOW+e50KaDTk66rsLzKmomfunkz+mI7sQMNL0Ck0s1APE=
X-Received: by 2002:a19:8c12:0:b0:4fe:8ba8:16a9 with SMTP id
 o18-20020a198c12000000b004fe8ba816a9mr2448150lfd.55.1696439668701; Wed, 04
 Oct 2023 10:14:28 -0700 (PDT)
MIME-Version: 1.0
References: <20231004111755.25338-1-meetakshisetiyaoss@gmail.com>
In-Reply-To: <20231004111755.25338-1-meetakshisetiyaoss@gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 4 Oct 2023 12:14:17 -0500
Message-ID: <CAH2r5mtDp3=5pc_CyThX=jJcXd98btAXArdF1Ept3OCVqrebcw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Add client version details to NTLM authenticate message
To:     meetakshisetiyaoss@gmail.com
Cc:     linux-cifs@vger.kernel.org, nspmangalore@gmail.com,
        bharathsm.hsk@gmail.com, pc@cjr.nz,
        Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending review/testing

On Wed, Oct 4, 2023 at 6:18=E2=80=AFAM <meetakshisetiyaoss@gmail.com> wrote=
:
>
> From: Meetakshi Setiya <msetiya@microsoft.com>
>
> The NTLM authenticate message currently sets the NTLMSSP_NEGOTIATE_VERSIO=
N
> flag but does not populate the VERSION structure. This commit fixes this
> bug by ensuring that the flag is set and the version details are included
> in the message.
>
> Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
> ---
>  fs/smb/client/ntlmssp.h |  4 ++--
>  fs/smb/client/sess.c    | 12 +++++++++---
>  2 files changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/fs/smb/client/ntlmssp.h b/fs/smb/client/ntlmssp.h
> index 2c5dde2ece58..875de43b72de 100644
> --- a/fs/smb/client/ntlmssp.h
> +++ b/fs/smb/client/ntlmssp.h
> @@ -133,8 +133,8 @@ typedef struct _AUTHENTICATE_MESSAGE {
>         SECURITY_BUFFER WorkstationName;
>         SECURITY_BUFFER SessionKey;
>         __le32 NegotiateFlags;
> -       /* SECURITY_BUFFER for version info not present since we
> -          do not set the version is present flag */
> +       struct  ntlmssp_version Version;
> +       /* SECURITY_BUFFER */
>         char UserString[];
>  } __attribute__((packed)) AUTHENTICATE_MESSAGE, *PAUTHENTICATE_MESSAGE;
>
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index 79f26c560edf..919ace2d13d4 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -1060,10 +1060,16 @@ int build_ntlmssp_auth_blob(unsigned char **pbuff=
er,
>         memcpy(sec_blob->Signature, NTLMSSP_SIGNATURE, 8);
>         sec_blob->MessageType =3D NtLmAuthenticate;
>
> +       /* send version information in ntlmssp authenticate also */
>         flags =3D ses->ntlmssp->server_flags | NTLMSSP_REQUEST_TARGET |
> -               NTLMSSP_NEGOTIATE_TARGET_INFO | NTLMSSP_NEGOTIATE_WORKSTA=
TION_SUPPLIED;
> -       /* we only send version information in ntlmssp negotiate, so do n=
ot set this flag */
> -       flags =3D flags & ~NTLMSSP_NEGOTIATE_VERSION;
> +               NTLMSSP_NEGOTIATE_TARGET_INFO | NTLMSSP_NEGOTIATE_VERSION=
 |
> +               NTLMSSP_NEGOTIATE_WORKSTATION_SUPPLIED;
> +
> +       sec_blob->Version.ProductMajorVersion =3D LINUX_VERSION_MAJOR;
> +       sec_blob->Version.ProductMinorVersion =3D LINUX_VERSION_PATCHLEVE=
L;
> +       sec_blob->Version.ProductBuild =3D cpu_to_le16(SMB3_PRODUCT_BUILD=
);
> +       sec_blob->Version.NTLMRevisionCurrent =3D NTLMSSP_REVISION_W2K3;
> +
>         tmp =3D *pbuffer + sizeof(AUTHENTICATE_MESSAGE);
>         sec_blob->NegotiateFlags =3D cpu_to_le32(flags);
>
> --
> 2.39.2
>


--=20
Thanks,

Steve
