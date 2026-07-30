Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C420246F4A0
	for <linux-cifs@vger.kernel.org>; Thu, 30 Jul 2026 23:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785453108; cv=pass; b=mYUqlx9BrigXtacH67ZuqR4IxDl4Uym6nBPBhqnTxWn7lU2lYB74RlO1RLePwv25eLlXxuMCB1eYsrt4GdV1r3os9EM4AhJkbgTk3QxfQQKv6b4lU/abciS9FWcJd6CT6U8rHwNTLiXzWYJZTl91MJASXd2ss+UfYhrGQvGgYB0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785453108; c=relaxed/simple;
	bh=bSqU/dXoTHTMlyhXvP2JatwhpAVeJ9qndgstzv85e1Y=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=hldOqtE2E7N+AgAhZgOua8gazSq2CepxX5B68CL6pYvSoX4+LZE/F5IXMO0U40g0M6btyT1ICEQY1Lj08CwR03K4/xz/QAjPz7w0dxmmU4/EZl0afgOU3vlqZXI1hXvzky1OStfP2jDA5cqWfei+XeeW6H4oVMOYk1OyyVeg9O0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=miB9qtT8; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="miB9qtT8"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-529a1ee0e62so1842621cf.2
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jul 2026 16:11:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785453105; cv=none;
        d=google.com; s=arc-20260327;
        b=RSWhDEVWCM9o+iTuMT64IMYePtNHEyxW5RPyLqtyzOuF6bLreZh2WbAWU4yqPuXhCY
         NtW0GdUbMHYVZJ2Oiqxzp3W/kLaYAxtIf9cK9lp6W+HxqynhK0psvKE+30ua51tHuUff
         l8mstcjc+4ndjeYu/jwz0Zk1V6235b4vs2Ke6uN8lwhlXnR6b7lkxwQwBwQyzkUjWtIM
         WCNKpBHGc3IUAxjnFFtY0XnnwAlCVhQ011p2w6WvpYaHJ8iN1SeAGe/t91WWzswAzoX3
         6S8GtWOeu0Jm7TVCPDDJBYK9ULM+HCsHHLrVrheoM+ffyrmKgDTwL2SikbC1iBxN0WTO
         Hx3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=xHCZlqOBHhADTSbQPixB9XxeeskHRQmallahj6f8+Qk=;
        fh=ArnBIT3WOtRI3yUJ0D/UgzXDXRK0DQJhFwoWBXcuzlM=;
        b=HDe9bgGGR8GhGoUZ5Xbhjc0v/YMZqcW1OzUjMSPQ/Hh+wtKi1UcQvezB7I26bI+MJM
         2MpZAZfxpvJwEU10K+H+sghGWx8QSWAeMC/Xog/APWLrUf/EZ5mfqrievbpEGXbY6Yxv
         Sf7fFeS+Ry09bm+ih7cKWi+xgWmFKCvYFMDsExDo/jYGR3cKslgCnCbL10dgc2HJLKwK
         JHswZs5da+aYnpWj6c2i3aQ5DNIXhtz9mSDExcTotu46FkfS1tck/lKxkAEjP1ie2Y54
         rWBqPsMHYbadajlZ/ENi26SXCOW8xszCptTD3bqwZTpD9I1o7t+kr72zj5VrjUV/vpYZ
         ho3A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785453105; x=1786057905; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xHCZlqOBHhADTSbQPixB9XxeeskHRQmallahj6f8+Qk=;
        b=miB9qtT8IaXq+R5FZVx5Wg4UtqznLDJ2+LEPNXQAiMAX/tAhXtumf/G/75P6/tPg2Z
         GMlCcVQf9qaaNMWLKIDzVjM5MG67EJberU2RQ9TTHa0LVuEYBl0bj8FALpmQ03JN7iPc
         ll7P13WQlhy3S2NvAFtKPQVF9RNvoADlSEupGJErmrec4fOrmJ0sVbbaMqWb4EIKljLz
         Nsbx8i5PmDDqFEX57gG2AHAiuEtNeM08eYEVp/sxeRboNEmAeOpoBbWxAaZO7QJ745G6
         PHY+wd4RXWa/urS0Abdo39ki62GZB6F4jaymqaYIcrY8GiMAWRh6JjdMUJrdzMWXLhz6
         MOog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785453105; x=1786057905;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=xHCZlqOBHhADTSbQPixB9XxeeskHRQmallahj6f8+Qk=;
        b=NhyK/4ZmZ4etODL7LNJnJbQ2WJBiGKdcaQN7R4iXRbIvpVvGpE5r8+JYDavZekJL8f
         5YUyNCLqOhaM/AlJg+eEYfHBExF+ZbJzy0Nf6boA0gGSevdtzxP7GPRfnaFcc+DeBS4e
         WwBgAvRNmFLOXDf0FJvpSAXVCTCg79BN8XOIFnC+libaVOFLPYE8IK0dEJUMnVFijFbg
         Cfs+oWR0jMSgwtjLBhSM6OrvaHKPjATDHnau9RP1rMk/Wc7y2RK4ni5PtxJgZinLknKV
         R7ZgqoUTuCs45jzbcm7PH+FvIYOCDHpx+LsBYlZLomzk1tfsFkw7ke3McPKrtbehwHSg
         u5Fg==
X-Forwarded-Encrypted: i=1; AHgh+RphpIsvuBWxn5t9s+DI9xmWPLiOa/r4R4DmMbsH9t/9YSbBeieNOQlCC6B4SUQ1JBmxErE0VhjTRWBB@vger.kernel.org
X-Gm-Message-State: AOJu0YygFN3dIQcdWKN7wB6g6v0yNjTsEIEzyvbtZD3KoIoCDmQ/pqTu
	ilLKhd/tsfZ0oR7RAHk3TTrcxfTwHgXawqVnktXy5FsBuCfpJto5K0qOqY/5Q2MBcRmLawaFLRJ
	P3pXP+VV/Pgh5IqTgHvkvwysytCe8qu4=
X-Gm-Gg: AR+sD10Gj1BIEFBnx6lTkaTJ6oZK/ka02dTpC0n2dvG4x8ry8RZ6/i105+xiHlQMmc5
	NNRjepeAEtvDCgagoylEdZgec05UV91RxdlWK8p7oEHK5tPsAFdZMnFk8/8O2Dgzc8VaVTxM4qU
	/pGmqpytGG6HXWgDrVHqfHghjUOMhYhhs7sDQOoYa5BQSR9vYBTuTWX9iVrKuU+DQGZL4fLcs/b
	/Ank0uK8uPf80nkrW76gspb+9/RoBwQql9QGeDTOhL4gtg2/gCJtl6newupVnJSyTglzAke5Bt5
	OX2jJcJfPY8tS/AmiXQBYt7IbZAoConkq83K1ntPaQ2wPZ56Eqjv9hqMZZvLf19/tucb8pmZueg
	ZdGb7npb+49eprcX/tiyrfpXEsRheHOcfmJhVrdY7AGRtJaUHkBANw7vmxtuVYjYZw9CwAEZlJp
	GncjDWVZR4N5InD+isH3TVPJhwM3kWXS9ckqi6UEzKTXHmrgm81hx2Uo3cCms=
X-Received: by 2002:a05:622a:40a:b0:51b:fdbc:86ce with SMTP id
 d75a77b69052e-52b38673fbamr50375331cf.52.1785453105246; Thu, 30 Jul 2026
 16:11:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 30 Jul 2026 18:11:34 -0500
X-Gm-Features: AUfX_myT67oDftcj157MKT1qPE61R0HOjtokkd8xLhKRyuPPbRsKvqeQV8iqV0I
Message-ID: <CAH2r5ms9nKwhH4uv0C0wKvmcu4F3AoPzvmGw8Xqr_pk2U9bUfg@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
f5098b6bae761e346ebcd9da7f95622c04733cff:

  Linux 7.2-rc5 (2026-07-26 14:45:48 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc5-smb3-client-fixes

for you to fetch changes up to fa724e235cfdb0fb0bb427d0f9dfe864ae27403e:

  cifs: add fscache_resize_cookie() to cifs_setsize() (2026-07-27
20:46:03 -0500)

----------------------------------------------------------------
Nine client fixes
- fix SMB1 read and write potential buffer leaks
- netfs error handling fix
- fix check for last write time in truncate and setattr and cleanup
use of smb_store_release()
- fscache fix and fscache cleanup
- validate idmap key payload length
- minor SMB1 error mapping cleanup
- witness protocol memory allocation fix

----------------------------------------------------------------
Dawei Feng (1):
      smb: client: fix buffer leaks in SMB1 read and write

Dmitry Antipov (1):
      smb: client: simplify cifs_fscache_get_super_cookie()

Frank Sorenson (3):
      cifs: consolidate time_last_write stamp into _cifsFileInfo_put()
      cifs: fix time_last_write stamp placement in setattr/truncate paths
      cifs: add fscache_resize_cookie() to cifs_setsize()

Fredric Cover (1):
      smb: client: use GFP_KERNEL for registry allocation

Li Qiang (1):
      cifs: validate idmap key payload length

Sang-Heon Jeon (1):
      smb: client: remove conditional return with no effect

Yichong Chen (1):
      smb: client: free partially allocated transform folio queue

 fs/smb/client/cifs_swn.c     |  6 +++---
 fs/smb/client/cifsacl.c      |  3 +++
 fs/smb/client/cifssmb.c      | 12 ++++++++---
 fs/smb/client/file.c         | 37 ++++++++++++++------------------
 fs/smb/client/fscache.c      |  6 +-----
 fs/smb/client/inode.c        | 27 +++++++++++++++++++----
 fs/smb/client/misc.c         | 51 ++++++--------------------------------------
 fs/smb/client/smb1maperror.c |  6 +-----
 fs/smb/client/smb2ops.c      |  2 +-
 9 files changed, 63 insertions(+), 87 deletions(-)


-- 
Thanks,

Steve
