Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B4522D4D3
	for <linux-cifs@vger.kernel.org>; Mon, 22 Jun 2026 01:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782090762; cv=none; b=RRxWuLlSUmbLSf/Cq1JRpnc43IoKuD0BQ7aooVcKwcQb/aeNuIu/MXjnQ+OMJ0Lx6VkxTO0Ri9a23g117+0ixWsABBZGpWrXW6MdVsivn0y27buBDC+YbkMMPkrFH5ZZ7kK/E+ck+SMLvtGxfPADzCDdoyvg2pY3zWGh9cMR0IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782090762; c=relaxed/simple;
	bh=3z47GEc6vuhs2Fbb03C5tIvk2B4yFoiHdtLVcwfJ3sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcC+9TMLlgKkRbFckc2DVQNctkHCXeZd/cHNhm2ASJcV8TZcAg8DL9esuWLFQvt/SIsnyH09q7tuQ5TE4MlV9VxahN2s+1z+RwEWRRQ2QVfe3jv4meBcY0pAjTBJH6AwJ3dAsnijRKHfiMPQpCJJXQIzUn367P1xolFkjqxUcfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C96wrBFp; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C96wrBFp"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-44747d96185so311280fac.1
        for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 18:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782090760; x=1782695560; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ohpu6B3vtN9gi73jmy44IymSXRN7/x+rvAG1OGlFlhA=;
        b=C96wrBFpSTsJXS0tIzaO1IggRQ9tbZl0+T2pZnJHzCxPPl9pxm/mJm/6zDwNf/1b5D
         3VtHSOvPn11c0eAwf0VPHbbJgn/YJSLsWZRGEPDRDGfuUVPZtlL5WGDXydTBW6m8/+e9
         YCH9T1jxMqiJ3bqRVaisZ0WBFmI78xBxLiGF6+fT0pdWbALs1cwzILh5B+SGF7etZoqj
         p/lQX0fcBBq9P1sEA/h+sA1leifgSdUlE9+gFv3v/awvOSzYYOT5gHZ5SvDbApeGiYLO
         JnguDetpkDsQcLO4CXdISNrE/I1+tNwgNS6iElL7K0WPTthPlfI/dcYhqjFvWCqj2N0r
         xrnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782090760; x=1782695560;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ohpu6B3vtN9gi73jmy44IymSXRN7/x+rvAG1OGlFlhA=;
        b=Z17StwXovigSsL5Go3kbf1BW5650C4jBUY8wi+tkLP41rVeqoD59n+r1MSeHSP2W96
         1mupLJGlURhToUHo0lGvrNyoLTdVh6EWNJLkT71lTomzqVdR8zHZz/ltQVtGXrjKdv3+
         C0QydQ/IGe57MFCWI1tw+Atfo320toZFgp2F1YBXEqRftzvmR1hnhbbO9he2WjNChRjG
         Jb390WyM/gO+CFMbX5QE5QEiu7QB+6i9yt6Lfiz3cjG/qQse404fEqGrls7OAElLa9A1
         ruhxH73Xmd55hU5+PxSRvhSGDqMVf0rXLlwi+2kkZyd7bgLiPoCJrKca916Y9PZ6G95L
         6IMA==
X-Gm-Message-State: AOJu0YyuXcfGGYEzD16Lj0OHB+sg2sh0iKi4t+8B4MrbU4VOFnlbDPmc
	7ydNr8Bk80fNqe7ioKQ9IRgKKa9RgoO+062n5wuILn9fFo+O5S1OUEXKTCPwiW9U
X-Gm-Gg: AfdE7ckXOeA5yRegtff60l/+IzixQTUcGfYGV484lENntZNPlkAXWgVOp8ncXzfom1E
	98HQXcvQPcXx/D1vMzqNC2A40pCx91opHzSCsOHBa8Q98DpNDfuujDqIjRnKRxve1qLiVYOuKbx
	9rYFYxTu+e8PTC73EaF8RevowkVDqn+32FA6cZOJVlQ7O1B1M+XoMNz1HoJEOjJ0s7JBytWDlND
	CcjL0QC7xT3NoLeMhE6oB7Z1yVRWmyC8H15D+mIzbXnLjXGOO2Q+RlGXCv/Hnz2x+12kjISbjZi
	6AzrT3nMvOgJHHy5gRvOHM6z3cYE3kjr6udtPHw5YEj62rT5lfEjPrdJfZC/dhGUr4CkYMnQWQl
	I87WjW85xbF3y66KWvgWDVfkLIzMAJYizlWF3iA1mFAeczDROXHk6/9LuCo4XgzQR3Q6jVlvrME
	c3/ei86NwmOIys4mHxVA2rymCz0fVU9xmEiCcVz8vg9rrC/N3oWxUg1Lo+y3x14chvU7VXjNrgt
	olt8YKEo9cKOO5+8EDg21mxdN2XJrtMbxK0ozIul7I6qX8ACIUAAYrWDAL6RMDsuFLwOwwWCxNS
	o984pjr2qIO16Fg/5D1yGy04T3g=
X-Received: by 2002:a05:6871:cc0d:10b0:447:4f9f:6ed0 with SMTP id 586e51a60fabf-4474f9f71d2mr2674942fac.7.1782090760446;
        Sun, 21 Jun 2026 18:12:40 -0700 (PDT)
Received: from smfrench-ThinkPad-P16s-Gen-2 ([2603:8080:2200:13fc:fe9d:7f65:95c3:3c73])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4472ec52815sm5206853fac.1.2026.06.21.18.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2026 18:12:39 -0700 (PDT)
From: Steve French <smfrench@gmail.com>
X-Google-Original-From: Steve French <stfrench@microsoft.com>
To: linux-cifs@vger.kernel.org
Cc: Ralph Boehme <slow@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 1/3] smb: client: refactor ACL setting control flow in id_mode_to_cifs_acl()
Date: Sun, 21 Jun 2026 20:08:15 -0500
Message-ID: <20260622010838.107524-1-stfrench@microsoft.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <smfrench@gmail.com>
References: <smfrench@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ralph Boehme <slow@samba.org>

Refactor the control flow in id_mode_to_cifs_acl() to reduce nesting and
prevent error code overwriting.

Instead of wrapping the call to ops->set_acl() in a conditional block,
introduce early exits (goto id_mode_to_cifs_acl_exit) when build_sec_desc()
fails or ops->set_acl is NULL. This ensures that any actual error returned
by build_sec_desc() is not overwritten with -EOPNOTSUPP.

Signed-off-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/cifsacl.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 42a3115359da..5bbf73736358 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1834,14 +1834,18 @@ id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
 
 	cifs_dbg(NOISY, "build_sec_desc rc: %d\n", rc);
 
-	if (ops->set_acl == NULL)
-		rc = -EOPNOTSUPP;
+	if (rc != 0)
+		goto id_mode_to_cifs_acl_exit;
 
-	if (!rc) {
-		/* Set the security descriptor */
-		rc = ops->set_acl(pnntsd, nsecdesclen, inode, path, aclflag);
-		cifs_dbg(NOISY, "set_cifs_acl rc: %d\n", rc);
+	if (ops->set_acl == NULL) {
+		rc = -EOPNOTSUPP;
+		goto id_mode_to_cifs_acl_exit;
 	}
+
+	/* Set the security descriptor */
+	rc = ops->set_acl(pnntsd, nsecdesclen, inode, path, aclflag);
+	cifs_dbg(NOISY, "set_cifs_acl rc: %d\n", rc);
+
 id_mode_to_cifs_acl_exit:
 	cifs_put_tlink(tlink);
 
-- 
2.53.0

