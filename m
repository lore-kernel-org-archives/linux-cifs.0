From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: proposed cifs.ko authentication overhaul
Date: Mon, 3 Dec 2012 07:46:39 -0500
Message-ID: <20121203074639.1a03d802@tlielax.poochiereds.net>
References: <20121130092751.16c83c3a@tlielax.poochiereds.net>
	<CAH2r5mtvpCXuhaT2W1A8+6NwMMaRZJwgERAo+3Rvrm8VD_XZEw@mail.gmail.com>
	<CAH2r5mu=a77eFwpBOz1nu0iE9Hw7dKF+hCwmROEqy8cM2+pEuw@mail.gmail.com>
	<20121202060456.372adbd8@tlielax.poochiereds.net>
	<CAH2r5mtYRcf8xu09iqPf2CHJbF2pBiV8nziwHwsXP708F3+XKQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtYRcf8xu09iqPf2CHJbF2pBiV8nziwHwsXP708F3+XKQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 2 Dec 2012 21:48:48 -0600
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> A few quick observations:
> 
> 1) since mounts in the global names space are implicit, and yet
> connect to multiple servers,  and you only get to specify security
> options on the initial mount - we have to be able to set a list of
> security mechanisms which are acceptable to the person doing the
> mount.  The common example of the problem of only allowing one "sec="
> option might be something like the following common case:
>     a) mount with krb5 to server1 (user specified "sec=krb5" since
> they couldn't use multiple sec options in todays code ie
> "sec=kbr5,sec=ntlmv2"  or "sec=krb5,ntlmv2")
>     b) dfs referral sends us to server2 which does not support krb5
> (or like many servers is simply misconfigured) but client won't
> negotiate ntlmv2 because the user required krb5
>     c) dfs referral fails, directory not accessible even though it
> could be accessed from every other cifs/smb2/smb3 client (except ours)
> 
> Another example:
>    a) user mounts with sec=ntlmv2, but server crashes and we failover
> to a mirror of that server (perhaps the server is one of those that
> supports ip address takeover, or even better this is an smb3
> continuously available share) - the other server only supports krb5 -
> so we fail to reconnect and lose data.
> 
> Both of these could be addressed if we allow multiple "sec=" mount
> options to be specified.   I don't think it matters which order we use
> as the "preferred" order (ie whether krb5 is always assumed to be
> better than ntlmv2 which is always better than ntlm, as I have
> suggested or whether you pick the first as the "preferred" mechanism).
> 
> A final example,
> mounting from fstab - if you don't allow specifying multiple sec=
> options you can fail automounts from fstab since you can't "retry" an
> fstab mount by specifying an "if this entry fails to mount, try a
> similar entry with different mount option" (if the server only
> supports ntlmv2 and you specify sec=krb5 or vice versa you are out of
> luck if you are automounting with a "sec=").  Note that there are
> obvious reasons why automatic mounts to different servers might
> specify different levels of security - the server which keeps home
> directories might require higher security for example.
> 
> Being able to specify something a list (persistent across boot) of
> acceptable authentication mechanisms (as samba does in smb.conf,
> windows does in the registry, and we do in
> /proc/fs/cifs/SecurityFlags) makes the need to have multiple "sec="
> less common (although still necessary).
> 

Sorry, I don't see the necessity for it. You have two choices here:

1/ live with the (sensible) defaults

2/ specify exactly what authentication type you want
 
In any case, that ability does not exist today, so I don't feel we'll
lose anything by punting on it initially.

If we can come to an agreement and I do this, then I'll try to engineer
it in a way that someone can add support for an ordered list of
sectypes later.

If you do want to add that though, then allowing someone to specify a
list of auth flavors means a new syntax. You cannot use multiple sec=
options since it's not clear what your intent is. The current code is
"last one wins" and if you try to change that, then you'll break it.

What you need to do is design a new syntax for passing in this ordered
list. Something like this:

    sec=krb5:ntlmssp:ntlmv2

Where they are attempted left to right.

> On Sun, Dec 2, 2012 at 5:04 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > As far as making a knob setting persistent...module options that can be
> > set in modprobe.conf or on the kernel command line are really the best
> > way.
> 
> that is fine with me - as long as they can be loaded from something
> persistent on disk, under administrator control.
> 

Now that I see your use cases above, then I really think that adding
this extra knob is the wrong approach. The auth method to use ought to
be governed solely by mount options. Anything else is extremely
confusing for users and will just be a headache.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
