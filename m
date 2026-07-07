Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA283D952F
	for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2026 10:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783418496; cv=none; b=SHlZITjZN1Nnv6mVBUNl+mGcY1g1geKZ/KHS7ISjKzRis7FhHtM5WnF6RZ2Tb4e5VlYUOSs6uxDL9Nzg6azUR1PorOf4MmVgqhlIKzt9G/FirMFH5CKS/Az/3dbhiQANOWQ3ziOq+bGqL8w5FGYq54osql27h4t6bhDqHqhdeiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783418496; c=relaxed/simple;
	bh=cgAqG/O12gwsG6gQHqKkMbScT9OlQXiTUZp5X21CxQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Bli80z+oDyBlCBRHUiLEJFoXvaW9Draj4Vs0BbkzwPlufTX1OqnpsTfyd0ARYMIfUv2hEzzoj8cyVMqlM8/kg4NvNIgOTfGWPt6Kzq681b00JunzVB6DmnjjLdnwWuoZtZY1/jkC8mTwq1B1zKJp1r558QIRo8sQQ6m1Pl9XAHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jsA+QCPy; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jsA+QCPy"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47d70879764so1554509f8f.2
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 03:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783418493; x=1784023293; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XTy5yBP1InRpkYk7HmMoBzJwmnoxpbvuaqpUbTqjmYk=;
        b=jsA+QCPyrJglMpmkVBCbhVxWgx5cHkP8Ym5uhyW3Jy45m/7UNpvQLKbEPFfDAZOMHZ
         CekvaEF4gWfhY5cHdmb/zXWOp3mv0oovS9bnClF2JPM8rJACdkbeJbR8enpcwg5bzfZg
         Wg7aB5WzBeR7FunkjyJoHbjDGiU2FQ5EP8Ca7e3a347QC7+m0V8mZGDHG0Vwje2XKiV5
         OyP8/tBWvk1fX8YgU+cp9ZgiyxUWOFsZqbv3U4SfIId81jQqCBqXthPBkmkA/JL+gqWX
         FcRiju2VxZ6Wt3I5se1A5sKY7hPQZ/qNxu651Le7ubW0SH77WdHRmpwJGvFY/eP5jXvn
         fKcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783418493; x=1784023293;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XTy5yBP1InRpkYk7HmMoBzJwmnoxpbvuaqpUbTqjmYk=;
        b=P30sJKzuKhH2IAL4HFkIUYE8kZonpVQmro881OPb6lYF9bsYu71vG31geVFJfcd2bt
         9uWPV8I3mh1KdspsH4wRi3FMAf4CSJUSvocYTLFYp16+T78y+dZPkw0KGU71frhUtigM
         KO6kXg3837nMczL9gd4wB0PZ47LLkMhz9oyiDf8ug9l8GZ3+VPI4IUukhSpyx2y+u3Lx
         39/Ng7sDKmynjaq3lwceuM0RQFTJtTq1lHwUc2Diq56KAMtAR6NOOd6T+bUBhmCawL0E
         TokaVAdJ5/8Sg5uqLzAi1EIQRj5tQjN3tK+mXHzQJjmbagL7RnUpSIOOe4kskFwqSLfG
         X//Q==
X-Forwarded-Encrypted: i=1; AHgh+Rrm1u3wsR3dnqI1EzjvDQHMJ92v5PUhq7PB0q+MdHsJyKPHI7fY6YdwuJlPAcU43zRx9YGEhUuwtwYO@vger.kernel.org
X-Gm-Message-State: AOJu0Yyyp5uT9O3nJZ/zE7ttKogbeFNRZb1NSBpiSIj8uAV1PMBArpAo
	hajCCnv00+W01SKe9lAMXblI0apClKVp4VsiA/9FgbyHGRtijS8JKFJ3dbCDJseN
X-Gm-Gg: AfdE7cm8N9et6CehkaXinTdgO6C0cg+YmeOBEyewnCdnKw+gozVXob+ZUa5DxEc8vTI
	cPTsBOfIEPmt3IMJ8tQ5o7xu71sziUBqJ9cbkhdOEExsDcKCrIgHnjAyEa61DfEG808I08unpeL
	p9mMj+vtl8t/oemugonN/QFWaTsTT5QOFjfTGrF8BeTpa1051lPFuuihN8wr0R0SbDymZKZWlMb
	jpIU7Ktsj3M6q70ZrFx0PIP28asw4Sji4Zsa8m6D6vVFiVWovmBr44cxccUJy9tUIUxoSSHZUbC
	H9yTkZXlT7yW8EmMOjL9ltzPkfrS89zklvj2+KLPTDIoR2GfQyWWnOE6Onxeb2xq5hClJOTO84z
	5qYbSOWSok/fO8WWccxFry3WDpKGXTJD50jXI8gXuvOyaRN2A8WhHGyR8LyoOmqM9sJPCQ7rP8Y
	GYJtyVUYYTAurlAR1x0XKAaVGTMDpftyjkm0A=
X-Received: by 2002:a05:6000:136e:b0:46e:98a7:232b with SMTP id ffacd0b85a97d-47de6650421mr3632640f8f.10.1783418493183;
        Tue, 07 Jul 2026 03:01:33 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1e785sm32203122f8f.8.2026.07.07.03.01.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Jul 2026 03:01:32 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 0/5] ksmbd: add macOS Time Machine / AAPL SMB2 extension support
Date: Tue,  7 Jul 2026 12:01:23 +0200
Message-ID: <20260707100129.47563-1-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

ksmbd currently doesn't implement any of the Apple "AAPL" SMB2
extensions. Without them, macOS Time Machine backups over SMB do not
work at all. This series adds enough of the extension to fix that.

The underlying logic was built and live-tested against a real Time
Machine backup and everyday Finder use over several days on an
earlier baseline. This series is a careful re-derivation against
ksmbd-for-next-next -- verified to build cleanly and pass
checkpatch.pl --strict, but not independently re-tested against this
exact tree.

Everything here is scoped to shares with the new
KSMBD_SHARE_FLAG_TIME_MACHINE flag, not enabled globally: the AAPL
extension is undocumented and reverse-engineered from observed
client/server behavior (cross-checked against Samba's vfs_fruit
module and the Apple Time Machine over SMB spec[1] where possible),
so this keeps the blast radius contained to shares that explicitly
opt in.

Patch 1 builds on top of the AAPL groundwork already in this tree:
`fs/smb/common/smb2pdu.h` already has the SMB2_CRTCTX_AAPL_* constant
definitions (added recently, currently unused anywhere), and
`conn->is_aapl` detection already exists for an unrelated narrow
purpose (reporting UniqueId=0 to Mac clients). This series reuses
both rather than introducing a parallel/competing implementation.

Patch order matters: 2-5 depend on the AAPL negotiation and
conn->aapl_readdir_attr flag added in patch 1.

[1] https://developer.apple.com/library/archive/releasenotes/NetworkingInternetWeb/Time_Machine_SMB_Spec/

Gael Blivet (5):
  ksmbd: add Apple AAPL kAAPL_SERVER_QUERY create context support
  ksmbd: synthesize empty AFP_AfpInfo xattr on first probe
  ksmbd: send inline FinderInfo in FIND responses when READDIR_ATTR
    negotiated
  ksmbd: defer CHANGE_NOTIFY completion instead of
    STATUS_NOT_IMPLEMENTED
  ksmbd: implement full-file copy for AAPL ChunkCount=0 COPYCHUNK

 fs/smb/common/smbglob.h       |   1 +
 fs/smb/server/connection.h    |   1 +
 fs/smb/server/ksmbd_netlink.h |   4 +-
 fs/smb/server/ksmbd_work.c    |   1 +
 fs/smb/server/ksmbd_work.h    |   2 +
 fs/smb/server/oplock.c        |  73 +++++++++
 fs/smb/server/oplock.h        |   1 +
 fs/smb/server/server.h        |   2 +
 fs/smb/server/smb2ops.c       |   4 +
 fs/smb/server/smb2pdu.c       | 275 +++++++++++++++++++++++++++++++---
 fs/smb/server/smb2pdu.h       |  60 ++++++++
 fs/smb/server/transport_ipc.c |   9 ++
 fs/smb/server/vfs.c           |  41 +++++
 fs/smb/server/vfs_cache.c     |  30 ++++
 fs/smb/server/vfs_cache.h     |   6 +
 15 files changed, 487 insertions(+), 23 deletions(-)

-- 
2.43.0

