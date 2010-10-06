From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 11/15] cifs: fix cifs_show_options to show "username=" or "multiuser"
Date: Tue, 5 Oct 2010 22:24:01 -0500
Message-ID: <AANLkTik=rQSkBv1R7A3b-ZGPa2sOpw0_aLRKDMMzjQaQ@mail.gmail.com>
References: <1285023704-2159-1-git-send-email-jlayton@redhat.com>
	<1285023704-2159-12-git-send-email-jlayton@redhat.com>
	<AANLkTikafmJ14vib9-0SPZ6AaTmjpeps7VGzd5SSgoni@mail.gmail.com>
	<AANLkTimkxBpNLN+pAXaKsXf5dPy19LFeszjadCyjCeGH@mail.gmail.com>
	<20101005181958.065772d5@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101005181958.065772d5-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Oct 5, 2010 at 5:19 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Tue, 5 Oct 2010 17:01:18 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> In reviewing this patch which changes the show_options on cifs mounts
>> to not display the network username (when multiuser mount flag is
>> turned on) ie not display the username sent on SMB SessionSetup.
>>
>
> 1) with krb5 it's absolutely worthless since we generally manufacture a
> username based on the fsuid for multiuser mounts.

krb5 has principal names ... not much different from usernames

> 2) /proc/mounts is probably the wrong interface for such a thing.
> When/if we are able to make multiuser mounts using non-krb5 auth, then
> the user should be able to get at that info via the keyring...
>
>> 2) In the future can't the domain name differ as well (so should we
>> special case the domain name - or perhaps showing the default domain
>> is fine?)
>>
>
> Maybe. But for now there aren't multiple domains per mount. I think we
> ought to keep this as simple as possible. We can always change that
> later if the need arises.

In the krb5 case you can have different realm names now but I agree
that we use the same default domain name for the mount.

-- 
Thanks,

Steve
