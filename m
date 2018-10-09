From: Ronnie Sahlberg <lsahlber@redhat.com>
Subject: Re: [PATCH v2] smb2: fix uninitialized variable bug in
 smb2_ioctl_query_info
Date: Tue, 9 Oct 2018 17:47:00 -0400 (EDT)
Message-ID: <716967702.32689579.1539121620152.JavaMail.zimbra@redhat.com>
References: <20181009201748.GA21025@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181009201748.GA21025@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Good catch, but I think it should be :

int resp_buftype = CIFS_NO_BUFFER;


----- Original Message -----
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: "Steve French" <sfrench@samba.org>, "Ronnie Sahlberg" <lsahlber@redhat.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Sent: Wednesday, 10 October, 2018 6:17:48 AM
Subject: [PATCH v2] smb2: fix uninitialized variable bug in smb2_ioctl_query_info

There is a potential execution path in which variable *resp_buftype*
is passed as an argument to function free_rsp_buf(), in which it is
used in a comparison without being properly initialized previously.

Fix this by initializing variable *resp_buftype* to -1 in order to
avoid unpredictable or unintended results.

Addresses-Coverity-ID: 1473971 ("Uninitialized scalar variable")
Fixes: c5d25bdb2967 ("cifs: add IOCTL for QUERY_INFO passthrough to userspace")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
Changes in v2:
 - Fix Coverity and Fixes tag.
 - Update commit log.

 fs/cifs/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index c6c6450d..927aadd 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -1133,7 +1133,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 	struct smb_rqst rqst;
 	struct kvec iov[1];
 	struct kvec rsp_iov;
-	int resp_buftype;
+	int resp_buftype = -1;
 	struct smb2_query_info_rsp *rsp = NULL;
 	void *buffer;
 
-- 
2.7.4
