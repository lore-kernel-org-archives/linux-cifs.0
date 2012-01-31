From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] cifs: check offset in decode_ntlmssp_challenge()
Date: Tue, 31 Jan 2012 11:52:01 +0300
Message-ID: <20120131085201.GB22039@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We should check that we're not copying memory from beyond the end of the
blob.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index d85efad..eb76741 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -395,6 +395,10 @@ static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 	ses->ntlmssp->server_flags = le32_to_cpu(pblob->NegotiateFlags);
 	tioffset = le32_to_cpu(pblob->TargetInfoArray.BufferOffset);
 	tilen = le16_to_cpu(pblob->TargetInfoArray.Length);
+	if (tioffset > blob_len || tioffset + tilen > blob_len) {
+		cERROR(1, "tioffset + tilen too high %u + %u", tioffset, tilen);
+		return -EINVAL;
+	}
 	if (tilen) {
 		ses->auth_key.response = kmalloc(tilen, GFP_KERNEL);
 		if (!ses->auth_key.response) {
