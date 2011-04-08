From: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
Subject: Re: [PATCH] CIFS: Assume passwords are encoded according to
 iocharset
Date: Fri, 8 Apr 2011 16:11:12 +0200
Message-ID: <20110408141112.GA20074@osk.mine.nu>
References: <20110327125648.GA3621@osk.mine.nu>
 <20110408093148.748eda25@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110408093148.748eda25-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Friday, April 08, 2011 at 09:48, Jeff Layton wrote:
> On Sun, 27 Mar 2011 14:56:48 +0200
> Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org> wrote:
> 
> > Modify cifs to assume that the supplied password is encoded according to
> > iocharset.  Before this patch passwords would be treated as raw 8-bit data,
> > which made authentication with Unicode passwords impossible (at least
> > passwords with characters > 0xFF).
> > 
> > The previous code would as a side effect accept passwords encoded with ISO
> > 8859-1, since Unicode < 0x100 basically is ISO 8859-1.  Software which
> > relies on that will no longer support password chars > 0x7F unless it also
> > uses iocharset=iso8859-1.  (mount.cifs does not care about the encoding so
> > it will work as expected.)
> > 
> > Signed-off-by: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
> > ---
> >  fs/cifs/cifsencrypt.c |    8 +++---
> >  fs/cifs/cifsproto.h   |    8 ++++--
> >  fs/cifs/connect.c     |    2 +-
> >  fs/cifs/sess.c        |    2 +-
> >  fs/cifs/smbencrypt.c  |   60 +++++++++----------------------------------------
> >  5 files changed, 22 insertions(+), 58 deletions(-)
> > 
> > diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> > index 5bb4b09..3c1306d 100644
> > --- a/fs/cifs/cifsencrypt.c
> > +++ b/fs/cifs/cifsencrypt.c
> > @@ -226,7 +226,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_pdu,
> >  }
> >  
> >  /* first calculate 24 bytes ntlm response and then 16 byte session key */
> > -int setup_ntlm_response(struct cifs_ses *ses)
> > +int setup_ntlm_response(struct cifs_ses *ses, const struct nls_table *nls_cp)
> >  {
> >  	int rc = 0;
> >  	unsigned int temp_len = CIFS_SESS_KEY_SIZE + CIFS_AUTH_RESP_SIZE;
> > @@ -243,14 +243,14 @@ int setup_ntlm_response(struct cifs_ses *ses)
> >  	ses->auth_key.len = temp_len;
> >  
> >  	rc = SMBNTencrypt(ses->password, ses->server->cryptkey,
> > -			ses->auth_key.response + CIFS_SESS_KEY_SIZE);
> > +			ses->auth_key.response + CIFS_SESS_KEY_SIZE, nls_cp);
> >  	if (rc) {
> >  		cFYI(1, "%s Can't generate NTLM response, error: %d",
> >  			__func__, rc);
> >  		return rc;
> >  	}
> >  
> > -	rc = E_md4hash(ses->password, temp_key);
> > +	rc = E_md4hash(ses->password, temp_key, nls_cp);
> >  	if (rc) {
> >  		cFYI(1, "%s Can't generate NT hash, error: %d", __func__, rc);
> >  		return rc;
> > @@ -458,7 +458,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
> >  	}
> >  
> >  	/* calculate md4 hash of password */
> > -	E_md4hash(ses->password, nt_hash);
> > +	E_md4hash(ses->password, nt_hash, nls_cp);
> >  
> >  	crypto_shash_setkey(ses->server->secmech.hmacmd5, nt_hash,
> >  				CIFS_NTHASH_SIZE);
> > diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> > index e42dc82..fd6d873 100644
> > --- a/fs/cifs/cifsproto.h
> > +++ b/fs/cifs/cifsproto.h
> > @@ -376,8 +376,9 @@ extern int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *,
> >  extern int cifs_verify_signature(struct smb_hdr *,
> >  				 struct TCP_Server_Info *server,
> >  				__u32 expected_sequence_number);
> > -extern int SMBNTencrypt(unsigned char *, unsigned char *, unsigned char *);
> > -extern int setup_ntlm_response(struct cifs_ses *);
> > +extern int SMBNTencrypt(unsigned char *, unsigned char *, unsigned char *,
> > +			const struct nls_table *);
> > +extern int setup_ntlm_response(struct cifs_ses *, const struct nls_table *);
> >  extern int setup_ntlmv2_rsp(struct cifs_ses *, const struct nls_table *);
> >  extern int cifs_crypto_shash_allocate(struct TCP_Server_Info *);
> >  extern void cifs_crypto_shash_release(struct TCP_Server_Info *);
> > @@ -429,7 +430,8 @@ extern int CIFSCheckMFSymlink(struct cifs_fattr *fattr,
> >  		const unsigned char *path,
> >  		struct cifs_sb_info *cifs_sb, int xid);
> >  extern int mdfour(unsigned char *, unsigned char *, int);
> > -extern int E_md4hash(const unsigned char *passwd, unsigned char *p16);
> > +extern int E_md4hash(const unsigned char *passwd, unsigned char *p16,
> > +		     const struct nls_table *codepage);
> >  extern int SMBencrypt(unsigned char *passwd, const unsigned char *c8,
> >  			unsigned char *p24);
> >  #endif			/* _CIFSPROTO_H */
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 96544a4..3c0190f 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -3060,7 +3060,7 @@ CIFSTCon(unsigned int xid, struct cifs_ses *ses,
> >  		else
> >  #endif /* CIFS_WEAK_PW_HASH */
> >  		rc = SMBNTencrypt(tcon->password, ses->server->cryptkey,
> > -					bcc_ptr);
> > +					bcc_ptr, nls_codepage);
> >  
> >  		bcc_ptr += CIFS_AUTH_RESP_SIZE;
> >  		if (ses->capabilities & CAP_UNICODE) {
> > diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> > index 6b140e1..17ae0db 100644
> > --- a/fs/cifs/sess.c
> > +++ b/fs/cifs/sess.c
> > @@ -694,7 +694,7 @@ ssetup_ntlmssp_authenticate:
> >  			cpu_to_le16(CIFS_AUTH_RESP_SIZE);
> >  
> >  		/* calculate ntlm response and session key */
> > -		rc = setup_ntlm_response(ses);
> > +		rc = setup_ntlm_response(ses, nls_cp);
> >  		if (rc) {
> >  			cERROR(1, "Error %d during NTLM authentication", rc);
> >  			goto ssetup_exit;
> > diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
> > index 1525d5e..92291c1 100644
> > --- a/fs/cifs/smbencrypt.c
> > +++ b/fs/cifs/smbencrypt.c
> > @@ -195,46 +195,13 @@ SMBencrypt(unsigned char *passwd, const unsigned char *c8, unsigned char *p24)
> >  	return rc;
> >  }
> >  
> > -/* Routines for Windows NT MD4 Hash functions. */
> > -static int
> > -_my_wcslen(__u16 *str)
> > -{
> > -	int len = 0;
> > -	while (*str++ != 0)
> > -		len++;
> > -	return len;
> > -}
> > -
> > -/*
> > - * Convert a string into an NT UNICODE string.
> > - * Note that regardless of processor type
> > - * this must be in intel (little-endian)
> > - * format.
> > - */
> > -
> > -static int
> > -_my_mbstowcs(__u16 *dst, const unsigned char *src, int len)
> > -{	/* BB not a very good conversion routine - change/fix */
> > -	int i;
> > -	__u16 val;
> > -
> > -	for (i = 0; i < len; i++) {
> > -		val = *src;
> > -		SSVAL(dst, 0, val);
> > -		dst++;
> > -		src++;
> > -		if (val == 0)
> > -			break;
> > -	}
> > -	return i;
> > -}
> > -
> >  /*
> >   * Creates the MD4 Hash of the users password in NT UNICODE.
> >   */
> >  
> >  int
> > -E_md4hash(const unsigned char *passwd, unsigned char *p16)
> > +E_md4hash(const unsigned char *passwd, unsigned char *p16,
> > +	  const struct nls_table *codepage)
> >  {
> >  	int rc;
> >  	int len;
> > @@ -242,20 +209,14 @@ E_md4hash(const unsigned char *passwd, unsigned char *p16)
> >  
> >  	/* Password cannot be longer than 128 characters */
> >  	if (passwd) {
> > -		len = strlen((char *) passwd);
> > -		if (len > 128)
> > -			len = 128;
> > -
> >  		/* Password must be converted to NT unicode */
> > -		_my_mbstowcs(wpwd, passwd, len);
> > -	} else
> > +		len = cifs_strtoUCS(wpwd, passwd, 128, codepage);
> > +	} else {
> >  		len = 0;
> > +		*wpwd = 0; /* Ensure string is null terminated */
> > +	}
> >  
> > -	wpwd[len] = 0;	/* Ensure string is null terminated */
> > -	/* Calculate length in bytes */
> > -	len = _my_wcslen(wpwd) * sizeof(__u16);
> > -
> > -	rc = mdfour(p16, (unsigned char *) wpwd, len);
> > +	rc = mdfour(p16, (unsigned char *) wpwd, len * sizeof(__u16));
> >  	memset(wpwd, 0, 129 * 2);
> >  
> >  	return rc;
> > @@ -275,7 +236,7 @@ nt_lm_owf_gen(char *pwd, unsigned char nt_p16[16], unsigned char p16[16])
> >  		memcpy(passwd, pwd, 512);
> >  	/* Calculate the MD4 hash (NT compatible) of the password */
> >  	memset(nt_p16, '\0', 16);
> > -	E_md4hash(passwd, nt_p16);
> > +	E_md4hash(passwd, nt_p16, /* put nls codepage here */);
> 			^^^^^^^^^^^^^
> 		Won't this fail to compile?

Yes, but it's inside a function which is commented out and not compiled. Instead
of adding an extra parameter to the function (which would be required) I
decided just to put a reminder there if that function is ever used in the
future.

#if 0 /* currently unused */
/* Does both the NT and LM owfs of a user's password */
static void
nt_lm_owf_gen(char *pwd, unsigned char nt_p16[16], unsigned char p16[16])
{
        char passwd[514];

        memset(passwd, '\0', 514);
        if (strlen(pwd) < 513)
                strcpy(passwd, pwd);
        else
                memcpy(passwd, pwd, 512);
        /* Calculate the MD4 hash (NT compatible) of the password */
        memset(nt_p16, '\0', 16);
        E_md4hash(passwd, nt_p16, /* put nls codepage here */);

        /* Mangle the passwords into Lanman format */
        passwd[14] = '\0';
/*      strupper(passwd); */

        /* Calculate the SMB (lanman) hash functions of the password */

        memset(p16, '\0', 16);
        E_P16((unsigned char *) passwd, (unsigned char *) p16);

        /* clear out local copy of user's password (just being paranoid). */
        memset(passwd, '\0', sizeof(passwd));
}
#endif
