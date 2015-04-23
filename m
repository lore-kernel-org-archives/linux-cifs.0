From: Federico Sauter <fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix race condition on RFC1002_NEGATIVE_SESSION_RESPONSE
Date: Thu, 23 Apr 2015 14:35:00 +0200
Message-ID: <5538E6F4.6010105@innominate.com>
References: <550860D2.5040207@innominate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <550860D2.5040207-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Any feedback on whether this patch makes sense or not? ;-)

---8<----------------------------------------------------------------------
 >From 54e3c95a4646c8666c6f08766250fd056b06e7f5 Mon Sep 17 00:00:00 2001
From: Federico Sauter <fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org>
Date: Tue, 17 Mar 2015 17:45:28 +0100
Subject: [PATCH] CIFS: Fix race condition on
  RFC1002_NEGATIVE_SESSION_RESPONSE

This patch fixes a race condition that occurs when connecting
to a NT 3.51 host without specifying a NetBIOS name.
In that case a RFC1002_NEGATIVE_SESSION_RESPONSE is received
and the SMB negotiation is reattempted, but under some conditions
it leads SendReceive() to hang forever while waiting for srv_mutex.
This, in turn, sets the calling process to an uninterruptible sleep
state and makes it unkillable.

The solution is to unlock the srv_mutex acquired in the demux
thread *before* going to sleep (after the reconnect error) and
before reattempting the connection.
---
  fs/cifs/connect.c |    3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d05a300..a45e7fc 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -381,6 +381,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
  		rc = generic_ip_connect(server);
  		if (rc) {
  			cifs_dbg(FYI, "reconnect error %d\n", rc);
+			mutex_unlock(&server->srv_mutex);
  			msleep(3000);
  		} else {
  			atomic_inc(&tcpSesReconnectCount);
@@ -388,8 +389,8 @@ cifs_reconnect(struct TCP_Server_Info *server)
  			if (server->tcpStatus != CifsExiting)
  				server->tcpStatus = CifsNeedNegotiate;
  			spin_unlock(&GlobalMid_Lock);
+			mutex_unlock(&server->srv_mutex);
  		}
-		mutex_unlock(&server->srv_mutex);
  	} while (server->tcpStatus == CifsNeedReconnect);

  	return rc;
-- 
1.7.10.4
---------------------------------------------------------------------->8---


On 03/17/2015 06:13 PM, Federico Sauter wrote:
> Greetings,
>
>
> I have been running into an issue (kernel v3.10.40) when connecting to
> an NT 3.51 Workstation host with a configuration missing the NetBIOS
> name ('servern' option.) Under some conditions, the mount helper would
> hang forever in an uninterruptible sleep state. The mount helper comes
> from busybox. Under some other conditions the mount program would exit
> with an error and not hang.
>
> I managed to create a setup where I could reliably reproduce both cases
> (the "good case" where the program exits, and the "bad case" where the
> program hangs forever.)
>
> The problem seems to be a race condition between the demux thread and
> the "main"(?) thread over the srv_mutex. Here is the summary of the
> functions calls that lead to this problem:
>
> * demux thread:
> cifs_demultiplex_thread()
>    is_smb_response()
>      [connect.c:626 -- case RFC1002_NEGATIVE_SESSION_RESPONSE]
>        cifs_reconnect()
>          [connect.c:380]
>          do {
>            mutex_lock(&server->srv_mutex);
>            generic_ip_connect(server);
>            // on error -> msleep(3000);
>            mutex_unlock(&server->srv_mutex);
>          } while (server->tcpStatus == CifsNeedReconnect);
>
> * "main" thread:
> cifs_negotiate()
>    CIFSSMBNegotiate()
>      SendReceive()
>        [transport.c:821 - thread hangs forever]
>        mutex_lock(&ses->server->srv_mutex);
>
> Another interesting piece of information is that in the good case at
> cifs_reconnect(), generic_ip_connect() returns -EINTR, whereas in the
> bad case it returns -ECONNREFUSED. In the bad case it all leads to
> generic_ip_connect() being called over and over again with the same
> result, but never exiting the loop (thus: hanging.)
>
> The following patch works around the issue by not re-attempting the SMB
> negotiation:
>
> ---8<----------------------------------------------------------------------
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index 4885a40..863a2da 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -415,10 +415,12 @@ cifs_negotiate(const unsigned int xid, struct
> cifs_ses *ses)
>          int rc;
>          rc = CIFSSMBNegotiate(xid, ses);
>          if (rc == -EAGAIN) {
> +#if 0
>                  /* retry only once on 1st time connection */
>                  set_credits(ses->server, 1);
>                  rc = CIFSSMBNegotiate(xid, ses);
>                  if (rc == -EAGAIN)
> +#endif
>                          rc = -EHOSTDOWN;
>          }
>          return rc;
> ---------------------------------------------------------------------->8---
>
> I was able, however, to identify a (hopefully) better solution for the
> issue (see the attached patch.)
>
> I would really appreciate your feedback on the attached patch. Please
> let me know if the solution seems acceptable as well as
> side-effects-free. We use CIFS to connect to older Windows systems and
> we have been experiencing similar issues for a while now (which I hope
> to solve with this patch.)
>
> Thanks a lot in advance! :-)
>
>
> Kind regards,
>
>
> Federico Sauter
> Senior Firmware Programmer
