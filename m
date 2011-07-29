From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: encryption on network
Date: Fri, 29 Jul 2011 09:34:55 -0700
Message-ID: <20110729163455.GA811@samba2>
References: <06B0D589A4AC0243AD95D4DA4978081A182DE84D@mbx024-e1-nj-6.exch024.domain.local>
 <4E31E9DD.2060604@ubiqx.mn.org>
 <20110728235410.GA4976@jeremy-laptop>
 <4E31F9E4.2030004@ubiqx.mn.org>
 <20110729001133.GA6742@jeremy-laptop>
 <20110729061610.59f282a8@tlielax.poochiereds.net>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	"Christopher R. Hertel" <crh-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org>,
	Dominic Dougherty <dominic.dougherty-cDnhz4gMPjZOSnsfY10OVw@public.gmane.org>,
	"samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110729061610.59f282a8-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jul 29, 2011 at 06:16:10AM -0400, Jeff Layton wrote:
> 
> Sorry, just haven't heard great hue and cry for this feature (other
> than from you, of course :). My next task for cifs is to make it do
> parallel reads, but I haven't had time to start on that yet.

The reason you haven't heard requests for this feature (IMHO) is
that no one knows it's even possible. It's been in the server
and client libraries for abouut 5+ years (if my memory serves
me right). Once you make it available in CIFSFS I think you'll
find a whole host of opportunities will open up for CIFS use
that weren't there before from people who need secure transport but
don't want to set up IPsec.

Jeremy.
