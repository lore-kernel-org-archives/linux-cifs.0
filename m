From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] CIFS: set *resp_buf_type to NO_BUFFER on error
Date: Tue, 7 Feb 2017 16:18:41 +0300
Message-ID: <20170207131841.GC31552@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        kernel-janitors@vger.kernel.org
To: Steve French <sfrench@samba.org>,
        Pavel Shilovsky <pshilov@microsoft.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

We recently shuffled this code around and introduced a new error path
before *resp_buf_type gets initialized.  It creates uninitialized
variable bugs in the callers.

    fs/cifs/smb2pdu.c:579 SMB2_negotiate()
    error: uninitialized symbol 'resp_buftype'.

Fixes: 738f9de5cdb9 ("CIFS: Send RFC1001 length in a separate iov")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 526f0533cb4e..8fa5e058fb15 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -807,6 +807,8 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	struct kvec *new_iov;
 	int rc;
 
+	*resp_buf_type = CIFS_NO_BUFFER; /* no response buf yet */
+
 	new_iov = kmalloc(sizeof(struct kvec) * (n_vec + 1), GFP_KERNEL);
 	if (!new_iov)
 		return -ENOMEM;
