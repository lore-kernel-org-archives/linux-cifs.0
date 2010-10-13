From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] [CIFS] [1/4] NTLM authentication and signing -
 Calculate auth response per smb session
Date: Wed, 13 Oct 2010 08:36:42 -0400
Message-ID: <20101013083642.74d9b8a9@corrin.poochiereds.net>
References: <1286912703-22661-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286912703-22661-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 12 Oct 2010 14:45:03 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> Start calculation auth response within a session.  Move/Add pertinet
> data structures like session key, server challenge and ntlmv2_hash in
> a session structure.  We should do the calculations within a session
> before copying session key and response over to server data
> structures because a session setup can fail.
> 
> Only after a very first smb session succeeds, it copies/makes its
> session key, session key of smb connection.  This key stays with
> the smb connection throughout its life.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


>  		bcc_ptr += CIFS_SESS_KEY_SIZE;
>  		if (ses->capabilities & CAP_UNICODE) {
> @@ -3175,6 +3176,15 @@ int cifs_setup_session(unsigned int xid, struct cifsSesInfo *ses,
>  	if (rc) {
>  		cERROR(1, "Send error in SessSetup = %d", rc);
>  	} else {
> +		mutex_lock(&ses->server->srv_mutex);
> +		if (!server->session_estab) {
> +			memcpy(&server->session_key.data,
> +				&ses->auth_key.data, ses->auth_key.len);
> +			server->session_key.len = ses->auth_key.len;
> +			ses->server->session_estab = true;
			^^^^
			nit: Aren't "server" and "ses->server" the
			same? Why access them differently here?

> +		}
> +		mutex_unlock(&server->srv_mutex);
> +
		^^^^^^
		What are the rules for locking around the session_estab
		flag? Here you're holding the srv_mutex when checking
		and altering it, but in cifs_reconnect you're altering
		it without holding the mutex. Is that a potential race
		condition?

>  		cFYI(1, "CIFS Session Established successfully");
>  		spin_lock(&GlobalMid_Lock);
>  		ses->status = CifsGood;

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
