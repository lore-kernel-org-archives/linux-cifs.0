From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] cifs: writing past end of struct in cifs_convert_address()
Date: Thu, 1 Mar 2012 10:06:52 +0300
Message-ID: <20120301070652.GA6959@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs@vger.kernel.org, kernel-janitors@vger.kernel.org,
	samba-technical@lists.samba.org
To: Steve French <sfrench@samba.org>, Jeff Layton <jlayton@redhat.com>
Return-path: <samba-technical-bounces@lists.samba.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

"s6->sin6_scope_id" is an int bits but strict_strtoul() writes a long
so this can corrupt memory on 64 bit systems.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 73e47e8..cab99b5 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -197,8 +197,7 @@ cifs_convert_address(struct sockaddr *dst, const char *src, int len)
 		memcpy(scope_id, pct + 1, slen);
 		scope_id[slen] = '\0';
 
-		rc = strict_strtoul(scope_id, 0,
-					(unsigned long *)&s6->sin6_scope_id);
+		rc = kstrtouint(scope_id, 0, &s6->sin6_scope_id);
 		rc = (rc == 0) ? 1 : 0;
 	}
 
