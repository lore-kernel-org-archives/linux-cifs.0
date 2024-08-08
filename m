Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA03156C78;
	Thu,  8 Aug 2024 22:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723154648; cv=none; b=j8rDo2F4NNJW2cXwL2Zavz/MqAQgPMDMUo4QVMKImIszYXVLWUcIC6Fd007U/NdPeRu2hFiMKBjeH/yk+PU795NSy21DW4LySHIy3G/Mo1V8dhn/EHC7lXv8LeqpQE04glv6OqyV18zrW2liCUAirJlGZtL61syrMncTZaghpAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723154648; c=relaxed/simple;
	bh=vF3wxdSW9XO29eue8EVs7PMb8qOZVTLaCZnW3y2XlEI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mCx8LaoUjC/AGBwqLch8izEVLkyHmeV7jxBP2I7mnzVp0fEbl0j1IYsjzioRIrq1QmROfh2QPhod8zQ4trJNSecuTzsO4W/aJ6tTZXsZTza/Vp2NC1WVhPOtfAaKxk2SUyvq+TLAzGTRAJoUfaLNE9PiynaIlcOZdx92uiwJBbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lcbT6Dfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lcbT6Dfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37E0C32782;
	Thu,  8 Aug 2024 22:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723154648;
	bh=vF3wxdSW9XO29eue8EVs7PMb8qOZVTLaCZnW3y2XlEI=;
	h=Date:From:To:Cc:Subject:From;
	b=lcbT6DfdERNNi4oaIhiOd7UkjLo5R9abMgt/Pzcso+b7cTE1w94h+uIJL8b/jcxN7
	 Au1aiy5WMDU9xEqr00hYZd40X3QIQ6Ycjqpr77k37929VKTnjoiBFWBYb0AfuOIDap
	 HkFKOO6alCWoNGHq830g7/5MvN10XgsBmLxf/KkND3IzZgzwHppW3/acKO6b5OinyL
	 5yB9qfwhD3VfK/PYQPr7u5hqFMngHBhhCCYkquFKbIhu4kGpFvnha/HfAZzx2nwu6n
	 6aez+O8agRvbBZLvy/Mt6h5T57UQ5XXhl4THbUGr49TaGbcI9IqtCmefdqgMFOkx8E
	 iF7uLMqpjpmew==
Date: Thu, 8 Aug 2024 16:04:04 -0600
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>, Steve French <sfrench@samba.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] smb: smb2pdu.h: Use static_assert() to check struct
 sizes
Message-ID: <ZrVA1N6Iv0Byb3I7@cute>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Commit 9f9bef9bc5c6 ("smb: smb2pdu.h: Avoid -Wflex-array-member-not-at-end
warnings") introduced tagged `struct create_context_hdr`. We want to
ensure that when new members need to be added to the flexible structure,
they are always included within this tagged struct.

So, we use `static_assert()` to ensure that the memory layout for
both the flexible structure and the tagged struct is the same after
any changes.

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 fs/smb/common/smb2pdu.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index c3ee42188d25..c769f9dbc0b4 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1216,6 +1216,8 @@ struct create_context {
 	);
 	__u8 Buffer[];
 } __packed;
+static_assert(offsetof(struct create_context, Buffer) == sizeof(struct create_context_hdr),
+	      "struct member likely outside of __struct_group()");
 
 struct smb2_create_req {
 	struct smb2_hdr hdr;
-- 
2.34.1

