From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Fix broken sec=ntlmv2/i sec mount option for Samba server
Date: Tue, 23 Aug 2011 20:16:52 -0500
Message-ID: <1314148612-18487-1-git-send-email-shirishpargaonkarp@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Fix sec=ntlmv2/i authentication option during mount of Samba shares.

Samba server does not like timestamp field as one of the av pair
elements during raw ntlmv2 authentication.
Windows servers do not care whether that av pair field is used in the
blob for NTLMv2 authentication.

For sec=ntlmsspi, build_av_pair is not used, a blob is plucked from
type 2 response sent by the server to use in authentication.

I tested sec=ntlmv2/i and sec=ntlmssp/i mount options against
Samba (3.6) and Windows - XP, 2003 Server and 7.
They all worked.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index e76bfeb..90f85af 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -353,7 +353,6 @@ build_avpair_blob(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	unsigned int dlen;
 	unsigned int wlen;
 	unsigned int size = 6 * sizeof(struct ntlmssp2_name);
-	__le64  curtime;
 	char *defdmname = "WORKGROUP";
 	unsigned char *blobptr;
 	struct ntlmssp2_name *attrptr;
@@ -373,7 +372,7 @@ build_avpair_blob(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	 * two times the unicode length of a server name +
 	 * size of a timestamp (which is 8 bytes).
 	 */
-	ses->auth_key.len = size + 2 * (2 * dlen) + 2 * (2 * wlen) + 8;
+	ses->auth_key.len = size + 2 * (2 * dlen) + 2 * (2 * wlen);
 	ses->auth_key.response = kzalloc(ses->auth_key.len, GFP_KERNEL);
 	if (!ses->auth_key.response) {
 		ses->auth_key.len = 0;
@@ -416,12 +415,6 @@ build_avpair_blob(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	blobptr += 2 * wlen;
 	attrptr = (struct ntlmssp2_name *) blobptr;
 
-	attrptr->type = cpu_to_le16(NTLMSSP_AV_TIMESTAMP);
-	attrptr->length = cpu_to_le16(sizeof(__le64));
-	blobptr = (unsigned char *)attrptr + sizeof(struct ntlmssp2_name);
-	curtime = cpu_to_le64(cifs_UnixTimeToNT(CURRENT_TIME));
-	memcpy(blobptr, &curtime, sizeof(__le64));
-
 	return 0;
 }
 
-- 
1.6.0.2
