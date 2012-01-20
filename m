From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Trouble accessing Buffalo NAS with CIFSFS
Date: Fri, 20 Jan 2012 11:19:36 -0500
Message-ID: <20120120111936.5329cbb4@tlielax.poochiereds.net>
References: <20120119090752.9b7aea6c.ralda@gmx.de>
	<20120119070543.662a3c56@tlielax.poochiereds.net>
	<20120120113042.0fdfea5f.ralda@gmx.de>
	<20120120101938.7ca7464d@tlielax.poochiereds.net>
	<20120120165657.00042c72.ralda@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: "ralda-Mmb7MZpHnFY@public.gmane.org" <ralda-Mmb7MZpHnFY@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120120165657.00042c72.ralda-Mmb7MZpHnFY@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 20 Jan 2012 16:56:57 +0100
"ralda-Mmb7MZpHnFY@public.gmane.org" <ralda-Mmb7MZpHnFY@public.gmane.org> wrote:

> Hallo Jeff!
> 
> > Unfortunately, this server seems to only be able to handle one request
> > at a time per socket.
> 
> Ack. I know that the Buffalo Drive station can handle only one request
> a time. It fails to work properly if several stations access (write
> to) the drive simultaneously.
> 
> 
> > It sets this value in the NEGOTIATE reply: Max Mpx Count: 1
> > 
> > CIFS ignores this value currently, which is a (rather bad) bug. Steve
> > is apparently working on fixing this, so he might have a patch that you
> > can help test.
> 
> Sure. Let me know what I shall test. I even freed another (smaller)
> hard disk that can be inserted into the Buffalo station. That disk
> allows tests with the NAS without risk of loosing data. So I may be
> able to run different test with the device and collect data for your
> analysis, if that can help your development.
> 
> 
> > > In the meantime, you can try setting the the cifs_max_pending module
> > parm to a low value (I think 2 is the minimum). I suspect that will
> > prevent this problem.
> 
> If you request to do me a test with this, I can do, else I wait for a
> patch.
> 
> As the Buffalo DriveStation 2Share allows for access via network and as
> an USB drive (alternate function) I do still have access to my data
> using the drive as an external USB device. That works fine but needs a
> separate computer for forwarding of the files. So it is not required to
> have a fix or workaround within a few days. But I like the simplicity
> of the NAS station to be accessed via network from every computer, so I
> would like to see a future solution for the problem. Thats all.
> 
> And probably there are more people out there, using Buffalo Drive
> Stations, so they probably ran into the same trouble and may not be
> able to collect data for diagnosis.
> 
> And thanks for your help so far.
> 

(re-cc'ing linux-cifs)

At this point, I'd suggest just setting the cifs_max_pending module
parm low  (1 or 2) and seeing if that helps. If it does, then that
should basically emulate the effect of steve's eventual patch. If it
doesn't then we'll probably need to have a closer look at why it isn't.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
