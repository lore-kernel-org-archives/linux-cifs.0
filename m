Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2B930E0E9
	for <linux-cifs@vger.kernel.org>; Sat, 18 Apr 2026 17:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776533441; cv=none; b=GDtiKJWCWqYFZhM+aE3FJoTc4NuOfBiuvpNW/HB9SW5pYTgj4rNW0oEx6xpX8CHvUM8KcgPcOlLmUPQWVV2DfM+WvdmN0o5infTELeZ1tJ61sFM2oFii1pWm7rGimEk0JpveZKvR4GcIDU5kvysZYopui8CqZn7ESaH1cYpIyL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776533441; c=relaxed/simple;
	bh=ezf//pPazx1mLelB2gmRNccf8HxZrkHgU//I5FWrCyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uldn3xxYsZ7ukEu4jl5UAa/7RTy4Y6z3LuGSbojzjmJnNTyPNu7KnIJMAIfVrqsSpZYc4GhiXwPji4PLoiGbgZ665mqFBTxHlw4XL4kd+76Ocl41ulUn4Pl6qrWbA2MKUivzT/hch//I/E98j9r3DB4+BZ9rRAPzWti36VDmykc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QurXQ/H5; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QurXQ/H5"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-35e57611113so378489a91.0
        for <linux-cifs@vger.kernel.org>; Sat, 18 Apr 2026 10:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776533440; x=1777138240; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n1YbAZG9CJiEeAf7NGLPiDB355/n4BunXq6TPbpCs08=;
        b=QurXQ/H5ToZI50kQGmZb+B3u4q4k9XFMiYZ+KArrL6tEn5Xjfy4DfzaDDuXnYlAC+i
         1V5oC06DP6uwk9ZBRC3jZjEhKg1k2ZhT+3Q/9uGW7uqAkPAEBMF9QjxvF9Efxies3L0H
         pbqtYt59yj5MgxOcvSWl4iUxHEIo2M+O/CAdnFqhd/7CCEH6957MWtIe6xstZ5OzjxVk
         /Mw9UMLCSxg/g/iHeC8BvZxO4cghs70Xs4c1G8lz4RQjgGsS1rQ8+VnC6FYnXyIsfz48
         mPyZBZLFAO6SEbtAzVtWJdKUfrrX/RtD+FM0quWR0I8qjoNxdBMWwvtQWLJ2D2c8Wq4R
         YqmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776533440; x=1777138240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n1YbAZG9CJiEeAf7NGLPiDB355/n4BunXq6TPbpCs08=;
        b=Y2ZEChKP4MbBnts78hZnEZdqWMjiWyZomXnOtRS7WRMEIsAPgv9L0QwKx4s/GHZvYQ
         I0kFiP6H6AKNeOvH3kDqyC9qOo3QCiLFP5wYu6uBXgVmuIAcWk5vz7LTabL+Bx3M3SGF
         292rKOXZWGgFIH+jd+K5Rj6/wiUXQsJzjcxA81q6lonSxTHuSq8ZdRgl1EZgvx2FHy+n
         CrfSxGePqKtEZb98IYxIHplPwyNfE9VigLovcUoHasMS7UQ+cVmtChnX7dc6wxUbJvl4
         oHmP1z6DJqGHo+7U7x4BF6BrjvpdvfyQEF1nsfmTduph2Olo7VQjrw9vJgm+8WsxVET3
         hh1Q==
X-Forwarded-Encrypted: i=1; AFNElJ/tT6GvpO5M8/eTa750vSAeTyBD3w8kwcGE18ZodoHy7QmjvKVDM1Iu+4qFtQlaeBJKdp9e2eB7cO9E@vger.kernel.org
X-Gm-Message-State: AOJu0YzAGLt57X+bryDKzZOWfRaA0IKYVdRc5C7TQzhyjLFOUQal6cmh
	hSlUx67IPdONWrkOm5MmkxgVl+aHVL71gQU03fY0ThyoBN+kwqfWQ9W/
X-Gm-Gg: AeBDievd7F3+OXopi0rBzbEEVEFPOCi1I1zyiZIM0NEy5TuX7arie1ie3mPniEslOSq
	GJ52t89Lr1S9FH7cRZDnzYLByEF5kVQko7uoc7DLk2LS0KIElSPMRqB6rNIAbI6QX/XYi6JUPdd
	IU5Jta4j6v76nu32PPtH02LppgX8yZ3aV2t8YaPGl4vs/vLF1ejLZ1hD2QRBbm1PWHXMpSUPv3G
	KV7oOE/7bSrKC3DGmxMTIsxdCyaXs2HTww3bHMsRPGovR+q6V+cN/9DegS0vYDDlT+zs2zImh6J
	2HjnOCZlK1mpNOCyI9zd2Qn8CKxRiKkqa4TjG3TNR77I4VgAyVKzwwIjA+ISRo/W79TzOjOILiI
	SmuMOMimfEjebszjYwrf4YfRO+fjKME94C3RFA7cHc8SduRQ04o3iiEpq6OYY/1DtarwQ1McAJA
	j4SCWAsF3xK+11Fo2/Ti8IisxF0Vo=
X-Received: by 2002:a17:902:c40a:b0:2b2:ac6f:f6a with SMTP id d9443c01a7336-2b5f9d679e8mr42742655ad.0.1776533440022;
        Sat, 18 Apr 2026 10:30:40 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fa9ff3bfsm69694965ad.7.2026.04.18.10.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Apr 2026 10:30:39 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: linkinjeon@kernel.org,
	smfrench@gmail.com
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH 2/2] ksmbd: reset rcount per connection in ksmbd_conn_wait_idle_sess_id()
Date: Sun, 19 Apr 2026 02:28:44 +0900
Message-ID: <20260418172844.1333378-3-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260418172844.1333378-1-charsyam@gmail.com>
References: <20260418172844.1333378-1-charsyam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

rcount is intended to be connection-specific: 2 for curr_conn, 1 for
every other connection sharing the same session.  However, it is
initialised only once before the hash iteration and is never reset.
After the loop visits curr_conn, later sibling connections are also
checked against rcount == 2, so a sibling with req_running == 1 is
incorrectly treated as idle.  This makes the outcome depend on the
hash iteration order: whether a given sibling is checked against the
loose (< 2) or the strict (< 1) threshold is decided by whether it
happens to be visited before or after curr_conn.

The function's contract is "wait until every connection sharing this
session is idle" so that destroy_previous_session() can safely tear
the session down.  The latched rcount violates that contract and
reopens the teardown race window the wait logic was meant to close:
destroy_previous_session() may proceed before sibling channels have
actually quiesced, overlapping session teardown with in-flight work
on those connections.

Recompute rcount inside the loop so each connection is compared
against its own threshold regardless of iteration order.

This is a code-inspection fix for an iteration-order-dependent logic
error; a targeted reproducer would require SMB3 multichannel with
in-flight work on a sibling channel landing after curr_conn in hash
order, which is not something that can be triggered reliably.

Fixes: 76e98a158b20 ("ksmbd: fix race condition between destroy_previous_session() and smb2 operations()")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 fs/smb/server/connection.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index a26899d12df1..b5e077f272cf 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -237,7 +237,7 @@ int ksmbd_conn_wait_idle_sess_id(struct ksmbd_conn *curr_conn, u64 sess_id)
 {
 	struct ksmbd_conn *conn;
 	int rc, retry_count = 0, max_timeout = 120;
-	int rcount = 1, bkt;
+	int rcount, bkt;
 
 retry_idle:
 	if (retry_count >= max_timeout)
@@ -246,8 +246,7 @@ int ksmbd_conn_wait_idle_sess_id(struct ksmbd_conn *curr_conn, u64 sess_id)
 	down_read(&conn_list_lock);
 	hash_for_each(conn_list, bkt, conn, hlist) {
 		if (conn->binding || xa_load(&conn->sessions, sess_id)) {
-			if (conn == curr_conn)
-				rcount = 2;
+			rcount = (conn == curr_conn) ? 2 : 1;
 			if (atomic_read(&conn->req_running) >= rcount) {
 				rc = wait_event_timeout(conn->req_running_q,
 					atomic_read(&conn->req_running) < rcount,
-- 
2.43.0

