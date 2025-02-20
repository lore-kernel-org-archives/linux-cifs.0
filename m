Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236F91FF60B;
	Thu, 20 Feb 2025 16:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740067748; cv=none; b=rVSaIJrShqqHDYRPmlUJZiPcpunOQ0VEphHCNhzxzv+Fp/KG6m6hUuEmU0nrXu46Yh+ZT0cwuG+DfBeLPeztBkSes8uUR9vkZF8btzA3MMeSsYsGVCoHXOyuFxikdf8I9J21wHbJFktmJv4Dr6JCqyp3YZwgWrJCYIEpWxRAVAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740067748; c=relaxed/simple;
	bh=8FsT86HvHh5IKWimy+L4odU7OmrKTONRAi6Pu0incCQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=amlx2LrdL8jfYUZjnsL10+QU4eeakrkOnLxySpc4bRXcQgL3orhMukknp/iT7OTKOJ8cU0UDZ9r/pqY4dQUkCgHz9l0ADQDs9ybG2loq9WFevCsZgd0ACFZ61nxQMYjZ+jU+bfl1aZGXCEWQ6VoG6rXUbL4BNzb/93mz6Av+wkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Peuju23o; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Peuju23o"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5439e331cceso1235467e87.1;
        Thu, 20 Feb 2025 08:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740067745; x=1740672545; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Y+qWinHwe8YOnxJ5mYsBzaKZSDx0En1bxNRinIyfw6M=;
        b=Peuju23oCZcdBz0CW5Yb4lxfG0vjK5qkr6nqkahiGbuJbDHOFwKpinKuVOed5tKTYr
         bd2v+oVrs/5RRuQSDd5/RbIFSt+jq18fH4DJmI2D+aOmpqWzOpseWB8JJmITjzz/mg1u
         KqFWEE/pWuaHCyvXCDGtRZ5UrE4uWsX1ga7cJXYbjG/Vsjz5afwy5dTmQjkqxWHYVQTc
         5CjQmnmUBJCdAgQ67Vdn4sSasEsaTyV26UZ+R7HthdQK74ZEzi2C8pMFtLUumWm22cMD
         TigLi1UDr9ullndh/8WkdI5lzKbY+paChhUNtYhFyuSqciFRzipRWNHEZf9mrdIhnx7a
         HXGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740067745; x=1740672545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y+qWinHwe8YOnxJ5mYsBzaKZSDx0En1bxNRinIyfw6M=;
        b=rddK4JoFtiFRjfTt+0ZEnPAMJ/fwRgSiwOjbx0577/o3H6SJb/7JDjYry0C3Vu2MhJ
         IyF5tFekLDVuekWmj1ufYm/VGmwlTMPG+PpDNdQJKkGz/48V2Uou9V+mzW0WV3AZc8Vr
         F6FosbdMa/fscLtazuSJW4BZF93v+D0cO3zn7iRoumjgf0dmHUmfxY9sGZikgTXOLGAE
         oQtSOE0C4a4jsGcigUN+Kmv9A8cvXeAFoSC+pPMmGrxOwBqIJps90fexhV8/YbvDC7hc
         Mfmivda96Ct4u3fG1FaI4qKt8lXE/oxMoqgSGMM3S6FbKn7EhtKU9PbvlbsfDYihfx0c
         D0Vg==
X-Forwarded-Encrypted: i=1; AJvYcCWD9HcbsN0tP/dS9oVq1NnzqnaUTJxkbMkCWFHAWAQFGXhjTqnxq518cTrCsVTKKhH7tX9hTv7l77XpKKA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7EYmIyarR500DhgPAr+TJd1vKeJF3k975AHo+y3HGEZ1BBOZp
	yQ4kzmk+yq6YANVggwZ9hGZTmZaCnK8Zgk1+/0/LIgwcotQXO5/BacdL4naj5iqRIXpU8nkm+yQ
	oAvvoNogAE6ZYcDqkCLZwyBvYq/aNsA==
X-Gm-Gg: ASbGncu6n3NlOKHADXzB0dH368r4G4G9rOhdrpvWAR2KR/rfuH16+rIxQ4cAnWjg4kC
	Yrg6yHrhFzujIuKCeYUfXEKJu58w6hQKe3z5cr6dsHRrRJwTadg2R0RncvqIsf1sERdohXA==
X-Google-Smtp-Source: AGHT+IEA4F2+bOnsZQ3R1OjHcJ0h+J5HFHIodoZTHVSSFfy9+j2RJ1mNUTlodpIl+ioD8CjxQsRoFlMfJhTmprnJ19c=
X-Received: by 2002:a05:6512:230a:b0:542:2999:399c with SMTP id
 2adb3069b0e04-5462ef20ef4mr3157161e87.46.1740067744718; Thu, 20 Feb 2025
 08:09:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 20 Feb 2025 10:08:53 -0600
X-Gm-Features: AWEUYZnJ9yZrl0g1agmwubQBDe66G1IBh1bJ5j4BsWun5zFs3hUviCyNldqbDG4
Message-ID: <CAH2r5mu-WXH1irOa5ZiSRnBA4Had9BPaVR_w6ZjSPFFkm=4WXQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pull the following changes since commit
0ad2507d5d93f39619fc42372c347d6006b64319:

  Linux 6.14-rc3 (2025-02-16 14:02:44 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc3-smb3-client-fixes

for you to fetch changes up to b587fd128660d48cd2122f870f720ff8e2b4abb3:

  cifs: Treat unhandled directory name surrogate reparse points as
mount directory nodes (2025-02-19 10:42:27 -0600)

----------------------------------------------------------------
Five SMB client fixes for readonly files
- Fix for chmod regression
- Two reparse point related fixes
- One minor cleanup (for GCC 14 compiles)
- Fix for SMB3.1.1 POSIX Extensions reporting incorrect file type
----------------------------------------------------------------
Gustavo A. R. Silva (1):
      smb: client, common: Avoid multiple
-Wflex-array-member-not-at-end warnings

Pali Roh=C3=A1r (2):
      cifs: Throw -EOPNOTSUPP error on unsupported reparse point type
from parse_reparse_point()
      cifs: Treat unhandled directory name surrogate reparse points as
mount directory nodes

Paulo Alcantara (1):
      smb: client: fix chmod(2) regression with ATTR_READONLY

Steve French (1):
      smb311: failure to open files of length 1040 when mounting with
SMB3.1.1 POSIX extensions

 fs/smb/client/cifsglob.h  |  5 +++--
 fs/smb/client/inode.c     | 17 +++++++++++++++--
 fs/smb/client/reparse.c   |  5 ++---
 fs/smb/client/reparse.h   | 28 ++++++++++++++++++++++------
 fs/smb/client/smb2inode.c |  4 ++++
 fs/smb/client/smb2ops.c   |  3 ++-
 fs/smb/common/smb2pdu.h   | 30 ++++++++++++++++++++----------
 fs/smb/common/smbfsctl.h  |  3 +++
 8 files changed, 71 insertions(+), 24 deletions(-)


--
Thanks,

Steve
