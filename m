Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02EA1FBCBE;
	Tue, 27 May 2025 02:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748313476; cv=none; b=kjoYZQ8KMHR58nzHYkIwAD0PKw74pQ0BsO9aZ6vrE2agMzHTb4joJlUDyZZHkNGZ4dajfvUJVJo7+0LACUOhw9qYxukG60fAThwIjdi1LN/XqVGcjrYPAZBHGikz5UaPSp9g52aBiffEu9/kjIs9xXcBt4I0sGbNAJf6EY/Hbdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748313476; c=relaxed/simple;
	bh=+lT2LEuNni8ViqKn05Nza/0ZecgImC+iyyjaB0KCjJE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ayqJuhzk31xQE+CXBEi5b+lI6CrSkNi/KQJqPGXu8wGR74+ggye/MXLkSWdy31NszUfrfqsoSYsanDyMZMWgLI4XtrGXXiiZgiIrIB5xVHzh1HcAYU1d6IYoFilSHRkBID458X+WEvUgDCzPAjINlwjAFwpwjBmDt2jrEvYuoy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rOrDJ1Bd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rOrDJ1Bd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228FCC4CEE7;
	Tue, 27 May 2025 02:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748313476;
	bh=+lT2LEuNni8ViqKn05Nza/0ZecgImC+iyyjaB0KCjJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOrDJ1BdqyNhIlEHhunYCusu0+4nE4OPJd52PpR/vQIb2EwPfkp7YxI+ZviGVeyGW
	 FRy0a8L1BJtCf12GI+O2JMfy8EXl12wti9aMiSogfgGq2Si7GsFa7EkOAzaEXBdCuu
	 mYWGkfpX45dEfQWU2aWaZcamuvvAdJfxxBkxpo8qB6/ARIPVpbHsVENhCPsPKclxW/
	 +3gA6gfwKc/cmBm4RJ2oyEzfzauMWd0rQXYr+ZOcUbZWZCLJJzRNAJiL8l318NEk8k
	 DHns7feYi1nv5cQy4kc4uuLeu1bbfYf2s/ujGmUP+7On/tSnuXBkI3hgUN/RzkdmzV
	 9V8fHFvBC5JAA==
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
Subject: [PATCH AUTOSEL 6.12 5/5] ksmbd: use list_first_entry_or_null for opinfo_get_list()
Date: Mon, 26 May 2025 22:37:45 -0400
Message-Id: <20250527023745.1017153-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250527023745.1017153-1-sashal@kernel.org>
References: <20250527023745.1017153-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.30
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

