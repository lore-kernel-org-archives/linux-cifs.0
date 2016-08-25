From: Jeff Layton <jlayton@samba.org>
Subject: [cifs-utils PATCHv2 4/6] cifs.upcall: remove KRB5_TC_OPENCLOSE
Date: Thu, 25 Aug 2016 10:17:43 -0400
Message-ID: <1472134665-4014-5-git-send-email-jlayton@samba.org>
References: <1472134665-4014-1-git-send-email-jlayton@samba.org>
Cc: jfdey@fredhutch.org, samba-technical@lists.samba.org
To: linux-cifs@vger.kernel.org
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1472134665-4014-1-git-send-email-jlayton@samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical/>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Errors-To: samba-technical-bounces@lists.samba.org
Sender: "samba-technical" <samba-technical-bounces@lists.samba.org>
List-Id: linux-cifs.vger.kernel.org

The header file says that this is deprecated, and all of the info I've
seen about it mentioned that it was for performance more than
correctness. It dates back to the original code dump from Igor, so I
think we're safe to just drop it at this point.

Signed-off-by: Jeff Layton <jlayton@samba.org>
---
 cifs.upcall.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 8448d00f6061..a25833592440 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -157,9 +157,6 @@ err_endseq:
 err_ccstart:
 	krb5_free_principal(context, principal);
 err_princ:
-#if defined(KRB5_TC_OPENCLOSE)
-	krb5_cc_set_flags(context, ccache, KRB5_TC_OPENCLOSE);
-#endif
 	krb5_cc_close(context, ccache);
 err_cache:
 	return credtime;
@@ -388,9 +385,6 @@ out_free_creds:
 out_free_principal:
 	krb5_free_principal(context, in_creds.client);
 out_free_ccache:
-#if defined(KRB5_TC_OPENCLOSE)
-	krb5_cc_set_flags(context, ccache, KRB5_TC_OPENCLOSE);
-#endif
 	krb5_cc_close(context, ccache);
 	return ret;
 }
-- 
2.7.4
