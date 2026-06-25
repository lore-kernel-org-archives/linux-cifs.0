Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B64F36F916
	for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 21:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782422919; cv=pass; b=X1Kc6APgXrD1xJek8pXWT2jt2nxwsLDB0ZtWxPEQkW7EUxXDXNbi1nx3OAxJoJKekcw+jkA7P56L9p9OM76CWSxlHU4mCVvpN9RLOjMTQViClWhfRCDYrvkYa+euzKFCb/BPVKnoPA5tftouDt1WP/bERMKSu5qBS1hHKiEHUTg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782422919; c=relaxed/simple;
	bh=QCWnBWpNo2TezemxWK6hszdTjxbLoCZBX6dnE1HiQ28=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=H7LfZhmEA4fPEZug5/sYqiYGjrUJQ60pMHdSwR4FM0lsOgiUk8SbiQKNyj4X4Vc75ZimjV7etnQgR2vx8as3f7ml6J7dRhL8nF1lONKsSHMIJhhE/rjQtBlfoMURRIZ8gA1QAvf+WW7wcVZ+K5rvkWJdg25YK07dgOAGHVRGVwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hmjtrPIZ; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hmjtrPIZ"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8e5be46f663so2632316d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 14:28:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782422917; cv=none;
        d=google.com; s=arc-20260327;
        b=QRLAV00OqzwM4ojTc4Ji1+WNWs3zkkelWfonvqEPqXk86tsELo3WD4FEW5K2dEaeb4
         6wPMVHVNCIwUhrO9/IxITgTog1cC97Yh0QPv6c9oHWd1x+TEqcoS+BH0dT3G67pMjFym
         L2oCmmGp3ozjApohmMCMHLNhUy7SzXjDbzM09x4cKSqWPaGNJMOsgTdhCp9tuGWR4a/g
         vr/QfooSSfFXH+8YyWj58UTDbMe70gNe/6uBDUe09mZp5yfgVpoDULm8i/H+VDAoHhlX
         kXrdUzsbdW7HN0qUOBOXtN4L/lH2g06Tq/BIwNoOiUdKRH07tsxxiDWMyTsZfRIwqzpO
         cyVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=QjthfDjwS/ARLjnFtAiUpFoaSpXp18C9kLBceUz66rQ=;
        fh=Nf1mvuQ9XbZKOmPhacDz1X5aHl0t82a+aHbY+2n4zlg=;
        b=lYXYFMOe+HCawmAR0sqy9rY7n8c1HpR05Fpeirwcyg731QJ22o8uZKvrInLz1VE9qj
         7slPVoqvZmoHv+v5tXESStj7SSW0SSOnF76rxPeSF7uhUGeQG3EaM+5diDgJc7Sm6Nbw
         a/IgVes0ECpodCsY/ah3KwiVzrLlYPdoILmtgMqZL8wF7n3NyRpuIvXsCBRS1b4hOHT6
         nE78Xlcm637ThImFT7cAvMKFAArJDf3MWnEjZJzXQ0qovX0ntAxLcm8NWNM7v8qZklAI
         jzkmoTci5ur9jCvV9VfSlK8BK6bO3TT4mFSRU+nlTmR6hE8v52e/1FzsZhVmWeiIJTzt
         lxHg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782422917; x=1783027717; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QjthfDjwS/ARLjnFtAiUpFoaSpXp18C9kLBceUz66rQ=;
        b=hmjtrPIZ9Vj9+8r4nbfa58qIvgIF92KWxJWBJbahGEu0upjs1n3jzKt0Qy2UJBCVsW
         uDJgO9xrDhKILfmgrPR2db76I2zXoL240wYYiuqLrbqRaXsElc4iNQheli85O8LJ95M2
         KxxeEnLsLud7QxLK4fU/uQcZSC9aGNov9NLdLlrwBbz/enX+eLt2Udfg4Qfj8mOWRNbl
         mY06ti+C4jqgky79rIgRRLCm4xmzNttJLZxoCGUN69u6UDUeSYCRekQolf573X0r3Lcq
         rEC9yRufiaduE67aDTVp6fDoyIjxT61zVHV4LEqt32RlaU7sbKeUZ8/RoqJJxaGVfzNs
         xglQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782422917; x=1783027717;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QjthfDjwS/ARLjnFtAiUpFoaSpXp18C9kLBceUz66rQ=;
        b=YFwTjuT4NPWDlLoshSQMHFLiSUYMo1srsSHLcSdcpk04dig3AtINTX1/cJgNeCu0c2
         H8XuDQiFKGL5M2qxx84kBx7/ioxb55d0C3O7c9h/KBa3ppqy9T2FozWFL1WeXwRYkC5N
         sVNn9KX8hEuSs9ynnb6Ep7yVoEZfTqzvvRnlLr0WANqrRhcN2AkJTjLBROiDE/6Q1X3s
         9MP2mkZLaQXc5CKHoKydW4ifylv69FI/Rav2GAs0rptSQ6TBvmYYFCQm/LZJFLEGxFif
         2Z802QvsQg+PpwcoA/GE01FTOgH7vyVoAe44qIgVoQSrJZ3mP2FcCv3NKjiPqndDCAEO
         9KoQ==
X-Gm-Message-State: AOJu0Yzu/0DbxgzoiJw3urxNncPRRb4QYeB44V93HBOiS8Zm0OAaXYto
	ve19jJ9AKS1SlrTNOwNXCnD2ZPXn6C4zJVstigDIRtVJBJiSrD1SbdJCMIc9Ia7ln205HqCJQji
	ovN7x5sioFsLAktVMeRYJnRJ9OMmzaIijn4C87Ew=
X-Gm-Gg: AfdE7cmij8PBwjq79LYQ32nP0hca7PVnRESACJ1fokLlsHLISCIaruE8JEJWGxZriX7
	ehG0L6LJKiA570XXjH8NgXNeavnx3Aj61lBJVeIdoIov/K49HEQ58JBJVIEW7PhpSLmIG4hSp8a
	/o5ppT8P72tXtKNWEXVbN5nLnlnS02rc+CzpkNBa1HHRVlVEiXCuaL4Dnk5s6dgRlDj/Rbq/tZO
	9DOPdvz4RYuoToN+yHVms32VmOL2INA1SznonZ17AXCCbGH6wGXBiTwDksEBVYc58kLhdlWKNsN
	T/fa1ZYa+l1fqhGid4OnE922Q8zlZqLfErsXJgWbaSXCzGA1HobrO8232lGcFS7HAQiommsbRcy
	IBldsuRlP0oqXQAJZHg3jDvhTC2daBtE/5Qlt7r63C7ajHruo19wRYuP06yYYTPOE52/lg0SC4o
	d8MWuIA575
X-Received: by 2002:a05:6214:5403:b0:8e6:1176:91c7 with SMTP id
 6a1803df08f44-8e6d687a398mr82410746d6.16.1782422917255; Thu, 25 Jun 2026
 14:28:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 25 Jun 2026 16:28:26 -0500
X-Gm-Features: AVVi8Cc87-li1KiIvfCD1sE72ARFLhkBnNBtuQA3sKUJi4mJNXSFIyF2rTRSisk
Message-ID: <CAH2r5mvMvo-Lmj+XHHpnGm6_iiJTW=e1N_f+uuFUpN_=3omycA@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
dac3b26eae7bee261fa05f20c3fcc24988a7c233:

  Merge tag 'v7.2-rc-part1-ksmbd-fixes' of git://git.samba.org/ksmbd
(2026-06-18 09:21:50 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc-part2-smb3-client-fixes

for you to fetch changes up to f53208233b2acaafe2af99c63c02481b2f5bcb39:

  cifs: define variable sized buffer for querydir responses
(2026-06-24 16:49:02 -0500)

----------------------------------------------------------------
17 smb3 client fixes
- fix seven potential double frees
- fix potential memory leak in receiving compound response
- querydir improvement
- fix chown with smb311 posix extensions
- two set ACL fixes
- minor debug improvement and cleanup
- add some missing protocol defines
- two sparse file fixes
----------------------------------------------------------------
Fredric Cover (1):
      smb/client: use %pe to print error pointer

Haoxiang Li (1):
      smb: client: Fix next buffer leak in receive_encrypted_standard()

Henrique Carvalho (6):
      smb: client: fix double-free in SMB2_open() replay
      smb: client: fix double-free in SMB2_ioctl() replay
      smb: client: fix double-free in SMB2_close() replay
      smb: client: fix query_info() replay double-free
      smb: client: fix change notify replay double-free
      smb: client: fix query directory replay double-free

Huiwen He (3):
      smb/client: name the default fallocate mode
      smb/client: preserve errors from smb2_set_sparse()
      smb/client: do not account EOF extension as allocation

Ralph Boehme (3):
      smb: client: refactor ACL setting control flow in id_mode_to_cifs_acl()
      smb/client: fix security flag calculation when setting security
descriptors
      smb/client: fix chown/chgrp with SMB3 POSIX Extensions

Shyam Prasad N (1):
      cifs: define variable sized buffer for querydir responses

Steve French (1):
      smb common: add missing AAPL defines

Zhao Zhang (1):
      smb: client: fix double-free in SMB2_flush() replay

 fs/smb/client/cifsacl.c  | 38 ++++++++++++++++++++++++++------------
 fs/smb/client/cifsglob.h |  2 ++
 fs/smb/client/connect.c  |  4 ++--
 fs/smb/client/file.c     |  2 ++
 fs/smb/client/inode.c    | 16 ++++++++++++----
 fs/smb/client/readdir.c  |  2 ++
 fs/smb/client/smb2ops.c  | 42 ++++++++++++++++++++++--------------------
 fs/smb/client/smb2pdu.c  | 28 +++++++++++++++++++++++++---
 fs/smb/common/smb2pdu.h  | 24 ++++++++++++++++++++++++
 9 files changed, 117 insertions(+), 41 deletions(-)


-- 
Thanks,

Steve
