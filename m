Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF50484234;
	Mon, 31 Aug 2026 13:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183483; cv=none; b=bhPt2Ys7lMfDK04tQyib16nXiy0Ly/KEE0tO3J76xKtlg9t/On/foP9x0w7sFnZw9buHCwNSeMbrsHYM629kjgIcK0UEJ5+k+6HUx4lp20T3yPX/l0WIKZcOAhThIsAnkYFAqFGCwwQMOUnCHpYwG2q0/MfkHUgehuSQ7aAKhhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183483; c=relaxed/simple;
	bh=knIvQGUmN7zxKYeKatGkr0ssgAdhDXx4C8vYHMwX55A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OGB9ovbnXXVaK2p85k0FoTZLyBLdF3+nKG9knQ2g+NS4ou63qQxC6wj1/LYj/6Vm81BEOv+SdDvzYqXJs070VaWSE9hO+q8xWpL57d1TxofplHsRZyf/ynOtvxO7wPdEftmL2wlDBDMBUBfNJ1szt5AgUmUPjTYNeuljDW53WgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FjUgCcJM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FjUgCcJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B06B1F00A3F;
	Mon, 31 Aug 2026 13:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183481;
	bh=B6+l2rfz5UzL4aaXXKFd1J/HIWoum85qj1SRmcJew3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FjUgCcJMRV31SZ0S7C95XPDDQJE07a8rF1vW4udgKu6Pl6o4eCuPS7JvDC3GzL7IK
	 OtuiQT/jgqlkfpgjfJP2CXC+sS7X3Q/rmsRFFUWRtEUAn6ce137PkCZCu7xcQvo6f/
	 zT1M5oUThHQ9YaL+EmylYQhuO0fB/2HKqx231SwEn7QhqmUZy/gSivdFhRHe1GivVH
	 FFOMntfJViKGWX1ilhKB6kwkb5gMEPFsYRR+RHuuFZZLC0dTkjuOCnaoZ/v5ouGf3J
	 LQu2T8v/zCvsrhd9ohKkPIH7Tx1urqyWL3SQOmMzV5RByz8wCKVrbVNh2KPgAFM27B
	 ZIHluXGcRjGkg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] ksmbd: find bound sessions during reauthentication
Date: Mon, 31 Aug 2026 09:22:30 -0400
Message-ID: <20260831133314.4125787-122-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit faf8578c77f3d846aca9cd882c293e03eafcc6df ]

A session bound to an additional connection is stored in the session
channel list, but it is not added to that connection's local session table.
After the binding exchange completes, conn->binding is cleared.

A later SESSION_SETUP reauthentication on the bound channel only searches
the local session table. It fails to find the session and returns
STATUS_USER_SESSION_DELETED instead of processing authentication and
returning STATUS_LOGON_FAILURE for invalid credentials.

If the local lookup fails, look up the session globally and accept it only
when the current connection is registered in its channel list. This keeps
unbound connections from using the session while allowing reauthentication
on an established channel.

This fixes smb2.session.bind_invalid_auth.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background `git branch -a --contains` check hung and was killed; it
didn’t change the backport analysis.

A quick rerun confirmed the SMB3 multichannel commit object exists in
this repo and the binding code landed via the 6.18-rc8 merge. The
verdict for **linux-6.18.y** stands: **YES** — a small, low-risk fix for
broken SMB3 multichannel reauthentication on bound channels.

 fs/smb/server/smb2pdu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 55ac0ee338dae..9394fd2605f3d 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1863,6 +1863,13 @@ int smb2_sess_setup(struct ksmbd_work *work)
 	} else {
 		sess = ksmbd_session_lookup(conn,
 					    le64_to_cpu(req->hdr.SessionId));
+		if (!sess) {
+			sess = ksmbd_session_lookup_slowpath(le64_to_cpu(req->hdr.SessionId));
+			if (sess && !lookup_chann_list(sess, conn)) {
+				ksmbd_user_session_put(sess);
+				sess = NULL;
+			}
+		}
 		if (!sess) {
 			rc = -ENOENT;
 			goto out_err;
-- 
2.53.0

