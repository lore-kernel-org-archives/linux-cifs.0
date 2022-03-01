Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFB5C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Mar 2022 23:12:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238638AbiCAXMo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Mar 2022 18:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238502AbiCAXMo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Mar 2022 18:12:44 -0500
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF349284C
        for <linux-cifs@vger.kernel.org>; Tue,  1 Mar 2022 15:12:01 -0800 (PST)
Received: by mail-vk1-xa31.google.com with SMTP id j5so7671403vkc.12
        for <linux-cifs@vger.kernel.org>; Tue, 01 Mar 2022 15:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sTEz7uHfFiQNSGce8KnqGNe58mpNbevwoUTEHygoITM=;
        b=R9tyz033RBzbxtpcvp1i1bUI/m5f0wZkyVoa79bNX/QxObfm7egmPCc6zS7FUbcq7V
         O3KcWOkI/O/BHtRF7MH3HWq2ttNjnsIBn5Oq0g+d9PkstaHBcd0tuyNvqaaA1DeTQ7vH
         Yg+linc0+4Ko2XzR9JjcvTXAROKO7EByEKqLZMll4sjuGYEeKX/8zVH9IRoMVFpbS8b/
         bXsCRWnmF96shCzg5LqdwMtiwr8pDAaFDgzZqJ7aOYK3ghAU6ApQuaUF5GRqGcr4V2l7
         MDlcETRIs4D5UwrFxM5nkXRxfQ9AFCqNFl9gaYgg9/yLsfgXzU/EZJCZvhO4EFq2SsDI
         AK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sTEz7uHfFiQNSGce8KnqGNe58mpNbevwoUTEHygoITM=;
        b=wcT0atI3KgthAjG7YfKVtxiVsDAFIElnE8N/0OJqxJf3sjPAcpsyKsoWmzw4bAqg+H
         yTkmfzqfRHbS6aSHeqMhwZDkwKQxf+YfDhp3VkFXo2nTAwKYSzDx0r7YQFutnmFV5aV/
         fApWIbsqDdfirUOubqlk/BrB+7lWZBG+A+nFCqp1fvx22I3NXXkaQAgA4ksWLHByDDYC
         yyCXM3WmDqp+K4xinMDWbAZwwBxOsvwt7EgJo1mUuAGbJrTPXd93fcLDmNQy8wVosUHY
         eWglRX1z1jv3othZh6StsN1ajIumlNTVfeRbmFNDvEd0x+bh0gKoTgVgph/8UvYivN+e
         GFqA==
X-Gm-Message-State: AOAM531BSLakE6o1CMPFcI+HK99kt7TjrCOtC95xXhHWhf4JVssWgsqi
        z1lVnhWxHSE/PzcH9a4neV1IB3sCJSBT0AQZ5u0=
X-Google-Smtp-Source: ABdhPJz746jbdJSr9i9GKUSykdOnjvtOIEBH8ArGnjnfaJvkhW3x5LyqgLUDW7BEKV0L5r3kp7LGKNs9L+MFAyqTJ48=
X-Received: by 2002:a05:6122:90d:b0:331:1fa1:5b40 with SMTP id
 j13-20020a056122090d00b003311fa15b40mr11967796vka.38.1646176320776; Tue, 01
 Mar 2022 15:12:00 -0800 (PST)
MIME-Version: 1.0
References: <20220301110006.4033351-1-mmakassikis@freebox.fr>
In-Reply-To: <20220301110006.4033351-1-mmakassikis@freebox.fr>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Wed, 2 Mar 2022 08:11:49 +0900
Message-ID: <CANFS6bYBFg2_AAQHpKUcDi06m2F-pG942TCpYoN+jWbuJXn67g@mail.gmail.com>
Subject: Re: [PATCH 1/4] ksmbd-tools: Fix function name typo
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good to me.
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

2022=EB=85=84 3=EC=9B=94 1=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 8:35, Ma=
rios Makassikis <mmakassikis@freebox.fr>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> Rename ndr_*_uniq_vsting_ptr to ndr_*_uniq_vstring_ptr.
>
> No functional change.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> ---
>  include/rpc.h       | 4 ++--
>  mountd/rpc.c        | 4 ++--
>  mountd/rpc_lsarpc.c | 2 +-
>  mountd/rpc_samr.c   | 6 +++---
>  mountd/rpc_srvsvc.c | 4 ++--
>  mountd/rpc_wkssvc.c | 4 ++--
>  6 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/include/rpc.h b/include/rpc.h
> index 6d6b8bdc127c..63d79bc724c8 100644
> --- a/include/rpc.h
> +++ b/include/rpc.h
> @@ -319,10 +319,10 @@ int ndr_write_string(struct ksmbd_dcerpc *dce, char=
 *str);
>  int ndr_write_lsa_string(struct ksmbd_dcerpc *dce, char *str);
>  char *ndr_read_vstring(struct ksmbd_dcerpc *dce);
>  void ndr_read_vstring_ptr(struct ksmbd_dcerpc *dce, struct ndr_char_ptr =
*ctr);
> -void ndr_read_uniq_vsting_ptr(struct ksmbd_dcerpc *dce,
> +void ndr_read_uniq_vstring_ptr(struct ksmbd_dcerpc *dce,
>                               struct ndr_uniq_char_ptr *ctr);
>  void ndr_free_vstring_ptr(struct ndr_char_ptr *ctr);
> -void ndr_free_uniq_vsting_ptr(struct ndr_uniq_char_ptr *ctr);
> +void ndr_free_uniq_vstring_ptr(struct ndr_uniq_char_ptr *ctr);
>  void ndr_read_ptr(struct ksmbd_dcerpc *dce, struct ndr_ptr *ctr);
>  void ndr_read_uniq_ptr(struct ksmbd_dcerpc *dce, struct ndr_uniq_ptr *ct=
r);
>  int __ndr_write_array_of_structs(struct ksmbd_rpc_pipe *pipe, int max_en=
try_nr);
> diff --git a/mountd/rpc.c b/mountd/rpc.c
> index 2361634f1a55..4db422abe9b0 100644
> --- a/mountd/rpc.c
> +++ b/mountd/rpc.c
> @@ -540,7 +540,7 @@ void ndr_read_vstring_ptr(struct ksmbd_dcerpc *dce, s=
truct ndr_char_ptr *ctr)
>         ctr->ptr =3D ndr_read_vstring(dce);
>  }
>
> -void ndr_read_uniq_vsting_ptr(struct ksmbd_dcerpc *dce,
> +void ndr_read_uniq_vstring_ptr(struct ksmbd_dcerpc *dce,
>                               struct ndr_uniq_char_ptr *ctr)
>  {
>         ctr->ref_id =3D ndr_read_int32(dce);
> @@ -557,7 +557,7 @@ void ndr_free_vstring_ptr(struct ndr_char_ptr *ctr)
>         ctr->ptr =3D NULL;
>  }
>
> -void ndr_free_uniq_vsting_ptr(struct ndr_uniq_char_ptr *ctr)
> +void ndr_free_uniq_vstring_ptr(struct ndr_uniq_char_ptr *ctr)
>  {
>         ctr->ref_id =3D 0;
>         free(ctr->ptr);
> diff --git a/mountd/rpc_lsarpc.c b/mountd/rpc_lsarpc.c
> index 5caf4d9ef3ac..cc99a147b239 100644
> --- a/mountd/rpc_lsarpc.c
> +++ b/mountd/rpc_lsarpc.c
> @@ -350,7 +350,7 @@ static int lsarpc_lookup_names3_invoke(struct ksmbd_r=
pc_pipe *pipe)
>                         break;
>                 ndr_read_int16(dce); // length
>                 ndr_read_int16(dce); // size
> -               ndr_read_uniq_vsting_ptr(dce, &username);
> +               ndr_read_uniq_vstring_ptr(dce, &username);
>                 if (strstr(STR_VAL(username), "\\")) {
>                         strtok(STR_VAL(username), "\\");
>                         name =3D strtok(NULL, "\\");
> diff --git a/mountd/rpc_samr.c b/mountd/rpc_samr.c
> index 7fe942cf3f08..6425215f6d34 100644
> --- a/mountd/rpc_samr.c
> +++ b/mountd/rpc_samr.c
> @@ -84,7 +84,7 @@ static int samr_connect5_invoke(struct ksmbd_rpc_pipe *=
pipe)
>         struct ksmbd_dcerpc *dce =3D pipe->dce;
>         struct ndr_uniq_char_ptr server_name;
>
> -       ndr_read_uniq_vsting_ptr(dce, &server_name);
> +       ndr_read_uniq_vstring_ptr(dce, &server_name);
>         ndr_read_int32(dce); // Access mask
>         dce->sm_req.level =3D ndr_read_int32(dce); // level in
>         ndr_read_int32(dce); // Info in
> @@ -184,7 +184,7 @@ static int samr_lookup_domain_invoke(struct ksmbd_rpc=
_pipe *pipe)
>         ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
>         ndr_read_int16(dce); // name len
>         ndr_read_int16(dce); // name size
> -       ndr_read_uniq_vsting_ptr(dce, &dce->sm_req.name); // domain name
> +       ndr_read_uniq_vstring_ptr(dce, &dce->sm_req.name); // domain name
>
>         return KSMBD_RPC_OK;
>  }
> @@ -254,7 +254,7 @@ static int samr_lookup_names_invoke(struct ksmbd_rpc_=
pipe *pipe)
>         ndr_read_int16(dce); // name len
>         ndr_read_int16(dce); // name size
>
> -       ndr_read_uniq_vsting_ptr(dce, &dce->sm_req.name); // names
> +       ndr_read_uniq_vstring_ptr(dce, &dce->sm_req.name); // names
>
>         return KSMBD_RPC_OK;
>  }
> diff --git a/mountd/rpc_srvsvc.c b/mountd/rpc_srvsvc.c
> index f3b4d069031a..7e9fa675d34a 100644
> --- a/mountd/rpc_srvsvc.c
> +++ b/mountd/rpc_srvsvc.c
> @@ -272,7 +272,7 @@ static int srvsvc_share_get_info_return(struct ksmbd_=
rpc_pipe *pipe)
>  static int srvsvc_parse_share_info_req(struct ksmbd_dcerpc *dce,
>                                        struct srvsvc_share_info_request *=
hdr)
>  {
> -       ndr_read_uniq_vsting_ptr(dce, &hdr->server_name);
> +       ndr_read_uniq_vstring_ptr(dce, &hdr->server_name);
>
>         if (dce->req_hdr.opnum =3D=3D SRVSVC_OPNUM_SHARE_ENUM_ALL) {
>                 int ptr;
> @@ -330,7 +330,7 @@ static int srvsvc_clear_headers(struct ksmbd_rpc_pipe=
 *pipe,
>         if (status =3D=3D KSMBD_RPC_EMORE_DATA)
>                 return 0;
>
> -       ndr_free_uniq_vsting_ptr(&pipe->dce->si_req.server_name);
> +       ndr_free_uniq_vstring_ptr(&pipe->dce->si_req.server_name);
>         if (pipe->dce->req_hdr.opnum =3D=3D SRVSVC_OPNUM_GET_SHARE_INFO)
>                 ndr_free_vstring_ptr(&pipe->dce->si_req.share_name);
>
> diff --git a/mountd/rpc_wkssvc.c b/mountd/rpc_wkssvc.c
> index 32b7893eb2c6..ba7f9a841e3d 100644
> --- a/mountd/rpc_wkssvc.c
> +++ b/mountd/rpc_wkssvc.c
> @@ -31,7 +31,7 @@
>  static int wkssvc_clear_headers(struct ksmbd_rpc_pipe *pipe,
>                                 int status)
>  {
> -       ndr_free_uniq_vsting_ptr(&pipe->dce->wi_req.server_name);
> +       ndr_free_uniq_vstring_ptr(&pipe->dce->wi_req.server_name);
>         return 0;
>  }
>
> @@ -141,7 +141,7 @@ static int
>  wkssvc_parse_netwksta_info_req(struct ksmbd_dcerpc *dce,
>                                struct wkssvc_netwksta_info_request *hdr)
>  {
> -       ndr_read_uniq_vsting_ptr(dce, &hdr->server_name);
> +       ndr_read_uniq_vstring_ptr(dce, &hdr->server_name);
>         hdr->level =3D ndr_read_int32(dce);
>         return 0;
>  }
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
