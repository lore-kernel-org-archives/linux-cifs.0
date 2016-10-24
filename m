From: Eryu Guan <guaneryu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: iterate over posix acl xattr entry correctly in
 ACL_to_cifs_posix()
Date: Mon, 24 Oct 2016 20:34:24 +0800
Message-ID: <20161024121823.GO2462@eguan.usersys.redhat.com>
References: <1477124080-27230-1-git-send-email-guaneryu@gmail.com>
 <CAHc6FU4p=30G9Tm5_F-z4s0EX-kQ_5DjjzVU+eR96huBKho-uQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHc6FU4p=30G9Tm5_F-z4s0EX-kQ_5DjjzVU+eR96huBKho-uQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Oct 24, 2016 at 01:03:16PM +0200, Andreas Gruenbacher wrote:
> On Sat, Oct 22, 2016 at 10:14 AM, Eryu Guan <guaneryu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > Commit 2211d5ba5c6c ("posix_acl: xattr representation cleanups")
> > removes the typedefs and the zero-length a_entries array in struct
> > posix_acl_xattr_header, and uses bare struct posix_acl_xattr_header
> > and struct posix_acl_xattr_entry directly.
> >
> > But it failed to iterate over posix acl slots when converting posix
> > acls to CIFS format, which results in several test failures in
> > xfstests (generic/053 generic/105) when testing against a samba v1
> > server, starting from v4.9-rc1 kernel. e.g.
> >
> >   [root@localhost xfstests]# diff -u tests/generic/105.out /root/xfstests/results//generic/105.out.bad
> >   --- tests/generic/105.out       2016-09-19 16:33:28.577962575 +0800
> >   +++ /root/xfstests/results//generic/105.out.bad 2016-10-22 15:41:15.201931110 +0800
> >   @@ -1,3 +1,4 @@
> >    QA output created by 105
> >    -rw-r--r-- root
> >   +setfacl: subdir: Invalid argument
> >    -rw-r--r-- root
> >
> > Fix it by introducing a new "ace" var, like what
> > cifs_copy_posix_acl() does, and iterating posix acl xattr entries
> > over it in the for loop.
> >
> > Signed-off-by: Eryu Guan <guaneryu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > ---
> >  fs/cifs/cifssmb.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> > index 3f3185f..d04c21c 100644
> > --- a/fs/cifs/cifssmb.c
> > +++ b/fs/cifs/cifssmb.c
> > @@ -3453,8 +3453,8 @@ static __u16 ACL_to_cifs_posix(char *parm_data, const char *pACL,
> >                 return 0;
> >         }
> >         for (i = 0; i < count; i++) {
> > -               rc = convert_ace_to_cifs_ace(&cifs_acl->ace_array[i],
> > -                       (struct posix_acl_xattr_entry *)(local_acl + 1));
> > +               struct posix_acl_xattr_entry *ace = (void *)(local_acl + 1);
> 
> Shouldn't ace better be defined outside the loop?

Agreed, that's much cleaner. Will fix in v2. Thanks for review!

Eryu

> 
> > +               rc = convert_ace_to_cifs_ace(&cifs_acl->ace_array[i], &ace[i]);
> >                 if (rc != 0) {
> >                         /* ACE not converted */
> >                         break;
> 
> Thanks,
> Andreas
