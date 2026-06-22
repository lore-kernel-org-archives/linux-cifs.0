Received: from out162-62-57-87.mail.qq.com (out162-62-57-87.mail.qq.com [162.62.57.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64C238BF81
	for <linux-cifs@vger.kernel.org>; Mon, 22 Jun 2026 08:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782118043; cv=none; b=kBoG5F2VY/OjaUJ4j+D7fxa5TgsbN36xpGxv4SgjQ2pPJORQosKs9OKyoan/nw6jjETPUDdGKL3qXm8YH5DHBSew5AhhFTXcR9eFFJqdAWtO2DI4SlRiUFlMFD/Elt4B1jWnN5xSCYkgXRjwgM81dSqTpZWJ5EH8EfqG4s/XMq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782118043; c=relaxed/simple;
	bh=UvtOPhmNTz+UOftq/B5KLn4iLsotG39/bHTNhPV3UQc=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=ZqSkDKgjfc23VBkr1vN0jZJC057Up7IYLnpC/YH+83isfbItBIKmqbeTlxkDsfc700hP307Ol3pOT0DwJ7SR0ymu91Y/PpHo1Qu7/Z+BIRovLmwZ9//UoHIS27T8pYl46WR1KA/alUb3u/MTd+kcM8+eV7weQNuebQLP1rK313g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=v7MkG9ar; arc=none smtp.client-ip=162.62.57.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="v7MkG9ar"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1782118035; bh=ggU7lf6xYTBXn+h6R+zKEOKBwr8KDc03p0FdkpZw+fg=;
	h=From:To:Cc:Subject:Date;
	b=v7MkG9arYmxg5lYy+LTX1sSTJVoogJ8GraIuD89Aj9AnNSWgcX7b1ZDPBiPRo26M8
	 XAGsAwZuNDxIhq8nTBFseLAdyTVusMLmJgZ6UwHwX9C+MYVw+V+a3mhG2XV7swSWzq
	 WkB9PnhfohA88E8Fil73Fm+xBdNe5zTXBqJIVAFI=
Received: from localhost.localdomain ([116.128.244.169])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id BCC3D091; Mon, 22 Jun 2026 16:47:12 +0800
X-QQ-mid: xmsmtpt1782118032t65limhfn
Message-ID: <tencent_160379D932900C07E87A916577DA03F73609@qq.com>
X-QQ-XMAILINFO: N2zgDHximsrq6yVcC3KLzRKMYfT8I0k8ihehkJy0BoN/WBnClZUxn/qax6y+eL
	 +NKiTrLhQWWo5wPti+CTSDQ2Frote871niGKZyxjB1IkTsDugQz/KOSWqLZv1gRtggcNgy9RPxHr
	 69imMJt08jfJOd6T7N9iZSTW20iTMey340oppmgkVbkxvwrNako5zoFS/ViHVe6K0ENrhP/URowD
	 /0YpY4zMIy4T2kAK/huJMSHbOmGDddymcsO8vL1MtwpMMnqhlXGMtCf4OfXaLPaTsRo0u4wU7p7j
	 2bprLcc3UJsMGbW3HNPv0H7DVMoxx5hw/Dcpnue8Wkss/RYKtz78nZjW5Gs0sEAFwVQjs6MjsACm
	 mQ5b32FjjNoKCw7GyVwtQHY3CYP1aOfJiJj8pZLRxunAZCBs7DVJFPF8/hCGzn4nAryByVzJpN4S
	 bacgLvlBwkPqVgUrn/n2POCSpcMBu6rYeKiW/kiUqm9DmPVYvMqOFqz2zSVcsm4hLGsb6iZx9wzQ
	 2fL4OFhjpe84m5cbho2pB0ewcBeQnxlgr3ME7CnPzf70Ib8KwixMA4cRAtNPjGVDvi6ADquq+qfX
	 lHXH1qKiXsVHqHPsIzlKXAkOwmRSi7wqXApLripGxPcnECQQxBcixe8saIn1G2ZWZRurOrXBk7r6
	 6LqISLFwo55CG6th0iE8Yy0PSEsXMmJuLF4PBPjIuYcx4n1fLF9IaowNFkqkwbkf9GCRAelAFb/6
	 2/NLGZpJgVkiHJ8dOogMil1yxfuWDkPR0aFkgxBI4sS+HqNMAm5E2yMBK7e12QT+zyEA7rRF8LMy
	 C30CyrukCbeYXpRRQaEhwa0Dx8uXE4O7/x2C7HJW3HxePQ8QtlyNNEvRu4/wxjaW5UUp1jolFbXj
	 xlmys3TCBpJnbMu6ESYs+YdDlXkcV+K8g1y+7xkQqiioFbKiAccR56imZg8o4xWfjdXT4OplRPLC
	 FkURyj7dnntnI1W4iHR1gSYvNQnj9PNPtP8jkQ29Vny/xhbqBnz53kMit4Kswi9yiNnOe1+w6pzZ
	 yZ2nRF9C+G0v21S6uKF+TLzpuXPSBy1+kYAh2+cA==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: Haofeng Li <920484857@qq.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	chenxiaosong@chenxiaosong.com
Cc: linux-cifs@vger.kernel.org,
	Haofeng Li <13266079573@163.com>,
	Haofeng Li <lihaofeng@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH] ksmbd: validate num_subauth when copying ACE in set_ntacl_dacl
Date: Mon, 22 Jun 2026 16:46:56 +0800
X-OQ-MSGID: <20260622084656.663701-1-920484857@qq.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Haofeng Li <lihaofeng@kylinos.cn>

set_ntacl_dacl() copies each ACE from the attacker-controlled stored
security descriptor verbatim into the response DACL without checking
sid.num_subauth. The ACE bytes (including an unchecked num_subauth)
originate from an authenticated SMB2_SET_INFO(SecInfo=DACL) that is
stored raw via ksmbd_vfs_set_sd_xattr(); parse_dacl() rejects a bad ACE
with `break` rather than an error, so parse_sec_desc() still returns
success and the malformed SD reaches the xattr intact.

On a subsequent SMB2_QUERY_INFO(SecInfo=DACL) for an inode carrying a
POSIX access ACL, build_sec_desc() -> set_ntacl_dacl() ->
set_posix_acl_entries_dacl() walks the copied ACEs and reads

    ntace->sid.sub_auth[ntace->sid.num_subauth - 1]

with num_subauth taken straight from the stored SD. Since sub_auth[]
is fixed at SID_MAX_SUB_AUTHORITIES (15), a crafted num_subauth (e.g.
255) drives an out-of-bounds heap read of ~1 KB with an offset fully
controlled by an authenticated client.

The sibling functions already gate this field:
  parse_dacl()    -- num_subauth == 0 || > SID_MAX_SUB_AUTHORITIES
  parse_sid()     -- num_subauth > SID_MAX_SUB_AUTHORITIES
  smb_copy_sid()  -- min_t(u8, num_subauth, SID_MAX_SUB_AUTHORITIES)
set_ntacl_dacl() is the lone inconsistent path that omits the check.

Add the same num_subauth validation in set_ntacl_dacl() before copying
the ACE, matching the gate already enforced by parse_dacl().

Signed-off-by: Haofeng Li <lihaofeng@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/server/smbacl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index 340ea98fa494..34f0fa43428f 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -740,6 +740,10 @@ static void set_ntacl_dacl(struct mnt_idmap *idmap,
 			if (nt_ace_size > aces_size)
 				break;
 
+			if (ntace->sid.num_subauth == 0 ||
+			    ntace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES)
+				break;
+
 			memcpy((char *)pndace + size, ntace, nt_ace_size);
 			if (check_add_overflow(size, nt_ace_size, &size))
 				break;
-- 
2.25.1

