From: Isaac Boukris <iboukris-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [cifs-utils PATCHv2 0/6] cifs.upcall: cleanup and overhaul of the
 cifs.upcall krb5 handling code
Date: Sat, 27 Aug 2016 20:11:41 +0300
Message-ID: <CAC-fF8TBygxZG8eP2LMAVknR00yfqP7Ar1BsQ-cVrDZJr_jyoA@mail.gmail.com>
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
> Ahh that's interesting. I didn't realize we'd be stuck having to handle
> a multi-stage negotiation if we use gss_init_sec_context. That is sort
> of difficult to handle with the way the upcall currently works.


Note that technically I think the current upcall code could still
switch from krb5 api to gssapi, but the manual spngo wrapping will
still be needed.
