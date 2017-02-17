From: Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
Subject: Re: Fix SMB2_TREE_CONNECT requests with the wrong TreeId
Date: Fri, 17 Feb 2017 11:55:15 +0100
Message-ID: <41c29ddb-eafa-dc03-ab2b-864919aa4192@fbihome.de>
References: <25f3edd0-3abf-f541-d7f8-54ae1dbac081@fbihome.de>
 <mps60keik2w.fsf@aaptelpc.suse.de>
 <066cc0b2-0e63-8cf6-7d46-578e524cf3bf@fbihome.de>
 <mpszihohiad.fsf@aaptelpc.suse.de>
 <1a130ab9-84bf-82cb-8c23-e071c286822c@fbihome.de>
 <mpswpcrhaet.fsf@aaptelpc.suse.de>
 <461c47b3-a4ae-c21c-26c5-b33dd19f2b37@fbihome.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------2D53E13FA49341812424BD33"
To: =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <461c47b3-a4ae-c21c-26c5-b33dd19f2b37-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------2D53E13FA49341812424BD33
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Am 15.02.2017 um 15:24 schrieb Jan-Marek Glogowski:
> I won't be able to test the patch today but hopefully tomorrow,
> depending on the current LiMux stuff. I'm tired too. It compiled for my
> old kernel and should work.

Took some time to test the 2nd patch and it turned out it doesn't work.
The TreeId must be reset before small_smb2_init(SMB2_TREE_CONNECT, ...)
call, as this copies the tcon->tid into the smb2 header.

This is fixed in the attached patch.

Can I add "Reported-by" or "Tested-by" for myself and Suggested-by, and
Reviewed-by for you?

Do you want to test it?

Jan-Marek

--------------2D53E13FA49341812424BD33
Content-Type: text/x-patch;
 name="0001-Reset-TreeId-to-zero-on-SMB2_TREE_CONNECT.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-Reset-TreeId-to-zero-on-SMB2_TREE_CONNECT.patch"

>From faf5ea71a567fa9f68daf296e0fa27823f968ee8 Mon Sep 17 00:00:00 2001
From: Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
Date: Fri, 10 Feb 2017 16:43:46 +0100
Subject: [PATCH] Reset TreeId to zero on SMB2_TREE_CONNECT

Currently the cifs module breaks the CIFS specs on reconnect as
described in http://msdn.microsoft.com/en-us/library/cc246529.aspx:

"TreeId (4 bytes): Uniquely identifies the tree connect for the
command. This MUST be 0 for the SMB2 TREE_CONNECT Request."

Signed-off-by: Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8745722..bdd3292 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1104,6 +1104,10 @@ static inline void init_copy_chunk_defaults(struct cifs_tcon *tcon)
 		return -EINVAL;
 	}
 
+	/* SMB2 TREE_CONNECT request must be called with TreeId == 0 */
+	if (tcon)
+		tcon->tid = 0;
+
 	rc = small_smb2_init(SMB2_TREE_CONNECT, tcon, (void **) &req);
 	if (rc) {
 		kfree(unc_path);
-- 
1.9.1


--------------2D53E13FA49341812424BD33--
