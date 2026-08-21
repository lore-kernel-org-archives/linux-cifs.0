Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0635E3515CE;
	Fri, 21 Aug 2026 02:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787279121; cv=none; b=KYZgaoa0iV4cp2CsKodrU/6fC7ZKyYzxOAkXF73td2XqsURZ0Htt83SjOJ2oRirJoYnIHdB2qVBnB5S5Ev0b+PgSN8lk0Trvc1y1J15fItq/UvBbWZzViN/00OuxTNVyVyGy4NbhEPle913WnCHugmSXT7CbOA26yAVn4EBTxGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787279121; c=relaxed/simple;
	bh=hkYBbG8FA3hR/kddRkbidPW5t2Eag5CGjG7PEIkKtwE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TbdfYAJD1M5ZPG0UVM6AkWNL60ZkQ03GXt2CERyGI3WzNZTKnadfgdIFNON4pBm10LXWr1pL+77i4eNNljjXJqcSIAEj6bwEtzG6mjEU90lix8EERy3qpa1lsvM8C21T2Q4PkKX2tvbun3KGxUmSeKpB+/wMHko7aK7gRXNqArA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r5aKzZGc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r5aKzZGc"
Received: by smtp.kernel.org (Postfix) with ESMTPS id B520AC2BCC7;
	Fri, 21 Aug 2026 02:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787279120;
	bh=hkYBbG8FA3hR/kddRkbidPW5t2Eag5CGjG7PEIkKtwE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=r5aKzZGctWR7455u7n22a/eVHm7cyApXgGV0XQucQpbIPRLYZuciV2UMcMr894iu/
	 KQFSbizipPs8uDnjnZUfTD7S1Yq5zNVJIY8V9JeyyIajZVVbRg6E60cPet3btB/8qP
	 MZkCou349q5Xkmd6pUQiExzkHTBH0KNUyR3fhgHmeC+z1cgVp7uvzsdFm3r3ldqeLP
	 UD2yE1QLliAYVZayZ/eUkRdBJPIgYSdEPYzfOlrAVpx333rLLvi7f3rSZaitnFtdI5
	 Wc/da7NnT5j+VzTl4rQw7w355jhgfFTW0Moa1ZCvIrq8V/ZZIu0JSzP6eTsDqHtp1p
	 wOcOl/2/r9YmA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A2CC5DF8F;
	Fri, 21 Aug 2026 02:25:20 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Thu, 20 Aug 2026 21:25:21 -0500
Subject: [PATCH v2 2/2] smb: client: reject a tree connect response whose
 byte count is too small
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-b4-disp-58f78a28-v2-2-1fb7a6cb1533@proton.me>
References: <20260820-b4-disp-58f78a28-v2-0-1fb7a6cb1533@proton.me>
In-Reply-To: <20260820-b4-disp-58f78a28-v2-0-1fb7a6cb1533@proton.me>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>, 
 Shyam Prasad N <sprasad@microsoft.com>, 
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
 David Howells <dhowells@redhat.com>, Nathan Chancellor <nathan@kernel.org>, 
 Tom Talpey <tom@talpey.com>, llvm@lists.linux.dev, 
 Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
 linux-kernel@vger.kernel.org, samba-technical@lists.samba.org, 
 Jeff Layton <jlayton@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787279119; l=2384;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=jnZThUSNJS01CGO4lQzrO1j6YlnsYJLpzBtHx4exYdM=;
 b=w+/8Ihs+uz3rUM7EkxCLzcvtmL5f1IxPJsPnfuu+gT7d+3HRyjmDZeQJ/F9s+3IeFuOftzIIG
 oSnIGaY9WwNC07/DHz4+YkuMOblDdJgGv6XfZeMscePfWzv49dxgpjh
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

CIFSTCon() bounds its strnlen() over the byte area with the server's
ByteCount minus two, which for ByteCount 0 or 1 goes negative as an int
and converts to a huge size_t.  The later subtraction wraps the __u16
bytes_left, and that is what bounds cifs_strndup_from_utf16(): a bound of
up to 65535 against a ~16 KB cifs_req_poolp object runs off the end of the
slab object, and the bytes reach userspace through tcon->nativeFileSystem
in /proc/fs/cifs/DebugData.

Reject a byte area too small for what the parser consumes.  Two bytes is
the least the parse can consume, and no conformant response carries fewer
-- the Service field is at least "A:" and its NUL.

Fixes: cc20c031bb06 ("cifs: convert CIFSTCon to use new unicode helper functions")
Cc: stable@kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 fs/smb/client/cifssmb.c | 6 ++++++
 fs/smb/client/trace.h   | 1 +
 2 files changed, 7 insertions(+)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 1f77512252e7..f5aad5f61dce 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -615,6 +615,11 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 		tcon->tid = smb_buffer_response->Tid;
 		bcc_ptr = pByteArea(smb_buffer_response);
 		bytes_left = get_bcc(smb_buffer_response);
+		if (bytes_left < 2) {
+			rc = smb_EIO2(smb_eio_trace_tcon_bcc_too_small,
+				      bytes_left, 2);
+			goto out;
+		}
 		length = strnlen(bcc_ptr, bytes_left - 2);
 		if (smb_buffer->Flags2 & SMBFLG2_UNICODE)
 			is_unicode = true;
@@ -670,6 +675,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 			reset_cifs_unix_caps(xid, tcon, NULL, NULL);
 		}
 	}
+out:
 	cifs_buf_release(smb_buffer);
 	return rc;
 }
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 0a91d3aaa079..12241abb8e2e 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -133,6 +133,7 @@
 	EM(smb_eio_trace_sym_slash,			"sym_slash") \
 	EM(smb_eio_trace_sym_target_len,		"sym_target_len") \
 	EM(smb_eio_trace_symlink_file_size,		"symlink_file_size") \
+	EM(smb_eio_trace_tcon_bcc_too_small,		"tcon_bcc_too_small") \
 	EM(smb_eio_trace_tdis_in_reconnect,		"tdis_in_reconnect") \
 	EM(smb_eio_trace_tx_chained_async,		"tx_chained_async") \
 	EM(smb_eio_trace_tx_compress_failed,		"tx_compress_failed") \

-- 
2.55.0


