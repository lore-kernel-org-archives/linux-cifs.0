Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B6E3043DB;
	Wed, 12 Aug 2026 10:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786531201; cv=none; b=O7oKdFrCAUT4Mky/YVfPU/V522hsbegDOtDDpAg+HsowNpU6hn9FVeXMgp5sFtgezw6PLgaRNRlCyySmnxDzFq02qxHdosGeLPzuX2dqk+yQyhbWu4Oy3lBexO9F5M+fS5RUs3rug7QHofE4fv+m4uKG91Djxiai/YH8VxNRuaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786531201; c=relaxed/simple;
	bh=+L5wkxUgiKMZ3Cl8wJRlxd/ghHJoNsRbF1F1FU37JfA=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=H6fTJxDmG3W9Hy82Pggw4GOBUBlzWm02kVxA6teNJcHiyhkXVGpI9PKpHq/3rXC3xhAvuAEr4Z6HLn5G/5xhhYZM+KLwJKnDG5rhJTRFCUcd1tfeYoiZ2jzY++vGRlM94I+sQTbepLWK5Pz10StEYokTytz4aCPOqE+c8fqxGZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=F/Qv4Ubd; arc=none smtp.client-ip=43.163.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="F/Qv4Ubd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786531188; bh=rgCcqBiI0HoQYoOXaf8gb7eBgw/tn9+ldMmIDz50nXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F/Qv4Ubde54z1IIRXW/anTWFCh3rL9iBYImxFpFIlTJLvZkmaeY7cohMuT2JePryo
	 7qCcIXbusXmjRJ4WyeDBQ3+kT7qmn12mASk9tuFesGG3WYmeoNm8EtdugJ2+c7Bw7h
	 0Ta6PQzqFThlOpcXll29iZWeQeqYKCu5lrrhF3jA=
Received: from localhost.localdomain ([240e:452:ddba:7caa:44f2:d3f7:942:3f36])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 9EE2B0DB; Wed, 12 Aug 2026 18:39:46 +0800
X-QQ-mid: xmsmtpt1786531186tkssg74q3
Message-ID: <tencent_9141A44794315FE8DB5711273E6522357E0A@qq.com>
X-QQ-XMAILINFO: M84Ob7gbJGBWQcAy6gmI0fw9v4NimMCHANT41JuXNsfIZ6cFJu7WedIqjtSDPC
	 GXX8mgEOLdSd1fwlohYIfpWj1bsER5uJGBA5/y4/YxSi680UYHf2E9TNfJPGXsK/XrjC8NMe0c7j
	 006AWH0aqHWuNySF4iVCbvgs+bAvLnxAjhSr3nutt65atQdcZn2lUXzQkH50TIf3UV9Z1PTlYucO
	 MkkDmzfAjf4CAZD+Vh0IUSjqvuocwBSgI1UokSm2o3NKDhs8CFpnYV+9JgS72mE7XeDYUQytStil
	 UylL6Bt8MFYmomx46ggksXlEQBCDUtswkDfVhHwqqlouGDtQDRDOcd3penxfFCMgZfeU/Sdn3ZRq
	 RFvxcZpyVg5QkVRYuXol5NDWSH0C6VOEguHuLmX/fDYd3+BxJY16CiIJzFNTg1u1Oqe12Up2Ir2N
	 dG436BAP6HW+yRtEXNsjGrVe80beNh7CGjrbFZ6swLoMu6nxV4btPOW07d/zbKlsRS0z3Td7cZh6
	 nV51876/5xBu/DYy9AgcdYjWGxanQCoR9wGpjoMELKEMY+tZrtsOg5Phj+JwMlEvPAHy2Q3oTMO9
	 priRXa/SMpGg+0R1hQwCksFGZTiOXskB3Mw/ciKYelMpiuYtWDz0qFBPBsQsofZ2FxJyxu/iEiH6
	 se+EcY8HnEJqr+cB5f/AVi4dS+Zz7Tchx4z9C+6ZD00uxm26UtW6JCJXve0Xpx7Wg9OjVGNwRXbA
	 uSQAlIAJ85ierLSViEHLDUH9Aq6wyI1RFCtHQ3gyM8A6EZ4yydp7DVSkEqsiOcfKIzxu298V0K29
	 JcQLxiAyyV9K/ep+Dxo/2XSCMucx7Dt3vpl2ZG13Bi+UB2IvCx03XH3C8KmDKb+HZP/T+zOvcLxu
	 EFnnk5J2UjdTgFt1o1RUDBPTwi19HJBgisLI8G0oCSFDou0Zew3qqNTQKiuB99eafvdKUjgoxNJD
	 Do957MXLlTkYUYjRwP2cDTgxt+nsqem9G9Oezoinpj04R6t7FVO2XM5sD96Zn9XFhw149kX7c1+E
	 /83Hnop/9ZGbVI0cj3PSpkEBOsXrc6LAx0qDHNJg==
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: Hang Nan <2122295973@qq.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: [PATCH v2 0/2] ksmbd: bound smb_check_perm_dacl() ACE walks by DACL size
Date: Wed, 12 Aug 2026 18:39:44 +0800
X-OQ-MSGID: <20260812103945.82495-1-2122295973@qq.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <8970140c-1de1-4989-b32c-ea485be00b79@chenxiaosong.com>
References: <8970140c-1de1-4989-b32c-ea485be00b79@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi ChenXiaoSong,

Thanks for the review. All three points are addressed:

1. The patch is rebased onto the current ksmbd-for-next-next
   (base e9d76059ff03 "smb: server: Clear sensitive stack and heap
   data in auth.c", 2026-08-11).  Rebased v2: patch 1/2.

2. The semantic KUnit harness is now the first KUnit test for
   fs/smb/server (patch 2/2), as you suggested.  It contains two
   tests in fs/smb/server/smbacl_kunit_test.c:

   - ksmbd_dacl_walk_must_stop_at_declared_size: the pure semantic
     harness used for the validation quoted in your mail.  It models
     the ACE walk and pins the invariant that the walk stops at
     struct smb_acl::size -- the post-boundary ACE is selected with
     the old (enclosing descriptor length) boundary and rejected with
     the declared-size boundary.

   - ksmbd_smb_check_perm_dacl_boundary: drives the real
     smb_check_perm_dacl() with a crafted descriptor stored through
     ksmbd's own NTACL xattr path on a tmpfs file, and asserts the
     post-boundary ACE is denied with -EACCES.  With the fix reverted
     this test fails (rc == 0, access granted), so it guards the
     boundary fix itself rather than only a model of it.

3. Validation (KUnit, UML, x86_64, KASAN, CONFIG_SMB_SERVER_KUNIT_TEST=y):

   with the fix:    ksmbd-smbacl: pass 2, fail 0
   fix reverted:    ksmbd_smb_check_perm_dacl_boundary_test FAILS
                    (expected -EACCES, got rc == 0)

Happy to split the harness into a separate RFC or adjust anything
else.

Thanks,
Hang

--
Hang Nan <2122295973@qq.com>

