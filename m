From: Jeff Layton <jlayton@samba.org>
Subject: [cifs-utils PATCHv2 1/6] aclocal: fix typo in idmap.m4
Date: Thu, 25 Aug 2016 10:17:40 -0400
Message-ID: <1472134665-4014-2-git-send-email-jlayton@samba.org>
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

We really don't want to do the same check twice.

Signed-off-by: Jeff Layton <jlayton@samba.org>
---
 aclocal/idmap.m4 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/aclocal/idmap.m4 b/aclocal/idmap.m4
index 3ccdae3ab968..4e16a46568a1 100644
--- a/aclocal/idmap.m4
+++ b/aclocal/idmap.m4
@@ -19,7 +19,7 @@ if test $enable_cifsidmap != "no" -o $enable_cifsacl != "no"; then
 			])
 fi
 
-if test $enable_cifsacl != "no" -o $enable_cifsacl != "no"; then
+if test $enable_cifsidmap != "no" -o $enable_cifsacl != "no"; then
 	ac_wbc_save_LDFLAGS="$LDFLAGS"
 	ac_wbc_save_LIBS="$LIBS"
 	LDFLAGS="$LDFLAGS $WBCLIENT_LIBS"
-- 
2.7.4
