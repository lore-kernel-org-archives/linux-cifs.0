From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 10/17] setcifsacl: fix up endianness conversions
Date: Sat,  3 Nov 2012 08:50:27 -0400
Message-ID: <1351947034-18876-11-git-send-email-jlayton@samba.org>
References: <1351947034-18876-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351947034-18876-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Don't use htole32 when you really want le32toh. Also, when copying or
comparing ACEs, it's incorrect to convert the endianness of these
fields. Let's just keep things simple and declare that multibyte fields
in all of these structs are always kept in little-endian.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 setcifsacl.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index 612796b..4d9787e 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -61,9 +61,9 @@ copy_sec_desc(const struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 	struct cifs_ctrl_acl *dacl_ptr, *ndacl_ptr;
 
 	/* copy security descriptor control portion */
-	osidsoffset = htole32(pntsd->osidoffset);
-	gsidsoffset = htole32(pntsd->gsidoffset);
-	dacloffset = htole32(pntsd->dacloffset);
+	osidsoffset = le32toh(pntsd->osidoffset);
+	gsidsoffset = le32toh(pntsd->gsidoffset);
+	dacloffset = le32toh(pntsd->dacloffset);
 
 	pnntsd->revision = pntsd->revision;
 	pnntsd->type = pntsd->type;
@@ -76,7 +76,7 @@ copy_sec_desc(const struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 
 	ndacl_ptr->revision = dacl_ptr->revision;
 	ndacl_ptr->size = htole16(acessize + sizeof(struct cifs_ctrl_acl));
-	ndacl_ptr->num_aces = htole32(numaces);
+	ndacl_ptr->num_aces = le32toh(numaces);
 
 	/* copy owner sid */
 	owner_sid_ptr = (struct cifs_sid *)((char *)pntsd + osidsoffset);
@@ -110,7 +110,7 @@ copy_ace(struct cifs_ace *dace, struct cifs_ace *sace)
 
 	dace->type = sace->type;
 	dace->flags = sace->flags;
-	dace->access_req = htole32(sace->access_req);
+	dace->access_req = sace->access_req;
 
 	dace->sid.revision = sace->sid.revision;
 	dace->sid.num_subauth = sace->sid.num_subauth;
@@ -119,7 +119,7 @@ copy_ace(struct cifs_ace *dace, struct cifs_ace *sace)
 	for (i = 0; i < sace->sid.num_subauth; i++)
 		dace->sid.sub_auth[i] = sace->sid.sub_auth[i];
 
-	dace->size = htole16(sace->size);
+	dace->size = sace->size;
 
 	return dace->size;
 }
@@ -155,7 +155,7 @@ compare_aces(struct cifs_ace *sace, struct cifs_ace *dace, int compflags)
 	}
 
 	if (compflags & COMPMASK) {
-		if (dace->access_req != htole32(sace->access_req))
+		if (dace->access_req != sace->access_req)
 			return 0;
 	}
 
-- 
1.7.11.7
