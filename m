From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: extend the buffer length enought for sprintf()
 using
Date: Fri, 19 Jul 2013 15:48:30 -0400
Message-ID: <20130719154830.4b9d8c39@tlielax.poochiereds.net>
References: <51E5E9DA.8020603@asianux.com>
	<CAFB9KM2nJEt-O+o=4bkxNMJ2Fr0TfjkpRF=7B98=Lp9zFu8_og@mail.gmail.com>
	<20130719135115.2ebff0cd@tlielax.poochiereds.net>
	<CAFB9KM1cP1rvnO66+9kz+zVhVOf+C-dAR7mVMx_uX9hT-ORLsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org>,
	"sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org" <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFB9KM1cP1rvnO66+9kz+zVhVOf+C-dAR7mVMx_uX9hT-ORLsw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 19 Jul 2013 15:32:29 -0400
Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Jul 19, 2013 at 1:51 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Tue, 16 Jul 2013 21:58:19 -0400
> > Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > > On Tue, Jul 16, 2013 at 8:48 PM, Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org> wrote:
> > > > For cifs_set_cifscreds() in "fs/cifs/connect.c", 'desc' buffer length
> > > > is 'CIFSCREDS_DESC_SIZE' (56 is less than 256), and 'ses->domainName'
> > > > length may be "255 + '\0'".
> > > >
> > > > The related sprintf() may cause memory overflow, so need extend related
> > > > buffer enough to hold all things.
> > > >
> > > > It is also necessary to be sure of 'ses->domainName' must be less than
> > > > 256, and define the related macro instead of hard code number '256'.
> > > >
> > > > Signed-off-by: Chen Gang <gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org>
> > > > ---
> > > >  fs/cifs/cifsencrypt.c |    2 +-
> > > >  fs/cifs/cifsglob.h    |    1 +
> > > >  fs/cifs/connect.c     |    7 ++++---
> > > >  fs/cifs/sess.c        |    6 +++---
> > > >  4 files changed, 9 insertions(+), 7 deletions(-)
> > > >
> > > > diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> > > > index 45e57cc..ce2d331 100644
> > > > --- a/fs/cifs/cifsencrypt.c
> > > > +++ b/fs/cifs/cifsencrypt.c
> > > > @@ -421,7 +421,7 @@ find_domain_name(struct cifs_ses *ses, const struct nls_table *nls_cp)
> > > >                 if (blobptr + attrsize > blobend)
> > > >                         break;
> > > >                 if (type == NTLMSSP_AV_NB_DOMAIN_NAME) {
> > > > -                       if (!attrsize)
> > > > +                       if (!attrsize || attrsize >= MAX_CIF_DOMAINNAME)
> > > >                                 break;
> > > >                         if (!ses->domainName) {
> > > >                                 ses->domainName =
> > > > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > > > index 33f17ed..88280e0 100644
> > > > --- a/fs/cifs/cifsglob.h
> > > > +++ b/fs/cifs/cifsglob.h
> > > > @@ -396,6 +396,7 @@ struct smb_version_values {
> > > >
> > > >  #define HEADER_SIZE(server) (server->vals->header_size)
> > > >  #define MAX_HEADER_SIZE(server) (server->vals->max_header_size)
> > > > +#define MAX_CIF_DOMAINNAME 256 /* 255 + '\0' */
> > > >
> > > >  struct smb_vol {
> > > >         char *username;
> > > > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > > > index fa68813..ed6bf20 100644
> > > > --- a/fs/cifs/connect.c
> > > > +++ b/fs/cifs/connect.c
> > > > @@ -1675,7 +1675,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
> > > >                         if (string == NULL)
> > > >                                 goto out_nomem;
> > > >
> > > > -                       if (strnlen(string, 256) == 256) {
> > > > +                       if (strnlen(string, MAX_CIF_DOMAINNAME)
> > > > +                                       == MAX_CIF_DOMAINNAME) {
> > > >                                 printk(KERN_WARNING "CIFS: domain name too"
> > > >                                                     " long\n");
> > > >                                 goto cifs_parse_mount_err;
> > > > @@ -2276,8 +2277,8 @@ cifs_put_smb_ses(struct cifs_ses *ses)
> > > >
> > > >  #ifdef CONFIG_KEYS
> > > >
> > > > -/* strlen("cifs:a:") + INET6_ADDRSTRLEN + 1 */
> > > > -#define CIFSCREDS_DESC_SIZE (7 + INET6_ADDRSTRLEN + 1)
> > > > +/* strlen("cifs:a:") + MAX_CIF_DOMAINNAME + 1 */
> > > > +#define CIFSCREDS_DESC_SIZE (7 + MAX_CIF_DOMAINNAME + 1)
> > > >
> > > >  /* Populate username and pw fields from keyring if possible */
> > > >  static int
> > > > diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> > > > index 79358e3..106a575 100644
> > > > --- a/fs/cifs/sess.c
> > > > +++ b/fs/cifs/sess.c
> > > > @@ -197,7 +197,7 @@ static void unicode_domain_string(char **pbcc_area, struct cifs_ses *ses,
> > > >                 bytes_ret = 0;
> > > >         } else
> > > >                 bytes_ret = cifs_strtoUTF16((__le16 *) bcc_ptr, ses->domainName,
> > > > -                                           256, nls_cp);
> > > > +                                           MAX_CIF_DOMAINNAME, nls_cp);
> > > >         bcc_ptr += 2 * bytes_ret;
> > > >         bcc_ptr += 2;  /* account for null terminator */
> > > >
> > > > @@ -255,8 +255,8 @@ static void ascii_ssetup_strings(char **pbcc_area, struct cifs_ses *ses,
> > > >
> > > >         /* copy domain */
> > > >         if (ses->domainName != NULL) {
> > > > -               strncpy(bcc_ptr, ses->domainName, 256);
> > > > -               bcc_ptr += strnlen(ses->domainName, 256);
> > > > +               strncpy(bcc_ptr, ses->domainName, MAX_CIF_DOMAINNAME);
> > > > +               bcc_ptr += strnlen(ses->domainName, MAX_CIF_DOMAINNAME);
> > > >         } /* else we will send a null domain name
> > > >              so the server will default to its own domain */
> > > >         *bcc_ptr = 0;
> > > > --
> > > > 1.7.7.6
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> > > If this is correct for the domain size, MAX_DOMAIN_SIZE in the
> > > cifs-utils mount helper (mount.cifs.c) has to be changed.  It is
> > > currently 64 + null terminator.  I can open a bug and patch it if this
> > > is correct.
> > >
> > > CC'ing Jeff Layton since he maintains the cifs-utils package.
> > >
> >
> > Yep, it probably should be extended out to 256. Send a patch when you
> > get a chance and I'll plan to review and merge it.
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> 
> I can get to it this afternoon. :)
> 
> What do you want to do about the conflicting MAX_SHARE_SIZE?  The
> kernel allows 80, we use 256 in the mount helper.  Right now we can
> potentially pass in a string that's too long and it'll be kicked back
> from the kernel.  I guess it could be bad if anyone ever forgets to
> check the string before using it on the kernel side.  A quick Googling
> suggests that the kernel side code is correct
> (http://support.microsoft.com/kb/916525) about 80 characters.
> 
> I've made the other MAX_* defines match up with the kernel side
> because the mount helper is too conservative with string lengths, this
> is the only case where it's too liberal.

Sure, sounds fine. Might as well fix up all that you can find...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
