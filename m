From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v3 3/3] CIFS: dump IPC tcon in debug proc file
Date: Wed, 24 Jan 2018 13:46:12 +0100
Message-ID: <20180124124612.21993-4-aaptel@suse.com>
References: <20180117172200.3221-1-aaptel@suse.com>
 <20180124124612.21993-1-aaptel@suse.com>
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180124124612.21993-1-aaptel-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

dump it as first share with an "IPC: " prefix.

Signed-off-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
---
 fs/cifs/cifs_debug.c | 61 ++++++++++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 26 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index 05be9b47eb0c..f491340f32ad 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -110,6 +110,32 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
 }
 
 #ifdef CONFIG_PROC_FS
+static void cifs_debug_tcon(struct seq_file *m, struct cifs_tcon *tcon)
+{
+	__u32 dev_type = le32_to_cpu(tcon->fsDevInfo.DeviceType);
+
+	seq_printf(m, "%s Mounts: %d ", tcon->treeName, tcon->tc_count);
+	if (tcon->nativeFileSystem)
+		seq_printf(m, "Type: %s ", tcon->nativeFileSystem);
+	seq_printf(m, "DevInfo: 0x%x Attributes: 0x%x\n\tPathComponentMax: %d Status: %d",
+		   le32_to_cpu(tcon->fsDevInfo.DeviceCharacteristics),
+		   le32_to_cpu(tcon->fsAttrInfo.Attributes),
+		   le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength),
+		   tcon->tidStatus);
+	if (dev_type == FILE_DEVICE_DISK)
+		seq_puts(m, " type: DISK ");
+	else if (dev_type == FILE_DEVICE_CD_ROM)
+		seq_puts(m, " type: CDROM ");
+	else
+		seq_printf(m, " type: %d ", dev_type);
+	if (tcon->ses->server->ops->dump_share_caps)
+		tcon->ses->server->ops->dump_share_caps(m, tcon);
+
+	if (tcon->need_reconnect)
+		seq_puts(m, "\tDISCONNECTED ");
+	seq_putc(m, '\n');
+}
+
 static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 {
 	struct list_head *tmp1, *tmp2, *tmp3;
@@ -118,7 +144,6 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 	int i, j;
-	__u32 dev_type;
 
 	seq_puts(m,
 		    "Display Internal CIFS Data Structures for Debugging\n"
@@ -260,35 +285,19 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 
 			seq_puts(m, "\n\tShares:");
 			j = 0;
+
+			seq_printf(m, "\n\t%d) IPC: ", j);
+			if (ses->tcon_ipc)
+				cifs_debug_tcon(m, ses->tcon_ipc);
+			else
+				seq_puts(m, "none\n");
+
 			list_for_each(tmp3, &ses->tcon_list) {
 				tcon = list_entry(tmp3, struct cifs_tcon,
 						  tcon_list);
 				++j;
-				dev_type = le32_to_cpu(tcon->fsDevInfo.DeviceType);
-				seq_printf(m, "\n\t%d) %s Mounts: %d ", j,
-					   tcon->treeName, tcon->tc_count);
-				if (tcon->nativeFileSystem) {
-					seq_printf(m, "Type: %s ",
-						   tcon->nativeFileSystem);
-				}
-				seq_printf(m, "DevInfo: 0x%x Attributes: 0x%x"
-					"\n\tPathComponentMax: %d Status: %d",
-					le32_to_cpu(tcon->fsDevInfo.DeviceCharacteristics),
-					le32_to_cpu(tcon->fsAttrInfo.Attributes),
-					le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength),
-					tcon->tidStatus);
-				if (dev_type == FILE_DEVICE_DISK)
-					seq_puts(m, " type: DISK ");
-				else if (dev_type == FILE_DEVICE_CD_ROM)
-					seq_puts(m, " type: CDROM ");
-				else
-					seq_printf(m, " type: %d ", dev_type);
-				if (server->ops->dump_share_caps)
-					server->ops->dump_share_caps(m, tcon);
-
-				if (tcon->need_reconnect)
-					seq_puts(m, "\tDISCONNECTED ");
-				seq_putc(m, '\n');
+				seq_printf(m, "\n\t%d) ", j);
+				cifs_debug_tcon(m, tcon);
 			}
 
 			seq_puts(m, "\n\tMIDs:\n");
-- 
2.12.3
