Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F94285CAE
	for <linux-cifs@vger.kernel.org>; Thu,  7 May 2026 03:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778126289; cv=pass; b=Am0lSSItT8k7zePV0lN+vGulkidyh3c4LERPh4Nac7v4gKuv2QKKeGF+YXqia2xqkOEwGcnsrgfVz8QEB2bMz03nbdxGHbMu6ZV7v9dEaFW9pSTY5SDYElwXtmGqqdvmTslohGygB4sY6geQxDQ7YLOzaQDL9QTY5eFKhrXH4CE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778126289; c=relaxed/simple;
	bh=S8z5Iiy+wQTWFvfXFASFDX4CTYTW9DfqrMX37iJH70M=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=TW6PQ4ZSJBgktIloQdDeWBCk6rh+X236vdoGzsAL1I0h6X+N7teNOkOIc7gSTA93sHL2TIpOx7wOtJOgK0uzTAafaBPssWveq0dK/yMfEhL6HnnC5u9M8dnbCUKelHkeKOC0YJ6rEG4NOqaoF3L8Q5i1zbpCCXGIMd9UO8FCyaw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=isoGOATG; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="isoGOATG"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8b3fe2f19a4so3786446d6.2
        for <linux-cifs@vger.kernel.org>; Wed, 06 May 2026 20:58:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778126287; cv=none;
        d=google.com; s=arc-20240605;
        b=AYVVi7UlElorh13Ol2+cQGQM4UdENR0KdRm9vDigTzyF0S1jgx/FcehWEX3HQb/P8X
         LM3rpEfxmXKlHBt62c6LOcqDip0BlZ6nIfWF4893uDfMsEvbldspf7W0xBmG66GFKGt8
         RCt/UJIOTZ5nWSjkVgJzAh2+n/lKzm1WKt3AVWvQmmCIFYmkWFqE3dfru0oxnIJ2jkjU
         aGYwxXYXnqJNBeQUeXlPI3pjOXgMiisRQNcwEZBfT1GuYFA9foagvwjf46Xt0gEHB6cR
         zrpSTnv9qhSCEfkN1B5O++XOQJzCYZ46RrWCKYoCOSjLjVJ0yS0FuxNWdNu6Y5GydVaF
         H2PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=yC7dplxGjM3T5ooeAAzgGYkogA9Gd4dsoiU+/exK67Y=;
        fh=ow2GC/8sewopyJM5Jtse94j+6XZYtMLeHi5nICy3//g=;
        b=VXHE5dmtfJGozs7wf0PLAOP+ghGZoHmbRPOWyzbzxEMDBwzpyOFA7qyrnXcaG5VK1d
         6YpzPsMfPA/RtxyMpLSp8r0kr0NGLoywp5S1KpWE+D2117BgvTesuxNYwhirpngHzRoG
         ZAE57Zc5DeiCD3VpZjiUgTLB/icuqgenD1b3tQ0WpLa6luOa2Iky14CilhtTBil2wYqz
         NcQlS9tdCtQxtk1V34J7G97sWcQSF0tTVtAPRyj7KXCu7cJ+uY80cgjpqooS1KcbmSsC
         oQbB6Y6FcYw8rcQwKkt6VWtkMGQGRPDTRb1OwWFhU/jUHjDoLrqRPBU4U3l2diKlwNdu
         Ctcw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778126287; x=1778731087; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yC7dplxGjM3T5ooeAAzgGYkogA9Gd4dsoiU+/exK67Y=;
        b=isoGOATGE7I+DnGiWEPWjJfdF//38Uvi9vUSwI6Stvnye+ROdl10GRzJf+OqJqL4Z/
         saw7L6rr+COZOITXw4RUWlwuAYhsV2Wg1L+otw/6Pl8LEEtugUOxwm1+hXKAj4e57jJs
         C8AGZGhmoR5qzLoEJEHkf6u+BP4ckIHcZ87+Jmrl2OZiikgbv6f6CqFus2m/7nPoUkKK
         DLUxMX3oLcK+n9D1LaCJKGBpt7yEMqJnlo9dqGdOfvyWpOIYmtgg7Fa3+XD8dSEyhNpp
         b09gTNGHv9LuDKA2UIVjIyU4xJVkFpUfFubbG4CHmkJVIuwin2hXp8s4NgnQswyRGEsX
         Lh1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778126287; x=1778731087;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yC7dplxGjM3T5ooeAAzgGYkogA9Gd4dsoiU+/exK67Y=;
        b=j9Nz1WWSj6zbfXrWg6B5k2CMCAGGqSzC8DjSWqTVPLnLiV4uGLUeSMIUNSAm+hUf6z
         ihdMFz9FfvnMgyGZFMFQmD4R+6J9auCRvqNWsu/iVnwqfSga2A33ajmQoGH3kPsWfC41
         8hufitWHOw/tbsqQvT+lStrD50qqcHR0KrhEb049mKd7tDUhc+bWbNdsmkZr0/v7lMx7
         cFL6Pi8fucT/Vf2N/X2BFirHW/48qBtthdAmUGalY9HXB5g+u1De4iba4w8oTvMlsh0p
         kd1kKzhKS/GslFO+RXE7MDW6xHwTqgpy7JYRPIt08qU2O2bBcppZf88WQ4aLa22lpUrH
         PTqw==
X-Forwarded-Encrypted: i=1; AFNElJ87QRYmIsEJmcIn8aylAhLx7o4RRAXhaJ8xSUuhmpxtnZO9Sh2JhWey3yOQIj8A0qeIsRswdoRDmxSQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yyv1cLTzGbb2NvNzkGsZ63gkNgVyMjyVfdoqlywpxEDXtXdMq/4
	tGVgZ8Dl9VHoKe+Bg+CopTTSqt8zciKrekWfdqmRak6ksCz/0KgUCdpcceTT5B9Hab4bFywdIXK
	JmrKcts3QdqBymvpuoQqUCTBw4Tl1bzn5E+Yx9aE=
X-Gm-Gg: AeBDiev+wSJS435SU1BgMdsQadAcnVelN+rhocIPP16FkabM7pk38bODgrK/MgPMd9P
	0IsB+q4B1u+JRJIKOOL7FpqAzqe2FUMlwE/l3k1ZhhEWGHijd28lam0v8Wy4/95aHAaQf1FfrWp
	g7uXjl4BrgapWOYt08W4dxifzfJe0OqPGKmDd3W2eOBfPCxkzbvgzdz186XF2tX1YlupLoqCknR
	cYM/Zn4g9RnMMnbrV50vR8z0rXeokGZh1cA7b7W8JTIO/8vCghRMK1W2jPah00zUbBi4v3MyIME
	btUNTfDbEqzWJCvAIYN85aGVvVxTuDLtUocWWWt6m/drVNRAOLVchrew2MyV0Qg5dFD1BRuF7BG
	8B8VS3gLMSWcq0PS40R1CW2HxH5sN78SYFGggnaC2dimqsJdZiJ9zkh8NYkNDelldchtl3UgoFt
	mTvJABXlCt7fj4uYmylGck+PNB+SU/pxWe
X-Received: by 2002:a05:6214:6003:b0:89c:4985:83e3 with SMTP id
 6a1803df08f44-8bc47867f27mr90145376d6.49.1778126287390; Wed, 06 May 2026
 20:58:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 6 May 2026 22:57:54 -0500
X-Gm-Features: AVHnY4KKvoqBvzWwvuC0pcg3sGF8owg0prcu_kechNHTrWTVGQ-Fb31JWdoB_5Q
Message-ID: <CAH2r5mvUOGk9ajF9PFVOyqmXawktBYr9XE0qXT=kgQAvMjOx3A@mail.gmail.com>
Subject: [GIT PULL] ksmbd server and smbdirect fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, "Stefan (metze) Metzmacher" <metze@samba.org>, 
	LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
227c3d546e963874198aafc0cae8c3e8c24ae4ee:

  Merge tag 'v7.1-rc2-ksmbd-server-fixes' of git://git.samba.org/ksmbd
(2026-05-01 12:16:42 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.1-rc3-ksmbd-server-fixes

for you to fetch changes up to 996454bc0da84d5a1dedb1a7861823087e01a7ae:

  ksmbd: validate inherited ACE SID length (2026-05-01 21:49:35 -0500)

----------------------------------------------------------------
Nine ksmbd server fixes
- Fix memory leak in connection free
- Fix inherited ACL ACE validation
- Minor cleanup
- Fix for share config
- Fix durable handle cleanup race
- Fix close_file_table_ids in session teardown
- 3 smbdirect fixes: fix memory region registration, two fix for out
of tree builds

----------------------------------------------------------------
DaeMyung Kang (3):
      ksmbd: centralize ksmbd_conn final release to plug transport leak
      ksmbd: harden file lifetime during session teardown
      ksmbd: close durable scavenger races against m_fp_list lookups

Namjae Jeon (1):
      ksmbd: fix kernel-doc warnings from ksmbd_conn_get/put()

Shota Zaizen (1):
      ksmbd: validate inherited ACE SID length

Shuhao Fu (1):
      ksmbd: fail share config requests when path allocation fails

Stefan Metzmacher (2):
      smb: smbdirect: make use of DEFAULT_SYMBOL_NAMESPACE and EXPORT_SYMBOL_GPL
      smb: smbdirect: introduce and use include/linux/smbdirect.h

Yi Kuo (1):
      smb: smbdirect: fix MR registration for coalesced SG lists

 MAINTAINERS                                        |   1 +
 fs/smb/client/smbdirect.c                          |   3 +-
 fs/smb/client/smbdirect.h                          |   2 +-
 fs/smb/server/connection.c                         | 105 ++++++-
 fs/smb/server/connection.h                         |   6 +
 fs/smb/server/mgmt/share_config.c                  |  12 +-
 fs/smb/server/oplock.c                             |   7 +-
 fs/smb/server/server.c                             |  12 +
 fs/smb/server/smb2pdu.c                            |   6 +-
 fs/smb/server/smbacl.c                             |  66 +++-
 fs/smb/server/transport_rdma.c                     |   3 +-
 fs/smb/server/transport_rdma.h                     |   2 +-
 fs/smb/server/vfs_cache.c                          | 341 +++++++++++++++++----
 fs/smb/server/vfs_cache.h                          |   4 +-
 fs/smb/smbdirect/accept.c                          |   2 +-
 fs/smb/smbdirect/connect.c                         |   4 +-
 fs/smb/smbdirect/connection.c                      |  16 +-
 fs/smb/smbdirect/debug.c                           |   2 +-
 fs/smb/smbdirect/devices.c                         |   2 +-
 fs/smb/smbdirect/internal.h                        |   4 +-
 fs/smb/smbdirect/listen.c                          |   2 +-
 fs/smb/smbdirect/mr.c                              |  27 +-
 fs/smb/smbdirect/rw.c                              |   2 +-
 fs/smb/smbdirect/smbdirect.h                       |  52 ----
 fs/smb/smbdirect/socket.c                          |  20 +-
 .../public.h => include/linux/smbdirect.h          |  52 +++-
 26 files changed, 554 insertions(+), 201 deletions(-)
 delete mode 100644 fs/smb/smbdirect/smbdirect.h
 rename fs/smb/smbdirect/public.h => include/linux/smbdirect.h (76%)

-- 
Thanks,

Steve
