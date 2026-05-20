Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5AB3FCB1E
	for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 14:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779288732; cv=pass; b=lK0w8J5YqfYb2GYlBz1ibAubLsZ9nNJyIl4/7V38gg4p32V6a8xml7XcK+pLl60OL5dxrgyNyvXdKoPVLklwTngF9LXMIj/BB9hAHVHfAlRjqr/AKccB9mymwdBLgXk9pEK72bkOeu4B6oekcMLsZ15dZzzMihbuFtGGxe+sajM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779288732; c=relaxed/simple;
	bh=3d3BcVtFG87CAvL+8GY/rPBFY1Ty98h7ejanNXu2EH0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IB2dMN99mkg2DLJMnZTtUW+w+F2BZLuWslb0Ft4K7iEzGxI/frl/dmyrAzk3yUhJRMBiE7DNloUwYkgZ2Mww92JHNbtljrhGpI7mM/pfq+8FAumyGdDrSmetNRNZR9AwqDspbmUEQfIK6JOnG+ezHJuYQUJqPBmMLCaYvdkp2uc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aHoi6esx; arc=pass smtp.client-ip=209.85.222.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aHoi6esx"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-95cd9bc6398so3333763241.3
        for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 07:52:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779288729; cv=none;
        d=google.com; s=arc-20240605;
        b=isC/Gkv7d2TovtibOiea81lN5MACPWISOTGACnsqhV3hKvsH4Tt1vEnDt/oW/e7lb5
         JCPY23wU3sNUsigGqeCJNJ5gFiGjonuNCKTMGFBbWLg9Ypi8OocVsicoK/wjxch69aZM
         JzGD85P4PQffrpTLkdcx1ALvj6B3pAEpOlb3h8Egrhpx0cMbzCZHDiVba/a72T5zqj+8
         YWSmMv6nqb9OJCyUQVJz5BQB1Jvim3rM+TSN7UxFwkWNJiGR6fej8F5gYlLF979NL9Mo
         AWhZa93MkehHtAfkCt5BCwFjEXKb9eMxJyZ1jW2N64C6z9f5iCut4onisgdY0rtaM3s4
         uvXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3LLWx2Mt/Wttvwt9GaEez5k8N4aCwdps9r/YbMbbLTo=;
        fh=eg+kQUqi6ulhMh/SzxFxdtBfpfLP/83OVL6JxQrWVDs=;
        b=HrYD5Ss2enUPDeIza7A+ale1QyAItA+F2MDsvAmtqbJt9kc2mEj4SR8YKEV9eJAFJd
         siJDlZ/uzkI98hAIakwlMOU75Tt5auIxYwuZrIzitCP1hbLuFFSTZQM2sbqPT4tT57T9
         IkTsYEKMIS2fWR5DXM1R5BhsO7Ekc5PTEF1z1+x3R54qO1F31knOJBVgycmh5eea0QMn
         YWaDDpZdq9vq204OHLesIT7VHaP1ACHGZjwnoqqzOoSW+ZI1aElcHz88pP6xXNIu+Mhm
         VLIIP1Jz1X6el7wcXNUVe37MFmS1YE6rNhRzByDsrY5EPevsciuALRtJoQq5TC7i7JfA
         /lEw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779288729; x=1779893529; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3LLWx2Mt/Wttvwt9GaEez5k8N4aCwdps9r/YbMbbLTo=;
        b=aHoi6esxdmjNpbBYfoW+/ketXbqhBnPIR/tSjGkEFHR+gc1zyOIahX8yELt3pCueW/
         oyozGmQC0/QcwhK/XeyPNG7nJRkfHvfAsaGpzwvmGwHpgadWyrioygK8go1r5wMugK+n
         drefNGrKF0kAKNXZcnjIAjIpenwiaakGq1F4uCxj8K6blFkNKrTie9F+ZZ25Exn8412+
         Gx0cXjXrQVHZPed5UutbaJ0B1uEiXF+Z0MWZY/83HX/I1DpyuS1MDsVKb4EpGAnV0g/S
         AGVkDu3EFUoTQr47h9JAt2j+Ph+j06Hq3LwIU/YXsXM7DhqmaMGcm7pKCQ4AIMGJbI45
         XLoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779288729; x=1779893529;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3LLWx2Mt/Wttvwt9GaEez5k8N4aCwdps9r/YbMbbLTo=;
        b=BE94pIWKHf59oNrkW5vNL+S3JEJ8//LUnXjoJZiu0qHRRZs7omSsBQm3cDDxMKNiaC
         CA+L/PL4FE3lu4gjdFajMomr/1aT7tRn6eGfdWC/o6P2yQNQpDfBaWMgiXSj0Qo0P2y2
         nETUOEm0m0zeOarwzSuPSD2dU6CxR07FHMz7dxKPev//rhRRNJ6ovssssjpcrziObd9w
         ngeb6svt678iBe2ltV11qCpYsArs41cqyXO8ttXlnNn5OfBroXrgFoMMk/Vz/dmYiKRK
         57JRCYG1vdHub+3xPyzxxegCkwKtUKfg106aa5uL/V8KJGArLqeTp0+xbSSCLfZNZ3+G
         D/MA==
X-Forwarded-Encrypted: i=1; AFNElJ/VKmIiiK62YtiYcHUkbV6m0RFeTeiBWmoXG68s52zRzR4tVeBK5iIzPe5aF+OXVKyQefLnRNaI79JC@vger.kernel.org
X-Gm-Message-State: AOJu0YxXXn/sxRsq5hTI318KnAqtINz97GSC7KgEzAQboBx+bfLEsUiW
	bNwZ3vakg/BtqTPcpzOCbruLphnoMEoLfxRJMVCjDSiMfwpVhoq4e2PR+R/zHaXFwGdoNg9EmsM
	U9/D60Ns+DsLNQz6XhTI/acOtxtgdn5U=
X-Gm-Gg: Acq92OEbKLb8aPIqZIKIb6QhAVEF5PLAWflXMj7/teADj0JXKsbVY9ZiYEZuDnM/ljA
	5WDOlpV+vgm8dhu0kLx2h9HJd+IelKlcXldFScFjhxcaNmGAg3hMel1AaTI8Qy1KidCtx5J4phk
	3s+fNGTcQeCnaY6kHe7ThZHV6Idno3FywXads/KoLz7UZtk5cjzfEDPZDF78Zdbxc6ljfHlBZfL
	02cOEW3B3X6T/D/3XEcgi4phfwTCyBvoW5ZxFYZB0Q3BqnqCyV2DuwyD9R32dq6A29qrBo0T99K
	jyICDYT5MucFvEr5VvonBhd8U7U5fxCveeFrMWdl3r0f81QlHcN4YiLKwraA0f0AMj3V6kYhL1K
	xMVn5uAmAxIxaHAqY+kiO0AnfJcF2W2eWntbByxCYK/u+aVE71vZustOx8pqYwHUNLY/+vZ8zi9
	ZOcZM/XEHrR15tmw+gIbfM
X-Received: by 2002:a05:6102:5e86:b0:636:46ee:2f10 with SMTP id
 ada2fe7eead31-63a3d329d9emr13406826137.9.1779288729358; Wed, 20 May 2026
 07:52:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513201915.401320-1-FredTheDude@proton.me> <CAAk_H6EYShvace2Kgdk+v9Mv_zkwfQgoLtRLCuu02w+S8BshWA@mail.gmail.com>
In-Reply-To: <CAAk_H6EYShvace2Kgdk+v9Mv_zkwfQgoLtRLCuu02w+S8BshWA@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 20 May 2026 09:51:58 -0500
X-Gm-Features: AVHnY4J1u4zrCHhK4ZFNmhNSNFqLKWGPybw3NaceCwD7YGT5-xk1MpIsQJorYkU
Message-ID: <CAH2r5mucVfaH7D24GSyHVSqvkZcvjeOabw8LGOyhZkYSDrvm2g@mail.gmail.com>
Subject: Re: [PATCH] smb: client: change allocation requirements in
 DUP_CTX_STR macro
To: Fredric Cover <fredric.cover.lkernel@gmail.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending additional testing and review

On Tue, May 19, 2026 at 8:53=E2=80=AFPM Fredric Cover
<fredric.cover.lkernel@gmail.com> wrote:
>
> Hi Steve,
>
> Following up on this patch. This logic should remain sound and still
> merge properly.
> Let me know if you need any modifications.
>
> Thanks,
> Fredric Cover
>
> On Wed, May 13, 2026 at 1:20=E2=80=AFPM Fredric Cover
> <fredric.cover.lkernel@gmail.com> wrote:
> >
> > From: Fredric Cover <fredric.cover.lkernel@gmail.com>
> >
> > Currently, the macro DUP_CTX_STR allocates new_ctx->field using
> > GFP_ATOMIC. DUP_CTX_STR is only used in smb3_fs_context_dup(), which
> > is never called in an atomic context. Using GFP_ATOMIC puts unnecessary
> > pressure on emergency memory pools.
> >
> > Change GFP_ATOMIC to GFP_KERNEL.
> >
> > Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
> > ---
> >  fs/smb/client/fs_context.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> > index b9544eb03..a3ccc06c0 100644
> > --- a/fs/smb/client/fs_context.c
> > +++ b/fs/smb/client/fs_context.c
> > @@ -420,7 +420,7 @@ static int parse_symlink_flavor(struct fs_context *=
fc, char *value,
> >  #define DUP_CTX_STR(field)                                            =
 \
> >  do {                                                                  =
 \
> >         if (ctx->field) {                                              =
 \
> > -               new_ctx->field =3D kstrdup(ctx->field, GFP_ATOMIC);    =
   \
> > +               new_ctx->field =3D kstrdup(ctx->field, GFP_KERNEL);    =
   \
> >                 if (new_ctx->field =3D=3D NULL) {                      =
     \
> >                         smb3_cleanup_fs_context_contents(new_ctx);     =
 \
> >                         return -ENOMEM;                                =
 \
> > --
> > 2.53.0
> >
>


--=20
Thanks,

Steve
