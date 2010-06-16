From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH] cifs: remove bogus first_time check in
	NTLMv2 session setup code
Date: Wed, 16 Jun 2010 09:38:13 -0400
Message-ID: <1276695493-6340-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-client@lists.samba.org, gdeschner@redhat.com,
	linux-cifs@vger.kernel.org
To: smfrench@gmail.com
Return-path: <linux-cifs-client-bounces@lists.samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/linux-cifs-client>,
	<mailto:linux-cifs-client-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/linux-cifs-client>
List-Post: <mailto:linux-cifs-client@lists.samba.org>
List-Help: <mailto:linux-cifs-client-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/linux-cifs-client>,
	<mailto:linux-cifs-client-request@lists.samba.org?subject=subscribe>
Sender: linux-cifs-client-bounces@lists.samba.org
Errors-To: linux-cifs-client-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

This bug appears to be the result of a cut-and-paste mistake from the
NTLMv1 code. The function to generate the MAC key was commented out, but
not the conditional above it. The conditional then ended up causing the
session setup key not to be copied to the buffer unless this was the
first session on the socket, and that made all but the first NTLMv2
session setup fail.

Fix this by removing the conditional and all of the commented clutter
that made it difficult to see.

Cc: Stable <stable@kernel.org>
Reported-by: Gunther Deschner <gdeschne@redhat.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/sess.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 7707389..0a57cb7 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -730,15 +730,7 @@ ssetup_ntlmssp_authenticate:
 
 		/* calculate session key */
 		setup_ntlmv2_rsp(ses, v2_sess_key, nls_cp);
-		if (first_time) /* should this be moved into common code
-				   with similar ntlmv2 path? */
-		/*   cifs_calculate_ntlmv2_mac_key(ses->server->mac_signing_key,
-				response BB FIXME, v2_sess_key); */
-
-		/* copy session key */
-
-	/*	memcpy(bcc_ptr, (char *)ntlm_session_key,LM2_SESS_KEY_SIZE);
-		bcc_ptr += LM2_SESS_KEY_SIZE; */
+		/* FIXME: calculate MAC key */
 		memcpy(bcc_ptr, (char *)v2_sess_key,
 		       sizeof(struct ntlmv2_resp));
 		bcc_ptr += sizeof(struct ntlmv2_resp);
-- 
1.6.6.1
