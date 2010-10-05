From: david.kondrad-9WVPih6vfS2cqzYg7KEe8g@public.gmane.org
Subject: deadlock in cifs mounts when server connection goes down
Date: Tue, 5 Oct 2010 15:18:29 -0400
Message-ID: <OFBD4F0D26.5B603757-ON852577B3.00696669-852577B3.006A1040@grpleg.it>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Greetings:

We have a product that uses cifs mounts to catalog digital music on
cifs/smb shares on our user's network. We have noticed that while
cataloging, if a computer leaves the network while the share is
mounted, any processes that attempt access while be held in the 'D'
state (which is expected); however, there doesn't appear to be any
time-out to give up trying to reconnect to the missing server.

Upon examining the source, I believe the issue is in this loop in
fs/cifs/connect.c:186 (inside cifs_reconnect() proc)

   while ((server->tcpStatus != CifsExiting) &&
          (server->tcpStatus != CifsGood)) {
      try_to_freeze();
      if (server->addr.sockAddr6.sin6_family == AF_INET6)
         rc = ipv6_connect(server);
      else
         rc = ipv4_connect(server);
      if (rc) {
         cFYI(1, "reconnect error %d", rc);
         msleep(3000);
      } else {
         atomic_inc(&tcpSesReconnectCount);
         spin_lock(&GlobalMid_Lock);
         if (server->tcpStatus != CifsExiting)
            server->tcpStatus = CifsGood;
         server->sequence_number = 0;
         spin_unlock(&GlobalMid_Lock);
   /*    atomic_set(&server->inFlight,0);*/
         wake_up(&server->response_q);
      }
   }

It looks like if the server leaves the network, this loop will never
exit because the loop condition never becomes false.

While I was looking at the callers of cifs_reconnect, I also noticed
that the return code is consistently ignored which points to the
assumption that cifs_reconnect() only returns when the connection is
again viable.

At first glance, the most direct route would be to add a retry counter
to the loop and then exit out if not successful within (user
configurable?) attempts; however, I am not familiar enough with the
cifs code-base to anticipate any regressions that might result from
that.

Any thoughts/comments/suggestions on supplying a fail-safe break out
of this loop? I'm guessing if we can't reconnect then we should treat
this connection as unmounted and fail out of any syscalls, right?

Best regards,
David

--
David Kondrad
Software Design Engineer
Home Systems Division
Legrand, North America

david.kondrad-9WVPih6vfS2cqzYg7KEe8g@public.gmane.org
www.legrand.us/onq

PS: I have no control over the forced footer appended to my emails

This email, and any document attached hereto, may contain
confidential and/or privileged information.  If you are not the
intended recipient (or have received this email in error) please
notify the sender immediately and destroy this email.  Any
unauthorized, direct or indirect, copying, disclosure, distribution
or other use of the material or parts thereof is strictly
forbidden.
