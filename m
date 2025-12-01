Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A6B3358DC
	for <linux-cifs@vger.kernel.org>; Mon,  1 Dec 2025 16:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764608124; cv=none; b=JAQsVluoNha7E+wy/0M8ZBZ4IvwD3ZcgqzOV9UWlfNs5CFjsmQGbS+tUKfJyI33oGCGrtcCz/2nRxP8JvYG5jlPU7GfdPn/3bevCPJpf0LJF508kAmrMof8x12loQhad0Mxr+qLL1hlgtV7BiDBURMj+S2JQOWHKxzfuUfA4bpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764608124; c=relaxed/simple;
	bh=tnBeSzBy41ElJjUNzaDGRg1rFGe4xN+4QiZQOyT4O+Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L5hpToML8PkGWHZT33/e4JMMMsS4MTfMeYafzm+7WYA/RIxS41kefx6hDeiUWZlqeiNDobreJt2DyNIPLGWRgMtPiJLyAOhBfBwbXrBl+PZPnO3yjKRXOGFaoPV0SfJ8tw5hMwzRYve4O29SOTMRdAu9Q47KipJXkgUeWXtXNqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GJ9X37Tk; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GJ9X37Tk"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8845498be17so56828786d6.3
        for <linux-cifs@vger.kernel.org>; Mon, 01 Dec 2025 08:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764608121; x=1765212921; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4sEVpko+5n0PJOroaHb42D9u1KdHljQU3qjynTesipo=;
        b=GJ9X37TkUuCxtss+oKBzZ89YJ0NLf0DpFV+EwYiunAPVlKcWGYsSV7r8Kw5Tw7XbnI
         EhxP/95SRbLzXJowplUn553x5fgSQf7MCTLICu2VvjHVyZwSljGa0If7LLS9uj/NsbWg
         zZ5zEsoOtrKoHj2ADWf7ONFJCN+Y0WX1fH2wl5C6VD21zUL0eHZS86SzLQ26Phks9kyI
         7Y/KAXn4tvuFRQevd9nQyJFWjRbFwDZYF+shQLI6Zo+oEdEL4DC7lFnZIxWNgplyV3Pl
         1Gv1Nl/FzAjtaSsyLlvnA95dRp7H5EvU0GeqCCmqFDBwpv++XUOegNRiKrHv9DDZDZU9
         rNig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764608121; x=1765212921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4sEVpko+5n0PJOroaHb42D9u1KdHljQU3qjynTesipo=;
        b=MfGnHH0iz/l92CqsqXkxUxrilj1zs9/ta45UUViknae8Pa2T+cgiUjhOpMyZ6ikTQH
         mpQrawKUFRs4tL6LUGEbZacIzyEAqKLxZDMvEWGGli0uDphWlW5rrqNcb/7lSsnJWvVM
         3/PEkp1pMwiorFmvZGgjbfk51rrL6batoEBqDj8InU7wDx7o/Ye5uItZ2Ma87SpKkJJo
         7RCjel6Nz1+M1G4+kOfdrGaNaEeXu/wuGgVD2QNofaQOiVsuUVSotEz6IdH6sGQbDAJT
         6aCC2saiYJebxubMUIJ3Y/7FVONHD3ofZ2hkk2A2Zpw5bp/m/gq9lf971AxnM1xaGXWL
         uR8w==
X-Forwarded-Encrypted: i=1; AJvYcCXMFzW0uATUUDGM9smWm7xyv6oSQBgYgAHByCtUZYLz6Z9eiXdzkQZnaRIMWS2cmbm/HQ38Mnds7q3u@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7p213CDHyBRgSnqbOTX0LShANn0Hcciy4u0VcYCOHUXnG3vVv
	pVi1fy/ao0T91mGwXUCyvc6ONR4Lw9Stiiwl1GAw0HRJ+bBJZDKuMJAIHoDlTYEw3noyICtoYh0
	8EyP7SeMwBGZDff+LGAR1o5/m6w4uDTs=
X-Gm-Gg: ASbGncui8/Sf4OpXpZh8SICRzy2sd3+sIEEpYMDywHykfqDS1TWPbkZ7btVhuqPXq6Y
	g65/YTf0sdt6ylOt+u1MFJVMcCtj03hPUCM8H2TpCRewlHUqiR2lkRxknIauUJHSTZN6h12y1Wz
	9g9OxlBgNub7fVqaX9SIrDeMlYeSFEdtDjdv82dp/J/oemtxmV+BnUYTAMnEa8ntMIur86egIY4
	wVZWveQ4/5aBHrRHm9hWvDuoKLtInj5kHcPGtFqv7N2QLBTWZayUfGHEgvubdpa7K5yUEeAmakX
	ZHue8nfaDa6MOK9a3tzdw+QWkxek+AJob2s5FcIm5/zpilpc2ipPqTnGvoCe4bqLQU1PQNRVq5/
	BKtMHARTyp23qsOp30WRI9GPGBPk+8y0emXv8r5T9P+UuWdqrRehYNafMHYACgK15l/W4prgQtd
	2Q5DzqJbI=
X-Google-Smtp-Source: AGHT+IEG6R92jICSyFXT632ttWwgPqabGo/7YGPVecrju8YTrqTUBKLOzvnujd7HCxZ6Q3MkFdRGL2qRP8TIEVJqoic=
X-Received: by 2002:ad4:5c6d:0:b0:880:4ec0:417f with SMTP id
 6a1803df08f44-8847c4a3f8emr545853166d6.24.1764608121279; Mon, 01 Dec 2025
 08:55:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1430101.1764595523@warthog.procyon.org.uk>
In-Reply-To: <1430101.1764595523@warthog.procyon.org.uk>
From: Steve French <smfrench@gmail.com>
Date: Mon, 1 Dec 2025 10:55:08 -0600
X-Gm-Features: AWmQ_bn6VuRsE8Iui3zMCTDCVt_cM2s03jlNDIA4eOmN3RT6hBJvlGPPfTBZm0o
Message-ID: <CAH2r5ms9VSfTebnVe24bM7V5TVJkZgG=cOmZrxJo+RCPf1ZgtA@mail.gmail.com>
Subject: Re: Can we sort out the prototypes within the cifs headers?
To: David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.org>, Enzo Matsumiya <ematsumiya@suse.de>, 
	Steve French <sfrench@samba.org>, Shyam Prasad N <sprasad@microsoft.com>, 
	Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org, netfs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> (4) Move SMB1-specific functions out to smb1proto.h.  Move SMB2/3-specifi=
c
     functions out to smb2proto.h.

I am generally in favor of those type of cleanup patches (as
potentially higher priority) as we want to be able to turn off/remove
SMB1 code easily and not confuse old, less secure SMB1, with modern
dialects

On Mon, Dec 1, 2025 at 7:26=E2=80=AFAM David Howells <dhowells@redhat.com> =
wrote:
>
> Hi Paulo, Enzo, et al.,
>
> You may have seen my patch:
>
>         https://lore.kernel.org/linux-cifs/20251124124251.3565566-4-dhowe=
lls@redhat.com/T/#u
>
> to sort out the cifs header file prototypes, which are a bit of a mess: s=
ome
> seem to have been placed haphazardly in the headers, some have unnamed
> arguments and also sometimes the names in the .h and the .c don't match.
>
> Now Steve specifically namechecked you two as this will affect the backpo=
rting
> of patches.  Whilst this only affects the prototypes in the headers and n=
ot
> the implementations in C files, it does cause chunks of the headers to mo=
ve
> around.
>
> Can we agree on at least a subset of the cleanups to be made?  In order o=
f
> increasing conflictiveness, I have:
>
>  (1) Remove 'extern'.  cifs has a mix of externed and non-externed, but t=
he
>      documented approach is to get rid of externs on prototypes.
>
>  (2) (Re)name the arguments in the prototypes to be the same as in the
>      implementations.
>
>  (3) Adjust the layout of each prototype to match the implementation, jus=
t
>      with a semicolon on the end.  My script partially does this, but mov=
es
>      the return type onto the same line as the function name.
>
>  (4) Move SMB1-specific functions out to smb1proto.h.  Move SMB2/3-specif=
ic
>      functions out to smb2proto.h.
>
>  (5) Divide the lists of prototypes (particularly the massive one in
>      cifsproto.h) up into blocks according to which .c file contains the
>      implementation and preface each block with a comment that indicates =
the
>      name of the relevant .c file.
>
>      The comment could then be used as a key for the script to maintain t=
he
>      division in future.
>
>  (6) Sort each block by position in the .c file to make it easier to main=
tain
>      them.
>
> A hybrid approach is also possible, where we run the script to do the bas=
ic
> sorting and then manually correct the output.
>
> David
>
>


--=20
Thanks,

Steve
