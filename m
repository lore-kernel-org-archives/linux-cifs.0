Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09AC72621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046181; cv=none; b=n0MR7+F6MwyNgnFOj/Ja1krdvsNR0EKeWfVGS+6ZjUO3jtY29Nn/joHmA6qSE0uNwnCJbT2ZWZ5lxIph8bQ/apF66osqCJGMWm3nVa9UWdRkdNnHD1YjivSiQaumlCDnphfr9kw3DECln33V+bhuTh5X4G/bFsoxaoyIYcFhS2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046181; c=relaxed/simple;
	bh=d4qI5rst2QPsmQdLgFYNeOugQG5slRY3zbRd/fOuX/g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pBaAWc8nZPTgnUwEuZ/v1sKvWU9Nm4HdAgdbk1R47ZSZjqZiCabGmI6rOYv8RN5ogsK3MYs7kqO+HE79DvvPN+oXaUpg8apZsxLrxzeWf8IsAZ3mgccc8wJWdFmS9TKY9sux41vAs9akcBW5aB4q0OY9bsUIGtseCky9SkLQZlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dG3MiLW2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dG3MiLW2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B571F00A3A;
	Sun, 21 Jun 2026 12:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046180;
	bh=Kfn69L2raL3IuR0akjQbRZfQweg3Ow5JA8cC9Vgt+jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dG3MiLW2ykybx9n0N/6s/pZQpbJkiXLvYPF5j0tzFOHJHSzcs9LQRdjZ87spQi3p4
	 3CFQKdyrQYi4DH0r+MOFAMH5xKQOPHAJ0OhowoM6SgpJBw4mqJsnDh/P0LGjMajSvN
	 HJ1qSLfG4oA5Q/oGS8Ra+Ox4ryHbPTQf9I0YGWbjUFMW13wNn18JZSc9MBqBD4EGEr
	 7Cl0sAf57Mm9B8RyLeboMd/vwRJcdW/0q/KDwHSUpUyqRdQHOyIjMRXOaFFWZqrfbD
	 aa+wlYhoXLoMN8InK7zPO9zki9n+E1coIPbYQvWolbt426fNcvRpXLTfGMYAdfnWGx
	 qJDtAuhmGfKLA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 25/29] ksmbd: validate :: stream type against directory create
Date: Sun, 21 Jun 2026 21:48:40 +0900
Message-Id: <20260621124844.6235-25-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260621124844.6235-1-linkinjeon@kernel.org>
References: <20260621124844.6235-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2.streams.dir opens <dir>::$DATA with FILE_DIRECTORY_FILE and expects
STATUS_NOT_A_DIRECTORY, then opens <dir>::$DATA without it and expects
STATUS_FILE_IS_A_DIRECTORY.

Commit "treat unnamed DATA stream as base file" canonicalizes the ::$DATA
suffix to a NULL stream name so the open continues through the base-file
path. That skipped the stream/directory type validation, which was
guarded by "if (stream_name)", so opening a directory's ::$DATA stream
with FILE_DIRECTORY_FILE incorrectly returned STATUS_OK and a plain open
of it no longer reported STATUS_FILE_IS_A_DIRECTORY.

parse_stream_name() still records the explicit $DATA type in s_type even
when it clears stream_name.  Run the data-stream vs directory validation
whenever s_type is DATA_STREAM, not only when stream_name is set, so the
canonicalized ::$DATA open is rejected with the correct status.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 67a1850d4368..778677ec3361 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3453,7 +3453,14 @@ int smb2_open(struct ksmbd_work *work)
 		rc = 0;
 	}
 
-	if (stream_name) {
+	/*
+	 * An explicit ::$DATA suffix names the unnamed data stream and is
+	 * canonicalized to a NULL stream name (base file), but the request
+	 * still has to be validated against the data-stream type, e.g. opening
+	 * <dir>::$DATA with FILE_DIRECTORY_FILE must fail with
+	 * STATUS_NOT_A_DIRECTORY.
+	 */
+	if (stream_name || s_type == DATA_STREAM) {
 		if (req->CreateOptions & FILE_DIRECTORY_FILE_LE) {
 			if (s_type == DATA_STREAM) {
 				rc = -EIO;
-- 
2.25.1

