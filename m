Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794457307;
	b=LPB7C0GWbQm+BJgBvo0v5MgdnAV/DgRNNTa866tL9yacy3h03gT7czhnWBNQ+9tgL4tA
	 DoTIuWw7b/VUfuuAp1Im1MoKsLuvjvjMLcdQIG73gnf0zw9FglBJoA4vDfFPp/YUVRHYG
	 IVEEMHuJP+xnj6uIGTCJipq3R+t+HxmRyjalHX8FHNPwoP6Ii41Ef2pKjY+po6NlPSAUs
	 NNOmmEDV+sfJlsnp2VicQIpq6IHVonsMnuK9awlOaVhJe/MD9xwLJz1kbDTGXh7y+SNJR
	 g9sRARfL/qBWYC8x1gcyp0EmxJdYhCiKRBsXFX28SX3/cG5Zs+ab1ba1sEzMMKKNuuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794457307;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=juANi56qwSWTWzrj5h15PKZII373PLXorjRyBOcmsyk=;
	b=zsg2406LeNaGT+rcusOMTKqaBw0TPpmgIL2hXYPt/WPGaOErrg+rLzKBJfe350HtCSQf
	 9DGJ4ZV7+/PiM5RC8KJYsZOZ5dq3V92+E8+FpA877DBr8XoU7u+dPuNVJuzsGc5Ju7ImR
	 MkIqi1wUztRZ5PUqHOheH1CReznqV2khiXOK9U1+o4wr7I0mJZDPN5I2itLguXLYVnG8T
	 VCbQqWW/i+eEi2O+XGoNosjg435BMons3ooRFH8JtUlIetFZ4XXwHyLy6wSrTR19JdH6M
	 +ZmSBjGIhkGs8SR1NS6NmOFfGofyWPQZgup4hqi8IqJgcBXW9rBYPOpHjFFuqaplfFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Dw7uovNY;
	arc=none smtp.remote-ip=209.85.215.170
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0174F606A323
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 04:21:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0174F606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Dw7uovNY
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cdb9f760337so245612a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 20:21:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794457306; x=1795062106; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=juANi56qwSWTWzrj5h15PKZII373PLXorjRyBOcmsyk=;
        b=Dw7uovNYBTbAEZaxM1MG/UZBxai/DRQ4KlDIbj+qtHRUJUbGFavjOePAquBTZafw2w
         QsHna4vo4YI+JpIlO0J1CfUkTJqfiIca2NImwuChbB99Xr8SG9WKBO29RuhdfYhSXOTJ
         dYf6vtLJmarEPrpeTpAN5O9U16bIYKLDMayHC9V8ttfaHSObS2noSX4hlSm3NDKDvy7L
         lm7R5sQ1gC+kik+18I+ulyZYp11Xd4kvxVDz/2SiG1U/Kh6CsXBd3CXJ8858pKPQTKCb
         LkAnObFL/vW1XJpk12r/iKPB8W66LotuX6Qlhl2cRmc4npFMCsMatvRI7zlZeNhZMfFS
         8tRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794457306; x=1795062106;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=juANi56qwSWTWzrj5h15PKZII373PLXorjRyBOcmsyk=;
        b=SDy8gUYmxp3WONW+INpqG1DJVO1ufXniHAah38CkpbXgriragY+bqy04G5jZSVWCCR
         pnwB0CG7tTRUHKtx/lQZnwniANfQJnzu0w22Iis95xcSGfNAldXLRYr0UdG2sLfDkA7L
         Jlf+VNEaIbl30Iy+tqUT3CrUCujURAFm3qHbYuqDXg+5YoAu0J0lQr89F77y/5BLf+IS
         /e+MvvpVyZQPZju1t3V+O3xk3fjSUzUeMsXndYjcTkeNIybkC6otjYvEBGPJDzHDRFwp
         zE7xg4HZIX32UCEReu7CP77QzlLkmnkk5+rwsUSseaRSEYJp8M9YGmEiKR+BX21AZBj4
         B91A==
X-Forwarded-Encrypted: i=1; AL+hErHR4QBLxWoyYowc4hdZC5WEIYJrbHBc3L7r2/usKn3lKthyZSTt+2NZSL2Q+HfkjqD77MZ2mdZGgd1+@vger.kernel.org
X-Gm-Message-State: APuU4Z8vv5PIb7i9WIQgSQTKx7PBF6pfUh6BbBx8lFIiK+DKXHyhxX0o
	2KfusWBcIqPHLSJm9PK4BGO304K9BcvocVan3/rqQB7x+J7990gElhFZ
X-Gm-Gg: AYBFou3ZG9S60AYqejwICObbKD295u48k3k0EWHHeWTBVglJ92VfFAmeV7H6ylRflTj
	uOmtV1CM2kP32BHFhgc64RRRAlvqI8VoS68/d6UFU/mW5EG2LTHBpmIb5ikffo6E/YdubKe+0G2
	FAxHKwabL6NgCv+zjaXwfzkl/V2G+98Nt/0gFvvikjWCLOO/3DszDZ3GKNK+2TrQmF6DE24QeW+
	MZ6e2FY3qQrTpnbkZa1vJOo+0HmIBXcithZTZOGc5MgmnHvDKbVdW3RJdvs8IH7LsF3ZRTYYy0f
	PRsa+k746nlpLDkNNeKEW/7In9+dI4prgbEX1ROsQwfo8oBSXHoUfpoZ5XJrYGL2rR4v9Eabelt
	8cWFkfGU9I5261iEnssZOr+LU27PlzXVawWlt0CU39vthtb5IRAzAYYUKkgTqL2v+cseEKBqSwU
	x4h6YkV2j+nJaBBobL/KXaHHILwORH3mH5JgAvZQXEXXTIOWK0Lf162C2szQht8zm1kIuStUz1b
	Uf0q069Jt4qLWToP8hI9lwRL5XuRDocO6sEqG045eJ2bYzRRbtKKTevoz2XTqnnod/gr26MC3JX
	dz9UlCd2yD6E8rYR74zGIfu35tlBhf5tnbS8p8dPnNy9xqVfTQc=
X-Received: by 2002:a17:90b:50cc:b0:3b1:6e2:3693 with SMTP id 98e67ed59e1d1-3b197c93f2fmr920063a91.17.1794457306154;
        Wed, 11 Nov 2026 20:21:46 -0800 (PST)
Received: from fred-server.tail1cd3ef.ts.net ([2600:381:9205:b5df::7ff])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197b76ccesm2439180a91.0.2026.11.11.20.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 20:21:45 -0800 (PST)
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>
Subject: [PATCH] smb: client: convert path_consumed to mount charset units
Date: Thu, 12 Nov 2026 04:21:36 +0000
Message-ID: <20261112042137.1642509-1-fredric.cover.lkernel@gmail.com>
X-Mailer: git-send-email 2.53.0
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

path_consumed in a DFS referral counts bytes of the canonical path,
which is in the DFS cache charset (utf8). dfs_parse_target_referral()
applies it as an offset into full_path, which is in the mount charset.
When the mount charset is not utf8, each non-ASCII character in the
consumed part that encodes longer in utf8 than in the mount charset
makes the offset too large, so leading characters of the prefix path
are dropped. For example, with iocharset=iso8859-1, mounting
//srv/dfs/café é/sub yields the prefix "ub" instead of "sub" and the
mount fails with -ENOENT. (A single accented character only worked
because the offset happened to land after the delimiter.)

Translate the count in parse_dfs_target(), where both strings are
available, by matching path components: count the delimiters in the
consumed part of the canonical path and find the same position in the
mount charset path. Delimiters are ASCII in both and are not affected
by remapping. If the consumed bytes are identical in both strings,
which is the case for utf8 mounts and ASCII-only prefixes using the
default backslash delimiter, the value is used unchanged.

This assumes the server reports PathConsumed on a component boundary;
a translated value that ends mid-component is rounded up to the next
boundary.

Tested against Samba on a KASAN kernel: with iocharset=iso8859-1, links
with 0 to 3 accented characters followed by a tail, a two-level tail,
an accented tail, a link in a subdirectory, and mapposix with an
accented name; iso8859-15 and cp932 mounts; and iocharset=utf8
controls. Not tested against Windows servers, with posixpaths, or with
reserved characters under mapchars/mapposix.



Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>

---
Hi Paulo,

This is the follow-up you asked for in your reply to the earlier series.
Based on cifs-next at 25912ed3b75d.

Separately, reconnecting a mount whose prefix path contains non-ASCII
characters still fails with a non-utf8 charset; I'm looking at that
and will send it as its own patch.

---
 fs/smb/client/dfs.c | 70 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index 57c90a2512a3..cbc2ea6a190b 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -85,16 +85,82 @@ static void set_root_smb_session(struct cifs_mount_ctx *mnt_ctx)
 	ctx->dfs_root_ses = ses;
 }
 
+static bool dfs_is_delim(wchar_t c)
+{
+	return c == '/' || c == '\\';
+}
+
+/*
+ * @consumed counts bytes of the canonical (cache charset) path @cpath.
+ * Return the matching byte offset in @fpath, which holds the same path in
+ * the mount charset.  Offsets are matched by path component, since the
+ * delimiters are ASCII in every charset and survive remapping.
+ */
+static int dfs_consumed_to_local(const struct nls_table *nls,
+				 const char *cpath, const char *fpath,
+				 int consumed)
+{
+	size_t clen = strlen(cpath), flen = strlen(fpath), off = 0;
+	int ndelims = 0, seen = 0, i;
+	bool ends_on_delim;
+
+	if (consumed < 0)
+		return -EINVAL;
+
+	/* Identical bytes in both strings: units already agree */
+	if ((size_t)consumed <= min(clen, flen) && !memcmp(cpath, fpath, consumed))
+		return consumed;
+
+	if ((size_t)consumed > clen)
+		consumed = clen;
+
+	for (i = 0; i < consumed; i++)
+		if (dfs_is_delim(cpath[i]))
+			ndelims++;
+	ends_on_delim = consumed && dfs_is_delim(cpath[consumed - 1]);
+
+	while (off < flen) {
+		wchar_t uni;
+		int len = nls->char2uni((const unsigned char *)fpath + off,
+					flen - off, &uni);
+
+		if (len <= 0) {
+			uni = (unsigned char)fpath[off];
+			len = 1;
+		}
+		if (dfs_is_delim(uni)) {
+			if (!ends_on_delim && seen == ndelims)
+				break;		/* start of next component */
+			seen++;
+			if (ends_on_delim && seen == ndelims) {
+				off += len;	/* just past the last consumed delimiter */
+				break;
+			}
+		}
+		off += len;
+	}
+	return off;
+}
+
 static inline int parse_dfs_target(struct smb3_fs_context *ctx,
 				   struct dfs_ref_walk *rw,
 				   struct dfs_info3_param *tgt)
 {
 	int rc;
 	const char *fpath = ref_walk_fpath(rw) + 1;
+	const char *cpath = ref_walk_path(rw) + 1;
 
 	rc = ref_walk_get_tgt(rw, tgt);
-	if (!rc)
-		rc = dfs_parse_target_referral(fpath, tgt, ctx);
+	if (!rc) {
+		struct dfs_info3_param local = *tgt;
+		int off = dfs_consumed_to_local(rw->mnt_ctx->cifs_sb->local_nls,
+						cpath, fpath, tgt->path_consumed);
+
+		if (off < 0)
+			return off;
+		local.path_consumed = off;
+		rc = dfs_parse_target_referral(fpath, &local, ctx);
+	}
 	return rc;
 }
 

base-commit: 25912ed3b75dcf5ff623dcb549b925dd0d0948f7
-- 
2.53.0

