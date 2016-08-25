From: Isaac Boukris <iboukris-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [cifs-utils PATCHv2 0/6] cifs.upcall: cleanup and overhaul of the
 cifs.upcall krb5 handling code
Date: Thu, 25 Aug 2016 22:59:06 +0300
Message-ID: <CAC-fF8RE-D=2wiSixiyXw7mR3Z8OeHD5GWtRkibuP9DNseGQuA@mail.gmail.com>
References: <1472134665-4014-1-git-send-email-jlayton@samba.org>
 <CAC-fF8S_K49oDzNMQ8PrjWyWEokdsRo2gC5xUQobWe4TTBYaCA@mail.gmail.com> <1472143488.3160.7.camel@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jfdey-rEd9KcVInK8dYYaOPf09RA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472143488.3160.7.camel-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Aug 25, 2016 at 7:44 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Thu, 2016-08-25 at 19:05 +0300, Isaac Boukris wrote:
>> However, it gets more complicated when it comes to SPNEGO.
>> First, when I call gss_init_sec_context with SPNEGO mech it will
>> always return GSS_S_CONTINUE_NEEDED as it need server response in
>> order to complete (even if mutual auth is not requested).
>> This causes (I think) the call to gss_inquire_sec_context_by_oid to
>> fail.
>> Also, we need to support continuation anyway for mutual auth and NTLM
>> fallback.
>>
>
> Ahh that's interesting. I didn't realize we'd be stuck having to handle
> a multi-stage negotiation if we use gss_init_sec_context. That is sort
> of difficult to handle with the way the upcall currently works.
>
> I may still play with it just to verify that I understand what you're
> saying but it does make sense.


You may take look at my (dirty) draft:
https://github.com/frenche/cifs-utils/tree/gssapi_upcall

> If we're going to go down the road of changing the upcall to handle
> that then I think I'd prefer to just change cifs.ko over to use
> gssproxy directly, like knfsd already does.
>
> It would be one less special snowflake to deal with and most of the
> plumbing is already in place. We could leave the old upcall in place
> for legacy userland case, and only do it if the gssproxy negotiation
> failed. It's a bit of a project, but would be totally doable.


The cifs kernel module will need some changes anyway to handle
multi-stage negotiation I think.
Using gssproxy sounds like an excellent idea, though I'm only vaguely
familiar with it so I'll have to look it up.

On the other hand I think there may still be an interest for stateless
mechanism (alongside) which wouldn't require a running daemon.
I'm trying to think of an alternative to exporting the gss context,
perhaps by keeping the upcall process running and continuing the
conversation with the kernel module somehow.

With best regards,
Isaac B.
