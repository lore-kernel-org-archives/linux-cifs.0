From: Colin King <colin.king@canonical.com>
Subject: [PATCH][V2] cifs: fix memory leak of an allocated cifs_ntsd structure
Date: Wed, 16 Jan 2019 16:28:59 +0000
Message-ID: <20190116162859.8028-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The call to SMB2_queary_acl can allocate memory to pntsd and also
return a failure via a call to SMB2_query_acl (and then query_info).
This occurs when query_info allocates the structure and then in
query_info the call to smb2_validate_and_copy_iov fails. Currently the
failure just returns without kfree'ing pntsd hence causing a memory
leak.

Currently, *data is allocated if it's not already pointing to a buffer,
so it needs to be kfree'd only if was allocated in query_info, so the
fix adds an allocated flag to track this.  Also set *dlen to zero on
an error just to be safe since *data is kfree'd.

Also set errno to -ENOMEM if the allocation of *data fails.

Signed-off-by: Colin Ian King <colin.king@canonical.com>

---
 fs/cifs/smb2pdu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 50811a7dc0e0..0af87bd0dc49 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2816,6 +2816,7 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	int resp_buftype = CIFS_NO_BUFFER;
 	struct cifs_ses *ses = tcon->ses;
 	int flags = 0;
+	bool allocated = false;
 
 	cifs_dbg(FYI, "Query Info\n");
 
@@ -2855,14 +2856,21 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 					"Error %d allocating memory for acl\n",
 					rc);
 				*dlen = 0;
+				rc = -ENOMEM;
 				goto qinf_exit;
 			}
+			allocated = true;
 		}
 	}
 
 	rc = smb2_validate_and_copy_iov(le16_to_cpu(rsp->OutputBufferOffset),
 					le32_to_cpu(rsp->OutputBufferLength),
 					&rsp_iov, min_len, *data);
+	if (rc && allocated) {
+		kfree(*data);
+		*data = NULL;
+		*dlen = 0;
+	}
 
 qinf_exit:
 	SMB2_query_info_free(&rqst);
-- 
2.19.1
