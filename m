From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 06/19] cifs: remove "seal" stubs
Date: Fri, 24 May 2013 15:42:06 -0400
Message-ID: <20130524154206.4cd7e357@corrin.poochiereds.net>
References: <1369321563-16893-1-git-send-email-jlayton@redhat.com>
	<1369321563-16893-7-git-send-email-jlayton@redhat.com>
	<CAH2r5mv3bRxXKzBSkD9BUGxLVdvtcrD1vTfqsEp=cX2MrcQAvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	Shirish S Pargaonkar <shirishp-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mv3bRxXKzBSkD9BUGxLVdvtcrD1vTfqsEp=cX2MrcQAvw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 24 May 2013 13:32:51 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> As soon as Shirish fixes the signing code, don't we need these stubs
> (for per-share smb3 encryption - albeit we could remove them from the
> cifs only code path since the cifs seal code allowed with unix
> extenions turned out to be hard to implement due to a design problem
> we didn't notice at the time in the unix specification).
> 

I think we should just let these flags go for now, and reimplement them
as they are needed. This patchset is pretty complex already, and taking
this out simplifies things for this patchset and likely for Shirish's
too.

His code may or may not end up using these fields. It makes sense to me
to just allow Shirish to add the fields that he thinks are necessary to
support his code, rather than making assumptions about it before that
code has materialised. For instance, the seal field is attached to the
tcon here which really makes no sense for smb3...

Also, signing and sealing are semi-related, so it might make sense to
have some sort of 3 way switch that determines what sort of integrity or
privacy are on the connection, rather than a pair of bools...

> On Thu, May 23, 2013 at 10:05 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > CIFS has mount options for sealing (aka encryption), but they aren't
> > actually hooked up to the code and errors are not generated when someone
> > requests it. Ensure that no one is tricked by this by removing the stub
> > option handling, thereby causing a mount-time error to be generated when
> > someone tries to set this option.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/cifsfs.c   |  2 --
> >  fs/cifs/cifsglob.h |  2 --
> >  fs/cifs/connect.c  | 18 +++---------------
> >  3 files changed, 3 insertions(+), 19 deletions(-)
> >
> > diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> > index 3752b9f..bb27269 100644
> > --- a/fs/cifs/cifsfs.c
> > +++ b/fs/cifs/cifsfs.c
> > @@ -416,8 +416,6 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
> >                 seq_printf(s, ",file_mode=0%ho,dir_mode=0%ho",
> >                                            cifs_sb->mnt_file_mode,
> >                                            cifs_sb->mnt_dir_mode);
> > -       if (tcon->seal)
> > -               seq_printf(s, ",seal");
> >         if (tcon->nocase)
> >                 seq_printf(s, ",nocase");
> >         if (tcon->retry)
> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > index be993ec..874b29b 100644
> > --- a/fs/cifs/cifsglob.h
> > +++ b/fs/cifs/cifsglob.h
> > @@ -425,7 +425,6 @@ struct smb_vol {
> >         bool nocase:1;     /* request case insensitive filenames */
> >         bool nobrl:1;      /* disable sending byte range locks to srv */
> >         bool mand_lock:1;  /* send mandatory not posix byte range lock reqs */
> > -       bool seal:1;       /* request transport encryption on share */
> >         bool nodfs:1;      /* Do not request DFS, even if available */
> >         bool local_lease:1; /* check leases only on local system, not remote */
> >         bool noblocksnd:1;
> > @@ -792,7 +791,6 @@ struct cifs_tcon {
> >         bool ipc:1;             /* set if connection to IPC$ eg for RPC/PIPES */
> >         bool retry:1;
> >         bool nocase:1;
> > -       bool seal:1;      /* transport encryption for this mounted share */
> >         bool unix_ext:1;  /* if false disable Linux extensions to CIFS protocol
> >                                 for this mount even if server would support */
> >         bool local_lease:1; /* check leases (only) on local system not remote */
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 118cc9c..b367a5a 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -83,7 +83,7 @@ enum {
> >         Opt_serverino, Opt_noserverino,
> >         Opt_rwpidforward, Opt_cifsacl, Opt_nocifsacl,
> >         Opt_acl, Opt_noacl, Opt_locallease,
> > -       Opt_sign, Opt_seal, Opt_noac,
> > +       Opt_sign, Opt_noac,
> >         Opt_fsc, Opt_mfsymlinks,
> >         Opt_multiuser, Opt_sloppy, Opt_nosharesock,
> >
> > @@ -159,7 +159,6 @@ static const match_table_t cifs_mount_option_tokens = {
> >         { Opt_noacl, "noacl" },
> >         { Opt_locallease, "locallease" },
> >         { Opt_sign, "sign" },
> > -       { Opt_seal, "seal" },
> >         { Opt_noac, "noac" },
> >         { Opt_fsc, "fsc" },
> >         { Opt_mfsymlinks, "mfsymlinks" },
> > @@ -1034,8 +1033,8 @@ static int cifs_parse_security_flavors(char *value,
> >                 break;
> >         case Opt_sec_krb5p:
> >                 /* vol->secFlg |= CIFSSEC_MUST_SEAL | CIFSSEC_MAY_KRB5; */
> > -               cifs_dbg(VFS, "Krb5 cifs privacy not supported\n");
> > -               break;
> > +               cifs_dbg(VFS, "sec=krb5p is not supported!\n");
> > +               return 1;
> >         case Opt_sec_ntlmssp:
> >                 vol->secFlg |= CIFSSEC_MAY_NTLMSSP;
> >                 break;
> > @@ -1427,14 +1426,6 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
> >                 case Opt_sign:
> >                         vol->secFlg |= CIFSSEC_MUST_SIGN;
> >                         break;
> > -               case Opt_seal:
> > -                       /* we do not do the following in secFlags because seal
> > -                        * is a per tree connection (mount) not a per socket
> > -                        * or per-smb connection option in the protocol
> > -                        * vol->secFlg |= CIFSSEC_MUST_SEAL;
> > -                        */
> > -                       vol->seal = 1;
> > -                       break;
> >                 case Opt_noac:
> >                         printk(KERN_WARNING "CIFS: Mount option noac not "
> >                                 "supported. Instead set "
> > @@ -2589,8 +2580,6 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
> >                 cifs_dbg(FYI, "Found match on UNC path\n");
> >                 /* existing tcon already has a reference */
> >                 cifs_put_smb_ses(ses);
> > -               if (tcon->seal != volume_info->seal)
> > -                       cifs_dbg(VFS, "transport encryption setting conflicts with existing tid\n");
> >                 return tcon;
> >         }
> >
> > @@ -2630,7 +2619,6 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
> >                 tcon->Flags &= ~SMB_SHARE_IS_IN_DFS;
> >                 cifs_dbg(FYI, "DFS disabled (%d)\n", tcon->Flags);
> >         }
> > -       tcon->seal = volume_info->seal;
> >         /*
> >          * We can have only one retry value for a connection to a share so for
> >          * resources mounted more than once to the same server share the last
> > --
> > 1.8.1.4
> >
> 
> 
> 


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
