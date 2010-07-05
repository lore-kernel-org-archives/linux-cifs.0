From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 04/09] cifs: define superblock-level cache index objects and register them
Date: Mon,  5 Jul 2010 18:12:27 +0530
Message-ID: <1278333747-30651-1-git-send-email-sjayaraman@suse.de>
References: <Yes>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cachefs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Yes>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Define superblock-level cache index objects (managed by cifsTconInfo structs).
Each superblock object is created in a server-level index object and in itself
an index into which inode-level objects are inserted.

The superblock object is keyed by sharename. The UniqueId/IndexNumber is used to
validate that the exported share is the same since we accessed it last time.

Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/cache.c    |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsglob.h |    4 +
 fs/cifs/connect.c  |    3 +
 fs/cifs/fscache.c  |   17 ++++++++
 fs/cifs/fscache.h  |    6 ++
 fs/cifs/inode.c    |    3 +
 6 files changed, 142 insertions(+)

Index: cifs-2.6/fs/cifs/cache.c
===================================================================
--- cifs-2.6.orig/fs/cifs/cache.c
+++ cifs-2.6/fs/cifs/cache.c
@@ -106,3 +106,112 @@ const struct fscache_cookie_def cifs_fsc
 	.type = FSCACHE_COOKIE_TYPE_INDEX,
 	.get_key = cifs_server_get_key,
 };
+
+/*
+ * Auxiliary data attached to CIFS superblock within the cache
+ */
+struct cifs_fscache_super_auxdata {
+	u64	resource_id;		/* unique server resource id */
+};
+
+static char *extract_sharename(const char *treename)
+{
+	const char *src;
+	char *delim, *dst;
+	int len;
+
+	/* skip double chars at the beginning */
+	src = treename + 2;
+
+	/* share name is always preceded by '\\' now */
+	delim = strchr(src, '\\');
+	if (!delim)
+		return ERR_PTR(-EINVAL);
+	delim++;
+	len = strlen(delim);
+
+	/* caller has to free the memory */
+	dst = kstrndup(delim, len, GFP_KERNEL);
+	if (!dst)
+		return ERR_PTR(-ENOMEM);
+
+	return dst;
+}
+
+/*
+ * Superblock object currently keyed by share name
+ */
+static uint16_t cifs_super_get_key(const void *cookie_netfs_data, void *buffer,
+				   uint16_t maxbuf)
+{
+	const struct cifsTconInfo *tcon = cookie_netfs_data;
+	char *sharename;
+	uint16_t len;
+
+	sharename = extract_sharename(tcon->treeName);
+	if (IS_ERR(sharename)) {
+		cFYI(1, "CIFS: couldn't extract sharename\n");
+		sharename = NULL;
+		return 0;
+	}
+
+	len = strlen(sharename);
+	if (len > maxbuf)
+		return 0;
+
+	memcpy(buffer, sharename, len);
+
+	kfree(sharename);
+
+	return len;
+}
+
+static uint16_t
+cifs_fscache_super_get_aux(const void *cookie_netfs_data, void *buffer,
+			   uint16_t maxbuf)
+{
+	struct cifs_fscache_super_auxdata auxdata;
+	const struct cifsTconInfo *tcon = cookie_netfs_data;
+
+	memset(&auxdata, 0, sizeof(auxdata));
+	auxdata.resource_id = tcon->resource_id;
+
+	if (maxbuf > sizeof(auxdata))
+		maxbuf = sizeof(auxdata);
+
+	memcpy(buffer, &auxdata, maxbuf);
+
+	return maxbuf;
+}
+
+static enum
+fscache_checkaux cifs_fscache_super_check_aux(void *cookie_netfs_data,
+					      const void *data,
+					      uint16_t datalen)
+{
+	struct cifs_fscache_super_auxdata auxdata;
+	const struct cifsTconInfo *tcon = cookie_netfs_data;
+
+	if (datalen != sizeof(auxdata))
+		return FSCACHE_CHECKAUX_OBSOLETE;
+
+	memset(&auxdata, 0, sizeof(auxdata));
+	auxdata.resource_id = tcon->resource_id;
+
+	if (memcmp(data, &auxdata, datalen) != 0)
+		return FSCACHE_CHECKAUX_OBSOLETE;
+
+	return FSCACHE_CHECKAUX_OKAY;
+}
+
+/*
+ * Superblock object for FS-Cache
+ */
+const struct fscache_cookie_def cifs_fscache_super_index_def = {
+	.name = "CIFS.super",
+	.type = FSCACHE_COOKIE_TYPE_INDEX,
+	.get_key = cifs_super_get_key,
+	.get_aux = cifs_fscache_super_get_aux,
+	.check_aux = cifs_fscache_super_check_aux,
+};
+
Index: cifs-2.6/fs/cifs/fscache.c
===================================================================
--- cifs-2.6.orig/fs/cifs/fscache.c
+++ cifs-2.6/fs/cifs/fscache.c
@@ -39,3 +39,20 @@ void cifs_fscache_release_client_cookie(
 	server->fscache = NULL;
 }
 
+void cifs_fscache_get_super_cookie(struct cifsTconInfo *tcon)
+{
+	struct TCP_Server_Info *server = tcon->ses->server;
+
+	tcon->fscache =
+		fscache_acquire_cookie(server->fscache,
+				&cifs_fscache_super_index_def, tcon);
+	cFYI(1, "CIFS: get superblock cookie (0x%p/0x%p)",
+				server->fscache, tcon->fscache);
+}
+
+void cifs_fscache_release_super_cookie(struct cifsTconInfo *tcon)
+{
+	cFYI(1, "CIFS: releasing superblock cookie (0x%p)", tcon->fscache);
+	fscache_relinquish_cookie(tcon->fscache, 0);
+	tcon->fscache = NULL;
+}
Index: cifs-2.6/fs/cifs/fscache.h
===================================================================
--- cifs-2.6.orig/fs/cifs/fscache.h
+++ cifs-2.6/fs/cifs/fscache.h
@@ -29,6 +29,7 @@
 
 extern struct fscache_netfs cifs_fscache_netfs;
 extern const struct fscache_cookie_def cifs_fscache_server_index_def;
+extern const struct fscache_cookie_def cifs_fscache_super_index_def;
 
 extern int cifs_fscache_register(void);
 extern void cifs_fscache_unregister(void);
@@ -38,6 +39,8 @@ extern void cifs_fscache_unregister(void
  */
 extern void cifs_fscache_get_client_cookie(struct TCP_Server_Info *);
 extern void cifs_fscache_release_client_cookie(struct TCP_Server_Info *);
+extern void cifs_fscache_get_super_cookie(struct cifsTconInfo *);
+extern void cifs_fscache_release_super_cookie(struct cifsTconInfo *);
 
 #else /* CONFIG_CIFS_FSCACHE */
 static inline int cifs_fscache_register(void) { return 0; }
@@ -47,6 +50,9 @@ static inline void
 cifs_fscache_get_client_cookie(struct TCP_Server_Info *server) {}
 static inline void
 cifs_fscache_get_client_cookie(struct TCP_Server_Info *server); {}
+static inline void cifs_fscache_get_super_cookie(struct cifsTconInfo *tcon) {}
+static inline void
+cifs_fscache_release_super_cookie(struct cifsTconInfo *tcon) {}
 
 #endif /* CONFIG_CIFS_FSCACHE */
 
Index: cifs-2.6/fs/cifs/cifsglob.h
===================================================================
--- cifs-2.6.orig/fs/cifs/cifsglob.h
+++ cifs-2.6/fs/cifs/cifsglob.h
@@ -314,6 +314,10 @@ struct cifsTconInfo {
 	bool local_lease:1; /* check leases (only) on local system not remote */
 	bool broken_posix_open; /* e.g. Samba server versions < 3.3.2, 3.2.9 */
 	bool need_reconnect:1; /* connection reset, tid now invalid */
+#ifdef CONFIG_CIFS_FSCACHE
+	u64 resource_id;		/* server resource id */
+	struct fscache_cookie *fscache;	/* cookie for share */
+#endif
 	/* BB add field for back pointer to sb struct(s)? */
 };
 
Index: cifs-2.6/fs/cifs/connect.c
===================================================================
--- cifs-2.6.orig/fs/cifs/connect.c
+++ cifs-2.6/fs/cifs/connect.c
@@ -1779,6 +1779,7 @@ cifs_put_tcon(struct cifsTconInfo *tcon)
 	_FreeXid(xid);
 
 	tconInfoFree(tcon);
+	cifs_fscache_release_super_cookie(tcon);
 	cifs_put_smb_ses(ses);
 }
 
@@ -1848,6 +1849,8 @@ cifs_get_tcon(struct cifsSesInfo *ses, s
 	list_add(&tcon->tcon_list, &ses->tcon_list);
 	write_unlock(&cifs_tcp_ses_lock);
 
+	cifs_fscache_get_super_cookie(tcon);
+
 	return tcon;
 
 out_fail:
Index: cifs-2.6/fs/cifs/inode.c
===================================================================
--- cifs-2.6.orig/fs/cifs/inode.c
+++ cifs-2.6/fs/cifs/inode.c
@@ -807,6 +807,9 @@ struct inode *cifs_root_iget(struct supe
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
+	/* populate tcon->resource_id */
+	cifs_sb->tcon->resource_id = CIFS_I(inode)->uniqueid;
+
 	if (rc && cifs_sb->tcon->ipc) {
 		cFYI(1, "ipc connection - fake read inode");
 		inode->i_mode |= S_IFDIR;
