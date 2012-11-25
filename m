From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 7/6] cifs: remove unneeded address argument from cifs_find_tcp_session and match_server
Date: Sun, 25 Nov 2012 07:57:31 -0500
Message-ID: <1353848252-2468-1-git-send-email-jlayton@redhat.com>
References: <1353087414-32152-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org,
	almiller_1-/E1597aS9LT10XsdtD+oqA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353087414-32152-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now that the smb_vol contains the destination sockaddr, there's no need
to pass it in separately.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 2602373..60295a4 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2042,9 +2042,10 @@ match_security(struct TCP_Server_Info *server, struct smb_vol *vol)
 	return true;
 }
 
-static int match_server(struct TCP_Server_Info *server, struct sockaddr *addr,
-			 struct smb_vol *vol)
+static int match_server(struct TCP_Server_Info *server, struct smb_vol *vol)
 {
+	struct sockaddr *addr = (struct sockaddr *)&vol->dstaddr;
+
 	if ((server->vals != vol->vals) || (server->ops != vol->ops))
 		return 0;
 
@@ -2065,13 +2066,13 @@ static int match_server(struct TCP_Server_Info *server, struct sockaddr *addr,
 }
 
 static struct TCP_Server_Info *
-cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
+cifs_find_tcp_session(struct smb_vol *vol)
 {
 	struct TCP_Server_Info *server;
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
-		if (!match_server(server, addr, vol))
+		if (!match_server(server, vol))
 			continue;
 
 		++server->srv_count;
@@ -2121,13 +2122,12 @@ static struct TCP_Server_Info *
 cifs_get_tcp_session(struct smb_vol *volume_info)
 {
 	struct TCP_Server_Info *tcp_ses = NULL;
-	struct sockaddr *dstaddr = (struct sockaddr *)&volume_info->dstaddr;
 	int rc;
 
 	cFYI(1, "UNC: %s", volume_info->UNC);
 
 	/* see if we already have a matching tcp_ses */
-	tcp_ses = cifs_find_tcp_session(dstaddr, volume_info);
+	tcp_ses = cifs_find_tcp_session(volume_info);
 	if (tcp_ses)
 		return tcp_ses;
 
@@ -2172,19 +2172,18 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
 	INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
 	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
-
+	memcpy(&tcp_ses->srcaddr, &volume_info->srcaddr,
+	       sizeof(tcp_ses->srcaddr));
+	memcpy(&tcp_ses->dstaddr, &volume_info->dstaddr,
+		sizeof(tcp_ses->dstaddr));
 	/*
 	 * at this point we are the only ones with the pointer
 	 * to the struct since the kernel thread not created yet
 	 * no need to spinlock this init of tcpStatus or srv_count
 	 */
 	tcp_ses->tcpStatus = CifsNew;
-	memcpy(&tcp_ses->srcaddr, &volume_info->srcaddr,
-	       sizeof(tcp_ses->srcaddr));
 	++tcp_ses->srv_count;
 
-	memcpy(&tcp_ses->dstaddr, dstaddr, sizeof(tcp_ses->dstaddr));
-
 	rc = ip_connect(tcp_ses);
 	if (rc < 0) {
 		cERROR(1, "Error connecting to socket. Aborting operation");
@@ -2736,7 +2735,6 @@ cifs_match_super(struct super_block *sb, void *data)
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 	struct tcon_link *tlink;
-	struct sockaddr *dstaddr;
 	int rc = 0;
 
 	spin_lock(&cifs_tcp_ses_lock);
@@ -2751,9 +2749,8 @@ cifs_match_super(struct super_block *sb, void *data)
 	tcp_srv = ses->server;
 
 	volume_info = mnt_data->vol;
-	dstaddr = (struct sockaddr *)&volume_info->dstaddr;
 
-	if (!match_server(tcp_srv, dstaddr, volume_info) ||
+	if (!match_server(tcp_srv, volume_info) ||
 	    !match_session(ses, volume_info) ||
 	    !match_tcon(tcon, volume_info->UNC)) {
 		rc = 0;
-- 
1.7.11.7
