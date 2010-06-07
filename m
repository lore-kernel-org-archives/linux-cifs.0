From: Jeff Layton <jlayton@samba.org>
Subject: Re: [linux-cifs-client] [PATCH] cifs: hard mount option behaviour
 implementation
Date: Mon, 7 Jun 2010 15:55:24 -0400
Message-ID: <20100607155524.73890d24@corrin.poochiereds.net>
References: <1275755825-6504-1-git-send-email-shirishpargaonkar@gmail.com>
	<20100606065124.065db32a@tlielax.poochiereds.net>
	<AANLkTimQ_KsvuJl25WI9E9KK2HxYyMUU9nzMi0wScheN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org
To: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <AANLkTimQ_KsvuJl25WI9E9KK2HxYyMUU9nzMi0wScheN@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Mon, 7 Jun 2010 14:26:50 -0500
Shirish Pargaonkar <shirishpargaonkar@gmail.com> wrote:

> On Sun, Jun 6, 2010 at 5:51 AM, Jeff Layton <jlayton@samba.org> wrote=
:
> > On Sat, =A05 Jun 2010 11:37:05 -0500
> > shirishpargaonkar@gmail.com wrote:
> >
> >> Add support for hard mount option by using -o hard.
> >>
> >> Current cifs behaviour amounts to that of a soft mount.
> >> If a response for a command does not arrive within a certain timeo=
ut,
> >> server is considered non-responsive and a reconnect is attempted.
> >> Commands/requests are returned with error for an app to decide.
> >>
> >> This code change adds hard mount option behaviour.
> >> A command waits in interruptible wait timing out every 60 seconds
> >> to log a debug message about server not responding and going
> >> back on interruptible wait queue for another 60 seconds.
> >> Once response arrives, a debug messages is logged that server is
> >> responding.
> >> An user has an option to interrupt a program if a response has not
> >> arrived for long enough for user to deem a dead server and retry
> >> the program.
> >> This takes care of unnecessary reconnects and subsequent retries
> >> of numerous commands for invalidated file handles etc. when either
> >> the server or client is stressed or slow.
> >>
> >> These commands such as negotiate, session setup, tree connect,
> >> logoff, non-blocking posix lock, and dfs referral are always soft.
> >>
> >>
> >
> > Looks like a step in the right direction. I think this will help br=
ing
> > better data integrity to CIFS. We really need to strive to minimize
> > reconnects since they are so costly and you lose things like file
> > locks, etc...
> >
> > Comments inline below:
> >
> >> From b1b0a7b1612dc3d865b4756dfddceeab4245a888 Mon Sep 17 00:00:00 =
2001
> >> From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
> >> Date: Sat, 5 Jun 2010 10:01:06 -0500
> >> Subject: [PATCH] add support for implementing hard mount option be=
haviour
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
> >> ---
> >> =A0fs/cifs/cifsproto.h | =A0 =A07 ++-
> >> =A0fs/cifs/cifssmb.c =A0 | =A0126 +++++++++++++++++++++++++++-----=
------------------
> >> =A0fs/cifs/connect.c =A0 | =A0 =A05 ++-
> >> =A0fs/cifs/sess.c =A0 =A0 =A0| =A0 =A02 +-
> >> =A0fs/cifs/transport.c | =A0 62 ++++++++++++++++++++++---
> >> =A05 files changed, 132 insertions(+), 70 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> >> index fb1657e..7a475c5 100644
> >> --- a/fs/cifs/cifsproto.h
> >> +++ b/fs/cifs/cifsproto.h
> >> @@ -63,12 +63,13 @@ extern char *cifs_compose_mount_options(const =
char *sb_mountdata,
> >> =A0extern int SendReceive(const unsigned int /* xid */ , struct ci=
fsSesInfo *,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_hdr * /* in=
put */ ,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_hdr * /* ou=
t */ ,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int * /* bytes returned =
*/ , const int long_op);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int * /* bytes returned =
*/ , const int long_op, bool);
> >> =A0extern int SendReceiveNoRsp(const unsigned int xid, struct cifs=
SesInfo *ses,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_hdr *in_buf, =
int flags);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_hdr *in_buf, =
int flags, bool hard_mount);
> >> =A0extern int SendReceive2(const unsigned int /* xid */ , struct c=
ifsSesInfo *,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct kvec *, int /* =
nvec to send */,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int * /* type of buf ret=
urned */ , const int flags);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int * /* type of buf ret=
urned */ , const int flags,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bool);
> >> =A0extern int SendReceiveBlockingLock(const unsigned int xid,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsTconInfo *p=
tcon,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct smb_hdr *in_buf=
 ,
> >> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> >> index c65c341..2634354 100644
> >> --- a/fs/cifs/cifssmb.c
> >> +++ b/fs/cifs/cifssmb.c
> >> @@ -404,7 +404,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs=
SesInfo *ses)
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, ses, (struct smb_hdr *) pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, false);
> >> =A0 =A0 =A0 if (rc !=3D 0)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto neg_err_exit;
> >>
> >> @@ -678,7 +678,7 @@ CIFSSMBTDis(const int xid, struct cifsTconInfo=
 *tcon)
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> >>
> >> - =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, smb_buffer, 0);
> >> + =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, smb_buffer, 0, t=
con->retry);
> >
> >
> > I know that this parameter predates your patch, but I'm not sure th=
at
> > the "retry" option ought to hang off of the tcon. I think it should
> > hang off of the superblock instead. It ought to be possible for som=
eone
> > to mount the same share with both hard and soft options simultaneou=
sly.
> >
> > In fact, the default timeout for soft mounts ought to be tunable as=
 well.
> > What may be best is to add a "call timeout" field to the superblock=
 and
> > set that to '0' for hard mounts and then drop the "retry" parm on t=
he
> > tcon.
>=20
> I can do that.  Does that mean adding a new mount option like timeo
> which does not apply to hard mounts but only to soft mounts and if on=
e is not
> specified for (default) soft mounts, come up with a default timeout v=
alue?

I think so, yes. "timeo" would be a good choice. There will clearly be
a difference though from how this parm works with NFS. SMB is not RPC,
so we don't really need to retransmit like RPC does.

> That means invalidating this existing logic (in fs/cifs/transport.c)?
>=20
>         if (long_op =3D=3D CIFS_STD_OP)
>                 timeout =3D 15 * HZ;
>         /* wait for 15 seconds or until woken up due to response arri=
ving or
>            due to last connection to this server being unmounted */
>         else if (long_op =3D=3D CIFS_ASYNC_OP)
>                 goto out;
>         else if (long_op =3D=3D CIFS_VLONG_OP) /* writes past EOF can=
 be slow */
>                 timeout =3D 180 * HZ;
>         else if (long_op =3D=3D CIFS_LONG_OP)
>                 timeout =3D 45 * HZ; /* should be greater than
>                         servers oplock break timeout (about 43 second=
s) */
>         else if (long_op =3D=3D CIFS_BLOCKING_OP)
>                 timeout =3D 0x7FFFFFFF; /* large but no so large as t=
o wrap */
>         else {
>                 cERROR(1, "unknown timeout flag %d", long_op);
>                 rc =3D -EIO;
>                 goto out;
>         }
>=20
> We do not really need a timeout value for hard mounts, the timeout
> value used in hard mount
> is only to wake up and log a message if response has not arrived.
>=20

Yes, probably so.

It may be worthwhile to step back from the existing code and give this
a hard rethink from first principles.

What's the real purpose in having timeouts at all? Once the server has
ACK'ed the TCP packet we know that it has been received. It seems
really silly to break the connection at that point just because it gets
bogged down while servicing the request.

We ought to be going to great lengths to *avoid* breaking the
connection whenever possible as so much of the state is tied up with
the state of the socket.

> >
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Tree disconnect failed %d", r=
c);
> >>
> >> @@ -725,7 +725,7 @@ CIFSSMBLogoff(const int xid, struct cifsSesInf=
o *ses)
> >> =A0 =A0 =A0 pSMB->hdr.Uid =3D ses->Suid;
> >>
> >> =A0 =A0 =A0 pSMB->AndXCommand =3D 0xFF;
> >> - =A0 =A0 rc =3D SendReceiveNoRsp(xid, ses, (struct smb_hdr *) pSM=
B, 0);
> >> + =A0 =A0 rc =3D SendReceiveNoRsp(xid, ses, (struct smb_hdr *) pSM=
B, 0, false);
> >> =A0session_already_dead:
> >> =A0 =A0 =A0 mutex_unlock(&ses->session_mutex);
> >>
> >> @@ -799,7 +799,7 @@ PsxDelete:
> >> =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pSMBr, &bytes_returne=
d, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Posix delete returned %d", rc=
);
> >> =A0 =A0 =A0 cifs_buf_release(pSMB);
> >> @@ -845,7 +845,7 @@ DelFileRetry:
> >> =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D name_len + 1;
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(name_len + 1);
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pSMBr, &bytes_returne=
d, 0, tcon->retry);
> >> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_deletes);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Error in RMFile =3D %d", rc);
> >> @@ -889,7 +889,7 @@ RmDirRetry:
> >> =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D name_len + 1;
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(name_len + 1);
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pSMBr, &bytes_returne=
d, 0, tcon->retry);
> >> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_rmdirs);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Error in RMDir =3D %d", rc);
> >> @@ -932,7 +932,7 @@ MkDirRetry:
> >> =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D name_len + 1;
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(name_len + 1);
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_mkdirs);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Error in Mkdir =3D %d", rc);
> >> @@ -1010,7 +1010,7 @@ PsxCreat:
> >> =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Posix create returned %d", rc=
);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto psx_create_err;
> >> @@ -1177,7 +1177,8 @@ OldOpenRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(count);
> >> =A0 =A0 =A0 /* long_op set to 1 to allow for oplock break timeouts=
 */
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *)pSMBr,=
 &bytes_returned, CIFS_LONG_OP);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *)pSMBr, &bytes_returned=
, CIFS_LONG_OP,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 tcon->retry);
> >> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_opens);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Error in Open =3D %d", rc);
> >> @@ -1290,7 +1291,8 @@ openRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(count);
> >> =A0 =A0 =A0 /* long_op set to 1 to allow for oplock break timeouts=
 */
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *)pSMBr,=
 &bytes_returned, CIFS_LONG_OP);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *)pSMBr, &bytes_returned=
, CIFS_LONG_OP,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 tcon->retry);
> >> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_opens);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Error in Open =3D %d", rc);
> >> @@ -1372,7 +1374,7 @@ CIFSSMBRead(const int xid, struct cifsTconIn=
fo *tcon, const int netfid,
> >> =A0 =A0 =A0 iov[0].iov_base =3D (char *)pSMB;
> >> =A0 =A0 =A0 iov[0].iov_len =3D pSMB->hdr.smb_buf_length + 4;
> >> =A0 =A0 =A0 rc =3D SendReceive2(xid, tcon->ses, iov, 1 /* num iove=
cs */,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&resp_buf_type, CIFS_=
STD_OP | CIFS_LOG_ERROR);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0&resp_buf_type, CIFS_STD_OP | CIFS_LO=
G_ERROR, tcon->retry);
> >> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_reads);
> >> =A0 =A0 =A0 pSMBr =3D (READ_RSP *)iov[0].iov_base;
> >> =A0 =A0 =A0 if (rc) {
> >> @@ -1516,7 +1518,8 @@ CIFSSMBWrite(const int xid, struct cifsTconI=
nfo *tcon,
> >> =A0 =A0 =A0 }
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, long_op);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pSMBr, &bytes_returne=
d, long_op,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 tcon->retry);
> >> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_writes);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in write =3D %d", =
rc);
> >> @@ -1608,7 +1611,7 @@ CIFSSMBWrite2(const int xid, struct cifsTcon=
Info *tcon,
> >>
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive2(xid, tcon->ses, iov, n_vec + 1, &r=
esp_buf_type,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 long_op);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 long_op, tcon->retry=
);
> >> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_writes);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error Write2 =3D %d", rc=
);
> >> @@ -1699,7 +1702,7 @@ CIFSSMBLock(const int xid, struct cifsTconIn=
fo *tcon,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_small_buf_release(pSMB);
> >> =A0 =A0 =A0 } else {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses=
, (struct smb_hdr *)pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 timeout);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 timeout, tcon->retry);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* SMB buffer freed by function above =
*/
> >> =A0 =A0 =A0 }
> >> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_locks);
> >> @@ -1790,7 +1793,7 @@ CIFSSMBPosixLock(const int xid, struct cifsT=
conInfo *tcon,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[0].iov_base =3D (char *)pSMB;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[0].iov_len =3D pSMB->hdr.smb_buf_l=
ength + 4;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D SendReceive2(xid, tcon->ses, io=
v, 1 /* num iovecs */,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &resp_bu=
f_type, timeout);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &resp_bu=
f_type, timeout, false);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB =3D NULL; /* request buf already =
freed by SendReceive2. Do
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 not tr=
y to free it twice below on exit */
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMBr =3D (struct smb_com_transaction2=
_sfi_rsp *)iov[0].iov_base;
> >> @@ -1866,7 +1869,8 @@ CIFSSMBClose(const int xid, struct cifsTconI=
nfo *tcon, int smb_file_id)
> >> =A0 =A0 =A0 pSMB->FileID =3D (__u16) smb_file_id;
> >> =A0 =A0 =A0 pSMB->LastWriteTime =3D 0xFFFFFFFF;
> >> =A0 =A0 =A0 pSMB->ByteCount =3D 0;
> >> - =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr =
*) pSMB, 0);
> >> + =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr =
*) pSMB, 0,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcon->re=
try);
> >> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_closes);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc !=3D -EINTR) {
> >> @@ -1895,7 +1899,8 @@ CIFSSMBFlush(const int xid, struct cifsTconI=
nfo *tcon, int smb_file_id)
> >>
> >> =A0 =A0 =A0 pSMB->FileID =3D (__u16) smb_file_id;
> >> =A0 =A0 =A0 pSMB->ByteCount =3D 0;
> >> - =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr =
*) pSMB, 0);
> >> + =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr =
*) pSMB, 0,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcon->re=
try);
> >> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_flushes);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Send error in Flush =3D %d"=
, rc);
> >> @@ -1958,7 +1963,7 @@ renameRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_renames);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in rename =3D %d",=
 rc);
> >> @@ -2037,7 +2042,7 @@ int CIFSSMBRenameOpenFile(const int xid, str=
uct cifsTconInfo *pTcon,
> >> =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, pTcon->ses, (struct smb_hdr *)=
 pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, pTcon->retry);
> >> =A0 =A0 =A0 cifs_stats_inc(&pTcon->num_t2renames);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in Rename (by file=
 handle) =3D %d", rc);
> >> @@ -2105,7 +2110,7 @@ copyRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pSMBr, &bytes_returne=
d, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pSMBr, &bytes_returne=
d, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in copy =3D %d wit=
h %d files copied",
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc, le16_to_cpu(pSMBr-=
>CopyCount));
> >> @@ -2194,7 +2199,7 @@ createSymLinkRetry:
> >> =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_symlinks);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in SetPathInfo cre=
ate symlink =3D %d", rc);
> >> @@ -2280,7 +2285,7 @@ createHardLinkRetry:
> >> =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_hardlinks);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in SetPathInfo (ha=
rd link) =3D %d", rc);
> >> @@ -2352,7 +2357,7 @@ winCreateHardLinkRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_hardlinks);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in hard link (NT r=
ename) =3D %d", rc);
> >> @@ -2423,7 +2428,7 @@ querySymLinkRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in QuerySymLinkInf=
o =3D %d", rc);
> >> =A0 =A0 =A0 } else {
> >> @@ -2586,7 +2591,7 @@ CIFSSMBQueryReparseLinkInfo(const int xid, s=
truct cifsTconInfo *tcon,
> >> =A0 =A0 =A0 pSMB->ByteCount =3D 0;
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in QueryReparseLin=
kInfo =3D %d", rc);
> >> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> >> @@ -2849,7 +2854,7 @@ queryAclRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pSMBr, &bytes_returne=
d, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pSMBr, &bytes_returne=
d, 0, tcon->retry);
> >> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_acl_get);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in Query POSIX ACL=
 =3D %d", rc);
> >> @@ -2942,7 +2947,7 @@ setAclRetry:
> >> =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Set POSIX ACL returned %d", r=
c);
> >>
> >> @@ -3001,7 +3006,7 @@ GetExtAttrRetry:
> >> =A0 =A0 =A0 pSMB->t2.ByteCount =3D cpu_to_le16(byte_count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "error %d in GetExtAttr", rc);
> >> =A0 =A0 =A0 } else {
> >> @@ -3070,7 +3075,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifs=
TconInfo *tcon, __u16 fid,
> >> =A0 =A0 =A0 iov[0].iov_len =3D pSMB->hdr.smb_buf_length + 4;
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive2(xid, tcon->ses, iov, 1 /* num iove=
c */, &buf_type,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_STD_OP);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_STD_OP, tcon->re=
try);
> >> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_acl_get);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in QuerySecDesc =3D=
 %d", rc);
> >> @@ -3182,7 +3187,7 @@ setCifsAclRetry:
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_cou=
nt;
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pSMBr, &bytes_returne=
d, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pSMBr, &bytes_returne=
d, 0, tcon->retry);
> >>
> >> =A0 =A0 =A0 cFYI(1, "SetCIFSACL bytes_returned: %d, rc: %d", bytes=
_returned, rc);
> >> =A0 =A0 =A0 if (rc)
> >> @@ -3234,7 +3239,7 @@ QInfRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(name_len);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in QueryInfo =3D %=
d", rc);
> >> =A0 =A0 =A0 } else if (pFinfo) {
> >> @@ -3308,7 +3313,7 @@ QFileInfoRetry:
> >> =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in QPathInfo =3D %=
d", rc);
> >> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> >> @@ -3396,7 +3401,7 @@ QPathInfoRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in QPathInfo =3D %=
d", rc);
> >> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> >> @@ -3476,7 +3481,7 @@ UnixQFileInfoRetry:
> >> =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in QPathInfo =3D %=
d", rc);
> >> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> >> @@ -3562,7 +3567,7 @@ UnixQPathInfoRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in QPathInfo =3D %=
d", rc);
> >> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> >> @@ -3676,7 +3681,7 @@ findFirstRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_ffirst);
> >>
> >> =A0 =A0 =A0 if (rc) {/* BB add logic to retry regular search if Un=
ix search
> >> @@ -3805,7 +3810,7 @@ int CIFSFindNext(const int xid, struct cifsT=
conInfo *tcon,
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pSMBr=
, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pSMBr, &bytes_returne=
d, 0, tcon->retry);
> >> =A0 =A0 =A0 cifs_stats_inc(&tcon->num_fnext);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D -EBADF) {
> >> @@ -3894,7 +3899,8 @@ CIFSFindClose(const int xid, struct cifsTcon=
Info *tcon,
> >>
> >> =A0 =A0 =A0 pSMB->FileID =3D searchHandle;
> >> =A0 =A0 =A0 pSMB->ByteCount =3D 0;
> >> - =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr =
*) pSMB, 0);
> >> + =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr =
*) pSMB, 0,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcon->re=
try);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Send error in FindClose =3D=
 %d", rc);
> >>
> >> @@ -3967,7 +3973,7 @@ GetInodeNumberRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pSMBr, &bytes_returne=
d, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pSMBr, &bytes_returne=
d, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "error %d in QueryInternalInfo=
", rc);
> >> =A0 =A0 =A0 } else {
> >> @@ -4191,7 +4197,7 @@ getDFSRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, ses, (struct smb_hdr *) pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, false);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in GetDFSRefer =3D=
 %d", rc);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto GetDFSRefExit;
> >> @@ -4265,7 +4271,7 @@ oldQFSInfoRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pSMBr, &bytes_returne=
d, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *) pSMBr, &bytes_returne=
d, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in QFSInfo =3D %d"=
, rc);
> >> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> >> @@ -4344,7 +4350,7 @@ QFSInfoRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in QFSInfo =3D %d"=
, rc);
> >> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> >> @@ -4424,7 +4430,7 @@ QFSAttributeRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Send error in QFSAttributeI=
nfo =3D %d", rc);
> >> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> >> @@ -4495,7 +4501,7 @@ QFSDeviceRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in QFSDeviceInfo =3D=
 %d", rc);
> >> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> >> @@ -4564,7 +4570,7 @@ QFSUnixRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Send error in QFSUnixInfo =3D=
 %d", rc);
> >> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> >> @@ -4647,7 +4653,7 @@ SETFSUnixRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Send error in SETFSUnixInfo=
 =3D %d", rc);
> >> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> >> @@ -4709,7 +4715,7 @@ QFSPosixRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in QFSUnixInfo =3D=
 %d", rc);
> >> =A0 =A0 =A0 } else { =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* decode resp=
onse */
> >> @@ -4835,7 +4841,7 @@ SetEOFRetry:
> >> =A0 =A0 =A0 parm_data->FileSize =3D cpu_to_le64(size);
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "SetPathInfo (file size) retur=
ned %d", rc);
> >>
> >> @@ -4915,7 +4921,8 @@ CIFSSMBSetFileSize(const int xid, struct cif=
sTconInfo *tcon, __u64 size,
> >> =A0 =A0 =A0 pSMB->Reserved4 =3D 0;
> >> =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >> - =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr =
*) pSMB, 0);
> >> + =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr =
*) pSMB, 0,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcon->re=
try);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in SetFileInfo (Se=
tFileSize) =3D %d", rc);
> >> =A0 =A0 =A0 }
> >> @@ -4984,7 +4991,8 @@ CIFSSMBSetFileInfo(const int xid, struct cif=
sTconInfo *tcon,
> >> =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >> =A0 =A0 =A0 memcpy(data_offset, data, sizeof(FILE_BASIC_INFO));
> >> - =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr =
*) pSMB, 0);
> >> + =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr =
*) pSMB, 0,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcon->re=
try);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in Set Time (SetFi=
leInfo) =3D %d", rc);
> >>
> >> @@ -5043,7 +5051,8 @@ CIFSSMBSetFileDisposition(const int xid, str=
uct cifsTconInfo *tcon,
> >> =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >> =A0 =A0 =A0 *data_offset =3D delete_file ? 1 : 0;
> >> - =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr =
*) pSMB, 0);
> >> + =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr =
*) pSMB, 0,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcon->re=
try);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in SetFileDisposit=
ion =3D %d", rc);
> >>
> >> @@ -5117,7 +5126,7 @@ SetTimesRetry:
> >> =A0 =A0 =A0 memcpy(data_offset, data, sizeof(FILE_BASIC_INFO));
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "SetPathInfo (times) returned =
%d", rc);
> >>
> >> @@ -5275,7 +5284,8 @@ CIFSSMBUnixSetFileInfo(const int xid, struct=
 cifsTconInfo *tcon,
> >>
> >> =A0 =A0 =A0 cifs_fill_unix_set_info(data_offset, args);
> >>
> >> - =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr =
*) pSMB, 0);
> >> + =A0 =A0 rc =3D SendReceiveNoRsp(xid, tcon->ses, (struct smb_hdr =
*) pSMB, 0,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tcon->re=
try);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in Set Time (SetFi=
leInfo) =3D %d", rc);
> >>
> >> @@ -5352,7 +5362,7 @@ setPermsRetry:
> >>
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "SetPathInfo (perms) returned =
%d", rc);
> >>
> >> @@ -5404,8 +5414,8 @@ int CIFSSMBNotify(const int xid, struct cifs=
TconInfo *tcon,
> >> =A0 =A0 =A0 pSMB->ByteCount =3D 0;
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *)pSM=
Br, &bytes_returned,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_ASYNC_OP);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 (struct smb_hdr *)pSMBr, &bytes_returned=
, CIFS_ASYNC_OP,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 tcon->retry);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Error in Notify =3D %d", rc);
> >> =A0 =A0 =A0 } else {
> >> @@ -5508,7 +5518,7 @@ QAllEAsRetry:
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Send error in QueryAllEAs =3D=
 %d", rc);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto QAllEAsOut;
> >> @@ -5720,7 +5730,7 @@ SetEARetry:
> >> =A0 =A0 =A0 pSMB->hdr.smb_buf_length +=3D byte_count;
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(byte_count);
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) =
pSMB,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pS=
MBr, &bytes_returned, 0);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(struct smb_hdr *) pSMBr, &bytes_retu=
rned, 0, tcon->retry);
> >> =A0 =A0 =A0 if (rc)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "SetPathInfo (EA) returned %d"=
, rc);
> >>
> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> index 2208f06..7ddc602 100644
> >> --- a/fs/cifs/connect.c
> >> +++ b/fs/cifs/connect.c
> >> @@ -1809,6 +1809,9 @@ cifs_get_tcon(struct cifsSesInfo *ses, struc=
t smb_vol *volume_info)
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> >> =A0 =A0 =A0 }
> >>
> >> + =A0 =A0 if (volume_info->retry)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 tcon->retry =3D volume_info->retry;
> >> +
> >> =A0 =A0 =A0 if (strchr(volume_info->UNC + 3, '\\') =3D=3D NULL
> >> =A0 =A0 =A0 =A0 =A0 && strchr(volume_info->UNC + 3, '/') =3D=3D NU=
LL) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Missing share name");
> >> @@ -2807,7 +2810,7 @@ CIFSTCon(unsigned int xid, struct cifsSesInf=
o *ses,
> >> =A0 =A0 =A0 pSMB->ByteCount =3D cpu_to_le16(count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive(xid, ses, smb_buffer, smb_buffer_re=
sponse, &length,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_STD_OP);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_STD_OP, false);
> >>
> >> =A0 =A0 =A0 /* above now done in SendReceive */
> >> =A0 =A0 =A0 if ((rc =3D=3D 0) && (tcon !=3D NULL)) {
> >> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> >> index 7707389..ff0dfb7 100644
> >> --- a/fs/cifs/sess.c
> >> +++ b/fs/cifs/sess.c
> >> @@ -866,7 +866,7 @@ ssetup_ntlmssp_authenticate:
> >> =A0 =A0 =A0 BCC_LE(smb_buf) =3D cpu_to_le16(count);
> >>
> >> =A0 =A0 =A0 rc =3D SendReceive2(xid, ses, iov, 3 /* num_iovecs */,=
 &resp_buf_type,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_STD_OP /* not l=
ong */ | CIFS_LOG_ERROR);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_STD_OP /* not long */ | CIFS_LO=
G_ERROR, false);
> >> =A0 =A0 =A0 /* SMB request buf freed in SendReceive2 */
> >>
> >> =A0 =A0 =A0 cFYI(1, "ssetup rc from sendrecv2 is %d", rc);
> >> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> >> index 82f78c4..0c7a07e 100644
> >> --- a/fs/cifs/transport.c
> >> +++ b/fs/cifs/transport.c
> >> @@ -311,6 +311,44 @@ static int allocate_mid(struct cifsSesInfo *s=
es, struct smb_hdr *in_buf,
> >> =A0 =A0 =A0 return 0;
> >> =A0}
> >>
> >> +static int
> >> +wait_for_response_hard(struct cifsSesInfo *ses, struct mid_q_entr=
y *midQ)
> >> +{
> >> + =A0 =A0 int rc;
> >> + =A0 =A0 bool cmdresp =3D true;
> >> + =A0 =A0 unsigned long timeout =3D 60 * HZ;
> >> + =A0 =A0 unsigned long curr_timeout;
> >> +
> >> +wait_again:
> >> + =A0 =A0 curr_timeout =3D timeout + jiffies;
> >> + =A0 =A0 rc =3D wait_event_interruptible_timeout(ses->server->res=
ponse_q,
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (midQ->midState !=3D MID=
_REQUEST_SUBMITTED), timeout);
> >> +
> >> + =A0 =A0 if (rc < 0) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "command 0x%x interrupted", midQ=
->command);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> >> + =A0 =A0 }
> >> + =A0 =A0 if (!time_before(jiffies, curr_timeout)) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 cmdresp =3D false;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "server not responding...");
> >> + =A0 =A0 =A0 =A0 =A0 =A0 goto wait_again;
> >> + =A0 =A0 }
> >> + =A0 =A0 spin_lock(&GlobalMid_Lock);
> >> + =A0 =A0 if (midQ->midState !=3D MID_REQUEST_SUBMITTED) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (midQ->midState =3D=3D MID_RESPONSE_R=
ECEIVED) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!cmdresp)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, =
"server is ok...");
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 } else {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "command 0x%x ab=
orted", midQ->command);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -1;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 }
> >> + =A0 =A0 spin_unlock(&GlobalMid_Lock);
> >> + =A0 =A0 return rc;
> >> +}
> >> +
> >
> > The cFYI's above could be a bit more descriptive. Which server isn'=
t
> > responding here? That could be important information. Also maybe th=
is
> > should be a cERROR printk so that administrators have some sort of =
clue
> > as to why the mount seems to be hung. Making those look similar to =
the
> > RPC timeout messages with NFS would also add some "consistency" to =
the
> > kernel's appearance too.
>=20
> OK. I had the messages at error level but changed them back to debug =
level.
> I have no problem going back, but such error messages can flood syslo=
g buffer
> if either server or client is slow for a long long time as observed i=
n
> some of the
> test runs.  And there is no turning off these error messages.
> If we have them at debug level, they are not logged until debugging i=
n cifs is
> turned on but can get lost in rest of the debug messages that also
> start getting logged.
> So I was not sure which option to exercise.
>=20
> >


They should be appropriately ratelimited. You don't want to spam syslog
with tons of these per second, but one per-minute per-server or so
seems reasonable to me.

It might be best to attempt to emulate the format of and the frequency
at which the NFS/RPC code spews these sorts of messages.=20

> >> +
> >> =A0static int wait_for_response(struct cifsSesInfo *ses,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct mid_q_entry *mi=
dQ,
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long timeout,
> >> @@ -367,7 +405,7 @@ static int wait_for_response(struct cifsSesInf=
o *ses,
> >> =A0 */
> >> =A0int
> >> =A0SendReceiveNoRsp(const unsigned int xid, struct cifsSesInfo *se=
s,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 struct smb_hdr *in_buf, int flags)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 struct smb_hdr *in_buf, int flags, bool =
hard_mount)
> >> =A0{
> >> =A0 =A0 =A0 int rc;
> >> =A0 =A0 =A0 struct kvec iov[1];
> >> @@ -376,7 +414,7 @@ SendReceiveNoRsp(const unsigned int xid, struc=
t cifsSesInfo *ses,
> >> =A0 =A0 =A0 iov[0].iov_base =3D (char *)in_buf;
> >> =A0 =A0 =A0 iov[0].iov_len =3D in_buf->smb_buf_length + 4;
> >> =A0 =A0 =A0 flags |=3D CIFS_NO_RESP;
> >> - =A0 =A0 rc =3D SendReceive2(xid, ses, iov, 1, &resp_buf_type, fl=
ags);
> >> + =A0 =A0 rc =3D SendReceive2(xid, ses, iov, 1, &resp_buf_type, fl=
ags, hard_mount);
> >> =A0 =A0 =A0 cFYI(DBG2, "SendRcvNoRsp flags %d rc %d", flags, rc);
> >>
> >> =A0 =A0 =A0 return rc;
> >> @@ -385,7 +423,7 @@ SendReceiveNoRsp(const unsigned int xid, struc=
t cifsSesInfo *ses,
> >> =A0int
> >> =A0SendReceive2(const unsigned int xid, struct cifsSesInfo *ses,
> >> =A0 =A0 =A0 =A0 =A0 =A0struct kvec *iov, int n_vec, int *pRespBufT=
ype /* ret */,
> >> - =A0 =A0 =A0 =A0 =A0const int flags)
> >> + =A0 =A0 =A0 =A0 =A0const int flags, bool hard_mount)
> >> =A0{
> >> =A0 =A0 =A0 int rc =3D 0;
> >> =A0 =A0 =A0 int long_op;
> >> @@ -483,7 +521,12 @@ SendReceive2(const unsigned int xid, struct c=
ifsSesInfo *ses,
> >> =A0 =A0 =A0 }
> >>
> >> =A0 =A0 =A0 /* No user interrupts in wait - wreaks havoc with perf=
ormance */
> >> - =A0 =A0 wait_for_response(ses, midQ, timeout, 10 * HZ);
> >> + =A0 =A0 if (hard_mount) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wait_for_response_hard(ses, midQ)=
;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> >> + =A0 =A0 } else
> >> + =A0 =A0 =A0 =A0 =A0 =A0 wait_for_response(ses, midQ, timeout, 10=
 * HZ);
> >
> > Maybe instead of the above, it may be better to embed whether this =
is a
> > hard or soft timeout in the mid queue entry itself. That is, add
> > another parameter? What may be best is to just put in a timeout
> > parameter in the mid queue entry and then set that to 0 for hard mo=
unts.
>=20
> I thought about that but instead opted for registering whether hard o=
r soft
> mount in tcon info struct because with that option in mid entry, we w=
ould not
> be able to override a hard mount option.  Some of the commands should
> remain soft such as unmount so deciding whether to override hard moun=
t
> option at command level made sense to me.
>=20

Override with -o remount you mean? Hmmm, ok I can probably buy that. It
might be reasonable to allow someone to flip a mount between soft and
hard mounts and expect that to apply to existing in-flight SMB's.

> >
> >>
> >> =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
> >>
> >> @@ -581,7 +624,7 @@ out:
> >> =A0int
> >> =A0SendReceive(const unsigned int xid, struct cifsSesInfo *ses,
> >> =A0 =A0 =A0 =A0 =A0 struct smb_hdr *in_buf, struct smb_hdr *out_bu=
f,
> >> - =A0 =A0 =A0 =A0 int *pbytes_returned, const int long_op)
> >> + =A0 =A0 =A0 =A0 int *pbytes_returned, const int long_op, bool ha=
rd_mount)
> >> =A0{
> >> =A0 =A0 =A0 int rc =3D 0;
> >> =A0 =A0 =A0 unsigned int receive_len;
> >> @@ -675,7 +718,12 @@ SendReceive(const unsigned int xid, struct ci=
fsSesInfo *ses,
> >> =A0 =A0 =A0 }
> >>
> >> =A0 =A0 =A0 /* No user interrupts in wait - wreaks havoc with perf=
ormance */
> >> - =A0 =A0 wait_for_response(ses, midQ, timeout, 10 * HZ);
> >> + =A0 =A0 if (hard_mount) {
> >> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wait_for_response_hard(ses, midQ)=
;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
> >> + =A0 =A0 } else
> >> + =A0 =A0 =A0 =A0 =A0 =A0 wait_for_response(ses, midQ, timeout, 10=
 * HZ);
> >>
> >> =A0 =A0 =A0 spin_lock(&GlobalMid_Lock);
> >> =A0 =A0 =A0 if (midQ->resp_buf =3D=3D NULL) {
> >> @@ -807,7 +855,7 @@ send_lock_cancel(const unsigned int xid, struc=
t cifsTconInfo *tcon,
> >> =A0 =A0 =A0 pSMB->hdr.Mid =3D GetNextMid(ses->server);
> >>
> >> =A0 =A0 =A0 return SendReceive(xid, ses, in_buf, out_buf,
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &bytes_returned, CIFS_ST=
D_OP);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &bytes_returned, CIFS_ST=
D_OP, tcon->retry);
> >> =A0}
> >>
> >> =A0int
> >
> >
> >

--=20
Jeff Layton <jlayton@samba.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
