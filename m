From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs.ko client failover with CSVFS Windows 2012 R2 server
Date: Tue, 23 Jun 2015 10:17:41 -0500
Message-ID: <CAH2r5muVBQ3OKrV8o466PwMWSh_SSbjkbM+KDPAqPXL0qx6VEA@mail.gmail.com>
References: <558948EF.9010008@alex.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Alex Bligh <alex-rWA27mgs/Jz10XsdtD+oqA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <558948EF.9010008-rWA27mgs/Jz10XsdtD+oqA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jun 23, 2015 at 6:54 AM, Alex Bligh <alex-rWA27mgs/Jz10XsdtD+oqA@public.gmane.org> wrote:
> I'm trying to establish to what extent a cifs.ko linux client will
> support failover with a Windows 2012 R2 server, sharing a CSVFS
> backend. The symptom a user is seeing here is that the share
> works, but the file system does not fail over if the server it
> initially mounts goes down (kernel 3.13.0-49-generic, on
> Ubuntu 14.04).

After network or server failure the cifs client does reconnect and
replay and writes which received errors, but will reconnect to the
same ip address that it was connected to.  In some server cluster
servers, this is sufficient as they proxy the address mapping to
various servers in a cluster, but probably won't help with connections
to Windows unless the new server has the same ip address as the old.

In addition the cifs client when mounted with SMB 2.02 or later does
support durable handles which does improve data integrity after
network failure but doesn't help if the server's ip address has
changed.

Even without the witness protocol, in a symmetric cluster with
multiple servers exporting the same data, in theory if we are
connected to a DFS share in a cluster for which the server has sent us
the list of servers exporting the same data we could reconnect to any
of the servers that we got in the previous DFS referral but currently
we don't do that.   Would welcome a patch for that though.



> This link:
>  https://wiki.samba.org/index.php/SMB3_kernel_status#Witness_Notification_Protocol
> implies that Witness Notification Protocol should work for a
> client if vers=3.02 is passed to mount.cifs. However, the user
> seems unable to get failover to work at all (transparently or
> otherwise).

Would love some patches for Witness protocol enablement, but currently
it is not implemented.

The Witness protocol could be useful for server movement (where a
server ip address changes) in SMB protocol version 3.0 or later (and
for share movement for version 3.02) but this is not supported by the
cifs.ko kernel client (or Samba server, although that work is in
progress).   Windows servers and clients do support the witness
protocol.

> Questions:
>
> * Is failover supported on cifs.ko, and if so do I need a newer
>   kernel version than 3.13? Are there any special commands needed
>   to enable it other than mounting with vers=3?

Currently only if the server ip address has not changed (also note
"hard" vs "soft" choice in mount options which controls whether we
retry reconnecting forever or not).

There are bug fixes in cifs.ko after 3.13 but I didn't see anything
related to failover.

-- 
Thanks,

Steve
