Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A6B200130;
	Thu, 13 Feb 2025 22:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739484212; cv=none; b=uBdOTBa9dZ+7jDtGfnkdTe0FJgkUTXbG6MtTu34yZvUoRkKtSADa+QMWUhF6H29Dri5qFgaUr4l2uENSk+THCQEq56zNuvNf6ql2FEzYg0pOKAyroI9hwYQydVVbw9O+tRaACbwW+tdtXPnLr42srOpU2KJHEHUAtZI5ImIDKp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739484212; c=relaxed/simple;
	bh=z5OtbrfKbKVSOtZp8ZkdxsdJY2gAsgvG4SBxuQ4dIxU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=L9txmom70NaKok4uHxhmcrbG+H3RKijoZp3fmK/J0PXJIuyD4R+YWTvj72b2I+yTySBryKn70vpqQYdiKT1y3JQ23/48VBx5u4nHxO/zbUnn3NL5Ev5zppB7W1o3b8icCNP5xgVIhFdQM87FskKwe1+eUq4kl87q2CZ5ToqpEFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NpmDca+2; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NpmDca+2"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-308f53aef4fso13355801fa.0;
        Thu, 13 Feb 2025 14:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739484209; x=1740089009; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aWe4ZcR9leH+p7tbON4TD61UpNJGfge7vFio00YzpVM=;
        b=NpmDca+2146H7qNLoGtYgUXGSiIybVv+MJjSWVjxcRXuSACYTMnaFqrzD99x7GWx98
         iUqoN5FZItbGh46+eyHIuZ5RdCuc0/EFEq5f+MAqRTo11X9V3YvnL6NKVXfMxrR1/ghZ
         US8T3UtxjEb7fdCU1WsOE2ObJmYx27n2lkyXe2rp+L/1hWUvDfIJpFzHudjvd64wIgec
         Pf9zs6EuXCxjUhURHFOxVK4wc6yebOHPUxRpjc/Vyd/4mMn5WjWevHEQqLLNU5pLSAgU
         My8xSOFxZ1+0gW79CWbSgVk1MFyGtxAWDmkznl5MKJQOv+yQzssRBDoD8twNXNxvifTh
         R3IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739484209; x=1740089009;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aWe4ZcR9leH+p7tbON4TD61UpNJGfge7vFio00YzpVM=;
        b=PjICp58sYQSIQQLoBzOTbUrawUxHDtmVn+npqneWkQeWIj0EL2hh0zDqDkjy/IDHoM
         IyKdERnykZtKbJOaQJWE3o37gZbfThs4zhZ/M60Mr7pw+NK16hO0HW0FXhJF9gWm9R1x
         jre6eSIC72tazuuoe/WDnY9DhdAXrip3PGyVROY2XnOxLRDnI8GofOe9zkybCtwx5aB3
         JswaPalNegK8WKnBLUXygK52VIrzVDbw914isdlcKcSy0w6+h3Bc8Ng2STg8CrRqah1r
         ldqOlfQQGNuARBJ/bWWk3oS4v8dalCcaTlhhGc8+Hv3MNrm9KTc+IBo99fL+VkSjzofN
         c2yA==
X-Gm-Message-State: AOJu0YwfujUx20HApE8XFK9/MBpMydpbVECp8atethxtcaeV/Az+0z4/
	3+zODZ+FkpdeFJuglUwMFvCRwRXQtTI9A4A7H1yuTjEuLGaGfNguBy95tCZfC0pl4GxsiEdKIEl
	sQrqPKDMmFG6mBDx+Ox2zh6so08AuYwsX
X-Gm-Gg: ASbGnctNnWo95MGV9cgdLcav1wn2l7RzJgJ7gzOwQIvRsbogH8MbnYjbmE5XBdSRd7G
	SM0JZd/gtvDTl/jCCnwzysmzdpmbJ45vKopDQVUP8lOVJpp06mIN5u8QsGouxvA92sbjt
X-Google-Smtp-Source: AGHT+IEqY9A3/CxO/nN0iN5TLd22QBKUhm+uF75nevTMIfY0t+1CqbNje/rwT1Wsfs4L7U1acddnicJ1rFUabPSTwdo=
X-Received: by 2002:a05:6512:3b90:b0:545:60b:f385 with SMTP id
 2adb3069b0e04-5451811958emr2819287e87.29.1739484208542; Thu, 13 Feb 2025
 14:03:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 13 Feb 2025 16:03:17 -0600
X-Gm-Features: AWEUYZm-ltwjx4ptEaNmMqX3T-q4GvUhwJ5ipYKizDCGdUr2j7ePhaJkMQPQs_8
Message-ID: <CAH2r5mshVYtTXJLFTy=0pHj_Lk=8g1dLkSKnLjNASxy+pn97WQ@mail.gmail.com>
Subject: [ANNOUNCE] cifs-utils release 7.2
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, Bharath S M <bharathsm@microsoft.com>, 
	Ritvik Budhiraja <budhirajaritviksmb@gmail.com>, 
	Henrique Carvalho <henrique.carvalho@suse.com>, Pavel Shilovsky <piastryyy@gmail.com>, 
	=?UTF-8?Q?Pavel_Filipensk=C3=BD?= <pfilipensky@samba.org>, 
	Thiago Becker <tbecker@redhat.com>, Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

A new update, version 7.2, of cifs-utils has been released today,
bringing various security enhancements, including support for password
rotation, and better support for credential management and namespaces
and various improvements to documentation.

Links:

webpage: https://wiki.samba.org/index.php/LinuxCIFS_utils
tarball: https://download.samba.org/pub/linux-cifs/cifs-utils/
git: git://git.samba.org/cifs-utils.git
gitweb: http://git.samba.org/?p=3Dcifs-utils.git;a=3Dsummary

Detailed list of changes since version 7.1 was released:

Bharath SM (1):
      cifs-utils: Skip TGT check if valid service ticket is already availab=
le

Henrique Carvalho (3):
      docs: update actimeo description
      docs: add max_cached_dirs description
      docs: add esize description

Meetakshi Setiya (4):
      cifs-utils: support and document password2 mount option
      use enums to check password or password2 in set_password,
get_password_from_file and minor documentation additions
      Fix compiler warnings in mount.cifs
      Do not pass passwords with sec=3Dnone and sec=3Dkrb5

Pavel Filipensk=C3=BD (1):
      smbinfo: add bash completion support for filestreaminfo, keys, gettco=
ninfo

Pavel Shilovsky (1):
      cifs-utils: bump version to 7.2

Ritvik Budhiraja (2):
      CIFS.upcall to accomodate new namespace mount opt
      cifs-utils: add documentation for upcall_target

Steve French (2):
      cifs-utils: avoid using mktemp when updating mtab
      getcifsacl: fix return code check for getting full ACL

Thiago Becker (2):
      cifscreds: use continue instead of break when matching commands
      cifscreds: allow user to set the key's timeout

Thomas Petazzoni (2):
      configure.ac: libtalloc is now mandatory
      cldap_ping.c: add missing <sys/types.h> include

--=20
Thanks,

Steve
