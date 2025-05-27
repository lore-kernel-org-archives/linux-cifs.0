Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D25B1D6195;
	Tue, 27 May 2025 02:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748313465; cv=none; b=ijA+zBxp7VjyIX+mKMUOUg8joFUiNK1YLony8wUVtDsmSMmd/3pnqd7IDM9qdm8N6IqQUpOEtJSdp+LIo1aRuY7EwHFNTSJ1TATtjStwx+mo6jF/Shh/kr9KegYluMxk5dD3biCsilPwTyS2gay0e49gRXBsh58+ACybY1ViBjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748313465; c=relaxed/simple;
	bh=+lT2LEuNni8ViqKn05Nza/0ZecgImC+iyyjaB0KCjJE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=skKruGbIpxoDbLYbSY78V8pU4MavNTmzsZvQWUvD3eaQTeGvLgThY8Vt/au+y0KNSfP2QIf0CeX84bACpanPJAv2ubbLGBCNzg+abFV9M414eaU76lLVhTsDvYbH0opwW8OSbB5/A3T9Lxud0Eno4TgCdz6acM3btLnOuVpFCO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LmxThTx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LmxThTx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7096CC4AF09;
	Tue, 27 May 2025 02:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748313465;
	bh=+lT2LEuNni8ViqKn05Nza/0ZecgImC+iyyjaB0KCjJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmxThTx9b/OWS5rhoOY14SLw4xxdVaRg/6zugvcW1kYPMf7KNSWyhdLi+oyIC27aY
	 1GNmXX6379LOG+ZrKl8yni0+FmdYE7SpJQS3xMEF13Z1Of3c80qUNzouZauy2gd00x
	 SYA9+dy+3M5V9woN0u5zkDtYo+BUX2pi6F5IF+//7y5k3G00B/d3H4H6p5axkLIZYc
	 IgCa8V0dwvaK211vWSa96fVN81USmdM/e2y/pkPYiVx4h4gVtrBWNMdArdNTpAQ6Cl
	 Uns+rzDMAusXiwoUuzC5b03NgYP+kIGS+w9IrwbuWljaBB+v0MDFU6J02XVlFhTTP8
	 9L9OSAAGBwFTg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 5/5] ksmbd: use list_first_entry_or_null for opinfo_get_list()
Date: Mon, 26 May 2025 22:37:34 -0400
Message-Id: <20250527023734.1017073-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250527023734.1017073-1-sashal@kernel.org>
References: <20250527023734.1017073-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 10379171f346e6f61d30d9949500a8de4336444a ]

The list_first_entry() macro never returns NULL.  If the list is
empty then it returns an invalid pointer.  Use list_first_entry_or_null()
to check if the list is empty.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202505080231.7OXwq4Te-lkp@intel.com/
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/oplock.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 03f606afad93a..d7a8a580d0136 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -146,12 +146,9 @@ static struct oplock_info *opinfo_get_list(struct ksmbd_inode *ci)
 {
 	struct oplock_info *opinfo;
 
-	if (list_empty(&ci->m_op_list))
-		return NULL;
-
 	down_read(&ci->m_lock);
-	opinfo = list_first_entry(&ci->m_op_list, struct oplock_info,
-					op_entry);
+	opinfo = list_first_entry_or_null(&ci->m_op_list, struct oplock_info,
+					  op_entry);
 	if (opinfo) {
 		if (opinfo->conn == NULL ||
 		    !atomic_inc_not_zero(&opinfo->refcount))
-- 
2.39.5

