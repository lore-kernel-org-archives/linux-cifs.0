From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/5] cifs.upcall: add keytab support for unattended
 mounts
Date: Fri, 14 Jan 2011 15:43:02 -0500
Message-ID: <20110114154302.31aab5e2@tlielax.poochiereds.net>
References: <1294409505-2999-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: niallain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294409505-2999-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri,  7 Jan 2011 09:11:40 -0500
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> This patchset is based on one originally proposed by Igor Mammedov back
> in 2008. For some reason (maybe my fault?) his patch was never committed
> and cifs.upcall has been unable to use keytabs for mounting since then.
> 
> The first few patches in the series clean up the key description parser
> and some of the other code. The last patch adds the actual keytab
> support. For now, the code is only able to use the systemwide default
> keytab. Eventually, we could extend that to point to other keytabs, but
> we need to think about the right way to pass that location to the upcall
> program.
> 
> Also, I've only tested this against MIT kerberos. If Heimdal or other
> krb5 implementations need special casing, I'd appreciate review that
> points that out.
> 
> Lightly tested on my own test rig and it seems to work correctly.
> 
> Jeff Layton (5):
>   cifs.upcall: consolidate find_krb5_cc calls
>   cifs.upcall: clean up key description decoding routine
>   cifs.upcall: save off username field from key description
>   cifs.upcall: debug logging for the key description parser
>   cifs.upcall: add keytab support for unattended mounts
> 
>  cifs.upcall.c |  161 ++++++++++++++++++++++++++++++++++++++++++++++----------
>  1 files changed, 132 insertions(+), 29 deletions(-)
> 

Entire set committed. I had hoped to get someone with knowledge of
heimdal to review this, but I guess if it breaks something they'll let
us know... ;)

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
