From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 0/3] Add O_DENY* flags to fcntl and cifs
Date: Thu, 6 Dec 2012 16:37:27 -0500
Message-ID: <20121206213727.GC4821@thunk.org>
References: <1354818391-7968-1-git-send-email-piastry@etersoft.ru>
 <20121206194949.7ab20d56@pyramind.ukuu.org.uk>
 <20121206195752.GA18585@samba2>
 <20121206213133.GB4821@thunk.org>
 <20121206213329.GB24076@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>,
	Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121206213329.GB24076@samba2>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Dec 06, 2012 at 01:33:29PM -0800, Jeremy Allison wrote:
> > I'm confused; why would a userspace application need to be able to
> > request this behavior?
> 
> This isn't my proposal Ted, I'm just commenting on it :-).

Ah, sorry, I thought was coming from the Samba team.  :-)

Hmm... I see wine-devel is cc'ed; is this coming from the Wine team,
wanting to do SMB paravirtualization?  It would be useful if the
commit description described how these flags are intended to be used....

       		   	     	       	     - Ted
