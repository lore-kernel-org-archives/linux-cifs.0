From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [cifs] smb2 mounts with signing fail due to incorrect
 security mode bits check
Date: Thu, 27 Jun 2013 02:55:34 -0500
Message-ID: <CAH2r5mtiK1is8ZxMbUv60jQKbSZ1tV7MsCBT25QHNJNCdPDi4g@mail.gmail.com>
References: <1372279639-31426-1-git-send-email-shirishpargaonkar@gmail.com>
	<CADT32eJvWa1f6fbfxWmo+_DH-SnMGsP3wH3HHxf9V6Chc73urA@mail.gmail.com>
	<CAH2r5mu0QSjZ5E0tepmKw=SuXuhx1SgVu-BPsX_ZMijzwW5zdA@mail.gmail.com>
	<CADT32eKX9yAS4iKZWQnUEaS95W5i2z2EFsVBe03ff9uRzUsa=g@mail.gmail.com>
	<20130626210944.59bf3827@corrin.poochiereds.net>
	<CAH2r5mv+K7CE8ApnUR2q0kf=cLaLPRDCP+4QNUYZ4mivtbRtMA@mail.gmail.com>
	<20130627004345.279cfb02@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130627004345.279cfb02-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

How about this patch to fix the problem that Shirish noted? It seemed
simple to simply map the two SMB2 flags to the older style flags that
we check in the sec_mode.

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2b312e4..8f0a46b 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -318,6 +318,23 @@ free_rsp_buf(int resp_buftype, void *rsp)
 		cifs_buf_release(rsp);
 }

+/* convert smb2 sec mode to older form so can be used for both smb2 and cifs */
+static __u16
+convert_sec_mode(__u16 smb2_sec_mode)
+{
+	u16 sec_mode = 0;
+
+	if ((smb2_sec_mode & SMB2_SEC_MODE_MASK) != smb2_sec_mode)
+		cifs_dbg(VFS, "srv ret unknown sec_mode 0x%x\n", smb2_sec_mode);
+
+	if (smb2_sec_mode & SMB2_NEGOTIATE_SIGNING_ENABLED)
+		sec_mode |= SECMODE_SIGN_ENABLED;
+
+	if (smb2_sec_mode & SMB2_NEGOTIATE_SIGNING_REQUIRED)
+		sec_mode |= SECMODE_SIGN_REQUIRED;
+
+	return sec_mode;
+}

 /*
  *
@@ -416,8 +433,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	server->maxBuf = le32_to_cpu(rsp->MaxTransactSize);
 	server->max_read = le32_to_cpu(rsp->MaxReadSize);
 	server->max_write = le32_to_cpu(rsp->MaxWriteSize);
-	/* BB Do we need to validate the SecurityMode? */
-	server->sec_mode = le16_to_cpu(rsp->SecurityMode);
+	server->sec_mode = convert_sec_mode(le16_to_cpu(rsp->SecurityMode));
 	server->capabilities = le32_to_cpu(rsp->Capabilities);
 	/* Internal types */
 	server->capabilities |= SMB2_NT_FIND | SMB2_LARGE_FILES;
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index f31043b..c7534ee 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -176,6 +176,7 @@ struct smb2_negotiate_req {
 /* SecurityMode flags */
 #define	SMB2_NEGOTIATE_SIGNING_ENABLED	0x0001
 #define SMB2_NEGOTIATE_SIGNING_REQUIRED	0x0002
+#define SMB2_SEC_MODE_MASK		0x0003
 /* Capabilities flags */
 #define SMB2_GLOBAL_CAP_DFS		0x00000001
 #define SMB2_GLOBAL_CAP_LEASING		0x00000002 /* Resp only New to SMB2.1 */

-- 
Thanks,

Steve
