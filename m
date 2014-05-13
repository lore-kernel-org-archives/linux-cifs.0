From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH][CIFS] Do not send non-zero ClientGUID on SMB2.02 dialect
 negotiate protocol request
Date: Tue, 13 May 2014 22:50:45 +0200
Message-ID: <CAH2r5msHgOcCtP-Qkat7kUNnjYU+QUufuMBJW0krfW1qdh_bog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

>From ac9334f68ece14fa3f6ee23a5966702fdadbe182 Mon Sep 17 00:00:00 2001
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Tue, 13 May 2014 13:37:45 -0700
Subject: [PATCH] [CIFS] Do not send ClientGUID on SMB2.02 dialect

ClientGUID must be zero for SMB2.02 dialect.  See section 2.2.3
of MS-SMB2. For SMB2.1 and later it must be non-zero.

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index dc44610..e8b2550 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -375,7 +375,12 @@ SMB2_negotiate(const unsigned int xid, struct
cifs_ses *ses)

  req->Capabilities = cpu_to_le32(ses->server->vals->req_capabilities);

- memcpy(req->ClientGUID, server->client_guid, SMB2_CLIENT_GUID_SIZE);
+ /* ClientGUID must be zero for SMB2.02 dialect */
+ if (ses->server->vals->protocol_id == SMB20_PROT_ID)
+ memset(req->ClientGUID, 0, SMB2_CLIENT_GUID_SIZE);
+ else
+ memcpy(req->ClientGUID, server->client_guid,
+ SMB2_CLIENT_GUID_SIZE);

  iov[0].iov_base = (char *)req;
  /* 4 for rfc1002 length field */
-- 
1.9.1


-- 
Thanks,

Steve
