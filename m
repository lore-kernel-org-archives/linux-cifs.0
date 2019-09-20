Return-Path: <SRS0=I8uG=XP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED054C49ED7
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Sep 2019 05:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F2732080F
	for <linux-cifs@archiver.kernel.org>; Fri, 20 Sep 2019 05:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437192AbfITFB6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 20 Sep 2019 01:01:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:48886 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2437189AbfITFB6 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 20 Sep 2019 01:01:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 98561AF81;
        Fri, 20 Sep 2019 05:01:53 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v4 5/6] cifs: try opening channels after mounting
Date:   Fri, 20 Sep 2019 07:01:18 +0200
Message-Id: <20190920050119.27017-6-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190920050119.27017-1-aaptel@suse.com>
References: <20190920050119.27017-1-aaptel@suse.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

After doing mount() sucessfully we call cifs_try_adding_channels()
which will open as many channels as it can.

The master connection become the first channel.

Each channel has its own signing key which must be used only after the
channel has been opened.

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/cifsglob.h      |   2 +
 fs/cifs/cifsproto.h     |   7 ++
 fs/cifs/connect.c       |  40 ++++++---
 fs/cifs/sess.c          | 211 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2misc.c      |  37 ++++++---
 fs/cifs/smb2pdu.c       |  75 ++++++++++-------
 fs/cifs/smb2transport.c | 126 +++++++++++++++++++++++------
 fs/cifs/transport.c     |  10 ++-
 8 files changed, 430 insertions(+), 78 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 57c6d322a877..98b3fad66c55 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -999,6 +999,8 @@ struct cifs_ses {
 	__u8 smb3decryptionkey[SMB3_SIGN_KEY_SIZE];
 	__u8 preauth_sha_hash[SMB2_PREAUTH_HASH_SIZE];
 
+	__u8 binding_preauth_sha_hash[SMB2_PREAUTH_HASH_SIZE];
+
 	/*
 	 * Network interfaces available on the server this session is
 	 * connected to.
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index ee3e6d6556a7..4cda8bba308b 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -242,6 +242,7 @@ extern void cifs_add_pending_open_locked(struct cifs_fid *fid,
 					 struct tcon_link *tlink,
 					 struct cifs_pending_open *open);
 extern void cifs_del_pending_open(struct cifs_pending_open *open);
+extern struct TCP_Server_Info *cifs_get_tcp_session(struct smb_vol *vol);
 extern void cifs_put_tcp_session(struct TCP_Server_Info *server,
 				 int from_reconnect);
 extern void cifs_put_tcon(struct cifs_tcon *tcon);
@@ -583,6 +584,12 @@ void cifs_free_hash(struct crypto_shash **shash, struct sdesc **sdesc);
 
 extern void rqst_page_get_length(struct smb_rqst *rqst, unsigned int page,
 				unsigned int *len, unsigned int *offset);
+int cifs_try_adding_channels(struct cifs_ses *ses);
+int cifs_ses_add_channel(struct cifs_ses *ses,
+				struct cifs_server_iface *iface);
+bool is_server_using_iface(struct TCP_Server_Info *server,
+			   struct cifs_server_iface *iface);
+bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface);
 
 void extract_unc_hostname(const char *unc, const char **h, size_t *len);
 int copy_path_name(char *dst, const char *src);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3e150cc8a5ae..9d6805062841 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2728,7 +2728,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 		send_sig(SIGKILL, task, 1);
 }
 
-static struct TCP_Server_Info *
+struct TCP_Server_Info *
 cifs_get_tcp_session(struct smb_vol *volume_info)
 {
 	struct TCP_Server_Info *tcp_ses = NULL;
@@ -3302,14 +3302,25 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 	ses->sectype = volume_info->sectype;
 	ses->sign = volume_info->sign;
 	mutex_lock(&ses->session_mutex);
+
+	/* add server as first channel */
+	ses->chans[0].server = server;
+	ses->chan_count = 1;
+	ses->chan_max = volume_info->multichannel ? volume_info->max_channels:1;
+
 	rc = cifs_negotiate_protocol(xid, ses);
 	if (!rc)
 		rc = cifs_setup_session(xid, ses, volume_info->local_nls);
+
+	/* each channel uses a different signing key */
+	memcpy(ses->chans[0].signkey, ses->smb3signingkey,
+	       sizeof(ses->smb3signingkey));
+
 	mutex_unlock(&ses->session_mutex);
 	if (rc)
 		goto get_ses_fail;
 
-	/* success, put it on the list */
+	/* success, put it on the list and add it as first channel */
 	spin_lock(&cifs_tcp_ses_lock);
 	list_add(&ses->smb_ses_list, &server->smb_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
@@ -4918,6 +4929,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb_vol *vol)
 	cifs_autodisable_serverino(cifs_sb);
 out:
 	free_xid(xid);
+	cifs_try_adding_channels(ses);
 	return mount_setup_tlink(cifs_sb, ses, tcon);
 
 error:
@@ -5192,21 +5204,23 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	int rc = -ENOSYS;
 	struct TCP_Server_Info *server = cifs_ses_server(ses);
 
-	ses->capabilities = server->capabilities;
-	if (linuxExtEnabled == 0)
-		ses->capabilities &= (~server->vals->cap_unix);
+	if (!ses->binding) {
+		ses->capabilities = server->capabilities;
+		if (linuxExtEnabled == 0)
+			ses->capabilities &= (~server->vals->cap_unix);
+
+		if (ses->auth_key.response) {
+			cifs_dbg(FYI, "Free previous auth_key.response = %p\n",
+				 ses->auth_key.response);
+			kfree(ses->auth_key.response);
+			ses->auth_key.response = NULL;
+			ses->auth_key.len = 0;
+		}
+	}
 
 	cifs_dbg(FYI, "Security Mode: 0x%x Capabilities: 0x%x TimeAdjust: %d\n",
 		 server->sec_mode, server->capabilities, server->timeAdj);
 
-	if (ses->auth_key.response) {
-		cifs_dbg(FYI, "Free previous auth_key.response = %p\n",
-			 ses->auth_key.response);
-		kfree(ses->auth_key.response);
-		ses->auth_key.response = NULL;
-		ses->auth_key.len = 0;
-	}
-
 	if (server->ops->sess_setup)
 		rc = server->ops->sess_setup(xid, ses, nls_info);
 
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 3c1c3999a414..20c73a42755d 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -31,6 +31,217 @@
 #include <linux/utsname.h>
 #include <linux/slab.h>
 #include "cifs_spnego.h"
+#include "smb2proto.h"
+
+bool
+is_server_using_iface(struct TCP_Server_Info *server,
+		      struct cifs_server_iface *iface)
+{
+	struct sockaddr_in *i4 = (struct sockaddr_in *)&iface->sockaddr;
+	struct sockaddr_in6 *i6 = (struct sockaddr_in6 *)&iface->sockaddr;
+	struct sockaddr_in *s4 = (struct sockaddr_in *)&server->dstaddr;
+	struct sockaddr_in6 *s6 = (struct sockaddr_in6 *)&server->dstaddr;
+
+	if (server->dstaddr.ss_family != iface->sockaddr.ss_family)
+		return false;
+	if (server->dstaddr.ss_family == AF_INET) {
+		if (s4->sin_addr.s_addr != i4->sin_addr.s_addr)
+			return false;
+	} else if (server->dstaddr.ss_family == AF_INET6) {
+		if (memcmp(&s6->sin6_addr, &i6->sin6_addr,
+			   sizeof(i6->sin6_addr)) != 0)
+			return false;
+	} else {
+		/* unknown family.. */
+		return false;
+	}
+	return true;
+}
+
+bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface)
+{
+	int i;
+	for (i = 0; i < ses->chan_count; i++) {
+		if (is_server_using_iface(ses->chans[i].server, iface))
+			return true;
+	}
+	return false;
+}
+
+/* returns number of channels added */
+int cifs_try_adding_channels(struct cifs_ses *ses)
+{
+	int old_chan_count = ses->chan_count;
+	int left = ses->chan_max - ses->chan_count;
+	int i = 0;
+	int rc = 0;
+
+	if (left <= 0) {
+		cifs_dbg(FYI,
+			 "ses already at max_channels (%zu), nothing to open\n",
+			 ses->chan_max);
+		return 0;
+	}
+
+	if (ses->server->dialect != SMB311_PROT_ID) {
+		cifs_dbg(VFS, "multichannel is not supported on this protocol version, use 3.1.1\n");
+		return 0;
+	}
+
+	/* ifaces are sorted by speed, try them in order */
+	for (i = 0; left > 0 && i < ses->iface_count; i++) {
+		struct cifs_server_iface *iface;
+
+		iface = &ses->iface_list[i];
+		if (is_ses_using_iface(ses, iface) && !iface->rss_capable)
+			continue;
+
+		rc = cifs_ses_add_channel(ses, iface);
+		if (rc) {
+			cifs_dbg(FYI, "failed to open extra channel\n");
+			continue;
+		}
+
+		cifs_dbg(FYI, "sucessfully opened new channel\n");
+		left--;
+	}
+
+	/*
+	 * TODO: if we still have channels left to open try to connect
+	 * to same RSS-capable iface multiple times
+	 */
+
+	return ses->chan_count - old_chan_count;
+}
+
+int
+cifs_ses_add_channel(struct cifs_ses *ses, struct cifs_server_iface *iface)
+{
+	struct cifs_chan *chan;
+	struct smb_vol vol = {0};
+	const char unc_fmt[] = "\\%s\\foo";
+	char unc[sizeof(unc_fmt)+SERVER_NAME_LEN_WITH_NULL] = {0};
+	struct sockaddr_in *ipv4 = (struct sockaddr_in *)&iface->sockaddr;
+	struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)&iface->sockaddr;
+	int rc;
+	unsigned int xid = get_xid();
+
+	cifs_dbg(FYI, "adding channel to ses %p (speed:%zu bps rdma:%s ",
+		 ses, iface->speed, iface->rdma_capable ? "yes" : "no");
+	if (iface->sockaddr.ss_family == AF_INET)
+		cifs_dbg(FYI, "ip:%pI4)\n", &ipv4->sin_addr);
+	else
+		cifs_dbg(FYI, "ip:%pI6)\n", &ipv6->sin6_addr);
+
+	/*
+	 * Setup a smb_vol with mostly the same info as the existing
+	 * session and overwrite it with the requested iface data.
+	 *
+	 * We need to setup at least the fields used for negprot and
+	 * sesssetup.
+	 *
+	 * We only need the volume here, so we can reuse memory from
+	 * the session and server without caring about memory
+	 * management.
+	 */
+
+	/* Always make new connection for now (TODO?) */
+	vol.nosharesock = true;
+
+	/* Auth */
+	vol.domainauto = ses->domainAuto;
+	vol.domainname = ses->domainName;
+	vol.username = ses->user_name;
+	vol.password = ses->password;
+	vol.sectype = ses->sectype;
+	vol.sign = ses->sign;
+
+	/* UNC and paths */
+	/* XXX: Use ses->server->hostname? */
+	sprintf(unc, unc_fmt, ses->serverName);
+	vol.UNC = unc;
+	vol.prepath = "";
+
+	/* Require SMB3.1.1 */
+	vol.vals = &smb311_values;
+	vol.ops = &smb311_operations;
+
+	vol.noblocksnd = ses->server->noblocksnd;
+	vol.noautotune = ses->server->noautotune;
+	vol.sockopt_tcp_nodelay = ses->server->tcp_nodelay;
+	vol.echo_interval = ses->server->echo_interval / HZ;
+
+	/*
+	 * This will be used for encoding/decoding user/domain/pw
+	 * during sess setup auth.
+	 *
+	 * XXX: We use the default for simplicity but the proper way
+	 * would be to use the one that ses used, which is not
+	 * stored. This might break when dealing with non-ascii
+	 * strings.
+	 */
+	vol.local_nls = load_nls_default();
+
+	/* Use RDMA if possible */
+	vol.rdma = iface->rdma_capable;
+	memcpy(&vol.dstaddr, &iface->sockaddr, sizeof(struct sockaddr_storage));
+
+	/* reuse master con client guid */
+	memcpy(&vol.client_guid, ses->server->client_guid, SMB2_CLIENT_GUID_SIZE);
+	vol.use_client_guid = true;
+
+	mutex_lock(&ses->session_mutex);
+
+	chan = &ses->chans[ses->chan_count];
+	chan->server = cifs_get_tcp_session(&vol);
+	if (IS_ERR(chan->server)) {
+		rc = PTR_ERR(chan->server);
+		chan->server = NULL;
+		goto out;
+	}
+
+	/*
+	 * We need to allocate the server crypto now as we will need
+	 * to sign packets before we generate the channel signing key
+	 * (we sign with the session key)
+	 */
+	rc = smb311_crypto_shash_allocate(chan->server);
+	if (rc) {
+		cifs_dbg(VFS, "%s: crypto alloc failed\n", __func__);
+		goto out;
+	}
+
+	ses->binding = true;
+	rc = cifs_negotiate_protocol(xid, ses);
+	if (rc)
+		goto out;
+
+	rc = cifs_setup_session(xid, ses, vol.local_nls);
+	if (rc)
+		goto out;
+
+	/* success, put it on the list
+	 * XXX: sharing ses between 2 tcp server is not possible, the
+	 * way "internal" linked lists works in linux makes element
+	 * only able to belong to one list
+	 *
+	 * the binding session is already established so the rest of
+	 * the code should be able to look it up, no need to add the
+	 * ses to the new server.
+	 */
+
+	ses->chan_count++;
+
+out:
+	ses->binding = false;
+	mutex_unlock(&ses->session_mutex);
+
+	if (rc && chan->server)
+		cifs_put_tcp_session(chan->server, 0);
+	unload_nls(vol.local_nls);
+
+	return rc;
+}
 
 static __u32 cifs_ssetup_hdr(struct cifs_ses *ses, SESSION_SETUP_ANDX *pSMB)
 {
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index e311f58dc1c8..a95ed951c67f 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -29,6 +29,7 @@
 #include "cifs_unicode.h"
 #include "smb2status.h"
 #include "smb2glob.h"
+#include "nterr.h"
 
 static int
 check_smb2_hdr(struct smb2_sync_hdr *shdr, __u64 mid)
@@ -788,23 +789,37 @@ smb311_update_preauth_hash(struct cifs_ses *ses, struct kvec *iov, int nvec)
 	int i, rc;
 	struct sdesc *d;
 	struct smb2_sync_hdr *hdr;
+	struct TCP_Server_Info *server = cifs_ses_server(ses);
 
-	if (ses->server->tcpStatus == CifsGood) {
-		/* skip non smb311 connections */
-		if (ses->server->dialect != SMB311_PROT_ID)
-			return 0;
+	hdr = (struct smb2_sync_hdr *)iov[0].iov_base;
+	/* neg prot are always taken */
+	if (hdr->Command == SMB2_NEGOTIATE)
+		goto ok;
 
-		/* skip last sess setup response */
-		hdr = (struct smb2_sync_hdr *)iov[0].iov_base;
-		if (hdr->Flags & SMB2_FLAGS_SIGNED)
-			return 0;
-	}
+	/*
+	 * If we process a command which wasn't a negprot it means the
+	 * neg prot was already done, so the server dialect was set
+	 * and we can test it. Preauth requires 3.1.1 for now.
+	 */
+	if (server->dialect != SMB311_PROT_ID)
+		return 0;
+
+	if (hdr->Command != SMB2_SESSION_SETUP)
+		return 0;
+
+	/* skip last sess setup response */
+	if ((hdr->Flags & SMB2_FLAGS_SERVER_TO_REDIR)
+	    && (hdr->Status == NT_STATUS_OK
+		|| (hdr->Status !=
+		    cpu_to_le32(NT_STATUS_MORE_PROCESSING_REQUIRED))))
+		return 0;
 
-	rc = smb311_crypto_shash_allocate(ses->server);
+ok:
+	rc = smb311_crypto_shash_allocate(server);
 	if (rc)
 		return rc;
 
-	d = ses->server->secmech.sdescsha512;
+	d = server->secmech.sdescsha512;
 	rc = crypto_shash_init(&d->shash);
 	if (rc) {
 		cifs_dbg(VFS, "%s: could not init sha512 shash\n", __func__);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 9637f6e1d3ba..8bcb278fdb0a 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1177,13 +1177,18 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
 	if (rc)
 		return rc;
 
-	/* First session, not a reauthenticate */
-	req->sync_hdr.SessionId = 0;
-
-	/* if reconnect, we need to send previous sess id, otherwise it is 0 */
-	req->PreviousSessionId = sess_data->previous_session;
-
-	req->Flags = 0; /* MBZ */
+	if (sess_data->ses->binding) {
+		req->sync_hdr.SessionId = sess_data->ses->Suid;
+		req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
+		req->PreviousSessionId = 0;
+		req->Flags = SMB2_SESSION_REQ_FLAG_BINDING;
+	} else {
+		/* First session, not a reauthenticate */
+		req->sync_hdr.SessionId = 0;
+		/* if reconnect, we need to send previous sess id, otherwise it is 0 */
+		req->PreviousSessionId = sess_data->previous_session;
+		req->Flags = 0; /* MBZ */
+	}
 
 	/* enough to enable echos and oplocks and one max size write */
 	req->sync_hdr.CreditRequest = cpu_to_le16(130);
@@ -1275,10 +1280,14 @@ SMB2_sess_establish_session(struct SMB2_sess_data *sess_data)
 	mutex_unlock(&server->srv_mutex);
 
 	cifs_dbg(FYI, "SMB2/3 session established successfully\n");
-	spin_lock(&GlobalMid_Lock);
-	ses->status = CifsGood;
-	ses->need_reconnect = false;
-	spin_unlock(&GlobalMid_Lock);
+	/* keep exising ses state if binding */
+	if (!ses->binding) {
+		spin_lock(&GlobalMid_Lock);
+		ses->status = CifsGood;
+		ses->need_reconnect = false;
+		spin_unlock(&GlobalMid_Lock);
+	}
+
 	return rc;
 }
 
@@ -1316,16 +1325,19 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 		goto out_put_spnego_key;
 	}
 
-	ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
-					 GFP_KERNEL);
-	if (!ses->auth_key.response) {
-		cifs_dbg(VFS,
-			"Kerberos can't allocate (%u bytes) memory",
-			msg->sesskey_len);
-		rc = -ENOMEM;
-		goto out_put_spnego_key;
+	/* keep session key if binding */
+	if (!ses->binding) {
+		ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
+						 GFP_KERNEL);
+		if (!ses->auth_key.response) {
+			cifs_dbg(VFS,
+				 "Kerberos can't allocate (%u bytes) memory",
+				 msg->sesskey_len);
+			rc = -ENOMEM;
+			goto out_put_spnego_key;
+		}
+		ses->auth_key.len = msg->sesskey_len;
 	}
-	ses->auth_key.len = msg->sesskey_len;
 
 	sess_data->iov[1].iov_base = msg->data + msg->sesskey_len;
 	sess_data->iov[1].iov_len = msg->secblob_len;
@@ -1335,9 +1347,11 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 		goto out_put_spnego_key;
 
 	rsp = (struct smb2_sess_setup_rsp *)sess_data->iov[0].iov_base;
-	ses->Suid = rsp->sync_hdr.SessionId;
-
-	ses->session_flags = le16_to_cpu(rsp->SessionFlags);
+	/* keep session id and flags if binding */
+	if (!ses->binding) {
+		ses->Suid = rsp->sync_hdr.SessionId;
+		ses->session_flags = le16_to_cpu(rsp->SessionFlags);
+	}
 
 	rc = SMB2_sess_establish_session(sess_data);
 out_put_spnego_key:
@@ -1431,9 +1445,11 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 
 	cifs_dbg(FYI, "rawntlmssp session setup challenge phase\n");
 
-
-	ses->Suid = rsp->sync_hdr.SessionId;
-	ses->session_flags = le16_to_cpu(rsp->SessionFlags);
+	/* keep existing ses id and flags if binding */
+	if (!ses->binding) {
+		ses->Suid = rsp->sync_hdr.SessionId;
+		ses->session_flags = le16_to_cpu(rsp->SessionFlags);
+	}
 
 out:
 	kfree(ntlmssp_blob);
@@ -1490,8 +1506,11 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 
 	rsp = (struct smb2_sess_setup_rsp *)sess_data->iov[0].iov_base;
 
-	ses->Suid = rsp->sync_hdr.SessionId;
-	ses->session_flags = le16_to_cpu(rsp->SessionFlags);
+	/* keep existing ses id and flags if binding */
+	if (!ses->binding) {
+		ses->Suid = rsp->sync_hdr.SessionId;
+		ses->session_flags = le16_to_cpu(rsp->SessionFlags);
+	}
 
 	rc = SMB2_sess_establish_session(sess_data);
 out:
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index d7d89741f3f0..12988df6b24d 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -48,7 +48,7 @@ smb2_crypto_shash_allocate(struct TCP_Server_Info *server)
 			       &server->secmech.sdeschmacsha256);
 }
 
-static int
+int
 smb3_crypto_shash_allocate(struct TCP_Server_Info *server)
 {
 	struct cifs_secmech *p = &server->secmech;
@@ -98,6 +98,44 @@ smb311_crypto_shash_allocate(struct TCP_Server_Info *server)
 	return rc;
 }
 
+u8 *smb2_find_chan_signkey(struct cifs_ses *ses, struct TCP_Server_Info *server)
+{
+	int i;
+	struct cifs_chan *chan;
+	int count;
+	spin_lock(&cifs_tcp_ses_lock);
+	count = ses->chan_count;
+	if (ses->binding)
+		count++;
+	for (i = 0; i < count; i++) {
+		chan = ses->chans + i;
+		if (chan->server == server) {
+			spin_unlock(&cifs_tcp_ses_lock);
+			return chan->signkey;
+		}
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+	return NULL;
+}
+
+struct cifs_ses *
+smb2_find_global_smb_ses(__u64 ses_id)
+{
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses;
+	spin_lock(&cifs_tcp_ses_lock);
+	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
+		list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+			if (ses->Suid == ses_id) {
+				spin_unlock(&cifs_tcp_ses_lock);
+				return ses;
+			}
+		}
+	}
+	spin_unlock(&cifs_tcp_ses_lock);
+	return NULL;
+}
+
 static struct cifs_ses *
 smb2_find_smb_ses_unlocked(struct TCP_Server_Info *server, __u64 ses_id)
 {
@@ -328,21 +366,33 @@ generate_smb3signingkey(struct cifs_ses *ses,
 {
 	int rc;
 
-	rc = generate_key(ses, ptriplet->signing.label,
-			  ptriplet->signing.context, ses->smb3signingkey,
-			  SMB3_SIGN_KEY_SIZE);
-	if (rc)
-		return rc;
-
-	rc = generate_key(ses, ptriplet->encryption.label,
-			  ptriplet->encryption.context, ses->smb3encryptionkey,
-			  SMB3_SIGN_KEY_SIZE);
-	if (rc)
-		return rc;
-
-	rc = generate_key(ses, ptriplet->decryption.label,
-			  ptriplet->decryption.context,
-			  ses->smb3decryptionkey, SMB3_SIGN_KEY_SIZE);
+	if (ses->binding) {
+		struct TCP_Server_Info *server;
+		server = cifs_ses_server(ses);
+		rc = generate_key(ses, ptriplet->signing.label,
+				  ptriplet->signing.context,
+				  smb2_find_chan_signkey(ses, server),
+				  SMB3_SIGN_KEY_SIZE);
+		if (rc)
+			return rc;
+	} else {
+		rc = generate_key(ses, ptriplet->signing.label,
+				  ptriplet->signing.context,
+				  ses->smb3signingkey,
+				  SMB3_SIGN_KEY_SIZE);
+		if (rc)
+			return rc;
+		rc = generate_key(ses, ptriplet->encryption.label,
+				  ptriplet->encryption.context,
+				  ses->smb3encryptionkey,
+				  SMB3_SIGN_KEY_SIZE);
+		rc = generate_key(ses, ptriplet->decryption.label,
+				  ptriplet->decryption.context,
+				  ses->smb3decryptionkey,
+				  SMB3_SIGN_KEY_SIZE);
+		if (rc)
+			return rc;
+	}
 
 	if (rc)
 		return rc;
@@ -434,18 +484,35 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 	struct cifs_ses *ses;
 	struct shash_desc *shash = &server->secmech.sdesccmacaes->shash;
 	struct smb_rqst drqst;
+	u8 *key;
 
-	ses = smb2_find_smb_ses(server, shdr->SessionId);
+	ses = smb2_find_global_smb_ses(shdr->SessionId);
 	if (!ses) {
 		cifs_server_dbg(VFS, "%s: Could not find session\n", __func__);
 		return 0;
 	}
 
+	/*
+	 * If we are binding an existing session use the session key,
+	 * otherwise use the channel key
+	 */
+	if (ses->binding)
+		key = ses->smb3signingkey;
+	else {
+		key = smb2_find_chan_signkey(ses, server);
+		if (!key) {
+			cifs_dbg(VFS,
+				 "%s: Could not find channel signing key\n",
+				 __func__);
+			return 0;
+		}
+        }
+
 	memset(smb3_signature, 0x0, SMB2_CMACAES_SIZE);
 	memset(shdr->Signature, 0x0, SMB2_SIGNATURE_SIZE);
 
 	rc = crypto_shash_setkey(server->secmech.cmacaes,
-				 ses->smb3signingkey, SMB2_CMACAES_SIZE);
+				 key, SMB2_CMACAES_SIZE);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not set key for cmac aes\n", __func__);
 		return rc;
@@ -494,16 +561,25 @@ static int
 smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
 	int rc = 0;
-	struct smb2_sync_hdr *shdr =
-			(struct smb2_sync_hdr *)rqst->rq_iov[0].iov_base;
+	struct smb2_sync_hdr *shdr;
+	struct smb2_sess_setup_req *ssr;
+	bool is_binding;
+	bool is_signed;
 
-	if (!(shdr->Flags & SMB2_FLAGS_SIGNED) ||
-	    server->tcpStatus == CifsNeedNegotiate)
-		return rc;
+	shdr = (struct smb2_sync_hdr *)rqst->rq_iov[0].iov_base;
+	ssr = (struct smb2_sess_setup_req *)shdr;
 
-	if (!server->session_estab) {
+	is_binding = shdr->Command == SMB2_SESSION_SETUP &&
+		(ssr->Flags & SMB2_SESSION_REQ_FLAG_BINDING);
+	is_signed = shdr->Flags & SMB2_FLAGS_SIGNED;
+
+	if (!is_signed)
+		return 0;
+	if (server->tcpStatus == CifsNeedNegotiate)
+		return 0;
+	if (!is_binding && !server->session_estab) {
 		strncpy(shdr->Signature, "BSRSPYL", 8);
-		return rc;
+		return 0;
 	}
 
 	rc = server->ops->calc_signature(rqst, server);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index afe66f9cb15e..39e6b47a77d9 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -995,7 +995,15 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		return -EIO;
 	}
 
-	server = ses->server;
+	if (!ses->binding) {
+		uint index = 0;
+		if (ses->chan_count > 1)
+			index = ((unsigned)get_random_int()) % ses->chan_count;
+		server = ses->chans[index].server;
+	} else {
+		server = cifs_ses_server(ses);
+	}
+
 	if (server->tcpStatus == CifsExiting)
 		return -ENOENT;
 
-- 
2.16.4

