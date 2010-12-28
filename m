From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Connection problems using kerberos against EMC Celerra servers
Date: Tue, 28 Dec 2010 07:35:32 -0500
Message-ID: <20101228073532.556e9643@tlielax.poochiereds.net>
References: <1293525693-11562-1-git-send-email-metze@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293525693-11562-1-git-send-email-metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 28 Dec 2010 09:41:30 +0100
Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> EMC Celerra server reject session setups with
> RPC_NT_INVALID_BINDING (0xc0020003) if the authenticator checksum
> uses CKSUMTYPE_HMAC_MD5(-138).
> 
> The correct fix for this is to use the GSSAPI checksum,
> see http://tools.ietf.org/html/rfc4121.
> 
> See also https://bugzilla.samba.org/show_bug.cgi?id=7890
> 
> metze
> 

Thanks Metze,

The patches look good to me at first glance. I'll plan to go over them
in detail in the next few days, and commit them unless someone raises
objections.

Cheers,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
