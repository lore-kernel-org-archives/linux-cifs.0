From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: hung system with cifsd, cannot reduce timeout
Date: Sat, 14 Dec 2013 06:50:54 -0500
Message-ID: <20131214065054.421eddbc@tlielax.poochiereds.net>
References: <52A0EA24.9000600@noffke.me>
	<52A0F1CB.5060709@noffke.me>
	<1774674.CzhmRQMMgZ@dingofarm.qg.com>
	<3540393.5GuVZWBWRs@dingofarm.qg.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Patrick Noffke <patrick-0qqNeQ6W4hOzQB+pC5nmwQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3540393.5GuVZWBWRs-J5+zLgb4AZ5BQzcUTsrH4w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 10 Dec 2013 09:15:41 -0600
Patrick Noffke <patrick-0qqNeQ6W4hOzQB+pC5nmwQ@public.gmane.org> wrote:

> On Friday, December 06, 2013 09:50:27 AM Patrick Noffke wrote:
> > 
> > 
> > It seems like the "Getting info on" log message is missing a filename.  Would 
> > this explain why it's hung until the server sends a RST?
> > 
> > There are also logs like the following before the cable is reattached:
> > fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> > 
> 
> In inode.c, in the cifs_revalidate_dentry_attr function, if I add a check for an empty full_path (returning -ENOENT if empty), then the system recovers much faster, but my process gets an error opening the file it was trying to open when the cable was disconnected.  I noticed cifs logs following trying to call cifs_revalidate_dentry_attr with the last file path, but there is a NULL inode for several such calls.
> 
> I added this right after the check for a NULL full_path:
> 
> 	if (0 != strcmp(full_path, "")) {
> 		cFYI(1, "Got empty full_path");
> 		rc = -ENOENT;
> 		goto out;
> 	}
> 
> I don't propose this as a patch -- I'm just curious if I'm on the right track.  Could I return something else, or is there some other way to help the file system recover faster?
> 

Complex problem...

I don't think you're on the right track there. An empty path is likely
just an indicator that it's trying to fetch info from the root of the
share. I think that's just happenstance. cifs.ko does a lot of dentry
revalidation by default, and that's probably where the syscalls are
when this occurs.

The problem you're describing seems more tied up with how the transport
layer and socket handling are working. I'd suggest focusing your
efforts there.

Basically, cifsd will just try to reconnect the socket if the
server->lstrp value is too far in the last. That's just a timestamp
that tells us when we last got a response from the server. The async
echoes just kick off to try and keep that going. That code needs
some work.

One thing that looks wrong to me immediately is that lstrp is reset to
jiffies before we reconnect to the server. If the reconnect takes a
while, then that value could easily be too far in the past by the time
the connect succeeds. I'll attach an untested patch. It probably won't
make much difference for this test, but looks like a reasonable thing
to fix while we're in here.

As to why the client would try to send an echo on the old socket after
connecting the new one, I'm not sure. I'd suspect that has more to do
with the socket layer. Just because we shut down the socket doesn't
mean we purge the data that we attempted to send on the old one.

Note too that there are a number of hardcoded timeouts in this code
(e.g., the msleep(3000) in cifs_reconnect, and the socket timeouts).
Reducing SMB_ECHO_TIMEOUT to 5s is likely to mean that you end up
overlapping with some of them. That's may give you odd results.

Also, 3.9.0 is pretty old at this point I'd suggest working with
something closer to mainline while troubleshooting this so you're not
treading over problems that have already been fixed.

Patch for lstrp problem follows. It compiles, but is otherwise untested.

-----------------------[snip]--------------------

[PATCH] cifs: reset server->lstrp after reconnecting

Currently we reset it before trying to reconnect. If the reconnect
attempt takes a long time, then this value could be too far in the past
by the time the connect succeeds. Reset it only after the connect
succeeds.

Cc: Patrick Noffke <patrick-0qqNeQ6W4hOzQB+pC5nmwQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8813ff7..6e83e8e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -353,7 +353,6 @@ cifs_reconnect(struct TCP_Server_Info *server)
 	kfree(server->session_key.response);
 	server->session_key.response = NULL;
 	server->session_key.len = 0;
-	server->lstrp = jiffies;
 	mutex_unlock(&server->srv_mutex);
 
 	/* mark submitted MIDs for retry and issue callback */
@@ -390,6 +389,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
 			if (server->tcpStatus != CifsExiting)
 				server->tcpStatus = CifsNeedNegotiate;
 			spin_unlock(&GlobalMid_Lock);
+			server->lstrp = jiffies;
 		}
 		mutex_unlock(&server->srv_mutex);
 	} while (server->tcpStatus == CifsNeedReconnect);
-- 
1.8.4.2
