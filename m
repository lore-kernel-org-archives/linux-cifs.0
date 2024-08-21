Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF0D3C0B
	for <linux-cifs@vger.kernel.org>; Wed, 21 Aug 2024 03:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724211914; cv=pass; b=QHICqG6XmkTgNzJdj/LLL0IM5iU3Wg5t1MaBnbBv5pa810ZKnJe258lqKb25E0RuC906uVzMA+gT1TlWYllWtAsb44BhdNVsKzGDrup1d3kamDLjIrDtXkUp2wpw9iOhQFyMPRb+FKmGPWikCUkoiV+QFW7a58TXASA5HITsg3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724211914; c=relaxed/simple;
	bh=p5c4ArW5QB3tk5afngAqDYJwwZNa/mWK1B3viCNc7iQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bO7HGPGfft2OMS1/70YCShKxh3z75seMbmXwOG7TbvyIzrZddAT4Z8a8jQdQ++hlO2QeT6/0lVm5b2QW/IazISgRzL35aHbRCRrCnXdsY4LwUR+oWCYU0tFVCx1o+x7418tj2kxySOvr7nsAopYeeRmWts+7azPTv1EZBus3024=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=lmfmYvzf; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="lmfmYvzf"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1724211909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=t/IMq/+2dham5KZZerTTUGIhAaKVVOVqsnzXljAaTlw=;
	b=lmfmYvzf5kBGQCCdxwLPnMq1+s6bPsXPBHh4f1vjrNTUKkpLuFfiCqnkIwOdVR0ngEGMRv
	2mQczZBujtZXlCZUGiq8+cQSFL3GV9VgzfnPReFhlQ6ULTsmkP0QdlUfjLHGE6x9NKfOx+
	/aq88W0G51qL/HVyqawNiwotV6s9WKBUo8Xs37LruaNIEKrAorS6Kkbbky2rTZGjvJ4RZ/
	2VpRosNRGJAk9sN894Mq88StZClTfwhVwcwwNLBs1r3mpbMWbPh3vNzR448J2AKDZzHNc3
	z/k1TQrdE6agEXn2JTrnrrEajHeYse91NfZt38RhDWK0UfQOzClKBe6R1gTm+w==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1724211909; a=rsa-sha256;
	cv=none;
	b=X0GQwigQyOyjtj+wu+abKk5621aRjKX9wrBccEdTEittPpQKQ+TnPAph4zcC6c1+H4od0e
	krGvWm6GBk1NStKGq8UesKSL6vflLPcnLALfJte/nP29vrOcMy9boF1wMoJ2r/NJuiKFlG
	u+gyQIvYntEg/7J9Ve4O0s+ltMdho3LiX041QLiVxK7IZ15kYDk2KaI7GqsH2NIhdWNWAi
	IVmtXEjzG4hUkaZFde/WZcZyi3OYWV1iDTRJvu5hfr7WS1j4BIrTk1dnRn/qLRe216mcfT
	a8w/siul9GYaTquom3p7j1KXALBIy5e2vqF0VvYYniR3YbOQ3afwE6f7aGpY1g==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1724211909; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=t/IMq/+2dham5KZZerTTUGIhAaKVVOVqsnzXljAaTlw=;
	b=Imp3uWjrRYjlN1tA2BI7CqzLOHxkFWQLZACocQBXbkftjguG1pVCX9OKreUxK6qCpnZDFR
	IDtI0mCPWena7Xx+Rp6SvZbDoTRslPJVWZ7yhzWOsCv9t5j8BWjMtFOcS+xdBnIIM7ylqa
	op6Rq1zB1hfEh9qfvoOg4TLbb9IPA5bxZxFNl2Bz7aUtxQZdryxM0B5dML8p59NYAU9vXU
	dVzs28MHSsKMUSrpVoe7bwVyQ3hA6qsy6dJXxitlZ3LSi5WRy3m4mPF+4xGjvg6518kkEZ
	ZeskmJ+C4/+TIsMTiCY5PJf5upMt7MBMsjY/9IuMSqCtYPNfY99Qw7xrVBHj8g==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	Marc <1marc1@gmail.com>
Subject: [PATCH] smb: client: ignore unhandled reparse tags
Date: Wed, 21 Aug 2024 00:45:03 -0300
Message-ID: <20240821034503.739532-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Just ignore reparse points that the client can't parse rather than
bailing out and not opening the file or directory.

Reported-by: Marc <1marc1@gmail.com>
Closes: https://lore.kernel.org/r/CAMHwNVv-B+Q6wa0FEXrAuzdchzcJRsPKDDRrNaYZJd6X-+iJzw@mail.gmail.com
Fixes: 539aad7f14da ("smb: client: introduce ->parse_reparse_point()")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/reparse.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 689d8a506d45..48c27581ec51 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -378,6 +378,8 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 			u32 plen, struct cifs_sb_info *cifs_sb,
 			bool unicode, struct cifs_open_info_data *data)
 {
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+
 	data->reparse.buf = buf;
 
 	/* See MS-FSCC 2.1.2 */
@@ -394,12 +396,13 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 	case IO_REPARSE_TAG_LX_FIFO:
 	case IO_REPARSE_TAG_LX_CHR:
 	case IO_REPARSE_TAG_LX_BLK:
-		return 0;
+		break;
 	default:
-		cifs_dbg(VFS, "%s: unhandled reparse tag: 0x%08x\n",
-			 __func__, le32_to_cpu(buf->ReparseTag));
-		return -EOPNOTSUPP;
+		cifs_tcon_dbg(VFS | ONCE, "unhandled reparse tag: 0x%08x\n",
+			      le32_to_cpu(buf->ReparseTag));
+		break;
 	}
+	return 0;
 }
 
 int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
-- 
2.46.0

