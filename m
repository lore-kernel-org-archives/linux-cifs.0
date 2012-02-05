From: Jeff Layton <jlayton@redhat.com>
Subject: Re: CIFS Unmount Issue
Date: Sun, 5 Feb 2012 16:10:34 -0500
Message-ID: <20120205161034.6aa790c4@tlielax.poochiereds.net>
References: <CAOH1cH=WsgDhwz1Dp5UsU3KV5Ocb3My9W3yjfEXiftHhHQ36ig@mail.gmail.com>
	<20120205073231.0f245671@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org
To: Mark Moseley <moseleymark@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120205073231.0f245671@tlielax.poochiereds.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Sun, 5 Feb 2012 07:32:31 -0500
Jeff Layton <jlayton@redhat.com> wrote:

> On Fri, 3 Feb 2012 15:47:08 -0800
> Mark Moseley <moseleymark@gmail.com> wrote:
>=20
> > I've got a slew of Netapp Filers talking CIFS to some Debian Squeez=
e
> > 64-bit boxes. I've noticed that in the kernel switch from 3.1 to 3.=
2,
> > the clients are no longer able to unmount a CIFS volume from an old=
er
> > Filer. The Netapp versions in question are 7.2.7 and 7.0.6. I can
> > unmount on a 3.2.x kernel from a 7.2.7 Filer just fine. With a 7.0.=
6
> > Filer, I get the following error printed to /proc/kmsg:
> >=20
> > <3>[  277.363460] CIFS VFS: RFC1001 size 35 smaller than SMB for mi=
d=3D12
> > <7>[  277.363466] Bad SMB: : dump of 39 bytes of data at 0xffff8802=
13e7e000
> > <7>[  277.363472]  23000000 424d53ff 00000074 00018800 . . . # =EF=BF=
=BD S M B
> > t . . . . . . .
> > <7>[  277.363478]  00000000 00000000 00000000 0e1000...............=
=2E<>
> > 27338] 0c0000f0
> >=20
> > but the umount call never returns, which makes reboots fun. I've
> > replicated this on 3.2.1 and 3.2.2. I've seen it print the same "Ba=
d
> > SMB..." message as pasted above with 3.1.10 but the umount call
> > returns successfully. And unmounting from the 7.2.7 Filers does not
> > cause a "Bad SMB" message to get logged to /proc/kmsg.
> >=20
> > The client is still responsive, and I can run whatever would helpfu=
l
> > to debug this. If I'm doing the unmount on the CLI, it hangs on the
> > 'umount' syscall. If I kill the umount command, the mount is gone. =
As
> > far as I can see, the unmount is succeeding, but for whatever reaso=
n,
> > the umount system call isn't ever returning. Looking at a network
> > dump, the last client call is for a logoff, which seems to succeed.
> >=20
> > There are no oops's or tracebacks logged.
> >=20
> > I can post my whole .config if it's helpful, though for brevity sak=
e,
> > here's the CIFS section:
> >=20
> > CONFIG_CIFS=3Dm
> > CONFIG_CIFS_STATS=3Dy
> > # CONFIG_CIFS_STATS2 is not set
> > CONFIG_CIFS_WEAK_PW_HASH=3Dy
> > CONFIG_CIFS_UPCALL=3Dy
> > CONFIG_CIFS_XATTR=3Dy
> > CONFIG_CIFS_POSIX=3Dy
> > # CONFIG_CIFS_DEBUG2 is not set
> > CONFIG_CIFS_DFS_UPCALL=3Dy
> > # CONFIG_CIFS_FSCACHE is not set
> > # CONFIG_CIFS_ACL is not set
> >=20
> > Let me know what I can post to be of help here, or if I should repo=
st
> > to LKML, or if I should just dust off git bisect. Thanks!
>=20
> (cc'ing linux-cifs list too)
>=20
> NetApp filers have a long-standing (for years even) bug with their
> handling of SMB_COM_LOGOFF_ANDX. The filer sends a malformed reply on
> that command. cifs.ko tends to be a little more strict on checking th=
e
> various lengths in the packet than windows is so it tosses out the
> reply.
>=20
> I'd suggest filing a bug with netapp on this. You can reference this
> (ancient) RH bug if you need more ammo:
>=20
>     https://bugzilla.redhat.com/show_bug.cgi?id=3D191112
>=20
> Now, that said...I think we have a bug in cifs.ko here too. It's
> throwing out these replies without waking up the thread that's waitin=
g
> on it, even though we were probably able to match it to a request. Th=
is
> patch will probably fix it, but it's untested and I need to stare at =
it
> a bit more to ensure that it doesn't cause any problems.
>=20
> In the meantime if you have a machine where you could test this, that
> would be helpful. I'll plan to send it to Steve F. for inclusion in 3=
=2E3
> and stable once I've smoke tested it a bit more.
>=20
> Thanks,

Revised patch. We want to return "length" if the mid wasn't ID'ed:

-------------------------------[snip]------------------------------

cifs: don't return error from standard_receive3 after marking response =
malformed

standard_receive3 will check the validity of the response from the
server (via checkSMB). It'll pass the result of that check to handle_mi=
d
which will eventually dequeue it and mark it with a status of
MID_RESPONSE_MALFORMED. At that point, it'll also return an error, whic=
h
will make the demultiplex thread skip doing the callback for the mid.

This is wrong -- if we were able to identify the request and the
response is now malformed, then we want the demultiplex thread to do th=
e
callback.  Fix this by making standard_receive3 return 0 in this
situation.

Cc: stable@vger.kernel.org
Reported-by: Mark Moseley <moseleymark@gmail.com>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/connect.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index aa687c8..4759543 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -773,10 +773,11 @@ standard_receive3(struct TCP_Server_Info *server,=
 struct mid_q_entry *mid)
 		cifs_dump_mem("Bad SMB: ", buf,
 			min_t(unsigned int, server->total_read, 48));
=20
-	if (mid)
-		handle_mid(mid, server, smb_buffer, length);
+	if (!mid)
+		return length;
=20
-	return length;
+	handle_mid(mid, server, smb_buffer, length);
+	return 0;
 }
=20
 static int
--=20
1.7.7.6


--=20
Jeff Layton <jlayton@redhat.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
