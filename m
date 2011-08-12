From: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: remove local xattr definitions
Date: Fri, 12 Aug 2011 12:44:55 +1000 (EST)
Message-ID: <alpine.LRH.2.00.1108121244250.14779@tundra.namei.org>
References: <1313090079-25859-1-git-send-email-zohar@linux.vnet.ibm.com> <CACLa4ptNaOvwFX-2VPBve=PBvnB7X85tzTnTPSLtprbT8vSGgw@mail.gmail.com> <1313092847.3122.13.camel@localhost.localdomain> <CAH2r5muSOM=haAXHg+ys05vgJ30m94g_NQz-Y2AgMDkmV1dbiw@mail.gmail.com>
 <alpine.LRH.2.00.1108121047540.14215@tundra.namei.org> <20110812114919.2797815cf41cd69048e1d3cf@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
	Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>,
	linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	David Safford <safford-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>,
	Mimi Zohar <zohar-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110812114919.2797815cf41cd69048e1d3cf-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 12 Aug 2011, Stephen Rothwell wrote:

> Except then that could leave Linus' tree broken during the next merge
> window depending on the order he merges the cifs and security-testing
> trees.  Unless that patch is sent to Linus as a fix patch before the next
> merge window, of course.
> 
> I will add this patch as a merge fixup to the merge of the
> security-testing tree for today.  And will remove my copy when one of the
> trees gets fixed.

I'll put it in my tree, then.

> James: maybe I should change the name of your tree in -next to just
> "security"?

Sure.


-- 
James Morris
<jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
