From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/5 v4] Split CIFS_SessSetup()
Date: Thu, 26 Jun 2014 17:28:35 +0100
Message-ID: <1403800115.11358.44.camel@sachin-laptop>
References: <1402929328-12866-1-git-send-email-sprabhu@redhat.com>
	 <CAH2r5muSiapN0OZNTt-74WwY1peL1y6Lg=WvzTDzyt8QnuGFkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muSiapN0OZNTt-74WwY1peL1y6Lg=WvzTDzyt8QnuGFkQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Steve,

I thought I had put those through the checkpatch.pl script before
sending them upstream. I guess I was mistaken.

On Thu, 2014-06-26 at 01:11 -0500, Steve French wrote:
> FYI - Two trivial checkpatch warnings.  Any obvious way to get rid of
> at least the first warning?
> 
> WARNING: Missing a blank line after declarations
> #30: FILE: fs/cifs/sess.c:527:
> +    struct nls_table *nls_cp;
> +    void (*func)(struct sess_data *);
> 
> total: 0 errors, 1 warnings, 349 lines checked
> 
> 0002-cifs-Split-lanman-auth-from-CIFS_SessSetup.patch has style
> problems, please review.

This seems to be a false positive where it incorrectly thinks that the
function pointer is not part of the declarations. if I add a blank line
between the 2 lines above, it no longer shows that warning.

> 
> 
> WARNING: Prefer kcalloc over kzalloc with multiply
> #358: FILE: fs/cifs/sess.c:1282:
> +    ntlmsspblob = kzalloc(5*sizeof(struct _AUTHENTICATE_MESSAGE),
> 
> total: 0 errors, 1 warnings, 565 lines checked
> 
> 0005-cifs-Separate-rawntlmssp-auth-from-CIFS_SessSetup.patch has style
> problems, please review.

This was simply copied from the original code.

Sachin Prabhu

> 
> On Mon, Jun 16, 2014 at 9:35 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > I am investigating the possibility of adding support for gss-proxy in the
> > cifs client module. As part of that investigation, I was looking at the
> > CIFS_SessSetup() function. This is a long function which handles multiple auths
> > using if conditions and switch statements. The code struction makes it
> > difficult to modify or add support for new authentication mechanisms.
> >
> > The proposal is to split the various authentication code into its own separate
> > functions. This increases the lines of code but will simplify maintenance and
> > addition of new auth methods.
> >
> > The short term goal is to add gss-proxy support for kerberos authentication.
> > This will require to and fro communication with the gss-proxy module over a
> > unix socket.
> >
> > Further long term goals are
> > 1) Add support for NTLMSSP using SPNEGO,
> > 2) Allow clients to negotiate which authentication mechanism to use using SPNEGO.
> >
> > V2:
> > - Ensure that sess_data allocated on intermediate patches are freed.
> > - Remove ifdef-endif blocks from the switch statement in CIFS_SessSetup().
> >
> > V3:
> > - Fix whitespace errors in some patches.
> > - Change sess_establish_session to return errors. Call this function only in
> >   case of successful establish session calls to the server.
> > - Delete an incorrect comment in case of rawntlmssp authentication.
> > - Delete an if statement before kfree(ntlmssp) in rawntlmssp authentication.
> >
> > v4:
> > - reordered elements of struct sess_data as asked by jlayton
> > - Use free_rsp_buf() to clean buffer.
> > - Clean up the rawntlmssp case further and break the calls into separate
> >   functions.
> >
> > Sachin Prabhu (5):
> >   cifs: replace code with free_rsp_buf()
> >   cifs: Split lanman auth from CIFS_SessSetup()
> >   cifs: Split ntlm and ntlmv2 authentication methods off
> >     CIFS_SessSetup()
> >   cifs: Split Kerberos authentication off CIFS_SessSetup()
> >   cifs: Separate rawntlmssp auth from CIFS_SessSetup()
> >
> >  fs/cifs/cifsproto.h |    1 +
> >  fs/cifs/cifssmb.c   |   20 +-
> >  fs/cifs/misc.c      |    9 +
> >  fs/cifs/sess.c      | 1192 ++++++++++++++++++++++++++++++++++++---------------
> >  fs/cifs/smb2pdu.c   |   10 -
> >  5 files changed, 854 insertions(+), 378 deletions(-)
> >
> > --
> > 1.9.3
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
