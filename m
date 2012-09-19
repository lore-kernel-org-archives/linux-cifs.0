From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [CIFS] Trivial Endian Fixes
Date: Wed, 19 Sep 2012 02:22:52 -0500
Message-ID: <CAH2r5mvZfG9+XZevPODrTKD72=M_PWmQSBiJ3K+_9Cf-yXNPbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Some trivial endian fixes for the SMB2 code.  One remains which I
asked Pavel to look at.

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index cd31715..7b1c5e3 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -422,7 +422,8 @@ smb2_is_valid_lease_break(char *buffer, struct
TCP_Server_Info *server)
        struct cifs_pending_open *open;
        struct smb2_lease_break_work *lw;
        bool found;
-       int ack_req = rsp->Flags & SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED;
+       int ack_req = le32_to_cpu(rsp->Flags &
+                                 SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED);

        lw = kmalloc(sizeof(struct smb2_lease_break_work), GFP_KERNEL);
        if (!lw) {
@@ -524,7 +525,7 @@ smb2_is_valid_oplock_break(char *buffer, struct
TCP_Server_Info *server)
        if (rsp->hdr.Command != SMB2_OPLOCK_BREAK)
                return false;

-       if (le16_to_cpu(rsp->StructureSize) !=
+       if (rsp->StructureSize !=
                                smb2_rsp_struct_sizes[SMB2_OPLOCK_BREAK_HE]) {
                if (le16_to_cpu(rsp->StructureSize) == 44)
                        return smb2_is_valid_lease_break(buffer, server);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 630156f..2183bb3 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -496,7 +496,7 @@ smb2_is_status_pending(char *buf, struct
TCP_Server_Info *server, int length)
 {
        struct smb2_hdr *hdr = (struct smb2_hdr *)buf;

-       if (le32_to_cpu(hdr->Status) != STATUS_PENDING)
+       if (hdr->Status != STATUS_PENDING)
                return false;

        if (!length) {


-- 
Thanks,

Steve
