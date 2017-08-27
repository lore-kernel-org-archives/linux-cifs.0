From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: setcifsacl - Send the actual (security descriptor) buffer size instead of the pre-allocated size
Date: Sat, 26 Aug 2017 22:23:29 -0500
Message-ID: <1503804209-5419-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Instead of sending allocated buffer size of a security descriptor,
send the actual size of the security descriptor during set cifs acl
operation.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Tested-by: Paul van Schayck <polleke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 setcifsacl.c | 58 +++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 21 deletions(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index 7eeeaa6..0d4b15f 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -50,24 +50,33 @@ enum setcifsacl_actions {
 static void *plugin_handle;
 static bool plugin_loaded;
 
-static void
+static int
 copy_cifs_sid(struct cifs_sid *dst, const struct cifs_sid *src)
 {
-	int i;
+	int i, size = 0;
 
 	dst->revision = src->revision;
+	size += sizeof(uint8_t);
+
 	dst->num_subauth = src->num_subauth;
+	size += sizeof(uint8_t);
+
 	for (i = 0; i < NUM_AUTHS; i++)
 		dst->authority[i] = src->authority[i];
+	size += (sizeof(uint8_t) * NUM_AUTHS);
+
 	for (i = 0; i < src->num_subauth; i++)
 		dst->sub_auth[i] = src->sub_auth[i];
+	size += (sizeof(uint32_t) * src->num_subauth);
+
+	return size;
 }
 
 static void
 copy_sec_desc(const struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
-		int numaces, int acessize)
+		int numaces, int acessize, ssize_t *bufsize)
 {
-	int osidsoffset, gsidsoffset, dacloffset;
+	int size, osidsoffset, gsidsoffset, dacloffset;
 	struct cifs_sid *owner_sid_ptr, *group_sid_ptr;
 	struct cifs_sid *nowner_sid_ptr, *ngroup_sid_ptr;
 	struct cifs_ctrl_acl *dacl_ptr, *ndacl_ptr;
@@ -77,28 +86,34 @@ copy_sec_desc(const struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 	gsidsoffset = le32toh(pntsd->gsidoffset);
 	dacloffset = le32toh(pntsd->dacloffset);
 
+	size = sizeof(struct cifs_ntsd);
 	pnntsd->revision = pntsd->revision;
 	pnntsd->type = pntsd->type;
 	pnntsd->osidoffset = pntsd->osidoffset;
 	pnntsd->gsidoffset = pntsd->gsidoffset;
 	pnntsd->dacloffset = pntsd->dacloffset;
+	*bufsize = *bufsize + size;
 
 	dacl_ptr = (struct cifs_ctrl_acl *)((char *)pntsd + dacloffset);
 	ndacl_ptr = (struct cifs_ctrl_acl *)((char *)pnntsd + dacloffset);
 
+	size = acessize + sizeof(struct cifs_ctrl_acl);
 	ndacl_ptr->revision = dacl_ptr->revision;
-	ndacl_ptr->size = htole16(acessize + sizeof(struct cifs_ctrl_acl));
+	ndacl_ptr->size = htole16(size);
 	ndacl_ptr->num_aces = htole32(numaces);
+	*bufsize = *bufsize + size;
 
 	/* copy owner sid */
 	owner_sid_ptr = (struct cifs_sid *)((char *)pntsd + osidsoffset);
 	nowner_sid_ptr = (struct cifs_sid *)((char *)pnntsd + osidsoffset);
-	copy_cifs_sid(nowner_sid_ptr, owner_sid_ptr);
+	size = copy_cifs_sid(nowner_sid_ptr, owner_sid_ptr);
+	*bufsize = *bufsize + size;
 
 	/* copy group sid */
 	group_sid_ptr = (struct cifs_sid *)((char *)pntsd + gsidsoffset);
 	ngroup_sid_ptr = (struct cifs_sid *)((char *)pnntsd + gsidsoffset);
-	copy_cifs_sid(ngroup_sid_ptr, group_sid_ptr);
+	size = copy_cifs_sid(ngroup_sid_ptr, group_sid_ptr);
+	*bufsize = *bufsize + size;
 
 	return;
 }
@@ -156,10 +171,10 @@ compare_aces(struct cifs_ace *sace, struct cifs_ace *dace, int compflags)
 }
 
 static int
-get_sec_desc_size(struct cifs_ntsd *pntsd, struct cifs_ntsd **npntsd,
-			int aces, ssize_t *bufsize, size_t *acesoffset)
+alloc_sec_desc(struct cifs_ntsd *pntsd, struct cifs_ntsd **npntsd,
+			int aces, size_t *acesoffset)
 {
-	unsigned int size, acessize, dacloffset;
+	unsigned int size, acessize, bufsize, dacloffset;
 
 	size = sizeof(struct cifs_ntsd) +
 		2 * sizeof(struct cifs_sid) +
@@ -169,9 +184,9 @@ get_sec_desc_size(struct cifs_ntsd *pntsd, struct cifs_ntsd **npntsd,
 
 	*acesoffset = dacloffset + sizeof(struct cifs_ctrl_acl);
 	acessize = aces * sizeof(struct cifs_ace);
-	*bufsize = size + acessize;
+	bufsize = size + acessize;
 
-	*npntsd = malloc(*bufsize);
+	*npntsd = malloc(bufsize);
 	if (!*npntsd) {
 		printf("%s: Memory allocation failure", __func__);
 		return errno;
@@ -188,7 +203,7 @@ ace_set(struct cifs_ntsd *pntsd, struct cifs_ntsd **npntsd, ssize_t *bufsize,
 	size_t acesoffset;
 	char *acesptr;
 
-	rc = get_sec_desc_size(pntsd, npntsd, numcaces, bufsize, &acesoffset);
+	rc = alloc_sec_desc(pntsd, npntsd, numcaces, &acesoffset);
 	if (rc)
 		return rc;
 
@@ -198,9 +213,8 @@ ace_set(struct cifs_ntsd *pntsd, struct cifs_ntsd **npntsd, ssize_t *bufsize,
 		acessize += size;
 		acesptr += size;
 	}
-	copy_sec_desc(pntsd, *npntsd, numcaces, acessize);
-	acesptr = (char *)*npntsd + acesoffset;
 
+	copy_sec_desc(pntsd, *npntsd, numcaces, acessize, bufsize);
 
 	return 0;
 }
@@ -215,7 +229,7 @@ ace_add(struct cifs_ntsd *pntsd, struct cifs_ntsd **npntsd, ssize_t *bufsize,
 	char *acesptr;
 
 	numaces = numfaces + numcaces;
-	rc = get_sec_desc_size(pntsd, npntsd, numaces, bufsize, &acesoffset);
+	rc = alloc_sec_desc(pntsd, npntsd, numaces, &acesoffset);
 	if (rc)
 		return rc;
 
@@ -230,7 +244,8 @@ ace_add(struct cifs_ntsd *pntsd, struct cifs_ntsd **npntsd, ssize_t *bufsize,
 		acesptr += size;
 		acessize += size;
 	}
-	copy_sec_desc(pntsd, *npntsd, numaces, acessize);
+
+	copy_sec_desc(pntsd, *npntsd, numaces, acessize, bufsize);
 
 	return 0;
 }
@@ -249,7 +264,7 @@ ace_modify(struct cifs_ntsd *pntsd, struct cifs_ntsd **npntsd, ssize_t *bufsize,
 		return -1;
 	}
 
-	rc = get_sec_desc_size(pntsd, npntsd, numfaces, bufsize, &acesoffset);
+	rc = alloc_sec_desc(pntsd, npntsd, numfaces, &acesoffset);
 	if (rc)
 		return rc;
 
@@ -270,7 +285,7 @@ ace_modify(struct cifs_ntsd *pntsd, struct cifs_ntsd **npntsd, ssize_t *bufsize,
 		acessize += size;
 	}
 
-	copy_sec_desc(pntsd, *npntsd, numfaces, acessize);
+	copy_sec_desc(pntsd, *npntsd, numfaces, acessize, bufsize);
 
 	return 0;
 }
@@ -294,7 +309,7 @@ ace_delete(struct cifs_ntsd *pntsd, struct cifs_ntsd **npntsd, ssize_t *bufsize,
 		return -1;
 	}
 
-	rc = get_sec_desc_size(pntsd, npntsd, numfaces, bufsize, &acesoffset);
+	rc = alloc_sec_desc(pntsd, npntsd, numfaces, &acesoffset);
 	if (rc)
 		return rc;
 
@@ -317,7 +332,8 @@ ace_delete(struct cifs_ntsd *pntsd, struct cifs_ntsd **npntsd, ssize_t *bufsize,
 		printf("%s: Nothing to delete\n", __func__);
 		return 1;
 	}
-	copy_sec_desc(pntsd, *npntsd, numaces, acessize);
+
+	copy_sec_desc(pntsd, *npntsd, numaces, acessize, bufsize);
 
 	return 0;
 }
-- 
1.9.1
