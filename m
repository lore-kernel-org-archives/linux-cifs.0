Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AC0355F5F;
	Mon, 28 Sep 2026 01:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790558920; cv=none; b=YemgUE/A/0CkxEXpfhhJRrthrquojjudBGUSEo8KGF+jHP2xLjXyH4ydhLvH4zxTnMn5Gc7KHlDmkrKxTQmh98s4Xu2+q4NanovAUCH+3SknsHFYcRvGO/v/dNTtVjOpz6hm5sTb2WTWZwINaivaRAkZwO8AGjBnONLx5QPMcJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790558920; c=relaxed/simple;
	bh=y7ntrEUiluxmNVBoao2AxMNrwHpEBTn9FngEi53Lzbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Abd80ZMMtNUwbHQlH/UXlMJrkzA7WG1gNcbfAcZMLVBW2N9B+Tw+zP6GMFbWqQwcfz+M7kt0BJFztlSpC6t/OFTZiIMOTnq4LN0zN3z3JEzN0Pmxru7htldRsQsyDO4icTQmEV2MVDvSPzAk25Zi2XRWELKHnfqfcMscljX0+sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=aOyQpvCf; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=cPfwDzaJ; arc=none smtp.client-ip=202.12.124.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="aOyQpvCf";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="cPfwDzaJ"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 292011D00046;
	Sun, 27 Sep 2026 21:28:38 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Sun, 27 Sep 2026 21:28:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1790558918;
	 x=1790645318; bh=jKFga5N1H79ktGj2rtkYTTXFLrTYebaO77yJ0LYh9EE=; b=
	aOyQpvCflc9ooYL0hWbEajNFEJfVa5Edi7uqh2rke9BfZQwajxSEZa9mQCMf6YZ0
	cIsEhBVhJxyOvaLe1JVW6v+MsBmeADdPXqU/COiK+qbZfYM6iIl3nvgZFCcxrCuV
	tPIC8SIMDDvaltZ+vCk+gMsE/nhr4QCy0ZWXIAx9l5TJ/qwkNrInHRBqfYPFW1r2
	cQPbOYfnw5dnzgQifrQk3bKv2ptFBFhw+xYcRdcgOhfXXHND88SKq0bp6b3XxK/5
	sojV0N5S1UGWwsMU9s3Py6Voa1QKUDJqjuNj9qmKPPBA7IhqycfafhADPTUHhOkg
	w6mMfRIa2Qi5M4Je+EjAmw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790558918; x=1790645318; bh=j
	KFga5N1H79ktGj2rtkYTTXFLrTYebaO77yJ0LYh9EE=; b=cPfwDzaJxK2sG/Fjw
	Lk9yMJnfR+UVVUsOO7xjLwh5HlYRqFscHr0nRAGsj1jshIIyjL3X7yqDTeV0IWqu
	zDjBz21MkiNhzBsHDM/wD+CiYm4QHbk21Ak0/tVwZWQLWA3KCpxCSWfIPywfnipM
	CHo5GmfyLInSoTf7wsGF0V5pi+9UaUf6ojOH5I0FhdTZ4djq44lKUCGU0MyFUtKh
	GGV+2TrJ6dLfnrTIr7vAWn2C7d/ANmi7RG73ZG27ytNnoTA6vz8sSLofk4i4Tho8
	eyronjgDJuJe3NpAtYQ2caF+nZq2toWycACVze0ZbKd4rBv5FPdD155AOHqbDlDo
	Ce6HQ==
X-ME-Sender: <xms:xcK5aor-orJV_al9BZr1ooEtCyk2xZJs1TxWcURQChIa5yHtVW-gTg>
    <xme:xcK5ahtewwNeHve7XQDdgP7yOdfATEUDklWQ1xuqkFLXwmsbrmF7hlk5GP0lvSi7i
    tDfZTFhJWS4l7FSkB9BjPgYAo8z3nogHxAzJg7ppsMtPFM>
X-ME-Received: <xmr:xcK5an0rvacZyyzdN_fh7RBxQiX-LSP_B3DPDRhA-3sdiz0bFOhkI0uzcPUaGPJK6OPRu5Paq7J5aqVddz5eQoUKepTBesA>
X-ME-Proxy-Cause: dmFkZTEo5XpDuYcFbgku1MpxLrtlAwn9oABQiqTHUUsYGNkTkpjNR1FoAv+g+LSQLaDYOj
    FwGH3NvRNteiumxt1F6Cp/2rGUKUvMZuLPGG0GnGBjAOs/QgYPZC/bBdtw9Zv0Ksy2JF90
    tuPjd78+GZH8BIhKu53k5StZKk1mRgGOhpyEXB3DuVVMf4LwggW9Ea8/JevZ7QwaWWJV6o
    SiS5wQHhkj0btG9M0UWaWiU6MPJn3I037+6FShebRcIBMY/3oesNf2QiHKI9HbGig861FF
    EAdciql9mo1y6FQjW/1ajz0TvW9Xg4e9YuQA1XOaiJlH/3OXtturskljpXM2Qfspbb2SoO
    Ow5fRq5Q6PMT2JGbCjl2bzr6zQlu9oCmQ4O3cwLE8GMo8hQzJxqf7avPA9mMk93XUfDCKG
    oafoZgsv1wuM5yQ+l0kn3z161mjOw94ORLPEP+pVWaI2S4ODbrB2lO/81xcGcGVUzSNWuS
    t5tsezhBo5jeOS7d/085yRScL4wjUmNOyf5lKZSLVfw4GzMa8crcdW96c0Br0rexMEMUZs
    BITxR1qRMAq23LcvnCXR9oTu3NYQo1EwT+sTtRhZRgjzPfvpRgA9dtekkDwtgApS0DeGV6
    BZgVdbifbmM81bNidYlQ47USAnLsGcxw2yvTkIQHOYRhbdCP6j7tf+SRF9AA
X-ME-Proxy: <xmx:xcK5asFJ3Lbzv8E2QzdQ-AhX_WHvteWWqqmFzdDhBukfWk3dJe919w>
    <xmx:xcK5ais2u7XrrOd2nf2zAlFKiOUUDdD1B1qcR1h8kdW9uI_pYUOBqQ>
    <xmx:xcK5avrCdo8w2bmjGbyTwhqV1hFerik_ah8tuFIwEWqb440k3b9EQw>
    <xmx:xcK5apVisNyBgcNiEQyTXpxlYVLqHz__jONSNVNTnOSXYycw94UDEg>
    <xmx:xsK5at4feT0GHeRWqf-d96Tek2ensuGBC-2qk9Es2g25480ixFEtm2Hj>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 27 Sep 2026 21:28:35 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] smb/client: use d_alloc_trylock in cifs_silly_fullpath()
Date: Mon, 28 Sep 2026 11:25:03 +1000
Message-ID: <20260928012812.2890035-3-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260928012812.2890035-1-neilb@ownmail.net>
References: <20260928012812.2890035-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: NeilBrown <neil@brown.name>

Rather than performing a normal lookup (which will be awkward with future
locking changes) use d_alloc_trylock() to find a dentry for an
unused name, and use an open-coded lookup_slow() to see if it is free on
the server.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/smb/client/dir.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 88fff65320f5..2faac93c6758 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -1183,23 +1183,34 @@ char *cifs_silly_fullpath(struct dentry *dentry)
 	unsigned char name[CIFS_SILLYNAME_LEN + 1];
 	int retries = 0, max_retries = 16;
 	size_t namesize = sizeof(name);
-	struct dentry *sdentry = NULL;
+	struct dentry *sdentry = NULL, *alias;
 	char *path;
 
 	do {
 		dput(sdentry);
 		scnprintf(name, namesize, CIFS_SILLYNAME_PREFIX "%x",
 			  atomic_inc_return(&cifs_sillycounter));
-		sdentry = lookup_noperm(&QSTR(name), dentry->d_parent);
+		sdentry = d_alloc_trylock(dentry->d_parent, &QSTR(name));
+		if (sdentry == ERR_PTR(-EWOULDBLOCK)) {
+			sdentry = NULL;
+			continue;
+		}
 		if (IS_ERR(sdentry))
 			return ERR_CAST(sdentry);
-		if (d_is_negative(sdentry)) {
-			dput(sdentry);
-			path = alloc_parent_path(dentry, CIFS_SILLYNAME_LEN);
-			if (!IS_ERR(path))
-				strcat(path, name);
-			return path;
+		if (!d_in_lookup(sdentry))
+			continue;
+		alias = cifs_lookup(sdentry->d_parent->d_inode, sdentry, 0);
+		d_lookup_done(sdentry);
+		if (alias || d_is_positive(dentry)) {
+			if (!IS_ERR(alias))
+				dput(alias);
+			continue;
 		}
+		dput(sdentry);
+		path = alloc_parent_path(dentry, CIFS_SILLYNAME_LEN);
+		if (!IS_ERR(path))
+			strcat(path, name);
+		return path;
 	} while (++retries < max_retries);
 	dput(sdentry);
 	return ERR_PTR(-EBUSY);
-- 
2.50.0.107.gf914562f5916.dirty

