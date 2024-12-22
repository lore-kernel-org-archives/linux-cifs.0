Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FC9187FEC;
	Sun, 22 Dec 2024 15:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734880293; cv=none; b=j+mq4iPPoe4r/DZiJovmZ1unkZeAYbiqkXt6MjjjT2tYLReUaBcyMjVuJEdhfi3OERlJuxoWbfi114Z2r5XpXzrFthg47aTlJReTKRR7d2NKwYA0UNCVrU5D5Nl92KT8Jr4Na+W8TCOl+MLXIAyBwV1mT8K25psyCAO4Bzh8d0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734880293; c=relaxed/simple;
	bh=w3xezpDINS1gpEoAL/xWrbxPdF+8yVkdMGud0FpYiFs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=fqENn0Aj9wG7R5yqf9rVtkMhc48FNXUMpK1zmrKe+FO3o2BZABQ5xMuihr60cHrCT39qwukC6LUHjhohrwiLa4mv399NsrBz7LyCKL6kQkavWgpYQaQpauRBwpczfHZ6XSM9tNAk9CWf39VS0ldS0TExp6FnfKzpDXUe1yYrZC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DrQRI36e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DrQRI36e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7A9C4CECD;
	Sun, 22 Dec 2024 15:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734880293;
	bh=w3xezpDINS1gpEoAL/xWrbxPdF+8yVkdMGud0FpYiFs=;
	h=From:To:Cc:Subject:Date:From;
	b=DrQRI36eteCfOeMHYxd+TmEsnSb16g6mE+uNPlnAsgCqB698LzPF0JUDkgCGwB7fF
	 aeHZS6+QN5V+wCD1xQFZ4Dm5dGwXmZeKfazt1vQ0t3sP+Cbt6RXFHMWVG5hh0OzBvX
	 4Ef+/w9we8bYFADimq26ZG59hyzzrT7HVJeKf3wKE2e7FC4/tdJCgpPq91Ll6gS9lY
	 es6zt9zjvNQDAfrtPfEaKGrB+gr2llEpR3R8Xt+UAlH57mpM6WhZzOXrzpYTCs0jKM
	 aA958/q28HJKKMUXcXLnXSpIkglSBtvVtXuEr/fm/xODoKpA6HmrvRsKbVDqIvdLZj
	 DJdLqdbF6ZU5A==
Received: by pali.im (Postfix)
	id C24A37F2; Sun, 22 Dec 2024 16:11:22 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] cifs: Fix gettting and setting parts of security descriptor
Date: Sun, 22 Dec 2024 16:10:47 +0100
Message-Id: <20241222151051.23917-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patch series fixes getting and setting SACLs over all SMB dialects
(SMB1, SMB2, SMB3) under different conditions (including the case when
user does not have granted access to READ DACLs, but has privilege to
access and change SACLs) and allows to change ownership of files by
users who have special privilege for it, without accessing DACLs.

As for each part of security descriptor (OWNER+GROUP, DACL, SACL) is
needed different permission and every user can have different access
rights and privileges, it is needed to have more granularity when
changing security descriptor.

Therefore this patch series introduce a new xattrs to change just
SACL (system.smb3_ntsd_sacl) or just OWNER/GROUP (system.smb3_ntsd_owner).

So with this patch series there are xattrs:
- system.smb3_acl - DACL only
- system.smb3_ntsd_sacl - SACL only (new one)
- system.smb3_ntsd_owner - OWNER and GROUP only (new one)
- system.smb3_ntsd - OWNER, GROUP, DACL
- system.smb3_ntsd_full - OWNER, GROUP, DACL, SACL

Pali Rohár (4):
  cifs: Fix getting and setting SACLs over SMB1
  cifs: Change ->get_acl() API callback to request only for asked info
  cifs: Add a new xattr system.smb3_ntsd_sacl for getting or setting
    SACLs
  cifs: Add a new xattr system.smb3_ntsd_owner for getting or setting
    owner

 fs/smb/client/cifsacl.c   | 27 ++++++++++++---------
 fs/smb/client/cifsproto.h |  2 +-
 fs/smb/client/cifssmb.c   |  5 ++--
 fs/smb/client/smb2pdu.c   |  4 +---
 fs/smb/client/xattr.c     | 49 ++++++++++++++++++++++++++++++++++++---
 5 files changed, 66 insertions(+), 21 deletions(-)

-- 
2.20.1

