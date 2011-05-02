From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: CIFS Not Responding Error On Working System
Date: Mon, 2 May 2011 07:01:56 -0400
Message-ID: <20110502070156.371ef97a@corrin.poochiereds.net>
References: <4DB9BFBA.3020403@softtalker.com>
	<BANLkTinoC1d=NBLyzXa61cB+tR-+4F50zg@mail.gmail.com>
	<20110429093256.3c33cd01@corrin.poochiereds.net>
	<4DBAD409.9000300@softtalker.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Dillinger <miked-yxPvCyoe84a+XT7JhA+gdA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DBAD409.9000300-yxPvCyoe84a+XT7JhA+gdA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 29 Apr 2011 08:06:49 -0700
Mike Dillinger <miked-yxPvCyoe84a+XT7JhA+gdA@public.gmane.org> wrote:

> > What sort of host is "peart" here? WinXP?
> 
> peart is WinXP 64 SP2, and the Linux machine is running Debian wheezy.  
> The XP firewall is off and the internet security firewall (Kaspersky 
> Internet Security) is off.
> 
> The firewall thing doesn't make sense, or else it seems to me that I 
> wouldn't be able to view the remote data.  The remote side *always* 
> works when I view the file share.  I have even tried during viewing the 
> data multiple times during the 5 minute interval where syslog states the 
> host is not responding.  I will capture Wireshark traces though if there 
> aren't any other suggestions.
> 

I might see the problem here. I think there's a bug in 2.6.38ish
kernels that's fixed by commit fd88ce93:

@@ -421,7 +420,7 @@ cifs_demultiplex_thread(struct TCP_Server_Info *server)
                pdu_length = 4; /* enough to get RFC1001 header */
 
 incomplete_rcv:
-               if (echo_retries > 0 &&
+               if (echo_retries > 0 && server->tcpStatus == CifsGood &&
                    time_after(jiffies, server->lstrp +
                                        (echo_retries * SMB_ECHO_INTERVAL))) {
                        cERROR(1, "Server %s has not responded in %d seconds. "


...if the server decides to disconnect the client for some reason, then
the above delta will prevent that error message from popping
unnecessarily. Steve, I think that patch should probably go to -stable
as well.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
