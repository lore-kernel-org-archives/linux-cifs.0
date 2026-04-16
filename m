Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896A913B293
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 19:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776368064; cv=none; b=FFFQ/CBg0+aXtcOTPCIHB+uMLW0z0NeE+7X4FMMBqjBEo3oFOtTHFitzffZLa1ldDbxHP17Zf+pU9Au44gli39365AfNvtIQ+dFQ+8kOkc/MWp9nJUZbKkirxyUQEw2gYt7+BiYhQ1fFjlFBpSeobBzMXp/GJI/aCfOHiyy0000=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776368064; c=relaxed/simple;
	bh=RFC3QVim0arIk7Lv3+cfW3gLQfc41MwZTxdP0bP0ces=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rbnmFpnVbG0+CLXtPxZfpNgx2qkyt4wbFJlLi/T/mGgPvMbx4lktAYPBfVIsYXLJ4qTBSu7fNsVTB8kTqtm8cwqTMlQB9XR7LTSIuqhLJpBCWq/+cQx6JKyuQvZwANQyBNO/emE+XlUUGzXQjj/YEL33WZMatdQWSFtgcj8LJwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IluCM8BE; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IluCM8BE"
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-7b6ae2ea4a1so35958407b3.2
        for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 12:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776368062; x=1776972862; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pDgrzdmqtoSKjkQ3Rpvi5tSh9COrIxr3KsgGxPSv/G4=;
        b=IluCM8BE6qXvwb/XaHTy0ZndDb8hI3MN/AXSVSzL1aW1CWpSKx6nJQq2P2bzSwQLgg
         xiLog1LrAMWDKcmo3SDbeUhd7nOVaREjRih8rYnWluVb1hXx6ADqpC9DLyPo8pBTDtxw
         b/kG1oIHIUxgeum6GK9nR3fQl28ivhGWQHcT/SveKHt1VWvG9QNY/WkMzE/jcqqzD0IT
         fbXen9ybJzTa5S54A2BuKQLp69R1eOBtOJ5VYC+iLtE1p0LE0uRrNLbWkxZJyrJYdDpm
         FIIYEmTRffJHM9xrP6hw+CwymuFGIT8Mud2ml6gHpBKsFYtoWXRHMt+fLtZfjXlEJJAw
         upTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776368062; x=1776972862;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pDgrzdmqtoSKjkQ3Rpvi5tSh9COrIxr3KsgGxPSv/G4=;
        b=MJ0vJd5TxM+nEdQEqq6A34+1fgdR+es2+Zx515U9UWiOSTFs3cDwukHZEQifVDensX
         FhIEItT1A71X6VNNh9QOb1/OHnBTrFqUA4zB6QKsCWTxedXNObvDaANc3fFr3MCfW0lv
         RDd6P1uMZn8OrjdL+L/rMfZAEuVY4rVB1a8UiUmY+IneRe/EOyL+2uP42Uxk0z1JdEJj
         X7+umb8Ldg/Hiw1VVM+HALdpxoE/7AL9lDkQaw/QL2kh5WzaG2S7F5oAM2+w6o8pgEJA
         ju8H0EnlHO/dq8MDFRDD+CygtnSKuPwroev9AI04h5j6o4WxHgSnHHAtBz1f6O3S0z3m
         D1SA==
X-Forwarded-Encrypted: i=1; AFNElJ9VC7zvqRlbkvccBA4ABuz8wzGzS0YAsJBEUJBotwQMpbMJMt91OmLPQ0GNrvN1wj/yJzIW29tylrJ2@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5MIYC6xK4adBCd0KRG0YB/IdfaU7SPPxyGufIEsxmyxUG7LCa
	Y6bPzas0K0lqa4AeySzCwOAWIk3Nbv6VJGEP0jQs7anHBgMmf1BRBzswKSrvNVDp
X-Gm-Gg: AeBDieuihbYVDVByvmYe5HSIj7JF3E/VVQbSJVEepvppksi2H6hA6yfFfseOFkU4fFC
	KzmxJX36/Jp+gPtu6kPFzUTuBNnMUE389ZL0O6WPQ+YfkPnQRq4+Vmch018BICkS2edpzqZXgGJ
	mww34pBWUv1/ncCvsEINwEapCStrFEChKN4Z4DdTE3Zp8w6CPYFJLzAI4wAOEo2wgF+02+LmsRY
	qpnro6ExM3ZphLdNmpBXg6vtncQOp47VuMIQhNSRDYhhWDsp4nBXjHuH1n0yX0szzeABvD9iGhn
	naknxDX3uaUXPwRzW6IqP5ek0G/mIhgDSCHjZyP9tSy9oKWW6IKK3rKI5FO/ClzSL+IJc81snCP
	TK3vraLpb568dgKdYhwk/Fr7SzSOyy6dhcTnVzoR5NugiPCzCt3UWGlVL9bK1yRUnm0OcluL2ZF
	5corUGXiRqOcK2LpY3JTyKuPfc3lClkPY7JMFmEU8PklRe/HEwMluRJGK6Cx2oRSZCFuNtaDH80
	GZR+ioHJQFcsCUx/WNM56cu66Fe3nRvzEsPL0J5tmAFIgBqtZiqvQ==
X-Received: by 2002:a05:690c:86:b0:7b7:c69f:22fc with SMTP id 00721157ae682-7b9e19ec401mr4952117b3.10.1776368062426;
        Thu, 16 Apr 2026 12:34:22 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ae6cda9277sm42594576d6.41.2026.04.16.12.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 12:34:21 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Steve French <sfrench@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: fix OOB reads from server-supplied dacloffset in cifsacl
Date: Thu, 16 Apr 2026 15:33:25 -0400
Message-ID: <20260416193325.2950619-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi again! Sorry for the piecemeal sends as I work through triaging
all of my personal "clanker" pipeline results.

Here is another malicious server issue, this time in two call sites
in fs/smb/client/cifsacl.c.  We compute a DACL pointer from a
server-supplied dacloffset and then read struct smb_acl fields 
(dacl_ptr->size, dacl_ptr->num_aces) without first checking that the
8-byte struct header fits within the security descriptor buffer.

1. build_sec_desc() -- chmod path:

    dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
    if (end_of_acl < (char *)dacl_ptr + le16_to_cpu(dacl_ptr->size))

2. id_mode_to_cifs_acl() -- chown path:

    dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
    ...
    le16_to_cpu(dacl_ptr->num_aces) * sizeof(struct smb_ace);
    le16_to_cpu(dacl_ptr->size);

In both cases, if dacloffset places dacl_ptr at or past end_of_acl,
the le16_to_cpu() dereferences are OOB heap reads.

Reproduced under UML + KASAN by constructing a 20-byte smb_ntsd
(sizeof(struct smb_ntsd)) with dacloffset = 20, placing dacl_ptr at
the exact end of the allocation.  The le16_to_cpu(dacl_ptr->size)
read triggers:

  BUG: KASAN: slab-out-of-bounds in kcifs2_test_build_sec_desc_old
  Read of size 2 at addr ... by task mount.nfs4/220

Confirmed -EINVAL without splat after patch applied.

parse_dacl() already handles this correctly with a two-step check that
validates the struct header fits before reading the size field:

    if (end_of_acl < (char *)pdacl + sizeof(struct smb_acl) ||
        end_of_acl < (char *)pdacl + le16_to_cpu(pdacl->size))

Apply the same pattern to both sites.  This is the client-side
counterpart of commit beff0bc9d69b ("ksmbd: fix overflow in dacloffset
bounds check") which fixed the identical class of issue on the server
side.

Fixes: bc3e9dd9d104 ("cifs: Change SIDs in ACEs while transferring file ownership.")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 fs/smb/client/cifsacl.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index c920039d733c..115990467dfa 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1293,7 +1293,8 @@ static int build_sec_desc(struct smb_ntsd *pntsd, struct smb_ntsd *pnntsd,
 	dacloffset = le32_to_cpu(pntsd->dacloffset);
 	if (dacloffset) {
 		dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
-		if (end_of_acl < (char *)dacl_ptr + le16_to_cpu(dacl_ptr->size)) {
+		if (end_of_acl < (char *)dacl_ptr + sizeof(struct smb_acl) ||
+		    end_of_acl < (char *)dacl_ptr + le16_to_cpu(dacl_ptr->size)) {
 			cifs_dbg(VFS, "Server returned illegal ACL size\n");
 			return -EINVAL;
 		}
@@ -1662,6 +1663,14 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 		dacloffset = le32_to_cpu(pntsd->dacloffset);
 		if (dacloffset) {
 			dacl_ptr = (struct smb_acl *)((char *)pntsd + dacloffset);
+			if ((char *)pntsd + secdesclen <
+			    (char *)dacl_ptr + sizeof(struct smb_acl)) {
+				cifs_dbg(VFS, "Server returned illegal dacloffset\n");
+				rc = -EINVAL;
+				kfree(pntsd);
+				cifs_put_tlink(tlink);
+				return rc;
+			}
 			if (mode_from_sid)
 				nsecdesclen +=
 					le16_to_cpu(dacl_ptr->num_aces) * sizeof(struct smb_ace);
-- 
2.53.0

