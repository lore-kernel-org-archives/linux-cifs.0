Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53D9170A11;
	Tue, 31 Dec 2024 22:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735684551; cv=none; b=WsdvnakFHObas8qEZ7x6p4+AaTDvtakb0A3PvQ++MK3GGJuMwctF4wiKE8MmDLLX8yeJ/YJr4Te/warzhiSC9QE8sBtX6STFqRfJfFZaPpIQmDKDPkidyiNAEJ9BPoEWVCZ3IHa+9mUxumHtXlLErw4oRYF3q9/gF6k27HQRX3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735684551; c=relaxed/simple;
	bh=2lN8Yf08Rc70bynorQlGAxZReDCriIUXlHP9bvzS+l0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S67urFmL+cdYBbfBERLwty3DxD5Nw8HkikD7cxhKlmkCnbD0As6cBACNw7s88BU7O1Hs5hH2WWUnY0bcoFjWlExoZPqHHtUjrUbvHMil82X3eNqmfpZsGlF9WFnf7oGbgqvVbFZLEe4gydWcJjeDPkWO0vMXxBsAzVbWtyfP73I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N3A4xnJa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N3A4xnJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFB9C4CEDE;
	Tue, 31 Dec 2024 22:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735684551;
	bh=2lN8Yf08Rc70bynorQlGAxZReDCriIUXlHP9bvzS+l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3A4xnJa7xBLMk3EfYXeaOBEcaht0HgzjFqXnVnhSPReM4SDF3Vpe2PUj3ukM0xle
	 e8YPVkC/vp5PC1sgq6d3NssSdGzi/PLQbtKlJqQ5MzTasx+3B70d0SL6Vgxs7vL0KJ
	 nZxcBMyehlt69qvXythBVhmxmjbHxPye1KJZt+O/16SALuN61oeiMvHo6/nTHwy+Od
	 K4UEuyi7WvEWXu3SfH7wFPbQm3xJf48/KJlV6etaXHu2P2G6IzcNkp5VxlD++AcfN3
	 fu/KB4gE5RRi/0GkP+pk77swPUIkWNVrdm04Mm3+ZiVmmU2+dTlg2oPA3MX0pwNvTw
	 Ycp1xNVBe7YNQ==
Received: by pali.im (Postfix)
	id D8B35983; Tue, 31 Dec 2024 23:35:40 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] cifs: Do not add FILE_READ_ATTRIBUTES when using GENERIC_READ/EXECUTE/ALL
Date: Tue, 31 Dec 2024 23:35:11 +0100
Message-Id: <20241231223514.15595-2-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241231223514.15595-1-pali@kernel.org>
References: <20241231223514.15595-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Individual bits GENERIC_READ, GENERIC_EXECUTE and GENERIC_ALL have meaning
which includes also access right for FILE_READ_ATTRIBUTES. So specifying
FILE_READ_ATTRIBUTES bit together with one of those GENERIC (except
GENERIC_WRITE) does not do anything.

This change prevents calling additional (fallback) code and sending more
requests without FILE_READ_ATTRIBUTES when the primary request fails on
-EACCES, as it is not needed at all.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb2file.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index 1476cb824ae4..0f3d20b597d6 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -158,7 +158,16 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 	if (smb2_path == NULL)
 		return -ENOMEM;
 
+	/*
+	 * GENERIC_READ, GENERIC_EXECUTE, GENERIC_ALL and MAXIMUM_ALLOWED
+	 * contains also FILE_READ_ATTRIBUTES access right. So do not append
+	 * FILE_READ_ATTRIBUTES when not needed and prevent calling code path
+	 * for retry_without_read_attributes.
+	 */
 	if (!(oparms->desired_access & FILE_READ_ATTRIBUTES) &&
+	    !(oparms->desired_access & GENERIC_READ) &&
+	    !(oparms->desired_access & GENERIC_EXECUTE) &&
+	    !(oparms->desired_access & GENERIC_ALL) &&
 	    !(oparms->desired_access & MAXIMUM_ALLOWED)) {
 		oparms->desired_access |= FILE_READ_ATTRIBUTES;
 		retry_without_read_attributes = true;
-- 
2.20.1

