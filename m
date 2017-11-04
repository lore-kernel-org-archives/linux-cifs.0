From: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [cifs-utils PATCH v2] manpage: update mount.cifs manpage with
 info about default version being mounted
Date: Sat, 04 Nov 2017 07:33:05 -0400
Message-ID: <1509795185.29302.5.camel@kernel.org>
References: <20171031160224.12523-1-jlayton@kernel.org>
         <CAKywueR4DpsM72EK6u=6PHRm+uD6m8vJWnmHfhYzUuYfFn1oNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        =?ISO-8859-1?Q?Aur=E9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueR4DpsM72EK6u=6PHRm+uD6m8vJWnmHfhYzUuYfFn1oNA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2017-10-31 at 10:45 -0700, Pavel Shilovsky wrote:
> 2017-10-31 9:02 GMT-07:00 Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> > From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > 
> > Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > ---
> >  mount.cifs.rst | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > Thanks Aurelien. I dropped Ronnie's Reviewed-by since this is a bit different.
> > Let me know if you'd like me to add it back.
> > 
> > diff --git a/mount.cifs.rst b/mount.cifs.rst
> > index 9714f795fe76..01305df60651 100644
> > --- a/mount.cifs.rst
> > +++ b/mount.cifs.rst
> > @@ -517,7 +517,7 @@ prefixpath=arg
> >  vers=arg
> >    SMB protocol version. Allowed values are:
> > 
> > -  - 1.0 - The classic CIFS/SMBv1 protocol. This is the default.
> > +  - 1.0 - The classic CIFS/SMBv1 protocol.
> >    - 2.0 - The SMBv2.002 protocol. This was initially introduced in
> >      Windows Vista Service Pack 1, and Windows Server 2008. Note that
> >      the initial release version of Windows Vista spoke a slightly
> > @@ -529,6 +529,9 @@ vers=arg
> >    Note too that while this option governs the protocol version used, not
> >    all features of each version are available.
> > 
> > +  In kernels v4.13 and later, the client and server negotiate a version greater
> > +  than or equal to ``2.1``. In kernels prior to v4.13, the default is ``1.0``.
> > +
> 
> The multi-dialect negotiation (version 2.1 and above) was added in
> v4.13.5 kernel. Should we mention the specific stable version in the
> doc?
> 

It would be very odd to make that sort of change in a stable series
kernel. What patch actually flipped the default to autonegotiate?

I was assuming that it was eef914a9eb5eb83e60eb498315a491cd1edc13a1:

    $ git tag --contains eef914a9eb5eb83e60eb498315a491cd1edc13a1 | grep v4.13$
    v4.13

git says that that commit went into v4.13. Was it a different one?
-- 
Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
