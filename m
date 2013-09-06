From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 2/3] cifs: Add a variable specific to NTLMSSP for key
 exchange.
Date: Fri, 6 Sep 2013 09:13:19 -0400
Message-ID: <20130906091319.2eafecdd@corrin.poochiereds.net>
References: <1377783311-3924-1-git-send-email-shirishpargaonkar@gmail.com>
	<1377783311-3924-3-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1377783311-3924-3-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 29 Aug 2013 08:35:10 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Add a variable specific to NTLMSSP authentication to determine
> whether to exchange keys during negotiation and authentication phases.
> 
> Since session key for smb1 is per smb connection, once a very first
> sesion is established, there is no need for key exchange during
> subsequent session setups. As a result, smb1 session setup code sets this
> variable as false.
> 
> Since session key for smb2 and smb3 is per smb connection, we need to
> exchange keys to generate session key for every sesion being established.
> As a result, smb2/3 session setup code sets this variable as true.
> ---
>  fs/cifs/cifsglob.h | 1 +
>  fs/cifs/sess.c     | 8 ++++++--
>  fs/cifs/smb2pdu.c  | 1 +
>  3 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 52ca861..cce26a8 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -135,6 +135,7 @@ struct cifs_secmech {
>  
>  /* per smb session structure/fields */
>  struct ntlmssp_auth {
> +	bool sesskey_per_smbsess; /* whether session key is per smb session */
>  	__u32 client_flags; /* sent by client in type 1 ntlmsssp exchange */
>  	__u32 server_flags; /* sent by server in type 2 ntlmssp exchange */
>  	unsigned char ciphertext[CIFS_CPHTXT_SIZE]; /* sent to server */
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 7afd54a..d7907c4 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -428,7 +428,8 @@ void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
>  		NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC;
>  	if (ses->server->sign) {
>  		flags |= NTLMSSP_NEGOTIATE_SIGN;
> -		if (!ses->server->session_estab)
> +		if (!ses->server->session_estab ||
> +				ses->ntlmssp->sesskey_per_smbsess)
>  			flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
>  	}
>  
> @@ -466,7 +467,8 @@ int build_ntlmssp_auth_blob(unsigned char *pbuffer,
>  		NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC;
>  	if (ses->server->sign) {
>  		flags |= NTLMSSP_NEGOTIATE_SIGN;
> -		if (!ses->server->session_estab)
> +		if (!ses->server->session_estab ||
> +				ses->ntlmssp->sesskey_per_smbsess)
>  			flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
>  	}
>  
> @@ -641,6 +643,8 @@ CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
>  		ses->ntlmssp = kmalloc(sizeof(struct ntlmssp_auth), GFP_KERNEL);
>  		if (!ses->ntlmssp)
>  			return -ENOMEM;
> +		ses->ntlmssp->sesskey_per_smbsess = false;
> +
>  	}
>  
>  ssetup_ntlmssp_authenticate:
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 05a0186..28083b4 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -491,6 +491,7 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
>  	ses->ntlmssp = kmalloc(sizeof(struct ntlmssp_auth), GFP_KERNEL);
>  	if (!ses->ntlmssp)
>  		return -ENOMEM;
> +	ses->ntlmssp->sesskey_per_smbsess = true;
>  
>  	/* FIXME: allow for other auth types besides NTLMSSP (e.g. krb5) */
>  	ses->sectype = RawNTLMSSP;

Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
