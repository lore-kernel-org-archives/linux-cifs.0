From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 09/19] cifs: move handling of signed connections into
 separate function
Date: Fri, 24 May 2013 08:45:36 -0400
Message-ID: <20130524084536.544c59a1@corrin.poochiereds.net>
References: <1369321563-16893-1-git-send-email-jlayton@redhat.com>
	<1369321563-16893-10-git-send-email-jlayton@redhat.com>
	<CAKywueQEwagjBhXsuSBEMRdnAAHyFovnoaR+28Gb7B9QpEXbqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueQEwagjBhXsuSBEMRdnAAHyFovnoaR+28Gb7B9QpEXbqw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 24 May 2013 16:41:37 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2013/5/23 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> > Move the sanity checks for signed connections into a separate function.
> > SMB2's was a cut-and-paste job from CIFS code, so we can make them use
> > the same function.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/cifsproto.h |  1 +
> >  fs/cifs/cifssmb.c   | 71 +++++++++++++++++++++++++++--------------------------
> >  fs/cifs/smb2pdu.c   | 33 +++----------------------
> >  3 files changed, 41 insertions(+), 64 deletions(-)
> >
> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> > index dda188a..f0e93ff 100644
> > --- a/fs/cifs/cifsproto.h
> > +++ b/fs/cifs/cifsproto.h
> > @@ -212,6 +212,7 @@ extern int cifs_negotiate_protocol(const unsigned int xid,
> >                                    struct cifs_ses *ses);
> >  extern int cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
> >                               struct nls_table *nls_info);
> > +extern int cifs_enable_signing(struct TCP_Server_Info *server, unsigned int secFlags);
> >  extern int CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses);
> >
> >  extern int CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
> > diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> > index 5dd4f8a..5b191f7 100644
> > --- a/fs/cifs/cifssmb.c
> > +++ b/fs/cifs/cifssmb.c
> > @@ -417,6 +417,38 @@ decode_ext_sec_blob(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr)
> >         return 0;
> >  }
> >
> > +int
> > +cifs_enable_signing(struct TCP_Server_Info *server, unsigned int secFlags)
> > +{
> > +       if ((secFlags & CIFSSEC_MAY_SIGN) == 0) {
> > +               /* MUST_SIGN already includes the MAY_SIGN FLAG
> > +                  so if this is zero it means that signing is disabled */
> > +               cifs_dbg(FYI, "Signing disabled\n");
> > +               if (server->sec_mode & SECMODE_SIGN_REQUIRED) {
> > +                       cifs_dbg(VFS, "Server requires packet signing to be enabled in /proc/fs/cifs/SecurityFlags\n");
> > +                       return -EOPNOTSUPP;
> > +               }
> > +               server->sec_mode &=
> > +                       ~(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED);
> > +       } else if ((secFlags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN) {
> > +               /* signing required */
> > +               cifs_dbg(FYI, "Must sign - secFlags 0x%x\n", secFlags);
> > +               if ((server->sec_mode &
> > +                       (SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED)) == 0) {
> > +                       cifs_dbg(VFS, "signing required but server lacks support\n");
> > +                       return -EOPNOTSUPP;
> > +               } else
> > +                       server->sec_mode |= SECMODE_SIGN_REQUIRED;
> > +       } else {
> > +               /* signing optional ie CIFSSEC_MAY_SIGN */
> > +               if ((server->sec_mode & SECMODE_SIGN_REQUIRED) == 0)
> > +                       server->sec_mode &=
> > +                               ~(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED);
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> >  #ifdef CONFIG_CIFS_WEAK_PW_HASH
> >  static int
> >  decode_lanman_negprot_rsp(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr,
> > @@ -495,7 +527,7 @@ decode_lanman_negprot_rsp(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr,
> >         }
> >
> >         cifs_dbg(FYI, "LANMAN negotiated\n");
> > -       return 0;
> > +       return cifs_enable_signing(server, secFlags);
> >  }
> >  #else
> >  static inline int
> > @@ -577,10 +609,7 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
> >                 goto neg_err_exit;
> >         } else if (pSMBr->hdr.WordCount == 13) {
> >                 rc = decode_lanman_negprot_rsp(server, pSMBr, secFlags);
> > -               if (!rc)
> > -                       goto signing_check;
> > -               else
> > -                       goto neg_err_exit;
> > +               goto neg_err_exit;
> 
> Go to a label that has "err" in it's name after a successful function
> call may confuse people.
> 

I guess we could change it to "neg_exit:" or something. I can toss a
patch onto the top of the pile to do that in the next iteration.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
