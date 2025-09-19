Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B20941DEFE8
	for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 20:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758313370; cv=none; b=XAIyOTYEO7Uh4YZciljZMFgJh7sCKzpsyruPxtOFcg/zbccAmuwKfluRNVXG1hnBxbg0itnb5K/yxuY31qAlPMT3UAq01f0KoE6k7WqCwINg8XXveqM/kLshk9xY12poEcLIB+4ZQ42V30ow3HiFFRRWL1d2ZIqtDkycQ5xUv7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758313370; c=relaxed/simple;
	bh=rmCarrm6/v36sWR5R5CvJ9C5raSkdoNouVGhkwQpN3k=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=rU8lbxeRSqRz1BduK2pW5lhhFBIbC0onpEnB08ulgCCH31ifaMndAI9Tsu/fwBLxJlhOF08Ug2OicX9lRUNxfySw+gCc/JulIEVdxcEDAtdGsiJkTZl5B8NC8zsy2NcMjmVdBhzM5SgkibiBMJsLwDmVM96WXRrHwGwq710uT3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZykDN+ON; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZykDN+ON"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-79a7d439efbso10364106d6.0
        for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 13:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758313366; x=1758918166; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4Cy206vdHXoNwug0xkOGBRn67z0vWl3+IUBx20uq9Ok=;
        b=ZykDN+ONryel5Vhd4kacbsQLcr/qSwC22938iJ9zWRy8+48r/0VtWnq0JaPB/22IC0
         DEe9qXlCRvsbntsYVsIN67V+j+FpmHukGfgpUvk979KGL29sx4rK5fcrVSuoqnn00fVS
         XA74KN2F8bKPwAymP6q9hy523q68pf16K5++xvRFWGwD97ZMfDY3VKsYn9JoH66QTjxW
         lRLmnwce5Cnn0Qh6RZX4wNnjALMlaRylAwNfxqCwInanmuzcukdqNzH+jmHRfNqepnsj
         fB3sXppIyb5brl5RVVV2gHKAYsJbX4yKCrC0CYM68lhwuBoEOhNsX/wPENsmncJ3MfHK
         Im6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758313367; x=1758918167;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4Cy206vdHXoNwug0xkOGBRn67z0vWl3+IUBx20uq9Ok=;
        b=UOuIo2aKVbVD9MUNTiWVHP6zh2riStvZCkPEXaw2fKfECLiYw7m4nDNh222TfttlXq
         PJXXloETy1hJW8YWirzP0alU0FYMj+1b6qSDt46N7In7PzMY/wO7p2UZJcdy0LyWYBJk
         3375nKcwRRCIFzYw6gpR3UwMTALYrdsSWk8cy20a7wC3CyD6vb18dBGuzb1dpSoJ6xP/
         FYHUKNmSPvQHfjsWtn5jA6/MI0Ve9ySszuxd+QTjLzrjF6EKkPfUFJ0+hg57IMPjujHs
         IltOfApHStZwTpfDUKcgQIIYEliXb356cfImhNLF9lcHltchSCrjMZaUA63GGWpDk1rJ
         zf+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXmWMVZFRjFPoF3zBP8TU5ujNXc/9bprf++5aOjwxC8xbALQjsguR0i2/XuGB3IMX+BypzxnNdBGQSf@vger.kernel.org
X-Gm-Message-State: AOJu0YyQO8dDxgZHufZFFdrOOo8L8diGCDINxRgx/joNDXwH+kV2pApx
	gzrMXUCw2jQaa2fWrvNeMU7DmdyJLxtwGTWz5sYbM4Q1esOzFtj7MIOYxFrFSyyN0EP8JaMaWwc
	ZQJDribCKS4e6HsHRq8xMvH5hwPdIoQUf338T
X-Gm-Gg: ASbGncsJ9B9DU1sMd7N+xb1nT7N2AZkuBENHJvIU6OVtbztFmSR26TavjBiwB4094ad
	C+pt2tPEJw0afdd0TV857BF63HfMqOxPl2AVgMrnEcGxTWpSh4Op2ZTTphrSL+prbKVQUYMUMHm
	7EUi3Ps1ln8af2NdLRoo+uKjkM0X+Tnh5wNcSy1vgQW8pU0FTsVIWmHx3V4OD+ckpm0dri++Te4
	naqEc7S9CAzYgiyojFlxFnLW4DqW1MFUgi4rsSzRLNAjRy3d22lX9WfOQkS5K+buvFfq1tpOh+L
	xgRRN7GDc80vu/dUBs1n6PB/baKH4kYH7u0boNJ9QN9v2b29XfxaUx5AipogVXmQy4VvKWKZdFw
	ivV9xG1NIdmHzXPQobAU9iw==
X-Google-Smtp-Source: AGHT+IGGImSU6vWX0E3XUBvl/H3q20vO7+Ak+1/XGT8LNRyvVP3NfjlHzlDkQ71ErIMJWhX6XIsBjifr13dctqtG2oY=
X-Received: by 2002:a05:6214:226e:b0:741:52cf:a104 with SMTP id
 6a1803df08f44-7990fe38074mr52494986d6.5.1758313366488; Fri, 19 Sep 2025
 13:22:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 19 Sep 2025 15:22:35 -0500
X-Gm-Features: AS18NWBD_WBUHdrEHM7UxAsP6qhd4g7AA9UdPCh_tSXfbHcTmH08YWsTsHv20zk
Message-ID: <CAH2r5ms1vdZHKz4guZFpR0fMfZFE36eBwdH+fapaW-i1tOTSaw@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
f83ec76bf285bea5727f478a68b894f5543ca76e:

  Linux 6.17-rc6 (2025-09-14 14:21:14 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.17-rc6-smb3-client-fixes

for you to fetch changes up to daac51c7032036a0ca5f1aa419ad1b0471d1c6e0:

  smb: client: fix smbdirect_recv_io leak in smbd_negotiate() error
path (2025-09-18 16:46:04 -0500)

----------------------------------------------------------------
Six smb3.1.1 client fixes, all for stable
- Two unlink fixes: one for rename and one for deferred close
- Four smbdirect/RDMA fixes: fix buffer leak in negotiate, two fixes for
  races in smbd_destroy, fix offset and length checks in recv_done

----------------------------------------------------------------
Paulo Alcantara (2):
      smb: client: fix filename matching of deferred files
      smb: client: fix file open check in __cifs_unlink()

Stefan Metzmacher (4):
      smb: client: let recv_done verify data_offset, data_length and
remaining_data_length
      smb: client: use disable[_delayed]_work_sync in smbdirect.c
      smb: client: let smbd_destroy() call
disable_work_sync(&info->post_send_credits_work)
      smb: client: fix smbdirect_recv_io leak in smbd_negotiate() error path

 fs/smb/client/cifsproto.h |  4 ++--
 fs/smb/client/inode.c     | 23 ++++++++++++++++++-----
 fs/smb/client/misc.c      | 38 ++++++++++++++++----------------------
 fs/smb/client/smbdirect.c | 33 ++++++++++++++++++++++++++++-----
 4 files changed, 64 insertions(+), 34 deletions(-)


-- 
Thanks,

Steve
