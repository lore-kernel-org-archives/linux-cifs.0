From: Alex Bligh <alex-rWA27mgs/Jz10XsdtD+oqA@public.gmane.org>
Subject: Re: cifs.ko client failover with CSVFS Windows 2012 R2 server
Date: Tue, 23 Jun 2015 20:20:34 +0100
Message-ID: <5589B182.1070501@alex.org.uk>
References: <558948EF.9010008@alex.org.uk> <CAH2r5muVBQ3OKrV8o466PwMWSh_SSbjkbM+KDPAqPXL0qx6VEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muVBQ3OKrV8o466PwMWSh_SSbjkbM+KDPAqPXL0qx6VEA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Steve,

On 23/06/2015 16:17, Steve French wrote:
> On Tue, Jun 23, 2015 at 6:54 AM, Alex Bligh <alex-rWA27mgs/Jz10XsdtD+oqA@public.gmane.org> wrote:
>> I'm trying to establish to what extent a cifs.ko linux client will
>> support failover with a Windows 2012 R2 server, sharing a CSVFS
>> backend. The symptom a user is seeing here is that the share
>> works, but the file system does not fail over if the server it
>> initially mounts goes down (kernel 3.13.0-49-generic, on
>> Ubuntu 14.04).
> 
> After network or server failure the cifs client does reconnect and
> replay and writes which received errors, but will reconnect to the
> same ip address that it was connected to.  In some server cluster
> servers, this is sufficient as they proxy the address mapping to
> various servers in a cluster, but probably won't help with connections
> to Windows unless the new server has the same ip address as the old.

Thanks for taking the time to reply.

I am not a Windows person but as I understand it there may be
some sort of 'floating IP' Windows provides for this purpose, but
the user concerned could not get the CIFS client to connect to
the floating IP at all, only the real IPs. I suspect this is
because 2012 is now using DNN (see below) so a name look-up
is returning the 'real' IP address of one of the servers; of
course if it's not using an inband list of these to reconnect
to, that's going to cause a problem, so perhaps we should
see if the 'floating IP' concept is still somehow supported.

I believe Windows clients are using the technology described here:

http://blogs.technet.com/b/josebda/archive/2012/10/08/windows-server-2012-file-servers-and-smb-3-0-simpler-and-easier-by-design.aspx

   "This new Scale-Out capability is enabled by using a couple of
   feature from Failover Clustering: Cluster Shared Volumes (CSV)
   and the Dynamic Network Name (DNN).
   ...
   With SMB Scale-Out, as we explained, you only need one name.
   In addition to that, we no longer need additional IP addresses
   besides the regular cluster node IP addresses. The DNN simply
   points to the existing node IP addresses of every node in the cluster.
   This means fewer IP addresses to configure and fewer Cluster
   resources to manage."

I presume that would require the CIFS client to call up back to
userspace to retranslate the name on reconnect or similar. This
doesn't seem to be happening from what I can gather. I presume
you are saying that this call up to userspace isn't happening
either?

> Even without the witness protocol, in a symmetric cluster with
> multiple servers exporting the same data, in theory if we are
> connected to a DFS share in a cluster for which the server has sent us
> the list of servers exporting the same data we could reconnect to any
> of the servers that we got in the previous DFS referral but currently
> we don't do that.   Would welcome a patch for that though.

Again, I am very far from a Windows expert, but I suspect DFS is
something different than the 2012 stuff referenced above.

> Currently only if the server ip address has not changed (also note
> "hard" vs "soft" choice in mount options which controls whether we
> retry reconnecting forever or not).

It's currently set to 'soft', on the basis we'd rather the system
returned errors whilst failing over rather than hanging. Does that
mean if it hits the timeout it will never retry even if the server
subsequently comes up? The ideal behaviour would be 'error if it
can't reach the server during failover, but reconnect, possibly
to a different IP, on the next attempt'. We're simply dumping
large files onto CIFS occasionally so if one fails, it would be nice
if things came back for the next one.

> There are bug fixes in cifs.ko after 3.13 but I didn't see anything
> related to failover.

Thanks for taking the time to look.

-- 
Alex Bligh
