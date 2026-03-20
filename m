Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F502D0600
	for <linux-cifs@vger.kernel.org>; Fri, 20 Mar 2026 04:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773982724; cv=pass; b=aKrenv8jCOCKtZHlJsVwFYuwi5b2120CiOLBuXzrE6Jzjx9EnmJndODrlk1MMG4c8Bip+gsfHaVUQ4hSAWtaSOTZxDCxWHJlJ64ZSE87EyRUZAIZiguE88qVbXSwI0hjZxtK0npJqvD8xOeWFlFrVD94t6pul/AEgispiLguPvw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773982724; c=relaxed/simple;
	bh=goQ+qYaUJJh+vv0Oz1W8hcbECrepwg+9ksSZjY0naHQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=kxDvggX5oAwpmlTvyAAv6QhcsmdG4OpR+JNWL2juYCZsTfPm/FdR+c++TUtFwg7aENUuO52NkHnEQXf2UYGrZO9O3mJbxmF9QAtasgRjvI0rAuBcLKTGg3sJg6OywvFiteXvYOgmzuCPZWmMTxL9gxebKGsEcUwuW0XXxDKT7+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mmC4wtlp; arc=pass smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mmC4wtlp"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8cd8c6e365eso24144185a.0
        for <linux-cifs@vger.kernel.org>; Thu, 19 Mar 2026 21:58:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773982722; cv=none;
        d=google.com; s=arc-20240605;
        b=UaYltGtoDQEmiwHo55rDrnU241kcBlKrF7moPny+rgCrwLkkT8XDyI/284zUOLO8kb
         uvUYF8z4IPlwgsRLwTT64geWE9EIaoyuNXRVmTo53NzO4EjbZrGki6guvz54Zpv6B0Wm
         JAkN4OzO0nH6cNUBFwU6cB5Qn9cOQvC7RTPQ3fCHyJa71+1Y9UlI2+iadYH073WUK2Q0
         1DUgzblal0ySUu/XZMbrc8dRXwJce5124EM/PjjmlE+PKr5aCVYyHOhbuwUdgwc/R1FI
         MqhJdnuStOp814VHFaW2959Y5TZwmL2hZsWlF6AmrCd6eYHH+p9oJZzvtew1lKE4OBwK
         E63g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=8OSVN6K4hFEwqMqxEQ7IZ/7YCBhBbzbvWZf14lTZG2M=;
        fh=mUj9/8/ONcVXM/2X2JWJb5YmQ/F3PqgL73VUDSll2vQ=;
        b=Tvm5omKbL9ensctwjd5XWdlLZVLWnglwXyn5pYAq72xVpoUne+RxW0/FVySrbr4buE
         jswbLfIw+u/tlHfyvKBa0CnoMXSk/yj987mP08pAhiB+x6RPs7xJ9ouZiYO4XOxCqQEY
         /4JbNHlak+Y9JDy5qGVIsMxmdzwqidfkMFVDSWHedtIJtbT+W9uOcztFjsafYA9Felpx
         uLk+Jago7CNCKaHmQaDLh1d86bAy1qgCiTOBIB34sjk4Qeb4P3JKgd0NHRQmhp6L9RRw
         FneYy2O1cSQRNpTdht8x47sIDrfDdOsIY9YC8v1xz7s8suBZxaq0MQxCW3fmQ1UyibAv
         cplw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773982722; x=1774587522; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8OSVN6K4hFEwqMqxEQ7IZ/7YCBhBbzbvWZf14lTZG2M=;
        b=mmC4wtlpm8fw0I7ERW915S0myBxzzRMAK5xHgT/fcdGQJWRVqmLVOZupHoF3YKxwqT
         VznYFNza7udeAnUbWZV0Fe43Loc09o7cXXLETOnbl2R763D76IKQcAV+RK8PwtcaQk6a
         yViz/o2AbGtL/Imnh7kmAwjS+scivXpaqRLTAz2u87lSi5Qf28FSQnqtsFX5q+w2RCJi
         DfX6sbh4ib5IF41o4fwe00liSF7PohmNYsk3w7GrD3A1xii6zLzSasFr5SzYeKMCUXLk
         eLly7DLsdnSNP0OSGVHPGPpLex0A+5m8zVqfRMhV5ArmAuAOjJOzBu6KNxFN5i09rKri
         CtcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773982722; x=1774587522;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8OSVN6K4hFEwqMqxEQ7IZ/7YCBhBbzbvWZf14lTZG2M=;
        b=aJPAYu7pjxGON7xsKHgO9GEo7oEV1wi5GqoCFijhOG3Tvo+h+MMiqQF35oUnmGNvbc
         yT1K0wce4VBuWT8ba2eF7xaamrUPcz38UZdg+g+FBnOyPfv9AL+JqubrovzHdXwqtJZ0
         xWrDj27USg0J87IyTA7azXeIpIfX2Q3a82mKrF8EW1PAg44Ik7a4I8JfRX/zPeIuOjTM
         u6NDSkJiX69dIBd760BKf71EQWCLWj6ig/UDw2gxR3HC2ALalGwcJnzFuuROfmpXiB4j
         llThKGJSIKZ3kPXjz8ANE8JM7D2wDFWkb+cMgicVdPqOZmTmQCFRqse2QN2DLc8H7a71
         6I0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVNwpkDWje4iuoc9sceIuB5mAzCJ5BuctUUFa33F83EyjsKrIvSS6EmygyIp6hsFoDvcavPQrKCkSC9@vger.kernel.org
X-Gm-Message-State: AOJu0YxalIIgTgNSKhpoq6/51tkVNtM5r8fs3MTqgCOO2PEVgjoJM5kd
	eIPHWYM9/iNraoOxq4Scnq4NSTbt8OTcSa6MseN3/7BIGLUW+cy762Gvfp+gIcrV3oj5Q6dCwzo
	deFRgKIxc4Y4+yA+Bm1OarBYtBzwotSYygRYy
X-Gm-Gg: ATEYQzyFFjQL2v2uk7QGJ2RwE/mb8Niao+UM+h9Ecmm6CtO3hHh5AlWQowluesTiWz8
	Ey5EGBYu+3uyf1aXc1BJ3hZeEGE+5zx6XM44NipnhgVRuROm/Mk9D0eHvC+9vQhA63MJt7sYQGh
	3RL4eRdsOa/k+d91k2BcFuNznmswMWPkkLIqaDBU1jb6k7vfC6E7L9eIQMMmGutwWSoMU5p0mNd
	iMUYNGIRdmZP8llHRaDrnyPb+huk7SIc0KwM9kMfbR3SzpbxTjM2b7u6HCb3dF5NYE6K3kD1vrE
	Wjh1tJAlwRApQkpRy4XPaxo4JJWZ9qEjHIeMUZIDnQs2lOV2UB5BOhEVDFhyBLI96BAWeSVTaI8
	5J1e3ulqmS2mQqxU+Ub60axuqgyvgKeeXKgGT4hxSnKnyxN10IuSK8vNgKNn93xigF4KBpGWrr4
	LqdUXKeGoOmnKWvtVHpUUVOQ==
X-Received: by 2002:a05:620a:4002:b0:8cd:e189:535b with SMTP id
 af79cd13be357-8cfc7ee8502mr267473385a.31.1773982722225; Thu, 19 Mar 2026
 21:58:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 19 Mar 2026 23:58:31 -0500
X-Gm-Features: AaiRm51mrHA2APOrBOWXZGtfVcVLMCxK0FROWTPpbNBvKlM5otVr-bilRsvrWZU
Message-ID: <CAH2r5mt6RqqfE1sS=AEROe1O8DuLRhDs+HZ2vP=nymR7CvkTMQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
f338e77383789c0cae23ca3d48adcc5e9e137e3c:

  Linux 7.0-rc4 (2026-03-15 13:52:05 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.0-rc4-ksmbd-server-fixes

for you to fetch changes up to b425e4d0eb321a1116ddbf39636333181675d8f4:

  ksmbd: fix use-after-free in durable v2 replay of active file
handles (2026-03-17 21:45:29 -0500)

----------------------------------------------------------------
Five server fixes
- Three use after free fixes (in close, in compounded ops, and in tree
disconnect)
- Multichannel fix
- return proper volume identifier (superblock uuid if available) in
FS_OBJECT_ID queries
----------------------------------------------------------------
Hyunwoo Kim (2):
      ksmbd: fix use-after-free of share_conf in compound request
      ksmbd: fix use-after-free in durable v2 replay of active file handles

Namjae Jeon (2):
      ksmbd: unset conn->binding on failed binding request
      ksmbd: use volume UUID in FS_OBJECT_ID_INFORMATION

Nicholas Carlini (1):
      ksmbd: fix share_conf UAF in tree_conn disconnect

 fs/smb/server/mgmt/tree_connect.c |  9 ++++++---
 fs/smb/server/smb2pdu.c           | 17 ++++++++++++-----
 2 files changed, 18 insertions(+), 8 deletions(-)

-- 
Thanks,

Steve
