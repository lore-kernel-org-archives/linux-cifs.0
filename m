Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795117027;
	b=My737T5TfHOdlZOgOEndSglfjQYa+Hy5g9SsW54FxykLbosMQUG47jkTruLH5UXj5Ca5
	 ZCgp33rlzuXeBwSkqs6VDaxnBbWbLIYAVz5dyAuK+ZKJnLGtqCQJmEPWSXTLlAbzR9EPZ
	 uqexcC1M4yX9oBsC+RpjdxYZ2uqq2Wg6qERJjD82R7xHSfknrBbOusvtkzIi6iBzrHB6+
	 cJLLdU2tvAjb5oRyNP8rvuGqeV5bUSLg++YeRZIKjGf2LuwGmpIIxDdvLBie+x/KUo7xF
	 3iOLV+7sSQppi1GqssZoH21zdi+PFtUHlmCJrKlo29drP3iUqXExmJNmPtcGt5NqvUw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795117027;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=vs2p+NKw9cBxSHvLMTQ1TCNiiuqtzY0tMFYF/M3imDY=;
	b=N6CbQlboHdjC0vCDEWNM8MUlrK1kJm4Ca8nMVQelF9RTY0+Y8XMCNWTW1jbXIYBtSsJF
	 cklwTFaztjkUWBsM3jyTAHRua4InaLX1DHdwaEDe5N7vAPJGZSXR30bAS+cRLifGKnvbJ
	 FSwPdGudesuMCB5bLkBILLr7P8aR/SjijnbYBqdXok2Ca56bst6lIP8zgCOoBWlGKHXNA
	 /4PNm4M2qyGsjWI5T0eoVwoA+GQkKwKxh4kv4zGYWnIEETjN52B6CL9QPFnWW3gSpr4uW
	 x23VHYmtJXZbGygyc1ruy8TFQPk7TDJYU/j9gYmOAbWtY6toUQNvOOwpaKDz9ekoVBQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J2P1rliW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4320B60A2600
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 19:37:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4320B60A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J2P1rliW
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b88bc47e23so126349a12.2
        for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 11:37:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795117026; cv=none;
        d=google.com; s=arc-20260327;
        b=WzTulVFjcqpg45gZmMGDhJc0e6dWokNyVjlvrlz5j6pl+Z07WbioYS1L1KK7+OyeKW
         WAFSVFOw8UhGF2CcZaMxyRiRrA83c+MdKIB8JXdOcvB7dLFi4YqSpYZDyp1lHR64F41b
         vIFszVe9RZYHh6+TLdVR4HIZHq1ABN/7mj3sjI9fW0ylzZ+wyPzg9RATuPFNuyBidv+b
         Bys0JLC8dN2n2gYlCSyjoq/8hYEYx7nczgFnlrZbGZxYT2yeD+LN8YeHHtY6NAfnZ+8c
         D2DfmVd2u/NZkqOWF4fpplohujKMDzgF4kYOYt5OhP80caJ1KJVcz2U5ASwvBhq+HAdt
         0Zyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vs2p+NKw9cBxSHvLMTQ1TCNiiuqtzY0tMFYF/M3imDY=;
        fh=9HLQS8KbK97ckwGrVjlqMObhOK+KyJkMjUcto3wBbBg=;
        b=VuyIbCbLUUsiogKglioklYnFpEZuJRGFAHhQkgDaHAqtTfFty8/3etk2315ODGgqOZ
         KU7a52amkNHE4xfe093UU7tM+n1yDKy9DNMFV6Zzg9GDcI2cqywpMLrFKBCjkxQ/BSmZ
         QndpELrZpqULQOxeyNG6zTGV7/4WFXiaA0xrIPtMHM3hEWyX1JyWXjmcmMRvo/93I3Tz
         lkAnz59R6sXDNLJuekUBZ3XObCp+oUSWuXOWd0sOssgsyUYn5GDtxhmS1slDkrGdABRi
         PO0uwGVEyCPfPqlIv9E1LuPSjlS3Nyn3lIDaQoAXZ7SdZVsfWXDWy6e+dY+fDWk2vc6z
         jthQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795117026; x=1795721826; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vs2p+NKw9cBxSHvLMTQ1TCNiiuqtzY0tMFYF/M3imDY=;
        b=J2P1rliWlWFeXXFXmXF+ohrZY4u8BY5guzLNIZE4zyZEFvv9XjVp6qSFQEuKBYS4gw
         tRHKICBYDX7EHD7dOjit9dYAF5zAZQoiMjaWziJZS+p8scKNzprADKCa9phj/1Tq5rLq
         AdLh58YB1IlCzIIphjpmi7F6IODiO1Lb028EXgDFuQRtiOTbHyBQqFgQJ2a9rTkXFmIk
         rIDw5jsAro28ug3nEE4pf9UY06m6dKeDy1GLSXALfX/FhKkPB24uxc9fzqALY5d5/0zY
         o3ELAOqepaHkRc8vyIjpo6spF9jSLJ5v2/RpEGLV7zg0pNxm6ebUphbxyHHPfV1Pvs4Y
         7KvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795117026; x=1795721826;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vs2p+NKw9cBxSHvLMTQ1TCNiiuqtzY0tMFYF/M3imDY=;
        b=ySXlMAl0EyjMdXGcTcmjR67vcJBq1jHwcycwcWWgXPwqK4xoybvYxXVp1sEigTKrZI
         Q6s2zr998eAiSvOfPek7JwhknyEfDi+xLRRnHM47oOE7TWMTOqsVfwP2dl2kqtQhgejr
         sZsMtmmd+Fq7rN4dRxk5imjEchpHLlur60ktzZ2Su0KAmWkZF1koZdPZsoJT/CQvJf0h
         C15r5+nRnI6jHt4XnIUmLpENptySgaTqqO8qaGNn8pzP4qeq9scQJb6IWI+OtWeQVP+H
         FlAZXKM9VpQC1YS4ad35ZxtwUxPHEKBmf+OthhpnDRLHmlVXaeCqH2EjMicEOM7slKJD
         13VQ==
X-Forwarded-Encrypted: i=1; AL+hErES4ay9gd7W3pEjL3nLugONETs0qWkUwnQFw+y8cK5cVbRgKuQIdb+A/BRu9w9bfue4/qwEfN/aTxdk@vger.kernel.org
X-Gm-Message-State: APuU4Z//YjCljKgUFJ6YERpWRMGiQuszScl4YGIBX4WjsVM9IHfk2og8
	GyQvRXai8CUdP8r84NrPz9zH7mdn4/TF403Ym6FfR9Un/Om12UkSMj884ey3FpgNbkDR4wuxkkN
	kiTMo9qlziYz78NyVbHOMWIGaoou0F4I=
X-Gm-Gg: AYBFou1wlDnE/Iu476fHHfCbLvTXJp6Kv+BCzCqLq8ZK868lKMIS/gLCcZ3LwXHhone
	KZKwHL/YsV+fG/weIhFEAAdk3Er88ZU8+jwnEcyG+jOvjqcrANSfrCoa9CT141RKp43E80qrAhv
	TqTQHlPg6C2uNOw0Eq6zNRDStErQ7pnZuqlcZTLzsQOwggvnikn0qR49ZplI6tXy4ut/IcwU8/j
	IfVU+YmIK4dU6CP2ji0ljYiAXUKFLBoIz5w0kvpx6rb6S+Otjm8kXT+5Ddo039NdUxvfxtC8qfJ
	3LalSVvhD8BpIYFjEsV6C29ymmXslPUE5dFgSglEHqsOCTRDia+PhtTgUcFC/x8oDN3r+HUHeHS
	SEbaysGv10giaCRSnIy3r8+O/GGUupJTJ79I7qur2Y/pBlIl0tB8aigindk7evMl7pL4IWTA=
X-Received: by 2002:a05:6402:897:b0:6b8:8328:8e66 with SMTP id
 4fb4d7f45d1cf-6ba37d62a2dmr239724a12.7.1795117025446; Thu, 19 Nov 2026
 11:37:05 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115180343.576773-1-koray.fra@gmail.com> <20261115180343.576773-3-koray.fra@gmail.com>
In-Reply-To: <20261115180343.576773-3-koray.fra@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 19 Nov 2026 20:36:52 +0100
X-Gm-Features: AclHuK-9kUyGBTzq0h8pZyp8mMZSXIXsu9pOi4Bu2Y5vLjqBJOsUk2EoN70jtkI
Message-ID: <CAOQ4uxiRFUqgUMvngvXc1nA7e_HMKSs+aXWVQmAEpcR7yQiQLw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 02/10] vfs: add fileattr_has_fsx_mask()
To: koraynilay <koray.fra@gmail.com>
Cc: David Sterba <dsterba@suse.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Paulo Alcantara <pc@manguebit.org>, Chris Mason <mason@kernel.org>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Sean Smith <defendthedisabled@gmail.com>, Andrey Albershteyn <aalbersh@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, exfat@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-api@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 15, 2026 at 7:04=E2=80=AFPM koraynilay <koray.fra@gmail.com> wr=
ote:
>
> Add fileattr_has_fsx_mask() as a helper to let filesystems check for
> unsupported xflags while allowing supported ones. Can be used in the
> same way as fileattr_has_fsx().
>
> Also make fileattr_has_fsx() a wrapper around fileattr_has_fsx_mask().
>
> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
> Signed-off-by: koraynilay <koray.fra@gmail.com>
> ---
>  include/linux/fileattr.h | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/fileattr.h b/include/linux/fileattr.h
> index 42b92ccdc583..ba7ed3b387d8 100644
> --- a/include/linux/fileattr.h
> +++ b/include/linux/fileattr.h
> @@ -65,6 +65,23 @@ int copy_fsxattr_to_user(const struct file_kattr *fa, =
struct fsxattr __user *ufa
>  void fileattr_fill_xflags(struct file_kattr *fa, u32 xflags);
>  void fileattr_fill_flags(struct file_kattr *fa, u32 flags);
>
> +/**
> + * fileattr_has_fsx_mask - check for extended flags/attributes
> + * @fa:                                fileattr pointer
> + * @allowed_xflags_mask:       additional xflags permitted
> + *
> + * Return: true if any attributes are present that are not represented i=
n
> + * ->flags or @allowed_xflags_mask.
> + */
> +static inline bool fileattr_has_fsx_mask(const struct file_kattr *fa,
> +                                        u32 allowed_xflags_mask)
> +{
> +       return fa->fsx_valid &&
> +               ((fa->fsx_xflags & ~(FS_XFLAG_COMMON | allowed_xflags_mas=
k)) ||
> +                fa->fsx_extsize !=3D 0 || fa->fsx_projid !=3D 0 ||
> +                fa->fsx_cowextsize !=3D 0);
> +}
> +

Every patch in your series did:

       if (fileattr_has_fsx_mask(fa, EXFAT_SUPPORTED_XFLAGS))
               return -EOPNOTSUPP;

       if (fa->fsx_xflags_mask & ~EXFAT_SUPPORTED_XFLAGS)
               return -EOPNOTSUPP;

It looks like this helper is not as helpful as it could have been
and you have raised this question yourself in the cover letter.

Effectively every filesystem that supports fileattr_set() already has
a defined SUPPORTED mask, so I think it's better to do the negated
something like:

static inline bool fileattr_supported_fsx_mask(const struct file_kattr *fa,
                                               u32 supported)
{
        if (!fa->fsx_valid)
                return true;
        if ((fa->fsx_xflags | fa->fsx_xflags_mask) & ~supported)
                return false;
        if (fa->fsx_extsize &&
            !(supported & (FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT)))
                return false;
        if (fa->fsx_cowextsize && !(supported & FS_XFLAG_COWEXTSIZE))
                return false;
        if (fa->fsx_projid && !(supported & FS_XFLAG_PROJID))
                return false;
        return true;
}


...

       if (!fileattr_supported_fsx_mask(fa, EXFAT_SUPPORTED_XFLAGS))
               return -EOPNOTSUPP;


>  /**
>   * fileattr_has_fsx - check for extended flags/attributes
>   * @fa:                fileattr pointer
> @@ -74,9 +91,7 @@ void fileattr_fill_flags(struct file_kattr *fa, u32 fla=
gs);
>   */
>  static inline bool fileattr_has_fsx(const struct file_kattr *fa)
>  {
> -       return fa->fsx_valid &&
> -               ((fa->fsx_xflags & ~FS_XFLAG_COMMON) || fa->fsx_extsize !=
=3D 0 ||
> -                fa->fsx_projid !=3D 0 || fa->fsx_cowextsize !=3D 0);
> +       return fileattr_has_fsx_mask(fa, 0);

            return !fileattr_supported_fsx_mask(fa, FS_XFLAG_COMMON);

I hope I got this right.

Thanks,
Amir.
