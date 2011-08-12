From: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] CIFS: remove local xattr definitions
Date: Fri, 12 Aug 2011 10:48:27 +1000 (EST)
Message-ID: <alpine.LRH.2.00.1108121047540.14215@tundra.namei.org>
References: <1313090079-25859-1-git-send-email-zohar@linux.vnet.ibm.com> <CACLa4ptNaOvwFX-2VPBve=PBvnB7X85tzTnTPSLtprbT8vSGgw@mail.gmail.com> <1313092847.3122.13.camel@localhost.localdomain>
 <CAH2r5muSOM=haAXHg+ys05vgJ30m94g_NQz-Y2AgMDkmV1dbiw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1665246916-429493442-1313110107=:14215"
Cc: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>,
	Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>,
	linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Safford <safford-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>,
	Mimi Zohar <zohar-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muSOM=haAXHg+ys05vgJ30m94g_NQz-Y2AgMDkmV1dbiw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1665246916-429493442-1313110107=:14215
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 11 Aug 2011, Steve French wrote:

> makes sense - do we want this going through the cifs tree or as part
> of the xattr change mentioned below.

Should be fine to go into the CIFS tree, as long as that is in -next.


> 
> On Thu, Aug 11, 2011 at 3:00 PM, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> > On Thu, 2011-08-11 at 15:29 -0400, Eric Paris wrote:
> >> Not that this patch is wrong, but shouldn't cifs include xattr.h
> >> directly rather than rely on such an obscure indirect callchain as
> >> well?
> >>
> >> -Eric
> >
> > True, updated below.
> >
> > thanks,
> >
> > Mimi
> >
> > ---
> > Local XATTR_TRUSTED_PREFIX_LEN and XATTR_SECURITY_PREFIX_LEN definitions
> > redefined ones in 'linux/xattr.h'. This was caused by commit 9d8f13ba3f48
> > ("security: new security_inode_init_security API adds function callback")
> > including 'linux/xattr.h' in 'linux/security.h'.
> >
> > In file included from include/linux/security.h:39,
> >                 from include/net/sock.h:54,
> >                 from fs/cifs/cifspdu.h:25,
> >                 from fs/cifs/xattr.c:26:
> >
> > This patch removes the local definitions.
> >
> > Reported-by: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
> > Signed-off-by: Mimi Zohar <zohar-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/xattr.c |   40 ++++++++++++++++++----------------------
> >  1 files changed, 18 insertions(+), 22 deletions(-)
> >
> > diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
> > index 2a22fb2..c323088 100644
> > --- a/fs/cifs/xattr.c
> > +++ b/fs/cifs/xattr.c
> > @@ -22,6 +22,7 @@
> >  #include <linux/fs.h>
> >  #include <linux/posix_acl_xattr.h>
> >  #include <linux/slab.h>
> > +#include <linux/xattr.h>
> >  #include "cifsfs.h"
> >  #include "cifspdu.h"
> >  #include "cifsglob.h"
> > @@ -31,16 +32,8 @@
> >  #define MAX_EA_VALUE_SIZE 65535
> >  #define CIFS_XATTR_DOS_ATTRIB "user.DosAttrib"
> >  #define CIFS_XATTR_CIFS_ACL "system.cifs_acl"
> > -#define CIFS_XATTR_USER_PREFIX "user."
> > -#define CIFS_XATTR_SYSTEM_PREFIX "system."
> > -#define CIFS_XATTR_OS2_PREFIX "os2."
> > -#define CIFS_XATTR_SECURITY_PREFIX "security."
> > -#define CIFS_XATTR_TRUSTED_PREFIX "trusted."
> > -#define XATTR_TRUSTED_PREFIX_LEN  8
> > -#define XATTR_SECURITY_PREFIX_LEN 9
> > -/* BB need to add server (Samba e.g) support for security and trusted prefix */
> > -
> >
> > +/* BB need to add server (Samba e.g) support for security and trusted prefix */
> >
> >  int cifs_removexattr(struct dentry *direntry, const char *ea_name)
> >  {
> > @@ -76,8 +69,8 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
> >        }
> >        if (ea_name == NULL) {
> >                cFYI(1, "Null xattr names not supported");
> > -       } else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5)
> > -               && (strncmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4))) {
> > +       } else if (strncmp(ea_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)
> > +               && (strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN))) {
> >                cFYI(1,
> >                     "illegal xattr request %s (only user namespace supported)",
> >                     ea_name);
> > @@ -88,7 +81,7 @@ int cifs_removexattr(struct dentry *direntry, const char *ea_name)
> >                if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
> >                        goto remove_ea_exit;
> >
> > -               ea_name += 5; /* skip past user. prefix */
> > +               ea_name += XATTR_USER_PREFIX_LEN; /* skip past user. prefix */
> >                rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, NULL,
> >                        (__u16)0, cifs_sb->local_nls,
> >                        cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> > @@ -149,21 +142,23 @@ int cifs_setxattr(struct dentry *direntry, const char *ea_name,
> >
> >        if (ea_name == NULL) {
> >                cFYI(1, "Null xattr names not supported");
> > -       } else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5) == 0) {
> > +       } else if (strncmp(ea_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)
> > +                  == 0) {
> >                if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
> >                        goto set_ea_exit;
> >                if (strncmp(ea_name, CIFS_XATTR_DOS_ATTRIB, 14) == 0)
> >                        cFYI(1, "attempt to set cifs inode metadata");
> >
> > -               ea_name += 5; /* skip past user. prefix */
> > +               ea_name += XATTR_USER_PREFIX_LEN; /* skip past user. prefix */
> >                rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, ea_value,
> >                        (__u16)value_size, cifs_sb->local_nls,
> >                        cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> > -       } else if (strncmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4) == 0) {
> > +       } else if (strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN)
> > +                  == 0) {
> >                if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
> >                        goto set_ea_exit;
> >
> > -               ea_name += 4; /* skip past os2. prefix */
> > +               ea_name += XATTR_OS2_PREFIX_LEN; /* skip past os2. prefix */
> >                rc = CIFSSMBSetEA(xid, pTcon, full_path, ea_name, ea_value,
> >                        (__u16)value_size, cifs_sb->local_nls,
> >                        cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> > @@ -269,7 +264,8 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
> >        /* return alt name if available as pseudo attr */
> >        if (ea_name == NULL) {
> >                cFYI(1, "Null xattr names not supported");
> > -       } else if (strncmp(ea_name, CIFS_XATTR_USER_PREFIX, 5) == 0) {
> > +       } else if (strncmp(ea_name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN)
> > +                  == 0) {
> >                if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
> >                        goto get_ea_exit;
> >
> > @@ -277,15 +273,15 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
> >                        cFYI(1, "attempt to query cifs inode metadata");
> >                        /* revalidate/getattr then populate from inode */
> >                } /* BB add else when above is implemented */
> > -               ea_name += 5; /* skip past user. prefix */
> > +               ea_name += XATTR_USER_PREFIX_LEN; /* skip past user. prefix */
> >                rc = CIFSSMBQAllEAs(xid, pTcon, full_path, ea_name, ea_value,
> >                        buf_size, cifs_sb->local_nls,
> >                        cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> > -       } else if (strncmp(ea_name, CIFS_XATTR_OS2_PREFIX, 4) == 0) {
> > +       } else if (strncmp(ea_name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN) == 0) {
> >                if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
> >                        goto get_ea_exit;
> >
> > -               ea_name += 4; /* skip past os2. prefix */
> > +               ea_name += XATTR_OS2_PREFIX_LEN; /* skip past os2. prefix */
> >                rc = CIFSSMBQAllEAs(xid, pTcon, full_path, ea_name, ea_value,
> >                        buf_size, cifs_sb->local_nls,
> >                        cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
> > @@ -339,10 +335,10 @@ ssize_t cifs_getxattr(struct dentry *direntry, const char *ea_name,
> >                cFYI(1, "Query CIFS ACL not supported yet");
> >  #endif /* CONFIG_CIFS_ACL */
> >        } else if (strncmp(ea_name,
> > -                 CIFS_XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) == 0) {
> > +                 XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) == 0) {
> >                cFYI(1, "Trusted xattr namespace not supported yet");
> >        } else if (strncmp(ea_name,
> > -                 CIFS_XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) == 0) {
> > +                 XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) == 0) {
> >                cFYI(1, "Security xattr namespace not supported yet");
> >        } else
> >                cFYI(1,
> > --
> > 1.7.3.4
> >
> >
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
> 

-- 
James Morris
<jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
--1665246916-429493442-1313110107=:14215--
