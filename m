From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [GIT] [CIFS] Allow user names longer than 32 bytes
Date: Mon, 28 Feb 2011 14:04:51 -0500
Message-ID: <20110228140451.056ee6ea@corrin.poochiereds.net>
References: <AANLkTimMxszw620jHORHYQ_jj-fhQiXUe=AiAFRAtMLU@mail.gmail.com>
	<20110228135935.1486b3dc@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110228135935.1486b3dc-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 28 Feb 2011 13:59:35 -0500
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Fri, 25 Feb 2011 12:24:17 -0600
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > commit 355e57ca063338eb00ea067a7570bb5f136cc513
> > Author: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> > Date:   Fri Feb 25 01:11:56 2011 -0600
> > 
> >     [CIFS] Allow user names longer than 32 bytes
> > 
> >     We artificially limited the user name to 32 bytes, but modern servers handle
> >     larger.  Set the maximum length to a reasonable 256, and make the user name
> >     string dynamically allocated rather than a fixed size in session structure.
> >     Also clean up old checkpatch warning.
> > 
> >     Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
> 
> [...]
> 
> > diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
> > index a51585f..e307a28 100644
> > --- a/fs/cifs/cifsencrypt.c
> > +++ b/fs/cifs/cifsencrypt.c
> > @@ -469,15 +469,15 @@ static int calc_ntlmv2_hash(struct cifsSesInfo
> > *ses, char *ntlmv2_hash,
> >  		return rc;
> >  	}
> > 
> > -	/* convert ses->userName to unicode and uppercase */
> > -	len = strlen(ses->userName);
> > +	/* convert ses->user_name to unicode and uppercase */
> > +	len = strlen(ses->user_name);
> >  	user = kmalloc(2 + (len * 2), GFP_KERNEL);
> >  	if (user == NULL) {
> >  		cERROR(1, "calc_ntlmv2_hash: user mem alloc failure\n");
> >  		rc = -ENOMEM;
> >  		goto calc_exit_2;
> >  	}
> > -	len = cifs_strtoUCS((__le16 *)user, ses->userName, len, nls_cp);
> > +	len = cifs_strtoUCS((__le16 *)user, ses->user_name, len, nls_cp);
> >  	UniStrupr(user);
> > 
> 
> Now that user_name can be a NULL pointer, what prevents the code above
> from oopsing if no one passes in a user= parm?
> 

Oh, and another problem too...

cifs_construct_tcon does a stack allocation for a temporary username field:

        char username[MAX_USERNAME_SIZE + 1];

That was probably ok when this was 33 bytes, but now that it's 257 it's
a little more scary. That should probably be switched to a kzalloc'ed
buffer too.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
