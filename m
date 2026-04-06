Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A131F239E80;
	Mon,  6 Apr 2026 13:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775483221; cv=none; b=AaCXwDAyHkttI14iHnlqCQMAik6SiuWqDrw34trbSZkI7x/slKtrJUi2E8aMVZE8MDx8ij+NkaZ+pMT7mCU6d0n/YUKPMHOQ0bDdVwz+iPZ3RINVhWWGYHhGTpJuCmzIjBHwy/50AmQh64secFsdRAgyOnDsTc80+2s0IR9/Plo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775483221; c=relaxed/simple;
	bh=3a3ms7S6HXSTmecMy+J7sYm3lCwUvO3MKPcbzv4lHAs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CBqz0Jx/SjI7xpGvDB93eSUz9qa01pPb+mobr7cVf1lSgjdADmoJ3MCt0+r8C+gKZWqUVfpca+ZHqJeIhllMI8QAkl2noZ3VpqE5Nzm6CEy4H6eCJUAhk4qTz/NkuqRCzhbv7dvlgTqNGvXbNUC7MxbmrvBTCbxChwm+y2F63Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SCMPJdAg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SCMPJdAg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF36C2BC9E;
	Mon,  6 Apr 2026 13:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775483221;
	bh=3a3ms7S6HXSTmecMy+J7sYm3lCwUvO3MKPcbzv4lHAs=;
	h=From:To:Cc:Subject:Date:From;
	b=SCMPJdAgwiIj/j9mtZm9scYEhQQ4VMC51HjDZo13edY5jvw1HXqCrLvctk0g6k3uw
	 2RRJhrtWZpsJ+xhz7yFT+uyBgeRbGA4HDlKUlZDLWULZwMHiNyVkEaljg3oQ/kv1Cz
	 svRiKDrXMD+9rfL5j+YP1aisc9SHRnXe7dyoar70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-cifs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 0/3] ksmbd: some potential bugfixes
Date: Mon,  6 Apr 2026 15:46:45 +0200
Message-ID: <2026040644-brussels-dab-6f99@gregkh>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=888; i=gregkh@linuxfoundation.org; h=from:subject:message-id; bh=3a3ms7S6HXSTmecMy+J7sYm3lCwUvO3MKPcbzv4lHAs=; b=owGbwMvMwCRo6H6F97bub03G02pJDJmXd7qUb+u5vXbmBHaLSE2VDmbzf3svxQh/yTx8011cU 3eZfNmqjlgWBkEmBlkxRZYv23iO7q84pOhlaHsaZg4rE8gQBi5OAZgIpy3Dgq6V+03Srl1sW5by V1hfjjF6e8BuboYFl7V6j9Wal/f7rYqYqpWeJXwwVIMfAA==
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit

I spent the time exercising some new fuzzing tools on the ksmbd and smb
code purely because it's something that is simple to set up and test
locally with virtual machines, and in doing so, potentially found some
minor problems for when you have an "untrusted" client.

Here's some fixes for what I happened to notice.  They pass my very
limited testing here, but please don't trust them at all and verify that
I'm not just making this all up before accepting them.

thanks!

greg k-h

Greg Kroah-Hartman (3):
  ksmbd: validate EaNameLength in smb2_get_ea()
  ksmbd: require 3 sub-authorities before reading sub_auth[2]
  ksmbd: fix mechToken leak when SPNEGO decode fails after token alloc

 fs/smb/server/connection.c | 1 +
 fs/smb/server/smb2pdu.c    | 7 ++++++-
 fs/smb/server/smbacl.c     | 3 ++-
 3 files changed, 9 insertions(+), 2 deletions(-)

-- 
2.53.0

