From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] [CIFS] [1/3 -v3] NTLM auth and sign - Allocate session
 key/client response dynamically
Date: Mon, 25 Oct 2010 12:14:10 -0400
Message-ID: <20101025121410.6a0aef5f@corrin.poochiereds.net>
References: <1287661375-6954-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287661375-6954-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 21 Oct 2010 06:42:55 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Start calculating auth response within a session.  Move/Add pertinet
> data structures like session key, server challenge and ntlmv2_hash in
> a session structure.  We should do the calculations within a session
> before copying session key and response over to server data
> structures because a session setup can fail.
> 
> Only after a very first smb session succeeds, it copy/make its
> session key, session key of smb connection.  This key stays with
> the smb connection throughout its life.
> sequence_number within server is set to 0x2.
> 
> The authentication Message Authentication Key (mak) which consists
> of session key followed by client response within structure session_key
> is now dynamic.  Every authentication type allocates the key + response
> sized memory within its session structure and later either assigns or
> frees it once the client response is sent and if session's session key
> becomes connetion's session key.
> 
> ntlm/ntlmi authentication functions are rearranged.  A function
> named setup_ntlm_resp(), similar to setup_ntlmv2_resp(), replaces
> function cifs_calculate_session_key().
> 
> size of CIFS_SESS_KEY_SIZE is changed to 16, to reflect the byte size
> of the key it holds.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsencrypt.c |  113 ++++++++++++++++++++++++++++---------------------
>  fs/cifs/cifsglob.h    |    9 +----
>  fs/cifs/cifspdu.h     |    7 +++-
>  fs/cifs/cifsproto.h   |   11 ++---
>  fs/cifs/connect.c     |   18 +++++++-
>  fs/cifs/sess.c        |  107 +++++++++++++++++-----------------------------
>  fs/cifs/transport.c   |    6 +-
>  7 files changed, 134 insertions(+), 137 deletions(-)
> 

[...]

> @@ -3178,10 +3185,11 @@ int cifs_setup_session(unsigned int xid, struct cifsSesInfo *ses,
>  	} else {
>  		mutex_lock(&ses->server->srv_mutex);
>  		if (!server->session_estab) {
> -			memcpy(&server->session_key.data,
> -				&ses->auth_key.data, ses->auth_key.len);
> +			server->session_key.response = ses->auth_key.response;
>  			server->session_key.len = ses->auth_key.len;
> -			ses->server->session_estab = true;
> +			server->sequence_number = 0x2;

It looks like the sequence_number is protected by the Global_MidLock.
It's not held here. Are there potential races with setting this value
here?

On a related note, given that the sequence_number is a simple counter,
is there a reason to protect it with that lock? Maybe it's a candidate
for converstion to atomic_t?

If so, I'd advise doing that conversion in a separate follow-on patch.

> +			server->session_estab = true;
> +			ses->auth_key.response = NULL;
>  		}
>  		mutex_unlock(&server->srv_mutex);
>  

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
