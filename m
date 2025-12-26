Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EED638DD3
	for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 13:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766756287; cv=none; b=s0U1/7cWu1dVJbX6UHXt+BizANjE4um82zJOYqb83AVhklRe8E4vWI+YIlNFzPD0D2+exgKEmjMl83JquSPUtFdBobui8OeUUibopyAoMb/rwiTw5gUN4+/SbQ/58otoa4sFkhxmAZXFaIMpTjcbtFIbt31Yl3uU35f2YQ4wgtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766756287; c=relaxed/simple;
	bh=4HyKDzkQjduXHUNdSo3NkLs4KgSLo+v9q9nWY3KBMKg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=m2EHXw65ZkO5Fd5HLT8ZH/PNGecfiHBJzVcMA/VAj5VvFi2cUcGOtcJFEMJe5FdQtNccTotkpB/I2rWAW9BdpPRyUt7b3n7lqfdlw6eWfSnoOn85obsP1Ol4I8RGKKNymzPWpou0hNwm7LWJA49wGHeuVH2U5o+PYqB16LPsplA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=khMWwOBV; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="khMWwOBV"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4f1b147eaa9so57740811cf.3
        for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 05:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766756285; x=1767361085; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=F+SQqlRXglp7x7SFLFfN3jmEzOPO4uSsy0i01Y94E6A=;
        b=khMWwOBV1ldsptMTx05l9sp+C1qH/CajwD/r2mBpHNMOA+ZZP8eNiV0kZhyPpYji2H
         aLS2HmM31nl+i71lf+O5O980QOOp3gumXX6fnmcX0GEa+dwivFuhF13CLL22A7DtjKeY
         fUDvUU1kwYd7MPe1sjZCEDECZI6LB3+eMdbB+IviPlpmRKXxQnyYS1JqI0hQCo/xhkzr
         1k9MOQjxe5uJ3GAZzQ/pk0cnYcxmMUVQ7NqyFEPHLSwvQJSJGHpcqEav3kc4ZEPtm4HG
         W56y+jIz/BF0qNHocHRDRbdOXKUm0xo721FUFnndeCkAWS3ITeWRhRvs4Ja8hLRn+sQg
         h0Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766756285; x=1767361085;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F+SQqlRXglp7x7SFLFfN3jmEzOPO4uSsy0i01Y94E6A=;
        b=HUA9mzGEglZJDYnwe002/OEgAi1XcUGMdpfNJjWrDXde+oJV/w2IjqgIisuKEMP/VC
         fHp5DZsK7cNA2iOtPJ212XBb0mbrnnM/b7/vB8oO+f1hTZIfVvcoFLUjdFGctgW0I1xZ
         fPI3J3xSNZBHOjCGtDrflSUa705NNXao3X48y1a6wmb6Hd8hTeIyb1DJ5Pqnkbrs/t6C
         nP2L/Qq59TBg1nAvDfKUd24YjeoTsD1mddUZBHbraEKfk0pzBGuxxdYxa+HXnKR7tA+R
         ZJVG9cfxHkd2aDo7Mw4gWYVOL13hRCVNG9eySUI1AMiAwmrYWG8tnD6uXCAEMb5Aw1iY
         aL+w==
X-Gm-Message-State: AOJu0Yz1GKsLghcXhhrX5pCf5DNJ3jckXzphyFpr0WOn4ZIOwGL0Q2wr
	du43Y18hHxSM6HH5Jo3p86jrmmM8l3sFi/7uu21oPDoOdqc7aaorFmt+kxOCkkO6gmwFrZaiik9
	0LU9RYiYn3aatt1ChaTOxWy9HYQbG9cAunFBC
X-Gm-Gg: AY/fxX6Hiq9HIKTjRMRczZPeIAJUQ6Ik9CYmTuDF1DfF1NoMD9d/msQCHPEl5fCMiIe
	33d9Nnotl+BBDtvriXeo6muT4CS7CQMdlPTEWzk2cEPoVIhUmyjpk9Dgjo1CzqsZXyByax1yIQj
	8vxFq0xPd8gSdL3S00ULOdY0EK60TsntXwMNN3iZHbLoea9SlG6z+HhEgso1LIPXWCRw9Qjdue1
	Hnh5lbONhNRadWhrC4axrB0rRlJyIuU95RvA+FG3CTwZp4raMQJOOigL1h0CKN23J7AHQbjoFVw
	TAKdanX02Gr+5Xsv8u0V0aNd1JorXeUVSTXtpnExD8hso/zZRnY9jrH+tXG5aYxtXJboGMbV0dP
	zjqN9/IHfKG9vXpfZCIuGgYjohV1WlMsmcILOHednERQZMvTPnA==
X-Google-Smtp-Source: AGHT+IHqZp/xZQSdZ4LNjzmzEk+cdUkbPaQnwlveT+L9MoRvI2H2zQNrryaST4+0A3YUMvDysUiJWy5v7qxdJhw14DI=
X-Received: by 2002:ac8:6f11:0:b0:4f3:530f:d752 with SMTP id
 d75a77b69052e-4f4abdf0a9fmr334131681cf.81.1766756284901; Fri, 26 Dec 2025
 05:38:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 26 Dec 2025 07:37:53 -0600
X-Gm-Features: AQt7F2pV6NtAKyrdLQoI0swPnuN190yO3Q110OBc9nlILISz91z5wyNJRx9jvjE
Message-ID: <CAH2r5msp+pQr8o77F41w7vdiV369y2e=vfn2MC2P12zR7mLKJQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
9448598b22c50c8a5bb77a9103e2d49f134c9578:

  Linux 6.19-rc2 (2025-12-21 15:52:04 -0800)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.19-rc2-smb3-server-fixes

for you to fetch changes up to 4c7d8eb9a79ae5400eac19c4f6f0815bff674452:

  smb/server: fix minimum SMB2 PDU size (2025-12-21 19:20:46 -0600)

----------------------------------------------------------------
Four smb3 server fixes:
- Fix parsing of SMB1 negotiate request by adjusting offsets
affected by the removal of the RFC1002 length field from the SMB
header.
-  Update minimum PDU size macros for both SMB1 and SMB2.
- Rename smb2_get_msg function to smb_get_msg to better reflect
its role in handling both SMB1 and SMB2 requests.
----------------------------------------------------------------
ChenXiaoSong (2):
      smb/server: fix minimum SMB1 PDU size
      smb/server: fix minimum SMB2 PDU size

David Howells (1):
      ksmbd: Fix to handle removal of rfc1002 header from smb_hdr

Namjae Jeon (1):
      ksmbd: rename smb2_get_msg to smb_get_msg

 fs/smb/server/auth.c       |  4 +--
 fs/smb/server/connection.c | 11 +++---
 fs/smb/server/oplock.c     |  8 ++---
 fs/smb/server/server.c     |  2 +-
 fs/smb/server/smb2pdu.c    | 70 +++++++++++++++++++--------------------
 fs/smb/server/smb2pdu.h    |  9 -----
 fs/smb/server/smb_common.c | 26 +++++++--------
 fs/smb/server/smb_common.h |  9 +++++
 8 files changed, 70 insertions(+), 69 deletions(-)

-- 
Thanks,

Steve
