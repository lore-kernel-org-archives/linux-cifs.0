From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] [CIFS] NTLM auth and sign - Use appropriate server
 challenge
Date: Wed, 27 Oct 2010 15:28:43 -0400
Message-ID: <20101027152843.128185a8@tlielax.poochiereds.net>
References: <1288197518-9117-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1288197518-9117-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 27 Oct 2010 11:38:38 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Need to have cryptKey or server challenge in smb connection
> (struct TCP_Server_Info) for ntlm and ntlmv2 auth types for which
> cryptKey (Encryption Key) is supplied just once in Negotiate Protocol
> response during an smb connection setup for all the smb sessions over
> that smb connection.
> 
> For ntlmssp, cryptKey or server challenge is provided for every
> smb session in type 2 packet of ntlmssp negotiation, the cryptKey
> provided during Negotiation Protocol response before smb connection
> does not count.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c |   10 +++++++---
>  fs/cifs/cifsglob.h    |    3 ++-
>  fs/cifs/cifssmb.c     |    4 ++--
>  fs/cifs/connect.c     |    4 ++--
>  fs/cifs/sess.c        |   10 +++++++---
>  5 files changed, 20 insertions(+), 11 deletions(-)
> 

[...]

> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 67d6a22..7255657 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -196,6 +196,7 @@ struct TCP_Server_Info {
>  	int capabilities; /* allow selective disabling of caps by smb sess */
>  	int timeAdj;  /* Adjust for difference in server time zone in sec */
>  	__u16 CurrentMid;         /* multiplex id - rotating counter */
> +	char cryptKey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlm, ntlmv2 etc */
		^^^^^^^^^^
	Please, no camel-case on new fields.

>  	/* 16th byte of RFC1001 workstation name is always null */
>  	char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
>  	__u32 sequence_number; /* needed for CIFS PDU signature */
> @@ -240,7 +241,7 @@ struct cifsSesInfo {
>  	char userName[MAX_USERNAME_SIZE + 1];
>  	char *domainName;
>  	char *password;
> -	char cryptKey[CIFS_CRYPTO_KEY_SIZE];
> +	char cryptKey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlmssp */
		^^^^^
	And it wouldn't hurt to fix this one while you're in here.

>  	struct session_key auth_key;
>  	char ntlmv2_hash[16];
>  	unsigned int tilen; /* length of the target info blob */

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
