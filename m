From: Simo <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [cifs-utils PATCHv2 0/6] cifs.upcall: cleanup and overhaul of
 the cifs.upcall krb5 handling code
Date: Sat, 27 Aug 2016 17:25:23 -0400
Message-ID: <1472333123.3226.3.camel@samba.org>
References: <1472134665-4014-1-git-send-email-jlayton@samba.org>
         <CAC-fF8S_K49oDzNMQ8PrjWyWEokdsRo2gC5xUQobWe4TTBYaCA@mail.gmail.com>
         <1472143488.3160.7.camel@samba.org> <1472215575.17759.3.camel@samba.org>
         <CAC-fF8TP8T_qzmLNjTcs-u+nG46WWsEVyEQMqRBdgscQno3L5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        jfdey-rEd9KcVInK8dYYaOPf09RA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Isaac Boukris <iboukris-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAC-fF8TP8T_qzmLNjTcs-u+nG46WWsEVyEQMqRBdgscQno3L5g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 2016-08-27 at 21:06 +0300, Isaac Boukris wrote:
> On Fri, Aug 26, 2016 at 3:46 PM, Simo <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> > 
> > The only thing we need to add kernel side (besides interfaces in
> > cifs.ko to use sunrpc) is a few xdr unmarshalling functions that
> > were
> > removed at the time of the knfsd submission because unused.
> 
> 
> Are you referring to missing gssx*init_sec_context? Could this
> removed
> code be found online?

I do not remember if I had fully implemented that one, but I know I
implemented a number of other unmarshalling/marshalling functions that
will be needed to implement it.

I can dig the code tomorrow, I should still have a git tree around with
the old patches if the garbage collector have not run in the meanwhile.

Simo.
