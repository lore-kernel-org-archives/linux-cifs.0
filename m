Received: from mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208173CA4B5
	for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2026 07:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787901643; cv=none; b=iByGc8wNDC1fNK3i9Gwa9P9uy0jCMkeQueycV36DOIlXoAxnmHwiEUZbqrSciSTxMAaF+6EIfFfmo3EYto08m/opSQuxlFvnSM6Xz/z6UFZlrjyu/ruSpabt0mHYbmbJGHYSwDzlQCBNYyxlEhes8rOZVtG0TmkAwW3oEH4xrtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787901643; c=relaxed/simple;
	bh=+jScTARdytzpsuqYfvYBWQ1fJ1DX7qgU8b5qbsCTMPk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VyA93AZ4svEm7n0VYnL+Om/HCv6LzqpM+odjyf7aCL2WziBe/+mAyOudGl8snUMeQyR9gyCTmsJ/4nXLU8mRyggUnXu3bQ1ixd4sb23FPa8CLlqWa2UTjudpeLMRBJDCeorC8+MwaPVv5NbnitgvjKlKi07B6moHFyp+q3eR6Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dl9B1Pd7; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dl9B1Pd7"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=+jScTARdytzpsuqYfvYBWQ1fJ1DX7qgU8b5qbsCTMPk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787901640; v=1; x=1788506440;
 b=dl9B1Pd77+zLxcPEv0AUh8E+M+hkIyxcp8UXUpI9TYkpZusEkpKfTJbxGY8LRXAaFpD7dkbC
 3aA0idUwvTat9SSWZYfzkhrEjQwd34E8h75kJwHApUvSpiGsDQeo8cgOSx2jU/bKwld8Bsd0wZ9
 NkwBtPqct7xkkZF4YXgJ/Vlo=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f6b3dfc8f37e6b9d;
	Fri, 28 Aug 2026 07:20:39 +0000
X-Mizu-Trace-ID: f6b3dfc8f37e6b9d
X-Migadu-Flow: FLOW_OUT
From: Huiwen He <huiwen.he@linux.dev>
To: linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v4 0/7] smb/client: fix fallocate range operation issues
Date: Fri, 28 Aug 2026 15:19:28 +0800
Message-ID: <20260828071935.552165-1-huiwen.he@linux.dev>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Huiwen He <hehuiwen@kylinos.cn>

This series fixes several issues in SMB3 fallocate range operations,
including insert range, collapse range, zero range, and punch hole.

Changes in v4:
- Add Reviewed-by: Namjae Jeon <linkinjeon@kernel.org> to all patches.
- The contents of patches 1, 2, and 5-7 are unchanged.
- Patch 3: update commit message to document the server deallocatio
  granularity limitation.
- Patch 4: relax the 4 KiB restriction to retain support for smaller
  insert ranges and update commit message.

Link to v3:
https://lore.kernel.org/linux-cifs/20260823151053.935889-1-huiwen.he@linux.dev

Thanks,
Huiwen

Huiwen He (7):
  smb/client: validate new EOF for insert range
  smb/client: validate new EOF for zero range
  smb/client: mark file sparse before emulating insert range
  smb/client: fix data corruption in emulated insert range
  smb/client: fix integer truncation in collapse range
  smb/client: fix stale page cache in insert/collapse range
  smb/client: invalidate fscache for fallocate range operations

 fs/smb/client/smb2ops.c | 188 ++++++++++++++++++++++++++++++++--------
 1 file changed, 154 insertions(+), 34 deletions(-)

-- 
2.43.0

