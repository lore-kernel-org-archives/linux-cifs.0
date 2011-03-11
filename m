From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [CIFS] do not try to dump cifs mids from smb2 sessions
Date: Thu, 10 Mar 2011 22:33:48 -0600
Message-ID: <AANLkTikoOp4DfA1dCeRPvom=OG5i0WNpAEjBSX2U6TbK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

[PATCH] [CIFS] do not try to dump cifs mids from smb2 sessions

Convert the debug routines in cifs_debug.c to recognize
smb2 sessions and not try to dump invalid information on
pending requests.  Check the socket type to see if
smb2.  Move the printing of cifs specific debug information
to a helper routine to make it clearer which type
of information we are printing.

cifs and smb2 both use the struct TCP_Server_Info to include information about
the tcp socket connection to the server.  The list of pending requests
is one of the "per-socket" pieces of information. smb2 and cifs
"mid" queue entries (multiplexed network requests, the active requests
on the wire) differ. smb2 has async support in the protocol,
as well as operation compounding and larger sizes (than cifs) for
various fields related to pending requests) so it is important
not to try to use the pending_mid_q for smb2 tcp sessions
as if it were a pending cifs request.  Most usage of the
pending_mid_q is safe because it is in either cifs or smb2
specific code, but this patch fixes the dumping of debug
data so we don't dump cifs debug data for an smb2 session.

Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_debug.c |  177 +++++++++++++++++++++++++++-----------------------
 1 files changed, 96 insertions(+), 81 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index d925cf6..c071599 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -72,7 +72,7 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
 	struct list_head *tmp;
 	struct mid_q_entry *mid_entry;

-	if (server == NULL)
+	if ((server == NULL) || (server->is_smb2))
 		return;

 	cERROR(1, "Dump pending requests:");
@@ -105,16 +105,103 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
 #endif /* CONFIG_CIFS_DEBUG2 */

 #ifdef CONFIG_PROC_FS
-static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
+
+static void dump_smb2_debug_info(int i, struct seq_file *m,
+				struct TCP_Server_Info *server)
 {
-	struct list_head *tmp1, *tmp2, *tmp3;
+	seq_printf("dumping debug information for smb2 not supported yet\n");
+}
+
+static void dump_cifs_debug_info(int i, struct seq_file *m,
+				struct TCP_Server_Info *server)
+{
+	struct list_head *tmp2, *tmp3;
 	struct mid_q_entry *mid_entry;
-	struct TCP_Server_Info *server;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
-	int i, j;
+	int j;
 	__u32 dev_type;

+
+	list_for_each(tmp2, &server->smb_ses_list) {
+		ses = list_entry(tmp2, struct cifs_ses, smb_ses_list);
+		if ((ses->serverDomain == NULL) || (ses->serverOS == NULL) ||
+			(ses->serverNOS == NULL)) {
+			seq_printf(m, "\n%d) entry for %s not fully "
+				   "displayed\n\t", i, ses->serverName);
+		} else {
+			seq_printf(m,
+				"\n%d) Name: %s  Domain: %s Uses: %d OS:"
+				" %s\n\tNOS: %s\tCapability: 0x%x\n\tSMB"
+				" session status: %d\t",
+				i, ses->serverName, ses->serverDomain,
+				ses->ses_count, ses->serverOS, ses->serverNOS,
+				ses->capabilities, ses->status);
+		}
+		seq_printf(m, "TCP status: %d\n\tLocal Users To "
+			      "Server: %d SecMode: 0x%x Req On Wire: %d",
+				server->tcpStatus, server->srv_count,
+				server->sec_mode,
+				atomic_read(&server->inFlight));
+
+#ifdef CONFIG_CIFS_STATS2
+		seq_printf(m, " In Send: %d In MaxReq Wait: %d",
+				atomic_read(&server->inSend),
+				atomic_read(&server->num_waiters));
+#endif
+
+		seq_puts(m, "\n\tShares:");
+		j = 0;
+		list_for_each(tmp3, &ses->tcon_list) {
+			tcon = list_entry(tmp3, struct cifs_tcon, tcon_list);
+			++j;
+			dev_type = le32_to_cpu(tcon->fsDevInfo.DeviceType);
+			seq_printf(m, "\n\t%d) %s Mounts: %d ", j,
+				   tcon->treeName, tcon->tc_count);
+			if (tcon->nativeFileSystem) {
+				seq_printf(m, "Type: %s ",
+					   tcon->nativeFileSystem);
+			}
+			seq_printf(m, "DevInfo: 0x%x Attributes: 0x%x"
+				"\nPathComponentMax: %d Status: 0x%d",
+				le32_to_cpu(tcon->fsDevInfo.DeviceCharacteristics),
+				le32_to_cpu(tcon->fsAttrInfo.Attributes),
+				le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength),
+				tcon->tidStatus);
+			if (dev_type == FILE_DEVICE_DISK)
+				seq_puts(m, " type: DISK ");
+			else if (dev_type == FILE_DEVICE_CD_ROM)
+				seq_puts(m, " type: CDROM ");
+			else
+				seq_printf(m, " type: %d ", dev_type);
+
+			if (tcon->need_reconnect)
+				seq_puts(m, "\tDISCONNECTED ");
+			seq_putc(m, '\n');
+		}
+
+		seq_puts(m, "\n\tMIDs:\n");
+
+		spin_lock(&GlobalMid_Lock);
+		list_for_each(tmp3, &server->pending_mid_q) {
+			mid_entry = list_entry(tmp3, struct mid_q_entry, qhead);
+			seq_printf(m, "\tState: %d com: %d pid:"
+					" %d cbdata: %p mid %d\n",
+					mid_entry->midState,
+					(int)mid_entry->command, mid_entry->pid,
+					mid_entry->callback_data,
+					mid_entry->mid);
+		}
+		spin_unlock(&GlobalMid_Lock);
+	}
+}
+
+static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
+{
+	struct list_head *tmp1;
+	struct TCP_Server_Info *server;
+	int i;
+
 	seq_puts(m,
 		    "Display Internal CIFS Data Structures for Debugging\n"
 		    "---------------------------------------------------\n");
@@ -151,82 +238,10 @@ static int cifs_debug_data_proc_show(struct
seq_file *m, void *v)
 		server = list_entry(tmp1, struct TCP_Server_Info,
 				    tcp_ses_list);
 		i++;
-		list_for_each(tmp2, &server->smb_ses_list) {
-			ses = list_entry(tmp2, struct cifs_ses,
-					 smb_ses_list);
-			if ((ses->serverDomain == NULL) ||
-				(ses->serverOS == NULL) ||
-				(ses->serverNOS == NULL)) {
-				seq_printf(m, "\n%d) entry for %s not fully "
-					   "displayed\n\t", i, ses->serverName);
-			} else {
-				seq_printf(m,
-				    "\n%d) Name: %s  Domain: %s Uses: %d OS:"
-				    " %s\n\tNOS: %s\tCapability: 0x%x\n\tSMB"
-				    " session status: %d\t",
-				i, ses->serverName, ses->serverDomain,
-				ses->ses_count, ses->serverOS, ses->serverNOS,
-				ses->capabilities, ses->status);
-			}
-			seq_printf(m, "TCP status: %d\n\tLocal Users To "
-				   "Server: %d SecMode: 0x%x Req On Wire: %d",
-				   server->tcpStatus, server->srv_count,
-				   server->sec_mode,
-				   atomic_read(&server->inFlight));
-
-#ifdef CONFIG_CIFS_STATS2
-			seq_printf(m, " In Send: %d In MaxReq Wait: %d",
-				atomic_read(&server->inSend),
-				atomic_read(&server->num_waiters));
-#endif
-
-			seq_puts(m, "\n\tShares:");
-			j = 0;
-			list_for_each(tmp3, &ses->tcon_list) {
-				tcon = list_entry(tmp3, struct cifs_tcon,
-						  tcon_list);
-				++j;
-				dev_type = le32_to_cpu(tcon->fsDevInfo.DeviceType);
-				seq_printf(m, "\n\t%d) %s Mounts: %d ", j,
-					   tcon->treeName, tcon->tc_count);
-				if (tcon->nativeFileSystem) {
-					seq_printf(m, "Type: %s ",
-						   tcon->nativeFileSystem);
-				}
-				seq_printf(m, "DevInfo: 0x%x Attributes: 0x%x"
-					"\nPathComponentMax: %d Status: 0x%d",
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
-
-				if (tcon->need_reconnect)
-					seq_puts(m, "\tDISCONNECTED ");
-				seq_putc(m, '\n');
-			}
-
-			seq_puts(m, "\n\tMIDs:\n");
-
-			spin_lock(&GlobalMid_Lock);
-			list_for_each(tmp3, &server->pending_mid_q) {
-				mid_entry = list_entry(tmp3, struct mid_q_entry,
-					qhead);
-				seq_printf(m, "\tState: %d com: %d pid:"
-						" %d cbdata: %p mid %d\n",
-						mid_entry->midState,
-						(int)mid_entry->command,
-						mid_entry->pid,
-						mid_entry->callback_data,
-						mid_entry->mid);
-			}
-			spin_unlock(&GlobalMid_Lock);
-		}
+		if (server->is_smb2)
+			dump_smb2_debug_info(i, m, server);
+		else
+			dump_cifs_debug_info(i, m, server);
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
 	seq_putc(m, '\n');

-- 
Thanks,

Steve
