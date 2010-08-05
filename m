From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Build infrastructure for storing NTLM creds in kernel keyring
Date: Thu, 5 Aug 2010 14:03:29 -0400
Message-ID: <20100805140329.069baa41@barsoom.rdu.redhat.com>
References: <CC75E34383A8445493DD41AF4F7E7857@lan.jax.org.ru>
	<20100721100503.672a735e@tlielax.poochiereds.net>
	<9DFCDE0105DF4B70AEA82A8A2B2A2A94@lan.jax.org.ru>
	<20100722093121.4c64b102@barsoom.rdu.redhat.com>
	<54DA210795E649C1A62B5E10BF366BB3@lan.jax.org.ru>
	<20100804073140.5734d1bb@tlielax.poochiereds.net>
	<9EE2EFBFF2304A849754EEE0F1C1CE29@lan.jax.org.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Igor Druzhinin" <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9EE2EFBFF2304A849754EEE0F1C1CE29-PUkIMHyhFB22ZuJnPpCLiw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 5 Aug 2010 19:43:57 +0400
"Igor Druzhinin" <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> > First, it looks like there are some problems with newlines. The new
> > files that were added seem to have CR+LF line terminators. There are
> > also quite a few whitespace problems in there -- spaces leading tabs,
> > etc. In general, we follow kernel coding style with cifs-utils, so
> > running your patches through checkpatch.pl in the kernel sources is a
> > good idea.
> 
> Checked and patched.
> 
> > Also, I don't see much need for the MULTI_LANG ifdef's. Is there any
> > reason not to make it always use MULTI_LANG? If so, I'd remove the code
> > that's ifdef'ed out.
> 
> Now I am still not sure of the correctness of my strategy of 
> internationalization. MULTI_LANG ifdef's will help me to correct necessary 
> sites in case of its change.
> 

Fair enough then...

> > There are also several routines that seem to already be in libc. For
> > instance, wstrtolower seems to do the same thing as towlower. I'd
> > suggest using libc routines rather than rolling your own where possible.
> 
> As I saw in the GNU libc documentation there is no routines for conversion 
> string to lowercase.
> 

Ahh you're correct -- towlower only operates on a single character.

> > That memcmp is going to walk off the end of "add". Depending on how the
> > memory is allocated, it could segfault.
> 
> Patched.
> 

I pulled down your latest code and it doesn't appear to be patched. Am
I missing something?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
