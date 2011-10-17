From: Gerlando Falauto <gerlando.falauto-SkAbAL50j+5BDgjK7y7TUQ@public.gmane.org>
Subject: Re: mount.cifs on Win2k8 DFS servers
Date: Mon, 17 Oct 2011 17:04:22 +0200
Message-ID: <4E9C43F6.9050702@keymile.com>
References: <4E9C1876.5090205@keymile.com> <20111017123635.GA5978@cobija.connexer.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org
To: sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111017123635.GA5978-Znhnm/lQSyjxW5zecs3cv0EOCMrvLtNR@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,


> I think this should be fixed in later kernels... I worked with Jeff
> and Steve to get some patches in for what I think is the same issue
> you're describing, and iirc they landed just after 2.6.39 but before 3.0.

OK, thanks!!!

I doubted it could have gone unnoticed for such long a time. I had 
looked up the samba bugzilla but of course the bug report was on the 
kernel's one. :-)

So I guess you're talking about these two little fellas:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=dd61394586dbd9387fe53b325c6807f61734cf89
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c1508ca23653245266e2e3ab69a8dad464f7a569

Which I painlessly merged and tested on my 2.6.39.3 and are working fine 
(external behvaviour seems consistent with my ugly patch in that it 
retries after a regular mount).

Two newbie-like comments though:

1) I would've expected a more radical fix by skipping to DFS referal 
altogether when server has DFS capabilities, even before trying a 
regular connect, so to make it consistent with smbclient.
Which (as far as I can tell) has been working like this for a looong time.

2) Shouldn't this/these patch/es also make it into earlier kernels as it 
is a (not-so-negligible) bugfix?

Thank you for your patience!
Gerlando
