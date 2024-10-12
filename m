Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B4114A617;
	Sat, 12 Oct 2024 08:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728723391; cv=none; b=huS12W4v4Lbjo3C7SS2ZduUOP2p6ZWADMgRtMaaePAV+UVgdgtdekmFFatHVVmsEWfsD+hSHolWV1uzfZOe8iaIGKc0uaaX3RwJGobXYiUOorOUbpAsDjDWw2hD97cJNZpd28fh9KNIqN5n4/9/IInrpQcUwIY4nDxVaPebkPus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728723391; c=relaxed/simple;
	bh=5x2dHJDCTdrmv146GBva78X3KSge+LDUkh4+nctDo0Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LCwfLLX2LkLn+ZPUERt0mOfLzowTK6ippaQ6W1h1c0In99hQoORM2RmD9EiNJsahwlRSXoieJ14TeLx2V7+Ub1f553FM0mnRvUdlIFEYEfva6AUnLprL2CQxJ8rtB8jztD/Jm17ni8MuJsdw+cVBvqrgzuLXpZ00zD9Hpz/40xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HjMktIA7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HjMktIA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27236C4CEC6;
	Sat, 12 Oct 2024 08:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728723390;
	bh=5x2dHJDCTdrmv146GBva78X3KSge+LDUkh4+nctDo0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjMktIA78XloQkt0u19d3dvlfoNH1eImriPs+d8Hcym7jHjCN+wtaiJ9TgMQPndMo
	 nxzSbow2Dww+B+2SYQCvPYkBxRb0rhtfR5SCJcLc18GFcmrRPbfXdZuudGDm7/tcJl
	 pVM/PI3qNHVVRoCVHlttn9qHlkffMVGG95aN/gzilkAdaB1qNNdhpYIhC/3ZkJ9PfC
	 x6Ion2o3XjT2l70t8EHWPfmFBxxuumjrcuNZ6M86EwPTwtTO1nJNrgiT1BITiYXwSs
	 lxwiC1RuZldmLoAIqBcXE/xvjFxO77oUfsFptTDsTY2z4Qr3cRpvWFbFN+iVuBD5lO
	 D9mHmoNRwpuug==
Received: by pali.im (Postfix)
	id 52CAC7BD; Sat, 12 Oct 2024 10:56:21 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 7/7] cifs: Validate content of WSL reparse point buffers
Date: Sat, 12 Oct 2024 10:56:20 +0200
Message-Id: <20241012085620.746-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241012085252.560-1-pali@kernel.org>
References: <20241012085252.560-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

WSL socket, fifo, char and block devices have empty reparse buffer.
Validate the length of the reparse buffer.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index b9a50eb03522..3de91331c96c 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1083,6 +1083,11 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 	case IO_REPARSE_TAG_LX_FIFO:
 	case IO_REPARSE_TAG_LX_CHR:
 	case IO_REPARSE_TAG_LX_BLK:
+		if (le16_to_cpu(buf->ReparseDataLength) != 0) {
+			cifs_dbg(VFS, "srv returned malformed buffer for reparse point: 0x%08x\n",
+				 le32_to_cpu(buf->ReparseTag));
+			return -EIO;
+		}
 		break;
 	default:
 		cifs_tcon_dbg(VFS | ONCE, "unhandled reparse tag: 0x%08x\n",
-- 
2.20.1

