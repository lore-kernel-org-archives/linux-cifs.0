Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1027018E351;
	Tue, 20 Aug 2024 23:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724198052; cv=none; b=emtoLEgKKuP+LDYX0JMGJr77gFGgT9M+GVFwzgzuKeslV9GZcVQ9YZ07IoKsJsosli579ORdP0pLJ0FKxRxLph7cmvZOEVZN2TPRSsfQ0kFNwHsFvK3Pdx6nkvnUGzxZLW4Ns2btJGrYiQ/hw4GCG15jVGjT6H1zyqNNi3nM8F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724198052; c=relaxed/simple;
	bh=QXFsA2ese4UeztseI2NxElCttL1AJluhksHoDB13WgY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=JkD4Tn4Nzv66nSCcB6z5N2zKowGVrsdI5m+5m3PeXULs9wakUnNbKH3d3fZH+Ly6UHMnquEzPCzKQZZ2/luljjSjlujq07CnT6pEXHor/IHKzpHSCTlvnaaevhab3pWikvYlB2cXqgWYIq+B9+sVCQKfzvZoM9QSQLhEGbwePvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F+080BMF; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F+080BMF"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a83856c6f51so340480766b.2;
        Tue, 20 Aug 2024 16:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724198049; x=1724802849; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=onaRW0YBMxMVv5h/71vLiCbfnDDOZOWnr0/UgnMghMA=;
        b=F+080BMFpp0DsZYah3WuP0AIpvlT6p6ExD2XbPri2gdEBgyyWU/izjQeS/59c7fX/Q
         fDTtGGbKKFfF2LXAvSrPmHtCd23BdNJI0OGg30DTx2BwQeg93aBJxSt6fbbP6BgDTabL
         4qhxQISTi3BEpk60ota9N2yQtfbhgQnUAVAzJi57BBg//5Nm4oh9qzlH4IOGSBiKhHmI
         mgmDRKa13jzmHRggdUiReWPW6SqysIXpOvwaNUIYDFwC99GPdQ3eWI81CrttmdEScczL
         RsFxmhfJ/3ibz3I1ta+0EogMeuRbD2DbjKpTp/Sj2aF18uUXRWRo9p0To6J/rp38GjT+
         guLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724198049; x=1724802849;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=onaRW0YBMxMVv5h/71vLiCbfnDDOZOWnr0/UgnMghMA=;
        b=m+nXoaBrM01V+jPdEWHHmPac72icaMlgPV/rPxgA65RJo0F7tRW/uDgeJaI3SPVJ4A
         Adnkin1RO1K3cejZPVCugeOJOdlAfDGsFEZXrkXswm4QzTB85NpHkviJE7JMC2BMhe1u
         2AlFy0iVtxdid3JPXrjAbuUgiZ09o6mKuOmjIY7hps9vdeHkOn7gls2uzkqdjWAsau/A
         7biREauKWNHVD3k/dpyYVWOk+L4VUzy6qlf4R4yLawimWsGGCW5b/l7N7s/FQDL627ta
         u2NW/BXaC35uXooa7791nCf0UYwvWO4XN8N3Cwg+YwRvwyz047PMBOE1bhaR6PYI3bnw
         ZH/g==
X-Forwarded-Encrypted: i=1; AJvYcCXj4tl9zLCHYcRiwmBTgGTdQU3TEdlO6iZr5HyUwoOyPrwkLyb9tLDptmri9UaCMc8gN867tn2dUX9k@vger.kernel.org
X-Gm-Message-State: AOJu0YzT0dI1tK3on6brQ6lbIYy+7QdnGE2AxgSI0Yzl7rBc1G9JPcGi
	CKvOhQL5Q3QNGdQ7hrDcxWBnvzGepsP2NTa23emtv3ERV/S8mPY7cI+054K2zsjeUR6gKkb+rH4
	Jw0axun2or3kzN45JO0yUXM13ysq0Hp/A
X-Google-Smtp-Source: AGHT+IGWlQHO9IoZtsP7iNdkwEWX0CsjFPXcmW4kSfmtVEDZufNaq3XEjjlrR8s5balEoGYYCREHGTCHwzn5f/BqcJE=
X-Received: by 2002:a05:6402:5253:b0:5be:cd72:377c with SMTP id
 4fb4d7f45d1cf-5bf1f2740bemr421254a12.25.1724198049067; Tue, 20 Aug 2024
 16:54:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 20 Aug 2024 18:53:57 -0500
Message-ID: <CAH2r5muR=S_6jx7KtLofSSY9T3depX6yXNqK7PX3LDiNvZW0hw@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
47ac09b91befbb6a235ab620c32af719f8208399:

  Linux 6.11-rc4 (2024-08-18 13:17:27 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.11-rc4-server-fixes

for you to fetch changes up to 7c525dddbee71880e654ad44f3917787a4f6042c:

  ksmbd: Replace one-element arrays with flexible-array members
(2024-08-18 17:02:36 -0500)

----------------------------------------------------------------
four ksmbd server fixes:
- important reconnect fix
- fix for memcpy issues on mount
- two minor cleanup patches

----------------------------------------------------------------
Namjae Jeon (2):
      ksmbd: Use unsafe_memcpy() for ntlm_negotiate
      ksmbd: fix race condition between destroy_previous_session() and
smb2 operations()

Thorsten Blum (1):
      ksmbd: Replace one-element arrays with flexible-array members

Victor Timofei (1):
      ksmbd: fix spelling mistakes in documentation

 Documentation/filesystems/smb/ksmbd.rst | 26 +++++++++++++-------------
 fs/smb/server/connection.c              | 34 +++++++++++++++++++++++++++++++++-
 fs/smb/server/connection.h              |  3 ++-
 fs/smb/server/mgmt/user_session.c       |  9 +++++++++
 fs/smb/server/smb2pdu.c                 | 13 ++++++++-----
 fs/smb/server/smb_common.h              |  4 ++--
 6 files changed, 67 insertions(+), 22 deletions(-)

-- 
Thanks,

Steve
