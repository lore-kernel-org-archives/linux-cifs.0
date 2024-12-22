Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B5F185B4C;
	Sun, 22 Dec 2024 17:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734888267; cv=none; b=bM+xbPG3HW/3bv2F72bw6/kpID7nEpg5vEIPfbs5MWxp0yBl2kUzWN8VGM1tgLcNgwqz1ndIZC88YOxOeuuWl3zMqsfOQKGqCHcbz2zHuQFctak7Md1bh9CEJB/Sfx9LeF1Rwm/EhZFJcx1fsMY48496+sAC70MDp/MJCiaMptE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734888267; c=relaxed/simple;
	bh=KegoF38CnALsF94yfAZg36I+y9X6eaOg6j6pnZqJHpE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=IBJLT1i1EQpZqTftsKvzLmOuTRUn+zucgnxh4qyBCARJDIYsV4mtufXw6rXdVTMzXCTpPumaqRUz6KqYAUPMCQQGfLwCkYxo+FafjoYpKwRhd34jHxNw9yZT53XEPEwfbQSfI96ysY2F7pzh4V/PIs2qdfatw2ElFiBsyy+mfLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r03YzQJX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r03YzQJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD217C4CECD;
	Sun, 22 Dec 2024 17:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734888266;
	bh=KegoF38CnALsF94yfAZg36I+y9X6eaOg6j6pnZqJHpE=;
	h=From:To:Cc:Subject:Date:From;
	b=r03YzQJXy8FD5jh+ok3wisiyVHzOtJfRMuhANmgsuBQ6CjG9CFM50mRLmCAMdrxoF
	 F/IWci9uTdeToLKes+8NQZFqJ71zi+uFpJAt/zdItArf/heyaJp1dKmmoxRN/8xN6O
	 ALtsH5il/EaA+p2EZqeLTfYdNei/Ero20GCmvZK5HaNOBHiY8OuInz8Re7rj5QIDiQ
	 qGtmCUFKW1ki/bVtNQxKQBli7hj2gSKb7GDmJXuFfoxiPEhugbW0W2tOIBnPpYEQ4g
	 MBoVOUnGuRCXjjnaTdx+1YUOuU+gDjJmY96xVYd/Ee6NR8wsQDG0DdI6T3iPkJvL1S
	 lEkzyfKu7o59w==
Received: by pali.im (Postfix)
	id 3172D7F2; Sun, 22 Dec 2024 18:24:17 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] cifs: Cleanup of duplicated structures
Date: Sun, 22 Dec 2024 18:24:01 +0100
Message-Id: <20241222172404.24755-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch series contains only code cleanup of few duplicates structures
and enums between smb/common and smb/client subdirs. No function change.

Can be useful also for ksmbd server part.

Pali Rohár (3):
  cifs: Remove struct reparse_posix_data from struct cifs_open_info_data
  cifs: Remove duplicate struct reparse_symlink_data and
    SYMLINK_FLAG_RELATIVE
  cifs: Rename struct reparse_posix_data to reparse_nfs_data_buffer and
    move to common/smb2pdu.h

 fs/smb/client/cifsglob.h |  5 +----
 fs/smb/client/cifspdu.h  | 30 ------------------------------
 fs/smb/client/reparse.c  | 15 +++++++--------
 fs/smb/common/smb2pdu.h  | 14 +++++++++++++-
 4 files changed, 21 insertions(+), 43 deletions(-)

-- 
2.20.1

