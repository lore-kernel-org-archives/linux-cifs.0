From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: remove unused ip_address field in struct TCP_Server_Info
Date: Tue,  6 Jul 2010 18:03:10 +0530
Message-ID: <1278419590-8307-1-git-send-email-sjayaraman@suse.de>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The ip_address field is not used and seems redundant as there is union addr
already and I don't see any future use as well.

Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/cifsglob.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a88479c..f182fe8 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -142,7 +142,6 @@ struct TCP_Server_Info {
 	struct list_head pending_mid_q;
 	void *Server_NlsInfo;	/* BB - placeholder for future NLS info  */
 	unsigned short server_codepage;	/* codepage for the server    */
-	unsigned long ip_address;	/* IP addr for the server if known */
 	enum protocolEnum protocolType;
 	char versionMajor;
 	char versionMinor;
