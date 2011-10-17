From: sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: Re: mount.cifs on Win2k8 DFS servers
Date: Mon, 17 Oct 2011 14:36:35 +0200
Message-ID: <20111017123635.GA5978@cobija.connexer.com>
References: <4E9C1876.5090205@keymile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gerlando Falauto <gerlando.falauto-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4E9C1876.5090205-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Oct 17, 2011 at 01:58:46PM +0200, Gerlando Falauto wrote:
> my CIFS kernel module (linux 2.6.39.3) fails to mount DFS trees from
> Win2k8 servers.

> This is somewhat related to:
> https://bugzilla.samba.org/show_bug.cgi?id=8003

hrm... i recognize that one :)  reminds me i should go poke the
samba team as it's still an issue afaik...

> What should be the be best approach for facing this?
> Detecting the server has DFS capabilities and start getting DFS
> referrals to begin with?
> Has this been discussed in the past? I find it hard to believe that
> no one has reported this problem before...

I think this should be fixed in later kernels... I worked with Jeff
and Steve to get some patches in for what I think is the same issue
you're describing, and iirc they landed just after 2.6.39 but before 3.0.

	sean

-- 
