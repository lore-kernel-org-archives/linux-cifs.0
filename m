Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01DC84D35
	for <linux-cifs@vger.kernel.org>; Mon, 29 Apr 2024 16:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714407233; cv=none; b=efJPOE5cDlT6hJc8uZtlRMdtAYudQh+Tnuh0/fD3dS2LB4xTCY6HKSDRhlQiNWOb9xCMh8u1nxF8v23xO6lQXZ7s896jJaYo6ZPL+ddvJa4CzGkwq26LCxb7h2VxVbgZi+ljhVG1X4enqOaXLbdHFRPLa9j6VK+Yrf9EeS+9KuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714407233; c=relaxed/simple;
	bh=5/o2/781wVC8TpBAgmKN0HGuXOdqTo1AFbpQ++SbgR0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NlccG3nToF2IejZ92DsWz+BmXkK3q8R1RVMw/cG8WUqMGyMCwyMWvjcLFpBoRtONJCDyOlKSRxssZZj0Q7oAcKrUT0rzXiu0cp1R0fnpn+ZAljgKHRiHJFYkn7+/lc2j/iRxjfs+L0fiSN6u1SfeREFyHGzrFPzXNXbydl3gZsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z9ia+npz; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z9ia+npz"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2db13ca0363so74563401fa.3
        for <linux-cifs@vger.kernel.org>; Mon, 29 Apr 2024 09:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714407230; x=1715012030; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UI5KsYZRbCsJ4uc2FmD4NMY/rgsJbING+RbxgVBHGxM=;
        b=Z9ia+npzU7hkeJ0Q0MSlOuwbp9ufMGGGvO2q3YbAvBS3N6HDmh278HhqR58U+8seId
         WOHge18de0RYgD11Rxmck0ZPAn3qNN2I2XlTAYY3xTsbsVrW/GrVmq6RB3RegxnHHScz
         hGqDI3NYP9msqtkwPSm+V6WCmWN8iB4dqJGGPUb5DiUJImd8IL6zQN2ZCcHSjzFK1PjD
         8dW+t1XjtSj3c8oq401vzyvHiSLsbC8gFOdiJeTtI8AvgzEOcOksfTzCihiCGenATlty
         nqb6PK4Fvb+T7nQT5l1djSSm1nrnSpzUingolI6lvQxDItb3BpzPoM7yLnzdxZfxr6Zp
         M5GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714407230; x=1715012030;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UI5KsYZRbCsJ4uc2FmD4NMY/rgsJbING+RbxgVBHGxM=;
        b=V4DrbgC64x2yI4gGG7nxN5niwSmY9TeBElsfBb5mbSEK/Fn/HtwcVcevQWB0fTn5mm
         geiiI0rShR0QFn+vhqMOgBld28EfJtplwiPQpbM9oXkI6JiKdJew2+ziXHZBjR/5K5JN
         hHT6aJXwMHXX6SyyLSXyPsKH78e+Qr8vbiZIVUmbU4Esuksi07VFBTzH4i0XUJClzQON
         pQnqRgF7IFq9K4d0LpSKWKfqas6XZH+BZq+a1bX6VClsZlaPBBwv0Ca38a5c0EwEsKtH
         ZzJ+Zjf6Rv/B89IYb8T24/3IVjHyUc1uzuhxAnSV13Zn0jumZbIMcwk1af/YdjSo7LbS
         mFMw==
X-Forwarded-Encrypted: i=1; AJvYcCV130W9yrvnITpc/4bbja/ZIEcXpfo+EIwVos+Vj3Dm0lMb9fW8DOEonMT+n5tcBDRTEv85Fa9ezh1KnpRucRXqsGe5Q14Hoy2MXQ==
X-Gm-Message-State: AOJu0Yw7WK5OTAtkBPp72SzvCAlwAAfYxVaAXDhoAEhUjZ946Ru2i2Ay
	Eo3eOtwSftHJGeZEqKqF4majCaTGRMJJjEOkw6ecrohvDxZ1vN/0shHClt+RzB5qj2VfoUwVYKK
	luC/0SHDKRJffHyHJ5bGqsaVdXSk/mw==
X-Google-Smtp-Source: AGHT+IG1+udI41KNVRYsPpO+Eu5KZBS9GII0f5Ck6zaeKvJdlvQPvhGyvXfl8pJ2L8kF9XFd/xNT+B+zz20+EAUmVB4=
X-Received: by 2002:a2e:b8d2:0:b0:2d6:f5c6:e5a1 with SMTP id
 s18-20020a2eb8d2000000b002d6f5c6e5a1mr9889978ljp.12.1714407229833; Mon, 29
 Apr 2024 09:13:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5msg91ad+K+eZmCjKCJeDgyb6xcUUhmpaXeeTFjqFZUeBA@mail.gmail.com>
 <72ec968a-ac67-415f-8478-d1b9017c0326@samba.org>
In-Reply-To: <72ec968a-ac67-415f-8478-d1b9017c0326@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 29 Apr 2024 11:13:37 -0500
Message-ID: <CAH2r5muhcnf6iYaB25k+wZC50b5pNV+enrK=Ye_-9t2NCVdCJQ@mail.gmail.com>
Subject: Re: query fs info level 0x100
To: Ralph Boehme <slow@samba.org>
Cc: samba-technical <samba-technical@lists.samba.org>, 
	"Volker.Lendecke@sernet.de" <Volker.Lendecke@sernet.de>, Jeremy Allison <jra@samba.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 29, 2024 at 12:31=E2=80=AFAM Ralph Boehme <slow@samba.org> wrot=
e:
>
> On 4/29/24 1:27 AM, Steve French wrote:
> > Trying some xfstests to current Samba (master branch, Samba 4.21),
> > they fail because query fs info (level 0x100) is returning
> > STATUS_INVALID_INFO_CLASS) - this works to ksmbd and I thought it used
> > to work to Samba.   I do see the SMB3.1.1 opens with the POSIX open
> > context works - but the query fs info failing causes xfstests to fail.
> >
> > Is that missing rom current mainline Samba?
>
> have you enabled SMB3 UNIX Extensions?
>
> smb3 unix extensions =3D yes

Yes - it is set to yes in the smb.conf for both the global section and
the per share section

I also see that POSIX extensions in:
1) the server returns posix negotiation context in the SMB3.1.1
negotiate protocol response
2) the server returns the level 100 (FILE_POSIX_INFO) query info responses

But the (current Samba) server fails the level 100 (level 0x64 in hex)
FS_POSIX_INFO with "STATUS_INVALID_ERROR_CLASS"
which causes all xfstests to break since they can't verify the mount
(e.g. with "stat -f").
Nothing related to this on the client has changed, and ksmbd has
always supported this so works fine there.


--=20
Thanks,

Steve
