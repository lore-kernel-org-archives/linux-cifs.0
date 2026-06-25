Received: from out203-205-221-153.mail.qq.com (out203-205-221-153.mail.qq.com [203.205.221.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B19F37269F
	for <linux-cifs@vger.kernel.org>; Thu, 25 Jun 2026 09:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782380068; cv=none; b=IMqrWs7t8ZGuyjY79Pxq1xgWJKwztQ+0E0zAtbgyE0MnsgXktpkh9iNEHd+Lo3Ktj9I+nnCXe97HWhza01EJB0lljCZjReTcxkGDY85aspNVC5M0Wt+vdGPOKazb80L3NRvMW3psXr/VFwGGjbR2sQ8OOX9/eKGXaLIBZOGtBkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782380068; c=relaxed/simple;
	bh=w6FjIWyw90LkPX4A4EDUt6AL/xSRESxmxtXstfV17Cc=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=alguecQzGo8SnZ51uad7RINNOrjMq+3yFIAGQQ80Vj46WLaNPHAOfkbx57lrzwM6z+hTFX7mptBrjkofLdNYBb6Xhd0MgVDJtSdgtW9DwALf2C0v3AX27aTsDm/Il5yrLuNThqsOxvrXil8ApI3SEnNbjeDtrgop9VEkODUhwOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=w2pDR10W; arc=none smtp.client-ip=203.205.221.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="w2pDR10W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1782380058; bh=DZBK98oDlAk3TaC60HDy3Ys+cN1+BR+gBGIu+m+ajUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w2pDR10WveZXItExjdynFX2a/QW6usvs8PdHauX4qFVOVcrHEzUZAtNAvPVxlh9N7
	 S9Jj7u4eF/8NZhhQPUzrj6ExP5S1oi1Of5vZCfrg9zGmGs3gS7Za3JZV9fJ/kGxfu/
	 z95ejgyzCZvT0KgQehxkVs7HT9og7sEEEvuBBPQM=
Received: from localhost.localdomain ([116.128.244.169])
	by newxmesmtplogicsvrszb43-0.qq.com (NewEsmtp) with SMTP
	id 88AA22DD; Thu, 25 Jun 2026 17:34:10 +0800
X-QQ-mid: xmsmtpt1782380052tr3u4fqxz
Message-ID: <tencent_0FF76AC982B6CBEFC907EEB1BD20950C340A@qq.com>
X-QQ-XMAILINFO: NGZp1yYNf7Y+YoqODZiDTe4ePq1APxox9fowPYP8VWGpW6BpSMpRoYsRRmuJTT
	 oG0xKDqAtML87rElUd6Bsp5kWCWNkmQQV5sURkQoplZT3RT9r6cl2d3WCEk5tSC1AqHpnW95xlyt
	 lBI+8DDhoi4xYZq05nsU4slxdci3Pwyg3Aa/WQTnW/c+fsm1BPz6i1SaxXcVhgYccYyxkJQ2EX35
	 l6wD1oXmmiBd3D9wrscoOoyXidZ2LcCfzLjrwgBq9IQ+ZyKP/lymEPz063XnxaTo1Q8uxa0Cki2k
	 zeuTofCzTf3Eb70voOhk/QP5DmAz/ljLCBytbHRwE6i+huz36WfCzP5qj92Kv5AfMtarKTxBaY5E
	 qNILnvTu3PGuBb0dXM8bOuFdcPq25tW4qJpaZsVJrggd2npmCcOJyjdbmlqZx4XU2WphYD237Gw8
	 Xf1sgtEwwsk/eO5x5enRADI4qyYAiMSWj/36k/pDpUpLpsS9YXA/IkWBjx2A20YkTGXzofRbjr5m
	 yplyFuLm3DMqbvzjUNzepXb6O1rvtgzNMV375f7AzoomLxCwML01ZO1EqY9DtXpruwjx8u5k6TzX
	 805sS/+QGwQ3QAgfClGlid/736xFKPkCobUob7zHk17J9+jEcp5LXSre4KfsFf36MpCPKhDxaz7l
	 oDyG1bCHI8jnS+KHMMpkPZjy3wCW+MxChI7IHDki6n6OPEcSnyfsVEBUyGtSNsAsJFoeT/xUz9Ur
	 u3R3ekEK+utTacu0RJXWLNfQjuCHQm5wd1vlYpjJU3Q0BATjbqx9TgbDS3ey5DutIL/a26ZeiYUS
	 TL2ZKp98nGnvGdf546oE1icYVwsUJKE5V2HyiZjb0o0bPlphqjlgkILuJkmnXqHU5MpSLsRXx2Zj
	 K/gJKOARbVcTgXkYdDGOartII9M3bNuAJaQqzjgVOFe710YY854t5wWTpX6UAB9vWm54m40dAlTS
	 Bi70PEvKEELjvWnsYepVAx4VPi0jmvM6PDQ1Uk8WFZYdVPBd1CrlywB13ZYZ96kycjCM31PPGktx
	 jN6glqAtzIRLJ/vRD4a8v6X3Ad03qMXiU6dv0n+qKNTVCm6qNs3AlHh1GnzQDGhzTm77N7Nq9DX8
	 z8/SEa
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
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
Subject: [PATCH v2 2/2] ksmbd: validate num_subauth when copying ACE in set_ntacl_dacl
Date: Thu, 25 Jun 2026 17:34:06 +0800
X-OQ-MSGID: <20260625093407.2859146-2-920484857@qq.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260625093407.2859146-1-920484857@qq.com>
References: <20260625093407.2859146-1-920484857@qq.com>
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
Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smbacl.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index fc9937cedb01..b135133c2609 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -745,9 +745,14 @@ static void set_ntacl_dacl(struct mnt_idmap *idmap,
 			if (nt_ace_size > aces_size)
 				break;
 
+			if (ntace->sid.num_subauth == 0 ||
+			    ntace->sid.num_subauth > SID_MAX_SUB_AUTHORITIES)
+				goto next;
+
 			memcpy((char *)pndace + size, ntace, nt_ace_size);
 			if (check_add_overflow(size, nt_ace_size, &size))
 				break;
+next:
 			aces_size -= nt_ace_size;
 			ntace = (struct smb_ace *)((char *)ntace + nt_ace_size);
 			num_aces++;
-- 
2.25.1

