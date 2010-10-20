From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] [CIFS} [1/3] NTLM auth & signing - Allocate session
 key/client response dynamically
Date: Wed, 20 Oct 2010 10:45:39 -0400
Message-ID: <20101020104539.5a17a03e@tlielax.poochiereds.net>
References: <1287533637-22367-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287533637-22367-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 19 Oct 2010 19:13:57 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Start calculation auth response within a session.  Move/Add pertinet
> data structures like session key, server challenge and ntlmv2_hash in
> a session structure.  We should do the calculations within a session
> before copying session key and response over to server data
> structures because a session setup can fail.
> 
> Only after a very first smb session succeeds, it copy/make its
> session key, session key of smb connection.  This key stays with
> the smb connection throughout its life.
> 
> The authentication response field within structure session_key
> is now dynamic.  Every authentication type allocates the response sized
> memory within its session structure and later frees it once the
> client response is sent and if session's session key becomes 
> connetion's session key.
> 
> ntlm/ntlmi authentication functions are rearranged.  A function
> named setup_ntlm_resp(), similar to setup_ntlmv2_resp(), replaces
> function cifs_calculate_session_key().
> 
> size of CIFS_SESS_KEY_SIZE is changed to 16, to reflect the byte size
> of the key it holds.
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c |   99 +++++++++++++++++++++++++----------------------
>  fs/cifs/cifsglob.h    |   10 +----
>  fs/cifs/cifspdu.h     |    7 +++-
>  fs/cifs/cifsproto.h   |   11 ++---
>  fs/cifs/connect.c     |   33 ++++++++++++++--
>  fs/cifs/sess.c        |  103 +++++++++++++++++++------------------------------
>  fs/cifs/transport.c   |    6 +-
>  7 files changed, 137 insertions(+), 132 deletions(-)
> 

[...]

> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 18ee0ad..c374859 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -98,15 +98,9 @@ enum protocolEnum {
>  };
>  
>  struct session_key {
> +	char key[16];
> +	char *response;
	^^^^^^^
	What's the point of keeping the key separate from the response?
	If you'll always need to allocate memory for the response, why
	not allocate the key too as part of the same allocation?

>  	unsigned int len;
> -	union {
> -		char ntlm[CIFS_SESS_KEY_SIZE + 16];
> -		char krb5[CIFS_SESS_KEY_SIZE + 16]; /* BB: length correct? */
> -		struct {
> -			char key[16];
> -			struct ntlmv2_resp resp;
> -		} ntlmv2;
> -	} data;
>  };
>  
>  struct cifs_cred {
> diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
> index b0f4b56..a152cd6 100644
> --- a/fs/cifs/cifspdu.h
> +++ b/fs/cifs/cifspdu.h
> @@ -131,9 +131,14 @@
>  #define CIFS_CRYPTO_KEY_SIZE (8)
>  
>  /*
> + * Size of the ntlm client response
> + */
> +#define CIFS_AUTH_RESP_SIZE (24)
> +
> +/*
>   * Size of the session key (crypto key encrypted with the password
>   */
> -#define CIFS_SESS_KEY_SIZE (24)
> +#define CIFS_SESS_KEY_SIZE (16)
>  
>  /*
>   * Maximum user name length
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index e593c40..8c2d0cf 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -362,13 +362,12 @@ extern int cifs_sign_smb(struct smb_hdr *, struct TCP_Server_Info *, __u32 *);
>  extern int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *,
>  			  __u32 *);
>  extern int cifs_verify_signature(struct smb_hdr *,
> -				 const struct session_key *session_key,
> +				 struct TCP_Server_Info *server,
>  				__u32 expected_sequence_number);
> -extern int cifs_calculate_session_key(struct session_key *key, const char *rn,
> -				 const char *pass);
> -extern void CalcNTLMv2_response(const struct cifsSesInfo *, char *);
> -extern int setup_ntlmv2_rsp(struct cifsSesInfo *, char *,
> -			     const struct nls_table *);
> +extern void SMBNTencrypt(unsigned char *, unsigned char *, unsigned char *);
> +extern int setup_ntlm_response(struct cifsSesInfo *);
> +extern void CalcNTLMv2_response(const struct cifsSesInfo *);
> +extern int setup_ntlmv2_rsp(struct cifsSesInfo *, const struct nls_table *);
>  #ifdef CONFIG_CIFS_WEAK_PW_HASH
>  extern void calc_lanman_hash(const char *password, const char *cryptkey,
>  				bool encrypt, char *lnm_session_key);
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 019f003..1006dec 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -175,6 +175,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
>  	}
>  	server->sequence_number = 0;
>  	server->session_estab = false;
> +	kfree(server->session_key.response);
> +	server->session_key.response = NULL;
> +	server->session_key.len = 0;
>  
>  	spin_lock(&GlobalMid_Lock);
>  	list_for_each(tmp, &server->pending_mid_q) {
> @@ -1562,6 +1565,10 @@ cifs_put_tcp_session(struct TCP_Server_Info *server)
>  
>  	cifs_fscache_release_client_cookie(server);
>  
> +	kfree(server->session_key.response);
> +	server->session_key.response = NULL;
> +	server->session_key.len = 0;
> +
>  	task = xchg(&server->tsk, NULL);
>  	if (task)
>  		force_sig(SIGKILL, task);
> @@ -3162,6 +3169,7 @@ int cifs_setup_session(unsigned int xid, struct cifsSesInfo *ses,
>  			struct nls_table *nls_info)
>  {
>  	int rc = 0;
> +	unsigned int len;
>  	struct TCP_Server_Info *server = ses->server;
>  
>  	ses->flags = 0;
> @@ -3178,10 +3186,22 @@ int cifs_setup_session(unsigned int xid, struct cifsSesInfo *ses,
>  	} else {
>  		mutex_lock(&ses->server->srv_mutex);
>  		if (!server->session_estab) {
> -			memcpy(&server->session_key.data,
> -				&ses->auth_key.data, ses->auth_key.len);
> -			server->session_key.len = ses->auth_key.len;
> -			ses->server->session_estab = true;
> +			if (server->secType == RawNTLMSSP)
> +				len = 16;
				^^^^^^^^^
			Why is this special-cased here? Does the
			auth_key have an incorrect len field in the
			RawNTLMSSP case?

> +			else
> +				len = ses->auth_key.len;
> +			server->session_key.response = kmalloc(len, GFP_KERNEL);
> +			if (!server->session_key.response) {
> +				rc = -ENOMEM;
> +				mutex_unlock(&server->srv_mutex);
> +				goto cifs_setup_session_ret;
> +			}
> +			memcpy(server->session_key.response,
> +				ses->auth_key.response, len);
> +			memcpy(server->session_key.key,
> +				ses->auth_key.key, 16);

Hmmm...you're going to be freeing ses->auth_key.response below.
Wouldn't it make more sense to just "hand-off" the pointer to the
response field instead? For instance:

	server->session_key.response = ses->auth_key.response;
	ses->auth_key.response = NULL;
	ses->auth_key.len = 0;

Then you don't have to deal with an error condition, etc...

> +			server->session_key.len = len;
> +			server->session_estab = true;
>  		}
>  		mutex_unlock(&server->srv_mutex);
>  
> @@ -3192,6 +3212,11 @@ int cifs_setup_session(unsigned int xid, struct cifsSesInfo *ses,
>  		spin_unlock(&GlobalMid_Lock);
>  	}
>  
> +cifs_setup_session_ret:
> +	kfree(ses->auth_key.response);
> +	ses->auth_key.response = NULL;
> +	ses->auth_key.len = 0;
> +
>  	return rc;
>  }
>  
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index e35dc60..8bb4518 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c

[...]

> @@ -785,16 +756,24 @@ ssetup_ntlmssp_authenticate:
>  			rc = -EKEYREJECTED;
>  			goto ssetup_exit;
>  		}
> +
> +		resplen = CIFS_SESS_KEY_SIZE + CIFS_AUTH_RESP_SIZE;
>  		/* bail out if key is too long */
> -		if (msg->sesskey_len >
> -		    sizeof(ses->auth_key.data.krb5)) {
> +		if (msg->sesskey_len > resplen) {
>  			cERROR(1, "Kerberos signing key too long (%u bytes)",
>  				msg->sesskey_len);
>  			rc = -EOVERFLOW;
>  			goto ssetup_exit;
>  		}
> +		ses->auth_key.response = kmalloc(resplen, GFP_KERNEL);
> +		if (!ses->auth_key.response) {
> +			cERROR(1, "Kerberos can't allocate (%u bytes) memory",
> +				resplen);
> +			rc = -ENOMEM;
> +			goto ssetup_exit;
> +		}
>  		ses->auth_key.len = msg->sesskey_len;
> -		memcpy(ses->auth_key.data.krb5, msg->data, msg->sesskey_len);
> +		memcpy(ses->auth_key.response, msg->data, msg->sesskey_len);

			^^^^^^^^^^
		This looks questionable. Previously we had a fixed 40
		byte field for the krb5 key (CIFS_SESS_KEY_SIZE (24) +
		16). Now, we have a 16 byte key and a 40-byte response field
		(CIFS_SESS_KEY_SIZE (16) + CIFS_AUTH_RESP_SIZE (24)),
		You're copying the data into the auth_key.response but
		the auth_key.key seems to be unused. Won't that mean
		that signing is broken?

		I suppose you could copy the first 16 bytes into the
		key part and then stick the rest into the response
		field, but that seems sort of kludgey. It would make
		more sense to have the session_key just be a length and
		a pointer to memory allocated off the slab and do away
		with the fixed-length key[16] field.

		Then when you want to access the key/response, just
		cast that pointer to a struct that has the fields you
		need.

>  		pSMB->req.hdr.Flags2 |= SMBFLG2_EXT_SEC;
>  		capabilities |= CAP_EXTENDED_SECURITY;
>  		pSMB->req.Capabilities = cpu_to_le32(capabilities);
> @@ -897,8 +876,6 @@ ssetup_ntlmssp_authenticate:
>  			  CIFS_STD_OP /* not long */ | CIFS_LOG_ERROR);
>  	/* SMB request buf freed in SendReceive2 */
>  
> -	cFYI(1, "ssetup rc from sendrecv2 is %d", rc);
> -
>  	pSMB = (SESSION_SETUP_ANDX *)iov[0].iov_base;
>  	smb_buf = (struct smb_hdr *)iov[0].iov_base;
>

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
