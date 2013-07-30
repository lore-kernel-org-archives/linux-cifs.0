From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: NTLMSSP unix query info problem
Date: Tue, 30 Jul 2013 06:32:36 -0400
Message-ID: <20130730063236.406ade84@corrin.poochiereds.net>
References: <CAKywueTz3hRCgFB00dGPE3Bo2mnPN_efZCtzc-yc4c6umg0pUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTz3hRCgFB00dGPE3Bo2mnPN_efZCtzc-yc4c6umg0pUQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 29 Jul 2013 20:41:53 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> For sec=ntlmssp unix query path info call returns OK for a
> non-existing uppercase filename if a lowercase one exists. E.g.: stat
> ABC return info about 'abc' file.
> 
> But for sec=ntlmv2 or sec=ntlm this call fails with
> STATUS_OBJECT_NAME_NOT_FOUND error code.
> 
> This difference was found on upgrade from v3.7 to v3.8 kernel due to
> changing the default security mechanism to NTLMSSP.
> 
> Any thoughts on this?
> 

Is this a client or server problem?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
