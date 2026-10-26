Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793053574;
	b=qUqhgLLAe39cSTSVI3HxlthoUZ4k8VMxuLb2sbVu0y7EyD6Y4mVUMrqn4EK3V79GK8Gd
	 wg4HiSte95a5qw6eGwBz3R53TsgDycN1ZvDhBMP33mijy8uXDnZbWmN9Gk1U0+apGYXKL
	 slvyyed+SECTaP//AcFYcP0Exnrh+Do0/h298nfQewMGlUGFFJGM4Nw0gnoKQ8RNiufRT
	 RTowlNWaqjnzPSJ5XtjWoKrKQTUH8yiXMc8GQ8oeqQ0cMFLK5Ge/WIvliFZ7bCtICDvhU
	 X6HTJFf1ZOnuAX+MApVNsi9qj9U3HOtFJqSFG8e8uHfdXnR9ecXllUdYEbv9nfk2TeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793053574;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+pKWqsZtpVaedfq+57u2C6voph2c6P1wUpIm/ILOreQ=;
	b=rv7jfX4J7CXE9GZA3IoVV5q6s1br3NBOUEFUvwLL/USqgFkht7o+WDKfbAYnQXhzeLQt
	 8zeFLECY+S+eUXXUK4rCjedtI3BLYaaue3fasAlurGjJif9AaFgO6F0IrYi5HqMW15PgK
	 jr6uWovVsuLMEUgdse6lFyXkOhl2zrYTm6WeCriQ9MRH2Mua2kKMD+rAkJVZ9yCMLEXlU
	 MrhuqtDdRMRRNIQ4Lo0ulyXDM3S8Ajd/NgT05l2WEiFt4EKLzq/MPHmR+Kbyio5XooY26
	 Xmm7Rdcgrd8AIhKy0Sps4CWOkU3WwEg295IKqB3qYMcRgCu+pyNBGWI5kZ8Ngpdlmwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CvPvRG0J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DD3606A31B;
	Mon, 26 Oct 2026 22:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CvPvRG0J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C011F01825;
	Mon, 26 Oct 2026 22:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793053573;
	bh=+pKWqsZtpVaedfq+57u2C6voph2c6P1wUpIm/ILOreQ=;
	h=From:To:Cc:Subject:Date;
	b=CvPvRG0JrZvk18vrkdQR+yFevbRsGwq81SuXnA4iDvz6tdaNb6PxmMiCdBAa3K5wR
	 yfIen6/j4qm70eRlQ7ouQX4wJWgq7IcBZWUQp+yLCQxLeYxGuhzhqb2SGEWK7YepkB
	 yc00qYGioe/MsV1JR/K3WkQ6ifEbkOTDPNXwjv0W5z+JvYwfGi4dYefxh6Ng/goNc3
	 f/dMNEKRRLxRUfnQoDl4qv57jCLsis8589tzfWcX0Npd9CaHHr4B3XWN9zMcVWQYuw
	 otOtX+jP4OwvZBI3JislYGOIj9M1GZIZEVsFlSUbFV7UzhSTXXDrMYKTp4m8VAoqRa
	 s/Gyc9hLfFrww==
Received: by pali.im (Postfix)
	id 98F1D6D9; Mon, 26 Oct 2026 23:26:09 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7.3 0/9] Various changes
Date: Mon, 26 Oct 2026 23:25:51 +0100
Message-Id: <20261026222600.17323-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Rebased changes on top of the v7.3.
No functional change, just fixed 3 oneliners from Sashiko.
Link to previous: https://lore.kernel.org/linux-cifs/20260825230622.24617-1-pali@kernel.org/

Pali Rohár (9):
  cifs: Remove code for querying FILE_INFO_STANDARD via
    CIFSSMBQPathInfo()
  cifs: Remove cifs_backup_query_path_info() and replace it by
    cifs_query_path_info()
  cifs: Fix validation of EAs for WSL reparse points
  cifs: Validate presence of EA $LXMOD for WSL reparse points
  cifs: Check if server supports EAs before trying to set it for WSL
  cifs: Extend ->set_EA() callback to allow operate on reparse point
  cifs: Create native Window socket file compatible also with WSL
    subsystem
  cifs: Add support for parsing WSL symlinks in version 1 format
  cifs: Add support for creating WSL symlinks in version 1 format

 fs/smb/client/cifsglob.h   |  10 +-
 fs/smb/client/cifsproto.h  |   1 +
 fs/smb/client/cifssmb.c    |  43 ++++---
 fs/smb/client/fs_context.c |  11 +-
 fs/smb/client/fs_context.h |   3 +-
 fs/smb/client/inode.c      |  98 +-------------
 fs/smb/client/link.c       |   3 +-
 fs/smb/client/reparse.c    | 257 ++++++++++++++++++++++++++++++++-----
 fs/smb/client/smb1ops.c    |  11 +-
 fs/smb/client/smb1proto.h  |   4 +-
 fs/smb/client/smb2ops.c    |   6 +-
 fs/smb/client/xattr.c      |   3 +-
 fs/smb/common/fscc.h       |   5 +-
 13 files changed, 287 insertions(+), 168 deletions(-)

-- 
2.20.1

