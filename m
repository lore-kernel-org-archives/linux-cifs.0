Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0581A2BE62B
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 16:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760718287; cv=none; b=mVczgXyNj4Y1SxGE4gavFT1kzg7NYFXcheJFSrU6Q6o6gScluvYANbWxqRBM+THv7cdShsGFKH5B7wi9JweSesBRz8Hn8A5aEwuCofxRPaiOwju+xlz6dgLcLFeWg2y5MhqSQuuMWokl/bjnzFyK6zZ3V4JYbeurztu5WjaCDiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760718287; c=relaxed/simple;
	bh=FTb0yFrHuRdjpgAJszQzIgA71Afk50W1vgFtxKtP+FI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=hfILk/zNxvFafJk9v9CdpGUS4Ij1bXkfmqnedqQeLiz4hgTLXhsTwJA4Pswpi9Bdv8esC6qi3++V8HhUSZ7mDkmvyrS72A915dcMkv1mgPhHyUBJfjrSUygScNUqifx6UTNjo+ny0Ix7H/7qb5LOsUQL+avwhOhnL/B4C+WNgQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XhkdPOUo; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XhkdPOUo"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-87be45cba29so30625066d6.2
        for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 09:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760718285; x=1761323085; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MCzK8PbFyItTRYW/eSHgtsp8i0BLpupCg/9Az9LQ8n8=;
        b=XhkdPOUoRgVOybqquu1G+op2vBZ5Luss2RGonvqlvb/I2Gk+AkHtSd5tWvXRe/s1j9
         ky0/15Q+WHU9Lz7MWhiaeYNoWNqbG43+ikEG2plxNHbFHXGQ7emIfyFxoNT495wbA8f4
         G8Bi+LEMA6TYxTuPCgwuyp0NufUe+gYFs69HLfGZcS5SfE7xlwBnLKIYGXl2XPfuG5EA
         jwX3usdA3fjFlUaz8UgNohiA9HE01fivXzbHLA3Efr4q6pEZkD+6smxtXIR1HW3xGtCB
         el7FW/ig6c9lrqJpbe11UC8SXiGopG2w5niN04oHe3vGEtKu2fhIPAB76xrBC7IOqLKj
         r7LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760718285; x=1761323085;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MCzK8PbFyItTRYW/eSHgtsp8i0BLpupCg/9Az9LQ8n8=;
        b=IOg1dBigDmeCdvg9lUQDNobAECjo4dWMTG9TzoamtNd71K7d7ePPaUT1YD6sAqGD74
         vVpXm5QPNKo4zRH43ndf3al/JIGgrz+jDONU8nzdp5IN7reDVpsLyfg0WJtx6II8lKTj
         xiJQDV3HRQLgwi7kcsI2hS153fnu6i+Iny95/OW/n52uR6PXXL4xfqNKD9n3WC2Z4rE1
         PRATJpNORbuA/jcsNUmbYtUbLFjpvJInqQzJg4VleUOfFuLbxb1bSI9T5n/bezSuQGTm
         fgBRmemSKMp40iR959Fu2TtwUle6OSlCmYRZgwnJCySIVXJDertchoErszXkmppL/lkK
         lIXA==
X-Forwarded-Encrypted: i=1; AJvYcCWPN2CZR5h0miedjBiWN9ozC2BCjw+wFHnyqVTJbwbYwmzm+s2K53WsNSw9Mdcuj2d52QfF1BI/lBq4@vger.kernel.org
X-Gm-Message-State: AOJu0Yzo4+iYzpvJxcX+riLlhpiiBLSUTxn/SgSovXFLgr+sEpsCHMDD
	UOGGmsshD8dLT71E08NKzLgj78nPhTtg33cIXYjZE5BgpvrAX0THF6nhiQ5vVn0zCARksoOL77e
	A6QjxEnlIs9+NzNLLTT2k78XqVUkZVKOTU1IA/Zw=
X-Gm-Gg: ASbGncuSMHM298Q1zyQxItcowWxK+zgVYBqK56m1KprkmpIYm7QY1Wd6gnlvgDHQBfa
	HUMvL0J45RPEp+rbbsilJ8G57+T8ivOcLsPCLRnd3J0hfMX6YCFsF52ZzVV/5g0VjKMiCRab+l5
	kXRPTIxgOrj3/8OkCRJP1totKGZX/2EWDiwZBfM990NayCYwmuUfddmDBEUwAV/bw6l8MPsFFhH
	Sh1VbWotamigtnv1q67D50kY1EwYcHKcj1gsPxd9nDVTi34SeXzTp1Taj2EUNPnPOONlUGYJPYw
	AjEQZIv71iLBSufqYJMBejSAjNqfS7S0f6jA9eZXDlyUubsxO4zfh+OePsWeIgbTiTsF0/fUNs+
	MpyvQOytSFObfAuYjtJBItGtdkIn24wf96MDXgjdYWpd9aJs+aU9+fMzAMl+/8bOCE4ElobhFiw
	k=
X-Google-Smtp-Source: AGHT+IEbKATRBQDJWotutsMuJ49f83ga0Ul3qcbhLWyRCQriEnv5Vi+HPuaaefU+GoPJWUoUDdT9wn/jVEaiNaFbuZY=
X-Received: by 2002:a05:6214:519a:b0:87c:2b5d:5bbf with SMTP id
 6a1803df08f44-87c2b5d6316mr20954186d6.30.1760718284648; Fri, 17 Oct 2025
 09:24:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 17 Oct 2025 11:24:32 -0500
X-Gm-Features: AS18NWDGB2RnEI5Ts-1Q0qBicF34CjvgCmiKaWBpfGxZFWRB7L98oOGQRbem09w
Message-ID: <CAH2r5ms-8MBEd9ssS8vtkneFt=wKW-5MDWr-4pMf0mSZS0JH5A@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

he following changes since commit 3a8660878839faadb4f1a6dd72c3179c1df56787:

  Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.18-rc1-smb-client-fixes

for you to fetch changes up to 3c15a6df61bab034b087f00181408b1537a535bb:

  smb: client: Consolidate cmac(aes) shash allocation (2025-10-15
22:10:28 -0500)

----------------------------------------------------------------
smb client fixes, security and smbdirect improvements, and some minor cleanup
- Important OOB DFS fix
- Fix various potential tcon refcount leaks
- Eleven smbdirect (RDMA) fixes (following up from test event a few weeks ago):
   -- Fixes to improve and simplify handling of memory lifetime of
smbdirect_mr_io
   structures, when a connection gets disconnected.
   -- Make sure we really wait to reach SMBDIRECT_SOCKET_DISCONNECTED
   before destroying resources.
   -- Make sure the send/recv submission/completion queues are
   large enough to avoid ib_post_send() from failing under
   pressure.
- Eight patches to convert cifs.ko to use the recommended crypto
libraries (instead of crypto_shash), this also can improve performance
- Three small cleanup patches

If you prefer to wait on the crypto library changes, that is fine, but
they tested well and got multiple reviews and look good.
----------------------------------------------------------------
Eric Biggers (8):
      smb: client: Use SHA-512 library for SMB3.1.1 preauth hash
      smb: client: Use HMAC-SHA256 library for key generation
      smb: client: Use HMAC-SHA256 library for SMB2 signature calculation
      smb: client: Use MD5 library for M-F symlink hashing
      smb: client: Use MD5 library for SMB1 signature calculation
      smb: client: Use HMAC-MD5 library for NTLMv2
      smb: client: Remove obsolete crypto_shash allocations
      smb: client: Consolidate cmac(aes) shash allocation

Eugene Korenevsky (1):
      cifs: parse_dfs_referrals: prevent oob on malformed input

Markus Elfring (2):
      smb: client: Return a status code only as a constant in sid_to_id()
      smb: client: Omit one redundant variable assignment in cifs_xattr_set()

Shuhao Fu (1):
      smb: client: Fix refcount leak for cifs_sb_tlink

Stefan Metzmacher (11):
      smb: smbdirect: introduce smbdirect_mr_io.{kref,mutex} and
SMBDIRECT_MR_DISABLED
      smb: client: change smbd_deregister_mr() to return void
      smb: client: let destroy_mr_list() call list_del(&mr->list)
      smb: client: let destroy_mr_list() remove locked from the list
      smb: client: improve logic in allocate_mr_list()
      smb: client: improve logic in smbd_register_mr()
      smb: client: improve logic in smbd_deregister_mr()
      smb: client: call ib_dma_unmap_sg if mr->sgt.nents is not 0
      smb: client: let destroy_mr_list() call ib_dereg_mr() before
ib_dma_unmap_sg()
      smb: client: let destroy_mr_list() keep smbdirect_mr_io memory
if registered
      smb: client: let smbd_destroy() wait for SMBDIRECT_SOCKET_DISCONNECTED

ZhangGuoDong (1):
      smb: move some duplicate definitions to common/cifsglob.h

 fs/smb/client/Kconfig                      |   7 +-
 fs/smb/client/cifsacl.c                    |   5 +-
 fs/smb/client/cifsencrypt.c                | 201 +++++++------------
 fs/smb/client/cifsfs.c                     |   4 -
 fs/smb/client/cifsglob.h                   |  22 +-
 fs/smb/client/cifsproto.h                  |  10 +-
 fs/smb/client/inode.c                      |   6 +-
 fs/smb/client/link.c                       |  31 +--
 fs/smb/client/misc.c                       |  17 ++
 fs/smb/client/sess.c                       |   2 +-
 fs/smb/client/smb2misc.c                   |  53 ++---
 fs/smb/client/smb2ops.c                    |   8 +-
 fs/smb/client/smb2proto.h                  |   8 +-
 fs/smb/client/smb2transport.c              | 164 +++------------
 fs/smb/client/smbdirect.c                  | 321 ++++++++++++++++++++----------
 fs/smb/client/smbdirect.h                  |   2 +-
 fs/smb/client/xattr.c                      |   1 -
 fs/smb/common/cifsglob.h                   |  30 +++
 fs/smb/common/smbdirect/smbdirect_socket.h |  11 +-
 fs/smb/server/smb_common.h                 |  14 +-
 20 files changed, 419 insertions(+), 498 deletions(-)
 create mode 100644 fs/smb/common/cifsglob.h


-- 
Thanks,

Steve
