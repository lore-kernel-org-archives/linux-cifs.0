Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2029032D0CC
	for <linux-cifs@vger.kernel.org>; Thu, 16 Oct 2025 16:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760630474; cv=none; b=RmmRreU5nDEy21pHya3DObH5C9QPANBweqQpMfH6n1vAvL/FhZ0akngC7Mkv42s7S1tNHktC0A/DfsRb7dOL4D7fW0NZ7lELnB/T7Mu3/SuAuh7sG4/o1pXxSLPL9vVbdYMRrm/qSyg9TLCNhWrntruodmnL70Ml7XeKetgX9Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760630474; c=relaxed/simple;
	bh=OkLmE1s7BCfavCRHWUlfiNzNqHQRLUNV9toLcXurg7c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dZqsvFrmJWS9xoiLreVchMAiHh4Bt60ZLYJ3VZ8OBSDvkAzQa0y4p9M3EGQuii3hFvDFAAzRzn7TQ527GahZcTfD32o8/gKcjIoBspB3XsxVG3AlZ/hsSka2L1TWFtiZLS6D6V/bdWtVUw+mW/HGE7UrFZYAWm6NRZc3rBBW3Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TUPbFIXF; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TUPbFIXF"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-87bf3d1e7faso18418366d6.3
        for <linux-cifs@vger.kernel.org>; Thu, 16 Oct 2025 09:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760630471; x=1761235271; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iFQ+JESL9UIjpR6PcV9P6XUYYp4yVYWVkfQwglpsal0=;
        b=TUPbFIXFhdmctjY+zWePfelAMI3NoubXrsoF6dFjQGnrMlEg79jj2uaVMCWRs5CRYE
         P4r0U7Emits0PxLuTWfLSN2zkgHreNV6lEW7UADi/gPB3b+t4sNZwnjepNLpyKUjY71l
         CC+cQdYo0rWCwSiUSJy0lsyXTwu3MNbdI/9hCk7nvrWlNiGpFYiuM+HNAs6GuB6EwKnU
         g6/owUto+TW+yuP3ASgLIkKdNRO9zR25ixi+LSYG2LE0zBFk4c82boGemQap0I5Ah4kG
         uKdpHccXu3gsJ/Lp2uC+AmVPYY7YtghUBaZXBTLWQEOS/M0hbmTH+TjriA2rPu75xoE9
         1sww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760630471; x=1761235271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iFQ+JESL9UIjpR6PcV9P6XUYYp4yVYWVkfQwglpsal0=;
        b=dXT57YZYSc26Df3VCtFZfnlmchuk+GkXSAgpWZekuw6wbKliNwnN00aMOeOPt3+chd
         1YWDYRVmdl6ZAFdJXXvIgPCWEfZ0G33ecdCFU/CL9cZCud0J3ZEjkUIRm4yNyRV8rwLq
         fxBbBHsYNwUoz5FutK101YqDJufoeZlxZ2GyzHqmKydk1d1/GQODH4OIrcfaJ2igYsAH
         g8O79SQFeW+sgtB5DF3sBsTTezE4mw8pbnVp8aT3BFvdeEwFenywWt+SPgJEkaaHPSRZ
         EtyU+gEykI7VS7xVu1v3fHJVRQAcfH7h0oKwSvKRjJW8X+GFah7TkJKw3VBNBkS3EWJy
         pAOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnyWdq54RHmDsd9gaMgfgDvCsQKEk2aEGHPpO7mWjgj1Y9U97FHPFKqpCifNDgb7Yjv6R2jFzLVboD@vger.kernel.org
X-Gm-Message-State: AOJu0YxBbIGKGiWY6nGMKlV8+3eV3zTWAD25WYZmPxySYuEVxlI1Mqlw
	QOF4Ha3mF4pmzLDxVZstfqL8ofE1Zi24BvLTzzewkBlutQEgc+jPspXt3BxFd0AJvYrETrGruCy
	CwegyvJ8sG4+/yiU+qTQ4RRCIYGNy9OI=
X-Gm-Gg: ASbGnctfCwhiIPE8Ux1lmzks7og6QozCJ8jOvaVROpm/s5WOSObO38zAD09L9ctfY0P
	6cOaOghSKeakNV22vqpzViDNGuJ94Q4c5dPqdyLMbrQHNAVB1ZPtm2bHfpcgrJXRW1RBUUcatUm
	RFcz5CV3MMc/nSVWdwDNzagfb7h2k9AiKiOlOUWJ4l2vOn3MoF677kJKpfSjUhG0qKdIp/QC8wg
	IRRPSN2FdK0MslE2IH4qtERvLHmkjgpU0bTzB6PRVLdRgDiD9F5EUKd9pxOS1oZ1pGPfETB8HOR
	Ki5DlD6xVtN6ZjmTSdhrmhZedGkLlKBkuE3fEt67DuM+pJ3saGibX6W4gT4WkaARHQ9/PVr9Yuf
	vpbEFQzfRbhruKTQVsZQvv0RsedE+P8OLksJUINJyAAkctRYZTcaCmuwwkXY5YJZzI3JzkpO4k4
	uKcbMzJwUt
X-Google-Smtp-Source: AGHT+IEjNzMcEiWFAsmyuj/Yi6bdGpUfk6izOvZ1EcmWMdmqpXJOOCJ14NVAuKFiY/6bCaKVNofLoAP/TbJKGrstSkg=
X-Received: by 2002:a05:6214:460c:b0:87c:21b0:79e9 with SMTP id
 6a1803df08f44-87c21b07fc2mr1201866d6.60.1760630469114; Thu, 16 Oct 2025
 09:01:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aPBeBxTQLeyFl4mx@chcpu18> <1f9e946d-91e3-4f9a-b26c-e69537cbbd4c@web.de>
In-Reply-To: <1f9e946d-91e3-4f9a-b26c-e69537cbbd4c@web.de>
From: Steve French <smfrench@gmail.com>
Date: Thu, 16 Oct 2025 11:00:57 -0500
X-Gm-Features: AS18NWCxy8CAvRIZM1Ad_Rzkx26Gk4ZxkE8KTaqrRNxF0A5mEjrWE1pFjeru6T0
Message-ID: <CAH2r5mvKpoaD3DDPAc=xUpbcF4TH4nedNdvZg6LBiETG5x3-DQ@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: Fix refcount leak for cifs_sb_tlink
To: Markus Elfring <Markus.Elfring@web.de>
Cc: Shuhao Fu <sfual@cse.ust.hk>, Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, Bharath SM <bharathsm@microsoft.com>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The patch looks fine.  More important is focusing on the fixes (and
missing features) - minor wording of description can be helpful but
MUCH more important is focusing on xfstests, new test scenarios,
automated analysis to find places where use after frees possible etc,
fuzzing (like the great scripts Dr. Morris created for us to show some
potential security issues), fixing the various known bugs, adding the
missing features etc

On Thu, Oct 16, 2025 at 2:22=E2=80=AFAM Markus Elfring <Markus.Elfring@web.=
de> wrote:
>
> > Fix three refcount inconsistency issues related to `cifs_sb_tlink`.
>
> I find such an introduction sentence not so relevant here.
>
>
> > Comments for `cifs_sb_tlink` state that `cifs_put_tlink()` needs to be
> > called after successful calls to `cifs_sb_tlink()`. Three calls fail to
> > update refcount accordingly, leading to possible resource leaks.
>
> * Can it be preferred to refer to the term =E2=80=9Creference count=E2=80=
=9D?
>
> * Would you find a description of corresponding case distinctions more he=
lpful?
>
> * May resource leaks be indicated also in the summary phrase?
>
> * Would it be helpful to append parentheses to function names at more pla=
ces?
>
> * Is there a need to mention change steps more individually?
>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/Documentation/process/submitting-patches.rst?h=3Dv6.17#n94
>
> * Will development interests grow for the application of scope-based reso=
urce management?
>
>
> Regards,
> Markus
>


--=20
Thanks,

Steve
