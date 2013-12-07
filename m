From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs-utils: pam module to set cifs credentials in key
 store
Date: Sat, 7 Dec 2013 09:23:41 -0500
Message-ID: <20131207092341.16e0fe0c@tlielax.poochiereds.net>
References: <loom.20131113T002139-562@post.gmane.org>
	<20131112212536.6061477e@corrin.poochiereds.net>
	<5283E835.2090508@cora.nwra.com>
	<20131130053237.5ba7359d@tlielax.poochiereds.net>
	<529CE146.8090202@cora.nwra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Orion Poplawski <orion-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <529CE146.8090202-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 02 Dec 2013 12:36:38 -0700
Orion Poplawski <orion-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org> wrote:

> On 11/30/2013 03:32 AM, Jeff Layton wrote:
> > On Wed, 13 Nov 2013 13:59:33 -0700
> > Orion Poplawski <orion-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org> wrote:
> >
> >>  From e2e6e73f05d912377656675292994858b99cabbb Mon Sep 17 00:00:00 2001
> >> From: Orion Poplawski <orion-CfuHcwXVrUc@public.gmane.org>
> >> Date: Wed, 13 Nov 2013 13:53:30 -0700
> >> Subject: [PATCH] Create cifscreds PAM module to insert credentials at login
> >>
> >
> > Sorry for taking so long to review this. This looks like a good start.
> > FWIW, I'd like to see this merged for the next release, which should
> > happen in the next month or two.
> >
> 
> No problem, thanks for the review.
> 
> > When you think this is ready for merge, please resend with a real
> > '[PATCH]' tag in the subject, so I don't miss it...
> 
> Hopefully this is okay.
> 
> >> @@ -231,6 +236,7 @@ AM_CONDITIONAL(CONFIG_CIFSUPCALL, [test "$enable_cifsupcall" != "no"])
> >>   AM_CONDITIONAL(CONFIG_CIFSCREDS, [test "$enable_cifscreds" != "no"])
> >>   AM_CONDITIONAL(CONFIG_CIFSIDMAP, [test "$enable_cifsidmap" != "no"])
> >>   AM_CONDITIONAL(CONFIG_CIFSACL, [test "$enable_cifsacl" != "no"])
> >> +AM_CONDITIONAL(CONFIG_PAM, [test "$enable_pam" != "no" -o "$enable_pam" != "no"])
> >
> > Erm...you're testing the same thing twice here?
> 
> Oops, copy/paste error.
> 
> >
> > I think the autoconf stuff needs some work.
> >
> > If the box doesn't have what's needed to build it, the build is going
> > to fail unless someone explicitly disables CONFIG_PAM.
> >
> > Ideally, we'd build this by default and have autoconf test for what's
> > required to build the PAM module. If the build requires aren't present,
> > then the building of the PAM module should be disabled with a warning
> > message that states that.
> >
> > There are some other examples of that sort of behavior in configure.ac.
> > It's a little more complicated, but it makes life easier for people
> > building the package.
> 
> Okay, I've added a section for checking for security/pam_appl.h.  Should we 
> also check for the other headers/libraries as well?
> 
> I've also added to the keyutils.h section so as to disable the pam module 
> there too.
> 
> 
> >> +static void
> >> +free_password (char *password)
> >> +{
> >> +	volatile char *vp;
> >> +	size_t len;
> >> +
> >> +	if (!password) {
> >> +		return;
> >> +	}
> >> +
> >> +	/* Defeats some optimizations */
> >> +	len = strlen (password);
> >> +	memset (password, 0xAA, len);
> >> +	memset (password, 0xBB, len);
> >> +
> >> +	/* Defeats others */
> >> +	vp = (volatile char*)password;
> >> +	while (*vp) {
> >> +		*(vp++) = 0xAA;
> >> +	}
> >> +
> >
> > I'm all for scrubbing the pw memory but that seems a bit like overkill.
> > Got any references to cite about why you need to write over it 3 times?
> >
> > If that's really necessary, then we should move the password handling
> > in cifscreds and mount.cifs binary to use something like this too.
> > Maybe consider putting this in an a.out lib and linking it into all 3?
> 
> This is copied directly from the gnome-keyring pam module.  I don't have any 
> references for why it is done.  My guess is because it is part of a PAM chain, 
> so perhaps to prevent later modules from accessing it?  Or perhaps just to 
> scrub memory?  I suspect that the multiple times is to defeat compiler 
> optimization making it a no-op?
> 
> >> +
> >> +/**
> >> + * This is called when the PAM session is closed.
> >> + *
> >> + * Currently it does nothing.  The session closing should remove the passwords
> >> + *
> >> + * @param ph PAM handle
> >> + * @param flags currently unused, TODO: check for silent flag
> >> + * @param argc number of arguments for this PAM module
> >> + * @param argv array of arguments for this PAM module
> >> + * @return PAM_SUCCESS
> >> + */
> >> +PAM_EXTERN int pam_sm_close_session(pam_handle_t *ph, int flags, int argc, const char **argv)
> >> +{
> >> +	return PAM_SUCCESS;
> >> +}
> >> +
> >
> > Cleaning up after you're done seems like a good thing to do. The thing
> > we need to be careful about here is that we might still need these
> > creds to write out dirty data. This may require some consideration...
> 
> Yeah, I'm not sure what there is to do here really.  Anything would be more 
> than what is done currently running cifscreds directly.
> 
> >> +/**
> >> + * This is called when PAM is invoked to change the user's authentication token.
> >> + * TODO - update the credetials
> >> + *
> >> + * @param ph PAM handle
> >> + * @param flags currently unused, TODO: check for silent flag
> >> + * @param argc number of arguments for this PAM module
> >> + * @param argv array of arguments for this PAM module
> >> + * @return PAM_SUCCESS
> >> + */
> >> + PAM_EXTERN int pam_sm_setcred(pam_handle_t *ph, int flags, int argc, const char **argv)
> >> +{
> >> +	return PAM_SUCCESS;
> >> +}
> >
> > The rest looks reasonably straightforward, but I don't PAM that well,
> > so it's hard for me to comment.
> >
> 
> Actually, I'm not sure what should be done here.  gnome-keyring doesn't do 
> anything.  http://pubs.opengroup.org/onlinepubs/008329799/pam_sm_setcred.htm 
> describes the call.
> 
> Looks like the pam_sm_chauthtok function is used to update the passwords. 
> I've made attempts to implement that.
> 

Oh, and one other thing...

Can you resend the above patch with a Signed-off-by line?

Thanks,

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
