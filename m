From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/3] cifs.upcall: attempt to use AD-style service
 principals
Date: Tue, 15 Nov 2011 08:46:20 -0500
Message-ID: <20111115084620.41d2c45b@tlielax.poochiereds.net>
References: <4EC24A9C.7080301@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
To: mat-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EC24A9C.7080301-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 15 Nov 2011 12:18:52 +0100
Matthieu Patou <mat-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> On 14/11/2011 02:17, Jeff Layton wrote:
> 
> > We've had a request recently to allow cifs.upcall to use AD-style
> > service principals. While trying to nail down what they need, I asked
> > Simo his opinion on how best to pick a service principal for a given
> > hostname. His suggestion was:
> >
> > 	INPUT: fooo
> > 	TRY in order:
> >    		FOOO$@REALM
> > 		cifs/fooo.<guessed domain ?>@REALM
> >    		host/fooo.<guessed domain ?>@REALM
> >
> > 	INPUT: bar.example.com
> > 	TRY in order:
> > 		cifs/bar.example.com@REALM
> > 		BAR$@REALM
> > 		host/bar.example.com@REALM
> >
> > This patchset attempts to embody that logic.
> >
> > Suggestions welcome. Those reviewing it, please pay particular attention
> > to the scheme for guessing a domain name. I want to make certain that
> > we're not opening up any security holes with that scheme.
> 
> Jeff, you have to pay attention to DFS volumes.
> IE. if I want to mount //mydomain.corp/sysvol you will never get a 
> ticket for cifs/mydomain.corp@REALM instead you need to locate with 
> trans2 calls (for smb1, I don't remember the name for smb2) the domain 
> controlers (DC) that could provide you the share.
> For sysvol it's still quite simple but you can have other DFS volume 
> that are not stored on DC, would be great to have DFS awareness in the 
> cifs client.
> 

Woah, that's a whole different problem altogether.

Currently the DFS code relies on being able to resolve the hostname
portion of the UNC in a DFS referral using getaddrinfo in an upcall. If
you want to do anything more elaborate, then that's really a separate
project.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
