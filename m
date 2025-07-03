Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B262E339E;
	Thu,  3 Jul 2025 15:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554895; cv=none; b=TkjD/OBZ+zL4CDZumkjMHXBZ2YvKgcYlYbl1RM9s+LddeaQlDQKwjtKsSV/a4cYEaxcaM/OaAQt4MGME5MKJfInk0qV6CI3BTj0MYM73M30DU7tzXpk539gIfXm48rOdbFQfzjAwgkRJ1Ec98SUUurtB/D7aTjAkPClQGNBeXvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554895; c=relaxed/simple;
	bh=Vb+jwLJrq5X3PNSKIOR03+ZO5TZWuEElYUdvjrgaKxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qw0LlyYzOxELyoun7lZsdCnDunnvNxO6Eh+59Hx8G7iG1l35QaYOkN3KsfIdr3nODsnmwPtFQ+ITJV/k52Wa0YFV9PQGYxhEpTpoT+Cl/HwsJbURSqxRKmWwE/LIPv3Z3aZNFo+y/EJUtMR+puaM0j/BrhsEnqpyjfx2kkgcM/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjC+KHKb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjC+KHKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E38C4CEE3;
	Thu,  3 Jul 2025 15:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554895;
	bh=Vb+jwLJrq5X3PNSKIOR03+ZO5TZWuEElYUdvjrgaKxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OjC+KHKbCATZuopUAkUdDjx8+gc4/YuaPyk1fmHvyL8ujI2lImgrXy3kmoVORHy4U
	 NDz164OY8HAfr/gj6DPVINnSWNzWvbvj7nWPxy8a/X7wpQ4xmW9Ufd5gIJUPLBFrFU
	 xOslMQ/nEHPKa9OVeFzpxTFeJuiKttFybnVmhcfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	Remy Monsen <monsen@monsen.cc>,
	Pierguido Lambri <plambri@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.15 112/263] smb: client: fix regression with native SMB symlinks
Date: Thu,  3 Jul 2025 16:40:32 +0200
Message-ID: <20250703144008.833120214@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit ff8abbd248c1f52df0c321690b88454b13ff54b2 upstream.

Some users and customers reported that their backup/copy tools started
to fail when the directory being copied contained symlink targets that
the client couldn't parse - even when those symlinks weren't followed.

Fix this by allowing lstat(2) and readlink(2) to succeed even when the
client can't resolve the symlink target, restoring old behavior.

Cc: linux-cifs@vger.kernel.org
Cc: stable@vger.kernel.org
Reported-by: Remy Monsen <monsen@monsen.cc>
Closes: https://lore.kernel.org/r/CAN+tdP7y=jqw3pBndZAGjQv0ObFq8Q=+PUDHgB36HdEz9QA6FQ@mail.gmail.com
Reported-by: Pierguido Lambri <plambri@redhat.com>
Fixes: 12b466eb52d9 ("cifs: Fix creating and resolving absolute NT-style symlinks")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/reparse.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 511611206dab..1c40e42e4d89 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -875,15 +875,8 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
 			abs_path += sizeof("\\DosDevices\\")-1;
 		else if (strstarts(abs_path, "\\GLOBAL??\\"))
 			abs_path += sizeof("\\GLOBAL??\\")-1;
-		else {
-			/* Unhandled absolute symlink, points outside of DOS/Win32 */
-			cifs_dbg(VFS,
-				 "absolute symlink '%s' cannot be converted from NT format "
-				 "because points to unknown target\n",
-				 smb_target);
-			rc = -EIO;
-			goto out;
-		}
+		else
+			goto out_unhandled_target;
 
 		/* Sometimes path separator after \?? is double backslash */
 		if (abs_path[0] == '\\')
@@ -910,13 +903,7 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
 			abs_path++;
 			abs_path[0] = drive_letter;
 		} else {
-			/* Unhandled absolute symlink. Report an error. */
-			cifs_dbg(VFS,
-				 "absolute symlink '%s' cannot be converted from NT format "
-				 "because points to unknown target\n",
-				 smb_target);
-			rc = -EIO;
-			goto out;
+			goto out_unhandled_target;
 		}
 
 		abs_path_len = strlen(abs_path)+1;
@@ -966,6 +953,7 @@ int smb2_parse_native_symlink(char **target, const char *buf, unsigned int len,
 		 * These paths have same format as Linux symlinks, so no
 		 * conversion is needed.
 		 */
+out_unhandled_target:
 		linux_target = smb_target;
 		smb_target = NULL;
 	}
-- 
2.50.0



