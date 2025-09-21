Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F049978F4B
	for <linux-cifs@vger.kernel.org>; Sun, 21 Sep 2025 21:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758491167; cv=none; b=UNth39BibkWHJyiV85Q4tEC/nR8GOS2UflevwuzOxLhRs/NAp78/lkwo74yDlAZk3fIQITZU/QJ9uYPMuF53jYvLLNwfAq/4zEOU/CYmv5WNe84v6/+mYHPIvYFGDu/PwGxwbPmkvCC4c6RsSUSomHQ77w01tehbBXx9Z54m9c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758491167; c=relaxed/simple;
	bh=/ApnX7ahN65ilq9GECxWSZ0iNtfOjQ+iI6UgsPu5KGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8UvLZ0vk8GLi86MzoS4F6lH/ImDCQVi2X50yiQ4wVZ3W70yJEM3PW0UVHDB4i4xFjl5XT34bUcVkdHvwqc2KqFdziGw+V1APF0lXDG70bZw65v4iKTR5CicTX9Qib5+m8IqZxnIF4J7xfEd0GYIGlddVO4ujxtIQDSIkUmuVMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=PMvu8V5F; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="PMvu8V5F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=mRaIcOrMnhZdNxDb84SGNbrVD7QuJfIGQvd9MyLo8Ic=; b=PMvu8V5FxVVWZ+wHbY5rvJBm4O
	mfVDrsulcMSwDhy98fuAJ6kr0/lSowXR9EDfXkHmoeBag9SzjON3CxFHKQKWHPVssOFALlAcVy0xf
	8hvFyX0RmFThyYqx15F10TItbp5CmwpUG6nZQGXxtKPA+5wJC3QL/vp2TsClOPLM/k9cwzebCCJ5U
	Lc4+qL7EAPwJ8SNsuaT/nYfQH7GqMGoYbj9JJhTSX7VghTfmK+qCGhYfX/rgxR9I5MdzcypT+xd41
	dHZooImMRUrMyFm1gfVKfLLPFbssDf6Ch97Bt9BDYljEKntrgTqgFc1kXuNZwlkcIrks7fWXVysqk
	hzo+p9MgGVlPLAccRyDFyFOfO4qh4ojEgyptCQ2QSZ6AM1YqasBVfzj6GwvNijkb43aeY3lFEsYxo
	aGJNRxuVBxe3aCuBY23ZY14WRZSi1ZVYK6ukn1MSIYkECwIhpo/sH6XScowDCTf3o1d5D6LWnYTPN
	GIHekT1Bz/DZEWu5SdgLCWSW;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v0Rsg-005GPu-1R;
	Sun, 21 Sep 2025 21:46:02 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 05/18] smb: client: fill in smbdirect_socket.first_error on error
Date: Sun, 21 Sep 2025 23:44:52 +0200
Message-ID: <16af61b4118ddb1c674f1f77405ee9d0ba146959.1758489989.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1758489988.git.metze@samba.org>
References: <cover.1758489988.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For now we just use -ECONNABORTED, but it will get more detailed
later.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 38934e330096..73beb681ac0b 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -181,6 +181,9 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 	disable_work(&sc->idle.immediate_work);
 	disable_delayed_work(&sc->idle.timer_work);
 
+	if (sc->first_error == 0)
+		sc->first_error = -ECONNABORTED;
+
 	switch (sc->status) {
 	case SMBDIRECT_SOCKET_NEGOTIATE_NEEDED:
 	case SMBDIRECT_SOCKET_NEGOTIATE_RUNNING:
@@ -217,6 +220,9 @@ static void smbd_disconnect_rdma_work(struct work_struct *work)
 
 static void smbd_disconnect_rdma_connection(struct smbdirect_socket *sc)
 {
+	if (sc->first_error == 0)
+		sc->first_error = -ECONNABORTED;
+
 	switch (sc->status) {
 	case SMBDIRECT_SOCKET_RESOLVE_ADDR_FAILED:
 	case SMBDIRECT_SOCKET_RESOLVE_ROUTE_FAILED:
-- 
2.43.0

