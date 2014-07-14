From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 1/7] CIFS: Indicate reconnect with ECONNABORTED error code
Date: Mon, 14 Jul 2014 13:01:11 +0400
Message-ID: <1405328477-13484-2-git-send-email-pshilovsky@samba.org>
References: <1405328477-13484-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405328477-13484-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

that let us not mix it with EAGAIN.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/connect.c | 8 ++++----
 fs/cifs/file.c    | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 20d75b8..b0427f6 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -557,7 +557,7 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
 		try_to_freeze();
 
 		if (server_unresponsive(server)) {
-			total_read = -EAGAIN;
+			total_read = -ECONNABORTED;
 			break;
 		}
 
@@ -571,7 +571,7 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
 			break;
 		} else if (server->tcpStatus == CifsNeedReconnect) {
 			cifs_reconnect(server);
-			total_read = -EAGAIN;
+			total_read = -ECONNABORTED;
 			break;
 		} else if (length == -ERESTARTSYS ||
 			   length == -EAGAIN ||
@@ -588,7 +588,7 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
 			cifs_dbg(FYI, "Received no data or error: expecting %d\n"
 				 "got %d", to_read, length);
 			cifs_reconnect(server);
-			total_read = -EAGAIN;
+			total_read = -ECONNABORTED;
 			break;
 		}
 	}
@@ -786,7 +786,7 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		cifs_dbg(VFS, "SMB response too long (%u bytes)\n", pdu_length);
 		cifs_reconnect(server);
 		wake_up(&server->response_q);
-		return -EAGAIN;
+		return -ECONNABORTED;
 	}
 
 	/* switch to large buffer if too big for a small one */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index d5f66ba..0974dd2 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2908,7 +2908,7 @@ cifs_uncached_read_into_pages(struct TCP_Server_Info *server,
 		total_read += result;
 	}
 
-	return total_read > 0 && result != -EAGAIN ? total_read : result;
+	return total_read > 0 && result != -ECONNABORTED ? total_read : result;
 }
 
 static int
@@ -3358,7 +3358,7 @@ cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
 		total_read += result;
 	}
 
-	return total_read > 0 && result != -EAGAIN ? total_read : result;
+	return total_read > 0 && result != -ECONNABORTED ? total_read : result;
 }
 
 static int
-- 
1.8.1.2
