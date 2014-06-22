From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Workaround a probable Samba case sensitivity bug
Date: Sun, 22 Jun 2014 12:40:16 -0500
Message-ID: <1403458816-10036-1-git-send-email-spargaonkar@suse.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>

When a client supports extended security but server does not,
and that client, in Flags2 field of smb header indicates that

- it supports extended security negotiation
- it does not support security signatures
- it does not require security signatures

Samba server treats a client as a Vista client.

That turns off case sensitivity and that is a problem for cifs vfs client.

This is the Samba server code.  I am not sure what is the
reasoning behind this.

------------- source3/smbd/negprot.c  reply_nt1() ------------------

        /* Check the flags field to see if this is Vista.
           WinXP sets it and Vista does not. But we have to 
           distinguish from NT which doesn't set it either. */

        if ( (req->flags2 & FLAGS2_EXTENDED_SECURITY) &&
                ((req->flags2 & FLAGS2_SMB_SECURITY_SIGNATURES_REQUIRED) == 0) )
        {
                if (get_remote_arch() != RA_SAMBA) {
                        set_remote_arch( RA_VISTA );
                }
        }

--------------------------------------------------------------------

But if this code has to stay, perhaps this line
if (get_remote_arch() != RA_SAMBA) {
could be changed to
if ((get_remote_arch() != RA_SAMBA) && (get_remote_arch() != RA_CIFSFS)) {
(I tested with this code change and it works)


I do not know what could be a correct fix for this is in cifs client code.

I think it is perfectly alright for cifs client to set these three flag2 bits
(extended security, security signature, and security signature required).
the way it sets in smb header and still retain its identity as cifsfs.

cifs client could set Security Signature bit in Flags2 in negotiate request
since it does support signatures but does not have to require
security signatures unless client asks using sec= mount option.

For subsequent packets, cifs client decides whether to set
Security Signature bit in Flags2 or not based on server (server->sign).


So I have attached a patch with that change.

The way I recreated it was using these three options in smb.conf

        client NTLMv2 auth = yes
        client use spnego = no
        use spnego = no


Signed-by: Shirish Pargaonkar <spargaonkar-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/cifssmb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 6ce4e09..2d7d131 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -568,6 +568,8 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 
 	pSMB->hdr.Mid = get_next_mid(server);
 	pSMB->hdr.Flags2 |= (SMBFLG2_UNICODE | SMBFLG2_ERR_STATUS);
+	pSMB->hdr.Flags2 |= (SMBFLG2_SECURITY_SIGNATURE |
+				SMBFLG2_SECURITY_SIGNATURE_REQUIRED);
 
 	if (should_set_ext_sec_flag(ses->sectype)) {
 		cifs_dbg(FYI, "Requesting extended security.");
-- 
1.8.3.2
