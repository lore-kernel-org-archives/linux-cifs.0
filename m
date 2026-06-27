Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0E52C0261
	for <linux-cifs@vger.kernel.org>; Sat, 27 Jun 2026 23:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782602061; cv=pass; b=DAI9ms1s+uXW/zNLk7zh0jabpKM0VhOeekRBgLhyLN+eSnEB6IID9xW1hOANgYDB7IlSpAAaoPGP7MCA4iABpaBsJvkTpmaoY+hRtWLojVw4LDsSLfCrnjmDvoG7Dv7SybXh3L/xRCtCCnfQb9SvJsdxh2dLziVafBLzI0fBQps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782602061; c=relaxed/simple;
	bh=DyQXK7ghhPO0dWZYqnO+7NiPbrCHLIYshEF/KzOftbQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rcgqnM6GLdlIKTBQSlJrVteSmH+Tb8PeMU1m4wBGeAxopb+biTC6n5olQn2fGRPw4Yhr0vEziMbQWnN63vNJLXIHjlt3n32ejTC/7PYWu3BsQB9v27O5yZQfDGhzTIWccG+WneKVR7NNLyDxJvGYotRz1immrc/qU75Y/1RUt1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jEoW8+kk; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jEoW8+kk"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8e423029db6so27255226d6.3
        for <linux-cifs@vger.kernel.org>; Sat, 27 Jun 2026 16:14:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782602059; cv=none;
        d=google.com; s=arc-20260327;
        b=aX1Z3EyCz/d0GruaVIEKtUfg89E6DXhiOM8agFshHZ9dzPHCAXD3Q86y0AZb7B9SnD
         NSs+rhZORIXr+kNKE7a3YlWHlWIXcvVrSJIskekBYV1lEmR46TTr+PqbfLsMMvJPpPhl
         7zWIeiUsh/TbJ1cGZafOPvikgfrj3rAw1fNZkUl3jQ789hBSfPv8ZAHlDLRM5qU/zGHp
         DmUFzg76Q1ut5z5mLyFqpRzUshS7ofxtvECT60yR5KuFS0NbyzdHYD0lzYDajXAzatK5
         +m8Kn9bx/0jmmXaqhGqKhU2WhC6ASRDC9PIxVzLf1vUxJYX83q6VCY1dUQcPwqDXgGkj
         rwqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TubvMIyZWMeOP0fVPGZuie8RU2bWkahq83KUFGXveNw=;
        fh=sIJ8y3kc62iRbYMKklqQxOiQ+CeWPTvN9mMheGo2uqs=;
        b=q3gM+rvSCSBl92k+bvtfht05pcYNthxDVIvfSQcqGMidEsmlPB+Gk4m1ol8zFUrljy
         kTSQ3rkeGJXbXdp8fD4PeHcEA1fCLSV4VmKcX8zHJ9b2j3TSaDknIY2Vi5Y+fZPodCsT
         SU7iNbtnbDnv8w3FM+OQwSPnK28OKoggkPbahqxQdMBJkXVbaP4pskYJt9ZN67l8iSVP
         KxdUwzvwUsY+sLjJ6s8N/HxxQ2DO9yqcmHeSs/7w+2DU0bhdU9KNMvWqMWYKnRoBgqbq
         UHmrruQeQ8rEb7J/IeSj6wCXLzNMdS+jm3NZSZnt+nXgdSZ39PfBiyXqcOCIoZ+RPuQ7
         HY/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782602059; x=1783206859; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TubvMIyZWMeOP0fVPGZuie8RU2bWkahq83KUFGXveNw=;
        b=jEoW8+kk8I4HDCUPpbj2ZlEoXDUDmb21FPoR082o57N90wfODtelu069S5eLr2d/E4
         TjoU3hBjgI9lkfxBzuknFUKsV2DlUa3EmlyQq/DlP1X0yZZc9WkXjU+dUQ/9KYYuzjLk
         3vGXOmaD1hChcMec/vxzRmhSH+K2akMcHt+C5oHsHUSWiW8vgyNQvW/TfvDeZ6XS4q7z
         y2YtBtTPX19w6vaqJEzkXrJcoOMKE8OyLEsPpmOetQAMpn0oexOivikA6I0lRW2kY3uI
         FpbRWuVgkgEKblvKKwFBHa5pr6gekoiZWZIG+UohZ/E3mH9jOUfWJeICPqrX+q4Wgfwx
         ptiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782602059; x=1783206859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TubvMIyZWMeOP0fVPGZuie8RU2bWkahq83KUFGXveNw=;
        b=jVrpVzqnGaRvPc498Jz6Q0XbJA4vWGnxBlwPqsDduGfIDPBmVyTQGyQh6h3rERfDpa
         LyShQkDuBJZfswqbeJTy0PImyTLjqvtrMXc1fZY4aGYcBfhcpnHuRPr/v7HLvxFQuBSB
         fIHzRJKVe9h/RzTFfkllofxfjc2ofTRibs6gtLWzHKXQnJrvog1svB976H8+Jjx4rmxv
         dq26EpFnbA2LUb0Wc7PnG8K4xIilMvoNzVU5Fuyq/MG07VGiouXPN788eq0MDStNZ9JP
         8cF+wnDY5z2RWTqpFHN5I9NQMd2efvBwrvfSsUQNQhXtg6zzoi8DWM4gTAiXvf6zNQHI
         WkaQ==
X-Forwarded-Encrypted: i=1; AHgh+Rox89se7zi8mv97Ae396Bc0i9PIJqJJ4iDTD1ADG9X8yBJlEP6BIunruVm/kMog+O+2C8VdITlcyvif@vger.kernel.org
X-Gm-Message-State: AOJu0YwwgQsTjt9ZMc8/2YY1sKNCp/FtQerrwaC3Bizs/S1hqkFSnwcA
	Jiis2oJa5yWdpou2V46u9VCFmtYhY2xL4O1DU1j5c4BCZW38SMRjWtMAjBnrHpJL8ZX9tgYbrVL
	UmjmsGd2kpXf0u8d6X75XVTF1D6uOzLI=
X-Gm-Gg: AfdE7cnwgXEFZ+nmoLUeS9iLQIZyPBZOFdhGeJO8khMWJP/ABtAlZ3YidH5tVgT/Hfj
	e/bbeji8mLkljzvzvLrghZl86EYXggm3GYMEFAE9OLsKDTlIOXrW3E2NgLk2uJvcSXWtlQelVVt
	Pb2HLyUeqU5UbCMuQ1TztkLaUtlDqrEXub80NK5MJkenNw/KWnTVQGmoOnwW5ER6vqICl2D/DKH
	xM5YL/nR5005bg3tDAz78fs6EfJo8JmoDjDjqoG6FFdLrNKpBLxgtljGqMMkd0DVAyNHcXqSv+3
	s4ZUzDKh4NnDbUwmlgllUHA9XMLgkx+SgftEhokCp+TQCcedisPeQxaAK4qE2rkoFbOKDlquPLf
	doKhEaEx7EPeSIZBldVo8TFdkaNJwukLXAYCs3hv0B+wh1ri4SK+Vd+3o5e43UZnShVZeep2yiy
	Mn0lO40EGg2wQpczk+Napj5Q==
X-Received: by 2002:ad4:576a:0:b0:8dd:69a7:d60 with SMTP id
 6a1803df08f44-8e6cfa748f1mr202153276d6.0.1782602059057; Sat, 27 Jun 2026
 16:14:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4a88b87d-c38d-4248-a3c3-59dd8c1f5095@freenet.de>
 <33ca19f8-6c6e-4738-bfab-25e70f77dcf3@samba.org> <077744e0-ffa3-4ab6-90cc-855fc7adbba3@samba.org>
In-Reply-To: <077744e0-ffa3-4ab6-90cc-855fc7adbba3@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Sat, 27 Jun 2026 18:14:07 -0500
X-Gm-Features: AVVi8Cf5x4mWmiq61QLEEEe2ufmicf-aKWRohDx3LAL0GEfskXWqpeb2fovwTKI
Message-ID: <CAH2r5mseoZJwfwyUUB43OBq5uEuxBVApHw_B9wizrQ50ncpnOQ@mail.gmail.com>
Subject: Re: BUG: SMB3.11 POSIX extensions: Absolute symlinks lose leading
 slash on creation
To: Ralph Boehme <slow@samba.org>, Paulo Alcantara <pc@manguebit.org>, =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Max-Ulrich Farber <m.u.farber@freenet.de>, linux-cifs@vger.kernel.org, 
	Jeremy Allison <jra@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Yes - I have verified that it is the client code (so copying Paulo and
Pali who did most of this code) that has the bug.   When the
FSCTL_SET_REPARSE_POINT is sent by the client, the leading '/' is
already stripped off.  This affects both reparse=3Dnfs (default)
and reparse=3Dwsl.    I would recommend mounting instead with
"mfsymlinks" (which is safer for most cases as well since the
symlinks are not processed by the server for the "mfsymlinks" case).

Paulo and Pali,
Any ideas about this bug with absolute pathnames in symlinks being
broken with reparse points by stripping off the leading slash?

On Fri, Jun 26, 2026 at 1:15=E2=80=AFPM Ralph Boehme <slow@samba.org> wrote=
:
>
> On 6/26/26 7:41 PM, Ralph Boehme wrote:
> > Now that we store as empty file + xattr on the server, not real
> > symlinks, this design decision might need to be revisited.
> >
> > I don't remember of the top of my head if this behaviour is implemented
> > in the client or the server. Does anyone remember? I'd have to check.
>
> it's the client: in cifs_convert_path_to_utf16() it strips the leading
> slash for the symlink target when called from create_native_symlink().
>
> As symlinks in SMB3 POSIX may be created any way the server thinks is
> safe (Samba does file+xattr, it never creates real symlinks on the
> server), so symlinks are just a client side thing and we should allow
> creating absolute symlinks. POSIX allows it (and users use it), so we
> should (safely) also allow it in SMB3 POSIX.



--=20
Thanks,

Steve
