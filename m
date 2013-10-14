From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Querying Server Adapter Info at mount time
Date: Mon, 14 Oct 2013 01:03:14 -0500
Message-ID: <CAH2r5mtiX65b8ZwAs0D7PdYfGkCW7hNku7oe9f2x8+tfgDCeow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It is easy now in SMB3 to query the information about the server's
network interfaces (and at least Windows 8 and above do this, if not
other clients) there are some useful pieces of information you can get
including:

- all of the network interfaces that the server advertises (not just
the one you are mounting over), and with SMB3 supporting multichannel
this helps with more than just failover (also aggregating multiple
sockets under one mount)

- whether the adapter supports RSS (useful to know if you want to
estimate whether setting up two or more socket connections to the same
address is going to be faster due to RSS offload in the adapter)

- whether the server supports RDMA

- whether the server has IPv6 interfaces (if you connected over IPv4
but prefer IPv6 e.g.)

- what the link speed is (you might want to reconnect over a higher
speed interface if available)

(Of course we could also rerequest this on every mount cheaplly to the
same server, as Windows apparently does, so we can update the adapter
info on new mounts, and also on every reconnect if the network
interface drops temporarily - so we don't have to rely on info from
the first mount to this server)

It is trivial to request this information (see below sample patch) -
and certainly is useful when we get to the point of doing multichannel
(and eventually RDMA), but I am wondering whether saving some of this
(linkspeed etc.) off for debugging could be useful.

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 25759c8..c4ede18 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -209,6 +209,28 @@ smb2_negotiate_rsize(struct cifs_tcon *tcon,
struct smb_vol *volume_info)
     return rsize;
 }

+static int
+SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon)
+{
+    int rc;
+    unsigned int ret_data_len = 0;
+    struct network_interface_info_ioctl_rsp *out_buf;
+
+    rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
+            FSCTL_QUERY_NETWORK_INTERFACE_INFO, true /* is_fsctl */,
+            NULL /* no data input */, 0 /* no data input */,
+            (char **)&out_buf, &ret_data_len);
+
+    if ((rc == 0)  && (ret_data_len > 0)) {
+        /* Dump info on first interface -- REMOVEME */
+        cifs_dbg(VFS, "Capability 0x%x\t", le32_to_cpu(out_buf->Capability));
+        cifs_dbg(VFS, "Link Speed %lld\n", le64_to_cpu(out_buf->LinkSpeed));
+    } else
+        cifs_dbg(VFS, "error %d on ioctl to get interface list\n", rc);
+
+    return rc;
+}
+
 static void
 smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon)
 {
@@ -229,6 +251,8 @@ smb3_qfs_tcon(const unsigned int xid, struct
cifs_tcon *tcon)
     if (rc)
         return;

+    SMB3_request_interfaces(xid, tcon);
+
     SMB2_QFS_attr(xid, tcon, fid.persistent_fid, fid.volatile_fid,
             FS_ATTRIBUTE_INFORMATION);
     SMB2_QFS_attr(xid, tcon, fid.persistent_fid, fid.volatile_fid,

-- 
Thanks,

Steve
