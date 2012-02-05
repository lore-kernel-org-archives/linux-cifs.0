From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: CIFS Unmount Issue
Date: Sun, 5 Feb 2012 07:32:31 -0500
Message-ID: <20120205073231.0f245671@tlielax.poochiereds.net>
References: <CAOH1cH=WsgDhwz1Dp5UsU3KV5Ocb3My9W3yjfEXiftHhHQ36ig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Moseley <moseleymark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOH1cH=WsgDhwz1Dp5UsU3KV5Ocb3My9W3yjfEXiftHhHQ36ig-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 3 Feb 2012 15:47:08 -0800
Mark Moseley <moseleymark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> I've got a slew of Netapp Filers talking CIFS to some Debian Squeeze
> 64-bit boxes. I've noticed that in the kernel switch from 3.1 to 3.2,
> the clients are no longer able to unmount a CIFS volume from an older
> Filer. The Netapp versions in question are 7.2.7 and 7.0.6. I can
> unmount on a 3.2.x kernel from a 7.2.7 Filer just fine. With a 7.0.6
> Filer, I get the following error printed to /proc/kmsg:
>=20
> <3>[  277.363460] CIFS VFS: RFC1001 size 35 smaller than SMB for mid=3D=
12
> <7>[  277.363466] Bad SMB: : dump of 39 bytes of data at 0xffff880213=
e7e000
> <7>[  277.363472]  23000000 424d53ff 00000074 00018800 . . . # =EF=BF=
=BD S M B
> t . . . . . . .
> <7>[  277.363478]  00000000 00000000 00000000 0e1000................<=
>
> 27338] 0c0000f0
>=20
> but the umount call never returns, which makes reboots fun. I've
> replicated this on 3.2.1 and 3.2.2. I've seen it print the same "Bad
> SMB..." message as pasted above with 3.1.10 but the umount call
> returns successfully. And unmounting from the 7.2.7 Filers does not
> cause a "Bad SMB" message to get logged to /proc/kmsg.
>=20
> The client is still responsive, and I can run whatever would helpful
> to debug this. If I'm doing the unmount on the CLI, it hangs on the
> 'umount' syscall. If I kill the umount command, the mount is gone. As
> far as I can see, the unmount is succeeding, but for whatever reason,
> the umount system call isn't ever returning. Looking at a network
> dump, the last client call is for a logoff, which seems to succeed.
>=20
> There are no oops's or tracebacks logged.
>=20
> I can post my whole .config if it's helpful, though for brevity sake,
> here's the CIFS section:
>=20
> CONFIG_CIFS=3Dm
> CONFIG_CIFS_STATS=3Dy
> # CONFIG_CIFS_STATS2 is not set
> CONFIG_CIFS_WEAK_PW_HASH=3Dy
> CONFIG_CIFS_UPCALL=3Dy
> CONFIG_CIFS_XATTR=3Dy
> CONFIG_CIFS_POSIX=3Dy
> # CONFIG_CIFS_DEBUG2 is not set
> CONFIG_CIFS_DFS_UPCALL=3Dy
> # CONFIG_CIFS_FSCACHE is not set
> # CONFIG_CIFS_ACL is not set
>=20
> Let me know what I can post to be of help here, or if I should repost
> to LKML, or if I should just dust off git bisect. Thanks!

(cc'ing linux-cifs list too)

NetApp filers have a long-standing (for years even) bug with their
handling of SMB_COM_LOGOFF_ANDX. The filer sends a malformed reply on
that command. cifs.ko tends to be a little more strict on checking the
various lengths in the packet than windows is so it tosses out the
reply.

I'd suggest filing a bug with netapp on this. You can reference this
(ancient) RH bug if you need more ammo:

    https://bugzilla.redhat.com/show_bug.cgi?id=3D191112

Now, that said...I think we have a bug in cifs.ko here too. It's
throwing out these replies without waking up the thread that's waiting
on it, even though we were probably able to match it to a request. This
patch will probably fix it, but it's untested and I need to stare at it
a bit more to ensure that it doesn't cause any problems.

In the meantime if you have a machine where you could test this, that
would be helpful. I'll plan to send it to Steve F. for inclusion in 3.3
and stable once I've smoke tested it a bit more.

Thanks,
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--------------------------[snip]------------------------

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
response is malformed, then we want the demultiplex thread to do the
callback.  Fix this by making standard_receive3 return 0 in this
situation.

Reported-by: Mark Moseley <moseleymark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index aa687c8..83104a5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -776,7 +776,7 @@ standard_receive3(struct TCP_Server_Info *server, s=
truct mid_q_entry *mid)
 	if (mid)
 		handle_mid(mid, server, smb_buffer, length);
=20
-	return length;
+	return 0;
 }
=20
 static int
--=20
1.7.7.6
