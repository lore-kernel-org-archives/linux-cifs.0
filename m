From: Simo <simo-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/4 v2] Split CIFS_SessSetup()
Date: Thu, 01 May 2014 08:57:49 -0400
Message-ID: <1398949069.30774.16.camel@pico.ipa.ssimo.org>
References: <1398948065-23265-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Simo Sorce <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1398948065-23265-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 2014-05-01 at 13:41 +0100, Sachin Prabhu wrote:
> I am investigating the possibility of adding support for gss-proxy in the
> cifs client module. As part of that investigation, I was looking at the
> CIFS_SessSetup() function. This is a long function which handles multiple auths
> using if conditions and switch statements. The code struction makes it
> difficult to modify of add support for new authentication mechanisms.
> 
> The proposal is to split the various authentication code into its own separate
> functions. This increases the lines of code but will simplify maintenance and
> addition of new auth methods.
> 
> The short term goal is to add gss-proxy support for kerberos authentication.
> This will require to and fro communication with the gss-proxy module over a
> unix socket.
> 
> Further long term goals are 
> 1) Add support for NTLMSSP using SPNEGO,
> 2) Allow clients to negotiate which authentication mechanism to use using SPNEGO.
> 
> I would like the opinion of this list about these proposed changes.
> Is there any part of the code which needs changing?
> 
> V2:
> - Ensure that sess_data allocated on intermediate patches are freed.
> - Remove ifdef-endif blocks from the switch statement in CIFS_SessSetup().
> 
> Sachin Prabhu (4):
>   cifs: Split lanman auth from CIFS_SessSetup()
>   cifs: Split ntlm and ntlmv2 authentication methods off
>     CIFS_SessSetup()
>   cifs: Split Kerberos authentication off CIFS_SessSetup()
>   cifs: Separate rawntlmssp auth from CIFS_SessSetup()
> 
>  fs/cifs/sess.c | 1142 +++++++++++++++++++++++++++++++++++++++-----------------
>  1 file changed, 799 insertions(+), 343 deletions(-)
> 

I had a cursory look at the patches, and I think in general the
direction is good, and will make it much easier to use gss-proxy going
forward.

Simo.
