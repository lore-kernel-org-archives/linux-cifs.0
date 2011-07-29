From: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: encryption on network
Date: Thu, 28 Jul 2011 17:14:35 -0700
Message-ID: <20110729001133.GA6742@jeremy-laptop>
References: <06B0D589A4AC0243AD95D4DA4978081A182DE84D@mbx024-e1-nj-6.exch024.domain.local>
 <4E31E9DD.2060604@ubiqx.mn.org>
 <20110728235410.GA4976@jeremy-laptop>
 <4E31F9E4.2030004@ubiqx.mn.org>
Reply-To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Dominic Dougherty <dominic.dougherty-cDnhz4gMPjZOSnsfY10OVw@public.gmane.org>,
	"samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Christopher R. Hertel" <crh-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4E31F9E4.2030004-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Jul 28, 2011 at 07:08:04PM -0500, Christopher R. Hertel wrote:
> Jeremy Allison wrote:
> > On Thu, Jul 28, 2011 at 05:59:41PM -0500, Christopher R. Hertel wrote:
> >> The network traffic is not encrypted.
> >>
> >> The SMB protocol does not provide any mechanism for encrypting traffic
> >> between clients and servers.
> > 
> > As shipped by Microsoft :-). The UNIX extensions to SMB allow
> > encrypted traffic between clients and servers and Samba has
> > supported this for a long time (smbclient -e will encrypt
> > traffic).
> 
> Right, but the question particularly listed WinXP as one of the
> participating clients.  Windows clients don't support the Unix extensions,
> so they don't support encrypted SMB and that kinda ruins the whole thing,
> eh?  [sad face]

Yes I realize that. But that's not what you said. You said:
"The SMB protocol does not provide any mechanism for encrypting traffic
between clients and servers." - but that's not generically true,
only between *Microsoft* clients and servers.

You made it sound like that was definitive, and you are the
acknowledged authority on CIFS/SMB, so I couldn't let that
stand. People link to your posts here :-).

> Please allow me to join the choir on that.  (I'll sit at the back and not
> get in anyone's way.)  [winky face]

Maybe if we all wish REALLY HARD, Steve and Jeff will hear
us.. :-).

Jeremy.
