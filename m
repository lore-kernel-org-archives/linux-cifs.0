From: Volker Lendecke <Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>
Subject: Re: cifs client timeouts and hard/soft mounts
Date: Mon, 6 Dec 2010 21:42:09 +0100
Message-ID: <E1PPhsv-00EaIW-JL@intern.SerNet.DE>
References: <AANLkTi=MCgZb=we2OEtxJ4DZ==sVmRLd8aQKeMU7vvKt@mail.gmail.com> <20101205210634.602b076b@corrin.poochiereds.net> <AANLkTik4Vh5hqWwVngjCC7v1ST1YxAP9LvQbcqKDhWHp@mail.gmail.com> <E1PPSnw-00DDbs-Va@intern.SerNet.DE> <AANLkTinPw8M6XaMvMQ_VMxdk7j8PDqdpjzKLgDMxPf1n@mail.gmail.com> <4CFD16D8.4090207@samba.org> <20101206124255.7ea8a8a9@tlielax.poochiereds.net> <4CFD3166.4000800@samba.org> <E1PPhWb-00EZX7-6F@intern.SerNet.DE> <4CFD49CD.5010002@samba.org>
Reply-To: Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4CFD49CD.5010002-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Dec 06, 2010 at 02:38:37PM -0600, Christopher R. Hertel wrote:
> > Sorry, but if a WAN accelerator does not have the smarts to
> > see that if a client sends smbechos, it is in trouble, then
> > that WAN accelerator is just broken. It does not necessarily
> > need to send these echos across the WAN link, but it must
> > trigger its own server liveliness check at this point.
> 
> I agree.
> 
> That's why these companies hire me, though.  They have *no clue* when it
> comes to CIFS and they run into brick walls at full speed.
> 
> When it comes down to it, though, anyone with smarts and half a clue would
> avoid SMB/CIFS if at all possible.  Most of what we do with Samba and the
> CIFS client is mitigate stupidity.  :)

AFS to the rescue! (Sorry, wrong list I think... :-)

Volker
