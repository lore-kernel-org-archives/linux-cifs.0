Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2319472613;
	Sat, 21 Jun 2025 16:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750522246; cv=none; b=eHA6MQD++Ivi/N8Jus87nGlzZ7/BAxe3rtQ6QTz3zlTFO3TRorUNxhfJol3WmStgX7QfODS2iKZxS3OtiZz9s7AS7WgyP3Gbgw1/O0Zany4b/Nbkv/iK1uoqVy4fIpRLbSqn7+2wNnA1rltv89ZkCt+trGYn551h6GiHEeZOQfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750522246; c=relaxed/simple;
	bh=HEDtX3F0mqge4mUIBW/e5lfO7pOxieE7eRL5EfKwEUY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=FXbFxSqJBmiE+ugR+47MT6j3c7NoVXvv13bNRz6A8BPobxigSv/hFAQvWms+C9SXFXkcy0bkkkec54t4Tju9n5TImDOMS53SdhB1RDatjAq3riwTqjZYuFxwb7CPLX7NzDFUMn/gwVSZ712Ny2h4MBFOJr3ve17HjjQGtRdqh4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VzOMkXm9; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VzOMkXm9"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-7d38ddc198eso302614185a.1;
        Sat, 21 Jun 2025 09:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750522244; x=1751127044; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9H+D2b2V/V2IwLAsJQhUHyhdLtgVW2yPUUKQ/nGIavU=;
        b=VzOMkXm9MLvFNp+APGH9sOXOvcjyI1ODx2POyPVvQVUUtdrCA/NxrdiYUSWUWF1pxD
         ylT7hcyJSnnVe89scc4RPEOf8yKHUz5P4Dn34QhhtBugaX4HNm1sdtthKm6bRO4JIDsp
         wgU1umtwdaHkkUIGysBJRa9tjCN4Be4X0LWdryAuGCMqO4XjSLFlO2GwvkY/0Md8l56M
         hTdBB2UIdibDZ8taj2fz/X4/WdRHuQYZLfH4QXPkUpKWJyLC5ZVVsQalrKtpz9O5Ar6+
         wxOE+4Ug8lAzQyhPU/mwH0lZlH82NP+WcD8EpIH/vLAlUx3YUT3CRVXIBRX3rtVQTkqP
         jDLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750522244; x=1751127044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9H+D2b2V/V2IwLAsJQhUHyhdLtgVW2yPUUKQ/nGIavU=;
        b=i//dpmt7IB4IgRdO1EUReVCnGM6bE1XcGuuVwCqkzoIoZ3ykbRlxzACHKn4ndUtrp8
         vIB2wk7KJvyr9I4aoCMnvpez84MkdFiWEuJk6t3Tpls6OM2MGD7bb5++Yy7+58E0wmux
         I79FCc0e7mek7AQoAk/9psBLk6nBej+bPIwZ4ce9a54pkihlsS76kWOQoFckHtB0Ldvh
         p7w71ZslKbREUcbUC7EmFVvszxFhP1LkeGVsvm/WjpM+GoC91MuBEjLTQLcSsPD2VpB9
         xNFGwnNvOnoZeHGu/kJ+BLCQtu+ea1n5NQ9uaB6CNIFPsCA1bwBwltUItgxMcB05yqUb
         W64A==
X-Forwarded-Encrypted: i=1; AJvYcCWujzTOzKA+9X5gyeNrsm1xpHlRG3DjcFhi1OQw/sGjmwEULoUUKstmodx8fzuQ/NxNPz5UBKJzZXkZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yxmln1D4S7XvPVF0+KWANx/2unxRziq0dDCY+ZmFuu7KvaND0Ca
	U6wWwQ65Lj696QjXEOLTGo9Yc3PIQYZzSNcXsoxCYhlxmu1p4BTg84CNQ7QGI2qwaJawNAi6p9l
	0R+bGELi2tSOyGSasQ2fdpL+smkkGZDGDZJCl
X-Gm-Gg: ASbGncsTXqtzdxdhyDFc1pJyyhEB3QBccYE6f6cbjEA9H0h+bnatSZgkZo2QiOTWN6n
	aorQ5SRRGCHSHxxT/0JMT7qeJkxRau1XkhMXR4fXoOVpR512iJdnPTkDgEQnV/SxhDl+mcISyXW
	HR9Zvr3pma3e8dcOLNE7vULRT2rOqp5Tci24UUZXW/b1aSWdGPj+OxJw9IDo6sRuYU6ohhKiMyM
	Jhg5g==
X-Google-Smtp-Source: AGHT+IH+5Mk6z1gxHSwq80CQyeOcUgsgnvSqq5U0Gh9NgvQXXzFPGujaFq6/jQ5SDrzQl6sxn1bigejlflHz5bbroJE=
X-Received: by 2002:a05:620a:f12:b0:7d3:9260:6db0 with SMTP id
 af79cd13be357-7d3f98c4a7dmr896419185a.3.1750522243849; Sat, 21 Jun 2025
 09:10:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 21 Jun 2025 11:10:32 -0500
X-Gm-Features: Ac12FXzEIhP38f58kDataIyklpp3nmjKHlHxnhDEwk-0WVjZxqHfPJNA_DFWQzw
Message-ID: <CAH2r5mt40T6YE_FLV5pdJcq_4ZBt53VNZPyPg9maoe3LxXPuBQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes (updated)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pull the following changes since commit
e04c78d86a9699d136910cfc0bdcf01087e3267e:

  Linux 6.16-rc2 (2025-06-15 13:49:41 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc2-smb3-client-fixes=
-v2

for you to fetch changes up to 27e9d5d021dbaa1211836d07a240078bf84b284e:

  smb: minor fix to use SMB2_NTLMV2_SESSKEY_SIZE for auth_key size
(2025-06-21 11:03:25 -0500)

----------------------------------------------------------------
Nine smb3 client fixes (updated P/R removing one SMB1 changeset as requeste=
d)
- Multichannel channel allocation fix for Kerberos mounts
- Two reconnect fixes
- Fix netfs_writepages crash with smbdirect/RDMA
- Directory caching fix
- Three minor cleanup fixes
- Log error when close cached dirs fails
----------------------------------------------------------------
Bharath SM (4):
      smb: fix secondary channel creation issue with kerberos by
populating hostname when adding channels
      smb: Use loff_t for directory position in cached_dirents
      smb: minor fix to use sizeof to initialize flags_string buffer
      smb: minor fix to use SMB2_NTLMV2_SESSKEY_SIZE for auth_key size

David Howells (1):
      cifs: Fix prepare_write to negotiate wsize if needed

Pali Roh=C3=A1r (1):
      cifs: Remove duplicate fattr->cf_dtype assignment from
wsl_to_fattr() function

Paul Aurich (1):
      smb: Log an error when close_all_cached_dirs fails

Stefan Metzmacher (1):
      smb: client: fix max_sge overflow in smb_extract_folioq_to_rdma()

zhangjian (1):
      smb: client: fix first command failure during re-negotiation

 fs/smb/client/cached_dir.c | 14 ++++++++++++--
 fs/smb/client/cached_dir.h |  2 +-
 fs/smb/client/cifs_debug.c |  2 +-
 fs/smb/client/cifs_ioctl.h |  2 +-
 fs/smb/client/connect.c    |  1 +
 fs/smb/client/file.c       |  8 ++++++--
 fs/smb/client/ioctl.c      |  2 +-
 fs/smb/client/reparse.c    |  1 -
 fs/smb/client/sess.c       |  3 +--
 fs/smb/client/smbdirect.c  |  5 +++--
 10 files changed, 27 insertions(+), 13 deletions(-)

--=20
Thanks,

Steve
