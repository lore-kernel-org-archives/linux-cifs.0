From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 5/5] CIFS: Move protocol specific tcon/tdis code to ops struct
Date: Tue, 19 Jun 2012 18:15:37 +0200
Message-ID: <CAH2r5mvw_AgcQpF59BLk2k74pAzKMma04Z6ZpkJRBdnA9w+YWg@mail.gmail.com>
References: <1339223164-9721-1-git-send-email-pshilovsky@samba.org>
	<1339223164-9721-6-git-send-email-pshilovsky@samba.org>
	<20120619085940.337536ed@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120619085940.337536ed-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The main debugging benefit I get from the xid is simply being able to
track in logs which operations I am looking at when running something
like dbench with lots of processes in parallel or even when one
process but log entries got lost. Pid isn't always as helpful since
log entries get dropped - it is not always clear which call is failing
when pid does multiple operations.   Quick modifications of other log
entries to add xid is pretty easy when the xid in a particular
important cFYI or cERROR is not clear in a complex trace.

On Tue, Jun 19, 2012 at 5:59 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Sat, =A09 Jun 2012 10:26:04 +0400
> Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
>
>> and rename variables around the code changes.
>>
>> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsglob.h =A0| =A0 =A06 ++++
>> =A0fs/cifs/cifsproto.h | =A0 =A05 +--
>> =A0fs/cifs/connect.c =A0 | =A0 71 ++++++++++++++++++++++++++++++----=
-----------------
>> =A0fs/cifs/smb1ops.c =A0 | =A0 =A02 +
>> =A04 files changed, 52 insertions(+), 32 deletions(-)
>>
>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> index 812f27c..1266e2e 100644
>> --- a/fs/cifs/cifsglob.h
>> +++ b/fs/cifs/cifsglob.h
>> @@ -160,6 +160,7 @@ struct mid_q_entry;
>> =A0struct TCP_Server_Info;
>> =A0struct cifsFileInfo;
>> =A0struct cifs_ses;
>> +struct cifs_tcon;
>>
>> =A0struct smb_version_operations {
>> =A0 =A0 =A0 int (*send_cancel)(struct TCP_Server_Info *, void *,
>> @@ -201,6 +202,11 @@ struct smb_version_operations {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_tab=
le *);
>> =A0 =A0 =A0 /* close smb session */
>> =A0 =A0 =A0 int (*logoff)(const int, struct cifs_ses *);
>> + =A0 =A0 /* connect to a server share */
>> + =A0 =A0 int (*tree_connect)(const int, struct cifs_ses *, const ch=
ar *,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_tcon *=
, const struct nls_table *);
>> + =A0 =A0 /* close tree connecion */
>> + =A0 =A0 int (*tree_disconnect)(const int, struct cifs_tcon *);
>> =A0};
>>
>> =A0struct smb_version_values {
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 8e6cd38..2f4f661 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -183,9 +183,8 @@ extern int cifs_setup_session(const int xid, str=
uct cifs_ses *ses,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct nls_t=
able *nls_info);
>> =A0extern int CIFSSMBNegotiate(const int xid, struct cifs_ses *ses);
>>
>> -extern int CIFSTCon(unsigned int xid, struct cifs_ses *ses,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *tree, struct c=
ifs_tcon *tcon,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *);
>> +extern int CIFSTCon(const int xid, struct cifs_ses *ses, const char=
 *tree,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_tcon *tcon, const stru=
ct nls_table *);
>>
>> =A0extern int CIFSFindFirst(const int xid, struct cifs_tcon *tcon,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *searchName, const struct nls=
_table *nls_codepage,
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 9679352..d14bd45 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -2552,7 +2552,8 @@ cifs_put_tcon(struct cifs_tcon *tcon)
>> =A0 =A0 =A0 spin_unlock(&cifs_tcp_ses_lock);
>>
>> =A0 =A0 =A0 xid =3D GetXid();
>> - =A0 =A0 CIFSSMBTDis(xid, tcon);
>> + =A0 =A0 if (ses->server->ops->tree_disconnect)
>> + =A0 =A0 =A0 =A0 =A0 =A0 ses->server->ops->tree_disconnect(xid, tco=
n);
>> =A0 =A0 =A0 _FreeXid(xid);
>>
>> =A0 =A0 =A0 cifs_fscache_release_super_cookie(tcon);
>> @@ -2577,6 +2578,11 @@ cifs_get_tcon(struct cifs_ses *ses, struct sm=
b_vol *volume_info)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return tcon;
>> =A0 =A0 =A0 }
>>
>> + =A0 =A0 if (!ses->server->ops->tree_connect) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOSYS;
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out_fail;
>> + =A0 =A0 }
>> +
>> =A0 =A0 =A0 tcon =3D tconInfoAlloc();
>> =A0 =A0 =A0 if (tcon =3D=3D NULL) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> @@ -2599,13 +2605,15 @@ cifs_get_tcon(struct cifs_ses *ses, struct s=
mb_vol *volume_info)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_fail;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 /* BB Do we need to wrap session_mutex around
>> - =A0 =A0 =A0* this TCon call and Unix SetFS as
>> - =A0 =A0 =A0* we do on SessSetup and reconnect? */
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* BB Do we need to wrap session_mutex around this TCon =
call and Unix
>> + =A0 =A0 =A0* SetFS as we do on SessSetup and reconnect?
>> + =A0 =A0 =A0*/
>> =A0 =A0 =A0 xid =3D GetXid();
>> - =A0 =A0 rc =3D CIFSTCon(xid, ses, volume_info->UNC, tcon, volume_i=
nfo->local_nls);
>> + =A0 =A0 rc =3D ses->server->ops->tree_connect(xid, ses, volume_inf=
o->UNC, tcon,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 volume_info->local_nls);
>> =A0 =A0 =A0 FreeXid(xid);
>> - =A0 =A0 cFYI(1, "CIFS Tcon rc =3D %d", rc);
>> + =A0 =A0 cFYI(1, "Tcon rc =3D %d", rc);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_fail;
>>
>> @@ -2614,10 +2622,11 @@ cifs_get_tcon(struct cifs_ses *ses, struct s=
mb_vol *volume_info)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "DFS disabled (%d)", tcon->Flags=
);
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 tcon->seal =3D volume_info->seal;
>> - =A0 =A0 /* we can have only one retry value for a connection
>> - =A0 =A0 =A0 =A0to a share so for resources mounted more than once
>> - =A0 =A0 =A0 =A0to the same server share the last value passed in
>> - =A0 =A0 =A0 =A0for the retry flag is used */
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* We can have only one retry value for a connection to =
a share so for
>> + =A0 =A0 =A0* resources mounted more than once to the same server s=
hare the last
>> + =A0 =A0 =A0* value passed in for the retry flag is used.
>> + =A0 =A0 =A0*/
>> =A0 =A0 =A0 tcon->retry =3D volume_info->retry;
>> =A0 =A0 =A0 tcon->nocase =3D volume_info->nocase;
>> =A0 =A0 =A0 tcon->local_lease =3D volume_info->local_lease;
>> @@ -2751,37 +2760,41 @@ out:
>> =A0}
>>
>> =A0int
>> -get_dfs_path(int xid, struct cifs_ses *pSesInfo, const char *old_pa=
th,
>> - =A0 =A0 =A0 =A0 =A0const struct nls_table *nls_codepage, unsigned =
int *pnum_referrals,
>> - =A0 =A0 =A0 =A0 =A0struct dfs_info3_param **preferrals, int remap)
>> +get_dfs_path(int xid, struct cifs_ses *ses, const char *old_path,
>> + =A0 =A0 =A0 =A0 =A0const struct nls_table *nls_codepage, unsigned =
int *num_referrals,
>> + =A0 =A0 =A0 =A0 =A0struct dfs_info3_param **referrals, int remap)
>> =A0{
>> =A0 =A0 =A0 char *temp_unc;
>> =A0 =A0 =A0 int rc =3D 0;
>>
>> - =A0 =A0 *pnum_referrals =3D 0;
>> - =A0 =A0 *preferrals =3D NULL;
>> + =A0 =A0 if (!ses->server->ops->tree_connect)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOSYS;
>> +
>> + =A0 =A0 *num_referrals =3D 0;
>> + =A0 =A0 *referrals =3D NULL;
>>
>> - =A0 =A0 if (pSesInfo->ipc_tid =3D=3D 0) {
>> + =A0 =A0 if (ses->ipc_tid =3D=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp_unc =3D kmalloc(2 /* for slashes */=
 +
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strnlen(pSesInfo->serverNa=
me,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SERVER_NAM=
E_LEN_WITH_NULL * 2)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+ 1 + 4=
 /* slash IPC$ */ =A0+ 2,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 GFP_KERNEL=
);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strnlen(ses->serverName, S=
ERVER_NAME_LEN_WITH_NULL * 2)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 + 1 + 4 /*=
 slash IPC$ */ + 2, GFP_KERNEL);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (temp_unc =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp_unc[0] =3D '\\';
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 temp_unc[1] =3D '\\';
>> - =A0 =A0 =A0 =A0 =A0 =A0 strcpy(temp_unc + 2, pSesInfo->serverName)=
;
>> - =A0 =A0 =A0 =A0 =A0 =A0 strcpy(temp_unc + 2 + strlen(pSesInfo->ser=
verName), "\\IPC$");
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSTCon(xid, pSesInfo, temp_unc, N=
ULL, nls_codepage);
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "CIFS Tcon rc =3D %d ipc_tid =3D %=
d", rc, pSesInfo->ipc_tid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 strcpy(temp_unc + 2, ses->serverName);
>> + =A0 =A0 =A0 =A0 =A0 =A0 strcpy(temp_unc + 2 + strlen(ses->serverNa=
me), "\\IPC$");
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D ses->server->ops->tree_connect(xid,=
 ses, temp_unc, NULL,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nls_codepage);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Tcon rc =3D %d ipc_tid =3D %d", r=
c, ses->ipc_tid);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(temp_unc);
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 if (rc =3D=3D 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSGetDFSRefer(xid, pSesInfo, old_=
path, preferrals,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
pnum_referrals, nls_codepage, remap);
>> - =A0 =A0 /* BB map targetUNCs to dfs_info3 structures, here or
>> - =A0 =A0 =A0 =A0 =A0 =A0 in CIFSGetDFSRefer BB */
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSGetDFSRefer(xid, ses, old_path,=
 referrals,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
num_referrals, nls_codepage, remap);
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* BB - map targetUNCs to dfs_info3 structures, here or =
in
>> + =A0 =A0 =A0* CIFSGetDFSRefer.
>> + =A0 =A0 =A0*/
>>
>> =A0 =A0 =A0 return rc;
>> =A0}
>> @@ -3758,7 +3771,7 @@ out:
>> =A0 * pointer may be NULL.
>> =A0 */
>> =A0int
>> -CIFSTCon(unsigned int xid, struct cifs_ses *ses,
>> +CIFSTCon(const int xid, struct cifs_ses *ses,
>> =A0 =A0 =A0 =A0const char *tree, struct cifs_tcon *tcon,
>> =A0 =A0 =A0 =A0const struct nls_table *nls_codepage)
>> =A0{
>> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
>> index ba3071f..1a3f08c 100644
>> --- a/fs/cifs/smb1ops.c
>> +++ b/fs/cifs/smb1ops.c
>> @@ -432,6 +432,8 @@ struct smb_version_operations smb1_operations =3D=
 {
>> =A0 =A0 =A0 .negotiate =3D cifs_negotiate,
>> =A0 =A0 =A0 .sess_setup =3D CIFS_SessSetup,
>> =A0 =A0 =A0 .logoff =3D CIFSSMBLogoff,
>> + =A0 =A0 .tree_connect =3D CIFSTCon,
>> + =A0 =A0 .tree_disconnect =3D CIFSSMBTDis,
>> =A0};
>>
>> =A0struct smb_version_values smb1_values =3D {
>
> Looks fine other than the type change on the xid. Note too, that if y=
ou
> wanted to just remove all of that xid stuff, I'd be even happier. Ste=
ve
> seems to like it for some reason though, so we'll need to convince hi=
m.
>
> IMO, it's just unnecessary clutter that gets in the way of the code
> clarity. It's also very unclear that FreeXid() has a side effect (a
> debug printk).
>
> A better scheme would be to turn all of those FreeXid calls into an
> explict cFYI that prints the name of the function and maybe the retur=
n
> code. The xid could be replaced with current->pid, which would
> eliminate GetXid.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Thanks,

Steve
