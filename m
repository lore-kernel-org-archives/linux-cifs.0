Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF2AAC4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 01:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjJ3BLI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 29 Oct 2023 21:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjJ3BLH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 29 Oct 2023 21:11:07 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0723ABC;
        Sun, 29 Oct 2023 18:11:05 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-507973f3b65so5954199e87.3;
        Sun, 29 Oct 2023 18:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698628263; x=1699233063; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HWzhoVnKFFBMffNWFQigYM9G4ho8YKPLcr5+ugrZUYU=;
        b=HC0WZWtfYFsIsITS/arQXd7zKmEHGtjcIX1+gf5TMqwqPwizdWMfY5RD8wSLxJ2xCE
         StyyLgVoPMTinAhPtx8B4OmtWyepX2SmSv/aCKjnY4LxtrDOGra4+yYceY3jqXSvzsb0
         YiOyH5k2TfObjNiH+QbnyqXmXuYH4ER6tUgjOtibsZaLajhRSizPXGBLJBHtjBvN7j5E
         nEmDu7mXjI0Jr9GZa1Jal/4bGvoHcV/lGrhE4eMjIcpJoBiuUA6TwfwEEKffV3fVIBqU
         9trHqn+sLd5nx/Ny+78Rn8J10YrSK4kKjwnLclqlPoQ76kt/jd3kp5P57N53vMdnrPcE
         EkeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698628263; x=1699233063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HWzhoVnKFFBMffNWFQigYM9G4ho8YKPLcr5+ugrZUYU=;
        b=MIvFst+nQpd00Sd1Kb4YZEDmMNri4TtZ5LvPBXRRsIyIjFG7/K7miFEAbnhZsmjsuw
         ZKkz5ZQyiJNrXBOGLyWN5Tz9bGkCbSraWLOdC7xCIZUxJBW+LHdF7LM37vo7cMnTJmJI
         JbksHmLen9NFZb/DA5JMOdddsoNZs/2hHRK6v1OKZLFt/XcaytqiW1gsHaEB5yIBVG/C
         HwX7IOEryyEcLyYtnig0gXmpnUuQMZ4+/hhiWj9684bZlU9bYqmQfzWTGgLEvKg4D4rZ
         WOiN5hwFEhVp7dxygdfKFXsQVDfz6hN8l0PZOOEx2bOuDlEBoPApGjrdU2EQNd3esdfO
         xoew==
X-Gm-Message-State: AOJu0YzA6JzaWfr/W/TbCwLMypGIIlS6gEDHRYgHustDNoGSGbjC9d5Y
        PMPFzYyXZM2oL2qv0lf9Bq4tXCjI58L03z3AAdgG6kFYblg=
X-Google-Smtp-Source: AGHT+IH8CmA4x6Qidm5r2Y+Fnv1OLL2vn/sW/rtdQtrLFbSsvCKmeg3l+lh4WQO4ZL+xv4rVaAudct1EY5J59jo/NsY=
X-Received: by 2002:a05:6512:124f:b0:500:7fc1:414b with SMTP id
 fb15-20020a056512124f00b005007fc1414bmr7571399lfb.25.1698628262793; Sun, 29
 Oct 2023 18:11:02 -0700 (PDT)
MIME-Version: 1.0
References: <20231029050300.154832-1-ebiggers@kernel.org>
In-Reply-To: <20231029050300.154832-1-ebiggers@kernel.org>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 29 Oct 2023 20:10:51 -0500
Message-ID: <CAH2r5mvsVVfKc=p5PKjRhhmnSodVbXeZqir5h4puL-jJcHoQ_w@mail.gmail.com>
Subject: Re: [PATCH] smb: use crypto_shash_digest() in symlink_hash()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending additional testing

On Sun, Oct 29, 2023 at 12:03=E2=80=AFAM Eric Biggers <ebiggers@kernel.org>=
 wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Simplify symlink_hash() by using crypto_shash_digest() instead of an
> init+update+final sequence.  This should also improve performance.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/smb/client/link.c | 16 ++--------------
>  1 file changed, 2 insertions(+), 14 deletions(-)
>
> diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
> index c66be4904e1f..a1da50e66fbb 100644
> --- a/fs/smb/client/link.c
> +++ b/fs/smb/client/link.c
> @@ -35,37 +35,25 @@
>  #define CIFS_MF_SYMLINK_MD5_ARGS(md5_hash) md5_hash
>
>  static int
>  symlink_hash(unsigned int link_len, const char *link_str, u8 *md5_hash)
>  {
>         int rc;
>         struct shash_desc *md5 =3D NULL;
>
>         rc =3D cifs_alloc_hash("md5", &md5);
>         if (rc)
> -               goto symlink_hash_err;
> +               return rc;
>
> -       rc =3D crypto_shash_init(md5);
> -       if (rc) {
> -               cifs_dbg(VFS, "%s: Could not init md5 shash\n", __func__)=
;
> -               goto symlink_hash_err;
> -       }
> -       rc =3D crypto_shash_update(md5, link_str, link_len);
> -       if (rc) {
> -               cifs_dbg(VFS, "%s: Could not update with link_str\n", __f=
unc__);
> -               goto symlink_hash_err;
> -       }
> -       rc =3D crypto_shash_final(md5, md5_hash);
> +       rc =3D crypto_shash_digest(md5, link_str, link_len, md5_hash);
>         if (rc)
>                 cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func=
__);
> -
> -symlink_hash_err:
>         cifs_free_hash(&md5);
>         return rc;
>  }
>
>  static int
>  parse_mf_symlink(const u8 *buf, unsigned int buf_len, unsigned int *_lin=
k_len,
>                  char **_link_str)
>  {
>         int rc;
>         unsigned int link_len;
>
> base-commit: 2af9b20dbb39f6ebf9b9b6c090271594627d818e
> --
> 2.42.0
>


--=20
Thanks,

Steve
