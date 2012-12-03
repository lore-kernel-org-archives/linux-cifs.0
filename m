From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: proposed cifs.ko authentication overhaul
Date: Sun, 2 Dec 2012 21:48:48 -0600
Message-ID: <CAH2r5mtYRcf8xu09iqPf2CHJbF2pBiV8nziwHwsXP708F3+XKQ@mail.gmail.com>
References: <20121130092751.16c83c3a@tlielax.poochiereds.net>
	<CAH2r5mtvpCXuhaT2W1A8+6NwMMaRZJwgERAo+3Rvrm8VD_XZEw@mail.gmail.com>
	<CAH2r5mu=a77eFwpBOz1nu0iE9Hw7dKF+hCwmROEqy8cM2+pEuw@mail.gmail.com>
	<20121202060456.372adbd8@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121202060456.372adbd8-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A few quick observations:

1) since mounts in the global names space are implicit, and yet
connect to multiple servers,  and you only get to specify security
options on the initial mount - we have to be able to set a list of
security mechanisms which are acceptable to the person doing the
mount.  The common example of the problem of only allowing one "sec="
option might be something like the following common case:
    a) mount with krb5 to server1 (user specified "sec=krb5" since
they couldn't use multiple sec options in todays code ie
"sec=kbr5,sec=ntlmv2"  or "sec=krb5,ntlmv2")
    b) dfs referral sends us to server2 which does not support krb5
(or like many servers is simply misconfigured) but client won't
negotiate ntlmv2 because the user required krb5
    c) dfs referral fails, directory not accessible even though it
could be accessed from every other cifs/smb2/smb3 client (except ours)

Another example:
   a) user mounts with sec=ntlmv2, but server crashes and we failover
to a mirror of that server (perhaps the server is one of those that
supports ip address takeover, or even better this is an smb3
continuously available share) - the other server only supports krb5 -
so we fail to reconnect and lose data.

Both of these could be addressed if we allow multiple "sec=" mount
options to be specified.   I don't think it matters which order we use
as the "preferred" order (ie whether krb5 is always assumed to be
better than ntlmv2 which is always better than ntlm, as I have
suggested or whether you pick the first as the "preferred" mechanism).

A final example,
mounting from fstab - if you don't allow specifying multiple sec=
options you can fail automounts from fstab since you can't "retry" an
fstab mount by specifying an "if this entry fails to mount, try a
similar entry with different mount option" (if the server only
supports ntlmv2 and you specify sec=krb5 or vice versa you are out of
luck if you are automounting with a "sec=").  Note that there are
obvious reasons why automatic mounts to different servers might
specify different levels of security - the server which keeps home
directories might require higher security for example.

Being able to specify something a list (persistent across boot) of
acceptable authentication mechanisms (as samba does in smb.conf,
windows does in the registry, and we do in
/proc/fs/cifs/SecurityFlags) makes the need to have multiple "sec="
less common (although still necessary).

On Sun, Dec 2, 2012 at 5:04 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> As far as making a knob setting persistent...module options that can be
> set in modprobe.conf or on the kernel command line are really the best
> way.

that is fine with me - as long as they can be loaded from something
persistent on disk, under administrator control.

>> I would also prefer that we set security settings differently for SMB3 (higher)
>> due e.g. to the performance improvements of signing that were noted
>> in various conference presentations.  I am not convinced that we even
>> need to allow anything other than ntlmv2 and Kerberos for SMB3.
>> We don't want to encourage users to use near-useless security
>> mechanisms.
>>
>
> Sure. Each version is going to end up with its own negotiation
> "path" anyway. While NTLMSSP and krb5 are what's available now for
> SMB2/3, it's hard to know if there might be another auth type added in
> later. I intend to engineer this in such a way that we can easily add
> support for different auth types in the future without having to
> overhaul everything.

Also note that due to SMB3 share encryption we will need to allow
requesting share encryption on mount (which will need to be stored
per-tcon or per-superblock rather than per-smb session - so we
reconnect properly).

>> On Fri, Nov 30, 2012 at 5:45 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> > Overhauling the authentication code is probably a good idea but
>> > a couple quick thoughts:
>> >
>> > 1) we must have system wide, administrator controllable, security
>> > defaults (samba does this, and every modern operating system
>> > probably does this by now) - for the case of cifs
>> > (and smb2/smb3) the features don't have to match Windows
>> > but should include at least the following:
>> >    - the ability to set signing on for all connection attempts
>> >    - the ability to set either a list of security mechanisms which
>> >      are acceptable (I recommend that we allow ntlmv2 and
>> >      kerberos, and allow administrator to enable others if desired)
>> >     or set a minimum security level (setting it lower e.g. might be
>> >  allowing
>> >      ntlm, or plaintext passwords) than recommended (presumably
>> >      our minimum acceptable is ntlmv2) or higher (Kerberos).
>> >      Alternatively
>> >       -
>> >>
>> >> SMB2 support is still pretty crippled and only supports NTLMSSP
>> >> currently, but eventually we'll need something similar for it to handle
>> >> krb5 too.

Yes - absolutely, and additional authentication mechanisms are likely
(presumably wrapped in Spnego)


-- 
Thanks,

Steve
