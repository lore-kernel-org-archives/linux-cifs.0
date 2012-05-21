From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [Samba] Trouble with mount.cifs while smbclient works (Ubuntu
 12.04)
Date: Mon, 21 May 2012 11:44:54 -0400
Message-ID: <20120521114454.7a58efb7@corrin.poochiereds.net>
References: <B284DF0EE72EBA488F6C7ED035128BF5105B547675@AUSX7MCPS302.AMER.DELL.COM>
	<CADT32e+HONu1ABEyjbgeLQjEBCzMjc01FTewJoHsT1bWn7tkTg@mail.gmail.com>
	<B284DF0EE72EBA488F6C7ED035128BF5105B4F777B@AUSX7MCPS302.AMER.DELL.COM>
	<201205180302.45016.linux@kukkukk.com>
	<B284DF0EE72EBA488F6C7ED035128BF5105B5B1C37@AUSX7MCPS302.AMER.DELL.COM>
	<20120519083749.513816b0@tlielax.poochiereds.net>
	<B284DF0EE72EBA488F6C7ED035128BF5105B4F777F@AUSX7MCPS302.AMER.DELL.COM>
	<CAH2r5msirj=AYseNMp7YFuCCYzv42ruLfDa-Ac0+DGg5yDt3WQ@mail.gmail.com>
	<B284DF0EE72EBA488F6C7ED035128BF5105B4F7780@AUSX7MCPS302.AMER.DELL.COM>
	<B284DF0EE72EBA488F6C7ED035128BF5105B607C12@AUSX7MCPS302.AMER.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, <samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	<linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: <Scott_Purcell-DYMqY+WieiM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B284DF0EE72EBA488F6C7ED035128BF5105B607C12-aIqoxSDCDnzHZ6aSvHnYXgVY21JRvFwKV6yJEvX+wlw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 21 May 2012 09:59:44 -0500
<Scott_Purcell-DYMqY+WieiM@public.gmane.org> wrote:

> Early responses are not encouraging.  It sounds like this was not an accidently happening, but they *intend* to obscure the root level of the share.
> 
> Might it work to try to downgrade my Samba installation to a version prior to the introduction of this bug?  If so, do you know which version would be the latest to still work?
> 

No, it was not intentional, just not simple to fix.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
