From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifscreds: add a check and warning for missing session
 keyring
Date: Wed, 18 Jul 2012 06:29:05 -0400
Message-ID: <20120718062905.73e14efe@tlielax.poochiereds.net>
References: <1342531717-30135-1-git-send-email-jlayton@samba.org>
	<30167.1342557999@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <30167.1342557999-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 17 Jul 2012 21:46:39 +0100
David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> 
> > +static void
> > +check_session_keyring(void)
> > +{
> > +	key_serial_t	ses_key, uses_key;
> > +
> > +	ses_key = keyctl_get_keyring_ID(KEY_SPEC_SESSION_KEYRING, 0);
> > +	if (ses_key == -1)
> > +		return;
> > +
> > +	uses_key = keyctl_get_keyring_ID(KEY_SPEC_USER_SESSION_KEYRING, 0);
> > +	if (uses_key == -1)
> > +		return;
> > +
> > +	if (ses_key == uses_key)
> > +		fprintf(stderr, "Warning: you have no session keyring. "
> > +				"cifscreds keys will not persist. See "
> > +				"pam_keyinit(8).\n");
> > +}
> 
> I would suggest reporting an error and exiting in the event that certainly the
> first call returns -1 and maybe the second.
> 


Yeah, I considered that. I figured the follow-on keyctl() calls would
end up erroring out, but I suppose doing it at this point would be more
efficient. I'll respin the patch in a bit...

> Other than that, it looks okay.
> 
> I wonder if I should suggest giving an error if you try and modify the session
> keyring when there isn't one (where modification includes adding a key to it).
> When I first did the keyring stuff in the kernel, I didn't envision pam_keyinit
> - which in retrospect is a much better way of generating the session keyring
> than having the kernel try to guess.
> 
> Note that this would not stop processes joining a session keyring or creating a
> new session keyring.
> 

That might be more reasonable. Spawning a new session keyring on the
fly like is done today seems to be of questionable value.


Thanks,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
