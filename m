Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CAD24DD13
	for <linux-cifs@vger.kernel.org>; Tue, 27 May 2025 19:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748373307; cv=none; b=hGribFMEIv6wfq6OUA3BGLUCVGV/UpmDG/TQPrUwuawej3InIGNGZ8lBB/dzXW3w7v2bxt6zoHSo87mG2LttcXz3yqFbhCBbxpoPLX/D9MaSSgcWRQv/auegmHTlMFFlx7bfD7AHGNH6q2ksBdvlI/mA9YYpQlWjaCTK90eBRfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748373307; c=relaxed/simple;
	bh=rx+3MtjBvCDmKt+gs1FFE+v0apuyp7IsoAATQP+4YIY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JyLOoeiFGauJ9ZqzJZRlOwMIYkqf0xvSuplzc8sFwZcfW2CqWQr++C0NpatOijoogmvG6ykrbpTDi/80Wkf6yMGddTB/B7Rm392+dI4cwGUNuoSk2W4IYd9OTELiSa28huPhpzOLuvPc8m+BGyM08I4EN3izf2e9f18JmzPVRIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Knd2NNWr; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Knd2NNWr"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-32a696ff4dcso15089001fa.3
        for <linux-cifs@vger.kernel.org>; Tue, 27 May 2025 12:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748373303; x=1748978103; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bGuuzxrf+ZMkXU/8TmT3e+//hn7WZvDG3I8PrXK61Jw=;
        b=Knd2NNWrxb7BJm9iyP3QKCB3h/J27+AYCVb6F9x8vcS6hwpXXq9inx1zXHynMyTkWw
         1a3rm4IbcIs96/sIV6QJRuMriDYz77+Ik5C1Uwybh+cannJdJqAxuGrCA15052Mm+6iF
         tZ/dC4WUnGtcG8k2fyfKwHl/7B+NLKBao9h/JpyrelGifwpmfWeMnvkRH9HKBSGldDtI
         KoRnjaNwR4IPVyvVpub+KI9rnOj78dnQ4oYvYATuj/TbOOPxI3EIftUSc8nK4aNNWX9l
         cgSYNQ3Nft1/2aIrh8R2rftQNiF8CkVM98qkvo4xoCCEV9HEHpf+y67GPyugYDWq9BOg
         3O8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748373303; x=1748978103;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bGuuzxrf+ZMkXU/8TmT3e+//hn7WZvDG3I8PrXK61Jw=;
        b=F7s0dKx8P4aV3y+I4qvApJ6ijH6yN251jf2k/LH2GGfRWd2mE9B5PYmiGyGHxQtAoU
         Vv03yZQCRxhcdyLVKpBU+VVD6GZcCk1OrkVw/6Kb+36viMUxz+WVKKnWiqiJqP2XYkSt
         QpUCnsgXTGTAGJxP1lJ4K1pexk7DQN8ikvPQo4k4wHpx1cwOBNCLOtZJaKiAjKDu3i+H
         why0ATTqzbDyQneLmRHjDtX+RElvuzqjw1FumMqxDjHNVhKu7XXiQb+WlKpkyP79++7A
         fg8yeDBmMyb+RjHEhuvtUxwKXZjiLqGLq2DjOSwIaq5xn6t8rIu432VhEu81b4pNGRc3
         Vr+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUTnn+vBuGW37DPFOw3M+RPTnEGThWr0E1gi/XNk37D6swXEOMvjBPHpkzDw+s8rmLDEbLd8D1eHzzR@vger.kernel.org
X-Gm-Message-State: AOJu0YwnjGHa2nY4Zj0lKRhbhjb5bZGdejvGPDF3Uo7k0+3f5OAHred1
	aGm3t8eQ03EREuQx9nzlEFlTFAT7cHz8bcDLCi2fpQqYQa/2Hy+lGPnubruAl/mdKLRSct0aePT
	sMHI3ZIQubbvgcbzCzUYrg7h96hYiZR0=
X-Gm-Gg: ASbGncuDmvyW07ypo9ILFpiHfUkQRNIZU4KMnkMzGxX86xBOyFskt3c7XPTBp7QLJnE
	nysSRJelbpjzRgjzJeNRC4odZqCD8HOoDqELMj4oYGYZtStZ7kexqGQ6qEbH0WYKMygj9li+nBI
	/0CNROGEPba/zFgsxIdiiS5W10OCmIBwkZeUb3bu9mSewP+yEpxatLaM0NGp8J8ikAq3RTqsY9r
	BMG
X-Google-Smtp-Source: AGHT+IF0rY0GJw4SzVaN9SFABRZodR+4SgkYw+tPSSz6q9aDlqqVJ25bv/A8Erb4SrkQ2kSwL2yeXlqUAxellXgvbfk=
X-Received: by 2002:a05:651c:304e:b0:32a:7386:c9f0 with SMTP id
 38308e7fff4ca-32a7386cb59mr5560821fa.29.1748373303077; Tue, 27 May 2025
 12:15:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1748362221.git.metze@samba.org> <31f6e853d60ec99136f3855acb3447d36fa0fc82.1748362221.git.metze@samba.org>
 <ace9b692-3a0d-4a47-b74b-c350a72efdf1@talpey.com>
In-Reply-To: <ace9b692-3a0d-4a47-b74b-c350a72efdf1@talpey.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 27 May 2025 14:14:51 -0500
X-Gm-Features: AX0GCFvxy2FH648vMWhsC-OSmUuRGWrqy_hAITLGNlCv5SDdz7S3Mi0eTgSKks8
Message-ID: <CAH2r5mscnhMOvF=5HNnmzdYZZyds19tkr7T-HSyHQtFVB9rBfA@mail.gmail.com>
Subject: Re: [PATCH 1/5] smb: common: split out smb_direct related header files
To: Tom Talpey <tom@talpey.com>
Cc: Stefan Metzmacher <metze@samba.org>, Long Li <longli@microsoft.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>, 
	samba-technical@lists.samba.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 27, 2025 at 1:50=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
>
> I love the idea. Couple of questions on the pathnames...
>
> On 5/27/2025 12:12 PM, Stefan Metzmacher wrote:
> > This is just a start moving into a common smb_direct layer.
> >
> > Cc: Steve French <smfrench@gmail.com>
> > Cc: Tom Talpey <tom@talpey.com>
> > Cc: Long Li <longli@microsoft.com>
> > Cc: Namjae Jeon <linkinjeon@kernel.org>
> > Cc: Hyunchul Lee <hyc.lee@gmail.com>
> > Cc: linux-cifs@vger.kernel.org
> > Cc: samba-technical@lists.samba.org
> > Signed-off-by: Stefan Metzmacher <metze@samba.org>
> > ---
> >   fs/smb/common/smb_direct/smb_direct.h     | 11 +++++
> >   fs/smb/common/smb_direct/smb_direct_pdu.h | 51 ++++++++++++++++++++++=
+
>
> Why the underscore in "smb_direct", in both components? The protocol
> doesn't use this, and it seems awkward and search-unfriendly.

I agree that it would be less confusing if smbdirect instead of
smb_direct in the file/directory names
