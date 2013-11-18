From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: validate negotiate info fsctl
Date: Mon, 18 Nov 2013 15:40:48 -0600
Message-ID: <CAH2r5msQEB2+1qNhe=qtV2+CigbFFYOoxeEHDH5VOR8Swe1a1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I have been experimenting with the validate negotiate info fsctl from
the cifs kernel client when negotiating smb3 or smb3.02 dialects.  I
still need to add the check to verify the four returned fields (server
GUID, capabilities etc.) that the server sent back.  And do I need to
sign this request whether or not signing is turned on (Samba did not
seem to care).

Comments on this early version of the patch?

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d9ea7ad..f918a99 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -384,6 +384,7 @@ struct smb_version_operations {
     int (*clone_range)(const unsigned int, struct cifsFileInfo *src_file,
             struct cifsFileInfo *target_file, u64 src_off, u64 len,
             u64 dest_off);
+    int (*validate_negotiate)(const unsigned int, struct cifs_tcon *);
 };

 struct smb_version_values {
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index a3968ee..757da3e 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1319,6 +1319,7 @@ struct smb_version_operations smb30_operations = {
     .create_lease_buf = smb3_create_lease_buf,
     .parse_lease_buf = smb3_parse_lease_buf,
     .clone_range = smb2_clone_range,
+    .validate_negotiate = smb3_validate_negotiate,
 };

 struct smb_version_values smb20_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 1e136ee..f01e97b 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -454,6 +454,50 @@ neg_exit:
     return rc;
 }

+int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
+{
+    int rc = 0;
+    struct validate_negotiate_info_req vneg_inbuf;
+    struct validate_negotiate_info_rsp *pneg_rsp;
+    u32 rsplen;
+
+    cifs_dbg(VFS, "validate negotiate ");
+    vneg_inbuf.Capabilities =
+            cpu_to_le32(tcon->ses->server->vals->req_capabilities);
+    memcpy(vneg_inbuf.Guid, cifs_client_guid, SMB2_CLIENT_GUID_SIZE);
+
+    if (tcon->ses->sign)
+        vneg_inbuf.SecurityMode =
+            cpu_to_le16(SMB2_NEGOTIATE_SIGNING_REQUIRED);
+    else if (global_secflags & CIFSSEC_MAY_SIGN)
+        vneg_inbuf.SecurityMode =
+            cpu_to_le16(SMB2_NEGOTIATE_SIGNING_ENABLED);
+    else
+        vneg_inbuf.SecurityMode = 0;
+
+    vneg_inbuf.DialectCount = cpu_to_le16(1);
+    vneg_inbuf.Dialects[0] =
+        cpu_to_le16(tcon->ses->server->vals->protocol_id);
+
+    /* BB need to force signing on this request */
+    rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
+        FSCTL_VALIDATE_NEGOTIATE_INFO, true /* is_fsctl */,
+        (char *)&vneg_inbuf, sizeof(struct validate_negotiate_info_req),
+        (char **)&pneg_rsp, &rsplen);
+    if ((rc == 0)  && (rsplen > 0)) {
+        /* BB add parsing to ensure that at least first three of
following 4 match */
+
+/*    __le32 Capabilities;
+    __u8   Guid[SMB2_CLIENT_GUID_SIZE];
+    __le16 SecurityMode;
+    __le16 Dialect; */
+
+    } else
+        cifs_dbg(VFS, "error %d on ioctl to validate negotiate\n", rc);
+
+    return rc;
+}
+
 int
 SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
         const struct nls_table *nls_cp)
@@ -829,6 +873,10 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses
*ses, const char *tree,
         ((tcon->share_flags & SHI1005_FLAGS_DFS) == 0))
         cifs_dbg(VFS, "DFS capability contradicts DFS flag\n");
     init_copy_chunk_defaults(tcon);
+    if (tcon->ses->server->ops->validate_negotiate) {
+        rc = tcon->ses->server->ops->validate_negotiate(xid, tcon);
+        /* if rc do something to make sure session gets torn down */
/* BB FIXME */
+    }
 tcon_exit:
     free_rsp_buf(resp_buftype, rsp);
     kfree(unc_path);
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index f88320b..2022c54 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -577,13 +577,19 @@ struct copychunk_ioctl_rsp {
     __le32 TotalBytesWritten;
 } __packed;

-/* Response and Request are the same format */
-struct validate_negotiate_info {
+struct validate_negotiate_info_req {
     __le32 Capabilities;
     __u8   Guid[SMB2_CLIENT_GUID_SIZE];
     __le16 SecurityMode;
     __le16 DialectCount;
-    __le16 Dialect[1];
+    __le16 Dialects[1]; /* dialect (someday maybe list) client asked for */
+} __packed;
+
+struct validate_negotiate_info_rsp {
+    __le32 Capabilities;
+    __u8   Guid[SMB2_CLIENT_GUID_SIZE];
+    __le16 SecurityMode;
+    __le16 Dialect; /* Dialect in use for the connection */
 } __packed;

 #define RSS_CAPABLE    0x00000001
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index b4eea10..93adc64 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -162,5 +162,6 @@ extern int smb2_lockv(const unsigned int xid,
struct cifs_tcon *tcon,
               struct smb2_lock_element *buf);
 extern int SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
                 __u8 *lease_key, const __le32 lease_state);
+extern int smb3_validate_negotiate(const unsigned int, struct cifs_tcon *);

 #endif            /* _SMB2PROTO_H */
diff --git a/fs/cifs/smbfsctl.h b/fs/cifs/smbfsctl.h
index a4b2391f..0e538b5 100644
--- a/fs/cifs/smbfsctl.h
+++ b/fs/cifs/smbfsctl.h
@@ -90,7 +90,7 @@
 #define FSCTL_LMR_REQUEST_RESILIENCY 0x001401D4 /* BB add struct */
 #define FSCTL_LMR_GET_LINK_TRACK_INF 0x001400E8 /* BB add struct */
 #define FSCTL_LMR_SET_LINK_TRACK_INF 0x001400EC /* BB add struct */
-#define FSCTL_VALIDATE_NEGOTIATE_INFO 0x00140204 /* BB add struct */
+#define FSCTL_VALIDATE_NEGOTIATE_INFO 0x00140204
 /* Perform server-side data movement */
 #define FSCTL_SRV_COPYCHUNK 0x001440F2
 #define FSCTL_SRV_COPYCHUNK_WRITE 0x001480F2

-- 
Thanks,

Steve
