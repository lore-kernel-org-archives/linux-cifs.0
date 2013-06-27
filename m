From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [CIFS][PATCH] Do not set DFS flag on SMB2 open
Date: Wed, 26 Jun 2013 19:18:10 -0500
Message-ID: <CAH2r5ms18n_cYzTN2+tUyo5R+6yPwKtg+wKziuPXLTrWOGXgVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

commit f87ab88b4065a9ef00620224c4fafadc201a430c
Author: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date:   Wed Jun 26 19:14:55 2013 -0500

    [CIFS] Do not set DFS flag on SMB2 open

    If we would set SMB2_FLAGS_DFS_OPERATIONS on open we also would have
    to pass the path on the Open SMB prefixed by \\server\share.
    Not sure when we would need to do the augmented path (if ever) and
    setting this flag breaks the SMB2 open operation since it is
    illegal to send an empty path name (without \\server\share prefix)
    when the DFS flag is set in the SMB open header. We could
    consider setting the flag on all operations other than open
    but it is safer to not set it for now.  Note that
    we still get error path not covered (when needed to give us
    a dfs referral) even when the flag is off.


    Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 53275bf..2b312e4 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -120,13 +120,20 @@ smb2_hdr_assemble(struct smb2_hdr *hdr, __le16
smb2_cmd /* command */ ,
 	/* Uid is not converted */
 	if (tcon->ses)
 		hdr->SessionId = tcon->ses->Suid;
-	/* BB check following DFS flags BB */
-	/* BB do we have to add check for SHI1005_FLAGS_DFS_ROOT too? */
-	if (tcon->share_flags & SHI1005_FLAGS_DFS)
-		hdr->Flags |= SMB2_FLAGS_DFS_OPERATIONS;
-	/* BB how does SMB2 do case sensitive? */
-	/* if (tcon->nocase)
-		hdr->Flags |= SMBFLG_CASELESS; */
+
+	/*
+	 * If we would set SMB2_FLAGS_DFS_OPERATIONS on open we also would have
+	 * to pass the path on the Open SMB prefixed by \\server\share.
+	 * Not sure when we would need to do the augmented path (if ever) and
+	 * setting this flag breaks the SMB2 open operation since it is
+	 * illegal to send an empty path name (without \\server\share prefix)
+	 * when the DFS flag is set in the SMB open header. We could
+	 * consider setting the flag on all operations other than open
+	 * but it is safer to net set it for now.
+	 */
+/*	if (tcon->share_flags & SHI1005_FLAGS_DFS)
+		hdr->Flags |= SMB2_FLAGS_DFS_OPERATIONS; */
+
 	if (tcon->ses && tcon->ses->server && tcon->ses->server->sign)
 		hdr->Flags |= SMB2_FLAGS_SIGNED;
 out:

-- 
Thanks,

Steve
