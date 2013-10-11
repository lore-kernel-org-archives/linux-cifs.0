From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] [CIFS] Fix corrupt SMB2 ioctl requests
Date: Thu, 10 Oct 2013 21:56:39 -0500
Message-ID: <CAH2r5mskG56nv8D6EQhQN+W7WbvynFksOzpLMa51jsTp0kWp0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

As Metze suggested I split this small patch out of the compression
ioctl patch.

We were off by one calculating the length of ioctls in some cases
because the protocol specification for SMB2 ioctl includes a mininum
one byte payload but not all SMB2 ioctl requests actually have
a data buffer to send. We were also not zeroing out the
return buffer (in case of error this is helpful).

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index edccb52..dabfa90 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1137,6 +1137,7 @@ SMB2_ioctl(const unsigned int xid, struct
cifs_tcon *tcon, u64 persistent_fid,

  cifs_dbg(FYI, "SMB2 IOCTL\n");

+ *out_data = NULL;
  /* zero out returned data len, in case of error */
  if (plen)
  *plen = 0;
@@ -1183,10 +1184,12 @@ SMB2_ioctl(const unsigned int xid, struct
cifs_tcon *tcon, u64 persistent_fid,

  iov[0].iov_base = (char *)req;
  /* 4 for rfc1002 length field */
- iov[0].iov_len = get_rfc1002_length(req) + 4;
+ /* -1 since last byte is buf[0] which is sent in iov[1] or not at all */
+ iov[0].iov_len = get_rfc1002_length(req) + 4 - 1;

+ /* -1 since last byte is buf[0] which was counted in smb2_buf_len */
  if (indatalen)
- inc_rfc1001_len(req, indatalen);
+ inc_rfc1001_len(req, indatalen - 1);

  rc = SendReceive2(xid, ses, iov, num_iovecs, &resp_buftype, 0);
  rsp = (struct smb2_ioctl_rsp *)iov[0].iov_base;
-- 
1.7.11.7


-- 
Thanks,

Steve
