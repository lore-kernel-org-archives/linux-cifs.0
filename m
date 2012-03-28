From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs: use standard token parser for mount options
Date: Wed, 28 Mar 2012 14:31:46 +0300
Message-ID: <20120328113146.GE3200@mwanda>
References: <20120328104541.GC29022@elgon.mountain>
 <1332933181.2144.11.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1332933181.2144.11.camel@localhost>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Mar 28, 2012 at 12:13:01PM +0100, Sachin Prabhu wrote:
> Hello Dan, 
> 
> You are right.
> 
> On Wed, 2012-03-28 at 13:45 +0300, Dan Carpenter wrote:
> > Hello Sachin Prabhu,
> > 
> > This is a semi-automatic email about new static checker warnings.
> > 
> > The patch 8830d7e07a5e: "cifs: use standard token parser for mount 
> > options" from Mar 23, 2012, leads to the following Smatch complaint:
> > 
> > fs/cifs/connect.c:1607 cifs_parse_mount_options()
> > 	 error: we previously assumed 'value' could be null (see line 1568)
> > 
> > fs/cifs/connect.c
> >   1567				value = strchr(data, '=');
> >   1568				if (value != NULL)
> >                                     ^^^^^^^^^^^^^
> > Check.
> 
> static const match_table_t cifs_mount_option_tokens = {
> ..
>         { Opt_pass, "pass=%s" },
>         { Opt_pass, "password=%s" },
> ..
> ^^^ The parser will only match Opt_pass if the token passed contains a
> '=' character so value cannot be NULL. That check for NULL is
> unnecessary and shouldn't be there. This is otherwise harmless.
> 

Great.  Could you send a patch to remove the unneeded check?  Please
give me the Reported-by: tag, I am trying to catch up to Randy.

regards,
dan carpenter
