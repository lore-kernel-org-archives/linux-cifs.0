Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C602562E
	for <linux-cifs@vger.kernel.org>; Thu, 15 Aug 2024 03:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723691710; cv=none; b=lX3/IbKVLBl++x1v5qk9VXUuFwQFseLiz+2E9OM7WHpFPZZAp1nMvHjk+UI6e8ugu8VU364cHJFIAy0JNd7TVQsujzFX63EBdHDP0LqSJ1WEFg3U86J++vz4ZQU/qEIJR28mCW/8tnY0/VUqKkxqmPNxFBusHSGheLKi3a8SGMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723691710; c=relaxed/simple;
	bh=ys6bGEwcV73+iONIiSq84oJoQshLzjOxQP3bCfPg200=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nXioSRySzAvO29AEici8RnQ8PjdKZKR3pn+8ppk+TCCye3q6+o6gsDwYSWzRW1gatOLR+5JYI6GNvwq22mc9pG011idLSoVxZGtFdnDlPyQgGrj1I+DI2HQz3NW3Zz43J3hQMrOWi3kmBjyKbHHaZZzdlLV8g07y+JMaRZsu1+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NrfiFiQe; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NrfiFiQe"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-53310adb4c3so49029e87.3
        for <linux-cifs@vger.kernel.org>; Wed, 14 Aug 2024 20:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723691707; x=1724296507; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WF6dnT0/CXKn8a//x4i5bIbLOCauBvKXP8LVxT19k3o=;
        b=NrfiFiQe4UN32zg0wfguvqYWMn3pLMp0FFQlT1epJSRfQ8j4Ix6dRFRTXlRymsxAHP
         AFLZPhk3z7oRiPQ59rxHI6sfOwKuLwgoQSDssHFnW+na+VmjvU68baqDG4r5ygHGinDx
         i14YNsMTjt9be87O7/LGWoKcjt6KfSoMfoA9iR3+p7xrlmwkJAoLad18bIiBjrQk9CtX
         cha3toCRhW9n8JYEDPvq3la9gnMRyhP7wxaL5RbU2WFzj/gIF9HqV2Em3ySVJNA6ZsF1
         OrHVamubJ3XRzdoVK2XNIDdYWOAHn9NSvgfjjLIDoKKkm/Nsd+IuDkfVgxcPX3e+JEr6
         AsVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723691707; x=1724296507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WF6dnT0/CXKn8a//x4i5bIbLOCauBvKXP8LVxT19k3o=;
        b=kzTF58mR6Fe6DxK83kDLEeXuK85rak8o8YVFAHUoWaXdUB2taFnaMJ0/TkVT2lkN5p
         VEgQHQ3zT2ZCCS9c8ffVHvN7laHVnFk6tme1ClMxVXaXx5v1B9UspSoFZoPA0dWqpjkc
         aTiYEvIXTTCUPbFQACFvufBF+ZSmivdXA6azlHAw65rfo3sFH7HpkdyDnFpzjKG8MOFu
         EDFn6MlqHeUgvtoWamXtF3wmyMRVaDD9yYeutB3QqV37uEEOadCi3p34AOCGxr6VCBxn
         diMSORYi3Dib8ndCW5Ujqg0uJBaMWCL/desIvM9NlMDKhr+iaOMPTp3KnmTmYivw6pHf
         MajA==
X-Gm-Message-State: AOJu0YyavUvo+XWlV66VGgCxEnE3cK9LDnQOIyhl4LlYCBBDthkusPaK
	G/Er2AqJDtduDn3zTrGe+PyHZkF+P5m6C6njlWqiFj/ougrjBnRgxu3SrKBVElSwq8aIFO9Uw/+
	Gr8g55tKwLVTf1Tq2zaWBZMZpTZ4=
X-Google-Smtp-Source: AGHT+IG6Zqq/TmASvMhVmKrTChvhvlbZVni0xITo1I1eKxOPbNlCO/IGAKAMWlGVYyzSo1M5gaDcSBV1VEedAGFzBHM=
X-Received: by 2002:a05:6512:2206:b0:52e:d0f8:2d30 with SMTP id
 2adb3069b0e04-532edbcade8mr3298682e87.59.1723691706547; Wed, 14 Aug 2024
 20:15:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240814235635.7998-1-linkinjeon@kernel.org>
In-Reply-To: <20240814235635.7998-1-linkinjeon@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 14 Aug 2024 22:14:55 -0500
Message-ID: <CAH2r5mtN1VfmCgrkK=02B6M4wAj2sT5nHeNio1fFYn0EgN1-NQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Use unsafe_memcpy() for ntlm_negotiate
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, senozhatsky@chromium.org, tom@talpey.com, 
	atteh.mailbox@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This fixed the 'field spanning write' warnings for me.

merged into ksmbd-for-next



On Wed, Aug 14, 2024 at 6:56=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> rsp buffer is allocatged larger than spnego_blob from
> smb2_allocate_rsp_buf().
>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/smb/server/smb2pdu.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 2df1354288e6..3f4c56a10a86 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -1370,7 +1370,8 @@ static int ntlm_negotiate(struct ksmbd_work *work,
>         }
>
>         sz =3D le16_to_cpu(rsp->SecurityBufferOffset);
> -       memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blo=
b_len);
> +       unsafe_memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spn=
ego_blob_len,
> +                       /* alloc is larger than blob, see smb2_allocate_r=
sp_buf() */);
>         rsp->SecurityBufferLength =3D cpu_to_le16(spnego_blob_len);
>
>  out:
> @@ -1453,7 +1454,9 @@ static int ntlm_authenticate(struct ksmbd_work *wor=
k,
>                         return -ENOMEM;
>
>                 sz =3D le16_to_cpu(rsp->SecurityBufferOffset);
> -               memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, sp=
nego_blob_len);
> +               unsafe_memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_b=
lob,
> +                               spnego_blob_len,
> +                               /* alloc is larger than blob, see smb2_al=
locate_rsp_buf() */);
>                 rsp->SecurityBufferLength =3D cpu_to_le16(spnego_blob_len=
);
>                 kfree(spnego_blob);
>         }
> --
> 2.25.1
>


--=20
Thanks,

Steve
