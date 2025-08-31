Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423BA2652AF;
	Sun, 31 Aug 2025 12:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643797; cv=none; b=paRCiRc8FZBK5WTp5DRLTu07+6SBbIa80e4Q1kxsPik1JL1Q/I0hmuGXMw9XjbHHJZaFzklfHN5umbIiYiQyGRWtTkGAmyBo0N4VXgy93yAVEahbAV6df/ajWeUBvRkyBiy3KP9qKvYynLLbWLIvI+eVAn9yUD6fXryJKKL0u2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643797; c=relaxed/simple;
	bh=xd3znamZi+4zYsYbHX3omonDAZMvYkQtdUQTv4wYa5U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q2fFQ8ma1EC0Yq7yrAiD2XK8nP0X56U8FjoQ1QN9/NufFa6w1aKrJLJWWvNOnY7OLfU04Iok9mYoIpBFaD1E6uRJGv4nAa+S+NTxXVx2XevhL2tRVt4KDo1SrP3ZzRkTmXmyOWXODq5co6GNYZE7fGfAQ75HG/cGdwJ7PZyjTBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X29NLIZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X29NLIZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FA4C4CEF9;
	Sun, 31 Aug 2025 12:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643797;
	bh=xd3znamZi+4zYsYbHX3omonDAZMvYkQtdUQTv4wYa5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X29NLIZpfgWjbFgEww9UZkc6i1Nt325WX1y9mdjRr4ZySILP9tqPp70gHsVuIjFbd
	 Yh6vxXWpt09D7t17nZaU9vhQ+bpwqt6Oslg6kpcS+tTVybuHIpCmgbEFu8c9rwpeO0
	 eva41iTkIZcHlgVx3rWQ7/vulzx2cjf8fXm2fRqE4g0y/BeN8K2fUQ+8NAqA89erdD
	 kJfXg1XV30dJ9KMOshIZ215Cg0WN2I+yys2hv/FAj6C+GB9YSWbLZkYaNwAPYzwV5Z
	 cyxmV6Ev9LbG5GLiWsP1CNoeXa9U01klkY8dvoexzh4nsf2zn53Pf56nqDYi6YsN0r
	 r+z7EvlmJHCZQ==
Received: by pali.im (Postfix)
	id 555A91ADF; Sun, 31 Aug 2025 14:36:34 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 18/35] cifs: Do not set NumberOfLinks to 1 from open or query calls
Date: Sun, 31 Aug 2025 14:35:45 +0200
Message-Id: <20250831123602.14037-19-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250831123602.14037-1-pali@kernel.org>
References: <20250831123602.14037-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Current code already interprets zero value as unknown number of links and
sets the CIFS_FATTR_UNKNOWN_NLINK flag to handle this situation.

Setting NumberOfLinks to 1 prevents the CIFS_FATTR_UNKNOWN_NLINK indicator.
So set the NumberOfLinks to 0 when it is unknown.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifssmb.c   | 4 ++--
 fs/smb/client/smb1ops.c   | 2 +-
 fs/smb/client/smb2inode.c | 6 ++++--
 fs/smb/client/smb2pdu.c   | 2 +-
 4 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 2427752bc224..2a83fbc65395 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1163,7 +1163,7 @@ SMBLegacyOpen(const unsigned int xid, struct cifs_tcon *tcon,
 			pfile_info->AllocationSize =
 				cpu_to_le64(le32_to_cpu(pSMBr->EndOfFile));
 			pfile_info->EndOfFile = pfile_info->AllocationSize;
-			pfile_info->NumberOfLinks = cpu_to_le32(1);
+			pfile_info->NumberOfLinks = cpu_to_le32(0); /* CIFS_FATTR_UNKNOWN_NLINK */
 			pfile_info->DeletePending = 0; /* successful open = not delete pending */
 		}
 	}
@@ -1288,7 +1288,7 @@ CIFS_open(const unsigned int xid, struct cifs_open_parms *oparms, int *oplock,
 		/* the file_info buf is endian converted by caller */
 		buf->AllocationSize = rsp->AllocationSize;
 		buf->EndOfFile = rsp->EndOfFile;
-		buf->NumberOfLinks = cpu_to_le32(1);
+		buf->NumberOfLinks = cpu_to_le32(0); /* trigger CIFS_FATTR_UNKNOWN_NLINK */
 		buf->DeletePending = 0; /* successful open = not delete pending */
 	}
 
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 618470db6444..6e928e90d72b 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -627,7 +627,7 @@ static int cifs_query_path_info(const unsigned int xid,
 				fi.EndOfFile = di->EndOfFile;
 				fi.EASize = di->EaSize;
 			}
-			fi.NumberOfLinks = cpu_to_le32(1);
+			fi.NumberOfLinks = cpu_to_le32(0); /* trigger CIFS_FATTR_UNKNOWN_NLINK */
 			/*
 			 * Do not change fi.DeletePending as it is set by the above
 			 * CIFSSMBQPathInfo() call even on error. By default it is
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 6c9da150a402..c8b0e9b2438f 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -696,8 +696,10 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		idata->fi.Attributes = create_rsp->FileAttributes;
 		idata->fi.AllocationSize = create_rsp->AllocationSize;
 		idata->fi.EndOfFile = create_rsp->EndofFile;
-		if (le32_to_cpu(idata->fi.NumberOfLinks) == 0)
-			idata->fi.NumberOfLinks = cpu_to_le32(1); /* dummy value */
+		/*
+		 * Do not change idata->fi.NumberOfLinks to correctly
+		 * trigger the CIFS_FATTR_UNKNOWN_NLINK flag.
+		 */
 		idata->fi.DeletePending = 0; /* successful open = not delete pending */
 		idata->fi.Directory = !!(le32_to_cpu(create_rsp->FileAttributes) & ATTR_DIRECTORY);
 
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 58800490142e..bf588ec99618 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3276,7 +3276,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 		buf->AllocationSize = rsp->AllocationSize;
 		buf->EndOfFile = rsp->EndofFile;
 		buf->Attributes = rsp->FileAttributes;
-		buf->NumberOfLinks = cpu_to_le32(1);
+		buf->NumberOfLinks = cpu_to_le32(0); /* trigger CIFS_FATTR_UNKNOWN_NLINK */
 		buf->DeletePending = 0; /* successful open = not delete pending */
 	}
 
-- 
2.20.1

