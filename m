From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] [CIFS] do not try to dump cifs mids from smb2 sessions
Date: Fri, 11 Mar 2011 12:06:18 -0600
Message-ID: <AANLkTinDbqDtkjQYR0pOjhW8qVUKOtpBZFJy4yqKqPU4@mail.gmail.com>
References: <AANLkTikoOp4DfA1dCeRPvom=OG5i0WNpAEjBSX2U6TbK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikoOp4DfA1dCeRPvom=OG5i0WNpAEjBSX2U6TbK-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Mar 10, 2011 at 10:33 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
> [PATCH] [CIFS] do not try to dump cifs mids from smb2 sessions
>
> Convert the debug routines in cifs_debug.c to recognize
> smb2 sessions and not try to dump invalid information on
> pending requests. =A0Check the socket type to see if
> smb2. =A0Move the printing of cifs specific debug information
> to a helper routine to make it clearer which type
> of information we are printing.
>
> cifs and smb2 both use the struct TCP_Server_Info to include informat=
ion about
> the tcp socket connection to the server. =A0The list of pending reque=
sts
> is one of the "per-socket" pieces of information. smb2 and cifs
> "mid" queue entries (multiplexed network requests, the active request=
s
> on the wire) differ. smb2 has async support in the protocol,
> as well as operation compounding and larger sizes (than cifs) for
> various fields related to pending requests) so it is important
> not to try to use the pending_mid_q for smb2 tcp sessions
> as if it were a pending cifs request. =A0Most usage of the
> pending_mid_q is safe because it is in either cifs or smb2
> specific code, but this patch fixes the dumping of debug
> data so we don't dump cifs debug data for an smb2 session.
>
> Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifs_debug.c | =A0177 +++++++++++++++++++++++++++---------=
--------------
> =A01 files changed, 96 insertions(+), 81 deletions(-)
>
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index d925cf6..c071599 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -72,7 +72,7 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
> =A0 =A0 =A0 =A0struct list_head *tmp;
> =A0 =A0 =A0 =A0struct mid_q_entry *mid_entry;
>
> - =A0 =A0 =A0 if (server =3D=3D NULL)
> + =A0 =A0 =A0 if ((server =3D=3D NULL) || (server->is_smb2))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>
> =A0 =A0 =A0 =A0cERROR(1, "Dump pending requests:");
> @@ -105,16 +105,103 @@ void cifs_dump_mids(struct TCP_Server_Info *se=
rver)
> =A0#endif /* CONFIG_CIFS_DEBUG2 */
>
> =A0#ifdef CONFIG_PROC_FS
> -static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
> +
> +static void dump_smb2_debug_info(int i, struct seq_file *m,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
TCP_Server_Info *server)
> =A0{
> - =A0 =A0 =A0 struct list_head *tmp1, *tmp2, *tmp3;
> + =A0 =A0 =A0 seq_printf("dumping debug information for smb2 not supp=
orted yet\n");
> +}
> +
> +static void dump_cifs_debug_info(int i, struct seq_file *m,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
TCP_Server_Info *server)
> +{
> + =A0 =A0 =A0 struct list_head *tmp2, *tmp3;
> =A0 =A0 =A0 =A0struct mid_q_entry *mid_entry;
> - =A0 =A0 =A0 struct TCP_Server_Info *server;
> =A0 =A0 =A0 =A0struct cifs_ses *ses;
> =A0 =A0 =A0 =A0struct cifs_tcon *tcon;
> - =A0 =A0 =A0 int i, j;
> + =A0 =A0 =A0 int j;
> =A0 =A0 =A0 =A0__u32 dev_type;
>
> +
> + =A0 =A0 =A0 list_for_each(tmp2, &server->smb_ses_list) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses =3D list_entry(tmp2, struct cifs_se=
s, smb_ses_list);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((ses->serverDomain =3D=3D NULL) || =
(ses->serverOS =3D=3D NULL) ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (ses->serverNOS =3D=3D =
NULL)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(m, "\n%d) en=
try for %s not fully "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
"displayed\n\t", i, ses->serverName);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(m,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "\n%d) =
Name: %s =A0Domain: %s Uses: %d OS:"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " %s\n\=
tNOS: %s\tCapability: 0x%x\n\tSMB"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " sessi=
on status: %d\t",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i, ses-=
>serverName, ses->serverDomain,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->se=
s_count, ses->serverOS, ses->serverNOS,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->ca=
pabilities, ses->status);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(m, "TCP status: %d\n\tLocal =
Users To "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Server: %d=
 SecMode: 0x%x Req On Wire: %d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server-=
>tcpStatus, server->srv_count,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 server-=
>sec_mode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_=
read(&server->inFlight));
> +
> +#ifdef CONFIG_CIFS_STATS2
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(m, " In Send: %d In MaxReq W=
ait: %d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_=
read(&server->inSend),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_=
read(&server->num_waiters));
> +#endif
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_puts(m, "\n\tShares:");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 j =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each(tmp3, &ses->tcon_list) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcon =3D list_entry(tmp=
3, struct cifs_tcon, tcon_list);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++j;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_type =3D le32_to_cp=
u(tcon->fsDevInfo.DeviceType);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(m, "\n\t%d) =
%s Mounts: %d ", j,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
tcon->treeName, tcon->tc_count);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tcon->nativeFileSys=
tem) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_pri=
ntf(m, "Type: %s ",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0tcon->nativeFileSystem);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(m, "DevInfo:=
 0x%x Attributes: 0x%x"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "\nPath=
ComponentMax: %d Status: 0x%d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le32_to=
_cpu(tcon->fsDevInfo.DeviceCharacteristics),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le32_to=
_cpu(tcon->fsAttrInfo.Attributes),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le32_to=
_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcon->t=
idStatus);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dev_type =3D=3D FIL=
E_DEVICE_DISK)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_put=
s(m, " type: DISK ");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (dev_type =3D=3D=
 FILE_DEVICE_CD_ROM)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_put=
s(m, " type: CDROM ");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_pri=
ntf(m, " type: %d ", dev_type);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tcon->need_reconnec=
t)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_put=
s(m, "\tDISCONNECTED ");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_putc(m, '\n');
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_puts(m, "\n\tMIDs:\n");
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each(tmp3, &server->pending_mi=
d_q) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry =3D list_entr=
y(tmp3, struct mid_q_entry, qhead);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(m, "\tState:=
 %d com: %d pid:"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 " %d cbdata: %p mid %d\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 mid_entry->midState,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 (int)mid_entry->command, mid_entry->pid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 mid_entry->callback_data,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 mid_entry->mid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_Lock);
> + =A0 =A0 =A0 }
> +}
> +
> +static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
> +{
> + =A0 =A0 =A0 struct list_head *tmp1;
> + =A0 =A0 =A0 struct TCP_Server_Info *server;
> + =A0 =A0 =A0 int i;
> +
> =A0 =A0 =A0 =A0seq_puts(m,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"Display Internal CIFS Data St=
ructures for Debugging\n"
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"-----------------------------=
----------------------\n");
> @@ -151,82 +238,10 @@ static int cifs_debug_data_proc_show(struct
> seq_file *m, void *v)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server =3D list_entry(tmp1, struct TCP=
_Server_Info,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
tcp_ses_list);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0i++;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each(tmp2, &server->smb_ses_li=
st) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses =3D list_entry(tmp2=
, struct cifs_ses,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0smb_ses_list);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((ses->serverDomain =
=3D=3D NULL) ||
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (ses->s=
erverOS =3D=3D NULL) ||
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (ses->s=
erverNOS =3D=3D NULL)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_pri=
ntf(m, "\n%d) entry for %s not fully "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0"displayed\n\t", i, ses->serverName);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_pri=
ntf(m,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 "\n%d) Name: %s =A0Domain: %s Uses: %d OS:"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 " %s\n\tNOS: %s\tCapability: 0x%x\n\tSMB"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 " session status: %d\t",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i, ses-=
>serverName, ses->serverDomain,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->se=
s_count, ses->serverOS, ses->serverNOS,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->ca=
pabilities, ses->status);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(m, "TCP stat=
us: %d\n\tLocal Users To "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
"Server: %d SecMode: 0x%x Req On Wire: %d",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
server->tcpStatus, server->srv_count,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
server->sec_mode,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
atomic_read(&server->inFlight));
> -
> -#ifdef CONFIG_CIFS_STATS2
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(m, " In Send=
: %d In MaxReq Wait: %d",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_=
read(&server->inSend),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_=
read(&server->num_waiters));
> -#endif
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_puts(m, "\n\tShares=
:");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 j =3D 0;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each(tmp3, &se=
s->tcon_list) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcon =3D=
 list_entry(tmp3, struct cifs_tcon,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcon_list);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++j;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_typ=
e =3D le32_to_cpu(tcon->fsDevInfo.DeviceType);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_pri=
ntf(m, "\n\t%d) %s Mounts: %d ", j,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0tcon->treeName, tcon->tc_count);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tco=
n->nativeFileSystem) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 seq_printf(m, "Type: %s ",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0tcon->nativeFileSystem);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_pri=
ntf(m, "DevInfo: 0x%x Attributes: 0x%x"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 "\nPathComponentMax: %d Status: 0x%d",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 le32_to_cpu(tcon->fsDevInfo.DeviceCharacteristics),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 le32_to_cpu(tcon->fsAttrInfo.Attributes),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 le32_to_cpu(tcon->fsAttrInfo.MaxPathNameComponentLength),
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 tcon->tidStatus);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dev=
_type =3D=3D FILE_DEVICE_DISK)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 seq_puts(m, " type: DISK ");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if=
 (dev_type =3D=3D FILE_DEVICE_CD_ROM)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 seq_puts(m, " type: CDROM ");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 seq_printf(m, " type: %d ", dev_type);
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (tco=
n->need_reconnect)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 seq_puts(m, "\tDISCONNECTED ");
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_put=
c(m, '\n');
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_puts(m, "\n\tMIDs:\=
n");
> -
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&GlobalMid_Lo=
ck);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_for_each(tmp3, &se=
rver->pending_mid_q) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_ent=
ry =3D list_entry(tmp3, struct mid_q_entry,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 qhead);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_pri=
ntf(m, "\tState: %d com: %d pid:"
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 " %d cbdata: %p mid %d\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->midState,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 (int)mid_entry->command,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->pid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->callback_data,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 mid_entry->mid);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&GlobalMid_=
Lock);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (server->is_smb2)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dump_smb2_debug_info(i,=
 m, server);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dump_cifs_debug_info(i,=
 m, server);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0spin_unlock(&cifs_tcp_ses_lock);

I suppose there would not be a smb2_tcp_ses_lock!
Also, although I have not see any issues, is it ok to take a spinlock
within a spinlock (GloablMid_Lock while holding cifs_tcp_ses_lock)?

> =A0 =A0 =A0 =A0seq_putc(m, '\n');
>
> --
> Thanks,
>
> Steve
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
