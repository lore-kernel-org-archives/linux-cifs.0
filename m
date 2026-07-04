Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376B325B098
	for <linux-cifs@vger.kernel.org>; Sat,  4 Jul 2026 01:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783128025; cv=pass; b=dO8qTarQpNHXQH1shuTaPJwBHRxFZZ1l3L8hZJh6XJA51vOOFLUw8BjbeJHRT3iyv6UkVS36ESOcFTqZe+9Xo47pFPtoVYiEoSgpUamvlxbL92ouM1XVvHIRP3h1h2kAuscADFnruZ0227w5B3mlBWBITSTVyPKoXfyap3tdduM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783128025; c=relaxed/simple;
	bh=bRX1Y+sRSjQD6w33SiQ2h7rckwmAZPw6ZEMOiJO4MRw=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Cw7oZN2Ji6EppgTd1cu28+MY2I0SAPclJwMfmaiCvsXolTjoAmjZPYV2Jpz4Kua7atxEzKDS8xSrjgey4RYVXpZ0l/5038rW2k3PvTgCNBllRzPq5FFiLXXoJBxvaN0SQJ1FpuWuZIOPV6yoZ/DTS0UpWwhpmx+v2NlS8qbpjbE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Iw8x7ozY; arc=pass smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Iw8x7ozY"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8ea70ca4fc8so8515686d6.1
        for <linux-cifs@vger.kernel.org>; Fri, 03 Jul 2026 18:20:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783128023; cv=none;
        d=google.com; s=arc-20260327;
        b=jzN9jJF2BoLvNd9DMK5kwEH7YYteSjvCqxzXslsSk+cKIoudMx7HP6quW25HKJLOv0
         ggHO3grOLNcRyMD986M79BQmRZpAXWxIqasMyus6GRmYBm2azEWH4jJkMlgkcQMQaQDT
         7kkPlJZ3+KD1ep51Xp9zJP4SmkLIyVr4tru0WlL3LaqxWBWEA6q4R58iA2N06fuTaRtg
         H5Eit+mhhf5ekJHa2BdN0syF61KSb+LFALIzBdtVs6aIQ5w6zEGJPbN3+Nf5qkK2If5U
         Gy+UFS85+PILBhopqK14yGzo9n6TX1Gjt1U449qwJ0MTatOLO5JAd+aResbF/FWdVp11
         1Y7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=UFp9rUcCAoT8X7CfTLttSToyFVHLAabUXidbnhSZFoY=;
        fh=O5F5DSS7l6KckG2deZLvu0zGG6M7msyFmmq4izhV/Zg=;
        b=h0umUblTODKQwaljm8FgK0vFaFeznSk/x0kh2P9Bd2Lyu8m1iCXjTOGL4gGrS+P4qf
         q9nV8p/UvLdoCpgmHeACR9G5me7tnTtpZViW2KfM3TfCPezsCRmD/kSwJpKu9xoHdmr5
         oioYRd3k3SkybQDx0+82GzcTNL1+v5lMTZd7DnR5Q4B+QI4G9/k5TB5MjlkxysnEk7rS
         NJwvMFS7R9ONNt2Bv1BolqDP1dr9Nlpg4Xj0rV6x7db266ArkwpdBRLuhPBNDFD8CsZd
         YS3QOnqkBiPDfPrSkn+fKpF9olADkF8JpBh21qvOHZVZ/OYEvQW3b+DCxHipuM4FA/G3
         rM3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783128023; x=1783732823; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UFp9rUcCAoT8X7CfTLttSToyFVHLAabUXidbnhSZFoY=;
        b=Iw8x7ozYqbEdW4FnnuOvl/o+rt1cYxX5Aw02YhFtp1d8GXixs4Qqps0b3HLsG2fe2v
         3gJa/gME/n5zZKjq8+2CwzCEdhvF/3zJ6REvMWUVW4GaUGfoSshEU3wwF250+HhRRT9A
         iRYsSPjkcW8IzAaiDwcSlZy+fxkkdkGsltoq4t6v4A1smnanR8qUJwC+CexqauxWPsm0
         3kvxmQMPm1cp11fzzzoR9FWn9X426lRrdXkL4XTHrwfRbJ7J2dPGos2RHm/jTQH8tneJ
         hWJx1Rer7hMMUK9ZmpkI/qSznvWT0c4l84wI0b0VGF6MiGtgc4N2EfuTlahNOZzwu0cx
         qkrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783128023; x=1783732823;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UFp9rUcCAoT8X7CfTLttSToyFVHLAabUXidbnhSZFoY=;
        b=QLCIf9pKlOsZ65q3YCnsv8pokNfXCu8uH1SxzG5Sv9LVipjKqDRQiR2R4lGe450Uzp
         L88/6vmSyDvXKs0G4DBHnEAKRqaZsAxtoAJMLjjMUjPtZ+0fhPufZYiHVlOdqr85TPhM
         LzwbjwxZiAcZ+eGi+w2+0NWsVxR5JvERQAlhSlwAwkzOhawggL2Tt7rzMo8N9+bPqPJQ
         SXknKB1+K5mqepH+6ejLkdACK8A/4afbNQ7lor8t9IVmbMhSDkjZ7/0r+H2W0XhBsEe4
         UyZvfwIVCNyHrB8Wh2rBzvsA4uprYPZMJqHevVj6WLCn3/cpLtaXmvZfx0z6qzEmpuVk
         7FBw==
X-Forwarded-Encrypted: i=1; AHgh+RpWf8vaWel5EkLHNThduk+lhCCvfnQlVqsbwSRrpL23R8XKJ/FBzJ4xXd5RZLpi4H8AzQcxM3x2rwuM@vger.kernel.org
X-Gm-Message-State: AOJu0YyBaCKuJL3nc2gZw7b493f+4UYPCNX7xUBAmLqty2aY/CJhM4PW
	eT3h6XQlz2q9jYZjD9k7dwgmQiBwd2HEtDbKW/3vS+3nuhvxIUdycsiZlniNC+oqrAZw5ZzLQEE
	H0LhHAyyDqbgb63epGLS0BtxDr7rhbe28XTglsqg=
X-Gm-Gg: AfdE7cnwEHF8AWItjp7j+gh26AO+ipFhBsDZRQGznTzWHhK6RbU2zj5WqoGNBmzF7DZ
	qI7NkOBeM5JEqBeovVVFy8zrB9nqqZYTJZiNRApPdU57DxqKSANTH7LbS2aku9u3o0RCEVhg20d
	vwGMpjcqFomQQ4f2TkX951CWtKwMC/V81PwWbWRvojxJeVReVeqyq5t8GPxtpCQtx1MDksfbeCg
	YdyrGgqFj0T6afoKpeZDjQSz6MicmotLQxBGmdoxcnY3gk7wzX4WHF+5TLP8bF5U/GBfWdkumeO
	hv0am21HtuniE0RyRqbFWy81jrHePRKAV8oltyvoq1qRPuJNNcxkC0YeL8mttCdAxGfKP6nEdnf
	z25b8ff4oefYTdkxFZIy8LHoXChAZQ3dgjhnat0m99vyClF4CIQ0+ANNW9kLypbSTMP45cvkPCX
	ojsSDj0QV728I=
X-Received: by 2002:a0c:e08a:0:b0:8d0:3950:aa0f with SMTP id
 6a1803df08f44-8f5bdffbcb1mr80625626d6.22.1783128023052; Fri, 03 Jul 2026
 18:20:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 3 Jul 2026 20:20:11 -0500
X-Gm-Features: AVVi8CeYpYkS_-mwdJ3KNv_mNZ4c7rRh40fMV7UWOftM_zCcBgdUkCp52P1UWf4
Message-ID: <CAH2r5muk1fnO80SZWJpmt8_Q7uhRw=2-GcKYs1WppF32nfjo7w@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
dc59e4fea9d83f03bad6bddf3fa2e52491777482:

  Linux 7.2-rc1 (2026-06-28 12:01:31 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.2-rc1-smb3-server-fixes

for you to fetch changes up to f363a0fb134a3eb9e47368b1edbd251fd76be84b:

  ksmbd: fix app-instance durable supersede session UAF (2026-06-30
21:29:46 -0500)

----------------------------------------------------------------
16 ksmbd server fixes

  - Fix several use-after-free races in durable handle reconnect,
    supersede, and oplock handling.
  - Avoid holding the inode oplock lock while waiting for a lease break
    acknowledgement. This removes delays of up to 35 seconds when
    cifs.ko closes a deferred handle in response to a lease break.
  - Fix malformed security descriptor handling, including an undersized
    DACL allocation issue and an out-of-bounds ACE SID read.
  - Fix memory leaks in security descriptor and DOS attribute xattr
    encoding/decoding error paths.
  - Fix outstanding SMB2 credit leaks on aborted requests and correct
    the QUERY_INFO credit charge calculation.
  - Fix hard-link creation without replacement being incorrectly rejected
    when the handle lacks DELETE access.
  - Avoid unnecessary zeroing of large SMB2 read buffers.
  - Add an oplock list lockdep annotation and update the documented
    support status for durable handles and SMB3.1.1 compression.
  - Durable handle fixes to address ownership and lifetime races during
    reconnect, session teardown, oplock handling, and superseding
    opens, preventing stale session and file references from being used
    by concurrent operations.

----------------------------------------------------------------
ChenXiaoSong (1):
      smb/server: do not require delete access for non-replacing links

Gil Portnoy (2):
      ksmbd: fix use-after-free of fp->owner.name in durable handle owner check
      ksmbd: close superseded durable handles through refcount handoff

Haofeng Li (2):
      ksmbd: reject undersized DACLs before parsing ACEs
      ksmbd: validate num_subauth when copying ACE in set_ntacl_dacl

Namjae Jeon (7):
      ksmbd: avoid zeroing the read buffer in smb2_read()
      ksmbd: fix credit charge calculation for SMB2 QUERY_INFO
      ksmbd: fix outstanding credit leak on abort and error paths
      ksmbd: doc: update feature support status for durable handles
and compression
      ksmbd: don't hold ci->m_lock while waiting for a lease break ack
      ksmbd: snapshot previous oplock state before durable checks
      ksmbd: fix app-instance durable supersede session UAF

Qiang Liu (3):
      ksmbd: fix sd_ndr.data memory leak in ksmbd_vfs_set_sd_xattr
      ksmbd: Fix acl.sd_buf memory leak and invalid sd_size error handling
      ksmbd: fix n.data memory leak in ksmbd_vfs_set_dos_attrib_xattr

Runyu Xiao (1):
      ksmbd: annotate oplock list traversals under m_lock

 Documentation/filesystems/smb/ksmbd.rst |   4 +-
 fs/smb/server/ksmbd_work.h              |   7 ++
 fs/smb/server/oplock.c                  | 109 +++++++++++++++++++++++++++-----
 fs/smb/server/server.c                  |  14 ++++
 fs/smb/server/smb2misc.c                |  18 ++++--
 fs/smb/server/smb2pdu.c                 |  17 +++--
 fs/smb/server/smbacl.c                  |  15 ++++-
 fs/smb/server/vfs.c                     |  14 ++--
 fs/smb/server/vfs_cache.c               |  79 +++++++++++++++++------
 9 files changed, 216 insertions(+), 61 deletions(-)

-- 
Thanks,

Steve
