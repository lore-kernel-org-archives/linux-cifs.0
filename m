From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH 1/4] cifs: Split lanman auth from CIFS_SessSetup()
Date: Tue, 29 Apr 2014 07:55:59 -0400
Message-ID: <20140429075559.60080e92@tlielax.poochiereds.net>
References: <1398694350-8526-1-git-send-email-sprabhu@redhat.com>
	<1398694350-8526-2-git-send-email-sprabhu@redhat.com>
	<20140429072045.7a52bdcf@tlielax.poochiereds.net>
	<1398771670.2814.6.camel@sachin-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Simo Sorce <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1398771670.2814.6.camel@sachin-laptop>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 29 Apr 2014 12:41:10 +0100
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, 2014-04-29 at 07:20 -0400, Jeff Layton wrote:
> > On Mon, 28 Apr 2014 15:12:27 +0100
> > Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > 
> > > In preparation for splitting CIFS_SessSetup() into smaller more
> > > manageable chunks, we first add helper functions.
> > > 
> > > We then proceed to split out lanman auth out of CIFS_SessSetup()
> > > 
> > > Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > > ---
> > >  fs/cifs/sess.c | 303 ++++++++++++++++++++++++++++++++++++++++++++++++---------
> > >  1 file changed, 259 insertions(+), 44 deletions(-)
> > > 
> > > diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> > > index e87387d..8481631 100644
> > > --- a/fs/cifs/sess.c
> > > +++ b/fs/cifs/sess.c
> > > @@ -520,6 +520,237 @@ select_sectype(struct TCP_Server_Info *server, enum securityEnum requested)
> > >  	}
> > >  }
> > >  
> > > +struct sess_data {
> > > +	unsigned int xid;
> > > +	struct cifs_ses *ses;
> > > +	struct nls_table *nls_cp;
> > > +	void (*func) (struct sess_data *);
> > > +	int result;
> > > +
> > > +	/* we will send the SMB in three pieces:
> > > +	 * a fixed length beginning part, an optional
> > > +	 * SPNEGO blob (which can be zero length), and a
> > > +	 * last part which will include the strings
> > > +	 * and rest of bcc area. This allows us to avoid
> > > +	 * a large buffer 17K allocation
> > > +	 */
> > > +	struct kvec iov[3];
> > > +	int buf0_type;
> > > +};
> > > +
> > > +static int
> > > +sess_alloc_buffer(struct sess_data *sess_data, int wct)
> > > +{
> > > +	int rc;
> > > +	struct cifs_ses *ses = sess_data->ses;
> > > +	struct smb_hdr *smb_buf;
> > > +
> > > +	rc = small_smb_init_no_tc(SMB_COM_SESSION_SETUP_ANDX, wct, ses,
> > > +				  (void **)&smb_buf);
> > > +
> > > +	if (rc)
> > > +		return rc;
> > > +
> > > +	sess_data->iov[0].iov_base = (char *)smb_buf;
> > > +	sess_data->iov[0].iov_len = be32_to_cpu(smb_buf->smb_buf_length) + 4;
> > > +	/*
> > > + *	  * This variable will be used to clear the buffer
> > > + *		   * allocated above in case of any error in the calling function.
> > > + *			    */
> > > +	sess_data->buf0_type = CIFS_SMALL_BUFFER;
> > > +
> > > +	/* 2000 big enough to fit max user, domain, NOS name etc. */
> > > +	sess_data->iov[2].iov_base = kmalloc(2000, GFP_KERNEL);
> > > +	if (!sess_data->iov[2].iov_base) {
> > > +		rc = -ENOMEM;
> > > +		goto out_free_smb_buf;
> > > +	}
> > > +
> > > +	return 0;
> > > +
> > > +out_free_smb_buf:
> > > +	kfree(smb_buf);
> > > +	sess_data->iov[0].iov_base = NULL;
> > > +	sess_data->iov[0].iov_len = 0;
> > > +	sess_data->buf0_type = CIFS_NO_BUFFER;
> > > +	return rc;
> > > +}
> > > +
> > > +static int
> > > +sess_free_buffer(struct sess_data *sess_data)
> > > +{
> > > +
> > > +	if (sess_data->buf0_type == CIFS_SMALL_BUFFER) {
> > > +		cifs_dbg(FYI, "%s: freeing small buf %p\n", __func__,
> > > +					sess_data->iov[0].iov_base);
> > > +		cifs_small_buf_release(sess_data->iov[0].iov_base);
> > > +	} else if (sess_data->buf0_type == CIFS_LARGE_BUFFER) {
> > > +		cifs_dbg(FYI, "%s: freeing small buf %p\n", __func__,
> > > +					sess_data->iov[0].iov_base);
> > > +		cifs_buf_release(sess_data->iov[0].iov_base);
> > > +	}
> > > +
> > > +	kfree(sess_data->iov[2].iov_base);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int
> > > +sess_establish_session(struct sess_data *sess_data)
> > > +{
> > > +	struct cifs_ses *ses = sess_data->ses;
> > > +
> > > +	if (!sess_data->result) {
> > > +		mutex_lock(&ses->server->srv_mutex);
> > > +		if (!ses->server->session_estab) {
> > > +			if (ses->server->sign) {
> > > +				ses->server->session_key.response =
> > > +					kmemdup(ses->auth_key.response,
> > > +					ses->auth_key.len, GFP_KERNEL);
> > > +				if (!ses->server->session_key.response) {
> > > +					sess_data->result = -ENOMEM;
> > > +					mutex_unlock(&ses->server->srv_mutex);
> > > +					return sess_data->result;
> > > +				}
> > > +				ses->server->session_key.len =
> > > +							ses->auth_key.len;
> > > +			}
> > > +			ses->server->sequence_number = 0x2;
> > > +			ses->server->session_estab = true;
> > > +		}
> > > +		mutex_unlock(&ses->server->srv_mutex);
> > > +
> > > +		cifs_dbg(FYI, "CIFS session established successfully\n");
> > > +		spin_lock(&GlobalMid_Lock);
> > > +		ses->status = CifsGood;
> > > +		ses->need_reconnect = false;
> > > +		spin_unlock(&GlobalMid_Lock);
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int
> > > +sess_sendreceive(struct sess_data *sess_data)
> > > +{
> > > +	int rc;
> > > +	struct smb_hdr *smb_buf = (struct smb_hdr *) sess_data->iov[0].iov_base;
> > > +	__u16 count;
> > > +
> > > +	count = sess_data->iov[1].iov_len + sess_data->iov[2].iov_len;
> > > +	smb_buf->smb_buf_length =
> > > +		cpu_to_be32(be32_to_cpu(smb_buf->smb_buf_length) + count);
> > > +	put_bcc(count, smb_buf);
> > > +
> > > +	rc = SendReceive2(sess_data->xid, sess_data->ses,
> > > +			  sess_data->iov, 3 /* num_iovecs */,
> > > +			  &sess_data->buf0_type,
> > > +			  CIFS_LOG_ERROR);
> > > +
> > > +	return rc;
> > > +}
> > > +
> > > +#ifdef CONFIG_CIFS_WEAK_PW_HASH
> > > +static void
> > > +sess_auth_lanman(struct sess_data *sess_data)
> > > +{
> > > +	int rc = 0;
> > > +	struct smb_hdr *smb_buf;
> > > +	SESSION_SETUP_ANDX *pSMB;
> > > +	char *bcc_ptr;
> > > +	struct cifs_ses *ses = sess_data->ses;
> > > +	char lnm_session_key[CIFS_AUTH_RESP_SIZE];
> > > +	__u32 capabilities;
> > > +	__u16 bytes_remaining;
> > > +
> > > +	/* lanman 2 style sessionsetup */
> > > +	/* wct = 10 */
> > > +	rc = sess_alloc_buffer(sess_data, 10);
> > > +	if (rc)
> > > +		goto out;
> > > +
> > > +	pSMB = (SESSION_SETUP_ANDX *)sess_data->iov[0].iov_base;
> > > +	bcc_ptr = sess_data->iov[2].iov_base;
> > > +	capabilities = cifs_ssetup_hdr(ses, pSMB);
> > > +
> > > +	pSMB->req.hdr.Flags2 &= ~SMBFLG2_UNICODE;
> > > +
> > > +	/* no capabilities flags in old lanman negotiation */
> > > +	pSMB->old_req.PasswordLength = cpu_to_le16(CIFS_AUTH_RESP_SIZE);
> > > +
> > > +	/* Calculate hash with password and copy into bcc_ptr.
> > > +	 * Encryption Key (stored as in cryptkey) gets used if the
> > > +	 * security mode bit in Negottiate Protocol response states
> > > +	 * to use challenge/response method (i.e. Password bit is 1).
> > > +	 */
> > > +	rc = calc_lanman_hash(ses->password, ses->server->cryptkey,
> > > +			      ses->server->sec_mode & SECMODE_PW_ENCRYPT ?
> > > +			      true : false, lnm_session_key);
> > > +
> > > +	memcpy(bcc_ptr, (char *)lnm_session_key, CIFS_AUTH_RESP_SIZE);
> > > +	bcc_ptr += CIFS_AUTH_RESP_SIZE;
> > > +
> > > +	/*
> > > +	 * can not sign if LANMAN negotiated so no need
> > > +	 * to calculate signing key? but what if server
> > > +	 * changed to do higher than lanman dialect and
> > > +	 * we reconnected would we ever calc signing_key?
> > > +	 */
> > > +
> > > +	cifs_dbg(FYI, "Negotiating LANMAN setting up strings\n");
> > > +	/* Unicode not allowed for LANMAN dialects */
> > > +	ascii_ssetup_strings(&bcc_ptr, ses, sess_data->nls_cp);
> > > +
> > > +	sess_data->iov[2].iov_len = (long) bcc_ptr -
> > > +			(long) sess_data->iov[2].iov_base;
> > > +
> > > +	rc = sess_sendreceive(sess_data);
> > > +	if (rc)
> > > +		goto out;
> > > +
> > > +	pSMB = (SESSION_SETUP_ANDX *)sess_data->iov[0].iov_base;
> > > +	smb_buf = (struct smb_hdr *)sess_data->iov[0].iov_base;
> > > +
> > > +	/* lanman response has a word count of 3 */
> > > +	if (smb_buf->WordCount != 3) {
> > > +		rc = -EIO;
> > > +		cifs_dbg(VFS, "bad word count %d\n", smb_buf->WordCount);
> > > +		goto out;
> > > +	}
> > > +
> > > +	if (le16_to_cpu(pSMB->resp.Action) & GUEST_LOGIN)
> > > +		cifs_dbg(FYI, "Guest login\n"); /* BB mark SesInfo struct? */
> > > +
> > > +	ses->Suid = smb_buf->Uid;   /* UID left in wire format (le) */
> > > +	cifs_dbg(FYI, "UID = %llu\n", ses->Suid);
> > > +
> > > +	bytes_remaining = get_bcc(smb_buf);
> > > +	bcc_ptr = pByteArea(smb_buf);
> > > +
> > > +	/* BB check if Unicode and decode strings */
> > > +	if (bytes_remaining == 0) {
> > > +		/* no string area to decode, do nothing */
> > > +	} else if (smb_buf->Flags2 & SMBFLG2_UNICODE) {
> > > +		/* unicode string area must be word-aligned */
> > > +		if (((unsigned long) bcc_ptr - (unsigned long) smb_buf) % 2) {
> > > +			++bcc_ptr;
> > > +			--bytes_remaining;
> > > +		}
> > > +		decode_unicode_ssetup(&bcc_ptr, bytes_remaining, ses,
> > > +				      sess_data->nls_cp);
> > > +	} else {
> > > +		decode_ascii_ssetup(&bcc_ptr, bytes_remaining, ses,
> > > +				    sess_data->nls_cp);
> > > +	}
> > > +
> > > +out:
> > > +	sess_data->result = rc;
> > > +	sess_data->func = NULL;
> > > +	sess_free_buffer(sess_data);
> > > +	sess_establish_session(sess_data);
> > > +}
> > > +#endif
> > > +
> > >  int
> > >  CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
> > >  	       const struct nls_table *nls_cp)
> > > @@ -540,12 +771,20 @@ CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
> > >  	__le32 phase = NtLmNegotiate; /* NTLMSSP, if needed, is multistage */
> > >  	u16 blob_len;
> > >  	char *ntlmsspblob = NULL;
> > > +	struct sess_data *sess_data;
> > >  
> > >  	if (ses == NULL) {
> > >  		WARN(1, "%s: ses == NULL!", __func__);
> > >  		return -EINVAL;
> > >  	}
> > >  
> > > +	sess_data = kzalloc(sizeof(struct sess_data), GFP_KERNEL);
> > > +	if (!sess_data)
> > > +		return -ENOMEM;
> > > +	sess_data->xid = xid;
> > > +	sess_data->ses = ses;
> > > +	sess_data->nls_cp = (struct nls_table *) nls_cp;
> > > +
> > 
> > Where does this eventually get kfreed?
> 
> Looks like I made a mistake when splitting up the gigantic patch I ended
> up when cleaning up CIFS_SessSetup(). This is fixed in the last patch in
> the series.
> 
> I'll make the necessary changes so that we don't have a memory leak
> after the first patch.
> 
> > 
> > >  	type = select_sectype(ses->server, ses->sectype);
> > >  	cifs_dbg(FYI, "sess setup type %d\n", type);
> > >  	if (type == Unspecified) {
> > > @@ -554,6 +793,24 @@ CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
> > >  		return -EINVAL;
> > >  	}
> > >  
> > > +        switch (type) {
> > > +        case LANMAN:
> > > +                /* LANMAN and plaintext are less secure and off by default.
> > > +                 * So we make this explicitly be turned on in kconfig (in the
> > > +                 * build) and turned on at runtime (changed from the default)
> > > +                 * in proc/fs/cifs or via mount parm.  Unfortunately this is
> > > +                 * needed for old Win (e.g. Win95), some obscure NAS and OS/2 */
> > > +#ifdef CONFIG_CIFS_WEAK_PW_HASH
> > > +                sess_auth_lanman(sess_data);
> > > +		return sess_data->result;
> > > +#else
> > > +                return -EOPNOTSUPP;
> > > +#endif
> > 
> > This is a good opportunity to get rid of the #ifdef'ery inside of this
> > function. What you should do is create another sess_auth_lanman() when
> > CONFIG_CIFS_WEAK_PW_HASH is not defined, and have it just set
> > sess_data->result to -EOPNOTSUPP.
> 
> I can make this change as well.
> 
> Sachin Prabhu
> 

Thanks. Also, I don't quite understand (and haven't worked all the way
through the patchset yet).

Why pass back the result in sess_data->result instead of just making
these be int return functions?

> > 
> > > +	default:
> > > +		/* Continue with the rest of the function */
> > > +		break;
> > > +	}
> > > +
> > >  	if (type == RawNTLMSSP) {
> > >  		/* if memory allocation is successful, caller of this function
> > >  		 * frees it.
> > > @@ -569,17 +826,7 @@ ssetup_ntlmssp_authenticate:
> > >  	if (phase == NtLmChallenge)
> > >  		phase = NtLmAuthenticate; /* if ntlmssp, now final phase */
> > >  
> > > -	if (type == LANMAN) {
> > > -#ifndef CONFIG_CIFS_WEAK_PW_HASH
> > > -		/* LANMAN and plaintext are less secure and off by default.
> > > -		So we make this explicitly be turned on in kconfig (in the
> > > -		build) and turned on at runtime (changed from the default)
> > > -		in proc/fs/cifs or via mount parm.  Unfortunately this is
> > > -		needed for old Win (e.g. Win95), some obscure NAS and OS/2 */
> > > -		return -EOPNOTSUPP;
> > > -#endif
> > > -		wct = 10; /* lanman 2 style sessionsetup */
> > > -	} else if ((type == NTLM) || (type == NTLMv2)) {
> > > +	if ((type == NTLM) || (type == NTLMv2)) {
> > >  		/* For NTLMv2 failures eventually may need to retry NTLM */
> > >  		wct = 13; /* old style NTLM sessionsetup */
> > >  	} else /* same size: negotiate or auth, NTLMSSP or extended security */
> > > @@ -618,39 +865,7 @@ ssetup_ntlmssp_authenticate:
> > >  	iov[1].iov_base = NULL;
> > >  	iov[1].iov_len = 0;
> > >  
> > > -	if (type == LANMAN) {
> > > -#ifdef CONFIG_CIFS_WEAK_PW_HASH
> > > -		char lnm_session_key[CIFS_AUTH_RESP_SIZE];
> > > -
> > > -		pSMB->req.hdr.Flags2 &= ~SMBFLG2_UNICODE;
> > > -
> > > -		/* no capabilities flags in old lanman negotiation */
> > > -
> > > -		pSMB->old_req.PasswordLength = cpu_to_le16(CIFS_AUTH_RESP_SIZE);
> > > -
> > > -		/* Calculate hash with password and copy into bcc_ptr.
> > > -		 * Encryption Key (stored as in cryptkey) gets used if the
> > > -		 * security mode bit in Negottiate Protocol response states
> > > -		 * to use challenge/response method (i.e. Password bit is 1).
> > > -		 */
> > > -
> > > -		rc = calc_lanman_hash(ses->password, ses->server->cryptkey,
> > > -				 ses->server->sec_mode & SECMODE_PW_ENCRYPT ?
> > > -					true : false, lnm_session_key);
> > > -
> > > -		memcpy(bcc_ptr, (char *)lnm_session_key, CIFS_AUTH_RESP_SIZE);
> > > -		bcc_ptr += CIFS_AUTH_RESP_SIZE;
> > > -
> > > -		/* can not sign if LANMAN negotiated so no need
> > > -		to calculate signing key? but what if server
> > > -		changed to do higher than lanman dialect and
> > > -		we reconnected would we ever calc signing_key? */
> > > -
> > > -		cifs_dbg(FYI, "Negotiating LANMAN setting up strings\n");
> > > -		/* Unicode not allowed for LANMAN dialects */
> > > -		ascii_ssetup_strings(&bcc_ptr, ses, nls_cp);
> > > -#endif
> > > -	} else if (type == NTLM) {
> > > +	if (type == NTLM) {
> > >  		pSMB->req_no_secext.Capabilities = cpu_to_le32(capabilities);
> > >  		pSMB->req_no_secext.CaseInsensitivePasswordLength =
> > >  			cpu_to_le16(CIFS_AUTH_RESP_SIZE);
> > 
> > 
> 
> 


-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
