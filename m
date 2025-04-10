Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311974503B
	for <linux-cifs@vger.kernel.org>; Thu, 10 Apr 2025 18:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744310279; cv=none; b=snUlMxnCdIykmFBS1xlO3uD8EFM2Pn4gIHceETWt8rviJxekWq3LTFwMJDdjVzVlVfem6kks/wOgcPNZNBeCwaSQxT6BLPeu6x8WD+EetenhTkb9uMobRBteVQa3sF3t6sF8AcB8WKkKvx930nyAPXkxQQORwZSjKj4mgsNZSIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744310279; c=relaxed/simple;
	bh=Y3GAObyOFGSDS+Xw4GgXyeEFbO2rwufo1uCKvwkNg80=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iUzy+hL15BDFYBn4rMWPoEs5p9Mvv3Xrh5YJBOp8Ru2jks7Mtxn88fSXSGNuaqyzVrLwDgG7NCQFJcv7sfspSja4jy6F2bSIUWwzMcNkpB9CeYxxMcfWqx9JxmqHDSWGl4C/JgbBL9cHwEn9oWQ/aBy+PxVJRXJx63vjBEe9cWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iJol/+6G; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iJol/+6G"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-54b166fa41bso1395681e87.0
        for <linux-cifs@vger.kernel.org>; Thu, 10 Apr 2025 11:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744310276; x=1744915076; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y3GAObyOFGSDS+Xw4GgXyeEFbO2rwufo1uCKvwkNg80=;
        b=iJol/+6GNPLpVDOyQqhNbuMcbtiUd+wgtSIybGnacdDbhIOBKg+BIYtmrQ0l8V1hSv
         sTa7JMYEXjTRaUFhiOuqzbzfVjlrGhlD0IGM+5z7oS4QxPo/NppBX5xw1ahESXUDh3ba
         X5wQttDiyIzzSBKkKwR4qGqcm/fFP8ujshGJrDh/uXZNro8jrBd1jqrS9JU1a7m9SjVY
         9MLFjhxi0EMMEewSPrJpD61qF5X5H3bcUxlBoaA+1C84Oxo/yqECKjHnGNxqxOc5xpBf
         jrJoZn5P07gwFd+lozdvF4UzPFtuhEywlVp32wK8tBDeehLMEz9Yl+JHEVSKUrEK+0ZP
         7ibQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744310276; x=1744915076;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y3GAObyOFGSDS+Xw4GgXyeEFbO2rwufo1uCKvwkNg80=;
        b=neD/m1tHEHRp+PZP3D4pI+GzO8nXvWkRnyv8+PTtbCMii3MUV46WOQpKq7LmX9oyfX
         t/9XfCsrpXBnqlqOnnlM/P832HQAu3eHwVi1E0a6/+N3xOno34SDjQTeDM/6GnQilqJg
         86UQnYDPqybqn7tqbH1p7nRiaAou9pCukJ7MNNocnDBkPrTbXRX369JZHIw1rf3WRT7k
         NrPOOcGzjurbzFHJoJ0qlSJYKKYaofcOPCnGyoTXsk/FCn3xs9FeTcxDl+Q8iiWybSbh
         ka+Yv0wKvBZgGYWU2SyjWRwaWquwTKFi4s5A0wEe4pflSoLqhpteDwFSaUUIvD7dcVI6
         EwJw==
X-Forwarded-Encrypted: i=1; AJvYcCUgl9KifIWeGPuF+ItJhrcISwb2S1jG/cm1AzcgXzhsJU38/Lpt55ZaxEp9OajapHijfK/JSbAOudlV@vger.kernel.org
X-Gm-Message-State: AOJu0YxpRBdfCK/XoeAfuVNGCUwTMltr0bXfk8cCTOOC7ATPl6IR8PmY
	e240jktiDeq+V2eqL1D/l1IWHJ71QPLGC2ziD7ygNWiVfKFCe0fbQhritccPcS0N9vvD359AVvg
	gtEGpBU4HmIFZQbFHX3rhA+UkOBM=
X-Gm-Gg: ASbGncuKx2oqNS7nq428crZ0sC1Fq3YZtJSIPA18OJnO6LLWiIDrgpvG+Am2+ozs33+
	pxRFzo6B+cbEbpzDwbmTEjFEPW89FdMK1+Z8rzqytQFUUUpWcPVQY4QAKwH8h4OnRgVN3aHe/yd
	Ctxqu8/R8o1hIShEXTEmQvhZWINnUek28bRoFyO0siyf4GQMHbMsgXmUhq
X-Google-Smtp-Source: AGHT+IGIPyKwAAreodyN6vVGJbh2ZobqpBvExETMq6i7L79uNw7TvmIO5fbwHo/74cz3OO8kQs6+n54d1Qm16vW7re0=
X-Received: by 2002:a05:6512:3f05:b0:545:f0a:bf50 with SMTP id
 2adb3069b0e04-54d3c62ef13mr1371323e87.35.1744310275992; Thu, 10 Apr 2025
 11:37:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <32f7a0c2-32cd-4ccd-b471-7cba98cc30f3@samba.org>
 <CAH2r5mt2032HC_yLrqGoAY-J6JZfP_2zjOjoKiY92YUrxBiqnA@mail.gmail.com>
 <a5c81acc-1e85-463d-925e-eb5b05af9ee7@samba.org> <a60852f5-cb90-4614-b35c-91d6507aee0a@talpey.com>
 <085204d2-22e6-4de6-aeec-620dba38280b@samba.org>
In-Reply-To: <085204d2-22e6-4de6-aeec-620dba38280b@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 10 Apr 2025 13:37:44 -0500
X-Gm-Features: ATxdqUGBKtzTsQKqy3ci9KeEdCz0oDkmM3tAH_MMGshL-7BoNDKgnFu-dS5gBl4
Message-ID: <CAH2r5msKR+CGgOHxCU+TfYPakQxbQJQnsVPyq6ANhSnON+vSWQ@mail.gmail.com>
Subject: Re: SMB3 POSIX and deleting files with FILE_ATTRIBUTE_READONLY
To: Ralph Boehme <slow@samba.org>
Cc: Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, 
	Steven French <Steven.French@microsoft.com>, Jeremy Allison <jra@samba.org>, 
	"vl@samba.org" <vl@samba.org>, Stefan Metzmacher <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 10, 2025 at 3:32=E2=80=AFAM Ralph Boehme <slow@samba.org> wrote=
:
>
> On 4/10/25 7:23 AM, Tom Talpey wrote:
> > On 4/9/2025 9:06 PM, Ralph Boehme wrote:
> >> On 4/9/25 8:43 PM, Steve French wrote:
> >>> On Wed, Apr 9, 2025 at 1:18=E2=80=AFPM Ralph Boehme <slow@samba.org> =
wrote:
> >>>> what should be the behavior with SMB3 POSIX when a POSIX client
> >>>> tries to
> >>>> delete a file that has FILE_ATTRIBUTE_READONLY set?
> >>>>
> >>>> The major question that we must answer is, if this we would want to
> >>>> allow for POSIX clients to ignore this in some way: either completel=
y
> >>>> ignore it on POSIX handles or first check if the handle has requeste=
d
> >>>> and been granted WRITE_ATTRIBUTES access.
> >>>
> >>> I agree that to delete a file with READ_ONLY set should by default
> >>> require
> >>> WRITE_ATTRIBUTES (and delete)
> >
> > Since when does Posix require this??
>
> Obviously it doesn't.
>
> Let me try to ask it differently: do we want to relax Windows security
> model on a POSIX handle for this operation, even if we can build sane
> semantics into the protocol that doesn't require this?

If in doubt, better to be "more secure" unless case is very strong to relax
this check.

--=20
Thanks,

Steve
