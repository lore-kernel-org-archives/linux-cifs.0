From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] DNS: Make AFS go to the DNS for AFSDB records for unknown
	cells
Date: Wed, 04 Aug 2010 15:16:38 +0100
Message-ID: <20100804141638.23934.25649.stgit@warthog.procyon.org.uk>
References: <20100804141633.23934.15025.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: jlayton@redhat.com, linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
	linux-kernel@vger.kernel.org, Wang Lei <wang840925@gmail.com>,
	David Howells <dhowells@redhat.com>
To: smfrench@gmail.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100804141633.23934.15025.stgit@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Wang Lei <wang840925@gmail.com>

Add DNS query support for AFS so that it can get the IP addresses of Volume
Location servers from the DNS using an AFSDB record.

This requires userspace support.  /etc/request-key.conf must be configured to
invoke a helper for dns_resolver type keys with a subtype of "afsdb:" in the
description.

Signed-off-by: Wang Lei <wang840925@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/afs/Kconfig |    1 +
 fs/afs/cell.c  |   40 ++++++++++++++++++++++++++++++----------
 2 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/fs/afs/Kconfig b/fs/afs/Kconfig
index 5c4e61d..8f975f2 100644
--- a/fs/afs/Kconfig
+++ b/fs/afs/Kconfig
@@ -2,6 +2,7 @@ config AFS_FS
 	tristate "Andrew File System support (AFS) (EXPERIMENTAL)"
 	depends on INET && EXPERIMENTAL
 	select AF_RXRPC
+	select DNS_RESOLVER
 	help
 	  If you say Y here, you will get an experimental Andrew File System
 	  driver. It currently only supports unsecured read-only AFS access.
diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index e19c13f..ffea35c 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/key.h>
 #include <linux/ctype.h>
+#include <linux/dns_resolver.h>
 #include <linux/sched.h>
 #include <keys/rxrpc-type.h>
 #include "internal.h"
@@ -36,6 +37,8 @@ static struct afs_cell *afs_cell_alloc(const char *name, char *vllist)
 	struct key *key;
 	size_t namelen;
 	char keyname[4 + AFS_MAXCELLNAME + 1], *cp, *dp, *next;
+	char  *dvllist = NULL, *_vllist = NULL;
+	char  delimiter = ':';
 	int ret;
 
 	_enter("%s,%s", name, vllist);
@@ -43,8 +46,10 @@ static struct afs_cell *afs_cell_alloc(const char *name, char *vllist)
 	BUG_ON(!name); /* TODO: want to look up "this cell" in the cache */
 
 	namelen = strlen(name);
-	if (namelen > AFS_MAXCELLNAME)
+	if (namelen > AFS_MAXCELLNAME) {
+		_leave(" = -ENAMETOOLONG");
 		return ERR_PTR(-ENAMETOOLONG);
+	}
 
 	/* allocate and initialise a cell record */
 	cell = kzalloc(sizeof(struct afs_cell) + namelen + 1, GFP_KERNEL);
@@ -64,15 +69,31 @@ static struct afs_cell *afs_cell_alloc(const char *name, char *vllist)
 	INIT_LIST_HEAD(&cell->vl_list);
 	spin_lock_init(&cell->vl_lock);
 
+	/* if the ip address is invalid, try dns query */
+	if (!vllist || strlen(vllist) < 7) {
+		ret = dns_query("afsdb", name, namelen, "ipv4", &dvllist, NULL);
+		if (ret < 0) {
+			_leave(" = %d", ret);
+			return ERR_PTR(ret);
+		}
+		_vllist = dvllist;
+
+		/* change the delimiter for user-space reply */
+		delimiter = ',';
+
+	} else {
+		_vllist = vllist;
+	}
+
 	/* fill in the VL server list from the rest of the string */
 	do {
 		unsigned a, b, c, d;
 
-		next = strchr(vllist, ':');
+		next = strchr(_vllist, delimiter);
 		if (next)
 			*next++ = 0;
 
-		if (sscanf(vllist, "%u.%u.%u.%u", &a, &b, &c, &d) != 4)
+		if (sscanf(_vllist, "%u.%u.%u.%u", &a, &b, &c, &d) != 4)
 			goto bad_address;
 
 		if (a > 255 || b > 255 || c > 255 || d > 255)
@@ -81,7 +102,7 @@ static struct afs_cell *afs_cell_alloc(const char *name, char *vllist)
 		cell->vl_addrs[cell->vl_naddrs++].s_addr =
 			htonl((a << 24) | (b << 16) | (c << 8) | d);
 
-	} while (cell->vl_naddrs < AFS_CELL_MAX_ADDRS && (vllist = next));
+	} while (cell->vl_naddrs < AFS_CELL_MAX_ADDRS && (_vllist = next));
 
 	/* create a key to represent an anonymous user */
 	memcpy(keyname, "afs@", 4);
@@ -110,6 +131,7 @@ bad_address:
 	ret = -EINVAL;
 error:
 	key_put(cell->anonymous_key);
+	kfree(dvllist);
 	kfree(cell);
 	_leave(" = %d", ret);
 	return ERR_PTR(ret);
@@ -201,14 +223,12 @@ int afs_cell_init(char *rootcell)
 	}
 
 	cp = strchr(rootcell, ':');
-	if (!cp) {
-		printk(KERN_ERR "kAFS: no VL server IP addresses specified\n");
-		_leave(" = -EINVAL");
-		return -EINVAL;
-	}
+	if (!cp)
+		_debug("kAFS: no VL server IP addresses specified");
+	else
+		*cp++ = 0;
 
 	/* allocate a cell record for the root cell */
-	*cp++ = 0;
 	new_root = afs_cell_create(rootcell, cp);
 	if (IS_ERR(new_root)) {
 		_leave(" = %ld", PTR_ERR(new_root));

