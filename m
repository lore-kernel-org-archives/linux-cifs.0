From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: samba+ctdb,Input/Output error (with Linux cifs filesystem)
Date: Mon, 15 Jul 2013 15:07:49 -0400
Message-ID: <20130715150749.1a8dc923@tlielax.poochiereds.net>
References: <CAC49Ng2gBB9DO_HAz-SEAkzg3W3xUu8aDa2h1A8n=2=vkqS+9w@mail.gmail.com>
	<20130713195514.5c7ccf03@martins.ozlabs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: shuai li <lishuai.ujs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Martin Schwenke <martin-A31Bip3ZrR6sTnJN9+BGXg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130713195514.5c7ccf03-Yhm47NvcaYaaexpREJDjWx2eb7JE58TQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 13 Jul 2013 19:55:14 +1000
Martin Schwenke <martin-A31Bip3ZrR6sTnJN9+BGXg@public.gmane.org> wrote:

> On Tue, 9 Jul 2013 17:48:42 +0800, shuai li <lishuai.ujs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> wrote:
> 
> >            I build samba+ctdb environment with 3 machines,the machine
> > 192.168.4.79 acted as client,machine 192.168.4.88 and machine 192.168.4.237
> > acted as glusterfs and ctdb server,during the copy operation on client,I
> > shutdown a server to verify ctdb's virtual IP drifting.But after the
> > shutdown operation,Input/Output error occured on client. [...]
> 
> I'm not sure if cifs client filesystem will retry after a disconnect.
> Other people on this list will be able to give advice about that.
> 
> I think that's the most likely issue.  You could check a couple of
> things:
> 
> * What does the ARP table on the client say after the failover?  Does
>   it match the NIC on the new node hosting the IP?
> 
> * Do you see the CIFS connection get reset if you do a tcpdump or
>   similar?
> 
> This certainly isn't a configuration I have tested.  For Linux clients
> I have tested NFS.
> 
> peace & happiness,
> martin

(cc'ing linux-cifs ml)

Typically, the Linux CIFS client will attempt to reestablish the
connection after it gets shut down. A capture of this event would be
nice.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
