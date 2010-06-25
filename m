From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Build infrastructure for storing NTLM creds in kernel keyring
Date: Fri, 25 Jun 2010 16:16:32 -0400
Message-ID: <20100625161632.5f9378b2@tlielax.poochiereds.net>
References: <20100430091431.624ee020@tlielax.poochiereds.net>
	<EB4CC79E8F0546FF8AFBFD746C856421@lan.jax.org.ru>
	<20100525121037.219129da@corrin.poochiereds.net>
	<2AF95C52855747BABAE21349F35C773E@lan.jax.org.ru>
	<20100601074406.5b8f7a87@tlielax.poochiereds.net>
	<73A4A0D322484441A6CEF0FE91E5D263@lan.jax.org.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Igor Druzhinin" <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <73A4A0D322484441A6CEF0FE91E5D263-PUkIMHyhFB22ZuJnPpCLiw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 25 Jun 2010 22:36:04 +0400
"Igor Druzhinin" <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> > I think the right thing to do is to not worry about upcalls for this at
> > first. Instead I think you'll want to create something like a
> > "ntlminit" program that takes user, password and host or domainname and
> > puts that information in the keyring. Then just fix the kernel to look
> > in the keyring for that information when doing a session setup.
> >
> > Eventually you may want to allow the kernel to upcall for these but you
> > have to figure out how that upcall should get those creds. Should it
> > try to prompt a user somehow? What if the process is being run out of
> > cron?
> >
> > To use the PAM mechanism you'll need to write a PAM module for it
> > (probably an authentication module). This is also something I wouldn't
> > worry about yet. That can be done later once you have the initial code
> > working.
> 
> I've already started to write some code for a project and if I understood 
> correctly I see its design as follows.
> 
> Some userspace program (in my opinion, it may be mount.cifs helper program) 
> checks the user-specific keyring for credentials on current user name and 
> the destination host or domain name. If there is no one, it requests the 
> password else it uses them. Then it tries to mount the resource. If it's ok 
> then it puts the requested password or precalculated NT session key in the 
> payload of key of some type (own registered type or "user"), the user and 
> the domain name or destination server address could be saved in the key 
> description. On CIFS session establishing the kernel can call request_key() 
> and find the appropriate credentials in the user's keyring under the 
> description and type
> 
> Is this a correct realisation algorithm or it should be in other way? 

cc'ing linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org to bring the discussion to a wider
audience...

That's not quite what I had envisioned. The main reason for putting
NTLM creds into the keyring is so that the kernel can fetch them when
it needs to establish a session. Right now that only happens at mount
time, but that will change when support for multisession mounts goes in.

At that point, the kernel will need to be able to fetch credentials for
users that were not involved in mounting the share. This would allow us
to use NTLM credentials instead of krb5 creds on a multisession mount.

So really what I was envisioning is a standalone program that puts
username/password/domain_or_hostname into the keyring. I had sort of
pictured an "ntlminit" program, similar to how krb5's kinit works
today. Instead of putting kerberos creds into a ccache though, it would
put NTLM creds into the keyring.

Along with that, we want a way for the kernel to use this info to
establish sessions. For now, that mostly occurs at mount time, but
eventually we want to be able to upcall for this info on the fly so
that we can do multisession mounts without requiring kerberos.

>From root's standpoint with the code as it stands today, they might
do something like:

# ntlminit -u username -h hostname
Password: 
# mount -t cifs -o sec=ntlmv2 //server/share /mnt/mountpoint

...mount.cifs could then be modified to look and see whether there are
already creds in the keyring that are suitable for the mount. If there
are, then it could skip querying for the password.

> Is it preffered to register own type of key?

Yes, you'll probably want your own keytype for this, but maybe one of
the user keytypes would be a better choice. You'll probably need to do
a little research to figure out what's most suitable. I'm not yet clear
on whether a userspace program is allowed to spawn a new keytype.

> Where else it is necessary to look up keyrings for credentials except
> for session establishing on mount operation?

During session establishment. In the current code, that's limited to
mount and reconnect times. When multisession mounts go in, then it will
be able to happen any time a "new" user enters the mount. The code
needs to be written with that in mind.

Let me know if you have other questions...

Cheers,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
