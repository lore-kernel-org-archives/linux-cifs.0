From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: Add per-version guid
Date: Wed, 13 Aug 2014 16:49:34 +0100
Message-ID: <1407944975-20653-1-git-send-email-sprabhu@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Commit
39552ea8120a699dbd0360848c4d949f9f0e6deb
changes guid on per connection basis. This can cause problems in the
future when making multichannel associations. The problem is described
by Tom Talpey at
https://www.mail-archive.com/linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg09396.html

We try and work around this problem by assigning a client guid for each
smb2 dialect and use these GUIDs with their corresponding dialects.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsfs.c   | 15 +++++++++++++++
 fs/cifs/cifsglob.h |  2 +-
 fs/cifs/connect.c  |  3 ---
 fs/cifs/smb2pdu.c  | 10 +++-------
 4 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8883980..fa8a1a4 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1162,6 +1162,16 @@ cifs_destroy_mids(void)
 	kmem_cache_destroy(cifs_mid_cachep);
 }
 
+static void init_guids(void)
+{
+	/* We do not sent a client GUID for SMB2.02 dialect */
+	memset(&smb20_values.client_guid, 0, SMB2_CLIENT_GUID_SIZE);
+
+	get_random_bytes(&smb21_values.client_guid, SMB2_CLIENT_GUID_SIZE);
+	get_random_bytes(&smb30_values.client_guid, SMB2_CLIENT_GUID_SIZE);
+	get_random_bytes(&smb302_values.client_guid, SMB2_CLIENT_GUID_SIZE);
+}
+
 static int __init
 init_cifs(void)
 {
@@ -1196,6 +1206,11 @@ init_cifs(void)
 	spin_lock_init(&cifs_file_list_lock);
 	spin_lock_init(&GlobalMid_Lock);
 
+
+#ifdef CONFIG_CIFS_SMB2
+	init_guids();
+#endif
+
 	if (cifs_max_pending < 2) {
 		cifs_max_pending = 2;
 		cifs_dbg(FYI, "cifs_max_pending set to min of 2\n");
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 0012e1e..1c044f4 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -429,6 +429,7 @@ struct smb_version_values {
 	__u16		signing_enabled;
 	__u16		signing_required;
 	size_t		create_lease_size;
+	__u8		client_guid[SMB2_CLIENT_GUID_SIZE];
 };
 
 #define HEADER_SIZE(server) (server->vals->header_size)
@@ -564,7 +565,6 @@ struct TCP_Server_Info {
 	int echo_credits;  /* echo reserved slots */
 	int oplock_credits;  /* oplock break reserved slots */
 	bool echoes:1; /* enable echoes */
-	__u8 client_guid[SMB2_CLIENT_GUID_SIZE]; /* Client GUID */
 #endif
 	u16 dialect; /* dialect index that server chose */
 	bool oplocks:1; /* enable oplocks */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 03ed8a0..2b8dd80 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2144,9 +2144,6 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	       sizeof(tcp_ses->srcaddr));
 	memcpy(&tcp_ses->dstaddr, &volume_info->dstaddr,
 		sizeof(tcp_ses->dstaddr));
-#ifdef CONFIG_CIFS_SMB2
-	get_random_bytes(tcp_ses->client_guid, SMB2_CLIENT_GUID_SIZE);
-#endif
 	/*
 	 * at this point we are the only ones with the pointer
 	 * to the struct since the kernel thread not created yet
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 42ebc1a..694638c 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -360,12 +360,8 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 
 	req->Capabilities = cpu_to_le32(ses->server->vals->req_capabilities);
 
-	/* ClientGUID must be zero for SMB2.02 dialect */
-	if (ses->server->vals->protocol_id == SMB20_PROT_ID)
-		memset(req->ClientGUID, 0, SMB2_CLIENT_GUID_SIZE);
-	else
-		memcpy(req->ClientGUID, server->client_guid,
-			SMB2_CLIENT_GUID_SIZE);
+	memcpy(req->ClientGUID, &server->vals->client_guid,
+						SMB2_CLIENT_GUID_SIZE);
 
 	iov[0].iov_base = (char *)req;
 	/* 4 for rfc1002 length field */
@@ -468,7 +464,7 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 
 	vneg_inbuf.Capabilities =
 			cpu_to_le32(tcon->ses->server->vals->req_capabilities);
-	memcpy(vneg_inbuf.Guid, tcon->ses->server->client_guid,
+	memcpy(vneg_inbuf.Guid, &tcon->ses->server->vals->client_guid,
 					SMB2_CLIENT_GUID_SIZE);
 
 	if (tcon->ses->sign)
-- 
1.9.3
