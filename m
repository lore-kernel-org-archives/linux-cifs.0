From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: use standard token parser for mount options
Date: Wed, 14 Mar 2012 20:47:57 +0000
Message-ID: <1331758077.3054.15.camel@localhost>
References: <90445c03-bbcc-4faf-afbf-fde4b1d17f05@zmail17.collab.prod.int.phx2.redhat.com>
	 <4F60FC5C.3050507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F60FC5C.3050507-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2012-03-14 at 16:15 -0400, Scott Lovenberg wrote:
> On 3/14/2012 3:58 PM, Sachin Prabhu wrote:
> > ----- Original Message -----
> >> I don't mind reviewing this, but it does appear to change behaviour
> >> significantly from existing code.  Does this fix a reported bug?
> >>
> >> The linux cifs kernel driver, like some other
> >> network clients, allows partial option matching to ease
> >> usability for users of other platforms (e.g. "pass" or
> >> "passwd" or "password" are intentionally all accepted
> >> since we match on the first four bytes of that keyword).
> >> Is there a way to get that to work with your patchset.
> >> I worry that some users will be confused that their
> >> mount options won't work if this is taken.
> >>
> > The reason I was looking at this code was because I was helping Jeff include in the sloppy mount option for cifs. The current if/elseif block is difficult to read through. There are also hidden gotchas like ordering the if blocks correctly if in case a mount option is also a substring in a different mount option. The decision to use the standard token parser was simply for consistency and to make the code easier to understand.
> >
> > Multiple versions of mount options can be accepted for the same mount option. For example, in the patch sent earlier, for the password, we accept the following mount options to pass the password.
> >
> >
> > +       { Opt_pass, "pass=%s" },
> > +       { Opt_pass, "password=%s" },
> >
> > So the user can use pass or password and they will both be accepted as the mount option to set the password.
> > We can add more options if I have missed any.
> >
> > The only difference I see is that the options matching is case sensitive and therefore will reject upper case mount options.
> >
> > Also, in my opinion the number of mount options is large at the moment and we should consider deprecating a few of the mount options.
> >
> > Sachin Prabhu
> >
> 
> Would this patchset be a reasonable compromise? This is the one I was 
> talking about in my last email. 
> http://samba.2283325.n4.nabble.com/Add-token-parsing-for-kernel-CIFS-mount-options-td2517375.html
> 
> Also, some mount options are synonyms for other mount options, they can 
> be combined.

That patch will definitely help when it comes to cleaning up the code to
make it easier to read. However this will still result in cifs using its
own parser instead of relying on the default one. 

Also we will still need to carefully order the if conditions to prevent
cases where one mount option is a substring of the another causing false
positives. 
ex: In the current parser, 'nouser_xattr' must be checked for before we
check for 'user' mount option.


> Which were you thinking about deprecating?  RHEL/SLED probably aren't 
> going to like shipping a kernel with deprecated mount options.  That's 
> more of a political problem, but a problem nonetheless.

I would start by reducing the synonyms. 
For example, dom, domain, workgroup all allow the user to set the
workgroup. ip & addr allow the user to set the ip addresses.

Sachin Prabhu
