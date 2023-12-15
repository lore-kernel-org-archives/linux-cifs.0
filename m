Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B173010B
	for <linux-cifs@vger.kernel.org>; Fri, 15 Dec 2023 19:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FHBYqq1E"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2c9f7fe6623so11029811fa.3
        for <linux-cifs@vger.kernel.org>; Fri, 15 Dec 2023 11:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702667217; x=1703272017; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wZiemOCqIAwL6vSP+5Lr+1+2ZvP7z6fHhPxugDj9rZs=;
        b=FHBYqq1Eq32D5OgV3d5I8iA02Pco3laTa5BIZvmgntRkYTOFlQa46mCneJQl5Ygsi7
         g3k3kF2NSBh5x1VcF2seb6N44gzjHLVzE1xBX3WaBIh32oPrEtekNkjSGEP7Amb4r+gk
         p5naUvOLbI+y8Gtdw+aBQxvaT4R1SX1rBKjs/TBHaD8FhWUIfQWduJCv7Q0fvWHHC8V6
         zOWdNL/2RSgpnnDVuMJ4z8ZjRDga2llRSIPPc3dgvYjg7XM7ryzv14B38lsW2EnpBzsa
         p//Au4rIbUrZiZmODjdZGRW24nGRaA6qYZcJeBbllJ1ZaXF7R/3jWaxkvKcQKNJ/yjIy
         rIrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702667217; x=1703272017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wZiemOCqIAwL6vSP+5Lr+1+2ZvP7z6fHhPxugDj9rZs=;
        b=uV8BSCIM/ULgaVqXSUJVGdkS+IUV8Q3qRH+3BWSo8ZeRJ5S7+p3LwHnw+ZTfgReJge
         hWPZnZAccNFQ/IZkJRFqRD/oE2lDtSH2bYuBEp6j7k5RDNS2EoQvPf64s+TjLO0Jn8vP
         UB6jkPOcVpyPqiTaPtaioAm7ZKWQPNO+He5wdzvqFQ4R8pba6y4uByRoXCLIWS164R/7
         Pf+zBBe9OPqDerW1ouJNVzucconpom1JzrtA5WO91HKOfnusa12pJIayGQCFVUSoalbR
         puxydCTUEVunyWeriuZDgL4YYWuX2WEmpRIa9Bz4KotQL72xKkS4NnTzeykEA32M9akP
         y0Jg==
X-Gm-Message-State: AOJu0YwmFvkPPVsdRAm8xw2jx57Ch+ZXESpzGCHosh+fjD8njqeYfCeh
	zIxrwZgTVVIWDQa0jf9BbR2m17hDlHPhfL7uqB41jQHC
X-Google-Smtp-Source: AGHT+IF2wNpAER0WpDsH3q0TuEGCpEEWF23/+69BC3tBNoUC8s2ix2t9byz8yyQZSonHihhcLhVRQN1DDKiBiMd3Qpw=
X-Received: by 2002:a2e:5c01:0:b0:2cb:2bd1:e984 with SMTP id
 q1-20020a2e5c01000000b002cb2bd1e984mr3500943ljb.17.1702667216649; Fri, 15 Dec
 2023 11:06:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtZW18Wq=mnU9MKH0eL-1wCKXTRGt00E-X32_dJ_H1F9w@mail.gmail.com>
In-Reply-To: <CAH2r5mtZW18Wq=mnU9MKH0eL-1wCKXTRGt00E-X32_dJ_H1F9w@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 15 Dec 2023 13:06:45 -0600
Message-ID: <CAH2r5mv1gQstP23XWMpGBWKaAgSj1r9fcv=MUsTDj7dL4RH=JA@mail.gmail.com>
Subject: Re: [PATCH v2] smb3: allow files to be created with backslash in name
To: CIFS <linux-cifs@vger.kernel.org>
Cc: Xiaoli Feng <xifeng@redhat.com>, ronnie sahlberg <ronniesahlberg@gmail.com>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I noticed that this patch got missed.  Do you remember if any problems with=
 it?

(I noticed it while deleting some old branches).

To avoid this happening in the future, I have created a
"for-next-next" in cifs-2.6.git for-next (similar to what we do with
ksmbd and have a "ksmbd-for-next" and a "ksmbd-for-next-next").  I
will add this patch to the for-next-next unless anyone has any
objections (pending more testing and review)

Since we basically have two types of patches - those that are for the
next RC (in this case rc6) vs. those that are for the next release (ie
6.8 merge window), I want to make sure we don't lose any of the latter
anymore.

On Sat, Feb 27, 2021 at 2:12=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> Backslash is reserved in Windows (and SMB2/SMB3 by default) but
> allowed in POSIX so must be remapped when POSIX extensions are
> not enabled.
>
> The default mapping for SMB3 mounts ("SFM") allows mapping backslash
> (ie 0x5C in UTF8) to 0xF026 in UCS-2 (using the Unicode remapping
> range reserved for these characters), but this was not mapped by
> cifs.ko (unlike asterisk, greater than, question mark etc).  This patch
> fixes that to allow creating files and directories with backslash
> in the file or directory name.
>
> Before this patch:
>    touch "/mnt2/subdir/filewith\slash"
> would return
>    touch: setting times of '/mnt2/subdir/filewith\slash': Invalid argumen=
t
>
> With the patch tReported-by: Xiaoli Feng <xifeng@redhat.com>ouch and
> mkdir with the backslash in the name works.
>
> Version two of the patch works with files in subdirectories not just
> the root of the share.
>
> This problem was found while debugging xfstest generic/453
>     https://bugzilla.kernel.org/show_bug.cgi?id=3D210961
>
> Reported-by: Xiaoli Feng <xifeng@redhat.com>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
