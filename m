From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 6/6] getcifsacl: ensure that we don't overrun the wbcDomainSid when converting
Date: Tue,  4 Dec 2012 10:16:44 -0500
Message-ID: <1354634204-21602-7-git-send-email-jlayton@samba.org>
References: <1354634204-21602-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1354634204-21602-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If we get a SID that contains more than 15 subauthorities, we'll end up
overrunning the struct wbcDomainSid. Just ignore any past 15.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 getcifsacl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/getcifsacl.c b/getcifsacl.c
index 256b2ad..3f94a99 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -180,12 +180,14 @@ static void
 csid_to_wsid(struct wbcDomainSid *wsid, const struct cifs_sid *csid)
 {
 	int i;
+	uint8_t num_subauth = (csid->num_subauth <= WBC_MAXSUBAUTHS) ?
+				csid->num_subauth : WBC_MAXSUBAUTHS;
 
 	wsid->sid_rev_num = csid->revision;
-	wsid->num_auths = csid->num_subauth;
+	wsid->num_auths = num_subauth;
 	for (i = 0; i < NUM_AUTHS; i++)
 		wsid->id_auth[i] = csid->authority[i];
-	for (i = 0; i < csid->num_subauth; i++)
+	for (i = 0; i < num_subauth; i++)
 		wsid->sub_auths[i] = le32toh(csid->sub_auth[i]);
 }
 
-- 
1.7.11.7
