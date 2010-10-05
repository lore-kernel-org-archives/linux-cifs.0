From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: deadlock in cifs mounts when server connection goes down
Date: Tue, 5 Oct 2010 18:21:11 -0400
Message-ID: <20101005182111.1fb57c46@tlielax.poochiereds.net>
References: <OFBD4F0D26.5B603757-ON852577B3.00696669-852577B3.006A1040@grpleg.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: david.kondrad-9WVPih6vfS2cqzYg7KEe8g@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OFBD4F0D26.5B603757-ON852577B3.00696669-852577B3.006A1040-RlcD8zjoVD9eoWH0uzbU5w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 5 Oct 2010 15:18:29 -0400
david.kondrad-9WVPih6vfS2cqzYg7KEe8g@public.gmane.org wrote:

> 
> Greetings:
> 
> We have a product that uses cifs mounts to catalog digital music on
> cifs/smb shares on our user's network. We have noticed that while
> cataloging, if a computer leaves the network while the share is
> mounted, any processes that attempt access while be held in the 'D'
> state (which is expected); however, there doesn't appear to be any
> time-out to give up trying to reconnect to the missing server.
> 
> Upon examining the source, I believe the issue is in this loop in
> fs/cifs/connect.c:186 (inside cifs_reconnect() proc)
> 
>    while ((server->tcpStatus != CifsExiting) &&
>           (server->tcpStatus != CifsGood)) {
>       try_to_freeze();
>       if (server->addr.sockAddr6.sin6_family == AF_INET6)
>          rc = ipv6_connect(server);
>       else
>          rc = ipv4_connect(server);
>       if (rc) {
>          cFYI(1, "reconnect error %d", rc);
>          msleep(3000);
>       } else {
>          atomic_inc(&tcpSesReconnectCount);
>          spin_lock(&GlobalMid_Lock);
>          if (server->tcpStatus != CifsExiting)
>             server->tcpStatus = CifsGood;
>          server->sequence_number = 0;
>          spin_unlock(&GlobalMid_Lock);
>    /*    atomic_set(&server->inFlight,0);*/
>          wake_up(&server->response_q);
>       }
>    }
> 
> It looks like if the server leaves the network, this loop will never
> exit because the loop condition never becomes false.
> 
> While I was looking at the callers of cifs_reconnect, I also noticed
> that the return code is consistently ignored which points to the
> assumption that cifs_reconnect() only returns when the connection is
> again viable.
> 
> At first glance, the most direct route would be to add a retry counter
> to the loop and then exit out if not successful within (user
> configurable?) attempts; however, I am not familiar enough with the
> cifs code-base to anticipate any regressions that might result from
> that.
> 
> Any thoughts/comments/suggestions on supplying a fail-safe break out
> of this loop? I'm guessing if we can't reconnect then we should treat
> this connection as unmounted and fail out of any syscalls, right?
> 
> Best regards,
> David
> 

Retrying indefinitely is actually the correct behavior I believe. If
I'm writing or reading files to/from CIFS, then the last thing I want
is for the kernel to corrupt that data or start returning errors just
because the network is having problems.

The correct behavior (IMO) is for the kernel to start sending SMB echo
requests if it doesn't get a reply within a certain amount of time. If
those don't get a reply after a certain number of attempts (probably
user-configurable), then we cancel in-flight MID's and attempt to
reconnect to the server.

However, none of this should cause the client to start returning errors
to userspace. That doesn't make for robustness in the face of network
partitions. If, however, the processes waiting on syscalls are
interrupted with a SIGKILL, we probably ought to return an error to
userspace (probably an EINTR).

What you may want to look at is wait_for_response -- it probably ought
to be fixed to handle fatal signals and return errors when the task
gets one.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
