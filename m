Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A0CC8D7;
	Mon,  7 Oct 2024 00:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728262157; cv=none; b=rdnse4N8iwlHmyxqEbdXDJ6N18Gkxl2t38U+rmGYZ+QwlS1CcVmzfZqC+5MfFO8K0prfQ1YRM6+KBq+mRGMrN5imoURGdfAz8SUDjrt3XJ+cJDLDiVcuOZPTGY9iTZLj8CIQYVJnJtQNhD6QNoDnF0R8X9qRIg3Ky/+2N/O5CPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728262157; c=relaxed/simple;
	bh=iaU0B8WuzS7hmbs1wV8+rUFzqoIkeCtZGkB/1Pl0CX4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eYq+bglcbSIjaiQlvAzmixD2fAJdCNm+OCJYzt+LIdSeaBC3s698os4rCtSjkzrqTB+2+B5QP5k+dxOMSthFIirKqzKJNKh0bTCVbj/AQmB+UTjvnM4hOdg4qfe9l7KnSIGvQS3TrZBkXaGWvnF6AyTpC8mqRSg9R5QyaC/JEaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=ApP8Cpwn; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="ApP8Cpwn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=P7rH2/zL3iSA4KbO8K39KJUAmnOzAcPC2REcM8vLdIw=; b=ApP8Cpwn2st7HJR8
	Ff5/IuNJkDDCC+A0qPcKmhpgeQ6maoaSMqLYSGlTBBEuO7JwGM7JyDM9N3KtdmDpGIvNTcVB9e/ON
	Qr4kkTnemnRvaTQcgvSYiQkR8lufs3qKoxDngIwa3ufg010f3UfWBb5iJjdHjTNV4ihkuA17P/SPN
	nDEre6N6AASuS2UCBHj/pv7f8nhojSRNB2PVSNWWy07pL3DCwqcyBIgB6ZDYO1DyQkrZp+f2air11
	1gvXXfSses/oaWfV+kad5/Yr749OGuJxi+e7cH65BgkTkeq8JYHAFbKgBfohdHLsfprHJcXdTvSlb
	yhUVd1jFuXnnHoaFOQ==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1sxbvk-009M6z-0i;
	Mon, 07 Oct 2024 00:48:56 +0000
From: linux@treblig.org
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] cifs: Remove unused functions
Date: Mon,  7 Oct 2024 01:48:55 +0100
Message-ID: <20241007004855.150168-1-linux@treblig.org>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

cifs_ses_find_chan() has been unused since commit
f486ef8e2003 ("cifs: use the chans_need_reconnect bitmap for reconnect status")

cifs_read_page_from_socket() has been unused since commit
d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than a page list")

cifs_chan_in_reconnect() has been unused since commit
bc962159e8e3 ("cifs: avoid race conditions with parallel reconnects")

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 fs/smb/client/cifsproto.h |  9 ---------
 fs/smb/client/connect.c   | 12 ------------
 fs/smb/client/sess.c      | 32 --------------------------------
 3 files changed, 53 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 68c716e6261b..1d3470bca45e 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -252,10 +252,6 @@ extern int cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 			         unsigned int to_read);
 extern ssize_t cifs_discard_from_socket(struct TCP_Server_Info *server,
 					size_t to_read);
-extern int cifs_read_page_from_socket(struct TCP_Server_Info *server,
-					struct page *page,
-					unsigned int page_offset,
-					unsigned int to_read);
 int cifs_read_iter_from_socket(struct TCP_Server_Info *server,
 			       struct iov_iter *iter,
 			       unsigned int to_read);
@@ -623,8 +619,6 @@ enum securityEnum cifs_select_sectype(struct TCP_Server_Info *,
 int cifs_alloc_hash(const char *name, struct shash_desc **sdesc);
 void cifs_free_hash(struct shash_desc **sdesc);
 
-struct cifs_chan *
-cifs_ses_find_chan(struct cifs_ses *ses, struct TCP_Server_Info *server);
 int cifs_try_adding_channels(struct cifs_ses *ses);
 bool is_server_using_iface(struct TCP_Server_Info *server,
 			   struct cifs_server_iface *iface);
@@ -640,9 +634,6 @@ cifs_chan_set_in_reconnect(struct cifs_ses *ses,
 void
 cifs_chan_clear_in_reconnect(struct cifs_ses *ses,
 			       struct TCP_Server_Info *server);
-bool
-cifs_chan_in_reconnect(struct cifs_ses *ses,
-			  struct TCP_Server_Info *server);
 void
 cifs_chan_set_need_reconnect(struct cifs_ses *ses,
 			     struct TCP_Server_Info *server);
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index adf8758847f6..15d94ac4095e 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -794,18 +794,6 @@ cifs_discard_from_socket(struct TCP_Server_Info *server, size_t to_read)
 	return cifs_readv_from_socket(server, &smb_msg);
 }
 
-int
-cifs_read_page_from_socket(struct TCP_Server_Info *server, struct page *page,
-	unsigned int page_offset, unsigned int to_read)
-{
-	struct msghdr smb_msg = {};
-	struct bio_vec bv;
-
-	bvec_set_page(&bv, page, to_read, page_offset);
-	iov_iter_bvec(&smb_msg.msg_iter, ITER_DEST, &bv, 1, to_read);
-	return cifs_readv_from_socket(server, &smb_msg);
-}
-
 int
 cifs_read_iter_from_socket(struct TCP_Server_Info *server, struct iov_iter *iter,
 			   unsigned int to_read)
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 3216f786908f..c88e9657f47a 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -115,18 +115,6 @@ cifs_chan_clear_in_reconnect(struct cifs_ses *ses,
 	ses->chans[chan_index].in_reconnect = false;
 }
 
-bool
-cifs_chan_in_reconnect(struct cifs_ses *ses,
-			  struct TCP_Server_Info *server)
-{
-	unsigned int chan_index = cifs_ses_get_chan_index(ses, server);
-
-	if (chan_index == CIFS_INVAL_CHAN_INDEX)
-		return true;	/* err on the safer side */
-
-	return CIFS_CHAN_IN_RECONNECT(ses, chan_index);
-}
-
 void
 cifs_chan_set_need_reconnect(struct cifs_ses *ses,
 			     struct TCP_Server_Info *server)
@@ -487,26 +475,6 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 	spin_unlock(&ses->chan_lock);
 }
 
-/*
- * If server is a channel of ses, return the corresponding enclosing
- * cifs_chan otherwise return NULL.
- */
-struct cifs_chan *
-cifs_ses_find_chan(struct cifs_ses *ses, struct TCP_Server_Info *server)
-{
-	int i;
-
-	spin_lock(&ses->chan_lock);
-	for (i = 0; i < ses->chan_count; i++) {
-		if (ses->chans[i].server == server) {
-			spin_unlock(&ses->chan_lock);
-			return &ses->chans[i];
-		}
-	}
-	spin_unlock(&ses->chan_lock);
-	return NULL;
-}
-
 static int
 cifs_ses_add_channel(struct cifs_ses *ses,
 		     struct cifs_server_iface *iface)
-- 
2.46.2

