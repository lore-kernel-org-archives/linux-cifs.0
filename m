From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] cifs: Make session key from per smb connection
 to per smb session
Date: Mon, 12 Aug 2013 10:05:02 -0400
Message-ID: <20130812100502.0caf5857@tlielax.poochiereds.net>
References: <1375973628-6218-1-git-send-email-shirishpargaonkar@gmail.com>
	<20130808163943.3f17811c@tlielax.poochiereds.net>
	<CADT32eJeLtVurM2upwGS4-+KKHdpkkf57Agj47Gm3vPrpoJhfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eJeLtVurM2upwGS4-+KKHdpkkf57Agj47Gm3vPrpoJhfg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 8 Aug 2013 23:30:57 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Thu, Aug 8, 2013 at 3:39 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Thu,  8 Aug 2013 09:53:48 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >> Change session key from per smb connection to per smb session for
> >> smb2 onwards.
> >> perconnkey is defined for only cifs/smb.
> >> For smb3, generate signing key per smb session.
> >>
> >
> > This description is pretty sparse. Seriously, be more verbose here. Ok,
> > so perconnkey is only defined for cifs/smb1, but what _is_ it? What
> > does it do, and why? Why do we want to change this to per-smb session
> > for smb2 and onwards? (yes, I know the reason, but other people trawling
> > through git log might not)
> >
> > It's worth it to spend the time and describe your patches properly.
> > Otherwise in 2-3 years, we'll have no idea why some of these changes
> > were made in this way.
> >
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >>  fs/cifs/cifsencrypt.c | 20 ++++++++++++++++++++
> >>  fs/cifs/cifsglob.h    |  2 ++
> >>  fs/cifs/cifsproto.h   |  3 +++
> >>  fs/cifs/connect.c     | 27 +++++++++++++++++++--------
> >>  fs/cifs/sess.c        |  6 ++++--
> >>  fs/cifs/smb1ops.c     |  1 +
> >>  fs/cifs/smb2pdu.c     |  1 +
> >>  7 files changed, 50 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> >> index 45e57cc..f9ef57a 100644
> >> --- a/fs/cifs/cifsencrypt.c
> >> +++ b/fs/cifs/cifsencrypt.c
> >> @@ -720,6 +720,26 @@ setup_ntlmv2_rsp_ret:
> >>       return rc;
> >>  }
> >>
> >> +void
> >> +free_authkey(struct cifs_ses *ses)
> >> +{
> >> +     kfree(ses->auth_key.response);
> >> +     ses->auth_key.response = NULL;
> >> +     ses->auth_key.len = 0;
> >> +}
> >> +
> >> +int
> >> +perconnkey(struct TCP_Server_Info *server, struct cifs_ses *ses)
> >> +{
> >> +     server->session_key.response = kmemdup(ses->auth_key.response,
> >> +             ses->auth_key.len, GFP_KERNEL);
> >> +     if (!server->session_key.response)
> >> +             return -ENOMEM;
> >> +     server->session_key.len = ses->auth_key.len;
> >> +
> >> +     return 0;
> >> +}
> >> +
> >
> > If you move "perconnkey" into smb1ops.c then it can be static. It could
> > also benefit from a more desciptive name, such as "smb1_set_conn_key"
> > or something.
> >
> >>  int
> >>  calc_seckey(struct cifs_ses *ses)
> >>  {
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> index 1fdc370..2909380 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -365,6 +365,8 @@ struct smb_version_operations {
> >>       void (*set_lease_key)(struct inode *, struct cifs_fid *fid);
> >>       /* generate new lease key */
> >>       void (*new_lease_key)(struct cifs_fid *fid);
> >> +     int (*perconnkey)(struct TCP_Server_Info *server,
> >> +                                     struct cifs_ses *ses);
> >
> > A name like this sounds like an operation that returns the (already
> > existing) per-connection key. How about something like
> > "generate_perconn_key" instead?
> >
> > Also, the ses->server pointer should already be set at this point,
> > right? So, it seems like there's probably no need to pass in both as
> > parms. Might it make more sense to just pass in "ses"?
> >
> >>       /* The next two functions will need to be changed to per smb session */
> >>       void (*generate_signingkey)(struct TCP_Server_Info *server);
> >>       int (*calc_signature)(struct smb_rqst *rqst,
> >> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> >> index f7e584d..b6c1d03 100644
> >> --- a/fs/cifs/cifsproto.h
> >> +++ b/fs/cifs/cifsproto.h
> >> @@ -437,6 +437,9 @@ extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
> >>  extern int calc_seckey(struct cifs_ses *);
> >>  extern void generate_smb3signingkey(struct TCP_Server_Info *);
> >>
> >> +extern int perconnkey(struct TCP_Server_Info *, struct cifs_ses *);
> >> +extern void free_authkey(struct cifs_ses *);
> >> +
> >>  #ifdef CONFIG_CIFS_WEAK_PW_HASH
> >>  extern int calc_lanman_hash(const char *password, const char *cryptkey,
> >>                               bool encrypt, char *lnm_session_key);
> >> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >> index fa68813..98deb98 100644
> >> --- a/fs/cifs/connect.c
> >> +++ b/fs/cifs/connect.c
> >> @@ -2117,6 +2117,8 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
> >>               goto out_err_crypto_release;
> >>       }
> >>
> >> +     tcp_ses->session_key.response = NULL;
> >> +     tcp_ses->session_key.len = 0;
> >
> > This is kzalloc'ed so these are not necessary.
> >
> >>       tcp_ses->noblocksnd = volume_info->noblocksnd;
> >>       tcp_ses->noautotune = volume_info->noautotune;
> >>       tcp_ses->tcp_nodelay = volume_info->sockopt_tcp_nodelay;
> >> @@ -2270,6 +2272,8 @@ cifs_put_smb_ses(struct cifs_ses *ses)
> >>               server->ops->logoff(xid, ses);
> >>               _free_xid(xid);
> >>       }
> >> +     if (!server->ops->perconnkey)
> >> +             free_authkey(ses);
> >
> > Hrm...so the SMB1 perconnkey operation that you have now kmemdups it.
> >
> > Why do you skip freeing it here? Doesn't the TCP_Server_Info have its
> > own copy and won't doing this cause a leak?
> 
> So for smb/cifs, session key of the very first smb session is used for signing
> for this and subsequent smb sessions on this smb connection, so it is
> kmemdup'ed as session key in the server structure.  Now there is no need to keep
> session key needed so generated during authentication (session setup phase) for
> any of the smb sessions on this smb connection anymore.
> 
> For smb2 and smb3, since session key is per smb session (and not per
> smb connection), we need_to/should keep it thus not free inuntil the session
> is in effect and so no need to kmemdup it to the smb connection
> (server structure).
> 
> So the perconneky function which is defined and declared only for smb1/cifs ops,
> is used to gate kmemdup and kfree of the session keys or not.
> 
> Is that good enough an explaination?  If so, will put this verbiage as
> part of the
> next version of this patch in the patchset.
> 

I'm sorry, I still don't understand why you're doing it this way.

Why not instead remove the free_authkey call in cifs_setup_session and
just always free it here instead? Won't the effect be the same (and the
lifecycle be simpler?)

> >
> >>       sesInfoFree(ses);
> >>       cifs_put_tcp_session(server);
> >>  }
> >> @@ -2484,6 +2488,9 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
> >>       ses->sectype = volume_info->sectype;
> >>       ses->sign = volume_info->sign;
> >>
> >> +     ses->auth_key.response = NULL;
> >> +     ses->auth_key.len = 0;
> >> +
> >
> > Again, these are kzalloced -- no need to do this here...and in any case
> > this would belong in sesInfoAlloc rather than here, I think.
> >
> >>       mutex_lock(&ses->session_mutex);
> >>       rc = cifs_negotiate_protocol(xid, ses);
> >>       if (!rc)
> >> @@ -3830,14 +3837,18 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
> >>       } else {
> >>               mutex_lock(&server->srv_mutex);
> >>               if (!server->session_estab) {
> >> -                     server->session_key.response = ses->auth_key.response;
> >> -                     server->session_key.len = ses->auth_key.len;
> >> +                     if (server->ops->perconnkey) {
> >> +                             rc = server->ops->perconnkey(server, ses);
> >> +                             if (rc) {
> >> +                                     mutex_unlock(&server->srv_mutex);
> >> +                                     goto setup_sess_ret;
> >> +                             }
> >> +                     }
> >>                       server->sequence_number = 0x2;
> >>                       server->session_estab = true;
> >> -                     ses->auth_key.response = NULL;
> >> -                     if (server->ops->generate_signingkey)
> >> -                             server->ops->generate_signingkey(server);
> >>               }
> >> +             if (server->ops->generate_signingkey)
> >> +                     server->ops->generate_signingkey(server);
> >
> > It seems a bit strange that you're calling "generate_signingkey" here
> > after you successfully call "perconnkey", but I'll take it on faith
> > that you fix that in patch #2.
> >
> 
> Need to call generate_signingkey for smb3 only and only if signing
> is enabled.
> 
> > Still, that's the type of thing that's worth mentioning in the patch
> > description since it doesn't seem to make much sense on its own.
> >
> >>               mutex_unlock(&server->srv_mutex);
> >>
> >>               cifs_dbg(FYI, "CIFS Session Established successfully\n");
> >> @@ -3847,9 +3858,9 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
> >>               spin_unlock(&GlobalMid_Lock);
> >>       }
> >>
> >> -     kfree(ses->auth_key.response);
> >> -     ses->auth_key.response = NULL;
> >> -     ses->auth_key.len = 0;
> >> +setup_sess_ret:
> >> +     if (server->ops->perconnkey)
> >> +             free_authkey(ses);
> >>       kfree(ses->ntlmssp);
> >>       ses->ntlmssp = NULL;
> >>
> >> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> >> index 79358e3..77642cd 100644
> >> --- a/fs/cifs/sess.c
> >> +++ b/fs/cifs/sess.c
> >> @@ -428,7 +428,8 @@ void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
> >>               NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC;
> >>       if (ses->server->sign) {
> >>               flags |= NTLMSSP_NEGOTIATE_SIGN;
> >> -             if (!ses->server->session_estab)
> >> +             if ((!ses->server->session_estab) ||
> >> +                             (!ses->server->ops->perconnkey))
> >>                       flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
> >>       }
> >>
> >> @@ -466,7 +467,8 @@ int build_ntlmssp_auth_blob(unsigned char *pbuffer,
> >>               NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC;
> >>       if (ses->server->sign) {
> >>               flags |= NTLMSSP_NEGOTIATE_SIGN;
> >> -             if (!ses->server->session_estab)
> >> +             if ((!ses->server->session_estab) ||
> >> +                             (!ses->server->ops->perconnkey))
> >>                       flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
> >>       }
> >>
> >> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> >> index 6457690..331b406 100644
> >> --- a/fs/cifs/smb1ops.c
> >> +++ b/fs/cifs/smb1ops.c
> >> @@ -944,6 +944,7 @@ struct smb_version_operations smb1_operations = {
> >>       .mand_lock = cifs_mand_lock,
> >>       .mand_unlock_range = cifs_unlock_range,
> >>       .push_mand_locks = cifs_push_mandatory_locks,
> >> +     .perconnkey = perconnkey,
> >>  };
> >>
> >>  struct smb_version_values smb1_values = {
> >> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> >> index abc9c28..11de60b 100644
> >> --- a/fs/cifs/smb2pdu.c
> >> +++ b/fs/cifs/smb2pdu.c
> >> @@ -477,6 +477,7 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
> >>               return -EIO;
> >>       }
> >>
> >> +     free_authkey(ses);
> >
> > Would it make more sense to instead just move all of this authkey
> > handling into the session setup routines? It seems a little odd to
> > allocate a key in the generic part of the session setup code, only
> > to later free it in the version specific routine.
> 
> Let me look into that.  So perhaps then we can skip the need for
> a ops specific routine like perconnkey.
> 

I think that would make much more sense. All of this could be done
much more cleanly under the aegis of the session_setup routines.

> >
> >>       /*
> >>        * If memory allocation is successful, caller of this function
> >>        * frees it.
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
