Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2043C5522
	for <linux-cifs@vger.kernel.org>; Tue,  2 Jun 2026 23:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780444612; cv=none; b=Gwhln2et+BxL7AXMCK4kbgVrBogTuwpPPH/gDEMjgiM0a1eghl/VksYhZKaaYbY3YMIxX7MHjlIgZ1VmAzsJQxgc5gl3kNtQxFrjRiQOijpbB3KFG+kZhzUmUpFDCvOSRd+WhJftvPLXhClZAbtQsCLF+8KipSsm+nv3yuZ8Sp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780444612; c=relaxed/simple;
	bh=sep4V0SjjMM5AxsPLB1KhRivWls906n1Sgx+OoHi9cA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rlXPnYLNgOOtBSTqEJE8YRFdZy7TSEB0c/iAnRWJhbrpFskkU9p9pTdkvMK6MqqZaKJUQFriAqeD3OmBFw5Sruu+r8NOFt5An1cO8SDrSIJ2K7kIlAJqTQV/JhtVV2Up2UlsAesMdtz2jGIzf4GjWMYYUmxhDTX7+1FCcEFZ3P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bAqoM0cf; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bAqoM0cf"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c8584e80d59so1588451a12.2
        for <linux-cifs@vger.kernel.org>; Tue, 02 Jun 2026 16:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780444611; x=1781049411; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0xHIqJkwJ2SbbPlEp9EiveDRo0m8mJTT+U3xdWCxDh8=;
        b=bAqoM0cf122ph8l4Kp32OIwNngy7b8d4jMf5JnoJckgx5hjgsxEqZ2KaebsqugQwDU
         TJAYkWdg8Ba6XTGPSweaBRCPR5DJjdWjp2I+1sazzGUMtcMsuAo7h2/DRdwxYXrmmU03
         V24+YMbQsDNjdxsn1EPiZ7s3PpmPNX/idhC8cg9UHOvWT3niOJx8oAXKvWswBsri+tBW
         m/JvDcdjP7OuHxplnWq32AgKLWoDC7npleglUwNnyPHtNCqcgQN3k33uCIQmEkZLsuY0
         N+J5wS7LPCizzNM8CkFj4igNd5s8/IEk7lM9vn6iUB4S2ap6hFGTbrlTzY9tX3yQ7feZ
         Jp7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780444611; x=1781049411;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0xHIqJkwJ2SbbPlEp9EiveDRo0m8mJTT+U3xdWCxDh8=;
        b=OJIJGt+t5PWhaLyi4aKXlWmfIoSH5pLcHCQb9radzphTrpcIAJ5twMs8Er6rYWYia3
         aZQfL8HuOhQoHaP43xSJtGmeIrGX6egWokNTyqPdkBoNhg+BWMcLoZEtsuqGfoGQrUuv
         1ZGYi2xxAJW+Qb2pkZedMSFDW7j6lFHOEW65OwN3yx1ImXj+OGAwDwS5QM1Fb4O+5x6F
         Tav8zMoLqQXx57DFi0X4nTPEzU2ZB1d+fPAfwkXlGVAZ/0bt6hEz8qvVaSqz+2CME1X+
         flLDRk86v/AyZJWEVoVAAzjWpGup0wgo+qdHxsGUEpgA1nLngOrdWZ05cFnfs7KQupAQ
         XA0g==
X-Forwarded-Encrypted: i=1; AFNElJ/MSj5+8bTEu4noYIkaCGS/pFTO2r9WCX7podu4brRZKd75CQbrQXwVNZkh+uny6vzBKsFWkeXl2LXb@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+G7Iat2IhyE57dI8lfK1dinYtMhU3lWGGw1V6Vof/4l8PpWO0
	9Tujw1XS8ZXo2amc2+WBtLVDwybSZznR1fJELp2SvsXr+QEeShEWskBj
X-Gm-Gg: Acq92OECAcKHK8sxqvcNymJ9c6/Ia8eesF6fYnGgv0+vAttLJS7+5g896p9P2w3gBiE
	xBc9OuVpyKxXG3k1t2NZeyISK9U6wJIeCuQ6wHfLHSOHU1VwvsTbBb8HW8wrPAWC76LvUMu6SFO
	8DYsMZJlDRnpneXfdiE5f3l34wEhxvHIRKtEAZ6N5JthJSPGulgYoGJWWUgef4JEcnVxelKbkyC
	InkOBYFdIMbeskM+tz2Fb4ugCWHeattfgcOV8ICcu2GTPq4V3W+7NuNihaOUWn/cN8KnGvSUAIo
	ldFRF4A8Cvx30oyfJSTBkC/KOITjDHOgA0wceGRKTF7ioSKTiyKKVDf7fShz+Cac1P/I5+gR0qE
	VAwVNSQRoCp41Ri2zGUj+5Yn7StCB2IMAlbw2kTb5PCozzXNUEQqKC+OnhIoHBKwYIxD+UbQut0
	EvyP0cSMTa1YqnIS3bJeIZtYFRJcSl9qgx8fSSnMcJf9pMF53jhhvDu08hSMfRDWCDfrH8GyVVl
	xs=
X-Received: by 2002:a05:6a21:6906:b0:3b4:68e3:f14f with SMTP id adf61e73a8af0-3b49731f75fmr1063489637.1.1780444610458;
        Tue, 02 Jun 2026 16:56:50 -0700 (PDT)
Received: from localhost.localdomain ([2601:600:807f:1ae0:c98d:5eba:43bd:375])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85df0a63b3sm352301a12.21.2026.06.02.16.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 16:56:50 -0700 (PDT)
From: Hem Parekh <hemparekh1596@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <sfrench@samba.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	linux-cifs@vger.kernel.org,
	Hem Parekh <hemparekh1596@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: fix out-of-bounds read in smb_check_perm_dacl()
Date: Tue,  2 Jun 2026 16:56:46 -0700
Message-ID: <20260602235646.23581-1-hemparekh1596@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The permission-check ACE walk in smb_check_perm_dacl() validates the ACE
header size and caps sid.num_subauth at SID_MAX_SUB_AUTHORITIES, but it
never checks that ace->size is actually large enough to contain
num_subauth sub-authorities before compare_sids() dereferences them.

CIFS_SID_BASE_SIZE covers the SID header up to but excluding the
sub_auth[] array, and offsetof(struct smb_ace, sid) is the ACE header,
so the existing guards only guarantee the 8-byte SID base, i.e. zero
sub-authorities. compare_sids() then reads ace->sid.sub_auth[i] for
i < min(local_sid->num_subauth, ace->sid.num_subauth). The local
comparison SIDs (sid_everyone, sid_unix_NFS_mode, and the id_to_sid()
result) always have at least one sub-authority, and an attacker controls
the ACE revision and authority bytes (which lie within the in-bounds SID
base), so they can match one of those SIDs and force the sub_auth read.

A crafted ACE with size == 16 and num_subauth >= 1 placed at the tail of
the security descriptor therefore causes a heap out-of-bounds read of up
to SID_MAX_SUB_AUTHORITIES * sizeof(__le32) bytes past the pntsd
allocation. The security descriptor is loaded by ksmbd_vfs_get_sd_xattr()
into a buffer sized exactly to the on-disk data (kzalloc(sd_size) in
ndr_decode_v4_ntacl()), so the read lands past the allocation. The
malformed descriptor can be stored verbatim via SMB2_SET_INFO (the DACL
is not normalised before being written to the security.NTACL xattr) and
the read fires on a subsequent SMB2_CREATE access check, making this
reachable by an authenticated client on a share that uses ACL xattrs.

Add the missing num_subauth-versus-ace_size check, mirroring the
identical guards already present in the sibling parsers parse_dacl() and
smb_inherit_dacl().

Fixes: d07b26f39246 ("ksmbd: require minimum ACE size in smb_check_perm_dacl()")
Cc: stable@vger.kernel.org
Signed-off-by: Hem Parekh <hemparekh1596@gmail.com>
---
 fs/smb/server/smbacl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 664b1b4a3..340ea98fa 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1477,7 +1477,9 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			break;
 		aces_size -= ace_size;
 
-		if (ace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES)
+		if (ace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES ||
+		    ace_size < offsetof(struct smb_ace, sid) + CIFS_SID_BASE_SIZE +
+			      sizeof(__le32) * ace->sid.num_subauth)
 			break;
 
 		if (!compare_sids(&sid, &ace->sid) ||
-- 
2.34.1

