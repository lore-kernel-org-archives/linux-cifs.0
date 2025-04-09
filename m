Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94553165F1A
	for <linux-cifs@vger.kernel.org>; Wed,  9 Apr 2025 19:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744226867; cv=none; b=dEg28fKkTaF+sOCfM+F13KFtRtt+39LB7/LISzL36DyP7/9wbfaKW+ZNxegsAKucDPkegI+5Ymjd1PqcqLeaCQ1p6vBo9XBnM852Gy4Z8fS9nqdO2pnW85Y8sDeIWoPfj46Yi+U3GTTkA77pjOngsVuTMA+/mKJC620uR5FRoTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744226867; c=relaxed/simple;
	bh=RVYFSJm6ec3yNR4jAqsTyb411I6JCBfp3wFVWAlj61Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kZ8R3F+oqdCAMjTQUWiCLpnxpQ+2x+2Bu9MLJ3sU7sGisEmSBmkqghoR3arjboytZtNusN00kFE03dAIxmx2Z0Khgx09F+7iiVtycPf1rQKN1VAac6vzYIY1z1dXueLHgqNwFOplQXmEqu27lKG2WkbZ3FpikM9Non73OsEz3hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cTbSMHrs; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cTbSMHrs"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-54b0d638e86so78855e87.1
        for <linux-cifs@vger.kernel.org>; Wed, 09 Apr 2025 12:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744226864; x=1744831664; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rqOXbSz+chjBUsJzlV2D+fl4Nye9E3ICRuGgAj48tsM=;
        b=cTbSMHrsml1+UBRzlOYVCbOE3QaiC+X7GqbtO7K6mZVAUkROsxql7ysTk3oOL1LOyU
         uy2UUBVLM8HdDSzZnNt5RHTMxhJz5OxH0DxftIkJTQg5KLFPGumvMvpJV3SWIV60aO3x
         xd/HAnVS2IQBor7sjxZtqYuLQbMKiTKjyJvEhUVMeC/20jPdyDKy/vsCyAVrfq+AkS/x
         m6aoceHrz9HTO4qHIjMKICwsbis5Ir7HoobydzYwf27rxeeX5Rm2uGwu2X0OZzHT6eNr
         /fJootMWXcZ9rUzAy/HU0odCzRX2OziYdXtyZ/LHpyTYtOlYawXx5hv8qsmlmCiCw8sX
         tOZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744226864; x=1744831664;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rqOXbSz+chjBUsJzlV2D+fl4Nye9E3ICRuGgAj48tsM=;
        b=lLJ5/f9YdR1hC8ZeOklD23D7Utzn/TIybLmf0sU+SmPr/wExW7HpG0muYhcpVYZM0d
         7mYH7NIRntjk2FCWyFhzLQqvFmcKX3WKrQt2ESNdo1G11bZY0SbrcDq+h0RWrEEcMLLx
         Fm8aojF0tzSRDBt3FO/3gzgPRHNLSn+56vJmqqW5by4scSjAlRZmHHqg2/FVAVNgdIMz
         wXcUGHbi9o83gEHO2o5HUPyb0O2v53vEBEs6y6oWW9+xvDuwEfaqQYuD+jBPxeycuSGI
         N0h3SLgmB20mU1qyXIC9CBfwKCjTXmnJ6XTPnmuVssuJtCwlb4LYXFo7d+Ilu1OsvEqq
         ZM0Q==
X-Gm-Message-State: AOJu0YxdwKgrHLBrhqQz5aJQw521u4C2DA3Fd8kP5NDogJSK6hCimJ1W
	EzuvZA7KWywimfWIuphHlLReD/O1NvmbNly1ynsYT59BFd4nzmA1U4rnLwGHXxpVhpSK4JF+6lW
	ylNLjFHDFHwDb6t0u2bs2lDTjC4Y=
X-Gm-Gg: ASbGncsFa4H22E8DeSQdiDPuPq9MERHsjeZTGxQW6G6uECEnfB2x7v693165Xd7Edqz
	9XiHCPuSRpOXWkKgHAsOQ+cg3DkROlHGQo0rNnKm0icrQv/NfjOy0AJ7062hSYzkM+ZzA4maEL2
	F+EK3MWiS23U6oOl7ARpCnWPaHqjRlpoymcEb6WJAmZXgd8xWVGY07j64=
X-Google-Smtp-Source: AGHT+IEdHuYgl4mY44yHkZLnBZqlBgacec7v0r0Bzpx57bsRGiLBLV4XdjDv/vVdjRc3Ov8QjG4RX202VIjpxEZtjcw=
X-Received: by 2002:a05:6512:3ba6:b0:545:944:aae1 with SMTP id
 2adb3069b0e04-54caf58e5cbmr36939e87.12.1744226863447; Wed, 09 Apr 2025
 12:27:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5msKV9ChZr6-2tQ3ZLSmS9D5s1SiOWGfbhCnVPMEKoDf_Q@mail.gmail.com>
 <20250409192208.eihyv566ralpl4zg@pali>
In-Reply-To: <20250409192208.eihyv566ralpl4zg@pali>
From: Steve French <smfrench@gmail.com>
Date: Wed, 9 Apr 2025 14:27:32 -0500
X-Gm-Features: ATxdqUFhU9QJj9-KxHjia7qzeMv_p-LjvEor8s0MLn_duFIBKK_PLqot3X0K60A
Message-ID: <CAH2r5mug12QDNinQtSZHM4phzoVADwvsrL-a6f0iHXeJCj+qdg@mail.gmail.com>
Subject: Re: [PATCH 03/25] cifs: Add support for SMB1 Session Setup NTLMSSP
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Are you aware of any servers which support NTLMSSP but not Unicode?

On Wed, Apr 9, 2025 at 2:22=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> wr=
ote:
>
> I have tested it against Windows Server 2022 with new -o nounicode
> option which turned off the Unicode support. Without this fix,
> the mount with -o nounicode option and NTLMSSP was failing.
>
> On Wednesday 09 April 2025 13:39:58 Steve French wrote:
> > Pali,
> > Have you been able to verify this (your patch, attached) to any
> > (presumably ancient?) server that actually wouldn't support Unicode
> > and would support NTLMSSP? or was this only emulated by turning off
> > Unicode (and if so which servers did you test it against?)
> >
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
> > From 1d789f0843075395945aa30528fb17d6c517d054 Mon Sep 17 00:00:00 2001
> > From: =3D?UTF-8?q?Pali=3D20Roh=3DC3=3DA1r?=3D <pali@kernel.org>
> > Date: Sun, 6 Oct 2024 19:24:29 +0200
> > Subject: [PATCH 03/25] cifs: Add support for SMB1 Session Setup NTLMSSP
> >  Request in non-UNICODE mode
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=3DUTF-8
> > Content-Transfer-Encoding: 8bit
> >
> > SMB1 Session Setup NTLMSSP Request in non-UNICODE mode is similar to
> > UNICODE mode, just strings are encoded in ASCII and not in UTF-16.
> >
> > With this change it is possible to setup SMB1 session with NTLM
> > authentication in non-UNICODE mode with Windows SMB server.
> >
> > Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> > ---
> >  fs/smb/client/sess.c | 20 ++++++++++----------
> >  1 file changed, 10 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> > index b3fa9ee26912..0f51d136cf23 100644
> > --- a/fs/smb/client/sess.c
> > +++ b/fs/smb/client/sess.c
> > @@ -1684,22 +1684,22 @@ _sess_auth_rawntlmssp_assemble_req(struct sess_=
data *sess_data)
> >       pSMB =3D (SESSION_SETUP_ANDX *)sess_data->iov[0].iov_base;
> >
> >       capabilities =3D cifs_ssetup_hdr(ses, server, pSMB);
> > -     if ((pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) =3D=3D 0) {
> > -             cifs_dbg(VFS, "NTLMSSP requires Unicode support\n");
> > -             return -ENOSYS;
> > -     }
> > -
> >       pSMB->req.hdr.Flags2 |=3D SMBFLG2_EXT_SEC;
> >       capabilities |=3D CAP_EXTENDED_SECURITY;
> >       pSMB->req.Capabilities |=3D cpu_to_le32(capabilities);
> >
> >       bcc_ptr =3D sess_data->iov[2].iov_base;
> > -     /* unicode strings must be word aligned */
> > -     if (!IS_ALIGNED(sess_data->iov[0].iov_len + sess_data->iov[1].iov=
_len, 2)) {
> > -             *bcc_ptr =3D 0;
> > -             bcc_ptr++;
> > +
> > +     if (pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) {
> > +             /* unicode strings must be word aligned */
> > +             if (!IS_ALIGNED(sess_data->iov[0].iov_len + sess_data->io=
v[1].iov_len, 2)) {
> > +                     *bcc_ptr =3D 0;
> > +                     bcc_ptr++;
> > +             }
> > +             unicode_oslm_strings(&bcc_ptr, sess_data->nls_cp);
> > +     } else {
> > +             ascii_oslm_strings(&bcc_ptr, sess_data->nls_cp);
> >       }
> > -     unicode_oslm_strings(&bcc_ptr, sess_data->nls_cp);
> >
> >       sess_data->iov[2].iov_len =3D (long) bcc_ptr -
> >                                       (long) sess_data->iov[2].iov_base=
;
> > --
> > 2.43.0
> >
>


--=20
Thanks,

Steve
