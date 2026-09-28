Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 774FE4F7CB7;
	Mon, 28 Sep 2026 20:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626190; cv=none; b=hFeba+SIylmR9BobrSlaoJBH/0wjY0KbbTst7lQkD2cH33gsw9qYwheUm+dg5Ee/kneHhGJK19N/crR6MkZCSfxSszGzMM2NWsOEJ2IM3iW/Wf5CPPxtrJUk4JGgmJ0Z+pENrVgtp4fKBEAYMfhXO9cnOs558MTmyth8DTP9O04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626190; c=relaxed/simple;
	bh=B3s+WgDx02UPtvXc73jhmByRJcAirc8Vuvq8AfMvxLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGfsC37UWejJidiLVkvQxlIaOj8GE4k1NfCCkGhR602jP1j4kjqJnBVor5BiRgE4N/W+28W6NjEBvX/IsijiQQAGIGNzH84UFKtv99LUP4Wdv7v3xxBBRu5PN2OeKsD95L8av0eHpAqdyUs2rPVE9SeRRZj0FakpQwOEkkhmVBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=4KKsU8sD; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="4KKsU8sD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=G8FxK4C8S9BI0IsaPf3E3gc0fflOw7hqGIK46yRd7A8=; b=4KKsU8sDpr6oPV9X4kveAkQELA
	/oLlKmiJxmxEFcXkqjqt/xT4IumQioKWj8lBemkxEYl1C/Tcwz7sNVG8h37JdnlKxHOxtKb+37I7a
	F9lezdp5TmjUWoQMKdYyaKXbDWcszSGyK/f0wFk1L0GQPWUkqBD3g8he/x11tHspkfhGcrnpbyNkO
	+JeV1PLCqo4ORlgDNsnWQVqQRV1h8jl9YD9NwsqL2y2gXA1lpfGiv3ASm3lxZvdVK97OK1yOkvxJg
	007zE4xBpD0dautrLiCgmB2DGpTNYm2bSfb3Aw/hTmfe7Dc1fSbf/mtSU288vP1QoAnDCYXU0cihs
	dMfXSQvw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xBHfN-00000002UJR-058t;
	Mon, 28 Sep 2026 17:09:37 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev
Cc: Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Frank Sorenson <sorenson@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH 07/15] smb: client: drain outstanding I/O before truncating on O_TRUNC open
Date: Mon, 28 Sep 2026 17:09:26 -0300
Message-ID: <20260928200934.1040189-8-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260928200934.1040189-1-pc@manguebit.org>
References: <20260928200934.1040189-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_do_truncate() flushes the pagecache with filemap_write_and_wait()
before resetting the file size to zero, but that does not wait for
direct/async I/O that was already in flight, which can complete after the
truncate and reinstate stale data past the new EOF.

Drain outstanding netfs I/O with netfs_wait_for_outstanding_io()
before resizing the file.

Reported-by: Frank Sorenson <sorenson@redhat.com>
Fixes: a8603b52b39f ("smb: client: fix data corruption with concurrent writes and O_TRUNC")
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 0d428517f454..d3114cb7fbc5 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1012,6 +1012,8 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
 	}
 	mapping_set_error(inode->i_mapping, rc);
 
+	netfs_wait_for_outstanding_io(inode);
+
 	cfile = find_writable_file(cinode, FIND_FSUID_ONLY);
 	rc = cifs_file_flush(xid, inode, cfile);
 	if (!rc) {
-- 
2.55.0

