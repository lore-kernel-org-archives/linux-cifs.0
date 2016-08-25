From: Jeff Layton <jlayton@samba.org>
Subject: [cifs-utils PATCHv2 5/6] cifs.upcall: make get_tgt_time take a ccache
 arg
Date: Thu, 25 Aug 2016 10:17:44 -0400
Message-ID: <1472134665-4014-6-git-send-email-jlayton@samba.org>
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

...instead of dealing with the ccname. Push resolution of the cache
into the caller.

Signed-off-by: Jeff Layton <jlayton@samba.org>
---
 cifs.upcall.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index a25833592440..a20576654a95 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -102,20 +102,14 @@ krb5_auth_con_getsendsubkey(krb5_context context,
 #endif
 
 /* does the ccache have a valid TGT? */
-static time_t get_tgt_time(const char *ccname)
+static time_t get_tgt_time(krb5_ccache ccache)
 {
-	krb5_ccache ccache;
 	krb5_cc_cursor cur;
 	krb5_creds creds;
 	krb5_principal principal;
 	time_t credtime = 0;
 	char *realm = NULL;
 
-	if (krb5_cc_resolve(context, ccname, &ccache)) {
-		syslog(LOG_DEBUG, "%s: unable to resolve krb5 cache", __func__);
-		goto err_cache;
-	}
-
 	if (krb5_cc_set_flags(context, ccache, 0)) {
 		syslog(LOG_DEBUG, "%s: unable to set flags", __func__);
 		goto err_cache;
@@ -156,8 +150,6 @@ err_endseq:
 	krb5_cc_end_seq_get(context, ccache, &cur);
 err_ccstart:
 	krb5_free_principal(context, principal);
-err_princ:
-	krb5_cc_close(context, ccache);
 err_cache:
 	return credtime;
 }
@@ -167,15 +159,22 @@ get_default_cc(void)
 {
 	const char *ccname;
 	char *rcc = NULL;
+	krb5_ccache ccache;
 
 	ccname = krb5_cc_default_name(context);
 	if (!ccname) {
-		syslog(LOG_DEBUG, "krb5_cc_default returned NULL.");
+		syslog(LOG_DEBUG, "%s: krb5_cc_default returned NULL.", __func__);
 		return NULL;
 	}
 
-	if (get_tgt_time(ccname))
+	if (krb5_cc_resolve(context, ccname, &ccache)) {
+		syslog(LOG_DEBUG, "%s: unable to resolve krb5 cache", __func__);
+		return NULL;
+	}
+
+	if (get_tgt_time(ccache))
 		rcc = strdup(ccname);
+	krb5_cc_close(context, ccache);
 	return rcc;
 }
 
-- 
2.7.4
