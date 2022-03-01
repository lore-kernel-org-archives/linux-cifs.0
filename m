Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55ECEC433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Mar 2022 23:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235726AbiCAXNe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Mar 2022 18:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbiCAXNd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Mar 2022 18:13:33 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA6037BCF
        for <linux-cifs@vger.kernel.org>; Tue,  1 Mar 2022 15:12:48 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id q9so18488vsg.2
        for <linux-cifs@vger.kernel.org>; Tue, 01 Mar 2022 15:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=apABZnBJF91cFJ0Z1+cHO/asO+ovcbyh7nzrWCreQNM=;
        b=CSJN+c2yMFwkw04DpfYYHmRCVdtV2D788XwHoREYDR0HXj9hU7jSEiPyuWYmPfEIr2
         l03x68vn+fzyLf0/8I+vK4xS9WVr1jDJy+6ujlWt+nj3GZRX1/yuOiETc7b50AUzeMqF
         KjY7iQ8wb2X375/wGxzJwJbeBoetTMPQVcyvre/78z7KD6/YjTpsxiWxkiPzsRG0ldEl
         HG07Iqa+RnTxy2WyK7IYUMNMZATXRNml/yig83D+we+7lsTk2inHcfzSH4Ot491+Pc04
         RrmtLa3+qRnJIrmpw7MsfQ0l94XK73uSa0KeM/QZPUmylRFJPG+MBKTN31f8QunWJ1AU
         aSsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=apABZnBJF91cFJ0Z1+cHO/asO+ovcbyh7nzrWCreQNM=;
        b=g7YsWqhkBgWxlYwmrne7C+xiwWGcZ4K1vplwbpXVdnDwNnYHfdBr3SrgXofMliIOPZ
         5bAHTqs90tuSsu9eDGtKfXT99mVOJBpCRqHwe6Hytqxaiwl7M4XCNidBJ/rmzRChKeTo
         xe1JMYTB8ZA/L90CF0Ng7O4AONydu73k5B77GrOKxsGV/8J39S9cH+OvMmwIGFsAEkiR
         nHg2CjgI2LzfiBEB4pzHuIxnSIiOpyIzVhGWWVt+Y2qPgMgdSru37SzmbB+8N3kj8yZh
         16unitgn2n92q8y9qRhySqxnqFMAwyCkCP4KTFUX4plHLKllAU4fHgleZnq1491UKw+U
         HTZg==
X-Gm-Message-State: AOAM533WTGK9NgmYljUjdRSDHrAV6JCvPPEF0rXFw5As5XNdHROufcrj
        mFyVF1TAy/gQymn8lto6/ZPLE76C0pmzgEsz4Zw=
X-Google-Smtp-Source: ABdhPJysJbjJULdRWONN8KpL4/0USu7UttPItQGdG8PWzWA8+Cl25R+taya9BxX4L8ieuvImO9i7U7BBYc/p6gfKYLE=
X-Received: by 2002:a67:ef98:0:b0:31b:fdff:f374 with SMTP id
 r24-20020a67ef98000000b0031bfdfff374mr12140380vsp.56.1646176367227; Tue, 01
 Mar 2022 15:12:47 -0800 (PST)
MIME-Version: 1.0
References: <20220301110006.4033351-1-mmakassikis@freebox.fr> <20220301110006.4033351-3-mmakassikis@freebox.fr>
In-Reply-To: <20220301110006.4033351-3-mmakassikis@freebox.fr>
From:   Hyunchul Lee <hyc.lee@gmail.com>
Date:   Wed, 2 Mar 2022 08:12:35 +0900
Message-ID: <CANFS6ba5wy4W4U3VNnoggFLxzPY8nsYTsuKR3jEUqr+1oGk0hw@mail.gmail.com>
Subject: Re: [PATCH 3/4] ksmbd-tools: Add validation for ndr_read_* functions
To:     Marios Makassikis <mmakassikis@freebox.fr>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good to me.
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

2022=EB=85=84 3=EC=9B=94 1=EC=9D=BC (=ED=99=94) =EC=98=A4=ED=9B=84 8:36, Ma=
rios Makassikis <mmakassikis@freebox.fr>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> Modify the ndr_read_* functions to check the payload is large enough to
> read the requested bytes. Rather than returning the decoded value,
> return 0 on success and -EINVAL if the buffer is too short.
> This is the same pattern used in the kernel ksmbd code when dealing with
> NDR encoded data.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> ---
>  include/rpc.h       |  18 ++---
>  include/smbacl.h    |   2 +-
>  mountd/rpc.c        | 166 +++++++++++++++++++++++++++++++-------------
>  mountd/rpc_lsarpc.c |  77 +++++++++++++++-----
>  mountd/rpc_samr.c   |  94 ++++++++++++++++++-------
>  mountd/rpc_srvsvc.c |  35 +++++++---
>  mountd/rpc_wkssvc.c |   9 ++-
>  mountd/smbacl.c     |  14 ++--
>  8 files changed, 291 insertions(+), 124 deletions(-)
>
> diff --git a/include/rpc.h b/include/rpc.h
> index 63d79bc724c8..0fa99d41df35 100644
> --- a/include/rpc.h
> +++ b/include/rpc.h
> @@ -298,10 +298,10 @@ struct ksmbd_rpc_pipe {
>                                                    int i);
>  };
>
> -__u8 ndr_read_int8(struct ksmbd_dcerpc *dce);
> -__u16 ndr_read_int16(struct ksmbd_dcerpc *dce);
> -__u32 ndr_read_int32(struct ksmbd_dcerpc *dce);
> -__u64 ndr_read_int64(struct ksmbd_dcerpc *dce);
> +int ndr_read_int8(struct ksmbd_dcerpc *dce, __u8 *value);
> +int ndr_read_int16(struct ksmbd_dcerpc *dce, __u16 *value);
> +int ndr_read_int32(struct ksmbd_dcerpc *dce, __u32 *value);
> +int ndr_read_int64(struct ksmbd_dcerpc *dce, __u64 *value);
>
>  int ndr_write_int8(struct ksmbd_dcerpc *dce, __u8 value);
>  int ndr_write_int16(struct ksmbd_dcerpc *dce, __u16 value);
> @@ -310,7 +310,7 @@ int ndr_write_int64(struct ksmbd_dcerpc *dce, __u64 v=
alue);
>
>  int ndr_write_union_int16(struct ksmbd_dcerpc *dce, __u16 value);
>  int ndr_write_union_int32(struct ksmbd_dcerpc *dce, __u32 value);
> -__u32 ndr_read_union_int32(struct ksmbd_dcerpc *dce);
> +int ndr_read_union_int32(struct ksmbd_dcerpc *dce, __u32 *value);
>
>  int ndr_write_bytes(struct ksmbd_dcerpc *dce, void *value, size_t sz);
>  int ndr_read_bytes(struct ksmbd_dcerpc *dce, void *value, size_t sz);
> @@ -318,13 +318,13 @@ int ndr_write_vstring(struct ksmbd_dcerpc *dce, voi=
d *value);
>  int ndr_write_string(struct ksmbd_dcerpc *dce, char *str);
>  int ndr_write_lsa_string(struct ksmbd_dcerpc *dce, char *str);
>  char *ndr_read_vstring(struct ksmbd_dcerpc *dce);
> -void ndr_read_vstring_ptr(struct ksmbd_dcerpc *dce, struct ndr_char_ptr =
*ctr);
> -void ndr_read_uniq_vstring_ptr(struct ksmbd_dcerpc *dce,
> +int ndr_read_vstring_ptr(struct ksmbd_dcerpc *dce, struct ndr_char_ptr *=
ctr);
> +int ndr_read_uniq_vstring_ptr(struct ksmbd_dcerpc *dce,
>                               struct ndr_uniq_char_ptr *ctr);
>  void ndr_free_vstring_ptr(struct ndr_char_ptr *ctr);
>  void ndr_free_uniq_vstring_ptr(struct ndr_uniq_char_ptr *ctr);
> -void ndr_read_ptr(struct ksmbd_dcerpc *dce, struct ndr_ptr *ctr);
> -void ndr_read_uniq_ptr(struct ksmbd_dcerpc *dce, struct ndr_uniq_ptr *ct=
r);
> +int ndr_read_ptr(struct ksmbd_dcerpc *dce, struct ndr_ptr *ctr);
> +int ndr_read_uniq_ptr(struct ksmbd_dcerpc *dce, struct ndr_uniq_ptr *ctr=
);
>  int __ndr_write_array_of_structs(struct ksmbd_rpc_pipe *pipe, int max_en=
try_nr);
>  int ndr_write_array_of_structs(struct ksmbd_rpc_pipe *pipe);
>
> diff --git a/include/smbacl.h b/include/smbacl.h
> index 5be815447906..b0fe131c9fac 100644
> --- a/include/smbacl.h
> +++ b/include/smbacl.h
> @@ -72,7 +72,7 @@ struct smb_ace {
>  };
>
>  void smb_init_domain_sid(struct smb_sid *sid);
> -void smb_read_sid(struct ksmbd_dcerpc *dce, struct smb_sid *sid);
> +int smb_read_sid(struct ksmbd_dcerpc *dce, struct smb_sid *sid);
>  void smb_write_sid(struct ksmbd_dcerpc *dce, const struct smb_sid *src);
>  void smb_copy_sid(struct smb_sid *dst, const struct smb_sid *src);
>  int smb_compare_sids(const struct smb_sid *ctsid, const struct smb_sid *=
cwsid);
> diff --git a/mountd/rpc.c b/mountd/rpc.c
> index 4db422abe9b0..9d6402ba5281 100644
> --- a/mountd/rpc.c
> +++ b/mountd/rpc.c
> @@ -311,17 +311,22 @@ NDR_WRITE_INT(int32, __u32, htobe32, htole32);
>  NDR_WRITE_INT(int64, __u64, htobe64, htole64);
>
>  #define NDR_READ_INT(name, type, be, le)                               \
> -type ndr_read_##name(struct ksmbd_dcerpc *dce)                         \
> +int ndr_read_##name(struct ksmbd_dcerpc *dce, type *value)             \
>  {                                                                      \
>         type ret;                                                       \
>                                                                         \
>         align_offset(dce, sizeof(type));                                \
> +       if (dce->offset + sizeof(type) > dce->payload_sz)               \
> +               return -EINVAL;                                         \
> +                                                                       \
>         if (dce->flags & KSMBD_DCERPC_LITTLE_ENDIAN)                    \
>                 ret =3D le(*(type *)PAYLOAD_HEAD(dce));                  =
 \
>         else                                                            \
>                 ret =3D be(*(type *)PAYLOAD_HEAD(dce));                  =
 \
>         dce->offset +=3D sizeof(type);                                   =
 \
> -       return ret;                                                     \
> +       if (value)                                                      \
> +               *value =3D ret;                                          =
 \
> +       return 0;                                                       \
>  }
>
>  NDR_READ_INT(int8,  __u8, betoh_n, letoh_n);
> @@ -350,15 +355,22 @@ NDR_WRITE_UNION(int16, __u16);
>  NDR_WRITE_UNION(int32, __u32);
>
>  #define NDR_READ_UNION(name, type)                                     \
> -type ndr_read_union_##name(struct ksmbd_dcerpc *dce)                   \
> +int ndr_read_union_##name(struct ksmbd_dcerpc *dce, type *value)       \
>  {                                                                      \
> -       type ret =3D ndr_read_##name(dce);                               =
 \
> -       if (ndr_read_##name(dce) !=3D ret) {                             =
 \
> +       type val1, val2;                                                \
> +                                                                       \
> +       if (ndr_read_##name(dce, &val1))                                \
> +               return -EINVAL;                                         \
> +       if (ndr_read_##name(dce, &val2))                                \
> +               return -EINVAL;                                         \
> +       if (val1 !=3D val2) {                                            =
 \
>                 pr_err("NDR: union representation mismatch %lu\n",      \
> -                               (unsigned long)ret);                    \
> -               ret =3D -EINVAL;                                         =
 \
> +                               (unsigned long)val1);                   \
> +               return -EINVAL;                                         \
>         }                                                               \
> -       return ret;                                                     \
> +       if (value)                                                      \
> +               *value =3D val1;                                         =
 \
> +       return 0;                                                       \
>  }
>
>  NDR_READ_UNION(int32, __u32);
> @@ -377,6 +389,8 @@ int ndr_write_bytes(struct ksmbd_dcerpc *dce, void *v=
alue, size_t sz)
>  int ndr_read_bytes(struct ksmbd_dcerpc *dce, void *value, size_t sz)
>  {
>         align_offset(dce, 2);
> +       if (dce->offset + sz > dce->payload_sz)
> +               return -EINVAL;
>         memcpy(value, PAYLOAD_HEAD(dce), sz);
>         dce->offset +=3D sz;
>         return 0;
> @@ -503,12 +517,16 @@ char *ndr_read_vstring(struct ksmbd_dcerpc *dce)
>         gsize bytes_read =3D 0;
>         gsize bytes_written =3D 0;
>
> -       size_t raw_len;
> +       int raw_len;
>         int charset =3D KSMBD_CHARSET_UTF16LE;
>
> -       raw_len =3D ndr_read_int32(dce);
> -       ndr_read_int32(dce); /* read in offset */
> -       ndr_read_int32(dce);
> +       if (ndr_read_int32(dce, &raw_len))
> +               return NULL;
> +       /* read in offset */
> +       if (ndr_read_int32(dce, NULL))
> +               return NULL;
> +       if (ndr_read_int32(dce, NULL))
> +               return NULL;
>
>         if (!(dce->flags & KSMBD_DCERPC_LITTLE_ENDIAN))
>                 charset =3D KSMBD_CHARSET_UTF16BE;
> @@ -521,6 +539,9 @@ char *ndr_read_vstring(struct ksmbd_dcerpc *dce)
>                 return out;
>         }
>
> +       if (dce->offset + 2 * raw_len > dce->payload_sz)
> +               return NULL;
> +
>         out =3D ksmbd_gconvert(PAYLOAD_HEAD(dce),
>                              raw_len * 2,
>                              KSMBD_CHARSET_DEFAULT,
> @@ -535,20 +556,28 @@ char *ndr_read_vstring(struct ksmbd_dcerpc *dce)
>         return out;
>  }
>
> -void ndr_read_vstring_ptr(struct ksmbd_dcerpc *dce, struct ndr_char_ptr =
*ctr)
> +int ndr_read_vstring_ptr(struct ksmbd_dcerpc *dce, struct ndr_char_ptr *=
ctr)
>  {
>         ctr->ptr =3D ndr_read_vstring(dce);
> +       if (!ctr->ptr)
> +               return -EINVAL;
> +       return 0;
>  }
>
> -void ndr_read_uniq_vstring_ptr(struct ksmbd_dcerpc *dce,
> +int ndr_read_uniq_vstring_ptr(struct ksmbd_dcerpc *dce,
>                               struct ndr_uniq_char_ptr *ctr)
>  {
> -       ctr->ref_id =3D ndr_read_int32(dce);
> +       if (ndr_read_int32(dce, &ctr->ref_id))
> +               return -EINVAL;
> +
>         if (ctr->ref_id =3D=3D 0) {
> -               ctr->ptr =3D 0;
> -               return;
> +               ctr->ptr =3D NULL;
> +               return 0;
>         }
>         ctr->ptr =3D ndr_read_vstring(dce);
> +       if (!ctr->ptr)
> +               return -EINVAL;
> +       return 0;
>  }
>
>  void ndr_free_vstring_ptr(struct ndr_char_ptr *ctr)
> @@ -564,19 +593,24 @@ void ndr_free_uniq_vstring_ptr(struct ndr_uniq_char=
_ptr *ctr)
>         ctr->ptr =3D NULL;
>  }
>
> -void ndr_read_ptr(struct ksmbd_dcerpc *dce, struct ndr_ptr *ctr)
> +int ndr_read_ptr(struct ksmbd_dcerpc *dce, struct ndr_ptr *ctr)
>  {
> -       ctr->ptr =3D ndr_read_int32(dce);
> +       if (ndr_read_int32(dce, &ctr->ptr))
> +               return -EINVAL;
> +       return 0;
>  }
>
> -void ndr_read_uniq_ptr(struct ksmbd_dcerpc *dce, struct ndr_uniq_ptr *ct=
r)
> +int ndr_read_uniq_ptr(struct ksmbd_dcerpc *dce, struct ndr_uniq_ptr *ctr=
)
>  {
> -       ctr->ref_id =3D ndr_read_int32(dce);
> +       if (ndr_read_int32(dce, &ctr->ref_id))
> +               return -EINVAL;
>         if (ctr->ref_id =3D=3D 0) {
>                 ctr->ptr =3D 0;
> -               return;
> +               return 0;
>         }
> -       ctr->ptr =3D ndr_read_int32(dce);
> +       if (ndr_read_int32(dce, &ctr->ptr))
> +               return -EINVAL;
> +       return 0;
>  }
>
>  static int __max_entries(struct ksmbd_dcerpc *dce, struct ksmbd_rpc_pipe=
 *pipe)
> @@ -731,10 +765,14 @@ static int dcerpc_hdr_read(struct ksmbd_dcerpc *dce=
,
>  {
>         /* Common Type Header for the Serialization Stream */
>
> -       hdr->rpc_vers =3D ndr_read_int8(dce);
> -       hdr->rpc_vers_minor =3D ndr_read_int8(dce);
> -       hdr->ptype =3D ndr_read_int8(dce);
> -       hdr->pfc_flags =3D ndr_read_int8(dce);
> +       if (ndr_read_int8(dce, &hdr->rpc_vers))
> +               return -EINVAL;
> +       if (ndr_read_int8(dce, &hdr->rpc_vers_minor))
> +               return -EINVAL;
> +       if (ndr_read_int8(dce, &hdr->ptype))
> +               return -EINVAL;
> +       if (ndr_read_int8(dce, &hdr->pfc_flags))
> +               return -EINVAL;
>         /*
>          * This common type header MUST be presented by using
>          * little-endian format in the octet stream. The first
> @@ -746,16 +784,20 @@ static int dcerpc_hdr_read(struct ksmbd_dcerpc *dce=
,
>          * MUST use the IEEE floating-point format representation and
>          * ASCII character format.
>          */
> -       ndr_read_bytes(dce, &hdr->packed_drep, sizeof(hdr->packed_drep));
> +       if (ndr_read_bytes(dce, &hdr->packed_drep, sizeof(hdr->packed_dre=
p)))
> +               return -EINVAL;
>
>         dce->flags |=3D KSMBD_DCERPC_ALIGN4;
>         dce->flags |=3D KSMBD_DCERPC_LITTLE_ENDIAN;
>         if (hdr->packed_drep[0] !=3D DCERPC_SERIALIZATION_LITTLE_ENDIAN)
>                 dce->flags &=3D ~KSMBD_DCERPC_LITTLE_ENDIAN;
>
> -       hdr->frag_length =3D ndr_read_int16(dce);
> -       hdr->auth_length =3D ndr_read_int16(dce);
> -       hdr->call_id =3D ndr_read_int32(dce);
> +       if (ndr_read_int16(dce, &hdr->frag_length))
> +               return -EINVAL;
> +       if (ndr_read_int16(dce, &hdr->auth_length))
> +               return -EINVAL;
> +       if (ndr_read_int32(dce, &hdr->call_id))
> +               return -EINVAL;
>         return 0;
>  }
>
> @@ -772,9 +814,12 @@ static int dcerpc_response_hdr_write(struct ksmbd_dc=
erpc *dce,
>  static int dcerpc_request_hdr_read(struct ksmbd_dcerpc *dce,
>                                    struct dcerpc_request_header *hdr)
>  {
> -       hdr->alloc_hint =3D ndr_read_int32(dce);
> -       hdr->context_id =3D ndr_read_int16(dce);
> -       hdr->opnum =3D ndr_read_int16(dce);
> +       if (ndr_read_int32(dce, &hdr->alloc_hint))
> +               return -EINVAL;
> +       if (ndr_read_int16(dce, &hdr->context_id))
> +               return -EINVAL;
> +       if (ndr_read_int16(dce, &hdr->opnum))
> +               return -EINVAL;
>         return 0;
>  }
>
> @@ -805,13 +850,21 @@ int dcerpc_write_headers(struct ksmbd_dcerpc *dce, =
int method_status)
>  static int __dcerpc_read_syntax(struct ksmbd_dcerpc *dce,
>                                 struct dcerpc_syntax *syn)
>  {
> -       syn->uuid.time_low =3D ndr_read_int32(dce);
> -       syn->uuid.time_mid =3D ndr_read_int16(dce);
> -       syn->uuid.time_hi_and_version =3D ndr_read_int16(dce);
> -       ndr_read_bytes(dce, syn->uuid.clock_seq, sizeof(syn->uuid.clock_s=
eq));
> -       ndr_read_bytes(dce, syn->uuid.node, sizeof(syn->uuid.node));
> -       syn->ver_major =3D ndr_read_int16(dce);
> -       syn->ver_minor =3D ndr_read_int16(dce);
> +       if (ndr_read_int32(dce, &syn->uuid.time_low))
> +               return -EINVAL;
> +       if (ndr_read_int16(dce, &syn->uuid.time_mid))
> +               return -EINVAL;
> +       if (ndr_read_int16(dce, &syn->uuid.time_hi_and_version))
> +               return -EINVAL;
> +       if (ndr_read_bytes(dce, syn->uuid.clock_seq,
> +                          sizeof(syn->uuid.clock_seq)))
> +               return -EINVAL;
> +       if (ndr_read_bytes(dce, syn->uuid.node, sizeof(syn->uuid.node)))
> +               return -EINVAL;
> +       if (ndr_read_int16(dce, &syn->ver_major))
> +               return -EINVAL;
> +       if (ndr_read_int16(dce, &syn->ver_minor))
> +               return -EINVAL;
>         return 0;
>  }
>
> @@ -843,13 +896,18 @@ static int dcerpc_parse_bind_req(struct ksmbd_dcerp=
c *dce,
>                                  struct dcerpc_bind_request *hdr)
>  {
>         int i, j;
> +       int ret =3D -EINVAL;
>
>         hdr->flags =3D dce->rpc_req->flags;
> -       hdr->max_xmit_frag_sz =3D ndr_read_int16(dce);
> -       hdr->max_recv_frag_sz =3D ndr_read_int16(dce);
> -       hdr->assoc_group_id =3D ndr_read_int32(dce);
> +       if (ndr_read_int16(dce, &hdr->max_xmit_frag_sz))
> +               return -EINVAL;
> +       if (ndr_read_int16(dce, &hdr->max_recv_frag_sz))
> +               return -EINVAL;
> +       if (ndr_read_int32(dce, &hdr->assoc_group_id))
> +               return -EINVAL;
> +       if (ndr_read_int8(dce, &hdr->num_contexts))
> +               return -EINVAL;
>         hdr->list =3D NULL;
> -       hdr->num_contexts =3D ndr_read_int8(dce);
>         auto_align_offset(dce);
>
>         if (!hdr->num_contexts)
> @@ -862,24 +920,32 @@ static int dcerpc_parse_bind_req(struct ksmbd_dcerp=
c *dce,
>         for (i =3D 0; i < hdr->num_contexts; i++) {
>                 struct dcerpc_context *ctx =3D &hdr->list[i];
>
> -               ctx->id =3D ndr_read_int16(dce);
> -               ctx->num_syntaxes =3D ndr_read_int8(dce);
> +               if (ndr_read_int16(dce, &ctx->id))
> +                       goto fail;
> +               if (ndr_read_int8(dce, &ctx->num_syntaxes))
> +                       goto fail;
>                 if (!ctx->num_syntaxes) {
>                         pr_err("BIND: zero syntaxes provided\n");
> -                       return -EINVAL;
> +                       goto fail;
>                 }
>
>                 __dcerpc_read_syntax(dce, &ctx->abstract_syntax);
>
>                 ctx->transfer_syntaxes =3D calloc(ctx->num_syntaxes,
>                                                 sizeof(struct dcerpc_synt=
ax));
> -               if (!ctx->transfer_syntaxes)
> -                       return -ENOMEM;
> +               if (!ctx->transfer_syntaxes) {
> +                       ret =3D -ENOMEM;
> +                       goto fail;
> +               }
>
>                 for (j =3D 0; j < ctx->num_syntaxes; j++)
>                         __dcerpc_read_syntax(dce, &ctx->transfer_syntaxes=
[j]);
>         }
>         return KSMBD_RPC_OK;
> +
> +fail:
> +       free(hdr->list);
> +       return ret;
>  }
>
>  static int dcerpc_bind_invoke(struct ksmbd_rpc_pipe *pipe)
> diff --git a/mountd/rpc_lsarpc.c b/mountd/rpc_lsarpc.c
> index b9088950c46e..6aab08dd7223 100644
> --- a/mountd/rpc_lsarpc.c
> +++ b/mountd/rpc_lsarpc.c
> @@ -105,8 +105,12 @@ static int lsa_domain_account_data(struct ksmbd_dcer=
pc *dce, char *domain_name,
>  static int lsarpc_get_primary_domain_info_invoke(struct ksmbd_rpc_pipe *=
pipe)
>  {
>         struct ksmbd_dcerpc *dce =3D pipe->dce;
> +       __u16 val;
>
> -       dce->lr_req.level =3D ndr_read_int16(dce);
> +       if (ndr_read_int16(dce, &val))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
> +
> +       dce->lr_req.level =3D val;
>
>         return KSMBD_RPC_OK;
>  }
> @@ -158,9 +162,15 @@ static int lsarpc_open_policy2_return(struct ksmbd_r=
pc_pipe *pipe)
>  static int lsarpc_query_info_policy_invoke(struct ksmbd_rpc_pipe *pipe)
>  {
>         struct ksmbd_dcerpc *dce =3D pipe->dce;
> +       __u16 val;
>
> -       ndr_read_bytes(dce, dce->lr_req.handle, HANDLE_SIZE);
> -       dce->lr_req.level =3D ndr_read_int16(dce); // level
> +       if (ndr_read_bytes(dce, dce->lr_req.handle, HANDLE_SIZE))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
> +       // level
> +       if (ndr_read_int16(dce, &val))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
> +
> +       dce->lr_req.level =3D val;
>
>         return KSMBD_RPC_OK;
>  }
> @@ -206,19 +216,26 @@ static int __lsarpc_entry_processed(struct ksmbd_rp=
c_pipe *pipe, int i)
>  static int lsarpc_lookup_sid2_invoke(struct ksmbd_rpc_pipe *pipe)
>  {
>         struct ksmbd_dcerpc *dce =3D pipe->dce;
> +       struct lsarpc_names_info *ni =3D NULL;
>         unsigned int num_sid, i;
>
> -       ndr_read_bytes(dce, dce->lr_req.handle, HANDLE_SIZE);
> +       if (ndr_read_bytes(dce, dce->lr_req.handle, HANDLE_SIZE))
> +               goto fail;
>
> -       num_sid =3D ndr_read_int32(dce);
> -       ndr_read_int32(dce); // ref pointer
> -       ndr_read_int32(dce); // max count
> +       if (ndr_read_int32(dce, &num_sid))
> +               goto fail;
> +       // ref pointer
> +       if (ndr_read_int32(dce, NULL))
> +               goto fail;
> +       // max count
> +       if (ndr_read_int32(dce, NULL))
> +               goto fail;
>
>         for (i =3D 0; i < num_sid; i++)
> -               ndr_read_int32(dce); // ref pointer
> +               if (ndr_read_int32(dce, NULL)) // ref pointer
> +                       goto fail;
>
>         for (i =3D 0; i < num_sid; i++) {
> -               struct lsarpc_names_info *ni;
>                 struct passwd *passwd;
>                 int rid;
>
> @@ -226,8 +243,12 @@ static int lsarpc_lookup_sid2_invoke(struct ksmbd_rp=
c_pipe *pipe)
>                 if (!ni)
>                         break;
>
> -               ndr_read_int32(dce); // max count
> -               smb_read_sid(dce, &ni->sid); // sid
> +               // max count
> +               if (ndr_read_int32(dce, NULL))
> +                       goto fail;
> +               // sid
> +               if (smb_read_sid(dce, &ni->sid))
> +                       goto fail;
>                 ni->sid.num_subauth--;
>                 rid =3D ni->sid.sub_auth[ni->sid.num_subauth];
>                 passwd =3D getpwuid(rid);
> @@ -244,6 +265,9 @@ static int lsarpc_lookup_sid2_invoke(struct ksmbd_rpc=
_pipe *pipe)
>
>         pipe->entry_processed =3D __lsarpc_entry_processed;
>         return KSMBD_RPC_OK;
> +fail:
> +       free(ni);
> +       return KSMBD_RPC_EINVALID_PARAMETER;
>  }
>
>  static int lsarpc_lookup_sid2_return(struct ksmbd_rpc_pipe *pipe)
> @@ -333,24 +357,34 @@ static int lsarpc_lookup_sid2_return(struct ksmbd_r=
pc_pipe *pipe)
>  static int lsarpc_lookup_names3_invoke(struct ksmbd_rpc_pipe *pipe)
>  {
>         struct ksmbd_dcerpc *dce =3D pipe->dce;
> +       struct lsarpc_names_info *ni =3D NULL;
>         struct ndr_uniq_char_ptr username;
>         int num_names, i;
>
> -       ndr_read_bytes(dce, dce->lr_req.handle, HANDLE_SIZE);
> +       if (ndr_read_bytes(dce, dce->lr_req.handle, HANDLE_SIZE))
> +               goto fail;
>
> -       num_names =3D ndr_read_int32(dce); // num names
> -       ndr_read_int32(dce); // max count
> +       // num names
> +       if (ndr_read_int32(dce, &num_names))
> +               goto fail;
> +       // max count
> +       if (ndr_read_int32(dce, NULL))
> +               goto fail;
>
>         for (i =3D 0; i < num_names; i++) {
> -               struct lsarpc_names_info *ni;
>                 char *name =3D NULL;
>
>                 ni =3D malloc(sizeof(struct lsarpc_names_info));
>                 if (!ni)
>                         break;
> -               ndr_read_int16(dce); // length
> -               ndr_read_int16(dce); // size
> -               ndr_read_uniq_vstring_ptr(dce, &username);
> +               // length
> +               if (ndr_read_int16(dce, NULL))
> +                       goto fail;
> +               // size
> +               if (ndr_read_int16(dce, NULL))
> +                       goto fail;
> +               if (ndr_read_uniq_vstring_ptr(dce, &username))
> +                       goto fail;
>                 if (strstr(STR_VAL(username), "\\")) {
>                         strtok(STR_VAL(username), "\\");
>                         name =3D strtok(NULL, "\\");
> @@ -368,6 +402,10 @@ static int lsarpc_lookup_names3_invoke(struct ksmbd_=
rpc_pipe *pipe)
>         pipe->entry_processed =3D __lsarpc_entry_processed;
>
>         return KSMBD_RPC_OK;
> +
> +fail:
> +       free(ni);
> +       return KSMBD_RPC_EINVALID_PARAMETER;
>  }
>
>  static int lsarpc_lookup_names3_return(struct ksmbd_rpc_pipe *pipe)
> @@ -433,7 +471,8 @@ static int lsarpc_close_invoke(struct ksmbd_rpc_pipe =
*pipe)
>  {
>         struct ksmbd_dcerpc *dce =3D pipe->dce;
>
> -       ndr_read_bytes(dce, dce->lr_req.handle, HANDLE_SIZE);
> +       if (ndr_read_bytes(dce, dce->lr_req.handle, HANDLE_SIZE))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
>
>         return KSMBD_RPC_OK;
>  }
> diff --git a/mountd/rpc_samr.c b/mountd/rpc_samr.c
> index 6425215f6d34..5a9afd3000a2 100644
> --- a/mountd/rpc_samr.c
> +++ b/mountd/rpc_samr.c
> @@ -84,11 +84,19 @@ static int samr_connect5_invoke(struct ksmbd_rpc_pipe=
 *pipe)
>         struct ksmbd_dcerpc *dce =3D pipe->dce;
>         struct ndr_uniq_char_ptr server_name;
>
> -       ndr_read_uniq_vstring_ptr(dce, &server_name);
> -       ndr_read_int32(dce); // Access mask
> -       dce->sm_req.level =3D ndr_read_int32(dce); // level in
> -       ndr_read_int32(dce); // Info in
> -       dce->sm_req.client_version =3D ndr_read_int32(dce);
> +       if (ndr_read_uniq_vstring_ptr(dce, &server_name))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
> +       // Access mask
> +       if (ndr_read_int32(dce, NULL))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
> +       // level in
> +       if (ndr_read_int32(dce, &dce->sm_req.level))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
> +       // Info in
> +       if (ndr_read_int32(dce, NULL))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
> +       if (ndr_read_int32(dce, &dce->sm_req.client_version))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
>         return 0;
>  }
>
> @@ -115,7 +123,8 @@ static int samr_enum_domain_invoke(struct ksmbd_rpc_p=
ipe *pipe)
>  {
>         struct ksmbd_dcerpc *dce =3D pipe->dce;
>
> -       ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
> +       if (ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
>
>         return KSMBD_RPC_OK;
>  }
> @@ -181,10 +190,17 @@ static int samr_lookup_domain_invoke(struct ksmbd_r=
pc_pipe *pipe)
>  {
>         struct ksmbd_dcerpc *dce =3D pipe->dce;
>
> -       ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
> -       ndr_read_int16(dce); // name len
> -       ndr_read_int16(dce); // name size
> -       ndr_read_uniq_vstring_ptr(dce, &dce->sm_req.name); // domain name
> +       if (ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
> +       // name len
> +       if (ndr_read_int16(dce, NULL))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
> +       // name size
> +       if (ndr_read_int16(dce, NULL))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
> +       // domain name
> +       if (ndr_read_uniq_vstring_ptr(dce, &dce->sm_req.name))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
>
>         return KSMBD_RPC_OK;
>  }
> @@ -221,7 +237,8 @@ static int samr_open_domain_invoke(struct ksmbd_rpc_p=
ipe *pipe)
>  {
>         struct ksmbd_dcerpc *dce =3D pipe->dce;
>
> -       ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
> +       if (ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
>
>         return KSMBD_RPC_OK;
>  }
> @@ -245,16 +262,30 @@ static int samr_lookup_names_invoke(struct ksmbd_rp=
c_pipe *pipe)
>         struct ksmbd_dcerpc *dce =3D pipe->dce;
>         int user_num;
>
> -       ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
> +       if (ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
>
> -       user_num =3D ndr_read_int32(dce);
> -       ndr_read_int32(dce); // max count
> -       ndr_read_int32(dce); // offset
> -       ndr_read_int32(dce); // actual count
> -       ndr_read_int16(dce); // name len
> -       ndr_read_int16(dce); // name size
> +       if (ndr_read_int32(dce, &user_num))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
> +       // max count
> +       if (ndr_read_int32(dce, NULL))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
> +       // offset
> +       if (ndr_read_int32(dce, NULL))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
> +       // actual count
> +       if (ndr_read_int32(dce, NULL))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
> +       // name len
> +       if (ndr_read_int16(dce, NULL))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
> +       // name size
> +       if (ndr_read_int16(dce, NULL))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
>
> -       ndr_read_uniq_vstring_ptr(dce, &dce->sm_req.name); // names
> +       // names
> +       if (ndr_read_uniq_vstring_ptr(dce, &dce->sm_req.name))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
>
>         return KSMBD_RPC_OK;
>  }
> @@ -291,10 +322,14 @@ static int samr_open_user_invoke(struct ksmbd_rpc_p=
ipe *pipe)
>  {
>         struct ksmbd_dcerpc *dce =3D pipe->dce;
>
> -       ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
> +       if (ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
>
> -       ndr_read_int32(dce);
> -       dce->sm_req.rid =3D ndr_read_int32(dce); // RID
> +       if (ndr_read_int32(dce, NULL))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
> +       // RID
> +       if (ndr_read_int32(dce, &dce->sm_req.rid))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
>
>         return KSMBD_RPC_OK;
>  }
> @@ -321,7 +356,8 @@ static int samr_query_user_info_invoke(struct ksmbd_r=
pc_pipe *pipe)
>  {
>         struct ksmbd_dcerpc *dce =3D pipe->dce;
>
> -       ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
> +       if (ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
>
>         return KSMBD_RPC_OK;
>  }
> @@ -481,7 +517,8 @@ static int samr_query_security_invoke(struct ksmbd_rp=
c_pipe *pipe)
>  {
>         struct ksmbd_dcerpc *dce =3D pipe->dce;
>
> -       ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
> +       if (ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
>
>         return KSMBD_RPC_OK;
>  }
> @@ -519,7 +556,8 @@ static int samr_get_group_for_user_invoke(struct ksmb=
d_rpc_pipe *pipe)
>  {
>         struct ksmbd_dcerpc *dce =3D pipe->dce;
>
> -       ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
> +       if (ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE))
> +               return KSMBD_RPC_EINVALID_PARAMETER;
>
>         return KSMBD_RPC_OK;
>  }
> @@ -549,7 +587,8 @@ static int samr_get_alias_membership_invoke(struct ks=
mbd_rpc_pipe *pipe)
>  {
>         struct ksmbd_dcerpc *dce =3D pipe->dce;
>
> -       ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
> +       if (ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE))
> +               return KSMBD_RPC_EACCESS_DENIED;
>
>         return KSMBD_RPC_OK;
>  }
> @@ -575,7 +614,8 @@ static int samr_close_invoke(struct ksmbd_rpc_pipe *p=
ipe)
>  {
>         struct ksmbd_dcerpc *dce =3D pipe->dce;
>
> -       ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE);
> +       if (ndr_read_bytes(dce, dce->sm_req.handle, HANDLE_SIZE))
> +               return KSMBD_RPC_EACCESS_DENIED;
>
>         return KSMBD_RPC_OK;
>  }
> diff --git a/mountd/rpc_srvsvc.c b/mountd/rpc_srvsvc.c
> index 7e9fa675d34a..38b984b3a269 100644
> --- a/mountd/rpc_srvsvc.c
> +++ b/mountd/rpc_srvsvc.c
> @@ -272,32 +272,45 @@ static int srvsvc_share_get_info_return(struct ksmb=
d_rpc_pipe *pipe)
>  static int srvsvc_parse_share_info_req(struct ksmbd_dcerpc *dce,
>                                        struct srvsvc_share_info_request *=
hdr)
>  {
> -       ndr_read_uniq_vstring_ptr(dce, &hdr->server_name);
> +       if (ndr_read_uniq_vstring_ptr(dce, &hdr->server_name))
> +               return -EINVAL;
>
>         if (dce->req_hdr.opnum =3D=3D SRVSVC_OPNUM_SHARE_ENUM_ALL) {
>                 int ptr;
> +               __u32 val;
>
>                 /* Read union switch selector */
> -               hdr->level =3D ndr_read_union_int32(dce);
> -               if (hdr->level =3D=3D -EINVAL)
> +               if (ndr_read_union_int32(dce, &val))
>                         return -EINVAL;
> -               ndr_read_int32(dce); // read container pointer ref id
> -               ndr_read_int32(dce); // read container array size
> -               ptr =3D ndr_read_int32(dce); // read container array poin=
ter
> -                                          // it should be null
> +               hdr->level =3D val;
> +               // read container pointer ref id
> +               if (ndr_read_int32(dce, NULL))
> +                       return -EINVAL;
> +               // read container array size
> +               if (ndr_read_int32(dce, NULL))
> +                       return -EINVAL;
> +               // read container array pointer
> +               if (ndr_read_int32(dce, &ptr))
> +                       return -EINVAL;
> +               // it should be null
>                 if (ptr !=3D 0x00) {
>                         pr_err("SRVSVC: container array pointer is %x\n",
>                                 ptr);
>                         return -EINVAL;
>                 }
> -               hdr->max_size =3D ndr_read_int32(dce);
> -               ndr_read_uniq_ptr(dce, &hdr->payload_handle);
> +               if (ndr_read_int32(dce, &val))
> +                       return -EINVAL;
> +               hdr->max_size =3D val;
> +               if (ndr_read_uniq_ptr(dce, &hdr->payload_handle))
> +                       return -EINVAL;
>                 return 0;
>         }
>
>         if (dce->req_hdr.opnum =3D=3D SRVSVC_OPNUM_GET_SHARE_INFO) {
> -               ndr_read_vstring_ptr(dce, &hdr->share_name);
> -               hdr->level =3D ndr_read_int32(dce);
> +               if (ndr_read_vstring_ptr(dce, &hdr->share_name))
> +                       return -EINVAL;
> +               if (ndr_read_int32(dce, &hdr->level))
> +                       return -EINVAL;
>                 return 0;
>         }
>
> diff --git a/mountd/rpc_wkssvc.c b/mountd/rpc_wkssvc.c
> index ba7f9a841e3d..124078fd38b4 100644
> --- a/mountd/rpc_wkssvc.c
> +++ b/mountd/rpc_wkssvc.c
> @@ -141,8 +141,13 @@ static int
>  wkssvc_parse_netwksta_info_req(struct ksmbd_dcerpc *dce,
>                                struct wkssvc_netwksta_info_request *hdr)
>  {
> -       ndr_read_uniq_vstring_ptr(dce, &hdr->server_name);
> -       hdr->level =3D ndr_read_int32(dce);
> +       int val;
> +
> +       if (ndr_read_uniq_vstring_ptr(dce, &hdr->server_name))
> +               return -EINVAL;
> +       if (ndr_read_int32(dce, &val))
> +               return -EINVAL;
> +       hdr->level =3D val;
>         return 0;
>  }
>
> diff --git a/mountd/smbacl.c b/mountd/smbacl.c
> index 66531c3bebea..cc043ea59c2c 100644
> --- a/mountd/smbacl.c
> +++ b/mountd/smbacl.c
> @@ -30,16 +30,20 @@ static const struct smb_sid sid_unix_groups =3D { 1, =
1, {0, 0, 0, 0, 0, 22},
>  static const struct smb_sid sid_local_group =3D {
>         1, 1, {0, 0, 0, 0, 0, 5}, {32} };
>
> -void smb_read_sid(struct ksmbd_dcerpc *dce, struct smb_sid *sid)
> +int smb_read_sid(struct ksmbd_dcerpc *dce, struct smb_sid *sid)
>  {
>         int i;
>
> -       sid->revision =3D ndr_read_int8(dce);
> -       sid->num_subauth =3D ndr_read_int8(dce);
> +       if (ndr_read_int8(dce, &sid->revision))
> +               return -EINVAL;
> +       if (ndr_read_int8(dce, &sid->num_subauth))
> +               return -EINVAL;
>         for (i =3D 0; i < NUM_AUTHS; ++i)
> -               sid->authority[i] =3D ndr_read_int8(dce);
> +               if (ndr_read_int8(dce, &sid->authority[i]))
> +                       return -EINVAL;
>         for (i =3D 0; i < sid->num_subauth; ++i)
> -               sid->sub_auth[i] =3D ndr_read_int32(dce);
> +               if (ndr_read_int32(dce, &sid->sub_auth[i]))
> +                       return -EINVAL;
>  }
>
>  void smb_write_sid(struct ksmbd_dcerpc *dce, const struct smb_sid *src)
> --
> 2.25.1
>


--=20
Thanks,
Hyunchul
