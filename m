From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: stop trying to use virtual circuits
Date: Mon, 16 Sep 2013 13:49:04 -0400
Message-ID: <20130916134904.343c876f@tlielax.poochiereds.net>
References: <1379345025-10868-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sauron99-Mmb7MZpHnFY@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1379345025-10868-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 16 Sep 2013 11:23:45 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Currently, we try to ensure that we use vcnum of 0 on the first
> established session on a connection and then try to use a different
> vcnum on each session after that.
> 
> This is a little odd, since there's no real reason to use a different
> vcnum for each SMB session. I can only assume there was some confusion
> between SMB sessions and VCs. That's somewhat understandable since they
> both get created during SESSION_SETUP, but the documentation indicates
> that they are really orthogonal. The comment on max_vcs in particular
> looks quite misguided. An SMB session is already uniquely identified
> by the SMB UID value -- there's no need to again uniquely ID with a
> VC.
> 
> Furthermore, a vcnum of 0 is a cue to the server that it should release
> any resources that were previously held by the client. This sounds like
> a good thing, until you consider that:
> 
> a) it totally ignores the fact that other programs on the box (e.g.
> smbclient) might have connections established to the server. Using a
> vcnum of 0 causes them to get kicked off.
> 
> b) it causes problems with NAT. If several clients are connected to the
> same server via the same NAT'ed address, whenever one connects to the
> server it kicks off all the others, which then reconnect and kick off
> the first one...ad nauseum.
> 
> I don't see any reason to ignore the advice in "Implementing CIFS" which
> has a comprehensive treatment of virtual circuits. In there, it states
> "...and contrary to the specs the client should always use a VcNumber of
> one, never zero."
> 
> Have the client just use a hardcoded vcnum of 1, and stop abusing the
> special behavior of vcnum 0.
> 


Forgot to mention too that I believe this patch will fix:

    https://bugzilla.samba.org/show_bug.cgi?id=10113


> Reported-by: Sauron99-Mmb7MZpHnFY@public.gmane.org <sauron99-Mmb7MZpHnFY@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |  4 ---
>  fs/cifs/cifssmb.c  |  1 -
>  fs/cifs/sess.c     | 84 +-----------------------------------------------------
>  3 files changed, 1 insertion(+), 88 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index cfa14c8..9c72be6 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -547,9 +547,6 @@ struct TCP_Server_Info {
>  	unsigned int max_rw;	/* maxRw specifies the maximum */
>  	/* message size the server can send or receive for */
>  	/* SMB_COM_WRITE_RAW or SMB_COM_READ_RAW. */
> -	unsigned int max_vcs;	/* maximum number of smb sessions, at least
> -				   those that can be specified uniquely with
> -				   vcnumbers */
>  	unsigned int capabilities; /* selective disabling of caps by smb sess */
>  	int timeAdj;  /* Adjust for difference in server time zone in sec */
>  	__u64 CurrentMid;         /* multiplex id - rotating counter */
> @@ -715,7 +712,6 @@ struct cifs_ses {
>  	enum statusEnum status;
>  	unsigned overrideSecFlg;  /* if non-zero override global sec flags */
>  	__u16 ipc_tid;		/* special tid for connection to IPC share */
> -	__u16 vcnum;
>  	char *serverOS;		/* name of operating system underlying server */
>  	char *serverNOS;	/* name of network operating system of server */
>  	char *serverDomain;	/* security realm of server */
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index a3d74fe..4baf359 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -463,7 +463,6 @@ decode_lanman_negprot_rsp(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr)
>  			       cifs_max_pending);
>  	set_credits(server, server->maxReq);
>  	server->maxBuf = le16_to_cpu(rsp->MaxBufSize);
> -	server->max_vcs = le16_to_cpu(rsp->MaxNumberVcs);
>  	/* even though we do not use raw we might as well set this
>  	accurately, in case we ever find a need for it */
>  	if ((le16_to_cpu(rsp->RawMode) & RAW_ENABLE) == RAW_ENABLE) {
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 5f99b7f..352358d 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -32,88 +32,6 @@
>  #include <linux/slab.h>
>  #include "cifs_spnego.h"
>  
> -/*
> - * Checks if this is the first smb session to be reconnected after
> - * the socket has been reestablished (so we know whether to use vc 0).
> - * Called while holding the cifs_tcp_ses_lock, so do not block
> - */
> -static bool is_first_ses_reconnect(struct cifs_ses *ses)
> -{
> -	struct list_head *tmp;
> -	struct cifs_ses *tmp_ses;
> -
> -	list_for_each(tmp, &ses->server->smb_ses_list) {
> -		tmp_ses = list_entry(tmp, struct cifs_ses,
> -				     smb_ses_list);
> -		if (tmp_ses->need_reconnect == false)
> -			return false;
> -	}
> -	/* could not find a session that was already connected,
> -	   this must be the first one we are reconnecting */
> -	return true;
> -}
> -
> -/*
> - *	vc number 0 is treated specially by some servers, and should be the
> - *      first one we request.  After that we can use vcnumbers up to maxvcs,
> - *	one for each smb session (some Windows versions set maxvcs incorrectly
> - *	so maxvc=1 can be ignored).  If we have too many vcs, we can reuse
> - *	any vc but zero (some servers reset the connection on vcnum zero)
> - *
> - */
> -static __le16 get_next_vcnum(struct cifs_ses *ses)
> -{
> -	__u16 vcnum = 0;
> -	struct list_head *tmp;
> -	struct cifs_ses *tmp_ses;
> -	__u16 max_vcs = ses->server->max_vcs;
> -	__u16 i;
> -	int free_vc_found = 0;
> -
> -	/* Quoting the MS-SMB specification: "Windows-based SMB servers set this
> -	field to one but do not enforce this limit, which allows an SMB client
> -	to establish more virtual circuits than allowed by this value ... but
> -	other server implementations can enforce this limit." */
> -	if (max_vcs < 2)
> -		max_vcs = 0xFFFF;
> -
> -	spin_lock(&cifs_tcp_ses_lock);
> -	if ((ses->need_reconnect) && is_first_ses_reconnect(ses))
> -			goto get_vc_num_exit;  /* vcnum will be zero */
> -	for (i = ses->server->srv_count - 1; i < max_vcs; i++) {
> -		if (i == 0) /* this is the only connection, use vc 0 */
> -			break;
> -
> -		free_vc_found = 1;
> -
> -		list_for_each(tmp, &ses->server->smb_ses_list) {
> -			tmp_ses = list_entry(tmp, struct cifs_ses,
> -					     smb_ses_list);
> -			if (tmp_ses->vcnum == i) {
> -				free_vc_found = 0;
> -				break; /* found duplicate, try next vcnum */
> -			}
> -		}
> -		if (free_vc_found)
> -			break; /* we found a vcnumber that will work - use it */
> -	}
> -
> -	if (i == 0)
> -		vcnum = 0; /* for most common case, ie if one smb session, use
> -			      vc zero.  Also for case when no free vcnum, zero
> -			      is safest to send (some clients only send zero) */
> -	else if (free_vc_found == 0)
> -		vcnum = 1;  /* we can not reuse vc=0 safely, since some servers
> -				reset all uids on that, but 1 is ok. */
> -	else
> -		vcnum = i;
> -	ses->vcnum = vcnum;
> -get_vc_num_exit:
> -	spin_unlock(&cifs_tcp_ses_lock);
> -
> -	return cpu_to_le16(vcnum);
> -}
> -
>  static __u32 cifs_ssetup_hdr(struct cifs_ses *ses, SESSION_SETUP_ANDX *pSMB)
>  {
>  	__u32 capabilities = 0;
> @@ -128,7 +46,7 @@ static __u32 cifs_ssetup_hdr(struct cifs_ses *ses, SESSION_SETUP_ANDX *pSMB)
>  					CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4,
>  					USHRT_MAX));
>  	pSMB->req.MaxMpxCount = cpu_to_le16(ses->server->maxReq);
> -	pSMB->req.VcNumber = get_next_vcnum(ses);
> +	pSMB->req.VcNumber = __constant_cpu_to_le16(1);
>  
>  	/* Now no need to set SMBFLG_CASELESS or obsolete CANONICAL PATH */
>  

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
