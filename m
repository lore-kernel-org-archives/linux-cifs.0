From: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [cifs-utils PATCH v3] manpage: update mount.cifs manpage with
 info about default version being mounted
Date: Sun, 05 Nov 2017 08:35:42 -0500
Message-ID: <1509888942.4773.6.camel@kernel.org>
References: <20171104205151.3507-1-jlayton@kernel.org>
         <CAKywueRMN0-NfUVsBra+wRCsA0N8jwG+J3FqQUt5K18favSA=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        =?ISO-8859-1?Q?Aur=E9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        Pavel Shilovskiy <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueRMN0-NfUVsBra+wRCsA0N8jwG+J3FqQUt5K18favSA=Q@mail.gmail.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 2017-11-04 at 18:27 -0700, Pavel Shilovsky wrote:
> 2017-11-04 13:51 GMT-07:00 Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>:
> > From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > 
> > Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> > ---
> >  mount.cifs.rst | 7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/mount.cifs.rst b/mount.cifs.rst
> > index 9714f795fe76..499b9a778927 100644
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
> > @@ -529,6 +529,10 @@ vers=arg
> >    Note too that while this option governs the protocol version used, not
> >    all features of each version are available.
> > 
> > +  In kernels v4.13.5 and later, the client and server negotiate a version
> > +  greater than or equal to ``2.1``. In kernels prior to v4.13.5, the default
> > +  is ``1.0``.
> 
> Between v4.13 and v4.13.4 (included) the default is 3.0, not sure if
> we should be so precise here.
> 

Grumble...the merge of that feature outside the normal merge window
makes this difficult to document. How about this?

    The default since v4.13.5 is for the client and server to negotiate 
    the highest possible version greater than or equal to ``2.1``. In
    kernels prior to v4.13, the default was ``1.0``. For kernels
    between v4.13 and v4.13.5 the default is ``3.0``.

It's still awkward, but I think it's correct.

> > +
> >  --verbose
> >    Print additional debugging information for the mount. Note that this
> >    parameter must be specified before the ``-o`` . For example::
> > @@ -857,4 +861,3 @@ Steve French
> >  The maintainer of the Linux cifs vfs and the userspace tool mount.cifs
> >  is Steve French. The Linux CIFS Mailing list is the preferred place to
> >  ask questions regarding these programs.
> > -
> > \ No newline at end of file
> > --
> > 2.13.6
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> Best regards,
> Pavel Shilovsky

-- 
Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
