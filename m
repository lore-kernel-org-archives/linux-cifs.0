From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: remove unnecessary getuid() check in libcap
 version of toggle_dac_capability
Date: Fri, 20 Apr 2012 07:56:33 -0400
Message-ID: <20120420075633.4318b959@tlielax.poochiereds.net>
References: <1334863493-18978-1-git-send-email-jlayton@samba.org>
	<4F90F55D.30909@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lmuelle-IBi9RG/b67k@public.gmane.org
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F90F55D.30909-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 20 Apr 2012 11:04:21 +0530
Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:

> On 04/20/2012 12:54 AM, Jeff Layton wrote:
> > I'm not sure what I was thinking when I added that check in, but it's
> > been there since the inception. We shouldn't care at all what the
> > real uid is when we call toggle_dac_capability and indeed we don't
> > care with the libcap-ng version. Remove that check.
> 
> No specific comments on the patch itself but I don't understand the
> changelog. This code corresponds to the #else part of #ifdef
> HAVE_LIBCAP_NG and doesn't have any relevance to the libcap-ng?
> 

Correct. This affects the version of toggle_dac_capability that uses
libcap functions, not libcap-ng.

> Or did you mean we didn't have to consider this check for #ifdef
> HAVE_LIBCAP_NG part?
> 

The libcap-ng version of this function never had this check, and I
don't think it should have ever been in the libcap version either. It
probably makes the program not work as a setuid program with regular
old libcap, but I haven't tested that to be sure.

> Thanks
> Suresh
> 
> > Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > ---
> >  mount.cifs.c |    3 ---
> >  1 files changed, 0 insertions(+), 3 deletions(-)
> > 
> > diff --git a/mount.cifs.c b/mount.cifs.c
> > index 06715dd..c90ce3e 100644
> > --- a/mount.cifs.c
> > +++ b/mount.cifs.c
> > @@ -552,9 +552,6 @@ toggle_dac_capability(int writable, int enable)
> >  	cap_t caps;
> >  	cap_value_t capability = writable ? CAP_DAC_OVERRIDE : CAP_DAC_READ_SEARCH;
> >  
> > -	if (getuid() != 0)
> > -		return 0;
> > -
> >  	caps = cap_get_proc();
> >  	if (caps == NULL) {
> >  		fprintf(stderr, "Unable to get current capability set: %s\n",
> 


-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
