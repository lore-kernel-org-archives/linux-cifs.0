Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9783DD86A
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 10:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786098870; cv=pass; b=V0o10EjbMLDVKQcptDSXbsjj13ockvpLRarbq2axrnP0wY0vRfQSAcjpA5CCq1nUcKOzvs+yewxtV3nI5QLfm2Q6GYw6FBl9lSI8zsD2r7m8f2TpWR42yaQOTEdTRIKjR4ja77q8t3JKtuvUFtx9yduUOy82KBoKYpYXWEo1+/A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786098870; c=relaxed/simple;
	bh=SEbxsgdPwEvcgL8SWXv9+EyXjEcd6tDhPuB9aTezW30=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EU66eipglxxe8jN30vxlbF1iLgxcxvtcegpKekJOdFXXfzAGFn7CCiIKg0O5SMEloA4I27n2aIf3Xl7HPxYz4+8pgcDUMngiWNp9UwIOH3+RT+bgvyQcAU/F0MI3SyDPYR/vQskVz/6/vzgE0LPwJuWmsd9UfhSqupP8R7vVNCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MKiWY85Y; arc=pass smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MKiWY85Y"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-667923d86a7so3555099d50.0
        for <linux-cifs@vger.kernel.org>; Fri, 07 Aug 2026 03:34:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786098868; cv=none;
        d=google.com; s=arc-20260327;
        b=Kc0aVB2jNHz6PrPBahuhqhw/XWl+L1rlVYrkxWMVudiao2x7V2pJZqvlYqs9gB7UIy
         G0onfNOXbYjnjzkRwq+BVJBrb+Q01dQVi0yy9ASuBa0LhW00peQaoFim6RdtDbwAhcCu
         ys6TUm/njorXLjWA+EUY/q49HoB3ZzVE2PVV1IMLsnf+sdTnweeyqS7SwM+UU7EBm5Tm
         eWyuy6HOrFCrhhSFelNhsmzN4zx3Pwzh3Za4/WiKZPoYI0iG1W9eeOgv2MHRAU9OpuAN
         FVRKly111C0b21LRwn5uCWBSH1YqPbdIhUIIblScJBE5/nxKAwsPpVcHxQV2c5AIesC6
         CPkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=aJUuRBFMP1U1bN6OLtYTzuaSfpRMAw9QaGmCwiEYFrs=;
        fh=tjl57AXXZXYgRratl8vHJGsmlSXIj9ajxqsfnFaXyZU=;
        b=BLTihkldF/il7k6WqY2HMOncgjo2f6AB0aF5u4dSUk7Tzox5pcAn1kWBOwWjxZ7tdg
         /lws85sr/nQsXZOvpF4FZZc/ITLFIfzh7ntaSkl3A4EdW3uFLNejqji4ej74yUGaYRm8
         Xxl2673aAnQ+eJY74a30MYbzHSFf/E54JUSDrZlxdKNccxNdmruAAB7aTD7tSyi5znkf
         D9Dk3Mlo7MVv7M3XnapzgBBI/kGPapucD3+mNyxRL7kLmy1cTbWsBTWwRE3sh0sWoSGs
         iTVegW7KH9Cw2nY8BBhO5R1E/MuLnb5bVtFIdaahEp3vaTlx+iijVG8v2kD5L3Uyfm59
         9AEw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786098868; x=1786703668; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aJUuRBFMP1U1bN6OLtYTzuaSfpRMAw9QaGmCwiEYFrs=;
        b=MKiWY85YYkGD67AYpL4KI2wQITfT8k27xQOM2FWSBE/nataxsV5k/P1EO5h885CRf3
         3Ur6rapQYl9YGYL9J1LxFa45pgWtc54Zwwdj+tVBHbnhrGA3ZSWhvt0ZNk0sTapzFdWw
         orWRzoLsLH07H5SSQ7DRok2i/qKht9/jv0vLGucucLgdsg+jPELeV0i9MeYzYSlaYwPr
         npxgvt3sx1eP+PQ4KTOg6gbSkynZzXN5iBr9oTvLNUtE1khre2Dnqpt90JooG1qNDpy/
         gmcPekNIRN2UeNhFZGqtBZ9j+Js1EiNPRmcQmH5Lr2PDSDF9ODZVdkNaGpJRzQzCfVV4
         9GwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786098868; x=1786703668;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aJUuRBFMP1U1bN6OLtYTzuaSfpRMAw9QaGmCwiEYFrs=;
        b=VklRrwiYKmBWizCbmVe5aaKmocSfOegIk/8jGkpLMIaC4+XSdn9+1Q6pAFcBfujjAe
         sC0n/eoysOs4PqFlCD7k6s/94IKFkRsuk21zILdDKqWiRn6uX/tAILET5JRrTsuorMsz
         hWuwpsvXybjK+kFxAjdEUF+wYthJRaeMy1jTsZKw6gtI+KTpd8pncgGSDxs5E0pyCfOx
         khqL00u+zRqhrsynYGMxiRMTC4ecIQ9bVO6kuvnpEHkInB84wZQB5QmN/P41IWh+I7Ty
         vsktD3OlqTvtU+kGIGcIGlB0BC3YNUmhkpGzgkVrKsuNNl6Lyz9IqFHqkNSROPnOJGU/
         V9RA==
X-Forwarded-Encrypted: i=1; AHgh+RrhCWE+NZGgVGzGWLrz4JQyCaWYLEl1nD9iM8zdW5vWMNpyiuErexWB9GoIANon8wTWNiLrJDZZ7XOu@vger.kernel.org
X-Gm-Message-State: AOJu0YxEJ7sXMSyXChF0I3EQQ3V9UeYg4g9UvVki9QjYJPssxghsU9yl
	hWojEWizE69El1oLaXRcFl4I0SEVU/RG8OQGPlVfbjmdg/x/SobdG/3xn7c25F4jsYwAJUwHFwL
	BWOQVGkImiFViOJvmLxZSidkWARKdYf3xcGS4HnM=
X-Gm-Gg: AR+sD12+rgu4l/osarwdZzPE8niI1zyjH5cJ9uMvg4ycpdqs2rKbj2rZUYfMSGvjRGT
	s5Mln48akh4wXb//AtHCh1qLXOSYUgQdiE8BFe55GFFoJVly0flIjVES6CA6GxBrHggcyG5Ag2G
	I+cH7ex2XtIQ48Y3xjnXPmCX5JvUPLdxnh73Q0LIoOa1aOjP4khmuU/qtkP4rYEo0fOiEUmMfFb
	bxLIolNyc/oOAwGha6WjZLqByPP8pSOviasFU45h041BHhHTpAlCgBtv+qLwiyD66ApQ2txdf/k
	QX4DZlDaCzEloWAPyGlpSANm52LQ73LE7C1/wq/sGra8DMtS77j0fSPvhpfWd5s78PKIh+wdhm3
	5sBr16+xRPhd0ceZJbvQ=
X-Received: by 2002:a05:690e:80d:10b0:668:4026:5484 with SMTP id
 956f58d0204a3-66abaf1e382mr4956834d50.20.1786098868098; Fri, 07 Aug 2026
 03:34:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGBKPgMzL+67L=wrKoCoOq-OQWW1enRLYUtUTHwcPSZ1vt0T8w@mail.gmail.com>
In-Reply-To: <CAGBKPgMzL+67L=wrKoCoOq-OQWW1enRLYUtUTHwcPSZ1vt0T8w@mail.gmail.com>
From: vova tokarev <vladimirelitokarev@gmail.com>
Date: Fri, 7 Aug 2026 13:34:15 +0300
X-Gm-Features: AUfX_myKSNbBmdj2Iee4ZRM5cn7CkNWHmPjnPJ86EFuGlskFjNIaNzKJZefEqbE
Message-ID: <CAGBKPgOX-cc8FkeUfBZvUFEABH6dMmKj28jv1w+xatn4+dvYQg@mail.gmail.com>
Subject: Fwd: ksmbd NTLM challenge blob heap buffer overflow (pre-auth)
To: linkinjeon@kernel.org, stfrench@microsoft.com
Cc: security@kernel.org, linux-cifs@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000009154260658728c02"

--0000000000009154260658728c02
Content-Type: multipart/alternative; boundary="0000000000009154240658728c00"

--0000000000009154240658728c00
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

It's been almost two months since I reported this, and I haven't heard
back. Reaching out to you directly as the ksmbd maintainers.

The bug: ksmbd_build_ntlmssp_challenge_blob() in fs/smb/server/auth.c
copies the netbios name (UTF-16LE) into TargetName + 4 AV_PAIR entries
with no check against the 448-byte MAX_CIFS_SMALL_BUFFER_SIZE response
buffer. A netbios name > ~47 chars overflows into adjacent kmalloc-512
objects (up to ~1620 bytes). Triggered pre-auth by any SMB2 client
sending raw NTLMSSP_NEGOTIATE (no SPNEGO).

ksmbd accepts names up to 255 bytes via netlink with no enforcement of
the 15-char NetBIOS limit.

Confirmed with KASAN: slab-out-of-bounds in
ksmbd_build_ntlmssp_challenge_blob. Full PoC and KASAN output in my
original report.

Thanks,
Vladimir

---------- Forwarded message ---------
From: vova tokarev <vladimirelitokarev@gmail.com>
Date: Fri, Jul 3, 2026 at 6:01=E2=80=AFPM
Subject: ksmbd NTLM challenge blob heap buffer overflow (pre-auth)
To: <security@kernel.org>


 Hi,

ksmbd_build_ntlmssp_challenge_blob() in fs/smb/server/auth.c writes the
NTLM challenge blob into a 448-byte SESSION_SETUP response buffer without
checking the size. With a netbios name longer than ~47 characters, the blob
overflows up to ~1620 bytes into adjacent kmalloc-512 objects.

The trigger is a pre-auth SMB2 SESSION_SETUP with NTLM Negotiate. (this
works with No credentials) KASAN confirms slab-out-of-bounds writes;
corrupted adjacent data
causes kernel crashes at netbios-name-derived addresses.

Affected: Linux 5.15+. Confirmed on 7.1.0 (aarch64) with KASAN.

Attached ZIP: report, userspace PoC (poc_ksmbd_ntlm_oob.c), KASAN output.

Suggested fix: reject blob_len that exceeds available response buffer space=
.

Thank you,
Vladimir Tokarev

--0000000000009154240658728c00
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<br><br>It&#39;s been almost two months since I reporte=
d this, and I haven&#39;t heard<br>back. Reaching out to you directly as th=
e ksmbd maintainers.<br><br>The bug: ksmbd_build_ntlmssp_challenge_blob() i=
n fs/smb/server/auth.c<br>copies the netbios name (UTF-16LE) into TargetNam=
e + 4 AV_PAIR entries<br>with no check against the 448-byte MAX_CIFS_SMALL_=
BUFFER_SIZE response<br>buffer. A netbios name &gt; ~47 chars overflows int=
o adjacent kmalloc-512<br>objects (up to ~1620 bytes). Triggered pre-auth b=
y any SMB2 client<br>sending raw NTLMSSP_NEGOTIATE (no SPNEGO).<br><br>ksmb=
d accepts names up to 255 bytes via netlink with no enforcement of<br>the 1=
5-char NetBIOS limit.<br><br>Confirmed with KASAN: slab-out-of-bounds in<br=
>ksmbd_build_ntlmssp_challenge_blob. Full PoC and KASAN output in my<br>ori=
ginal report.<br><br>Thanks,<br>Vladimir<br><br><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">---------- Forw=
arded message ---------<br>From: <strong class=3D"gmail_sendername" dir=3D"=
auto">vova tokarev</strong> <span dir=3D"auto">&lt;<a href=3D"mailto:vladim=
irelitokarev@gmail.com">vladimirelitokarev@gmail.com</a>&gt;</span><br>Date=
: Fri, Jul 3, 2026 at 6:01=E2=80=AFPM<br>Subject: ksmbd NTLM challenge blob=
 heap buffer overflow (pre-auth)<br>To:  &lt;<a href=3D"mailto:security@ker=
nel.org">security@kernel.org</a>&gt;<br></div><br><br><div dir=3D"ltr">=C2=
=A0Hi,<br><br>ksmbd_build_ntlmssp_challenge_blob() in fs/smb/server/auth.c =
writes the<br>NTLM challenge blob into a 448-byte SESSION_SETUP response bu=
ffer without<br>checking the size. With a netbios name longer than ~47 char=
acters, the blob<br>overflows up to ~1620 bytes into adjacent kmalloc-512 o=
bjects.<br><br>The trigger is a pre-auth SMB2 SESSION_SETUP with NTLM Negot=
iate. (this works with No credentials) KASAN confirms slab-out-of-bounds wr=
ites; corrupted adjacent data<br>causes kernel crashes at netbios-name-deri=
ved addresses.<br><br>Affected: Linux 5.15+. Confirmed on 7.1.0 (aarch64) w=
ith KASAN.<br><br>Attached ZIP: report, userspace PoC (poc_ksmbd_ntlm_oob.c=
), KASAN output.<br><br>Suggested fix: reject blob_len that exceeds availab=
le response buffer space.<br><br>Thank you,<br>Vladimir Tokarev</div>
</div></div>

--0000000000009154240658728c00--
--0000000000009154260658728c02
Content-Type: application/zip; name="ksmbd_ntlm_oob_submission.zip"
Content-Disposition: attachment; filename="ksmbd_ntlm_oob_submission.zip"
Content-Transfer-Encoding: base64
Content-ID: <f_mr52997o0>
X-Attachment-Id: f_mr52997o0

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
AAADAAMADgEAAFAcAAAAAA==
--0000000000009154260658728c02--
