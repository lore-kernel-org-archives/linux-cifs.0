From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [Patch v8 05/16] CIFS: SMBD: Upper layer destroys SMB Direct session on shutdown or umount
Date: Wed, 22 Nov 2017 17:38:38 -0700
Message-ID: <20171123003849.17093-6-longli@exchange.microsoft.com>
References: <20171123003849.17093-1-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Stephen Hemminger <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171123003849.17093-1-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

When upper layer wants to umount, make it call shutdown on transport when
SMB Direct is used.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/connect.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index fc46066..d8bfa89 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -704,7 +704,10 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 	wake_up_all(&server->request_q);
 	/* give those requests time to exit */
 	msleep(125);
-
+	if (cifs_rdma_enabled(server) && server->smbd_conn) {
+		smbd_destroy(server->smbd_conn);
+		server->smbd_conn = NULL;
+	}
 	if (server->ssocket) {
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
