From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: proposed cifs.ko authentication overhaul
Date: Fri, 30 Nov 2012 17:45:10 -0600
Message-ID: <CAH2r5mtvpCXuhaT2W1A8+6NwMMaRZJwgERAo+3Rvrm8VD_XZEw@mail.gmail.com>
References: <20121130092751.16c83c3a@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121130092751.16c83c3a-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Overhauling the authentication code is probably a good idea but
a couple quick thoughts:

1) we must have system wide, administrator controllable, security
defaults (samba does this, and every modern operating system
probably does this by now) - for the case of cifs
(and smb2/smb3) the features don't have to match Windows
but should include at least the following:
   - the ability to set signing on for all connection attempts
   - the ability to set either a list of security mechanisms which
     are acceptable (I recommend that we allow ntlmv2 and
     kerberos, and allow administrator to enable others if desired)
    or set a minimum security level (setting it lower e.g. might be
 allowing
     ntlm, or plaintext passwords) than recommended (presumably
     our minimum acceptable is ntlmv2) or higher (Kerberos).
     Alternatively
      -

On Fri, Nov 30, 2012 at 8:27 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Executive Summary:
> ------------------
> I want to overhaul the cifs.ko authentication code to handle
> autonegotiation better. This means a fair bit of user-visible changes,
> but I think they're mostly for the better. I don't want to do this work
> unless it's clear that the proposed design is acceptable though.
>
> Longer description:
> -------------------
> As I mentioned the other day, I'd like to see us overhaul the auth code
> in cifs.ko. I'm willing to do this work, but my attempt from several
> years ago was not merged. I'd like to ensure that the overall design
> is something everyone can live with before I embark upon coding
> anything.
>
> This may be tl;dr for most folks, but please do read it if you think
> you care about how all of this works, especially if you might end up
> reviewing this code.
>
> Why change anything?
> --------------------
> There are several reasons that I think the auth code needs an overhaul:
>
> 1/ The current code hamstrings the ability to properly autonegotiate
> the auth method to use. It currently decides what auth method it's
> going to use before ever contacting the server. This means that once
> you figure out that the server doesn't support the authentication that
> was decided, it's too late.
>
> 2/ The SecurityFlags interface is totally unintuitive. It makes zero
> sense to perpetuate the travesty of the SecurityFlags interface. For
> one thing, it's global so you have a server that requires plaintext
> passwords then you're stuck with that for all of the servers you need
> to talk to.
>
> 3/ Passing in multiple sec= options is broken. This can happen if you
> have a mount set up in /etc/fstab, and then pass extra options to it
> when mounting. The extra options get appended onto the end of the
> options string. In that situation, it's reasonable for a user to expect
> "last one wins", but the sec= option doesn't currently work that way.
> The secFlg's will get or'ed and you can end up using the first auth
> method even though you specified a different one on the command line.
>
> A proposed design for the user interface
> ----------------------------------------
> Here's a number of changes I'd like to make:
>
> 1/ Get rid of the SecurityFlags interface altogether, and simply
> require anyone who wants fine-grained control over the auth method to
> use specify a sec= option when mounting. If one isn't specified, then
> the code will be changed to use the a selection algorithm of its
> choosing (more on that later).
>
> 2/ Steve in particular has mentioned that he thinks there needs to be
> some mechanism to allow the admin to set system-wide security defaults.
> I don't think that's really necessary if we only allow the code to use
> authentication methods that we deem secure by default. Since the sec=
> mount option is only able to be specified by an administrator in the
> first place, I don't think it makes any sense to require the admin to
> also set specific module options in order to use a particular auth
> method.
>
> 3/ it may however make sense to allow an admin to require signing, or
> to enforce the disabling of signing altogether. A tristate module
> option could be added for that.
>
> If #2 isn't acceptable, then I'm willing to compromise. Perhaps we
> could add a boolean module option "disable weak crypto" or something.
>
> Proposed auth selection algorithm
> ---------------------------------
> Once we change the code not to decide the auth method before contacting
> the server, we can allow it to be a lot smarter about picking an auth
> scheme. The following applies to SMB1, things are simpler with SMB2,
> but we still will be living with SMB1 for a long, long time to come.
> Also, it's possible that in the future SMB3+ will introduce new auth
> schemes and we'll need a better selection mechanism for that than we
> have today.
>
> For SMB1, we'll set the SMBFLG2_EXT_SEC unconditionally in the NegProt
> request. We can then use the NegProt response to decide what auth
> method to use. If the server responds with that bit set, we'll try the
> methods specified in the SPNEGO response, in the specified order. With
> that change we can even try to use krb5 without requiring that sec=krb5
> be specified. We can try to upcall first and then fall back onto the
> next method if we don't get a ticket.
>
> If the server responds w/o setting SMBFLG2_EXT_SEC, then we'll try
> ntlmv2(i). If that fails, we'll give up. Trying anything lower will
> require that the admin set the sec= mount option.
>
> SMB2 support is still pretty crippled and only supports NTLMSSP
> currently, but eventually we'll need something similar for it to handle
> krb5 too.
>
> Thoughts?
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
