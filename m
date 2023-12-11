Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="BGcsJQqq"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925F19A
	for <linux-cifs@vger.kernel.org>; Mon, 11 Dec 2023 05:26:57 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1702301215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=63WTdPDkz3LE3zWAJqYYF/WlxbtZ09ObWFDDXPAqHkA=;
	b=BGcsJQqq49qazPtUf7H1ZZUT5c6jExj6QmyvmecKNK4Iz2Ct784ySbYhGaI0f4L1TLV12n
	HKFlMQAk5LLs06gMSdYqu7f1z8nSf+uuDJPUwqbp+GjcJcM9sKGmkXxrxfgvAakZlHsDG1
	0E1UwjgtdR2TlhacvKD2ZUWjmE8LTSKvJ27NLTaahxLosSbah8TXpWJPjoQKJcafOgINWV
	CLwnJQ7TXrXqyim58PBmnSqhsjN9CxrS1ZElevBqHXDjxZ8AAWg+JndrHkmM7qZv8pae9S
	Sb414FZL9PXVXEZxIil34bOm/NNc6UDtcvMdLJL7pMmc9yIkmtoY7uePEZ5dIQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1702301215; a=rsa-sha256;
	cv=none;
	b=riMS02itPlMwYdUyRLJj7ERS0jlk4dgglZx/MMY0hJGFIhGmYJCTLE5ZX4JOTLljuavt1R
	SPT6wzVzh0lHsYHi0KSfn0SfwO1wuF6sIUD/N0/mw3LJJfkVszc9KebWEsaD9LopE9lTcF
	aw3pcBxy+uiGNEn0RnorlnGqbmc1Jvgm8NqTvK/ELmIClI7Vj/KaisoFC+bDpxmdmb1YhA
	tfBVrwX3/BEjJVStkNswjoqueARF5cByb53KYL66td/SpQvXOdyVH3JfvNL7wWzUNQtGir
	LPt77Mr3TxZ25N9wDWYB19fENf40V4gjVtzcLEQBabpYbE2+GlGikt2RSX5uCg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1702301215; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=63WTdPDkz3LE3zWAJqYYF/WlxbtZ09ObWFDDXPAqHkA=;
	b=IYLsVQzrmjizvVk85ictTw8leoN+RevE+6G3Tlbnphfi9G+wgKoL+3dKR2piiPBMQXZx33
	ay+1gsYryCRGffBFGoFPKiW009pD082K2qgoL7jLOYFPl655ftAh2CEymXbl11uj6wjXlN
	aZm/Y6Eq3khz2DNPykU/OCTAljkYpd4IR9RXG6vHKXWnkfUJY6u+ksa62XSuZB6vrSGAsx
	9PVlbPdWuGxRN4YJpBVgtlwL4mm+UUUpMVM4bJdwGKfXxvrXAUYUdqvQD9sX50p+l6kNL/
	984niomKLuNML8kzp4K9Z98rXMnKv6QTyo/V+fcBTLe5fZhW5a/rqDeQrjblRw==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	Robert Morris <rtm@csail.mit.edu>
Subject: [PATCH 1/4] smb: client: fix OOB in receive_encrypted_standard()
Date: Mon, 11 Dec 2023 10:26:40 -0300
Message-ID: <20231211132643.18724-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix potential OOB in receive_encrypted_standard() if server returned a
large shdr->NextCommand that would end up writing off the end of
@next_buffer.

Fixes: b24df3e30cbf ("cifs: update receive_encrypted_standard to handle compounded responses")
Reported-by: Robert Morris <rtm@csail.mit.edu>
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/smb2ops.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index fcfb6566b899..a6f4948adcbb 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4943,6 +4943,7 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 	struct smb2_hdr *shdr;
 	unsigned int pdu_length = server->pdu_size;
 	unsigned int buf_size;
+	unsigned int next_cmd;
 	struct mid_q_entry *mid_entry;
 	int next_is_large;
 	char *next_buffer = NULL;
@@ -4971,14 +4972,15 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 	next_is_large = server->large_buf;
 one_more:
 	shdr = (struct smb2_hdr *)buf;
-	if (shdr->NextCommand) {
+	next_cmd = le32_to_cpu(shdr->NextCommand);
+	if (next_cmd) {
+		if (WARN_ON_ONCE(next_cmd > pdu_length))
+			return -1;
 		if (next_is_large)
 			next_buffer = (char *)cifs_buf_get();
 		else
 			next_buffer = (char *)cifs_small_buf_get();
-		memcpy(next_buffer,
-		       buf + le32_to_cpu(shdr->NextCommand),
-		       pdu_length - le32_to_cpu(shdr->NextCommand));
+		memcpy(next_buffer, buf + next_cmd, pdu_length - next_cmd);
 	}
 
 	mid_entry = smb2_find_mid(server, buf);
@@ -5002,8 +5004,8 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 	else
 		ret = cifs_handle_standard(server, mid_entry);
 
-	if (ret == 0 && shdr->NextCommand) {
-		pdu_length -= le32_to_cpu(shdr->NextCommand);
+	if (ret == 0 && next_cmd) {
+		pdu_length -= next_cmd;
 		server->large_buf = next_is_large;
 		if (next_is_large)
 			server->bigbuf = buf = next_buffer;
-- 
2.43.0

