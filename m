Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16F718F2EF;
	Sun, 22 Dec 2024 14:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734879572; cv=none; b=X5BNEKZkDvgrYJkVa0Ch2piplD44rf1TkOJuqkP3LAbPrXo+yR93rVQaxE197SBnMV9oNmFv6/Av5r1DhURw6lWcCVpEFS9wBqTqCxnyMkNh0oUloWupBmbUo3lseFgDdmMdPDWFIpHFJ+bsc7Sl02wrzUWvFhcGqN4gOwb/3s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734879572; c=relaxed/simple;
	bh=8WOB6f+UEr9J0RPx979Kbw6EEKfbBot12UyD+7tqZXc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C5xWy3eJueB6OuiYYWRdUNRqg/NnnIJjuyybyCoElhUkyEOqcBsPSolOAeJUb7CU79l823Xpnd9BiMb2hl9Vs2GARkCk+EPQPi8pdYA8SkM1hEsQor1XfCcwLNgsmmgomekqS6WoAMON+oGaBCnc+uVQdXpPqg4GJNwMTdSqNC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uNEHdtvj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uNEHdtvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDEFC4CED3;
	Sun, 22 Dec 2024 14:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734879571;
	bh=8WOB6f+UEr9J0RPx979Kbw6EEKfbBot12UyD+7tqZXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uNEHdtvjf8EH3e4efj3LQDUJCJO/DlhpLNeqg5Rxg+LBrmFYPUGr35G6z72d8O0lS
	 3yABXzIraCRh+bBjLLH8GSfVHEIcvuBCUY3qX5AfDgi/Jj6fezLGMTgi+7QZixj0wb
	 9XEjwJCVlJG8QO4gjCILi2EcOZ0B6vjiXkC75IQ6Mi69pJsvLp6tdSqkjkXifaTEON
	 KqlWMPzfd/evj2UCXuIi7xxVH20Wl21tGL48gBmqdST4e+wTPKcJN6cI3Ef+vCEEDR
	 LQhsywZ4EDQd6KDsuJVqsHIxVQIfpy7e8HnWHXr8hyTbrk4GCz1P7umwgfHJJ08VLW
	 c3WPnaDbZRzrg==
Received: by pali.im (Postfix)
	id 7CC22982; Sun, 22 Dec 2024 15:59:21 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] cifs: Throw -EOPNOTSUPP error on unsupported reparse point type from parse_reparse_point()
Date: Sun, 22 Dec 2024 15:58:42 +0100
Message-Id: <20241222145845.23801-2-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241222145845.23801-1-pali@kernel.org>
References: <20241222145845.23801-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This would help to track and detect by caller if the reparse point type was
processed or not.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 4ea987f84bd1..63a95ecc7542 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1088,13 +1088,12 @@ int parse_reparse_point(struct reparse_data_buffer *buf,
 				 le32_to_cpu(buf->ReparseTag));
 			return -EIO;
 		}
-		break;
+		return 0;
 	default:
 		cifs_tcon_dbg(VFS | ONCE, "unhandled reparse tag: 0x%08x\n",
 			      le32_to_cpu(buf->ReparseTag));
-		break;
+		return -EOPNOTSUPP;
 	}
-	return 0;
 }
 
 int smb2_parse_reparse_point(struct cifs_sb_info *cifs_sb,
-- 
2.20.1

