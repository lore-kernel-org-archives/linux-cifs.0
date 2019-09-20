Return-Path: <SRS0=I8uG=XP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CBBC49ED7
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Sep 2019 05:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 589E82080F
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Sep 2019 05:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725867AbfITFBq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 Sep 2019 01:01:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:48844 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725781AbfITFBp (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 20 Sep 2019 01:01:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D2500AF11;
        Fri, 20 Sep 2019 05:01:42 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v4 3/6] cifs: switch servers depending on binding state
Date:   Fri, 20 Sep 2019 07:01:16 +0200
Message-Id: <20190920050119.27017-4-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190920050119.27017-1-aaptel@suse.com>
References: <20190920050119.27017-1-aaptel@suse.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Currently a lot of the code to initialize a connection & session uses
the cifs_ses as input. But depending on if we are opening a new session
or a new channel we need to use different server pointers.

Add a "binding" flag in cifs_ses a helper function that returns the
current server a session should use (only in the sess establishment
code path)

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/cifs_spnego.c |  2 +-
 fs/cifs/cifsglob.h    | 10 ++++++++++
 fs/cifs/connect.c     |  4 ++--
 fs/cifs/sess.c        |  5 +++--
 fs/cifs/smb2ops.c     |  2 +-
 fs/cifs/smb2pdu.c     | 31 ++++++++++++++++---------------
 6 files changed, 33 insertions(+), 21 deletions(-)

diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
index 7f01c6e60791..7b9b876b513b 100644
--- a/fs/cifs/cifs_spnego.c
+++ b/fs/cifs/cifs_spnego.c
@@ -98,7 +98,7 @@ struct key_type cifs_spnego_key_type = {
 struct key *
 cifs_get_spnego_key(struct cifs_ses *sesInfo)
 {
-	struct TCP_Server_Info *server = sesInfo->server;
+	struct TCP_Server_Info *server = cifs_ses_server(sesInfo);
 	struct sockaddr_in *sa = (struct sockaddr_in *) &server->dstaddr;
 	struct sockaddr_in6 *sa6 = (struct sockaddr_in6 *) &server->dstaddr;
 	char *description, *dp;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index e980e7b0d79d..57c6d322a877 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -992,6 +992,7 @@ struct cifs_ses {
 	bool sign;		/* is signing required? */
 	bool need_reconnect:1; /* connection reset, uid now invalid */
 	bool domainAuto:1;
+	bool binding:1; /* are we binding the session? */
 	__u16 session_flags;
 	__u8 smb3signingkey[SMB3_SIGN_KEY_SIZE];
 	__u8 smb3encryptionkey[SMB3_SIGN_KEY_SIZE];
@@ -1018,6 +1019,15 @@ struct cifs_ses {
 	size_t chan_max;
 };
 
+static inline
+struct TCP_Server_Info *cifs_ses_server(struct cifs_ses *ses)
+{
+	if (ses->binding)
+		return ses->chans[ses->chan_count].server;
+	else
+		return ses->server;
+}
+
 static inline bool
 cap_unix(struct cifs_ses *ses)
 {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index fb95fd90b578..3e150cc8a5ae 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -5163,7 +5163,7 @@ int
 cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses)
 {
 	int rc = 0;
-	struct TCP_Server_Info *server = ses->server;
+	struct TCP_Server_Info *server = cifs_ses_server(ses);
 
 	if (!server->ops->need_neg || !server->ops->negotiate)
 		return -ENOSYS;
@@ -5190,7 +5190,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		   struct nls_table *nls_info)
 {
 	int rc = -ENOSYS;
-	struct TCP_Server_Info *server = ses->server;
+	struct TCP_Server_Info *server = cifs_ses_server(ses);
 
 	ses->capabilities = server->capabilities;
 	if (linuxExtEnabled == 0)
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 4c764ff7edd2..3c1c3999a414 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -342,6 +342,7 @@ int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
 					 struct cifs_ses *ses)
 {
+	struct TCP_Server_Info *server = cifs_ses_server(ses);
 	NEGOTIATE_MESSAGE *sec_blob = (NEGOTIATE_MESSAGE *)pbuffer;
 	__u32 flags;
 
@@ -354,9 +355,9 @@ void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
 		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
 		NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC |
 		NTLMSSP_NEGOTIATE_SEAL;
-	if (ses->server->sign)
+	if (server->sign)
 		flags |= NTLMSSP_NEGOTIATE_SIGN;
-	if (!ses->server->session_estab || ses->ntlmssp->sesskey_per_smbsess)
+	if (!server->session_estab || ses->ntlmssp->sesskey_per_smbsess)
 		flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
 
 	sec_blob->NegotiateFlags = cpu_to_le32(flags);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index eaed18061314..1ca35672350c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -315,7 +315,7 @@ smb2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 {
 	int rc;
 
-	ses->server->CurrentMid = 0;
+	cifs_ses_server(ses)->CurrentMid = 0;
 	rc = SMB2_negotiate(xid, ses);
 	/* BB we probably don't need to retry with modern servers */
 	if (rc == -EAGAIN)
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 87066f1af12c..9637f6e1d3ba 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -789,7 +789,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	struct kvec rsp_iov;
 	int rc = 0;
 	int resp_buftype;
-	struct TCP_Server_Info *server = ses->server;
+	struct TCP_Server_Info *server = cifs_ses_server(ses);
 	int blob_offset, blob_length;
 	char *security_blob;
 	int flags = CIFS_NEG_OP;
@@ -811,7 +811,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	memset(server->preauth_sha_hash, 0, SMB2_PREAUTH_HASH_SIZE);
 	memset(ses->preauth_sha_hash, 0, SMB2_PREAUTH_HASH_SIZE);
 
-	if (strcmp(ses->server->vals->version_string,
+	if (strcmp(server->vals->version_string,
 		   SMB3ANY_VERSION_STRING) == 0) {
 		req->Dialects[0] = cpu_to_le16(SMB30_PROT_ID);
 		req->Dialects[1] = cpu_to_le16(SMB302_PROT_ID);
@@ -827,7 +827,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 		total_len += 8;
 	} else {
 		/* otherwise send specific dialect */
-		req->Dialects[0] = cpu_to_le16(ses->server->vals->protocol_id);
+		req->Dialects[0] = cpu_to_le16(server->vals->protocol_id);
 		req->DialectCount = cpu_to_le16(1);
 		total_len += 2;
 	}
@@ -1169,7 +1169,7 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
 	int rc;
 	struct cifs_ses *ses = sess_data->ses;
 	struct smb2_sess_setup_req *req;
-	struct TCP_Server_Info *server = ses->server;
+	struct TCP_Server_Info *server = cifs_ses_server(ses);
 	unsigned int total_len;
 
 	rc = smb2_plain_req_init(SMB2_SESSION_SETUP, NULL, (void **) &req,
@@ -1256,22 +1256,23 @@ SMB2_sess_establish_session(struct SMB2_sess_data *sess_data)
 {
 	int rc = 0;
 	struct cifs_ses *ses = sess_data->ses;
+	struct TCP_Server_Info *server = cifs_ses_server(ses);
 
-	mutex_lock(&ses->server->srv_mutex);
-	if (ses->server->ops->generate_signingkey) {
-		rc = ses->server->ops->generate_signingkey(ses);
+	mutex_lock(&server->srv_mutex);
+	if (server->ops->generate_signingkey) {
+		rc = server->ops->generate_signingkey(ses);
 		if (rc) {
 			cifs_dbg(FYI,
 				"SMB3 session key generation failed\n");
-			mutex_unlock(&ses->server->srv_mutex);
+			mutex_unlock(&server->srv_mutex);
 			return rc;
 		}
 	}
-	if (!ses->server->session_estab) {
-		ses->server->sequence_number = 0x2;
-		ses->server->session_estab = true;
+	if (!server->session_estab) {
+		server->sequence_number = 0x2;
+		server->session_estab = true;
 	}
-	mutex_unlock(&ses->server->srv_mutex);
+	mutex_unlock(&server->srv_mutex);
 
 	cifs_dbg(FYI, "SMB2/3 session established successfully\n");
 	spin_lock(&GlobalMid_Lock);
@@ -1507,7 +1508,7 @@ SMB2_select_sec(struct cifs_ses *ses, struct SMB2_sess_data *sess_data)
 {
 	int type;
 
-	type = smb2_select_sectype(ses->server, ses->sectype);
+	type = smb2_select_sectype(cifs_ses_server(ses), ses->sectype);
 	cifs_dbg(FYI, "sess setup type %d\n", type);
 	if (type == Unspecified) {
 		cifs_dbg(VFS,
@@ -1535,7 +1536,7 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
 		const struct nls_table *nls_cp)
 {
 	int rc = 0;
-	struct TCP_Server_Info *server = ses->server;
+	struct TCP_Server_Info *server = cifs_ses_server(ses);
 	struct SMB2_sess_data *sess_data;
 
 	cifs_dbg(FYI, "Session Setup\n");
@@ -1561,7 +1562,7 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
 	/*
 	 * Initialize the session hash with the server one.
 	 */
-	memcpy(ses->preauth_sha_hash, ses->server->preauth_sha_hash,
+	memcpy(ses->preauth_sha_hash, server->preauth_sha_hash,
 	       SMB2_PREAUTH_HASH_SIZE);
 
 	while (sess_data->func)
-- 
2.16.4

