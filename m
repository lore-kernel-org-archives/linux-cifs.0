From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [cifs-utils PATCH] cifs.upcall: trim even more capabilities
Date: Thu, 16 Feb 2017 12:44:51 -0500
Message-ID: <1487267091.3661.6.camel@samba.org>
References: <20170216145913.15848-1-jlayton@samba.org>
         <CAKywueQiDRKZPW3ev7OBmXea=h7W1bc_5rtf9Ds7NChVm6=gbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQiDRKZPW3ev7OBmXea=h7W1bc_5rtf9Ds7NChVm6=gbg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2017-02-16 at 09:28 -0800, Pavel Shilovsky wrote:
> 2017-02-16 6:59 GMT-08:00 Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> > We really only need CAP_DAC_READ_SEARCH, not CAP_DAC_OVERRIDE, and
> > only when we are going to probe the environ file.
> > 
> > Also, fix the non-libcap-ng trim_capabilities prototype.
> > 
> > Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > ---
> >  cifs.upcall.c | 17 ++++++++---------
> >  1 file changed, 8 insertions(+), 9 deletions(-)
> > 
> > diff --git a/cifs.upcall.c b/cifs.upcall.c
> > index 6d9c427b7032..dae58b919408 100644
> > --- a/cifs.upcall.c
> > +++ b/cifs.upcall.c
> > @@ -70,22 +70,21 @@ typedef enum _sectype {
> > 
> >  #ifdef HAVE_LIBCAP_NG
> >  static int
> > -trim_capabilities(bool need_ptrace)
> > +trim_capabilities(bool need_environ)
> >  {
> >         capng_clear(CAPNG_SELECT_BOTH);
> > 
> > -       /*
> > -        * Need PTRACE and DAC_OVERRIDE for environment scraping, SETGID to
> > -        * change gid and grouplist, and SETUID to change uid.
> > -        */
> > +       /* SETUID and SETGID to change uid, gid, and grouplist */
> >         if (capng_updatev(CAPNG_ADD, CAPNG_PERMITTED|CAPNG_EFFECTIVE,
> > -                       CAP_SETUID, CAP_SETGID, CAP_DAC_OVERRIDE, -1)) {
> > +                       CAP_SETUID, CAP_SETGID, -1)) {
> >                 syslog(LOG_ERR, "%s: Unable to update capability set: %m\n", __func__);
> >                 return 1;
> >         }
> > 
> > -       if (need_ptrace &&
> > -           capng_update(CAPNG_ADD, CAPNG_PERMITTED|CAPNG_EFFECTIVE, CAP_SYS_PTRACE)) {
> > +        /* Need PTRACE and DAC_OVERRIDE for environment scraping */
> 
> It seems that the comment above doesn't reflect the proposed change.
> Should it be DAC_READ_SEARCH instead?
> 

Yes! It should and it's fixed in the version in the tree.

Thanks,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
